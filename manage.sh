#!/bin/bash

#####
# LIVE
#####
LIVE_CONFIGS=(
              'live/admin/settings.json.enc'
              'live/customer/settings.json.enc'
              'live/merchant/settings.json.enc'
             )

LIVE_PASS_FILE="live_pass_file"

#####
# BETA
#####
BETA_CONFIGS=(
              'beta/admin/settings.json.enc'
              'beta/customer/settings.json.enc'
              'beta/merchant/settings.json.enc'
             )

BETA_PASS_FILE="beta_pass_file"

#####
# DEV
#####
DEV_CONFIGS=(
              'dev/settings.json.enc'
            )

DEV_PASS_FILE="dev_pass_file"




function help_text {
  echo "\
Usage: manage.sh -d|-e (-s)\

  -e --encrypt
  -d --decrypt
  -s --stage
             Stages in a comma separated list to encrypt/decrypt. 
             Allowed are <all>, <live>, <beta> and <dev>. 
             Default value is <all>.

  Example: 
    Decrypt all live and beta config files:
      manage.sh -d -s live,beta
       "
}

function check_pass {
  if [ ! -f $1 ]; then
    echo "
[Error] Could not find password file $1 

    Please provide the password inside the file $1

    Aborting ...
         "
    exit 1
  fi
}

function contains_element {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

function encrypt_files {

  pw=$1
  shift
  arr=("${@}")

  check_pass $pw

  for f in "${arr[@]}"
  do
    echo "Encrypt ${f::${#f}-4} to $f"
    openssl aes-256-cbc -k "`cat $pw`" -in ${f::${#f}-4} -e > $f
  done
}

function decrypt_files {

  pw=$1
  shift
  arr=("${@}")

  check_pass $pw

  for f in "${arr[@]}"
  do
    echo "Decrypt $f to ${f::${#f}-4}"
    openssl aes-256-cbc -k "`cat $pw`" -in $f -d > ${f::${#f}-4}
  done
}

STAGES=('all')

while [[ $# > 0 ]]
do
key="$1"
val="$2"

case $key in
    -d|--decrypt)
    DECRYPT=true
    ;;
    -e|--encrypt)
    ENCRYPT=true
    ;;
    -s|--stage)
    IFS=',' read -r -a STAGES <<< "$2"
    shift
    ;;
    -h|--help)
    help_text
    exit 0
    ;;
    -*)
    echo "[WARNING] Ignoring unknown option $key $val"
    ;;
    *)
    ;;
esac
shift
done

if [ ! $ENCRYPT ] && [ ! $DECRYPT ]
then
  help_text
  exit 1
fi

if [ $ENCRYPT ] && [ $DECRYPT ]
then
  echo "[Error] Both encrypt and decrypt flag set - only one allowed"
  exit 1
fi

if [ $ENCRYPT ]
then

  if contains_element 'all' ${STAGES[@]} || contains_element 'live' ${STAGES[@]} 
  then
    encrypt_files $LIVE_PASS_FILE ${LIVE_CONFIGS[@]}
  fi
  if contains_element 'all' ${STAGES[@]} || contains_element 'beta' ${STAGES[@]}
  then
    encrypt_files $BETA_PASS_FILE ${BETA_CONFIGS[@]}
  fi
  if contains_element 'all' ${STAGES[@]} || contains_element 'dev' ${STAGES[@]}
  then
    encrypt_files $DEV_PASS_FILE ${DEV_CONFIGS[@]}
  fi
fi

if [ $DECRYPT ]
then

  if contains_element 'all' ${STAGES[@]} || contains_element 'live' ${STAGES[@]} 
  then
    decrypt_files $LIVE_PASS_FILE ${LIVE_CONFIGS[@]}
  fi
  if contains_element 'all' ${STAGES[@]} || contains_element 'beta' ${STAGES[@]}
  then
    decrypt_files $BETA_PASS_FILE ${BETA_CONFIGS[@]}
  fi
  if contains_element 'all' ${STAGES[@]} || contains_element 'dev' ${STAGES[@]}
  then
    decrypt_files $DEV_PASS_FILE ${DEV_CONFIGS[@]}
  fi
fi
