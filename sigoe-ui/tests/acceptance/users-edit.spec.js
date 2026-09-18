import { mount, flushPromises } from '@vue/test-utils'
import { describe, expect, it, vi, beforeEach } from 'vitest'
import EditUser from '@/views/users/edit.vue'

const { findMock, updateMock, pushMock } = vi.hoisted(() => ({
  findMock: vi.fn(),
  updateMock: vi.fn(),
  pushMock: vi.fn()
}))

vi.mock('@/services/users', () => ({
  find: findMock,
  update: updateMock
}))

vi.mock('vue-router', () => ({
  useRoute: () => ({
    params: { id: '1' }
  }),
  useRouter: () => ({
    push: pushMock
  })
}))

describe('aceitação: edição de usuário', () => {
  beforeEach(() => {
    vi.clearAllMocks()

    findMock.mockResolvedValue({
      user: {
        name: 'Usuário',
        email: 'user@example.com',
        username: 'usuario'
      }
    })

    updateMock.mockResolvedValue({
      user: {
        id: 1
      }
    })
  })

  it('carrega os dados e envia as alterações', async () => {
    const wrapper = mount(EditUser, {
      global: {
        stubs: {
          Header: true,
          Sidebar: true,
          Breadcrumb: true,

          Card: {
            template: '<section><slot /></section>'
          },

          Input: {
            props: ['modelValue', 'id', 'label'],
            emits: ['update:modelValue'],
            template: `
              <input
                :id="id"
                :value="modelValue"
                @input="$emit('update:modelValue', $event.target.value)"
              />
            `
          },

          Alert: true,

          Button: {
            template: '<button type="submit"><slot /></button>'
          }
        }
      }
    })

    await flushPromises()

    expect(wrapper.text()).toContain(
      'Alterar informações do usuário'
    )

    expect(wrapper.find('#name').element.value).toBe('Usuário')

    expect(wrapper.find('#email').element.value).toBe(
      'user@example.com'
    )

    expect(wrapper.find('#username').element.value).toBe(
      'usuario'
    )

    await wrapper.find('#name').setValue('Nome Alterado')

    await wrapper.find('form').trigger('submit.prevent')

    await flushPromises()

    expect(updateMock).toHaveBeenCalledWith(
      '1',
      expect.objectContaining({
        name: 'Nome Alterado'
      })
    )
  })
})