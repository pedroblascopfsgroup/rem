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
      T_TIPO_TFA('PLALIQ', 'Plan de liquidación', 'Plan de liquidación', 'CO') -- Trámite de fase de liquidación
      ,T_TIPO_TFA('AAPLIQ', 'Auto aprobando plan de liquidación', 'Auto aprobando plan de liquidación', 'CO') -- Trámite de fase de liquidación      
      ,T_TIPO_TFA('INFRENCUE', 'Informe de rendición de cuentas', 'Informe de rendición de cuentas', 'CO') -- Trámite de fase de liquidación
      ,T_TIPO_TFA('AUTCONCON', 'Auto de conclusión de concurso', 'Auto de conclusión de concurso', 'CO') -- Trámite de fase de liquidación
      ,T_TIPO_TFA('INFPRO', 'Informe de la propuesta', 'Informe de la propuesta', 'CO') -- Trámite de propuesta anticipada
      ,T_TIPO_TFA('RESJUD', 'Resolución judicial', 'Resolución judicial', 'CO') -- Trámite de propuesta anticipada
      ,T_TIPO_TFA('INFADMCON', 'Informe del Adm. Concursal', 'Informe del Adm. Concursal', 'CO') -- Trámite de fase convenio
      ,T_TIPO_TFA('ACTJUNACR', 'Acta de la junta de acreedores', 'Acta de la junta de acreedores', 'CO') -- Trámite de fase convenio
      ,T_TIPO_TFA('RESADE', 'Resolución de la adenda', 'Resolución de la adenda', 'CO') -- Trámite de fase común
      ,T_TIPO_TFA('RESJUZ', 'Resolución juzgado', 'Resolución juzgado', 'CO') -- Trámite de fase común
      ,T_TIPO_TFA('BOE', 'BOE', 'BOE', 'CO') -- Trámite de fase común
      ,T_TIPO_TFA('INTDEM', 'Interposición de la demanda', 'Interposición de la demanda', 'CO') -- Trámite de demanda incidental
      ,T_TIPO_TFA('INFCANOPE', 'Informe de cancelación de operación', 'Informe de cancelación de operación', 'CO') -- Trámite de demandado en incidente
      ,T_TIPO_TFA('OFEVEN', 'Oferta venta', 'Oferta venta', 'CO') -- Trámite de venta directa
      ,T_TIPO_TFA('INFSOBVEN', 'Informe sobre oferta', 'Informe sobre oferta', 'CO') -- Trámite de venta directa
      ,T_TIPO_TFA('AUTO', 'Auto', 'Auto', 'CO') -- Trámite de venta directa
      ,T_TIPO_TFA('PROPLAPAG', 'Propuesta de plan de pagos', 'Propuesta de plan de pagos', 'CO') -- Trámite de acuerdo extrajudicial de pagos
      ,T_TIPO_TFA('INFCON', 'Informe concursal', 'Informe concursal', 'CO') -- Trámite de acuerdo extrajudicial de pagos
      ,T_TIPO_TFA('LIBARR', 'Certificado de Libertad de arrendamientos', 'Certificado de Libertad de arrendamientos', 'TR') -- Trámite de certificado de libertad de arrendamiento
      ,T_TIPO_TFA('PRVFND', 'Provisión de Fondos', 'Provisión de Fondos', 'TR') -- T. Provision de fondos
      ,T_TIPO_TFA('CAS', 'Contrato de alquiler social', 'Contrato de alquiler social', 'AP') -- Trámite de posesión
      ,T_TIPO_TFA('SCBCCR', 'Documento acreditativo de la cancelación de cargas registrales', 'Documento acreditativo de la cancelación de cargas registrales', 'AP') -- Saneamiento de cargas
      ,T_TIPO_TFA('SCBCPC', 'Carta de pago o documentación acreditativa de cancelación', 'Carta de pago o documentación acreditativa de cancelación', 'AP') -- Saneamiento de cargas
      ,T_TIPO_TFA('CRSOLADJ', 'Sol. de adj. con reserva de facultad de cesión de remate', 'Solicitud de adjudicación con reserva de facultad de cesión de remate', 'AP') -- Trámite de Cesión Remate
      ,T_TIPO_TFA('CRACCES', 'Acta de cesión', 'Acta de cesión', 'AP') -- Trámite de Cesión Remate
      ,T_TIPO_TFA('CRRESTRA', 'Resguardo trasferencia', 'Resguardo trasferencia', 'AP') -- Trámite de Cesión Remate
      ,T_TIPO_TFA('INSUFI', 'Informe Subasta Firmado', 'Informe Subasta Firmado', 'AP') -- T. Subasta concursal
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
