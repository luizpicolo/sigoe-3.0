import { mount } from '@vue/test-utils'
import { nextTick } from 'vue'
import { describe, expect, it } from 'vitest'
import Select from '@/components/ui/select.vue'

describe('Select', () => {
  const options = [
    { value: '', label: 'Todas' },
    { value: '1', label: 'Alice' },
    { value: '2', label: 'Bruno' }
  ]

  it('filtra opções e emite o valor selecionado', async () => {
    const wrapper = mount(Select, { props: { options, modelValue: '' } })

    await wrapper.find('button').trigger('click')
    await wrapper.find('input[type="search"]').setValue('bru')

    expect(wrapper.findAll('button').map(button => button.text())).toContain('Bruno')
    expect(wrapper.findAll('button').map(button => button.text())).not.toContain('Alice')

    await wrapper.findAll('button').find(button => button.text() === 'Bruno').trigger('click')
    expect(wrapper.emitted('update:modelValue')).toEqual([['2']])
  })

  it('fecha ao clicar fora', async () => {
    const wrapper = mount(Select, { props: { options } })

    await wrapper.find('button').trigger('click')
    expect(wrapper.find('input[type="search"]').exists()).toBe(true)

    document.body.click()
    await nextTick()
    expect(wrapper.find('input[type="search"]').exists()).toBe(false)
  })
})
