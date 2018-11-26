--/*
--##########################################
--## AUTOR=Javier Pons Ruiz
--## FECHA_CREACION=20181114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2298
--## PRODUCTO=NO
--##
--## Finalidad: Modificar el tamaño de la distribucion interior de la tabla info comercial
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2298';
    V_MSQL VARCHAR2(4000 CHAR); 
    V_TABLA VARCHAR2(25 CHAR) := 'ACT_ICO_INFO_COMERCIAL';
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    CUENTA NUMBER;


BEGIN	

	 DBMS_OUTPUT.PUT_LINE('ALTER DE LA TABLA '||V_TABLA);
	 
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY ICO_INFO_DISTRIBUCION_INTERIOR VARCHAR2(3000 CHAR)';
            
		EXECUTE IMMEDIATE V_MSQL;
	
		DBMS_OUTPUT.PUT_LINE('UPDATE DE LA TABLA '||V_TABLA||'OK');
	 
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
