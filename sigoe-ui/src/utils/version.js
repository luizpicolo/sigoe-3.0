export async function version() {
  try {
    const resposta = await fetch('/package.json')

    if (!resposta.ok) {
      throw new Error('Não foi possível carregar o package.json')
    }

    const texto = await resposta.json()
    return texto.version
  } catch (erro) {
    console.error('Erro ao carregar o arquivo:', erro)
    return '0.0.0'
  }
}