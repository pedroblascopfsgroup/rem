--##########################################
--## Author: Roberto
--## Finalidad: DML para crear BIENES de prueba
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_MSQL2 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
    V_MSQL3 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    TOTAL_INSERTS NUMBER(3); -- Variable para controlar el número de inserts realizados
    
    --procedimientos  que no existen en la tabla personas
	CURSOR todos_los_procedimientos is 
		SELECT codigo_procedimiento_nuse FROM CNV_AUX_ALTA_PRC 
    WHERE CODIGO_PROCEDIMIENTO_NUSE
    NOT IN 
          ( SELECT CODIGO_PROCEDIMIENTO_NUSE FROM CNV_AUX_ALTA_PRC_BIE);
		--where fila<51;
		--50 asuntos
		
	
    
BEGIN	  
	
	TOTAL_INSERTS := 0;
	
	FOR procedimientos in todos_los_procedimientos
	LOOP

		V_MSQL1:='Insert into CNV_AUX_ALTA_PRC_BIE (CODIGO_PROCEDIMIENTO_NUSE,ID_BIEN_NUSE,CD_BIEN,NUMERO_FINCA,COD_POSTAL,LOCALIDAD,NUMERO_REGISTRO,PLAZA_REGISTRO,DESCRIPCION,CODIGO_SITUACION_BIEN,FECHA_PROCESO) values ('|| procedimientos.codigo_procedimiento_nuse ||',''8012787'',''0'',''00002207'',''08000'',''GELIDA'',''132'',''MARTORELL'',''SALVADOR ESPRIU, 2'',''OT05'',to_date(''11/01/15'',''DD/MM/RR''))';


		V_MSQL2:='Insert into CNV_AUX_ALTA_PRC_BIE (CODIGO_PROCEDIMIENTO_NUSE,ID_BIEN_NUSE,CD_BIEN,NUMERO_FINCA,COD_POSTAL,LOCALIDAD,NUMERO_REGISTRO,PLAZA_REGISTRO,DESCRIPCION,CODIGO_SITUACION_BIEN,FECHA_PROCESO) values ('|| procedimientos.codigo_procedimiento_nuse ||',''8107847'',''0'',''00002207'',''08000'',''GELIDA'',''003'',''MARTORELL'',''SALVADOR ESPRIU, 2'',''OT05'',to_date(''11/01/15'',''DD/MM/RR''))';


		V_MSQL3:='Insert into CNV_AUX_ALTA_PRC_BIE (CODIGO_PROCEDIMIENTO_NUSE,ID_BIEN_NUSE,CD_BIEN,NUMERO_FINCA,COD_POSTAL,LOCALIDAD,NUMERO_REGISTRO,PLAZA_REGISTRO,DESCRIPCION,CODIGO_SITUACION_BIEN,FECHA_PROCESO) values ('|| procedimientos.codigo_procedimiento_nuse ||',''8124295'',''0'',''00002207'',null,null,''003'',''Martorell'',''SALVADOR ESPRIU, 2'',''OT05'',to_date(''11/01/15'',''DD/MM/RR''))';		
			  
							
		--DBMS_OUTPUT.PUT_LINE(V_MSQL1);
		EXECUTE IMMEDIATE V_MSQL1;
		
		--DBMS_OUTPUT.PUT_LINE(V_MSQL2);
		EXECUTE IMMEDIATE V_MSQL2;
		
		--DBMS_OUTPUT.PUT_LINE(V_MSQL3);
		EXECUTE IMMEDIATE V_MSQL3;
																								
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('BIENES ASIGNADOS A NUEVOS PROCEDIMIENTOS.');
	
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('El proceso ha finalizado correctamente.');
	
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
