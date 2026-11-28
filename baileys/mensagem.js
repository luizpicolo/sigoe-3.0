const arquivo = Bun.file("./template.txt")
const template = await arquivo.text()

export function montarMensagem(dados) {
  return template
    .replace(/\{\{(\w+)\}\}/g, (_, chave) => dados[chave] ?? "")
    .trim()
}