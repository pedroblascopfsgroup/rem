--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-505
--## PRODUCTO=NO
--##
--## Finalidad: Insercion en la TMP_APROV_DACIONES
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
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTR_TIPO_TRABAJO
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--BIE_ENTIDAD_ID	
			  T_TIPO_DATA(6961855)
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en TMP_APROV_DACIONES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TMP_APROV_DACIONES... Empezando a insertar datos en la tabla TMP_APROV_DACIONES');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
   		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_APROV_DACIONES(BIE_ENTIDAD_ID)
			  VALUES('||V_TMP_TIPO_DATA(1)||')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('INSERTANDO BIE_ENTIDAD_ID: '''||V_TMP_TIPO_DATA(1)||'''');
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.TMP_APROV_DACIONES... Datos de la tabla insertados');
   

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


