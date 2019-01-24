--/*
--#########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20190125
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3147
--## PRODUCTO=NO
--## 
--## Finalidad: Cambio publicaciones
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
           SELECT ACT.ACT_ID
        FROM REM01.ACT_ACTIVO ACT
        JOIN REM01.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID and apu.borrado = 0
        JOIN REM01.ACT_AHP_HIST_PUBLICACION AHP ON AHP.ACT_ID = APU.ACT_ID
        JOIN REM01.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID 
        JOIN REM01.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = APU.DD_EPA_ID 
        WHERE APU.USUARIOCREAR LIke ''%APR_MAIN_ACTIVES_POST%'' and act.borrado = 0 AND (APU_CHECK_PUBLICAR_V = 1  OR APU_CHECK_PUBLICAR_A = 1)
        AND (APU.DD_EPV_ID = (SELECT DD_EPV_ID FROM REM01.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = ''01'') OR APU.DD_EPA_ID = (SELECT DD_EPA_ID FROM REM01.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''01''))
     
        )T2 ON (T1.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN
        UPDATE
            SET
            T1.APU_CHECK_PUBLICAR_V = 0,
            T1.APU_CHECK_PUBLICAR_A = 0,
            T1.USUARIOMODIFICAR = ''REMVIP-3147'',
            T1.FECHAMODIFICAR = SYSDATE;

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
