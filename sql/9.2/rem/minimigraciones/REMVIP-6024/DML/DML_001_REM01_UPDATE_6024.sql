--###########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6024
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar gastos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
alter session set NLS_NUMERIC_CHARACTERS = '.,';

DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-6024';
    
BEGIN	
	
    V_NUM_TABLAS := 0;
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('	[INFO]: ACTUALIZAR ACTIVOS');


V_MSQL := ' MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
	USING (

		SELECT DISTINCT ACT.ACT_ID, ACT.ACT_NUM_ACTIVO
		FROM '||V_ESQUEMA||'.AUX_REMVIP_6024 AUX, '||V_ESQUEMA||'.ACT_ACTIVO ACT
		WHERE 1 = 1
		AND AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
		AND ACT.BORRADO = 0
		
	      ) AUX	
	ON ( ACT.ACT_ID = AUX.ACT_ID )
		WHEN MATCHED THEN UPDATE SET
			ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO * ( -100000 ),
			BORRADO        = 1,
			USUARIOBORRAR  = ''REMVIP-6024'',
			FECHABORRAR    = SYSDATE

' ;


    --DBMS_OUTPUT.PUT_LINE(V_MSQL);        
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' ACTIVOS BORRADOS ');  

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
