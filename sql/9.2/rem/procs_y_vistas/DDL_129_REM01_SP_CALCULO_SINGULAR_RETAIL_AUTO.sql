--/*
--##########################################
--## AUTOR=Daniel Gutiérrez
--## FECHA_CREACION=20170320
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1814
--## PRODUCTO=NO
--## Finalidad: Actualiza el tipo comercializar (Singular/Retail) del activo
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
create or replace PROCEDURE CALCULO_SINGULAR_RETAIL_AUTO (
   p_act_id       	IN #ESQUEMA#.act_activo.act_id%TYPE,
   p_username     	IN #ESQUEMA#.act_activo.usuariomodificar%TYPE,
   p_all_activos	IN NUMBER,
   p_ignore_block	IN NUMBER
)
AUTHID CURRENT_USER IS
-- Definición parámetros de entrada ---------------------------------------------------------------------------------------
-- p_act_id, 		id del activo a comprobar (si viene a null, los comprabará todos)**(Condicionado con p_all_activos)
-- p_username, 		usuario que hace la llamada (se insertará en usuariomodificar)
-- p_all_activos,	si viene a 1, se analizarán todos los activos, sino, solo aquellos que no tengan informado el dd_tcr_id
-- p_ignore_block,	si viene a 1, se ignora el bloqueo automático(ACT_BLOQUEO_TIPO_COMERCIALIZAR) para actualizar el TCR
-- ------------------------------------------------------------------------------------------------------------------------
	-- Definición de cursores --------------------------------------------------------

	-- Devuelve 1 si el activo pertenece a una agrupacion asistida o de obra nueva
	CURSOR crs_act_agr_asis_on(p_act_id #ESQUEMA#.act_activo.act_id%TYPE)
	IS
		SELECT count(1)
			FROM #ESQUEMA#.ACT_ACTIVO act
			INNER JOIN #ESQUEMA#.ACT_AGA_AGRUPACION_ACTIVO aga on act.act_id = aga.act_id
			INNER JOIN #ESQUEMA#.ACT_AGR_AGRUPACION agr on aga.agr_id = agr.agr_id and agr.agr_fecha_baja is null
			INNER JOIN #ESQUEMA#.DD_TAG_TIPO_AGRUPACION tag on agr.dd_tag_id = tag.dd_tag_id
				WHERE act.act_id = p_act_id
				AND tag.dd_tag_codigo IN ('01','13')
				AND rownum=1
        and act.borrado = 0;

	-- Devuelve 1 si el activo tiene el tipo uso destino de 1ª o 2ª residencia
	CURSOR crs_activo_residencia(p_act_id #ESQUEMA#.act_activo.act_id%TYPE)
	IS
		SELECT count(1)
			FROM #ESQUEMA#.ACT_ACTIVO act
			INNER JOIN #ESQUEMA#.DD_TUD_TIPO_USO_DESTINO tud on act.dd_tud_id = tud.dd_tud_id
				WHERE act.act_id = p_act_id
				AND tud.dd_tud_codigo IN ('01','06')
				AND rownum=1
        and act.borrado = 0;

	-- Devuelve importe si el activo tiene el tipo de precio indicado dentro del limite pasados por parametros
	CURSOR crs_act_importe_limite(p_act_id #ESQUEMA#.act_activo.act_id%TYPE, p_cod_precio VARCHAR2, p_importe_limite NUMBER)
	IS
		SELECT val.val_importe
			FROM #ESQUEMA#.ACT_ACTIVO act
			INNER JOIN #ESQUEMA#.ACT_VAL_VALORACIONES val ON act.act_id = val.act_id
			INNER JOIN #ESQUEMA#.DD_TPC_TIPO_PRECIO tpc ON val.dd_tpc_id = tpc.dd_tpc_id
				WHERE act.act_id = p_act_id
				AND tpc.dd_tpc_codigo = p_cod_precio
				AND val.val_importe <= p_importe_limite
				AND (val.val_fecha_fin is null OR val.val_fecha_fin >= sysdate)
        and act.borrado = 0;

	-- Devuelve importe tasación dentro del limite pasados por parametros
	CURSOR crs_activo_tasacion_in_limite(p_act_id #ESQUEMA#.act_activo.act_id%TYPE, p_importe_limite NUMBER)
	IS
		SELECT count(1)
			FROM #ESQUEMA#.ACT_TAS_TASACION tas
			WHERE tas.TAS_IMPORTE_TAS_FIN <= p_importe_limite
			AND rownum=1;

	-- Comprueba que el activo tenga asociado el tipo de gestor pasado por parametro
	CURSOR crs_activo_with_gestor(p_act_id #ESQUEMA#.act_activo.act_id%TYPE, p_cod_gestor VARCHAR2)
	IS
		SELECT count(1)
			FROM #ESQUEMA#.GAC_GESTOR_ADD_ACTIVO gac
			INNER JOIN #ESQUEMA#.ACT_ACTIVO act ON gac.act_id = act.act_id
			INNER JOIN #ESQUEMA#.GEE_GESTOR_ENTIDAD gee ON gac.gee_id = gee.gee_id
			INNER JOIN #ESQUEMA_MASTER#.DD_TGE_TIPO_GESTOR tge ON gee.dd_tge_id = tge.dd_tge_id
				WHERE act.act_id = p_act_id
				AND tge.dd_tge_codigo = p_cod_gestor
				AND rownum=1
        and act.borrado = 0;

	-- Comprueba si existen tareas activas de tramites comerciales para el activo con el TIPO gestor anterior
	CURSOR crs_activo_tareas_activas(p_act_id #ESQUEMA#.act_activo.act_id%TYPE, p_cod_gestor VARCHAR2)
	IS
		select CASE existe WHEN 1 THEN 0 ELSE 1 END FROM (
			SELECT count(1) as existe
				FROM #ESQUEMA#.V_BUSQUEDA_TRAMITES_ACTIVO v
				INNER JOIN #ESQUEMA#.tac_tareas_activos tac ON v.tra_id = tac.tra_id
				INNER JOIN #ESQUEMA#.tar_tareas_notificaciones tar ON tac.tar_id = tar.tar_id
				INNER JOIN #ESQUEMA_MASTER#.usu_usuarios usu ON tac.usu_id = usu.usu_id
				INNER JOIN #ESQUEMA#.GEE_GESTOR_ENTIDAD gee ON usu.usu_id = gee.usu_id
				INNER JOIN #ESQUEMA_MASTER#.DD_TGE_TIPO_GESTOR tge ON gee.dd_tge_id = tge.dd_tge_id
					WHERE v.act_id = p_act_id
					AND v.TIPO_TRAMITE_CODIGO = 'T013'
					AND tar.tar_fecha_fin is null
					AND tge.dd_tge_codigo = p_cod_gestor
					AND rownum=1);

	-- Declaración de variables
	V_MSQL 							VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
	v_act_id 						NUMBER(16);	-- activo a actualizar en el loop
	v_username						#ESQUEMA#.act_activo.usuariomodificar%TYPE; -- nombre de usuario que llama al procedure
	v_all_activos      				NUMBER; -- Indicador de si actualizar todos los activos o solo el pasado por parametro
	v_ignore_block					NUMBER; -- Indicador para ignorar el bloqueo automático para actualizar Singular/Retail del activo
	v_is_retail						NUMBER(1); -- Indicador para ver si es ratil o no (singular) según los cálculos
	v_importe_max					NUMBER; -- Variable aux. para guardar el importe del activo
	v_importe_max_cartera_1			NUMBER := 500000; -- Cte. almacena el importe máximo para cajamar
	v_importe_max_cartera_2			NUMBER := 600000; -- Cte. almacena el importe máximo para sareb
	v_importe_max_cartera_3			NUMBER := 600000; -- Cte. almacena el importe máximo para bankia
    v_importe_max_cartera_4			NUMBER := 600000; -- Cte. almacena el importe máximo para HyT
	v_cod_tipo_comercializar		VARCHAR2(10 CHAR); -- Vble. aux. para almacenar el codigo calculado
	v_cod_cartera_activo			VARCHAR2(10 CHAR); -- Vble. aux. para almacenar el codigo cartera del activo
	v_cod_cartera_1					VARCHAR2(10 CHAR) := '01';
	v_cod_cartera_2					VARCHAR2(10 CHAR) := '02';
	v_cod_cartera_3					VARCHAR2(10 CHAR) := '03';
    v_cod_cartera_4                 VARCHAR2(10 CHAR) := '06';
	v_cod_importe_vnc				VARCHAR2(10 CHAR) := '01';
	v_cod_importe_aprobado_venta	VARCHAR2(10 CHAR) := '02';
	v_cod_gestor_sing				VARCHAR2(10 CHAR) := 'GCOM';
	v_cod_gestor_ret				VARCHAR2(10 CHAR) := 'GCOM';
	v_cod_gestor					VARCHAR2(10 CHAR);
	v_update_ok						NUMBER(1);
	v_cadena_aux					VARCHAR2(10 CHAR);

   	TYPE criterio_valor_map IS TABLE OF NUMBER INDEX BY VARCHAR2(30);
	criterio_valor criterio_valor_map;
	TYPE ACTIVOS_REF IS REF CURSOR;
	crs_activos ACTIVOS_REF;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	-- Si no viene informado el username, asignamos el de este procedure
	v_username := p_username;
	IF(p_username IS NULL) THEN
		v_username := 'SP_CALCULO_SING_RET';
	END IF;
	-- Si no viene informado el parametro de entrada p_all_activos, le ponemos el valor por defecto '0'.
	v_all_activos := p_all_activos;

	IF(p_all_activos IS NULL) THEN
		v_all_activos := 0;
	END IF;


    -- Abriremos un cursor u otro, dependiendo si el parametro de entrada p_act_id viene informado
    IF(p_ignore_block IS NOT NULL AND p_ignore_block = 1) THEN
    	IF(p_act_id IS NULL AND v_all_activos = 1) THEN -- Todos los activos
			OPEN crs_activos FOR
	   		 SELECT DISTINCT act.act_id
				FROM #ESQUEMA#.act_activo act
				LEFT JOIN #ESQUEMA#.act_pac_perimetro_activo pac on pac.act_id=act.act_id
					WHERE pac.pac_check_comercializar is null or pac.pac_check_comercializar = 1
        and act.borrado = 0;
		ELSE
			IF(p_act_id IS NULL) THEN 					-- Todos los activos que no tengan informado el tipo comercializar
				OPEN crs_activos FOR
		   		 SELECT DISTINCT act.act_id
					FROM #ESQUEMA#.act_activo act
					LEFT JOIN #ESQUEMA#.act_pac_perimetro_activo pac on pac.act_id=act.act_id
						WHERE act.DD_TCR_ID is null
						AND (pac.pac_check_comercializar is null or pac.pac_check_comercializar = 1)
        and act.borrado = 0;
			ELSE											-- Solo el activo pasado por parametro
				OPEN crs_activos FOR
		   		 SELECT act.act_id
		   		 	FROM #ESQUEMA#.act_activo act
		   		 	LEFT JOIN #ESQUEMA#.act_pac_perimetro_activo pac on pac.act_id=act.act_id
		   		 		WHERE act.act_id = p_act_id
		   		 		AND (pac.pac_check_comercializar is null or pac.pac_check_comercializar = 1)
        and act.borrado = 0;
		   	END IF;
		END IF;
    ELSE 												-- Misma situación, salvo aquellos activos que tengan activado el bloqueo para actualizar la comercializacion
		IF(p_act_id IS NULL AND v_all_activos = 1) THEN
			OPEN crs_activos FOR
	   		 SELECT DISTINCT act.act_id
				FROM #ESQUEMA#.act_activo act
				LEFT JOIN #ESQUEMA#.act_pac_perimetro_activo pac on pac.act_id=act.act_id
					WHERE act.ACT_BLOQUEO_TIPO_COMERCIALIZAR=0
					AND (pac.pac_check_comercializar is null or pac.pac_check_comercializar = 1)
        and act.borrado = 0;
		ELSE
			IF(p_act_id IS NULL) THEN
				OPEN crs_activos FOR
		   		 SELECT DISTINCT act.act_id
					FROM #ESQUEMA#.act_activo act
					LEFT JOIN #ESQUEMA#.act_pac_perimetro_activo pac on pac.act_id=act.act_id
						WHERE act.DD_TCR_ID is null
						AND act.ACT_BLOQUEO_TIPO_COMERCIALIZAR=0
						AND (pac.pac_check_comercializar is null or pac.pac_check_comercializar = 1)
        and act.borrado = 0;
			ELSE
				OPEN crs_activos FOR
		   		 SELECT act.act_id
		   		 	FROM #ESQUEMA#.act_activo act
		   		 	LEFT JOIN #ESQUEMA#.act_pac_perimetro_activo pac on pac.act_id=act.act_id
		   		 		WHERE act.act_id = p_act_id
		   		 		AND act.ACT_BLOQUEO_TIPO_COMERCIALIZAR=0
		   		 		AND (pac.pac_check_comercializar is null or pac.pac_check_comercializar = 1)
        and act.borrado = 0;
			END IF;
		END IF;
	END IF;

	-- Calcula la puntuación y el rating correspondiente por activo
	FETCH crs_activos INTO v_act_id;
	WHILE (crs_activos%FOUND) LOOP
		-- inicializamos las variables
		v_is_retail := 0;
		v_cod_tipo_comercializar := '01';
		v_cod_cartera_activo := null;
		v_importe_max := null;
		v_cod_gestor := v_cod_gestor_sing;
		v_update_ok := 0;
		v_cadena_aux := null;


		-- Obtenemos la cartera del activo a comprobar.
		V_MSQL := 'SELECT cra.dd_cra_codigo FROM #ESQUEMA#.ACT_ACTIVO act INNER JOIN #ESQUEMA#.DD_CRA_CARTERA cra ON act.dd_cra_id = cra.dd_cra_id WHERE act.act_id='||v_act_id||' and act.borrado = 0';
		EXECUTE IMMEDIATE V_MSQL INTO v_cod_cartera_activo;

		-- Es Activo en agrupacion Obra Nueva o Asistida --> RETAIL
		OPEN crs_act_agr_asis_on (v_act_id);
			FETCH crs_act_agr_asis_on into v_is_retail;
		CLOSE crs_act_agr_asis_on;

		IF (v_is_retail = 0) THEN
			-- Es Activo con TIPO USO DESTINO de 1ª o 2ª residencia --> RETAIL
			OPEN crs_activo_residencia (v_act_id);
				FETCH crs_activo_residencia into v_is_retail;
			CLOSE crs_activo_residencia;
		END IF;

      	IF (v_is_retail = 0 AND v_cod_cartera_activo = v_cod_cartera_1) THEN
			-- Es Activo cartera Cajamar con VNC <= 500000 --> RETAIL
			OPEN crs_act_importe_limite (v_act_id, v_cod_importe_vnc, v_importe_max_cartera_1);
				FETCH crs_act_importe_limite into v_importe_max;
			CLOSE crs_act_importe_limite;

			IF (v_importe_max is not null) THEN
				v_is_retail := 1;
			END IF;

		END IF;

		IF (v_is_retail = 0 AND (v_cod_cartera_activo = v_cod_cartera_2 OR v_cod_cartera_activo = v_cod_cartera_3 OR v_cod_cartera_activo = v_cod_cartera_4)) THEN
			-- Es Activo cartera Sareb o Bankia con Aprobado venta <= 600000 --> RETAIL
			IF(v_cod_cartera_activo = v_cod_cartera_2) THEN
				v_importe_max := v_importe_max_cartera_2;
			ELSE 
                IF (v_cod_cartera_activo = v_cod_cartera_3) THEN
                    v_importe_max := v_importe_max_cartera_3;
			ELSE
				v_importe_max := v_importe_max_cartera_4;
                END IF;
			END IF;

			OPEN crs_act_importe_limite (v_act_id, v_cod_importe_aprobado_venta, v_importe_max);
				FETCH crs_act_importe_limite into v_importe_max;
			CLOSE crs_act_importe_limite;

			-- Si el activo no tiene informado un importe de Aprobado venta, miramos su tasacion, si esta es <= 600000 --> RETAIL
			IF (v_importe_max IS NOT NULL) THEN
				v_is_retail := 1;
			ELSE
				OPEN crs_activo_tasacion_in_limite (v_act_id,v_importe_max);
					FETCH crs_activo_tasacion_in_limite into v_is_retail;
				CLOSE crs_activo_tasacion_in_limite;
			END IF;
		END IF;


		IF (v_is_retail = 1) THEN
			v_cod_tipo_comercializar := '02';
			v_cod_gestor := v_cod_gestor_ret;
		END IF;

		---------------------TODO: Provisional, Revisar cuando se haga el cambio funcional sobre gestores comerciales ----------------
		--- Antes de actualizar el nuevo TCR, debemos comprobar si el activo tiene el gestor comercial adecuado para ello
		OPEN crs_activo_with_gestor (v_act_id,v_cod_gestor);
			FETCH crs_activo_with_gestor into v_update_ok;
		CLOSE crs_activo_with_gestor;

		-- Si no lo tiene, pero tampoco tiene tareas realacionadas con el gestor comercial actual, se pouede cambiar el tipo al activo.
		IF (v_update_ok = 0) THEN
			IF (v_cod_gestor = v_cod_gestor_ret) THEN
				v_cadena_aux := v_cod_gestor_sing;
			ELSE
				v_cadena_aux := v_cod_gestor_ret;
			END IF;

			OPEN crs_activo_tareas_activas (v_act_id,v_cadena_aux);
				FETCH crs_activo_tareas_activas into v_update_ok;
			CLOSE crs_activo_tareas_activas;

		END IF;
		------------------------------------------------------------------------------------------------------------------------------

		IF (v_update_ok = 1) THEN
			-- Actualizamos el tipo comercializar del activo, si el que ya tienes asignado, es diferente del que se acaba de calcular
			UPDATE #ESQUEMA#.ACT_ACTIVO act
				SET act.DD_TCR_ID = (select tcr.dd_tcr_id from DD_TCR_TIPO_COMERCIALIZAR tcr where tcr.dd_tcr_codigo = v_cod_tipo_comercializar),
					act.USUARIOMODIFICAR = v_username, act.FECHAMODIFICAR = SYSDATE
				WHERE act.ACT_ID = v_act_id
				AND (act.DD_TCR_ID IS NULL OR
					act.DD_TCR_ID <> (select tcr.dd_tcr_id from DD_TCR_TIPO_COMERCIALIZAR tcr where tcr.dd_tcr_codigo = v_cod_tipo_comercializar));
			DBMS_OUTPUT.PUT_LINE('[Tipo comercializar actualizado en act_id='||v_act_id||' con codigo='||v_cod_tipo_comercializar||']');
        END IF;

		FETCH crs_activos INTO v_act_id;
	  END LOOP;

	CLOSE crs_activos;
   COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END CALCULO_SINGULAR_RETAIL_AUTO;
/
EXIT
