print("LSPCONFIG.LUA IS LOADING!")

-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "pyright", "clangd" }
local nvlsp = require "nvchad.configs.lspconfig"

-- Debug: print what we're setting up
print("Setting up servers:", vim.inspect(servers))

-- lsps with default config
for _, lsp in ipairs(servers) do
  print("Setting up LSP:", lsp)
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
  print("Finished setting up:", lsp)
end
