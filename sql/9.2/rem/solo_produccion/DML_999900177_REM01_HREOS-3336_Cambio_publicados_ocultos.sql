--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20171126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3336
--## PRODUCTO=NO
--##
--## Finalidad: Script cambio activos publicados ocultos a despublicados
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
 
BEGIN   

DBMS_OUTPUT.PUT_LINE('[INICIO] PROCESO cambio despublicados ocultos');

DBMS_OUTPUT.PUT_LINE('Actualizamos registros existentes en la HEP con fecha hasta');

MERGE INTO REM01.ACT_HEP_HIST_EST_PUBLICACION HEP_OLD
USING (
       select aux.act_id
       from ACT_PUBLIOCULTO_SINCOND_BANKIA aux
       join REM01.ACT_HEP_HIST_EST_PUBLICACION hep on aux.ACT_ID = hep.act_id
       where hep.hep_fecha_hasta is null
) HEP_NEW 
ON (HEP_OLD.ACT_ID = HEP_NEW.ACT_ID)
WHEN MATCHED THEN UPDATE 
SET HEP_OLD.hep_fecha_hasta = sysdate
--,   HEP_OLD.HEP_MOTIVO ='Actualización masiva PFS'
,   HEP_OLD.USUARIOMODIFICAR = 'HREOS-3336'
,   HEP_OLD.FECHAMODIFICAR = sysdate
 where HEP_OLD.hep_fecha_hasta is null
 ;


    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' registros actualizados ACT_HEP_HIST_EST_PUBLICACION informamos FECHA_HASTA.');

DBMS_OUTPUT.PUT_LINE('Se inserta una nueva línea en la HEP con HEP_FECHA_HASTA y HEP_FECHA_DESDE a sysdate y el estado de la publicación a "Publicado"');

INSERT INTO REM01.ACT_HEP_HIST_EST_PUBLICACION HEP (
               HEP_ID
              ,ACT_ID
              ,HEP_FECHA_DESDE
              ,HEP_FECHA_HASTA
              ,DD_POR_ID
              ,DD_TPU_ID
              ,DD_EPU_ID
              ,HEP_MOTIVO
              ,VERSION
              ,USUARIOCREAR
              ,FECHACREAR
              ,BORRADO
          )
          SELECT
            REM01.S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL                AS HEP_ID,
            HEP_OLD.ACT_ID                                              AS ACT_ID,
            sysdate                                                     AS HEP_FECHA_DESDE,
            sysdate                                                     AS HEP_FECHA_HASTA,
            CASE WHEN AUX.CONDICIONADO = 0 THEN 
                     (select dd_por_id from rem01.dd_por_portal where dd_por_codigo = '01')  
                  WHEN AUX.CONDICIONADO > 0 THEN 
                      (select dd_por_id from rem01.dd_por_portal where dd_por_codigo = '02') 
            ELSE NULL 
            END AS DD_POR_ID,
            HEP_OLD.DD_TPU_ID                                            AS DD_TPU_ID,
            (select dd_epu_id from rem01.dd_epu_estado_publicacion where dd_epu_codigo = '01')            AS DD_EPU_ID,
            'Actualización masiva PFS'                                  AS HEP_MOTIVO,
            0                                                           AS VERSION,
            'HREOS-3336'                                                AS USUARIOCREAR,
            SYSDATE                                                     AS FECHACREAR,
            0                                                           AS BORRADO
          FROM REM01.ACT_HEP_HIST_EST_PUBLICACION HEP_OLD
          JOIN ACT_PUBLIOCULTO_SINCOND_BANKIA AUX on HEP_OLD.ACT_ID = AUX.ACT_ID
          WHERE HEP_OLD.USUARIOMODIFICAR = 'HREOS-3336';

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' registros insertados ACT_HEP_HIST_EST_PUBLICACION ');         
          
DBMS_OUTPUT.PUT_LINE('Se inserta una nueva línea en la HEP con HEP_FECHA_DESDE a sysdate y estado a "Despublicado"');
   
INSERT INTO REM01.ACT_HEP_HIST_EST_PUBLICACION HEP (
               HEP_ID
              ,ACT_ID
              ,HEP_FECHA_DESDE
              ,HEP_FECHA_HASTA
              ,DD_POR_ID
              ,DD_TPU_ID
              ,DD_EPU_ID
              ,HEP_MOTIVO
              ,VERSION
              ,USUARIOCREAR
              ,FECHACREAR
              ,BORRADO
          )
          SELECT
            REM01.S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL                AS HEP_ID,
            HEP_OLD.ACT_ID                                              AS ACT_ID,
            sysdate                                                     AS HEP_FECHA_DESDE,
            null                                                        AS HEP_FECHA_HASTA,
            CASE WHEN AUX.CONDICIONADO = 0 THEN 
                     (select dd_por_id from rem01.dd_por_portal where dd_por_codigo = '01')  
                  WHEN AUX.CONDICIONADO > 0 THEN 
                      (select dd_por_id from rem01.dd_por_portal where dd_por_codigo = '02') 
            ELSE NULL 
            END AS DD_POR_ID,
            HEP_OLD.DD_TPU_ID                                            AS DD_TPU_ID,
            (select dd_epu_id from rem01.dd_epu_estado_publicacion where dd_epu_codigo = '05')            AS DD_EPU_ID,
            'Actualización masiva PFS'                                  AS HEP_MOTIVO,
            0                                                           AS VERSION,
            'HREOS-3336'                                                AS USUARIOCREAR,
            SYSDATE                                                     AS FECHACREAR,
            0                                                           AS BORRADO
          FROM REM01.ACT_HEP_HIST_EST_PUBLICACION HEP_OLD
          JOIN ACT_PUBLIOCULTO_SINCOND_BANKIA AUX on HEP_OLD.ACT_ID = AUX.ACT_ID
          WHERE HEP_OLD.USUARIOMODIFICAR = 'HREOS-3336';
 
 DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' registros insertados ACT_HEP_HIST_EST_PUBLICACION ');  

 DBMS_OUTPUT.PUT_LINE('Actualizamos ACT_ATIVO estado publicación "Despublicado"');
 
MERGE INTO REM01.ACT_ACTIVO ACT_OLD
USING (
       select aux.act_id
       from ACT_PUBLIOCULTO_SINCOND_BANKIA aux
       ) ACT_NEW
ON (ACT_OLD.ACT_ID = ACT_NEW.ACT_ID)
WHEN MATCHED THEN UPDATE 
SET ACT_OLD.DD_EPU_ID = (select dd_epu_id from rem01.dd_epu_estado_publicacion where dd_epu_codigo = '05')
,   ACT_OLD.USUARIOMODIFICAR = 'HREOS-3336'
,   ACT_OLD.FECHAMODIFICAR = sysdate;

 DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' actualizados ACT_ACTIVO');  

    
 DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO cambio despublicados ocultos');

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

EXIT;


