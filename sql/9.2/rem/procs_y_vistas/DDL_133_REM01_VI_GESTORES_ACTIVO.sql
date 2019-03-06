--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5553
--## PRODUCTO=NO
--## Finalidad: Crear vista gestores activo
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial Pau Serrano Rodrigo
--##    0.2 Cambio de GCBO a HAYAGBOINM / HAYASBOFIN SOG
--##    0.3 Cambio de GESRES y SUPRES.
--##    0.4 Cambio de SFORM
--##    0.5 HREOS-4844- SHG - AÑADIMOS GESTCOMALQ y SUPCOMALQ
--##	0.6 Se añade GPUBL y SPUBL.
--##	0.7 Se quita las restricción de filtrar por el tipo de destino comercial para los gestores GESTCOMALQ y SUPCOMALQ (HREOS-5090)
--##    0.8 Se añade el Supervisor comercial Backoffice Inmobiliario
--##    0.9 Se añade filtro tipo comercializar para Backoffice Inmobiliario
--##    0.10 Se añade filtro codigo postal para Backoffice Inmobiliario
--##	0.11 Se modifica la vista entera para añadirle el código de la subcartera
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
 
    V_MSQL1 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar    
    V_MSQL2 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar    
    V_MSQL3 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar  
    V_MSQL4 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar  
    V_MSQL5 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar  
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

V_MSQL1 := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.' || V_TEXT_VISTA || ' ("ACT_ID", "DD_CRA_CODIGO", "DD_SCR_CODIGO", "DD_EAC_CODIGO", "DD_TCR_CODIGO", "DD_PRV_CODIGO", "DD_LOC_CODIGO", "COD_POSTAL", "TIPO_GESTOR", "USERNAME", "NOMBRE") 
AS SELECT "ACT_ID", "DD_CRA_CODIGO", "DD_SCR_CODIGO", "DD_EAC_CODIGO", "DD_TCR_CODIGO", "DD_PRV_CODIGO", "DD_LOC_CODIGO", "COD_POSTAL", "TIPO_GESTOR", "USERNAME", "NOMBRE"
/* ---VERSION 0.5 -----*/
     FROM (
/*Gestores de grupo*/
SELECT act.act_id, NULL dd_cra_codigo, NULL dd_scr_codigo, NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor, dist1.username username,
                  dist1.nombre_usuario nombre
             FROM '||V_ESQUEMA||'.act_activo act 
				  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON dist1.tipo_gestor IN (''GADM'', ''GMARK'', ''GPREC'', ''GTOPDV'', ''GTOPLUS'', ''GESTLLA'', ''GADMT'', ''GFSV'', ''GCAL'', ''GESMIN'', ''SUPMIN'', ''SUPADM'')
           where act.borrado = 0
           UNION ALL
/*Gestor de grupo - SUPERVISOR COMERCIAL BACKOFFICE*/
SELECT  act.act_id , 
                TO_NUMBER(COALESCE(dist2.cod_cartera,dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
                TO_NUMBER(COALESCE(dist2.cod_subcartera,dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera, 
                NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                COALESCE(dist2.tipo_gestor,dist1.tipo_gestor,dist0.tipo_gestor) tipo_gestor, 
                COALESCE(dist2.username,dist1.username,dist0.username) username,
                COALESCE(dist2.nombre_usuario,dist1.nombre_usuario,dist0.nombre_usuario) nombre
            FROM '||V_ESQUEMA||'.ACT_ACTIVO act
            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on act.dd_cra_id = cra.dd_cra_id
            JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA scr on act.dd_scr_id = scr.dd_scr_id AND cra.dd_cra_id = scr.dd_cra_id
            JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''GBACKOFFICE''
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                ON (dist0.tipo_gestor = TGE.DD_TGE_CODIGO
                    AND dist0.cod_cartera IS NULL
                    AND dist0.cod_subcartera IS NULL)
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
                ON (dist1.tipo_gestor = TGE.DD_TGE_CODIGO
                    AND dist1.cod_cartera = cra.dd_cra_codigo
                    AND dist1.cod_subcartera IS NULL)
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
                ON (dist2.tipo_gestor = TGE.DD_TGE_CODIGO
                    AND dist2.cod_cartera = cra.dd_cra_codigo
                    AND dist2.cod_subcartera = scr.dd_scr_codigo)
            where act.borrado = 0 
                    AND (dist0.tipo_gestor = ''GBACKOFFICE'' 
                      OR dist1.tipo_gestor = ''GBACKOFFICE'' 
                      OR dist2.tipo_gestor = ''GBACKOFFICE'') 
           UNION ALL
/*Gestor de grupo - SUPERVISOR COMERCIAL BACKOFFICE LIBERBANK*/
SELECT  act.act_id, 
                    TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
                    TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera, 
                    NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                    COALESCE(dist1.tipo_gestor,dist0.tipo_gestor) tipo_gestor, 
                    COALESCE(dist1.username,dist0.username) username,
                    COALESCE(dist1.nombre_usuario,dist0.nombre_usuario) nombre
                FROM '||V_ESQUEMA||'.ACT_ACTIVO act
                LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on act.dd_cra_id = cra.dd_cra_id
                LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA scr on act.dd_scr_id = scr.dd_scr_id AND scr.dd_scr_id = act.dd_scr_id
                     JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''SBACKOFFICEINMLIBER''
                LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                    ON (dist0.tipo_gestor = TGE.DD_TGE_CODIGO
                        AND TO_NUMBER(dist0.cod_cartera) = TO_NUMBER(cra.dd_cra_codigo)
                        AND dist0.cod_subcartera IS NULL)
                LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
                    ON (dist1.tipo_gestor = TGE.DD_TGE_CODIGO
                        AND TO_NUMBER(dist1.cod_cartera) = TO_NUMBER(cra.dd_cra_codigo)
                        AND TO_NUMBER(dist1.cod_subcartera) = TO_NUMBER(scr.dd_scr_codigo))
                where act.borrado = 0 
                    AND (dist0.tipo_gestor = ''SBACKOFFICEINMLIBER'' 
                      OR dist1.tipo_gestor = ''SBACKOFFICEINMLIBER'')
           UNION ALL
/*Gestor capa de control*/
           SELECT act.act_id, 
                  TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
                  TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera ,
                  NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                  COALESCE(dist1.tipo_gestor,dist0.tipo_gestor)  tipo_gestor,
                  COALESCE(dist1.username,dist0.username)  username, 
                  COALESCE(dist1.nombre_usuario,dist0.nombre_usuario) nombre
             FROM '||V_ESQUEMA||'.act_activo act 
				  JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
				  JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
                  JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR tge on TGE.DD_TGE_CODIGO = ''GCCBANKIA''
                  LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                    ON (dist0.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist0.cod_subcartera IS NULL
                        AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO)
                  LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
                    ON (dist1.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
                        AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO)
           where act.borrado = 0 
                AND (DIST0.TIPO_GESTOR = ''GCCBANKIA'' 
                  OR DIST1.TIPO_GESTOR = ''GCCBANKIA'')
           UNION ALL
/*Gestor Comercial BackOffice Inmobiliario*/
           SELECT act.act_id, 
                  TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
                  TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera ,
                  NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                  COALESCE(dist1.tipo_gestor,dist0.tipo_gestor)  tipo_gestor,
                  COALESCE(dist1.username,dist0.username)  username, 
                  COALESCE(dist1.nombre_usuario,dist0.nombre_usuario)  nombre
             FROM '||V_ESQUEMA||'.act_activo act 
				  JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
				  JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
                  JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BL ON BL.BIE_ID = ACT.BIE_ID
                  LEFT JOIN '||V_ESQUEMA||'.dd_tcr_tipo_comercializar dd_tcr ON dd_tcr.dd_tcr_id = act.dd_tcr_id
                  JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = BL.DD_PRV_ID 
                  LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_ID = BL.DD_LOC_ID 
                  LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                    ON (dist0.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist0.cod_subcartera IS NULL
                        AND dist0.tipo_gestor = ''HAYAGBOINM'' 
                        AND PRV.DD_PRV_CODIGO = dist0.COD_PROVINCIA 
                        AND LOC.DD_LOC_CODIGO = NVL(dist0.COD_MUNICIPIO,LOC.DD_LOC_CODIGO)  
                        AND (dist0.COD_TIPO_COMERZIALZACION IS NULL OR DD_TCR.DD_TCR_CODIGO = NVL(dist0.COD_TIPO_COMERZIALZACION,DD_TCR.DD_TCR_CODIGO))
                        AND (dist0.COD_POSTAL IS NULL OR BL.BIE_LOC_COD_POST = NVL(dist0.COD_POSTAL,BL.BIE_LOC_COD_POST)))
                  LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
                    ON (dist1.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
                        AND dist1.tipo_gestor = ''HAYAGBOINM'' 
                        AND PRV.DD_PRV_CODIGO = dist1.COD_PROVINCIA 
                        AND LOC.DD_LOC_CODIGO = NVL(dist1.COD_MUNICIPIO,LOC.DD_LOC_CODIGO)  
                        AND (DIST1.COD_TIPO_COMERZIALZACION IS NULL OR DD_TCR.DD_TCR_CODIGO = NVL(dist1.COD_TIPO_COMERZIALZACION,DD_TCR.DD_TCR_CODIGO))
                        AND (DIST1.COD_POSTAL IS NULL OR BL.BIE_LOC_COD_POST = NVL(DIST1.COD_POSTAL,BL.BIE_LOC_COD_POST)))
           where act.borrado = 0
           UNION ALL
/*Supervisor Comercial BackOffice Inmobiliario*/
           SELECT act.act_id, 
                  TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)), 
                  TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)),
                  NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                  COALESCE(dist1.tipo_gestor,dist0.tipo_gestor)tipo_gestor,
                  COALESCE(dist1.username,dist0.username) username, 
                  COALESCE(dist1.nombre_usuario,dist0.nombre_usuario) nombre
             FROM '||V_ESQUEMA||'.act_activo act 
				  JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
				  JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
                  JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BL ON BL.BIE_ID = ACT.BIE_ID
				  JOIN '||V_ESQUEMA||'.dd_tcr_tipo_comercializar dd_tcr ON dd_tcr.dd_tcr_id = act.dd_tcr_id
                  JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = BL.DD_PRV_ID
                  LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_ID = BL.DD_LOC_ID
                  LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
                        ON (dist0.cod_cartera = dd_cra.dd_cra_codigo  
                            AND dist0.cod_subcartera IS NULL
                            AND dist0.tipo_gestor = ''HAYASBOINM'' 
                            AND PRV.DD_PRV_CODIGO = dist0.COD_PROVINCIA 
                            AND LOC.DD_LOC_CODIGO = NVL(dist0.COD_MUNICIPIO,LOC.DD_LOC_CODIGO) 
                            AND (DIST0.COD_TIPO_COMERZIALZACION IS NULL OR DD_TCR.DD_TCR_CODIGO = NVL(dist0.COD_TIPO_COMERZIALZACION,DD_TCR.DD_TCR_CODIGO)))
                  LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
                        ON (dist1.cod_cartera = dd_cra.dd_cra_codigo  
                            AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
                            AND dist1.tipo_gestor = ''HAYASBOINM'' 
                            AND PRV.DD_PRV_CODIGO = dist1.COD_PROVINCIA 
                            AND LOC.DD_LOC_CODIGO = NVL(dist1.COD_MUNICIPIO,LOC.DD_LOC_CODIGO) 
                            AND (DIST1.COD_TIPO_COMERZIALZACION IS NULL OR DD_TCR.DD_TCR_CODIGO = NVL(dist1.COD_TIPO_COMERZIALZACION,DD_TCR.DD_TCR_CODIGO)))          
           where act.borrado = 0
           UNION ALL
/*Gestor del activo*/
SELECT act.act_id,
	   TO_NUMBER( COALESCE (dist9.cod_cartera,dist8.cod_cartera,dist7.cod_cartera,dist6.cod_cartera,dist5.cod_cartera,dist4.cod_cartera,dist3.cod_cartera,dist2.cod_cartera,dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
	   TO_NUMBER( COALESCE (dist9.cod_subcartera,dist8.cod_subcartera,dist7.cod_subcartera,dist6.cod_subcartera,dist5.cod_subcartera,dist4.cod_subcartera,dist3.cod_subcartera,dist2.cod_subcartera,dist1.cod_subcartera,dist0.cod_subcartera)) dd_scr_subcartera, 
	   TO_NUMBER (COALESCE (dist9.cod_estado_activo,dist8.cod_estado_activo,dist7.cod_estado_activo,dist6.cod_estado_activo,dist5.cod_estado_activo,dist4.cod_estado_activo,dist3.cod_estado_activo,dist2.cod_estado_activo,dist1.cod_estado_activo,dist0.cod_estado_activo)) dd_eac_codigo,
	   NULL dd_tcr_codigo, 
	   COALESCE (dist9.cod_provincia,dist8.cod_provincia, dist7.cod_provincia, dist6.cod_provincia, dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) cod_provincia,
       COALESCE (dist9.cod_municipio,dist8.cod_municipio,dist7.cod_municipio,dist6.cod_municipio,dist5.cod_municipio,dist4.cod_municipio,dist3.cod_municipio,dist2.cod_municipio,dist1.cod_municipio,dist0.cod_municipio) cod_municipio, 
       COALESCE (dist9.cod_postal,dist8.cod_postal,dist7.cod_postal,dist6.cod_postal,dist5.cod_postal,dist4.cod_postal,dist3.cod_postal,dist2.cod_postal,dist1.cod_postal,dist0.cod_postal) cod_postal,
       COALESCE (dist9.tipo_gestor,dist8.tipo_gestor,dist7.tipo_gestor,dist6.tipo_gestor,dist5.tipo_gestor,dist4.tipo_gestor,dist3.tipo_gestor,dist2.tipo_gestor,dist1.tipo_gestor,dist0.tipo_gestor) AS tipo_gestor, 
       COALESCE (dist9.username,dist8.username,dist7.username,dist6.username,dist5.username,dist4.username,dist3.username,dist2.username,dist1.username,dist0.username) username,
       COALESCE (dist9.nombre_usuario,dist8.nombre_usuario,dist7.nombre_usuario,dist6.nombre_usuario,dist5.nombre_usuario,dist4.nombre_usuario,dist3.nombre_usuario,dist2.nombre_usuario,dist1.nombre_usuario,dist0.nombre_usuario) nombre
  FROM '||V_ESQUEMA||'.act_activo act 
	   JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       LEFT JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
       JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
                ON (dist0.cod_estado_activo IS NULL
                  AND dist0.cod_cartera = dd_cra.dd_cra_codigo
                    AND dist0.cod_subcartera IS NULL
                    AND dist0.cod_provincia = dd_prov.dd_prv_codigo
                    AND dist0.cod_municipio IS NULL
                    AND dist0.cod_postal IS NULL
                    AND dist0.tipo_gestor = ''GACT''
                    ) 
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
                ON (dist1.cod_estado_activo IS NULL
                  AND dist1.cod_cartera = dd_cra.dd_cra_codigo
                    AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
                    AND dist1.cod_provincia = dd_prov.dd_prv_codigo
                    AND dist1.cod_municipio IS NULL
                    AND dist1.cod_postal IS NULL
                    AND dist1.tipo_gestor = ''GACT''
                    ) 
           left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
           ON (dist2.cod_estado_activo = dd_eac.dd_eac_codigo 
               AND dist2.cod_cartera = dd_cra.dd_cra_codigo
               AND dist2.cod_subcartera IS NULL
               AND dist2.cod_provincia = dd_prov.dd_prv_codigo
               AND dist2.cod_municipio IS NULL
               AND dist2.cod_postal IS NULL
               AND dist2.tipo_gestor = ''GACT''
              )
           left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
           ON (dist3.cod_estado_activo = dd_eac.dd_eac_codigo 
               AND dist3.cod_cartera = dd_cra.dd_cra_codigo
               AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
               AND dist3.cod_provincia = dd_prov.dd_prv_codigo
               AND dist3.cod_municipio IS NULL
               AND dist3.cod_postal IS NULL
               AND dist3.tipo_gestor = ''GACT''
              )
           left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4
           ON (dist4.cod_estado_activo IS NULL
               AND dist4.cod_cartera = dd_cra.dd_cra_codigo
               AND dist4.cod_subcartera IS NULL
               AND dist4.cod_provincia = dd_prov.dd_prv_codigo
               AND dist4.cod_municipio = dd_loc.dd_loc_codigo
               AND dist4.cod_postal IS NULL
               AND dist4.tipo_gestor = ''GACT''
              )
           left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5
           ON (dist5.cod_estado_activo IS NULL
               AND dist5.cod_cartera = dd_cra.dd_cra_codigo
               AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
               AND dist5.cod_provincia = dd_prov.dd_prv_codigo
               AND dist5.cod_municipio = dd_loc.dd_loc_codigo
               AND dist5.cod_postal IS NULL
               AND dist5.tipo_gestor = ''GACT''
              )
           left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6
           ON (dist6.cod_estado_activo = dd_eac.dd_eac_codigo 
               AND dist6.cod_cartera = dd_cra.dd_cra_codigo
               AND dist6.cod_subcartera IS NULL
               AND dist6.cod_provincia = dd_prov.dd_prv_codigo
               AND dist6.cod_municipio = dd_loc.dd_loc_codigo
               AND dist6.cod_postal IS NULL
               AND dist6.tipo_gestor = ''GACT''
              )
              left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7
           ON (dist7.cod_estado_activo = dd_eac.dd_eac_codigo 
               AND dist7.cod_cartera = dd_cra.dd_cra_codigo
               AND dist7.cod_subcartera = dd_scr.dd_scr_codigo
               AND dist7.cod_provincia = dd_prov.dd_prv_codigo
               AND dist7.cod_municipio = dd_loc.dd_loc_codigo
               AND dist7.cod_postal IS NULL
               AND dist7.tipo_gestor = ''GACT''
              )
            left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist8
               ON (dist8.cod_estado_activo = dd_eac.dd_eac_codigo 
                   AND dist8.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist8.cod_subcartera IS NULL
                   AND dist8.cod_provincia = dd_prov.dd_prv_codigo 
                   AND dist8.cod_municipio = dd_loc.dd_loc_codigo
                   AND dist8.cod_postal  = loc.BIE_LOC_COD_POST
                   AND dist8.tipo_gestor = ''GACT''
                  )
           left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist9
           ON (dist9.cod_estado_activo = dd_eac.dd_eac_codigo 
               AND dist9.cod_cartera = dd_cra.dd_cra_codigo
               AND dist9.cod_subcartera = dd_scr.dd_scr_codigo
               AND dist9.cod_provincia = dd_prov.dd_prv_codigo
               AND dist9.cod_municipio = dd_loc.dd_loc_codigo
               AND dist9.cod_postal  = loc.BIE_LOC_COD_POST
               AND dist9.tipo_gestor = ''GACT''
              )   
          where act.borrado = 0             
           UNION ALL
/*supervisor del activo*/
SELECT act.act_id, 
        TO_NUMBER (COALESCE (dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) dd_cra_codigo,
        TO_NUMBER (COALESCE (dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) dd_scr_subcartera, 
        TO_NUMBER (COALESCE (dist7.cod_estado_activo, dist6.cod_estado_activo, dist5.cod_estado_activo, dist4.cod_estado_activo, dist3.cod_estado_activo, dist2.cod_estado_activo, dist1.cod_estado_activo, dist0.cod_estado_activo )) dd_eac_codigo,
        NULL dd_tcr_codigo, 
        COALESCE (dist7.cod_provincia, dist6.cod_provincia, dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) cod_provincia, 
        COALESCE (dist7.cod_municipio, dist6.cod_municipio, dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) cod_municipio, 
        COALESCE (dist7.cod_postal, dist6.cod_postal, dist5.cod_postal, dist4.cod_postal, dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
        COALESCE (dist7.tipo_gestor, dist6.tipo_gestor, dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor, 
        COALESCE (dist7.username, dist6.username, dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username) username,
        COALESCE (dist7.nombre_usuario, dist6.nombre_usuario, dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
  FROM '||V_ESQUEMA||'.act_activo act 
	   JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       LEFT JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
       JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
        ON (dist0.cod_estado_activo IS NULL
            AND dist0.cod_cartera = dd_cra.dd_cra_codigo
            AND dist0.cod_subcartera IS NULL
            AND dist0.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist0.cod_municipio IS NULL
            AND dist0.cod_postal IS NULL
            AND dist0.tipo_gestor = ''SUPACT''
            )
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
        ON (dist1.cod_estado_activo IS NULL
            AND dist1.cod_cartera = dd_cra.dd_cra_codigo
            AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
            AND dist1.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist1.cod_municipio IS NULL
            AND dist1.cod_postal IS NULL
            AND dist1.tipo_gestor = ''SUPACT''
            )
        left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
       ON (dist2.cod_estado_activo = dd_eac.dd_eac_codigo 
            AND dist2.cod_cartera = dd_cra.dd_cra_codigo
            AND dist2.cod_subcartera IS NULL
            AND dist2.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist2.cod_municipio IS NULL
            AND dist2.cod_postal IS NULL
            AND dist2.tipo_gestor = ''SUPACT''
            )
        left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
       ON (dist3.cod_estado_activo = dd_eac.dd_eac_codigo 
            AND dist3.cod_cartera = dd_cra.dd_cra_codigo
            AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
            AND dist3.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist3.cod_municipio IS NULL
            AND dist3.cod_postal IS NULL
            AND dist3.tipo_gestor = ''SUPACT''
            )
        left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4
        ON (dist4.cod_estado_activo = dd_eac.dd_eac_codigo
            AND dist4.cod_cartera = dd_cra.dd_cra_codigo
            AND dist4.cod_subcartera IS NULL
            AND dist4.cod_provincia = dd_prov.dd_prv_codigo
            AND dist4.cod_municipio = dd_loc.dd_loc_codigo
            AND dist4.cod_postal IS NULL
            AND dist4.tipo_gestor = ''SUPACT''
            )
        left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5
        ON (dist5.cod_estado_activo = dd_eac.dd_eac_codigo
            AND dist5.cod_cartera = dd_cra.dd_cra_codigo
            AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
            AND dist5.cod_provincia = dd_prov.dd_prv_codigo
            AND dist5.cod_municipio = dd_loc.dd_loc_codigo
            AND dist5.cod_postal IS NULL
            AND dist5.tipo_gestor = ''SUPACT''
            )
        left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6
        ON (dist6.cod_estado_activo = dd_eac.dd_eac_codigo 
            AND dist6.cod_cartera = dd_cra.dd_cra_codigo
            AND dist6.cod_subcartera IS NULL
            AND dist6.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist6.cod_municipio = dd_loc.dd_loc_codigo
            AND dist6.cod_postal  = loc.BIE_LOC_COD_POST
            AND dist6.tipo_gestor = ''SUPACT''
            ) 
        left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7
        ON (dist7.cod_estado_activo = dd_eac.dd_eac_codigo
            AND dist7.cod_cartera = dd_cra.dd_cra_codigo
            AND dist7.cod_subcartera = dd_scr.dd_scr_codigo
            AND dist7.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist7.cod_municipio = dd_loc.dd_loc_codigo
            AND dist7.cod_postal  = loc.BIE_LOC_COD_POST
            AND dist7.tipo_gestor = ''SUPACT''
            )   
          where act.borrado = 0                 
           UNION ALL';
V_MSQL2 := '/*Gestoría de admisión*/
SELECT act.act_id, 
       TO_NUMBER(COALESCE(dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) cod_cartera, 
	   TO_NUMBER(COALESCE (dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera )) dd_scr_subcartera,
       TO_NUMBER (COALESCE(dist1.cod_estado_activo, dist0.cod_estado_activo)) cod_estado_activo, 
       NULL dd_tcr_codigo, 
       COALESCE (dist3.cod_provincia, dist2.cod_provincia) cod_provincia, 
       COALESCE (dist5.cod_municipio, dist4.cod_municipio) cod_municipio,
       COALESCE (dist7.cod_postal, dist6.cod_postal) cod_postal,
       COALESCE (dist7.tipo_gestor, dist6.tipo_gestor, dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor, 
       COALESCE (dist7.username, dist6.username, dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username ) username,
       COALESCE (dist7.nombre_usuario, dist6.nombre_usuario, dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario ) nombre
  FROM '||V_ESQUEMA||'.act_activo act JOIN act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
       JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
        ON (dist0.cod_estado_activo  = dd_eac.dd_eac_codigo 
            AND dist0.cod_cartera = dd_cra.dd_cra_codigo
            AND dist0.cod_subcartera IS NULL
            AND dist0.tipo_gestor = ''GGADM'')
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
        ON (dist1.cod_estado_activo  = dd_eac.dd_eac_codigo 
            AND dist1.cod_cartera = dd_cra.dd_cra_codigo
            AND TO_NUMBER(dist1.cod_subcartera) = TO_NUMBER(DD_SCR.DD_SCR_CODIGO)
            AND dist1.tipo_gestor = ''GGADM'')
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 
        ON (dist2.cod_provincia  = dd_prov.dd_prv_codigo
            AND dist2.cod_cartera = dd_cra.dd_cra_codigo
            AND dist2.cod_subcartera IS NULL
            AND dist2.tipo_gestor = ''GGADM'')
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 
        ON (dist3.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist3.cod_cartera = dd_cra.dd_cra_codigo
            AND TO_NUMBER(dist3.cod_subcartera) = TO_NUMBER(DD_SCR.DD_SCR_CODIGO)
            AND dist3.tipo_gestor = ''GGADM'')
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4 
        ON (dist4.cod_municipio  = dd_loc.dd_loc_codigo  
            AND dist4.cod_cartera = dd_cra.dd_cra_codigo
            AND dist4.cod_subcartera IS NULL
            AND dist4.tipo_gestor = ''GGADM'')
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5 
        ON (dist5.cod_municipio = dd_loc.dd_loc_codigo 
            AND dist5.cod_cartera = dd_cra.dd_cra_codigo
            AND TO_NUMBER(dist5.cod_subcartera) = TO_NUMBER(DD_SCR.DD_SCR_CODIGO)
            AND dist5.tipo_gestor = ''GGADM'')
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6 
        ON (dist6.cod_postal = loc.bie_loc_cod_post 
            AND dist6.cod_cartera = dd_cra.dd_cra_codigo
            AND dist6.cod_subcartera IS NULL
            AND dist6.tipo_gestor = ''GGADM'')
       LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7 
        ON (dist7.cod_postal = loc.bie_loc_cod_post 
            AND dist7.cod_cartera = dd_cra.dd_cra_codigo
            AND TO_NUMBER(dist7.cod_subcartera) = TO_NUMBER(DD_SCR.DD_SCR_CODIGO)
            AND dist7.tipo_gestor = ''GGADM'')
    where act.borrado = 0
           UNION ALL
/*Gestoría de administración*/
           SELECT DISTINCT act.act_id, 
                TO_NUMBER (COALESCE (dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) cod_cartera, 
                TO_NUMBER (COALESCE (dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) cod_subcartera,
                TO_NUMBER (COALESCE(dist1.cod_estado_activo,dist0.cod_estado_activo)) cod_estado_activo, 
                NULL dd_tcr_codigo, 
                COALESCE(dist3.cod_provincia, dist2.cod_provincia) cod_provincia, 
                COALESCE (dist5.cod_municipio, dist4.cod_municipio )  cod_municipio, 
                COALESCE (dist7.cod_postal, dist6.cod_postal ) cod_postal,
                COALESCE (dist7.tipo_gestor, dist6.tipo_gestor, dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor ) AS tipo_gestor,
                COALESCE (dist7.username, dist6.username, dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username ) username,
                COALESCE (dist7.nombre_usuario, dist6.nombre_usuario, dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario ) nombre
            FROM '||V_ESQUEMA||'.act_activo act 
            JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
            JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
            JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
            JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
            LEFT JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
            LEFT JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                ON (dist0.cod_estado_activo = dd_eac.dd_eac_codigo 
                    AND dist0.cod_cartera = dd_cra.dd_cra_codigo 
                    AND dist0.cod_subcartera IS NULL
                    AND dist0.tipo_gestor = ''GIAADMT'')
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
                ON (dist1.cod_estado_activo = dd_eac.dd_eac_codigo  
                    AND dist1.cod_cartera = dd_cra.dd_cra_codigo 
                    AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
                    AND dist1.tipo_gestor = ''GIAADMT'')
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 
                ON (dist2.cod_provincia = dd_prov.dd_prv_codigo 
                    AND dist2.cod_cartera = dd_cra.dd_cra_codigo 
                    AND dist2.cod_subcartera IS NULL
                    AND dist2.tipo_gestor = ''GIAADMT'')
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 
                ON (dist3.cod_provincia = dd_prov.dd_prv_codigo 
                    AND dist3.cod_cartera = dd_cra.dd_cra_codigo 
                    AND dist3.cod_subcartera = dd_scr.dd_scr_codigo 
                    AND dist3.tipo_gestor = ''GIAADMT'')
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4 
                ON (dist4.cod_municipio = dd_loc.dd_loc_codigo  
                    AND dist4.cod_cartera = dd_cra.dd_cra_codigo 
                    AND dist4.cod_subcartera IS NULL
                    AND dist4.tipo_gestor = ''GIAADMT'')
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5 
                ON (dist5.cod_municipio = dd_loc.dd_loc_codigo  
                    AND dist5.cod_cartera = dd_cra.dd_cra_codigo 
                    AND dist5.cod_subcartera = dd_scr.dd_scr_codigo 
                    AND dist5.tipo_gestor = ''GIAADMT'')
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6 
                ON (dist6.cod_postal = loc.bie_loc_cod_post  
                    AND dist6.cod_cartera = dd_cra.dd_cra_codigo 
                    AND dist6.cod_subcartera IS NULL
                    AND dist6.tipo_gestor = ''GIAADMT'')
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7 
                ON (dist7.cod_postal = loc.bie_loc_cod_post  
                    AND dist7.cod_cartera = dd_cra.dd_cra_codigo 
                    AND dist7.cod_subcartera = dd_scr.dd_scr_codigo 
                    AND dist7.tipo_gestor = ''GIAADMT'')
            where act.borrado = 0
           UNION ALL
/*Gestoría de formalización*/
           SELECT act.act_id, 
        TO_NUMBER (COALESCE (dist9.cod_cartera ,dist8.cod_cartera ,dist7.cod_cartera ,dist6.cod_cartera ,dist5.cod_cartera ,dist4.cod_cartera ,dist3.cod_cartera ,dist2.cod_cartera ,dist1.cod_cartera ,dist0.cod_cartera )) cod_cartera, 
        TO_NUMBER (COALESCE (dist9.cod_subcartera ,dist8.cod_subcartera ,dist7.cod_subcartera ,dist6.cod_subcartera ,dist5.cod_subcartera ,dist4.cod_subcartera ,dist3.cod_subcartera ,dist2.cod_subcartera ,dist1.cod_subcartera ,dist0.cod_subcartera )) cod_subcartera,
        TO_NUMBER (COALESCE(dist9.cod_estado_activo, dist8.cod_estado_activo)) cod_estado_activo, 
        NULL dd_tcr_codigo, 
        COALESCE(dist7.cod_provincia, dist6.cod_provincia) cod_provincia, 
        COALESCE (dist5.cod_municipio ,dist4.cod_municipio ) cod_municipio,
        COALESCE (dist3.cod_postal ,dist2.cod_postal ) cod_postal,
        COALESCE (dist9.tipo_gestor ,dist8.tipo_gestor ,dist7.tipo_gestor ,dist6.tipo_gestor ,dist5.tipo_gestor ,dist4.tipo_gestor ,dist3.tipo_gestor ,dist2.tipo_gestor ,dist1.tipo_gestor ,dist0.tipo_gestor) AS tipo_gestor,
        COALESCE (dist9.username ,dist8.username ,dist7.username ,dist6.username ,dist5.username ,dist4.username ,dist3.username ,dist2.username ,dist1.username ,dist0.username) username,
        COALESCE (dist9.nombre_usuario ,dist8.nombre_usuario ,dist7.nombre_usuario ,dist6.nombre_usuario ,dist5.nombre_usuario ,dist4.nombre_usuario ,dist3.nombre_usuario ,dist2.nombre_usuario ,dist1.nombre_usuario ,dist0.nombre_usuario) nombre
    FROM '||V_ESQUEMA||'.act_activo act 
    JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
    JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
    JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
    JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
    JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
    JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
    JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
	LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
       ON (dist0.cod_cartera = dd_cra.dd_cra_codigo 
           AND dist0.cod_subcartera IS NULL
           AND dist0.tipo_gestor = ''GIAFORM'' 
           AND dist0.cod_provincia is null
           )
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
        ON (dist1.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
            AND dist1.tipo_gestor = ''GIAFORM'' 
            )
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 
        ON (dist2.cod_postal = loc.bie_loc_cod_post
            AND dist2.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist2.cod_subcartera IS NULL
            AND dist2.tipo_gestor = ''GIAFORM'')
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 
        ON (dist3.cod_postal = loc.bie_loc_cod_post  
            AND dist3.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist3.cod_subcartera = dd_scr.dd_scr_codigo 
            AND dist3.tipo_gestor = ''GIAFORM'')
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4 
        ON (dist4.cod_municipio = dd_loc.dd_loc_codigo 
            AND dist4.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist4.cod_subcartera IS NULL
            AND dist4.tipo_gestor = ''GIAFORM'')
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5 
        ON (dist5.cod_municipio = dd_loc.dd_loc_codigo  
            AND dist5.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist5.cod_subcartera = dd_scr.dd_scr_codigo 
            AND dist5.tipo_gestor = ''GIAFORM'')
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6 
        ON (dist6.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist6.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist6.cod_subcartera IS NULL
            AND dist6.tipo_gestor = ''GIAFORM'')
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7 
        ON (dist7.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist7.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist7.cod_subcartera = dd_scr.dd_scr_codigo 
            AND dist7.tipo_gestor = ''GIAFORM'')
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist8 
        ON (dist8.cod_estado_activo = dd_eac.dd_eac_codigo
            AND dist8.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist8.cod_subcartera IS NULL
            AND dist8.tipo_gestor = ''GIAFORM'')
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist9 
        ON (dist9.cod_estado_activo = dd_eac.dd_eac_codigo 
            AND dist9.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist9.cod_subcartera = dd_scr.dd_scr_codigo 
            AND dist9.tipo_gestor = ''GIAFORM'')
where act.borrado = 0
           UNION ALL

 /*Gestor de formalización*/
SELECT  act.act_id, 
        TO_NUMBER (COALESCE(dist3.cod_cartera, dist2.cod_cartera ,dist1.cod_cartera, dist0.cod_cartera )) cod_cartera,
        TO_NUMBER (COALESCE (dist3.cod_subcartera, dist2.cod_subcartera ,dist1.cod_subcartera, dist0.cod_subcartera)) dd_scr_subcartera,
        NULL cod_estado_activo, NULL dd_tcr_codigo, 
        COALESCE(dist3.cod_provincia ,dist2.cod_provincia) cod_provincia, 
        NULL cod_municipio, NULL cod_postal, 
        COALESCE (dist3.tipo_gestor, dist2.tipo_gestor ,dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
        COALESCE (dist3.username, dist2.username ,dist1.username, dist0.username ) username,
        COALESCE (dist3.nombre_usuario, dist2.nombre_usuario ,dist1.nombre_usuario, dist0.nombre_usuario) nombre
    FROM '||V_ESQUEMA||'.act_activo act 
    JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
    JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
    JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
    JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
    JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
        ON (dist0.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist0.cod_subcartera IS NULL
            AND dist0.tipo_gestor = ''GFORM'' 
            AND dist0.username IS NULL
            AND dist0.cod_provincia IS NULL)
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
        ON (dist1.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
            AND dist1.tipo_gestor = ''GFORM'' 
            AND dist1.username IS NULL)
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 
        ON (dist2.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist2.cod_subcartera IS NULL
            AND dist2.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist2.tipo_gestor = ''GFORM'')
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 
        ON (dist3.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist3.cod_subcartera = dd_scr.dd_scr_codigo 
            AND dist3.cod_provincia = dd_prov.dd_prv_codigo   
            AND dist3.tipo_gestor = ''GFORM'') 
    where act.borrado = 0
            UNION ALL
/*Supervisor de formalizacion*/
SELECT  act.act_id, 
        TO_NUMBER(COALESCE(dist3.cod_cartera, dist2.cod_cartera ,dist1.cod_cartera, dist0.cod_cartera )) cod_cartera,        
        TO_NUMBER(COALESCE (dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) cod_subcartera,
        NULL cod_estado_activo, NULL dd_tcr_codigo, 
        COALESCE(dist3.cod_provincia ,dist2.cod_provincia) cod_provincia, 
        NULL cod_municipio, NULL cod_postal, 
        COALESCE (dist3.tipo_gestor, dist2.tipo_gestor ,dist1.tipo_gestor, dist0.tipo_gestor) tipo_gestor,
        COALESCE (dist3.username, dist2.username ,dist1.username, dist0.username ) username,
        COALESCE (dist3.nombre_usuario, dist2.nombre_usuario ,dist1.nombre_usuario, dist0.nombre_usuario) nombre
    FROM '||V_ESQUEMA||'.act_activo act 
    JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
    JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
    JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
    JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
    JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
        ON (dist0.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist0.cod_subcartera IS NULL 
            AND dist0.tipo_gestor = ''SFORM'' 
            AND dist0.username IS NULL)
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
        ON (dist1.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
            AND dist1.tipo_gestor = ''SFORM'' 
            AND dist1.username IS NULL)
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 
        ON (dist2.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist2.cod_subcartera IS NULL
            AND dist2.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist2.tipo_gestor = ''SFORM'')
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 
        ON (dist3.cod_cartera = dd_cra.dd_cra_codigo 
            AND dist3.cod_subcartera = dd_scr.dd_scr_codigo 
            AND dist3.cod_provincia = dd_prov.dd_prv_codigo  
            AND dist3.tipo_gestor = ''SFORM'')    
where act.borrado = 0
            UNION ALL
/*Gestor comercial*/
 SELECT act.act_id, 
        TO_NUMBER (COALESCE(dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) cod_cartera, 
        TO_NUMBER (COALESCE(dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) cod_subcartera,
        null dd_eac_codigo, 
        COALESCE(dist7.cod_tipo_comerzialzacion, dist6.cod_tipo_comerzialzacion, dist5.cod_tipo_comerzialzacion, dist4.cod_tipo_comerzialzacion, dist3.cod_tipo_comerzialzacion, dist2.cod_tipo_comerzialzacion, dist1.cod_tipo_comerzialzacion, dist0.cod_tipo_comerzialzacion) cod_tipo_comerzialzacion, 
        COALESCE(dist7.cod_provincia, dist6.cod_provincia, dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) cod_provincia,
        COALESCE (dist7.cod_municipio, dist6.cod_municipio, dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) cod_municipio,
        COALESCE (dist7.cod_postal, dist6.cod_postal, dist5.cod_postal, dist4.cod_postal, dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
        COALESCE (dist7.tipo_gestor, dist6.tipo_gestor, dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
        COALESCE (dist7.username, dist6.username, dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username) username,
        COALESCE (dist7.nombre_usuario, dist6.nombre_usuario, dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
  FROM '||V_ESQUEMA||'.act_activo act 
	   JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       JOIN '||V_ESQUEMA||'.dd_tcr_tipo_comercializar dd_tcr ON dd_tcr.dd_tcr_id = act.dd_tcr_id
       JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
       ON (dist0.cod_tipo_comerzialzacion IS NULL
           AND dist0.cod_cartera = dd_cra.dd_cra_codigo
           AND dist0.cod_subcartera IS NULL
           AND dist0.cod_provincia IS NULL
           AND dist0.cod_municipio IS NULL
           AND dist0.cod_postal IS NULL
           AND dist0.tipo_gestor = ''GCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
       ON (dist1.cod_tipo_comerzialzacion IS NULL
           AND dist1.cod_cartera = dd_cra.dd_cra_codigo
           AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist1.cod_provincia IS NULL
           AND dist1.cod_municipio IS NULL
           AND dist1.cod_postal IS NULL
           AND dist1.tipo_gestor = ''GCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
       ON (dist2.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist2.cod_cartera = dd_cra.dd_cra_codigo
           AND dist2.cod_subcartera IS NULL
           AND dist2.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist2.cod_municipio IS NULL
           AND dist2.cod_postal IS NULL
           AND dist2.tipo_gestor = ''GCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
       ON (dist3.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist3.cod_cartera = dd_cra.dd_cra_codigo
           AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist3.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist3.cod_municipio IS NULL
           AND dist3.cod_postal IS NULL
           AND dist3.tipo_gestor = ''GCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4
       ON (dist4.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist4.cod_cartera = dd_cra.dd_cra_codigo
           AND dist4.cod_subcartera IS NULL
           AND dist4.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist4.cod_municipio = dd_loc.dd_loc_codigo
           AND dist4.cod_postal IS NULL
           AND dist4.tipo_gestor = ''GCOM''
          )   
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5
       ON (dist5.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist5.cod_cartera = dd_cra.dd_cra_codigo
           AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist5.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist5.cod_municipio = dd_loc.dd_loc_codigo
           AND dist5.cod_postal IS NULL
           AND dist5.tipo_gestor = ''GCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6
       ON (dist6.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist6.cod_cartera = dd_cra.dd_cra_codigo
           AND dist6.cod_subcartera IS NULL
           AND dist6.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist6.cod_municipio = dd_loc.dd_loc_codigo
           AND dist6.cod_postal = loc.BIE_LOC_COD_POST
           AND dist6.tipo_gestor = ''GCOM''
          )   
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7
       ON (dist7.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist7.cod_cartera = dd_cra.dd_cra_codigo
           AND dist7.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist7.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist7.cod_municipio = dd_loc.dd_loc_codigo
           AND dist7.cod_postal = loc.BIE_LOC_COD_POST
           AND dist7.tipo_gestor = ''GCOM''
          )
          where act.borrado = 0
    UNION ALL
/* SUPERVISOR COMERCIAL */
SELECT act.act_id, 
       TO_NUMBER (COALESCE (dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera )) cod_cartera, 
       TO_NUMBER (COALESCE (dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera )) cod_subcartera,
       null dd_eac_codigo, 
       COALESCE (dist5.cod_tipo_comerzialzacion, dist4.cod_tipo_comerzialzacion, dist3.cod_tipo_comerzialzacion, dist2.cod_tipo_comerzialzacion, dist1.cod_tipo_comerzialzacion, dist0.cod_tipo_comerzialzacion) cod_tipo_comerzialzacion, 
       COALESCE (dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) cod_provincia, 
       COALESCE (dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) cod_municipio, 
       COALESCE (dist5.cod_postal, dist4.cod_postal, dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
       COALESCE (dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor, 
       COALESCE (dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username) username,
       COALESCE (dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre_usuario
  FROM '||V_ESQUEMA||'.act_activo act 
	   JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       JOIN '||V_ESQUEMA||'.dd_tcr_tipo_comercializar dd_tcr ON dd_tcr.dd_tcr_id = act.dd_tcr_id
       JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
       ON (dist0.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist0.cod_cartera = dd_cra.dd_cra_codigo
           AND dist0.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist0.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist0.cod_municipio IS NULL
           AND dist0.cod_postal IS NULL
           AND dist0.tipo_gestor = ''SCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
       ON (dist1.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist1.cod_cartera = dd_cra.dd_cra_codigo
           AND dist1.cod_subcartera IS NULL
           AND dist1.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist1.cod_municipio IS NULL
           AND dist1.cod_postal IS NULL
           AND dist1.tipo_gestor = ''SCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
       ON (dist2.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist2.cod_cartera = dd_cra.dd_cra_codigo
           AND dist2.cod_subcartera IS NULL
           AND dist2.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist2.cod_municipio = dd_loc.dd_loc_codigo
           AND dist2.cod_postal IS NULL
           AND dist2.tipo_gestor = ''SCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
       ON (dist3.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist3.cod_cartera = dd_cra.dd_cra_codigo
           AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist3.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist3.cod_municipio = dd_loc.dd_loc_codigo
           AND dist3.cod_postal IS NULL
           AND dist3.tipo_gestor = ''SCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4
       ON (dist4.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist4.cod_cartera = dd_cra.dd_cra_codigo
           AND dist4.cod_subcartera IS NULL
           AND dist4.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist4.cod_municipio = dd_loc.dd_loc_codigo
           AND dist4.cod_postal = loc.BIE_LOC_COD_POST
           AND dist4.tipo_gestor = ''SCOM''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5
       ON (dist5.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist5.cod_cartera = dd_cra.dd_cra_codigo
           AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist5.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist5.cod_municipio = dd_loc.dd_loc_codigo
           AND dist5.cod_postal = loc.BIE_LOC_COD_POST
           AND dist5.tipo_gestor = ''SCOM''
          )
          where act.borrado = 0   
    UNION ALL';
V_MSQL3 := '/*Gestor de Reserva (Cajamar)*/ 
SELECT act.act_id, 
        TO_NUMBER (COALESCE(dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) cod_cartera, 
        TO_NUMBER (COALESCE(dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) cod_subcartera,
        null dd_eac_codigo, 
        COALESCE(dist7.cod_tipo_comerzialzacion, dist6.cod_tipo_comerzialzacion, dist5.cod_tipo_comerzialzacion, dist4.cod_tipo_comerzialzacion, dist3.cod_tipo_comerzialzacion, dist2.cod_tipo_comerzialzacion, dist1.cod_tipo_comerzialzacion, dist0.cod_tipo_comerzialzacion) cod_tipo_comerzialzacion, 
        COALESCE(dist7.cod_provincia, dist6.cod_provincia, dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) cod_provincia,
        COALESCE (dist7.cod_municipio, dist6.cod_municipio, dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) cod_municipio,
        COALESCE (dist7.cod_postal, dist6.cod_postal, dist5.cod_postal, dist4.cod_postal, dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
        COALESCE (dist7.tipo_gestor, dist6.tipo_gestor, dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
        COALESCE (dist7.username, dist6.username, dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username) username,
        COALESCE (dist7.nombre_usuario, dist6.nombre_usuario, dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
  FROM '||V_ESQUEMA||'.act_activo act 
	   JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       JOIN '||V_ESQUEMA||'.dd_tcr_tipo_comercializar dd_tcr ON dd_tcr.dd_tcr_id = act.dd_tcr_id
       JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
       ON (dist0.cod_tipo_comerzialzacion IS NULL
           AND dist0.cod_cartera = dd_cra.dd_cra_codigo
           AND dist0.cod_subcartera IS NULL
           AND dist0.cod_provincia IS NULL
           AND dist0.cod_municipio IS NULL
           AND dist0.cod_postal IS NULL
           AND dist0.tipo_gestor = ''GESRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
       ON (dist1.cod_tipo_comerzialzacion IS NULL
           AND dist1.cod_cartera = dd_cra.dd_cra_codigo
           AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist1.cod_provincia IS NULL
           AND dist1.cod_municipio IS NULL
           AND dist1.cod_postal IS NULL
           AND dist1.tipo_gestor = ''GESRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
       ON (dist2.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist2.cod_cartera = dd_cra.dd_cra_codigo
           AND dist2.cod_subcartera IS NULL
           AND dist2.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist2.cod_municipio IS NULL
           AND dist2.cod_postal IS NULL
           AND dist2.tipo_gestor = ''GESRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
       ON (dist3.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist3.cod_cartera = dd_cra.dd_cra_codigo
           AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist3.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist3.cod_municipio IS NULL
           AND dist3.cod_postal IS NULL
           AND dist3.tipo_gestor = ''GESRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4
       ON (dist4.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist4.cod_cartera = dd_cra.dd_cra_codigo
           AND dist4.cod_subcartera IS NULL
           AND dist4.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist4.cod_municipio = dd_loc.dd_loc_codigo
           AND dist4.cod_postal IS NULL
           AND dist4.tipo_gestor = ''GESRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5
       ON (dist5.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist5.cod_cartera = dd_cra.dd_cra_codigo
           AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist5.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist5.cod_municipio = dd_loc.dd_loc_codigo
           AND dist5.cod_postal IS NULL
           AND dist5.tipo_gestor = ''GESRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6
       ON (dist6.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo
           AND dist6.cod_cartera = dd_cra.dd_cra_codigo
           AND dist6.cod_subcartera IS NULL
           AND dist6.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist6.cod_municipio = dd_loc.dd_loc_codigo
           AND dist6.cod_postal = loc.BIE_LOC_COD_POST
           AND dist6.tipo_gestor = ''GESRES''
          )   
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7
       ON (dist7.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist7.cod_cartera = dd_cra.dd_cra_codigo
           AND dist7.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist7.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist7.cod_municipio = dd_loc.dd_loc_codigo
           AND dist7.cod_postal = loc.BIE_LOC_COD_POST
           AND dist7.tipo_gestor = ''GESRES''
          )
          where act.borrado = 0
    and act.dd_cra_id in (select dd_cra_id from '||V_ESQUEMA||'.dd_cra_cartera where dd_cra_codigo = ''01'')
    and act.dd_scm_id in (select dd_scm_id from '||V_ESQUEMA||'.dd_scm_situacion_comercial  where dd_scm_codigo <> ''05'')
    UNION ALL
/*Supervisor de Reserva (Cajamar)*/
 SELECT act.act_id, 
        TO_NUMBER (COALESCE(dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) cod_cartera, 
        TO_NUMBER (COALESCE(dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) cod_subcartera,
        null dd_eac_codigo, 
        COALESCE(dist7.cod_tipo_comerzialzacion, dist6.cod_tipo_comerzialzacion, dist5.cod_tipo_comerzialzacion, dist4.cod_tipo_comerzialzacion, dist3.cod_tipo_comerzialzacion, dist2.cod_tipo_comerzialzacion, dist1.cod_tipo_comerzialzacion, dist0.cod_tipo_comerzialzacion) cod_tipo_comerzialzacion, 
        COALESCE(dist7.cod_provincia, dist6.cod_provincia, dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) cod_provincia,
        COALESCE (dist7.cod_municipio, dist6.cod_municipio, dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) cod_municipio,
        COALESCE (dist7.cod_postal, dist6.cod_postal, dist5.cod_postal, dist4.cod_postal, dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
        COALESCE (dist7.tipo_gestor, dist6.tipo_gestor, dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
        COALESCE (dist7.username, dist6.username, dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username) username,
        COALESCE (dist7.nombre_usuario, dist6.nombre_usuario, dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
  FROM '||V_ESQUEMA||'.act_activo act 
	   JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       JOIN '||V_ESQUEMA||'.dd_tcr_tipo_comercializar dd_tcr ON dd_tcr.dd_tcr_id = act.dd_tcr_id
       JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
       ON (dist0.cod_tipo_comerzialzacion IS NULL
           AND dist0.cod_cartera = dd_cra.dd_cra_codigo
           AND dist0.cod_subcartera IS NULL
           AND dist0.cod_provincia IS NULL
           AND dist0.cod_municipio IS NULL
           AND dist0.cod_postal IS NULL
           AND dist0.tipo_gestor = ''SUPRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
       ON (dist1.cod_tipo_comerzialzacion IS NULL
           AND dist1.cod_cartera = dd_cra.dd_cra_codigo
           AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist1.cod_provincia IS NULL
           AND dist1.cod_municipio IS NULL
           AND dist1.cod_postal IS NULL
           AND dist1.tipo_gestor = ''SUPRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
       ON (dist2.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist2.cod_cartera = dd_cra.dd_cra_codigo
           AND dist2.cod_subcartera IS NULL
           AND dist2.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist2.cod_municipio IS NULL
           AND dist2.cod_postal IS NULL
           AND dist2.tipo_gestor = ''SUPRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
       ON (dist3.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist3.cod_cartera = dd_cra.dd_cra_codigo
           AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist3.cod_provincia = dd_prov.dd_prv_codigo
           AND dist3.cod_municipio IS NULL
           AND dist3.cod_postal IS NULL
           AND dist3.tipo_gestor = ''SUPRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4
       ON (dist4.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist4.cod_cartera = dd_cra.dd_cra_codigo
           AND dist4.cod_subcartera IS NULL
           AND dist4.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist4.cod_municipio = dd_loc.dd_loc_codigo
           AND dist4.cod_postal IS NULL
           AND dist4.tipo_gestor = ''SUPRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5
       ON (dist5.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist5.cod_cartera = dd_cra.dd_cra_codigo
           AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist5.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist5.cod_municipio = dd_loc.dd_loc_codigo
           AND dist5.cod_postal IS NULL
           AND dist5.tipo_gestor = ''SUPRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6
       ON (dist6.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist6.cod_cartera = dd_cra.dd_cra_codigo
           AND dist6.cod_subcartera IS NULL
           AND dist6.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist6.cod_municipio = dd_loc.dd_loc_codigo
           AND dist6.cod_postal = loc.BIE_LOC_COD_POST
           AND dist6.tipo_gestor = ''SUPRES''
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7
       ON (dist7.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist7.cod_cartera = dd_cra.dd_cra_codigo
           AND dist7.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist7.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist7.cod_municipio = dd_loc.dd_loc_codigo
           AND dist7.cod_postal = loc.BIE_LOC_COD_POST
           AND dist7.tipo_gestor = ''SUPRES''
          )
          where act.borrado = 0
    and act.dd_cra_id in (select dd_cra_id from '||V_ESQUEMA||'.dd_cra_cartera where dd_cra_codigo = ''01'')
    and act.dd_scm_id in (select dd_scm_id from '||V_ESQUEMA||'.dd_scm_situacion_comercial  where dd_scm_codigo <> ''05'')
    UNION ALL
/*PROVEEDOR TECNICO*/
SELECT act.act_id, 
      TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
	  TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera, 
      NULL dd_eac_codigo, NULL dd_tcr_codigo, 
      COALESCE(dist1.cod_provincia, dist0.cod_provincia) cod_provincia,
      COALESCE(dist1.cod_municipio, dist0.cod_municipio) cod_municipio,
      COALESCE(dist1.cod_postal, dist0.cod_postal) cod_postal,
      COALESCE(dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
      COALESCE(dist1.username, dist0.username) username,
      COALESCE(dist1.nombre_usuario, dist0.nombre_usuario) nombre
  FROM '||V_ESQUEMA||'.act_activo act 
	   JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
       JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''PTEC''
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
       ON (dist0.cod_cartera = dd_cra.dd_cra_codigo
		   AND dist0.cod_subcartera IS NULL
           AND dist0.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
       ON (dist1.cod_cartera = dd_cra.dd_cra_codigo
		   AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist1.cod_provincia = dd_prov.dd_prv_codigo 
           AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO
          )
          where act.borrado = 0 
            AND (dist0.tipo_gestor = ''PTEC'' 
              OR dist1.tipo_gestor = ''PTEC'')
    union all
/*GOLDEN TREE */
SELECT act.act_id, 
      TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
	  TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera, 
      NULL dd_eac_codigo, NULL dd_tcr_codigo, 
      COALESCE(dist1.cod_provincia, dist0.cod_provincia) cod_provincia,
      COALESCE(dist1.cod_municipio, dist0.cod_municipio) cod_municipio,
      COALESCE(dist1.cod_postal, dist0.cod_postal) cod_postal,
      COALESCE(dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
      COALESCE(dist1.username, dist0.username) username,
      COALESCE(dist1.nombre_usuario, dist0.nombre_usuario) nombre
    FROM '||V_ESQUEMA||'.act_activo act
    JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
    join '||V_ESQUEMA||'.BIE_LOCALIZACION loc on loc.bie_loc_id = aloc.bie_loc_id
    left join '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA prv on prv.dd_prv_id = loc.dd_prv_id
    left join '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR tcr on tcr.dd_tcr_id = act.dd_tcr_id
    left join '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO eac on eac.dd_eac_id = act.dd_eac_id
    join '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''GTREE''
    JOIN '||V_ESQUEMA||'.dd_cra_cartera cra on cra.dd_cra_id = act.dd_cra_id
    JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
        on(dist0.COD_CARTERA = CRA.DD_CRA_CODIGO 
            AND dist0.cod_subcartera IS NULL 
            AND dist0.tipo_gestor = tge.dd_tge_codigo
            AND dist0.tipo_gestor IS NOT NULL)
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
        on(dist1.COD_CARTERA = CRA.DD_CRA_CODIGO 
            AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
            AND dist1.tipo_gestor = tge.dd_tge_codigo
            AND dist1.tipo_gestor IS NOT NULL)
    where act.borrado = 0
            AND (DIST0.TIPO_GESTOR = ''GTREE'' 
              OR DIST1.TIPO_GESTOR = ''GTREE'')
                           
  UNION ALL
  /*Gestor Liberbank Residencial (Liberbank)*/
           SELECT act.act_id, 
                  TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
                  TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera, 
                  NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                  COALESCE(dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
                  COALESCE(dist1.username, dist0.username) username,
                  COALESCE(dist1.nombre_usuario, dist0.nombre_usuario) nombre
             FROM '||V_ESQUEMA||'.act_activo act 
				  JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
				  JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                    ON (dist0.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist0.cod_subcartera IS NULL 
                        AND dist0.tipo_gestor = ''GLIBRES'')
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
                    ON (dist1.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
                        AND dist1.tipo_gestor = ''GLIBRES'')
           where act.borrado = 0

  UNION ALL
  /*Gestor Inversión Inmobiliaria (Liberbank)*/
           SELECT act.act_id, 
                  TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
                  TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera, 
                  NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                  COALESCE(dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
                  COALESCE(dist1.username, dist0.username) username,
                  COALESCE(dist1.nombre_usuario, dist0.nombre_usuario) nombre
             FROM '||V_ESQUEMA||'.act_activo act 
				  JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
				  JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                    ON (dist0.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist0.cod_subcartera IS NULL 
                        AND dist0.tipo_gestor = ''GLIBINVINM'')
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
                    ON (dist1.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
                        AND dist1.tipo_gestor = ''GLIBINVINM'')
           where act.borrado = 0
    UNION ALL
  /*Gestor Singular/Terciario (Liberbank)*/
           SELECT act.act_id, 
                  TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
                  TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera, 
                  NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                  COALESCE(dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
                  COALESCE(dist1.username, dist0.username) username,
                  COALESCE(dist1.nombre_usuario, dist0.nombre_usuario) nombre
             FROM '||V_ESQUEMA||'.act_activo act 
				  JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
				  JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                    ON (dist0.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist0.cod_subcartera IS NULL 
                        AND dist0.tipo_gestor = ''GLIBSINTER'')
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
                    ON (dist1.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
                        AND dist1.tipo_gestor = ''GLIBSINTER'')
           where act.borrado = 0
  UNION ALL
  /*Gestor Comité de Inversiones Inmobiliarias (Liberbank)*/
           SELECT act.act_id, 
                  TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
                  TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera, 
                  NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                  COALESCE(dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
                  COALESCE(dist1.username, dist0.username) username,
                  COALESCE(dist1.nombre_usuario, dist0.nombre_usuario) nombre
             FROM '||V_ESQUEMA||'.act_activo act 
				  JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
				  JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                    ON (dist0.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist0.cod_subcartera IS NULL 
                        AND dist0.tipo_gestor = ''GCOIN'')
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
                    ON (dist1.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
                        AND dist1.tipo_gestor = ''GCOIN'')
           where act.borrado = 0

  UNION ALL
  /*Gestor Comité Inmobiliario (Liberbank)*/
           SELECT act.act_id, 
                  TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
                  TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera, 
                  NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                  COALESCE(dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
                  COALESCE(dist1.username, dist0.username) username,
                  COALESCE(dist1.nombre_usuario, dist0.nombre_usuario) nombre
             FROM '||V_ESQUEMA||'.act_activo act 
				  JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
				  JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                    ON (dist0.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist0.cod_subcartera IS NULL 
                        AND dist0.tipo_gestor = ''GCOINM'')
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
                    ON (dist1.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
                        AND dist1.tipo_gestor = ''GCOINM'')
           where act.borrado = 0

  UNION ALL
  /*Gestor Comité de Dirección (Liberbank)*/
           SELECT act.act_id, 
                  TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
                  TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera, 
                  NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                  COALESCE(dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
                  COALESCE(dist1.username, dist0.username) username,
                  COALESCE(dist1.nombre_usuario, dist0.nombre_usuario) nombre
             FROM '||V_ESQUEMA||'.act_activo act 
				  JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
				  JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                    ON (dist0.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist0.cod_subcartera IS NULL 
                        AND dist0.tipo_gestor = ''GCODI'')
                  JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
                    ON (dist1.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
                        AND dist1.tipo_gestor = ''GCODI'')
           where act.borrado = 0

  UNION ALL
    /*Gestor de suelos*/
        SELECT  act.act_id, 
        TO_NUMBER (COALESCE(dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) cod_cartera, 
        TO_NUMBER (COALESCE(dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) cod_subcartera,
        null dd_eac_codigo, 
        COALESCE(dist7.cod_tipo_comerzialzacion, dist6.cod_tipo_comerzialzacion, dist5.cod_tipo_comerzialzacion, dist4.cod_tipo_comerzialzacion, dist3.cod_tipo_comerzialzacion, dist2.cod_tipo_comerzialzacion, dist1.cod_tipo_comerzialzacion, dist0.cod_tipo_comerzialzacion) cod_tipo_comerzialzacion, 
        COALESCE(dist7.cod_provincia, dist6.cod_provincia, dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) cod_provincia,
        COALESCE (dist7.cod_municipio, dist6.cod_municipio, dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) cod_municipio,
        COALESCE (dist7.cod_postal, dist6.cod_postal, dist5.cod_postal, dist4.cod_postal, dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
        COALESCE (dist7.tipo_gestor, dist6.tipo_gestor, dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
        COALESCE (dist7.username, dist6.username, dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username) username,
        COALESCE (dist7.nombre_usuario, dist6.nombre_usuario, dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
        FROM '||V_ESQUEMA||'.act_activo act 
            JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
            JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
            JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
            JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
            JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
            JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''GSUE''
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 ON (
                dist0.cod_cartera = dd_cra.dd_cra_codigo
                AND dist0.cod_subcartera IS NULL
                AND dist0.cod_provincia IS NULL
                AND dist0.cod_municipio IS NULL
                AND dist0.cod_postal IS NULL
                AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (
                dist1.cod_cartera = dd_cra.dd_cra_codigo
                AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist1.cod_provincia IS NULL
                AND dist1.cod_municipio IS NULL
                AND dist1.cod_postal IS NULL
                AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 ON (
                dist2.cod_cartera = dd_cra.dd_cra_codigo
                AND dist2.cod_subcartera IS NULL
                AND dist2.cod_provincia = dd_prov.dd_prv_codigo
                AND dist2.cod_municipio IS NULL
                AND dist2.cod_postal IS NULL
                AND dist2.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 ON (
                dist3.cod_cartera = dd_cra.dd_cra_codigo
                AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist3.cod_provincia = dd_prov.dd_prv_codigo 
                AND dist3.cod_municipio IS NULL
                AND dist3.cod_postal IS NULL
                AND dist3.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4 ON (
                dist4.cod_cartera = dd_cra.dd_cra_codigo
                AND dist4.cod_subcartera IS NULL
                AND dist4.cod_provincia = dd_prov.dd_prv_codigo 
                AND dist4.cod_municipio = dd_loc.dd_loc_codigo
                AND dist4.cod_postal IS NULL
                AND dist4.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5 ON (
                dist5.cod_cartera = dd_cra.dd_cra_codigo
                AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist5.cod_provincia = dd_prov.dd_prv_codigo 
                AND dist5.cod_municipio = dd_loc.dd_loc_codigo
                AND dist5.cod_postal IS NULL
                AND dist5.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6 ON (
                dist6.cod_cartera = dd_cra.dd_cra_codigo
                AND dist6.cod_subcartera IS NULL
                AND dist6.cod_provincia = dd_prov.dd_prv_codigo
                AND dist6.cod_municipio = dd_loc.dd_loc_codigo
                AND dist6.cod_postal  = loc.BIE_LOC_COD_POST
                AND dist6.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7 ON (
                dist7.cod_cartera = dd_cra.dd_cra_codigo
                AND dist7.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist7.cod_provincia = dd_prov.dd_prv_codigo
                AND dist7.cod_municipio = dd_loc.dd_loc_codigo
                AND dist7.cod_postal  = loc.BIE_LOC_COD_POST
                AND dist7.tipo_gestor = TGE.DD_TGE_CODIGO
            )   
        WHERE 
            act.borrado = 0 
            AND act.DD_TPA_ID = (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = ''01'')
            AND act.DD_EAC_ID = (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = ''01'')
    UNION ALL';
V_MSQL4 := '/*Supervisor de suelos*/
        SELECT  act.act_id, 
        TO_NUMBER (COALESCE(dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) cod_cartera, 
        TO_NUMBER (COALESCE(dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) cod_subcartera,
        null dd_eac_codigo, 
        COALESCE(dist7.cod_tipo_comerzialzacion, dist6.cod_tipo_comerzialzacion, dist5.cod_tipo_comerzialzacion, dist4.cod_tipo_comerzialzacion, dist3.cod_tipo_comerzialzacion, dist2.cod_tipo_comerzialzacion, dist1.cod_tipo_comerzialzacion, dist0.cod_tipo_comerzialzacion) cod_tipo_comerzialzacion, 
        COALESCE(dist7.cod_provincia, dist6.cod_provincia, dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) cod_provincia,
        COALESCE (dist7.cod_municipio, dist6.cod_municipio, dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) cod_municipio,
        COALESCE (dist7.cod_postal, dist6.cod_postal, dist5.cod_postal, dist4.cod_postal, dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
        COALESCE (dist7.tipo_gestor, dist6.tipo_gestor, dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
        COALESCE (dist7.username, dist6.username, dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username) username,
        COALESCE (dist7.nombre_usuario, dist6.nombre_usuario, dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
        FROM '||V_ESQUEMA||'.act_activo act 
            JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
            JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
            JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
            JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
            JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
            JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''SUPSUE''
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 ON (
                dist0.cod_cartera = dd_cra.dd_cra_codigo
                AND dist0.cod_subcartera IS NULL
                AND dist0.cod_provincia IS NULL
                AND dist0.cod_municipio IS NULL
                AND dist0.cod_postal IS NULL
                AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (
                dist1.cod_cartera = dd_cra.dd_cra_codigo
                AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist1.cod_provincia IS NULL
                AND dist1.cod_municipio IS NULL
                AND dist1.cod_postal IS NULL
                AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 ON (
                dist2.cod_cartera = dd_cra.dd_cra_codigo
                AND dist2.cod_subcartera IS NULL
                AND dist2.cod_provincia = dd_prov.dd_prv_codigo
                AND dist2.cod_municipio IS NULL
                AND dist2.cod_postal IS NULL
                AND dist2.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 ON (
                dist3.cod_cartera = dd_cra.dd_cra_codigo
                AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist3.cod_provincia = dd_prov.dd_prv_codigo 
                AND dist3.cod_municipio IS NULL
                AND dist3.cod_postal IS NULL
                AND dist3.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4 ON (
                dist4.cod_cartera = dd_cra.dd_cra_codigo
                AND dist4.cod_subcartera IS NULL
                AND dist4.cod_provincia = dd_prov.dd_prv_codigo 
                AND dist4.cod_municipio = dd_loc.dd_loc_codigo
                AND dist4.cod_postal IS NULL
                AND dist4.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5 ON (
                dist5.cod_cartera = dd_cra.dd_cra_codigo
                AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist5.cod_provincia = dd_prov.dd_prv_codigo 
                AND dist5.cod_municipio = dd_loc.dd_loc_codigo
                AND dist5.cod_postal IS NULL
                AND dist5.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6 ON (
                dist6.cod_cartera = dd_cra.dd_cra_codigo
                AND dist6.cod_subcartera IS NULL
                AND dist6.cod_provincia = dd_prov.dd_prv_codigo
                AND dist6.cod_municipio = dd_loc.dd_loc_codigo
                AND dist6.cod_postal  = loc.BIE_LOC_COD_POST
                AND dist6.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7 ON (
                dist7.cod_cartera = dd_cra.dd_cra_codigo
                AND dist7.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist7.cod_provincia = dd_prov.dd_prv_codigo
                AND dist7.cod_municipio = dd_loc.dd_loc_codigo
                AND dist7.cod_postal  = loc.BIE_LOC_COD_POST
                AND dist7.tipo_gestor = TGE.DD_TGE_CODIGO
            )   
        WHERE 
            act.borrado = 0 
            AND act.DD_TPA_ID = (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = ''01'')
            AND act.DD_EAC_ID = (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = ''01'')
        
    UNION ALL
    /*Gestor de edificación*/
        SELECT  act.act_id, 
        TO_NUMBER (COALESCE(dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) cod_cartera, 
        TO_NUMBER (COALESCE(dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) cod_subcartera,
        null dd_eac_codigo, 
        COALESCE(dist7.cod_tipo_comerzialzacion, dist6.cod_tipo_comerzialzacion, dist5.cod_tipo_comerzialzacion, dist4.cod_tipo_comerzialzacion, dist3.cod_tipo_comerzialzacion, dist2.cod_tipo_comerzialzacion, dist1.cod_tipo_comerzialzacion, dist0.cod_tipo_comerzialzacion) cod_tipo_comerzialzacion, 
        COALESCE(dist7.cod_provincia, dist6.cod_provincia, dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) cod_provincia,
        COALESCE (dist7.cod_municipio, dist6.cod_municipio, dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) cod_municipio,
        COALESCE (dist7.cod_postal, dist6.cod_postal, dist5.cod_postal, dist4.cod_postal, dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
        COALESCE (dist7.tipo_gestor, dist6.tipo_gestor, dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
        COALESCE (dist7.username, dist6.username, dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username) username,
        COALESCE (dist7.nombre_usuario, dist6.nombre_usuario, dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
        FROM '||V_ESQUEMA||'.act_activo act 
            JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
            JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
            JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
            JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
            JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
            JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''GEDI''
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 ON (
                dist0.cod_cartera = dd_cra.dd_cra_codigo
                AND dist0.cod_subcartera IS NULL
                AND dist0.cod_provincia IS NULL
                AND dist0.cod_municipio IS NULL
                AND dist0.cod_postal IS NULL
                AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (
                dist1.cod_cartera = dd_cra.dd_cra_codigo
                AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist1.cod_provincia IS NULL
                AND dist1.cod_municipio IS NULL
                AND dist1.cod_postal IS NULL
                AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 ON (
                dist2.cod_cartera = dd_cra.dd_cra_codigo
                AND dist2.cod_subcartera IS NULL
                AND dist2.cod_provincia = dd_prov.dd_prv_codigo
                AND dist2.cod_municipio IS NULL
                AND dist2.cod_postal IS NULL
                AND dist2.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 ON (
                dist3.cod_cartera = dd_cra.dd_cra_codigo
                AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist3.cod_provincia = dd_prov.dd_prv_codigo 
                AND dist3.cod_municipio IS NULL
                AND dist3.cod_postal IS NULL
                AND dist3.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4 ON (
                dist4.cod_cartera = dd_cra.dd_cra_codigo
                AND dist4.cod_subcartera IS NULL
                AND dist4.cod_provincia = dd_prov.dd_prv_codigo 
                AND dist4.cod_municipio = dd_loc.dd_loc_codigo
                AND dist4.cod_postal IS NULL
                AND dist4.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5 ON (
                dist5.cod_cartera = dd_cra.dd_cra_codigo
                AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist5.cod_provincia = dd_prov.dd_prv_codigo 
                AND dist5.cod_municipio = dd_loc.dd_loc_codigo
                AND dist5.cod_postal IS NULL
                AND dist5.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6 ON (
                dist6.cod_cartera = dd_cra.dd_cra_codigo
                AND dist6.cod_subcartera IS NULL
                AND dist6.cod_provincia = dd_prov.dd_prv_codigo
                AND dist6.cod_municipio = dd_loc.dd_loc_codigo
                AND dist6.cod_postal  = loc.BIE_LOC_COD_POST
                AND dist6.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7 ON (
                dist7.cod_cartera = dd_cra.dd_cra_codigo
                AND dist7.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist7.cod_provincia = dd_prov.dd_prv_codigo
                AND dist7.cod_municipio = dd_loc.dd_loc_codigo
                AND dist7.cod_postal  = loc.BIE_LOC_COD_POST
                AND dist7.tipo_gestor = TGE.DD_TGE_CODIGO
            )   
        WHERE 
            act.borrado = 0 
            AND act.DD_TPA_ID != (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = ''01'')
            AND act.DD_EAC_ID IN (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO IN (''09'', ''02'', ''06'', ''11'', ''10'', ''05'', ''08'', ''07''))
    UNION ALL
    /*Supervisor de edificación*/
        SELECT  act.act_id, 
        TO_NUMBER (COALESCE(dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) cod_cartera, 
        TO_NUMBER (COALESCE(dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) cod_subcartera,
        null dd_eac_codigo, 
        COALESCE(dist7.cod_tipo_comerzialzacion, dist6.cod_tipo_comerzialzacion, dist5.cod_tipo_comerzialzacion, dist4.cod_tipo_comerzialzacion, dist3.cod_tipo_comerzialzacion, dist2.cod_tipo_comerzialzacion, dist1.cod_tipo_comerzialzacion, dist0.cod_tipo_comerzialzacion) cod_tipo_comerzialzacion, 
        COALESCE(dist7.cod_provincia, dist6.cod_provincia, dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) cod_provincia,
        COALESCE (dist7.cod_municipio, dist6.cod_municipio, dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) cod_municipio,
        COALESCE (dist7.cod_postal, dist6.cod_postal, dist5.cod_postal, dist4.cod_postal, dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
        COALESCE (dist7.tipo_gestor, dist6.tipo_gestor, dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
        COALESCE (dist7.username, dist6.username, dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username) username,
        COALESCE (dist7.nombre_usuario, dist6.nombre_usuario, dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
        FROM '||V_ESQUEMA||'.act_activo act 
            JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
            JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
            JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
            JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
            JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
            JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''SUPEDI''
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 ON (
                dist0.cod_cartera = dd_cra.dd_cra_codigo
                AND dist0.cod_subcartera IS NULL
                AND dist0.cod_provincia IS NULL
                AND dist0.cod_municipio IS NULL
                AND dist0.cod_postal IS NULL
                AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON (
                dist1.cod_cartera = dd_cra.dd_cra_codigo
                AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist1.cod_provincia IS NULL
                AND dist1.cod_municipio IS NULL
                AND dist1.cod_postal IS NULL
                AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2 ON (
                dist2.cod_cartera = dd_cra.dd_cra_codigo
                AND dist2.cod_subcartera IS NULL
                AND dist2.cod_provincia = dd_prov.dd_prv_codigo
                AND dist2.cod_municipio IS NULL
                AND dist2.cod_postal IS NULL
                AND dist2.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3 ON (
                dist3.cod_cartera = dd_cra.dd_cra_codigo
                AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist3.cod_provincia = dd_prov.dd_prv_codigo 
                AND dist3.cod_municipio IS NULL
                AND dist3.cod_postal IS NULL
                AND dist3.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4 ON (
                dist4.cod_cartera = dd_cra.dd_cra_codigo
                AND dist4.cod_subcartera IS NULL
                AND dist4.cod_provincia = dd_prov.dd_prv_codigo 
                AND dist4.cod_municipio = dd_loc.dd_loc_codigo
                AND dist4.cod_postal IS NULL
                AND dist4.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5 ON (
                dist5.cod_cartera = dd_cra.dd_cra_codigo
                AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist5.cod_provincia = dd_prov.dd_prv_codigo 
                AND dist5.cod_municipio = dd_loc.dd_loc_codigo
                AND dist5.cod_postal IS NULL
                AND dist5.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6 ON (
                dist6.cod_cartera = dd_cra.dd_cra_codigo
                AND dist6.cod_subcartera IS NULL
                AND dist6.cod_provincia = dd_prov.dd_prv_codigo
                AND dist6.cod_municipio = dd_loc.dd_loc_codigo
                AND dist6.cod_postal  = loc.BIE_LOC_COD_POST
                AND dist6.tipo_gestor = TGE.DD_TGE_CODIGO
            )
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7 ON (
                dist7.cod_cartera = dd_cra.dd_cra_codigo
                AND dist7.cod_subcartera = dd_scr.dd_scr_codigo
                AND dist7.cod_provincia = dd_prov.dd_prv_codigo
                AND dist7.cod_municipio = dd_loc.dd_loc_codigo
                AND dist7.cod_postal  = loc.BIE_LOC_COD_POST
                AND dist7.tipo_gestor = TGE.DD_TGE_CODIGO
            )   
        WHERE 
            act.borrado = 0 
            AND act.DD_TPA_ID != (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = ''01'')
            AND act.DD_EAC_ID IN (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO IN (''09'', ''02'', ''06'', ''11'', ''10'', ''05'', ''08'', ''07''))
  UNION ALL

  /*Gestor / supervisor de alquileres*/ 
  SELECT act.act_id, NULL dd_cra_codigo, NULL dd_scr_codigo, NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, dist1.tipo_gestor, dist1.username username,
                    dist1.nombre_usuario nombre
               FROM '||V_ESQUEMA||'.act_activo act 
					JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 ON dist1.tipo_gestor IN (''GALQ'', ''SUALQ'')
					JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO ACT_PTA ON ACT_PTA.ACT_ID = ACT.ACT_ID 
             where act.borrado = 0 AND ACT_PTA.CHECK_HPM = 1
           UNION ALL

  /*Gestor comercial alquiler - Obligatorio cartera, no mira por más campos*/
    SELECT act.act_id, 
        TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
        TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera,  
        NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
        COALESCE(dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
        COALESCE(dist1.username, dist0.username) username,
        COALESCE(dist1.nombre_usuario, dist0.nombre_usuario) nombre  
    FROM '||V_ESQUEMA||'.act_activo act 
              INNER JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
                    JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
                    JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''GESTCOMALQ''
                    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                        ON (dist0.tipo_gestor = TGE.DD_TGE_CODIGO
                            AND dist0.cod_cartera = dd_cra.dd_cra_codigo
                            AND dist0.cod_subcartera IS NULL)
                    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
                        ON (dist1.tipo_gestor = TGE.DD_TGE_CODIGO
                            AND dist1.cod_cartera = dd_cra.dd_cra_codigo
                            AND dist1.cod_subcartera = dd_scr.dd_scr_codigo)
         where act.borrado = 0 
			AND (dist0.tipo_gestor = ''GESTCOMALQ''
			  OR dist1.tipo_gestor = ''GESTCOMALQ'')

      UNION ALL

  /*Supervisor comercial alquiler - Admite cartera nula*/
    SELECT act.act_id, 
        TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) cod_cartera, 
        TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) cod_subcartera,  
        NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
        COALESCE(dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
        COALESCE(dist1.username, dist0.username) username,
        COALESCE(dist1.nombre_usuario, dist0.nombre_usuario) nombre  
    FROM '||V_ESQUEMA||'.act_activo act 
              INNER JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
                    JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
                    JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''SUPCOMALQ''
                    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                        ON (dist0.tipo_gestor = TGE.DD_TGE_CODIGO
                            AND dist0.cod_cartera = dd_cra.dd_cra_codigo
                            AND dist0.cod_subcartera IS NULL)
                    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
                        ON (dist1.tipo_gestor = TGE.DD_TGE_CODIGO
                            AND dist1.cod_cartera = dd_cra.dd_cra_codigo
                            AND dist1.cod_subcartera = dd_scr.dd_scr_codigo)
         where act.borrado = 0
			AND (dist0.tipo_gestor = ''SUPCOMALQ''
			  OR dist1.tipo_gestor = ''SUPCOMALQ'')

UNION ALL
/*Gestor de publicaciones*/
      SELECT
        act.act_id,
        TO_NUMBER (COALESCE (dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera )) cod_cartera, 
        TO_NUMBER (COALESCE (dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera )) cod_subcartera,
        TO_NUMBER (dd_eac.DD_EAC_CODIGO) dd_eac_codigo,
        null dd_eac_codigo, 
        COALESCE (dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) cod_provincia, 
        COALESCE (dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) cod_municipio, 
        COALESCE (dist5.cod_postal, dist4.cod_postal, dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
        COALESCE (dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor, 
        COALESCE (dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username) username,
        COALESCE (dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre_usuario
    FROM '||V_ESQUEMA||'.act_activo act
    JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
    JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
    JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
    JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
    JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
    JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
    JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
    JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''GPUBL''
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
        ON (dist0.cod_cartera = dd_cra.dd_cra_codigo
            AND dist0.cod_subcartera IS NULL
            AND dist0.cod_provincia = dd_prov.dd_prv_codigo 
            AND (dist0.cod_municipio IS NULL OR dist0.cod_municipio = 0)
            AND dist0.cod_postal IS NULL
            AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
            )
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
        ON (dist1.cod_cartera = dd_cra.dd_cra_codigo
            AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
            AND dist1.cod_provincia = dd_prov.dd_prv_codigo 
            AND (dist1.cod_municipio IS NULL OR dist1.cod_municipio = 0)
            AND dist1.cod_postal IS NULL
            AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO
            )
    left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
        ON (dist2.cod_cartera = dd_cra.dd_cra_codigo
            AND dist2.cod_subcartera IS NULL
            AND dist2.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist2.cod_municipio = dd_loc.dd_loc_codigo
            AND dist2.cod_postal IS NULL
            AND dist2.tipo_gestor = TGE.DD_TGE_CODIGO
            )
    left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
        ON (dist3.cod_cartera = dd_cra.dd_cra_codigo
            AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
            AND dist3.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist3.cod_municipio = dd_loc.dd_loc_codigo
            AND dist3.cod_postal IS NULL
            AND dist3.tipo_gestor = TGE.DD_TGE_CODIGO
            )
    left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4
        ON (dist4.cod_cartera = dd_cra.dd_cra_codigo
            AND dist4.cod_subcartera IS NULL
            AND dist4.cod_provincia = dd_prov.dd_prv_codigo
            AND dist4.cod_municipio = dd_loc.dd_loc_codigo
            AND dist4.cod_postal  = loc.BIE_LOC_COD_POST
            AND dist4.tipo_gestor = TGE.DD_TGE_CODIGO
    )
    left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5
        ON (dist5.cod_cartera = dd_cra.dd_cra_codigo
            AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
            AND dist5.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist5.cod_municipio = dd_loc.dd_loc_codigo
            AND dist5.cod_postal  = loc.BIE_LOC_COD_POST
            AND dist5.tipo_gestor = TGE.DD_TGE_CODIGO
    )
    WHERE act.borrado = 0
		AND (dist0.tipo_gestor = ''GPUBL''
	      OR dist1.tipo_gestor = ''GPUBL''
	      OR dist2.tipo_gestor = ''GPUBL''
	      OR dist3.tipo_gestor = ''GPUBL''
	      OR dist4.tipo_gestor = ''GPUBL''
	      OR dist5.tipo_gestor = ''GPUBL'')
UNION ALL';
V_MSQL5 := '/*Supervisor de publicaciones*/
        SELECT
        act.act_id,
        TO_NUMBER (COALESCE (dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera )) cod_cartera, 
        TO_NUMBER (COALESCE (dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera )) cod_subcartera,
        TO_NUMBER (dd_eac.DD_EAC_CODIGO) dd_eac_codigo,
        null dd_eac_codigo, 
        COALESCE (dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) cod_provincia, 
        COALESCE (dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) cod_municipio, 
        COALESCE (dist5.cod_postal, dist4.cod_postal, dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
        COALESCE (dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor, 
        COALESCE (dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username) username,
        COALESCE (dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre_usuario
    FROM '||V_ESQUEMA||'.act_activo act
    JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
    JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
    JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
    JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
    JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
    JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
    JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
    JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''SPUBL''
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
        ON (dist0.cod_cartera = dd_cra.dd_cra_codigo
            AND dist0.cod_subcartera IS NULL
            AND dist0.cod_provincia = dd_prov.dd_prv_codigo 
            AND (dist0.cod_municipio IS NULL OR dist0.cod_municipio = 0)
            AND dist0.cod_postal IS NULL
            AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
            )
    LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
        ON (dist1.cod_cartera = dd_cra.dd_cra_codigo
            AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
            AND dist1.cod_provincia = dd_prov.dd_prv_codigo 
            AND (dist1.cod_municipio IS NULL OR dist1.cod_municipio = 0)
            AND dist1.cod_postal IS NULL
            AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO
            )
    left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
        ON (dist2.cod_cartera = dd_cra.dd_cra_codigo
            AND dist2.cod_subcartera IS NULL
            AND dist2.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist2.cod_municipio = dd_loc.dd_loc_codigo
            AND dist2.cod_postal IS NULL
            AND dist2.tipo_gestor = TGE.DD_TGE_CODIGO
            )
    left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
        ON (dist3.cod_cartera = dd_cra.dd_cra_codigo
            AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
            AND dist3.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist3.cod_municipio = dd_loc.dd_loc_codigo
            AND dist3.cod_postal IS NULL
            AND dist3.tipo_gestor = TGE.DD_TGE_CODIGO
            )
    left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4
        ON (dist4.cod_cartera = dd_cra.dd_cra_codigo
            AND dist4.cod_subcartera IS NULL
            AND dist4.cod_provincia = dd_prov.dd_prv_codigo
            AND dist4.cod_municipio = dd_loc.dd_loc_codigo
            AND dist4.cod_postal  = loc.BIE_LOC_COD_POST
            AND dist4.tipo_gestor = TGE.DD_TGE_CODIGO
    )
    left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5
        ON (dist5.cod_cartera = dd_cra.dd_cra_codigo
            AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
            AND dist5.cod_provincia = dd_prov.dd_prv_codigo 
            AND dist5.cod_municipio = dd_loc.dd_loc_codigo
            AND dist5.cod_postal  = loc.BIE_LOC_COD_POST
            AND dist5.tipo_gestor = TGE.DD_TGE_CODIGO
    )
    WHERE act.borrado = 0
		AND (dist0.tipo_gestor = ''SPUBL''
	      OR dist1.tipo_gestor = ''SPUBL''
	      OR dist2.tipo_gestor = ''SPUBL''
	      OR dist3.tipo_gestor = ''SPUBL''
	      OR dist4.tipo_gestor = ''SPUBL''
	      OR dist5.tipo_gestor = ''SPUBL'')
)';


    --DBMS_OUTPUT.PUT_LINE(  V_MSQL); 
  EXECUTE IMMEDIATE V_MSQL1||V_MSQL2||V_MSQL3||V_MSQL4||V_MSQL5;


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
