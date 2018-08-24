--/*
--##########################################
--## AUTOR=REMUS Sergio Ortuño
--## FECHA_CREACION=20180628
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-985
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar el estado de la oferta a tramitada
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-985';
    V_MSQL VARCHAR2(4000 CHAR); 
    V_TABLA VARCHAR2(25 CHAR) := 'OFR_OFERTAS';
    V_DICCIONARIO VARCHAR2(25 CHAR) := 'DD_EOF_ESTADOS_OFERTA';
    V_NUMERO_OFERTA NUMBER := 90026255;
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    CUENTA NUMBER;


BEGIN	

	 DBMS_OUTPUT.PUT_LINE('UPDATE DE LA TABLA '||V_TABLA||' DE LA OFERTA: '||V_NUMERO_OFERTA);
	 
	 V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE OFR_NUM_OFERTA = '||V_NUMERO_OFERTA;
	 EXECUTE IMMEDIATE V_MSQL INTO CUENTA;
	 
	 IF CUENTA > 0 THEN
	 
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET FECHAMODIFICAR = SYSDATE, USUARIOMODIFICAR = '''||V_USUARIO||''', DD_EOF_ID = 
			(SELECT EOF.DD_EOF_ID
			FROM '||V_ESQUEMA||'.'||V_DICCIONARIO||' EOF
			WHERE EOF.DD_EOF_CODIGO = ''01'')
		 WHERE OFR_NUM_OFERTA = '||V_NUMERO_OFERTA;
		EXECUTE IMMEDIATE V_MSQL;
	
		DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' registros');
		DBMS_OUTPUT.PUT_LINE('UPDATE DE LA TABLA '||V_TABLA||' DE LA OFERTA: '||V_NUMERO_OFERTA||' OK');
		
	 ELSE
	 DBMS_OUTPUT.PUT_LINE('LA OFERTA:' ||V_NUMERO_OFERTA||' NO EXISTE');
	 
	 END IF;
	 
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
