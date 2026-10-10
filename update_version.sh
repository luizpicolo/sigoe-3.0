#!/usr/bin/env bash

set -euo pipefail

# Verifica se a nova versão foi informada
if [[ $# -ne 1 ]]; then
    echo "Uso: $0 <nova-versao>"
    echo "Exemplo: $0 1.2.3"
    exit 1
fi

NOVA_VERSAO="$1"
PACKAGE_JSON="sigoe-ui/package.json"

# Verifica se o arquivo existe
if [[ ! -f "$PACKAGE_JSON" ]]; then
    echo "Erro: arquivo package.json não encontrado."
    exit 1
fi

# Valida o formato básico da versão semver
if [[ ! "$NOVA_VERSAO" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$ ]]; then
    echo "Erro: versão inválida: $NOVA_VERSAO"
    echo "Utilize o formato: MAJOR.MINOR.PATCH (ex.: 1.2.3)"
    exit 1
fi

# Atualiza a versão no arquivo de versão da raiz
echo $NOVA_VERSAO > 'VERSION.md'

# Atualiza a versão usando Node.js
node -e '
const fs = require("fs");
const file = process.argv[1];
const version = process.argv[2];

const packageJson = JSON.parse(fs.readFileSync(file, "utf8"));
packageJson.version = version;

fs.writeFileSync(file, JSON.stringify(packageJson, null, 2) + "\n");

console.log(`Versão atualizada para ${version}`);
' "$PACKAGE_JSON" "$NOVA_VERSAO"