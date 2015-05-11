--/*
--##########################################
--## Author: Óscar
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set dd_sta_id = (select dd_sta_id from '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base where dd_sta_codigo = ''101'') where dd_tpo_id = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P415'')';


--INC 154
execute immediate 'update '||V_ESQUEMA_M||'.dd_tas_tipos_asunto set borrado = 1, usuarioborrar = ''DD'', fechaborrar = sysdate where dd_tas_codigo in (''01'',''02'')';

--INC 170
execute immediate 'update '||V_ESQUEMA||'.dd_tbi_tipo_bien set borrado = 1, usuarioborrar = ''DD'', fechaborrar = sysdate where dd_tbi_descripcion = ''PRUEBA ARTURO''';

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA');

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

EXIT

    