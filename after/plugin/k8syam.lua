local lspconfig = require('lspconfig')
local cmp = require('cmp')

-- Specialized Kubernetes YAML settings
lspconfig.yamlls.setup {
  settings = {
    yaml = {
      -- Basic schema validation for standard resources
      schemas = {
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/all.json"] = {
          "/*.yaml",
          "/*.yml",
          "kubectl-edit*.yaml",
        },
        -- Add common CRD schemas
        ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] = "*-application.yaml",
        ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/cert-manager.io/certificate_v1.json"] = "*-certificate.yaml",
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        ["https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/crds/application-crd.yaml"] = "*application*.yaml",
        ["https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml"] = "*prometheus*.yaml",
        -- Add more schemas as needed for your specific CRDs
      },
      -- General YAML language settings
      format = {
        enable = true,              
        singleQuote = false,       
        bracketSpacing = true,     
            },
      validate = true,
      hover = true,
      completion = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      -- Custom tags for Kubernetes YAML
      customTags = {
        "!Ref scalar",
        "!Sub scalar",
        "!ImportValue scalar",
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Add Kubernetes-specific keymaps
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>kk', '<cmd>lua vim.lsp.buf.hover()<CR>', 
      { noremap = true, desc = "Kubernetes resource info" })
    
    -- Enable autoformat
    require('lsp-zero').default_keymaps({buffer = bufnr})
    require('lsp-zero').buffer_autoformat()
  end
}

-- Enhance CMP specifically for Kubernetes files
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"yaml"},
  callback = function()
    -- Check if this is a Kubernetes YAML file
    local is_k8s = false
    local bufnr = vim.api.nvim_get_current_buf()
    local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n')
    
    if content:match("apiVersion:") and (content:match("kind:") or content:match("metadata:")) then
      is_k8s = true
    end
    
    if is_k8s then
      -- Special setup for Kubernetes YAML
      cmp.setup.buffer({
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'luasnip', priority = 750 },
          { 
            name = 'buffer', 
            priority = 500,
            option = {
              -- Include content from other Kubernetes files
              get_bufnrs = function()
                local bufs = {}
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                  if vim.api.nvim_buf_is_loaded(buf) then
                    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
                    if ft == 'yaml' then
                      table.insert(bufs, buf)
                    end
                  end
                end
                return bufs
              end
            }
          },
        }),
        
        formatting = {
          format = function(entry, vim_item)
            -- K8s specific icons and descriptions
            if entry.source.name == 'nvim_lsp' then
              -- Add Kubernetes-specific completion hints
              local item_kind = vim_item.kind
              if vim_item.kind == 'Field' then
                -- Check for common Kubernetes fields
                if vim_item.word:match("^api") then
                  vim_item.menu = " [K8s API]"
                elseif vim_item.word:match("^kind") then 
                  vim_item.menu = " [K8s Kind]"
                elseif vim_item.word:match("^metadata") then
                  vim_item.menu = " [K8s Meta]"
                elseif vim_item.word:match("^spec") then
                  vim_item.menu = " [K8s Spec]"
                elseif vim_item.word:match("^status") then
                  vim_item.menu = " [K8s Status]"
                else
                  vim_item.menu = " [K8s Field]"
                end
              end
            end
            
            return vim_item
          end
        }
      })
      
      -- Set helpful diagnostic settings for Kubernetes
      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        update_in_insert = false,
      })
    end
  end
})

-- Create command to load local CRDs
vim.api.nvim_create_user_command('KubeLoadCRDs', function()
  -- Get current Kubernetes context
  vim.fn.jobstart('kubectl get crds -o json', {
    on_stdout = function(_, data, _)
      if data and #data > 1 then
        local combined = table.concat(data, '')
        local success, crds = pcall(vim.fn.json_decode, combined)
        
        if success and crds and crds.items then
          -- Process CRDs into schemas
          local crd_count = 0
          for _, crd in ipairs(crds.items) do
            if crd.spec and crd.spec.names and crd.spec.names.kind then
              crd_count = crd_count + 1
            end
          end
          
          vim.notify("Found " .. crd_count .. " CRDs in current context", vim.log.levels.INFO)
          -- This would need more processing to convert to actual schemas
          -- But the concept is showing how to enhance with local CRDs
        end
      end
    end,
    on_stderr = function(_, data, _)
      if data and #data > 1 then
        vim.notify("Error loading CRDs: " .. table.concat(data, ''), vim.log.levels.ERROR)
      end
    end
  })
end, {})


local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Only load for YAML files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    ls.add_snippets("yaml", {
      -- Basic deployment
      s("k8s-deployment", {
        t({"apiVersion: apps/v1", "kind: Deployment", "metadata:"}),
        t({"", "  name: "}), i(1, "app-name"),
        t({"", "  namespace: "}), i(2, "default"),
        t({"", "spec:", "  replicas: "}), i(3, "1"),
        t({"", "  selector:", "    matchLabels:"}),
        t({"", "      app: "}), f(function(args) return args[1][1] end, {1}),
        t({"", "  template:", "    metadata:", "      labels:"}),
        t({"", "        app: "}), f(function(args) return args[1][1] end, {1}),
        t({"", "    spec:", "      containers:"}),
        t({"", "      - name: "}), f(function(args) return args[1][1] end, {1}),
        t({"", "        image: "}), i(4, "image:tag"),
        t({"", "        ports:"}),
        t({"", "        - containerPort: "}), i(5, "80"),
        i(0),
      }),
      
      -- Service template
      s("k8s-service", {
        t({"apiVersion: v1", "kind: Service", "metadata:"}),
        t({"", "  name: "}), i(1, "service-name"),
        t({"", "  namespace: "}), i(2, "default"),
        t({"", "spec:", "  selector:"}),
        t({"", "    app: "}), i(3, "app-name"),
        t({"", "  ports:"}),
        t({"", "  - port: "}), i(4, "80"),
        t({"", "    targetPort: "}), i(5, "80"),
        t({"", "    protocol: TCP"}),
        t({"", "  type: "}), i(6, "ClusterIP"),
        i(0),
      }),
      
      -- ConfigMap template
      s("k8s-configmap", {
        t({"apiVersion: v1", "kind: ConfigMap", "metadata:"}),
        t({"", "  name: "}), i(1, "config-name"),
        t({"", "  namespace: "}), i(2, "default"),
        t({"", "data:"}),
        t({"", "  "}), i(3, "key"), t({": "}), i(4, "value"),
        i(0),
      }),
    })
  end
})