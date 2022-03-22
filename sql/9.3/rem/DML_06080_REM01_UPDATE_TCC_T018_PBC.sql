--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20220222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16987
--## PRODUCTO=NO
--##
--## Finalidad: Borra una restricción para el /avanzaoferta
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
    V_ID2 NUMBER(16);
    V_USR VARCHAR2(100 CHAR):= 'HREOS-16987';
    V_TAREA VARCHAR2(100 CHAR):= 'T018_PbcAlquiler';
    V_TFI VARCHAR2(100 CHAR):= 'fechaResolucion';
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');


	
        V_SQL := 'SELECT count(*) FROM '|| V_ESQUEMA ||'.tap_tarea_procedimiento where tap_codigo like '''||V_TAREA||''' ';
        DBMS_OUTPUT.PUT_LINE(V_SQL);  
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				         
   
           V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.tcc_tarea_config_campos ' ||
                      'where tap_id = (SELECT tap_id FROM '|| V_ESQUEMA ||'.tap_tarea_procedimiento where tap_codigo like '''||V_TAREA ||''') 
						and tfi_id =
						    (SELECT tfi_id FROM '|| V_ESQUEMA ||'.tfi_tareas_form_items 
						    where tap_id = 
						        (SELECT tap_id FROM '|| V_ESQUEMA ||'.tap_tarea_procedimiento where tap_codigo like '''||V_TAREA||''') 
						    and tfi_nombre like '''||V_TFI||''') ';
          
           DBMS_OUTPUT.PUT_LINE(V_MSQL);          
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO BORRADO CORRECTAMENTE');
        
        
       END IF;

    COMMIT;


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

EXIT