--/*
--##########################################
--## AUTOR=Alberto B.
--## FECHA_CREACION=20160212
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0
--## INCIDENCIA_LINK=BKREC-1745
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_FUNCIONES
    

BEGIN	
    -- LOOP Insertando valores en FUN_FUNCIONES
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.SUB_SUBASTA...Comprobaciones previas');
    
    V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.SUB_SUBASTA WHERE ASU_ID IN (SELECT ASU_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES WHERE TAR_TAREA = ''Celebración de subasta'' AND TAR_FECHA_FIN IS NOT NULL AND TAR_TAREA_FINALIZADA = ''1'') AND DD_ESU_ID != (SELECT DD_ESU_ID FROM '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA WHERE DD_ESU_CODIGO = ''CEL'')';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	    V_MSQL := 'UPDATE '||V_ESQUEMA||'.SUB_SUBASTA SET DD_ESU_ID = (SELECT DD_ESU_ID FROM '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA WHERE DD_ESU_CODIGO = ''CEL'') WHERE ASU_ID IN (SELECT ASU_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES WHERE TAR_TAREA = ''Celebración de subasta'' AND TAR_FECHA_FIN IS NOT NULL AND TAR_TAREA_FINALIZADA = ''1'') AND DD_ESU_ID != (SELECT DD_ESU_ID FROM '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA WHERE DD_ESU_CODIGO = ''CEL'')';
	    EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.SUB_SUBASTA...  registros actualizados');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.SUB_SUBASTA...  No hay registros con estado incorrecto');
  	END IF;
    COMMIT;
    

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
  	