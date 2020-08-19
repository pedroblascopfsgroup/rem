--/*
--##########################################
--## AUTOR=Jonathan Ovalle
--## FECHA_CREACION=20200722
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10602
--## PRODUCTO=NO
--##
--## Finalidad: Script que fusiona los datos de SGT_ID en ACT_CONFIG_PTDAS_PREP
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-10602';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_PTDAS_PREP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
BEGIN	

    -- LOOP para insertar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: MERGE EN  '||V_TEXT_TABLA||' ');  
          V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' PTDAS USING
                     (SELECT PTDAS.CPP_PTDAS_ID, SGT.SGT_ID
                     FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' PTDAS
                     JOIN '||V_ESQUEMA||'.ACT_SGT_SUBTIPO_GPV_TBJ SGT ON PTDAS.DD_STG_ID = SGT.DD_STG_ID
                     LEFT JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR ON SGT.DD_STR_ID = STR.DD_STR_ID
                     WHERE STR.DD_STR_CODIGO IN (''28'', ''29'', ''30'', ''31'', ''32'',''121'')) AUX
                     ON (PTDAS.CPP_PTDAS_ID = AUX.CPP_PTDAS_ID)
                     WHEN MATCHED THEN UPDATE SET PTDAS.SGT_ID = AUX.SGT_ID';
                        DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' MODIFICADA CORRECTAMENTE ');
   

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
