export const formatDate = date => {
  if (!date) return ''
  // A calendar date has no timezone: avoid shifting it to the previous day.
  const value = /^\d{4}-\d{2}-\d{2}$/.test(date)
    ? new Date(`${date}T12:00:00`)
    : new Date(date)
  if (Number.isNaN(value.getTime())) return ''
  return value.toLocaleDateString('pt-BR', { day: '2-digit', month: '2-digit', year: '2-digit' })
}

export const formatTime = (time) => {
  if (!time) return ''

  if (/^\d{2}:\d{2}(:\d{2})?$/.test(time)) {
    return time.slice(0, 5)
  }

  try {
    return new Date(time).toLocaleTimeString('pt-BR', {
      hour: '2-digit',
      minute: '2-digit',
    })
  } catch {
    return ''
  }
}

export const avatar = (path) => {
  if (!path) return '';
  try {
    return `https://sigoe.na.ifms.edu.br/${path}`;
  } catch {
    return ''
  }
}