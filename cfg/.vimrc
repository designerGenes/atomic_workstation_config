set nocompatible   
filetype off                  
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-sensible'
Plugin 'preservim/nerdtree'
Plugin 'ajmwagar/vim-deus'
call vundle#end()          
filetype plugin on
syntax enable

set mouse=a
set background=dark

colorscheme deus
set number              
set relativenumber
set cursorline        
set laststatus=2
set clipboard=unnamedplus

