export const formatPhone = value => {
  const digits = String(value ?? '').replace(/\D/g, '').slice(0, 11)
  if (!digits) return ''

  const areaCode = digits.slice(0, 2)
  const subscriber = digits.slice(2)
  if (digits.length <= 2) return `(${areaCode}`

  const splitAt = digits.length > 10 ? 5 : 4
  const firstPart = subscriber.slice(0, splitAt)
  const secondPart = subscriber.slice(splitAt)
  return `(${areaCode})${firstPart}${secondPart ? `-${secondPart}` : ''}`
}
