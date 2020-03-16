--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9612
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en proveedores los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
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
    V_ID_COD_REM NUMBER(16);
    V_ID_PVC NUMBER(16);
    V_ID_ETP NUMBER(16);
    V_BOOLEAN NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-9612';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    --Comprobamos el dato a insertar
    V_SQL := '
            SELECT COUNT(CCC.CCC_ID)
            FROM '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES CCC
            JOIN '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
            LEFT JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
            LEFT JOIN '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO STG ON CCC.DD_STG_ID = STG.DD_STG_ID
            WHERE SCR.DD_SCR_CODIGO IN (''138'')
            AND STG.DD_STG_CODIGO IN (''01'',''02'')
            AND CCC.BORRADO = 0
    ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    --1 existe lo modificamos
    IF V_NUM_TABLAS = 0 THEN	

      DBMS_OUTPUT.PUT_LINE('[INFO]: YA ESTÁN BORRADAS LAS CCC');  

    ELSE
    
      DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADAMOS LAS CCC');   

      V_MSQL := '
        UPDATE '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES CCC SET
        CCC.BORRADO = 1
        , CCC.USUARIOBORRAR = '''||TRIM(V_ITEM)||'''
        , CCC.FECHABORRAR = SYSDATE
        WHERE CCC.CCC_ID IN (
          SELECT CCC.CCC_ID
          FROM '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES CCC
          JOIN '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
          LEFT JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
          LEFT JOIN '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO STG ON CCC.DD_STG_ID = STG.DD_STG_ID
          WHERE SCR.DD_SCR_CODIGO IN (''138'')
          AND STG.DD_STG_CODIGO IN (''01'',''02'')
          AND CCC.BORRADO = 0
        )
      ';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: CCC_CONFIG_CTAS_CONTABLES BORRADAS');
    
    END IF;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: CCC_CONFIG_CTAS_CONTABLES MODIFICADO CORRECTAMENTE ');
   

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
