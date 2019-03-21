--/* 
--##########################################
--## AUTOR=Sonia Garcia Mochales
--## FECHA_CREACION=20190110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=func-rem-alquileres
--## INCIDENCIA_LINK=HREOS-5066
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en la tabla ENVIO_MAIL_CONTRATO_ALQUILER.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de un registro.
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    
BEGIN   
        
     DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ENVIO_MAIL_CONTRATO_ALQUILER'' and owner = '''||V_ESQUEMA||'''';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	
	IF V_NUM_TABLAS = 1 THEN
	
V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ENVIO_MAIL_CONTRATO_ALQUILER (
					DE, 
					A,  
					CUERPO, 
					ASUNTO
					) 
		values ( 
				 ''noreply.rem@haya.es'',
				 '''',
				 ''Durante la obtención de la información del contrato de alquiler del activo {idHaya} se ha encontrado la siguiente información duplicada que mostramos a continuación para que se realice la gestión adecuada por su parte.{Registros duplicados}'',
				 ''Registros duplicados en contrato de alquiler''		 
				)';


		DBMS_OUTPUT.PUT_LINE(V_SQL);
    	EXECUTE IMMEDIATE V_SQL ; 
 	DBMS_OUTPUT.PUT_LINE('[INFO]: MAIL ENVIADO');
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
