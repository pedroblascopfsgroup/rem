--/*
--##########################################
--## AUTOR=Sergio Belenguer Gadea
--## FECHA_CREACION=20181024
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4606
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial ANAHUAC DE VICENTE
--## 		0.2 JOSEVI: Nuevas condiciones: Varios propietarios activo o 1 propietario con menos de 100%.
--##             Calculo de condicionado/no condicionado desde la vista
--##		0.3 HREOS-1954 - Inclusión condicionantes SIN_INFORME_APROBADO y CON_CARGAS
--##		0.4 HREOS-2142 - Corregir PENDIENTE_INSCRIPCION que estaba al reves
--##		0.5 Correcciones pre arranque REM
--##		0.6	HREOS-2628
--##		0.7 HREOS-2992 - Correcciones para PDVs
--##		0.8 HREOS-3344 - Cambio check obra nueva en construcción
--##		0.9 HREOS-3890 - Vandalizado añadido
--##		0.10 REMVIP-205 - Cambio de la forma de cálculo de el campo "Pendiente de inscripción"
--##		0.11 REMVIP-448 - Añadir condicion de poner nulos a 0
--##		0.12 REMVIP-969 - Añadir condicionante "Sin acceso"
--##		0.13 HREOS-4565 -SBG- Optimizar vista: evito hacer 7 LEFT con la tabla act_sps_sit_posesoria y 2 LEFT con la tabla dd_eac_estado_activo añadiendo CASE con las distintas opciones
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Vble. número de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_COND_DISPONIBILIDAD' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_COND_DISPONIBILIDAD';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.v_cond_disponibilidad (act_id,
                                                          sin_toma_posesion_inicial,
                                                          ocupado_contitulo,
                                                          pendiente_inscripcion,
                                                          proindiviso,
                                                          tapiado,
                                                          obranueva_sindeclarar,
                                                          obranueva_enconstruccion,
                                                          divhorizontal_noinscrita,
                                                          ruina,
                                                          vandalizado,
                                                          otro,
                                                          sin_informe_aprobado,
                                                          revision,
                                                          procedimiento_judicial,
                                                          con_cargas,
							                                sin_acceso,
                                                          ocupado_sintitulo,
                                                          estado_portal_externo,
                                                          es_condicionado,
                                                          est_disp_com_codigo,
                                                          borrado
                                                         )
AS
   SELECT act_id, sin_toma_posesion_inicial, ocupado_contitulo, pendiente_inscripcion, proindiviso, tapiado, obranueva_sindeclarar, obranueva_enconstruccion, divhorizontal_noinscrita, ruina, vandalizado, otro,
          sin_informe_aprobado, revision, procedimiento_judicial, con_cargas, sin_acceso, ocupado_sintitulo, estado_portal_externo, DECODE (est_disp_com_codigo, ''01'', 1, 0) AS es_condicionado,
          est_disp_com_codigo, borrado

     FROM (SELECT act.act_id, 
				CASE WHEN (sps1.dd_sij_id is not null and sij.DD_SIJ_INDICA_POSESION = 0) 
                    THEN 1 
                    ELSE 
						CASE WHEN (sps1.sps_fecha_toma_posesion IS NULL AND aba2.dd_cla_id = 2) 
							THEN 1 
							ELSE 0 
						END 
                END AS sin_toma_posesion_inicial,        
                CASE WHEN (sps1.sps_ocupado = 1 AND sps1.sps_con_titulo = 1) THEN 1 ELSE 0 END AS ocupado_contitulo,
                NVL2 (tit.act_id, 0, 1) AS pendiente_inscripcion,
                NVL2 (npa.act_id, 1, 0) AS proindiviso,
                CASE WHEN sps1.sps_acc_tapiado = 1 THEN 1 ELSE 0 END AS tapiado, 
                NVL2 (eon.dd_eon_id, 1, 0) AS obranueva_sindeclarar,
                CASE WHEN (eac1.dd_eac_codigo = ''02''  OR   eac1.dd_eac_codigo = ''06'') THEN 1 ELSE 0 END as obranueva_enconstruccion, 
                NVL2 (reg2.reg_id, 1, 0) AS divhorizontal_noinscrita, 
                CASE WHEN eac1.dd_eac_codigo = ''05'' THEN 1 ELSE 0 END as ruina,
				CASE WHEN (eac1.dd_eac_codigo = ''07'' ) THEN 1 ELSE 0 END as VANDALIZADO,
                sps1.sps_otro AS otro,
                DECODE (vei.dd_aic_codigo, ''02'', 0, 1) AS sin_informe_aprobado,
                0 AS revision,                                                                                      --NO EXISTE EN REM
				0 AS procedimiento_judicial,                                                          --NO EXISTE EN REM
				NVL2 (vcg.con_cargas, vcg.con_cargas, 0) AS con_cargas,
                DECODE (ico.ico_posible_hacer_inf, 1, 0, 0, 1, 0) AS sin_acceso,                                                                                                            
                CASE WHEN (sps1.sps_ocupado = 1 AND sps1.sps_con_titulo = 0) THEN 1 ELSE 0 END AS ocupado_sintitulo, 
                CASE WHEN (sps1.sps_estado_portal_externo = 1) THEN 1 ELSE 0 END AS estado_portal_externo,  -- ESTADO PUBLICACION PORTALES EXTERNOS
                CASE WHEN ( (sps1.sps_fecha_toma_posesion IS NULL AND aba2.dd_cla_id = 2)               -- SIN TOMA POSESION INICIAL
                           OR eac1.dd_eac_codigo=''05''                                                   -- RUINA

                           OR NVL2 (tit.act_id, 0, 1) = 1
                           OR NVL2 (eon.dd_eon_id, 1, 0) = 1
                           OR NVL2 (npa.act_id, 1, 0) = 1
                           OR (eac1.dd_eac_codigo = ''02''  OR   eac1.dd_eac_codigo = ''06'' OR eac1.dd_eac_codigo = ''07'')               -- OBRA NUEVA EN CONSTRUCCIÓN/VANDALIZADO
                           OR (sps1.sps_ocupado = 1 AND sps1.sps_con_titulo = 1)                        -- OCUPADO CON TITULO
                           OR sps1.sps_acc_tapiado = 1                                                  -- TAPIADO
                           OR (sps1.sps_ocupado = 1 AND sps1.sps_con_titulo = 0)                        -- OCUPADO SIN TITULO
                           OR NVL2 (reg2.reg_id, 1, 0) = 1

                           OR NVL2(sps1.sps_otro,1,0) = 1                                               -- OTROS MOTIVOS                           

                          )                                                                                                                              --OR DECODE(VEI.DD_AIC_CODIGO ,''02'' ,0 , 1) = 1
						   OR NVL2 (vcg.con_cargas, vcg.con_cargas, 0) = 1
					THEN ''01''
                    ELSE ''02''
                  END AS est_disp_com_codigo,
                  0 AS borrado
             FROM '||V_ESQUEMA||'.act_activo act LEFT JOIN '||V_ESQUEMA||'.act_aba_activo_bancario aba2 ON aba2.act_id = act.act_id 

				  LEFT JOIN '||V_ESQUEMA||'.dd_eac_estado_activo eac1 ON eac1.dd_eac_id = act.dd_eac_id                  
                  LEFT JOIN '||V_ESQUEMA||'.act_sps_sit_posesoria sps1 ON sps1.act_id = act.act_id                  
				  LEFT JOIN '||V_ESQUEMA||'.DD_SIJ_SITUACION_JURIDICA sij on  sij.dd_sij_id =sps1.dd_sij_id                   

				  LEFT JOIN
                  (SELECT act_tit.act_id
                     FROM '||V_ESQUEMA||'.act_reg_info_registral act_reg JOIN '||V_ESQUEMA||'.act_aba_activo_bancario aba ON aba.act_id = act_reg.act_id
                     JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO act_tit ON act_tit.act_id = act_reg.act_id 
                     JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BDR ON BDR.BIE_DREG_ID = act_REG.BIE_DREG_ID
                    WHERE aba.dd_cla_id = 1 OR act_tit.TIT_FECHA_INSC_REG IS NOT NULL) tit ON tit.act_id = act.act_id                                                            -- PENDIENTE DE INSCRIPCIÓN
                  LEFT JOIN '||V_ESQUEMA||'.act_reg_info_registral reg1 ON reg1.act_id = act.act_id
                  LEFT JOIN '||V_ESQUEMA||'.dd_eon_estado_obra_nueva eon ON eon.dd_eon_id = reg1.dd_eon_id AND eon.dd_eon_codigo IN (''02'')                                              -- OBRA NUEVA SIN DECLARAR
                  LEFT JOIN '||V_ESQUEMA||'.act_reg_info_registral reg2 ON reg2.act_id = act.act_id AND reg2.reg_div_hor_inscrito = 0                                           -- DIVISIÓN HORIZONTAL NO INSCRITA
                  LEFT JOIN '||V_ESQUEMA||'.v_num_propietariosactivo npa ON npa.act_id = act.act_id                                            --PROINDIVISO (VARIOS PROPIETARIOS O 1 PROPIETARIO CON %PROP < 100)
                  LEFT JOIN '||V_ESQUEMA||'.vi_activos_con_cargas vcg ON vcg.act_id = act.act_id
                  LEFT JOIN '||V_ESQUEMA||'.act_ico_info_comercial ico ON ico.act_id = act.act_id
                  LEFT JOIN '||V_ESQUEMA||'.vi_estado_actual_infmed vei ON vei.ico_id = ico.ico_id                                                                                          --SIN_INFORME_APROBADO
            WHERE act.borrado = 0)';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD...Creada OK');

  	/*EXECUTE IMMEDIATE 'GRANT SELECT ON '||V_ESQUEMA||'.V_COND_DISPONIBILIDAD TO PFSREM';

	EXECUTE IMMEDIATE 'GRANT SELECT ON '||V_ESQUEMA||'.V_COND_DISPONIBILIDAD TO REM_QUERY';

	EXECUTE IMMEDIATE 'GRANT SELECT ON '||V_ESQUEMA||'.V_COND_DISPONIBILIDAD TO REMWS';*/

END;
/

EXIT;
