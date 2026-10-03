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
  if (!value) {
    return ''
  }

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

const renderField = (label, value, inline = false) => {
  if (!hasValue(value)) {
    return ''
  }

  let className = 'field'

  if (inline) {
    className = 'field inline-field'
  }

  if (Array.isArray(value)) {
    const items = value
      .filter(hasValue)
      .map(item => `
        <div class="regulation">
          ${escapeHtml(item)}
        </div>
      `)
      .join('')

    if (!items) {
      return ''
    }

    return `
      <div class="${className}">
        <strong>
          ${escapeHtml(label)}:
        </strong>

        ${items}
      </div>
    `
  }

  return `
    <div class="${className}">
      <strong>
        ${escapeHtml(label)}:
      </strong>
      ${escapeHtml(value)}
    </div>
  `
}

const renderIncidentDate = incident => {
  const date = formatDate(incident.date_incident)

  let time = ''

  if (hasValue(incident.time_incident)) {
    time = escapeHtml(incident.time_incident)
  }

  if (date && time) {
    return renderField(
      'Data ocorrência',
      `${date} às ${time}`,
      true
    )
  }

  if (date) {
    return renderField(
      'Data ocorrência',
      date,
      true
    )
  }

  if (time) {
    return renderField(
      'Data ocorrência',
      time,
      true
    )
  }

  return ''
}

const renderIncidentPdfHtml = incident => {
  return `
    <article class="incident-report">

      <img
        src="/c_report.png"
        style="width: 210mm; max-width: 100%;"
      />

      <h1>
        Relatório de ocorrências
      </h1>

      ${renderField(
        'Aluno(a)',
        incident.student
      )}

      ${renderField(
        'Curso',
        incident.course
      )}

      ${renderIncidentDate(incident)}

      ${renderField(
        'Tipo da ocorrência',
        incident.type_incident,
        true
      )}

      ${renderField(
        'Problema ocorrido',
        incident.description
      )}

      ${renderField(
        'Sanção adotada',
        incident.sanction,
        true
      )}

      ${renderField(
        'Solução adotada para o problema',
        incident.solution
      )}

      ${renderField(
        'Deveres do aluno',
        incident.studentDuties
      )}

      ${renderField(
        'Proibições e responsabilidades',
        incident.prohibitionAndResponsibilities
      )}

      <div class="signatures">

        <div class="signature">
          <div class="signature-line"></div>
          <div>
            Aluno(a)
          </div>
        </div>

        <div class="signature">
          <div class="signature-line"></div>
          <div>
            Responsável
          </div>
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
  let reports = []

  if (Array.isArray(incidents)) {
    reports = incidents
  } else {
    reports = [incidents]
  }

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

          .inline-field {
            margin-bottom: 3mm;
          }

          .regulation {
            margin-top: 3mm;
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

export const generateIncidentReportFromIncident = incident => {
  if (!incident) {
    throw new Error('Ocorrência não encontrada.')
  }

  let studentDuties = []

  if (Array.isArray(incident.student_duties)) {
    studentDuties = incident.student_duties
      .map(item => {
        if (typeof item === 'string') {
          return item
        }

        if (item) {
          return item.item
        }

        return undefined
      })
      .filter(Boolean)
  }

  let prohibitionAndResponsibilities = []

  if (
    Array.isArray(
      incident.prohibition_and_responsibilities
    )
  ) {
    prohibitionAndResponsibilities =
      incident.prohibition_and_responsibilities
        .map(item => {
          if (typeof item === 'string') {
            return item
          }

          if (item) {
            return item.item
          }

          return undefined
        })
        .filter(Boolean)
  }

  let student = ''

  if (incident.student?.name) {
    student = incident.student.name
  } else if (incident.student_name) {
    student = incident.student_name
  }

  let course = ''

  if (incident.course?.name) {
    course = incident.course.name
  } else if (incident.course_name) {
    course = incident.course_name
  }

  let typeIncident = ''

  if (incident.type_incident?.name) {
    typeIncident = incident.type_incident.name
  } else if (incident.type_incident) {
    typeIncident = incident.type_incident
  }

  let solution = ''

  if (incident.soluction) {
    solution = incident.soluction
  } else if (incident.solution) {
    solution = incident.solution
  }

  createIncidentPdf([
    {
      student,
      course,
      date_incident: incident.date_incident,
      time_incident: incident.time_incident,
      type_incident: typeIncident,
      description: incident.description,
      sanction: incident.sanction || '',
      solution,
      studentDuties,
      prohibitionAndResponsibilities
    }
  ])
}