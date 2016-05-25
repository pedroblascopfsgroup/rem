--/*
--##########################################
--## AUTOR=Óscar
--## FECHA_CREACION=20160503
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1322
--## PRODUCTO=SI
--## Finalidad: DDL para versionado en git
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'vtar_tarea_vs_responsables';

BEGIN
    
	V_MSQL := '
	CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' (tar_id, dd_tge_id_alerta, dd_tge_id_pendiente, dd_tge_id_supervisor, usu_pendientes, usu_alerta, usu_supervisor)
AS
   SELECT   tar_id, MAX (dd_tge_id_alerta) AS dd_tge_id_alerta, MAX (dd_tge_id_pendiente) AS dd_tge_id_pendiente, MAX (dd_tge_id_supervisor) AS dd_tge_id_supervisor,
            MAX (NVL (usu_pendientes, -1)) usu_pendientes, MAX (NVL (usu_alerta, -1)) usu_alerta, MAX (NVL (usu_supervisor, -1)) usu_supervisor
       --,MAX(NVL (en_espera, 0)) en_espera
   FROM     (SELECT vtar.tar_id, vtar.dd_tge_id_alerta, vtar.dd_tge_id_pendiente, vtar.dd_tge_id_supervisor, DECODE (vusu.dd_tge_id, vtar.dd_tge_id_pendiente, vusu.usu_id) usu_pendientes
           --, vtar.en_espera en_espera
                    ,
                    DECODE (vusu.dd_tge_id, vtar.dd_tge_id_alerta, vusu.usu_id) usu_alerta, DECODE (vusu.dd_tge_id, vtar.dd_tge_id_supervisor, vusu.usu_id) usu_supervisor
               FROM '||V_ESQUEMA||'.vtar_tarea_vs_tge vtar JOIN '||V_ESQUEMA||'.vtar_asu_vs_usu vusu ON vtar.asu_id = vusu.asu_id
                    )
      WHERE (usu_pendientes > 0
             OR usu_alerta > 0)
   GROUP BY tar_id';
  
 EXECUTE IMMEDIATE V_MSQL;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NOMBRE_VISTA||' Creada o reemplazada');     

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

