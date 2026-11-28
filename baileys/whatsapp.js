import makeWASocket, {useMultiFileAuthState, DisconnectReason} from "@whiskeysockets/baileys"
import qrcode from "qrcode-terminal"

let socket

export async function iniciarWhatsApp() {
  const { state, saveCreds } = await useMultiFileAuthState("./auth_info")

  socket = makeWASocket({ auth: state })
  socket.ev.on("creds.update", saveCreds)

  socket.ev.on("connection.update", ({ connection, qr, lastDisconnect }) => {
    if (qr) {
      qrcode.generate(qr, { small: true })
    }

    if (connection === "open") {
      console.log("WhatsApp conectado.")
    }

    if (connection === "close") {
      const codigo = lastDisconnect?.error?.output?.statusCode

      if (codigo !== DisconnectReason.loggedOut) {
        iniciarWhatsApp()
      }
    }
  })
}

export async function enviarMensagem(to, message) {
  return socket.sendMessage(`${to}@s.whatsapp.net`, { text: message })
}