--/*
--##########################################
--## AUTOR=Sergio Salt
--## FECHA_CREACION=20190103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en POP_PLANTILLAS_OPERACION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN POP_PLANTILLAS_OPERACION] ');
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.POP_PLANTILLAS_OPERACION WHERE POP_NOMBRE = ''ALTA_ACTIVOS_THIRD_PARTY''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.POP_PLANTILLAS_OPERACION...no se modifica nada.');
				
			ELSE
                V_MSQL := 'SELECT DD_OPM_ID FROM '||V_ESQUEMA||'.DD_OPM_OPERACION_MASIVA WHERE DD_OPM_CODIGO = ''AATP''';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID;
                
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.POP_PLANTILLAS_OPERACION (POP_ID, POP_NOMBRE, POP_DIRECTORIO, DD_OPM_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
				VALUES (
				('||V_ESQUEMA||'.S_POP_PLANTILLAS_OPERACION.NEXTVAL),
				''ALTA_ACTIVOS_THIRD_PARTY'',
				''plantillas/plugin/masivo/plantillaTP.xls'',
				'||V_ID||',
				0,
				''HREOS-3888'',
				SYSDATE,
				0
				)';
		    	
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.POP_PLANTILLAS_OPERACION insertados correctamente.');
				
		    END IF;	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: POP_PLANTILLAS_OPERACION ACTUALIZADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/
EXIT;




