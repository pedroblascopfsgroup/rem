--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160321
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-861
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Op. Masiva Carterización de acreditados. Actualizar OFI_ID persona.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE opm_carterizacion_acreditados (
   p_username     	#ESQUEMA_MASTER#.usu_usuarios.usu_username%TYPE,
   p_dni_persona   	#ESQUEMA#.per_personas.per_doc_id%TYPE,
   p_usuario		#ESQUEMA_MASTER#.usu_usuarios.usu_username%TYPE, --Usuario que ha cargado el fichero
   p_poc_id         #ESQUEMA#.POC_PETICION_OPM_CARTERIZAR.poc_id%TYPE,
   PL_OUTPUT        OUT VARCHAR2
)
AUTHID CURRENT_USER IS
	-- Recupera la oficina del gestor
   CURSOR crs_oficina_gestor (p_username #ESQUEMA_MASTER#.usu_usuarios.usu_username%TYPE)
   IS
     SELECT ofi.ofi_id
        FROM #ESQUEMA_MASTER#.usu_usuarios usu
        join #ESQUEMA#.zon_pef_usu zpu on usu.usu_id = zpu.usu_id 
        join #ESQUEMA#.zon_zonificacion zon on zpu.zon_id = zon.zon_id
        join #ESQUEMA#.ofi_oficinas ofi on zon.ofi_id = ofi.ofi_id
        where usu.usu_username = p_username
        	and zpu.pef_id = (select pef_id from pef_perfiles where pef_codigo='FPFCARTERIZ');

   -- Recupera la oficina del cliente
   CURSOR crs_oficina_cliente (p_dni_persona #ESQUEMA#.per_personas.per_doc_id%TYPE)
   IS
		SELECT per.ofi_id
			FROM #ESQUEMA#.per_personas per
			WHERE per.per_doc_id = p_dni_persona;

	-- Recupera los expedientes tipo 'Gestión de deuda', que tienen como titular de menor orden a la persona pasara por parametro
	CURSOR crs_expedientes (p_dni_persona #ESQUEMA#.per_personas.per_doc_id%TYPE)
	IS
		SELECT aux.exp_id FROM
			(SELECT exp.exp_id, cpe.per_id, MIN(cpe.cpe_orden)
				FROM #ESQUEMA#.exp_expedientes exp
				JOIN #ESQUEMA#.DD_TPX_TIPO_EXPEDIENTE tpx on exp.dd_tpx_id = tpx.dd_tpx_id AND tpx.dd_tpx_codigo = 'GESDEU'
				JOIN #ESQUEMA#.cex_contratos_expediente cex on exp.exp_id = cex.exp_id AND cex.cex_pase = 1
				JOIN #ESQUEMA#.cpe_contratos_personas cpe on cex.cnt_id = cpe.cnt_id
				GROUP BY exp.exp_id, cpe.per_id) aux
			WHERE aux.per_id = (select per_id from per_personas where per_doc_id = p_dni_persona);

   v_gestor_ofi_id           #ESQUEMA#.ofi_oficinas.ofi_id%TYPE;
   v_cliente_ofi_id          #ESQUEMA#.ofi_oficinas.ofi_id%TYPE;
   v_filtro_expediente        SYS.odcinumberlist;
   V_MSG_RES                  VARCHAR2(2000 CHAR);
   V_NUM_TABLAS 			NUMBER(16); -- Vble. para validar la existencia de una tabla.
   
   --Comprobar si se han procesado todos los registros de la misma peticion
   CURSOR crs_comprobar_peticion (p_poc_id #ESQUEMA#.POC_PETICION_OPM_CARTERIZAR.poc_id%TYPE)
   IS
		SELECT count(1)
			FROM #ESQUEMA#.POC_PETICION_OPM_CARTERIZAR poc
			WHERE poc.prm_id = (select prm_id from #ESQUEMA#.POC_PETICION_OPM_CARTERIZAR where poc_id = p_poc_id)
			AND POC_PENDIENTE = 0;
   
BEGIN
  DBMS_OUTPUT.PUT_LINE('********************************************************');
  dbms_output.put_line('INICIO PROCEDURE opm_carterizacion_acreditados ' || systimestamp);
  DBMS_OUTPUT.PUT_LINE('********************************************************');

	-- Recupera la oficina del gestor
   OPEN crs_oficina_gestor (p_username);
   FETCH crs_oficina_gestor
    INTO v_gestor_ofi_id;
   CLOSE crs_oficina_gestor;

   -- Recupera la oficina del cliente
   OPEN crs_oficina_cliente (p_dni_persona);
   FETCH crs_oficina_cliente
    INTO v_cliente_ofi_id;
   CLOSE crs_oficina_cliente;

   DBMS_OUTPUT.PUT_LINE(v_gestor_ofi_id);
   DBMS_OUTPUT.PUT_LINE(v_cliente_ofi_id);
   
   -- Si el of_id del cliente es distinto al encontrado en crs_oficina_gestor, se lo actualizamos por el encontrado.
   V_MSG_RES := 'OK - La oficina del cliente y el del gestor son iguales. No se actualizan oficinas de ningún expediente';
   IF v_gestor_ofi_id != v_cliente_ofi_id THEN
   DBMS_OUTPUT.PUT_LINE('*** OFI_ID del gestor diferente al del cliente, se va a actualizar el ofi_id a ('||v_gestor_ofi_id||') de per_doc_id ('||p_dni_persona||') ***');
   	 V_MSG_RES := 'OK - Oficina del cliente actualizada a la misma del gestor. ';
     
     UPDATE #ESQUEMA#.per_personas per
          SET ofi_id = v_gestor_ofi_id, per.usuariomodificar = p_usuario, per.fechamodificar = sysdate
          WHERE per.per_doc_id=p_dni_persona;

        -- Buscamos los expedientes que tengan de titular de menor orden al cliente pasado por parametro
	    OPEN crs_expedientes (p_dni_persona);
	      LOOP
	   		FETCH crs_expedientes
	    	BULK COLLECT INTO v_filtro_expediente;
	        EXIT WHEN crs_expedientes%NOTFOUND;
	      END LOOP;
	   	CLOSE crs_expedientes;
     
	   	-- Si se han encontrado expedientes, actualizamos su ofi_id al nuevo encontrado
		IF v_filtro_expediente.COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('*** Se van a actualizar uno o varios ofi_id a ('||v_gestor_ofi_id||') de exp_expedientes ***');
			UPDATE #ESQUEMA#.exp_expedientes exp
				SET exp.ofi_id = v_gestor_ofi_id, exp.usuariomodificar = p_usuario, exp.fechamodificar = sysdate
				WHERE exp_id IN (select COLUMN_VALUE from table (v_filtro_expediente));
        
      -- Actualizamos el registro para que no se vuelve a ejecutar la operacion en otra ocasion.
      V_MSG_RES := V_MSG_RES||'Se ha actualizado la oficina de uno o varios expedientes';
      
		END IF;
   END IF;
   
   UPDATE #ESQUEMA#.POC_PETICION_OPM_CARTERIZAR 
        set fechamodificar = sysdate, usuariomodificar = 'ETL', poc_pendiente = 1, poc_resultado = 0,
          poc_resultado_descrip = V_MSG_RES
        where poc_id = p_poc_id;
  
  -- Comprobamos si se han procesado todos los registros de la misma peticion para cambiar el estado del arhivo
   OPEN crs_comprobar_peticion (p_poc_id);
   FETCH crs_comprobar_peticion
    INTO V_NUM_TABLAS;
   CLOSE crs_comprobar_peticion;
   
   --Si se han procesado todos (y ha ido todo bien), cambiamos el estado a procesado del fichero.
   IF V_NUM_TABLAS = 0 THEN
   	UPDATE #ESQUEMA#.PRM_PROCESO_MASIVO
   		SET DD_EPF_ID = (select DD_EPF_ID from #ESQUEMA#.DD_EPF_ESTADO_PROCES_FICH where DD_EPF_CODIGO='PRC')
   		WHERE PRM_ID=(select prm_id from #ESQUEMA#.POC_PETICION_OPM_CARTERIZAR where poc_id = p_poc_id);
   END IF;

  DBMS_OUTPUT.PUT_LINE('********************************************************');
  dbms_output.put_line('Fin PROCEDURE opm_carterizacion_acreditados ' || systimestamp);
  DBMS_OUTPUT.PUT_LINE('********************************************************');
  PL_OUTPUT := 'OK';
   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
      PL_OUTPUT := 'Error: '|| TO_CHAR (SQLCODE)||'['||SQLERRM||']';
END opm_carterizacion_acreditados;
/
EXIT;
