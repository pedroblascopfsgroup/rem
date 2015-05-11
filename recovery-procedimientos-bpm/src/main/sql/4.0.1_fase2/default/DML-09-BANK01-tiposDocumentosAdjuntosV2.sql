--/*
--##########################################
--## Author: Roberto
--## Finalidad: DML para crear los nuevos tipos de documentos adjuntos
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en dd_tfa_fichero_adjunto
    TYPE T_TIPO_TFA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TFA IS TABLE OF T_TIPO_TFA;
    V_TIPO_TFA T_ARRAY_TFA := T_ARRAY_TFA(
      T_TIPO_TFA('EDC', 'Escrito de la demanda (Cambiario)', 'Escrito de la demanda (Cambiario)', 'EJ'),

      T_TIPO_TFA('EDCO', 'Escrito de la demanda de oposición (Cambiario)', 'Escrito de la Demanda de oposición (Cambiario)', 'EJ'),

      T_TIPO_TFA('EDTJ', 'Escrito de la demanda (Ejecución Título Judicial)', 'Escrito de la demanda (Ejecución Título Judicial)', 'EJ'),

      T_TIPO_TFA('EDH', 'Escrito de la demanda (Hipotecario)', 'Escrito de la demanda (Hipotecario)', 'EJ'),

      T_TIPO_TFA('EDM', 'Escrito de la demanda (Monitorio)', 'Escrito de la demanda (Monitorio)', 'DE'),

      T_TIPO_TFA('EDO', 'Escrito de la demanda (Ordinario)', 'Escrito de la demanda (Ordinario)', 'DE'),

      T_TIPO_TFA('EDV', 'Escrito de la demanda (Verbal)', 'Escrito de la demanda (Verbal)', 'DE'),

      T_TIPO_TFA('ADEC', 'Auto despachando ejecución (Cambiario)', 'Auto despachando ejecución (Cambiario)', 'EJ'),

      T_TIPO_TFA('ADETJ', 'Auto despachando ejecución (Ejecución Título Judicial)', 'Auto despachando ejecución (Ejecución Título Judicial)', 'EJ'),

      T_TIPO_TFA('ADETNJ', 'Auto despachando ejecución (Ejecución Título No Judicial)', 'Auto despachando ejecución (Ejecución Título No Judicial)', 'EJ'),

      T_TIPO_TFA('ADEH', 'Auto despachando ejecución (Hipotecario)', 'Auto despachando ejecución (Hipotecario)', 'EJ'),

      T_TIPO_TFA('ADEM', 'Auto despachando ejecución (Monitorio)', 'Auto despachando ejecución (Monitorio)', 'DE'),

      T_TIPO_TFA('ADEO', 'Auto despachando ejecución (Ordinario)', 'Auto despachando ejecución (Ordinario)', 'DE'),

      T_TIPO_TFA('ADEV', 'Auto despachando ejecución (Verbal)', 'Auto despachando ejecución (Verbal)', 'DE'),

      T_TIPO_TFA('REC', 'Resolución (Cambiario)', 'Resolución (Cambiario)', 'EJ'),

      T_TIPO_TFA('ARETJ', 'Auto de resolución (Título Judicial)', 'Auto de resolución (Título Judicial)', 'EJ'),

      T_TIPO_TFA('REO', 'Resolución del Juzgado (Ordinario)', 'Resolución del Juzgado (Ordinario)', 'DE'),

      T_TIPO_TFA('REV', 'Resolución del Juzgado (Verbal)', 'Resolución del Juzgado (Verbal)', 'DE'),

      T_TIPO_TFA('REVM', 'Resolución del Juzgado (Verbal desde Monitorio)', 'Resolución del Juzgado (Verbal desde Monitorio)', 'DE'),

      T_TIPO_TFA('REI', 'Resolución del Juzgado (Intereses)', 'Resolución del Juzgado (Intereses)', 'TR'),

      T_TIPO_TFA('REM', 'Resolución (Moratoria de Posesión)', 'Resolución (Moratoria de Posesión)', 'AP'),

      T_TIPO_TFA('REAFC', 'Resolución de las Alegaciones (Fase Común)', 'Resolución de las Alegaciones (Fase Común)', 'CO'),

      T_TIPO_TFA('AREDI', 'AutoResolución (Demanda incidental)', 'AutoResolución (Demanda incidental)', 'CO'),

      T_TIPO_TFA('REDIT', 'Resolución (Demandado en incidente)', 'Resolución (Demandado en incidente)', 'CO'),

      T_TIPO_TFA('REAC', 'Resolución Admisión Convenio', 'Resolución Admisión Convenio', 'CO'),

      T_TIPO_TFA('RESPAC', 'Resolución Sareb (Propuesta Anticipada Convenio)', 'Resolución Sareb (Propuesta Anticipada Convenio)', 'CO'),

      T_TIPO_TFA('RESFL', 'Resolución Sareb (Fase de liquidación)', 'Resolución Sareb (Fase de liquidación)', 'CO'),

      T_TIPO_TFA('RECA', 'Resolución (Calificación)', 'Resolución (Calificación)', 'CO'),

      T_TIPO_TFA('RESHA', 'Resolución Sareb (Homologación acuerdo)', 'Resolución Sareb (Homologación acuerdo)', 'CO'),

      T_TIPO_TFA('REACHA', 'Resolución judicial y acuerdo (Homologación acuerdo)', 'Resolución judicial y acuerdo (Homologación acuerdo)', 'CO'),

      T_TIPO_TFA('REFC', 'Resolución Conclusión (Fase de Conclusión)', 'Resolución Conclusión (Fase de Conclusión)', 'CO'),

      T_TIPO_TFA('EOETJ', 'Escrito de Oposición (Ejecución Titulo Judicial)', 'Escrito de Oposición (Ejecución Titulo Judicial)', 'EJ'),

      T_TIPO_TFA('EOETNJ', 'Escrito de Oposición (Ejecución Titulo No Judicial)', 'Escrito de Oposición (Ejecución Titulo No Judicial)', 'EJ'),

      T_TIPO_TFA('EOH', 'Escrito de Oposición (Hipotecario)', 'Escrito de Oposición (Hipotecario)', 'EJ'),

      T_TIPO_TFA('EOM', 'Escrito de Oposición (Monitorio)', 'Escrito de Oposición (Monitorio)', 'DE'),

      T_TIPO_TFA('EOO', 'Escrito de Oposición (Ordinario)', 'Escrito de Oposición (Ordinario)', 'DE'),

      T_TIPO_TFA('EOSC', 'Escrito de Oposición (Solicitud Concursal/Declaración Concurso)', 'Escrito de Oposición (Solicitud Concursal/Declaración Concurso)', 'CO'),

      T_TIPO_TFA('EODI', 'Escrito de Oposición (Demanda incidental)', 'Escrito de Oposición (Demanda incidental)', 'CO'),

      T_TIPO_TFA('EORC', 'Escrito de Oposición (Reapertura del concurso)', 'Escrito de Oposición (Reapertura del concurso)', 'CO'),

      T_TIPO_TFA('EIETJ', 'Escrito impugnación oposición contrario (Ejecución título judicial)', 'Escrito impugnación oposición contrario (Ejecución título judicial)', 'EJ'),

      T_TIPO_TFA('CCH', 'Certificado de cargas (Hipotecario)', 'Certificado de cargas (Hipotecario)', 'EJ'),

      T_TIPO_TFA('CCB', 'Certificado de cargas de cada bien (Certificado de Cargas y Revisión)', 'Certificado de cargas de cada bien (Certificado de Cargas y Revisión)', 'AP'),

      T_TIPO_TFA('PCCSC', 'Propuesta de cancelación de las cargas (Saneamiento de cargas)', 'Propuesta de cancelación de las cargas (Saneamiento de cargas)', 'AP'),

      T_TIPO_TFA('MP', 'Mandamiento de Pago', 'Mandamiento de Pago', 'AP'),

      T_TIPO_TFA('EIC', 'Escrito de impugnación (Costas)', 'Escrito de impugnación (Costas)', 'EJ'),

      T_TIPO_TFA('EII', 'Escrito de impugnación (Intereses)', 'Escrito de impugnación (Intereses)', 'TR'),

      T_TIPO_TFA('AAC', 'Auto aprobación (Costas)', 'Auto aprobación (Costas)', 'EJ'),

      T_TIPO_TFA('AACONV', 'Auto Aprobación del convenio', 'Auto Aprobación del convenio', 'CO'),

      T_TIPO_TFA('CONV', 'Convenio', 'Convenio', 'CO'),

      T_TIPO_TFA('RECGES', 'Recibí de Gestoría (Adjudicación)', 'Recibí de Gestoría (Adjudicación)', 'AP'),

      T_TIPO_TFA('CALHAC', 'Copia de la autoliquidación presentada en Hacienda', 'Copia de la autoliquidación presentada en Hacienda', 'AP'),

      T_TIPO_TFA('TJC', 'Tasación del juzgado (Costas)', 'Tasación del juzgado (Costas)', 'TR'),

      T_TIPO_TFA('DTC', 'Decreto de Tasación de Costas', 'Decreto de Tasación de Costas', 'TR'),

      T_TIPO_TFA('DJAC', 'Documento del Juzgado de Aceptación del Cargo', 'Documento del Juzgado de Aceptación del Cargo', 'TR'),

      T_TIPO_TFA('AAEEE', 'Documento que acredite el acuerdo de la entrega y la entrega efectiva', 'Documento que acredite el acuerdo de la entrega y la entrega efectiva', 'TR'),

      T_TIPO_TFA('ENES', 'Escrito de Notificación (Embargos de Salarios)', 'Escrito de Notificación (Embargos de Salarios)', 'TR'),

      T_TIPO_TFA('HCI', 'Hoja de cálculo de Intereses', 'Hoja de cálculo de Intereses', 'TR'),

      T_TIPO_TFA('DRO', 'Documento registrado de cada Organismo (Investigación Judicial)', 'Documento registrado de cada Organismo (Investigación Judicial)', 'TR'),

      T_TIPO_TFA('EPME', 'Escrito de Presentación (Mejora de embargo)', 'Escrito de Presentación (Mejora de embargo)', 'TR'),

      T_TIPO_TFA('REME', 'Resolución (Mejora de embargo)', 'Resolución (Mejora de embargo)', 'TR'),

      T_TIPO_TFA('ECM', 'Escrito Conformidad a la Moratoria', 'Escrito Conformidad a la Moratoria', 'AP'),

      T_TIPO_TFA('REOC', 'Resolución (Ocupantes)', 'Resolución (Ocupantes)', 'AP'),

      T_TIPO_TFA('DJPOS', 'Diligencia judicial de la posesión', 'Diligencia judicial de la posesión', 'AP'),

      T_TIPO_TFA('DJLPOS', 'Diligencia judicial del lanzamiento (Posesión)', 'Diligencia judicial del lanzamiento (Posesión)', 'AP'),

      T_TIPO_TFA('DSSDA', 'Decreto Subsanado (Subsanación del Decreto de Adjudicación)', 'Decreto Subsanado (Subsanación del Decreto de Adjudicación)', 'AP'),

      T_TIPO_TFA('AVPR', 'Avalúo practicado', 'Avalúo practicado', 'AP'),

      T_TIPO_TFA('MEMB', 'Mandamiento de Embargo', 'Mandamiento de Embargo', 'TR'),

      T_TIPO_TFA('REREVC', 'Renovación del registro (Vigilancia y Caducidad de Embargos)', 'Renovación del registro (Vigilancia y Caducidad de Embargos)', 'TR'),

      T_TIPO_TFA('NOSI', 'Nota simple', 'Nota simple', 'AP'),

      T_TIPO_TFA('INFDUE', 'Informe DUE', 'Informe DUE', 'AP'),

      T_TIPO_TFA('PSFDUL', 'Propuesta Subasta firmada por Dtor UCyL', 'Propuesta Subasta firmada por Dtor UCyL', 'AP'),

      T_TIPO_TFA('RSAR', 'Respuesta Sareb', 'Respuesta Sareb', 'AP'),

      T_TIPO_TFA('RSIND', 'Resultado servicio índices', 'Resultado servicio índices', 'AP'),

      T_TIPO_TFA('RSARSI', 'Respuesta Sareb (servicio índices)', 'Respuesta Sareb (servicio índices)', 'AP'),

      T_TIPO_TFA('INFAC', 'Informe de la AC (Fase común)', 'Informe de la AC (Fase común)', 'CO'),

      T_TIPO_TFA('PCTER', 'Propuesta Convenio Tercero', 'Propuesta Convenio Tercero', 'CO'),

      T_TIPO_TFA('INFVL', 'Informe Valoración Letrado', 'Informe Valoración Letrado', 'CO'),

      T_TIPO_TFA('AUTORE', 'Autoresolución (Fase Convenio)', 'Autoresolución (Fase Convenio)', 'CO'),

      T_TIPO_TFA('DEINC', 'Demanda incidental', 'Demanda incidental', 'CO'),

      T_TIPO_TFA('INFLETRADO', 'Informe del Letrado (Demandado en Incidente)', 'Informe del Letrado (Demandado en Incidente)', 'CO'),

      T_TIPO_TFA('ESCJUZ', 'Escrito presentado en el Juzgado (Demandado en Incidente)', 'Escrito presentado en el Juzgado (Demandado en Incidente)', 'CO'),

      T_TIPO_TFA('PRAC', 'Propuesta Anticipada Convenio', 'Propuesta Anticipada Convenio', 'CO'),

      T_TIPO_TFA('IACPAC', 'Informe AC (Propuesta Anticipada Convenio)', 'Informe AC (Propuesta Anticipada Convenio)', 'CO'),

      T_TIPO_TFA('PLIQ', 'Plan de liquidación', 'Plan de liquidación', 'CO'),

      T_TIPO_TFA('INFLFL', 'Informe del letrado (Fase de Liquidación)', 'Informe del letrado (Fase de Liquidación)', 'CO'),

      T_TIPO_TFA('ESALEG', 'Escrito de Alegaciones', 'Escrito de Alegaciones', 'CO'),

      T_TIPO_TFA('INFTC', 'Informe Trimestral del Cierre', 'Informe Trimestral del Cierre', 'CO'),

      T_TIPO_TFA('PREPCO', 'Propuesta del Convenio (Presentación Propuesta Convenio)', 'Propuesta del Convenio (Presentación Propuesta Convenio)', 'CO'),

      T_TIPO_TFA('INACPC', 'Informe del AC (Presentación Propuesta Convenio)', 'Informe del AC (Presentación Propuesta Convenio)', 'CO'),

      T_TIPO_TFA('ESSORE', 'Escrito de Solicitud de Reapertura', 'Escrito de Solicitud de Reapertura', 'CO'),

      T_TIPO_TFA('P5BIS', 'Publicación 5BIS', 'Publicación 5BIS', 'CO'),

      T_TIPO_TFA('AACO', 'Auto admitiendo el concurso', 'Auto admitiendo el concurso', 'CO'),

      T_TIPO_TFA('ADCO', 'Auto declarando el concurso', 'Auto declarando el concurso', 'CO'),
      
      T_TIPO_TFA('ILCRLM', 'Informe del Letrado sobre cumplimiento requisitos legales (Moratoria de posesión)', 'Informe del Letrado sobre cumplimiento requisitos legales (Moratoria de posesión)', 'AP'),
 
	  T_TIPO_TFA('TVAPJ', 'Tasación de verificación del avalúo realizado por perito judicial (Valoración de Bienes Inmuebles)', 'Tasación de verificación del avalúo realizado por perito judicial (Valoración de Bienes Inmuebles)', 'AP'), 
      
	  T_TIPO_TFA('ELAA', 'Escrito del letrado con las alegaciones al avalúo (Valoración de Bienes Inmuebles)', 'Escrito del letrado con las alegaciones al avalúo (Valoración de Bienes Inmuebles)', 'AP')	  
	  
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
			
			V_SQL := 'SELECT COUNT(1) FROM dd_tfa_fichero_adjunto WHERE dd_tfa_codigo = '''||TRIM(V_TMP_TIPO_TFA(1))||''' and dd_tac_id = (select DD_TAC_ID FROM DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' || TRIM(V_TMP_TIPO_TFA(4)) || ''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN				
				--DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.dd_tfa_fichero_adjunto... Ya existe la relacion dd_tfa_codigo='''|| TRIM(V_TMP_TIPO_TFA(1))||''' con el código de actuación='''|| TRIM(V_TMP_TIPO_TFA(4))||'''');
				 V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.dd_tfa_fichero_adjunto ' || 
                         ' SET DD_TFA_DESCRIPCION = '''||TRIM(V_TMP_TIPO_TFA(2))||
                         ''', DD_TFA_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_TFA(3))||
                         ''', VERSION = 1' ||
                         '  , USUARIOMODIFICAR = ''DML' || 
                         ''', FECHAMODIFICAR = '''|| SYSDATE ||
                         ''', BORRADO = 0 ' ||
                         ', DD_TAC_ID = (select DD_TAC_ID FROM DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' || TRIM(V_TMP_TIPO_TFA(4)) || ''')' ||
                         ' where dd_tfa_codigo = ''' || V_TMP_TIPO_TFA(1)|| '''';
              DBMS_OUTPUT.PUT_LINE(V_MSQL);
              EXECUTE IMMEDIATE V_MSQL;
			ELSE		
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.dd_tfa_fichero_adjunto (' ||
						'dd_tfa_id, dd_tfa_codigo, dd_tfa_descripcion, dd_tfa_descripcion_larga, VERSION, usuariocrear, fechacrear, borrado, dd_tac_id) ' ||
						'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_TFA(1)||''','''||V_TMP_TIPO_TFA(2)||''','''||TRIM(V_TMP_TIPO_TFA(3))||''','||
						'0, ''DML'',SYSDATE,0, (select DD_TAC_ID FROM DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' || TRIM(V_TMP_TIPO_TFA(4)) || ''') FROM DUAL';
				
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
