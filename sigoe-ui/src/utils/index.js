export const formatDate = (date) => {
  if (!date) return '';
  try {
    return new Date(date).toLocaleDateString('pt-BR', { dateStyle: 'short' });
  } catch {
    return '';
  }
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