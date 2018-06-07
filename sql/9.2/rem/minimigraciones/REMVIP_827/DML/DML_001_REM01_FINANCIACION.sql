--/*
--#########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20180226
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.14
--## INCIDENCIA_LINK=REMVIP-827
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

    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; 			--REM01
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; 	--REMMASTER
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-827';
    V_TABLA_MIG VARCHAR2(40 CHAR) := 'AUX_REMVIP_FINANCIACION';
    V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    EXECUTE IMMEDIATE 'MERGE INTO REM01.COE_CONDICIONANTES_EXPEDIENTE T1
                       USING (select distinct coe.coe_id
                                   , upper(aux.DESC_ENTIDAD_FINANCIADORA) as DESC_ENTIDAD_FINANCIADORA
                               from rem01.ofr_ofertas ofr
                               join REM01.ECO_EXPEDIENTE_COMERCIAL eco      on ofr.ofr_id = eco.ofr_id
                               join REM01.COE_CONDICIONANTES_EXPEDIENTE coe on eco.eco_id = coe.eco_id
                               join REM01.AUX_REMVIP_FINANCIACION aux       on aux.ID_OFERTA_REM = ofr.OFR_NUM_OFERTA
                               where upper(coe.COE_ENTIDAD_FINANCIACION_AJENA) not like ''%BANKIA%''
                                  or coe.COE_ENTIDAD_FINANCIACION_AJENA is null
                       ) T2
		ON (T1.COE_ID = T2.COE_ID)
		WHEN MATCHED THEN UPDATE SET
			T1.COE_SOLICITA_FINANCIACION = 1
                      , T1.COE_ENTIDAD_FINANCIACION_AJENA = T2.DESC_ENTIDAD_FINANCIADORA
		      , T1.USUARIOMODIFICAR = ''REMVIP-827''
		      , T1.FECHAMODIFICAR = SYSDATE';
		      
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||SQL%ROWCOUNT||' registros de COE_CONDICIONANTES_EXPEDIENTES actualizados.');


    EXECUTE IMMEDIATE 'MERGE INTO REM01.FOR_FORMALIZACION T1
                       USING (select ffor.for_id
                                   , eco.eco_id
                                   , aux.NM_RIESGO_FINANCIACION as FOR_NUMEXPEDIENTE
                                   , sum(to_number(aux.IMP_FINANCIACION_VENTA ) / 100) as FOR_CAPITALCONCEDIDO
                              from rem01.ofr_ofertas ofr
                              join REM01.ECO_EXPEDIENTE_COMERCIAL eco on ofr.ofr_id = eco.ofr_id
                              left join REM01.FOR_FORMALIZACION ffor       on eco.eco_id = ffor.eco_id
                              join REM01.AUX_REMVIP_FINANCIACION aux  on aux.ID_OFERTA_REM = ofr.OFR_NUM_OFERTA
                              group by ffor.for_id
                                   , eco.eco_id                              
                                   , aux.NM_RIESGO_FINANCIACION
                       ) T2
                ON (T1.FOR_ID = T2.FOR_ID)
                WHEN MATCHED THEN UPDATE SET
                        T1.FOR_NUMEXPEDIENTE = T2.FOR_NUMEXPEDIENTE
                      , T1.FOR_CAPITALCONCEDIDO = T2.FOR_CAPITALCONCEDIDO
                      , T1.USUARIOMODIFICAR = ''REMVIP-827''
                      , T1.FECHAMODIFICAR = SYSDATE
                WHEN NOT MATCHED THEN INSERT (FOR_ID, ECO_ID, VERSION, USUARIOCREAR, FECHACREAR, FOR_NUMEXPEDIENTE, FOR_CAPITALCONCEDIDO)
                       VALUES ( REM01.S_FOR_FORMALIZACION.nextval
                               , T2.eco_id
                               , 0 
                               , ''REMVIP-827''
                               , sysdate
                               , T2.FOR_NUMEXPEDIENTE
                               , T2.FOR_CAPITALCONCEDIDO)'
                      ;
                      
    DBMS_OUTPUT.PUT_LINE('      [INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||SQL%ROWCOUNT||' registros de FOR_FORMALIZACION actualizados.');
    
    
        
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
EXIT;
