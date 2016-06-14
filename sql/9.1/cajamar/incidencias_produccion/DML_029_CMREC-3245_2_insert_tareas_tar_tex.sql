--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160601
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-3245
--## PRODUCTO=NO
--## 
--## Finalidad: Inserta tareas y tex de procedimientos paralizados y corrige TAR y TEX
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 20151126 GMN Versión inicial
--##########################################
-- --*/

-- 1. Cargamos estados anteriores a la paralización

/*******************************  INSERTAMOS ESTADOS EN LA HEP  ***************************************/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN


/********  CREACION TAREAS  *************/

/* TAREA ENVIADO*/

INSERT INTO CM01.TAR_TAREAS_NOTIFICACIONES (TAR_ID, EXP_ID, ASU_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, 
					TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_EMISOR, 
					VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PRC_ID, DTYPE, NFA_TAR_REVISADA, SYS_GUID)
	SELECT  CM01.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL,        
         null AS EXP_ID,
         ASU.ASU_ID,
         6 AS DD_EST_ID,
         5 AS DD_EIN_ID,
         NVL(tap.dd_sta_id,39) AS DD_STA_ID, -- 39 = TAREA EXTERNA (GESTOR)
         1 AS TAR_CODIGO,
         TAP.TAP_CODIGO AS  TAR_TAREA,
         TAP.TAP_DESCRIPCION AS TAR_DESCRIPCION, 
         NVL(EXP.FECHA_ENVIO_LETRADO, TRUNC(SYSDATE)) AS TAR_FECHA_INI,
         0 AS TAR_EN_ESPERA,
         0 AS TAR_ALERTA,
         'AUTOMATICA' AS TAR_EMISOR,
         0 AS VERSION, 
         'CMREC-3245' AS USUARIOCREAR,
         SYSDATE AS FECHACREAR,
         1 AS BORRADO,
         PRC.PRC_ID,
         'EXTTareaNotificacion' AS DTYPE,
         0 AS NFA_TAR_REVISADA,
         SYS_GUID() AS SYS_GUID
        FROM  CM01.PCO_PRC_PROCEDIMIENTOS PCO
           inner join CM01.PRC_PROCEDIMIENTOS PRC on PCO.PRC_ID = PRC.PRC_ID
           inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id           
           inner join CM01.ASU_ASUNTOS ASU on PRC.ASU_ID = ASU.ASU_ID 
           inner join CM01.MIG_EXPEDIENTES_CABECERA EXP on exp.cd_expediente = asu.asu_id_externo
           INNER JOIN cm01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP_CODIGO = 'PCO_RegistrarTomaDec'
         WHERE PRC.prc_paralizado = 1
           and hep.usuariocrear like 'MIGRA%PCO'                                                              
           and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
           and hep.PCO_PRC_HEP_FECHA_FIN is null    
           and exp.fecha_asignacion is not null
           and exp.fecha_envio_letrado is not null 
            ;
           
    DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);              

/* TAREA PREPARACION */

   INSERT INTO CM01.TAR_TAREAS_NOTIFICACIONES (TAR_ID, EXP_ID, ASU_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, 
					TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_EMISOR, 
					VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PRC_ID, DTYPE, NFA_TAR_REVISADA, SYS_GUID)
				SELECT CM01.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL,
					   null AS EXP_ID,
					   ASU.ASU_ID,
					   6 AS DD_EST_ID,
					   5 AS DD_EIN_ID,
					   NVL(tap.dd_sta_id,39) AS DD_STA_ID, -- 39 = TAREA EXTERNA (GESTOR)
					   1 AS TAR_CODIGO,
					   TAP.TAP_CODIGO TAR_TAREA,
					   TAP.TAP_DESCRIPCION AS TAR_DESCRIPCION, 
					   NVL(EXP.FECHA_REALIZ_ESTUDIO_SOLV, TRUNC(SYSDATE)) AS TAR_FECHA_INI,
					   0 AS TAR_EN_ESPERA,
					   0 AS TAR_ALERTA,
					   'AUTOMATICA' AS TAR_EMISOR,
					   0 AS VERSION, 
					   'CMREC-3245' AS USUARIOCREAR,
					   SYSDATE AS FECHACREAR,
					   1 AS BORRADO,
					   PRC.PRC_ID,
					   'EXTTareaNotificacion' AS DTYPE,
					   0 AS NFA_TAR_REVISADA,
					   SYS_GUID() AS SYS_GUID
				FROM  CM01.PCO_PRC_PROCEDIMIENTOS PCO
                                   inner join CM01.PRC_PROCEDIMIENTOS PRC on PCO.PRC_ID = PRC.PRC_ID
                                   inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id           
                                   inner join CM01.ASU_ASUNTOS ASU on PRC.ASU_ID = ASU.ASU_ID 
                                   inner join CM01.MIG_EXPEDIENTES_CABECERA EXP on exp.cd_expediente = asu.asu_id_externo
				   INNER JOIN CM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP_CODIGO = 'PCO_PrepararExpediente'
                                WHERE PRC.prc_paralizado = 1
                                  and hep.usuariocrear like 'MIGRA%PCO'                                                              
                                  and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                  and hep.PCO_PRC_HEP_FECHA_FIN is null    
                                  and exp.fecha_asignacion is not null
                                  and exp.fecha_envio_letrado is null
                                  and exp.FECHA_PREPARADO     is null
                                  and exp.FECHA_REALIZ_ESTUDIO_SOLV IS not NULL ;
     
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);    


/* TAREA EN ESTUDIO  */  
    
         INSERT INTO CM01.TAR_TAREAS_NOTIFICACIONES (TAR_ID, EXP_ID, ASU_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, 
                     TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_EMISOR, 
                     VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PRC_ID, DTYPE, NFA_TAR_REVISADA, SYS_GUID)
                     SELECT CM01.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL,
                                       null AS EXP_ID,
                                       ASU.ASU_ID,
                                       6 AS DD_EST_ID,
                                       5 AS DD_EIN_ID,
                                       NVL(tap.dd_sta_id,39) AS DD_STA_ID, -- 39 = TAREA EXTERNA (GESTOR)
                                       1 AS TAR_CODIGO,
                                       TAP.TAP_CODIGO TAR_TAREA,
                                       TAP.TAP_DESCRIPCION AS TAR_DESCRIPCION, 
                                       NVL(EXP.FECHA_ASIGNACION, TRUNC(SYSDATE)) AS TAR_FECHA_INI,
                                       0 AS TAR_EN_ESPERA,
                                       0 AS TAR_ALERTA,
                                       'AUTOMATICA' AS TAR_EMISOR,
                                       0 AS VERSION, 
                                       'CMREC-3245' AS USUARIOCREAR,
                                       SYSDATE AS FECHACREAR,
                                       1 AS BORRADO,
                                       PRC.PRC_ID,
                                       'EXTTareaNotificacion' AS DTYPE,
                                       0 AS NFA_TAR_REVISADA,
                                       SYS_GUID() AS SYS_GUID
                              FROM  CM01.PCO_PRC_PROCEDIMIENTOS PCO
                                   inner join CM01.PRC_PROCEDIMIENTOS PRC on PCO.PRC_ID = PRC.PRC_ID
                                   inner join CM01.PCO_PRC_HEP_HISTOR_EST_PREP hep on pco.pco_prc_id = hep.pco_prc_id           
                                   inner join CM01.ASU_ASUNTOS ASU on PRC.ASU_ID = ASU.ASU_ID 
                                   inner join CM01.MIG_EXPEDIENTES_CABECERA EXP on exp.cd_expediente = asu.asu_id_externo
                                   INNER JOIN CM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP_CODIGO = 'PCO_RevisarExpedientePreparar'
                              WHERE PRC.prc_paralizado = 1
                                and hep.usuariocrear like 'MIGRA%PCO'                                                              
                                and hep.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM CM01.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = 'PA')
                                and hep.PCO_PRC_HEP_FECHA_FIN is null    
                                and exp.fecha_asignacion is not null
                                and exp.fecha_envio_letrado is  null
                                and exp.FECHA_PREPARADO IS  NULL
                                and exp.FECHA_REALIZ_ESTUDIO_SOLV IS NULL ;
     

	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  


/*****************************
*   TEX_TAREA_EXTERNA        *
******************************/

  INSERT INTO CM01.TEX_TAREA_EXTERNA(TEX_ID, TAR_ID, TAP_ID, TEX_DETENIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TEX_CANCELADA, TEX_NUM_AUTOP, DTYPE)
  SELECT CM01.S_TEX_TAREA_EXTERNA.NEXTVAL,
       TAR_ID,
       TAP.TAP_ID AS TAP_ID,
       1 AS TEX_DETENIDA,
       0 AS VERSION,
       'CMREC-3245' AS USUARIOCREAR,
       SYSDATE AS FECHACREAR,
       0 AS BOORADO,
       0 AS TEX_CANCELADA,
       0 AS TEX_NUM_AUTOP,
       'EXTTareaExterna'  AS DTYPE
  FROM CM01.TAR_TAREAS_NOTIFICACIONES TAR, CM01.TAP_TAREA_PROCEDIMIENTO TAP
  WHERE TAR.USUARIOCREAR = 'CMREC-3245'
          AND TAR.TAR_TAREA = TAP.TAP_DESCRIPCION
          ;

  
  DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);           

  
UPDATE CM01.TAR_TAREAS_NOTIFICACIONES SET 
     TAR_TAREA = (SELECT TAP_DESCRIPCION FROM CM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = 'PCO_RegistrarTomaDec')                                        
WHERE TAR_TAREA = 'PCO_RegistrarTomaDec'
AND USUARIOCREAR = 'CMREC-3245';

  DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);           

UPDATE CM01.TAR_TAREAS_NOTIFICACIONES SET 
     TAR_TAREA = (SELECT TAP_DESCRIPCION FROM CM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = 'PCO_PrepararExpediente')                                        
WHERE TAR_TAREA = 'PCO_PrepararExpediente'
AND USUARIOCREAR = 'CMREC-3245';

  DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);           


UPDATE CM01.TAR_TAREAS_NOTIFICACIONES SET 
     TAR_TAREA = (SELECT TAP_DESCRIPCION FROM CM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = 'PCO_RevisarExpedientePreparar')                                        
WHERE TAR_TAREA = 'PCO_RevisarExpedientePreparar'
AND USUARIOCREAR = 'CMREC-3245';

  DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);           
  
  
commit;                             
                             
                             

EXCEPTION

 WHEN OTHERS THEN
   err_num := SQLCODE;
   err_msg := SQLERRM;

   DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
   DBMS_OUTPUT.put_line(err_msg);

   ROLLBACK;
   RAISE;
 END;
  /
 EXIT;
	