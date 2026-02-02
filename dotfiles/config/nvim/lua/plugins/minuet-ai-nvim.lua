return {
  "milanglacier/minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("minuet").setup({
      -- OpenAI互換設定を使用
      provider = "openai_compatible",
      provider_options = {
        openai_compatible = {
          -- OllamaのOpenAI互換エンドポイント
          end_point = "http://host.docker.internal:11434/v1/chat/completions",
          -- 使用するモデル名 (ollama listで表示される名前)
          model = "qwen2.5-coder:7b",
          -- 重要: 環境変数の「名前」を文字列で渡す (実際のキーは不要)
          api_key = "TERM", 
          name = "Ollama",
          stream = true,
          optional = {
            max_tokens = 256,
            stop = { "\n" },
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = { "cpp", "hpp", "lua", "python" },
        keymap = {
          accept = "<A-a>", -- Alt + a で確定
          dismiss = "<A-e>", -- Alt + e で消去
          next = "<A-j>",    -- 次の候補
          prev = "<A-k>",    -- 前の候補
        },
      },
    })
  end,
}