#!/bin/bash +x

umask 0002

#LC_ALL=pt_BR.utf8 date

readonly NC='\033[0m'
readonly RED='\033[0;31m' 
readonly DIR_SCRIPT=$(dirname "$0")
readonly FILE_LOCALIZADOR="localizador.json"
readonly CMD_DATE="date +%y%m%d%H%M%S"

## JAVA
if ! [ -x "$(command -v java)" ]; then
  echo "Comando 'java' nao instalado!"
  exit 1
fi

## OPENSSL
if ! [ -x "$(command -v openssl)" ]; then
  echo "Comando 'openssl' nao instalado!"
  exit 1
fi

## PDFSIG
if ! [ -x "$(command -v pdfsig)" ]; then
  echo "Comando 'pdfsig' nao instalado!"
  exit 1
fi

#######################
## ARGUMENTOS
###################
# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [-f OUTFILE] [FILE]...
Do stuff with FILE and write the result to standard output. With no FILE
or when FILE is -, read standard input.

    -h          display this help and exit
    -f OUTFILE  write the result to OUTFILE instead of standard output.
    -v          verbose mode. Can be used multiple times for increased
                verbosity.
EOF
exit 1
}

[ "$#" == 0 ] && show_help

#######################
## FUNÇÕES
###################

## SIGN PDF
function sign {
  return 0
}

## FUNÇÃO: VERIFICAR SE O CERTIFICADO É VÁLIDO
##
## check_certificate /PATH/TO/CERTIFICADO.PFX SENHA
##
## retorna 1 se verdadeiro | 0 se falso
##
function check_certificate {
  CERT="$1"
  PASSWORD="$2"
  expiration_date=`openssl pkcs12 -in "${CERT}" -nokeys -passin pass:"${PASSWORD}" 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2`
  expiration_date_ts=`date -d "${expiration_date}" +%s`
  current_ts=`date +%s`
  if [ $((${expiration_date_ts})) -gt $((${current_ts})) ]
  then
    return 1
  else
    return 0
  fi
}

## FUNÇÃO: VERIFICAR SE O CERTIFICADO ESTÁ EXPIRADO
##
## check_certificate_date /PATH/TO/CERTIFICADO.PFX
##
## retorna 1 se verdadeiro | 0 se falso
##
function check_pdf {
  PDF="$1"
  #pdfsig "${PDF}" | fgrep -c "Certificate has Expired"
  pdfsig "${PDF}" 
}

#######################
## ARGUMENTOS
###################

while [[ $# -gt 0 ]]; do
  key="$1"
  case "$key" in
    -h|--help)
    show_help
    ;;
    -p|--pdf)
    check_pdf $2
    ;;
    *)
    echo "Opção inválida '$key'"
    ;;
  esac
  shift 2
done


## PRIMEIRO ARGUMENTO: CERTIFICADO PFX
#if [ -s "$1" ]
#then
#  # verificando se o certificado é válido
#  check_certificate "$1" "$2"
#  RETURN_CODE=$?
#  if [ ${RETURN_CODE} -eq "1" ]
#  then
#    echo "Certificado OK"
#    cd $(dirname "$1")
#    echo "Diretorio atual: `pwd`"
#  else
#    echo -e "${RED}Erro: Certificado ou senha INVALIDOS${NC}"
#    exit 1
#  fi
#else
#  echo -e "${RED}Erro: O primeiro argumento deve ser um arquivo '.pfx' de certificado válido${NC}"
#  exit 1
#fi

exit 0

export CLASSPATH="${DIR_SCRIPT}/bcprov-jdk16-137.jar:${DIR_SCRIPT}/itext-2.0.4.jar:${DIR_SCRIPT}/sign.class:."

#echo "Usage: $0 <Certifiate.pkcs12> <Password> <Original.pdf> <Output.pdf>"

java sign ${@}

exit 0
