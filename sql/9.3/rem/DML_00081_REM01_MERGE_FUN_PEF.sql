--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20200123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9213
--## PRODUCTO=NO
--##
--## Finalidad: Modificar perfiles de edición de la funcion EDITAR_GRID_PUBLICACION_HISTORICO_MEDIADORES.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_SQL VARCHAR2(4000 CHAR);
    V_MSQL VARCHAR2(4000 CHAR);
    V_MSQL_1 VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_PERFIL IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    TYPE T_ARRAY_PERFILES IS TABLE OF T_PERFIL;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('EDITAR_GRID_PUBLICACION_HISTORICO_MEDIADORES')
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_TMP_PERFIL T_PERFIL;
    -- ARRAY DE PERFILES para otorgales los permisos o '%'
    V_PERFILES T_ARRAY_PERFILES := T_ARRAY_PERFILES(
	T_PERFIL('SUPERPLANIF'),
	T_PERFIL('HAYASUPER')
    );

BEGIN

        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_PEF... Empezando a modificar datos en la tabla');
    
    	V_MSQL := '
		MERGE INTO '||V_ESQUEMA||'.fun_pef fp
		    USING (select fp_id
			      from '||V_ESQUEMA||'.fun_pef fp
			    where exists (select 1 
				            from '||V_ESQUEMA_M||'.fun_funciones fun
				            where fun.fun_descripcion = ''EDITAR_GRID_PUBLICACION_HISTORICO_MEDIADORES''
				            and fun.fun_id= fp.fun_id
				         )
			     and exists (select 1
				            from '||V_ESQUEMA||'.pef_perfiles pef
				            where pef.pef_codigo not in (''SUPERPLANIF'',''HAYASUPER'')
				            and pef.pef_id = fp.pef_id
				         )
			     and fp.BORRADO = 0) aux
		    ON (fp.fp_id = aux.fp_id)
		  WHEN MATCHED THEN
		    UPDATE 
		       SET fp.BORRADO = 1
			  ,fp.usuarioborrar = ''HREOS-9213''
			  ,fp.fechaborrar = sysdate	
		 ';
        
        execute immediate v_msql;

	DBMS_OUTPUT.PUT_LINE('[INFO] FUN_PEF registros borrados: ' || sql%rowcount);

	-- LOOP Insertando valores en FUN_PEF
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_PEF... Empezando a insertar datos en la tabla');
    
    	FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
    	LOOP
            V_TMP_FUNCION := V_FUNCION(I);
            
            FOR I IN V_PERFILES.FIRST .. V_PERFILES.LAST
		LOOP
    		
			V_TMP_PERFIL := V_PERFILES(I);            
    			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_PERFIL(1))||''') AND FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''')';
				
    		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			-- Si existe la FUNCION PARA EL PERFIL
			IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_PEF... Ya existe la relacion entre '''|| TRIM(V_TMP_FUNCION(1))||''' y '''||TRIM(V_TMP_PERFIL(1))||'''');
			ELSE
				V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
					' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT FUN.FUN_ID, PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''HREOS-9213'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA||'.PEF_PERFILES, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
					' WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''' AND PEF_CODIGO LIKE ('''||TRIM(V_TMP_PERFIL(1))||''') ';

				EXECUTE IMMEDIATE V_MSQL_1;
				DBMS_OUTPUT.PUT_LINE('[INFO] ' ||sql%rowcount|| 'Datos en la tabla '||V_ESQUEMA||'.FUN_PEF insertados correctamente.');	
			END IF;	
		END LOOP;
    	END LOOP; 

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
