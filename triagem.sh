#!/bin/sh
# Uso:
# ./triagem.sh /home/leandro/Sliic/git/sliic-erp/Sliic_ERP/Sliic_ERP_Modulo_Configuracao/
# ou pode passar o caminho do projeto por dentro do script, dispensando o uso do argumento
# na hora de chamar o script.

FONTES=${1:-"sliic-erp/Sliic_ERP/Sliic_ERP_Modulo_Integracao/webapp/WEB-INF/jsp/"}
# ABSPATH="/home/leandro/Sliic/git/"
ABSPATH="sliic-erp/"

arquivosEncontrados=($(grep -E -r -l --include=*.jsp "(formView|listView|formTable).* title=" $FONTES))

echo "Encontrados " ${#arquivosEncontrados[@]} " arquivos."

if [ ${#arquivosEncontrados[@]} -eq 0 ]
then
    exit 0
fi

awk -i inplace -v GitPath=$ABSPATH -f refatorarTitle.awk ${arquivosEncontrados[@]}
