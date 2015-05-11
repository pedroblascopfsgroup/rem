/*
--######################################################################
--## Author: Roberto
--## Finalidad: eliminar datos del diccionario DD_EAD_ENTIDAD_ADJUDICA
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

	V_MSQL := 'update BIE_ADJ_ADJUDICACION '
				|| ' set dd_ead_id=(select dd_ead_id from DD_EAD_ENTIDAD_ADJUDICA where dd_ead_descripcion=''Entidad'') ' 
				|| ' where dd_ead_id=(select dd_ead_id from DD_EAD_ENTIDAD_ADJUDICA where dd_ead_codigo=''BAN'') ';
	
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 				
	
	V_MSQL := 'update BIE_ADJ_ADJUDICACION '
				|| ' set dd_ead_id=(select dd_ead_id from DD_EAD_ENTIDAD_ADJUDICA '
				|| ' where dd_ead_descripcion=''Terceros'') where dd_ead_id in (select dd_ead_id from DD_EAD_ENTIDAD_ADJUDICA where dd_ead_descripcion not in (''Entidad'') )';
				
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 				
	
	V_MSQL := 'delete from DD_EAD_ENTIDAD_ADJUDICA where dd_ead_codigo in (''FON'',''BAN'',''SAR'',''TER'')';
				
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 					

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