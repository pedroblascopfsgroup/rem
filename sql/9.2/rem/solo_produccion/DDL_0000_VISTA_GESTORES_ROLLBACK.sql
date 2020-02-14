--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191003
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5383
--## PRODUCTO=NO
--## Finalidad: Crear vista gestores activo
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##    0.1 Versión inicial Pau Serrano Rodrigo
--##    0.2 Cambio de GCBO a HAYAGBOINM / HAYASBOFIN SOG
--##    0.3 Cambio de GESRES y SUPRES.
--##    0.4 Cambio de SFORM
--##    0.5 HREOS-4844- SHG - AÑADIMOS GESTCOMALQ y SUPCOMALQ
--##	0.6 Se añade GPUBL y SPUBL.
--##	0.7 Se quita las restricción de filtrar por el tipo de destino comercial para los gestores GESTCOMALQ y SUPCOMALQ (HREOS-5090)
--##    0.8 Se añade el Supervisor comercial Backoffice Inmobiliario
--##    0.9 Se añade filtro tipo comercializar para Backoffice Inmobiliario
--##    0.10 Se añade filtro codigo postal para Backoffice Inmobiliario
--##	0.11v1 Se añade GFORMADM
--##	0.11v2 Se modifica la vista entera para añadirle el código de la subcartera
--##	0.12 Se modifica la vista para que no saque registros nulos
--##	0.13 Se corrige la query de GACT
--##    0.14 Se modifica la vista para optimizarla y quitar codigo duplicado
--##    0.15 Permitir que los gestores HAYAGBOINM, HAYASBOINM, SCOM, GCOM, SUPRES, GESRES se puedan asignar con activos con DD_TCR_ID nulo
--##    0.16 Se añade el gestor Portfolio Manager (GPM)
--##    0.17 SBG Se añaden las restricciones y se ordena en base a la configuración de gestores.
--##    0.18 VRO Se modifica el orden de la prioridad de los gestores segun subcartera.
--##	0.19 VRO Se modifica el orden de la prioridad de los gestores segun subcartera.
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
 
    V_MSQL0 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar
    V_MSQL1 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar    
    V_MSQL2 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar    
    V_MSQL3 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar  
    V_MSQL4 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar  
    V_MSQL5 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar  
    V_MSQL6 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar  
    V_MSQL7 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar  
    V_MSQL8 VARCHAR2( 32767 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2( 25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2( 25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER( 25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2( 32767 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT_VISTA VARCHAR2( 2400 CHAR) := 'V_GESTORES_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_1 VARCHAR2( 2400 CHAR) := 'V_GA_PARTE1'; 
	V_2 VARCHAR2( 2400 CHAR) := 'V_GA_PARTE2'; 
	V_3 VARCHAR2( 2400 CHAR) := 'V_GA_PARTE3'; 
	V_4 VARCHAR2( 2400 CHAR) := 'V_GA_PARTE4';
	V_5 VARCHAR2( 2400 CHAR) := 'V_GA_PARTE5';
	V_6 VARCHAR2( 2400 CHAR) := 'V_GA_PARTE6';

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('********  ' ||V_TEXT_VISTA|| '  ********'); 
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_VISTA||'... Creación vista');
  
  
  -- Creamos la vista
  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_VISTA||'...');

V_MSQL0 := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.V_GESTORES_ACTIVO AS 
				SELECT /*+ ALL_ROWS */  ACT_ID , DD_CRA_CODIGO, DD_SCR_CODIGO, DD_EAC_CODIGO, DD_TCR_CODIGO, DD_PRV_CODIGO, DD_LOC_CODIGO, COD_POSTAL, TIPO_GESTOR, USERNAME, NOMBRE 
				FROM (
                    SELECT /*+ ALL_ROWS */     ACT_ID 
                            , DD_CRA_CODIGO
                            , DD_SCR_CODIGO
                            , DD_EAC_CODIGO
                            , DD_TCR_CODIGO
                            , DD_PRV_CODIGO
                            , DD_LOC_CODIGO
                            , COD_POSTAL
                            , TIPO_GESTOR
                            , USERNAME
                            , NOMBRE  
                    FROM '||V_ESQUEMA||'.'||V_1||'
                        UNION ALL
                    SELECT /*+ ALL_ROWS */     ACT_ID 
                            , DD_CRA_CODIGO
                            , DD_SCR_CODIGO
                            , DD_EAC_CODIGO
                            , DD_TCR_CODIGO
                            , DD_PRV_CODIGO
                            , DD_LOC_CODIGO
                            , COD_POSTAL
                            , TIPO_GESTOR
                            , USERNAME
                            , NOMBRE 
                    FROM '||V_ESQUEMA||'.'||V_2||'
                        UNION ALL
                    SELECT /*+ ALL_ROWS */     ACT_ID 
                            , DD_CRA_CODIGO
                            , DD_SCR_CODIGO
                            , DD_EAC_CODIGO
                            , DD_TCR_CODIGO
                            , DD_PRV_CODIGO
                            , DD_LOC_CODIGO
                            , COD_POSTAL
                            , TIPO_GESTOR
                            , USERNAME
                            , NOMBRE 
                    FROM '||V_ESQUEMA||'.'||V_3||'                        
					)';

V_MSQL1 := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_1||' AS 
				SELECT /*+ ALL_ROWS */  ACT_ID , DD_CRA_CODIGO, DD_SCR_CODIGO, DD_EAC_CODIGO, DD_TCR_CODIGO, DD_PRV_CODIGO, DD_LOC_CODIGO, COD_POSTAL, TIPO_GESTOR, USERNAME, NOMBRE 
				FROM (
				
/*Gestor de grupo - SUPERVISOR COMERCIAL BACKOFFICE*/
/*Gestores de grupo*/
SELECT /*+ ALL_ROWS */  act.act_id,
                TO_NUMBER(COALESCE(dist2.cod_cartera,dist1.cod_cartera,dist0.cod_cartera)) DD_CRA_CODIGO, 
                TO_NUMBER(COALESCE(dist2.cod_subcartera,dist1.cod_subcartera,dist0.cod_subcartera)) DD_SCR_CODIGO,  
                NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                COALESCE(dist2.tipo_gestor,dist1.tipo_gestor,dist0.tipo_gestor) tipo_gestor, 
                COALESCE(dist2.username,dist1.username,dist0.username) username,
                COALESCE(dist2.nombre_usuario,dist1.nombre_usuario,dist0.nombre_usuario) nombre
			 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
                JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on act.dd_cra_id = cra.dd_cra_id
                JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA scr on act.dd_scr_id = scr.dd_scr_id AND cra.dd_cra_id = scr.dd_cra_id
                JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO IN (''GADM'', ''GMARK'', ''GPREC'', ''GTOPDV'', ''GTOPLUS'', ''GESTLLA'', 
                ''GADMT'', ''GFSV'', ''GCAL'', ''GESMIN'', ''SUPMIN'', ''SUPADM'',''GBACKOFFICE'')
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
                    AND (dist0.tipo_gestor = TGE.DD_TGE_CODIGO
                      OR dist1.tipo_gestor = TGE.DD_TGE_CODIGO 
                      OR dist2.tipo_gestor = TGE.DD_TGE_CODIGO)
UNION ALL                      
/*Gestor del activo*/
/*Gestor Comercial BackOffice Inmobiliario*/
/*Gestor de grupo - SUPERVISOR COMERCIAL BACKOFFICE LIBERBANK*/
/*Gestor capa de control*/
/*Gestor Liberbank Residencial (Liberbank)*/
/*Gestor Inversión Inmobiliaria (Liberbank)*/
/*Gestor Singular/Terciario (Liberbank)*/
/*Gestor Comité de Inversiones Inmobiliarias (Liberbank)*/
/*Gestor Comité Inmobiliario (Liberbank)*/
/*Gestor Comité de Dirección (Liberbank)*/
/*Supervisor comercial alquiler*/
/*supervisor del activo*/
/*Supervisor Comercial BackOffice Inmobiliario*/
/*Gestoría de admisión*/
/*Gestoría de administración*/
/*Gestoría de formalización*/
/*Gestor de formalización*/
/*Supervisor de formalizacion*/
/*Gestor comercial alquiler*/
/*Gestor comercial*/
/* SUPERVISOR COMERCIAL */
/*Gestor de publicaciones*/
/*Supervisor de publicaciones*/
SELECT /*+ ALL_ROWS */  act.act_id,
	   TO_NUMBER( COALESCE (dist9.cod_cartera, dist8.cod_cartera,dist3.cod_cartera,dist13.cod_cartera, dist12.cod_cartera,dist11.cod_cartera,dist10.cod_cartera,dist7.cod_cartera,dist6.cod_cartera,dist5.cod_cartera,dist4.cod_cartera,dist2.cod_cartera,dist0.cod_cartera)) DD_CRA_CODIGO,
	   TO_NUMBER( COALESCE (dist9.cod_subcartera, dist8.cod_subcartera,dist3.cod_subcartera,dist13.cod_subcartera, dist12.cod_subcartera,dist11.cod_subcartera,dist10.cod_subcartera,dist7.cod_subcartera,dist6.cod_subcartera,dist5.cod_subcartera,dist4.cod_subcartera,dist2.cod_subcartera,dist0.cod_subcartera)) DD_SCR_CODIGO,
	   TO_NUMBER (COALESCE (dist9.cod_estado_activo, dist8.cod_estado_activo,dist3.cod_estado_activo,dist13.cod_estado_activo, dist12.cod_estado_activo,dist11.cod_estado_activo,dist10.cod_estado_activo,dist7.cod_estado_activo,dist6.cod_estado_activo,dist5.cod_estado_activo,dist4.cod_estado_activo,dist2.cod_estado_activo,dist0.cod_estado_activo)) dd_eac_codigo,
	   COALESCE (dist9.cod_tipo_comerzialzacion, dist8.cod_tipo_comerzialzacion,dist3.cod_tipo_comerzialzacion,dist13.cod_tipo_comerzialzacion, dist12.cod_tipo_comerzialzacion,dist11.cod_tipo_comerzialzacion,dist10.cod_tipo_comerzialzacion,dist7.cod_tipo_comerzialzacion,dist6.cod_tipo_comerzialzacion, dist5.cod_tipo_comerzialzacion, dist4.cod_tipo_comerzialzacion, dist2.cod_tipo_comerzialzacion, dist0.cod_tipo_comerzialzacion) DD_TCR_CODIGO,
	   COALESCE (dist9.cod_provincia,dist8.cod_provincia,dist3.cod_provincia,dist13.cod_provincia,dist12.cod_provincia,dist11.cod_provincia,dist10.cod_provincia, dist7.cod_provincia, dist6.cod_provincia, dist5.cod_provincia, dist4.cod_provincia, dist2.cod_provincia, dist0.cod_provincia) cod_provincia,
       COALESCE (dist9.cod_municipio,dist8.cod_municipio,dist3.cod_municipio,dist13.cod_municipio,dist12.cod_municipio,dist11.cod_municipio,dist10.cod_municipio,dist7.cod_municipio,dist6.cod_municipio,dist5.cod_municipio,dist4.cod_municipio,dist2.cod_municipio,dist0.cod_municipio) cod_municipio,
       COALESCE (dist9.cod_postal,dist8.cod_postal,dist3.cod_postal,dist13.cod_postal,dist12.cod_postal,dist11.cod_postal,dist10.cod_postal,dist7.cod_postal,dist6.cod_postal,dist5.cod_postal,dist4.cod_postal,dist2.cod_postal,dist0.cod_postal) cod_postal,
       COALESCE (dist9.tipo_gestor,dist8.tipo_gestor,dist3.tipo_gestor,dist13.tipo_gestor,dist12.tipo_gestor,dist11.tipo_gestor,dist10.tipo_gestor,dist7.tipo_gestor,dist6.tipo_gestor,dist5.tipo_gestor,dist4.tipo_gestor,dist2.tipo_gestor,dist0.tipo_gestor) AS tipo_gestor,
       COALESCE (dist9.username,dist8.username,dist3.username,dist13.username,dist12.username,dist11.username,dist10.username,dist7.username,dist6.username,dist5.username,dist4.username,dist2.username,dist0.username) username,
       COALESCE (dist9.nombre_usuario,dist8.nombre_usuario,dist3.nombre_usuario,dist13.nombre_usuario,dist12.nombre_usuario,dist11.nombre_usuario,dist10.nombre_usuario,dist7.nombre_usuario,dist6.nombre_usuario,dist5.nombre_usuario,dist4.nombre_usuario,dist2.nombre_usuario,dist0.nombre_usuario) nombre
  FROM '||V_ESQUEMA||'.act_activo act 
	   JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       LEFT JOIN '||V_ESQUEMA||'.dd_tcr_tipo_comercializar dd_tcr ON dd_tcr.dd_tcr_id = act.dd_tcr_id
       LEFT JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
       JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
       JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO IN (''GACT'',''HAYAGBOINM'',''GTREE'',''SBACKOFFICEINMLIBER''
																					,''GCCBANKIA'',''GLIBRES'',''GLIBINVINM'',''GLIBSINTER''
																					,''GCOIN'',''GCOINM'',''GCODI'',''SUPCOMALQ''
                                                                                    ,''SUPACT'',''HAYASBOINM'',''GGADM'',''GIAADMT'',''GIAFORM''
                                                                                    ,''GFORM'',''SFORM'',''GESTCOMALQ'',''PTEC''
                                                                                    ,''GCOM'',''SCOM'',''GPUBL'',''SPUBL'', ''GPM'',''GCCLBK''
                                                                                    )
            left JOIN REM01.act_ges_dist_gestores dist0
               ON (dist0.cod_estado_activo IS NULL
                   AND dist0.cod_tipo_comerzialzacion IS NULL
                   AND dist0.cod_cartera IS NULL
                   AND dist0.cod_subcartera IS NULL
                   AND dist0.cod_provincia IS NULL
                   AND dist0.cod_municipio IS NULL
                   AND dist0.cod_postal IS NULL
                   AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
                  )          
left JOIN REM01.act_ges_dist_gestores dist2
               ON (dist2.cod_estado_activo IS NULL
                   AND dist2.cod_tipo_comerzialzacion IS NULL
                   AND dist2.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist2.cod_subcartera IS NULL
                   AND dist2.cod_provincia IS NULL
                   AND dist2.cod_municipio IS NULL
                   AND dist2.cod_postal IS NULL
                   AND dist2.tipo_gestor = TGE.DD_TGE_CODIGO
                  )        
left JOIN REM01.act_ges_dist_gestores dist3
               ON (dist3.cod_estado_activo IS NULL
                   AND dist3.cod_tipo_comerzialzacion IS NULL
                   AND dist3.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
                   AND dist3.cod_provincia IS NULL
                   AND dist3.cod_municipio IS NULL
                   AND dist3.cod_postal IS NULL
                   AND dist3.tipo_gestor = TGE.DD_TGE_CODIGO
                  )                          
left JOIN REM01.act_ges_dist_gestores dist4
               ON (dist4.cod_estado_activo IS NULL
                   AND dist4.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo
                   AND dist4.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist4.cod_subcartera IS NULL
                   AND dist4.cod_provincia IS NULL
                   AND dist4.cod_municipio IS NULL
                   AND dist4.cod_postal IS NULL
                   AND dist4.tipo_gestor = TGE.DD_TGE_CODIGO
                  )               
left JOIN REM01.act_ges_dist_gestores dist5
               ON (dist5.cod_estado_activo IS NULL
                   AND dist5.cod_tipo_comerzialzacion IS NULL
                   AND dist5.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist5.cod_subcartera IS NULL
                   AND dist5.cod_provincia = dd_prov.dd_prv_codigo
                   AND dist5.cod_municipio IS NULL
                   AND dist5.cod_postal IS NULL
                   AND dist5.tipo_gestor = TGE.DD_TGE_CODIGO
                  )     
left JOIN REM01.act_ges_dist_gestores dist6
               ON (dist6.cod_estado_activo IS NULL
                   AND dist6.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo
                   AND dist6.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist6.cod_subcartera IS NULL
                   AND dist6.cod_provincia = dd_prov.dd_prv_codigo
                   AND dist6.cod_municipio IS NULL
                   AND dist6.cod_postal IS NULL
                   AND dist6.tipo_gestor = TGE.DD_TGE_CODIGO
                  )                       
left JOIN REM01.act_ges_dist_gestores dist7
               ON (dist7.cod_estado_activo = dd_eac.dd_eac_codigo
                   AND dist7.cod_tipo_comerzialzacion IS NULL
                   AND dist7.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist7.cod_subcartera IS NULL
                   AND dist7.cod_provincia = dd_prov.dd_prv_codigo
                   AND dist7.cod_municipio IS NULL
                   AND dist7.cod_postal IS NULL
                   AND dist7.tipo_gestor = TGE.DD_TGE_CODIGO
                  )     
left JOIN REM01.act_ges_dist_gestores dist8
               ON (dist8.cod_estado_activo IS NULL
                   AND dist8.cod_tipo_comerzialzacion IS NULL
                   AND dist8.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist8.cod_subcartera = dd_scr.dd_scr_codigo
                   AND dist8.cod_provincia = dd_prov.dd_prv_codigo
                   AND dist8.cod_municipio IS NULL
                   AND dist8.cod_postal IS NULL
                   AND dist8.tipo_gestor = TGE.DD_TGE_CODIGO
                  )
left JOIN REM01.act_ges_dist_gestores dist9
               ON (dist9.cod_estado_activo IS NULL
                   AND dist9.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo
                   AND dist9.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist9.cod_subcartera = dd_scr.dd_scr_codigo
                   AND dist9.cod_provincia IS NULL
                   AND dist9.cod_municipio IS NULL
                   AND dist9.cod_postal IS NULL
                   AND dist9.tipo_gestor = TGE.DD_TGE_CODIGO
                  )
left JOIN REM01.act_ges_dist_gestores dist10
               ON (dist10.cod_estado_activo IS NULL
                   AND dist10.cod_tipo_comerzialzacion IS NULL
                   AND dist10.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist10.cod_subcartera IS NULL
                   AND dist10.cod_provincia = dd_prov.dd_prv_codigo
                   AND dist10.cod_municipio = dd_loc.dd_loc_codigo
                   AND dist10.cod_postal IS NULL
                   AND dist10.tipo_gestor = TGE.DD_TGE_CODIGO
                  )
left JOIN REM01.act_ges_dist_gestores dist11
               ON (dist11.cod_estado_activo IS NULL
                   AND dist11.cod_tipo_comerzialzacion IS NULL
                   AND dist11.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist11.cod_subcartera IS NULL
                   AND dist11.cod_provincia = dd_prov.dd_prv_codigo
                   AND dist11.cod_municipio = dd_loc.dd_loc_codigo
                   AND dist11.cod_postal = loc.BIE_LOC_COD_POST
                   AND dist11.tipo_gestor = TGE.DD_TGE_CODIGO
                  )       
left JOIN REM01.act_ges_dist_gestores dist12
               ON (dist12.cod_estado_activo IS NULL
                   AND dist12.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo
                   AND dist12.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist12.cod_subcartera IS NULL
                   AND dist12.cod_provincia = dd_prov.dd_prv_codigo
                   AND dist12.cod_municipio = dd_loc.dd_loc_codigo
                   AND dist12.cod_postal IS NULL
                   AND dist12.tipo_gestor = TGE.DD_TGE_CODIGO
                  )                   
left JOIN REM01.act_ges_dist_gestores dist13
               ON (dist13.cod_estado_activo IS NULL
                   AND dist13.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo
                   AND dist13.cod_cartera = dd_cra.dd_cra_codigo
                   AND dist13.cod_subcartera IS NULL
                   AND dist13.cod_provincia = dd_prov.dd_prv_codigo
                   AND dist13.cod_municipio = dd_loc.dd_loc_codigo
                   AND dist13.cod_postal = loc.BIE_LOC_COD_POST
                   AND dist13.tipo_gestor = TGE.DD_TGE_CODIGO
                  )  
where act.borrado = 0  and
		( 		dist0.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist2.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist3.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist4.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist5.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist6.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist7.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist8.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist9.tipo_gestor = TGE.DD_TGE_CODIGO
            OR  dist10.tipo_gestor = TGE.DD_TGE_CODIGO
            OR  dist11.tipo_gestor = TGE.DD_TGE_CODIGO
            OR  dist12.tipo_gestor = TGE.DD_TGE_CODIGO
            OR  dist13.tipo_gestor = TGE.DD_TGE_CODIGO
		)                                       
)';

V_MSQL2 := ' CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_2||' AS 
				SELECT /*+ ALL_ROWS */  ACT_ID , DD_CRA_CODIGO, DD_SCR_CODIGO, DD_EAC_CODIGO, DD_TCR_CODIGO, DD_PRV_CODIGO, DD_LOC_CODIGO, COD_POSTAL, TIPO_GESTOR, USERNAME, NOMBRE 
				FROM (
/*Gestor de Reserva (Cajamar)*/ 
SELECT /*+ ALL_ROWS */  act.act_id, 
        TO_NUMBER (COALESCE(dist8.cod_cartera,dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) DD_CRA_CODIGO, 
        TO_NUMBER (COALESCE(dist8.cod_subcartera,dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) DD_SCR_CODIGO,
        null DD_EAC_CODIGO, 
        COALESCE(dist8.cod_tipo_comerzialzacion,dist7.cod_tipo_comerzialzacion, dist6.cod_tipo_comerzialzacion, dist5.cod_tipo_comerzialzacion, dist4.cod_tipo_comerzialzacion, dist3.cod_tipo_comerzialzacion, dist2.cod_tipo_comerzialzacion, dist1.cod_tipo_comerzialzacion, dist0.cod_tipo_comerzialzacion) DD_TCR_CODIGO, 
        COALESCE(dist8.cod_provincia,dist7.cod_provincia, dist6.cod_provincia, dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) DD_PRV_CODIGO,
        COALESCE (dist8.cod_municipio,dist7.cod_municipio, dist6.cod_municipio, dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) DD_LOC_CODIGO,
        COALESCE (dist8.cod_postal,dist7.cod_postal, dist6.cod_postal, dist5.cod_postal, dist4.cod_postal, dist3.cod_postal, dist2.cod_postal, dist1.cod_postal, dist0.cod_postal) cod_postal,
        COALESCE (dist8.tipo_gestor,dist7.tipo_gestor, dist6.tipo_gestor, dist5.tipo_gestor, dist4.tipo_gestor, dist3.tipo_gestor, dist2.tipo_gestor, dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
        COALESCE (dist8.username,dist7.username, dist6.username, dist5.username, dist4.username, dist3.username, dist2.username, dist1.username, dist0.username) username,
        COALESCE (dist8.nombre_usuario,dist7.nombre_usuario, dist6.nombre_usuario, dist5.nombre_usuario, dist4.nombre_usuario, dist3.nombre_usuario, dist2.nombre_usuario, dist1.nombre_usuario, dist0.nombre_usuario) nombre
  FROM '||V_ESQUEMA||'.act_activo act 
	   JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
       JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
       JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
       LEFT JOIN '||V_ESQUEMA||'.dd_tcr_tipo_comercializar dd_tcr ON dd_tcr.dd_tcr_id = act.dd_tcr_id
       JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
       JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
       JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO IN (''GESRES'',''SUPRES'')
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0
       ON (dist0.cod_tipo_comerzialzacion IS NULL
           AND dist0.cod_cartera = dd_cra.dd_cra_codigo
           AND dist0.cod_subcartera IS NULL
           AND dist0.cod_provincia IS NULL
           AND dist0.cod_municipio IS NULL
           AND dist0.cod_postal IS NULL
           AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1
       ON (dist1.cod_tipo_comerzialzacion IS NULL
           AND dist1.cod_cartera = dd_cra.dd_cra_codigo
           AND dist1.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist1.cod_provincia IS NULL
           AND dist1.cod_municipio IS NULL
           AND dist1.cod_postal IS NULL
           AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist2
       ON (dist2.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist2.cod_cartera = dd_cra.dd_cra_codigo
           AND dist2.cod_subcartera IS NULL
           AND dist2.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist2.cod_municipio IS NULL
           AND dist2.cod_postal IS NULL
           AND dist2.tipo_gestor = TGE.DD_TGE_CODIGO
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist3
       ON (dist3.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist3.cod_cartera = dd_cra.dd_cra_codigo
           AND dist3.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist3.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist3.cod_municipio IS NULL
           AND dist3.cod_postal IS NULL
           AND dist3.tipo_gestor = TGE.DD_TGE_CODIGO
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist4
       ON (dist4.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist4.cod_cartera = dd_cra.dd_cra_codigo
           AND dist4.cod_subcartera IS NULL
           AND dist4.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist4.cod_municipio = dd_loc.dd_loc_codigo
           AND dist4.cod_postal IS NULL
           AND dist4.tipo_gestor = TGE.DD_TGE_CODIGO
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist5
       ON (dist5.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo  
           AND dist5.cod_cartera = dd_cra.dd_cra_codigo
           AND dist5.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist5.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist5.cod_municipio = dd_loc.dd_loc_codigo
           AND dist5.cod_postal IS NULL
           AND dist5.tipo_gestor = TGE.DD_TGE_CODIGO
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist6
       ON (dist6.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo
           AND dist6.cod_cartera = dd_cra.dd_cra_codigo
           AND dist6.cod_subcartera IS NULL
           AND dist6.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist6.cod_municipio = dd_loc.dd_loc_codigo
           AND dist6.cod_postal = loc.BIE_LOC_COD_POST
           AND dist6.tipo_gestor = TGE.DD_TGE_CODIGO
          )   
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist7
       ON (dist7.cod_tipo_comerzialzacion = dd_tcr.dd_tcr_codigo 
           AND dist7.cod_cartera = dd_cra.dd_cra_codigo
           AND dist7.cod_subcartera = dd_scr.dd_scr_codigo
           AND dist7.cod_provincia = dd_prov.dd_prv_codigo  
           AND dist7.cod_municipio = dd_loc.dd_loc_codigo
           AND dist7.cod_postal = loc.BIE_LOC_COD_POST
           AND dist7.tipo_gestor = TGE.DD_TGE_CODIGO
          )
       left JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist8
        ON (dist8.cod_tipo_comerzialzacion IS NULL
            AND dist8.cod_cartera = dd_cra.dd_cra_codigo
            AND dist8.cod_subcartera IS NULL
            AND dist8.cod_provincia = dd_prov.dd_prv_codigo
            AND dist8.cod_municipio = dd_loc.dd_loc_codigo
            AND dist8.cod_postal IS NULL
            AND dist8.tipo_gestor = TGE.DD_TGE_CODIGO
           )
          where act.borrado = 0 and 
		( 		dist0.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist1.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist2.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist3.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist4.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist5.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist6.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist7.tipo_gestor = TGE.DD_TGE_CODIGO
			OR  dist8.tipo_gestor = TGE.DD_TGE_CODIGO
		) 
    and act.dd_cra_id in (SELECT /*+ ALL_ROWS */  dd_cra_id from '||V_ESQUEMA||'.dd_cra_cartera where dd_cra_codigo = ''01'')
    and act.dd_scm_id in (SELECT /*+ ALL_ROWS */  dd_scm_id from '||V_ESQUEMA||'.dd_scm_situacion_comercial  where dd_scm_codigo <> ''05'')
	)';

V_MSQL3 := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_3||' AS 
				SELECT /*+ ALL_ROWS */  ACT_ID , DD_CRA_CODIGO, DD_SCR_CODIGO, DD_EAC_CODIGO, DD_TCR_CODIGO, DD_PRV_CODIGO, DD_LOC_CODIGO, COD_POSTAL, TIPO_GESTOR, USERNAME, NOMBRE 
				FROM (		

/*Gestor de suelos*/
/*Supervisor de suelos*/
        SELECT /*+ ALL_ROWS */   act.act_id, 
        TO_NUMBER (COALESCE(dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) DD_CRA_CODIGO, 
        TO_NUMBER (COALESCE(dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) DD_SCR_CODIGO,
        null dd_eac_codigo, 
        COALESCE(dist7.cod_tipo_comerzialzacion, dist6.cod_tipo_comerzialzacion, dist5.cod_tipo_comerzialzacion, dist4.cod_tipo_comerzialzacion, dist3.cod_tipo_comerzialzacion, dist2.cod_tipo_comerzialzacion, dist1.cod_tipo_comerzialzacion, dist0.cod_tipo_comerzialzacion) DD_TCR_CODIGO, 
        COALESCE(dist7.cod_provincia, dist6.cod_provincia, dist5.cod_provincia, dist4.cod_provincia, dist3.cod_provincia, dist2.cod_provincia, dist1.cod_provincia, dist0.cod_provincia) DD_PRV_CODIGO,
        COALESCE (dist7.cod_municipio, dist6.cod_municipio, dist5.cod_municipio, dist4.cod_municipio, dist3.cod_municipio, dist2.cod_municipio, dist1.cod_municipio, dist0.cod_municipio) DD_LOC_CODIGO,
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
            JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO IN (''GSUE'',''SUPSUE'')
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
            act.borrado = 0 and 
			( 		dist0.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist1.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist2.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist3.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist4.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist5.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist6.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist7.tipo_gestor = TGE.DD_TGE_CODIGO
			)
            AND act.DD_TPA_ID = (SELECT /*+ ALL_ROWS */  DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = ''01'')
            AND act.DD_EAC_ID = (SELECT /*+ ALL_ROWS */  DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = ''01'')
UNION ALL                     


/*Gestor de edificación*/
/*Supervisor de edificación*/
        SELECT /*+ ALL_ROWS */   act.act_id, 
        TO_NUMBER (COALESCE(dist7.cod_cartera, dist6.cod_cartera, dist5.cod_cartera, dist4.cod_cartera, dist3.cod_cartera, dist2.cod_cartera, dist1.cod_cartera, dist0.cod_cartera)) DD_CRA_CODIGO, 
        TO_NUMBER (COALESCE(dist7.cod_subcartera, dist6.cod_subcartera, dist5.cod_subcartera, dist4.cod_subcartera, dist3.cod_subcartera, dist2.cod_subcartera, dist1.cod_subcartera, dist0.cod_subcartera)) DD_SCR_CODIGO,
        null dd_eac_codigo, 
        COALESCE(dist7.cod_tipo_comerzialzacion, dist6.cod_tipo_comerzialzacion, dist5.cod_tipo_comerzialzacion, dist4.cod_tipo_comerzialzacion, dist3.cod_tipo_comerzialzacion, dist2.cod_tipo_comerzialzacion, dist1.cod_tipo_comerzialzacion, dist0.cod_tipo_comerzialzacion) DD_TCR_CODIGO, 
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
            JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO IN (''GEDI'',''SUPEDI'')
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
            act.borrado = 0 and 
			( 		dist0.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist1.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist2.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist3.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist4.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist5.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist6.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist7.tipo_gestor = TGE.DD_TGE_CODIGO
			)
            AND act.DD_TPA_ID != (SELECT /*+ ALL_ROWS */  DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = ''01'')
            AND act.DD_EAC_ID IN (SELECT /*+ ALL_ROWS */  DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO IN (''09'', ''02'', ''06'', ''11'', ''10'', ''05'', ''08'', ''07''))
    UNION ALL
  
   /* Gestor de alquileres */ 
 SELECT /*+ ALL_ROWS */  act.act_id, 
                  TO_NUMBER(COALESCE(dist1.cod_cartera,dist0.cod_cartera)) DD_CRA_CODIGO, 
                  TO_NUMBER(COALESCE(dist1.cod_subcartera,dist0.cod_subcartera)) DD_SCR_CODIGO, 
                  NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                  COALESCE(dist1.tipo_gestor, dist0.tipo_gestor) AS tipo_gestor,
                  COALESCE(dist1.username, dist0.username) username,
                  COALESCE(dist1.nombre_usuario, dist0.nombre_usuario) nombre
             FROM '||V_ESQUEMA||'.act_activo act 
				  JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
				  JOIN '||V_ESQUEMA||'.dd_scr_subcartera dd_scr ON dd_scr.dd_cra_id = dd_cra.dd_cra_id AND dd_scr.dd_scr_id = act.dd_scr_id
				  JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO ACT_PTA ON ACT_PTA.ACT_ID = ACT.ACT_ID 
				  JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = ''GALQ''
                  LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist0 
                    ON (dist0.cod_cartera IS NULL
                        AND dist0.cod_subcartera IS NULL 
                        AND dist0.tipo_gestor = TGE.DD_TGE_CODIGO)
                  LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist1 
                    ON (dist1.cod_cartera = dd_cra.dd_cra_codigo 
                        AND dist1.cod_subcartera = dd_scr.dd_scr_codigo 
                        AND dist1.tipo_gestor = TGE.DD_TGE_CODIGO)
           where act.borrado = 0 and 
			( 		dist0.tipo_gestor = TGE.DD_TGE_CODIGO
				OR  dist1.tipo_gestor = TGE.DD_TGE_CODIGO
			) AND ACT_PTA.CHECK_HPM = 1
UNION ALL

/* Supervisor de alquileres */ 

SELECT /*+ ALL_ROWS */  act.act_id,
                TO_NUMBER(COALESCE(dist2.cod_cartera,dist1.cod_cartera,dist0.cod_cartera)) DD_CRA_CODIGO, 
                TO_NUMBER(COALESCE(dist2.cod_subcartera,dist1.cod_subcartera,dist0.cod_subcartera)) DD_SCR_CODIGO,  
                NULL dd_eac_codigo, NULL dd_tcr_codigo, NULL dd_prv_codigo, NULL dd_loc_codigo, NULL cod_postal, 
                COALESCE(dist2.tipo_gestor,dist1.tipo_gestor,dist0.tipo_gestor) tipo_gestor, 
                COALESCE(dist2.username,dist1.username,dist0.username) username,
                COALESCE(dist2.nombre_usuario,dist1.nombre_usuario,dist0.nombre_usuario) nombre
			 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
                JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on act.dd_cra_id = cra.dd_cra_id
                JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA scr on act.dd_scr_id = scr.dd_scr_id AND cra.dd_cra_id = scr.dd_cra_id
                JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO ACT_PTA ON ACT_PTA.ACT_ID = ACT.ACT_ID
                JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO IN (''SUALQ'')
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
                where act.borrado = 0 AND ACT_PTA.CHECK_HPM = 1
                    AND (dist0.tipo_gestor = TGE.DD_TGE_CODIGO
                      OR dist1.tipo_gestor = TGE.DD_TGE_CODIGO 
                      OR dist2.tipo_gestor = TGE.DD_TGE_CODIGO)
UNION ALL                      

/* Gestor Formalización-Administración */

        SELECT /*+ ALL_ROWS */ 
            act.act_id,
            TO_NUMBER (dd_cra.dd_cra_codigo) dd_cra_codigo,
			NULL dd_scr_codigo,
            TO_NUMBER (dd_eac.DD_EAC_CODIGO) dd_eac_codigo,
			NULL DD_TCR_CODIGO,
            dist.cod_provincia DD_PRV_CODIGO,
            dist.cod_municipio DD_LOC_CODIGO,
            dist.cod_postal cod_postal,
            dist.tipo_gestor AS tipo_gestor,
            dist.username username,
            nombre_usuario nombre_usuario
        FROM '||V_ESQUEMA||'.act_activo act
            JOIN '||V_ESQUEMA||'.act_loc_localizacion aloc ON act.act_id = aloc.act_id
            JOIN '||V_ESQUEMA||'.bie_localizacion loc ON loc.bie_loc_id = aloc.bie_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_loc_localidad dd_loc ON loc.dd_loc_id = dd_loc.dd_loc_id
            JOIN '||V_ESQUEMA_M||'.dd_prv_provincia dd_prov ON dd_prov.dd_prv_id = loc.dd_prv_id
            JOIN '||V_ESQUEMA||'.dd_eac_estado_activo dd_eac ON dd_eac.dd_eac_id = act.dd_eac_id
            JOIN '||V_ESQUEMA||'.dd_cra_cartera dd_cra ON dd_cra.dd_cra_id = act.dd_cra_id
            LEFT JOIN '||V_ESQUEMA||'.act_ges_dist_gestores dist 
            ON (dd_prov.dd_prv_codigo = dist.cod_provincia
            AND dist.tipo_gestor = ''GFORMADM'')
          WHERE
            act.borrado = 0 AND dist.COD_PROVINCIA IN (''8'',''17'',''43'',''25'')                
) ';
    
    
-- HASTA AQUÍ VISTA 1


V_MSQL4 := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_4||' AS 
				SELECT /*+ ALL_ROWS */  ACT_ID , DD_CRA_CODIGO, DD_SCR_CODIGO, DD_EAC_CODIGO, DD_TCR_CODIGO, DD_PRV_CODIGO, DD_LOC_CODIGO, COD_POSTAL, TIPO_GESTOR, USERNAME, NOMBRE 
				FROM (
            				
				)';
  
V_MSQL5 := ' CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_5||' AS 
				SELECT /*+ ALL_ROWS */  ACT_ID , DD_CRA_CODIGO, DD_SCR_CODIGO, DD_EAC_CODIGO, DD_TCR_CODIGO, DD_PRV_CODIGO, DD_LOC_CODIGO, COD_POSTAL, TIPO_GESTOR, USERNAME, NOMBRE 
				FROM (

 )';

V_MSQL6 := '  CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_6||' AS 
				SELECT /*+ ALL_ROWS */  ACT_ID , DD_CRA_CODIGO, DD_SCR_CODIGO, DD_EAC_CODIGO, DD_TCR_CODIGO, DD_PRV_CODIGO, DD_LOC_CODIGO, COD_POSTAL, TIPO_GESTOR, USERNAME, NOMBRE 
				FROM ( 
)';


--  DBMS_OUTPUT.PUT_LINE (V_MSQL1 );
DBMS_OUTPUT.PUT_LINE('[INFO] Empieza '||V_1||' - '||LENGTH(V_MSQL1)||' ');
EXECUTE IMMEDIATE V_MSQL1 ;
--  DBMS_OUTPUT.PUT_LINE (V_MSQL2 );
DBMS_OUTPUT.PUT_LINE('[INFO] Empieza '||V_2||' - '||LENGTH(V_MSQL2)||' ');
EXECUTE IMMEDIATE V_MSQL2;
COMMIT;

-- DBMS_OUTPUT.PUT_LINE (V_MSQL3);
DBMS_OUTPUT.PUT_LINE('[INFO] Empieza '||V_3||' - '||LENGTH(V_MSQL3)||' ');
EXECUTE IMMEDIATE V_MSQL3  ;	
--	DBMS_OUTPUT.PUT_LINE (V_MSQL4 );
--  DBMS_OUTPUT.PUT_LINE('[INFO] Empieza '||V_4||' - '||LENGTH(V_MSQL4)||' ');
--  EXECUTE IMMEDIATE V_MSQL4 ;	
COMMIT;

--	DBMS_OUTPUT.PUT_LINE (V_MSQL5 );
--  DBMS_OUTPUT.PUT_LINE('[INFO] Empieza '||V_5||' - '||LENGTH(V_MSQL5)||' ');
--  EXECUTE IMMEDIATE V_MSQL5;
--  DBMS_OUTPUT.PUT_LINE (V_MSQL6);
--  DBMS_OUTPUT.PUT_LINE('[INFO] Empieza '||V_6||' - '||LENGTH(V_MSQL6)||' ');
--  EXECUTE IMMEDIATE V_MSQL6 ;
--  COMMIT;

--	DBMS_OUTPUT.PUT_LINE (V_MSQL0);
DBMS_OUTPUT.PUT_LINE('[INFO] Empieza '||V_TEXT_VISTA||' - '||LENGTH(V_MSQL0)||' ');
EXECUTE IMMEDIATE V_MSQL0;

DBMS_OUTPUT.PUT_LINE('[FIN]  Finaliza la creación del la vista - '||V_TEXT_VISTA||' ');

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
