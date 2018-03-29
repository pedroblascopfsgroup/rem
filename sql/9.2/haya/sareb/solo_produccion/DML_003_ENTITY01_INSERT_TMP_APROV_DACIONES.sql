--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180330
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-384
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
			  T_TIPO_DATA(6781274)
			, T_TIPO_DATA(6781275)
			, T_TIPO_DATA(100876)
			, T_TIPO_DATA(119421)
			, T_TIPO_DATA(119120)
			, T_TIPO_DATA(120660)
			, T_TIPO_DATA(120661)
			, T_TIPO_DATA(119121)
			, T_TIPO_DATA(149191)
			, T_TIPO_DATA(175441)
			, T_TIPO_DATA(133783)
			, T_TIPO_DATA(70946)
			, T_TIPO_DATA(158106)
			, T_TIPO_DATA(148966)
			, T_TIPO_DATA(145998)
			, T_TIPO_DATA(133466)
			, T_TIPO_DATA(149192)
			, T_TIPO_DATA(146227)
			, T_TIPO_DATA(158107)
			, T_TIPO_DATA(201127)
			, T_TIPO_DATA(148967)
			, T_TIPO_DATA(146347)
			, T_TIPO_DATA(158108)
			, T_TIPO_DATA(146348)
			, T_TIPO_DATA(145999)
			, T_TIPO_DATA(133261)
			, T_TIPO_DATA(174188)
			, T_TIPO_DATA(149193)
			, T_TIPO_DATA(133262)
			, T_TIPO_DATA(157851)
			, T_TIPO_DATA(146000)
			, T_TIPO_DATA(157852)
			, T_TIPO_DATA(146229)
			, T_TIPO_DATA(146230)
			, T_TIPO_DATA(149194)
			, T_TIPO_DATA(133467)
			, T_TIPO_DATA(146001)
			, T_TIPO_DATA(148968)
			, T_TIPO_DATA(158109)
			, T_TIPO_DATA(146558)
			, T_TIPO_DATA(148969)
			, T_TIPO_DATA(133784)
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


