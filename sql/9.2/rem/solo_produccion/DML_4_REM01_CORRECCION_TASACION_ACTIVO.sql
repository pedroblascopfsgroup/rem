--/*
--##########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=20181212
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2372
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar tasadora de tasaciones
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2372';
    V_MSQL VARCHAR2(4000 CHAR); 
    V_TABLA_TASACION VARCHAR2(25 CHAR) := 'ACT_TAS_TASACION';
    V_TABLA_ACTIVO VARCHAR2(25 CHAR) := 'ACT_ACTIVO';
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    CUENTA NUMBER;


BEGIN	

	 DBMS_OUTPUT.PUT_LINE('UPDATE DE LA TABLA '||V_TABLA_TASACION||' DE LAS TASACIONES: 146784, 125505');
	 
	 
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TASACION||' TAS USING '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT ON (TAS.ACT_ID = ACT.ACT_ID) WHEN MATCHED THEN
	UPDATE SET TAS_NOMBRE_TASADOR = ''GESVALT'' , TAS.USUARIOMODIFICAR = ''REMVIP-2372'', TAS.FECHAMODIFICAR = SYSDATE WHERE TAS_ID IN (146784, 125505)';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('UPDATE DE LA TABLA '||V_TABLA_TASACION||' DE LAS TASACIONES: 146784, 125505 OK');
	 	 
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
