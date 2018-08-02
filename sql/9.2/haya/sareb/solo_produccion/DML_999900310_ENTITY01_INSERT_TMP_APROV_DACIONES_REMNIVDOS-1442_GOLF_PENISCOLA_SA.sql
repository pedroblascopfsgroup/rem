--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180727
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.13
--## INCIDENCIA_LINK=REMNIVDOS-1442
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
				T_TIPO_DATA(6946504),
				T_TIPO_DATA(6946565),
				T_TIPO_DATA(6946505),
				T_TIPO_DATA(6946506),
				T_TIPO_DATA(6946507),
				T_TIPO_DATA(6946508),
				T_TIPO_DATA(6946509),
				T_TIPO_DATA(6946510),
				T_TIPO_DATA(6946511),
				T_TIPO_DATA(6946585),
				T_TIPO_DATA(6946512),
				T_TIPO_DATA(6946513),
				T_TIPO_DATA(6946514),
				T_TIPO_DATA(6946515),
				T_TIPO_DATA(6946516),
				T_TIPO_DATA(6946517),
				T_TIPO_DATA(6946518),
				T_TIPO_DATA(6946519),
				T_TIPO_DATA(6946520),
				T_TIPO_DATA(6946521),
				T_TIPO_DATA(6946522),
				T_TIPO_DATA(6946523),
				T_TIPO_DATA(6946524),
				T_TIPO_DATA(6946525),
				T_TIPO_DATA(6946526),
				T_TIPO_DATA(6946527),
				T_TIPO_DATA(6946528),
				T_TIPO_DATA(6946529),
				T_TIPO_DATA(6946530),
				T_TIPO_DATA(6946531),
				T_TIPO_DATA(6946532),
				T_TIPO_DATA(6946533),
				T_TIPO_DATA(6946534),
				T_TIPO_DATA(6946535),
				T_TIPO_DATA(6946536),
				T_TIPO_DATA(6946537),
				T_TIPO_DATA(6946538),
				T_TIPO_DATA(6946539),
				T_TIPO_DATA(6946540),
				T_TIPO_DATA(6946541),
				T_TIPO_DATA(6946542),
				T_TIPO_DATA(6946543),
				T_TIPO_DATA(6946544),
				T_TIPO_DATA(6946545),
				T_TIPO_DATA(6946546),
				T_TIPO_DATA(6946547),
				T_TIPO_DATA(6946548),
				T_TIPO_DATA(6946549),
				T_TIPO_DATA(6946550),
				T_TIPO_DATA(6946563),
				T_TIPO_DATA(6946564),
				T_TIPO_DATA(6946551),
				T_TIPO_DATA(6946552),
				T_TIPO_DATA(6946553),
				T_TIPO_DATA(6946587),
				T_TIPO_DATA(6946554),
				T_TIPO_DATA(6946555),
				T_TIPO_DATA(6946556),
				T_TIPO_DATA(6946557),
				T_TIPO_DATA(6946558),
				T_TIPO_DATA(6946559),
				T_TIPO_DATA(6946560),
				T_TIPO_DATA(6946561),
				T_TIPO_DATA(6946562),
				T_TIPO_DATA(6946566)
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


