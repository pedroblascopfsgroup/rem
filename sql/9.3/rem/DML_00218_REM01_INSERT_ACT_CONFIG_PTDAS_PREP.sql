--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200716
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10527
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CONFIG_PTDAS_PREP los datos la antigua tabla CPP
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-10527';
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_PTDAS_PREP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
       
    V_SQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TEXT_TABLA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO]: La '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' no existe');
    ELSE
      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
                (CPP_PTDAS_ID
                , CPP_PARTIDA_PRESUPUESTARIA
                , DD_TGA_ID
                , DD_STG_ID
                , DD_CRA_ID
                , DD_SCR_ID
                , DD_TIM_ID
                , PRO_ID
                , EJE_ID
                , CPP_ARRENDAMIENTO
                , CPP_REFACTURABLE
                , VERSION
                , USUARIOCREAR
                , FECHACREAR
                , BORRADO
                ) 
                  SELECT 
                  '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL CPP_PTDAS_ID
                  , AUX.CPP_PARTIDA_PRESUPUESTARIA
                  , AUX.DD_TGA_ID
                  , AUX.DD_STG_ID
                  , AUX.DD_CRA_ID
                  , AUX.DD_SCR_ID
                  , AUX.DD_TIM_ID
                  , AUX.PRO_ID
                  , AUX.EJE_ID
                  , AUX.CPP_ARRENDAMIENTO
                  , AUX.CPP_REFACTURABLE
                  , AUX.VERSION
                  , AUX.USUARIOCREAR
                  , AUX.FECHACREAR
                  , AUX.BORRADO
                  FROM (
                    SELECT
                    DISTINCT
                    CPP.CPP_PARTIDA_PRESUPUESTARIA CPP_PARTIDA_PRESUPUESTARIA
                    , (SELECT STG.DD_TGA_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.BORRADO = 0 AND STG.DD_STG_ID = CPP.DD_STG_ID) DD_TGA_ID
                    , CPP.DD_STG_ID DD_STG_ID
                    , CPP.DD_CRA_ID DD_CRA_ID
                    , CPP.DD_SCR_ID DD_SCR_ID
                    , (SELECT DD_TIM_ID FROM '||V_ESQUEMA||'.DD_TIM_TIPO_IMPORTE WHERE DD_TIM_CODIGO = ''BAS'') DD_TIM_ID
                    , CPP.PRO_ID PRO_ID
                    , CPP.EJE_ID EJE_ID
                    , CPP.CPP_ARRENDAMIENTO CPP_ARRENDAMIENTO
                    , CPP.CPP_REFACTURABLE CPP_REFACTURABLE
                    , 0 VERSION
                    , '''||TRIM(V_ITEM)||''' USUARIOCREAR
                    , SYSDATE FECHACREAR
                    , 0 BORRADO
                    FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
                    WHERE CPP.BORRADO = 0
                  ) AUX';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADO CORRECTAMENTE');
    END IF;
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
