--/*
--##########################################
--## AUTOR=Javier Pons Ruiz
--## FECHA_CREACION=20181109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2488
--## PRODUCTO=NO
--##
--## Finalidad: Borrado logico de ACTIVO
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2488';
    V_MSQL VARCHAR2(4000 CHAR); 
    V_TABLA VARCHAR2(25 CHAR) := 'ACT_ACTIVO';
    V_NUMERO_ACTIVO NUMBER := 149322;
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    CUENTA NUMBER;


BEGIN	

	 DBMS_OUTPUT.PUT_LINE('UPDATE DE LA TABLA '||V_TABLA||' DEL ACTIVO: '||V_NUMERO_ACTIVO);
	 
	 V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_NUM_ACTIVO = '||V_NUMERO_ACTIVO;

	 EXECUTE IMMEDIATE V_MSQL INTO CUENTA;
	 
	 IF CUENTA > 0 THEN
	 
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
            FECHABORRAR = SYSDATE,
            USUARIOBORRAR = '''||V_USUARIO||''',
            BORRADO = 1
			WHERE ACT_NUM_ACTIVO = '||V_NUMERO_ACTIVO||'';
            
		EXECUTE IMMEDIATE V_MSQL;
	
		DBMS_OUTPUT.PUT_LINE('UPDATE DE LA TABLA '||V_TABLA||' DEL ACTIVO: '||V_NUMERO_ACTIVO||' OK');
		
	 ELSE
	 DBMS_OUTPUT.PUT_LINE('EL ACTIVO:'||V_NUMERO_ACTIVO||' NO EXISTE');
	 
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
