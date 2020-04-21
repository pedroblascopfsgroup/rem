--/*
--######################################### 
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200411
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6936
--## PRODUCTO=NO
--## 
--## Finalidad: Posicionamiento de trabajos.
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
            
    V_JBV T_ARRAY_JBV := T_ARRAY_JBV( 
        T_JBV(6001504),
        T_JBV(6001935),
        T_JBV(6002324),
        T_JBV(6002589),
        T_JBV(6004573),
        T_JBV(6004691),
        T_JBV(6004766),
        T_JBV(6004975),
        T_JBV(6005072),
        T_JBV(6005393),
        T_JBV(6005497),
        T_JBV(6005498),
        T_JBV(6005621),
        T_JBV(6005897),
        T_JBV(6006020),
        T_JBV(6006061),
        T_JBV(6006104),
        T_JBV(6006320),
        T_JBV(6006564),
        T_JBV(6006712),
        T_JBV(6006865),
        T_JBV(6006908),
        T_JBV(6006941),
        T_JBV(6007013),
        T_JBV(6007135),
        T_JBV(6007337),
        T_JBV(6007405),
        T_JBV(6007599),
        T_JBV(6007606),
        T_JBV(6007607),
        T_JBV(6007648),
        T_JBV(6007693),
        T_JBV(6007894),
        T_JBV(6007944),
        T_JBV(6007963),
        T_JBV(6007971),
        T_JBV(6008010),
        T_JBV(6008030),
        T_JBV(6008034),
        T_JBV(6008075),
        T_JBV(6008133),
        T_JBV(6008169),
        T_JBV(6008257),
        T_JBV(6008320),
        T_JBV(6008414),
        T_JBV(6008449),
        T_JBV(6008468),
        T_JBV(6008522),
        T_JBV(6008524),
        T_JBV(6008546),
        T_JBV(6008549),
        T_JBV(6008562),
        T_JBV(6008590),
        T_JBV(6008599),
        T_JBV(6008664),
        T_JBV(6008666),
        T_JBV(6008682),
        T_JBV(6008703),
        T_JBV(6008714),
        T_JBV(6008716),
        T_JBV(6008731),
        T_JBV(6008733),
        T_JBV(6008750),
        T_JBV(6008837),
        T_JBV(6008900),
        T_JBV(6008917),
        T_JBV(6008935),
        T_JBV(6008954),
        T_JBV(6009016),
        T_JBV(6009100),
        T_JBV(6009103),
        T_JBV(6009168),
        T_JBV(6009174),
        T_JBV(6009247),
        T_JBV(6009248),
        T_JBV(6009256),
        T_JBV(6009394),
        T_JBV(6009535),
        T_JBV(6009575),
        T_JBV(6009716),
        T_JBV(6009718),
        T_JBV(6009916),
        T_JBV(6010157),
        T_JBV(6010662),
        T_JBV(6010726),
        T_JBV(6011249),
        T_JBV(6011288),
        T_JBV(6011318),
        T_JBV(6011451),
        T_JBV(6011522),
        T_JBV(6011526),
        T_JBV(6011587),
        T_JBV(6011779),
        T_JBV(6011820),
        T_JBV(6011892),
        T_JBV(6011982),
        T_JBV(6012025),
        T_JBV(6012062),
        T_JBV(6012066),
        T_JBV(6012101),
        T_JBV(6012123),
        T_JBV(6012142),
        T_JBV(6012233),
        T_JBV(6012243),
        T_JBV(6012255),
        T_JBV(6012273),
        T_JBV(6012274),
        T_JBV(6012290),
        T_JBV(6012361),
        T_JBV(6012366),
        T_JBV(6012410),
        T_JBV(6012415),
        T_JBV(6012428),
        T_JBV(6012430),
        T_JBV(6012451),
        T_JBV(6012476),
        T_JBV(6012487),
        T_JBV(6012491),
        T_JBV(6012580),
        T_JBV(6012665),
        T_JBV(6012755),
        T_JBV(6012761),
        T_JBV(6012767),
        T_JBV(6012771),
        T_JBV(6012817),
        T_JBV(6012857),
        T_JBV(6012994)
	);
	V_TMP_JBV T_JBV;

BEGIN	

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
    
    V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL
                SET ECO_ESTADO_PBC = 1
                    ,USUARIOMODIFICAR = ''REMVIP-6936''
                    ,FECHAMODIFICAR = SYSDATE
                WHERE OFR_ID = (
                    SELECT OFR_ID 
                    FROM '||V_ESQUEMA||'.OFR_OFERTAS
                    WHERE OFR_NUM_OFERTA = '||TRIM(V_TMP_JBV(1))||'
                )';
    
	EXECUTE IMMEDIATE V_SQL;
	
	END LOOP;
    
    V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL T1
                SET ECO_ESTADO_PBC = 1
                    ,USUARIOMODIFICAR = ''REMVIP-6936''
                    ,FECHAMODIFICAR = SYSDATE
                WHERE EXISTS (
                    SELECT DISTINCT OFR.OFR_ID 
                    FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                    JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID
                    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''07''
                    JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.DD_SCR_CODIGO IN (''151'', ''152'')
                    JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
                    JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.DD_EEC_CODIGO IN (''03'', ''08'')
                    WHERE T1.ECO_ID = ECO.ECO_ID
                )';
    
	EXECUTE IMMEDIATE V_SQL;
		
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