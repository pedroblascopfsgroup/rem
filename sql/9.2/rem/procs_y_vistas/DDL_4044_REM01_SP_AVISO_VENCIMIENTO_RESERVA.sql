--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170807
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.7
--## INCIDENCIA_LINK=HREOS-2339
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de inserción de notificaciones en MNO
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
DBMS_OUTPUT.PUT_LINE('[INFO] Función PROCEDURE AVISO_VENCIMIENTO_RESERVA: INICIANDO...');   	 
EXECUTE IMMEDIATE '
		
  CREATE OR REPLACE PROCEDURE '||V_ESQUEMA||'.AVISO_VENCIMIENTO_RESERVA IS

  ERR_NUM NUMBER;-- Numero de errores
  ERR_MSG VARCHAR2(2048);-- Mensaje de error

BEGIN
    
    INSERT INTO REM01.MNO_MAESTRO_NOTIFICACIONES (MNO_ID,DD_EIN_ID,DD_TNO_ID,EIN_ID,DD_STA_ID,TAR_TAREA,TAR_DESCRIPCION,TAR_ID_DEST,FECHA_NOTIFICACION)
    SELECT REM01.S_MNO_MAESTRO_NOTIFICACIONES.NEXTVAL, EIN.DD_EIN_ID, TNO.DD_TNO_ID, ACT.ACT_ID, STA.DD_STA_ID, ''Aviso''
        , CONCAT(''Vencimiento reserva próximo. Verifique la situación de la firma de la reserva y, en su caso, solicite ampliación de plazo, reflejando la nueva fecha de vencimiento en el expediente comercial número: '', ECO.ECO_NUM_EXPEDIENTE)
        , USU.USU_ID, SYSDATE
    FROM RES_RESERVAS RES
    JOIN DD_ERE_ESTADOS_RESERVA ERE ON RES.DD_ERE_ID = ERE.DD_ERE_ID
    JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID
    JOIN OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID
    JOIN ACT_OFR ACTOFR ON ACTOFR.OFR_ID = OFR.OFR_ID
    JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = ACTOFR.ACT_ID AND ACT.BORRADO = 0
    JOIN GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACTOFR.ACT_ID
    JOIN GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
    JOIN REMMASTER.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID
    JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
    JOIN REMMASTER.DD_EIN_ENTIDAD_INFORMACION EIN ON EIN.DD_EIN_CODIGO = ''61''
    JOIN REMMASTER.DD_TNO_TIPO_NOTIFICACION TNO ON TNO.DD_TNO_CODIGO = ''AVI_VENC''
    JOIN REMMASTER.DD_STA_SUBTIPO_TAREA_BASE STA ON STA.DD_STA_CODIGO = ''701''
    WHERE ERE.DD_ERE_CODIGO = ''02'' AND TGE.DD_TGE_CODIGO in (''GCOM'', ''GESRES'') AND OFR.AGR_ID IS NULL
        AND TRUNC(RES_FECHA_VENCIMIENTO)-TRUNC(SYSDATE) < 10 AND TRUNC(RES_FECHA_VENCIMIENTO) > TRUNC(SYSDATE)
        AND NOT EXISTS (SELECT 1 FROM REM01.MNO_MAESTRO_NOTIFICACIONES AUX WHERE AUX.EIN_ID = ACT.ACT_ID AND AUX.TAR_ID_DEST = USU.USU_ID
            AND AUX.TAR_DESCRIPCION = CONCAT(''Vencimiento reserva próximo. Verifique la situación de la firma de la reserva y, en su caso, solicite ampliación de plazo, reflejando la nueva fecha de vencimiento en el expediente comercial número: '', ECO.ECO_NUM_EXPEDIENTE));

    INSERT INTO MNO_MAESTRO_NOTIFICACIONES (MNO_ID,DD_EIN_ID,DD_TNO_ID,EIN_ID,DD_STA_ID,TAR_TAREA,TAR_DESCRIPCION,TAR_ID_DEST,FECHA_NOTIFICACION)
    SELECT REM01.S_MNO_MAESTRO_NOTIFICACIONES.NEXTVAL, EIN.DD_EIN_ID, TNO.DD_TNO_ID, ACT.ACT_ID, STA.DD_STA_ID, ''Aviso''
        , CONCAT(''Vencimiento reserva próximo. Verifique la situación de la firma de la reserva y, en su caso, solicite ampliación de plazo, reflejando la nueva fecha de vencimiento en el expediente comercial número: '', ECO.ECO_NUM_EXPEDIENTE)
        , LCO.LCO_GESTOR_COMERCIAL, SYSDATE
    FROM RES_RESERVAS RES
    JOIN DD_ERE_ESTADOS_RESERVA ERE ON RES.DD_ERE_ID = ERE.DD_ERE_ID
    JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID
    JOIN OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID
    JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = OFR.AGR_ID AND AGR.BORRADO = 0
    JOIN ACT_LCO_LOTE_COMERCIAL LCO ON LCO.AGR_ID = AGR.AGR_ID
    JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID AND AGA.BORRADO = 0
    JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND ACT.BORRADO = 0
    JOIN REMMASTER.DD_EIN_ENTIDAD_INFORMACION EIN ON EIN.DD_EIN_CODIGO = ''61''
    JOIN REMMASTER.DD_TNO_TIPO_NOTIFICACION TNO ON TNO.DD_TNO_CODIGO = ''AVI_VENC''
    JOIN REMMASTER.DD_STA_SUBTIPO_TAREA_BASE STA ON STA.DD_STA_CODIGO = ''701''
    WHERE ERE.DD_ERE_CODIGO = ''02'' AND TRUNC(RES_FECHA_VENCIMIENTO)-TRUNC(SYSDATE) < 10
        AND TRUNC(RES_FECHA_VENCIMIENTO) > TRUNC(SYSDATE) AND LCO.LCO_GESTOR_COMERCIAL IS NOT NULL
        AND NOT EXISTS (SELECT 1 FROM REM01.MNO_MAESTRO_NOTIFICACIONES AUX WHERE AUX.EIN_ID = ACT.ACT_ID AND AUX.TAR_ID_DEST = LCO.LCO_GESTOR_COMERCIAL
            AND AUX.TAR_DESCRIPCION = CONCAT(''Vencimiento reserva próximo. Verifique la situación de la firma de la reserva y, en su caso, solicite ampliación de plazo, reflejando la nueva fecha de vencimiento en el expediente comercial número: '', ECO.ECO_NUM_EXPEDIENTE));

    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(''[ERROR] Se ha producido un error en la ejecución:''||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.PUT_LINE(''-----------------------------------------------------------'');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
        RAISE;

END;';
  
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Function creada.');
	
COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
