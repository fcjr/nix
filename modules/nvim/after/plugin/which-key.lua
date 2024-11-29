local wk = require("which-key")

wk.setup()

local mappings = {
  ["<leader>"] = {
    k = { "<cmd>lnext<CR>zz", "Next Location List Item" },
    j = { "<cmd>lprev<CR>zz", "Previous Location List Item" },
    p = {
      name = "Find",
      f = { "<cmd>Telescope find_files<cr>", "Find File" },
      s = { "<cmd>Telescope live_grep<cr>", "Grep Search" },
      v = { "<cmd>Ex<cr>", "Open File Explorer" },
    },
    v = {
      name = "LSP",
      w = { "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", "Workspace Symbol" },
      d = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Open Float Diagnostic" },
      c = {
        name = "Code",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      },
      r = {
        name = "References",
        r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Show References" },
        n = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename Symbol" },
      },
    },
    c = {
      name = "Comment",
      c = { "Toggle Line Comment" },
    },
    b = {
      name = "Block",
      c = { "Toggle Block Comment" },
    },
    g = {
      s = { "<cmd>Git<cr>", "Git Status" },
    },
    u = { "<cmd>UndotreeToggle<cr>", "Toggle Undotree" },
    a = { "Add to Harpoon" },
    f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format Buffer" },
    s = { "Search and Replace Word" },
    x = { "<cmd>!chmod +x %<cr>", "Make Executable" },
    y = { "Yank to Clipboard" },
    d = { "Delete to Void" },
    ["d"] = {
      name = "Debug",
      t = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle DAP UI" },
      b = { "<cmd>DapToggleBreakpoint<cr>", "Toggle Breakpoint" },
      c = { "<cmd>DapContinue<cr>", "Continue Debugging" },
      r = { "<cmd>lua require('dapui').open({reset = true})<cr>", "Open DAP UI (Reset)" },
    },
  },
  g = {
    d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition" },
  },
  ["<C-"] = {
    e = { "Toggle Harpoon Menu" },
    d = { "Scroll Down (centered)" },
    u = { "Scroll Up (centered)" },
    f = { "Open tmux-sessionizer" },
    h = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
    j = { "Harpoon File 1" },
    k = { "Harpoon File 2" },
    l = { "Harpoon File 3" },
    [";"] = { "Harpoon File 4" },
    p = { "Git Files" },
  },
  K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show Hover Information" },
  ["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Diagnostic" },
  ["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
  ["<C-k>"] = { "<cmd>cnext<CR>zz", "Next Quickfix Item" },
  ["<C-j>"] = { "<cmd>cprev<CR>zz", "Previous Quickfix Item" },
}

wk.register(mappings)