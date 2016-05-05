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
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'vtar_asu_vs_usu';

BEGIN
    
	V_MSQL := '
	CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' (usu_id,
                                                     des_id,
                                                     dd_tge_id,
                                                     usu_id_original,
                                                     asu_id,
                                                     gas_id,
                                                     dd_est_id,
                                                     asu_fecha_est_id,
                                                     asu_process_bpm,
                                                     asu_nombre,
                                                     exp_id,
                                                     VERSION,
                                                     usuariocrear,
                                                     fechacrear,
                                                     usuariomodificar,
                                                     fechamodificar,
                                                     usuarioborrar,
                                                     fechaborrar,
                                                     borrado,
                                                     dd_eas_id,
                                                     asu_asu_id,
                                                     asu_observacion,
                                                     sup_id,
                                                     sup_com_id,
                                                     com_id,
                                                     dco_id,
                                                     asu_fecha_recep_doc,
                                                     usd_id,
                                                     dtype,
                                                     dd_ucl_id,
                                                     ref_asesoria,
                                                     lote,
                                                     dd_tas_id,
                                                     asu_id_externo,
                                                     dd_pas_id,
                                                     dd_ges_id
                                                    )
AS
   SELECT usd.usu_id, usd.des_id, ges.dd_tge_id, usd.usu_id usu_id_original, asu.asu_id, asu.gas_id, asu.dd_est_id, asu.asu_fecha_est_id, asu.asu_process_bpm, asu.asu_nombre, asu.exp_id, asu.VERSION,
          asu.usuariocrear, asu.fechacrear, asu.usuariomodificar, asu.fechamodificar, asu.usuarioborrar, asu.fechaborrar, asu.borrado, asu.dd_eas_id, asu.asu_asu_id, asu.asu_observacion, asu.sup_id,
          asu.sup_com_id, asu.com_id, asu.dco_id, asu.asu_fecha_recep_doc, asu.usd_id, asu.dtype, asu.dd_ucl_id, asu.ref_asesoria, asu.lote, asu.dd_tas_id, asu.asu_id_externo, asu.dd_pas_id,
          asu.dd_ges_id
     FROM '||V_ESQUEMA||'.asu_asuntos asu
          JOIN
          (SELECT asu_id, usd_id, 4 dd_tge_id
             FROM '||V_ESQUEMA||'.asu_asuntos
            WHERE usd_id IS NOT NULL
           UNION ALL
           SELECT asu_id, usd_id, dd_tge_id
             FROM '||V_ESQUEMA||'.gaa_gestor_adicional_asunto
            WHERE borrado = 0) ges ON asu.asu_id = ges.asu_id
          JOIN '||V_ESQUEMA||'.usd_usuarios_despachos usd ON ges.usd_id = usd.usd_id
          ';
  
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

