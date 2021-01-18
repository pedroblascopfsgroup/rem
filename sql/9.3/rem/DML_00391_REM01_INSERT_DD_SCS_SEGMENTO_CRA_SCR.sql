--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200929
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11197
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SCS_SEGMENTO_CRA_SCR los datos añadidos en T_ARRAY_DATA
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SCS_SEGMENTO_CRA_SCR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-11197'; 
    V_ID_CRA NUMBER(16); --Vble para extraer el ID del registro de la cartera.
    V_ID_SCR_ARROW NUMBER(16); --Vble para extraer el ID del registro de la subcartera.
    V_ID_SCR_REMAINING NUMBER(16); --Vble para extraer el ID del registro de la subcartera.
    V_ID_TS NUMBER(16); --Vble para extraer el ID del registro del diccionario tipo segmento.
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SCS_SEGMENTO_CRA_SCR ');
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN
      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
      (
        DD_TS_ID
        , DD_CRA_ID
        , DD_SCR_ID
        , USUARIOCREAR
      )
      SELECT 
        TS.DD_TS_ID
        , CRA.DD_CRA_ID
        , SCR.DD_SCR_ID
        , ''HREOS-11197'' USUARIOCREAR
      FROM '|| V_ESQUEMA ||'.DD_TS_TIPO_SEGMENTO TS
      LEFT JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON 1 = 1 AND CRA.BORRADO = 0
      LEFT JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND SCR.BORRADO = 0
      WHERE CRA.DD_CRA_CODIGO = ''16''
      AND TS.BORRADO = 0 AND TS.DD_TS_CODIGO IN (''00200'',''00201'',''00202'',''00203'',''00204'',''00205'',''00206'',''00207''
      ,''00208'',''00209'',''00210'',''00211'',''00212'',''00213'',''00214'',''00215''
      ,''00216'',''00217'',''00218'',''00219'',''00220'',''00221'',''00222'',''00223''
      ,''00224'',''00225'',''00226'',''00227'',''00228'',''00229'',''00230'',''00231''
      ,''00232'',''00233'',''00234'',''00235'',''00236'',''00237'')';
      EXECUTE IMMEDIATE V_MSQL;
    ELSE
      DBMS_OUTPUT.PUT_LINE('LA TABLA DD_SCS_SEGMENTO_CRA_SCR NO EXISTE');
    END IF;
  COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SCS_SEGMENTO_CRA_SCR MODIFICADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE(V_MSQL);

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
