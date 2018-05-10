--/*
--#########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180509
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-680
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-680';
	ACT_NUM_ACTIVO_UVEM NUMBER(32);
	DD_SCR_DESCRIPCION VARCHAR2(72 CHAR);
	ACT_NUM_ACTIVO_OLD NUMBER(32);
	ACT_NUM_ACTIVO_NEW NUMBER(32);


BEGIN


EXECUTE IMMEDIATE 'MERGE INTO REM01.ACT_ACTIVO T1 USING(
						SELECT ACT.ACT_NUM_ACTIVO, ACT.ACT_NUM_ACTIVO_UVEM, TMP.DD_SCR_ID AS NEW_DD_SCR_ID, ACT.DD_SCR_ID AS OLD_DD_SCR_ID FROM REM01.TMP_SCR_GIANTS TMP
						JOIN REM01.UVEM_HAYA_OLD UVEM ON TMP.ACT_NUM_ACTIVO_UVEM = UVEM.ACT_NUM_ACTIVO_UVEM
						JOIN REM01.HAYA_OLD_HAYA_NEW NEW ON UVEM.ACT_NUM_ACTIVO_OLD = NEW.ACT_NUM_ACTIVO_OLD
						JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = NEW.ACT_NUM_ACTIVO_NEW
						JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''12''
					) T2 ON (T2.ACT_NUM_ACTIVO = T1.ACT_NUM_ACTIVO)
					WHEN MATCHED THEN UPDATE SET
					T1.DD_SCR_ID = T2.NEW_DD_SCR_ID
';

    
	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros');

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
