--/*
--##########################################
--## AUTOR=Marco MUnoz
--## FECHA_CREACION=20180808
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.6
--## INCIDENCIA_LINK=HREOS-4392
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  Rellenar el array
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
  
  TYPE T_VIC IS TABLE OF VARCHAR2(4000 CHAR);
  TYPE T_ARRAY_VIC IS TABLE OF T_VIC;
   
  V_ESQUEMA          VARCHAR2(25 CHAR):= 'REM01'; 	                           -- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M        VARCHAR2(25 CHAR):= 'REMMASTER'; 	                       -- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_TABLA            VARCHAR2(30 CHAR):= 'MIG2_COUNTS_INFORME_CAJA_NEGRA'; 
  TABLE_COUNT        NUMBER(3); 											   -- Vble. para validar la existencia de las Tablas.
  err_num            NUMBER; 												   -- Numero de errores
  err_msg            VARCHAR2(2048); 										   -- Mensaje de error
  V_MSQL             VARCHAR2(4000 CHAR);
  V_EXIST            NUMBER(10);

	V_VIC T_ARRAY_VIC := T_ARRAY_VIC(
  		
  		
  		--BLOQUE OFERTAS-EXPEDIENTES
  		T_VIC(01,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(02,'SELECT ''''BLOQUE OFERTAS-EXPEDIENTES'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(03,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(04,'SELECT ''''Estado de la oferta'''', ''''Estado del expediente | Tarea'''', NULL  FROM DUAL'),
        T_VIC(05,'SELECT ''''-----------------------------------------------------------------------------'''', ''''----------------------------------------'''', NULL  FROM DUAL'),
  		T_VIC(06,'select decode(estado_oferta,''''-'''',null,estado_oferta)                                                                         as estado_oferta, 
                         nvl(decode(estado_expediente,''''-'''',null,estado_expediente),''''null'''')||'''' | ''''||nvl(tarea,''''null'''')         as estado_exp_tarea,   
                         cantidad                                                                                                                   as cantidad
                       from (
                            select distinct eof.dd_eof_codigo||''''-''''||eof.dd_eof_descripcion as estado_oferta, 
                                            eec.dd_eec_codigo||''''-''''||eec.dd_eec_descripcion as estado_expediente, 
                                            tar.tar_descripcion                            as tarea, 
                                            count(*)                                       as cantidad
                            from      rem01.ofr_ofertas              ofr
                            left join rem01.eco_expediente_comercial eco on eco.ofr_id = ofr.ofr_id
                            left join rem01.DD_EOF_ESTADOS_OFERTA    eof on eof.dd_eof_id = ofr.dd_eof_id
                            left join rem01.DD_EEC_EST_EXP_COMERCIAL eec on eec.dd_eec_id = eco.dd_eec_id
                            left join rem01.act_tbj_trabajo          tbj on tbj.tbj_id = eco.tbj_id
                            left join rem01.act_tra_tramite          tra on tra.tbj_id = tbj.tbj_id
                            left join rem01.tac_tareas_activos       tac on tac.tra_id = tra.tra_id
                            left join rem01.tar_tareas_notificaciones tar on tar.tar_id = tac.tar_id
                            where ofr.usuariocrear = ''''#USUARIO_MIGRACION#'''' and (tar.usuariocrear = ''''#USUARIO_MIGRACION#'''' or tar.tar_id is null)
                            group by eof.dd_eof_codigo||''''-''''||eof.dd_eof_descripcion, eec.dd_eec_codigo||''''-''''||eec.dd_eec_descripcion, tar.tar_descripcion
                            order by 1,2,3
                )'
	    ), 
        T_VIC(07,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
  		T_VIC(08,'SELECT ''''CLIENTES COMERCIALES'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(09,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(10,'SELECT ''''Estado de la oferta'''', ''''Estado del expediente'''', NULL  FROM DUAL'),
        T_VIC(11,'SELECT ''''-----------------------------------------------------------------------------'''', ''''----------------------------------------'''', NULL  FROM DUAL'),
  		T_VIC(12,'select dd_eof_descripcion, dd_eec_descripcion, cuenta from (
						select dd_eof_descripcion, dd_eec_descripcion, cuenta, rownum as rn from (
							select eof.dd_eof_descripcion, eec.dd_eec_descripcion, count(*) as cuenta from rem01.ofr_ofertas ofr
							left join rem01.DD_EOF_ESTADOS_OFERTA eof on eof.dd_eof_id = ofr.dd_eof_id
							left join rem01.eco_expediente_comercial eco on eco.ofr_id = ofr.ofr_id
							left join rem01.DD_EEC_EST_EXP_COMERCIAL eec on eec.dd_eec_id = eco.dd_eec_id
							join rem01.CLC_CLIENTE_COMERCIAL clc on clc.clc_id = ofr.clc_id
							where ofr.usuariocrear = ''''#USUARIO_MIGRACION#''''
							group by (eof.dd_eof_descripcion, eec.dd_eec_descripcion)
							order by 1,2
						)
				  )'
	    ),
  		T_VIC(13,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
  		T_VIC(14,'SELECT ''''COMPRADORES'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(15,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(16,'SELECT ''''Estado de la oferta'''', ''''Estado del expediente'''', NULL  FROM DUAL'),
        T_VIC(17,'SELECT ''''-----------------------------------------------------------------------------'''', ''''----------------------------------------'''', NULL  FROM DUAL'),
  		T_VIC(18,'select dd_eof_descripcion, dd_eec_descripcion, cuenta from (     
                        select dd_eof_descripcion, dd_eec_descripcion, cuenta, rownum as rn from (
                            select eof.dd_eof_descripcion, eec.dd_eec_descripcion, count(*) as cuenta from rem01.eco_expediente_comercial eco
                            join rem01.ofr_ofertas ofr on ofr.ofr_id = eco.ofr_id
                            join rem01.CEX_COMPRADOR_EXPEDIENTE cex on cex.eco_id = eco.eco_id
                            join rem01.com_comprador com on com.com_id = cex.com_id
                            left join rem01.DD_EOF_ESTADOS_OFERTA eof on eof.dd_eof_id = ofr.dd_eof_id
                            left join rem01.DD_EEC_EST_EXP_COMERCIAL eec on eec.dd_eec_id = eco.dd_eec_id
                            where eco.usuariocrear = ''''#USUARIO_MIGRACION#'''' and com.usuariocrear = ''''#USUARIO_MIGRACION#''''
                            group by (eof.dd_eof_descripcion, eec.dd_eec_descripcion)
                            order by 1,2
                        )
                  )'
	    ),
	    --BLOQUE OFERTAS-ACTIVOS
        T_VIC(19,'SELECT '''' '''' as id1, ''''  '''', NULL  FROM DUAL'),
        T_VIC(20,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(21,'SELECT ''''BLOQUE OFERTAS-ACTIVOS'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(22,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
  		T_VIC(23,'SELECT ''''Número de relaciones Oferta/Activo'''', '''' '''', 
                                                                                count(*) from rem01.ofr_ofertas ofr
                                                                                join rem01.act_ofr ao on ao.ofr_id = ofr.ofr_id
                                                                                where ofr.usuariocrear = ''''#USUARIO_MIGRACION#''''                                        
        '),
        --BLOQUE GASTOS
        T_VIC(24,'SELECT '''' '''' as id1, ''''  '''', NULL  FROM DUAL'),
        T_VIC(25,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(26,'SELECT ''''BLOQUE GASTOS'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(27,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
  		T_VIC(28,'SELECT ''''Estado del gasto'''', ''''Estado autorización de Haya | Estado autorización del Propietario'''', NULL  FROM DUAL'),
        T_VIC(29,'SELECT ''''-----------------------------------------------------------------------------'''', ''''----------------------------------------'''', NULL  FROM DUAL'),
        T_VIC(30,'select dd_ega_descripcion, nvl(dd_eah_descripcion,''''null'''')||'''' | ''''||nvl(dd_eap_descripcion,''''null''''), cuenta from (
						select dd_ega_descripcion, dd_eah_descripcion, dd_eap_descripcion, cuenta, rownum as rn from (
							select ega.dd_ega_descripcion, eah.dd_eah_descripcion, eap.dd_eap_descripcion, count(*) as cuenta from rem01.GPV_GASTOS_PROVEEDOR gpv 
							join rem01.DD_EGA_ESTADOS_GASTO ega on ega.dd_ega_id = gpv.dd_ega_id
							left join rem01.gge_gastos_gestion gge on gge.gpv_id = gpv.gpv_id
							left join rem01.DD_EAH_ESTADOS_AUTORIZ_HAYA eah on eah.dd_eah_id = gge.dd_eah_id
							left join rem01.DD_EAP_ESTADOS_AUTORIZ_PROP eap on eap.dd_eap_id = gge.dd_eap_id
							where gpv.usuariocrear = ''''#USUARIO_MIGRACION#''''
							group by (ega.dd_ega_descripcion, eah.dd_eah_descripcion, eap.dd_eap_descripcion)
							order by 1,2,3
						)
					)'
	    ),
        --BLOQUE ACTIVOS OCUPADOS
        T_VIC(31,'SELECT '''' '''' as id1, ''''  '''', NULL  FROM DUAL'),
        T_VIC(32,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(33,'SELECT ''''BLOQUE ACTIVOS OCUPADOS'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(34,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
  		T_VIC(35,'SELECT ''''Título del activo'''', ''''Ocupación del activo'''', NULL  FROM DUAL'),
        T_VIC(36,'SELECT ''''-----------------------------------------------------------------------------'''', ''''----------------------------------------'''', NULL  FROM DUAL'),
        T_VIC(37,'select decode(SPS_CON_TITULO, 1, ''''El activo posee título'''', 0, ''''El activo no posee título'''', ''''No tenemos información de si el activo posee título o no''''), 
                           decode(SPS_OCUPADO,  1, ''''El activo está ocupado'''', 0, ''''El activo no está ocupado'''', ''''No sabemos si el activo está ocupado o no''''),  
                           cuenta from (
                        select SPS_CON_TITULO, SPS_OCUPADO, cuenta, rownum as rn from (
                                select sps.SPS_CON_TITULO, sps.SPS_OCUPADO, count(*) as cuenta from rem01.act_activo act
                                left join rem01.ACT_SPS_SIT_POSESORIA sps on sps.act_id = act.act_id
                                where act.usuariocrear = ''''#USUARIO_MIGRACION#''''
                                group by (sps.sps_con_titulo, sps.sps_ocupado)
                        )
                  )'
	    ),       
  		--BLOQUE ACTIVOS CON FECHA DE ADJUDICACION
  		T_VIC(38,'SELECT '''' '''' as id1, ''''  '''', NULL  FROM DUAL'),
        T_VIC(39,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(40,'SELECT ''''BLOQUE FECHA DE ADJUDICACION'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(41,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
  		T_VIC(42,'SELECT ''''Número de Activos con la fecha de adjudicación informada'''', '''' '''', 
                                                                                 count(*) from rem01.act_activo act
                                                                                 left join rem01.act_ajd_adjjudicial ajd on ajd.act_id = act.act_id
                                                                                 where ajd.AJD_FECHA_ADJUDICACION is not null and act.usuariocrear = ''''#USUARIO_MIGRACION#''''
                                       
        '),
  		--BLOQUE ACTIVOS CON FECHA DE TOMA DE POSESION
  		T_VIC(43,'SELECT '''' '''' as id1, ''''  '''', NULL  FROM DUAL'),
        T_VIC(44,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(45,'SELECT ''''BLOQUE FECHA DE TOMA DE POSESION'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(46,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
  		T_VIC(47,'SELECT ''''Número de Activos con la fecha de toma de posesión informada'''', '''' '''', 
                                                                                    count(*) from rem01.act_activo act
                                                                                    left join rem01.ACT_SPS_SIT_POSESORIA sps on sps.act_id = act.act_id
                                                                                    where act.usuariocrear = ''''#USUARIO_MIGRACION#'''' and sps.sps_fecha_toma_posesion is not null

                                       
        '),
        --BLOQUE GESTORES
        T_VIC(48,'SELECT '''' '''' as id1, ''''  '''', NULL  FROM DUAL'),
        T_VIC(49,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(50,'SELECT ''''BLOQUE GESTORES'''', '''' '''', NULL  FROM DUAL'),
        T_VIC(51,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
  		T_VIC(52,'SELECT ''''GESTORES DE LOS ACTIVOS'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(53,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(54,'SELECT ''''Tipo de gestor'''', '''' '''', NULL  FROM DUAL'),
        T_VIC(55,'SELECT ''''-----------------------------------------------------------------------------'''', ''''----------------------------------------'''', NULL  FROM DUAL'),
        T_VIC(56,'select DD_TGE_DESCRIPCION, '''' '''', cuenta from ( 
                        select DD_TGE_DESCRIPCION, '''' '''', cuenta, rownum as rn from ( 
                                select tge.DD_TGE_DESCRIPCION, count(*) as cuenta from rem01.GAC_GESTOR_ADD_ACTIVO gac 
                                join rem01.gee_gestor_entidad gee on gee.gee_id = gac.gee_id
                                join remmaster.dd_tge_tipo_gestor tge on tge.dd_tge_id = gee.dd_tge_id
                                where gee.usuariocrear = ''''#USUARIO_MIGRACION#''''
                                group by (tge.DD_TGE_DESCRIPCION)
                                order by 1
                        )
                    )'
	    ),
        T_VIC(57,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
  		T_VIC(58,'SELECT ''''GESTORES DE LOS EXPEDIENTES COMERCIALES'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(59,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(60,'SELECT ''''Tipo de gestor'''', '''' '''', NULL  FROM DUAL'),
        T_VIC(61,'SELECT ''''-----------------------------------------------------------------------------'''', ''''----------------------------------------'''', NULL  FROM DUAL'),
        T_VIC(62,'select DD_TGE_DESCRIPCION, '''' '''', cuenta from ( 
                        select DD_TGE_DESCRIPCION, '''' '''', cuenta, rownum as rn from ( 
                                select tge.DD_TGE_DESCRIPCION, count(*) as cuenta from rem01.GCO_GESTOR_ADD_ECO gco 
                                join rem01.gee_gestor_entidad gee on gee.gee_id = gco.gee_id
                                join remmaster.dd_tge_tipo_gestor tge on tge.dd_tge_id = gee.dd_tge_id
                                where gee.usuariocrear = ''''#USUARIO_MIGRACION#''''
                                group by (tge.DD_TGE_DESCRIPCION)
                                order by 1
                        )
                    )'
	    ),
        --BLOQUE FECHAS DE INSCRIPCION
        T_VIC(63,'SELECT '''' '''' as id1, ''''  '''', NULL  FROM DUAL'),
        T_VIC(64,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(65,'SELECT ''''BLOQUE FECHAS DE INSCRIPCION'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(66,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
  		T_VIC(67,'SELECT ''''Indicador de si el activo tiene fecha de inscripción'''', ''''Estado del título del activo'''', NULL  FROM DUAL'),
        T_VIC(68,'SELECT ''''-----------------------------------------------------------------------------'''', ''''----------------------------------------'''', NULL  FROM DUAL'),
        T_VIC(69,'select fecha_inscripcion, dd_eti_descripcion, cuenta from (     
                                select fecha_inscripcion, dd_eti_descripcion, cuenta, rownum as rn from (
                                        select fecha_inscripcion, dd_eti_descripcion, count (*) as cuenta from (
                                        select 
                                        CASE
                                        WHEN (dr.BIE_DREG_FECHA_INSCRIPCION is not null) THEN ''''CON FECHA''''
                                        WHEN (dr.BIE_DREG_FECHA_INSCRIPCION is null) THEN ''''SIN FECHA''''
                                        ELSE NULL
                                        END as fecha_inscripcion
                                        , eti.dd_eti_descripcion from act_activo act
                                        join rem01.bie_datos_registrales dr on dr.bie_id = act.bie_id
                                        join rem01.act_tit_titulo tit on tit.act_id = act.act_id
                                        join rem01.DD_ETI_ESTADO_TITULO eti on eti.dd_eti_id = tit.dd_eti_id
                                        where dr.usuariocrear = ''''#USUARIO_MIGRACION#'''')
                                        group by (fecha_inscripcion, dd_eti_descripcion)
                                        order by 1,2
                                 )
                 )'
	    ),
        T_VIC(70,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(71,'SELECT ''''CON SITUACIÓN COMERCIAL'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(72,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
  		T_VIC(73,'SELECT ''''Indicador de si el activo tiene fecha de inscripción'''', ''''Estado del título del activo | Situación comercial del activo'''', NULL  FROM DUAL'),
        T_VIC(74,'SELECT ''''-----------------------------------------------------------------------------'''', ''''----------------------------------------'''', NULL  FROM DUAL'),
        T_VIC(75,'select fecha_inscripcion, id2, cuenta from (
                        select fecha_inscripcion, nvl(dd_eti_descripcion,''''null'''')||'''' | ''''||nvl(dd_scm_descripcion,''''null'''') as id2, cuenta, rownum as rn from (
                            select fecha_inscripcion, dd_eti_descripcion, dd_scm_descripcion, count (*) as cuenta from (
                            select 
                            CASE
                            WHEN (dr.BIE_DREG_FECHA_INSCRIPCION is not null) THEN ''''CON FECHA''''
                            WHEN (dr.BIE_DREG_FECHA_INSCRIPCION is null) THEN ''''SIN FECHA''''
                            ELSE NULL
                            END as fecha_inscripcion
                            , eti.dd_eti_descripcion, scm.dd_scm_descripcion from act_activo act
                            join rem01.DD_SCM_SITUACION_COMERCIAL scm on scm.dd_scm_id = act.dd_scm_id
                            join rem01.bie_datos_registrales dr on dr.bie_id = act.bie_id
                            join rem01.act_tit_titulo tit on tit.act_id = act.act_id
                            join rem01.DD_ETI_ESTADO_TITULO eti on eti.dd_eti_id = tit.dd_eti_id
                            where dr.usuariocrear = ''''#USUARIO_MIGRACION#'''')
                            group by (fecha_inscripcion, dd_eti_descripcion, dd_scm_descripcion)
                            order by 1,2,3
                        )
                  )'
	    ),
        T_VIC(76,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
        T_VIC(77,'SELECT ''''BLOQUE OTROS'''', '''' '''', NULL  FROM DUAL'),
  		T_VIC(78,'SELECT ''''*****************************************************************************'''', ''''****************************************'''', NULL  FROM DUAL'),
  		T_VIC(79,'SELECT ''''Total de activos migrados'''', '''' '''', COUNT(1) FROM ACT_ACTIVO WHERE USUARIOCREAR = ''''#USUARIO_MIGRACION#''''  ') ,                                     
  		T_VIC(80,'SELECT ''''Nª activos adjudicacion:'''', '''' '''', COUNT(1) FROM ACT_ACTIVO ACT WHERE ACT.BIE_ID IN(SELECT BIE.BIE_ID FROM BIE_ADJ_ADJUDICACION BIE WHERE ACT.BIE_ID = BIE.BIE_ID) AND USUARIOCREAR = ''''#USUARIO_MIGRACION#''''  '),                                     
 		T_VIC(81,'SELECT ''''Nª activos con cargas:'''', '''' '''', COUNT(1) FROM ACT_ACTIVO ACT WHERE ACT.ACT_ID IN (SELECT CRG.ACT_ID FROM ACT_CRG_CARGAS CRG WHERE ACT.ACT_ID = CRG.ACT_ID) AND USUARIOCREAR =  ''''#USUARIO_MIGRACION#''''  ') ,                                    
 		T_VIC(82,'SELECT ''''Nª trabajos:'''', '''' '''',  COUNT(1) FROM ACT_TBJ_TRABAJO WHERE USUARIOCREAR = ''''#USUARIO_MIGRACION#''''  '),                                     
		T_VIC(83,'SELECT ''''Nª tasaciones:'''', '''' '''',  COUNT(1) FROM ACT_TAS_TASACION WHERE USUARIOCREAR = ''''#USUARIO_MIGRACION#''''  ') ,                                  
		T_VIC(84,'SELECT ''''Nº Agrupaciones comerciales con municipio:'''', '''' '''',  COUNT(1) FROM ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA, ACT_ACTIVO ACT, BIE_LOCALIZACION BIE, DD_TAG_TIPO_AGRUPACION TAG 
                  WHERE AGR.DD_TAG_ID = TAG.DD_TAG_ID AND AGR.AGR_ID = AGA.AGR_ID AND AGA.ACT_ID = ACT.ACT_ID AND ACT.BIE_ID = BIE.BIE_ID AND BIE.BIE_LOC_MUNICIPIO IS NOT NULL AND DD_TAG_CODIGO = 14 AND AGR.USUARIOCREAR =  ''''#USUARIO_MIGRACION#''''  '),                                     
		T_VIC(85,'SELECT ''''Nº Agrupaciones comerciales con provincia:'''', '''' '''',  COUNT(1) FROM ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA, ACT_ACTIVO ACT, BIE_LOCALIZACION BIE, DD_TAG_TIPO_AGRUPACION TAG 
                  WHERE AGR.DD_TAG_ID = TAG.DD_TAG_ID AND AGR.AGR_ID = AGA.AGR_ID AND AGA.ACT_ID = ACT.ACT_ID AND ACT.BIE_ID = BIE.BIE_ID AND BIE.BIE_LOC_PROVINCIA IS NOT NULL AND DD_TAG_CODIGO = 14 AND AGR.USUARIOCREAR = ''''#USUARIO_MIGRACION#''''  ')  ,                                
		T_VIC(86,'SELECT ''''Nª Agrupaciones comerciales:'''', '''' '''',  COUNT(1) FROM ACT_AGR_AGRUPACION AGR, DD_TAG_TIPO_AGRUPACION TAG WHERE AGR.DD_TAG_ID = TAG.DD_TAG_ID AND DD_TAG_CODIGO = 14 AND AGR.USUARIOCREAR =  ''''#USUARIO_MIGRACION#''''  '),                                   
		T_VIC(87,'SELECT ''''Bolsa de activos por tipos de cargas:'''', TCA.DD_TCA_DESCRIPCION AS DESCRIPCION,  COUNT(1) AS NUMERO FROM ACT_CRG_CARGAS CRG, DD_TCA_TIPO_CARGA TCA WHERE CRG.DD_TCA_ID = TCA.DD_TCA_ID AND CRG.USUARIOCREAR =''''#USUARIO_MIGRACION#'''' GROUP BY CRG.DD_TCA_ID, TCA.DD_TCA_DESCRIPCION') ,                                  
		T_VIC(88,'SELECT ''''Bolsa de activos por cada estado de trabajo:'''', EST.DD_EST_DESCRIPCION AS DESCRIPCION, COUNT(1) AS NUMERO FROM ACT_TBJ_TRABAJO TBJ, DD_EST_ESTADO_TRABAJO EST WHERE TBJ.DD_EST_ID = EST.DD_EST_ID AND TBJ.USUARIOCREAR =''''#USUARIO_MIGRACION#'''' GROUP BY TBJ.DD_EST_ID, EST.DD_EST_DESCRIPCION'),                                   
		T_VIC(89,'SELECT ''''Nº inmuebles Publicados'''', '''' '''',  COUNT(1) FROM ACT_ACTIVO ACT, DD_EPU_ESTADO_PUBLICACION EPU WHERE ACT.DD_EPU_ID = EPU.DD_EPU_ID AND ACT.USUARIOCREAR = ''''#USUARIO_MIGRACION#'''' AND EPU.DD_EPU_CODIGO = 01 '),                                   
		T_VIC(90,'SELECT ''''Nº inmuebles Publicados Forzados'''', '''' '''', COUNT(1) FROM ACT_ACTIVO ACT, DD_EPU_ESTADO_PUBLICACION EPU WHERE ACT.DD_EPU_ID = EPU.DD_EPU_ID AND ACT.USUARIOCREAR = ''''#USUARIO_MIGRACION#'''' AND EPU.DD_EPU_CODIGO = 02 '),                                   
		T_VIC(91,'SELECT ''''Nª Inmuebles okupados:'''', '''' '''',  COUNT(1) FROM ACT_ACTIVO ACT, ACT_SPS_SIT_POSESORIA SPS WHERE ACT.USUARIOCREAR = ''''#USUARIO_MIGRACION#'''' AND SPS.SPS_OCUPADO = 1 AND ACT.ACT_ID = SPS.ACT_ID '),                                   
		T_VIC(92,'SELECT ''''VPO'''', decode(ACT_VPO, 1, ''''El activo es VPO'''', 0, ''''El activo no es VPO'''', ''''No tenemos información de si el activo es VPO''''),  COUNT(1) AS NUMERO FROM ACT_ACTIVO ACT WHERE ACT.USUARIOCREAR =''''#USUARIO_MIGRACION#'''' GROUP BY ACT.ACT_VPO '),                                   
		T_VIC(93,'SELECT ''''Numero Retail Singular:'''', TCR.DD_TCR_DESCRIPCION AS DESCRIPCION, COUNT(1) AS NUMERO FROM ACT_ACTIVO ACT, DD_TCR_TIPO_COMERCIALIZAR TCR WHERE ACT.DD_TCR_ID = TCR.DD_TCR_ID AND ACT.USUARIOCREAR =''''#USUARIO_MIGRACION#'''' GROUP BY ACT.DD_TCR_ID, TCR.DD_TCR_DESCRIPCION '),                                   
		T_VIC(94,'SELECT ''''Nª Activos Notarial'''', '''' '''',  COUNT(1) FROM ACT_ACTIVO ACT, DD_STA_SUBTIPO_TITULO_ACTIVO STA WHERE ACT.USUARIOCREAR =''''#USUARIO_MIGRACION#'''' AND ACT.DD_STA_ID = STA.DD_STA_ID AND (STA.DD_STA_CODIGO = 03 OR STA.DD_STA_CODIGO = 04 OR STA.DD_STA_CODIGO = 05 OR STA.DD_STA_CODIGO = 06) '),                                   
		T_VIC(95,'SELECT ''''Nº Activos con precio venta web informado:'''', '''' '''',  COUNT(1) FROM ACT_ACTIVO ACT, ACT_VAL_VALORACIONES VAL, DD_TPC_TIPO_PRECIO TPC WHERE ACT.ACT_ID = VAL.ACT_ID AND TPC.DD_TPC_ID = VAL.DD_TPC_ID AND ACT.USUARIOCREAR = ''''#USUARIO_MIGRACION#'''' AND TPC.DD_TPC_CODIGO = 02 AND VAL.VAL_IMPORTE IS NOT NULL '),                                   
		T_VIC(96,'SELECT ''''Nª Agrupaciones con Gestor:'''', '''' '''',  COUNT(1) FROM ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA, ACT_ACTIVO ACT WHERE AGR.AGR_ID = AGA.AGR_ID AND AGA.ACT_ID = ACT.ACT_ID AND ACT.ACT_ID 
                             IN(SELECT GAC.ACT_ID FROM GAC_GESTOR_ADD_ACTIVO GAC WHERE ACT.ACT_ID = GAC.ACT_ID) AND AGR.USUARIOCREAR = ''''#USUARIO_MIGRACION#'''' '),                                   
		T_VIC(97,'SELECT ''''Relacion activos con llaves:'''', '''' '''', COUNT(1) FROM ACT_ACTIVO ACT WHERE ACT.ACT_ID IN (SELECT LLV.ACT_ID FROM ACT_LLV_LLAVE LLV WHERE ACT.ACT_ID = LLV.ACT_ID) AND ACT.USUARIOCREAR =  ''''#USUARIO_MIGRACION#''''  '),                                   
		T_VIC(98,'SELECT ''''Nº de referencias catrastrales:'''', '''' '''',COUNT(1) FROM ACT_ACTIVO ACT, ACT_CAT_CATASTRO CAT WHERE ACT.ACT_ID = CAT.ACT_ID AND CAT.CAT_REF_CATASTRAL IS NOT NULL AND ACT.USUARIOCREAR = ''''#USUARIO_MIGRACION#''''   ')                                   

  		
	);
	V_TMP_VIC T_VIC;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO TABLE_COUNT;

    IF TABLE_COUNT = 1 THEN
    	EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA;
        FOR I IN V_VIC.FIRST .. V_VIC.LAST
            LOOP
                V_TMP_VIC := V_VIC(I);
                             
	              DBMS_OUTPUT.PUT_LINE('Insertando el indicador: '''||V_TMP_VIC(1)||''' '''||V_TMP_VIC(2)||''' ');
	              V_MSQL := '
	              INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
	                (ID,CAJA_NEGRA_INDICADOR, BORRADO)
	              VALUES 
	                ('||V_TMP_VIC(1)||','''||V_TMP_VIC(2)||''',0)';
	              EXECUTE IMMEDIATE V_MSQL;

            END LOOP;
        END IF;

        V_TMP_VIC := NULL;

        COMMIT;
        
        DBMS_OUTPUT.PUT_LINE('[FIN] Indicadores insertados.');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE;

END;
/
EXIT
