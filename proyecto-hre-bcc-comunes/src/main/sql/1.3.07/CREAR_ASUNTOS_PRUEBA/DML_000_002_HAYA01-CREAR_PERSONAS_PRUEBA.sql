--##########################################
--## Author: RAFA
--## Finalidad: DML para crear PERSONAS de prueba
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
          ( SELECT CODIGO_PROCEDIMIENTO FROM CNV_AUX_ALTA_PRC_PER);
		--where fila<51;
		--50 asuntos
		
	
    
BEGIN	  
	
	TOTAL_INSERTS := 0;
	
	FOR procedimientos in todos_los_procedimientos
	LOOP
        V_MSQL1:='Insert into CNV_AUX_ALTA_PRC_PER (CODIGO_PROCEDIMIENTO,CODIGO_PROPIETARIO,CODIGO_PERSONA,NUMERO_CLIENTE_NUSE,TIPO_PERSONA,TIPO_DOCUMENTO,NIF_CIF_PASAP_NIE,NOMBRE,NOM_COMPLETO,APELLIDO1,APELLIDO2,FECHA_PROCESO,REL_PER_PDM) values ('|| procedimientos.codigo_procedimiento_nuse ||',''0'',''238414734'',''14678237'',''1'',''D'',''011366678D'',''JORGE LUIS'',''JORGE LUIS ESTRADA GRANDA'',''ESTRADA'',''GRANDA'',to_date(''11/01/15'',''DD/MM/RR''),''FIA'')';
        V_MSQL2:='Insert into CNV_AUX_ALTA_PRC_PER (CODIGO_PROCEDIMIENTO,CODIGO_PROPIETARIO,CODIGO_PERSONA,NUMERO_CLIENTE_NUSE,TIPO_PERSONA,TIPO_DOCUMENTO,NIF_CIF_PASAP_NIE,NOMBRE,NOM_COMPLETO,APELLIDO1,APELLIDO2,FECHA_PROCESO,REL_PER_PDM) values ('|| procedimientos.codigo_procedimiento_nuse ||',''0'',''242021764'',''14685159'',''1'',''D'',''071892402Z'',''GUILLERMO'',''GUILLERMO ESTRADA GARCIA'',''ESTRADA'',''GARCIA'',to_date(''11/01/15'',''DD/MM/RR''),''TIT'')';
        V_MSQL3:='Insert into CNV_AUX_ALTA_PRC_PER (CODIGO_PROCEDIMIENTO,CODIGO_PROPIETARIO,CODIGO_PERSONA,NUMERO_CLIENTE_NUSE,TIPO_PERSONA,TIPO_DOCUMENTO,NIF_CIF_PASAP_NIE,NOMBRE,NOM_COMPLETO,APELLIDO1,APELLIDO2,FECHA_PROCESO,REL_PER_PDM) values ('|| procedimientos.codigo_procedimiento_nuse ||',''0'',''97064380'',''11591965'',''1'',''D'',''034876454J'',''MIGUEL ANGEL'',''MIGUEL ANGEL CASTRO IGLESIAS'',''CASTRO'',''IGLESIAS'',to_date(''11/01/15'',''DD/MM/RR''),''TIT'')';
		
			  
							
				--DBMS_OUTPUT.PUT_LINE(V_MSQL1);
				EXECUTE IMMEDIATE V_MSQL1;
        
        --DBMS_OUTPUT.PUT_LINE(V_MSQL2);
        EXECUTE IMMEDIATE V_MSQL2;
        
        --DBMS_OUTPUT.PUT_LINE(V_MSQL3);
        EXECUTE IMMEDIATE V_MSQL3;
								
												
				

	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('PERSONAS ASIGNADAS A NUEVOS PROCEDIMIENTOS.');
	
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
