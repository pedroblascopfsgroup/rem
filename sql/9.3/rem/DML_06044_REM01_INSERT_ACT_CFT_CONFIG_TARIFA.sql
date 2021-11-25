--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20211125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16539
--## PRODUCTO=NO
--##
--## Finalidad: Insertar registros en ACT_CFT_CONFIG_TARIFA
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_CFT_CONFIG_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-16539'; -- Usuario modificar

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

  	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
        (CFT_ID
        ,DD_TTF_ID
        ,DD_TTR_ID
        ,DD_STR_ID
        ,DD_CRA_ID
        ,CFT_PRECIO_UNITARIO
        ,CFT_UNIDAD_MEDIDA
        ,USUARIOCREAR
        ,FECHACREAR
        ,PVE_ID
        ,DD_SCR_ID
        ,CFT_FECHA_INI
        ,CFT_FECHA_FIN
        ,CFT_PRECIO_UNITARIO_CLIENTE
        ,CFT_TARIFA_PVE)
        SELECT 
            '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
            ,DD_TTF_ID
            ,DD_TTR_ID
            ,DD_STR_ID
            ,(SELECT CRA2.DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA2 WHERE CRA2.DD_CRA_CODIGO = ''03'') AS DD_CRA_ID
            ,CFT_PRECIO_UNITARIO
            ,CFT_UNIDAD_MEDIDA
            ,''HREOS-16539''
            ,SYSDATE
            ,PVE_ID
            ,(SELECT SCR.DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR WHERE SCR.DD_SCR_CODIGO = ''08'') AS DD_SCR_ID
            ,CFT_FECHA_INI
            ,CFT_FECHA_FIN
            ,CFT_PRECIO_UNITARIO_CLIENTE
            ,CFT_TARIFA_PVE
        FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CFT2
        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CFT2.DD_CRA_ID
        WHERE CRA.DD_CRA_CODIGO = ''16''';
  	
	EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '|| SQL%ROWCOUNT ||' REGISTROS PARA Titulizada EN '||V_TEXT_TABLA);

	COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
   			
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
