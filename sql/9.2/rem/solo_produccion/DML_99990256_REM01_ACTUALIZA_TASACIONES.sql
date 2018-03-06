--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20180306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-177
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza la tabla de tasaciones a partir del fichero de UVEM (actualización inicial)
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';--'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';--'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIOMOD VARCHAR2(50 CHAR):= 'REMVIP-177';

    
BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]: Actualización tasaciones');  
  
  DBMS_OUTPUT.PUT_LINE('[INFO]: Se crean las tablas backup');
  
          
  EXECUTE IMMEDIATE 'CREATE TABLE REM01.TMP_REMVIP177_BIE_VALORACIONES as
                     select * from REM01.BIE_VALORACIONES';          

  EXECUTE IMMEDIATE 'CREATE TABLE REM01.TMP_REMVIP177_ACT_TAS_TASACION as
                     select * from REM01.ACT_TAS_TASACION';                     
    
  DBMS_OUTPUT.PUT_LINE('[INFO]: Tablas backup creadas');
  
  
  DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos la tabla BIE_VALORACIONES a partir de la tabla APR_AUX_TAS_TASACIONES');  
  
  EXECUTE IMMEDIATE 'MERGE INTO  REM01.BIE_VALORACIONES VAL_OLD USING 
       (
         select TAS.BIE_VAL_ID
               , AUX.FECHA_TASACION
               , AUX.IMP_VALOR_TASACION
            from REM01.ACT_TAS_TASACION TAS
            inner join REM01.act_activo act on tas.act_id = act.ACT_ID
            inner join REM01.APR_AUX_TAS_TASACIONES AUX on TAS.TAS_ID_EXTERNO = AUX.NUM_IDENTIF_TASACION and act.act_num_activo_uvem = AUX.IDENTIFICADOR_ACTIVO_ESPECIAL
       ) VAL_NEW ON (VAL_NEW.BIE_VAL_ID = VAL_OLD.BIE_VAL_ID)
      WHEN MATCHED THEN UPDATE SET 
          VAL_OLD.BIE_FECHA_VALOR_TASACION   = VAL_NEW.FECHA_TASACION
        , VAL_OLD.BIE_IMPORTE_VALOR_TASACION = VAL_NEW.IMP_VALOR_TASACION
        , VAL_OLD.USUARIOMODIFICAR           = ''REMVIP-177''
        , VAL_OLD.FECHAMODIFICAR             = sysdate';
                
  
  DBMS_OUTPUT.PUT_LINE('[INFO]: Tabla BIE_VALORACIONES actualizada. '||SQL%ROWCOUNT||'  registros ');  

  
  DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos la tabla ACT_TAS_TASACION a partir de la tabla APR_AUX_TAS_TASACIONES');  

  EXECUTE IMMEDIATE 'MERGE INTO  REM01.ACT_TAS_TASACION TAS_OLD USING 
       (
          select TAS.TAS_ID
               , tts.DD_TTS_ID
               , AUX.FECHA_TASACION
               , AUX.CODIGO_FIRMA_TASADORA
               , AUX.FIRMA_TASADORA
               , AUX.IMP_VALOR_TASACION
               , AUX.PORCENTAJE_OBRA
          from REM01.ACT_TAS_TASACION TAS
          inner join REM01.act_activo act on tas.act_id = act.ACT_ID          
          inner join REM01.APR_AUX_TAS_TASACIONES AUX on TAS.TAS_ID_EXTERNO = AUX.NUM_IDENTIF_TASACION  
                 and act.act_num_activo_uvem = AUX.IDENTIFICADOR_ACTIVO_ESPECIAL
          INNER JOIN REM01.DD_EQV_BANKIA_REM EQV ON EQV.DD_CODIGO_BANKIA = NVL(aux.TIPO_TASACION, ''00'')
          INNER JOIN REM01.dd_tts_tipo_tasacion tts ON tts.dd_tts_codigo = EQV.DD_CODIGO_REM
          WHERE EQV.DD_NOMBRE_BANKIA = ''DD_TASACION_BANKIA''
            AND EQV.DD_NOMBRE_REM = ''DD_TTS_TIPO_TASACION''
       ) TAS_NEW ON (TAS_NEW.TAS_ID = TAS_OLD.TAS_ID)
 WHEN MATCHED THEN UPDATE SET 
        TAS_OLD.DD_TTS_ID                    = TAS_NEW.DD_TTS_ID
      , TAS_OLD.TAS_FECHA_RECEPCION_TASACION = TAS_NEW.FECHA_TASACION
      , TAS_OLD.TAS_CODIGO_FIRMA             = TAS_NEW.CODIGO_FIRMA_TASADORA
      , TAS_OLD.TAS_NOMBRE_TASADOR           = TAS_NEW.FIRMA_TASADORA
      , TAS_OLD.TAS_IMPORTE_TAS_FIN          = TAS_NEW.IMP_VALOR_TASACION
      , TAS_OLD.TAS_PORCENTAJE_OBRA          = TAS_NEW.PORCENTAJE_OBRA
      , TAS_OLD.USUARIOMODIFICAR             = ''REMVIP-177''
      , TAS_OLD.FECHAMODIFICAR               = sysdate';
  
  DBMS_OUTPUT.PUT_LINE('[INFO]: Tabla ACT_TAS_TASACION actualizada. '||SQL%ROWCOUNT||'  registros ');  
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]: Actualización tasaciones');    
  
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

EXIT;