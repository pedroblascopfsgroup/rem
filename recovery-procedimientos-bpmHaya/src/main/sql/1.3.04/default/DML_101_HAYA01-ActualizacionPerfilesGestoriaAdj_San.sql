/*
--##########################################
--## Author: Ignacio Arcos
--## 
--## Finalidad: Asociar perfiles Gestoria adjudicacion y gestoria saneamiento a las tareas de los trámites necesarias
--## INSTRUCCIONES:  Verificar esquemas correctos en el Declare
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_NUM_TAREAS NUMBER(4);  -- Vble. auxiliar para registrar errores en el script.
   
BEGIN	
	
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
          || ' SET DD_STA_ID = (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''1001'') '
          || ' WHERE (TAP_CODIGO = ''H066_registrarEntregaTitulo'' OR TAP_CODIGO = ''H066_registrarPresentacionHacienda'' OR TAP_CODIGO = ''H066_registrarPresentacionRegistro'' OR TAP_CODIGO = ''H066_registrarInscripcionTitulo'') ';
   
    DBMS_OUTPUT.PUT_LINE('Trámite inscripción título - Gestoria Adjudicación');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
      
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
          || ' SET DD_STA_ID = (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''1001'') '
          || ' WHERE (TAP_CODIGO = ''H005_RegistrarEntregaTitulo'' OR TAP_CODIGO = ''H005_RegistrarPresentacionEnHacienda'' OR TAP_CODIGO = ''H005_RegistrarPresentacionEnRegistro'' OR TAP_CODIGO = ''H005_RegistrarInscripcionDelTitulo'') ';
   
    DBMS_OUTPUT.PUT_LINE('Trámite adjudicación - Gestoria Adjudicación');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
          || ' SET DD_STA_ID = (SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''1011'') '
          || ' WHERE (TAP_CODIGO LIKE ''H008_%'' AND TAP_CODIGO != ''H008_RevisarPropuestaCancelacionCargas'') ';
   
    DBMS_OUTPUT.PUT_LINE('Trámite saneamiento cargas - Gestoria Saneamiento');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('[FIN-UPDATES] ');

COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('KO');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;