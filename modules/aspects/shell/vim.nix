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
      let &fillchars = 'eob: '
      set timeoutlen=1000
      " Short key-code timeout so Esc-prefixed Alt mappings don't lag Esc
      set ttimeout
      set ttimeoutlen=20
      set numberwidth=1
      set showcmd
      set showmode
      set showmatch

      set expandtab
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set backspace=indent,eol,start
      autocmd FileType nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
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

      " Use the terminal (Noctalia/kitty) palette instead of a vim theme, (no theme plugin)
      set notermguicolors

      " Same lazy external-change check as nvf (autoread alone only fires on some events)
      autocmd FocusGained,BufEnter * checktime

      " Search files by name with :find, recursive like a fuzzy finder would be
      set path+=**

      " Built-in gc/gcc comment operator (vim9 'comment' package, optional runtime pack)
      packadd comment

      autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

      let mapleader = " "

      nnoremap <Tab> :bnext<CR>
      nnoremap <S-Tab> :bprev<CR>
      nnoremap <C-Up> <C-u>
      nnoremap <C-Down> <C-d>
      nnoremap q <Nop>
      nnoremap Q q

      " Alt-key codes aren't known to terminal vim; map them to Esc-prefixed sequences
      execute "set <M-h>=\eh"
      execute "set <M-j>=\ej"
      execute "set <M-k>=\ek"
      execute "set <M-l>=\el"

      " mini.move equivalent: move lines/selections with Alt-hjkl
      nnoremap <M-j> :m .+1<CR>==
      nnoremap <M-k> :m .-2<CR>==
      nnoremap <M-h> <<
      nnoremap <M-l> >>
      xnoremap <M-j> :m '>+1<CR>gv=gv
      xnoremap <M-k> :m '<-2<CR>gv=gv
      xnoremap <M-h> <gv
      xnoremap <M-l> >gv

      nnoremap <C-s> :w<CR>
      inoremap <C-s> <C-o>:w<CR>
      xnoremap <C-s> <Esc>:w<CR>gv
      nnoremap <C-q> :q<CR>
      " Suspend would drop to a shell-less session in kitty
      nnoremap <C-z> <Nop>
      xnoremap <C-z> <Nop>

      " Substitute helpers (same keys as nvf)
      nnoremap <leader>s. :s/\<<C-r><C-w>\>//gI<Left><Left><Left>
      xnoremap <leader>s. :s/\<<C-r><C-w>\>//gI<Left><Left><Left>
      nnoremap <leader>s> :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>
      xnoremap <leader>s> :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>
      nnoremap <leader>sg :%s/
      xnoremap <leader>sg :%s/
      nnoremap <leader>sG :%s//gI<Left><Left><Left>
      xnoremap <leader>sG :%s//gI<Left><Left><Left>
      nnoremap <leader>sS :s//gI<Left><Left><Left>
      xnoremap <leader>sS :s//gI<Left><Left><Left>

      " Buffer delete keeping the window layout (mini.bufremove equivalent)
      nnoremap <leader>bd :bprevious<bar>bdelete #<CR>

      " netrw sidebar in place of neo-tree
      nnoremap <C-e> :Lexplore<CR>
      nnoremap <leader>ne :Lexplore<CR>
      let g:netrw_banner = 0
      let g:netrw_winsize = 25

      " Terminal split in place of toggleterm
      nnoremap <C-t> :botright terminal<CR>
      tnoremap <Esc><Esc> <C-\><C-n>
      tnoremap <C-h> <C-w>h
      tnoremap <C-j> <C-w>j
      tnoremap <C-k> <C-w>k
      tnoremap <C-l> <C-w>l

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

    # Pure-vimscript, loaded from the native pack dir: no plugin manager needed
    home.file.".vim/pack/hm/start/vim-surround".source = pkgs.vimPlugins.vim-surround;

    home.file.".cache/vim/undo/.keep".text = "";
  };
}
