--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160520
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.4
--## INCIDENCIA_LINK=PRODUCTO-1271
--## PRODUCTO=NO
--##
--## Finalidad: Campos y tipos de termino acuerdo para Asuntos
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

	VN_COUNT NUMBER;
	VN_COUNTAMBAS NUMBER;
	VN_ENT_ASUNTOS NUMBER;
	VN_ENT_AMBAS NUMBER;
	VN_DD_TPA_ID NUMBER;
	VN_DD_ENT_ACU NUMBER;
	VN_ENT_EXP NUMBER;

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ENTIDAD_ACUERDO WHERE DD_ENT_ACU_COD = ''ASU'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ENTIDAD_ACUERDO WHERE DD_ENT_ACU_COD = ''AMBAS'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO VN_COUNTAMBAS;
	IF VN_COUNT > 0 THEN
		V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_ENTIDAD_ACUERDO WHERE DD_ENT_ACU_COD = ''ASU'' AND BORRADO = 0 AND ROWNUM=1';
		EXECUTE IMMEDIATE V_SQL INTO VN_ENT_ASUNTOS;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tipo entidad acuerdo Asunto, id: '||VN_ENT_ASUNTOS||'');

		IF VN_COUNTAMBAS > 0 THEN
			V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_ENTIDAD_ACUERDO WHERE DD_ENT_ACU_COD = ''AMBAS'' AND BORRADO = 0 AND ROWNUM=1';
			EXECUTE IMMEDIATE V_SQL INTO VN_ENT_AMBAS;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo entidad acuerdo Ambas, id: '||VN_ENT_AMBAS||'');
		END IF;

		--******************** 01 (Dación) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Dación, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID)
					VALUES ('||VN_DD_TPA_ID||',''01'',''Dación'',''Dación'',0,''DML'',SYSDATE,0,'||VN_ENT_ASUNTOS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Dacion creado con DD_TPA_ID: '||VN_DD_TPA_ID||'');
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Dación con DD_TPA_ID: '||VN_DD_TPA_ID||'');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO
					SET BORRADO = 0, DD_TPA_DESCRIPCION=''Dación'', DD_TPA_DESCRIPCION_LARGA=''Dación''
					WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''01'' AND DD_TPA_ID <> '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			-- Si no era de tipo asunto (es decir, expediente) la cambiamos a ambas
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Dación activado');
			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si erá de tipo asunto');
			V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_ENT_ACU;
			IF VN_DD_ENT_ACU <> VN_ENT_ASUNTOS AND VN_COUNTAMBAS > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizamos a tipo Ambas');
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET DD_ENT_ACU_ID = '||VN_ENT_AMBAS||'';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado a tipo Ambas');
			END IF;
		END IF;

		----------------------------- 01 - Cargas posteriores ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosteriores''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Cargas posteriores para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''cargasPosteriores'',0,''DML'',SYSDATE,0,''Cargas Posteriores'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Cargas posteriores para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosteriores'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores para el tipo acuerdo Dación, activado');
		END IF;

		----------------------------- 01 - Solicitar Alquiler ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''solicitarAlquiler''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Solicitar Alquiler para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''solicitarAlquiler'',0,''DML'',SYSDATE,0,''Solicitar Alquiler'',''combobox'',''1,Si;2,Social;0,No'',1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Solicitar Alquiler para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Solicitar Alquiler para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO= ''1,Si;2,Social;0,No'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''solicitarAlquiler'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Solicitar alquiler para el tipo acuerdo Dación, activado');
		END IF;


		----------------------------- 01 - Importe costas según contrato ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según contrato para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasContrato'',0,''DML'',SYSDATE,0,''Importe costas según contrato (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según contrato para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Dación, activado');
		END IF;

		----------------------------- 01 - Importe costas según colegio ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según colegio para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasColegio'',0,''DML'',SYSDATE,0,''Importe costas según colegio (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según colegio para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Dación, activado');
		END IF;

		----------------------------- 01 - Informe Solicitante ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Informe Solicitante para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''informeSolicitante'',0,''DML'',SYSDATE,0,''Informe Solicitante'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Informe Solicitante para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Dación, activado');
		END IF;

		----------------------------- 01 - Datos de contacto 1 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 1 para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto1'',0,''DML'',SYSDATE,0,''Datos contacto1'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 1 para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Dación, activado');
		END IF;

		----------------------------- 01 - Datos de contacto 2 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 2 para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto2'',0,''DML'',SYSDATE,0,''Datos contacto2'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 2 para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Dación, activado');
		END IF;

		----------------------------- 01 - Cargas posteriores/anteriores ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Cargas posteriores/anteriores para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''cargasPosterioresAnteriores'',0,''DML'',SYSDATE,0,''Cargas post./ant.'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Cargas posteriores/anteriores para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Dación, activado');
		END IF;

		----------------------------- 01 - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Cargas para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionCargas'',0,''DML'',SYSDATE,0,''Valoración Carga(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Cargas para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Dación, activado');
		END IF;

		----------------------------- 01 - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Cargas para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionCargas'',0,''DML'',SYSDATE,0,''Descripción Cargas'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Cargas para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Dación, activado');
		END IF;

		----------------------------- 01 - Otros bienes/solvencia ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Otros bienes/solvencia para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''otrosBienesSolvencia'',0,''DML'',SYSDATE,0,''Otros Bienes/Solvencia'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Otros bienes/solvencia para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Dación, activado');
		END IF;

		----------------------------- 01 - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Bienes/Solvencia para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionBienesSolvencia'',0,''DML'',SYSDATE,0,''Valoración Bien/Solvencia(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Bienes/Solvencia para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Dación, activado');
		END IF;

		----------------------------- 01 - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Bienes/Solvencia para el tipo acuerdo Dación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionBienesSolvencia'',0,''DML'',SYSDATE,0,''Descripción Bien/Solvencia'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Dación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Bienes/Solvencia para el tipo acuerdo Dación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Dación, activado');
		END IF;


		---Borramos el resto de campos para el tipo de acuerdo Dación
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Dación');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
				WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''cargasPosteriores'',''solicitarAlquiler'')
				AND NOT CMP_NOMBRE_CAMPO IN (''importeCostasContrato'',''importeCostasColegio'',''informeSolicitante'',''datosContacto1'',''datosContacto2'',''cargasPosterioresAnteriores'',''valoracionCargas'',''descripcionCargas'',''otrosBienesSolvencia'',''valoracionBienesSolvencia'',''descripcionBienesSolvencia'')
				AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;

		--******************** ADECU (Adecuación) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''ADECU''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Adecuación, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID)
					VALUES ('||VN_DD_TPA_ID||',''ADECU'',''Adecuación'',''Adecuación'',0,''DML'',SYSDATE,0,'||VN_ENT_ASUNTOS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Adecuación creado con DD_TPA_ID: '||VN_DD_TPA_ID||'');
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''ADECU'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Adecuación con DD_TPA_ID: '||VN_DD_TPA_ID||'');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO
					SET BORRADO = 0, DD_TPA_DESCRIPCION=''Adecuación'', DD_TPA_DESCRIPCION_LARGA=''Adecuación''
					WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''ADECU'' AND DD_TPA_ID <> '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Adecuación activado');
			-- Si no era de tipo asunto (es decir, expediente) la cambiamos a ambas
			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si erá de tipo asunto');
			V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_ENT_ACU;
			IF VN_DD_ENT_ACU <> VN_ENT_ASUNTOS AND VN_COUNTAMBAS > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizamos a tipo Ambas');
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET DD_ENT_ACU_ID = '||VN_ENT_AMBAS||'';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado a tipo Ambas');
			END IF;
		END IF;

		----------------------------- ADECU - Importe pago previo formalización ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importePagoPrevForm''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe pago previo formalización para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importePagoPrevForm'',0,''DML'',SYSDATE,0,''Importe pago previo formalización'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe pago previo formalización para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe pago previo formalización para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importePagoPrevForm'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe pago previo formalización para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Plazos pago previo formalización ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''plazosPagoPrevForm''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Plazos pago previo formalización para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''plazosPagoPrevForm'',0,''DML'',SYSDATE,0,''Plazos pago previo formalización'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Plazos pago previo formalización para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Plazos pago previo formalización para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''plazosPagoPrevForm'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Plazos pago previo formalización para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Carencia ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''carencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Carencia para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''carencia'',0,''DML'',SYSDATE,0,''Carencia'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Carencia para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Carencia para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''carencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Carencia para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Cuota asumible cliente ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cuotaAsumibleCliente''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Cuota asumible cliente para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''cuotaAsumibleCliente'',0,''DML'',SYSDATE,0,''Cuota asumible cliente'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cuota asumible cliente para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Cuota asumible cliente para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cuotaAsumibleCliente'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cuota asumible cliente para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Cargas posteriores ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosteriores''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Cargas posteriores para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''cargasPosteriores'',0,''DML'',SYSDATE,0,''Cargas posteriores'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Cargas posteriores para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosteriores'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Garantías extras ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''garantiasExtras''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Garantías extras para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''garantiasExtras'',0,''DML'',SYSDATE,0,''Garantías extras'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Garantías extras para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Garantías extras para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''garantiasExtras'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Garantías extras para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Importe costas según contrato ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según contrato para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasContrato'',0,''DML'',SYSDATE,0,''Importe costas según contrato (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según contrato para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Importe costas según colegio ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según colegio para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasColegio'',0,''DML'',SYSDATE,0,''Importe costas según colegio (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según colegio para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Informe Solicitante ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Informe Solicitante para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''informeSolicitante'',0,''DML'',SYSDATE,0,''Informe Solicitante'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Informe Solicitante para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Datos de contacto 1 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 1 para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto1'',0,''DML'',SYSDATE,0,''Datos contacto1'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 1 para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Datos de contacto 2 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 2 para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto2'',0,''DML'',SYSDATE,0,''Datos contacto2'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 2 para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Cargas posteriores/anteriores ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Cargas posteriores/anteriores para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''cargasPosterioresAnteriores'',0,''DML'',SYSDATE,0,''Cargas post./ant.'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Cargas posteriores/anteriores para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Cargas para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionCargas'',0,''DML'',SYSDATE,0,''Valoración Carga(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Cargas para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Cargas para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionCargas'',0,''DML'',SYSDATE,0,''Descripción Cargas'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Cargas para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Otros bienes/solvencia ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Otros bienes/solvencia para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''otrosBienesSolvencia'',0,''DML'',SYSDATE,0,''Otros Bienes/Solvencia'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Otros bienes/solvencia para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Bienes/Solvencia para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionBienesSolvencia'',0,''DML'',SYSDATE,0,''Valoración Bien/Solvencia(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Bienes/Solvencia para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Adecuación, activado');
		END IF;

		----------------------------- ADECU - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Bienes/Solvencia para el tipo acuerdo Adecuación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionBienesSolvencia'',0,''DML'',SYSDATE,0,''Descripción Bien/Solvencia'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Adecuación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Bienes/Solvencia para el tipo acuerdo Adecuación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Adecuación, activado');
		END IF;


		---Borramos el resto de campos para el tipo de acuerdo Adecuación
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Adecuacion');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
				WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''importePagoPrevForm'',''plazosPagoPrevForm'',''carencia'',''cuotaAsumibleCliente'',''cargasPosteriores'',''garantiasExtras'')
				AND NOT CMP_NOMBRE_CAMPO IN (''importeCostasContrato'',''importeCostasColegio'',''informeSolicitante'',''datosContacto1'',''datosContacto2'',''cargasPosterioresAnteriores'',''valoracionCargas'',''descripcionCargas'',''otrosBienesSolvencia'',''valoracionBienesSolvencia'',''descripcionBienesSolvencia'')
				AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;

		--******************** QUITA (Quita) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Quita, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID)
					VALUES ('||VN_DD_TPA_ID||',''QUITA'',''Quita'',''Quita'',0,''DML'',SYSDATE,0,'||VN_ENT_ASUNTOS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Quita creado con DD_TPA_ID: '||VN_DD_TPA_ID||'');
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''QUITA'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Quita con DD_TPA_ID: '||VN_DD_TPA_ID||'');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO
					SET BORRADO = 0, DD_TPA_DESCRIPCION=''Quita'', DD_TPA_DESCRIPCION_LARGA=''Quita''
					WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''QUITA'' AND DD_TPA_ID <> '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Quita activado');
			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si erá de tipo asunto');
			V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_ENT_ACU;
			IF VN_DD_ENT_ACU <> VN_ENT_ASUNTOS AND VN_COUNTAMBAS > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizamos a tipo Ambas');
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET DD_ENT_ACU_ID = '||VN_ENT_AMBAS||'';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado a tipo Ambas');
			END IF;
		END IF;

		----------------------------- QUITA - Importe a pagar ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeAPagar''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe a pagar para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeAPagar'',0,''DML'',SYSDATE,0,''Importe a pagar'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe a pagar para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe a pagar para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeAPagar'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe a pagar para el tipo acuerdo Quita, activado');
		END IF;

		----------------------------- QUITA - % de Quita ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''porcentajeQuita''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo % de Quita para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''porcentajeQuita'',0,''DML'',SYSDATE,0,''% de Quita'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo % de Quita para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo % de Quita para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''porcentajeQuita'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo % de Quita para el tipo acuerdo Quita, activado');
		END IF;

		----------------------------- QUITA - Importe costas según contrato ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según contrato para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasContrato'',0,''DML'',SYSDATE,0,''Importe costas según contrato (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según contrato para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Quita, activado');
		END IF;

		----------------------------- QUITA - Importe costas según colegio ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según colegio para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasColegio'',0,''DML'',SYSDATE,0,''Importe costas según colegio (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según colegio para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Quita, activado');
		END IF;

		----------------------------- QUITA - Informe Solicitante ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Informe Solicitante para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''informeSolicitante'',0,''DML'',SYSDATE,0,''Informe Solicitante'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Informe Solicitante para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Quita, activado');
		END IF;

		----------------------------- QUITA - Datos de contacto 1 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 1 para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto1'',0,''DML'',SYSDATE,0,''Datos contacto1'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 1 para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Quita, activado');
		END IF;

		----------------------------- QUITA - Datos de contacto 2 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 2 para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto2'',0,''DML'',SYSDATE,0,''Datos contacto2'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 2 para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Quita, activado');
		END IF;

		----------------------------- QUITA - Cargas posteriores/anteriores ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Cargas posteriores/anteriores para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''cargasPosterioresAnteriores'',0,''DML'',SYSDATE,0,''Cargas post./ant.'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Cargas posteriores/anteriores para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Quita, activado');
		END IF;

		----------------------------- QUITA - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Cargas para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionCargas'',0,''DML'',SYSDATE,0,''Valoración Carga(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Cargas para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Quita, activado');
		END IF;

		----------------------------- QUITA - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Cargas para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionCargas'',0,''DML'',SYSDATE,0,''Descripción Cargas'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Cargas para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Quita, activado');
		END IF;

		----------------------------- QUITA - Otros bienes/solvencia ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Otros bienes/solvencia para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''otrosBienesSolvencia'',0,''DML'',SYSDATE,0,''Otros Bienes/Solvencia'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Otros bienes/solvencia para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Quita, activado');
		END IF;

		----------------------------- QUITA - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Bienes/Solvencia para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionBienesSolvencia'',0,''DML'',SYSDATE,0,''Valoración Bien/Solvencia(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Bienes/Solvencia para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Quita, activado');
		END IF;

		----------------------------- QUITA - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Bienes/Solvencia para el tipo acuerdo Quita, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionBienesSolvencia'',0,''DML'',SYSDATE,0,''Descripción Bien/Solvencia'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Quita, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Bienes/Solvencia para el tipo acuerdo Quita, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Quita, activado');
		END IF;


		---Borramos el resto de campos para el tipo de acuerdo Quita
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Quita');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
				WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''importeAPagar'',''porcentajeQuita'')
				AND NOT CMP_NOMBRE_CAMPO IN (''importeCostasContrato'',''importeCostasColegio'',''informeSolicitante'',''datosContacto1'',''datosContacto2'',''cargasPosterioresAnteriores'',''valoracionCargas'',''descripcionCargas'',''otrosBienesSolvencia'',''valoracionBienesSolvencia'',''descripcionBienesSolvencia'')
				AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;

		--******************** ENTLLAVES (Entrega de llaves) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''ENTLLAVES''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Entrega de llaves, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID)
					VALUES ('||VN_DD_TPA_ID||',''ENTLLAVES'',''Entrega de llaves'',''Entrega de llaves'',0,''DML'',SYSDATE,0,'||VN_ENT_ASUNTOS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Entrega de llaves creado con DD_TPA_ID: '||VN_DD_TPA_ID||'');
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''ENTLLAVES'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Entrega de llaves con DD_TPA_ID: '||VN_DD_TPA_ID||'');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO
					SET BORRADO = 0, DD_TPA_DESCRIPCION=''Entrega de llaves'', DD_TPA_DESCRIPCION_LARGA=''Entrega de llaves''
					WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''ENTLLAVES'' AND DD_TPA_ID <> '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Entrega de llaves activado');
			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si erá de tipo asunto');
			V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_ENT_ACU;
			IF VN_DD_ENT_ACU <> VN_ENT_ASUNTOS AND VN_COUNTAMBAS > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizamos a tipo Ambas');
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET DD_ENT_ACU_ID = '||VN_ENT_AMBAS||'';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado a tipo Ambas');
			END IF;
		END IF;

		----------------------------- ENTLLAVES - Vivienda habitual ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''viviendaHabitual''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Vivienda habitual para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''viviendaHabitual'',0,''DML'',SYSDATE,0,''Vivienda habitual'',''combobox'',''0,No;1,Si'',1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Vivienda habitual para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Vivienda habitual para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''viviendaHabitual'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Vivienda habitual para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Riesgo de solicitud de moratoria ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''riesgoSolicitudMoratoria''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Riesgo de solicitud de moratoria para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''riesgoSolicitudMoratoria'',0,''DML'',SYSDATE,0,''Riesgo de solicitud de moratoria'',''combobox'',''0,No;1,Si'',1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Riesgo de solicitud de moratoria para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Riesgo de solicitud de moratoria para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''riesgoSolicitudMoratoria'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Riesgo de solicitud de moratoria para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Deudor en riesgo de exclusión social ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''deudorRiesgoExclusionSocial''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Deudor en riesgo de exclusión social para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''deudorRiesgoExclusionSocial'',0,''DML'',SYSDATE,0,''Deudor en riesgo de exclusión social'',''combobox'',''0,No;1,Si'',1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Deudor en riesgo de exclusión social para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Deudor en riesgo de exclusión social para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''deudorRiesgoExclusionSocial'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Deudor en riesgo de exclusión social para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Edad del deudor ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''edadDeudor''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Edad del deudor para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''edadDeudor'',0,''DML'',SYSDATE,0,''Edad del deudor'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Edad del deudor para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Edad del deudor para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''edadDeudor'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Edad del deudor para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Tiempo estimado de la posesión ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''tiempoEstimadoPosesion''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Tiempo estimado de la posesión para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''tiempoEstimadoPosesion'',0,''DML'',SYSDATE,0,''Tiempo estimado de la posesión (meses)'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Tiempo estimado de la posesión para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Tiempo estimado de la posesión para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''tiempoEstimadoPosesion'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Tiempo estimado de la posesión para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Incidencias procesales ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''incidenciasProcesales''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Incidencias procesales para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''incidenciasProcesales'',0,''DML'',SYSDATE,0,''Incidencias procesales'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Incidencias procesales para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Incidencias procesales para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''incidenciasProcesales'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Incidencias procesales para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Existencia de ocupantes ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''existenciaOcupantes''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Existencia de ocupantes para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''existenciaOcupantes'',0,''DML'',SYSDATE,0,''Existencia de ocupantes'',''combobox'',''0,No;1,Si'',1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Existencia de ocupantes para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Existencia de ocupantes para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''existenciaOcupantes'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Existencia de ocupantes para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Intereses > Principal del préstamo ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''interesesMayorPrincipal''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Intereses > Principal del préstamo para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''interesesMayorPrincipal'',0,''DML'',SYSDATE,0,''Intereses > Principal del préstamo'',''combobox'',''0,No;1,Si'',1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Intereses > Principal del préstamo para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Intereses > Principal del préstamo para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''interesesMayorPrincipal'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Intereses > Principal del préstamo para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Importe costas según contrato ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según contrato para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasContrato'',0,''DML'',SYSDATE,0,''Importe costas según contrato (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según contrato para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Importe costas según colegio ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según colegio para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasColegio'',0,''DML'',SYSDATE,0,''Importe costas según colegio (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según colegio para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Informe Solicitante ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Informe Solicitante para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''informeSolicitante'',0,''DML'',SYSDATE,0,''Informe Solicitante'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Informe Solicitante para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Datos de contacto 1 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 1 para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto1'',0,''DML'',SYSDATE,0,''Datos contacto1'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 1 para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Datos de contacto 2 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 2 para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto2'',0,''DML'',SYSDATE,0,''Datos contacto2'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 2 para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Cargas posteriores/anteriores ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Cargas posteriores/anteriores para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''cargasPosterioresAnteriores'',0,''DML'',SYSDATE,0,''Cargas post./ant.'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Cargas posteriores/anteriores para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Cargas para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionCargas'',0,''DML'',SYSDATE,0,''Valoración Carga(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Cargas para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Cargas para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionCargas'',0,''DML'',SYSDATE,0,''Descripción Cargas'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Cargas para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Otros bienes/solvencia ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Otros bienes/solvencia para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''otrosBienesSolvencia'',0,''DML'',SYSDATE,0,''Otros Bienes/Solvencia'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Otros bienes/solvencia para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Bienes/Solvencia para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionBienesSolvencia'',0,''DML'',SYSDATE,0,''Valoración Bien/Solvencia(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Bienes/Solvencia para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Entrega de llaves, activado');
		END IF;

		----------------------------- ENTLLAVES - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Bienes/Solvencia para el tipo acuerdo Entrega de llaves, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionBienesSolvencia'',0,''DML'',SYSDATE,0,''Descripción Bien/Solvencia'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Entrega de llaves, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Bienes/Solvencia para el tipo acuerdo Entrega de llaves, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Entrega de llaves, activado');
		END IF;


		---Borramos el resto de campos para el tipo de acuerdo Entrega de llaves
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Entrega de llaves');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
				WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''viviendaHabitual'',''riesgoSolicitudMoratoria'',''deudorRiesgoExclusionSocial'',''edadDeudor'',''tiempoEstimadoPosesion'',''incidenciasProcesales'',''existenciaOcupantes'',''interesesMayorPrincipal'')
				AND NOT CMP_NOMBRE_CAMPO IN (''importeCostasContrato'',''importeCostasColegio'',''informeSolicitante'',''datosContacto1'',''datosContacto2'',''cargasPosterioresAnteriores'',''valoracionCargas'',''descripcionCargas'',''otrosBienesSolvencia'',''valoracionBienesSolvencia'',''descripcionBienesSolvencia'')
				AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;

		--******************** 203 (Regularización) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''203''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Regularización, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID)
					VALUES ('||VN_DD_TPA_ID||',''203'',''Regularización'',''Regularización'',0,''DML'',SYSDATE,0,'||VN_ENT_ASUNTOS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Regularización creado con DD_TPA_ID: '||VN_DD_TPA_ID||'');
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''203'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Regularización con DD_TPA_ID: '||VN_DD_TPA_ID||'');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO
					SET BORRADO = 0, DD_TPA_DESCRIPCION=''Regularización'', DD_TPA_DESCRIPCION_LARGA=''Regularización''
					WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''203'' AND DD_TPA_ID <> '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Regularización activado');
			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si erá de tipo asunto');
			V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_ENT_ACU;
			IF VN_DD_ENT_ACU <> VN_ENT_ASUNTOS AND VN_COUNTAMBAS > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizamos a tipo Ambas');
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET DD_ENT_ACU_ID = '||VN_ENT_AMBAS||'';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado a tipo Ambas');
			END IF;
		END IF;

		----------------------------- 203 - Fecha / Calendario de pago ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPlanPago''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha / Calendario de pago para el tipo acuerdo Regularización, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''fechaPlanPago'',0,''DML'',SYSDATE,0,''Fecha / Calendario de pago'',''fecha'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha / Calendario de pago para el tipo acuerdo Regularización, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha / Calendario de pago para el tipo acuerdo Regularización, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Fecha / Calendario de pago'', CMP_TIPO_CAMPO = ''fecha'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPlanPago'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha / Calendario de pago para el tipo acuerdo Regularización, activado');
		END IF;

		----------------------------- 203 - Importe costas según contrato ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según contrato para el tipo acuerdo Regularización, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasContrato'',0,''DML'',SYSDATE,0,''Importe costas según contrato (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Regularización, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según contrato para el tipo acuerdo Regularización, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Regularización, activado');
		END IF;

		----------------------------- 203 - Importe costas según colegio ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según colegio para el tipo acuerdo Regularización, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasColegio'',0,''DML'',SYSDATE,0,''Importe costas según colegio (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Regularización, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según colegio para el tipo acuerdo Regularización, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Regularización, activado');
		END IF;

		----------------------------- 203 - Informe Solicitante ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Informe Solicitante para el tipo acuerdo Regularización, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''informeSolicitante'',0,''DML'',SYSDATE,0,''Informe Solicitante'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Regularización, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Informe Solicitante para el tipo acuerdo Regularización, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Regularización, activado');
		END IF;

		----------------------------- 203 - Datos de contacto 1 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 1 para el tipo acuerdo Regularización, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto1'',0,''DML'',SYSDATE,0,''Datos contacto1'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Regularización, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 1 para el tipo acuerdo Regularización, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Regularización, activado');
		END IF;

		----------------------------- 203 - Datos de contacto 2 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 2 para el tipo acuerdo Regularización, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto2'',0,''DML'',SYSDATE,0,''Datos contacto2'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Regularización, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 2 para el tipo acuerdo Regularización, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Regularización, activado');
		END IF;

		----------------------------- 203 - Cargas posteriores/anteriores ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Cargas posteriores/anteriores para el tipo acuerdo Regularización, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''cargasPosterioresAnteriores'',0,''DML'',SYSDATE,0,''Cargas post./ant.'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Regularización, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Cargas posteriores/anteriores para el tipo acuerdo Regularización, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Regularización, activado');
		END IF;

		----------------------------- 203 - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Cargas para el tipo acuerdo Regularización, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionCargas'',0,''DML'',SYSDATE,0,''Valoración Carga(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Regularización, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Cargas para el tipo acuerdo Regularización, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Regularización, activado');
		END IF;

		----------------------------- 203 - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Cargas para el tipo acuerdo Regularización, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionCargas'',0,''DML'',SYSDATE,0,''Descripción Cargas'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Regularización, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Cargas para el tipo acuerdo Regularización, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Regularización, activado');
		END IF;

		----------------------------- 203 - Otros bienes/solvencia ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Otros bienes/solvencia para el tipo acuerdo Regularización, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''otrosBienesSolvencia'',0,''DML'',SYSDATE,0,''Otros Bienes/Solvencia'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Regularización, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Otros bienes/solvencia para el tipo acuerdo Regularización, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Regularización, activado');
		END IF;

		----------------------------- 203 - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Bienes/Solvencia para el tipo acuerdo Regularización, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionBienesSolvencia'',0,''DML'',SYSDATE,0,''Valoración Bien/Solvencia(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Regularización, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Bienes/Solvencia para el tipo acuerdo Regularización, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Regularización, activado');
		END IF;

		----------------------------- 203 - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Bienes/Solvencia para el tipo acuerdo Regularización, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionBienesSolvencia'',0,''DML'',SYSDATE,0,''Descripción Bien/Solvencia'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Regularización, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Bienes/Solvencia para el tipo acuerdo Regularización, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Regularización, activado');
		END IF;


		---Borramos el resto de campos para el tipo de acuerdo Regularización
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Regularización');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
				WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''fechaPlanPago'')
				AND NOT CMP_NOMBRE_CAMPO IN (''importeCostasContrato'',''importeCostasColegio'',''informeSolicitante'',''datosContacto1'',''datosContacto2'',''cargasPosterioresAnteriores'',''valoracionCargas'',''descripcionCargas'',''otrosBienesSolvencia'',''valoracionBienesSolvencia'',''descripcionBienesSolvencia'')
				AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;

		--******************** 204 (Cancelación) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''204''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Cancelación, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID)
					VALUES ('||VN_DD_TPA_ID||',''204'',''Cancelación'',''Cancelación'',0,''DML'',SYSDATE,0,'||VN_ENT_ASUNTOS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Cancelación creado con DD_TPA_ID: '||VN_DD_TPA_ID||'');
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''204'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Cancelación con DD_TPA_ID: '||VN_DD_TPA_ID||'');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO
					SET BORRADO = 0, DD_TPA_DESCRIPCION=''Cancelación'', DD_TPA_DESCRIPCION_LARGA=''Cancelación''
					WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''204'' AND DD_TPA_ID <> '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Cancelación activado');
			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si erá de tipo asunto');
			V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_ENT_ACU;
			IF VN_DD_ENT_ACU <> VN_ENT_ASUNTOS AND VN_COUNTAMBAS > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizamos a tipo Ambas');
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET DD_ENT_ACU_ID = '||VN_ENT_AMBAS||'';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado a tipo Ambas');
			END IF;
		END IF;

		----------------------------- 204 - Fecha / Calendario de pago ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPlanPago''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha / Calendario de pago para el tipo acuerdo Cancelación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''fechaPlanPago'',0,''DML'',SYSDATE,0,''Fecha / Calendario de pago'',''fecha'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha / Calendario de pago para el tipo acuerdo Cancelación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha / Calendario de pago para el tipo acuerdo Cancelación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Fecha / Calendario de pago'', CMP_TIPO_CAMPO = ''fecha'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPlanPago'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha / Calendario de pago para el tipo acuerdo Cancelación, activado');
		END IF;

		----------------------------- 204 - Importe costas según contrato ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según contrato para el tipo acuerdo Cancelación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasContrato'',0,''DML'',SYSDATE,0,''Importe costas según contrato (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Cancelación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según contrato para el tipo acuerdo Cancelación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Cancelación, activado');
		END IF;

		----------------------------- 204 - Importe costas según colegio ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según colegio para el tipo acuerdo Cancelación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasColegio'',0,''DML'',SYSDATE,0,''Importe costas según colegio (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Cancelación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según colegio para el tipo acuerdo Cancelación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Cancelación, activado');
		END IF;

		----------------------------- 204 - Informe Solicitante ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Informe Solicitante para el tipo acuerdo Cancelación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''informeSolicitante'',0,''DML'',SYSDATE,0,''Informe Solicitante'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Cancelación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Informe Solicitante para el tipo acuerdo Cancelación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Cancelación, activado');
		END IF;

		----------------------------- 204 - Datos de contacto 1 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 1 para el tipo acuerdo Cancelación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto1'',0,''DML'',SYSDATE,0,''Datos contacto1'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Cancelación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 1 para el tipo acuerdo Cancelación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Cancelación, activado');
		END IF;

		----------------------------- 204 - Datos de contacto 2 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 2 para el tipo acuerdo Cancelación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto2'',0,''DML'',SYSDATE,0,''Datos contacto2'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Cancelación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 2 para el tipo acuerdo Cancelación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Cancelación, activado');
		END IF;

		----------------------------- 204 - Cargas posteriores/anteriores ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Cargas posteriores/anteriores para el tipo acuerdo Cancelación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''cargasPosterioresAnteriores'',0,''DML'',SYSDATE,0,''Cargas post./ant.'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Cancelación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Cargas posteriores/anteriores para el tipo acuerdo Cancelación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Cancelación, activado');
		END IF;

		----------------------------- 204 - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Cargas para el tipo acuerdo Cancelación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionCargas'',0,''DML'',SYSDATE,0,''Valoración Carga(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Cancelación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Cargas para el tipo acuerdo Cancelación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Cancelación, activado');
		END IF;

		----------------------------- 204 - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Cargas para el tipo acuerdo Cancelación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionCargas'',0,''DML'',SYSDATE,0,''Descripción Cargas'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Cancelación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Cargas para el tipo acuerdo Cancelación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Cancelación, activado');
		END IF;

		----------------------------- 204 - Otros bienes/solvencia ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Otros bienes/solvencia para el tipo acuerdo Cancelación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''otrosBienesSolvencia'',0,''DML'',SYSDATE,0,''Otros Bienes/Solvencia'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Cancelación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Otros bienes/solvencia para el tipo acuerdo Cancelación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Cancelación, activado');
		END IF;

		----------------------------- 204 - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Bienes/Solvencia para el tipo acuerdo Cancelación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionBienesSolvencia'',0,''DML'',SYSDATE,0,''Valoración Bien/Solvencia(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Cancelación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Bienes/Solvencia para el tipo acuerdo Cancelación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Cancelación, activado');
		END IF;

		----------------------------- 204 - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Bienes/Solvencia para el tipo acuerdo Cancelación, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionBienesSolvencia'',0,''DML'',SYSDATE,0,''Descripción Bien/Solvencia'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Cancelación, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Bienes/Solvencia para el tipo acuerdo Cancelación, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Cancelación, activado');
		END IF;


		---Borramos el resto de campos para el tipo de acuerdo Cancelación
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Cancelación');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
				WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''fechaPlanPago'')
				AND NOT CMP_NOMBRE_CAMPO IN (''importeCostasContrato'',''importeCostasColegio'',''informeSolicitante'',''datosContacto1'',''datosContacto2'',''cargasPosterioresAnteriores'',''valoracionCargas'',''descripcionCargas'',''otrosBienesSolvencia'',''valoracionBienesSolvencia'',''descripcionBienesSolvencia'')
				AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;

		--******************** 11 (Cesión Remate) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''11''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Cesión Remate, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID)
					VALUES ('||VN_DD_TPA_ID||',''11'',''Cesión Remate'',''Cesión Remate'',0,''DML'',SYSDATE,0,'||VN_ENT_ASUNTOS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Cesión Remate creado con DD_TPA_ID: '||VN_DD_TPA_ID||'');
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''11'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Cesión Remate con DD_TPA_ID: '||VN_DD_TPA_ID||'');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO
					SET BORRADO = 0, DD_TPA_DESCRIPCION=''Cesión Remate'', DD_TPA_DESCRIPCION_LARGA=''Cesión Remate''
					WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''11'' AND DD_TPA_ID <> '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Cesión Remate activado');
			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si erá de tipo asunto');
			V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_ENT_ACU;
			IF VN_DD_ENT_ACU <> VN_ENT_ASUNTOS AND VN_COUNTAMBAS > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizamos a tipo Ambas');
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET DD_ENT_ACU_ID = '||VN_ENT_AMBAS||'';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado a tipo Ambas');
			END IF;
		END IF;

		----------------------------- 11 - Nombre cesionario ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nombreCesionario''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nombre cesionario para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''nombreCesionario'',0,''DML'',SYSDATE,0,''Nombre cesionario'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nombre cesionario para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nombre cesionario para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Nombre cesionario'', CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nombreCesionario'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nombre cesionario para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Relación cesionario / titular ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''relacionCesionarioTitular''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Relación cesionario / titular para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''relacionCesionarioTitular'',0,''DML'',SYSDATE,0,''Relación cesionario / titular'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Relación cesionario / titular para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Relación cesionario / titular para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Relación cesionario / titular'', CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''relacionCesionarioTitular'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Relación cesionario / titular para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Solvencia cesionario ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''solvenciaCesionario''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Solvencia cesionario para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''solvenciaCesionario'',0,''DML'',SYSDATE,0,''Solvencia cesionario'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Solvencia cesionario para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Solvencia cesionario para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Solvencia cesionario'', CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''solvenciaCesionario'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Solvencia cesionario para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Importe cesión ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCesion''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe cesión para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCesion'',0,''DML'',SYSDATE,0,''Importe cesión'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe cesión para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe cesión para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Importe cesión'', CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCesion'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe cesión para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Fecha pago ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPago''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha pago para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''fechaPago'',0,''DML'',SYSDATE,0,''Fecha pago'',''fecha'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha pago para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha pago para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Fecha pago'', CMP_TIPO_CAMPO = ''fecha'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPago'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha pago para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Modo de pago ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''modoPago''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Modo de pago para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''modoPago'',0,''DML'',SYSDATE,0,''Modo de pago'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Modo de pago para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Modo de pago para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Modo de pago'', CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''modoPago'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Modo de pago para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Importe costas según contrato ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según contrato para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasContrato'',0,''DML'',SYSDATE,0,''Importe costas según contrato (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según contrato para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Importe costas según colegio ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según colegio para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasColegio'',0,''DML'',SYSDATE,0,''Importe costas según colegio (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según colegio para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Informe Solicitante ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Informe Solicitante para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''informeSolicitante'',0,''DML'',SYSDATE,0,''Informe Solicitante'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Informe Solicitante para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Datos de contacto 1 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 1 para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto1'',0,''DML'',SYSDATE,0,''Datos contacto1'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 1 para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Datos de contacto 2 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 2 para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto2'',0,''DML'',SYSDATE,0,''Datos contacto2'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 2 para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Cargas posteriores/anteriores ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Cargas posteriores/anteriores para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''cargasPosterioresAnteriores'',0,''DML'',SYSDATE,0,''Cargas post./ant.'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Cargas posteriores/anteriores para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Cargas para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionCargas'',0,''DML'',SYSDATE,0,''Valoración Carga(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Cargas para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Cargas para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionCargas'',0,''DML'',SYSDATE,0,''Descripción Cargas'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Cargas para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Otros bienes/solvencia ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Otros bienes/solvencia para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''otrosBienesSolvencia'',0,''DML'',SYSDATE,0,''Otros Bienes/Solvencia'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Otros bienes/solvencia para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Bienes/Solvencia para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionBienesSolvencia'',0,''DML'',SYSDATE,0,''Valoración Bien/Solvencia(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Bienes/Solvencia para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Cesión Remate, activado');
		END IF;

		----------------------------- 11 - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Bienes/Solvencia para el tipo acuerdo Cesión Remate, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionBienesSolvencia'',0,''DML'',SYSDATE,0,''Descripción Bien/Solvencia'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Cesión Remate, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Bienes/Solvencia para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Cesión Remate, activado');
		END IF;


		---Borramos el resto de campos para el tipo de acuerdo Cesión Remate
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Cesión Remate');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
				WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''nombreCesionario'',''relacionCesionarioTitular'',''solvenciaCesionario'',''importeCesion'',''fechaPago'',''modoPago'')
				AND NOT CMP_NOMBRE_CAMPO IN (''importeCostasContrato'',''importeCostasColegio'',''informeSolicitante'',''datosContacto1'',''datosContacto2'',''cargasPosterioresAnteriores'',''valoracionCargas'',''descripcionCargas'',''otrosBienesSolvencia'',''valoracionBienesSolvencia'',''descripcionBienesSolvencia'')
				AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;

		--******************** CES_CRED (Cesión de Crédito) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo Cesión de Crédito, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID)
					VALUES ('||VN_DD_TPA_ID||',''CES_CRED'',''Cesión de Crédito'',''Cesión de Crédito'',0,''DML'',SYSDATE,0,'||VN_ENT_ASUNTOS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo Cesión de Crédito creado con DD_TPA_ID: '||VN_DD_TPA_ID||'');
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''CES_CRED'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo Cesión de Crédito con DD_TPA_ID: '||VN_DD_TPA_ID||'');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO
					SET BORRADO = 0, DD_TPA_DESCRIPCION=''Cesión de Crédito'', DD_TPA_DESCRIPCION_LARGA=''Cesión de Crédito''
					WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''CES_CRED'' AND DD_TPA_ID <> '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo Cesión de Crédito activado');
			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si erá de tipo asunto');
			V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_ID = '||VN_DD_TPA_ID||'';
			EXECUTE IMMEDIATE V_SQL INTO VN_DD_ENT_ACU;
			IF VN_DD_ENT_ACU <> VN_ENT_ASUNTOS AND VN_COUNTAMBAS > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizamos a tipo Ambas');
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET DD_ENT_ACU_ID = '||VN_ENT_AMBAS||'';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado a tipo Ambas');
			END IF;
		END IF;

		----------------------------- CES_CRED - Nombre cesionario ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nombreCesionario''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Nombre cesionario para el tipo acuerdo Cesión de Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''nombreCesionario'',0,''DML'',SYSDATE,0,''Nombre cesionario'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nombre cesionario para el tipo acuerdo Cesión de Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Nombre cesionario para el tipo acuerdo Cesión de Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Nombre cesionario'', CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''nombreCesionario'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Nombre cesionario para el tipo acuerdo Cesión de Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Relación cesionario / titular ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''relacionCesionarioTitular''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Relación cesionario / titular para el tipo acuerdo Cesión de Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''relacionCesionarioTitular'',0,''DML'',SYSDATE,0,''Relación cesionario / titular'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Relación cesionario / titular para el tipo acuerdo Cesión de Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Relación cesionario / titular para el tipo acuerdo Cesión de Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Relación cesionario / titular'', CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''relacionCesionarioTitular'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Relación cesionario / titular para el tipo acuerdo Cesión de Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Solvencia cesionario ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''solvenciaCesionario''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Solvencia cesionario para el tipo acuerdo Cesión de Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''solvenciaCesionario'',0,''DML'',SYSDATE,0,''Solvencia cesionario'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Solvencia cesionario para el tipo acuerdo Cesión de Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Solvencia cesionario para el tipo acuerdo Cesión Remate, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Solvencia cesionario'', CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''solvenciaCesionario'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Solvencia cesionario para el tipo acuerdo Cesión de Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Importe cesión ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCesion''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe cesión para el tipo acuerdo Cesión de Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCesion'',0,''DML'',SYSDATE,0,''Importe cesión'',''number'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe cesión para el tipo acuerdo Cesión de Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Importe cesión para el tipo acuerdo Cesión de Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Importe cesión'', CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCesion'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe cesión para el tipo acuerdo Cesión de Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Fecha pago ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPago''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha pago para el tipo acuerdo Cesión de Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''fechaPago'',0,''DML'',SYSDATE,0,''Fecha pago'',''fecha'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha pago para el tipo acuerdo Cesión de Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha pago para el tipo acuerdo Cesión de Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Fecha pago'', CMP_TIPO_CAMPO = ''fecha'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fechaPago'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha pago para el tipo acuerdo Cesión de Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Modo de pago ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''modoPago''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Modo de pago para el tipo acuerdo Cesión de Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''modoPago'',0,''DML'',SYSDATE,0,''Modo de pago'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Modo de pago para el tipo acuerdo Cesión de Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Modo de pago para el tipo acuerdo Cesión de Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_LABEL = ''Modo de pago'', CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO =1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''modoPago'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Modo de pago para el tipo acuerdo Cesión de Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Importe costas según contrato ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según contrato para el tipo acuerdo Cesión Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasContrato'',0,''DML'',SYSDATE,0,''Importe costas según contrato (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Cesión Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según contrato para el tipo acuerdo Cesión Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasContrato'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según contrato para el tipo acuerdo Cesión Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Importe costas según colegio ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Importe costas según colegio para el tipo acuerdo Cesión Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''importeCostasColegio'',0,''DML'',SYSDATE,0,''Importe costas según colegio (€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Cesión Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Importe costas según colegio para el tipo acuerdo Cesión Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''importeCostasColegio'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Importe costas según colegio para el tipo acuerdo Cesión Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Informe Solicitante ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Informe Solicitante para el tipo acuerdo Cesión Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''informeSolicitante'',0,''DML'',SYSDATE,0,''Informe Solicitante'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Cesión Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Informe Solicitante para el tipo acuerdo Cesión Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''informeSolicitante'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Informe Solicitante para el tipo acuerdo Cesión Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Datos de contacto 1 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 1 para el tipo acuerdo Cesión Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto1'',0,''DML'',SYSDATE,0,''Datos contacto1'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Cesión Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 1 para el tipo acuerdo Cesión Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto1'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 1 para el tipo acuerdo Cesión Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Datos de contacto 2 ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Datos de contacto 2 para el tipo acuerdo Cesión Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''datosContacto2'',0,''DML'',SYSDATE,0,''Datos contacto2'',''text'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Cesión Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Datos de contacto 2 para el tipo acuerdo Cesión Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 1
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''datosContacto2'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Datos de contacto 2 para el tipo acuerdo Cesión Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Cargas posteriores/anteriores ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Cargas posteriores/anteriores para el tipo acuerdo Cesión Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''cargasPosterioresAnteriores'',0,''DML'',SYSDATE,0,''Cargas post./ant.'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Cesión Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Cargas posteriores/anteriores para el tipo acuerdo Cesión Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''cargasPosterioresAnteriores'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas posteriores/anteriores para el tipo acuerdo Cesión Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Cargas para el tipo acuerdo Cesión Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionCargas'',0,''DML'',SYSDATE,0,''Valoración Carga(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Cesión Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Cargas para el tipo acuerdo Cesión Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Cargas para el tipo acuerdo Cesión Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Cargas para el tipo acuerdo Cesión Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionCargas'',0,''DML'',SYSDATE,0,''Descripción Cargas'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Cesión Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Cargas para el tipo acuerdo Cesión Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionCargas'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Cargas para el tipo acuerdo Cesión Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Otros bienes/solvencia ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Otros bienes/solvencia para el tipo acuerdo Cesión Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''otrosBienesSolvencia'',0,''DML'',SYSDATE,0,''Otros Bienes/Solvencia'',''combobox'',''0,No;1,Si'',0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Cesión Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Otros bienes/solvencia para el tipo acuerdo Cesión Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''combobox'', CMP_VALORES_COMBO = ''0,No;1,Si'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''otrosBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Otros bienes/solvencia para el tipo acuerdo Cesión Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Valoración ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Valoración Bienes/Solvencia para el tipo acuerdo Cesión Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''valoracionBienesSolvencia'',0,''DML'',SYSDATE,0,''Valoración Bien/Solvencia(€)'',''number'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Cesión Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Valoración Bienes/Solvencia para el tipo acuerdo Cesión Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''number'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Valoración Bienes/Solvencia para el tipo acuerdo Cesión Crédito, activado');
		END IF;

		----------------------------- CES_CRED - Descripción ----------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia''';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Descripción Bienes/Solvencia para el tipo acuerdo Cesión Crédito, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
					VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||VN_DD_TPA_ID||',''descripcionBienesSolvencia'',0,''DML'',SYSDATE,0,''Descripción Bien/Solvencia'',''text'',NULL,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Cesión Crédito, insertado OK');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya exsite el campo Descripción Bienes/Solvencia para el tipo acuerdo Cesión Crédito, se marca como activo');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0, CMP_TIPO_CAMPO = ''text'', CMP_OBLIGATORIO = 0
					WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Descripción Bienes/Solvencia para el tipo acuerdo Cesión Crédito, activado');
		END IF;


		---Borramos el resto de campos para el tipo de acuerdo Cesión de Crédito
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de campos para el tipo de acuerdo Cesión de Crédito');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1
				WHERE DD_TPA_ID='||VN_DD_TPA_ID||' AND NOT CMP_NOMBRE_CAMPO IN (''nombreCesionario'',''relacionCesionarioTitular'',''solvenciaCesionario'',''importeCesion'',''fechaPago'',''modoPago'')
				AND NOT CMP_NOMBRE_CAMPO IN (''importeCostasContrato'',''importeCostasColegio'',''informeSolicitante'',''datosContacto1'',''datosContacto2'',''cargasPosterioresAnteriores'',''valoracionCargas'',''descripcionCargas'',''otrosBienesSolvencia'',''valoracionBienesSolvencia'',''descripcionBienesSolvencia'')
				AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;

		-- ************************************ Borramos el resto de tipos de acuerdo para Asuntos
		DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el resto de tipos de acuerdo para Asuntos');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1
				WHERE NOT DD_TPA_CODIGO IN (''01'',''ADECU'',''QUITA'',''ENTLLAVES'',''203'',''204'',''11'',''CES_CRED'')
				AND DD_ENT_ACU_ID = '||VN_ENT_ASUNTOS||'
				AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ENTIDAD_ACUERDO WHERE DD_ENT_ACU_COD = ''EXP'' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
		IF VN_COUNT > 0 AND VN_COUNTAMBAS > 0 THEN
			V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_ENTIDAD_ACUERDO WHERE DD_ENT_ACU_COD = ''EXP'' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO VN_ENT_EXP;
			DBMS_OUTPUT.PUT_LINE('[INFO] Cambiamos a Expedientes el resto de tipos que sean de tipo ambas');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET DD_ENT_ACU_ID = '||VN_ENT_EXP||'
					WHERE NOT DD_TPA_CODIGO IN (''01'',''ADECU'',''QUITA'',''ENTLLAVES'',''203'',''204'',''11'',''CES_CRED'')
					AND DD_ENT_ACU_ID ='||VN_ENT_AMBAS||'';
			EXECUTE IMMEDIATE V_MSQL;
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[ERROR] No existe el tipo acuerdo entidad ASUNTOS');
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
