filetype off

" set RunTime Path
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" 導入したいプラグインを以下に列挙
" Plugin '[Github Author]/[Github repo]' の形式で記入
" Plugin 'vim-scripts/vim-auto-save'
"
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-commentary'
Plugin 'vim-jp/vimdoc-ja'
Plugin 'tpope/vim-unimpaired'
Plugin 'imsnif/kdl.vim'

call vundle#end()
filetype plugin indent on

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ }

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>


"新しい行のインデントを現在行と同じにする
set autoindent
"バックアップファイルのディレクトリを指定する
set backupdir=$HOME/vimbackup
"クリップボードをWindowsと連携する
set clipboard=unnamed
"vi互換をオフする
set nocompatible
"スワップファイル用のディレクトリを指定する
set directory=$HOME/vimbackup
"タブの代わりに空白文字を指定する
set expandtab
"変更中のファイルでも、保存しないで他のファイルを表示する
set hidden
"インクリメンタルサーチを行う
set incsearch
"行番号を表示する
set number
"閉括弧が入力された時、対応する括弧を強調する
set showmatch
"新しい行を作った時に高度な自動インデントを行う
set smarttab
" grep検索を設定する
set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m,%f
set grepprg=grep\ -nh
" 検索結果をハイライトする
set hlsearch

" タブを表示するときの幅
set tabstop=2
" タブを挿入するときの幅
set shiftwidth=2
" タブをスペースとして扱う
set expandtab
"
set softtabstop=0
set backspace=2

" 0が前置された数字も10進数として扱う(デフォルトでは8進数)
set nrformats=
"補完設定
set wildmenu
set wildmode=full

set iskeyword-=_

" 検索結果のハイライトをEsc連打でクリアする
nnoremap <ESC><ESC> :nohlsearch<CR>
" <C-p>と<C-n>を矢印キーにマッピング
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" autosave
" let g:auto_save = 1

"----------
" カラースキーム
"----------
colorscheme molokai
syntax enable
