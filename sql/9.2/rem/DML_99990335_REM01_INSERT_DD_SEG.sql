--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180528
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-783
--## PRODUCTO=NO
--## 
--## Finalidad: 
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

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(30 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(30 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(30 CHAR):= 'DD_SEG_SUBTIPO_ERROR_GASTO';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR):= 'REMVIP-783';
	DD_SEG_DESCRIPCION VARCHAR2(250 CHAR);
	DD_SEG_CODIGO VARCHAR2(50 CHAR);
	DD_TEG_CODIGO VARCHAR2(50 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);

    TYPE T_JBV IS TABLE OF VARCHAR2(250 CHAR);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV('Pasa controles UVEM', '000','04'),
		T_JBV('Código de Cliente (arrendatario) no existe en URSUS', '001','04'),
		T_JBV('Documento arrendatario no coincide con  el registrado en URSUS', '002','04'),
		T_JBV('Tipo de recibo desconocido', '003','04'),
		T_JBV('Concepto Contable no se ajusta a la acción', '004','04'),
		T_JBV('Tipo de Operación no admitida para acción.', '005','04'),
		T_JBV('Distintas Sociedades pagadoras en la misma factura', '006','04'),
		T_JBV('Distintas Sociedades propietarias en la misma factura', '007','04'),
		T_JBV('Falta usuario autorizador', '008','04'),
		T_JBV('Usuario que autoriza no válido', '009','04'),
		T_JBV('Falta Activo', '021','04'),
		T_JBV('Sin fecha de emisión', '022','04'),
		T_JBV('Faltan datos para obtener la sociedad de la factura', '023','04'),
		T_JBV('ERRORES EN LINEA DE FACTURA', '100','04'),
		T_JBV('TIPO DE FACTURA ERRONEO', '101','04'),
		T_JBV('TRAE ACTIVO Y TIPO DE FACTURA ES SIN ACTIVO', '102','04'),
		T_JBV('SIN FECHA DE DEVENGO', '103','04'),
		T_JBV('SIN IMPORTE DEL GASTO', '104','04'),
		T_JBV('NO EXISTE LA ACCIÓN', '105','04'),
		T_JBV('ACCION DE TIPO D NO ADMITIDA PARA ESTE TIPODE FACTURA', '106','04'),
		T_JBV('NO EXISTE EL PROVEEDOR', '107','04'),
		T_JBV('USUARIO AUTORIZADOR NO EXISTE EN TABLA DE PARAMETROS', '108','04'),
		T_JBV('No encuentra el Centro de la Conexión en la Entidad', '119', '06'),
		T_JBV('RETORNO DE GMNKNM28 CON ERROR', '300','04'),
		T_JBV('NO EXISTE EL PROVEEDOR', '301','04'),
		T_JBV('USUARIO AUTORIZADOR NO EXISTE EN TABLA DE PARAMETROS', '302','04'),
		T_JBV('ERROR EN LINEAS DE FACTURA', '400','04'),
		T_JBV('IMPORTE CERO EN LÍNEA DE FACTURA', '401','04'),
		T_JBV('IMPORTE CERO EN CABECERA DE FACTURA', '402','04'),
		T_JBV('NO COINCIDE IMPORTE CABECERA CON SUMA IMPORTES LINEAS', '403','04'),
		T_JBV('FACTURA CON LINEAS SIN IMPORTE', '404','04'),
		T_JBV('IMPORTE BASE DE IMPUESTO DIRECTO DISTINTO CERO Y TIPO CERO', '405','04'),
		T_JBV('SOCIEDAD PAGADORA NO VÁLIDA', '406','04'),
		T_JBV('FECHA DE DEVENGO INVÁLIDA', '407','04'),
		T_JBV('CONCEPTO CONTABLE NO VALIDO', '408','04'),
		T_JBV('ERROR EN DATOS IMPUESTO DIRECTO', '409','04'),
		T_JBV('FORMA DE PAGO INVALIDA', '410','04'),
		T_JBV('MODALIDAD DE PAGO INVALIDA', '411','04'),
		T_JBV('FORMA Y MODALIDAD DE PAGO NO SE CORRESPONDEN', '412','04'),
		T_JBV('CODIGO TIPO OPERACIÓN INVALIDO', '413','04'),
		T_JBV('TIPO OPERACIÓN INCOMPATIBLE CON IMPORTE', '414','04'),
		T_JBV('ERROR EN DATOS CONEXIÓN', '415','04')
	); 
	V_TMP_JBV T_JBV;

BEGIN

	PL_OUTPUT := '[INICIO]' || CHR(10);

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	LOOP

		V_TMP_JBV := V_JBV(I);

			DD_SEG_DESCRIPCION  := UPPER(SUBSTR(TRIM(V_TMP_JBV(1)),1,1)) || LOWER(SUBSTR(TRIM(V_TMP_JBV(1)),2));
			DD_SEG_CODIGO  := TRIM(V_TMP_JBV(2));
			DD_TEG_CODIGO  := TRIM(V_TMP_JBV(3));

		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (DD_SEG_ID, DD_TEG_ID, DD_SEG_CODIGO, DD_SEG_DESCRIPCION, DD_SEG_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
			SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL, TEG.DD_TEG_ID, '''||DD_SEG_CODIGO||''', '''||DD_SEG_DESCRIPCION||''', '''||DD_SEG_DESCRIPCION||''', '''||V_USUARIO||''', SYSDATE
			FROM '||V_ESQUEMA||'.DD_TEG_TIPO_ERROR_GASTO TEG
			WHERE TEG.DD_TEG_CODIGO = '''||DD_TEG_CODIGO||''' AND NOT EXISTS (
					SELECT 1
					FROM '||V_ESQUEMA||'.'||V_TABLA||' SEG
					WHERE SEG.DD_TEG_ID = TEG.DD_TEG_ID AND SEG.DD_SEG_CODIGO = '''||DD_SEG_CODIGO||'''
				)';
		EXECUTE IMMEDIATE V_SQL;
		
		IF SQL%ROWCOUNT = 1 THEN
			PL_OUTPUT := PL_OUTPUT || '	[INFO] Se ha creado el subtipo error de gasto ' || DD_SEG_DESCRIPCION || CHR(10);
		ELSIF SQL%ROWCOUNT = 0 THEN
			PL_OUTPUT := PL_OUTPUT || '	[INFO] Ya existe el subtipo error de gasto ' || DD_SEG_DESCRIPCION || CHR(10);
		END IF;

	END LOOP;

	PL_OUTPUT := PL_OUTPUT || '[FIN]' || CHR(10);

	COMMIT;

	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE) || CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------' || CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM || CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
