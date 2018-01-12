lftp -c "open -u ftpsocpart,tempo.99 -p 2153 sftp://192.168.235.59; ls /datos/usuarios/socpart/CISA/out"
lftp -c "open -u ftpsocpart,tempo.99 -p 2153 sftp://192.168.235.59; ls /datos/usuarios/socpart/CISA/in"

lftp -u ftpsocpart,tempo.99 -p 2153 sftp://192.168.235.59 <<EOF

cd /datos/usuarios/socpart/CISA/in/
mput $DIR_SALIDA/$2.*

cd /datos/usuarios/socpart/CISA/out/
mput $DIR_SALIDA/$2.*

bye
EOF
