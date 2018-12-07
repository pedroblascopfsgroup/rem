--/*
--#########################################
--## AUTOR=Javier Pons
--## FECHA_CREACION=20181014
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-2298
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar EDI_DESCRIPCION de la tabla ACT_EDI_EDIFICIO
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
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
V_TABLA VARCHAR2(40 CHAR) := 'AUX_JPR_ICO_INFO_COMERCIAL';

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]'); 

	EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_EDI_EDIFICIO T1
						USING (
							SELECT NUM_HAYA, 
                                   EDI.EDI_ID,
							       DESCRIPCION,
								   DISTRIBUCION_INTERIOR 
							FROM '||V_ESQUEMA||'.'||V_TABLA||' AUX
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = COALESCE(TO_NUMBER(REGEXP_SUBSTR(REPLACE(AUX.NUM_HAYA,''-'',''''),''^\d+(\.\d+)?'')), 0)
                            JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID
                            JOIN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI ON EDI.ICO_ID = ICO.ICO_ID 
                            WHERE 
							LENGTH(AUX.DESCRIPCION) > (5)
							AND (AUX.DESCRIPCION is not null OR AUX.DISTRIBUCION_INTERIOR is not null)
							AND AUX.NUM_HAYA NOT IN (
       						''-6877736'',
       						''-6883420'',
       						''-6850098'',
       						''-6877737'',
       						''-6883419'',
       						''-6879193'',
       						''-6881012'',
      						''-6881645'',
       						''-6878553'',
       						''-6849710''
   							)                         
						) T2
						ON (T1.EDI_ID = T2.EDI_ID)
						WHEN MATCHED THEN UPDATE SET
							T1.EDI_DESCRIPCION = T2.DESCRIPCION,
							T1.USUARIOMODIFICAR = ''REMVIP-2298'',
							T1.FECHAMODIFICAR = SYSDATE
	';
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' Activos a los que actualizamos la EDI_DESCRIPCION.');  

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;

/

EXIT
