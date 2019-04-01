--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190301
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-3421
--## PRODUCTO=NO
--## 
--## Finalidad: Actualiza activos COOPER
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3421';

BEGIN


	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1
				 USING (
					SELECT DISTINCT
						TBJ_NUM_TRABAJO,
						REQUIRENTE,
						EMAIL,
						DIRECCION,
						PERSONA_CTO,
						TEL1,
						TEL2,
						NOMBRE_CTO,
						PROV,
						POB
					FROM '||V_ESQUEMA||'.AUX_ACT_TBJ_TRABAJO AUX
					WHERE 1 = 1
				       ) T2 
						ON (T1.TBJ_NUM_TRABAJO = T2.TBJ_NUM_TRABAJO) 
						WHEN MATCHED THEN UPDATE SET 
							T1.TBJ_TERCERO_NOMBRE = T2.REQUIRENTE,
							T1.TBJ_TERCERO_EMAIL  = T2.EMAIL, 
							T1.TBJ_TERCERO_DIRECCION = ( T2.DIRECCION || '' '' || T2.POB || '' ('' || T2.PROV || '')'' ),
							T1.TBJ_TERCERO_CONTACTO  = T2.PERSONA_CTO,
							T1.TBJ_TERCERO_TEL1 = T2.TEL1,
							T1.TBJ_TERCERO_TEL2 = T2.TEL2,
	
							T1.USUARIOMODIFICAR = ''REMVIP-3421'', 
							T1.FECHAMODIFICAR = SYSDATE

					'; 

	EXECUTE IMMEDIATE V_SQL;
		
	COMMIT;

      DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registro en la tabla ACT_TBJ_TRABAJO');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
