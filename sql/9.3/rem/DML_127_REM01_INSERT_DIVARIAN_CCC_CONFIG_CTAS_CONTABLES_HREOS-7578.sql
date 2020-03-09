--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-9544
--## PRODUCTO=NO
--##
--## Finalidad: Script que replica los valores de la cartera Apple para la cartera Divarian en la tabla CCC_CONFIG_CTAS_CONTABLES.
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
    V_CCC_DIVARIAN_ARROW VARCHAR2(20 CHAR);
    V_ID_SCR_DIVARIAN_REMAINING VARCHAR2(20 CHAR);
    V_CCC_DIVARIAN_REMAINING VARCHAR2(20 CHAR);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

BEGIN   
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
           
    
	V_SQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_DD||' WHERE DD_SCR_CODIGO = ''138''';
    EXECUTE IMMEDIATE V_SQL INTO V_ID_SCR_APPLE;
    
    DBMS_OUTPUT.PUT_LINE('ID DE LA SUBCARTERA APPLE RECOGIDO.');
    
    V_SQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_DD||' WHERE DD_SCR_CODIGO = ''151''';
    EXECUTE IMMEDIATE V_SQL INTO V_ID_SCR_DIVARIAN_ARROW;

    V_SQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_DD||' WHERE DD_SCR_CODIGO = ''152''';
    EXECUTE IMMEDIATE V_SQL INTO V_ID_SCR_DIVARIAN_REMAINING;
	
    DBMS_OUTPUT.PUT_LINE('ID DE LAS SUBCARTERAS DIVARIAN RECOGIDO.');
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: COMIENZA PROCESO DE REPLICAR DATOS DE APPLE PARA DIVARIAN EN LA TABLA: ' ||V_TEXT_TABLA);

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_SCR_ID = '||V_ID_SCR_DIVARIAN_ARROW||' AND USUARIOCREAR = ''HREOS-9544''';
    EXECUTE IMMEDIATE V_SQL INTO V_CCC_DIVARIAN_ARROW;

    IF V_CCC_DIVARIAN_ARROW = 0 THEN
 
        V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (CCC_ID, DD_STG_ID, DD_CRA_ID, PRO_ID, 
                    CCC_CUENTA_ACTIVABLE, VERSION,	USUARIOCREAR, FECHACREAR, BORRADO,
                    CCC_CUENTA_CONTABLE, EJE_ID, CCC_ARRENDAMIENTO, DD_SCR_ID)
                    SELECT S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL, CCC.DD_STG_ID, CCC.DD_CRA_ID, CCC.PRO_ID, 
                    CCC.CCC_CUENTA_ACTIVABLE, 0, ''HREOS-9544'', SYSDATE, 0,
                    CCC.CCC_CUENTA_CONTABLE, CCC.EJE_ID, CCC.CCC_ARRENDAMIENTO, '||V_ID_SCR_DIVARIAN_ARROW||'
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CCC WHERE CCC.DD_SCR_ID = '||V_ID_SCR_APPLE||' AND CCC.BORRADO = 0
                    AND NOT EXISTS (
                                    SELECT 1
                                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AUX_CCC
                                    LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON AUX_CCC.DD_CRA_ID = CRA.DD_CRA_ID
                                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON AUX_CCC.DD_SCR_ID = SCR.DD_SCR_ID
                                    WHERE SCR.DD_SCR_CODIGO = ''151'' AND AUX_CCC.DD_STG_ID = CCC.DD_STG_ID AND AUX_CCC.CCC_CUENTA_CONTABLE = CCC.CCC_CUENTA_CONTABLE AND AUX_CCC.EJE_ID = CCC.EJE_ID
                    )';
        
        EXECUTE IMMEDIATE V_SQL;
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FIN] YA EXISTEN CCC PARA DIVARIAN ARROW');
    END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_SCR_ID = '||V_ID_SCR_DIVARIAN_REMAINING||' AND USUARIOCREAR = ''HREOS-9544''';
    EXECUTE IMMEDIATE V_SQL INTO V_CCC_DIVARIAN_REMAINING;

    IF V_CCC_DIVARIAN_REMAINING = 0 THEN

        V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (CCC_ID, DD_STG_ID, DD_CRA_ID, PRO_ID, 
                    CCC_CUENTA_ACTIVABLE, VERSION,	USUARIOCREAR, FECHACREAR, BORRADO,
                    CCC_CUENTA_CONTABLE, EJE_ID, CCC_ARRENDAMIENTO, DD_SCR_ID)
                    SELECT S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL, CCC.DD_STG_ID, CCC.DD_CRA_ID, CCC.PRO_ID, 
                    CCC.CCC_CUENTA_ACTIVABLE, 0, ''HREOS-9544'', SYSDATE, 0,
                    CCC.CCC_CUENTA_CONTABLE, CCC.EJE_ID, CCC.CCC_ARRENDAMIENTO, '||V_ID_SCR_DIVARIAN_REMAINING||'
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CCC WHERE CCC.DD_SCR_ID = '||V_ID_SCR_APPLE||' AND CCC.BORRADO = 0
                    AND NOT EXISTS (
                                    SELECT 1
                                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AUX_CCC
                                    LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON AUX_CCC.DD_CRA_ID = CRA.DD_CRA_ID
                                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON AUX_CCC.DD_SCR_ID = SCR.DD_SCR_ID
                                    WHERE SCR.DD_SCR_CODIGO = ''152'' AND AUX_CCC.DD_STG_ID = CCC.DD_STG_ID AND AUX_CCC.CCC_CUENTA_CONTABLE = CCC.CCC_CUENTA_CONTABLE AND AUX_CCC.EJE_ID = CCC.EJE_ID
                    )';
        
        EXECUTE IMMEDIATE V_SQL;
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FIN] YA EXISTEN CCC PARA DIVARIAN ARROW');
    END IF;
				
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
