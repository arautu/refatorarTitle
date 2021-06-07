#!/bin/sh

FONTES=${1:-"src"}
ABSPATH="src"

arquivosEncontrados=($(grep -E -r -l --include=*.jsp "(formView|listView|formTable).* title=" $FONTES))

echo "Encontrados " ${#arquivosEncontrados[@]} " arquivos."

if [ ${#arquivosEncontrados[@]} -eq 0 ]
then
    exit 0
fi

awk -i inplace -v GitPath=$ABSPATH -f refatorarTitle.awk ${arquivosEncontrados[@]}
