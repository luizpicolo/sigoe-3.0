git push backend $(git subtree split --prefix=backend main):main
git push frontend $(git subtree split --prefix=sigoe-ui main):main
git push baileys $(git subtree split --prefix=baileys main):main

# Configura o APP para usar o Docker como builder
dokku builder:set sigeo-ui selected dockerfile

# Adicione a variavel de Ambiente para ser complicada durante a compilação do APP
dokku docker-options:add sigoeui build '--build-arg VITE_API_URL'

# Criar novo release
gh release create v3.0.1 --title "v3.0.1" --notes "v3.0.1"


# No servidor Bailers
dokku apps:create baileys
dokku builder:set baileys selected dockerfile

dokku network:create sigoe-internal
dokku network:set sigoe attach-post-deploy sigoe-internal
dokku network:set baileys attach-post-deploy sigoe-internal

dokku domains:clear baileys
dokku config:set sigoe BAILEYS_URL=http://baileys.web:5051


# Worker
dokku ps:scale sigoe worker=1