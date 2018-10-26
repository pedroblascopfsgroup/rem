--/*
--##########################################
--## AUTOR=Javier Pons Ruiz
--## FECHA_CREACION=20181019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2146
--## PRODUCTO=NO
--##
--## Finalidad: Borrado logico de proveedor
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2283';
    V_MSQL VARCHAR2(4000 CHAR); 
    V_TABLA_PROVEEDOR VARCHAR2(25 CHAR) := 'ACT_PVE_PROVEEDOR';
    V_NUMERO_PROVEEDOR NUMBER := 110112133;
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    CUENTA NUMBER;


BEGIN	

	 DBMS_OUTPUT.PUT_LINE('UPDATE DE LA TABLA '||V_TABLA_PROVEEDOR||' DEL PROVEEDOR: '||V_NUMERO_PROVEEDOR);
	 
	 V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' WHERE PVE_COD_REM = '||V_NUMERO_PROVEEDOR;
	 EXECUTE IMMEDIATE V_MSQL INTO CUENTA;
	 
	 IF CUENTA > 0 THEN
	 
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' SET
            FECHABORRAR = SYSDATE,
            USUARIOBORRAR = '''||V_USUARIO||''',
			USUARIOMODIFICAR = '''||V_USUARIO||''',
			FECHAMODIFICAR = SYSDATE,
            BORRADO = 0
			WHERE PVE_COD_REM = '||V_NUMERO_PROVEEDOR||'';
		EXECUTE IMMEDIATE V_MSQL;
	
		DBMS_OUTPUT.PUT_LINE('UPDATE DE LA TABLA '||V_TABLA_PROVEEDOR||' DEL PROVEEDOR: '||V_NUMERO_PROVEEDOR||' OK');
		
	 ELSE
	 DBMS_OUTPUT.PUT_LINE('EL PROVEEDOR:' ||V_NUMERO_PROVEEDOR||' NO EXISTE');
	 
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
