--/*
--##########################################
--## AUTOR=Alejandro Valverde Herrera
--## FECHA_CREACION=20180720
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4293
--## PRODUCTO=NO
--##
--## Finalidad: Script que crea las funciones añadidas en T_ARRAY_FUNCION.
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
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    --						Descripción Larga																							Descripción
      T_FUNCION('Permite editar la tab de documentos del activo',																'EDITAR_TAB_ACTIVO_DOCUMENTOS'),
      T_FUNCION('Permite acceder a la tab de gestores del activo',																'TAB_ACTIVO_PRECIOS'),
      T_FUNCION('Permite acceder a la tab de publicación del activo',															'TAB_ACTIVO_PUBLICACION'),
      T_FUNCION('Permite acceder a la tab comercial del activo',																'TAB_ACTIVO_COMERCIAL'),
      T_FUNCION('Permite acceder a la tab de administración del activo',														'TAB_ACTIVO_ADMINISTRACION'),
      T_FUNCION('Permite acceder a la tab de datos básicos de la tab datos generales del activo',								'TAB_DATOS_BASICOS_ACTIVO'),
      T_FUNCION('Permite editar la tab de cargas de la tab datos generales del activo',											'EDITAR_TAB_ACTIVO_CARGAS'),
      T_FUNCION('Permite editar la tab de fotos web de la tab fotos del activo',												'EDITAR_TAB_FOTOS_ACTIVO_WEB'),
      T_FUNCION('Permite acceder a la tab de fotos web de la tab fotos del activo',												'TAB_FOTOS_ACTIVO_WEB'),
      T_FUNCION('Permite editar la tab de fotos técnicas de la tab fotos del activo',											'EDITAR_TAB_FOTOS_ACTIVO_TECNICAS'),
      T_FUNCION('Permite acceder a la tab de fotos técnicas de la tab admisión del activo',										'TAB_FOTOS_ACTIVO_TECNICAS'),
      T_FUNCION('Permite acceder a la tab de check de información de la tab admisión del activo',								'TAB_CHECKING_INFO_ADMISION'),
      T_FUNCION('Permite acceder a la tab de check de documentos de la tab admisión del activo',								'TAB_CHECKING_DOC_ADMISION'),
      T_FUNCION('Permite acceder a la tab de historico peticiones de la tab gestión del activo',								'TAB_HIST_PETICIONES'),
      T_FUNCION('Permite acceder a la tab de presupuesto asignado de la tab gestión del activo',								'TAB_PRESUPUESTO_ASIGNADO_ACTIVO'),
      T_FUNCION('Permite editar la tab de valoraciones precios de la tab precios del activo',									'EDITAR_TAB_VALORACIONES_PRECIOS'),
      T_FUNCION('Permite acceder a la tab de valoraciones precios de la tab precios del activo',								'TAB_VALORACIONES_PRECIOS'),
      T_FUNCION('Permite editar la tab de tasaciones de la tab precios del activo',												'EDITAR_TAB_TASACIONES'),
      T_FUNCION('Permite acceder a la tab de tasaciones de la tab precios del activo',											'TAB_TASACIONES'),
      T_FUNCION('Permite acceder a la tab de propuestas precio de la tab precios del activo',									'TAB_PROPUESTAS_PRECIO'),
      T_FUNCION('Permite editar la tab de info comercial de la tab publicación del activo',										'EDITAR_TAB_INFO_COMERCIAL_PUBLICACION'),
      T_FUNCION('Permite acceder a la tab de info comercial de la tab publicación del activo',									'TAB_INFO_COMERCIAL_PUBLICACION'),
      T_FUNCION('Permite editar la tab de datos publicación de la tab publicación del activo',									'EDITAR_TAB_DATOS_PUBLICACION'),
      T_FUNCION('Permite acceder a la tab de datos publicación de la tab publicación del activo',								'TAB_DATOS_PUBLICACION'),
      T_FUNCION('Permite acceder a la tab de visitas de la tab comercial del activo',											'TAB_COMERCIAL_VISITAS'),
      T_FUNCION('Permite acceder a la tab de ofertas de la tab comercial del activo',											'TAB_COMERCIAL_OFERTAS'),
      T_FUNCION('Permite acceder a la tab de datos generales del trámite',														'TAB_DATOS_GENERALES_TRAMITE'),
	  T_FUNCION('Permite acceder a la tab de tareas del trámite',																'TAB_TAREAS_TRAMITE'),
	  T_FUNCION('Permite acceder a la tab de histórico tareas del trámite',														'TAB_HISTORICO_TAREAS_TRAMITE'),
	  T_FUNCION('Permite acceder a la tab de activo del trámite',																'TAB_ACTIVOS_TRAMITE'),
	  T_FUNCION('Permite acceder a la tab de ficha agrupación de la agrupación',												'TAB_AGRUPACION'),
	  T_FUNCION('Permite editar la tab de listado activos de la agrupación',													'EDITAR_TAB_LISTA_ACTIVOS_AGRUPACION'),
	  T_FUNCION('Permite acceder a la tab de listado activos de la agrupación',													'TAB_LISTA_ACTIVOS_AGRUPACION'),
	  T_FUNCION('Permite acceder a la tab de fotos de la agrupación',															'TAB_FOTOS_AGRUPACION'),
	  T_FUNCION('Permite editar la tab de observaciones de la agrupación',														'EDITAR_TAB_OBSERVACIONES_AGRUPACION'),
	  T_FUNCION('Permite acceder a la tab de observaciones de la agrupación',													'TAB_OBSERVACIONES_AGRUPACION'),
	  T_FUNCION('Permite editar la tab de documentos de la agrupación',														'EDITAR_TAB_DOCUMENTOS_AGRUPACION'),
	  T_FUNCION('Permite acceder a la tab de documentos de la agrupación',													'TAB_DOCUMENTOS_AGRUPACION'),
	  T_FUNCION('Permite editar la tab de seguimiento de la agrupación',														'EDITAR_TAB_SEGUIMIENTO_AGRUPACION'),
	  T_FUNCION('Permite acceder a la tab de seguimiento de la agrupación',													'TAB_SEGUIMIENTO_AGRUPACION'),
	  T_FUNCION('Permite acceder a la tab de subdivisiones de la agrupación',													'TAB_SUBDIVISIONES_AGRUPACION'),
	  T_FUNCION('Permite editar la tab de comercial de la agrupación',															'EDITAR_TAB_COMERCIAL_AGRUPACION'),
	  T_FUNCION('Permite acceder a la tab de comercial de la agrupación',														'TAB_COMERCIAL_AGRUPACION'),
	  T_FUNCION('Permite acceder a la tab de ficha del trabajo',																'TAB_FICHA_TRABAJO'),
	  T_FUNCION('Permite acceder a la tab de listado activos del trabajo',														'TAB_ACTIVOS_TRABAJO'),
	  T_FUNCION('Permite editar la tab de trámites del trabajo',																'EDITAR_TAB_TRAMITES_TRABAJO'),
	  T_FUNCION('Permite acceder a la tab de trámites del trabajo',																'TAB_TRAMITES_TRABAJO'),
	  T_FUNCION('Permite editar la tab de diario gestiones del trabajo',														'EDITAR_TAB_DIARIO_GESTIONES_TRABAJO'),
	  T_FUNCION('Permite acceder a la tab de diario gestiones del trabajo',														'TAB_DIARIO_GESTIONES_TRABAJO'),
	  T_FUNCION('Permite acceder a la tab de fotos del trabajo',																'TAB_FOTOS_TRABAJO'),
	  T_FUNCION('Permite acceder a la tab de fotos solicitante del trabajo',													'TAB_FOTOS_SOLICITANTE_TRABAJO'),
	  T_FUNCION('Permite editar la tab de fotos solicitante del trabajo',														'EDITAR_TAB_FOTOS_SOLICITANTE_TRABAJO'),
	  T_FUNCION('Permite acceder a la tab de fotos proveedor del trabajo',														'TAB_FOTOS_PROVEEDOR_TRABAJO'),
	  T_FUNCION('Permite editar la tab de ficha del trabajo',																	'EDITAR_TAB_FOTOS_PROVEEDOR_TRABAJO'),
	  T_FUNCION('Permite editar la tab de documentos del trabajo',																'EDITAR_TAB_DOCUMENTOS_TRABAJO'),
	  T_FUNCION('Permite acceder a la tab de documentos del trabajo',															'TAB_DOCUMENTOS_TRABAJO'),
	  T_FUNCION('Permite acceder a la tab de gestión económica del trabajo',													'TAB_GESTION_ECONOMICA_TRABAJO'),
	  T_FUNCION('Permite acceder a la tab de generación propuestas precios de precios',											'TAB_GENERACION_PROPUESTAS_PRECIO'),
	  T_FUNCION('Permite acceder a la tab de inclusión automática de la tab generación propuestas precios de precios',			'TAB_INCLUSION_AUTOMATICA_PRECIOS'),
	  T_FUNCION('Permite acceder a la tab de selección manual de la tab generación propuestas precios de precios',				'TAB_SELECCION_MANUAL_PRECIOS'),
	  T_FUNCION('Permite acceder a la tab de histórico propuestas precios de precios',											'TAB_HISTORICO_PROPUESTA_PRECIOS'),
	  T_FUNCION('Permite acceder a la tab de activos de publicación',															'TAB_PUBLICACION_ACTIVOS'),
	  T_FUNCION('Permite acceder a la tab de configuración de publicación',														'TAB_CONFIGURACION_PUBLICACION'),
	  T_FUNCION('Permite editar la tab de configuración de publicación',														'EDITAR_TAB_CONFIGURACION_PUBLICACION'),
	  T_FUNCION('Permite acceder a la tab de visitas de comercial',																'TAB_VISITAS_COMERCIAL'),
	  T_FUNCION('Permite acceder a la tab de ofertas de comercial',																'TAB_OFERTAS_COMERCIAL'),
	  T_FUNCION('Permite acceder a la tab de datos básicos del expediente',														'TAB_DATOS_BASICOS_EXPEDIENTES'),
	  T_FUNCION('Permite editar la tab de datos básicos del expediente',														'EDITAR_TAB_DATOS_BASICOS_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de oferta del expediente',															'TAB_OFERTA_EXPEDIENTES'),
	  T_FUNCION('Permite editar la tab de datos básicos de la tab oferta del expediente',										'EDITAR_TAB_DATOS_BASICOS_OFERTA_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de datos básicos de la tab oferta del expediente',									'TAB_DATOS_BASICOS_OFERTA_EXPEDIENTES'),
	  T_FUNCION('Permite editar la tab de condiciones del expediente',															'EDITAR_TAB_CONDICIONES_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de condiciones del expediente',														'TAB_CONDICIONES_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de listado activos comercializables del expediente',									'TAB_ACTIVOS_COMERCIALIZABLES_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de reserva del expediente',															'TAB_RESERVA_EXPEDIENTES'),
	  T_FUNCION('Permite editar la tab de reserva del expediente',																'EDITAR_TAB_RESERVA_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de compradores del expediente',														'TAB_COMPRADORES_EXPEDIENTES'),
	  T_FUNCION('Permite editar la tab de compradores del expediente',															'EDITAR_TAB_COMPRADORES_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de diario gestiones del expediente',													'TAB_DIARIO_GESTIONES_EXPEDIENTES'),
	  T_FUNCION('Permite editar la tab de diario gestiones del expediente',														'EDITAR_TAB_DIARIO_GESTIONES_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de trámites del expediente',															'TAB_TRÁMITES_EXPEDIENTES'),
	  T_FUNCION('Permite editar a la tab de documentos del expediente',															'EDITAR_TAB_DOCUMENTOS_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de ddocumentosoc del expediente',														'TAB_DOCUMENTOS_EXPEDIENTES'),
	  T_FUNCION('Permite editar la tab de formalización del expediente',														'EDITAR_TAB_FORMALIZACION_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de formalización del expediente',														'TAB_FORMALIZACION_EXPEDIENTES'),
	  T_FUNCION('Permite editar la tab de gestión económica del expediente',													'EDITAR_TAB_GESTION_ECONOMICA_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de gestión económica del expediente',													'TAB_GESTION_ECONOMICA_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de tanteo retracto de la tab ofertas del expediente',									'EDITAR_TAB_TANTEO_RETRACTO_OFERTA_EXPEDIENTES'),
	  T_FUNCION('Permite editar la tab de tanteo retracto de la tab ofertas del expediente',									'TAB_TANTEO_RETRACTO_OFERTA_EXPEDIENTES'),
	  T_FUNCION('Permite acceder a la tab de gastos de administración',															'TAB_GASTOS_ADMINISTRACION'),
	  T_FUNCION('Permite acceder a la tab de gestión gastos de administración',													'TAB_GESTION_GASTOS_ADMINISTRACION'),
	  T_FUNCION('Permite acceder a la tab de gestión provisiones de administración',											'TAB_GESTION_PROVISIONES_ADMINISTRACION'),
	  T_FUNCION('Permite editar la tab de datos generales del gasto',															'EDITAR_TAB_DATOS_GENERALES_GASTOS'),
	  T_FUNCION('Permite acceder a la tab de datos generales del gasto',														'TAB_DATOS_GENERALES_GASTOS'),
	  T_FUNCION('Permite editar la tab de detalle económico del gasto',															'EDITAR_TAB_DETALLE_ECONOMICO_GASTOS'),
	  T_FUNCION('Permite acceder a la tab de detalle económico del gasto',														'TAB_DETALLE_ECONOMICO_GASTOS'),
	  T_FUNCION('Permite acceder a la tab de activos afectados del gasto',														'TAB_ACTIVOS_AFECTADOS_GASTOS'),
	  T_FUNCION('Permite acceder a la tab de contabilidad del gasto',															'TAB_CONTABILIDAD_GASTOS'),
	  T_FUNCION('Permite editar la tab de contabilidad del gasto',																'EDITAR_TAB_CONTABILIDAD_GASTOS'),
	  T_FUNCION('Permite acceder a la tab de gestión del gasto',																'TAB_GESTION_GASTOS'),
	  T_FUNCION('Permite editar la tab de gestión del gasto',																	'EDITAR_TAB_GESTION_GASTOS'),
	  T_FUNCION('Permite acceder a la tab de impugnación del gasto',															'TAB_IMPUGNACION_GASTOS'),
	  T_FUNCION('Permite editar la tab de impugnación del gasto',																'EDITAR_TAB_IMPUGNACION_GASTOS'),
	  T_FUNCION('Permite acceder a la tab de documentos del gasto',																'TAB_DOCUMENTOS'),
	  T_FUNCION('Permite editar la tab de documentos del gasto',																'EDITAR_TAB_DOCUMENTOS'),
	  T_FUNCION('Permite acceder a la tab de administración de la configuración',												'TAB_ADMINISTRACION_CONFIGURACION'),
	  T_FUNCION('Permite acceder a la tab de proveedores de la tab administración de la configuración',							'TAB_PROVEEDORES'),
	  T_FUNCION('Permite acceder a la tab de mediadores de la tab administración de la configuración',							'TAB_MEDIADORES'),
	  T_FUNCION('Permite acceder a la tab de datos de proveedores',																'TAB_DATOS_PROVEEDORES'),
	  T_FUNCION('Permite editar la tab de datos de proveedores',																'EDITAR_TAB_DATOS_PROVEEDORES'),
	  T_FUNCION('Permite acceder a la tab de documentos de proveedores',														'TAB_DOCUMENTOS_PROVEEDORES'),
	  T_FUNCION('Permite editar la tab de documentos de proveedores',															'EDITAR_TAB_DOCUMENTOS_PROVEEDORES'),
	  T_FUNCION('Puede ver la opción de menú precios',																			'MENU_PRECIOS'),
	  T_FUNCION('Puede ver la opción de menú publicación',																		'MENU_PUBLICACION'),
	  T_FUNCION('Puede ver la opción de menú comercial',																		'MENU_COMERCIAL'),
	  T_FUNCION('Puede ver la opción de menú administración',																	'MENU_ADMINISTRACION'),
	  T_FUNCION('Puede ver la opción de menú configuraicón',																	'MENU_CONFIGURACION'),
	  T_FUNCION('Puede autorizar/rechazar el gasto',																			'OPERAR_GASTO'),
	  T_FUNCION('Puede crear un gasto',																							'CREAR_GASTO'),
	  T_FUNCION('Permite editar la tab de activos asociados a un gasto',														'EDITAR_TAB_ACTIVOS_AFECTADOS_GASTOS')
	  
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN	
    -- LOOP Insertando valores en FUN_FUNCIONES
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Empezando a insertar funciones');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_FUN_FUNCIONES.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(2))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... Ya existe la funcion '''|| TRIM(V_TMP_FUNCION(2))||'''');
			ELSE		
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.FUN_FUNCIONES (' ||
						'FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
						'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||''','||
						'0, ''HREOS-4293'',SYSDATE,0 FROM DUAL';
				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Datos insertados');

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
  	
