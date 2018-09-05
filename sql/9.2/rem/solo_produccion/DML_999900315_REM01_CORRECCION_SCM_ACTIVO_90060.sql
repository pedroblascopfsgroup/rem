--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20180905
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1726
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar la situacion comercial del activo
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
   
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1726';
    V_MSQL VARCHAR2(4000 CHAR); 
    V_TABLA_ACTIVO VARCHAR2(25 CHAR) := 'ACT_ACTIVO';
    V_NUMERO_ACTIVO NUMBER := 90060;
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    CUENTA NUMBER;


BEGIN	

	 DBMS_OUTPUT.PUT_LINE('UPDATE DE LA TABLA '||V_TABLA_ACTIVO||' DEL ACTIVO: '||V_NUMERO_ACTIVO);
	 
	 V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '||V_NUMERO_ACTIVO;
	 EXECUTE IMMEDIATE V_MSQL INTO CUENTA;
	 
	 IF CUENTA > 0 THEN
	 
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' SET
			DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''02''),
			USUARIOMODIFICAR = '''||V_USUARIO||''',
			FECHAMODIFICAR = SYSDATE
			WHERE ACT_NUM_ACTIVO = '||V_NUMERO_ACTIVO||'';
		EXECUTE IMMEDIATE V_MSQL;
	
		DBMS_OUTPUT.PUT_LINE('UPDATE DE LA TABLA '||V_TABLA_ACTIVO||' DEL ACTIVO: '||V_NUMERO_ACTIVO||' OK');
		
	 ELSE
	 DBMS_OUTPUT.PUT_LINE('EL ACTIVO:' ||V_NUMERO_ACTIVO||' NO EXISTE');
	 
	 END IF;
	 
	 COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          DBMS_OUTPUT.put_line(V_MSQL);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
