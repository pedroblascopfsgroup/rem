--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160601
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1483
--## PRODUCTO=NO
--##
--## Finalidad: Actulizar TEX_TOKEN_ID_BPM de la tarea 'Registrar toma de decision' donde el token sea diferente a su tarea anterior 'Registrar aceptacion asunto'
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
set linesize 2000
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

-- Este DML actualizar el campo TEX_TOKEN_ID_BPM de la tarea 'Registrar toma de decisión' del trámite T. Aceptación Decisión de Litigios
-- Cuyo valor del campo TEX_TOKEN_ID_BPM, debe ser el mismo que la tarea anterior 'Registrar Aceptación asunto'

V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_STRING VARCHAR2(10); -- Vble. para validar la existencia de si el campo es nulo
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

   V_MERGE  VARCHAR2(4000 CHAR) := 'MERGE INTO ' || V_ESQUEMA || '.TEX_TAREA_EXTERNA tableTex  ' || 
		' USING	(' ||
		' select t2.tex_id, t1.TEX_TOKEN_ID_BPM from (' ||
		'     select tex.tex_id, tex.TEX_TOKEN_ID_BPM, prc.prc_id ' ||
		'       from ' || V_ESQUEMA || '.TEX_TAREA_EXTERNA tex' ||
		'       join ' || V_ESQUEMA || '.TAR_TAREAS_NOTIFICACIONES tar on tex.tar_id = tar.TAR_ID' ||
		'       join ' || V_ESQUEMA || '.PRC_PROCEDIMIENTOS prc on tar.prc_id = prc.prc_id' ||
		'       where tex.TAP_ID = (select tap_id from ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H068_registrarAceptacion'')' ||
		'   ) t1' ||
		' join (' ||
		'     select tex.tex_id, tex.TEX_TOKEN_ID_BPM, prc.prc_id ' ||
		'       from ' || V_ESQUEMA || '.TEX_TAREA_EXTERNA tex' ||
		'       join ' || V_ESQUEMA || '.TAR_TAREAS_NOTIFICACIONES tar on tex.tar_id = tar.TAR_ID' ||
		'       join ' || V_ESQUEMA || '.PRC_PROCEDIMIENTOS prc on tar.prc_id = prc.prc_id' ||
		'       where tex.TAP_ID = (select tap_id from ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H068_registrarProcedimiento'')' ||
		'   ) t2 ' ||
		'   on t1.prc_id = t2.prc_id' ||
		'   where t1.TEX_TOKEN_ID_BPM <> t2.TEX_TOKEN_ID_BPM' ||
		' ) tableJoin' ||
		' ON(tableTex.tex_id = tableJoin.tex_id)' ||
		' WHEN MATCHED THEN UPDATE SET' ||
		' tableTex.TEX_TOKEN_ID_BPM = tableJoin.TEX_TOKEN_ID_BPM';

  
BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TEX_TAREA_EXTERNA... Haciendo MERGE');
	EXECUTE IMMEDIATE V_MERGE;
  DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.TEX_TAREA_EXTERNA... TEX_TOKEN_ID_BPM actualizados.');
	COMMIT;
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT