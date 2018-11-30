:local backupfile ([/system identity get name] . "-" . [/system clock get time])
:local sendto "mail@example.com"
:local sendfrom "mail@example.com"
:local subject "Mikrotik Backup"
:local password "SuperMegaUserPass"
:local port "587"
:local server "smtp.example.com"
:local starttls "yes"
:local user "mail@example.com"
/log info "Backup started, File $backupfile"
/system backup save name=$backupfile 
:delay 5s
/export terse file=$backupfile
:delay 5s
/tool e-mail send from=$sendfrom to=$sendto subject=$subject body=[/system clock get date] file="$backupfile.backup, $backupfile.rsc" password=$password port=$port server=$server start-tls=$starttls user=$user
:delay 30s
/file remove "$backupfile.backup"
/file remove "$backupfile.rsc"