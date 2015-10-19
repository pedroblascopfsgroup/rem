/*
--##########################################
--## AUTOR=Jorge Martin
--## FECHA_CREACION=20151019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HR-1361
--## PRODUCTO=SI
--##
--## Finalidad: Ajustar script de validacion en Asignacion de gestores
--##           LET_PCO --> GEXT
--##           SUP_PCO --> SUP
--##
--## DEPENDE DE:
--##    DML_064_MASTER_PCO_nuevosTGE.sql
--##    DML_061_ENTITY01_BPMPrecon_Tareas.sql
--##
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_DD_TGE_ID NUMBER(16);   
    V_DD_TGE_ID_DEST NUMBER(16);

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO]');


-- Borrado Logico LET_PCO y SUP_PCO

DBMS_OUTPUT.PUT_LINE('[INFO] - Borrado logico en DD_TGE_TIPO_GESTOR');
V_MSQL := 'UPDATE ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR SET BORRADO = ''1'' WHERE DD_TGE_CODIGO = ''LET_PCO'' OR DD_TGE_CODIGO = ''SUP_PCO''';
EXECUTE IMMEDIATE V_MSQL;


DBMS_OUTPUT.PUT_LINE('[INFO] - Borrado logico en DD_TDE_TIPO_DESPACHO');
V_MSQL := 'UPDATE ' || V_ESQUEMA_MASTER || '.DD_TDE_TIPO_DESPACHO SET BORRADO = ''1'' WHERE DD_TDE_CODIGO = ''LET_PCO'' OR DD_TDE_CODIGO = ''SUP_PCO''';
EXECUTE IMMEDIATE V_MSQL;


-- Modificacion de la tarea

V_SQL := 'SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GEXT''';
EXECUTE IMMEDIATE V_SQL INTO V_DD_TGE_ID;

DBMS_OUTPUT.PUT_LINE('[INFO] - Update en DD_STA_SUBTIPO_TAREA_BASE PCO_LET');
V_MSQL := 'UPDATE ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE SET DD_TGE_ID = ''' || V_DD_TGE_ID || ''' WHERE DD_STA_CODIGO = ''PCO_LET''';
EXECUTE IMMEDIATE V_MSQL;



V_SQL := 'SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUP''';
EXECUTE IMMEDIATE V_SQL INTO V_DD_TGE_ID;

DBMS_OUTPUT.PUT_LINE('[INFO] - Update en DD_STA_SUBTIPO_TAREA_BASE PCO_SUP');
V_MSQL := 'UPDATE ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE SET DD_TGE_ID = ''' || V_DD_TGE_ID || ''' WHERE DD_STA_CODIGO = ''PCO_SUP''';
EXECUTE IMMEDIATE V_MSQL;



-- Modificacion de TAP_TAREA_PROCEDIMIENTO

V_SQL := 'SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUP_PCO''';
EXECUTE IMMEDIATE V_SQL INTO V_DD_TGE_ID;

V_SQL := 'SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUP''';
EXECUTE IMMEDIATE V_SQL INTO V_DD_TGE_ID_DEST;

DBMS_OUTPUT.PUT_LINE('[INFO] - Update en TAP_TAREA_PROCEDIMIENTO SUP');
V_MSQL := 'UPDATE ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO SET DD_TSUP_ID = ''' || V_DD_TGE_ID_DEST || ''', USUARIOMODIFICAR = ''HR-1361''' || ' WHERE DD_TSUP_ID = ''' || V_DD_TGE_ID || '''';

EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[FIN]');

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
