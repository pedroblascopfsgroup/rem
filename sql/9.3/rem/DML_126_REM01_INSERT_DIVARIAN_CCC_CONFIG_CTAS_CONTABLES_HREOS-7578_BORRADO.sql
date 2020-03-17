--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-9544
--## PRODUCTO=NO
--##
--## Finalidad: Script que borra las cuentas contables para la cartera Divarian con código 150 en la tabla CCC_CONFIG_CTAS_CONTABLES.
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
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'CCC_CONFIG_CTAS_CONTABLES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_DD VARCHAR2(30 CHAR) := 'DD_SCR_SUBCARTERA'; -- Vble. auxiliar para almacenar el nombre de la tabla diccionario.
    
    V_ID_SCR_APPLE VARCHAR2(20 CHAR);
    V_ID_SCR_DIVARIAN_ARROW VARCHAR2(20 CHAR);
    V_ID_SCR_DIVARIAN_REMAINING VARCHAR2(20 CHAR);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

BEGIN   
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
           
    DBMS_OUTPUT.PUT_LINE('[INFO]: COMIENZA PROCESO DE CUENTAS CONTABLES CREADAS COMO DIVARIAN CON CÓDIGO 150 EN LA TABLA: ' ||V_TEXT_TABLA);


    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET 
                USUARIOBORRAR = ''HREOS-9544''
                , FECHABORRAR = SYSDATE
                , BORRADO = 1
                WHERE CCC_ID IN 
                (
                    SELECT CCC.CCC_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CCC
                    LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CCC.DD_CRA_ID = CRA.DD_CRA_ID
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID
                    WHERE CCC.USUARIOCREAR = ''HREOS-7578'' AND SCR.DD_SCR_CODIGO = ''150'' AND CCC.BORRADO = 0
                )';
    
	EXECUTE IMMEDIATE V_SQL;
				
	DBMS_OUTPUT.PUT_LINE('[FIN] FINALIZADO EL PROCESO DE REPLICA DE GESTORES DE APPLE PARA DIVARIAN');
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
