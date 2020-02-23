--/*
--##########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9578
--## PRODUCTO=NO
--##
--## Finalidad: Modificar la etiqueta de la tabla TFI_TAREAS_FORM_ITEMS del procedimiento T017
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
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'TFI_TAREAS_FORM_ITEMS';  -- Tabla a modificar
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-9578'; -- USUARIOCREAR/USUARIOMODIFICAR

    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
                                        
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
                       --TAP_CODIGO 				 --TFI_LABEL_VIEJO 		                --TFI_NOMBRE 	      --TFI_LABEL_NUEVO	  
                T_TFI('T017_RespuestaOfertanteCES'   ,'Respuesta ofertante CESS'            ,'comboRespuesta'     ,'Respuesta ofertante Comité'),
                T_TFI('T017_RespuestaOfertanteCES'   ,'Fecha de respuesta ofertante CESS'   ,'fechaRespuesta'     ,'Fecha de respuesta ofertante Comité'),
                T_TFI('T017_RatificacionComiteCES'   ,'Importe Contraoferta CESS'           ,'numImporteContra'   ,'Importe Contraoferta Comité')
    );
    V_TMP_T_TFI T_TFI;
        
BEGIN	

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  -- Si existe la tabla modificamos los datos
  IF V_NUM_TABLAS = 1 THEN

    --LOOP para insertar los valores en TFI_TAREAS_FORM_ITEMS
    FOR I IN V_TFI.FIRST .. V_TFI.LAST
		LOOP
	
			V_TMP_T_TFI := V_TFI(I);
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
	        TFI_LABEL = '''||V_TMP_T_TFI(4)||''' 
	        ,USUARIOMODIFICAR = '''||V_USUARIO||'''
            , FECHAMODIFICAR = SYSDATE 
	        WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
                            WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') 
	        AND TFI_NOMBRE = '''||V_TMP_T_TFI(3)||''' ';
	    EXECUTE IMMEDIATE V_MSQL;
	    DBMS_OUTPUT.PUT_LINE('[INFO] En tarea '||V_TMP_T_TFI(1)||' se ha actualizado el campo '||V_TMP_T_TFI(2)||'.');
	
		END LOOP;

		DBMS_OUTPUT.PUT_LINE('[FIN] Tabla'||V_TEXT_TABLA|| 'actualizada correctamente');	    
		COMMIT; 
       
  END IF;
  
EXCEPTION
    WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT