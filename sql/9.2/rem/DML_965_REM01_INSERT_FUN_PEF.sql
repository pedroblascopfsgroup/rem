--/*
--##########################################
--## AUTOR=Alejandro Valverde Herrera
--## FECHA_CREACION=20180720
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4293
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade a un perfil o a todos los perfiles, las funciones añadidas en T_ARRAY_FUNCION.
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_PERFIL IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    TYPE T_ARRAY_PERFILES IS TABLE OF T_PERFIL;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('TAB_ACTIVO_PRECIOS'),
      T_FUNCION('TAB_ACTIVO_PUBLICACION'),
      T_FUNCION('TAB_ACTIVO_COMERCIAL'),
      T_FUNCION('TAB_ACTIVO_ADMINISTRACION'),
      T_FUNCION('TAB_DATOS_BASICOS_ACTIVO'),
      T_FUNCION('TAB_FOTOS_ACTIVO_WEB'),
      T_FUNCION('TAB_FOTOS_ACTIVO_TECNICAS'),
      T_FUNCION('TAB_CHECKING_INFO_ADMISION'),
      T_FUNCION('TAB_CHECKING_DOC_ADMISION'),
      T_FUNCION('TAB_HIST_PETICIONES'),
      T_FUNCION('TAB_PRESUPUESTO_ASIGNADO_ACTIVO'),
      T_FUNCION('TAB_VALORACIONES_PRECIOS'),
      T_FUNCION('TAB_TASACIONES'),
      T_FUNCION('TAB_PROPUESTAS_PRECIO'),
      T_FUNCION('TAB_INFO_COMERCIAL_PUBLICACION'),
      T_FUNCION('TAB_DATOS_PUBLICACION'),
      T_FUNCION('TAB_COMERCIAL_VISITAS'),
      T_FUNCION('TAB_COMERCIAL_OFERTAS'),
      T_FUNCION('TAB_DATOS_GENERALES_TRAMITE'),
      T_FUNCION('TAB_TAREAS_TRAMITE'),
      T_FUNCION('TAB_HISTORICO_TAREAS_TRAMITE'),
      T_FUNCION('TAB_ACTIVOS_TRAMITE'),
      T_FUNCION('TAB_AGRUPACION'),
      T_FUNCION('TAB_LISTA_ACTIVOS_AGRUPACION'),
      T_FUNCION('TAB_FOTOS_AGRUPACION'),
      T_FUNCION('TAB_OBSERVACIONES_AGRUPACION'),
      T_FUNCION('TAB_DOCUMENTOS_AGRUPACION'),
      T_FUNCION('TAB_SEGUIMIENTO_AGRUPACION'),
      T_FUNCION('TAB_SUBDIVISIONES_AGRUPACION'),
      T_FUNCION('TAB_COMERCIAL_AGRUPACION'),
      T_FUNCION('TAB_FICHA_TRABAJO'),
      T_FUNCION('TAB_ACTIVOS_TRABAJO'),
      T_FUNCION('TAB_TRAMITES_TRABAJO'),
      T_FUNCION('TAB_DIARIO_GESTIONES_TRABAJO'),
      T_FUNCION('TAB_FOTOS_TRABAJO'),
      T_FUNCION('TAB_FOTOS_SOLICITANTE_TRABAJO'),
      T_FUNCION('TAB_FOTOS_PROVEEDOR_TRABAJO'),
      T_FUNCION('TAB_DOCUMENTOS_TRABAJO'),
      T_FUNCION('TAB_GESTION_ECONOMICA_TRABAJO'),
      T_FUNCION('TAB_GENERACION_PROPUESTAS_PRECIO'),
      T_FUNCION('TAB_INCLUSION_AUTOMATICA_PRECIOS'),
      T_FUNCION('TAB_SELECCION_MANUAL_PRECIOS'),
      T_FUNCION('TAB_HISTORICO_PROPUESTA_PRECIOS'),
      T_FUNCION('TAB_PUBLICACION_ACTIVOS'),
      T_FUNCION('TAB_CONFIGURACION_PUBLICACION'),
      T_FUNCION('TAB_VISITAS_COMERCIAL'),
      T_FUNCION('TAB_OFERTAS_COMERCIAL'),
      T_FUNCION('TAB_DATOS_BASICOS_EXPEDIENTES'),
      T_FUNCION('TAB_OFERTA_EXPEDIENTES'),
      T_FUNCION('TAB_DATOS_BASICOS_OFERTA_EXPEDIENTES'),
      T_FUNCION('TAB_CONDICIONES_EXPEDIENTES'),
      T_FUNCION('TAB_ACTIVOS_COMERCIALIZABLES_EXPEDIENTES'),
      T_FUNCION('TAB_RESERVA_EXPEDIENTES'),
      T_FUNCION('TAB_COMPRADORES_EXPEDIENTES'),
      T_FUNCION('TAB_DIARIO_GESTIONES_EXPEDIENTES'),
      T_FUNCION('TAB_TRÁMITES_EXPEDIENTES'),
      T_FUNCION('TAB_DOCUMENTOS_EXPEDIENTES'),
      T_FUNCION('TAB_FORMALIZACION_EXPEDIENTES'),
      T_FUNCION('TAB_GESTION_ECONOMICA_EXPEDIENTES'),
      T_FUNCION('TAB_GESTION_GASTOS_ADMINISTRACION'),
      T_FUNCION('TAB_GESTION_PROVISIONES_ADMINISTRACION'),
      T_FUNCION('TAB_DATOS_GENERALES_GASTOS'),
      T_FUNCION('TAB_DETALLE_ECONOMICO_GASTOS'),
      T_FUNCION('TAB_ACTIVOS_AFECTADOS_GASTOS'),
      T_FUNCION('TAB_CONTABILIDAD_GASTOS'),
      T_FUNCION('TAB_GESTION_GASTOS'),
      T_FUNCION('TAB_IMPUGNACION_GASTOS'),
      T_FUNCION('TAB_DOCUMENTOS'),
      T_FUNCION('TAB_ADMINISTRACION_CONFIGURACION'),
      T_FUNCION('TAB_PROVEEDORES'),
      T_FUNCION('TAB_DATOS_PROVEEDORES'),
      T_FUNCION('TAB_TANTEO_RETRACTO_OFERTA_EXPEDIENTES'),
      T_FUNCION('TAB_GASTOS_ADMINISTRACION'),
      T_FUNCION('TAB_MEDIADORES'),
      T_FUNCION('TAB_DOCUMENTOS_PROVEEDORES'),
      T_FUNCION('MENU_PRECIOS'),
      T_FUNCION('MENU_PUBLICACION'),
      T_FUNCION('MENU_COMERCIAL'),
      T_FUNCION('MENU_ADMINISTRACION'),
      T_FUNCION('MENU_AGENDA'),
      T_FUNCION('MENU_ACTIVOS'),
      T_FUNCION('MENU_AGRUPACIONES'),
      T_FUNCION('MENU_TRABAJOS'),
      T_FUNCION('MENU_MASIVO'),
      T_FUNCION('MENU_TOP_TAREAS'),
      T_FUNCION('MENU_TOP_ALERTAS'),
      T_FUNCION('MENU_TOP_AVISOS'),
      T_FUNCION('MENU_TOP_AVISOS'),
      T_FUNCION('MENU_CONFIGURACION')
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_TMP_PERFIL T_PERFIL;
    -- ARRAY DE PERFILES para otorgales los permisos o '%'
    V_PERFILES T_ARRAY_PERFILES := T_ARRAY_PERFILES(
      T_PERFIL('GESTIAFORM'), -- Gestoria de formalizacion.
      T_PERFIL('GESTCOMBACKOFFICE') -- Gestor comercial de back office.
    );   
    V_MSQL_1 VARCHAR2(4000 CHAR);

BEGIN	
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
						DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... Ya existe la funcion '''|| TRIM(V_TMP_FUNCION(1))||'''');
					ELSE
						V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
							' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
							' SELECT FUN.FUN_ID, PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''HREOS-4293'', SYSDATE, 0' ||
							' FROM '||V_ESQUEMA||'.PEF_PERFILES, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
							' WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''' AND PEF_CODIGO LIKE ('''||TRIM(V_TMP_PERFIL(1))||''') ';
		    	
						EXECUTE IMMEDIATE V_MSQL_1;
					END IF;
					DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.FUN_PEF insertados correctamente.');		
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
