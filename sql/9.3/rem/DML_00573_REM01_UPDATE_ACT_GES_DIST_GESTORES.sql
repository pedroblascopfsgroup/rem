--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210325
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9216
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar gestores GIAFORM apple y sareb
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-9216'; -- Usuario modificar
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
				SET USERNAME = ''garsa03apple'',
				USUARIOMODIFICAR = '''||V_USUARIO||''', 
				FECHAMODIFICAR = SYSDATE 
				WHERE TIPO_GESTOR = ''GIAFORM'' AND COD_CARTERA = 7 AND COD_SUBCARTERA = 138 AND USERNAME = ''garsa03''
                AND BORRADO = 0';
  	
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS PARA APPLE EN '||V_TEXT_TABLA);

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
				SET USERNAME = ''garsa03sareb'',
				USUARIOMODIFICAR = '''||V_USUARIO||''', 
				FECHAMODIFICAR = SYSDATE 
				WHERE TIPO_GESTOR = ''GIAFORM'' AND COD_CARTERA = 2 AND USERNAME = ''garsa03''
                AND BORRADO = 0';
  	
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS PARA SAREB EN '||V_TEXT_TABLA);

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
