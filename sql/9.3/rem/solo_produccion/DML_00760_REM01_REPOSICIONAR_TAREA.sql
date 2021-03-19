--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210315
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9212
--## PRODUCTO=NO
--## 
--## Finalidad: Reposicionar tarea
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
   V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
   PL_OUTPUT VARCHAR2(20000 CHAR);
   V_SQL VARCHAR(20000 CHAR);
   V_USUARIO VARCHAR(25 CHAR) := 'REMVIP-9212';
 
BEGIN
   DBMS_OUTPUT.put_line('[INICIO]');

   REM01.AVANCE_TRAMITE (
       V_USUARIO,
       '248638',
       'T013_InstruccionesReserva',
       '248638', '11', PL_OUTPUT);
   DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
               
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
   WHEN OTHERS THEN
        ERR_NUM := SQLCODE;
        ERR_MSG := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(ERR_MSG);
        ROLLBACK;
        RAISE;  
END;
/
EXIT;
