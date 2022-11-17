--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20221117
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12701
--## PRODUCTO=NO
--##
--## Finalidad: DESBORRAR GTOPLUS PARA CERBERUS
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_CARTERA VARCHAR2(50 CHAR):= '07';
    V_GESTOR VARCHAR2(50 CHAR):= 'GTOPLUS';
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN DD_GCM_GESTOR_CARGA_MASIVA');
	
    V_MSQL := 'SELECT COUNT(1)
                FROM '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA GCM
                INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = GCM.DD_GCM_CODIGO
                INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = GCM.DD_CRA_ID
                WHERE TGE.DD_TGE_CODIGO = '''||V_GESTOR||'''
                AND CRA.DD_CRA_CODIGO = '''||V_CARTERA||'''
                AND GCM.BORRADO = 1';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

        V_MSQL := 'SELECT DD_GCM_ID
                        FROM '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA GCM
                        INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = GCM.DD_GCM_CODIGO
                        INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = GCM.DD_CRA_ID
                        WHERE TGE.DD_TGE_CODIGO = '''||V_GESTOR||'''
                        AND CRA.DD_CRA_CODIGO = '''||V_CARTERA||'''
                        AND GCM.BORRADO = 1';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA
                    SET BORRADO = 0,
                    USUARIOMODIFICAR = ''REMVIP-12701'',
                    FECHAMODIFICAR = SYSDATE,
                    USUARIOBORRAR = NULL,
                    FECHABORRAR = NULL
                    WHERE DD_GCM_ID = '||V_ID||'';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: DESBORRADO REGISTRO PARA EL GESTOR '''|| V_GESTOR ||''' Y LA CARTERA '''||V_CARTERA||'''');

    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE DESBORRADO EL REGISTRO PARA EL GESTOR '''|| V_GESTOR ||''' Y LA CARTERA '''||V_CARTERA||'''');
    END IF;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: GESTOR DE CARGAS MASIVAS ACTUALZIADO CORRECTAMENTE.');   

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
