require("dapui").setup()
require("nvim-dap-virtual-text").setup()
require('dap-go').setup()

vim.api.nvim_set_keymap('n', '<leader>dt', ':lua require("dapui").toggle()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>db', ':DapToggleBreakpoint<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dc', ':DapContinue<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dr', ":lua require('dapui').open({reset = true})<CR>", { noremap = true })

