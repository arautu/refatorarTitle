# Arquivo: refatorarTitle.awk
# Descrição: Refatora tags JSP, conforme api i18n.
@include "sliic/libLocProperties";
@include "sliic/libConvIsoUtf";
@include "sliic/libLocController";
@include "sliic/libParserFilePath";

BEGIN {
  findFiles(GitPath, msgs_paths);
}

BEGINFILE {
  convertIso8859ToUtf8();
  parserFilePath(FILENAME, aMetaFile);
  msgProp = locProperties(aMetaFile);
}

/(formView|formTablet|listView).* title=/{
  print "== Programa de refatoração de tags que declaram title ==" > "/dev/tty";
  print " Arquivo:", FILENAME > "/dev/tty";
  print " Properties:", msgProp > "/dev/tty";
  print " Refatorar:", $0 > "/dev/tty";
  
  controller = locController(FILENAME, aMetaFile);
  
  $0 = getTagDetails($0, tagDetails);
  printf " Para: %s\n\n", $0 > "/dev/tty";

  printf "codigo: %s.%s.%s.%sTag=%s\n", aMetaFile["module"], controller,
         aMetaFile["file"], tagDetails["tag"], tagDetails["title"] >> msgProp;  
}

{
  printf "%s", $0;
}

function getTagDetails(line, tagDetails,     atag, fieldpat, seps, i, instruction) {
  fieldpat = "(:\\w+)|(\\w+=)|(\"[^\"]+\")";
  patsplit(line, atag, fieldpat, seps);
  for (i in atag) {
    switch (atag[i]) {
      case /:\w+/ :
        tagDetails["tag"] = atag[i];
        gsub(/[:\s]/, "", tagDetails["tag"]);
        break;
      case /title=/ :
        delete seps[--i];
        i++;
        delete atag[i];
        delete seps[i++];
        tagDetails["title"] = atag[i];
        gsub("\"", "", tagDetails["title"]);
        delete atag[i];
        break;
      default :
        break;
    }
  }
# Reconstrução da instrução sem "title"
  for (i=0; i < length(seps); i++) {
    instruction = instruction sprintf ("%s%s", atag[i], seps[i]);
  }
  return instruction;
}

END {
  convertUtf8ToIso8859();
}
