--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190408
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-3948
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar estado gastos para que queden 'contabilizados'
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
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := '';
V_SQL VARCHAR2(32767 CHAR);
V_SENTENCIA VARCHAR2(32000 CHAR);
PL_OUTPUT VARCHAR2(32000 CHAR);
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3948';

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);



	V_SQL := '
	MERGE INTO ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR T1 USING
(
    SELECT GPV.GPV_ID
    FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
    JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN  ( 

					10333489,
					10333491,
					10333493,
					10333496,
					10333497,
					10333498,
					10333500,
					10333504,
					10333506,
					10333507,
					10333508,
					10333511,
					10333512

				)     
)T2 ON (T1.GPV_ID = T2.GPV_ID) 
WHEN MATCHED THEN
        UPDATE
        SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  ' || V_ESQUEMA || '.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''04''),
    	    T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''',
            T1.FECHAMODIFICAR = SYSDATE';
            
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' GASTOS CAMBIADOS A ESTADO <CONTABILIZADO> ');

    
    COMMIT;

	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

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
