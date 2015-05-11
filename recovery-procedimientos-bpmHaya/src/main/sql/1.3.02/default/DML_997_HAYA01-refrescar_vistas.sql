/*
--######################################################################
--## Author: Roberto
--## Finalidad: refrescar vistas materializadas
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
declare
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    
begin

	V_MSQL := 'alter materialized view "HAYA01"."VTAR_ASU_VS_USU"'
				|| 'REFRESH COMPLETE ON DEMAND '
				|| '	START WITH sysdate+1 '
				|| '	NEXT sysdate+1 +  4/24 ';
	
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 				
	
	V_MSQL := 'alter materialized view "HAYA01"."VTAR_ASUNTO_GESTOR" '
				|| 'REFRESH COMPLETE ON DEMAND '
				|| 'START WITH sysdate+1 '
				|| 'NEXT sysdate+1 +  5/24 ';
				
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 				
	
	V_MSQL := 'alter materialized view "HAYA01"."V_TAREA_USUPENDIENTE"  '
				|| 'REFRESH COMPLETE ON DEMAND  '
				|| 'START WITH sysdate+1 '
				|| 'NEXT sysdate+1 +  6/24 ';
				
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 				
	
	V_MSQL := 'alter materialized view "HAYA01"."V42_BUSQUEDA_TAREAS" ' 
				|| 'REFRESH COMPLETE ON DEMAND ' 
				|| 'START WITH sysdate+1 '
				|| 'NEXT sysdate+1 +  7/24 ';	
				
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
  
  commit;
	
  DBMS_MVIEW.REFRESH ('VTAR_ASU_VS_USU');  
  commit;
  
  DBMS_MVIEW.REFRESH ('VTAR_ASUNTO_GESTOR');
  commit;
  
  DBMS_MVIEW.REFRESH ('V_TAREA_USUPENDIENTE');
  commit;
  
  DBMS_MVIEW.REFRESH ('V42_BUSQUEDA_TAREAS');
  commit;
  
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
end;
/

EXIT;