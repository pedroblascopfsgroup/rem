--/*
--##########################################
--## AUTOR=Alejandro Valverde Herrera
--## FECHA_CREACION=20180625
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4214
--## PRODUCTO=NO
--##
--## Finalidad: Script que borra  añade a un perfil o a todos los perfiles, las funciones añadidas en T_ARRAY_FUNCION.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

BEGIN	
    -- LOOP Insertando valores en FUN_PEF
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_PEF... Empezando a insertar datos en la tabla');
    
    V_MSQL := '
	MERGE INTO '||V_ESQUEMA||'.fun_pef fp
	    USING (select fp_id
		      from '||V_ESQUEMA||'.fun_pef fp
		    where exists (select 1 
		                    from '||V_ESQUEMA_M||'.fun_funciones fun
		                    where fun.fun_descripcion in (''EDITAR_GRID_PRECIOS_VIGENTES'',''EDITAR_GRID_PUBLICACION_HISTORICO_MEDIADORES'',''EDITAR_GRID_PUBLICACION_CONDICIONES_ESPECIFICAS'')
		                    and fun.fun_id= fp.fun_id
		                 )
		     and exists (select 1
		                  from '||V_ESQUEMA||'.pef_perfiles pef
		                  where pef.pef_codigo in (''PERFGCCLIBERBANK'',''PERFGCCBANKIA'')
		                   and pef.pef_id = fp.pef_id
		                )
		     and fp.BORRADO = 0) aux
	    ON (fp.fp_id = aux.fp_id)
	  WHEN MATCHED THEN
	    UPDATE 
	       SET fp.BORRADO = 1
		  ,fp.usuarioborrar = ''HREOS-4214''
		  ,fp.fechaborrar = sysdate		
         ';
        
        execute immediate v_msql;
		
	COMMIT;

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
