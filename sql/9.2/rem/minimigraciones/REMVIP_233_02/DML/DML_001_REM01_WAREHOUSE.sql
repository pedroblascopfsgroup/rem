--/*
--#########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=201803015
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-233
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

    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
    V_ESQUEMA_M VARCHAR2(10 CHAR) := 'REMMASTER';
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-233';

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
	EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.OFR_OFERTAS T1
       USING '||V_ESQUEMA||'.AUX_IDUVEM T2
       ON (T1.OFR_NUM_OFERTA = T2.CODIGO_OFERTA_HAYA)
       WHEN MATCHED THEN UPDATE SET
           T1.OFR_UVEM_ID = T2.CODIGO_OFERTA_UVEM, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
       WHERE T2.CODIGO_OFERTA_LOTE_UVEM = 0';


    DBMS_OUTPUT.PUT_LINE('[INFO] - Se han actualizado '||SQL%ROWCOUNT||' ids_uvem.');


    DBMS_OUTPUT.PUT_LINE('[FIN]');

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
