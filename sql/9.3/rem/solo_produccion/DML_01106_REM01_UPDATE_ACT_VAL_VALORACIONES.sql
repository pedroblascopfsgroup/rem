--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20211220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10853
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar la fecha de fin de los precios de los activos 7432113 y 7432094
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-10853'; -- Configuracion Esquema Master.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
	type t_num is table of number(16);
  	T_IDS t_num;
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	DBMS_OUTPUT.PUT_LINE('[INFO]: ELIMINANDO FECHA FIN DE LOS  ');

	
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_VAL_VALORACIONES
				SET VAL_FECHA_FIN = NULL, USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
				WHERE ACT_ID IN (SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO IN (7432113,7432094))
				AND (VAL_FECHA_FIN IS NOT NULL AND TO_DATE(VAL_FECHA_FIN,''DD/MM/RRRR'') <= TO_DATE(''31/12/1999'',''DD/MM/RRRR''))';
    EXECUTE IMMEDIATE V_MSQL;
  	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	   	
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
