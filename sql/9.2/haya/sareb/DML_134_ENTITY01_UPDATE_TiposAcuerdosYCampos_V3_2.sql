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
--##			parte 2
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
		
		-- Cambio del campo Fecha para el tipo Reestructuración/Refinanciación
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''RESTRUREFI'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS||' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM>0 THEN
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''RESTRUREFI'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS||' AND BORRADO = 0 AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			
			-- Quitamos el campo Fecha Solicitud prevista
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaSolucionPrevista''';
			EXECUTE IMMEDIATE V_MSQL;
			
			----------------------------------------- RESTRUREFI - Fecha Prevista firma -----------------------------------------------------
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM;
			IF V_NUM=0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha Prevista Firma para el tipo acuerdo Reestructuración/Refinanciación, se insertará');
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
							VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''fechaPrevistaFirma'',0,''DML'',SYSDATE,0,''Fecha Prevista firma'',''fecha'',NULL,1)';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha Prevista Firma para el tipo acuerdo Reestructuración/Refinanciación, insertado OK.');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha Prevista Firma para el tipo acuerdo Reestructuración/Refinanciación.');
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_OBLIGATORIO = 1  WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma'' AND ROWNUM = 1';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha Prevista Firma para el tipo acuerdo Reestructuración/Refinanciación, activado');			
			END IF;			
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo: Reestructuración/Refinanción, por lo tanto no se cambiará la etiqueta del campo fecha');
		END IF;
		
		--******************** PASELITIG (Pase a litigio) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PASELITIG'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Pase a litigio, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID) 
						VALUES ('||V_DD_TPA_ID||',''PASELITIG'',''Pase a litigio'',''Pase a litigio'',0,''DML'',SYSDATE,0,'||V_ENT_AMBAS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Pase a litigio creado con DD_TAP_ID: '||V_DD_TPA_ID);
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PASELITIG'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Pase a litigio con DD_TPA_ID: '||V_DD_TPA_ID);
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID = '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''PASELITIG'' AND DD_TPA_ID <> '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;			
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Pase a litigio activado');
		END IF;		
		
		-- Borramos el resto de campos para el tipo de acuerdo Pase a litigio
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Pase a litigio');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
					WHERE DD_TPA_ID='||V_DD_TPA_ID||' 
						AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrados el resto de campos para el tipo de acuerdo Pase a litigio');		
		
		--******************** PDV (PDV) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PDV'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo PDV, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID) 
						VALUES ('||V_DD_TPA_ID||',''PDV'',''PDV'',''PDV'',0,''DML'',SYSDATE,0,'||V_ENT_AMBAS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo PDV creado con DD_TAP_ID: '||V_DD_TPA_ID);
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PDV'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo PDV con DD_TPA_ID: '||V_DD_TPA_ID);
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID = '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''PASELITIG'' AND DD_TPA_ID <> '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;			
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo PDV activado');
		END IF;		
		
		----------------------------------------- PDV - Fecha prevista firma -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha Prevista Firma para el tipo acuerdo PDV, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''fechaPrevistaFirma'',0,''DML'',SYSDATE,0,''Fecha Prevista Firma'',''fecha'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha Prevista Firma para el tipo acuerdo PDV, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha Prevista Firma para el tipo acuerdo PDV, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha prevista firma para el tipo acuerdo PDV, activado.');
		END IF;
		
		----------------------------------------- PDV - Fecha inicio y vencimiento de la PDV -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fInicioVencPDV''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha inicio y vencimiento de la PDV para el tipo acuerdo PDV, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''fInicioVencPDV'',0,''DML'',SYSDATE,0,''Fecha inicio y vencimiento de la PDV'',''fecha'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha inicio y vencimiento de la PDV para el tipo acuerdo PDV, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha inicio y vencimiento de la PDV para el tipo acuerdo PDV, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fInicioVencPDV'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha inicio y vencimiento de la PDV para el tipo acuerdo PDV, activado.');
		END IF;
		
		----------------------------------------- PDV - Periodo de carencia -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''periodoCarencia''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Periodo de Carencia para el tipo acuerdo PDV, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''periodoCarencia'',0,''DML'',SYSDATE,0,''Periodo de Carencia'',''combobox'',''1M,1 Mes;2M,2 Meses;3M,3 Meses;4M,4 Meses;5M,5 Meses;6M,6 Meses;1Y,1 Año'',1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Periodo de Carencia para el tipo acuerdo PDV, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Periodo de Carencia para el tipo acuerdo PDV, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''periodoCarencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Periodo de Carencia para el tipo acuerdo PDV, activado.');
		END IF;
		
		----------------------------------------- PDV - Número de préstamo promotor -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nPrestamoPromotor''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Número de préstamo promotor para el tipo acuerdo PDV, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''nPrestamoPromotor'',0,''DML'',SYSDATE,0,''Número de préstamo promotor'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Número de préstamo promotor para el tipo acuerdo PDV, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Número de préstamo promotor para el tipo acuerdo PDV, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nPrestamoPromotor'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Número de préstamo promotor para el tipo acuerdo PDV, activado.');
		END IF;		
		
		----------------------------------------- PDV - Gestión -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''gestion''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Gestión para el tipo acuerdo PDV, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''gestion'',0,''DML'',SYSDATE,0,''Gestión'',''combobox'',''P,Promotor;H,HRE;T,Tercero'',1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Gestión para el tipo acuerdo PDV, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Gestión para el tipo acuerdo PDV, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''gestion'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Gestión para el tipo acuerdo PDV, activado.');
		END IF;
		
		----------------------------------------- PDV - Nº Bienes -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nBienes''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nº Bienes para el tipo acuerdo PDV, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO, CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''nBienes'',0,''DML'',SYSDATE,0,''Nº Bienes'',''number'',NULL, 0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº Bienes para el tipo acuerdo PDV, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nº Bienes para el tipo acuerdo PDV, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nBienes'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº Bienes para el tipo acuerdo PDV, activado.');
		END IF;		

		----------------------------------------- PDV - Nº WorkFlow -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nº WorkFlow para el tipo acuerdo PDV, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO, CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''nWorkflow'',0,''DML'',SYSDATE,0,''Nº WorkFlow'',''text'',NULL, 0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº WorkFlow para el tipo acuerdo PDV, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nº WorkFlow para el tipo acuerdo PDV, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº WorkFlow para el tipo acuerdo PDV, activado.');
		END IF;
		
		----------------------------------------- PDV - Capaña Sareb -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Capaña Sareb para el tipo acuerdo PDV, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO, CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''campSareb'',0,''DML'',SYSDATE,0,''Capaña Sareb'',''text'',NULL, 0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Capaña Sareb para el tipo acuerdo PDV, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Capaña Sareb para el tipo acuerdo PDV, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Capaña Sareb para el tipo acuerdo PDV, activado');
		END IF;

		-- Borramos el resto de campos para el tipo de acuerdo PDV
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo PDV');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
					WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''fechaPrevistaFirma'',''fInicioVencPDV'',''periodoCarencia'',''nPrestamoPromotor'',''gestion'',''nBienes'',''nWorkflow'',''campSareb'')
						AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrados el resto de campos para el tipo de acuerdo PDV');		
		
		
		--******************** VENTDEUDA (Venta de deuda) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''VENTDEUDA'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Venta de deuda, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID) 
						VALUES ('||V_DD_TPA_ID||',''VENTDEUDA'',''Venta de deuda'',''Venta de deuda'',0,''DML'',SYSDATE,0,'||V_ENT_AMBAS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Venta de deuda creado con DD_TAP_ID: '||V_DD_TPA_ID);
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''VENTDEUDA'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Venta de deuda con DD_TPA_ID: '||V_DD_TPA_ID);
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID = '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''VENTDEUDA'' AND DD_TPA_ID <> '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;			
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Venta de deuda activado');
		END IF;		
		
		----------------------------------------- VENTDEUDA - Fecha prevista firma -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha Prevista Firma para el tipo acuerdo Venta de deuda, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''fechaPrevistaFirma'',0,''DML'',SYSDATE,0,''Fecha Prevista Firma'',''fecha'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha Prevista Firma para el tipo acuerdo Venta de deuda, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha Prevista Firma para el tipo acuerdo Venta de deuda, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha prevista firma para el tipo acuerdo Venta de deuda, activado.');
		END IF;
		
		----------------------------------------- VENTDEUDA - Importe -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importe''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe para el tipo acuerdo Venta de deuda, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''importe'',0,''DML'',SYSDATE,0,''Importe'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe para el tipo acuerdo Venta de deuda, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe para el tipo acuerdo Venta de deuda, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importe'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe para el tipo acuerdo Venta de deuda, activado.');
		END IF;		
		
		----------------------------------------- VENTDEUDA - Nº WorkFlow -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nº WorkFlow para el tipo acuerdo Venta de deuda, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO, CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''nWorkflow'',0,''DML'',SYSDATE,0,''Nº WorkFlow'',''text'',NULL, 0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº WorkFlow para el tipo acuerdo Venta de deuda, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nº WorkFlow para el tipo acuerdo Venta de deuda, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº WorkFlow para el tipo acuerdo Venta de deuda, activado.');
		END IF;
		
		----------------------------------------- VENTDEUDA - Capaña Sareb -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Capaña Sareb para el tipo acuerdo Venta de deuda, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO, CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''campSareb'',0,''DML'',SYSDATE,0,''Capaña Sareb'',''text'',NULL, 0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Capaña Sareb para el tipo acuerdo Venta de deuda, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Capaña Sareb para el tipo acuerdo Venta de deuda, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Capaña Sareb para el tipo acuerdo Venta de deuda, activado');
		END IF;

		-- Borramos el resto de campos para el tipo de acuerdo Venta de deuda
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Venta de deuda');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
					WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''fechaPrevistaFirma'',''importe'',''nWorkflow'',''campSareb'')
						AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrados el resto de campos para el tipo de acuerdo Venta de deuda');		
		
		--******************** LIBIPF (Liberación IPF) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''LIBIPF'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Liberación IPF, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID) 
						VALUES ('||V_DD_TPA_ID||',''LIBIPF'',''Liberación IPF'',''Liberación IPF'',0,''DML'',SYSDATE,0,'||V_ENT_AMBAS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Liberación IPF creado con DD_TAP_ID: '||V_DD_TPA_ID);
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''LIBIPF'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Liberación IPF con DD_TPA_ID: '||V_DD_TPA_ID);
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID = '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''LIBIPF'' AND DD_TPA_ID <> '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;			
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Liberación IPF activado');
		END IF;
		
		----------------------------------------- LIBIPF - Fecha prevista firma -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha Prevista Firma para el tipo acuerdo Liberación IPF, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''fechaPrevistaFirma'',0,''DML'',SYSDATE,0,''Fecha Prevista Firma'',''fecha'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha Prevista Firma para el tipo acuerdo Liberación IPF, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha Prevista Firma para el tipo acuerdo Liberación IPF, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha prevista firma para el tipo acuerdo Liberación IPF, activado.');
		END IF;
		
		----------------------------------------- LIBIPF - Importe a recuperar -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeRecuperar''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe a recuperar para el tipo acuerdo Liberación IPF, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''importeRecuperar'',0,''DML'',SYSDATE,0,''Importe a recuperar'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe a recuperar para el tipo acuerdo Liberación IPF, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe a recuperar para el tipo acuerdo Liberación IPF, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeRecuperar'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe a recuperar para el tipo acuerdo Liberación IPF, activado.');
		END IF;		
		
		----------------------------------------- LIBIPF - Nº WorkFlow -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nº WorkFlow para el tipo acuerdo Liberación IPF, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO, CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''nWorkflow'',0,''DML'',SYSDATE,0,''Nº WorkFlow'',''text'',NULL, 0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº WorkFlow para el tipo acuerdo Liberación IPF, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nº WorkFlow para el tipo acuerdo Liberación IPF, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº WorkFlow para el tipo acuerdo Liberación IPF, activado.');
		END IF;
		
		----------------------------------------- LIBIPF - Capaña Sareb -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Capaña Sareb para el tipo acuerdo Liberación IPF, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO, CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''campSareb'',0,''DML'',SYSDATE,0,''Capaña Sareb'',''text'',NULL, 0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Capaña Sareb para el tipo acuerdo Liberación IPF, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Capaña Sareb para el tipo acuerdo Liberación IPF, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Capaña Sareb para el tipo acuerdo Liberación IPF, activado');
		END IF;

		-- Borramos el resto de campos para el tipo de acuerdo Liberación IPF
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Liberación IPF');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
					WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''fechaPrevistaFirma'',''importeRecuperar'',''nWorkflow'',''campSareb'')
						AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrados el resto de campos para el tipo de acuerdo Liberación IPF');		
		
		--******************** LDVCS (Liquidación deuda por venta de colaterales singulares) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''LDVCS'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Liquidación deuda por venta de colaterales singulares, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID) 
						VALUES ('||V_DD_TPA_ID||',''LDVCS'',''Liq. deuda venta colaterales singulares'',''Liquidación deuda por venta de colaterales singulares'',0,''DML'',SYSDATE,0,'||V_ENT_AMBAS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Liquidación deuda por venta de colaterales singulares creado con DD_TAP_ID: '||V_DD_TPA_ID);
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''LDVCS'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Liquidación deuda por venta de colaterales singulares con DD_TPA_ID: '||V_DD_TPA_ID);
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID = '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''LDVCS'' AND DD_TPA_ID <> '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;			
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Liquidación deuda por venta de colaterales singulares activado');
		END IF;		
		
		----------------------------------------- LDVCS - Fecha prevista firma -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha Prevista Firma para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''fechaPrevistaFirma'',0,''DML'',SYSDATE,0,''Fecha Prevista Firma'',''fecha'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha Prevista Firma para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha Prevista Firma para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha prevista firma para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, activado.');
		END IF;
		
		----------------------------------------- LDVCS - Importe -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importe''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''importe'',0,''DML'',SYSDATE,0,''Importe'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importe'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, activado.');
		END IF;		
		
		----------------------------------------- LDVCS - Nº WorkFlow -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nº WorkFlow para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO, CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''nWorkflow'',0,''DML'',SYSDATE,0,''Nº WorkFlow'',''text'',NULL, 0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº WorkFlow para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nº WorkFlow para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº WorkFlow para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, activado.');
		END IF;
		
		----------------------------------------- VENTDEUDA - Capaña Sareb -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Capaña Sareb para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO, CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''campSareb'',0,''DML'',SYSDATE,0,''Capaña Sareb'',''text'',NULL, 0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Capaña Sareb para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Capaña Sareb para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Capaña Sareb para el tipo acuerdo Liquidación deuda por venta de colaterales singulares, activado');
		END IF;

		-- Borramos el resto de campos para el tipo de acuerdo Venta de deuda
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Liquidación deuda por venta de colaterales singulares');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
					WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''fechaPrevistaFirma'',''importe'',''nWorkflow'',''campSareb'')
						AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrados el resto de campos para el tipo de acuerdo Liquidación deuda por venta de colaterales singulares');
		
		--******************** DESPIG (Despignoraciones) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''DESPIG'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Despignoraciones, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID) 
						VALUES ('||V_DD_TPA_ID||',''DESPIG'',''Despignoraciones'',''Despignoraciones'',0,''DML'',SYSDATE,0,'||V_ENT_AMBAS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Despignoraciones creado con DD_TAP_ID: '||V_DD_TPA_ID);
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''DESPIG'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Despignoraciones con DD_TPA_ID: '||V_DD_TPA_ID);
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID = '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''DESPIG'' AND DD_TPA_ID <> '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;			
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Despignoraciones activado');
		END IF;
		
		----------------------------------------- DESPIG - Fecha prevista firma -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha Prevista Firma para el tipo acuerdo Despignoraciones, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''fechaPrevistaFirma'',0,''DML'',SYSDATE,0,''Fecha Prevista Firma'',''fecha'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha Prevista Firma para el tipo acuerdo Despignoraciones, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha Prevista Firma para el tipo acuerdo Despignoraciones, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPrevistaFirma'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha prevista firma para el tipo acuerdo Despignoraciones, activado.');
		END IF;
		
		----------------------------------------- DESPIG - Importe a recuperar -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeRecuperar''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe a recuperar para el tipo acuerdo Despignoraciones, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''importeRecuperar'',0,''DML'',SYSDATE,0,''Importe a recuperar'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe a recuperar para el tipo acuerdo Despignoraciones, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe a recuperar para el tipo acuerdo Despignoraciones, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeRecuperar'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe a recuperar para el tipo acuerdo Despignoraciones, activado.');
		END IF;		
		
		----------------------------------------- DESPIG - Nº WorkFlow -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nº WorkFlow para el tipo acuerdo Despignoraciones, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO, CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''nWorkflow'',0,''DML'',SYSDATE,0,''Nº WorkFlow'',''text'',NULL, 0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº WorkFlow para el tipo acuerdo Despignoraciones, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nº WorkFlow para el tipo acuerdo Despignoraciones, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nWorkflow'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nº WorkFlow para el tipo acuerdo Despignoraciones, activado.');
		END IF;
		
		----------------------------------------- DESPIG - Capaña Sareb -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Capaña Sareb para el tipo acuerdo Despignoraciones, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO, CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''campSareb'',0,''DML'',SYSDATE,0,''Capaña Sareb'',''text'',NULL, 0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Capaña Sareb para el tipo acuerdo Despignoraciones, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Capaña Sareb para el tipo acuerdo Liberación IPF, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''campSareb'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Capaña Sareb para el tipo acuerdo Despignoraciones, activado');
		END IF;

		-- Borramos el resto de campos para el tipo de acuerdo Despignoraciones
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Despignoraciones');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
					WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''fechaPrevistaFirma'',''importeRecuperar'',''nWorkflow'',''campSareb'')
						AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrados el resto de campos para el tipo de acuerdo Despignoraciones');		
		
		-- ************************************ Borramos el resto de tipos de acuerdo
		/*
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de tipos de acuerdo.');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1
					WHERE NOT DD_TPA_CODIGO IN (''01'',''QUITA'',''RESTRUREFI'',''SINACCIONES'',''VEN_CRED'')
							AND DD_ENT_ACU_ID = '||V_ENT_AMBAS||'
							AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;*/
		
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
  	