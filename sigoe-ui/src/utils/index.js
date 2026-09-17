export const formatDate = (date) => {
  if (!date) return '';
  try {
    return new Date(date).toLocaleString('pt-BR', { dateStyle: 'short', timeStyle: 'short' });
  } catch {
    return '';
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