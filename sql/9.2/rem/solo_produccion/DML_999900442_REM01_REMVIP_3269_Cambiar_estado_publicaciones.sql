--/*
--#########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20190204
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3269
--## PRODUCTO=NO
--## 
--## Finalidad: Cambio 
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
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	


BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO ');
      
 
      V_SENTENCIA := '

    MERGE INTO REM01.ACT_APU_ACTIVO_PUBLICACION T1 USING
(
select act.act_id,ACT.ACT_NUM_ACTIVO, APU.DD_TCO_ID,apu.APU_CHECK_OCULTAR_V, apu.APU_CHECK_OCULTAR_A,apu.DD_EPV_ID APU_ESTADO
from rem01.act_activo act
join REM01.ACT_APU_ACTIVO_PUBLICACION apu on apu.act_id = act.act_id
join REM01.AUX_ICC_REMVIP_3269 aux on aux.activo = act.act_num_activo
WHERE apu.DD_EPV_ID = 1 


)T2 ON (T1.act_ID = T2.act_ID) 
WHEN MATCHED THEN
        UPDATE
        SET 
            T1.APU_CHECK_PUBLICAR_V = 1,
            T1.DD_EPV_ID = 4,
            T1.USUARIOMODIFICAR = ''REMVIP-3269'',
            T1.FECHAMODIFICAR = SYSDATE 

        ';


      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CAMBIADAS  '||SQL%ROWCOUNT||' Filas.');
   

      V_SENTENCIA := '

MERGE INTO REM01.ACT_AHP_HIST_PUBLICACION T1 USING
(
    SELECT act_id, ahp_id FROM (
    select act.act_id, ahp.ahp_id,ACT.ACT_NUM_ACTIVO, APU.DD_TCO_ID,apu.APU_CHECK_OCULTAR_V, apu.APU_CHECK_OCULTAR_A,apu.DD_EPV_ID APU_ESTADO, AHP.DD_EPv_ID HIST_ESTADO,
    ROW_NUMBER() OVER (PARTITION BY act.ACT_ID ORDER BY AHP.AHP_ID DESC) RN
    from rem01.act_activo act
    join REM01.AUX_ICC_REMVIP_3269 aux on aux.activo = act.act_num_activo
    join REM01.ACT_APU_ACTIVO_PUBLICACION apu on apu.act_id = act.act_id
    JOIN REM01.ACT_AHP_HIST_PUBLICACION AHP ON AHP.ACT_ID = ACT.ACT_ID AND AHP.BORRADO = 0
    WHERE AHP.DD_EPV_ID = 1 
    )WHERE RN = 1

)T2 ON (T1.ahp_ID = T2.ahp_ID) 
WHEN MATCHED THEN
        UPDATE
        SET 
            T1.AHP_CHECK_PUBLICAR_V = 1,
            T1.DD_EPV_ID = 4,
            T1.USUARIOMODIFICAR = ''REMVIP-3269'',
            T1.FECHAMODIFICAR = SYSDATE

        ';


      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CAMBIADAS  '||SQL%ROWCOUNT||' Filas.');
    
   
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
