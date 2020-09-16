--/*
--##########################################
--## AUTOR=Jose Villel
--## FECHA_CREACION=20170816
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2664
--## PRODUCTO=NO
--## Finalidad: Actualiza la alerta AVG_INCR_IMPORTE para un gasto.
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
-- p_gasto_id, 		id del gasto a actualizar
-- ------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE UPDATE_AVG_INCR_IMPORTE (
   p_gpv_id       	IN #ESQUEMA#.gpv_gastos_proveedor.gpv_id%TYPE
)
AUTHID CURRENT_USER IS

	-- Declaración de variables
	
	-- Subtipos de gasto a los que se refiere es procedure
	-- 01	IBI urbana
	-- 02	IBI rústica
	v_stg_codigo_ibi_urbana 	VARCHAR2(10 CHAR) := '01';
	v_stg_codigo_ibi_rustica 	VARCHAR2(10 CHAR) := '02';
	
	-- Registro completo del gasto pasado como parámetro
	
	 TYPE GASTO IS RECORD 
	 (GPV_ID     			#ESQUEMA#.GPV_GASTOS_PROVEEDOR.GPV_ID%TYPE,
	  GPV_FECHA_EMISION	#ESQUEMA#.GPV_GASTOS_PROVEEDOR.GPV_FECHA_EMISION%TYPE,
	  GDE_IMPORTE_TOTAL		#ESQUEMA#.GDE_GASTOS_DETALLE_ECONOMICO.GDE_IMPORTE_TOTAL%TYPE
	 );  
		
	record_gasto 			GASTO;				
	
	-- Registro completo del gasto pasado como parámetro
	record_gasto_anterior	GASTO;
	
	-- Valor de la columna de alerta que añadiremos/modicaremos [0/1]
	v_alerta_value			#ESQUEMA#.AVG_AVISOS_GASTOS.AVG_INCR_IMPORTE%TYPE; 
	-- Usuario para INSERTS y UPDATES
	v_username 				#ESQUEMA#.AVG_AVISOS_GASTOS.USUARIOCREAR%TYPE := 'SP_UPDATE_AVG_INCR_IMPORTE';

	

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	
-- Buscamos el registro del gasto.

	SELECT GPV.GPV_ID,GPV.GPV_FECHA_EMISION, GDE.GDE_IMPORTE_TOTAL INTO record_gasto
	FROM  #ESQUEMA#.GPV_GASTOS_PROVEEDOR GPV
	INNER JOIN #ESQUEMA#.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
	INNER JOIN #ESQUEMA#.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = GPV.DD_STG_ID
	WHERE GPV.GPV_ID = p_gpv_id
	AND STG.DD_STG_CODIGO IN (v_stg_codigo_ibi_urbana,v_stg_codigo_ibi_rustica);
		
		
-- Buscamos el registro anterior.
	
	SELECT * INTO record_gasto_anterior
	FROM (SELECT GPV.GPV_ID,GPV.GPV_FECHA_EMISION, GDE.GDE_IMPORTE_TOTAL
	FROM #ESQUEMA#.GPV_GASTOS_PROVEEDOR GPV 
	INNER JOIN #ESQUEMA#.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
	INNER JOIN #ESQUEMA#.GPV_ACT GPVACT ON GPVACT.GPV_ID = GPV.GPV_ID
	INNER JOIN #ESQUEMA#.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = GPV.DD_STG_ID
	WHERE GPVACT.ACT_ID = (SELECT MAX(ACT_ID) FROM GPV_ACT WHERE GPV_ID =  record_gasto.GPV_ID)
	AND GPV.GPV_FECHA_EMISION < record_gasto.GPV_FECHA_EMISION
	AND STG.DD_STG_CODIGO IN (v_stg_codigo_ibi_urbana,v_stg_codigo_ibi_rustica)
	AND GPV.GPV_ID != record_gasto.GPV_ID ORDER BY GPV.GPV_FECHA_EMISION DESC)
	WHERE ROWNUM = 1;	
	
	IF (record_gasto.GDE_IMPORTE_TOTAL > (record_gasto_anterior.GDE_IMPORTE_TOTAL + (record_gasto_anterior.GDE_IMPORTE_TOTAL * 5 / 100)) ) THEN
   	-- Alerta Incremento importe a 1
   		DBMS_OUTPUT.PUT_LINE('[GASTO ' || p_gpv_id || '] El gasto anterior cumple los requisitos');
           	v_alerta_value:=1;
        ELSE
  	-- Alerta Incremento importe a 0
   	DBMS_OUTPUT.PUT_LINE('[GASTO ' || p_gpv_id || '] No existe gasto anterior o no cumple los requisitos');
   	v_alerta_value:=0;
	       
	END IF;
	    
-- Intentamos actualizar la alerta 
	UPDATE #ESQUEMA#.AVG_AVISOS_GASTOS SET 
	AVG_INCR_IMPORTE=v_alerta_value, 
	USUARIOMODIFICAR = v_username,
	FECHAMODIFICAR = SYSDATE
	WHERE GPV_ID = p_gpv_id;
	    
-- Si no ha encontrado alertas, la creamos solamente si es activa 
	IF(SQL%ROWCOUNT=0) THEN
		IF(v_alerta_value=1) THEN
			INSERT INTO #ESQUEMA#.AVG_AVISOS_GASTOS(AVG_ID,GPV_ID,AVG_INCR_IMPORTE,USUARIOCREAR,FECHACREAR) values
    		(#ESQUEMA#.S_AVG_AVISOS_GASTOS.nextval,p_gpv_id,v_alerta_value,v_username,SYSDATE);
    		DBMS_OUTPUT.PUT_LINE('[GASTO ' || p_gpv_id || '] Insertamos alerta Incremento importe con el valor ' || v_alerta_value);
    	END IF;
	    	
    ELSE 
    	DBMS_OUTPUT.PUT_LINE('[GASTO ' || p_gpv_id || '] Modificada alerta Incremento importe con el valor ' || v_alerta_value);
	END IF;
 		
	DBMS_OUTPUT.PUT_LINE('[TERMINADO]');
	
	
COMMIT;

EXCEPTION
 	WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.put_line ('ERROR: No existe el gasto o no tiene gastos anteriores.');
	WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END UPDATE_AVG_INCR_IMPORTE;
/
EXIT;

