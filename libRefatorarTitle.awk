function getTagDetails(line, tagDetails,     atag, fieldpat, seps, i, instruction) {
  fieldpat = "(:\\w+)|(\\w+=)|(\"[^\"]*\")";
  patsplit(line, atag, fieldpat, seps);
  for (i in atag) {
    switch (atag[i]) {
      case /:\w+/ :
        tagDetails["tag"] = atag[i];
        gsub(/[: ]/, "", tagDetails["tag"]);
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
