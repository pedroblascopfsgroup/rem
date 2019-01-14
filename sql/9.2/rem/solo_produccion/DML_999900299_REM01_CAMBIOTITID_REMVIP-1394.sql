--/*
--###########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180723
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1394
--## PRODUCTO=NO
--## 
--## Finalidad: Cabio de tit_id en COE
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1394';
  V_TABLA VARCHAR2(50 CHAR) := 'COE_CONDICIONANTES_EXPEDIENTE';
  V_TABLA_ECO VARCHAR2(50 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';
  V_DIC_TIT VARCHAR2(50 CHAR) := 'DD_TIT_TIPOS_IMPUESTO';

  V_COUNT NUMBER(16);
  V_ID NUMBER(16);
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLA||' COE 
				JOIN '||V_ESQUEMA||'.'||V_DIC_TIT||' TIT ON TIT.DD_TIT_ID = COE.DD_TIT_ID AND TIT.DD_TIT_CODIGO = ''01''
				JOIN '||V_ESQUEMA||'.'||V_TABLA_ECO||' ECO ON ECO.ECO_ID = COE.ECO_ID AND ECO.ECO_NUM_EXPEDIENTE = 105827';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	
	IF V_COUNT > 0 THEN
	
		DBMS_OUTPUT.PUT_LINE('[INFO] Los datos ya estan cambiados, no se realiza acción');
	
	ELSE
	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' COE SET COE.USUARIOMODIFICAR = '''||V_USUARIO||''', COE.FECHAMODIFICAR = SYSDATE, COE.DD_TIT_ID = (
			SELECT TIT.DD_TIT_ID
			FROM '||V_ESQUEMA||'.'||V_DIC_TIT||' TIT
			WHERE TIT.DD_TIT_CODIGO = ''01''
			)
			WHERE COE.ECO_ID = (
				SELECT ECO.ECO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ECO||' ECO
				WHERE ECO.ECO_NUM_EXPEDIENTE = 105827
			)
			';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
	
	END IF;
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
 

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
