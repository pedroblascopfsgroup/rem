--/*
--########################################################
--## AUTOR=VICTOR OLIVARES
--## FECHA_CREACION=20190226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v2.5.0-rem
--## INCIDENCIA_LINK=HREOS-5654
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en MGD_MAPEO_GESTOR_DOC
--## 		registros con parámetro CLIENTE_GD = Promontoria Agora
--##		si no existían previamente, de la cartera Cerberus
--##		subcartera Agora. Si ya existían, los actualiza.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--#######################################################
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
    
    ARRAY_SUBCARTERAS dbms_sql.number_table;
    
BEGIN	
	
  ARRAY_SUBCARTERAS(1) := '135';
  ARRAY_SUBCARTERAS(2) := '137';

  FOR I IN ARRAY_SUBCARTERAS.FIRST .. ARRAY_SUBCARTERAS.LAST
  LOOP
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
   	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN MGD_MAPEO_GESTOR_DOC');
 

	--Comprobamos el dato a insertar MGD_MAPEO_GESTOR_DOC
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MGD_MAPEO_GESTOR_DOC WHERE DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||ARRAY_SUBCARTERAS(I)||''') AND DD_CRA_ID =  (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				         
  		  DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '); 
  			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.MGD_MAPEO_GESTOR_DOC SET CLIENTE_GD = ''Promontoria Agora'' WHERE DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||ARRAY_SUBCARTERAS(I)||''') AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'')';

        DBMS_OUTPUT.PUT_LINE('UPDATEADOS '||sql%rowcount);          
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO');
        ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO ');   	
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_MGD_MAPEO_GESTOR_DOC.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
           
           V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.MGD_MAPEO_GESTOR_DOC (MGD_ID, DD_CRA_ID, DD_SCR_ID, CLIENTE_GD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES
                      ('|| V_ID ||',(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07''),(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||ARRAY_SUBCARTERAS(I)||'''),''Promontoria Agora'',0,''HREOS-5654'',SYSDATE FROM DUAL,0)';         
          EXECUTE IMMEDIATE V_MSQL;
        
        END IF;

      END LOOP;
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



   
