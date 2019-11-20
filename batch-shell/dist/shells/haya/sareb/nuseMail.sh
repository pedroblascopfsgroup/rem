/usr/lib64/nagios/plugins/sendEmail -f "BA01@pfsgroup.es" -s "172.22.1.114" -u "Fichero NUSE Recibido." -m "El job convivencia_cdd_resultado_nuse[HAYA] ha finalizado, revisa la ejecucion de sus procesos." -t "operaciones@pfsgroup.es"
echo "Correo enviado a operaciones@pfsgroup.es" 
