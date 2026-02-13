# dotfiles

macOS 用の dotfiles。[chezmoi](https://www.chezmoi.io/) で管理。

## 新マシンでのセットアップ

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

## Homebrew パッケージの追加

```bash
# 1. Brewfile を編集
chezmoi edit ~/.Brewfile

# 2. パッケージを追加（例）
# brew "ripgrep"
# cask "visual-studio-code"
# vscode "ms-python.python"

# 3. 変更を適用（brew bundle が自動実行される）
chezmoi apply
```

Brewfile の書き方:
- `brew "package"` - CLI ツール
- `cask "app"` - GUI アプリ
- `vscode "extension"` - VSCode 拡張
- `mas "App Name", id: 123456` - Mac App Store アプリ

## 含まれる設定

| ファイル | 説明 |
|---------|------|
| `.zshrc` | zsh メイン設定 |
| `.gitconfig` | Git 設定 |
| `.vimrc` | Vim 設定 |
| `.config/starship.toml` | Starship プロンプト |
| `.config/sheldon/` | zsh プラグイン管理 |
| `.config/aerospace/` | タイル型ウィンドウマネージャ |
| `.config/ghostty/` | Ghostty ターミナル |
| `.config/alacritty/` | Alacritty ターミナル |
| `.config/karabiner/` | キーリマップ |
| `.Brewfile` | Homebrew パッケージ |

## 自動スクリプト

- **run_onchange_brew-bundle.sh** - Brewfile 変更時に `brew bundle` を実行
- **run_after_generate-completions.sh** - apply 後に補完キャッシュを生成

## 補完キャッシュの手動再生成

```bash
~/.config/zsh/generate-completions.sh
rm -f ~/.zcompdump && exec zsh
```

## バージョン管理ツール

| ツール | 用途 |
|--------|------|
| [Volta](https://volta.sh/) | Node.js |
| [pyenv](https://github.com/pyenv/pyenv) | Python |
| [rbenv](https://github.com/rbenv/rbenv) | Ruby |
| [aqua](https://aquaproj.github.io/) | CLI ツール |
| [mise](https://mise.jdx.dev/) | マルチ言語 |
