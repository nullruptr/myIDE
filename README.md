# myIDE

Docker 上で、Neovim を利用した開発環境です。C++、LaTeX、Python、などの複合的なシステムを構築、内蔵しており、Neovim から各々アクセスできる環境になっています。また、エディタ上から、上記内容のLSPによる補完に加え、AIによる補完も行うことができます。

## セットアップ

### Ollamaの設定

1. ホストに[Ollama](https://ollama.com/) をダウンロード。
2. PowerShell にて、`ollama pull qwen2.5-coder:14b`と`ollama pull qwen2.5-coder:7b`をそれぞれ実行。
3. コンテナから、`curl http://host.docker.internal:11434/api/tags`を実行し、インストールできていることを確認する。
4. `<leader>ll` で、AIによる補完が機能する。
