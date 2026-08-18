# dotfiles

macOS 用の dotfiles。[chezmoi](https://www.chezmoi.io/) で管理。

## 新マシンでのセットアップ

前提: Homebrew は導入済み

```bash
# chezmoi インストール
brew install chezmoi

# リポジトリをクローン（GOPATH スタイル）
mkdir -p ~/dev/src/github.com/cmmmli
git clone https://github.com/cmmmli/dotfiles ~/dev/src/github.com/cmmmli/dotfiles

# chezmoi 設定
mkdir -p ~/.config/chezmoi
echo "sourceDir = \"$HOME/dev/src/github.com/cmmmli/dotfiles\"" > ~/.config/chezmoi/chezmoi.toml

# 適用（初回は対話的に name, email, isWork を入力）
# → Brewfile の brew bundle、mise install、補完キャッシュ生成まで自動で走る
chezmoi apply
```

## 日常的な使い方

```bash
# 設定ファイルを編集
chezmoi edit ~/.zshrc

# 変更を適用
chezmoi apply

# 差分を確認
chezmoi diff

# ソースディレクトリに移動
chezmoi cd
```

## ツールの追加

置き場所の方針:

| 種類 | 置き場所 |
|------|---------|
| GUI アプリ (cask)、コンパイル物 (git, zsh, neovim, php, postgresql)、常に最新でよい汎用 CLI (bat, fd, jq, gh, ...) | `~/.Brewfile` (Homebrew) |
| 言語ランタイム (node, python, go, bun, pnpm)、プロジェクトごとにバージョンが効く CLI (terraform, kubectl, helm, k9s, ...) | `~/.config/mise/config.toml` (mise) |
| 仕事リポジトリが `aqua.yaml` を持っているもの | そのリポジトリの aqua.yaml (aqua バイナリだけ Homebrew で入れる) |

```bash
# Homebrew: Brewfile を編集して apply (brew bundle が自動実行される)
chezmoi edit ~/.Brewfile
chezmoi apply

# mise: config.toml を編集して apply (mise install が自動実行される)
chezmoi edit ~/.config/mise/config.toml
chezmoi apply
#   もしくは mise use -g <tool>@<version> で追加し、chezmoi re-add ~/.config/mise/config.toml
```

Brewfile の書き方:
- `brew "package"` - CLI ツール
- `cask "app"` - GUI アプリ
- `mas "App Name", id: 123456` - Mac App Store アプリ

## 含まれる設定

| ファイル | 説明 |
|---------|------|
| `.zprofile` | login shell 用 (Homebrew shellenv, mise shims) |
| `.zshrc` | zsh メイン設定 |
| `.gitconfig` | Git 設定 |
| `.vimrc` | Vim 設定 |
| `.config/starship.toml` | Starship プロンプト |
| `.config/sheldon/` | zsh プラグイン管理 |
| `.config/ghostty/` | Ghostty ターミナル |
| `.config/karabiner/` | キーリマップ |
| `.Brewfile` | Homebrew パッケージ |
| `.config/mise/config.toml` | mise で管理するランタイム / CLI |

## 自動スクリプト

すべて `after_` スクリプト（全ファイル適用後に番号順で実行）:

- **00-brew-bundle.sh** - Brewfile 変更時に、記載 tap の `brew trust` と `brew bundle` を実行
- **10-mise-install.sh** - mise の config.toml 変更時に `mise install` を実行
- **20-generate-completions.sh** - apply 後に毎回補完キャッシュを生成

## 補完キャッシュの手動再生成

```bash
~/.config/zsh/generate-completions.sh
rm -f ~/.zcompdump && exec zsh
```

## ツール管理

| ツール | 用途 |
|--------|------|
| [Homebrew](https://brew.sh/) | cask、コンパイル物、汎用 CLI |
| [mise](https://mise.jdx.dev/) | 言語ランタイム (node, python, go, bun, pnpm) と pin したい CLI (terraform, kubectl, helm, ...) |
| [aqua](https://aquaproj.github.io/) | 仕事リポジトリの aqua.yaml 用 (バイナリのみ) |
