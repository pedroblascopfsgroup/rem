--/*
--##########################################
--## AUTOR=Jose Villel
--## FECHA_CREACION=20170814
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2652
--## PRODUCTO=NO
--## Finalidad: Actualiza la alerta AVG_IMPUESTO para un gasto o todos
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

CREATE OR REPLACE PROCEDURE UPDATE_AVG_IMPUESTO (
   p_gpv_id       	IN #ESQUEMA#.gpv_gastos_proveedor.gpv_id%TYPE
)
AUTHID CURRENT_USER IS

	-- Declaración de variables
	
	-- Subtipos de gasto a los que se refiere este procedure
	-- 03	Plusvalia urbana
	-- 04	Plusvalia rústica
	v_stg_codigo_plusvalia_compra	VARCHAR2(10 CHAR) := '03';
	v_stg_codigo_plusvalia_venta 	VARCHAR2(10 CHAR) := '04';
	-- Estado comercial del activo a los que se refiere este procedure
	-- 05	Vendido
	v_stg_codigo_scm_vendido	VARCHAR2(10 CHAR) := '05';
	-- Codigo provincia a la que no puede pertenecer el activo
	-- 09	Cataluña
	v_cma_codigo_catalunya	VARCHAR2(10 CHAR) := '09';
	
	-- Gasto a actualizar
	v_gpv_id 					#ESQUEMA#.gpv_gastos_proveedor.gpv_id%TYPE;
	-- Número de activos que no tienen exención de ibi para un gasto dado.
	v_num_activos				NUMBER(4,0);
	-- Valor de la columna de alerta que añadiremos/modicaremos [0/1]
	v_alerta_value				NUMBER(1,0); 
	-- Usuario para INSERTS y UPDATES
	v_username 					VARCHAR2(100 CHAR) := 'SP_UPDATE_AVG_IMPUESTO';

	
	TYPE GASTOS_REF IS REF CURSOR;
	crs_gastos GASTOS_REF;


BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	
	-- Buscamos un gasto en concreto si lo hemos recibido o todos los gastos de los subtipos 
	-- declarados en v_stg_codigo_plusvalia_compra y v_stg_codigo_plusvalia_venta. 
	IF(p_gpv_id IS NULL ) THEN 
	
		OPEN crs_gastos FOR
	   		SELECT DISTINCT gpv.gpv_id
			FROM #ESQUEMA#.gpv_gastos_proveedor gpv
			INNER JOIN #ESQUEMA#.dd_stg_subtipos_gasto stg on stg.dd_stg_id = gpv.dd_stg_id
			WHERE stg.dd_stg_codigo IN (v_stg_codigo_plusvalia_compra,v_stg_codigo_plusvalia_venta)
			AND gpv.borrado = 0;
	ELSE
		OPEN crs_gastos FOR
	   		SELECT DISTINCT gpv.gpv_id
			FROM #ESQUEMA#.gpv_gastos_proveedor gpv
			INNER JOIN #ESQUEMA#.dd_stg_subtipos_gasto stg on stg.dd_stg_id = gpv.dd_stg_id
			WHERE stg.dd_stg_codigo IN (v_stg_codigo_plusvalia_compra,v_stg_codigo_plusvalia_venta) 
			AND gpv.gpv_id = p_gpv_id
			AND gpv.borrado = 0;
	
	END IF;
	
	-- Recorremos los gastos.
	FETCH crs_gastos INTO v_gpv_id;
	WHILE (crs_gastos%FOUND) LOOP
		
		-- Buscamos entre los activos de este gasto si alguno no cumple los siguientes requisitos:
			-- Estado comercial vendido.
			-- No ha transcurrido un año entre la fecha de venta y la fecha de adjudicación/adquisición
			-- No está en Cataluña 
		
		    SELECT COUNT(GPV_ACT.ACT_ID) INTO v_num_activos 
		    FROM  #ESQUEMA#.GPV_ACT GPV_ACT
            INNER JOIN #ESQUEMA#.ACT_ACTIVO ACT ON ACT.ACT_ID = GPV_ACT.ACT_ID
            INNER JOIN #ESQUEMA#.DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
            INNER JOIN #ESQUEMA#.BIE_LOCALIZACION BIE_LOC ON ACT.BIE_ID = BIE_LOC.BIE_ID
            INNER JOIN #ESQUEMA#.ACT_CMP_COMAUTONOMA_PROVINCIA CMP ON BIE_LOC.DD_PRV_ID = CMP.DD_PRV_ID
            INNER JOIN #ESQUEMA#.DD_CMA_COMAUTONOMA CMA ON CMP.DD_CMA_ID = CMA.DD_CMA_ID
            LEFT JOIN #ESQUEMA#.ACT_OFR ACTOFR ON ACT.ACT_ID = ACTOFR.ACT_ID
            LEFT JOIN #ESQUEMA#.ECO_EXPEDIENTE_COMERCIAL ECO ON ACTOFR.OFR_ID = ECO.OFR_ID
            LEFT JOIN #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID AND EEC.DD_EEC_CODIGO = '08'
            LEFT JOIN #ESQUEMA#.ACT_AJD_ADJJUDICIAL AJD ON ACT.ACT_ID = AJD.ACT_ID
            LEFT JOIN #ESQUEMA#.ACT_ADN_ADJNOJUDICIAL ADN ON ACT.ACT_ID = ADN.ACT_ID            
            WHERE GPV_ID = v_gpv_id
            AND (SCM.DD_SCM_CODIGO != v_stg_codigo_scm_vendido OR
            	 CMA.DD_CMA_CODIGO = v_cma_codigo_catalunya OR 
            	 (ACT.ACT_VENTA_EXTERNA_FECHA IS NULL AND ECO.ECO_FECHA_VENTA IS NULL) OR
                 (AJD.AJD_FECHA_ADJUDICACION IS NULL AND ADN.ADN_FECHA_TITULO IS NULL) OR
                 NVL2(ACT.ACT_VENTA_EXTERNA_FECHA,ACT.ACT_VENTA_EXTERNA_FECHA,ECO.ECO_FECHA_VENTA) - NVL2(AJD.AJD_FECHA_ADJUDICACION,AJD.AJD_FECHA_ADJUDICACION,ADN.ADN_FECHA_TITULO) >= 365
                 );
            
        -- Si hay activos que no cumplen los requisitos v_alerta_value será 0, sino será 1. 
		
            IF (v_num_activos > 0) THEN
            	-- Alerta ibi Exento a 0
            	--DBMS_OUTPUT.PUT_LINE('[GASTO ' || v_gpv_id || '] Existe algún activo que no cumple los requisitos');
            	v_alerta_value:=0;
            ELSE
            	-- Alerta ibi Exento a 1
            	--DBMS_OUTPUT.PUT_LINE('[GASTO ' || v_gpv_id || '] Todos los activos cumplen los requisitos');
            	v_alerta_value:=1;
           
            END IF;
            
        -- Intentamos actualizar la alerta 
        	UPDATE #ESQUEMA#.AVG_AVISOS_GASTOS SET 
        	AVG_IMPUESTO=v_alerta_value, 
        	USUARIOMODIFICAR = v_username,
        	FECHAMODIFICAR = SYSDATE
        	WHERE GPV_ID = v_gpv_id;
            
        -- Si existe y se ha actualizado mostramos el mensaje
        	IF(SQL%ROWCOUNT=0) THEN
        -- Si no ha encontrado alertas, la creamos solamente si es activa 
        		IF(v_alerta_value=1) THEN
        			INSERT INTO #ESQUEMA#.AVG_AVISOS_GASTOS(AVG_ID,GPV_ID,AVG_IMPUESTO,USUARIOCREAR,FECHACREAR) values
            		(#ESQUEMA#.S_AVG_AVISOS_GASTOS.nextval,v_gpv_id,v_alerta_value,v_username,SYSDATE);
            		--DBMS_OUTPUT.PUT_LINE('[GASTO ' || v_gpv_id || '] Insertamos alerta Impuesto con el valor ' || v_alerta_value);
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
END UPDATE_AVG_IMPUESTO;
/
EXIT;

