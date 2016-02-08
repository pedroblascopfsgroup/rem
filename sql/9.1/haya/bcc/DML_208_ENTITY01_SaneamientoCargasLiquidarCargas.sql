--/*
--##########################################
--## AUTOR=OSCAR DORADO
--## FECHA_CREACION=20160118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-585
--## PRODUCTO=NO
--##
--## Finalidad: Realiza las inserciones de la resolución para la tarea H054_PresentarEscritoJuzgado.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    /* ##############################################################################
    ## INSTRUCCIONES - DATOS DE LA RESOLUCIÓN
    ## Modificar sólo los siguientes datos.
    ## En descripción larga introducirá los datos de la descripción (Tanto en la resolución como en el Input).
    ## En la ayuda introducirá la cadena 'Ayuda de ' seguida del valor definido en la variable: V_TR_DESCRIPCION.
    ## En el input introducirá la cadena 'Input ' seguida del valor definido en la variable: V_TR_DESCRIPCION.
    */
    V_TR_ID VARCHAR2(16 CHAR):= 			'428';
    V_TR_CODIGO VARCHAR2(25 CHAR):= 		'R_LIQ_CAR';
    V_TR_DESCRIPCION  VARCHAR2(100 CHAR):=	'Carta de pago o documentación acreditativa de cancelación';
    V_TJ_CODIGO VARCHAR2(20 CHAR):=			'SCR';
    V_TAC_CODIGO VARCHAR2(20 CHAR):=		'ADVANCE'; -- ADVANCE, INFO, etc.
    
    V_TIN_CODIGO VARCHAR2(50 CHAR):=		'I_LIQ_CAR';
    
    V_TPO_CODIGO VARCHAR2(20 CHAR):=		'H008';
    V_NODO VARCHAR2(50 CHAR):=				'H008_LiquidarCargas';
    
    TYPE T_INPUT IS TABLE OF VARCHAR2(50);
    TYPE T_ARRAY_INPUT IS TABLE OF T_INPUT;
    V_INPUT T_ARRAY_INPUT := T_ARRAY_INPUT(
    	T_INPUT('idAsunto','idAsunto'), -- Está siempre en el factoria, no eliminar.
    	T_INPUT('d_numAutos','numAutos'), -- Está siempre en el factoria, no eliminar.
        T_INPUT('d_fechaLiquidacion','fechaLiquidacion'),
        T_INPUT('d_fechaRecepcion','fechaRecepcion'),
        T_INPUT('d_fechaCancelacion','fechaCancelacion'),
    	T_INPUT('d_observaciones','observaciones') -- Está siempre en el factoria, no eliminar.
    );
    V_TMP_T_INPUT T_INPUT;
    
    -- ## FIN DATOS DE LA RESOLUCION
    -- ########################################################################################

BEGIN	

      -- LOOP Insertando valores en PRO_PROCURADORES ------------------------------------------------------------------------

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION... Empezando a insertar datos de la resolución '||V_TR_CODIGO||'.');
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION WHERE DD_TR_CODIGO = '''||V_TR_CODIGO||'''';
    EXECUTE IMMEDIATE V_SQL INTO table_count;
    
    IF table_count = 1 THEN
   		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TR_TIPOS_RESOLUCION... Ya existe el DD_TR_TIPOS_RESOLUCION '||V_TR_CODIGO||'.');
	ELSE
		-- Insertamos en la tabla dd_tr_tipos_resolucion el tipo de resolución
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION (' ||
				   'DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID) ' ||
				   'SELECT '''||V_TR_ID||''','''||V_TR_CODIGO||''','''||V_TR_DESCRIPCION||''','''||V_TR_DESCRIPCION||''','||
				   		'(SELECT DD_TJ_ID FROM '||V_ESQUEMA||'.DD_TJ_TIPO_JUICIO WHERE DD_TJ_CODIGO = '''||V_TJ_CODIGO||'''),'||
				   		'0, ''MOD_PROC'', SYSDATE, 0, ''Ayuda de '||V_TR_DESCRIPCION||''', (SELECT BPM_DD_TAC_ID FROM '||V_ESQUEMA||'.BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO ='''||V_TAC_CODIGO||''')'||
				   		' FROM DUAL';
				   		
		EXECUTE IMMEDIATE V_MSQL;
		
		V_MSQL := 'SELECT '||V_ESQUEMA||'.S_BPM_DD_TIN_TIPO_INPUT.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.BPM_DD_TIN_TIPO_INPUT (' ||
					'BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TIN_CLASE) ' ||
					'SELECT '''||V_ENTIDAD_ID||''','''||V_TIN_CODIGO||''',''Input '||V_TR_DESCRIPCION||''',''Input '||V_TR_DESCRIPCION||''','||
					'''0'',''MOD_PROC'', SYSDATE, ''0'',NULL FROM DUAL';
		
		EXECUTE IMMEDIATE V_MSQL;
		
					
					
		-- Insertamos en BPM_TPI_TIPO_PROC_INPUT para crear la relación entre inputs y los nodos del procedimiento
		V_MSQL := 'SELECT '||V_ESQUEMA||'.S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.BPM_TPI_TIPO_PROC_INPUT (' ||
					'BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) '||
					'VALUES ('||V_ENTIDAD_ID||', (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||V_TPO_CODIGO||'''),'||
					'(SELECT BPM_DD_TIN_ID FROM '||V_ESQUEMA||'.BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='''||V_TIN_CODIGO||'''),'''||V_NODO||''',''NONE'', 0, ''MOD_PROC'', '||
					'SYSDATE, 0, (SELECT BPM_DD_TAC_ID FROM '||V_ESQUEMA||'.BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='''||V_TAC_CODIGO||'''), NULL, NULL)';
		
		EXECUTE IMMEDIATE V_MSQL;
		
					
					
		--Insertamos en la Tabla BPM_IDT_INPUTS_DATOS: los campos del formulario(los de la tarea) más los obligatorios (idAsunto, d_numAutos).
	    FOR I IN V_INPUT.FIRST .. V_INPUT.LAST
	      LOOP
	          V_TMP_T_INPUT := V_INPUT(I);
	          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_BPM_IDT_INPUT_DATOS.NEXTVAL FROM DUAL';
	          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
	          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.BPM_IDT_INPUT_DATOS (' ||
	                      'BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)' ||
	                      'SELECT '||V_ENTIDAD_ID ||', BPM_TPI_ID,'''||V_TMP_T_INPUT(1)||''',''generico'','''||V_TMP_T_INPUT(2)||''','||
						  '0, ''MOD_PROC'', SYSDATE, 0 FROM '||V_ESQUEMA||'.BPM_TPI_TIPO_PROC_INPUT WHERE BPM_DD_TIN_ID = ('||
						  'SELECT BPM_DD_TIN_ID FROM '||V_ESQUEMA||'.BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='''||V_TIN_CODIGO||''') '||
						  'AND DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO ='''||V_TPO_CODIGO||''')';
	          DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_T_INPUT(1)||''' de '''||V_TR_CODIGO||''''); 
	          EXECUTE IMMEDIATE V_MSQL;
	      END LOOP;
    	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION... ha terminado la insercción de datos de la resolución '||V_TR_CODIGO||'.');
    END IF;
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