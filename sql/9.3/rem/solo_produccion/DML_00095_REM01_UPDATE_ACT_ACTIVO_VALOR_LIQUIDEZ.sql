--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200205
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6324
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_SQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	DBMS_OUTPUT.PUT_LINE('[INICIO] Recorriendo activos para cambiar el valor liquidez  ');
     
    	V_SQL := ' MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
		   USING(  
			SELECT AUX.ACT_NUM_ACTIVO, AUX.VALOR_LIQ 
			FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_6324 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		   ) T2
		   ON ( T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO)
		   WHEN MATCHED THEN UPDATE	
		   SET T1.ACT_VALOR_LIQUIDEZ = T2.VALOR_LIQ,
		       T1.USUARIOMODIFICAR = ''REMVIP-6324'',
		       T1.FECHAMODIFICAR = SYSDATE			
		 ' ;
	EXECUTE IMMEDIATE V_SQL;     
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla ACT_ACTIVO');

	COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;

/

EXIT;
