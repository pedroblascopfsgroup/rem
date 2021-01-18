--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190412
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3906
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_REENVIO_GASTO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Oscar Diestre-Versión inicial (20190412)
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE       SP_EXT_REENVIO_GASTO (
         GPV_NUM_GASTO_HAYA IN  REM01.RSR_REGISTRO_SQLS.RSR_SALIDA_LOG%TYPE,
         V_USUARIO       VARCHAR2 DEFAULT 'SP_EXT_REENVIO_GASTO',
         COD_RETORNO    OUT NUMBER
) AS

--

-- GPV_NUM_GASTO_HAYA se utiliza en una expresión de tipo 'IN' con lo que puede
-- ponerse 1 o múltiples identificadores separados por ',', con limite de 400		
V_SQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 								-- Configuracion Esquema.
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN

       COD_RETORNO := 0;

	V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.GGE_GASTOS_GESTION T1 USING
(
    SELECT GPV.GPV_ID
    FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
    JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN (  ' || GPV_NUM_GASTO_HAYA || '  )


)T2 ON (T1.GPV_ID = T2.GPV_ID)
WHEN MATCHED THEN
UPDATE
SET T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM  ' || V_ESQUEMA || '.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03''),
    T1.GGE_FECHA_EAH = SYSDATE,
    T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM  ' || V_ESQUEMA || '.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''01''),
    T1.GGE_FECHA_EAP = NULL,
    T1.GGE_MOTIVO_RECHAZO_PROP = NULL,
    T1.GGE_FECHA_ENVIO_PRPTRIO = NULL,
    T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''',
    T1.FECHAMODIFICAR = SYSDATE';

        EXECUTE IMMEDIATE V_SQL;    

    	  DBMS_OUTPUT.PUT_LINE('[INFO] - Modificados '||SQL%ROWCOUNT||' registro/s en la GGE_GASTOS_GESTION.');




	V_SQL := '
	MERGE INTO ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR T1 USING
(
    SELECT GPV.GPV_ID
    FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
    JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN (  ' || GPV_NUM_GASTO_HAYA || '  )
)T2 ON (T1.GPV_ID = T2.GPV_ID) 
WHEN MATCHED THEN
        UPDATE
        SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  ' || V_ESQUEMA || '.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''03''),
            T1.PRG_ID = NULL,
    	    T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''',
            T1.FECHAMODIFICAR = SYSDATE';

        EXECUTE IMMEDIATE V_SQL;    

    	  DBMS_OUTPUT.PUT_LINE('[INFO] - Modificados '||SQL%ROWCOUNT||' registro/s en la GPV_GASTOS_PROVEEDOR.');
    	  DBMS_OUTPUT.PUT_LINE('[INFO] - Reenviados ' ||SQL%ROWCOUNT||' gasto/s.');          


   COMMIT;

       COD_RETORNO := 1;


EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ERR_NUM := SQLCODE;
      RAISE;
END SP_EXT_REENVIO_GASTO;
/
EXIT
