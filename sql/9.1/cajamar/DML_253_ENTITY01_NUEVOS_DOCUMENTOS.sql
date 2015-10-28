--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20150715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.7-hcj
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar los documentos para HRE-BCC
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en dd_tfa_fichero_adjunto
    TYPE T_TIPO_TFA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TFA IS TABLE OF T_TIPO_TFA;
    V_TIPO_TFA T_ARRAY_TFA := T_ARRAY_TFA(
    	T_TIPO_TFA('IFISCAL', 'Informe fiscal (T. Subasta)', 'Informe fiscal (T. Subasta)', 'AP') -- T. Subasta
    ); 
    V_TMP_TIPO_TFA T_TIPO_TFA;
    
BEGIN	
  
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando con DD_TFA_FICHERO_ADJUNTO');  
  -- LOOP Insertando valores en dd_tfa_fichero_adjunto
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.dd_tfa_fichero_adjunto... Empezando a insertar datos en el diccionario');
    
	FOR I IN V_TIPO_TFA.FIRST .. V_TIPO_TFA.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.s_dd_tfa_fichero_adjunto.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_TFA := V_TIPO_TFA(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.dd_tfa_fichero_adjunto WHERE dd_tfa_codigo = '''||TRIM(V_TMP_TIPO_TFA(1))||''' and dd_tac_id = (select DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' || TRIM(V_TMP_TIPO_TFA(4)) || ''')';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			-- Si existe
			IF V_NUM_TABLAS > 0 THEN				
				--DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.dd_tfa_fichero_adjunto... Ya existe la relacion dd_tfa_codigo='''|| TRIM(V_TMP_TIPO_TFA(1))||''' con el código de actuación='''|| TRIM(V_TMP_TIPO_TFA(4))||'''');
				 V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.dd_tfa_fichero_adjunto ' || 
                         ' SET DD_TFA_DESCRIPCION = '''||TRIM(V_TMP_TIPO_TFA(2))||
                         ''', DD_TFA_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_TFA(3))||
                         ''', VERSION = 1' ||
                         '  , USUARIOMODIFICAR = ''DML' || 
                         ''', FECHAMODIFICAR = '''|| SYSDATE ||
                         ''', BORRADO = 0 ' ||
                         ', DD_TAC_ID = (select DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' || TRIM(V_TMP_TIPO_TFA(4)) || ''')' ||
                         ' where dd_tfa_codigo = ''' || V_TMP_TIPO_TFA(1)|| '''';
              DBMS_OUTPUT.PUT_LINE(V_MSQL);
              EXECUTE IMMEDIATE V_MSQL;
			ELSE		
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.dd_tfa_fichero_adjunto (' ||
						'dd_tfa_id, dd_tfa_codigo, dd_tfa_descripcion, dd_tfa_descripcion_larga, VERSION, usuariocrear, fechacrear, borrado, dd_tac_id) ' ||
						'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_TFA(1)||''','''||V_TMP_TIPO_TFA(2)||''','''||TRIM(V_TMP_TIPO_TFA(3))||''','||
						'0, ''DML'',SYSDATE,0, (select DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' || TRIM(V_TMP_TIPO_TFA(4)) || ''') FROM DUAL';
				
        DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TFA(1)||''','''||TRIM(V_TMP_TIPO_TFA(2))||''','''||TRIM(V_TMP_TIPO_TFA(3))||''','''||TRIM(V_TMP_TIPO_TFA(4))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA ||'.dd_tfa_fichero_adjunto... Insertados datos en el diccionario');

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
