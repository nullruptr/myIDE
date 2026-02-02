-- https://github.com/nomnivore/ollama.nvim
return {
  "nomnivore/ollama.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  -- All the user commands added by the plugin
  cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

  keys = {
    -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
    {
      "<leader>ll",
      ":<c-u>lua require('ollama').prompt()<cr>",
      desc = "ollama prompt",
      mode = { "n", "v" },
    },

    -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
    {
      "<leader>lg",
      ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
      desc = "ollama Generate Code",
      mode = { "n", "v" },
    },
  },

  ---@type Ollama.Config
  opts = {
    -- your configuration overrides
	  url = "http://host.docker.internal:11434",
	  model = "qwen2.5-coder:14b",
	  serve = {on_start = false},
    -- 各プロンプトの指示を日本語にカスタマイズ
    prompts = {
      -- コード解説 (Explain_Code) を日本語化
      Explain_Code = {
        prompt = "以下のコードの内容を、日本語で詳しく解説してください。:\n\n```$ftype\n$sel\n```",
        action = "display",
        view = "vsplit",
      },
      -- コード生成 (Generate_Code) を日本語化
      Generate_Code = {
        prompt = "以下の指示に従って、日本語のコメントを含めたコードを生成してください。回答はコードのみ出力してください。:\n\n$sel",
        action = "replace",
      },
      -- 一般的な質問 (Ask_About_Code) を日本語化
      Ask_About_Code = {
        action = "display",
        view = "vsplit",
      },
    },
  },
}
