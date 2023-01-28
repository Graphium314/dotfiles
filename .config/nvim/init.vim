let g:python3_host_prog = '/opt/homebrew/bin/python3'
set number "行番号を表示
syntax on "シンタックスハイライトをon
colorscheme molokai
set wrapscan "行末まで検索した後行頭に戻って検索
set showmatch "検索結果をハイライト表示(:nohで消す)
set expandtab "tabの代わりにスペースを使用
set shiftwidth=4 "tabキーで挿入されるスペースの数
set smartindent "中括弧を始めた後などの改行のあと自動的にインデントを入れる
set softtabstop=4 "インデント周りの各種機能で操作されるスペースの数
set encoding=utf-8 "VimではUTF-8で文字を表示する
set fileencodings=utf-8,sjis "UTF-8でファイルを読み込み、ダメだったらShift_JISを試す
set clipboard+=unnamed "クリップボードとVimの無名レジスタを結合する
set wildmode=longest,full "コマンドモードでtabを使ってファイル名を補完するときに、1回目は最大共通文字列、次からは順番にファイル名を完全補完する
set pumblend=1000 "pop-up menuを半透明にする。

set tabstop=4
set shiftwidth=4

" PLUGIN SETTINGS
"call plug#begin('~/.config/nvim/plugged')
"Plug 'vim-jp/vimdoc-ja'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'preservim/nerdtree'
"call plug#end()
packadd vim-jetpack
call jetpack#begin('~/.config/nvim/plugged')
Jetpack 'vim-jp/vimdoc-ja'
Jetpack 'vim-airline/vim-airline'
Jetpack 'vim-airline/vim-airline-themes'
Jetpack 'preservim/nerdtree'
Jetpack 'sheerun/vim-polyglot'
Jetpack 'tpope/vim-surround'
Jetpack 'jiangmiao/auto-pairs'
Jetpack 'google/vim-maktaba'
Jetpack 'google/vim-codefmt'
" lsp
"Jetpack 'neovim/nvim-lspconfig'
"Jetpack 'williamboman/nvim-lsp-installer'
"Jetpack 'ray-x/lsp_signature.nvim'
" auto complete
"Jetpack 'hrsh7th/nvim-cmp'
"Jetpack 'hrsh7th/cmp-nvim-lsp'
"Jetpack 'hrsh7th/cmp-buffer'
"Jetpack 'hrsh7th/cmp-path'
"Jetpack 'hrsh7th/cmp-cmdline'
"Jetpack 'onsails/lspkind-nvim'
"Jetpack 'ray-x/cmp-treesitter'

Jetpack 'neovim/nvim-lspconfig'
Jetpack 'williamboman/mason.nvim'
Jetpack 'williamboman/mason-lspconfig.nvim'
Jetpack 'hrsh7th/nvim-cmp'
Jetpack 'hrsh7th/cmp-nvim-lsp'
Jetpack 'hrsh7th/vim-vsnip'
call jetpack#end()

augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType vue AutoFormatBuffer prettier
  autocmd FileType swift AutoFormatBuffer swift-format
augroup END

noremap <Down> <Nop>
noremap <Up> <Nop>
noremap <Right> <Nop>
noremap <Left> <Nop>

let g:airline#extensions#tabline#enabled = 1
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab
map <C-m> :NERDTreeToggle<CR>



lua << EOF

-- 1. LSP Sever management
require('mason').setup()
require('mason-lspconfig').setup_handlers({ function(server)
  local opt = {
    -- -- Function executed when the LSP server startup
    -- on_attach = function(client, bufnr)
    --   local opts = { noremap=true, silent=true }
    --   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    --   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
    -- end,
    capabilities = require('cmp_nvim_lsp').update_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )
  }
  require('lspconfig')[server].setup(opt)
end })

-- 2. build-in LSP function
-- keyboard shortcut
local opts = { noremap=true, silent=true }
vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = true }
)
-- Reference highlight
vim.cmd [[
set updatetime=500
highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
augroup lsp_document_highlight
  autocmd!
  autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
augroup END
]]

-- 3. completion (hrsh7th/nvim-cmp)
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    -- { name = "buffer" },
    -- { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ['<C-l>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  }),
  experimental = {
    ghost_text = true,
  },
})

EOF

