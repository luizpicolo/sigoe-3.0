import { describe, expect, it } from "bun:test"
import { montarMensagem } from "../mensagem.js"

describe("montarMensagem", () => {
  it("substitui os campos do modelo e remove espaços nas pontas", () => {
    const mensagem = montarMensagem({
      nome: "Maria",
      data: "27/11/2026",
      filho: "João",
      descricao: "Saiu antes do horário",
      link: "https://sigoe.test/ocorrencias/5"
    })

    expect(mensagem).toContain("Olá, *Maria*!")
    expect(mensagem).toContain("*27/11/2026*")
    expect(mensagem).toContain("*João*")
    expect(mensagem).toContain("Saiu antes do horário")
    expect(mensagem).toContain("https://sigoe.test/ocorrencias/5")
    expect(mensagem.startsWith("Olá")).toBe(true)
    expect(mensagem.endsWith("coordenação.")).toBe(true)
  })

  it("substitui campos ausentes por texto vazio e não deixa marcadores", () => {
    const mensagem = montarMensagem({ nome: "Responsável" })

    expect(mensagem).toContain("Olá, *Responsável*!")
    expect(mensagem).not.toMatch(/\{\{\w+\}\}/)
  })
})
