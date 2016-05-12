--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=201600512
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1395
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Nuevo algoritmo de turnado de procuradores. 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE asignacion_turnado_procu (
   p_prc_id       #ESQUEMA#.prc_procedimientos.prc_id%TYPE,
   p_username     #ESQUEMA_MASTER#.usu_usuarios.usu_username%TYPE,
   p_tge_codigo   #ESQUEMA_MASTER#.dd_tge_tipo_gestor.dd_tge_codigo%TYPE := 'GESPROC'
)
AUTHID CURRENT_USER IS

CURSOR crs_asu_id
   IS
      SELECT prc.asu_id
      
      FROM #ESQUEMA#.prc_procedimientos prc
      WHERE prc.prc_id = p_prc_id;

CURSOR crs_importe_prc
   IS
      SELECT prc.prc_saldo_recuperacion
      FROM #ESQUEMA#.prc_procedimientos prc
      WHERE prc.prc_id = p_prc_id;
      
CURSOR crs_datos_usu_pfs
   IS
      SELECT usu.usu_id
        FROM #ESQUEMA_MASTER#.usu_usuarios usu
       WHERE usu.usu_username = 'PFS';--condicion para recuperar el usuario de pfs

CURSOR crs_datos_usu_aba
   IS
      SELECT usu.usu_id
        FROM #ESQUEMA_MASTER#.usu_usuarios usu
       WHERE usu.usu_username = 'ABA';--condicion para recuperar el usuario de aba

CURSOR crs_datos_usu_mc
   IS
      SELECT usu.usu_id
        FROM #ESQUEMA_MASTER#.usu_usuarios usu
       WHERE usu.usu_username = 'MC';--condicion para recuperar el usuario de mc

CURSOR crs_usd_id (p_usu_id #ESQUEMA_MASTER#.usu_usuarios.usu_id%TYPE)
   IS
      SELECT usd.usd_id
        FROM #ESQUEMA#.usd_usuarios_despachos usd
       WHERE usd.usu_id = p_usu_id;

CURSOR crs_des_id (p_usd_id #ESQUEMA#.usd_usuarios_despachos.usd_id%TYPE)
   IS
      SELECT usd.des_id
        FROM #ESQUEMA#.usd_usuarios_despachos usd
       WHERE usd.usd_id = p_usd_id;

CURSOR crs_gestores_activos (p_tge_codigo #ESQUEMA_MASTER#.dd_tge_tipo_gestor.dd_tge_codigo%TYPE, p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE)
   IS
      SELECT gaa.gaa_id, gaa.usd_id, gaa.fechacrear
        FROM #ESQUEMA#.gaa_gestor_adicional_asunto gaa, #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge
       WHERE tge.dd_tge_codigo = p_tge_codigo AND tge.dd_tge_id = gaa.dd_tge_id AND gaa.asu_id = p_asu_id AND gaa.borrado = 0;

CURSOR crs_relacion_existente (p_tge_codigo #ESQUEMA_MASTER#.dd_tge_tipo_gestor.dd_tge_codigo%TYPE, p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE, v_des_id #ESQUEMA#.des_despacho_externo.des_id%TYPE)
    IS
      SELECT distinct FIRST_VALUE (gah_id) OVER (ORDER BY gah_fecha_desde ASC)
      FROM #ESQUEMA#.gah_gestor_adicional_historico 
              WHERE gah_fecha_hasta is null AND gah_gestor_id = 
                  (SELECT DISTINCT FIRST_VALUE (usd.usd_id) OVER (ORDER BY usd.usd_gestor_defecto DESC) FROM #ESQUEMA#.usd_usuarios_despachos usd WHERE usd.des_id = v_des_id)
                AND gah_tipo_gestor_id = (SELECT tge.dd_tge_id  FROM #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge  WHERE tge.dd_tge_codigo = p_tge_codigo)
                AND gah_asu_id = p_asu_id;

p_asu_id       #ESQUEMA#.asu_asuntos.asu_id%TYPE;
v_usu_id_pfs                  #ESQUEMA#.des_despacho_externo.des_id%TYPE;
v_usu_id_aba                 #ESQUEMA#.des_despacho_externo.des_id%TYPE;
v_usu_id_mc                  #ESQUEMA#.des_despacho_externo.des_id%TYPE;
p_importe_tarea     NUMBER;
p_tpo_tarea    #ESQUEMA#.DD_TPO_TIPO_PROCEDIMIENTO.DD_TPO_CODIGO%TYPE;

v_usd_id_result       #ESQUEMA#.usd_usuarios_despachos.usd_id%TYPE;
v_des_id                  #ESQUEMA#.des_despacho_externo.des_id%TYPE;
v_gah_existente           #ESQUEMA#.gah_gestor_adicional_historico.gah_id%TYPE;

BEGIN
   
   --antes que nada recupero el id del asunto
  --recupero los 3 usuarios posibles
  OPEN crs_asu_id ();

   FETCH crs_asu_id
    INTO p_asu_id;

   CLOSE crs_asu_id;
   
    --ahora recupero el importe del procedimiento
  OPEN crs_importe_prc ();

   FETCH crs_importe_prc
    INTO p_importe_tarea;

   CLOSE crs_importe_prc;
   
  --recupero los 3 usuarios posibles
  OPEN crs_datos_usu_pfs ();

   FETCH crs_datos_usu_pfs
    INTO v_usu_id_pfs;

   CLOSE crs_datos_usu_pfs;

   OPEN crs_datos_usu_aba ();

   FETCH crs_datos_usu_aba
    INTO v_usu_id_aba;

   CLOSE crs_datos_usu_aba;

   OPEN crs_datos_usu_mc ();

   FETCH crs_datos_usu_mc
    INTO v_usu_id_mc;

   CLOSE crs_datos_usu_mc;


  IF p_importe_tarea <= 180304
  THEN
  --a traves del id del usu que queramos, cogemos el usd
  OPEN crs_usd_id (v_usu_id_mc);

   FETCH crs_usd_id
    INTO v_usd_id_result;

   CLOSE crs_usd_id;

       --recuperamos el id del despacho que se ha utilizado
    OPEN crs_des_id (v_usd_id_result);

   FETCH crs_des_id
    INTO v_des_id;

   CLOSE crs_des_id;
  END IF;

  IF (p_importe_tarea > 180305 and p_importe_tarea <= 1000000)
  THEN
  --a traves del id del usu que queramos, cogemos el usd
  OPEN crs_usd_id (v_usu_id_aba);

   FETCH crs_usd_id
    INTO v_usd_id_result;

   CLOSE crs_usd_id;

       --recuperamos el id del despacho que se ha utilizado
    OPEN crs_des_id (v_usd_id_result);

   FETCH crs_des_id
    INTO v_des_id;

   CLOSE crs_des_id;
  END IF;

  IF p_importe_tarea > 1000000
  THEN
  --a traves del id del usu que queramos, cogemos el usd
  OPEN crs_usd_id (v_usu_id_pfs);

   FETCH crs_usd_id
    INTO v_usd_id_result;

   CLOSE crs_usd_id;

       --recuperamos el id del despacho que se ha utilizado
    OPEN crs_des_id (v_usd_id_result);

   FETCH crs_des_id
    INTO v_des_id;

   CLOSE crs_des_id;
  END IF;

 -- Si existe algun gestor activo del tipo indicado para el asunto, se añade al historico y se borra la relacion
      FOR relacion IN crs_gestores_activos (p_tge_codigo, p_asu_id)
      LOOP
         DELETE FROM #ESQUEMA#.gaa_gestor_adicional_asunto gaa
               WHERE gaa.gaa_id = relacion.gaa_id;
      END LOOP;

  -- Se añade la relacion entre el despacho elegido y el asunto
      INSERT INTO #ESQUEMA#.gaa_gestor_adicional_asunto
                  (gaa_id, asu_id, usd_id, dd_tge_id, VERSION,
                   usuariocrear, fechacrear, borrado
                  )
           VALUES (#ESQUEMA#.s_gaa_gestor_adicional_asunto.NEXTVAL, p_asu_id, 
                  v_usd_id_result,(SELECT tge.dd_tge_id
                      FROM #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge
                      WHERE tge.dd_tge_codigo = p_tge_codigo)
                      , 0,  p_username, SYSDATE, 0
              );

  -- Si quedan rastros en GAH_GESTOR_ADICIONAL_HISTORICO para el mismo asunto, y mismo tipo de gestor, le asignamos una fecha hasta para evitar conflictos
        UPDATE #ESQUEMA#.gah_gestor_adicional_historico gah
          SET gah.gah_fecha_hasta = SYSDATE
          WHERE gah.gah_asu_id = p_asu_id
            AND gah.gah_tipo_gestor_id = (SELECT tge.dd_tge_id  FROM #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge  WHERE tge.dd_tge_codigo = p_tge_codigo)
            AND gah.gah_fecha_hasta is null
            AND gah.gah_gestor_id = (SELECT DISTINCT FIRST_VALUE (usd.usd_id) OVER (ORDER BY usd.usd_gestor_defecto DESC) FROM #ESQUEMA#.usd_usuarios_despachos usd WHERE usd.des_id = v_des_id);


-- Ahora insertamos la relacion asunto-despacho, con el nuevo PROCURADOR seleccionado, y lo insertamos en el historico, pero sin la fecha HASTA, para que recovery lo recoja como el activo.
        OPEN crs_relacion_existente (p_tge_codigo, p_asu_id, v_des_id);
        FETCH crs_relacion_existente
          INTO v_gah_existente;
                
        IF v_gah_existente is null
        THEN
          INSERT INTO #ESQUEMA#.gah_gestor_adicional_historico
                       (gah_id, gah_gestor_id, gah_asu_id, gah_tipo_gestor_id, gah_fecha_desde, VERSION, usuariocrear, fechacrear, borrado)
              (SELECT #ESQUEMA#.s_gah_gestor_adic_historico.NEXTVAL
              , (SELECT DISTINCT FIRST_VALUE (usd.usd_id) OVER (ORDER BY usd.usd_gestor_defecto DESC) FROM #ESQUEMA#.usd_usuarios_despachos usd WHERE usd.des_id = v_des_id)
              , p_asu_id, tge.dd_tge_id, SYSDATE, 0, p_username, SYSDATE, 0
                 FROM #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge
                WHERE tge.dd_tge_codigo = p_tge_codigo);
        END IF;
        CLOSE crs_relacion_existente;

END asignacion_turnado_procu;
