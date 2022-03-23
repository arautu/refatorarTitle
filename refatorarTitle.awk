# Arquivo: refatorarTitle.awk
# Descrição: Refatora tags JSP, conforme api i18n.
# Uso: awk -v GitPath="/home/leandro/Sliic/git/" -f refatorarTitle.awk src/Sliic_ERP/Sliic_ERP_Modulo_Configuracao/webapp/WEB-INF/jsp/configuracao/perfilVinculacaoListagem.jsp 
@include "sliic/libLocProperties";
@include "sliic/libConvIsoUtf";
@include "sliic/libLocController";
@include "sliic/libParserFilePath";
@include "sliic/libJavaParser"
@include "libRefatorarTitle";

BEGIN {
  findFiles(msgs_paths);
}

BEGINFILE {
  parserFilePath(FILENAME, aMetaFile);
  MsgProp = locProperties(aMetaFile, msgs_paths);
  convertIso8859ToUtf8();
}

/(:(form|list)*[vV]iew|formTable).* title=/ {
  print "\n== Programa de refatoração de tags que declaram title ==\n" > "/dev/tty";
  print " Arquivo:", FILENAME > "/dev/tty";
  print " Properties:", MsgProp > "/dev/tty";
  
  controller = locController(FILENAME, aMetaFile);
  if (MsgProp) {
    fmt = removerIdentacao($0);
    printf " Refatorar:\t%s\n", fmt > "/dev/tty";

    $0 = getTagDetails($0, tagDetails);
    fmt = removerIdentacao($0);
    printf " Para:\t\t%s\n", fmt > "/dev/tty";
    
    tagName = toupper(substr(tagDetails["tag"], 1, 1)) substr(tagDetails["tag"], 2) "Tag.title";
    codigo = sprintf("%s.%s.%s.%s=%s", aMetaFile["module"], controller,
        aMetaFile["file"], tagName, tagDetails["title"]);
    printf " Código: %s\n\n", codigo  > "/dev/tty";
    
    if ("inplace::begin" in FUNCTAB) {
      printf "%s\r\n", codigo >> MsgProp;
    }
  }
  else {
    print "Erro: Nenhum arquivo de dicionário encontrado." > "/dev/tty";
}
}

{
  if ("inplace::begin" in FUNCTAB) {
    printf "%s%s", $0, RT;
  }
}

END {
  convertUtf8ToIso8859();
}
