--/*
--##########################################
--## AUTOR=Miguel.Sanchez
--## FECHA_CREACION=20160304
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2032
--## PRODUCTO=NO
--##
--## Finalidad: Modificar el SP de carterización para insertar el gestor expediente judicial para los concursos
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

create or replace PROCEDURE "CONVIVE_F2_CARTERIZACION" AS
DECLARE

BEGIN

--  SOLO CONCURSOS
----Grupo - Supervisor del asunto (concursos) SUP
 
insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.des_despacho_externo des inner join #ESQUEMA#.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id 
        where usu.usu_username = 'bcaballero' and usd.borrado = 0 and des.des_despacho = 'Unidad de concursos') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'))
  and asu.asu_id in (select asuu.asu_id
                     from #ESQUEMA#.asu_asuntos asuu 
                     where asuu.DD_TAS_ID = 2
                    )  
  ) aux ;
----
insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.des_despacho_externo des inner join #ESQUEMA#.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id 
        where usu.usu_username = 'bcaballero' and usd.borrado = 0 and des.des_despacho = 'Unidad de concursos') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu
                    where asuu.DD_TAS_ID = 2) 
 ) aux ;
 
-- Grupo - Gestor concursos

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.des_despacho_externo des inner join #ESQUEMA#.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id 
        where usu.usu_username = 'bcaballero' and usd.borrado = 0 and des.des_despacho = 'Unidad de concursos') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GUCO' ), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GUCO'))
  and asu.asu_id in (select asuu.asu_id
                     from #ESQUEMA#.asu_asuntos asuu 
                     where asuu.DD_TAS_ID = 2
                    ) 
  ) aux ;
  
----

insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.des_despacho_externo des inner join #ESQUEMA#.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id 
        where usu.usu_username = 'bcaballero' and usd.borrado = 0 and des.des_despacho = 'Unidad de concursos') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GUCO'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GUCO'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu
                    where asuu.DD_TAS_ID = 2) 
 ) aux ;

-- Grupo - Gestor subasta concursal

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GSUBCO' and usd.borrado = 0) usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GSUBC' ), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GSUBC'))
  and asu.asu_id in (select asuu.asu_id
                     from #ESQUEMA#.asu_asuntos asuu 
                     where asuu.DD_TAS_ID = 2
                    ) 
  ) aux ;
  
----

insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GSUBCO' and usd.borrado = 0) usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GSUBC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GSUBC'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu
                    where asuu.DD_TAS_ID = 2) 
 ) aux ;

-- Grupo - supervisor subasta concursal

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.des_despacho_externo des inner join #ESQUEMA#.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id 
        where usu.usu_username = 'bcaballero' and usd.borrado = 0 and des.des_despacho = 'Unidad de concursos') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SSUBC' ), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SSUBC'))
  and asu.asu_id in (select asuu.asu_id
                     from #ESQUEMA#.asu_asuntos asuu 
                     where asuu.DD_TAS_ID = 2
                    ) 
  ) aux ;
  
----

insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.des_despacho_externo des inner join #ESQUEMA#.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id 
        where usu.usu_username = 'bcaballero' and usd.borrado = 0 and des.des_despacho = 'Unidad de concursos') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SSUBC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SSUBC'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu
                    where asuu.DD_TAS_ID = 2) 
 ) aux ;
 
-- Grupo - Dirección de concursos

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.des_despacho_externo des inner join #ESQUEMA#.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id 
        where usu.usu_username = 'bcaballero' and usd.borrado = 0 and des.des_despacho = 'Unidad de concursos') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRCON' ), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRCON'))
  and asu.asu_id in (select asuu.asu_id
                     from #ESQUEMA#.asu_asuntos asuu 
                     where asuu.DD_TAS_ID = 2
                    ) 
  ) aux ;
  
----

insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.des_despacho_externo des inner join #ESQUEMA#.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id 
        where usu.usu_username = 'bcaballero' and usd.borrado = 0 and des.des_despacho = 'Unidad de concursos') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRCON'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRCON'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu
                    where asuu.DD_TAS_ID = 2) 
 ) aux ;
 
 ----Grupo - Supervisor expediente judicial (concursos) SUP_PCO
 
INSERT INTO #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
SELECT 
    #ESQUEMA#.S_GAA_GESTOR_ADICIONAL_ASUNTO.NEXTVAL AS GAA_ID, 
    ASU.ASU_ID AS ASU_ID,
    (SELECT USD_ID 
        FROM #ESQUEMA#.DES_DESPACHO_EXTERNO DES 
        INNER JOIN #ESQUEMA#.USD_USUARIOS_DESPACHOS USD ON DES.DES_ID = USD.DES_ID 
        INNER JOIN #ESQUEMA_MASTER#.USU_USUARIOS USU ON USU.USU_ID = USD.USU_ID 
        WHERE UPPER(USU.USU_USERNAME) = 'GRUPO-SUPERVISOR EXPEDIENTES JUDICIALES'
        AND USD.BORRADO = 0 AND UPPER(DES.DES_DESPACHO) = 'SUPERVISOR EXPEDIENTES JUDICIALES') USD_ID,
    (SELECT DD_TGE_ID 
        FROM #ESQUEMA_MASTER#.DD_TGE_TIPO_GESTOR
        WHERE DD_TGE_CODIGO = 'SUP_PCO') AS DD_TGE_ID, 
    'CONVIVE_F2' AS USUARIOCREAR, 
    SYSDATE AS FECHACREAR

FROM #ESQUEMA#.ASU_ASUNTOS ASU
    INNER JOIN #ESQUEMA#.CNV_AUX_ALTA_PRC CNV ON ASU.ASU_ID_EXTERNO=CNV.CODIGO_PROCEDIMIENTO_NUSE 
WHERE NOT EXISTS (
    SELECT 1 
    FROM #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO GAA 
    WHERE GAA.ASU_ID = ASU.ASU_ID 
    AND GAA.DD_TGE_ID =
        (
        SELECT DD_TGE_ID 
        FROM #ESQUEMA_MASTER#.DD_TGE_TIPO_GESTOR 
        WHERE DD_TGE_CODIGO = 'SUP_PCO'
        )
    )
AND ASU.DD_TAS_ID=(SELECT DD_TAS_ID FROM #ESQUEMA_MASTER#.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_CODIGO LIKE '02' )
 ;
----
INSERT INTO #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO GAH 
(GAH.GAH_ID, GAH.GAH_ASU_ID, GAH.GAH_GESTOR_ID, GAH.GAH_FECHA_DESDE, GAH.GAH_TIPO_GESTOR_ID, USUARIOCREAR, FECHACREAR)
SELECT 
    #ESQUEMA#.S_GAH_GESTOR_ADIC_HISTORICO.NEXTVAL AS GAH_ID, 
    ASU.ASU_ID AS GAH_ASU_ID,
    (   
        SELECT USD_ID 
        FROM #ESQUEMA#.DES_DESPACHO_EXTERNO DES 
        INNER JOIN #ESQUEMA#.USD_USUARIOS_DESPACHOS USD ON DES.DES_ID = USD.DES_ID 
        INNER JOIN #ESQUEMA_MASTER#.USU_USUARIOS USU ON USU.USU_ID = USD.USU_ID 
        WHERE UPPER(USU.USU_USERNAME) = 'GRUPO-SUPERVISOR EXPEDIENTES JUDICIALES' 
        AND USD.BORRADO = 0 
        AND UPPER(DES.DES_DESPACHO) = 'SUPERVISOR EXPEDIENTES JUDICIALES'
    ) AS GAH_GESTOR_ID,
    SYSDATE AS GAH_FECHA_DESDE, 
    (  
        SELECT DD_TGE_ID 
        FROM #ESQUEMA_MASTER#.DD_TGE_TIPO_GESTOR 
        WHERE DD_TGE_CODIGO = 'SUP_PCO'
    ) AS GAH_TIPO_GESTOR_ID,
    'CONVIVE_F2'AS USUARIOCREAR,
    SYSDATE AS FECHACREAR
FROM #ESQUEMA#.ASU_ASUNTOS ASU 
INNER JOIN #ESQUEMA#.CNV_AUX_ALTA_PRC CNV ON ASU.ASU_ID_EXTERNO=CNV.CODIGO_PROCEDIMIENTO_NUSE 
WHERE NOT EXISTS (
    SELECT 1 
    FROM #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO GAA 
    WHERE GAA.GAH_ASU_ID = ASU.ASU_ID AND GAA.GAH_TIPO_GESTOR_ID =
    (SELECT DD_TGE_ID FROM #ESQUEMA_MASTER#.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = 'SUP_PCO')
    )
AND ASU.DD_TAS_ID=(SELECT DD_TAS_ID FROM #ESQUEMA_MASTER#.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_CODIGO LIKE '02' )
;

-- SOLO LITIGIOS

-- Grupo - Gestor de subasta litigios	GSUBLI

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GSUBLI' and usd.borrado = 0) usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GSUB'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GSUB'))
  and asu.asu_id in (select asuu.asu_id
                     from #ESQUEMA#.asu_asuntos asuu 
                     where asuu.DD_TAS_ID = 1
                    ) 
  ) aux ;
----
insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GSUBLI' and usd.borrado = 0) usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GSUB'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GSUB'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu 
                    where asuu.DD_TAS_ID = 1) 
 ) aux ;
 
----Grupo - Supervisor del asunto (litigios) SUP
 
insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GSUPLI' and usd.borrado = 0) usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'))
  and asu.asu_id in (select asuu.asu_id
                     from #ESQUEMA#.asu_asuntos asuu 
                     where asuu.DD_TAS_ID = 1
                    )  
  ) aux ;
----
insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GSUPLI' and usd.borrado = 0) usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu
                    where asuu.DD_TAS_ID = 1) 
 ) aux ;
 
-- Grupo - Gestor de litigios	GLIT
 
insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GLIT' and usd.borrado = 0) usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GULI'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GULI'))
  and asu.asu_id in (select asuu.asu_id
                     from #ESQUEMA#.asu_asuntos asuu 
                      where asuu.DD_TAS_ID = 1
                    ) 
  ) aux ;
----
insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GLIT' and usd.borrado = 0) usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GULI'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GULI'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu
                     where asuu.DD_TAS_ID = 1) 
 ) aux ; 
 
-- LITIGIOS y CONCURSOS 
--Grupo - Gestor soporte deuda	GSOPD
 
insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GSOPD' and usd.borrado = 0) usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GSDE'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GSDE'))
  and asu.asu_id in (select asuu.asu_id
                     from #ESQUEMA#.asu_asuntos asuu 
                    ) 
  ) aux ;
----
insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GSOPD' and usd.borrado = 0) usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GSDE'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GSDE'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu ) 
 ) aux ; 
 
-- Grupo - Gestor contabilidad	GCONT
 
insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GCONT' and usd.borrado = 0) usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'UCON'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'UCON'))
  and asu.asu_id in (select asuu.asu_id
                     from #ESQUEMA#.asu_asuntos asuu 
                    ) 
  ) aux ;
----
insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GCONT' and usd.borrado = 0) usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'UCON'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'UCON'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu ) 
 ) aux ;  
 
--Grupo - Gestor área Fiscal	GARFIS
 
insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GARFIS' and usd.borrado = 0) usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'UFIS'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'UFIS'))
  and asu.asu_id in (select asuu.asu_id
                     from #ESQUEMA#.asu_asuntos asuu 
                    ) 
  ) aux ;
----
insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GARFIS' and usd.borrado = 0) usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'UFIS'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'UFIS'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu ) 
 ) aux ;  

 
-- Grupo - Gestor admisión	GADMIN
 
insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GADMIN' and usd.borrado = 0) usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GAREO'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GAREO'))
  and asu.asu_id in (select asuu.asu_id
                     from #ESQUEMA#.asu_asuntos asuu 
                    ) 
  ) aux ;

----

insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GADMIN' and usd.borrado = 0) usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GAREO'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GAREO'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu ) 
 ) aux ;  
 
COMMIT;

EXCEPTION
     WHEN OTHERS THEN

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(SQLERRM);

          ROLLBACK;
          RAISE;

END CONVIVE_F2_CARTERIZACION;
/

EXIT;
