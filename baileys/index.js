import Fastify from "fastify"
import { iniciarWhatsApp, enviarMensagem } from "./whatsapp.js"
import { montarMensagem } from "./mensagem.js"

const fastify = Fastify({ logger: false })

fastify.post("/messages", async (request, reply) => {
  const { to, nome, data, filho, descricao, link } = request.body ?? {}

  if (!to || !nome || !data || !filho || !descricao || !link) {
    return reply.code(400).send({ error: "Campos obrigatórios ausentes" })
  }

  const mensagem = montarMensagem({ nome, data, filho, descricao, link })

  try {
    const resultado = await enviarMensagem(to, mensagem)
    return reply.code(201).send({ id: resultado?.key?.id, to })
  } catch (erro) {
    request.log.error(erro)
    return reply.code(500).send({ error: "Falha ao enviar mensagem" })
  }
})

try {
  await fastify.listen({ port: 5051, host: "0.0.0.0" })
  console.log("Servidor iniciado")
  await iniciarWhatsApp()
} catch (err) {
  fastify.log.error(err)
  process.exit(1)
}
