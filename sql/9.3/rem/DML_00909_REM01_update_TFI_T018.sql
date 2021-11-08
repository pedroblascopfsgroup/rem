--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20210933
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15248
--## PRODUCTO=NO
--##
--## Finalidad:
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
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_TAP_ID NUMBER(16);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TFI_TAREAS_FORM_ITEMS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TFI'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14397';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(800);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    
    	T_TIPO_DATA('T018_DefinicionOferta'		,'combobox', 			'1'		,'tipoOfertaAlquiler'		,'false' 	,'DDTipoOfertaAlquiler'	,'Tipo de oferta'),
    	T_TIPO_DATA('T018_DefinicionOferta'		,'combobox', 			'2'		,'isVulnerable'				,null 		,'DDSiNo'				,'Es vulnerable'),
    	T_TIPO_DATA('T018_DefinicionOferta'		,'numberfield', 			'3'		,'expedienteAnterior'		,null 		,null					,'Expediente anterior'),
    	T_TIPO_DATA('T018_DefinicionOferta'		,'textarea', 			'5'		,'observaciones'			,null		,null					,'Observaciones'),
    
		T_TIPO_DATA('T018_AnalisisBc'		,'comboboxinicialedi', 	'1'		,'comboResultado'			,'false' 	,'DDSiNo'				,'Aprobado'),
    	T_TIPO_DATA('T018_AnalisisBc'		,'combobox', 			'2'		,'tipoOfertaAlquiler'		,'false' 	,'DDTipoOfertaAlquiler'	,'Tipo de oferta'),
    	T_TIPO_DATA('T018_AnalisisBc'		,'combobox', 			'3'		,'isVulnerable'				,null 		,'DDSiNo'				,'Es vulnerable'),
    	T_TIPO_DATA('T018_AnalisisBc'		,'combobox', 			'4'		,'isVulnerableAnalisisT'	,null 		,'DDSiNo'				,'Requiere análisis técnico'),
    	T_TIPO_DATA('T018_AnalisisBc'		,'textarea', 			'5'		,'observaciones'			,null		,null					,'Observaciones'),
    	
    	
    	T_TIPO_DATA('T018_Scoring'			,'datefield', 	'2'		,'fechaResolucion'			,'false' 	,null						,'Fecha sanción Scoring'),
    	T_TIPO_DATA('T018_Scoring'			,'combobox', 	'3'		,'motivoAnulacion'			,null 		,'DDMotivoAnulacionOferta'	,'Motivo rechazo'),
    	T_TIPO_DATA('T018_Scoring'			,'textfield', 	'5'		,'numExpediente'			,'false' 		,null						,'Número Expediente'),
    	T_TIPO_DATA('T018_Scoring'			,'textarea', 	'6'		,'observaciones'			,null		,null						,'Observaciones'),
    	
    	T_TIPO_DATA('T018_ScoringBc'			,'datefield', 	'2'		,'fechaResolucion'			,'false' 	,null						,'Fecha sanción Scoring BC'),
    	T_TIPO_DATA('T018_ScoringBc'			,'combobox', 	'3'		,'motivoAnulacion'			,null 		,'DDMotivoAnulacionOferta'	,'Motivo anulación'),
    	T_TIPO_DATA('T018_ScoringBc'			,'textarea', 	'6'		,'observacionesBC'			,null		,null						,'Observaciones BC'),
    	T_TIPO_DATA('T018_ScoringBc'			,'textarea', 	'7'		,'observaciones'			,null		,null						,'Observaciones'),
    	
    	T_TIPO_DATA('T018_ResolucionComite'			,'comboboxinicialedi', 	'1'		,'comboResultado'			,'false' 	,'DDSiNo'					,'Resolución'),
    	T_TIPO_DATA('T018_ResolucionComite'			,'datefield', 	'2'				,'fechaResolucion'			,'false' 	,null						,'Fecha'),
    	T_TIPO_DATA('T018_ResolucionComite'			,'combobox', 	'3'				,'motivoAnulacion'			,null 		,'DDMotivoAnulacionOferta'	,'Motivo Anulación'),
    	T_TIPO_DATA('T018_ResolucionComite'			,'textarea', 	'6'				,'observacionesBC'			,null		,null						,'Observaciones BC'),
    	T_TIPO_DATA('T018_ResolucionComite'			,'textarea', 	'6'				,'observaciones'			,null		,null						,'Observaciones'),
    	
    	T_TIPO_DATA('T018_SolicitarGarantiasAdicionales'			,'combobox', 	'1'				,'respuestaComprador'		,'false' 	,'DDRespuestaComprador'		,'Tipo de respuesta'),
    	T_TIPO_DATA('T018_SolicitarGarantiasAdicionales'			,'textarea', 	'2'				,'observaciones'			,null		,null						,'Observaciones'),
    	
    	T_TIPO_DATA('T018_TrasladarOfertaCliente'			,'datefield', 	'2'				,'fechaResolucion'			,'false' 	,null		,'Fecha envío'),
    	T_TIPO_DATA('T018_TrasladarOfertaCliente'			,'textarea', 	'3'				,'observaciones'			,null		,null		,'Observaciones'),
    	
    	T_TIPO_DATA('T018_RevisionBcYCondiciones'			,'datefield', 	'2'				,'fechaResolucion'			,'false' 	,null		,'Fecha envío'),
    	T_TIPO_DATA('T018_RevisionBcYCondiciones'			,'textarea', 	'3'				,'observaciones'			,null		,null		,'Observaciones'),
    	
    	T_TIPO_DATA('T018_AgendarYFirmar'			,'datefield', 	'1'				,'fecha'					,'false' 	,null		,'Fecha firma'),
    	T_TIPO_DATA('T018_AgendarYFirmar'			,'textfield', 	'2'				,'lugarFirma'				,'false' 	,null		,'Lugar firma'),
    	T_TIPO_DATA('T018_AgendarYFirmar'			,'textarea', 	'3'				,'observaciones'			,null		,null		,'Observaciones'),
    	
    	T_TIPO_DATA('T018_AnalisisTecnico'			,'combobox', 	'1'				,'certificacionesObtenidas'		,'false' 	,'DDSiNo'		,'Certificaciones obtenidas'),
    	T_TIPO_DATA('T018_AnalisisTecnico'			,'combobox', 	'2'				,'requiereAdecuaciones'			,'false'	,'DDSiNo'		,'Requiere adecuaciones'),
    	T_TIPO_DATA('T018_AnalisisTecnico'			,'textarea', 	'3'				,'observaciones'				,null		,null			,'Observaciones'),
    	
    	T_TIPO_DATA('T018_PbcAlquiler'				,'comboboxinicialedi', 	'1'				,'comboResultado'			,'false' 	,'DDSiNo'				,'Aprobado'),
		T_TIPO_DATA('T018_PbcAlquiler'				,'datefield', 			'2'				,'fechaResolucion'			,'false' 	,null					,'Fecha sanción'),
		T_TIPO_DATA('T018_PbcAlquiler'				,'textarea', 			'3'				,'observaciones'			,null		,null					,'Observaciones'),

		T_TIPO_DATA('T018_PteClRod'				,'comboboxinicialedi', 	'1'				,'comboResultado'			,'false' 	,'DDSiNo'				,'Aprobado'),
		T_TIPO_DATA('T018_PteClRod'				,'datefield', 			'2'				,'fechaResolucion'			,'false' 	,null					,'Fecha sanción'),
		T_TIPO_DATA('T018_PteClRod'				,'textarea', 			'3'				,'observaciones'			,null		,null					,'Observaciones')



    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        
		V_SQL := 'SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_TAP_ID;
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE '||
				'TAP_ID = '||V_TAP_ID||' '||
				'AND '||V_TEXT_CHARS||'_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(4))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL CAMPO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' DE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET '||V_TEXT_CHARS||'_TIPO = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', '||V_TEXT_CHARS||'_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', '||V_TEXT_CHARS||'_LABEL = '''||TRIM(V_TMP_TIPO_DATA(7))||''''||
					', '||V_TEXT_CHARS||'_ORDEN = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', '||V_TEXT_CHARS||'_VALIDACION = '''||TRIM(V_TMP_TIPO_DATA(5))||''''||
					', '||V_TEXT_CHARS||'_BUSINESS_OPERATION = '''||TRIM(V_TMP_TIPO_DATA(6))||''''||
					', USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE, BORRADO = 0 '||
					'WHERE '||V_TEXT_CHARS||'_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(4))||''' AND TAP_ID = '||V_TAP_ID||'';
          EXECUTE IMMEDIATE V_MSQL;
         
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL CAMPO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' DE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      ''||V_TEXT_CHARS||'_ID, TAP_ID, '||V_TEXT_CHARS||'_ORDEN, '||V_TEXT_CHARS||'_TIPO, '||V_TEXT_CHARS||'_NOMBRE, '||V_TEXT_CHARS||'_LABEL, '||V_TEXT_CHARS||'_VALIDACION, '||V_TEXT_CHARS||'_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ', '||V_TAP_ID||', '''||V_TMP_TIPO_DATA(3)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(5))||''', '''||TRIM(V_TMP_TIPO_DATA(6))||''', 0, '''||V_USUARIO||''',SYSDATE,0 '||
					  ' FROM DUAL';
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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
