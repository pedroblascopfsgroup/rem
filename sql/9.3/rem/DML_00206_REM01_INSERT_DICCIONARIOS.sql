--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20200617
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10391
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade registros a distintos diccionarios.
--## INSTRUCCIONES:
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
	V_NUM NUMBER(16); 
	
	V_USU VARCHAR2(30 CHAR) := 'HREOS-10391'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

	TYPE T_VAR IS TABLE OF VARCHAR2(100);
	TYPE T_ARRAY_VAR IS TABLE OF T_VAR;
	V_VAR T_ARRAY_VAR := T_ARRAY_VAR(
	-- 			TABLA 							TAG 		CODIGO 		DESCRIPCIÓN
		T_VAR('DD_SNA_SI_NO_NA', 				'SNA',		'SI', 		'Sí'), 
		T_VAR('DD_SNA_SI_NO_NA', 				'SNA',		'NO', 		'No'),
		T_VAR('DD_SNA_SI_NO_NA', 				'SNA',		'NA', 		'No Aplica'),
				
		T_VAR('DD_SII_SIT_INI_INSCRIPCION', 	'SII',		'INS', 		'Inscrita'),
		T_VAR('DD_SII_SIT_INI_INSCRIPCION', 	'SII',		'PDTE', 	'Pendiente Inscripción'),
				
		T_VAR('DD_SPI_SIT_POSESORIA_INI', 		'SPI',		'PDTE', 	'Pendiente obtención'),
		T_VAR('DD_SPI_SIT_POSESORIA_INI', 		'SPI',		'OBT', 		'Obtenida en procedimiento judicial'),
		T_VAR('DD_SPI_SIT_POSESORIA_INI', 		'SPI',		'COM', 		'Dación/compraventa (comprobada)'),
		T_VAR('DD_SPI_SIT_POSESORIA_INI', 		'SPI',		'ARR', 		'Arrendada'),
		T_VAR('DD_SPI_SIT_POSESORIA_INI', 		'SPI',		'PRE', 		'Precario'),
		T_VAR('DD_SPI_SIT_POSESORIA_INI', 		'SPI',		'NPR', 		'Nuda propiedad'),
				
		T_VAR('DD_SIC_SIT_INI_CARGAS', 			'SIC',		'PRP', 		'Propias'),
		T_VAR('DD_SIC_SIT_INI_CARGAS', 			'SIC',		'AJE', 		'Ajenas'),
		T_VAR('DD_SIC_SIT_INI_CARGAS', 			'SIC',		'AFF', 		'Libre de cargas salvo afecciones fiscales'),
		T_VAR('DD_SIC_SIT_INI_CARGAS', 			'SIC',		'PUR', 		'Las cargas se purgan con la inscripción'),
		T_VAR('DD_SIC_SIT_INI_CARGAS', 			'SIC',		'PRE', 		'Título judicial/Preferentes'),
		T_VAR('DD_SIC_SIT_INI_CARGAS', 			'SIC',		'ANT', 		'Título judicial/Anteriores'),
				
		T_VAR('DD_TTI_TIPO_TITULARIDAD', 		'TTI',		'PLD', 		'Pleno dominio'),
		T_VAR('DD_TTI_TIPO_TITULARIDAD', 		'TTI',		'NPR', 		'Nuda propiedad'),
		T_VAR('DD_TTI_TIPO_TITULARIDAD', 		'TTI',		'USU', 		'Usufructo'),
				
		T_VAR('DD_AUT_AUTORIZ_TRANSMISION', 	'AUT',		'OBT', 		'Obtenida'),
		T_VAR('DD_AUT_AUTORIZ_TRANSMISION', 	'AUT',		'PDTE', 	'Pendiente'),
				
		T_VAR('DD_ANC_ANOTACION_CONCURSO', 		'ANC',		'VIG', 		'Vigente'),
		T_VAR('DD_ANC_ANOTACION_CONCURSO', 		'ANC',		'CAN', 		'Cancelada'),
				
		T_VAR('DD_ESG_ESTADO_GESTION', 			'ESG',		'TRA', 		'En Trámite'),
		T_VAR('DD_ESG_ESTADO_GESTION', 			'ESG',		'FIN', 		'Terminado'),
				
		T_VAR('DD_CFO_CERTIFICADO_FIN_OBRA', 	'CFO',		'PDTE', 	'Pendiente'),
		T_VAR('DD_CFO_CERTIFICADO_FIN_OBRA', 	'CFO',		'OBT', 		'Obtenido'),
				
		T_VAR('DD_AFO_ACTA_FIN_OBRA', 			'AFO',		'PDTE', 	'Pendiente'),
		T_VAR('DD_AFO_ACTA_FIN_OBRA', 			'AFO',		'OBT', 		'Obtenido'),
				
		T_VAR('DD_LPO_LIC_PRIMERA_OCUPACION', 	'LPO',		'PDTE', 	'Pendiente'),
		T_VAR('DD_LPO_LIC_PRIMERA_OCUPACION', 	'LPO',		'OBT', 		'Obtenido'),
				
		T_VAR('DD_BOL_BOLETINES', 				'BOL',		'PDTE', 	'Pendiente'),
		T_VAR('DD_BOL_BOLETINES', 				'BOL',		'OBT', 		'Obtenido'),
				
		T_VAR('DD_SDC_SEGURO_DECENAL', 			'SDC',		'PDTE', 	'Pendiente'),
		T_VAR('DD_SDC_SEGURO_DECENAL', 			'SDC',		'OBT', 		'Obtenido'),
				
		T_VAR('DD_CEH_CEDULA_HABITABILIDAD', 	'CEH',		'PDTE', 	'Pendiente'),
		T_VAR('DD_CEH_CEDULA_HABITABILIDAD', 	'CEH',		'OBT', 		'Obtenido'),
		T_VAR('DD_CEH_CEDULA_HABITABILIDAD', 	'CEH',		'NA', 		'No Aplica'),
				
		T_VAR('DD_TIA_TIPO_ARRENDAMIENTO', 		'TIA',		'VIV', 		'Urbano/vivienda'),
		T_VAR('DD_TIA_TIPO_ARRENDAMIENTO', 		'TIA',		'DIS_VIV', 	'Urbano/uso distinto vivienda'),
		T_VAR('DD_TIA_TIPO_ARRENDAMIENTO', 		'TIA',		'RUS', 		'Rústico'),
				
		T_VAR('DD_TEA_TIPO_EXP_ADM', 			'TEA',		'EXF', 		'Expropiación forzosa'),
		T_VAR('DD_TEA_TIPO_EXP_ADM', 			'TEA',		'SAN', 		'Sancionador'),
		T_VAR('DD_TEA_TIPO_EXP_ADM', 			'TEA',		'EJO', 		'Ejecución obras'),
				
		T_VAR('DD_TIR_TIPO_INCI_REGISTRAL', 	'TIR',		'01', 		'Discrepancia físico-jurídica/Exceso cabida > al 20%'),
		T_VAR('DD_TIR_TIPO_INCI_REGISTRAL', 	'TIR',		'02', 		'Discrepancia físico-jurídica/Exceso cabida < al 20%'),
		T_VAR('DD_TIR_TIPO_INCI_REGISTRAL', 	'TIR',		'03', 		'Discrepancia físico-jurídica/Sin inmatricular'),
		T_VAR('DD_TIR_TIPO_INCI_REGISTRAL', 	'TIR',		'04', 		'Discrepancia físico-jurídica/Cambio de uso'),
		T_VAR('DD_TIR_TIPO_INCI_REGISTRAL', 	'TIR',		'05', 		'Discrepancia físico-jurídica/Cambio descripción registral'),
		T_VAR('DD_TIR_TIPO_INCI_REGISTRAL', 	'TIR',		'06', 		'Discrepancia físico-jurídica/División horizontal'),
		T_VAR('DD_TIR_TIPO_INCI_REGISTRAL', 	'TIR',		'07', 		'Construcción ilegal/Irregularidades urbanísticas'),
		T_VAR('DD_TIR_TIPO_INCI_REGISTRAL', 	'TIR',		'08', 		'Construcción ilegal/Fuera de ordenación'),
		T_VAR('DD_TIR_TIPO_INCI_REGISTRAL', 	'TIR',		'09', 		'Activo irregular'),
				
		T_VAR('DD_TOL_TIPO_OCUPACION_LEGAL', 	'TOL',		'USU', 		'Usufructuario'),
		T_VAR('DD_TOL_TIPO_OCUPACION_LEGAL', 	'TOL',		'PRE', 		'Precarista'),
		T_VAR('DD_TOL_TIPO_OCUPACION_LEGAL', 	'TOL',		'NA', 		'No aplica'),
				
		T_VAR('DD_STA_SUBTIPOLOGIA_AGENDA', 	'STA',		'TIJ', 		'Título judicial'),
		T_VAR('DD_STA_SUBTIPOLOGIA_AGENDA', 	'STA',		'SUN', 		'Subasta notarial'),
		T_VAR('DD_STA_SUBTIPOLOGIA_AGENDA', 	'STA',		'DEP', 		'Dación en pago'),
		T_VAR('DD_STA_SUBTIPOLOGIA_AGENDA', 	'STA',		'CV', 		'Compraventa')
	); 
	V_TMP_VAR T_VAR;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_VAR.FIRST .. V_VAR.LAST LOOP
		V_TMP_VAR := V_VAR(I);
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Verificando si la tabla '''||V_TMP_VAR(1)||''' existe...');
		V_SQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TMP_VAR(1)||''' AND OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
		IF V_NUM = 1 THEN
			DBMS_OUTPUT.PUT_LINE('	[INFO] Añadiendo el registro '''||V_TMP_VAR(3)||'''...');
			V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TMP_VAR(1)||''' AND COLUMN_NAME = '''||V_TMP_VAR(3)||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM;
			
			IF V_NUM = 0 THEN
				V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TMP_VAR(1)||' (
					DD_'||V_TMP_VAR(2)||'_ID,
					DD_'||V_TMP_VAR(2)||'_CODIGO,
					DD_'||V_TMP_VAR(2)||'_DESCRIPCION,
					DD_'||V_TMP_VAR(2)||'_DESCRIPCION_LARGA,
					USUARIOCREAR,
					FECHACREAR,
					VERSION,
					BORRADO
				)
				VALUES(
					'||V_ESQUEMA||'.S_'||V_TMP_VAR(1)||'.NEXTVAL,
					'''||V_TMP_VAR(3)||''',
					'''||V_TMP_VAR(4)||''',
					'''||V_TMP_VAR(4)||''',
					'''||V_USU||''',
					SYSDATE,
					0,
					0
				)';
				EXECUTE IMMEDIATE V_SQL;
				DBMS_OUTPUT.PUT_LINE('	[OK] Campo añadido.');
				
			ELSE
				DBMS_OUTPUT.PUT_LINE('	[ERROR] El campo ya existe.');
			END IF;
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[ERROR] La tabla '''||V_TMP_VAR(1)||''' no existe.');
		END IF;
	END LOOP;
	
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: Tablas actualizadas correctamente.');


EXCEPTION
	WHEN OTHERS THEN
		err_num := SQLCODE;
		err_msg := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(err_msg);
		ROLLBACK;
		RAISE;          

END;
/
EXIT
