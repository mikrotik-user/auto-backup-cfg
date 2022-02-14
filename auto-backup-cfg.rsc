# RouterOS 6.49.2
# This script makes configuration backup in text mode and transfers to FTP server
# The script is part of https://github.com/mikrotik-user/auto-backup-cfg

/system scheduler
add interval=1w1d name=export_cfg on-event=":local userName \"USERNAME\"\r\
    \n:local userPassword \"PASSWORD\"\r\
    \n:local ftpAddress \"10.20.10.1\"\r\
    \n:local curDate [/system clock get date]\r\
    \n:local curTime [/system clock get time]\r\
    \n:local systemName [/system identity get name]\r\
    \n:local curMonth [:pick \$curDate 0 3]\r\
    \n:set curMonth ( [ :find key=\"\$curMonth\" in=\"jan,feb,mar,apr,may,jun,\
    jul,aug,sep,oct,nov,dec\" from=-1 ] / 4 + 1)\r\
    \nif ( \$curMonth < 10 ) do={ :set curMonth ( \"0\".\$curMonth ) } else={ \
    :set curMonth \$curMonth }\r\
    \n:local curDay [:pick \$curDate 4 6]\r\
    \n:local curYear [:pick \$curDate 7 13]\r\
    \n:local curHour [:pick \$curTime 0 2]\r\
    \n:local curMin [:pick \$curTime 3 5]\r\
    \n:local cfgName ( \"\$systemName\".\"-\".\"\$curYear\".\"\$curMonth\".\"\
    \$curDay\" .\"-\".\"\$curHour\".\"\$curMin\" )\r\
    \n:do { /export comp file=\$cfgName } on-error={ :error \"Cannot export cf\
    g file\" }\r\
    \n:do { \r\
    \n      /tool fetch address=\$ftpAddress src-path=(\"\$cfgName\".\".rsc\")\
    \_\\\r\
    \n      user=\$userName mode=ftp \\\r\
    \n      password=\$userPassword dst-path=(\"./cfg/\".\"\$cfgName\".\".rsc\
    \") upload=yes \r\
    \n    } on-error={ :error \"Cannon upload file to FTP\" }\r\
    \n:do { /file remove [find name=(\"\$cfgName\".\".rsc\")] } on-error={ }" \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=jan/01/1970 start-time=00:00:00
