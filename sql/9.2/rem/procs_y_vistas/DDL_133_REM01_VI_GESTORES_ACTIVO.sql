--/*
--##########################################
--## AUTOR=ISIDRO SOTOCA
--## FECHA_CREACION=20180705
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4208
--## PRODUCTO=NO
--## Finalidad: Crear vista gestores activo
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial Pau Serrano Rodrigo
--##		0.2 Cambio de GCBO a HAYAGBOINM / HAYASBOFIN SOG
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2( 32000 CHAR); -- Sentencia a ejecutar    
    V_MSQL2 VARCHAR2( 32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2( 25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2( 25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER( 25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2( 1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT_VISTA VARCHAR2( 2400 CHAR) := 'V_GESTORES_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.


BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_VISTA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_VISTA||'... Creación vista');
	
	
	-- Creamos la vista
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_VISTA||'...');

	V_MSQL := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.' || V_TEXT_VISTA || ' ("ACT_ID", "DD_CRA_CODIGO", "DD_EAC_CODIGO", "DD_TCR_CODIGO", "DD_PRV_CODIGO", "DD_LOC_CODIGO", "COD_POSTAL", "TIPO_GESTOR", "USERNAME", "NOMBRE") AS 
  SELECT "ACT_ID", "DD_CRA_CODIGO", "DD_EAC_CODIGO", "DD_TCR_CODIGO", "DD_PRV_CODIGO", "DD_LOC_CODIGO", "COD_POSTAL", "TIPO_GESTOR", "USERNAME", "NOMBRE"
     FROM (
/*Gestores de grupo*/
SELECT act.act_id, NULL dd_cra_codigo, NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor, dist1.username username,
                  dist1.nombre_usuario nombre
             FROM act_activo act JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON dist1.tipo_gestor IN (''GADM'', ''GPUBL'', ''GMARK'', ''GPREC'', ''GTOPDV'', ''GTOPLUS'', ''GESTLLA'', ''GADMT'', ''GFSV'', ''GCAL'', ''SPUBL'', ''GESRES'', ''SUPRES'', ''GESMIN'', ''SUPMIN'', ''SUPADM'')
           where act.borrado = 0
           UNION ALL
/*Gestor de grupo - SUPERVISOR COMERCIAL BACKOFFICE*/
SELECT act.act_id, TO_NUMBER(cra.dd_cra_codigo), NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor, dist1.username username,
                  dist1.nombre_usuario nombre
             FROM act_activo act JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON dist1.tipo_gestor = ''GBACKOFFICE''
             LEFT JOIN '||V_ESQUEMA||'.dd_cra_cartera cra on TO_NUMBER(cra.dd_cra_codigo) = dist1.cod_cartera 
           where act.borrado = 0 AND cra.dd_cra_id = act.dd_cra_id
           UNION ALL
/*Gestor de grupo - SUPERVISOR COMERCIAL BACKOFFICE LIBERBANK*/
SELECT act.act_id, TO_NUMBER(cra.dd_cra_codigo), NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor, dist1.username username,
                  dist1.nombre_usuario nombre
             FROM act_activo act JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON dist1.tipo_gestor = ''SBACKOFFICEINMLIBER''
             LEFT JOIN '||V_ESQUEMA||'.dd_cra_cartera cra on TO_NUMBER(cra.dd_cra_codigo) = dist1.cod_cartera 
           where act.borrado = 0 AND cra.dd_cra_id = act.dd_cra_id
           UNION ALL
/*Gestor capa de control*/
           SELECT act.act_id, dist1.cod_cartera, NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor tipo_gestor,
                  dist1.username username, dist1.nombre_usuario nombre
             FROM act_activo act JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (dist1.cod_cartera = dd_cra.dd_cra_codigo AND dist1.tipo_gestor = ''GCCBANKIA'')
           where act.borrado = 0
           UNION ALL
/*Gestor Comercial BackOffice Inmobiliario*/
           SELECT act.act_id, dist1.cod_cartera, NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor tipo_gestor,
                  dist1.username username, dist1.nombre_usuario nombre
             FROM act_activo act JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
                  JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BL ON BL.BIE_ID = ACT.BIE_ID
                  JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = BL.DD_PRV_ID 
                  LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_ID = BL.DD_LOC_ID 
                  LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON dist1.cod_cartera = dd_cra.dd_cra_codigo AND dist1.tipo_gestor = ''HAYAGBOINM''
                  AND PRV.DD_PRV_CODIGO = dist1.COD_PROVINCIA AND LOC.DD_LOC_CODIGO = NVL(dist1.COD_MUNICIPIO,LOC.DD_LOC_CODIGO)
           where act.borrado = 0
           UNION ALL
/*Gestor del activo*/
SELECT act.act_id, TO_NUMBER (dd_cra.dd_cra_codigo) dd_cra_codigo, TO_NUMBER (COALESCE (dist3.cod_estado_activo, dist2.cod_estado_activo, dist1.cod_estado_activo, dist0.cod_estado_activo)) dd_eac_codigo,
		NULL dd_tcr_codigo, dd_prov.dd_prv_codigo, 
       COALESCE (dist3.cod_municipio,dist2.cod_municipio,dist1.cod_municipio,dist0.cod_municipio) cod_municipio, 
       COALESCE (dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
       COALESCE (dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor, 
       COALESCE (dist3.username, dist2.username, dist1.username, dist0.username) username,
       COALESCE (dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
  FROM '||V_ESQUEMA||'.act_activo act JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       LEFT JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
       JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
		LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
        ON (dist0.cod_estado_activo is null
        	AND dist0.cod_cartera = dd_cra.dd_cra_codigo
            AND dd_prov.dd_prv_codigo = dist0.cod_provincia
            AND dist0.cod_municipio IS NULL
            AND dist0.cod_postal IS NULL
            AND dist0.tipo_gestor = ''GACT''
            ) 
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
       ON (dd_eac.dd_eac_codigo = dist1.cod_estado_activo
           AND dist1.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist1.cod_provincia
           AND dist1.cod_municipio IS NULL
           AND dist1.cod_postal IS NULL
           AND dist1.tipo_gestor = ''GACT''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
       ON (dd_eac.dd_eac_codigo = dist2.cod_estado_activo
           AND dist2.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist2.cod_provincia
           AND dist2.cod_municipio = dd_loc.dd_loc_codigo
           AND dist2.cod_postal IS NULL
           AND dist2.tipo_gestor = ''GACT''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
       ON (dd_eac.dd_eac_codigo = dist3.cod_estado_activo
           AND dist3.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist3.cod_provincia
           AND dist3.cod_municipio = dd_loc.dd_loc_codigo
           AND dist3.cod_postal  = loc.BIE_LOC_COD_POST
           AND dist3.tipo_gestor = ''GACT''
          )   
          where act.borrado = 0                 
           UNION ALL
/*supervisor del activo*/
SELECT act.act_id, TO_NUMBER (dd_cra.dd_cra_codigo) dd_cra_codigo, TO_NUMBER (COALESCE (dist3.cod_estado_activo, dist2.cod_estado_activo, dist1.cod_estado_activo, dist0.cod_estado_activo)) dd_eac_codigo,
		NULL dd_tcr_codigo, dd_prov.dd_prv_codigo, 
       COALESCE (dist3.cod_municipio,dist2.cod_municipio,dist1.cod_municipio,dist0.cod_municipio) cod_municipio, 
       COALESCE (dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
       COALESCE (dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor, 
       COALESCE (dist3.username, dist2.username, dist1.username, dist0.username) username,
       COALESCE (dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
  FROM '||V_ESQUEMA||'.act_activo act JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       LEFT JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
       JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
		LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
        ON (dist0.cod_estado_activo is null
        	AND dist0.cod_cartera = dd_cra.dd_cra_codigo
            AND dd_prov.dd_prv_codigo = dist0.cod_provincia
            AND dist0.cod_municipio IS NULL
            AND dist0.cod_postal IS NULL
            AND dist0.tipo_gestor = ''SUPACT''
            ) 
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
       ON (dd_eac.dd_eac_codigo = dist1.cod_estado_activo
           AND dist1.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist1.cod_provincia
           AND dist1.cod_municipio IS NULL
           AND dist1.cod_postal IS NULL
           AND dist1.tipo_gestor = ''SUPACT''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
       ON (dd_eac.dd_eac_codigo = dist2.cod_estado_activo
           AND dist2.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist2.cod_provincia
           AND dist2.cod_municipio = dd_loc.dd_loc_codigo
           AND dist2.cod_postal IS NULL
           AND dist2.tipo_gestor = ''SUPACT''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
       ON (dd_eac.dd_eac_codigo = dist3.cod_estado_activo
           AND dist3.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist3.cod_provincia
           AND dist3.cod_municipio = dd_loc.dd_loc_codigo
           AND dist3.cod_postal  = loc.BIE_LOC_COD_POST
           AND dist3.tipo_gestor = ''SUPACT''
          )   
          where act.borrado = 0                 
           UNION ALL
/*Gestoría de admisión*/
SELECT act.act_id, TO_NUMBER (dd_cra.dd_cra_codigo), TO_NUMBER (dd_eac.dd_eac_codigo), NULL dd_tcr_codigo, to_char(dist2.cod_provincia), dist3.cod_municipio, dist4.cod_postal,
       COALESCE (dist1.tipo_gestor, dist2.tipo_gestor, dist3.tipo_gestor, dist4.tipo_gestor) AS tipo_gestor, COALESCE (dist1.username, dist2.username, dist3.username, dist4.username) username,
       COALESCE (dist1.nombre_usuario, dist2.nombre_usuario, dist3.nombre_usuario, dist4.nombre_usuario) nombre
  FROM act_activo act JOIN act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       JOIN dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
       JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (dd_eac.dd_eac_codigo = dist1.cod_estado_activo AND dist1.cod_cartera = dd_cra.dd_cra_codigo AND dist1.tipo_gestor = ''GGADM'')
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 ON (dd_prov.dd_prv_codigo = dist2.cod_provincia AND dist2.cod_cartera = dd_cra.dd_cra_codigo AND dist2.tipo_gestor = ''GGADM'')
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 ON (dd_loc.dd_loc_codigo = dist3.cod_municipio AND dist3.cod_cartera = dd_cra.dd_cra_codigo AND dist3.tipo_gestor = ''GGADM'')
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4 ON (loc.bie_loc_cod_post = dist4.cod_postal AND dist4.cod_cartera = dd_cra.dd_cra_codigo AND dist4.tipo_gestor = ''GGADM'')
           where act.borrado = 0
           UNION ALL
/*Gestoría de administración*/
           SELECT DISTINCT act.act_id, TO_NUMBER (dd_cra.dd_cra_codigo), TO_NUMBER (dd_eac.dd_eac_codigo), NULL dd_tcr_codigo, to_char(dist2.cod_provincia), dist3.cod_municipio, dist4.cod_postal,
                           COALESCE (dist1.tipo_gestor, dist2.tipo_gestor, dist3.tipo_gestor, dist4.tipo_gestor) AS tipo_gestor,
                           COALESCE (dist1.username, dist2.username, dist3.username, dist4.username) username,
                           COALESCE (dist1.nombre_usuario, dist2.nombre_usuario, dist3.nombre_usuario, dist4.nombre_usuario) nombre
                      FROM '||V_ESQUEMA||'.act_activo act 
                           JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
                           JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
                           JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
                           JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
                           LEFT JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
                           LEFT JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
                           LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (dd_eac.dd_eac_codigo = dist1.cod_estado_activo AND dist1.cod_cartera = dd_cra.dd_cra_codigo AND dist1.tipo_gestor = ''GIAADMT'')
                           LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 ON (dd_prov.dd_prv_codigo = dist2.cod_provincia AND dist2.cod_cartera = dd_cra.dd_cra_codigo AND dist2.tipo_gestor = ''GIAADMT'')
                           LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 ON (dd_loc.dd_loc_codigo = dist3.cod_municipio AND dist3.cod_cartera = dd_cra.dd_cra_codigo AND dist3.tipo_gestor = ''GIAADMT'')
                           LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4 ON (loc.bie_loc_cod_post = dist4.cod_postal AND dist4.cod_cartera = dd_cra.dd_cra_codigo AND dist4.tipo_gestor = ''GIAADMT'')
           where act.borrado = 0
           UNION ALL
/*Gestoría de formalización*/
           SELECT act.act_id, TO_NUMBER (dd_cra.dd_cra_codigo), TO_NUMBER (dd_eac.dd_eac_codigo), NULL dd_tcr_codigo, to_char(dist2.cod_provincia), dist3.cod_municipio, dist4.cod_postal,
                          COALESCE (dist1.tipo_gestor, dist2.tipo_gestor, dist3.tipo_gestor, dist4.tipo_gestor, dist5.tipo_gestor) AS tipo_gestor,
						  COALESCE (dist1.username, dist2.username, dist3.username, dist4.username, dist5.username) username,
						  COALESCE (dist1.nombre_usuario, dist2.nombre_usuario, dist3.nombre_usuario, dist4.nombre_usuario, dist5.nombre_usuario) nombre
                      FROM act_activo act JOIN act_loc_localizacion aloc ON act.act_id = aloc.act_id
                           JOIN bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
                           JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
                           JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
                           JOIN dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
                           JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
                           LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (dd_eac.dd_eac_codigo = dist1.cod_estado_activo AND dist1.cod_cartera = dd_cra.dd_cra_codigo AND dist1.tipo_gestor = ''GIAFORM'')
                           LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 ON (dd_prov.dd_prv_codigo = dist2.cod_provincia AND dist2.cod_cartera = dd_cra.dd_cra_codigo AND dist2.tipo_gestor = ''GIAFORM'')
                           LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 ON (dd_loc.dd_loc_codigo = dist3.cod_municipio AND dist3.cod_cartera = dd_cra.dd_cra_codigo AND dist3.tipo_gestor = ''GIAFORM'')
                           LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4 ON (loc.bie_loc_cod_post = dist4.cod_postal AND dist4.cod_cartera = dd_cra.dd_cra_codigo AND dist4.tipo_gestor = ''GIAFORM'')
                           LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5 ON (dist5.cod_cartera = dd_cra.dd_cra_codigo AND dist5.tipo_gestor = ''GIAFORM'' AND DIST1.username IS NULL AND DIST2.username IS NULL AND DIST3.username IS NULL AND DIST4.username IS NULL)
           where act.borrado = 0
           UNION ALL
/*Gestor de formalización*/
SELECT act.act_id, TO_NUMBER (dd_cra.dd_cra_codigo), NULL cod_estado_activo, NULL dd_tcr_codigo, to_char(dist1.cod_provincia), NULL cod_municipio, NULL cod_postal, 
			COALESCE (dist1.tipo_gestor, dist2.tipo_gestor) AS tipo_gestor,
			COALESCE (dist1.username, dist2.username) username,
			COALESCE (dist1.nombre_usuario, dist2.nombre_usuario) nombre
  FROM act_activo act JOIN act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (dist1.cod_cartera = dd_cra.dd_cra_codigo AND dd_prov.dd_prv_codigo = dist1.cod_provincia AND dist1.tipo_gestor = ''GFORM'')
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 ON (dist2.cod_cartera = dd_cra.dd_cra_codigo AND dist2.tipo_gestor = ''GFORM'' AND DIST1.username IS NULL)                         
            where act.borrado = 0
            UNION ALL
/*Gestor comercial*/
 SELECT act.act_id, TO_NUMBER (dd_cra.dd_cra_codigo) dd_cra_codigo, null dd_eac_codigo, dd_tcr.dd_tcr_codigo, dd_prov.dd_prv_codigo,
       COALESCE (dist1.cod_municipio,dist2.cod_municipio,dist3.cod_municipio,dist0.cod_municipio) cod_municipio,
       COALESCE (dist1.cod_postal, dist2.cod_postal, dist3.cod_postal, dist0.cod_postal) cod_postal,
       COALESCE (dist1.tipo_gestor, dist2.tipo_gestor, dist3.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
       COALESCE (dist1.username, dist2.username, dist3.username, dist0.username) username,
       COALESCE (dist1.nombre_usuario, dist2.nombre_usuario, dist3.nombre_usuario, dist0.nombre_usuario) nombre
  FROM act_activo act JOIN act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       JOIN dd_tcr_tipo_comercializar dd_tcr ON dd_tcr.dd_tcr_id = act.dd_tcr_id
       JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
       ON (dist0.cod_tipo_comerzialzacion IS NULL
           AND dist0.cod_cartera = dd_cra.dd_cra_codigo
           AND dist0.cod_provincia IS NULL
           AND dist0.cod_municipio IS NULL
           AND dist0.cod_postal IS NULL
           AND dist0.tipo_gestor = ''GCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
       ON (dd_tcr.dd_tcr_codigo = dist1.cod_tipo_comerzialzacion
           AND dist1.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist1.cod_provincia
           AND dist1.cod_municipio IS NULL
           AND dist1.cod_postal IS NULL
           AND dist1.tipo_gestor = ''GCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
       ON (dd_tcr.dd_tcr_codigo = dist2.cod_tipo_comerzialzacion
           AND dist2.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist2.cod_provincia
           AND dist2.cod_municipio = dd_loc.dd_loc_codigo
           AND dist2.cod_postal IS NULL
           AND dist2.tipo_gestor = ''GCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
       ON (dd_tcr.dd_tcr_codigo = dist3.cod_tipo_comerzialzacion
           AND dist3.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist3.cod_provincia
           AND dist3.cod_municipio = dd_loc.dd_loc_codigo
           AND dist3.cod_postal = loc.BIE_LOC_COD_POST
           AND dist3.tipo_gestor = ''GCOM''
          )
          where act.borrado = 0
		UNION ALL
/* SUPERVISOR COMERCIAL */
SELECT act.act_id, TO_NUMBER (dd_cra.dd_cra_codigo) dd_cra_codigo, null dd_eac_codigo, dd_tcr.dd_tcr_codigo, dd_prov.dd_prv_codigo, 
       COALESCE (dist1.cod_municipio,dist2.cod_municipio,dist3.cod_municipio) cod_municipio, 
       COALESCE (dist1.cod_postal, dist2.cod_postal, dist3.cod_postal) cod_postal,
       COALESCE (dist1.tipo_gestor, dist2.tipo_gestor, dist3.tipo_gestor) AS tipo_gestor, 
       COALESCE (dist1.username, dist2.username, dist3.username) username,
       COALESCE (dist1.nombre_usuario, dist2.nombre_usuario, dist3.nombre_usuario) nombre
  FROM act_activo act JOIN act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       JOIN dd_tcr_tipo_comercializar dd_tcr ON dd_tcr.dd_tcr_id = act.dd_tcr_id
       JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
       ON (dd_tcr.dd_tcr_codigo = dist1.cod_tipo_comerzialzacion
           AND dist1.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist1.cod_provincia
           AND dist1.cod_municipio IS NULL
           AND dist1.cod_postal IS NULL
           AND dist1.tipo_gestor = ''SCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
       ON (dd_tcr.dd_tcr_codigo = dist2.cod_tipo_comerzialzacion
           AND dist2.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist2.cod_provincia
           AND dist2.cod_municipio = dd_loc.dd_loc_codigo
           AND dist2.cod_postal IS NULL
           AND dist2.tipo_gestor = ''SCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
       ON (dd_tcr.dd_tcr_codigo = dist3.cod_tipo_comerzialzacion
           AND dist3.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist3.cod_provincia
           AND dist3.cod_municipio = dd_loc.dd_loc_codigo
           AND dist3.cod_postal = loc.BIE_LOC_COD_POST
           AND dist3.tipo_gestor = ''SCOM''
          )
          where act.borrado = 0		
		UNION ALL
/*PROVEEDOR TECNICO*/
 SELECT act.act_id, TO_NUMBER (dd_cra.dd_cra_codigo) dd_cra_codigo, null dd_eac_codigo, null dd_tcr_codigo, dd_prov.dd_prv_codigo,
      dist1.cod_municipio cod_municipio,
      dist1.cod_postal cod_postal,
      dist1.tipo_gestor AS tipo_gestor,
      dist1.username username,
      dist1.nombre_usuario nombre
  FROM act_activo act JOIN act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
       ON (dist1.cod_cartera = dd_cra.dd_cra_codigo
           AND dd_prov.dd_prv_codigo = dist1.cod_provincia
           AND dist1.tipo_gestor = ''PTEC''
          )
          where act.borrado = 0
		union all
    -- GOLDEN TREE 
  SELECT act.act_id, TO_NUMBER (cra.dd_cra_codigo) dd_cra_codigo, null dd_eac_codigo, tcr.dd_tcr_codigo, prv.dd_prv_codigo,
       dist1.cod_municipio,
       loc.bie_loc_cod_post cod_postal,
       tge.dd_tge_codigo as tipo_gestor,
       dist1.username,
       dist1.nombre_USUARIO
  FROM act_activo act
  JOIN act_loc_localizacion aloc ON act.act_id = aloc.act_id
  join BIE_LOCALIZACION loc on loc.bie_loc_id = aloc.bie_loc_id
  left join REMMASTER.DD_PRV_PROVINCIA prv on prv.dd_prv_id = loc.dd_prv_id
  left join DD_TCR_TIPO_COMERCIALIZAR tcr on tcr.dd_tcr_id = act.dd_tcr_id
  left join DD_EAC_ESTADO_ACTIVO eac on eac.dd_eac_id = act.dd_eac_id
  join REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''GTREE''
  JOIN dd_cra_cartera cra on cra.dd_cra_id = act.dd_cra_id
  JOIN rem01.act_ges_dist_gestores dist1 on dist1.COD_CARTERA = CRA.DD_CRA_CODIGO AND DIST1.tipo_gestor = tge.dd_tge_codigo
  where act.borrado = 0
                           )
    WHERE tipo_gestor IS NOT NULL

  UNION ALL
  /*Gestor Liberbank Residencial (Liberbank)*/
           SELECT act.act_id, dist1.cod_cartera, NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor tipo_gestor,
                  dist1.username username, dist1.nombre_usuario nombre
             FROM act_activo act JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (dist1.cod_cartera = dd_cra.dd_cra_codigo AND dist1.tipo_gestor = ''GLIBRES'')
           where act.borrado = 0

  UNION ALL
  /*Gestor Inversión Inmobiliaria (Liberbank)*/
           SELECT act.act_id, dist1.cod_cartera, NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor tipo_gestor,
                  dist1.username username, dist1.nombre_usuario nombre
             FROM act_activo act JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (dist1.cod_cartera = dd_cra.dd_cra_codigo AND dist1.tipo_gestor = ''GLIBINVINM'')
           where act.borrado = 0

    UNION ALL
  /*Gestor Singular/Terciario (Liberbank)*/
           SELECT act.act_id, dist1.cod_cartera, NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor tipo_gestor,
                  dist1.username username, dist1.nombre_usuario nombre
             FROM act_activo act JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (dist1.cod_cartera = dd_cra.dd_cra_codigo AND dist1.tipo_gestor = ''GLIBSINTER'')
           where act.borrado = 0

  UNION ALL
  /*Gestor Comité de Inversiones Inmobiliarias (Liberbank)*/
           SELECT act.act_id, dist1.cod_cartera, NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor tipo_gestor,
                  dist1.username username, dist1.nombre_usuario nombre
             FROM act_activo act JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (dist1.cod_cartera = dd_cra.dd_cra_codigo AND dist1.tipo_gestor = ''GCOIN'')
           where act.borrado = 0

  UNION ALL
  /*Gestor Comité Inmobiliario (Liberbank)*/
           SELECT act.act_id, dist1.cod_cartera, NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor tipo_gestor,
                  dist1.username username, dist1.nombre_usuario nombre
             FROM act_activo act JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (dist1.cod_cartera = dd_cra.dd_cra_codigo AND dist1.tipo_gestor = ''GCOINM'')
           where act.borrado = 0

  UNION ALL
  /*Gestor Comité de Dirección (Liberbank)*/
           SELECT act.act_id, dist1.cod_cartera, NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor tipo_gestor,
                  dist1.username username, dist1.nombre_usuario nombre
             FROM act_activo act JOIN dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (dist1.cod_cartera = dd_cra.dd_cra_codigo AND dist1.tipo_gestor = ''GCODI'')
           where act.borrado = 0';
V_MSQL2 := '
	UNION ALL
    /*Gestor de suelos*/
        SELECT 
            act.act_id, 
            TO_NUMBER (dd_cra.dd_cra_codigo) dd_cra_codigo, 
            TO_NUMBER (dd_eac.DD_EAC_CODIGO) dd_eac_codigo,
            NULL dd_tcr_codigo, dd_prov.dd_prv_codigo, 
            COALESCE (dist3.cod_municipio,dist2.cod_municipio,dist1.cod_municipio,dist0.cod_municipio) cod_municipio, 
            COALESCE (dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
            COALESCE (dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor, 
            COALESCE (dist3.username, dist2.username, dist1.username, dist0.username) username,
            COALESCE (dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
        FROM '||V_ESQUEMA||'.act_activo act 
            JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
            JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
            JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
            JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
            JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''GSUE''
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 ON (
                dist0.cod_cartera = dd_cra.dd_cra_codigo
                AND dist0.cod_provincia IS NULL
                AND dist0.cod_municipio IS NULL
                AND dist0.cod_postal IS NULL
                AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (
                dist1.cod_cartera = dd_cra.dd_cra_codigo
                AND dd_prov.dd_prv_codigo = dist1.cod_provincia
                AND dist1.cod_municipio IS NULL
                AND dist1.cod_postal IS NULL
                AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 ON (
                dist2.cod_cartera = dd_cra.dd_cra_codigo
                AND dd_prov.dd_prv_codigo = dist2.cod_provincia
                AND dist2.cod_municipio = dd_loc.dd_loc_codigo
                AND dist2.cod_postal IS NULL
                AND dist2.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 ON (
                dist3.cod_cartera = dd_cra.dd_cra_codigo
                AND dd_prov.dd_prv_codigo = dist3.cod_provincia
                AND dist3.cod_municipio = dd_loc.dd_loc_codigo
                AND dist3.cod_postal  = loc.BIE_LOC_COD_POST
                AND dist3.tipo_gestor = TGE.DD_TGE_CODIGO
            )   
        WHERE 
            act.borrado = 0 
            AND act.DD_TPA_ID = (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = ''01'')
            AND act.DD_EAC_ID = (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = ''01'')
    UNION ALL
    /*Supervisor de suelos*/
        SELECT 
            act.act_id, 
            TO_NUMBER (dd_cra.dd_cra_codigo) dd_cra_codigo, 
            TO_NUMBER (dd_eac.DD_EAC_CODIGO) dd_eac_codigo,
            NULL dd_tcr_codigo, dd_prov.dd_prv_codigo, 
            COALESCE (dist3.cod_municipio,dist2.cod_municipio,dist1.cod_municipio,dist0.cod_municipio) cod_municipio, 
            COALESCE (dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
            COALESCE (dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor, 
            COALESCE (dist3.username, dist2.username, dist1.username, dist0.username) username,
            COALESCE (dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
        FROM '||V_ESQUEMA||'.act_activo act 
            JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
            JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
            JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
            JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
            JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''SUPSUE''
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 ON (
                dist0.cod_cartera = dd_cra.dd_cra_codigo
                AND dist0.cod_provincia IS NULL
                AND dist0.cod_municipio IS NULL
                AND dist0.cod_postal IS NULL
                AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (
                dist1.cod_cartera = dd_cra.dd_cra_codigo
                AND dd_prov.dd_prv_codigo = dist1.cod_provincia
                AND dist1.cod_municipio IS NULL
                AND dist1.cod_postal IS NULL
                AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 ON (
                dist2.cod_cartera = dd_cra.dd_cra_codigo
                AND dd_prov.dd_prv_codigo = dist2.cod_provincia
                AND dist2.cod_municipio = dd_loc.dd_loc_codigo
                AND dist2.cod_postal IS NULL
                AND dist2.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 ON (
                dist3.cod_cartera = dd_cra.dd_cra_codigo
                AND dd_prov.dd_prv_codigo = dist3.cod_provincia
                AND dist3.cod_municipio = dd_loc.dd_loc_codigo
                AND dist3.cod_postal  = loc.BIE_LOC_COD_POST
                AND dist3.tipo_gestor = TGE.DD_TGE_CODIGO
            )   
        WHERE 
            act.borrado = 0 
            AND act.DD_TPA_ID = (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = ''01'')
            AND act.DD_EAC_ID = (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = ''01'')
    UNION ALL
    /*Gestor de edificación*/
        SELECT 
            act.act_id, 
            TO_NUMBER (dd_cra.dd_cra_codigo) dd_cra_codigo, 
            TO_NUMBER (dd_eac.DD_EAC_CODIGO) dd_eac_codigo,
            NULL dd_tcr_codigo, dd_prov.dd_prv_codigo, 
            COALESCE (dist3.cod_municipio,dist2.cod_municipio,dist1.cod_municipio,dist0.cod_municipio) cod_municipio, 
            COALESCE (dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
            COALESCE (dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor, 
            COALESCE (dist3.username, dist2.username, dist1.username, dist0.username) username,
            COALESCE (dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
        FROM '||V_ESQUEMA||'.act_activo act 
            JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
            JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
            JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
            JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
			JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''GEDI''
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 ON (
                dist0.cod_cartera = dd_cra.dd_cra_codigo
                AND dist0.cod_provincia IS NULL
                AND dist0.cod_municipio IS NULL
                AND dist0.cod_postal IS NULL
                AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
            ) 
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (
                dist1.cod_cartera = dd_cra.dd_cra_codigo
                AND dd_prov.dd_prv_codigo = dist1.cod_provincia
                AND dist1.cod_municipio IS NULL
                AND dist1.cod_postal IS NULL
                AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 ON (
                dist2.cod_cartera = dd_cra.dd_cra_codigo
                AND dd_prov.dd_prv_codigo = dist2.cod_provincia
                AND dist2.cod_municipio = dd_loc.dd_loc_codigo
                AND dist2.cod_postal IS NULL
                AND dist2.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 ON (
                dist3.cod_cartera = dd_cra.dd_cra_codigo
                AND dd_prov.dd_prv_codigo = dist3.cod_provincia
                AND dist3.cod_municipio = dd_loc.dd_loc_codigo
                AND dist3.cod_postal  = loc.BIE_LOC_COD_POST
                AND dist3.tipo_gestor = TGE.DD_TGE_CODIGO
            )   
        WHERE 
            act.borrado = 0 
            AND act.DD_TPA_ID != (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = ''01'')
            AND act.DD_EAC_ID IN (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO IN (''09'', ''02'', ''06'', ''11'', ''10'', ''05'', ''08'', ''07''))
    UNION ALL
    /*Supervisor de edificación*/
        SELECT 
            act.act_id, 
            TO_NUMBER (dd_cra.dd_cra_codigo) dd_cra_codigo, 
            TO_NUMBER (dd_eac.DD_EAC_CODIGO) dd_eac_codigo,
            NULL dd_tcr_codigo, 
			dd_prov.dd_prv_codigo, 
            COALESCE (dist3.cod_municipio,dist2.cod_municipio,dist1.cod_municipio,dist0.cod_municipio) cod_municipio, 
            COALESCE (dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
            COALESCE (dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor, 
            COALESCE (dist3.username, dist2.username, dist1.username, dist0.username) username,
            COALESCE (dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
        FROM '||V_ESQUEMA||'.act_activo act 
            JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
            JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
            JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
            JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
			JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''SUPEDI''
			LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 ON (
                dist0.cod_cartera = dd_cra.dd_cra_codigo
                AND dist0.cod_provincia IS NULL
                AND dist0.cod_municipio IS NULL
                AND dist0.cod_postal IS NULL
                AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (
                dist1.cod_cartera = dd_cra.dd_cra_codigo
                AND dd_prov.dd_prv_codigo = dist1.cod_provincia
                AND dist1.cod_municipio IS NULL
                AND dist1.cod_postal IS NULL
                AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 ON (
                dist2.cod_cartera = dd_cra.dd_cra_codigo
                AND dd_prov.dd_prv_codigo = dist2.cod_provincia
                AND dist2.cod_municipio = dd_loc.dd_loc_codigo
                AND dist2.cod_postal IS NULL
                AND dist2.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 ON (
                dist3.cod_cartera = dd_cra.dd_cra_codigo
                AND dd_prov.dd_prv_codigo = dist3.cod_provincia
                AND dist3.cod_municipio = dd_loc.dd_loc_codigo
                AND dist3.cod_postal  = loc.BIE_LOC_COD_POST
                AND dist3.tipo_gestor = TGE.DD_TGE_CODIGO
            )   
        WHERE 
            act.borrado = 0 
            AND act.DD_TPA_ID != (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = ''01'')
            AND act.DD_EAC_ID IN (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO IN (''09'', ''02'', ''06'', ''11'', ''10'', ''05'', ''08'', ''07''))
	UNION ALL

	/*Gestor / supervisor de alquileres*/
	SELECT act.act_id, NULL dd_cra_codigo, NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor, dist1.username username,
	                  dist1.nombre_usuario nombre
	             FROM act_activo act JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON dist1.tipo_gestor IN (''GALQ'', ''SUALQ'')
				 JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO ACT_PTA ON ACT_PTA.ACT_ID = ACT.ACT_ID 
	           where act.borrado = 0 AND ACT_PTA.CHECK_HPM = 1

';

    --DBMS_OUTPUT.PUT_LINE(  V_MSQL); 
	EXECUTE IMMEDIATE V_MSQL||V_MSQL2;

	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'... Vista creada.');

	COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;
