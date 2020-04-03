#!/usr/bin/env bash

##############################################################################
#
# Tavinus Cloud Manager
# https://github.com/tavinus/cloudmanager
#
# CLI App to use Nextcloud/Owncloud via Webdav
# Uses curl to perform webdav calls
# Tries to be feature-complete with NC's webdav functions
#
# Gustavo Arnosti Neves
#
# Created..: 12 / 06 / 2018
# Modified.: 03 / 04 / 2020
#
##############################################################################


C_VERSION='0.1.9'

                                    # working languages should be added here
C_SUPPORTED_LANGUAGES=(en_US pt_BR)
C_USER_LANGUAGE='en_US'             # default language








##############################################################################
## MESSAGES TRANSLATIONS


# US English Messages
setMessagesEnUs() {
        # ONLY en_US should have these vars
        M_EMPTYMESSAGE=$''
        M_SEP=$'-------------------------------------------------------\n'
        
        # All languages should have these vars
        M_DEPMISS=$'Error! Dependency Missing.\nYou need to install or add the missing dependency to your $PATH'
        M_ERRORCONNECT=$'Error! Could not contact the destination server with NC.\nServer seems to be offline:'
        M_TRYHELP="Try: $0 --help"
        M_NAME='Name'
        M_FILE='File'
        M_ERRORCONFIGNOTFOUND=$'Error! Config file not found!'
        M_ERRORACCSNOTFOUND=$'Error! Accounts file not found!'
        M_ERRORSENDFILE=$'Error when sending file.'
        M_FILEORIGINNOTFOUND=$'Source file does not exist!'
        M_ERRORCREATEFOLDER=$'Error when creating folder!'
        M_FOLDEREMPTY=$'Folder name is not set / it is empty.'
        M_ERRORERASE="Error when removing folder or file!"
        M_ITEMEMPTY="One item is empty / not specified."
        M_ERRORMOVE="Error when moving folder or file!"
        M_SOURCE="Source"
        M_DESTINATION="Destination"
        M_ERRORUSERNOTFOUND="Error! Could not locate the user"
        M_CHECKUSER="Plase check the login name or the accounts file."
        M_ERRORCOPY="Error when copying folder or file!"
        M_ERRORFILENOTFOUND="Error! File not found!"
        M_INVALIDOPTION="Invalid Option"
        M_NOCOMMANDSELECTED="No command selected!"
        M_ERRORGETFILE="Error when downloading file"
        M_CLOUDFILE="Cloud File"
        M_LOCALFILE="Local File"
        M_ERRORDOWNLOAD="Download error detected, removing file..."
        M_USINGHSORTLANGUAGE='Using short notation for language'
        M_INVALIDLANGUAGE='Invalid language selected will be ignored'
        M_EDITCONFIGFILE='Please edit the new config file before using CloudManager.'
        M_MAYNEEDPERMISSIONS='May need elevated permissions?'
        M_SERVERCONFIGWASRESET=$'The server config file was reset!\n'"$M_EDITCONFIGFILE"
        M_ACCOUNTSCONFIGWASRESET=$'The accounts config file was reset!\n'"$M_EDITCONFIGFILE"
        M_SERVERCONFIGRESETERROR=$'Error when trying to reset the server config file.\n'"$M_MAYNEEDPERMISSIONS"
        M_ACCOUNTSCONFIGRESETERROR=$'Error when trying to reset the accounts config file.\n'"$M_MAYNEEDPERMISSIONS"
        M_RESETSERVERCONFIG='You can create a new/empty server config file template with'
        M_RESETACCOUNTSCONFIG='You can create a new/empty accounts config file template with'
        M_REMOVING='Removing'
        M_CREATINGFOLDER='Creating Folder'


        ### HELP
        M_HELPINFO="
CONFIG
 - cloudmanager.server    Edit this file to configure host domain, protocol and port
 - cloudmanager.accounts  Edit this file to add nextcloud accounts
                          The first user of the list is the default user
                          You may use an \"app\" token instead of the user password (safer)

 Both config files MUST be populated before you try to use Cloud Manager

OPTIONS

 -V, --version             Prints version to screen and finishes execution
 -v, --verbose             Prints execution information to screen
 -h, --help                Prints this help to screen and finishes execution
     --resetServerConfig   Resets server config file to default
     --resetAccountsConfig Resets accounts config file to default
     --resetAll            Resets all config files
 -u, --user <username>     Loads the user <username> from the cloudmanager.accounts file
 -l, --language <lang>     Force the language <lang>
                           Languages currently supported:
                           ${C_SUPPORTED_LANGUAGES[@]}

NOTES
 - Target locations ending with a forward dash "/" will be treated as folders and
   will have the source name file appended to it as a target location.

COMMANDS

> ls,list [target]
    Lists a folder or file (lists root folder if empty)
    Ex: $C_SNAME list 

> mkdir,makeFolder <foldername>
    Creates a folder at the cloud
    Ex: $C_SNAME mkdir MyTestFolder

> send,upload <localfolder/localfile> [cloudfolder/cloudfile]
    Sends a local file to the cloud instance
    Ex: $C_SNAME send '/home/user/MyFile.xml' 'CloudFolder/MyFile.xml'

> mv,move <source> <target>
    Moves a folder or file inside the cloud instance
    Ex: $C_SNAME move 'OneFolder/MyFile.txt' 'AnotherFolder/MyFile.txt'

> cp,copy <source> <target>
    Copies a folder or file inside the cloud instance
    Ex: $C_SNAME copy 'OneFolder/MyFile.txt' 'AnotherFolder/MyFile.txt'

> del,delete <target>
    Erases a folder or file inside the cloud instance (may move to Trashbin)
    Ex: $C_SNAME del 'MyFolder/MyFile.txt'

> get,download <source> [target]
    Downloads a file from the cloud to a local folder 
    Target defaults to current folder with remote name if blank
    Ex: $C_SNAME get 'RemoteFolder/RemoteFile.txt' '/home/user/MyFile.txt'

> shares,listShares [folder]
    Prints table with shares (183 cols)
    Specify a folder or leave blank to list all
    Ex: $C_SNAME shares

> links,sharedLinks
    List shares by links using the format <URL>,<FILE NAME>
    Ex: $C_SNAME listShares

"

}


# Brazilian Portuguese Messages
setMessagesPtBr() {
        M_DEPMISS=$'Erro! Dependencia nao encontrada.\nVoce precisa instalar ou adicionar o programa em questao ao seu $PATH'
        M_ERRORCONNECT=$'Erro! Nao foi possivel conectar ao servidor de destino.\nServidor parece estar offline:'
        M_TRYHELP="Tente: $0 --help"
        M_NAME='Nome'
        M_FILE='Arquivo'
        M_ERRORCONFIGNOTFOUND=$'Erro! Arquivo de configuracao nao foi encontrado!'
        M_ERRORACCSNOTFOUND=$'Erro! Arquivo de contas e senhas nao foi encontrado!'
        M_ERRORSENDFILE=$'Erro ao enviar arquivo.'
        M_FILEORIGINNOTFOUND=$'Arquivo de origem nao existe!'
        M_ERRORCREATEFOLDER=$'Erro ao criar pasta!'
        M_FOLDEREMPTY=$'Nome da pasta em branco / nao especificada.'
        M_ERRORERASE="Erro ao apagar pasta ou arquivo!"
        M_ITEMEMPTY="A item em branco / nao especificado."
        M_ERRORMOVE="Erro ao mover a pasta ou arquivo!"
        M_SOURCE="Origem"
        M_DESTINATION="Destino"
        M_ERRORUSERNOTFOUND="Erro! Nao foi possivel localizar o usuario"
        M_CHECKUSER="Verifique o nome do usuario ou o arquivo de contas."
        M_ERRORCOPY="Erro ao copiar a pasta ou arquivo!"
        M_ERRORFILENOTFOUND="Erro! Arquivo nao encontrado!"
        M_INVALIDOPTION="Opcao Invalida"
        M_NOCOMMANDSELECTED="Nenhum comando selecionado!"
        M_ERRORGETFILE="Erro ao baixar arquivo"
        M_CLOUDFILE="Arquivo Cloud"
        M_LOCALFILE="Arquivo Local"
        M_ERRORDOWNLOAD="Erro de download detectado, removendo arquivo..."
        M_USINGHSORTLANGUAGE='Usando notacao minimalist para idioma'
        M_INVALIDLANGUAGE='Idioma invalido sera ignorado'
        M_EDITCONFIGFILE='Edite o novo arquivo de configuracao antes de usar o CloudManager.'
        M_MAYNEEDPERMISSIONS='Talvez precise de permissoes elevadas?'
        M_SERVERCONFIGWASRESET=$'A configuracao do servidor foi restaurada!\n'"$M_EDITCONFIGFILE"
        M_ACCOUNTSCONFIGWASRESET=$'A configuracao das contas foi restaurada!\n'"$M_EDITCONFIGFILE"
        M_SERVERCONFIGRESETERROR=$'Erro ao tentar recriar o arquivo de configuracao do servidor.\n'"$M_MAYNEEDPERMISSIONS"
        M_ACCOUNTSCONFIGRESETERROR=$'Erro ao tentar recriar o arquivo de configuracao das contas.\n'"$M_MAYNEEDPERMISSIONS"
        M_RESETSERVERCONFIG='Voce pode criar um novo arquivo de config do servidor usando'
        M_RESETACCOUNTSCONFIG='Voce pode criar um novo arquivo de config das contas usando'
        M_REMOVING='Removendo'
        M_CREATINGFOLDER='Criando Pasta'


        ### HELP
        M_HELPINFO="
ARQUIVOS DE CONFIG
 - cloudmanager.server    Edite este arquivo para configurar o dominio, porta e protocolo
 - cloudmanager.accounts  Edite este arquivo para configurar as contas de acesso 
                          O primeiro usuario e' o padrao
                          Voce pode utilizar um token de aplicativo ao inves da senha do usuario (mais seguro)

 Ambos os arquivos de configuracao TEM que ser preenchidos antes de usar o Cloud Manager

OPCOES

 -V, --version             Imprime versao na tela e termina execucao
 -v, --verbose             Imprime informacoes de execucao na tela
 -h, --help                Imprime esta ajuda e termina execucao
 -r, --resetServerConfig   Reseta / recria o arquivo de configuracoes de servidor
 -r, --resetAccountsConfig Reseta / recria o arquivo de configuracoes de contas
 -r, --resetAll            Reseta / recria todos os arquivos de configuracoes
 -u, --user <username>     Carrega o usuario <username> do arquivo cloudmanager.accounts
 -l, --language <lang>     Forca o idioma <lang>
                           Idiomas aceitos nesta versao:
                           ${C_SUPPORTED_LANGUAGES[@]}

NOTAS
 - Destinos que terminarem com uma barra para frente "/" serao tratados como uma
   pasta e terao o nome do arquivo de origem adicionados ao caminho como destino.

COMANDOS

> ls,list [destino]
    Lista uma pasta ou arquivo
    Ex: $C_SNAME list 

> mkdir,makeFolder <nomedapasta>
    Cria uma pasta no cloud
    Ex: $C_SNAME mkdir PastaTeste

> send,upload <pasta/arquivo.local> [pasta/arquivo.cloud]
    Envia um arquivo local para o cloud
    Ex: $C_SNAME send '/user/nfe/meuarquivo.xml' 'ARCO/nfe/meuarquivo.xml'

> mv,move <origem> <destino>
    Move um arquivo ou pasta dentro do cloud
    Ex: $C_SNAME move 'ARCO/meuarquivo.txt' 'ATL/meuarquivo.txt'

> cp,copy <origem> <destino>
    Copia um arquivo ou pasta dentro do cloud
    Ex: $C_SNAME copy 'ARCO/meuarquivo.txt' 'ATL/meuarquivo.txt'

> del,delete <destino>
    Apaga um arquivo ou pasta dentro do cloud (move para a lixeira)
    Ex: $C_SNAME del 'ARCO/meuarquivo.txt'

> get,download <origem> [destino]
    Faz download de um arquivo do cloud para um disco local
    Ex: $C_SNAME get 'ARCO/meuarquivo.txt' '/user/nfe/meuarquivo.txt'

> shares,listShares [pasta]
    Imprime tabela com compartilhamentos (183 cols)
    Especifique uma pasta ou deixe em branco para listar tudo.
    Ex: $C_SNAME shares

> links,sharedLinks
    Lista os compartilhamentos por links em formato <URL>,<NOME ARQUIVO>
    Ex: $C_SNAME listShares

"

}







##############################################################################
## LANGUAGE HANDLING


# Loads language strings based on env vars and/or cli params
initLanguage() {
        # Load english defaults to make sure we have all messages
        setMessagesEnUs

        # Get language from env var $LANG and use it as new default
        if [[ ! -z ${LANG%.*} ]]; then
                C_USER_LANGUAGE=${LANG%.*}
                setMessages
        fi
        
        # Now we try to parse a forced language from cli
        #echo " ${C_SUPPORTED_LANGUAGES[@]} " ; echo "$(lowercase "${C_SUPPORTED_LANGUAGES[@]}")"
        local lsup="$(lowercase "${C_SUPPORTED_LANGUAGES[@]}")"
        local ssup=() # short versions
        for i in "${C_SUPPORTED_LANGUAGES[@]}"; do
                ssup=( "${ssup[@]}" "${i%_*}" )
        done
        ssupSTR="$(lowercase "${ssup[@]}")"

        # get language from cli parameter (if set)
        while :; do
                case "$1" in
                        -l|--language)
                                if [[ " $lsup " =~ " $(lowercase ${2}) " ]]; then 
                                        C_USER_LANGUAGE="$2"
                                elif [[ " $ssupSTR " =~ " $(lowercase ${2}) " ]]; then 
                                        C_USER_LANGUAGE="$2"
                                        #log "$M_USINGHSORTLANGUAGE: $2"
                                else
                                        logErr "$M_INVALIDLANGUAGE: $2"
                                fi
                                break ;;
                        *)
                                isEmpty "$1" && break || shift ;;
                esac
        done

        setMessages
}


# Load messages based on language set
setMessages() {
        # use lowercase version for comparison (case insensitiveness)
        local lang="$(lowercase $C_USER_LANGUAGE)"

        #log "C_USER_LANGUAGE > $C_USER_LANGUAGE" ; log "lang            > $lang"

        # load secondary languages or default
        # Default is en_US (English US)
        if [[ $lang == 'en_us' ]] || [[ ${lang%_*} == 'en' ]]; then    # default for en_*
                setMessagesEnUs
        elif [[ $lang == 'pt_br' ]] || [[ ${lang%_*} == 'pt' ]]; then  # default for pt_*
                setMessagesPtBr
        fi
}






##############################################################################
## INITIAL SETUP


# Initial Variables
initVars() {
        C_SNAME="$(basename "$0")"
        C_DNAME="$(dirname "$0")"
        C_REALPATH="$(realpath "$0")"
        C_REALSNAME="$(basename "$C_REALPATH")"
        C_REALDNAME="$(dirname "$C_REALPATH")"

        # Uncomment to debug
        # echo "\$0          > $C_SNAME" ; echo "C_SNAME     > $C_SNAME" ; echo "C_DNAME     > $C_DNAME" ; echo "C_REALPATH  > $C_REALPATH" ; echo "C_REALSNAME > $C_REALSNAME" ; echo "C_REALDNAME > $C_REALDNAME" ;

        C_CONFIG_FILE="$C_REALDNAME"/cloudmanager.server      # Edit server info here
        C_ACCOUNTS_FILE="$C_REALDNAME"/cloudmanager.accounts  # Edit accounts here

        C_ACC_USERS=()
        C_ACC_PASSWORDS=()

        TRUE=0
        FALSE=1
        VERBOSE=$FALSE
}


# Creates the file cloudmanager.server with the default options
resetServerConfig() {
        echo -ne "# Edit the shell variables below
CLOUDSERVERDOMAIN='cloud.domain.tld'
CLOUDSERVERPROTOCOL='https://'
CLOUDSERVERPORT=443
" > "$C_CONFIG_FILE"
        if [[ $? -eq 0 ]]; then
                log "$M_SEP$M_SERVERCONFIGWASRESET"$'\n'" > $C_CONFIG_FILE"
        else
                logErr "$M_SEP$M_SERVERCONFIGRESETERROR"$'\n'" > $C_CONFIG_FILE"
        fi
}


# Creates the file cloudmanager.accounts with the default options
resetAccountsConfig() {
        echo -ne "---- Add accounts one per line, as in USERNAME:PASSWORD
---- You can use an \"App Password\" to access your account (instead of your regular password)
---- Settings > Personal > Security > Enter App Name > Create new app password
---- The first user is the default user, the rest can be used with -u <usernamme>
---- Lines starting with four dashes will be ignored
myUsername:myPassword
" > "$C_ACCOUNTS_FILE"
        if [[ $? -eq 0 ]]; then
                log "$M_SEP$M_ACCOUNTSCONFIGWASRESET"$'\n'" > $C_ACCOUNTS_FILE"
        else
                logErr "$M_SEP$M_ACCOUNTSCONFIGRESETERROR"$'\n'" > $C_ACCOUNTS_FILE"
        fi
}


# Resets all config files with the default options
resetAll() {
        resetServerConfig
        resetAccountsConfig
}


# Initial setups and checks
initCloudManager() {

        # initVars

        if [[ -f "$C_CONFIG_FILE" ]]; then
                . "$C_CONFIG_FILE"
        else
                logErr "$M_ERRORCONFIGNOTFOUND"$'\n > '"$C_CONFIG_FILE"$'\n'"$M_RESETSERVERCONFIG"$'\n'"$0 --resetServerConfig"
                exit 33
        fi

        if [[ -f "$C_ACCOUNTS_FILE" ]]; then
                C_ACCOUNTS="$(grep -v '^----' "$C_ACCOUNTS_FILE")"
                #echo -e "$C_ACCOUNTS"
        else
                logErr "$M_ERRORACCSNOTFOUND"$'\n > '"$C_ACCOUNTS_FILE"$'\n'"$M_RESETACCOUNTSCONFIG"$'\n'"$0 --resetAccountsConfig"
                exit 33
        fi
        
        parseAccounts

        # The default username is the first account in the config file
        #C_USER="$(echo "$C_ACCOUNTS" | head -n 1)"
        #C_USERNAME=${C_USER%:*}
        #C_PASS=${C_USER#*:}
        C_USER="${C_ACC_USERS[0]}:${C_ACC_PASSWORDS[0]}"
        C_USERNAME="${C_ACC_USERS[0]}"
        C_PASS="${C_ACC_PASSWORDS[0]}"

        # Uncomment to debug
        # echo "CUSER      > $C_USER" ; echo "C_USERNAME > $C_USERNAME" ; echo "C_PASS     > $C_PASS"

        # https://cloud.domain.net/remote.php/dav/files/<username>/
        C_BASE_URL="$CLOUDSERVERPROTOCOL""$CLOUDSERVERDOMAIN"":""$CLOUDSERVERPORT"
        C_FDAV_URL="$C_BASE_URL/remote.php/dav/files"
        C_OCS_URL="$C_BASE_URL/ocs/v2.php/apps/files_sharing/api/v1"

        CURLBIN="$(command -v curl 2>/dev/null)"
        STRBIN="$(command -v strings 2>/dev/null)"
        NCBIN="$(command -v nc 2>/dev/null)"

        ### INITIAL ENVIRONMENT VALIDATION
        checkDep "$CURLBIN"
        checkDep "$STRBIN"
        checkDep "$NCBIN"
}


# Load account info into Bash arrays
parseAccounts() {
        C_ACC_USERS=()
        C_ACC_PASSWORDS=()
        while IFS= read -r acc; do
                #echo $'accounts > '"$acc"
                C_ACC_USERS=( "${C_ACC_USERS[@]}" "${acc%:*}" )
                C_ACC_PASSWORDS=( "${C_ACC_PASSWORDS[@]}" "${acc#*:}" )
        done <<< "$C_ACCOUNTS"
        #echo "------------------" ; echo $'C_ACC_USERS     > '"${C_ACC_USERS[@]}" ; echo $'C_ACC_PASSWORDS > '"${C_ACC_PASSWORDS[@]}" ; echo "------------------"
        #echo "${C_ACC_USERS[1]}"
}







################################################################
#### VALIDATORS


# Dependency check
checkDep() {
        isExecutable "$1" && return $TRUE
        logErr "$M_DEPMISS"$'\n'" > $1"
        exit 6
}


# Returns $TRUE if $1 is a file, $FALSE otherwise
isFile() {
        [[ -f "$1" ]] && return $TRUE
        return $FALSE
}


# Returns $TRUE if $1 is executable, $FALSE otherwise
isExecutable() {
        [[ -x "$1" ]] && return $TRUE
        return $FALSE
}


# Returns $TRUE if $1 is empty, $FALSE otherwise
isEmpty() {
        [[ -z "$1" ]] && return $TRUE
        return $FALSE
}


# Returns $TRUE if $1 is not empty, $FALSE otherwise
isNotEmpty() {
        [[ -z "$1" ]] && return $FALSE
        return $TRUE
}


# Prints error message and exits with status code
initError() {
        isEmpty "$1" || printf "$1"
        ret=33
        isEmpty "$2" || ret=$2
        exit $ret
}


# Check if the server is reachable with nc
checkCloud() {
        "$NCBIN" -w 3 -z "$CLOUDSERVERDOMAIN" $CLOUDSERVERPORT &>/dev/null
        if [[ $? -ne 0 ]]; then
                logErr "$M_ERRORCONNECT"$'\n'" > $C_BASE_URL"
                exit 2
        fi
}


# Prints last char of a string
strLastChar() {
        local __str="$@"
        echo -ne "${__str: -1}"
}


# Returns $TRUE if a string ends with a dash (/), $FALSE otherwise
endsWithDash() {
        local __str="$@"
        [[ $(strLastChar "$__str") == '/' ]] && return $TRUE
        return $FALSE
}







################################################################
#### XML PARSING


# XML Iterator
read_dom () {
        local IFS=\>
        read -d \< ENTITY CONTENT
        local RET=$?
        TAG_NAME=${ENTITY%% *}
        ATTRIBUTES=${ENTITY#* }
        return $RET
}


# simple XML STRING print
dumpXmlString() {
        local readme="$1"
        while read_dom; do
                echo "$ENTITY => $CONTENT"
        done < <(printf '%s\n' "$readme")
}


# simple XML FILE print
dumpXmlFile() {
        while read_dom; do
                echo "$ENTITY => $CONTENT"
        done < "$1"
}


# ls behaviour from XML list
listFromXml() {
        local readme="$1"
        local isFirst=$TRUE
        while read_dom; do
                if [[ "$ENTITY" = "d:href" ]]; then
                        if [[ $isFirst -eq $TRUE ]]; then
                                isFirst=$FALSE
                                continue # ignore ROOT folder
                        fi
                        # ${haystack//needle/replacement}
                        printf "%s\n" "$(basename "${CONTENT//%20/ }")"
                fi
        done < <(printf '%s\n' "$readme")
}







################################################################
#### HELPER FUNCTIONS


# encode URL escaping
rawUrlEncode() {
        local string="${1}"
        local strlen=${#string}
        local encoded=""
        local pos c o

        for (( pos=0 ; pos<strlen ; pos++ )); do
                c=${string:$pos:1}
                case "$c" in
                        [-_.~a-zA-Z0-9] ) o="${c}" ;;
                        * )               printf -v o '%%%02x' "'$c"
                esac
                encoded+="${o}"
        done
        echo "${encoded}"    # You can either set a return variable (FASTER) 
        REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}


escapeWhitespaces() {
        local string="${1}"
        local strlen=${#string}
        local encoded=""
        local pos c o

        for (( pos=0 ; pos<strlen ; pos++ )); do
                c=${string:$pos:1}
                case "$c" in
                        " " ) o='%20' ;;
                        * ) o="${c}" ;;
                esac
                encoded+="${o}"
        done
        echo "${encoded}"    # You can either set a return variable (FASTER) 
        REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p

}


#testVar='https://cloud.arnosti.net.br/dav/test/what ever you want'
#echo "$(rawUrlEncode "$testVar")"
#echo "$(escapeWhitespaces "$testVar")"


# Returns the lowercase version of $@
lowercase() {
        echo -ne "$@" | tr '[:upper:]' '[:lower:]'
}


# Returns the uppercase version of $@
uppercase() {
        echo -ne "$@" | tr '[:lower:]' '[:upper:]'
}







################################################################
#### NEXTCLOUD API INFO

####################################################
## Share API Statuscodes:
##    100 - successful
##    400 - wrong or no update parameter given
##    403 - public upload disabled by the admin
##    404 - couldn’t update share
####################################################
# The OCS Share API allows you to access the sharing API from outside over pre-defined OCS calls.
# The base URL for all calls to the share API is: <nextcloud_base_url>/ocs/v2.php/apps/files_sharing/api/v1
# All calls to OCS endpoints require the OCS-APIRequest header to be set to true
####################################################
# https://doc.owncloud.org/server/10.0/developer_manual/core/ocs-share-api.html
# /shares
# /shares?path=/<path-file>&reshares=true
# /shares/<share_id>
# 








################################################################
#### WEBDAV OPERATIONS


# Lists the contents of a cloud instance folder
# LIST remote.php/dav/files/user/path/to/fileOrfolder
listCloud() {
        local tgt=""
        if ! isEmpty "$1"; then
                #tgt="$1"
                tgt="$(escapeWhitespaces "$1")"
        fi
        local xml="$("$CURLBIN" -s -u $C_USERNAME:$C_PASS -X PROPFIND "$C_FDAV_URL/$C_USERNAME/$tgt")"
        #"$CURLBIN" -s -u $C_USERNAME:$C_PASS -X PROPFIND "$C_FDAV_URL/$C_USERNAME/$tgt"
        #printf "%s\n" "$xml"
        listFromXml "$xml"
        return $?
}


# Sends a file into a cloud instance tree
# curl -u user:pass -T error.log "https://example.com/nextcloud/remote.php/dav/files/USERNAME/$(date '+%d-%b-%Y')/error.log"
sendFile() {
        local __target="$2"
        if ! isFile "$1"; then
                logErr "$M_ERRORSENDFILE $M_FILEORIGINNOTFOUND"
                logErr "$M_FILE: $1"
                logErr "$M_TRYHELP"
                return $FALSE
        fi
        if isEmpty "$2"; then        # Send to root with source name
                __target="$(basename "$1")"
        elif endsWithDash "$2"; then # Appends source name to target folder
                __target="$2$(basename "$1")"
        fi
        #echo "source: $1"$'\n'"target: $__target"
        log "$M_SOURCE: $1"$'\n'"$M_DESTINATION: $__target"
        "$CURLBIN" -s -u $C_USERNAME:$C_PASS -T "$1" "$C_FDAV_URL/$C_USERNAME/$(escapeWhitespaces "$__target")"
}


# Creates a folder into a cloud instance tree
# curl -u user:pass -X MKCOL "https://example.com/nextcloud/remote.php/dav/files/USERNAME/$(date '+%d-%b-%Y')"
createFolder() {
        if isEmpty "$1"; then
                logErr "$M_ERRORCREATEFOLDER $M_FOLDEREMPTY"
                logErr "$M_TRYHELP"
                return $FALSE
        fi
        #echo "$CURLBIN" -s -u $C_USERNAME:$C_PASS -X MKCOL "$C_FDAV_URL/$C_USERNAME/$1"
        log "$M_CREATINGFOLDER: $1"
        "$CURLBIN" -s -u $C_USERNAME:$C_PASS -X MKCOL "$C_FDAV_URL/$C_USERNAME/$(escapeWhitespaces "$1")"
        return $?
}


# Deletes a folder or file from a cloud instance (may send to trash)
# DELETE remote.php/dav/files/user/path/to/file
deleteFileFolder() {
        if isEmpty "$1"; then
                logErr "$M_ERRORERASE"$'\n'"$M_ITEMEMPTY"
                logErr "$M_TRYHELP"
                return $FALSE
        fi
        log "$M_REMOVING: $1"
        "$CURLBIN" -s -u $C_USERNAME:$C_PASS -X DELETE "$C_FDAV_URL/$C_USERNAME/$(escapeWhitespaces "$1")"
        return $?
}


# Moves a folder or file from-to a cloud instance
# MOVE remote.php/dav/files/user/path/to/file
# Destination: https://cloud.example/remote.php/dav/files/user/new/location
# curl -u user:pass -X MOVE --header 'Destination: https://example.com/nextcloud/remote.php/dav/files/USERNAME/target.jpg' https://example.com/nextcloud/remote.php/dav/files/USERNAME/source.jpg
moveFileFolder() {
        local __target="$2"
        if isEmpty "$1" || isEmpty "$2"; then
                logErr "$M_ERRORMOVE"$'\n'"$M_ITEMEMPTY"
                logErr "$M_SOURCE: $1"
                logErr "$M_DESTINATION: $2"
                logErr "$M_TRYHELP"
                return $FALSE
        fi
        if endsWithDash "$2"; then # Appends source name to target folder
                __target="$2$(basename "$1")"
        fi
        #echo "source: $1"$'\n'"target: $__target"
        log "$M_SOURCE: $1"$'\n'"$M_DESTINATION: $__target"
        "$CURLBIN" -s -u $C_USERNAME:$C_PASS -X MOVE --header "Destination: $C_FDAV_URL/$C_USERNAME/$(escapeWhitespaces "$__target")" "$C_FDAV_URL/$C_USERNAME/$(escapeWhitespaces "$1")"
        return $?
}


# Copies a folder or file from-to a cloud instance
# COPY remote.php/dav/files/user/path/to/file
# Destination: https://cloud.example/remote.php/dav/files/user/new/location
copyFileFolder() {
        local __target="$2"
        if isEmpty "$1" || isEmpty "$2"; then
                logErr "$M_ERRORCOPY"$'\n'"$M_ITEMEMPTY"
                logErr "$M_SOURCE: $1"
                logErr "$M_DESTINATION: $2"
                logErr "$M_TRYHELP"
                return $FALSE
        fi
        if endsWithDash "$2"; then # Appends source name to target folder
                __target="$2$(basename "$1")"
        fi
        #echo "source: $1"$'\n'"target: $__target"
        log "$M_SOURCE: $1"$'\n'"$M_DESTINATION: $__target"
        "$CURLBIN" -s -u $C_USERNAME:$C_PASS -X COPY --header "Destination: $C_FDAV_URL/$C_USERNAME/$(escapeWhitespaces "$__target")" "$C_FDAV_URL/$C_USERNAME/$(escapeWhitespaces "$1")"
        return $?
}


# Checks file for error and prints error messages
fileHasError() {
        # echo "$1 -- $2"
        if ! isFile "$1"; then
                logErr "$M_ERRORFILENOTFOUND"
                logErr " > $1"
                logErr "$M_TRYHELP"
                return $FALSE
        fi
        "$STRBIN" "$1" | grep -m 1 '<?xml version="1.0" encoding="utf-8"?>
<d:error xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns">' >/dev/null || return $FALSE
        "$STRBIN" "$1" | grep -m 1 "$2" >/dev/null || return $FALSE
        return $TRUE
}


# Downloads a file
# GET remote.php/dav/files/user/path/to/file
getFile() {
        local __target="$2"
        if isEmpty "$2"; then
                __target="$(basename "$1")"
        elif endsWithDash "$2"; then # Appends source name to target folder
                __target="$2$(basename "$1")"
        fi
        if isEmpty "$1" || isEmpty "$__target"; then
                logErr "$M_ERRORGETFILE!"$'\n'"$M_ITEMEMPTY"$'\n'"$M_CLOUDFILE: $1"$'\n'"$M_LOCALFILE: $__target"
                return $FALSE
        fi
        log "$M_CLOUDFILE: $1"$'\n'"$M_LOCALFILE: $__target"
        #"$CURLBIN" --silent -u $C_USERNAME:$C_PASS -X GET "$C_FDAV_URL/$C_USERNAME/$1" --output "$__target" 2>>log.txt
        "$CURLBIN" --silent -u $C_USERNAME:$C_PASS "$C_FDAV_URL/$C_USERNAME/$(escapeWhitespaces "$1")" --output "$__target"
        local ret=$?
        #echo "ret: $ret"
        if [[ $ret -ne 0 ]]; then
                isFile "$__target" || return $ret
                logErr "$M_ERRORGETFILE: $__target"
                >&2 cat "$__target"
                rm "$__target"
        fi
        if fileHasError "$__target" "$1"; then
                logErr "$M_ERRORDOWNLOAD"
                >&2 cat "$__target" 2>/dev/null
                rm "$__target"
                return 36
        fi
        return $ret
}







################################################################
#### OCS SHARE API OPERATIONS


# curl -u "myuser:mypassword" -H "OCS-APIRequest: true" \
# -X POST https://nextcloud/ocs/v1.php/apps/files_sharing/api/v1/shares \
# -d path="globalshare/0002/pic.jpg" -d shareType=3 -d permissions=1 -d expireDate="2017-07-20"


# List shares for a folder (defaults to root folder)
listShares() {
        local tgt=""
        if ! isEmpty "$1"; then
                tgt="$(rawUrlEncode "$1")"
                #tgt='?path='"$tgt"'&reshares=true&shared_with_me=1'
                tgt='?path='"$tgt"'&reshares=true'
        fi
        #echo "tgt: $tgt"
        local xml="$("$CURLBIN" -s -u $C_USERNAME:$C_PASS -H "OCS-APIRequest: true" -X GET "$C_OCS_URL/shares$tgt")"
        printSharesTable "$xml"
        return $?
}


# Prints shares as a formatted table
printSharesTable() {
        isEmpty "$1" && return $FALSE
        local ITEMS=()
        local ID="-"
        local SHARE_TYPE="-"
        local SHARE_OWNER="-"
        local FILE_OWNER="-"
        local EXPIRATION="-"
        local PATH="-"
        local SHARE_WITH="-"
        local TOKEN="-"
        local DIVTEMPLATE="+-------+------+------------+------------+------------+------------------+------------------------------------+----------------------------------------------------------------------+\n"
        local PFTEMPLATE='| %-5.5s | %-4.4s | %-10.10s | %-10.10s | %-10.10s | %-16.16s | %-34.34s | %-68.68s |\n'
        local expGet=()
        while read_dom; do
                # 0  | 1          | 2           | 3          | 4          | 5     | 6          | 7
                # ID | SHARE_TYPE | SHARE_OWNER | FILE_OWNER | EXPIRATION | TOKEN | SHARE_WITH | PATH
                if [[ "$ENTITY" = "id" ]]; then
                        IDS+=("${CONTENT}")
                        ID="$CONTENT"
                elif [[ "$ENTITY" = "share_type" ]]; then
                        SHARE_TYPE="$CONTENT"
                elif [[ "$ENTITY" = "uid_owner" ]]; then
                        SHARE_OWNER="$CONTENT"
                elif [[ "$ENTITY" = "uid_file_owner" ]]; then
                        FILE_OWNER="$CONTENT"
                elif [[ "$ENTITY" = "expiration" ]]; then
                        expGet=($CONTENT)
                        EXPIRATION="${expGet[0]}"
                elif [[ "$ENTITY" = "path" ]]; then
                        PATH="${CONTENT// /%20}"
                elif [[ "$ENTITY" = "share_with" ]]; then
                        SHARE_WITH="$CONTENT"
                elif [[ "$ENTITY" = "token" ]]; then
                        TOKEN="$CONTENT"
                elif [[ "$ENTITY" = "/element" ]]; then
                        if [[ "$ID" = "-" ]]; then
                                SHARE_TYPE="-" ; SHARE_OWNER="-" ; FILE_OWNER="-" ; EXPIRATION="-" ; PATH="-" ; SHARE_WITH="-" ; TOKEN="-"
                                continue
                        fi
                        #ITEMS+=("$ID $SHARE_TYPE $SHARE_OWNER $FILE_OWNER $EXPIRATION $SHARE_WITH $TOKEN $PATH")
                        ITEMS+=("$ID $SHARE_TYPE $SHARE_OWNER $FILE_OWNER $EXPIRATION $TOKEN $SHARE_WITH $PATH")
                        ID="-" ; SHARE_TYPE="-" ; SHARE_OWNER="-" ; FILE_OWNER="-" ; EXPIRATION="-" ; PATH="-" ; SHARE_WITH="-" ; TOKEN="-"
                fi
        done < <(printf '%s\n' "$1")

        printf "$DIVTEMPLATE"
        printf "$PFTEMPLATE" "ID" "TYPE" "SHOWNER" "FOWNER" "EXPIRATION" "TOKEN" "SHARED_TO" "PATH"
        printf "$DIVTEMPLATE"
        for i in "${ITEMS[@]}"; do
                i=($i)
                passDetect='1|$'
                shareTo="${i[6]}"
                if [[ $shareTo = "$passDetect"* ]]; then
                        shareTo="Shared With Password"
                fi
                printf "$PFTEMPLATE" "${i[0]}" "${i[1]}" "${i[2]}" "${i[3]}" "${i[4]}" "${i[5]}" "${shareTo}" "${i[7]//%20/ }"
        done
        printf "$DIVTEMPLATE"
}


# Prints the formatted links list
# <URL>,<PATH>
listLinks() {
        local xml="$("$CURLBIN" -s -u $C_USERNAME:$C_PASS -H "OCS-APIRequest: true" -X GET "$C_OCS_URL/shares")"
        printLinks "$xml"
        return $?
}


# Parses the list link to be printed
printLinks() {
        isEmpty "$1" && return $FALSE
        local ITEMS=()
        local PATH="-"
        local TOKEN="-"
        while read_dom; do
                # PATH,TOKEN
                if [[ "$ENTITY" = "path" ]]; then
                        PATH="${CONTENT// /%20}"
                elif [[ "$ENTITY" = "token" ]]; then
                        TOKEN="$CONTENT"
                elif [[ "$ENTITY" = "/element" ]]; then
                        if [[ "$PATH" = "-" ]] || [[ "$TOKEN" = "-" ]]; then
                                PATH="-" ; TOKEN="-"
                                continue
                        fi
                        #ITEMS+=("$ID $SHARE_TYPE $SHARE_OWNER $FILE_OWNER $EXPIRATION $SHARE_WITH $TOKEN $PATH")
                        ITEMS+=("$C_BASE_URL/s/$TOKEN,$PATH")
                        PATH="-" ; TOKEN="-"
                fi
        done < <(printf '%s\n' "$1")

        for i in "${ITEMS[@]}"; do
                printf "%s\n" "${i//%20/ }"
        done
}







################################################################
#### PRINTING TO SCREEN


isVerbose() {
        return $VERBOSE
}


# Prints message to stdout
log() {
        if isVerbose; then
                printf "%s\n" "$@"
        fi
}


# Prints message to stderrout
logErr() {
        >&2 printf "%s\n" "$@"
}


# Prints program name and version to screen
printBanner() {
        [[ "$1" == 'nopadding' ]] || echo
        echo "Tavinus Cloud Manager v$C_VERSION"
}


# Prints help info to screen
printHelp() {
        printBanner
        printf "%s" "$M_HELPINFO"
}







################################################################
#### ACCOUNT HANDLING


# Loads and validates a user from cloudmanager.accounts
loadUser() {
        j=0
        for i in "${C_ACC_USERS[@]}"; do
                if [ "$i" == "$1" ] ; then
                        C_USER="${C_ACC_USERS[$j]}:${C_ACC_PASSWORDS[$j]}"
                        C_USERNAME="${C_ACC_USERS[$j]}"
                        C_PASS="${C_ACC_PASSWORDS[$j]}"
                        # Uncomment to debug
                        # echo "CUSER      > $C_USER" ; echo "C_USERNAME > $C_USERNAME" ; echo "C_PASS     > $C_PASS"
                        return $TRUE
                fi
                ((j+=1))
        done
        
        logErr "$M_ERRORUSERNOTFOUND $1"$'\n'"$M_CHECKUSER"
        logErr "$M_TRYHELP"
        exit 34
        return 34
}







################################################################
#### COMMANDS PARSING AND EXECUTION


### Parse CLI options and execute each command
checkRunResets() {
        while :; do
                case "$1" in
                        --resetServerConfig)
                                resetServerConfig ; exit $? ;;
                        --resetAccountConfig|--resetAccountsConfig)
                                resetAccountsConfig ; exit $? ;;
                        --resetAll)
                                resetAll ; exit $? ;;
                        *)
                                isEmpty "$1" && break || shift ;;
                esac
        done
}


### Parse CLI options and execute each command
runCloudManager() {
        while :; do
                case "$1" in
                        -V|--version|--Version)
                                printBanner 'nopadding' ; exit 0 ;;
                        -v|--verbose)
                                VERBOSE=$TRUE ; shift ;;
                        -h|--help|--Help)
                                printHelp ; exit 0 ;;
                        -u|--user)
                                loadUser "$2" ; shift ; shift ;;
                        -l|--language)
                                shift ; shift ;;
                        --resetServerConfig)
                                exit 12 ;;
                        --resetAccountConfig|--resetAccountsConfig)
                                exit 12 ;;
                        --resetAll)
                                exit 12 ;;
                        mkdir|makeFolder|createFolder|makeDir)
                                checkCloud
                                createFolder "$2"
                                exit $? ;;
                        send|sendFile|upload|uploadFile)
                                checkCloud
                                sendFile "$2" "$3"
                                exit $? ;;
                        mv|move|moveFileFolder)
                                checkCloud
                                moveFileFolder "$2" "$3"
                                exit $? ;;
                        cp|copy|copyFileFolder)
                                checkCloud
                                copyFileFolder "$2" "$3"
                                exit $? ;;
                        del|delete|deleteFileFolder|rm|remove)
                                checkCloud
                                deleteFileFolder "$2" "$3"
                                exit $? ;;
                        get|getFile|download|downloadFile)
                                checkCloud
                                getFile "$2" "$3"
                                exit $? ;;
                        ls|list|dir)
                                checkCloud
                                listCloud "$2"
                                exit $? ;;
                        lsShares|listShares|lsshares|listshares|shares)
                                checkCloud
                                listShares "$2"
                                exit $? ;;
                        sharedLinks|links|sharedlinks|urls)
                                checkCloud
                                listLinks "$2"
                                exit $? ;;
                        *)
                                checkOpts "$1" ; break ;;
                esac
        done
        exit 12
}


# Finalizes the GetOpt execution and deals with errors
checkOpts() {
        printBanner 'nopadding'
        if isEmpty "$1"; then
                logErr "$M_NOCOMMANDSELECTED"
                logErr "$M_TRYHELP"
        else
                logErr "$M_INVALIDOPTION: $1"
                logErr "$M_TRYHELP"
        fi
        exit 10
}







##############################################################################
## REALPATH IMPLEMENTATION
## https://github.com/mkropat/sh-realpath/blob/master/realpath.sh

realpath() {
    canonicalize_path "$(resolve_symlinks "$1")"
}

resolve_symlinks() {
    _resolve_symlinks "$1"
}

_resolve_symlinks() {
    _assert_no_path_cycles "$@" || return

    local dir_context path
    path=$(readlink -- "$1")
    if [ $? -eq 0 ]; then
        dir_context=$(dirname -- "$1")
        _resolve_symlinks "$(_prepend_dir_context_if_necessary "$dir_context" "$path")" "$@"
    else
        printf '%s\n' "$1"
    fi
}

_prepend_dir_context_if_necessary() {
    if [ "$1" = . ]; then
        printf '%s\n' "$2"
    else
        _prepend_path_if_relative "$1" "$2"
    fi
}

_prepend_path_if_relative() {
    case "$2" in
        /* ) printf '%s\n' "$2" ;;
         * ) printf '%s\n' "$1/$2" ;;
    esac
}

_assert_no_path_cycles() {
    local target path

    target=$1
    shift

    for path in "$@"; do
        if [ "$path" = "$target" ]; then
            return 1
        fi
    done
}

canonicalize_path() {
    if [ -d "$1" ]; then
        _canonicalize_dir_path "$1"
    else
        _canonicalize_file_path "$1"
    fi
}

_canonicalize_dir_path() {
    (cd "$1" 2>/dev/null && pwd -P)
}

_canonicalize_file_path() {
    local dir file
    dir=$(dirname -- "$1")
    file=$(basename -- "$1")
    (cd "$dir" 2>/dev/null && printf '%s/%s\n' "$(pwd -P)" "$file")
}







##############################################################################
##############################################################################







##############################################################################
## EXECUTION


### Bootstrap localized messages
initLanguage "${@}"

### Populate initial environment vars
initVars

### Perform reset operations if needed
checkRunResets "${@}"

### INITIAL ENVIRONMENT SETUP
initCloudManager

### PARSE AND RUN
runCloudManager "${@}"
exit $?

