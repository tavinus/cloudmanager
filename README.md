# cloudmanager
Nextcloud / Owncloud CLI Webdav Client  
  
Uses `curl` to access the Nextcloud webdav service.  
## Features  
Tries to be feature-complete with the Nextcloud Webdav's capabilities.  
### Webservice Tasks
 - [x] list file/folder
 - [x] create folder
 - [x] send file
 - [ ] send folder (not avail on Webdav)
 - [x] get file
 - [ ] get folder (not avail on Webdav)
 - [x] delete file/folder
 - [x] move file/folder
 - [x] copy file/folder
 - [x] list shares
 - [x] list links
### Internal App Goals
 - [x] target folder detection redirection  
will use source file name when target ends with  /
 - [x] external config files
 - [x] reset config files
 - [x] multiple users
 - [x] multi-language support
 - [x] auto-detect / auto-load system language
 - [x] force language from param
 - [x] run from symlinks (find config files)
 - [ ] load specific config files from params
## Configuration
There are two configuration files that need to be edited
#### `cloudmanager.server`
Defines the target server domain, protocol and port
```
# Edit the shell variables below
CLOUDSERVERDOMAIN='cloud.domain.tld'
CLOUDSERVERPROTOCOL='https://'
CLOUDSERVERPORT=443
```
#### `cloudmanager.accounts`
Defines the usernames/password to be used  
*The first user is used as default*
```
---- Add accounts one per line, as in USERNAME:PASSWORD
---- You can use an "App Password" to access your account (instead of your regular password)
---- Settings > Personal > Security > Enter App Name > Create new app password
---- The first user is the default user, the rest can be used with -u <usernamme>
---- Lines starting with four dashes will be ignored
myUsername:myPassword
```
## Localization
CloudManager supports localization and automatic language detection.  
You can also force a language with `-l <language_code>`.  
  
#### Currently supported languages
 - en_US
 - pt_BR
## Help
You can use the parameters `-h` or `--help` to get the help information.
```
$ ./cloudmanager -l en --help

Tavinus Cloud Manager v0.1.5

CONFIG
 - cloudmanager.server    Edit this file to configure host domain, protocol and port
 - cloudmanager.accounts  Edit this file to add nextcloud accounts
                          The first user of the list is the default user
                          You may use an "app" token instead of the user password (safer)

 Both config files MUST be populated before you try to use Cloud Manager

OPTIONS

 -V, --version             Prints version to screen and finishes execution
 -h, --help                Prints this help to screen and finishes execution
     --resetServerConfig   Resets server config file to default
     --resetAccountsConfig Resets accounts config file to default
     --resetAll            Resets all config files
 -u, --user <username>     Loads the user <username> from the cloudmanager.accounts file
 -l, --language <lang>     Force the language <lang>
                           Languages currently supported:
                           en_US pt_BR

COMMANDS

> ls,list [target]
    Lists a folder or file (lists root folder if empty)
    Ex:  list

> mkdir,makeFolder <foldername>
    Creates a folder at the cloud
    Ex:  mkdir MyTestFolder

> send,upload <localfolder/localfile> <cloudfolder/cloudfile>
    Sends a local file to the cloud instance
    Ex:  send '/home/user/MyFile.xml' 'CloudFolder/MyFile.xml'

> mv,move <source> <target>
    Moves a folder or file inside the cloud instance
    Ex:  move 'OneFolder/MyFile.txt' 'AnotherFolder/MyFile.txt'

> cp,copy <source> <target>
    Copies a folder or file inside the cloud instance
    Ex:  copy 'OneFolder/MyFile.txt' 'AnotherFolder/MyFile.txt'

> del,delete <target>
    Erases a folder or file inside the cloud instance (may move to Trashbin)
    Ex:  del 'MyFolder/MyFile.txt'

> get,download <source> <target>
    Downloads a file from the cloud to a local folder
    Target defaults to current folder with remote name if blank
    Ex:  get 'RemoteFolder/RemoteFile.txt' '/home/user/MyFile.txt'

> shares,listShares
    Prints table with shares (183 cols)
    Specify a folder or leave blank to list all
    Ex:  shares

> links,sharedLinks
    List shares by links using the format <URL>,<FILE NAME>
    Ex:  listShares

```
