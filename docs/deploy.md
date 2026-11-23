git push backend $(git subtree split --prefix=backend main):main
git push frontend $(git subtree split --prefix=sigoe-ui main):main

# Configura o APP para usar o Docker como builder
dokku builder:set sigeo-ui selected dockerfile

# Adicione a variavel de Ambiente para ser complicada durante a compilação do APP
dokku docker-options:add sigoeui build '--build-arg VITE_API_URL'

# Criar novo release
gh release create v3.0.1 --title "v3.0.1" --notes "v3.0.1"