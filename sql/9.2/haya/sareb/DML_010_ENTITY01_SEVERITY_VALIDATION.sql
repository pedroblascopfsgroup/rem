--/*
--##########################################
--## AUTOR=DANIEL ALBERT PÉREZ
--## FECHA_CREACION=20160616
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.6
--## INCIDENCIA_LINK=HR-2553
--## PRODUCTO=NO
--## 
--## Finalidad: Ajustar la severidad de las validaciones de PCR y GCL en cliente Haya-Sareb
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--## 0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	TYPE T_JBV IS TABLE OF VARCHAR2(4000);
	TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
	-- Configuración Esquemas
	V_ESQUEMA           VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_MASTER    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	err_num             NUMBER; -- Numero de errores
	err_msg             VARCHAR2(2048); -- Mensaje de error 
	V_MSQL              VARCHAR2(4000 CHAR);
	V_ENTIDAD           NUMBER(16);
	V_USUARIOMODIFICAR	VARCHAR2(50) := 'SEVERITY_MODIFIER';

	V_JBV T_ARRAY_JBV := 
		T_ARRAY_JBV(
			-- Validaciones de contratos 
			T_JBV('cnt-00.countValidator',1)
			, T_JBV('cnt-01.entityValidator',1)
			, T_JBV('cnt-02.loadDateValidator.Oracle9iDialect',1)
			, T_JBV('cnt-03.movementValidator',2)
			, T_JBV('cnt-04.insertOfficeZoneCodeValidator',1)
			, T_JBV('cnt-04.officeCodeValidator',1)
			, T_JBV('cnt-05.zonaCodeValidator',1)
			, T_JBV('cnt-06.insertCurrencyCodeValidator',1)
			, T_JBV('cnt-06.currencyCodeValidator',1)
			, T_JBV('cnt-07.insertProductTypeCodeValidator',1)
			, T_JBV('cnt-07.productTypeCodeValidator',1)
			, T_JBV('cnt-08.contratoRelacionValidator',1)
			, T_JBV('cnt-09.movimientoPrevio',1)
			, T_JBV('cnt-10.fechaExtracionMenorHoy',1)
			, T_JBV('cnt-11.fechaPosVencida',1)
			, T_JBV('cnt-12.activoPositvo',1)
			, T_JBV('cnt-13.insertFinalidadOficial',1)
			, T_JBV('cnt-13.finalidadOficial',1)
			, T_JBV('cnt-14.insertFinalidadContrato',1)
			, T_JBV('cnt-14.finalidadContrato',1)
			, T_JBV('cnt-15.insertGarantia1',1)
			, T_JBV('cnt-15.garantia1',1)
			, T_JBV('cnt-16.insertGarantia2',1)
			, T_JBV('cnt-16.garantia2',1)
			, T_JBV('cnt-17.insertCatalogo1',1)
			, T_JBV('cnt-17.catalogo1',1)
			, T_JBV('cnt-18.catalogo2',1)
			, T_JBV('cnt-19.catalogo3',1)
			, T_JBV('cnt-20.catalogo4',1)
			, T_JBV('cnt-21.extra3',1)
			, T_JBV('cnt-22.extra4',1)
			, T_JBV('cnt-23.relacionesCatalogos',1)
			, T_JBV('cnt-24.insertAplicativoOrigen',1)
			, T_JBV('cnt-24.aplicativoOrigen',1)
			, T_JBV('cnt-25.insertCodPropietario',1)
			, T_JBV('cnt-25.codPropietario',1)
			, T_JBV('cnt-26.insertEstadoFinanciero',1)
			, T_JBV('cnt-26.estadoFinanciero',1)
			, T_JBV('cnt-27.officeAdmCodeValidator',1)
			, T_JBV('cnt-28.insertGestionEspecial',1)
			, T_JBV('cnt-28.gestionEspecial',1)
			, T_JBV('cnt-29.insertCondicionesRemuneracion',1)
			, T_JBV('cnt-29.condicionesRemuneracion',1)
			, T_JBV('cnt-30.insertMotivoRenumeracion',1)
			, T_JBV('cnt-30.motivoRenumeracion',1)
			, T_JBV('cnt-31.limiteInicialMayorCero',1)
			, T_JBV('cnt-32.limiteFinalMayorCero',1)
			, T_JBV('cnt-33.insertEstadoFinancieroAnterior',1)
			, T_JBV('cnt-33.estadoFinancieroAnterior',1)
			, T_JBV('cnt-34.estadoContrato',1)
			, T_JBV('cnt-35.insertTipoProducto',1)
			, T_JBV('cnt-35.tipoProducto',1)
			, T_JBV('cnt-36.cnt50CodeValidator',1)
			-- Validaciones de personas
			, T_JBV('per-00.validateCount',1)
			, T_JBV('per-01.entityValidator',1)
			, T_JBV('per-02.loadDateValidator.Oracle9iDialect',1)
			, T_JBV('per-03.personTypeValidator',1)
			, T_JBV('per-04.insertDocumentTypeValidator',1)
			, T_JBV('per-04.documentTypeValidator',1)
			, T_JBV('per-05.insertSegmentValidator',1)
			, T_JBV('per-05.segmentValidator',1)
			, T_JBV('per-06.personaRelacionValidator',1)
			, T_JBV('per-07.oficina',1)
			, T_JBV('per-08.zona',1)
			, T_JBV('per-09.insertTipoTelefono1',1)
			, T_JBV('per-09.tipoTelefono1',1)
			, T_JBV('per-10.insertTipoTelefono2',1)
			, T_JBV('per-10.tipoTelefono2',1)
			, T_JBV('per-11.insertTipoTelefono3',1)
			, T_JBV('per-11.tipoTelefono3',1)
			, T_JBV('per-12.insertTipoTelefono4',1)
			, T_JBV('per-12.tipoTelefono4',1)
			, T_JBV('per-13.insertTipoTelefono5',1)
			, T_JBV('per-13.tipoTelefono5',1)
			, T_JBV('per-14.insertTipoTelefono6',1)
			, T_JBV('per-14.tipoTelefono6',1)
			, T_JBV('per-15.insertPerfilGestor',1)
			, T_JBV('per-15.perfilGestor',1)
			, T_JBV('per-16.usuarioGestor',1)
			, T_JBV('per-17.insertGrupoGestor',1)
			, T_JBV('per-17.grupoGestor',1)
			, T_JBV('per-18.insertPolitica',1)
			, T_JBV('per-18.politica',1)
			, T_JBV('per-19.insertRatingExterno',1)
			, T_JBV('per-19.ratingExterno',1)
			, T_JBV('per-20.insertRatingAuxiliar',1)
			, T_JBV('per-20.ratingAuxiliar',1)
			, T_JBV('per-21.insertNacionalidad',1)
			, T_JBV('per-21.nacionalidad',1)
			, T_JBV('per-22.insertPaisNacimiento',1)
			, T_JBV('per-22.paisNacimiento',1)
			, T_JBV('per-23.insertSexo',1)
			, T_JBV('per-23.sexo',1)
			, T_JBV('per-24.insertSegment2Validator',1)
			, T_JBV('per-24.segment2Validator',1)
			, T_JBV('per-25.insertCodPropietarioValidator',1)
			, T_JBV('per-25.codPropietarioValidator',1)
			, T_JBV('per-26.insertOrigenTelefono1Validator',1)
			, T_JBV('per-26.origenTelefono1Validator',1)
			, T_JBV('per-27.insertPersonaNivelValidator',1)
			, T_JBV('per-27.personaNivelValidator',1)
			, T_JBV('per-28.insertColectivoSingularValidator',1)
			, T_JBV('per-28.colectivoSingularValidator',1)
			, T_JBV('per-29.insertTipoGestorValidator',1)
			, T_JBV('per-29.tipoGestorValidator',1)
			, T_JBV('per-30.insertAreaGestionValidator',1)
			, T_JBV('per-30.areaGestionValidator',1)
			, T_JBV('per-31.vrOtrasEntidadesValidator',1)
			, T_JBV('per-32.vrOtrasEntidadesValidator',1)
			, T_JBV('per-33.tipoGestorPersonaValidator',1)
			, T_JBV('per-34.tipoGestorOficinaValidator',1)
			, T_JBV('per-35.insertTipoPolitica',1)
			, T_JBV('per-35.tipoPolitica',1)
			, T_JBV('per-36.codigoClienteEntidadValidation',1)
			-- Validaciones de Relaciones
			, T_JBV('cnt-per-00.countValidator',1)
			, T_JBV('cnt-per-01.entityValidator',1)
			, T_JBV('cnt-per-02.loadDateValidator.MySQLDialect',1)
			, T_JBV('cnt-per-02.loadDateValidator.Oracle9iDialect',1)
			, T_JBV('cnt-per-03.insertIntervencionValidator',1)
			, T_JBV('cnt-per-03.intervencionValidator',1)
			, T_JBV('cnt-per-04.propietarioValidator.MySQLDialect',1)
			, T_JBV('cnt-per-04.propietarioValidator.Oracle9iDialect',1)
			, T_JBV('cnt-per-05.ProductTypeValidator.MySQLDialect',1)
			, T_JBV('cnt-per-05.ProductTypeValidator.Oracle9iDialect',1)
			, T_JBV('cnt-per-06.integridadValidator.MySQLDialect',1)
			, T_JBV('cnt-per-06.integridadValidator.Oracle9iDialect',1)
			, T_JBV('cnt-per-07.integridadCodOficinaValidator.MySQLDialect',1)
			, T_JBV('cnt-per-07.integridadCodOficinaValidator.Oracle9iDialect',1)
			-- Validaciones Grupos
			, T_JBV('gcl-01.entityValidatorGrupos',1)
			, T_JBV('gcl-02.loadDateValidatorGrupos',1)
			, T_JBV('gcl-03.insertTipoGrupoValidator',1)
			, T_JBV('gcl-03.tipoGrupoValidator',1)
			, T_JBV('gcl-04.gruposVaciosValidator',1)
			, T_JBV('gcl-05.entityValidatorRelaciones',1)
			, T_JBV('gcl-06.loadDateValidatorRelaciones',1)
			, T_JBV('gcl-07.insertPersonasValidator',1) 
			, T_JBV('gcl-07.personasValidator',1)
			, T_JBV('gcl-08.personasGruposValidator',1)
			, T_JBV('gcl-11.lastLoadDateValidator',1)
			, T_JBV('gcl-12.gruposRepetidosValidator',1)
			, T_JBV('gcl-13.personasEnMasDeUnGrupoValidator',1)
			, T_JBV('gcl-15.tipoRelacionGrupoValidator',1)
		);   
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
	V_TMP_JBV T_JBV;

BEGIN
	--Sacamos la el codigo entidad de la tabla ENTIDAD.
	SELECT ID INTO V_ENTIDAD FROM HAYAMASTER.ENTIDAD WHERE DESCRIPCION = 'HAYA';
	DBMS_OUTPUT.PUT_LINE('Actualizando SEVERIDAD validaciones en BATCH_JOB_VALIDATION. .. ... .... .....');
	--Comienza actualización de severidad.
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
		LOOP
			V_TMP_JBV := V_JBV(I);
			DBMS_OUTPUT.PUT_LINE('Actualizando el registro número '||I||' en BATCH_JOB_VALIDATION: '||V_TMP_JBV(1)); 
				V_MSQL := '
						  UPDATE
							'||V_ESQUEMA_MASTER||'.BATCH_JOB_VALIDATION 
							SET
								JOB_VAL_SEVERITY = '||V_TMP_JBV(2)||'
								, USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
								, FECHAMODIFICAR = SYSDATE
							WHERE
								JOB_VAL_ENTITY = '||V_ENTIDAD||'
								AND JOB_VAL_CODIGO LIKE '''||V_TMP_JBV(1)||'''
								AND JOB_VAL_SEVERITY <> '||V_TMP_JBV(2)||'
						';
				EXECUTE IMMEDIATE V_MSQL;
		END LOOP;
	--Control errores
	EXCEPTION
		WHEN OTHERS THEN  
			err_num := SQLCODE;
			err_msg := SQLERRM;
			DBMS_OUTPUT.put_line('Código de error: '||TO_CHAR(err_num));
			DBMS_OUTPUT.put_line('Mensaje de error: '||err_msg);
			ROLLBACK;
			RAISE;
END;
/
EXIT;
