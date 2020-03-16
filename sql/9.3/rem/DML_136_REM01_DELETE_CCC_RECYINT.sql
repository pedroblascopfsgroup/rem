--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200313
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9807
--## PRODUCTO=NO
--##
--## Finalidad: Script que borrar CCC subtipo Recargos e intereses
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-9807';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: COMENZAMOS ');
    
    --Comprobamos el dato a insertar
    V_SQL := 'SELECT COUNT(1) 
              FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
              WHERE CCC.BORRADO = 1 AND CCC.USUARIOBORRAR = ''HREOS-9807'' AND CCC.CCC_CUENTA_CONTABLE IN (''6780100000'',''6315000'')
    ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    --1 existe lo modificamos
    IF V_NUM_TABLAS > 0 THEN	

      DBMS_OUTPUT.PUT_LINE('[INFO]: YA SE HAN BORRADO LOS REGISTROS EN CCC');  

    ELSE
    
      DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS');

      V_MSQL := 'UPDATE '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC SET
                  CCC.BORRADO = 1
                  , CCC.USUARIOBORRAR = ''HREOS-9807''
                  , CCC.FECHABORRAR = SYSDATE
                  WHERE CCC.CCC_ID IN (
                    SELECT CCC.CCC_ID
                    FROM REM01.CCC_CONFIG_CTAS_CONTABLES CCC
                    JOIN REM01.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
                    LEFT JOIN REM01.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                    WHERE CCC.BORRADO = 0 AND SCR.DD_SCR_CODIGO IN (''138'',''151'',''152'') AND CCC.CCC_CUENTA_CONTABLE IN (''6780100000'',''6315000'')
                  )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO BORRADO CORRECTAMENTE EN CCC PARA APPLE Y DIVARIAn: ' ||sql%rowcount);
    
    END IF;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]:  MODIFICADO CORRECTAMENTE ');
   

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
