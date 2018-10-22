--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180927
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1973
--## PRODUCTO=SI
--## Finalidad: Se reasignan los gestores de formalizacion (GFORM) para expedientes comerciales de Giants.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
--set serveroutput on size 1000000;


DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR) := 'REM01';				-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := 'REMMASTER';		-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1973';
    V_SQL VARCHAR2(4000 CHAR); 
    ERR_NUM NUMBER;										-- Numero de errores
    ERR_MSG VARCHAR2(2048);							    -- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_ECO_ID                        NUMBER(16) := -1;
    V_GEE_ID                        NUMBER(16) := -1;
    V_GEH_ID                        NUMBER(16) := -1;
    V_GEH_ID_NUEVA                  NUMBER(16) := -1;
    V_ACT_ID                        NUMBER(16) := -1;
    V_NUM                           NUMBER(16) := 0;

BEGIN

    For cosa IN (SELECT DISTINCT ECO.ECO_ID ECO_ID
            FROM REM01.ACT_ACTIVO ACT
            JOIN REM01.DD_CRA_CARTERA CRA
              ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
            JOIN REM01.ACT_OFR    AOF
              ON AOF.ACT_ID = ACT.ACT_ID
            JOIN REM01.OFR_OFERTAS OFR
              ON OFR.OFR_ID = AOF.OFR_ID
            JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
              ON ECO.OFR_ID = OFR.OFR_ID
            JOIN REM01.GCO_GESTOR_ADD_ECO GCO
              ON GCO.ECO_ID = ECO.ECO_ID
            JOIN REM01.GEE_GESTOR_ENTIDAD GEE
              ON GEE.GEE_ID = GCO.GEE_ID
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE
              ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
            JOIN REMMASTER.USU_USUARIOS USU
              ON USU.USU_ID = GEE.USU_ID
            WHERE TGE.DD_TGE_CODIGO IN ('GFORM')
              AND CRA.DD_CRA_CODIGO = '12'
              AND ACT.BORRADO = 0
              AND OFR.BORRADO = 0
              AND ECO.BORRADO = 0
              AND GEE.BORRADO = 0)
    LOOP
        V_ECO_ID := cosa.ECO_ID;
        --V_ACT_ID := cosa.ACT_ID;
        --DBMS_OUTPUT.PUT_LINE('ECO '||V_ECO_ID);
        --DBMS_OUTPUT.PUT_LINE('Hola '||V_ECO_ID);
        
        V_NUM := V_NUM + 1;
       
        EXECUTE IMMEDIATE  
                    'SELECT GEH.GEH_ID 
                    FROM REM01.GCH_GESTOR_ECO_HISTORICO GCH
                    JOIN REM01.GEH_GESTOR_ENTIDAD_HIST GEH
                      ON GCH.GEH_ID = GEH.GEH_ID
                    JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE
                      ON TGE.DD_TGE_ID = GEH.DD_TGE_ID
                    WHERE GCH.ECO_ID ='||V_ECO_ID||'
                      AND TGE.DD_TGE_CODIGO = ''GFORM'' 
                      AND Geh.Geh_Fecha_Hasta IS NULL'      
        INTO V_GEH_ID; 
            
        EXECUTE IMMEDIATE 
                   'UPDATE REM01.GEH_GESTOR_ENTIDAD_HIST GEH
                    SET 
                        GEH.GEH_FECHA_HASTA = SYSDATE,
                        GEH.USUARIOMODIFICAR = ''REMVIP-1973'',
                        GEH.FECHAMODIFICAR = SYSDATE
                    WHERE GEH.GEH_ID = '||V_GEH_ID;
    
        EXECUTE IMMEDIATE 
                   'SELECT REM01.S_GEE_GESTOR_ENTIDAD.NEXTVAL FROM DUAL' 
        INTO V_GEE_ID;
        
        EXECUTE IMMEDIATE 
                   'SELECT REM01.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL FROM DUAL' 
        INTO V_GEH_ID_NUEVA;
        
        EXECUTE IMMEDIATE 
                   'SELECT DISTINCT ACT.ACT_ID
                    FROM REM01.ACT_ACTIVO ACT
                    JOIN REM01.DD_CRA_CARTERA CRA
                      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                    JOIN REM01.ACT_OFR    AOF
                      ON AOF.ACT_ID = ACT.ACT_ID
                    JOIN REM01.OFR_OFERTAS OFR
                      ON OFR.OFR_ID = AOF.OFR_ID
                    JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                      ON ECO.OFR_ID = OFR.OFR_ID
                    WHERE CRA.DD_CRA_CODIGO = ''12'' AND 
                    ECO.ECO_ID = '||V_ECO_ID||' AND ROWNUM = 1'
        INTO V_ACT_ID;
        
        
        EXECUTE IMMEDIATE 
                   'INSERT INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE (GEE_ID, USU_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR, BORRADO)
                    SELECT
                        '||V_GEE_ID||',
                        (SELECT REM01.CALCULAR_USUARIO_GFORM('||V_ACT_ID||') FROM DUAL),
                        (SELECT DD_TGE_ID FROM REMMASTER.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''GFORM''),
                        ''REMVIP-1973'',
                        SYSDATE,
                        0
                    FROM DUAL';    
                    
        EXECUTE IMMEDIATE 
                   'INSERT INTO '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO (GEE_ID, ECO_ID)
                    SELECT
                        '||V_GEE_ID||',
                        '||V_ECO_ID||'
                    FROM DUAL';
        
        EXECUTE IMMEDIATE 
                   'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH (GEH_ID, USU_ID, DD_TGE_ID, GEH_FECHA_DESDE, GEH_FECHA_HASTA, USUARIOCREAR, FECHACREAR, BORRADO)
                    SELECT
                        '||V_GEH_ID_NUEVA||',
                        (SELECT REM01.CALCULAR_USUARIO_GFORM('||V_ACT_ID||') FROM DUAL),
                        (SELECT DD_TGE_ID FROM REMMASTER.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''GFORM''),
                        SYSDATE,
                        NULL,
                        ''REMVIP-1973'',
                        SYSDATE,
                        0
                    FROM DUAL';   
		 
         
         EXECUTE IMMEDIATE 
                   'INSERT INTO '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO GCH (GEH_ID, ECO_ID)
                    SELECT
                        '||V_GEH_ID_NUEVA||',
                        '||V_ECO_ID||'
                    FROM DUAL';    
		 

    END LOOP;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se añaden '||V_NUM||' gestores de formalización (GFORM) nuevos.');
	
	EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD COMPUTE STATISTICS');
	EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO COMPUTE STATISTICS');
	EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST COMPUTE STATISTICS');
	EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO COMPUTE STATISTICS');
	
    COMMIT;

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
