import { test, expect } from '@playwright/test'

test('visualiza os detalhes de uma ocorrência', async ({ page }) => {
  await page.goto('/ocorrencias/ocorrencias/visualizar/1')
  await expect(page.getByText(/Detalhes da Ocorrência #/)).toBeVisible()
  await expect(page.getByText('Informações da Ocorrência')).toBeVisible()
  await expect(page.getByText('Status da Ocorrência')).toBeVisible()
  await expect(page.getByText('Descrição da Ocorrência')).toBeVisible()
  await expect(page.getByText('Descrição da Solução')).toBeVisible()
})
