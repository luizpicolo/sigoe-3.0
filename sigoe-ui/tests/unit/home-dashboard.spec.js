import { flushPromises, shallowMount } from '@vue/test-utils'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import Home from '@/views/home.vue'
import { show } from '@/services/dashboard'

vi.mock('@/services/dashboard', () => ({ show: vi.fn() }))

describe('Dashboard', () => {
  beforeEach(() => {
    show.mockResolvedValue({
      by_years: { '2026': 3 },
      by_campus: { 'Campo Grande': 2, Dourados: 1 },
      by_courses: {},
      by_type_incident: {},
      by_sanction: {},
      by_is_resolved: {}
    })
  })

  it('renders the campus chart with the data returned by the API', async () => {
    const wrapper = shallowMount(Home, {
      global: {
        stubs: {
          Header: true,
          Sidebar: true,
          Breadcrumb: true,
          Chart: { name: 'Chart', props: ['title', 'data'], template: '<div data-test="chart">{{ title }}</div>' }
        }
      }
    })

    await flushPromises()

    const campusChart = wrapper.findAllComponents({ name: 'Chart' }).find(chart => chart.props('title') === 'Por Campus')
    expect(show).toHaveBeenCalledOnce()
    expect(campusChart).toBeDefined()
    expect(campusChart.props('data')).toEqual({ 'Campo Grande': 2, Dourados: 1 })
  })
})
