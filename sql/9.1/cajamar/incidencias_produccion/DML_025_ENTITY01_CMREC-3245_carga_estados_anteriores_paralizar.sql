--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160526
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-3245
--## PRODUCTO=NO
--## 
--## Finalidad: Inserta estados anteriores a la paralización y corrige TAR y TEX
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 20151126 GMN Versión inicial
--##########################################
--*/

-- 1. Cargamos estados anteriores a la paralización
-- 2. Actualizamos la TAR y la TEX con borrado = 1
-- 3. Actualizamos la TAR y la TEX con las tareas que les corresponden según su estado

/*******************************  INSERTAMOS ESTADOS EN LA HEP  ***************************************/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
set timing ON
set linesize 2000
SET VERIFY OFF
set feedback on

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN


/*************************************/
/** INSERTAR ESTADO ENVIADO         **/
/*************************************/

INSERT INTO CM01.PCO_PRC_HEP_HISTOR_EST_PREP (PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, PCO_PRC_HEP_FECHA_FIN, USUARIOCREAR, FECHACREAR, SYS_GUID)
				SELECT CM01.S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL,
                        PCO_PRC_ID,
                        (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'EN') ,-- enviado
                                NVL(CASE WHEN FECHA_ENVIO_LETRADO < FECHA_PARALIZACION THEN FECHA_ENVIO_LETRADO -1 ELSE FECHA_PARALIZACION END , (PRC_HEP_FECHA_INICIO-1)) AS PRC_HEP_FECHA_INICIO,
                                PRC_HEP_FECHA_INICIO as PCO_PRC_HEP_FECHA_FIN,             
                                'CMREC-3245' AS USUARIOCREAR,
                                 SYSDATE, SYS_GUID() AS SYS_GUID
                         FROM(
                              SELECT PCO.PCO_PRC_ID,  exp.FECHA_ENVIO_LETRADO, exp.FECHA_PARALIZACION, hep.PCO_PRC_HEP_FECHA_INCIO AS PRC_HEP_FECHA_INICIO
                                FROM  CM01.PCO_PRC_PROCEDIMIENTOS PCO
                                inner join CM01.PRC_PROCEDIMIENTOS PRC on PCO.PRC_ID = PRC.PRC_ID
                                inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id           
                                inner join CM01.ASU_ASUNTOS ASU on PRC.ASU_ID = ASU.ASU_ID 
                                inner join CM01.MIG_EXPEDIENTES_CABECERA EXP on exp.cd_expediente = asu.asu_id_externo
                              WHERE PRC.prc_paralizado = 1
                                and hep.usuariocrear = 'MIGRACM01PCO'                                                              
                                and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                and hep.PCO_PRC_HEP_FECHA_FIN is null    
                                and exp.fecha_asignacion is not null
                                and exp.fecha_envio_letrado is not null
        );    
        

--121 -- ENVIADO
-- TAP_CODIGO = 'PCO_RegistrarTomaDec'

--ACTUALIZAMOS LA TAR TAREAS_ NOTIFICACIONES

UPDATE CM01.TAR_TAREAS_NOTIFICACIONES SET USUARIOMODIFICAR = 'CMREC-3245'
                                        , FECHAMODIFICAR = systimestamp
                                        , TAR_DESCRIPCION = (SELECT TAP_DESCRIPCION FROM CM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = 'PCO_RegistrarTomaDec')
                                        , TAR_TAREA = (SELECT TAP_DESCRIPCION FROM CM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = 'PCO_RegistrarTomaDec')                                        
            WHERE TAR_CODIGO = 1
              AND PRC_ID in (SELECT PRC.PRC_ID
                                FROM  CM01.PCO_PRC_PROCEDIMIENTOS PCO
                                inner join CM01.PRC_PROCEDIMIENTOS PRC on PCO.PRC_ID = PRC.PRC_ID
                                inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id           
                                inner join CM01.ASU_ASUNTOS ASU on PRC.ASU_ID = ASU.ASU_ID 
                                inner join CM01.MIG_EXPEDIENTES_CABECERA EXP on exp.cd_expediente = asu.asu_id_externo
                              WHERE PRC.prc_paralizado = 1
                                and hep.usuariocrear = 'MIGRACM01PCO'                                                              
                                and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                and hep.PCO_PRC_HEP_FECHA_FIN is null    
                                and exp.fecha_asignacion is not null
                                and exp.fecha_envio_letrado is not null
                             );

-- ACTUALIZAMOS la TAREA EN  LA TEX

UPDATE CM01.TEX_TAREA_EXTERNA SET  USUARIOMODIFICAR = 'CMREC-3245'
                                             , FECHAMODIFICAR = systimestamp
                                             , TAP_ID = (SELECT TAP_ID FROM CM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = 'PCO_RegistrarTomaDec')
            WHERE TAR_ID IN (SELECT TAR_ID 
                               FROM CM01.TAR_TAREAS_NOTIFICACIONES 
                               WHERE PRC_ID in 
                                          (SELECT PRC.PRC_ID
                                            FROM  CM01.PCO_PRC_PROCEDIMIENTOS PCO
                                            inner join CM01.PRC_PROCEDIMIENTOS PRC on PCO.PRC_ID = PRC.PRC_ID
                                            inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                            inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id           
                                            inner join CM01.ASU_ASUNTOS ASU on PRC.ASU_ID = ASU.ASU_ID 
                                            inner join CM01.MIG_EXPEDIENTES_CABECERA EXP on exp.cd_expediente = asu.asu_id_externo
                                          WHERE PRC.prc_paralizado = 1
                                            and hep.usuariocrear = 'MIGRACM01PCO'                                                              
                                            and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                            and hep.PCO_PRC_HEP_FECHA_FIN is null    
                                            and exp.fecha_asignacion is not null
                                            and exp.fecha_envio_letrado is not null
                                       )
                             );

         
/*************************************/
/** INSERTAR ESTADO EN PREPARACION  **/
/*************************************/      
INSERT INTO CM01.PCO_PRC_HEP_HISTOR_EST_PREP (PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, PCO_PRC_HEP_FECHA_FIN, USUARIOCREAR, FECHACREAR, SYS_GUID)
				SELECT CM01.S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL,
                        PCO_PRC_ID,
                        (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PR') ,-- en preparacion
                                NVL(CASE WHEN FECHA_REALIZ_ESTUDIO_SOLV < FECHA_PARALIZACION THEN FECHA_REALIZ_ESTUDIO_SOLV -1 ELSE FECHA_PARALIZACION END , (PRC_HEP_FECHA_INICIO-1)) AS PRC_HEP_FECHA_INICIO,
                                PRC_HEP_FECHA_INICIO as PCO_PRC_HEP_FECHA_FIN,             
                                'CMREC-3245' AS USUARIOCREAR,
                                 SYSDATE, SYS_GUID() AS SYS_GUID
                         FROM(
                              SELECT PCO.PCO_PRC_ID,  exp.FECHA_REALIZ_ESTUDIO_SOLV, exp.FECHA_PARALIZACION, hep.PCO_PRC_HEP_FECHA_INCIO AS PRC_HEP_FECHA_INICIO
                                FROM  CM01.PCO_PRC_PROCEDIMIENTOS PCO
                                inner join CM01.PRC_PROCEDIMIENTOS PRC on PCO.PRC_ID = PRC.PRC_ID
                                inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id           
                                inner join CM01.ASU_ASUNTOS ASU on PRC.ASU_ID = ASU.ASU_ID 
                                inner join CM01.MIG_EXPEDIENTES_CABECERA EXP on exp.cd_expediente = asu.asu_id_externo
                              WHERE PRC.prc_paralizado = 1
                                and hep.usuariocrear = 'MIGRACM01PCO'                                                              
                                and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                and hep.PCO_PRC_HEP_FECHA_FIN is null    
                                and exp.fecha_asignacion is not null
                                and exp.fecha_envio_letrado is null
                                and exp.FECHA_PREPARADO     is null
                                and exp.FECHA_REALIZ_ESTUDIO_SOLV IS not NULL 
                                );            

        
 -- 2483   PREPARACION     
 
 --ACTUALIZAMOS LA TAR TAREAS_ NOTIFICACIONES
 

UPDATE CM01.TAR_TAREAS_NOTIFICACIONES SET USUARIOMODIFICAR = 'CMREC-3245'
                                        , FECHAMODIFICAR = systimestamp
                                        , TAR_DESCRIPCION = (SELECT TAP_DESCRIPCION FROM CM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = 'PCO_PrepararExpediente')
                                        , TAR_TAREA = (SELECT TAP_DESCRIPCION FROM CM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = 'PCO_PrepararExpediente')                                        
            WHERE TAR_CODIGO = 1
              AND PRC_ID in ( SELECT PRC.PRC_ID
                                FROM  CM01.PCO_PRC_PROCEDIMIENTOS PCO
                                inner join CM01.PRC_PROCEDIMIENTOS PRC on PCO.PRC_ID = PRC.PRC_ID
                                inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id           
                                inner join CM01.ASU_ASUNTOS ASU on PRC.ASU_ID = ASU.ASU_ID 
                                inner join CM01.MIG_EXPEDIENTES_CABECERA EXP on exp.cd_expediente = asu.asu_id_externo
                              WHERE PRC.prc_paralizado = 1
                                and hep.usuariocrear = 'MIGRACM01PCO'                                                              
                                and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                and hep.PCO_PRC_HEP_FECHA_FIN is null    
                                and exp.fecha_asignacion is not null
                                and exp.fecha_envio_letrado is null
                                and exp.FECHA_PREPARADO     is null
                                and exp.FECHA_REALIZ_ESTUDIO_SOLV IS not NULL 
                             );
                             
                             commit;


UPDATE CM01.TEX_TAREA_EXTERNA SET  USUARIOMODIFICAR = 'CMREC-3245'
                                             , FECHAMODIFICAR = systimestamp
                                             , TAP_ID = (SELECT TAP_ID FROM CM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = 'PCO_PrepararExpediente')
            WHERE TAR_ID IN (SELECT TAR_ID 
                               FROM CM01.TAR_TAREAS_NOTIFICACIONES 
                               WHERE PRC_ID in 
                                          (SELECT PRC.PRC_ID
                                            FROM  CM01.PCO_PRC_PROCEDIMIENTOS PCO
                                            inner join CM01.PRC_PROCEDIMIENTOS PRC on PCO.PRC_ID = PRC.PRC_ID
                                            inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                            inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id           
                                            inner join CM01.ASU_ASUNTOS ASU on PRC.ASU_ID = ASU.ASU_ID 
                                            inner join CM01.MIG_EXPEDIENTES_CABECERA EXP on exp.cd_expediente = asu.asu_id_externo
                                          WHERE PRC.prc_paralizado = 1
                                            and hep.usuariocrear = 'MIGRACM01PCO'                                                              
                                            and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                            and hep.PCO_PRC_HEP_FECHA_FIN is null    
                                            and exp.fecha_asignacion is not null
                                            and exp.fecha_envio_letrado is null
                                            and exp.FECHA_PREPARADO     is null
                                            and exp.FECHA_REALIZ_ESTUDIO_SOLV IS not NULL 
                                       )
                             );
 

/*************************************/
/** INSERTAR ESTADO EN ESTUDIO  **/
/*************************************/      
        
INSERT INTO CM01.PCO_PRC_HEP_HISTOR_EST_PREP (PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, PCO_PRC_HEP_FECHA_FIN, USUARIOCREAR, FECHACREAR, SYS_GUID)
				SELECT CM01.S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL,
                        PCO_PRC_ID,
                        (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PT') ,-- en estudio
                                NVL(CASE WHEN FECHA_ASIGNACION < FECHA_PARALIZACION THEN FECHA_ASIGNACION -1 ELSE FECHA_PARALIZACION END , (PRC_HEP_FECHA_INICIO-1)) AS PRC_HEP_FECHA_INICIO,
                                PRC_HEP_FECHA_INICIO as PCO_PRC_HEP_FECHA_FIN,             
                                'CMREC-3245' AS USUARIOCREAR,
                                 SYSDATE, SYS_GUID() AS SYS_GUID
                         FROM(
                              SELECT PCO.PCO_PRC_ID,  exp.FECHA_ASIGNACION, exp.FECHA_PARALIZACION, hep.PCO_PRC_HEP_FECHA_INCIO AS PRC_HEP_FECHA_INICIO, asu.asu_id
                                FROM  CM01.PCO_PRC_PROCEDIMIENTOS PCO
                                inner join CM01.PRC_PROCEDIMIENTOS PRC on PCO.PRC_ID = PRC.PRC_ID
                                inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id           
                                inner join CM01.ASU_ASUNTOS ASU on PRC.ASU_ID = ASU.ASU_ID 
                                inner join CM01.MIG_EXPEDIENTES_CABECERA EXP on exp.cd_expediente = asu.asu_id_externo
                              WHERE PRC.prc_paralizado = 1
                                and hep.usuariocrear = 'MIGRACM01PCO'                                                              
                                and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                and hep.PCO_PRC_HEP_FECHA_FIN is null    
                                and exp.fecha_asignacion is not null
                                and exp.fecha_envio_letrado is  null
                                and exp.FECHA_PREPARADO IS  NULL
                                and exp.FECHA_REALIZ_ESTUDIO_SOLV IS NULL 
              );            
 


-- PARALIZAMOS LAS TAREAS

UPDATE CM01.TAR_TAREAS_NOTIFICACIONES SET USUARIOMODIFICAR = 'CMREC-3245'
                                        , FECHAMODIFICAR = systimestamp
                                        , BORRADO = 1
            WHERE TAR_CODIGO = 1
              AND PRC_ID in (select distinct prc.prc_ID
                             from CM01.MIG_EXPEDIENTES_CABECERA mig
                               inner join CM01.asu_asuntos asu  on mig.cd_expediente = asu.asu_id_externo
                               inner join CM01.prc_procedimientos prc on asu.asu_id = prc.asu_id 
                               inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                               inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id
                               inner join CM01.tar_tareas_notificaciones tar on prc.prc_id = tar.prc_id 
                               inner join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
                             where  prc.usuariocrear = 'MIGRACM01PCO'
                               and prc.prc_paralizado = 1
                               and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                               and hep.PCO_PRC_HEP_FECHA_FIN is null
                             );


             
-- PARALIZAMOS LAS TAREAS_EXTERNAS

UPDATE CM01.TEX_TAREA_EXTERNA SET  USUARIOMODIFICAR = 'CMREC-3245'
                                             , FECHAMODIFICAR = systimestamp
                                             , TEX_DETENIDA = 1
            WHERE TAR_ID IN (SELECT TAR_ID 
                               FROM CM01.TAR_TAREAS_NOTIFICACIONES 
                               WHERE PRC_ID in 
                                          (select distinct prc.prc_ID
                                           from CM01.MIG_EXPEDIENTES_CABECERA mig
                                             inner join CM01.asu_asuntos asu  on mig.cd_expediente = asu.asu_id_externo
                                             inner join CM01.prc_procedimientos prc on asu.asu_id = prc.asu_id 
                                             inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                                             inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id
                                             inner join CM01.tar_tareas_notificaciones tar on prc.prc_id = tar.prc_id 
                                             inner join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
                                           where  prc.usuariocrear = 'MIGRACM01PCO'
                                             and prc.prc_paralizado = 1
                                             and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                             and hep.PCO_PRC_HEP_FECHA_FIN is null
                                            )
                             );
                             

                             
                             
--Corregimos fechas que coinciden y hacen fallar la aplicación

                             
UPDATE CM01.PCO_PRC_HEP_HISTOR_EST_PREP
set pco_prc_hep_fecha_incio = pco_prc_hep_fecha_incio -1
where pco_prc_hep_id in (
with pco_oks as (
select hep.*
from CM01.MIG_EXPEDIENTES_CABECERA mig
inner join CM01.asu_asuntos asu  on mig.cd_expediente = asu.asu_id_externo
inner join CM01.prc_procedimientos prc on asu.asu_id = prc.asu_id 
inner join CM01.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id
inner join CM01.tar_tareas_notificaciones tar on prc.prc_id = tar.prc_id 
inner join CM01.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
inner join CM01.DPR_DECISIONES_PROCEDIMIENTOS dpr on prc.prc_id = dpr.prc_id
where prc.usuariocrear = 'MIGRACM01PCO'
and prc.prc_paralizado = 1
and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
and hep.PCO_PRC_HEP_FECHA_FIN is null
and mig.fecha_asignacion is not null
) 
select hep.pco_prc_hep_id from pco_oks 
  inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco_oks.PCO_PRC_ID = hep.PCO_PRC_ID
  where trunc(hep.pco_prc_hep_fecha_incio) = trunc(hep.pco_prc_hep_fecha_fin)
);


commit;                             
                             
                             
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;
