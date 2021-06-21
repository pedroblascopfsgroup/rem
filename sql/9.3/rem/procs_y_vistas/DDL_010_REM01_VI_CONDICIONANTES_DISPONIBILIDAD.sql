--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210607
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9845
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
--##    	0.14 HREOS-5003 - Añadimos Obra nueva (Vandalizado) a VANDALIZADO
--##		0.15 HREOS-5562 - Ocultación Automática, motivo "Revisión publicación", comentar la linea "OR DECODE(VEI.DD_AIC_CODIGO ,''02'' ,0 , 1) = 1"
--##		0.16 REMVIP-3503 - Correcciones cálculo ocupado_sin_titulo y ocupado_con_titulo (nueva columna DD_TPA_ID)
--##		0.17 REMVIP-4233 - Se corrige el join con la ACT_ABA ya que hay activos que no aparecen en esta.
--##        0.18 David Gonzalez - HREOS-6184 - Ajustes joins
--##        0.19 Adrián Molina - REMVIP-4259 - Se añade la columna del combo otros
--##        0.20 GUILLEM REY - REMVIP-4606 - Discleimer "Ocupado con título" para Activos Matrices
--##        0.21 Remus Ovidiu - REMVIP-5203 - Quitamos activos Bankia del calculo de posesion por fecha de posesion, ya que estos se calculan por situacion juridica
--##        0.22 Juan Bautista Alfonso - - REMVIP-7935 - Modificado fecha posesion para que cargue de la vista V_FECHA_POSESION_ACTIVO
--#         0.23 Sergio Gomez - - HREOS-13460 - Ajustes joins
--#         0.24 Daniel Gallego - - HREOS-13790 - Sustitución de obtención de campos ES_CONDICIONADO y SIN_INFORME_APROBADO_REM para que no usen la tabla V_COND_DISPONIBILIDAD
--#	        0.24 Remus OVidiu - REMVIP-9765 - Añadido LEFT JOIN con la vista V_FECHA_POSESION_ACTIVO para el calculo correcto de la fecha de posesion
--##		0.25 Juan Bautista Alfonso - REMVIP-9845 - Añadido LEFT JOIN con V_SIN_INFORME_APROBADO_REM para obtener el campo SIN_INFROME_APROBADO_REM
--##		0.26 Juan Bautista Alfonso - REMVIP-9845 - Sustitución de obtención de campos ES_CONDICIONADO y SIN_INFORME_APROBADO_REM para que no usen la tabla V_COND_DISPONIBILIDAD
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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEM_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(32000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_COND_DISPONIBILIDAD' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_COND_DISPONIBILIDAD';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD...');
  V_MSQL := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.v_cond_disponibilidad(act_id,
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
														  combo_otro,
                                                          sin_informe_aprobado,                                                       
                                                          revision,
                                                          procedimiento_judicial,
                                                          con_cargas,
							                              sin_acceso,
                                                          ocupado_sintitulo,
                                                          estado_portal_externo,
                                                      
                                                          est_disp_com_codigo,
                                                          borrado
                                                         )
AS
   SELECT act_id, sin_toma_posesion_inicial, ocupado_contitulo, pendiente_inscripcion, proindiviso, tapiado, obranueva_sindeclarar, obranueva_enconstruccion, divhorizontal_noinscrita, ruina, vandalizado, otro, combo_otro,
          sin_informe_aprobado, revision, procedimiento_judicial, con_cargas, sin_acceso, ocupado_sintitulo, estado_portal_externo,
          est_disp_com_codigo2,borrado

     FROM (SELECT act.act_id,
				CASE WHEN (sps1.dd_sij_id is not null and sij.DD_SIJ_INDICA_POSESION = 0) THEN 1
                ELSE
                    CASE WHEN (FPOS.FECHA_POSESION IS NULL AND aba2.dd_cla_id = 2 and act.dd_cra_id <> 21) THEN 1
                    ELSE 0
				END
                END AS sin_toma_posesion_inicial,          
                CASE WHEN (sps1.sps_ocupado = 1 AND TPA.DD_TPA_CODIGO = ''01'' OR ua.act_id is not null) THEN 1 ELSE 0 END AS ocupado_contitulo,
                NVL2 (tit.act_id, 0, 1) AS pendiente_inscripcion,
                NVL2 (npa.act_id, 1, 0) AS proindiviso,
                CASE WHEN sps1.sps_acc_tapiado = 1 THEN 1 ELSE 0 END AS tapiado,
                NVL2 (eon.dd_eon_id, 1, 0) AS obranueva_sindeclarar,
                CASE WHEN (eac1.dd_eac_codigo = ''02''  OR   eac1.dd_eac_codigo = ''06'') THEN 1 ELSE 0 END as obranueva_enconstruccion,
                NVL2 (reg2.reg_id, 1, 0) AS divhorizontal_noinscrita,
                CASE WHEN eac1.dd_eac_codigo = ''05'' THEN 1 ELSE 0 END as ruina,
				CASE WHEN (eac1.dd_eac_codigo = ''08''  OR   eac1.dd_eac_codigo = ''07'') THEN 1 ELSE 0 END as VANDALIZADO,
                sps1.sps_otro AS otro,
				sps1.sps_combo_otro AS combo_otro,
				CASE WHEN (cra.dd_cra_codigo = ''01'' OR cra.dd_cra_codigo = ''02'' OR cra.dd_cra_codigo = ''08'')
                    THEN DECODE (vei.dd_aic_codigo, ''02'', 0, 1)
                    ELSE 0
				END AS sin_informe_aprobado,
                0 AS revision,                                                                                      --NO EXISTE EN REM
				0 AS procedimiento_judicial,                                                          --NO EXISTE EN REM
				NVL2 (vcg.con_cargas, vcg.con_cargas, 0) AS con_cargas,
                DECODE (ico.ico_posible_hacer_inf, 1, 0, 0, 1, 0) AS sin_acceso,
                CASE WHEN (sps1.sps_ocupado = 1 AND (TPA.DD_TPA_CODIGO = ''02'' OR TPA.DD_TPA_CODIGO = ''03'')) THEN 1 ELSE 0 END AS ocupado_sintitulo,
                CASE WHEN (sps1.sps_estado_portal_externo = 1) THEN 1 ELSE 0 END AS estado_portal_externo,  -- ESTADO PUBLICACION PORTALES EXTERNOS
                CASE WHEN ( (FPOS.FECHA_POSESION IS NULL AND aba2.dd_cla_id = 2)               -- SIN TOMA POSESION INICIAL
                           OR eac1.dd_eac_codigo=''05''                                                   -- RUINA
                           OR NVL2 (tit.act_id, 0, 1) = 1
                           OR NVL2 (eon.dd_eon_id, 1, 0) = 1
                           OR NVL2 (npa.act_id, 1, 0) = 1
                           OR (eac1.dd_eac_codigo = ''02''  OR   eac1.dd_eac_codigo = ''06'' OR eac1.dd_eac_codigo = ''07'')               -- OBRA NUEVA EN CONSTRUCCIÓN/VANDALIZADO
                           OR (sps1.sps_ocupado = 1 AND TPA.DD_TPA_CODIGO = ''01'')                        -- OCUPADO CON TITULO
                           OR sps1.sps_acc_tapiado = 1                                                  -- TAPIADO
                           OR (sps1.sps_ocupado = 1 AND (TPA.DD_TPA_CODIGO = ''02'' OR TPA.DD_TPA_CODIGO = ''03''))                        -- OCUPADO SIN TITULO
                           OR NVL2 (reg2.reg_id, 1, 0) = 1
                           OR NVL2(sps1.sps_otro,1,0) = 1                                               -- OTROS MOTIVOS
                          )
						   OR NVL2 (vcg.con_cargas, vcg.con_cargas, 0) = 1
					THEN ''01''
                    ELSE ''02''
                  END AS est_disp_com_codigo1,
                  vact.est_disp_com_codigo as est_disp_com_codigo2,
                  0 AS borrado


             FROM REM01.act_activo act LEFT JOIN REM01.act_aba_activo_bancario aba2 ON aba2.act_id = act.act_id

				  LEFT JOIN REM01.DD_CRA_CARTERA cra ON cra.dd_cra_id = act.dd_cra_id
				  LEFT JOIN REM01.dd_eac_estado_activo eac1 ON eac1.dd_eac_id = act.dd_eac_id
                  		  LEFT JOIN REM01.act_sps_sit_posesoria sps1 ON sps1.act_id = act.act_id
				  LEFT JOIN REM01.DD_TPA_TIPO_TITULO_ACT TPA ON TPA.DD_TPA_ID = SPS1.DD_TPA_ID
				  LEFT JOIN REM01.DD_SIJ_SITUACION_JURIDICA sij on  sij.dd_sij_id =sps1.dd_sij_id
				  LEFT JOIN (select  aga.act_id
                      from REM01.act_aga_agrupacion_activo aga
                      where AGA.AGA_PRINCIPAL = 1 AND EXISTS
                       (
                         select aga2.agr_id from REM01.ACT_AGA_AGRUPACION_ACTIVO aga2
                         inner join REM01.ACT_SPS_SIT_POSESORIA sps on sps.act_id = aga2.act_id
                         inner join REM01.ACT_AGR_AGRUPACION agr on aga2.agr_id = agr.agr_id
                         inner join REM01.DD_TAG_TIPO_AGRUPACION tag1 on tag1.dd_tag_id = agr.dd_tag_id
                         where TAG1.DD_TAG_CODIGO = ''16'' and SPS.DD_TPA_ID = 1 AND aga.AGA_ID = aga2.AGA_ID
                        )) ua on ua.act_id = act.act_id
				  LEFT JOIN
                  (SELECT act_tit.act_id
                     FROM REM01.act_reg_info_registral act_reg
                     LEFT JOIN REM01.act_aba_activo_bancario aba ON aba.act_id = act_reg.act_id
                     JOIN REM01.ACT_TIT_TITULO act_tit ON act_tit.act_id = act_reg.act_id
                     JOIN REM01.BIE_DATOS_REGISTRALES BDR ON BDR.BIE_DREG_ID = act_REG.BIE_DREG_ID
                    WHERE aba.dd_cla_id = 1 OR act_tit.TIT_FECHA_INSC_REG IS NOT NULL) tit ON tit.act_id = act.act_id                                                            -- PENDIENTE DE INSCRIPCIÓN
                  LEFT JOIN REM01.act_reg_info_registral reg1 ON reg1.act_id = act.act_id
                  LEFT JOIN REM01.dd_eon_estado_obra_nueva eon ON eon.dd_eon_id = reg1.dd_eon_id AND eon.dd_eon_codigo = ''02''                                              -- OBRA NUEVA SIN DECLARAR
                  LEFT JOIN REM01.act_reg_info_registral reg2 ON reg2.act_id = act.act_id AND reg2.reg_div_hor_inscrito = 0                                           -- DIVISIÓN HORIZONTAL NO INSCRITA
                  LEFT JOIN REM01.v_num_propietariosactivo npa ON npa.act_id = act.act_id                                            --PROINDIVISO (VARIOS PROPIETARIOS O 1 PROPIETARIO CON %PROP < 100)
                  LEFT JOIN REM01.vi_activos_con_cargas vcg ON vcg.act_id = act.act_id
                  LEFT JOIN REM01.act_ico_info_comercial ico ON ico.act_id = act.act_id
                  LEFT JOIN REM01.vi_estado_actual_infmed vei ON vei.ico_id = ico.ico_id                                                                                          --SIN_INFORME_APROBADO
            	  LEFT JOIN REM01.V_ACT_ESTADO_DISP vact on vact.act_id = act.act_id 
            	  LEFT JOIN REM01.V_FECHA_POSESION_ACTIVO FPOS ON FPOS.ACT_ID = ACT.ACT_ID
            WHERE act.borrado = 0)
          ';

  EXECUTE IMMEDIATE V_MSQL;
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD...Creada OK');

  	EXECUTE IMMEDIATE 'GRANT SELECT ON '||V_ESQUEMA||'.V_COND_DISPONIBILIDAD TO PFSREM';

	EXECUTE IMMEDIATE 'GRANT SELECT ON '||V_ESQUEMA||'.V_COND_DISPONIBILIDAD TO REM_QUERY';

--	EXECUTE IMMEDIATE 'GRANT SELECT ON '||V_ESQUEMA||'.V_COND_DISPONIBILIDAD TO REMWS';


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

