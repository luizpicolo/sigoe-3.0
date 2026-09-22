import axios from 'axios'

const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000'

const config = () => ({
  headers: {
    Authorization: localStorage.getItem('jwt')
  }
})

export const getIncidentReportOptions = async () => {
  const response = await axios.get(
    `${BASE_URL}/api/report_incidents/options`,
    config()
  )

  return response.data
}

const formatDate = value => {
  if (!value) return ''

  const date = new Date(`${value}T00:00:00`)

  if (Number.isNaN(date.getTime())) {
    return value
  }

  return date.toLocaleDateString('pt-BR')
}

const escapeHtml = value => {
  if (value === null || value === undefined) {
    return ''
  }

  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;')
}

const hasValue = value => {
  if (value === null || value === undefined) {
    return false
  }

  if (typeof value === 'string') {
    return value.trim() !== ''
  }

  if (Array.isArray(value)) {
    return value.length > 0
  }

  return true
}

const renderField = (label, value) => {
  if (!hasValue(value)) {
    return ''
  }

  return `
    <div class="field">
      <div class="label">${escapeHtml(label)}</div>
      <div class="value">${escapeHtml(value)}</div>
    </div>
  `
}

const renderIncidentPdfHtml = incident => {
  const dataOcorrencia = formatDate(incident.date_incident)

  const horaOcorrencia = hasValue(incident.time_incident)
    ? ` às ${escapeHtml(incident.time_incident)}`
    : ''

  const dataHtml =
    dataOcorrencia
      ? `
        <div class="field inline-field">
          <strong>Data ocorrência:</strong>
          ${escapeHtml(dataOcorrencia)}${horaOcorrencia}
        </div>
      `
      : horaOcorrencia
        ? `
          <div class="field inline-field">
            <strong>Data ocorrência:</strong>
            ${escapeHtml(horaOcorrencia.replace(' às ', ''))}
          </div>
        `
        : ''

  const tipoHtml = hasValue(incident.type_incident)
    ? `
      <div class="field inline-field">
        <strong>Tipo da ocorrência:</strong>
        ${escapeHtml(incident.type_incident)}
      </div>
    `
    : ''

  const sanctionHtml = hasValue(incident.sanction)
    ? `
      <div class="field inline-field">
        <strong>Sanção adotada:</strong>
        ${escapeHtml(incident.sanction)}
      </div>
    `
    : ''

  const regulationsHtml =
    Array.isArray(incident.regulations)
      ? incident.regulations
          .filter(hasValue)
          .map(regulation => `
            <div class="regulation">
              ${escapeHtml(regulation)}
            </div>
          `)
          .join('')
      : ''

  return `
    <article class="incident-report">

      <img src="/c_report.png" style="width: 210mm; max-width: 100%;"/>

      <h1>Relatório de ocorrências</h1>

      ${renderField('Aluno(a)', incident.student)}

      ${renderField('Curso', incident.course)}

      ${dataHtml}

      ${tipoHtml}

      ${renderField(
        'Problema ocorrido',
        incident.description
      )}

      ${sanctionHtml}

      ${renderField(
        'Solução adotada para o problema',
        incident.solution
      )}

      ${
        regulationsHtml
          ? `
            <div class="regulations">
              ${regulationsHtml}
            </div>
          `
          : ''
      }

      <div class="signatures">

        <div class="signature">
          <div class="signature-line"></div>
          <div>Aluno(a)</div>
        </div>

        <div class="signature">
          <div class="signature-line"></div>
          <div>Responsável</div>
        </div>

      </div>

      <div class="final-dates">

        <div>
          Data de comparecimento do responsável:
          ____ de _____________ de 20___
        </div>

        <div>
          Arquivado na pasta do estudante em:
          ____ de _____________ de 20___
        </div>

      </div>

    </article>
  `
}

const createIncidentPdf = incidents => {
  const reports = Array.isArray(incidents)
    ? incidents
    : [incidents]

  const html = `
    <!DOCTYPE html>
    <html lang="pt-BR">
      <head>
        <meta charset="UTF-8">

        <title>Relatório de ocorrências</title>

        <style>

          @page {
            size: A4;
            margin: 20mm;
          }

          * {
            box-sizing: border-box;
          }

          html,
          body {
            margin: 0;
            padding: 0;
            background: #fff;
            color: #000;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 11pt;
            line-height: 1.45;
          }

          body {
            width: 100%;
          }

          .incident-report {
            width: 170mm;
            min-height: 257mm;
            margin: 0 auto;
            position: relative;
            page-break-after: always;
            break-after: page;
          }

          .incident-report:last-child {
            page-break-after: auto;
            break-after: auto;
          }

          h1 {
            margin: 0 0 12mm;
            text-align: center;
            font-size: 16pt;
            font-weight: bold;
          }

          .field {
            margin-bottom: 5mm;
            page-break-inside: avoid;
            break-inside: avoid;
          }

          .label {
            margin-bottom: 1.5mm;
            font-weight: bold;
          }

          .value {
            white-space: pre-wrap;
            overflow-wrap: anywhere;
          }

          .inline-field {
            margin-bottom: 3mm;
          }

          .regulations {
            margin-top: 6mm;
            page-break-inside: avoid;
          }

          .regulation {
            margin-bottom: 3mm;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
          }

          .signatures {
            margin-top: 35mm;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25mm;
            page-break-inside: avoid;
            break-inside: avoid;
          }

          .signature {
            text-align: center;
          }

          .signature-line {
            border-top: 1px solid #000;
            margin-bottom: 2mm;
          }

          .final-dates {
            grid-column: 1 / -1;
            margin-top: 5mm;
          }

          .final-dates > div {
            margin-bottom: 4mm;
          }

          @media screen {
            body {
              background: #eee;
              padding: 20mm 0;
            }

            .incident-report {
              background: #fff;
              padding: 0;
              margin-bottom: 10mm;
            }
          }

          @media print {
            body {
              background: #fff;
            }
          }

        </style>
      </head>

      <body>

        ${reports
          .filter(Boolean)
          .map(renderIncidentPdfHtml)
          .join('')}

      </body>
    </html>
  `

  const printWindow = window.open(
    '',
    '_blank',
    'width=900,height=700'
  )

  if (!printWindow) {
    throw new Error(
      'Não foi possível abrir a janela de impressão. Verifique se o navegador bloqueou pop-ups.'
    )
  }

  printWindow.document.open()
  printWindow.document.write(html)
  printWindow.document.close()

  printWindow.onload = () => {
    printWindow.focus()
    printWindow.print()
  }
}

export const generateIncidentReport = async filters => {
  const response = await axios.get(
    `${BASE_URL}/api/report_incidents/data`,
    {
      ...config(),
      params: filters
    }
  )

  createIncidentPdf(response.data)
}