--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200710
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7779
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar COD_TIPO_COMERCIALIZACIÓN A NULL
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-7779'; -- Usuario modificar
	PL_OUTPUT VARCHAR2(32000 CHAR);
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES
				SET COD_TIPO_COMERZIALZACION = NULL,
				USUARIOMODIFICAR = '''||V_USUARIO||''', 
				FECHAMODIFICAR = SYSDATE 
				WHERE TIPO_GESTOR IN (''GIAFORM'', ''GGADM'', ''GIAADMT'')';
  	
	EXECUTE IMMEDIATE V_MSQL;  
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
