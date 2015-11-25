--/*
--##########################################
--## AUTOR=ENRIQUE JIMENEZ DIAZ 
--## FECHA_CREACION=20150810
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-1227
--## PRODUCTO=NO
--## 
--## Finalidad: Asignamos correctamente DD_STA_ID a las Tareas para que les salgan a los gestores. SOLO CONCURSAL
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## TABLAS AFECTADAS
--##	tar_tareas_notificaciones
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE; -- Abortar en caso de error.

SET SERVEROUTPUT ON; 

DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLADD1 VARCHAR(31) :='tar_tareas_notificaciones'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL1 VARCHAR2(2500 CHAR);
 V_EXISTE NUMBER (1):=null;

BEGIN

 V_MSQL1 := 'MERGE INTO ' ||V_ESQUEMA|| '.tar_tareas_notificaciones tar USING (
		select tap.dd_sta_id, tex.tar_id
       		from ' ||V_ESQUEMA|| '.tex_tarea_externa tex
	          inner join ' ||V_ESQUEMA|| '.TAP_TAREA_PROCEDIMIENTO tap on tex.tap_id = tap.tap_id
	          inner join ' ||V_ESQUEMA|| '.TAR_TAREAS_NOTIFICACIONES t on t.TAR_ID = tex.TAR_ID
	          inner join ' ||V_ESQUEMA|| '.PRC_PROCEDIMIENTOS      prc on prc.PRC_ID = t.PRC_ID
	          inner join ' ||V_ESQUEMA|| '.ASU_ASUNTOS             asu on prc.asu_id = asu.asu_id
         	where asu.usuariocrear=''MIGRACM01''
	            and asu.DD_TAS_ID = 2  
	    ) tmp
	    on (tmp.tar_id = tar.tar_id)
		WHEN MATCHED THEN UPDATE SET tar.dd_sta_id = tmp.dd_sta_id,  tar.usuariomodificar = tar.dd_sta_id, tar.fechamodificar = sysdate';


 
 EXECUTE IMMEDIATE V_MSQL1;

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
