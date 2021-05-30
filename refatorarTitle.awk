# Arquivo: refatorarTitle.awk
# Descrição: Refatora tags JSP, conforme api i18n.
@include "sliic/libLocProperties";
@include "sliic/libConvIsoUtf";

BEGIN {
  findFiles("src", msgs_paths);
}

BEGINFILE {
  locProperties(FILENAME);
  convertIso8859ToUtf8();
}
{

}

ENDFILE {
  convertUtf8ToIso8859();
}
