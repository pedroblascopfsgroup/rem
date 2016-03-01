--/*
--##########################################
--## AUTOR=MIGUEL ANGEL SANCHEZ
--## FECHA_CREACION=26-02-2016
--## ARTEFACTO=Tar_Tareas
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=HR-1927
--## PRODUCTO=SI
--## Finalidad: DML borrado tareas 'Registrar aceptación del asunto' sin TEX
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
    V_TABLA VARCHAR2(100 CHAR); --Vble. para guardar la tabla
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);



BEGIN

-----------------------------------------------------------------------------------------------------------------------------------

DBMS_OUTPUT.PUT_LINE('[INICIO]');

V_SQL := 'SELECT count(1) FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR LEFT JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID' ||
          ' WHERE TEX.TEX_ID IS NULL AND TAR.TAR_TAREA LIKE ''Registrar aceptación del asunto'' AND TAR.BORRADO=0';
DBMS_OUTPUT.PUT_LINE('   [QUERY] '|| V_SQL );
EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
IF V_NUM_FILAS > 0 THEN
    DBMS_OUTPUT.PUT_LINE('   [INFO] '|| V_NUM_FILAS ||' Filas para borrar');
V_SQL := 
   'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR '||
   'USING ( '||
   'SELECT TAR.TAR_ID ' ||
   'FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR '||
   'LEFT JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID '||
   'WHERE TEX.TEX_ID IS NULL '||
   'AND TAR.TAR_TAREA LIKE ''Registrar aceptación del asunto'' '||
   'AND TAR.BORRADO=0 '||
   ') DEL '||
   'ON (DEL.TAR_ID=TAR.TAR_ID) '||
   'WHEN MATCHED THEN UPDATE SET TAR.BORRADO=1, ' ||
   'TAR.USUARIOBORRAR=''HR-1927'', '||
   'TAR.FECHABORRAR=SYSDATE';
DBMS_OUTPUT.PUT_LINE('   [QUERY] '|| V_SQL );
EXECUTE IMMEDIATE V_SQL  ;
    DBMS_OUTPUT.PUT_LINE('   [INFO] '||V_NUM_FILAS||' Tareas del tipo ''Registrar aceptación del asunto'' borradas.');      	
ELSE
    DBMS_OUTPUT.PUT_LINE('   [INFO] No existen tareas del tipo ''Registrar aceptación del asunto'' sin TEX');
END IF;

-----------------------------------------------------------------------------------------------------------------------------------
COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

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
