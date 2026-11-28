import Fastify from "fastify"
import { enviarMensagem } from "./whatsapp.js"
import { montarMensagem } from "./mensagem.js"

export function criarApp({ sendMessage = enviarMensagem } = {}) {
  const fastify = Fastify({ logger: false })

  fastify.post("/messages", async (request, reply) => {
    const { to, nome, data, filho, descricao, link } = request.body ?? {}

    if (!to || !nome || !data || !filho || !descricao || !link) {
      return reply.code(400).send({ error: "Campos obrigatórios ausentes" })
    }

    const mensagem = montarMensagem({ nome, data, filho, descricao, link })

    try {
      const resultado = await sendMessage(to, mensagem)
      return reply.code(201).send({ id: resultado?.key?.id, to })
    } catch (erro) {
      request.log.error(erro)
      return reply.code(500).send({ error: "Falha ao enviar mensagem" })
    }
  })

  return fastify
}
