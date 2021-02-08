--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210129
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8542
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización tabla 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

	-- Variables
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8542';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);

	V_TABLA_ACT	VARCHAR2 (30 CHAR)	:= 'ACT_ACTIVO';	
	V_TABLA_ICO	VARCHAR2(50 CHAR)	:= 'ACT_ICO_INFO_COMERCIAL';
	V_TABLA_AUX	VARCHAR2(50 CHAR)	:= 'AUX_REMVIP_8542_1';
   	
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR TABLA '||V_ESQUEMA||'.'||V_TABLA_ICO||'.');
	  	
	V_SQL := '
		MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ICO||'  T1
			USING (
				SELECT ACT.ACT_ID, AUX.ICO_DESCRIPCION, AUX.ICO_INFO_DISTRIBUCION_INTERIOR FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT
				INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
				WHERE ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
				) T2
			ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE
			SET				
				T1.ICO_DESCRIPCION = T2.ICO_DESCRIPCION,
				T1.ICO_INFO_DISTRIBUCION_INTERIOR = T2.ICO_INFO_DISTRIBUCION_INTERIOR,
				T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
				T1.FECHAMODIFICAR = SYSDATE';										
			
	EXECUTE IMMEDIATE V_SQL;
        
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');  
		
  	COMMIT;
 
 
EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
