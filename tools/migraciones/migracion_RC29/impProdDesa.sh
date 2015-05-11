sqlplus system/desa.2008 @DropUsers.sql
sqlplus system/desa.2008 @CreateUsers.sql

impdp system/desa.2008 dumpfile=pfsmaster.dmp schemas=pfsmaster
impdp system/desa.2008 dumpfile=pfs01.dmp schemas=pfs01
impdp system/desa.2008 dumpfile=pfs02.dmp schemas=pfs02
impdp system/desa.2008 dumpfile=pfs03.dmp schemas=pfs03

sqlplus pfsmaster/admin @Prod2Desa.sql

