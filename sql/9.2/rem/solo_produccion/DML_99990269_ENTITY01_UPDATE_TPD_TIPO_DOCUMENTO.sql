--/*
--######################################### 
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180320
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-289
--## PRODUCTO=NO
--## 
--## Finalidad: Insercion de datos en el historico de informes comerciales
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_TABLA VARCHAR2(30 CHAR) := 'DD_TPD_TIPO_DOCUMENTO';  -- Tabla a modificar
  V_USR VARCHAR2(30 CHAR) := 'REMVIP-289'; -- USUARIOCREAR/USUARIOMODIFICAR

    --Array que contiene los registros que se van a insertar
    TYPE T_DATA is table of VARCHAR2(250); 
    TYPE T_ARRAY IS TABLE OF T_DATA;
    V_FOR T_ARRAY := T_ARRAY(
         T_DATA('Acta de Subasta','AI-01-ESCR-26'),
		 T_DATA('Alquiler: contrato','AI-02-CNCV-04'),
		 T_DATA('Alquiler: contrato con opción a compra','AI-02-CNCV-05'),
		 T_DATA('Alquiler: justificante deposito fianza','AI-02-CERJ-54'),
		 T_DATA('Alquiler: Liquidación contrato','AI-02-CERJ-78'),
		 T_DATA('Auto moratoria','AI-02-DOCJ-AK'),
		 T_DATA('Auto ocupantes','AI-02-SERE-48'),
		 T_DATA('Autorización venta VPO','AI-11-ACUE-07'),
		 T_DATA('Boletín agua','AI-09-CERT-07'),
		 T_DATA('Boletín electricidad','AI-09-CERT-10'),
		 T_DATA('Boletín gas','AI-09-CERT-11'),
		 T_DATA('Catastro: Alteración de titular por adjudicación (MOD 901, 902, 903, 904)','AI-01-DECL-01'),
		 T_DATA('Catastro: Alteración de titular por venta  (MOD 901, 902, 903, 904)','AI-11-DECL-01'),
		 T_DATA('Catastro: declaración de alteración','AI-11-DECL-01'),
		 T_DATA('Cédula de habitabilidad','AI-09-LIPR-03'),
		 T_DATA('CEE (Certificado de eficiencia energética)','AI-10-CERT-05'),
		 T_DATA('CEE (Etiqueta de eficiencia energética)','AI-05-CERT-25'),
		 T_DATA('CEE (Justificante de presentación en registro)','AI-01-CERA-71'),
		 T_DATA('Certificado sustitutivo de Cédula de Habitabilidad','AI-09-LIPR-14'),
		 T_DATA('CFO (Certificado de final de obra)','AI-08-CERT-17'),
		 T_DATA('Comunicación de oferta a la Administración','AI-11-CERJ-65'),
		 T_DATA('Contrato alquiler','AI-02-CNCV-04'),
		 T_DATA('Contrato ampliación arras','AI-11-CNCV-79'),
		 T_DATA('Contrato de reserva','AI-11-CNCV-50'),
		 T_DATA('Copia simple escritura de venta','AI-11-ESCR-10'),
		 T_DATA('Decreto adjudicación','AI-01-SERE-24'),
		 T_DATA('Decreto adjudicación (Testimonio)','AI-01-SERE-26'),
		 T_DATA('Diligencia judicial de la posesión','AI-02-DOCJ-AI'),
		 T_DATA('Diligencia judicial del lanzamiento','AI-02-DOCJ-AJ'),
		 T_DATA('Edicto de Subasta','AI-01-PBLO-28'),
		 T_DATA('Escritura de compraventa (titularidad)','AI-01-ESCR-10'),
		 T_DATA('Escritura de permuta','AI-01-ESCR-14'),
		 T_DATA('Escritura pública inscrita','AI-01-ESCR-26'),
		 T_DATA('Impuesto de transmisiones patrimoniales (ITP) y Actos Jurídicos Documentados (AJD)','AI-01-CERA-14'),
		 T_DATA('Informe del trabajo realizado','AI-03-ESIN-34'),
		 T_DATA('Informe jurídico','AI-09-ESIN-90'),
		 T_DATA('Informe okupación y/o desokupacion','AI-02-ESIN-97'),
		 T_DATA('Informes','AI-01-FICH-05'),
		 T_DATA('Justificante ingreso importe compraventa','AI-11-CERA-45'),
		 T_DATA('Justificante ingreso reserva','AI-11-CERA-32'),
		 T_DATA('Liquidación plusvalía','AI-11-CERA-15'),
		 T_DATA('Listado de actualización de precios','AI-05-ESIN-BB'),
		 T_DATA('LPO (Licencia de primera ocupación)','AI-09-LIPR-06'),
		 T_DATA('Mandamiento cancelación cargas','AI-01-SERE-25'),
		 T_DATA('Nota simple actualizada','AI-01-NOTS-01'),
		 T_DATA('Nota simple sin cargas','AI-01-NOTS-01'),
		 T_DATA('Obra: certificado instalación eléctrica','AI-09-CERT-28'),
		 T_DATA('Obra: certificado instalación térmica','AI-09-CERT-27'),
		 T_DATA('Posesión activo: acta de posesión','AI-02-DOCJ-14'),
		 T_DATA('Posesión activo: moratoria suspensión lanzamiento','AI-02-DOCJ-AK'),
		 T_DATA('Posesión: acta de lanzamiento','AI-02-DOCJ-15'),
		 T_DATA('Presupuesto','AI-03-PRES-07'),
		 T_DATA('Propuesta de precios enviada','AI-05-ESIN-AN'),
		 T_DATA('Propuesta de precios generada','AI-05-ESIN-AM'),
		 T_DATA('Propuesta de precios sancionada','AI-05-ESIN-AO'),
		 T_DATA('Reclamación al letrado del titulo firme','AI-01-COMU-80'),
		 T_DATA('Registro Propiedad: calificación y/o inscripción','AI-01-INRG-08'),
		 T_DATA('Registro Propiedad: certificación dominio y cargas','AI-01-CERJ-47'),
		 T_DATA('Resolución tanteo por la Administración','AI-11-ACUI-25'),
		 T_DATA('Respuesta propietario incremento de presupuesto','AI-03-PRES-15'),
		 T_DATA('Retrocesión de la venta','AI-11-CNCV-51'),
		 T_DATA('Subsanación de escritura de venta','AI-11-ESCR-43'),
		 T_DATA('Tasación adjudicación','AI-04-TASA-11'),
		 T_DATA('Testimonio decreto adjudicación','AI-01-SERE-26'),
		 T_DATA('Título inscrito','AI-01-DOCJ-70'),
		 T_DATA('VPO: Notificación adjudicación para tanteo','AI-05-COMU-74'),
		 T_DATA('VPO: Solicitud autorización venta','AI-11-ACUE-07'),
		 T_DATA('VPO: Solicitud importe devolución ayudas','AI-05-PRPE-38')
    );
    V_TMP T_DATA;   
BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comienza el proceso de actualización de registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'...');
  
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comprovaciones previas...');
  -- Verificar si la tabla ya existe
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  IF V_NUM_TABLAS = 1 THEN
    
    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla ' ||V_ESQUEMA|| '.'||V_TABLA||'... Existe.');  

    FOR I IN V_FOR.FIRST .. V_FOR.LAST 
    LOOP
      V_TMP := V_FOR(I);  
      
        V_MSQL := 'SELECT COUNT(1) FROM ' ||V_ESQUEMA|| '.'||V_TABLA||' WHERE TRIM(DD_TPD_DESCRIPCION_LARGA) = '''||V_TMP(1)||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
		IF V_NUM_TABLAS = 1 THEN
		
			DBMS_OUTPUT.PUT_LINE('    [INFO] Actualizando matricula de... '||V_TMP(1)||'...');
			  
			  EXECUTE IMMEDIATE '
			  UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
				SET
				  DD_TPD_MATRICULA_GD = '''||V_TMP(2)||''',
				  USUARIOMODIFICAR = '''||V_USR||''',
				  FECHAMODIFICAR = SYSDATE
				WHERE TRIM(DD_TPD_DESCRIPCION_LARGA) = '''||V_TMP(1)||'''             
			  '
			  ;
			  DBMS_OUTPUT.PUT_LINE('    [INFO] Matricula de '||V_TMP(1)||' actualizada');
		ELSE
			  DBMS_OUTPUT.PUT_LINE('  [INFO] El tipo de documento '||V_TMP(1)||'... No existe.');
		END IF;
      
    END LOOP;

    COMMIT;
    
  ELSE
    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA|| '.'||V_TABLA||'... No existe.');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]');    

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
