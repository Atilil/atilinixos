_: {
  den.aspects.shell.homeManager = {pkgs, ...}: let
    vimrc = pkgs.writeText "vimrc" ''
      syntax on
      set background=dark
      set number
      set relativenumber
      set cursorline
      set cursorlineopt=both
      set scrolloff=999
      set signcolumn=yes
      set numberwidth=1
      set showcmd
      set showmode
      set showmatch

      set expandtab
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set copyindent
      set autoindent
      set smartindent
      set preserveindent

      set wrap
      set linebreak
      set breakindent
      set showbreak=↪

      set ignorecase
      set smartcase
      set hlsearch
      set incsearch
      nnoremap <Esc> :nohlsearch<CR>

      set wildmenu
      set wildmode=longest:full,full

      set encoding=utf-8
      set fileencoding=utf-8
      set clipboard=unnamedplus
      set splitbelow
      set splitright
      set hidden
      set mouse=a
      set history=1000
      set nomodeline
      set autoread
      set nobackup
      set nowritebackup
      set noswapfile
      set undofile
      set undodir=~/.cache/vim/undo//

      set foldlevelstart=99

      set list
      set listchars=tab:»·,trail:·,nbsp:·

      autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

      let mapleader = " "

      nnoremap <Tab> :bnext<CR>
      nnoremap <S-Tab> :bprev<CR>
      nnoremap <C-Up> <C-u>
      nnoremap <C-Down> <C-d>
      nnoremap q <Nop>
      nnoremap Q q

      nnoremap <leader>w :w<CR>
      nnoremap <leader>q :q<CR>
      nnoremap <leader>e :e<space>
      nnoremap <leader>f :find<space>
      nnoremap <leader>v :vsplit<CR>
      nnoremap <leader>s :split<CR>
      nnoremap <leader>h <C-w>h
      nnoremap <leader>j <C-w>j
      nnoremap <leader>k <C-w>k
      nnoremap <leader>l <C-w>l
      nnoremap <leader>bn :bnext<CR>
      nnoremap <leader>bp :bprev<CR>
      nnoremap <leader>bb :buffers<CR>
      nnoremap <leader>be :e<space>
      nnoremap <leader><Tab> :tabnext<CR>
      nnoremap <leader><S-Tab> :tabprev<CR>
      nnoremap <leader><CR> :tabedit<space>
    '';
  in {
    home.packages = [pkgs.vim-full pkgs.zeal];

    home.file.".vimrc".source = vimrc;

    home.file.".cache/vim/undo/.keep".text = "";
  };
}
