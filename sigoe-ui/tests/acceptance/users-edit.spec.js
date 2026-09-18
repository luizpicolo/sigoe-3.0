import { mount, flushPromises } from '@vue/test-utils'
import { describe, expect, it, vi, beforeEach } from 'vitest'
import EditUser from '@/views/users/edit.vue'

const mocks = vi.hoisted(() => ({
  find: vi.fn(),
  update: vi.fn(),
  push: vi.fn()
}))

vi.mock('@/services/users', () => ({ find: mocks.find, update: mocks.update }))
vi.mock('vue-router', () => ({
  useRoute: () => ({ params: { id: '1' } }),
  useRouter: () => ({ push: mocks.push })
}))

describe('aceitação: edição de usuário', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    mocks.find.mockResolvedValue({ user: { name: 'Usuário', email: 'user@example.com', username: 'usuario' } })
    mocks.update.mockResolvedValue({ user: { id: 1 } })
  })

  it('carrega os dados e envia as alterações', async () => {
    const wrapper = mount(EditUser, {
      global: {
        stubs: {
          Header: true,
          Sidebar: true,
          Breadcrumb: true,
          Card: { template: '<section><slot /></section>' },
          Input: { props: ['modelValue', 'id', 'label'], emits: ['update:modelValue'], template: '<input :id="id" :value="modelValue" @input="$emit(\'update:modelValue\', $event.target.value)" />' },
          Alert: true,
          Button: { template: '<button type="submit"><slot /></button>' }
        }
      }
    })

    await flushPromises()
    expect(wrapper.find('#name').element.value).toBe('Usuário')

    await wrapper.find('#name').setValue('Nome Alterado')
    await wrapper.find('form').trigger('submit.prevent')
    await flushPromises()

    expect(mocks.update).toHaveBeenCalledWith('1', expect.objectContaining({ name: 'Nome Alterado' }))
  })
})
