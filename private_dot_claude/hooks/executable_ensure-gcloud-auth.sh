#!/bin/bash
# Claude Code SessionStart hook: gcloud の認証が切れていたらブラウザでの再ログインを起動する。
#
# - `gcloud auth print-access-token` はキャッシュ済み access token があると refresh token が
#   失効していても成功してしまうため、`config-helper --force-auth-refresh` で実際に refresh して判定する
# - ADC (terraform などが使う) も同じ再認証ポリシーで切れるので、`--update-adc` でまとめて更新する
# - 結果は systemMessage (JSON) でユーザーに表示する。素の stdout は Claude のコンテキストに入るだけで見えない

command -v gcloud >/dev/null 2>&1 || exit 0

# プロジェクト設定で SA impersonation が有効でも、判定・ログインは本人のユーザー認証に対して行う
unset CLOUDSDK_AUTH_IMPERSONATE_SERVICE_ACCOUNT

account=$(gcloud config get-value account 2>/dev/null)
# 未設定、または SA の鍵で動いている環境は対象外
[[ -z $account || $account == *.gserviceaccount.com ]] && exit 0

emit() {
  local msg=$1
  if command -v jq >/dev/null 2>&1; then
    jq -nc --arg m "$msg" '{systemMessage: $m}'
  else
    printf '{"systemMessage": "%s"}\n' "${msg//\"/\\\"}"
  fi
}

user_ok() {
  gcloud config config-helper --force-auth-refresh >/dev/null 2>&1
}

adc_ok() {
  local adc=${CLOUDSDK_CONFIG:-$HOME/.config/gcloud}/application_default_credentials.json
  # ADC 未作成、またはユーザー認証以外 (SA 鍵 / WIF) なら判定しない
  [[ -f $adc ]] || return 0
  grep -q '"authorized_user"' "$adc" || return 0
  gcloud auth application-default print-access-token >/dev/null 2>&1
}

user_ok && adc_ok && exit 0

# SSH 越しではブラウザを開けず、gcloud が標準入力待ちで固まるので案内だけにする
if [[ -n $SSH_CONNECTION ]]; then
  emit "gcloud の認証が切れています: ! gcloud auth login --update-adc"
  exit 0
fi

# 複数セッションを同時に起動したときにブラウザが何枚も開かないようにする
lock=${TMPDIR:-/tmp}/ensure-gcloud-auth.lock
if ! mkdir "$lock" 2>/dev/null; then
  if [[ -n $(find "$lock" -maxdepth 0 -mmin +5 2>/dev/null) ]]; then
    rm -rf "$lock" && mkdir "$lock" 2>/dev/null || exit 0
  else
    emit "gcloud の再認証は別のセッションで進行中です"
    exit 0
  fi
fi
trap 'rm -rf "$lock"' EXIT

if gcloud auth login "$account" --update-adc --launch-browser --quiet >/dev/null 2>&1 && user_ok; then
  emit "gcloud を再認証しました ($account)"
else
  emit "gcloud の再認証に失敗しました: ! gcloud auth login --update-adc"
fi
exit 0
