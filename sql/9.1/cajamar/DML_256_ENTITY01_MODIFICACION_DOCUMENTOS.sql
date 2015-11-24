--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20151124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.7-hcj
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
--## Finalidad: DML
--##
--## INSTRUCCIONES: Borrado lógico de los documentos que no se utilizan en Cajamar
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
   V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
   V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
   err_num   NUMBER (25);                                                                                                                        -- Vble. auxiliar para registrar errores en el script.
   err_msg   VARCHAR2 (1024 CHAR);                                                                                                               -- Vble. auxiliar para registrar errores en el script.
   V_ENTIDAD_ID NUMBER(16);
   
   TYPE T_TIPO_TFA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TFA IS TABLE OF T_TIPO_TFA;
    V_TIPO_TFA T_ARRAY_TFA := T_ARRAY_TFA(
      T_TIPO_TFA('EDH', 'Escrito de demanda completo + copia sellada de la demanda', 'Escrito de demanda completo + copia sellada de la demanda', 'EJ') -- T. Hipotecario (modificado)
      ,T_TIPO_TFA('HEDIMP', 'Escrito de impugnación', 'Escrito de impugnación', 'EJ') -- T. Hipotecario
      ,T_TIPO_TFA('HRESOL', 'Resolución (Hipotecario)', 'Resolución (Hipotecario)', 'EJ') -- T. Hipotecario
      ,T_TIPO_TFA('PRVFND', 'Provisión de Fondos', 'Provisión de Fondos', 'TR') -- T. Provision de fondos
      ,T_TIPO_TFA('INFLIQ', 'Informe de liquidación', 'Informe de liquidación', 'TR') -- T. Calculo de deuda a fecha
      ,T_TIPO_TFA('IFISCAL', 'Informe fiscal (T. Subasta)', 'Informe fiscal (T. Subasta)', 'AP') -- T. Subasta
      ,T_TIPO_TFA('EDCSDE', 'Escrito de demanda completo + copia sellada de la demanda', 'Escrito de demanda completo + copia sellada de la demanda', 'DE') -- Trámites de Tipo de Actuación Declarativo 
      ,T_TIPO_TFA('COMAD', 'Comunicación adicional', 'Comunicación adicional', 'AP') -- Trámites de Adjudicación 
      ,T_TIPO_TFA('LIBARR', 'Certificado de Libertad de arrendamientos', 'Certificado de Libertad de arrendamientos', 'TR') -- Trámite de certificado de libertad de arrendamiento
      ,T_TIPO_TFA('ASP', 'Resultado averiguación solvencia patrimonial', 'Resultado averiguación solvencia patrimonial', 'TR') -- Trámite de solicitud de solvencia patrimonial
      ,T_TIPO_TFA('CRSOLADJ', 'Sol. de adj. con reserva de facultad de cesión de remate', 'Solicitud de adjudicación con reserva de facultad de cesión de remate', 'AP') -- Trámite de Cesión Remate
      ,T_TIPO_TFA('CRRESTRA', 'Resguardo trasferencia', 'Resguardo trasferencia', 'AP') -- Trámite de Cesión Remate
      ,T_TIPO_TFA('CRACCES', 'Acta de cesión', 'Acta de cesión', 'AP') -- Trámite de Cesión Remate
      ,T_TIPO_TFA('SCBCCR', 'Documento acreditativo de la cancelación de cargas registrales', 'Documento acreditativo de la cancelación de cargas registrales', 'AP') -- Saneamiento de cargas
      ,T_TIPO_TFA('SCBCPC', 'Carta de pago o documentación acreditativa de cancelación', 'Carta de pago o documentación acreditativa de cancelación', 'AP') -- Saneamiento de cargas
      ,T_TIPO_TFA('CAS', 'Contrato de alquiler social', 'Contrato de alquiler social', 'AP') -- Trámite de posesión
      ,T_TIPO_TFA('DSPJ', 'Documentación con sello de presentación en el Juzgado', 'Documentación con sello de presentación en el Juzgado', 'TR') -- Trámite de mandamiento de cancelación de cargas
      ,T_TIPO_TFA('MCC', 'Mandato de cancelación de cargas', 'Mandato de cancelación de cargas', 'TR') -- Trámite de mandamiento de cancelación de cargas
      ,T_TIPO_TFA('SAP', 'Solicitud archivo procedimiento', 'Solicitud archivo procedimiento', 'TR') -- Trámite de mandamiento de cancelación de cargas
      ,T_TIPO_TFA('INSUFI', 'Informe Subasta Firmado', 'Informe Subasta Firmado', 'AP') -- T. Subasta
      ,T_TIPO_TFA('INSEXT', 'Informe de subasta', 'Informe de subasta', 'EX') -- Trámite de ejecución notarial
      ,T_TIPO_TFA('INFSUBEXT', 'Informe Subasta firmada', 'Informe Subasta firmada', 'EX') -- Trámite de ejecución notarial
      ,T_TIPO_TFA('DECADM', 'Decreto de admisión', 'Decreto de admisión', 'TR') -- Trámite de posesión interina
      ,T_TIPO_TFA('SOLCONS', 'Solicitud de consignación', 'Solicitud de consignación', 'AP') -- Trámite de consignación
      ,T_TIPO_TFA('DTCCE', 'Decreto de Tasación de Costas (Costas contra entidad)', 'Decreto de Tasación de Costas (Costas contra entidad)', 'CO') -- Trámite de costras contra entidad
      ,T_TIPO_TFA('ESCSUS', 'Escrito de suspensión', 'Escrito de suspensión', 'AP') -- Trámite de subasta
      ,T_TIPO_TFA('MANCANCAR', 'Mandamiento de cancelación de cargas', 'Mandamiento de cancelación de cargas', 'AP') -- Trámite de Adjudicación
      ,T_TIPO_TFA('PETPOS', 'Petición de la posesión', 'Petición de la posesión', 'TR') -- Trámite de posesión interina
      ,T_TIPO_TFA('PRECUE', 'Presentación de cuentas', 'Presentación de cuentas', 'TR') -- Trámite de posesión interina
      ,T_TIPO_TFA('ACUREC', 'Acuse de recibo', 'Acuse de recibo', 'TR') -- Trámite de notificación
      ,T_TIPO_TFA('ESCPET', 'Escrito de petición', 'Escrito de petición', 'AP') -- Trámite de subsanación de decreto de adjudicación
    ); 
    V_TMP_TIPO_TFA T_TIPO_TFA;
BEGIN
   DBMS_OUTPUT.put_line
      ('[INICIO] Comenzando con el borrado lógico en DD_TFA_FICHERO_ADJUNTO de los documentos con código ''RSPCCA'', ''RSFSCO'', ''RSPRAL'', ''RSINFC'', ''RSCOPR'', ''RSISDI'', ''RSIPAC'', ''RSPPAL'', ''RSANSU'', ''RSINPA'', ''PSSB'', ''FSSF'', ''FSSB'', ''RSAR'', ''RSARSI'', ''INFFIS'', ''EJUZTBS'''
      );

   -- LOOP Insertando valores en dd_tfa_fichero_adjunto
   UPDATE #ESQUEMA#.dd_tfa_fichero_adjunto tfa
      SET tfa.borrado = 1,
          tfa.usuarioborrar = 'DD',
          tfa.fechaborrar = SYSDATE
    WHERE tfa.dd_tfa_codigo IN ('RSPCCA', 'RSFSCO', 'RSPRAL', 'RSINFC', 'RSCOPR', 'RSISDI', 'RSIPAC', 'RSPPAL', 'RSANSU', 'RSINPA', 'PSSB', 'FSSF', 'FSSB', 'RSAR', 'RSARSI', 'INFFIS', 'EJUZTBS');
    
      DBMS_OUTPUT.put_line ('[FIN] #ESQUEMA#.dd_tfa_fichero_adjunto... Borrado lógico finalizado');

    DBMS_OUTPUT.PUT_LINE('[INFO] #ESQUEMA#.dd_tfa_fichero_adjunto... Empezando a insertar datos en el diccionario');
    
	FOR I IN V_TIPO_TFA.FIRST .. V_TIPO_TFA.LAST
      LOOP
        V_MSQL := 'SELECT #ESQUEMA#.s_dd_tfa_fichero_adjunto.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_TFA := V_TIPO_TFA(I);
			
			V_SQL := 'SELECT COUNT(1) FROM #ESQUEMA#.dd_tfa_fichero_adjunto WHERE dd_tfa_codigo = '''||TRIM(V_TMP_TIPO_TFA(1))||''' and dd_tac_id = (select DD_TAC_ID FROM #ESQUEMA#.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' || TRIM(V_TMP_TIPO_TFA(4)) || ''')';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			-- Si existe
			IF V_NUM_TABLAS > 0 THEN				
				 V_MSQL := 'UPDATE #ESQUEMA#.dd_tfa_fichero_adjunto ' || 
                         ' SET DD_TFA_DESCRIPCION = '''||TRIM(V_TMP_TIPO_TFA(2))||
                         ''', DD_TFA_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_TFA(3))||
                         ''', VERSION = 1' ||
                         '  , USUARIOMODIFICAR = ''DML' || 
                         ''', FECHAMODIFICAR = '''|| SYSDATE ||
                         ''', BORRADO = 0 ' ||
                         ', DD_TAC_ID = (select DD_TAC_ID FROM #ESQUEMA#.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' || TRIM(V_TMP_TIPO_TFA(4)) || ''')' ||
                         ' where dd_tfa_codigo = ''' || V_TMP_TIPO_TFA(1)|| '''';
              DBMS_OUTPUT.PUT_LINE(V_MSQL);
              EXECUTE IMMEDIATE V_MSQL;
			ELSE		
				V_MSQL := 'INSERT INTO #ESQUEMA#.dd_tfa_fichero_adjunto (' ||
						'dd_tfa_id, dd_tfa_codigo, dd_tfa_descripcion, dd_tfa_descripcion_larga, VERSION, usuariocrear, fechacrear, borrado, dd_tac_id) ' ||
						'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_TFA(1)||''','''||V_TMP_TIPO_TFA(2)||''','''||TRIM(V_TMP_TIPO_TFA(3))||''','||
						'0, ''DML'',SYSDATE,0, (select DD_TAC_ID FROM #ESQUEMA#.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' || TRIM(V_TMP_TIPO_TFA(4)) || ''') FROM DUAL';
				
        DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TFA(1)||''','''||TRIM(V_TMP_TIPO_TFA(2))||''','''||TRIM(V_TMP_TIPO_TFA(3))||''','''||TRIM(V_TMP_TIPO_TFA(4))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;

    DBMS_OUTPUT.PUT_LINE('[FIN] #ESQUEMA#.dd_tfa_fichero_adjunto... Insertados datos en el diccionario');
    
    
   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      err_num := SQLCODE;
      err_msg := SQLERRM;
      DBMS_OUTPUT.put_line ('[ERROR] Se ha producido un error en la ejecución:' || TO_CHAR (err_num));
      DBMS_OUTPUT.put_line ('-----------------------------------------------------------');
      DBMS_OUTPUT.put_line (err_msg);
      ROLLBACK;
      RAISE;
END;
/

EXIT;