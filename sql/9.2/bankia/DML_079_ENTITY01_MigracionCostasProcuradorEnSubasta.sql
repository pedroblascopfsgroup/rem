--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160425
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1119
--## PRODUCTO=SI
--## 
--## Finalidad: Migración en sub_subasta de las costas de procurador
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
 V_TABLA VARCHAR(31) :='SUB_SUBASTA'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(2500 CHAR);
 V_USUARIO VARCHAR2(50 CHAR) := 'PRODUCTO-1119';

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INFO] Comienza la migración');
		
 V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' old
            USING ( 
			select  sub_id, tev_valor from (
			SELECT DISTINCT rank() over(partition by sub.sub_id order by tev.fechacrear desc) as ranking, sub.PRC_ID, sub.SUB_ID, sub.SUB_COSTAS_PROCURADOR,  TO_NUMBER(REPLACE(TEV.TEV_VALOR,''.'','','')) TEV_VALOR
                      FROM '||V_ESQUEMA||'.SUB_SUBASTA sub
                      JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar ON sub.PRC_ID = tar.PRC_ID
		      JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex ON tar.TAR_ID = tex.TAR_ID
		      JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap ON tex.TAP_ID = tap.TAP_ID
		      JOIN '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS tfi ON tap.TAP_ID = tfi.TAP_ID
		      JOIN '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR tev ON tex.TEX_ID = tev.TEX_ID
                      WHERE (tap.TAP_CODIGO LIKE ''%SenyalamientoSubasta'') AND TFI_NOMBRE = ''costasProcurador'' AND tev.TEV_NOMBRE = ''costasProcurador'')
			where ranking = 1)  new
            ON (old.SUB_ID = new.SUB_ID)
            WHEN MATCHED THEN UPDATE
            SET old.SUB_COSTAS_PROCURADOR = new.TEV_VALOR, old.USUARIOMODIFICAR = '''||V_USUARIO||''', old.FECHAMODIFICAR = Sysdate';
 
            DBMS_OUTPUT.PUT_LINE('[INFO] Finalizada la migración');
            
 EXECUTE IMMEDIATE V_MSQL;
 
 commit;
 
 	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');

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
