#!/bin/bash +x

umask 0002

LC_ALL=pt_BR.utf8 date

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
  return `openssl pkcs12 -info -noout -in "${CERT}" -passin stdin <<<"${PASSWORD}" 2>&1 | fgrep -c "MAC verified OK"`
}

## FUNÇÃO: VERIFICAR SE O CERTIFICADO ESTÁ EXPIRADO
##
## check_certificate_date /PATH/TO/CERTIFICADO.PFX
##
## retorna 1 se verdadeiro | 0 se falso
##
function check_certificate_date {
  CERT="$1"
  return `pdfsig "${CERT}" | fgrep -c "Certificate has Expired"`
}

#######################
## ARGUMENTOS
###################

## PRIMEIRO ARGUMENTO: CERTIFICADO PFX
if [ -s "$1" ]
then
  # verificando se o certificado é válido
  check_certificate "$1" "$2"
  RETURN_CODE=$?
  if [ ${RETURN_CODE} -eq "1" ]
  then
    echo "Certificado OK"
    cd $(dirname "$1")
    echo "Diretorio atual: `pwd`"
  else
    echo "Certificado INVALIDO"
    exit 1
  fi
fi

exit 0

export CLASSPATH="${DIR_SCRIPT}/bcprov-jdk16-137.jar:${DIR_SCRIPT}/itext-2.0.4.jar:${DIR_SCRIPT}/sign.class:."

#echo "Usage: $0 <Certifiate.pkcs12> <Password> <Original.pdf> <Output.pdf>"

java sign ${@}

exit 0
