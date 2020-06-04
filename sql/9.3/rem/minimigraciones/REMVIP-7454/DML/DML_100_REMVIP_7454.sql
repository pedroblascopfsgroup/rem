--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200603
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7454
--## PRODUCTO=NO
--## 
--## Finalidad:
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-7454';

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO]');
        
        V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO T1
					USING (
						SELECT ACT.ACT_ID, AUX.TIPO_INQUILINO, CASE WHEN AUX.RENTA_ANTIGUA = ''N'' THEN 0 WHEN AUX.RENTA_ANTIGUA = ''S'' THEN 1 END AS RENTA_ANTIGUA
						FROM '||V_ESQUEMA||'.AUX_REMVIP_7454 AUX
                        			JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.NUM_ACTIVO
					) T2
					ON (T1.ACT_ID = T2.ACT_ID)
					WHEN MATCHED THEN UPDATE SET
					T1.DD_TPI_ID = (SELECT DD_TPI_ID FROM '||V_ESQUEMA||'.DD_TPI_TIPO_INQUILINO WHERE DD_TPI_CODIGO = T2.TIPO_INQUILINO),
                        		T1.PTA_RENTA_ANTIGUA = T2.RENTA_ANTIGUA,
					T1.USUARIOMODIFICAR = ''REMVIP-7454'',
					T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros.');

		COMMIT;
		DBMS_OUTPUT.PUT_LINE('[FIN]');

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
