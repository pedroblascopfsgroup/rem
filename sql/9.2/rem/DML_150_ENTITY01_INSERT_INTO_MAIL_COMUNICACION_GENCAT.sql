--/* 
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20190409
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6184
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en la tabla MAIL_COMUNICACION_GENCAT.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
  --  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de un registro.
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    
BEGIN   
        
     DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MAIL_COMUNICACION_GENCAT'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	

	IF V_NUM_TABLAS = 1 THEN

	 V_SQL:= 'DELETE FROM '||V_ESQUEMA||'.MAIL_COMUNICACION_GENCAT WHERE DE IN ( ''GENCAT_Proceso_Comunicacion'', ''GENCAT_Proceso_Reclamacion'' )';
	  EXECUTE IMMEDIATE V_SQL;
	  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || 'registros borrados');

	
V_SQL := 'INSERT INTO '||V_ESQUEMA||'.MAIL_COMUNICACION_GENCAT	(
					DE, 
					A, 
					COPIA, 
					CUERPO, 
					ASUNTO,
					ADJUNTO
					) 
		values ( 
				 ''noreply.rem@haya.es'',
				 ''jpoyatos@haya.es;backup.rem@pfsgroup.es;GFORMADM'',
				 '''',
				 ''Los activos del Excel adjunto están bloqueados en REM a DDMMYYYY'',
				 ''Comunicación activos con ofertas afectas por GENCAT, DDMMYYYY'',
				''ExcelComunicacion.xls''
				 
				)';

    	EXECUTE IMMEDIATE V_SQL ; 
 	DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' registro/s insertado/s.');
	END IF;               

  COMMIT;
           
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;


/

EXIT
