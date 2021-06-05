# Arquivo: refatorarTitle.awk
# Descrição: Refatora tags JSP, conforme api i18n.
@include "sliic/libLocProperties";
@include "sliic/libConvIsoUtf";
@include "sliic/libLocController";
@include "sliic/libParserFilePath";

BEGIN {
  findFiles("src", msgs_paths);
}

BEGINFILE {
  convertIso8859ToUtf8();
  parserFilePath(FILENAME, aMetaFile);
  print FILENAME;
  print msgProp = locProperties(aMetaFile);
}

/(formView|formTablet|listView).* title=/{
  print $0;
  print "controller", controller = locController(FILENAME, aMetaFile);
  
  print getTagDetails($0, tagDetails);

  for (i in tagDetails) {
    print i, tagDetails[i];
  }
  printf "codigo: %s.%s.%s=%s\n", aMetaFile["module"], controller, aMetaFile["file"], tagDetails["title"];  
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

ENDFILE {
  convertUtf8ToIso8859();
}
