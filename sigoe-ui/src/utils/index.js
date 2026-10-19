const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:3000";

export const formatDate = date => {
  if (!date) return ''
  // A calendar date has no timezone: avoid shifting it to the previous day.
  const value = /^\d{4}-\d{2}-\d{2}$/.test(date)
    ? new Date(`${date}T12:00:00`)
    : new Date(date)
  if (Number.isNaN(value.getTime())) return ''
  return value.toLocaleDateString('pt-BR', { day: '2-digit', month: '2-digit', year: '2-digit' })
}

export const toTimeInputValue = (time) => {
  if (!time) return ''

  // API time values represent a wall clock time. Keep their clock portion
  // instead of parsing the timestamp and shifting it to the browser timezone.
  const match = String(time).match(/(?:^|T)(\d{2}):(\d{2})/)
  return match ? `${match[1]}:${match[2]}` : ''
}

export const formatTime = toTimeInputValue

export const avatar = (path) => {
  if (!path) return '';
  try {
    return `${BASE_URL}/${path}`;
  } catch {
    return ''
  }
}
