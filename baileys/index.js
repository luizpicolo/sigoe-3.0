import { criarApp } from "./app.js"
import { iniciarWhatsApp } from "./whatsapp.js"

const fastify = criarApp()

try {
  await fastify.listen({ port: 5051, host: "0.0.0.0" })
  console.log("Servidor iniciado")
  await iniciarWhatsApp()
} catch (err) {
  fastify.log.error(err)
  process.exit(1)
}
