--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201231
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8624
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
   V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
   V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
   PL_OUTPUT VARCHAR2(20000 CHAR);
   V_SQL VARCHAR(20000 CHAR);
   V_USUARIO VARCHAR(25 CHAR) := 'REMVIP-8624';
   V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
 
BEGIN
   DBMS_OUTPUT.put_line('[INICIO]');

   DBMS_OUTPUT.PUT_LINE('[INFO]: REALIZANDO REPOSICIONAMIENTO DE TAREA' );

   V_SQL :='SELECT COUNT(1) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = ''224877''';
   EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

   IF V_NUM_TABLAS = 1 THEN

      REM01.AVANCE_TRAMITE (
            V_USUARIO,
            '224877',
            'T013_PosicionamientoYFirma',
            NULL, NULL, PL_OUTPUT);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

      DBMS_OUTPUT.PUT_LINE('[INFO]: REPOSICIONAMIENTO REALIZADO CON ÉXITO' );
   
   ELSE

      DBMS_OUTPUT.PUT_LINE('[INFO]: EL EXPEDIENTE NO EXISTE' );
        
   END IF;

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
