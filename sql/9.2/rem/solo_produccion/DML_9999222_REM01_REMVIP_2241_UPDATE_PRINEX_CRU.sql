--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20181013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2236
--## PRODUCTO=NO
--##
--## Finalidad: FUSION CCM TO LIBERBANK
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
DBMS_OUTPUT.put_line('[FUSION CCM TO LIBERBANK] SCRIPT DE FUSIÓN');

DBMS_OUTPUT.put_line('[1] Cambiar BIE_DREG_CRU');



V_SQL := 'MERGE INTO '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES DESTINO
          USING (
              SELECT BIE.BIE_ID, AUX.IDUFIR 
              FROM '||V_ESQUEMA||'.AUX_CAMBIO_IDUFIR AUX
              JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_AAII
              JOIN '||V_ESQUEMA||'.BIE_BIEN BIE ON BIE.BIE_ID = ACT.BIE_ID  
              JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES REG ON REG.BIE_ID = BIE.BIE_ID
          ) ORIGEN
          ON (DESTINO.BIE_ID = ORIGEN.BIE_ID)
          WHEN MATCHED THEN
          UPDATE SET DESTINO.BIE_DREG_CRU = ORIGEN.IDUFIR,
                     DESTINO.USUARIOMODIFICAR = ''REMVIP-2241'',
                     DESTINO.FECHAMODIFICAR = SYSDATE';
          EXECUTE IMMEDIATE V_SQL;


DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla BIE_DATOS_REGISTRALES');




DBMS_OUTPUT.put_line('[2] Cambiar ACT_NUM_ACTIVO_PRINEX');


V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO DESTINO
          USING (
              SELECT ACT.ACT_NUM_ACTIVO, AUX.ID_PRINEX
              FROM '||V_ESQUEMA||'.AUX_CAMBIO_PRINEX AUX
              JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_ACTIVO_HAYA
          ) ORIGEN
          ON (DESTINO.ACT_NUM_ACTIVO = ORIGEN.ACT_NUM_ACTIVO)
          WHEN MATCHED THEN
          UPDATE SET DESTINO.ACT_NUM_ACTIVO_PRINEX = ORIGEN.ID_PRINEX,
                     DESTINO.USUARIOMODIFICAR = ''REMVIP-2241'',
                     DESTINO.FECHAMODIFICAR = SYSDATE';
EXECUTE IMMEDIATE V_SQL;


DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla ACT_ACTIVO');




 COMMIT;  

EXCEPTION
     WHEN OTHERS THEN
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

