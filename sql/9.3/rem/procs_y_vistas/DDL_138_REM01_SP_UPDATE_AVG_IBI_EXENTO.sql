--/*
--##########################################
--## AUTOR=Jose Villel
--## FECHA_CREACION=20170809
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2555
--## PRODUCTO=NO
--## Finalidad: Actualiza la alerta 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

-- Parámetros de entrada --------------------------------------------------------------------------------------------------
-- p_gasto_id, 		id del gasto a actualizar (si viene a null, los actualizará todos)
-- ------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE UPDATE_AVG_IBI_EXENTO (
   p_gpv_id       	IN #ESQUEMA#.gpv_gastos_proveedor.gpv_id%TYPE
)
AUTHID CURRENT_USER IS

	-- Declaración de variables
	
	-- Subtipos de gasto a los que se refiere es procedure
	-- 01	IBI urbana
	-- 02	IBI rústica
	v_stg_codigo_ibi_urbana 	VARCHAR2(10 CHAR) := '01';
	v_stg_codigo_ibi_rustica 	VARCHAR2(10 CHAR) := '02';
	-- Gasto a actualizar
	v_gpv_id 					#ESQUEMA#.gpv_gastos_proveedor.gpv_id%TYPE;
	-- Número de activos que no tienen exención de ibi para un gasto dado.
	v_num_activos				NUMBER(4,0);
	-- Valor de la columna de alerta que añadiremos/modicaremos [0/1]
	v_alerta_value				NUMBER(1,0); 
	-- Usuario para INSERTS y UPDATES
	v_username 					VARCHAR2(100 CHAR) := 'SP_UPDATE_AVG_IBI_EXENTO';

	
	TYPE GASTOS_REF IS REF CURSOR;
	crs_gastos GASTOS_REF;


BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	
	-- Buscamos un gasto en concreto si lo hemos recibido o todos los gastos de los subtipos 
	-- declarados en v_codigos_stg_ibi. 
	IF(p_gpv_id IS NULL ) THEN 
	
		OPEN crs_gastos FOR
	   		SELECT DISTINCT gpv.gpv_id
			FROM #ESQUEMA#.gpv_gastos_proveedor gpv
			INNER JOIN #ESQUEMA#.dd_stg_subtipos_gasto stg on stg.dd_stg_id = gpv.dd_stg_id
			WHERE stg.dd_stg_codigo IN (v_stg_codigo_ibi_urbana,v_stg_codigo_ibi_rustica)
			AND gpv.borrado = 0;
	ELSE
		OPEN crs_gastos FOR
	   		SELECT DISTINCT gpv.gpv_id
			FROM #ESQUEMA#.gpv_gastos_proveedor gpv
			INNER JOIN #ESQUEMA#.dd_stg_subtipos_gasto stg on stg.dd_stg_id = gpv.dd_stg_id
			WHERE stg.dd_stg_codigo IN (v_stg_codigo_ibi_urbana,v_stg_codigo_ibi_rustica) 
			AND gpv.gpv_id = p_gpv_id
			AND gpv.borrado = 0;
	
	END IF;
	
	-- Recorremos los gastos.
	FETCH crs_gastos INTO v_gpv_id;
	WHILE (crs_gastos%FOUND) LOOP
		
		-- Buscamos entre los activos de este gasto si alguno no tiene marcado el ibi como exento.
		
		    SELECT COUNT(GPV_ACT.ACT_ID) INTO v_num_activos 
		    FROM  #ESQUEMA#.GPV_ACT GPV_ACT
            INNER JOIN  #ESQUEMA#.ACT_ACTIVO ACT ON ACT.ACT_ID = GPV_ACT.ACT_ID
            WHERE GPV_ID = v_gpv_id 
            AND (ACT.ACT_IBI_EXENTO IS NULL OR ACT.ACT_IBI_EXENTO = 0);
            
        -- Si hay activos que no tengan marcada la exención de IBI v_alerta_value será 0, sino será 1. 
		
            IF (v_num_activos > 0) THEN
            	-- Alerta ibi Exento a 0
            	--DBMS_OUTPUT.PUT_LINE('[GASTO ' || v_gpv_id || '] Existe algún activo que no tiene marcado el ibi exento');
            	v_alerta_value:=0;
            ELSE
            	-- Alerta ibi Exento a 1
            	--DBMS_OUTPUT.PUT_LINE('[GASTO ' || v_gpv_id || '] Todos los activos tienen marcado el ibi exento');
            	v_alerta_value:=1;
           
            END IF;
            
        -- Intentamos actualizar la alerta 
        	UPDATE #ESQUEMA#.AVG_AVISOS_GASTOS SET 
        	AVG_IBI_EXENTO=v_alerta_value, 
        	USUARIOMODIFICAR = v_username,
        	FECHAMODIFICAR = SYSDATE
        	WHERE GPV_ID = v_gpv_id;
            
        -- Si existe y se ha actualizado mostramos el mensaje
        	IF(SQL%ROWCOUNT>0) THEN
        		DBMS_OUTPUT.PUT_LINE('[GASTO ' || v_gpv_id || '] Actualizamos la alerta Ibi Exento con el valor ' || v_alerta_value);
        	
        	ELSE
        -- Si no ha encontrado alertas, la creamos solamente si es activa 
        		IF(v_alerta_value=1) THEN
        			INSERT INTO #ESQUEMA#.AVG_AVISOS_GASTOS(AVG_ID,GPV_ID,AVG_IBI_EXENTO,USUARIOCREAR,FECHACREAR) values
            		(#ESQUEMA#.S_AVG_AVISOS_GASTOS.nextval,v_gpv_id,v_alerta_value,v_username,SYSDATE);
            		DBMS_OUTPUT.PUT_LINE('[GASTO ' || v_gpv_id || '] Insertamos alerta Ibi Exento.' || v_alerta_value);
            	END IF;
        	END IF;
            	
		
			FETCH crs_gastos INTO v_gpv_id;
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[CURSOR DE GASTOS] NUMERO DE GASTOS IMPLICADOS: '|| crs_gastos%ROWCOUNT);
	
	CLOSE crs_gastos;
	
	
COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END UPDATE_AVG_IBI_EXENTO;
/
EXIT;
	


