# chezmoi の管理フローを迂回する操作に確認プロンプトを出すガード。
#
# 正規ルート:
#   brew install / uninstall / tap  -> chezmoi edit ~/.Brewfile               -> chezmoi apply
#   mise use -g / mise global       -> chezmoi edit ~/.config/mise/config.toml -> chezmoi apply
#
# 非対話シェル (Claude Code の Bash ツール, スクリプト, CI, chezmoi の
# run_onchange_ スクリプト) では素通りさせる。tty が無いと read が EOF で即 n 扱いに
# なり、「確認」ではなく無言の失敗になってしまうため。Claude 側の確認は
# ~/.claude/settings.json の permissions.ask が担当する。
#
# mise activate は自前の mise 関数を定義するので、このファイルは
# eval "$(mise activate zsh)" より後で source すること。

__chezmoi_guard_confirm() {
  [[ -t 0 ]] || return 0
  print -u2 -- "⚠️  chezmoi 管理外の操作です: $1"
  print -u2 -- "   正規ルート: $2"
  local reply
  if read -q "reply?   このまま実行しますか? [y/N] "; then
    print -u2
    return 0
  fi
  print -u2
  return 1
}

brew() {
  case "${1:-}" in
    install|uninstall|remove|rm|tap|untap)
      __chezmoi_guard_confirm "brew $1" "chezmoi edit ~/.Brewfile して chezmoi apply" || return 1
      ;;
  esac
  command brew "$@"
}

# mise use は -g/--global が付いたときだけグローバル設定を書き換える。
# 引数なしの mise use / プロジェクトローカルの変更は対象外。
__chezmoi_guard_mise_is_global() {
  [[ "${1:-}" == global ]] && return 0
  [[ "${1:-}" == use ]] || return 1
  local arg
  for arg in "${@[2,-1]}"; do
    [[ "$arg" == (-g|--global) ]] && return 0
  done
  return 1
}

# mise activate 済みならその関数を退避してラップする。zshrc を同一シェルで
# 再 source した場合、activate が先に mise を定義し直すのでここも再度巻き直す。
# 自分自身を退避してしまう無限再帰だけはマーカーで防ぐ。
if (( $+functions[mise] )) && [[ "${functions[mise]}" != *__chezmoi_guard_mise_wrapper* ]]; then
  functions -c mise __chezmoi_guard_mise_orig
fi

mise() {
  : __chezmoi_guard_mise_wrapper
  if __chezmoi_guard_mise_is_global "$@"; then
    __chezmoi_guard_confirm "mise $1 (グローバル)" \
      "chezmoi edit ~/.config/mise/config.toml して chezmoi apply" || return 1
  fi
  if (( $+functions[__chezmoi_guard_mise_orig] )); then
    __chezmoi_guard_mise_orig "$@"
  else
    command mise "$@"
  fi
}
