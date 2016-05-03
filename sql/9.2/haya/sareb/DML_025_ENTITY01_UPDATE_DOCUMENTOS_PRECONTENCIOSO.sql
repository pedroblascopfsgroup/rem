--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20160502
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-1939
--## PRODUCTO=NO
--## Finalidad: DML corrección acentos descripciones de ficheros.
--##           
--## INSTRUCCIONES: Configurar los documentos necesarios para precontencioso
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master	
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    TYPE T_TIPO_TFA IS TABLE OF VARCHAR2(350);
    TYPE T_ARRAY_TFA IS TABLE OF T_TIPO_TFA;
    V_TIPO_TFA T_ARRAY_TFA := T_ARRAY_TFA(  
		T_TIPO_TFA('CEHE','Escritura de hipoteca','Primera copia de la escritura de préstamo hipotecario, con carácter ejecutivo y sin haberse emitido otra con tal carácter si es posterior al 30 de noviembre de 2006, si no primera copia'),
		T_TIPO_TFA('RPFDE','Requerimiento de pago ','Requerimiento de pago fehaciente al demandado en el domicilio señalado en la escritura.'),
		T_TIPO_TFA('ANLS','Acta de liquidación y cierre','Acta notarial de Liquidación de saldo.'),
		T_TIPO_TFA('CEEAN','Certificado de deuda','Certificado expedido por la Entidad acreedora, intervenido por Notario.'),
		T_TIPO_TFA('CVIP','Certificado de variación interés','Certificado de la variación del tipo de interés del Préstamo (cuando sea a tipo variable).'),
		T_TIPO_TFA('EDPIN','Extracto de deuda','Extracto de certificación de deuda de Préstamo intervenido por Notario.'),
		T_TIPO_TFA('CSH','Certificación de subsistencia','Certificación de subsistencia de la hipoteca.'),
		T_TIPO_TFA('NSE','Nota simple extensa','Nota simple extensa de la finca objeto de procedimiento.'),
		T_TIPO_TFA('ANDPP','Acta notarial de disposiciones','Acta notarial de disposición de préstamo promotor.'),
		T_TIPO_TFA('ACPSAREB','Acta cesión préstamo ','Acta de cesión del préstamo a Sareb.'),
		T_TIPO_TFA('NSISE','Nota simple','Notas simples en el caso de encontrarse inmuebles susceptibles embargo (no es imprescindible).'),
		T_TIPO_TFA('PSTRCE','Título ejecutivo',' Póliza que sirve de título a la reclamación con carácter ejecutivo.'),
		T_TIPO_TFA('CCAN','Certificado conformidad con el asiento notarial','Certificado Notarial de la conformidad de la póliza con el asiento.'),
		T_TIPO_TFA('AC218','Acta de conformidad 218','Documento fehaciente de conformidad con el artículo 218 del Reglamento Notarial.'),
		T_TIPO_TFA('ECDRE','Efectos cambiarios','Los efectos impagados con la devolución realizada por la Entidad.'),
		T_TIPO_TFA('EDPI','Extracto de devolución','Documento acreditativo de la devolución del efecto o pagaré impagado.'),
		T_TIPO_TFA('PROTN','Protesto notarial','En algunos casos protesto notarial.'),
		T_TIPO_TFA('TTEPPM','Título no ejecutivo','Póliza de Préstamo Mercantil.'),
		T_TIPO_TFA('CLD','Certificado liquidación de deuda','Liquidación practicada por la entidad en la forma pactada por las partes en la Póliza.'),
		T_TIPO_TFA('ICP','Informe de cierre','Informe de cierre del préstamo.'),
		T_TIPO_TFA('CS','Certificado de saldo','Certificación de saldo.')
    ); 
    V_TMP_TIPO_TFA T_TIPO_TFA;
	
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualización tipos de adjunto.');  

	FOR I IN V_TIPO_TFA.FIRST .. V_TIPO_TFA.LAST LOOP
		V_TMP_TIPO_TFA := V_TIPO_TFA(I);

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = ''' || V_TMP_TIPO_TFA(1) || ''' ';

		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS = 1 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO SET DD_TFA_DESCRIPCION = ''' || V_TMP_TIPO_TFA(2)  || 
					''', DD_TFA_DESCRIPCION_LARGA= ''' || V_TMP_TIPO_TFA(3) || ''', FECHAMODIFICAR = SYSDATE, USUARIOMODIFICAR = ''HR-1939''' ||
					' WHERE DD_TFA_CODIGO = ''' || V_TMP_TIPO_TFA(1) || ''' ';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('Actualizando '||V_TMP_TIPO_TFA(1)||' correctamente.');					
		ELSE
			DBMS_OUTPUT.PUT_LINE('El fichero adjunto '||V_TMP_TIPO_TFA(1)||' no existe, no se pudo actualizar.');				
		END IF;
	END LOOP;   
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] Actualización tipos adjunto.');  
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
