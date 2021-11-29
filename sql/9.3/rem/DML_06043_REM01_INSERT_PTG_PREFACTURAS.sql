--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20211125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16538
--## PRODUCTO=NO
--##
--## Finalidad: Insertar registros de PFA_PREFACTURA a PTG_PREFACTURAS
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'PTG_PREFACTURAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_ORIGEN VARCHAR2(27 CHAR) := 'PFA_PREFACTURA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-16538'; -- Usuario modificar

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

  	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
        (PTG_ID
        ,PFA_ID
        ,PRO_ID
        ,TBJ_ID
        ,GPV_ID
        ,USUARIOCREAR
        ,FECHACREAR
        ,USUARIOBORRAR
        ,FECHABORRAR
        ,BORRADO)
        SELECT
            '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
            ,PFA.PFA_ID
            ,PFA.PRO_ID
            ,TBJ.TBJ_ID
            ,GPV.GPV_ID
            ,''HREOS-16538''
            ,SYSDATE
            ,PFA.USUARIOBORRAR
            ,PFA.FECHABORRAR
            ,PFA.BORRADO
        FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_ORIGEN||' PFA
        JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.PFA_ID = PFA.PFA_ID
        LEFT JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.PFA_ID = PFA.PFA_ID AND GPV.BORRADO = 0
        WHERE 0 = (
                SELECT COUNT(PTG.PTG_ID)
                FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' PTG
                WHERE PTG.USUARIOCREAR = ''HREOS-16538'')';
  	
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
