--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160413
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.3
--## INCIDENCIA_LINK= PRODUCTO-1243
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar los tipos de soluciones y sus campos correspondientes según la versión 3 del funcional
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    
    V_NUM NUMBER;
    V_ENT_AMBAS NUMBER;
    V_DD_TPA_ID NUMBER;
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ENTIDAD_ACUERDO WHERE DD_ENT_ACU_COD = ''AMBAS'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM > 0 THEN
		V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_ENTIDAD_ACUERDO WHERE DD_ENT_ACU_COD = ''AMBAS'' AND BORRADO = 0 AND ROWNUM=1';
		EXECUTE IMMEDIATE V_SQL INTO V_ENT_AMBAS;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tipo entidad acuerdo AMBAS, id: '||V_ENT_AMBAS);
		
		--******************** 01 (Dación en pago) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Dación en pago, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID) 
						VALUES ('||V_DD_TPA_ID||',''01'',''Dación en pago'',''Dación en pago'',0,''DML'',SYSDATE,0,'||V_ENT_AMBAS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Dación en pago creado con DD_TAP_ID: '||V_DD_TPA_ID);
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Dación en pago con DD_TPA_ID: '||V_DD_TPA_ID);
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID = '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''01'' AND DD_TPA_ID <> '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;			
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Dación en pago activado');
		END IF;
		
		----------------------------------------- 01 - Solicitar alquiler -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''solicitarAlquiler''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Solicitar Alquiler para el tipo acuerdo Dación en pago, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''solicitarAlquiler'',0,''DML'',SYSDATE,0,''Solicitar alquiler'',''combobox'',''1,Si;0,No'')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Solicitar Alquiler para el tipo acuerdo Dación en pago, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Solicitar Alquiler para el tipo acuerdo Dación en pago, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''solicitarAlquiler'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Solicitar Alquiler para el tipo acuerdo Dación en pago, activado.');
		END IF;
		
		----------------------------------------- 01 - Liquidez aportada -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''liquidez''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Liquidez aportada para el tipo acuerdo Dación en pago, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''liquidez'',0,''DML'',SYSDATE,0,''Liquidez aportada'',''number'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Liquidez aportada para el tipo acuerdo Dación en pago, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Liquidez aportada para el tipo acuerdo Dación en pago, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''liquidez'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Liquidez aportada para el tipo acuerdo Dación en pago, activado');
		END IF;
		
		----------------------------------------- 01 - Nº WorkFlow -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nº WorkFlow para el tipo acuerdo Dación en pago, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''nWorkflow'',0,''DML'',SYSDATE,0,''Nº WorkFlow'',''text'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº WorkFlow para el tipo acuerdo Dación en pago, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nº WorkFlow para el tipo acuerdo Dación en pago, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº WorkFlow para el tipo acuerdo Dación en pago, activado.');
		END IF;
		
		----------------------------------------- 01 - Capaña Sareb -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Capaña Sareb para el tipo acuerdo Dación en pago, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''campSareb'',0,''DML'',SYSDATE,0,''Capaña Sareb'',''text'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Capaña Sareb para el tipo acuerdo Dación en pago, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Capaña Sareb para el tipo acuerdo Dación en pago, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Capaña Sareb para el tipo acuerdo Dación en pago, activado');
		END IF;
		
		----------------------------------------- 01 - Fecha prevista firma -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha prevista firma para el tipo acuerdo Dación en pago, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''fechaPrevistaFirma'',0,''DML'',SYSDATE,0,''Fecha prevista firma'',''fecha'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha prevista firma para el tipo acuerdo Dación en pago, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha prevista firma para el tipo acuerdo Dación en pago, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha prevista firma para el tipo acuerdo Dación en pago, activado');
		END IF;		
		
		-- Borramos el resto de campos para el tipo de acuerdo Dación/Compraventa
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Dación/Compraventa');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
					WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''fechaPrevistaFirma'',''solicitarAlquiler'',''liquidez'',''nWorkflow'',''campSareb'')
						AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrados el resto de campos para el tipo de acuerdo Dación/Compraventa');
		
		--******************** QUITA (Quita) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Quita, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID) 
						VALUES ('||V_DD_TPA_ID||',''QUITA'',''Quita'',''Quita'',0,''DML'',SYSDATE,0,'||V_ENT_AMBAS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Quita creado con DD_TAP_ID: '||V_DD_TPA_ID);
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Quita con DD_TPA_ID: '||V_DD_TPA_ID||', se activará');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID = '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''QUITA'' AND DD_TPA_ID <> '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;			
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Quita, activado');
		END IF;
		
		----------------------------------------- QUITA - Importe a pagar -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeQuita''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe a pagar para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''importeQuita'',0,''DML'',SYSDATE,0,''Importe a pagar'',''number'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe a pagar para el tipo acuerdo Quita, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe a pagar para el tipo acuerdo Quita, se activará');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeQuita'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe a pagar para el tipo acuerdo Quita, activado');			
		END IF;
		
		----------------------------------------- QUITA - Fecha prevista firma -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe a pagar para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''fechaPrevistaFirma'',0,''DML'',SYSDATE,0,''Fecha Prevista Firma'',''fecha'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha prevista firma para el tipo acuerdo Quita, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha prevista firma para el tipo acuerdo Quita, se activará');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha prevista firma para el tipo acuerdo Quita, activado');			
		END IF;		
		
		----------------------------------------- QUITA - % de Quita -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''porcentajeQuita''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo % de Quita para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''porcentajeQuita'',0,''DML'',SYSDATE,0,''% de Quita'',''number'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo % de Quita para el tipo acuerdo Quita, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo % de Quita para el tipo acuerdo Quita.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''porcentajeQuita'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo % Quita para el tipo acuerdo Quita, activado');			
		END IF;
		
		----------------------------------------- QUITA - Importe Vencido -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeVencido''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe Vencido para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''importeVencido'',0,''DML'',SYSDATE,0,''Importe Vencido'',''number'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe Vencido para el tipo acuerdo Quita, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe Vencido para el tipo acuerdo Quita.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeVencido'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe Vencido para el tipo acuerdo Quita, activado');			
		END IF;		
		
		----------------------------------------- QUITA - Importe no vencido -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeNoVencido''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe no vencido para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''importeNoVencido'',0,''DML'',SYSDATE,0,''Importe no vencido'',''number'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe no vencido para el tipo acuerdo Quita, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe no vencido para el tipo acuerdo Quita.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeNoVencido'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe no vencido para el tipo acuerdo Quita, activado');			
		END IF;
		
		----------------------------------------- QUITA - Importe intereses moratorios -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''interesesMoratorios''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe intereses moratorios para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''interesesMoratorios'',0,''DML'',SYSDATE,0,''Importe intereses moratorios'',''number'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe intereses moratorios para el tipo acuerdo Quita, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe intereses moratorios para el tipo acuerdo Quita.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''interesesMoratorios'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe intereses moratorios para el tipo acuerdo Quita, activado');			
		END IF;
		
		----------------------------------------- QUITA - Importe intereses ordinarios -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''interesesOrdinarios''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe intereses ordinarios para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''interesesOrdinarios'',0,''DML'',SYSDATE,0,''Importe intereses ordinarios'',''number'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe intereses ordinarios para el tipo acuerdo Quita, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe intereses ordinarios para el tipo acuerdo Quita.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''interesesOrdinarios'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe intereses ordinarios para el tipo acuerdo Quita, activado');			
		END IF;
		
		----------------------------------------- QUITA - Comisiones -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''comision''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Comisiones para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''comision'',0,''DML'',SYSDATE,0,''Comisiones'',''number'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Comisiones para el tipo acuerdo Quita, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Comisiones para el tipo acuerdo Quita.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''comision'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Comisiones para el tipo acuerdo Quita, activado');			
		END IF;
		
		----------------------------------------- QUITA - Gastos -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''gastos''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Gastos para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''gastos'',0,''DML'',SYSDATE,0,''Gastos'',''number'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Gastos para el tipo acuerdo Quita, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Gastos para el tipo acuerdo Quita.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''gastos'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Gastos para el tipo acuerdo Quita, activado');			
		END IF;
		
		----------------------------------------- QUITA - Nº Workflow -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nº Workflow para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''nWorkflow'',0,''DML'',SYSDATE,0,''Nº Workflow'',''text'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº Workflow para el tipo acuerdo Quita, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nº Workflow para el tipo acuerdo Quita.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº Workflow para el tipo acuerdo Quita, activado');			
		END IF;
		
		----------------------------------------- QUITA - Campaña Sareb -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Campaña Sareb para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''campSareb'',0,''DML'',SYSDATE,0,''Campaña Sareb'',''text'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Campaña Sareb para el tipo acuerdo Quita, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Campaña Sareb para el tipo acuerdo Quita.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Campaña Sareb para el tipo acuerdo Quita, activado');			
		END IF;
		
		-- Borramos el resto de campos para el tipo de acuerdo Quita
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Quita');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
					WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''importeQuita'',''fechaPrevistaFirma'',''porcentajeQuita'',''importeVencido'',''importeNoVencido'',''interesesMoratorios'',''interesesOrdinarios'',''comision'',''gastos'',''nWorkflow'',''campSareb'')
						AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrados el resto de campos para el tipo de acuerdo Quita');		
		
		--******************** RESTRUREFI (Reestructuración/Refinanciación) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''RESTRUREFI'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Reestructuración/Refinanciación, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID) 
						VALUES ('||V_DD_TPA_ID||',''RESTRUREFI'',''Reestructuración/Refinanciación'',''Reestructuración/Refinanciación'',0,''DML'',SYSDATE,0,'||V_ENT_AMBAS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Reestructuración/Refinanciación creado con DD_TAP_ID: '||V_DD_TPA_ID);
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''RESTRUREFI'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Reestructuración/Refinanciación con DD_TPA_ID: '||V_DD_TPA_ID);
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID = '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''RESTRUREFI'' AND DD_TPA_ID <> '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;			
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Reestructuración/Refinanciación con DD_TPA_ID: '||V_DD_TPA_ID||', activado');
		END IF;
		
		----------------------------------------- RESTRUREFI - Fecha Sol. Prevista -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaSolucionPrevista''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha Sol. Prevista para el tipo acuerdo Reestructuración/Refinanciación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''fechaSolucionPrevista'',0,''DML'',SYSDATE,0,''Fecha Sol. Prevista'',''fecha'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha Sol. Prevista para el tipo acuerdo Reestructuración/Refinanciación, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha Sol. Prevista para el tipo acuerdo Reestructuración/Refinanciación.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaSolucionPrevista'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha Sol. Prevista para el tipo acuerdo Reestructuración/Refinanciación, activado');			
		END IF;		
		
		----------------------------------------- RESTRUREFI - Nº Workflow -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nº Workflow para el tipo acuerdo Reestructuración/Refinanciación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''nWorkflow'',0,''DML'',SYSDATE,0,''Nº Workflow'',''text'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº Workflow para el tipo acuerdo Reestructuración/Refinanciación, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nº Workflow para el tipo acuerdo Reestructuración/Refinanciación.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº Workflow para el tipo acuerdo Reestructuración/Refinanciación, activado');			
		END IF;
		
		----------------------------------------- RESTRUREFI - Campaña Sareb -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Campaña Sareb para el tipo acuerdo Reestructuración/Refinanciación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''campSareb'',0,''DML'',SYSDATE,0,''Campaña Sareb'',''text'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Campaña Sareb para el tipo acuerdo Reestructuración/Refinanciación, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Campaña Sareb para el tipo acuerdo Reestructuración/Refinanciación.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Campaña Sareb para el tipo acuerdo Reestructuración/Refinanciación, activado');			
		END IF;
		
		-- Borramos el resto de campos para el tipo de acuerdo Reestructuración/Refinanciación
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Reestructuración/Refinanciación');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
					WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''fechaSolucionPrevista'',''nWorkflow'',''campSareb'')
						AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrados el resto de campos para el tipo de acuerdo Reestructuración/Refinanciación');		
		
		--******************** SINACCIONES (Sin Acciones) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''SINACCIONES'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Sin Acciones, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID) 
						VALUES ('||V_DD_TPA_ID||',''SINACCIONES'',''Sin Acciones'',''Sin Acciones'',0,''DML'',SYSDATE,0,'||V_ENT_AMBAS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Sin Acciones creado con DD_TAP_ID: '||V_DD_TPA_ID);
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''SINACCIONES'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Sin Acciones con DD_TPA_ID: '||V_DD_TPA_ID);
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID = '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''SINACCIONES'' AND DD_TPA_ID <> '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;				
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Sin Acciones con DD_TPA_ID: '||V_DD_TPA_ID||', activado');
		END IF;
		
		-- Borramos el resto de campos para el tipo de acuerdo Sin Acciones
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Sin Acciones');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
					WHERE DD_TPA_ID='||V_DD_TPA_ID||' 
						AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrados el resto de campos para el tipo de acuerdo Sin Acciones');			
		
		--******************** VEN_CRED (Venta de crédito) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''VEN_CRED'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Venta de crédito, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID) 
						VALUES ('||V_DD_TPA_ID||',''VEN_CRED'',''Venta de crédito'',''Venta de crédito'',0,''DML'',SYSDATE,0,'||V_ENT_AMBAS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Venta de crédito creado con DD_TAP_ID: '||V_DD_TPA_ID);
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''VEN_CRED'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Venta de crédito con DD_TPA_ID: '||V_DD_TPA_ID);
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID = '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''VEN_CRED'' AND DD_TPA_ID <> '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;			
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Venta de crédito con DD_TPA_ID: '||V_DD_TPA_ID||', activado');
		END IF;		
		
		----------------------------------------- VEN_CRED - Nombre cesionario -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nombreCesionario''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nombre cesionario para el tipo acuerdo Venta de crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''nombreCesionario'',0,''DML'',SYSDATE,0,''Nombre cesionario'',''text'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nombre cesionario para el tipo acuerdo Venta de crédito, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nombre cesionario para el tipo acuerdo Venta de crédito.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nombreCesionario'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nombre cesionario para el tipo acuerdo Venta de crédito, activado.');
		END IF;
		
		----------------------------------------- VEN_CRED - Relación cesionario / Titular -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''relacionCesionarioTitular''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Relación cesionario / Titular para el tipo acuerdo Venta de crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''relacionCesionarioTitular'',0,''DML'',SYSDATE,0,''Relación cesionario / Titular'',''text'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Relación cesionario / Titular para el tipo acuerdo Venta de crédito, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Relación cesionario / Titular para el tipo acuerdo Venta de crédito.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''relacionCesionarioTitular'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Relación cesionario / Titular para el tipo acuerdo Venta de crédito, activado.');			
		END IF;		
		
		----------------------------------------- VEN_CRED - Importe cesión -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCesion''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe cesión para el tipo acuerdo Venta de crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''importeCesion'',0,''DML'',SYSDATE,0,''Importe cesión'',''number'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe cesión para el tipo acuerdo Venta de crédito, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe cesión para el tipo acuerdo Venta de crédito.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCesion'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe cesión para el tipo acuerdo Venta de crédito, activado.');			
		END IF;		
		
		----------------------------------------- VEN_CRED - Fecha prevista firma  -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha prevista firma para el tipo acuerdo Venta de crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''fechaPrevistaFirma'',0,''DML'',SYSDATE,0,''Fecha prevista firma'',''fecha'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha prevista firma para el tipo acuerdo Venta de crédito, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha prevista firma para el tipo acuerdo Venta de crédito.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe cesión para el tipo acuerdo Venta de crédito, activado.');			
		END IF;		
		
		----------------------------------------- VEN_CRED - Nº Workflow -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nº Workflow para el tipo acuerdo Cesión de crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''nWorkflow'',0,''DML'',SYSDATE,0,''Nº Workflow'',''text'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº Workflow para el tipo acuerdo Venta de crédito, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nº Workflow para el tipo acuerdo Venta de crédito.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº Workflow para el tipo acuerdo Venta de crédito, activado.');			
		END IF;
		
		----------------------------------------- VEN_CRED - Campaña Sareb -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Campaña Sareb para el tipo acuerdo Venta de crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''campSareb'',0,''DML'',SYSDATE,0,''Campaña Sareb'',''text'',NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Campaña Sareb para el tipo acuerdo Venta de crédito, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Campaña Sareb para el tipo acuerdo Venta de crédito.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Campaña Sareb para el tipo acuerdo Venta de crédito, activado.');			
		END IF;
		
		-- Borramos el resto de campos para el tipo de acuerdo Cesión de crédito
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Cesión de crédito');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
					WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''nombreCesionario'',''relacionCesionarioTitular'',''importeCesion'',''fechaPrevistaFirma'',''nWorkflow'',''campSareb'')
						AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrados el resto de campos para el tipo de acuerdo Cesión de crédito');	
		
		-- ************************************ Borramos el resto de tipos de acuerdo
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de tipos de acuerdo.');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1
					WHERE NOT DD_TPA_CODIGO IN (''01'',''QUITA'',''RESTRUREFI'',''SINACCIONES'',''VEN_CRED'')
							AND DD_ENT_ACU_ID = '||V_ENT_AMBAS||'
							AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('[ERROR] No existe el tipo acuerdo entidad AMBAS.');
	END IF;	
	
	
	COMMIT;
	    
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');


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
  	