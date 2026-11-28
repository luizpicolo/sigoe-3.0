import { afterAll, beforeAll, describe, expect, it, mock } from "bun:test"

const sendMessage = mock(async () => ({ key: { id: "wamid.test" } }))
const { criarApp } = await import("../app.js")
const app = criarApp({ sendMessage })

const payload = {
  to: "5567999990000",
  nome: "Maria Silva",
  data: "27/11/2026",
  filho: "João Silva",
  descricao: "Ocorrência de teste",
  link: "https://sigoe.test/ocorrencias/12"
}

beforeAll(async () => app.ready())
afterAll(async () => app.close())

describe("POST /messages", () => {
  it("envia a mensagem formatada e retorna identificador e destinatário", async () => {
    const response = await app.inject({ method: "POST", url: "/messages", payload })

    expect(response.statusCode).toBe(201)
    expect(response.json()).toEqual({ id: "wamid.test", to: payload.to })
    expect(sendMessage).toHaveBeenCalledTimes(1)
    expect(sendMessage).toHaveBeenLastCalledWith(
      payload.to,
      expect.stringContaining("Ocorrência de teste")
    )
  })

  it("retorna 400 se faltar um campo obrigatório e não envia", async () => {
    sendMessage.mockClear()
    const response = await app.inject({
      method: "POST",
      url: "/messages",
      payload: { ...payload, nome: "" }
    })

    expect(response.statusCode).toBe(400)
    expect(response.json()).toEqual({ error: "Campos obrigatórios ausentes" })
    expect(sendMessage).not.toHaveBeenCalled()
  })

  it("retorna 400 para corpo vazio", async () => {
    const response = await app.inject({ method: "POST", url: "/messages", payload: {} })

    expect(response.statusCode).toBe(400)
    expect(response.json()).toEqual({ error: "Campos obrigatórios ausentes" })
  })

  it("converte falha do provedor em resposta 500", async () => {
    sendMessage.mockImplementationOnce(async () => {
      throw new Error("conexão indisponível")
    })

    const response = await app.inject({ method: "POST", url: "/messages", payload })

    expect(response.statusCode).toBe(500)
    expect(response.json()).toEqual({ error: "Falha ao enviar mensagem" })
  })

  it("permite resposta sem identificador do provedor", async () => {
    sendMessage.mockImplementationOnce(async () => ({}))

    const response = await app.inject({ method: "POST", url: "/messages", payload })

    expect(response.statusCode).toBe(201)
    expect(response.json()).toEqual({ to: payload.to })
  })
})
