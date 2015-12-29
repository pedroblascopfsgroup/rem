--/*
--##########################################
--## AUTOR=JSV
--## FECHA_CREACION=20151228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=
--## PRODUCTO=
--## Finalidad: DML Insertar documentos precontencioso
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
	V_USUARIO_EJECUTA VARCHAR2(25 CHAR):= 'JSV'; -- Usuario que EJECUTA el paquete.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    ERR_BUCLE VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el bucle donde estamos.
		
    --Valores a insertar para fichero adjunto
	/*V_TIPO_TFA T_ARRAY_TFA := T_ARRAY_TFA(  
      T_TIPO_TFA(
      	1.- CODIGO TFA.,
      	2.- TFA DESCRIPCION.,
      	3.- TFA DESCRIPCION_LARGA.,
      	4.- CODIGO TIPO_ACTUACION.)
    ); */
    TYPE T_TIPO_TFA IS TABLE OF VARCHAR2(350);
    TYPE T_ARRAY_TFA IS TABLE OF T_TIPO_TFA;
    V_TIPO_TFA T_ARRAY_TFA := T_ARRAY_TFA(  
		T_TIPO_TFA('CEHE','Escritura de hipoteca','Primera copia de la escritura de préstamo hipotecario, con carácter ejecutivo y sin haberse emitido otra con tal carácter si es posterior al 30 de noviembre de 2006, si no primera copia','PCO'),
		T_TIPO_TFA('RPFDE','Requerimiento de pago ','Requerimiento de pago fehaciente al demandado en el domicilio señalado en la escritura.','PCO'),
		T_TIPO_TFA('ANLS','Acta de liquidación y cierre','Acta notarial de Liquidación de saldo.','PCO'),
		T_TIPO_TFA('CEEAN','Certificado de deuda','Certificado expedido por la Entidad acreedora, intervenido por Notario.','PCO'),
		T_TIPO_TFA('CVIP','Certificado de variación interés','Certificado de la variación del tipo de interés del Préstamo (cuando sea a tipo variable).','PCO'),
		T_TIPO_TFA('EDPIN','Extracto de deuda','Extracto de certificación de deuda de Préstamo intervenido por Notario.','PCO'),
		T_TIPO_TFA('CSH','Certificación de subsistencia','Certificación de subsistencia de la hipoteca.','PCO'),
		T_TIPO_TFA('NSE','Nota simple extensa','Nota simple extensa de la finca objeto de procedimiento.','PCO'),
		T_TIPO_TFA('ANDPP','Acta notarial de disposiciones','Acta notarial de disposición de préstamo promotor.','PCO'),
		T_TIPO_TFA('ACPSAREB','Acta cesión préstamo ','Acta de cesión del préstamo a Sareb.','PCO'),
		T_TIPO_TFA('NSISE','Nota simple','Notas simples en el caso de encontrarse inmuebles susceptibles embargo (no es imprescindible).','PCO'),
		T_TIPO_TFA('PSTRCE','Titulo ejecutivo',' Póliza que sirve de título a la reclamación con carácter ejecutivo.','PCO'),
		T_TIPO_TFA('CCAN','Certificado conformidad con el asiento notarial','Certificado Notarial de la conformidad de la póliza con el asiento.','PCO'),
		T_TIPO_TFA('AC218','Acta de conformidad 218','Documento fehaciente de conformidad con el artículo 218 del Reglamento Notarial.','PCO'),
		T_TIPO_TFA('ECDRE','Efectos cambiarios','Los efectos impagados con la devolución realizada por la Entidad.','PCO'),
		T_TIPO_TFA('EDPI','Extracto de devolución','Documento acreditativo de la devolución del efecto o pagaré impagado.','PCO'),
		T_TIPO_TFA('PROTN','Protesto notarial','En algunos casos protesto notarial.','PCO'),
		T_TIPO_TFA('TTEPPM','Titulo no ejecutivo','Póliza de Préstamo Mercantil.','PCO'),
		T_TIPO_TFA('CLD','Certificado liquidación de deuda','Liquidación practicada por la entidad en la forma pactada por las partes en la Póliza.','PCO'),
		T_TIPO_TFA('ICP','Informe de cierre','Informe de cierre del préstamo.','PCO'),
		T_TIPO_TFA('CS','Certificado de saldo',' Certificación de saldo.','PCO')
    ); 
    V_TMP_TIPO_TFA T_TIPO_TFA;
	
	
	--Valores a insertar para fichero adjunto
	/*V_TIPO_XXX T_ARRAY_XXX := T_ARRAY_XXX(  
      T_TIPO_XXX(
      	1.- CODIGO DOC_UNIDADGESTION.,
      	2.- CODIGO TIPO_PROCEDIMIENTO,
      	3.- CODIGO Documento (TFA),
      	4.- CODIGO TIPO_ACTUACION.)
    ); */
	TYPE T_TIPO_PCO IS TABLE OF VARCHAR2(350);
	TYPE T_ARRAY_PCO IS TABLE OF T_TIPO_PCO;
    V_TIPO_PCO T_ARRAY_PCO := T_ARRAY_PCO( 
		T_TIPO_PCO('CO','H001','CLD','PCO'),
		T_TIPO_PCO('CO','H001','CS','PCO'),
		T_TIPO_PCO('CO','H001','ACPSAREB','PCO'),
		T_TIPO_PCO('CO','H001','AC218','PCO'),
		T_TIPO_PCO('CO','H001','AC218','PCO'),
		T_TIPO_PCO('CO','H001','CLD','PCO'),
		T_TIPO_PCO('CO','H001','AC218','PCO'),
		T_TIPO_PCO('CO','H001','CS','PCO'),
		T_TIPO_PCO('CO','H001','ACPSAREB','PCO'),
		T_TIPO_PCO('CO','H001','ACPSAREB','PCO'),
		T_TIPO_PCO('CO','H018','CS','PCO'),
		T_TIPO_PCO('CO','H020','CS','PCO'),
		T_TIPO_PCO('CO','H020','AC218','PCO'),
		T_TIPO_PCO('CO','H020','ACPSAREB','PCO'),
		T_TIPO_PCO('CO','H020','ACPSAREB','PCO'),
		T_TIPO_PCO('CO','H020','AC218','PCO'),
		T_TIPO_PCO('CO','H020','CS','PCO'),
		T_TIPO_PCO('CO','H020','CLD','PCO'),
		T_TIPO_PCO('CO','H016','CLD','PCO'),
		T_TIPO_PCO('CO','H016','CLD','PCO'),
		T_TIPO_PCO('CO','H016','AC218','PCO'),
		T_TIPO_PCO('CO','H016','CS','PCO'),
		T_TIPO_PCO('CO','H022','CS','PCO'),
		T_TIPO_PCO('CO','H022','AC218','PCO'),
		T_TIPO_PCO('CO','H022','CS','PCO'),
		T_TIPO_PCO('CO','H022','AC218','PCO'),
		T_TIPO_PCO('CO','H022','CS','PCO'),
		T_TIPO_PCO('CO','H024','CS','PCO'),
		T_TIPO_PCO('CO','H024','AC218','PCO'),
		T_TIPO_PCO('CO','H024','CS','PCO'),
		T_TIPO_PCO('CO','H024','CS','PCO'),
		T_TIPO_PCO('CO','H026','CS','PCO'),
		T_TIPO_PCO('CO','H026','AC218','PCO'),
		T_TIPO_PCO('CO','H026','CS','PCO'),
		T_TIPO_PCO('CO','H026','CS','PCO'),
		T_TIPO_PCO('CO','H009','AC218','PCO')
	 ); 
    V_TMP_TIPO_PCO T_TIPO_PCO;
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando con Documentos para Precontencioso');  

	DBMS_OUTPUT.PUT_LINE('[INICIO-DD_TFA_FICHERO_ADJUNTO] Insertamos los tipos de ficheros adjunto para Precontencioso - DD_TFA_FICHERO_ADJUNTO');  
	ERR_BUCLE :='DD_TFA_FICHERO_ADJUNTO';

	FOR I IN V_TIPO_TFA.FIRST .. V_TIPO_TFA.LAST LOOP
		V_TMP_TIPO_TFA := V_TIPO_TFA(I);
		-- Creamos el fichero adjunto si no existe
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''' || V_TMP_TIPO_TFA(1) || ''' ';
		--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID,DD_TFA_CODIGO,DD_TFA_DESCRIPCION,DD_TFA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,DD_TAC_ID) VALUES ('
				|| V_ESQUEMA ||'.S_DD_TFA_FICHERO_ADJUNTO.nextval,'
				|| '''' || V_TMP_TIPO_TFA(1) || ''','
				|| '''' || V_TMP_TIPO_TFA(2) || ''','
				|| '''' || V_TMP_TIPO_TFA(3) || ''','
				|| '''' || V_USUARIO_EJECUTA || ''', SYSDATE, (SELECT DD_TAC_ID FROM ' || V_ESQUEMA || '.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' || V_TMP_TIPO_TFA(4) || ''' ) )';
			--DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('Creado el fichero adjunto de codigo '||V_TMP_TIPO_TFA(1)||' correctamente.');					
		ELSE --fichero adjunto ya existe
			DBMS_OUTPUT.PUT_LINE('El  fichero adjunto '||V_TMP_TIPO_TFA(1)||' ya existe, NO se creará de nuevo otra vez.');				
		END IF;	 --fin Si no existe el fichero adjunto lo damos de alta
	END LOOP;   

	DBMS_OUTPUT.PUT_LINE('[FIN-DD_TFA_FICHERO_ADJUNTO] Insertamos los tipos de ficheros adjunto para Precontencioso - DD_TFA_FICHERO_ADJUNTO');  
	COMMIT;

	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO-PCO_CDE_CONF_TFA_TIPOENTIDAD] Insertamos las Unidad de gestión documentos para Precontencioso - PCO_CDE_CONF_TFA_TIPOENTIDAD');  
	ERR_BUCLE :='PCO_CDE_CONF_TFA_TIPOENTIDAD';	
	FOR I IN V_TIPO_PCO.FIRST .. V_TIPO_PCO.LAST LOOP
		V_TMP_TIPO_PCO := V_TIPO_PCO(I);
		
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_CDE_CONF_TFA_TIPOENTIDAD WHERE '
			|| 'DD_PCO_DTD_ID = (SELECT DD_PCO_DTD_ID FROM '||V_ESQUEMA||'.DD_PCO_DOC_UNIDADGESTION WHERE DD_PCO_DTD_CODIGO = ''' || V_TMP_TIPO_PCO(1) || ''' )'
			|| 'AND DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || V_TMP_TIPO_PCO(2) || ''' )'
			|| 'AND DD_TFA_ID = (SELECT DD_TFA_ID FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = ''' || V_TMP_TIPO_PCO(3) || ''' AND DD_TAC_ID = ' 
			|| '(SELECT DD_TAC_ID FROM ' || V_ESQUEMA || '.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' ||  V_TMP_TIPO_PCO(4) || ''' ) ) '
		;
		--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS < 1 THEN
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_CDE_CONF_TFA_TIPOENTIDAD (PCO_CDE_ID,DD_PCO_DTD_ID,DD_TPO_ID,DD_TFA_ID,USUARIOCREAR,FECHACREAR,PCO_REQ_LIQUIDA) VALUES ('
				|| V_ESQUEMA ||'.S_PCO_CDE_CONF_TFA_TIPOENTIDAD.nextval,'
				|| '(SELECT DD_PCO_DTD_ID FROM '||V_ESQUEMA||'.DD_PCO_DOC_UNIDADGESTION WHERE DD_PCO_DTD_CODIGO = ''' || V_TMP_TIPO_PCO(1) || ''' ),'
				|| '(SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || V_TMP_TIPO_PCO(2) || ''' ),'
				|| '(SELECT DD_TFA_ID FROM ' || V_ESQUEMA || '.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = ''' || V_TMP_TIPO_PCO(3) || ''' AND DD_TAC_ID = ' 
				|| 				'(SELECT DD_TAC_ID FROM ' || V_ESQUEMA || '.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' ||  V_TMP_TIPO_PCO(4) || ''' ) ),'
				|| '''' || V_USUARIO_EJECUTA || ''', SYSDATE, 0 )'
			;
			--DBMS_OUTPUT.PUT_LINE(V_MSQL);	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Creado la Unidad de gestión documentos '|| V_TMP_TIPO_PCO(1) || '-' ||  V_TMP_TIPO_PCO(2) || '-'  || V_TMP_TIPO_PCO(3) ||' correctamente.');	
		ELSE --Unidad de gestión documentos ya existe
			DBMS_OUTPUT.PUT_LINE('La Unidad de gestión documentos '|| V_TMP_TIPO_PCO(1) || '-' ||  V_TMP_TIPO_PCO(2) || '-'  || V_TMP_TIPO_PCO(3) ||' ya existe, NO se creará de nuevo otra vez.');				
		END IF;	 --fin Si no existe Unidad de gestión documentos lo damos de alta

	END LOOP; 
	DBMS_OUTPUT.PUT_LINE('[FIN-PCO_CDE_CONF_TFA_TIPOENTIDAD] Insertamos los tipos de Unidad de gestión documentos para Precontencioso - PCO_CDE_CONF_TFA_TIPOENTIDAD');  
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] Documentos para Precontencioso');  
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
	DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución del bucle:'||ERR_BUCLE);
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/

EXIT;