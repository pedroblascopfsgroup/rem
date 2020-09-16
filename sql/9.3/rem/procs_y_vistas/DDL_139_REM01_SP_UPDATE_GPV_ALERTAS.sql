--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20170927
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2555
--## PRODUCTO=NO
--## Finalidad: Actualiza el flag de alertas en un gasto o en todos
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - Jose Villel
--##        0.2 Se modifica where para obtener valor dinamico
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

-- Parámetros de entrada --------------------------------------------------------------------------------------------------
-- p_gasto_id, 		id del gasto a actualizar (si viene a null, los actualizará todos)
-- ------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE UPDATE_GPV_ALERTAS (
   p_gpv_id       	IN #ESQUEMA#.gpv_gastos_proveedor.gpv_id%TYPE
)
AUTHID CURRENT_USER IS

	-- Declaración de variables

	v_sql						VARCHAR2(1000 CHAR); 
	-- Usuario para INSERTS y UPDATES
	v_username 					VARCHAR2(100 CHAR) := 'SP_UPDATE_GPV_ALERTAS';
	-- Select para hacer el mergE.
	v_merge_select_all_gpv		VARCHAR2(1000 CHAR) := 'SELECT GPV_ID,
														CASE WHEN NVL(AVG_COMPRADOR,0) + NVL(AVG_IBI_EXENTO,0) + NVL(AVG_IMPUESTO,0) + NVL(AVG_PRIMER_PAGO,0) + NVL(AVG_INCR_IMPORTE,0) + NVL(AVG_DIF_IMPORTE,0) + NVL(AVG_PROVEEDOR_BAJA,0) + NVL(AVG_PROVEEDOR_SINSALDO,0) + NVL(AVG_SIN_PER_ADMINISTRACION,0) > 0 THEN 1 
														ELSE 0 END AS TIENE_ALGUNA_ALERTA
														FROM #ESQUEMA#.AVG_AVISOS_GASTOS';
	
	v_where_gpv_selected 		VARCHAR2(100 CHAR) := ' WHERE GPV_ID = '||p_gpv_id;

	
	TYPE GASTOS_REF IS REF CURSOR;
	crs_gastos GASTOS_REF;


BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- Si solamente vamos a actualizar un gasto, añadimos el where a la select del merge 
	IF(p_gpv_id IS NOT NULL ) THEN 
	
		v_merge_select_all_gpv := v_merge_select_all_gpv || v_where_gpv_selected;
	
	END IF;
	
	v_sql :=	'MERGE INTO #ESQUEMA#.GPV_GASTOS_PROVEEDOR GPV ' ||	
				'USING('||v_merge_select_all_gpv||') AVISOS ' ||
				'ON (AVISOS.GPV_ID = GPV.GPV_ID) ' ||
				'WHEN MATCHED THEN ' ||
				'UPDATE SET ' ||
				'GPV.GPV_ALERTAS = AVISOS.TIENE_ALGUNA_ALERTA,' ||
				'GPV.FECHAMODIFICAR = SYSDATE,' ||
				'GPV.USUARIOMODIFICAR = ''' || v_username||'''';
	
	EXECUTE IMMEDIATE v_sql;
	

	DBMS_OUTPUT.PUT_LINE('[NUMERO DE GASTOS MODIFICADOS: '|| SQL%ROWCOUNT||']');
	
	
COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END UPDATE_GPV_ALERTAS;
/
EXIT;
	


