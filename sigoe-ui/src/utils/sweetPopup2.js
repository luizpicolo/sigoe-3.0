import Swal from 'sweetalert2'

const baseOptions = {
  confirmButtonText: 'OK',
  customClass: {
    confirmButton: 'bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded'
  },
  buttonsStyling: false
}

export const success = message => Swal.fire({
  ...baseOptions,
  icon: 'success',
  title: 'Sucesso',
  text: message
})

export const error = message => Swal.fire({
  ...baseOptions,
  icon: 'error',
  title: 'Erro',
  text: message
})

export const warning = message => Swal.fire({
  ...baseOptions,
  icon: 'warning',
  title: 'Atenção',
  text: message
})

export const confirm = message => Swal.fire({
  ...baseOptions,
  icon: 'warning',
  title: 'Confirmação',
  text: message,
  showCancelButton: true,
  confirmButtonText: 'Confirmar',
  cancelButtonText: 'Cancelar',
  customClass: {
    confirmButton: 'bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded mr-2',
    cancelButton: 'bg-gray-200 hover:bg-gray-300 text-gray-800 px-4 py-2 rounded'
  }
}).then(result => result.isConfirmed)
