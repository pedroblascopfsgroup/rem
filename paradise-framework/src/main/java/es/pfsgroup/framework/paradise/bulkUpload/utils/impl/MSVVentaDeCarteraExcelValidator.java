package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationRunner;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVValidationResult;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVMultiColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.dto.ResultadoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;

@Component
public class MSVVentaDeCarteraExcelValidator extends MSVExcelValidatorAbstract {

	public static final String TIPO_DOC_OBLIGATORIO = "El tipo de documento  no esta informado.";
	public static final String DOC_OBLIGATORIO = "El documento del cliente  no esta informado.";
	public static final String TIPOS_APLICABLES_DIFERENTES = "El tipo de impuesto y el tipo aplicable han de ser iguales para todos los activos de la agrupación";
	public static final String FORMATO_FECHA_CHEQUE_INVALIDO = "La fecha ingreso cheque tiene un formato incorrecto";
	public static final String FORMATO_FECHA_VENTA_INVALIDO = "La fecha venta tiene un formato incorrecto";
	public static final String PRESCRIPTORES_DIFERENTES = "Los activos tienen que tener el mismo prescriptor";
	public static final String GESTORES_DIFERENTES = "Los activos tienen que tener el mismo gestor";
	public static final String TITULARES_DIFERENTES = "Los activos tienen que tener los mismos titulares";
	public static final String FECHA_INGRESO_CHEQUE_OBLIGATORIA = "La fecha ingreso cheque tiene que estar informada.";
	public static final String ACTIVOS_DIFERENTES_SUBCARTERAS = "Existen activos de diferentes subcarteras en la oferta.";
	public static final String ACTIVOS_CARTERA_CAIXABANK_BANKIA = "Existen activos de Bankia o Caixabank.";
	public static final String CARTERA_OBLIGATORIA = "El código de cartera no esta informado.";
	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_NULL = "El campo número activo no puede estar vacío";
	public static final String PRECIO_VENTA_NULL = "El campo precio de venta no es correcto";
	public static final String OFERTAS_TRAMITADAS = "El activo no tiene ofertas tramitadas";
	public static final String MAXIMO_AGRUPADOS = "El número máximo de activos que pueden agruparse en una oferta es de 40";
	public static final String TITULARES_AGRUPACION = "El primer titular de cada grupo debe ser el mismo";
	public static final String TITULAR_OPCIONAL_2 = "Si el titular opcional (2o titular) viene informado, se debe rellenar su número URSUS";
	public static final String TITULAR_OPCIONAL_3 = "Si el titular opcional (3er titular) viene informado, se debe rellenar su número URSUS";
	public static final String TITULAR_OPCIONAL_4 = "Si el titular opcional (4o titular) viene informado, se debe rellenar su número URSUS";

	public static final String COMITE_SANCIONADOR_NOT_EXISTS = "El comité sancionador indicado no existe";
	public static final String COMITE_SANCIONADOR_NULL = "El campo comité sancionador no puede estar vacío";
	public static final String TIPO_IMPUESTO_NULL = "El campo tipo impuesto no puede estar vacío";
	public static final String TIPO_IMPUESTO_NOT_EXISTS = "El tipo de impuesto indicado no existe";
	public static final String TIPO_APLICABLE_NULL = "El campo tipo aplicable no puede estar vacio";
	public static final String FECHA_VENTA_NULL = "El campo fecha venta no puede estar vacío";
	public static final String CODIGO_UNICO_OFERTA_NULL = "El campo código único oferta no puede estar vacío";
	public static final String TIPO_DOCUMENTO_TITULAR_NOT_EXISTS = "El tipo de documento indicado del primer titular no existe";
	public static final String TIPO_DOCUMENTO_TITULAR_2_NOT_EXISTS = "El tipo de documento indicado del segundo titular no existe";
	public static final String TIPO_DOCUMENTO_TITULAR_3_NOT_EXISTS = "El tipo de documento indicado del tercer titular no existe";
	public static final String TIPO_DOCUMENTO_TITULAR_4_NOT_EXISTS = "El tipo de documento indicado del cuarto titular no existe";
	public static final String USER_GESTOR_COMERCIALIZACION_NULL = "El campo usuario gestor comercialización no puede estar vacío";
	public static final String USER_NO_GESTOR_COMERCIALIZACION = "No existe el gestor de comercialización indicado";
	public static final String CODIGO_PRESCRIPTOR_NULL = "El campo código prescriptor no puede estar vacío";
	public static final String CODIGO_PRESCRIPTOR_NOT_EXISTS = "El código presciptor indicado no existe";

	public static final String NUMERO_URSUS_TITULAR_NULL = "El campo número URSUS del 1er titular no puede estar vacío";
	public static final String PORCENTAJE_COMPRA_TITULAR_NULL = "El campo % compra del 1er titular no puede estar vacío";

	public static final String FICHERO_VACIO = "El fichero debe tener al menos una fila. La primera columna es obligatoria.";
	public static final String ACTIVO_EN_AGRUPACION_RESTRINGIDA = "El activo está en una agrupación restringida.";
	
	public static final String OBLIGATORIO_DATOS_RTE = "Ya que ha puesto un titular que será tipo persona Jurídica, es obligatorio rellenar los campos * del Representante";
	public static final String OBLIGATORIO_DATOS_LOCALIZACION = "Es obligatorio rellenar los datos de localización del titular";
	public static final String PAIS_NO_EXISTE = "El país indicado no existe";
	public static final String PROVINCIA_NO_EXISTE = "La provincia indicada no existe";
	public static final String MUNICIPIO_NO_EXISTE = "El municipio indicado no existe o no es de esa provincia";
	public static final String CODIGO_PAIS_ESPANYA = "28";
	
	public static final class COL_NUM {
		public static final int NUM_CAMPOS_COMPRADOR = 18;
		
		public static final int FILA_CABECERA = 2;
		public static final int DATOS_PRIMERA_FILA = 3;

		// Datos Activo
		public static final int NUM_ACTIVO_HAYA = 0;
		public static final int PRECIO_VENTA = 1;

		// Información expediente comercial
		public static final int COMITE_SANCIONADOR = 2;
		public static final int TIPO_IMPUESTO = 3;
		public static final int TIPO_APLICABLE = 4;
		public static final int FECHA_VENTA = 5;
		public static final int FECHA_INGRESO_CHEQUE = 6;
		public static final int CODIGO_CARTERA = 7;
		public static final int OPERACION_EXENTA = 8;
		public static final int RENUNCIA_EXENCION = 9;
		public static final int INVERSION_SUJETO_PASIVO = 10;

		// Datos Oferta
		// Identificacion
		public static final int CODIGO_UNICO_OFERTA = 11;
		public static final int USU_GESTOR_COMERCIALIZACION = 12;

		// Prescriptor
		public static final int CODIGO_PRESCRIPTOR = 13;

		// Titular
		public static final int NOMBRE_TITULAR = 14;
		public static final int RAZON_SOCIAL_TITULAR = 15;
		public static final int TIPO_DOCUMENTO_TITULAR = 16;
		public static final int DOC_IDENTIFICACION_TITULAR = 17;
		public static final int NUMERO_URSUS_TITULAR = 18;
		public static final int NUMERO_URSUS_CONYUGE_TITULAR = 19;
		public static final int PORCENTAJE_COMPRA_TITULAR = 20;
		public static final int REGIMEN_MATRIMONIAL = 21;
		public static final int PAIS_TITULAR = 22;
		public static final int PROVINCIA_TITULAR = 23;
		public static final int MUNICIPIO_TITULAR = 24;
		public static final int DIRECCION_TITULAR = 25;
		public static final int NOMBRE_RTE_TITULAR = 26;
		public static final int RAZON_SOCIAL_RTE_TITULAR = 27;
		public static final int TIPO_DOCUMENTO_RTE_TITULAR = 28;
		public static final int DOC_IDENTIFICACION_RTE_TITULAR = 29;
		public static final int PAIS_RTE_TITULAR = 30;
		public static final int PROVINCIA_RTE_TITULAR = 31;
		public static final int MUNICIPIO_RTE_TITULAR = 32;
		

		// Titular 2
		public static final int NOMBRE_TITULAR_2 = 33;
		public static final int RAZON_SOCIAL_TITULAR_2 = 34;
		public static final int TIPO_DOCUMENTO_TITULAR_2 = 35;
		public static final int DOC_IDENTIFICACION_TITULAR_2 = 36;
		public static final int NUMERO_URSUS_TITULAR_2 = 37;
		public static final int NUMERO_URSUS_CONYUGE_TITULAR_2 = 38;
		public static final int PORCENTAJE_COMPRA_TITULAR_2 = 39;
		public static final int REGIMEN_MATRIMONIAL_2 = 40;
		public static final int PAIS_TITULAR_2 = 41;
		public static final int PROVINCIA_TITULAR_2 = 42;
		public static final int MUNICIPIO_TITULAR_2 = 43;
		public static final int DIRECCION_TITULAR_2 = 44;
		public static final int NOMBRE_RTE_TITULAR_2 = 45;
		public static final int RAZON_SOCIAL_RTE_TITULAR_2 = 46;
		public static final int TIPO_DOCUMENTO_RTE_TITULAR_2 = 47;
		public static final int DOC_IDENTIFICACION_RTE_TITULAR_2 = 48;
		public static final int PAIS_RTE_TITULAR_2 = 49;
		public static final int PROVINCIA_RTE_TITULAR_2 = 50;
		public static final int MUNICIPIO_RTE_TITULAR_2 = 51;

		// Titular 3
		public static final int NOMBRE_TITULAR_3 = 52;
		public static final int RAZON_SOCIAL_TITULAR_3 = 53;
		public static final int TIPO_DOCUMENTO_TITULAR_3 = 54;
		public static final int DOC_IDENTIFICACION_TITULAR_3 = 55;
		public static final int NUMERO_URSUS_TITULAR_3 = 56;
		public static final int NUMERO_URSUS_CONYUGE_TITULAR_3 = 57;
		public static final int PORCENTAJE_COMPRA_TITULAR_3 = 58;
		public static final int REGIMEN_MATRIMONIAL_3 = 59;
		public static final int PAIS_TITULAR_3 = 60;
		public static final int PROVINCIA_TITULAR_3 = 61;
		public static final int MUNICIPIO_TITULAR_3 = 62;
		public static final int DIRECCION_TITULAR_3 = 63;
		public static final int NOMBRE_RTE_TITULAR_3 = 64;
		public static final int RAZON_SOCIAL_RTE_TITULAR_3 = 65;
		public static final int TIPO_DOCUMENTO_RTE_TITULAR_3 = 66;
		public static final int DOC_IDENTIFICACION_RTE_TITULAR_3 = 67;
		public static final int PAIS_RTE_TITULAR_3 = 68;
		public static final int PROVINCIA_RTE_TITULAR_3 = 69;
		public static final int MUNICIPIO_RTE_TITULAR_3 = 70;

		// Titular 4
		public static final int NOMBRE_TITULAR_4 = 71;
		public static final int RAZON_SOCIAL_TITULAR_4 = 72;
		public static final int TIPO_DOCUMENTO_TITULAR_4 = 73;
		public static final int DOC_IDENTIFICACION_TITULAR_4 = 74;
		public static final int NUMERO_URSUS_TITULAR_4 = 75;
		public static final int NUMERO_URSUS_CONYUGE_TITULAR_4 = 76;
		public static final int PORCENTAJE_COMPRA_TITULAR_4 = 77;
		public static final int REGIMEN_MATRIMONIAL_4 = 78;
		public static final int PAIS_TITULAR_4 = 79;
		public static final int PROVINCIA_TITULAR_4 = 80;
		public static final int MUNICIPIO_TITULAR_4 = 81;
		public static final int DIRECCION_TITULAR_4 = 82;
		public static final int NOMBRE_RTE_TITULAR_4 = 83;
		public static final int RAZON_SOCIAL_RTE_TITULAR_4 = 84;
		public static final int TIPO_DOCUMENTO_RTE_TITULAR_4 = 85;
		public static final int DOC_IDENTIFICACION_RTE_TITULAR_4 = 86;
		public static final int PAIS_RTE_TITULAR_4 = 87;
		public static final int PROVINCIA_RTE_TITULAR_4 = 88;
		public static final int MUNICIPIO_RTE_TITULAR_4 = 89;
	}

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private MSVExcelParser excelParser;

	@Autowired
	private MSVBusinessValidationRunner validationRunner;

	@Autowired
	private ParticularValidatorApi particularValidator;

	@Resource
	MessageService messageServices;

	@Autowired
	private MSVProcesoApi msvProcesoApi;

	private Integer numFilasHoja;

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		/*
		 * List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		 * MSVHojaExcel exc =
		 * excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		 * MSVHojaExcel excPlantilla =
		 * excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion())
		 * ); MSVBusinessValidators validators =
		 * validationFactory.getValidators(getTipoOperacion(dtoFile.
		 * getIdTipoOperacion())); MSVBusinessCompositeValidators
		 * compositeValidators =
		 * validationFactory.getCompositeValidators(getTipoOperacion(dtoFile.
		 * getIdTipoOperacion())); MSVDtoValidacion dtoValidacionContenido =
		 * recorrerFichero(exc, excPlantilla, lista, validators,
		 * compositeValidators, true); MSVDDOperacionMasiva operacionMasiva =
		 * msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		 */
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = new MSVDtoValidacion();
		dtoValidacionContenido.setFicheroTieneErrores(false);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		// Validaciones especificas no contenidas en el fichero Excel de
		// validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());

		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();			
				mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsByRows(exc));
				mapaErrores.put(ACTIVO_EN_AGRUPACION_RESTRINGIDA, activoEnAgrupacionRestringida(exc));
				mapaErrores.put(ACTIVE_NULL, esCampoNullByRows(exc, COL_NUM.NUM_ACTIVO_HAYA));
				mapaErrores.put(PRECIO_VENTA_NULL, esCampoNullByRows(exc, COL_NUM.PRECIO_VENTA));
				mapaErrores.put(OFERTAS_TRAMITADAS, sinOfertasTramitadasByRow(exc));
				mapaErrores.put(MAXIMO_AGRUPADOS, maxAgrupadoByRow(exc));
				mapaErrores.put(TITULARES_AGRUPACION, titularesAgrupacionByRow(exc));
				mapaErrores.put(TITULAR_OPCIONAL_2, titularInformadoSinURSUSByRow(exc, 2));
				mapaErrores.put(TITULAR_OPCIONAL_3, titularInformadoSinURSUSByRow(exc, 3));
				mapaErrores.put(TITULAR_OPCIONAL_4, titularInformadoSinURSUSByRow(exc, 4));
				mapaErrores.put(COMITE_SANCIONADOR_NOT_EXISTS, comiteSancionadorNotExistsByRow(exc));
				mapaErrores.put(COMITE_SANCIONADOR_NULL, esCampoNullByRows(exc, COL_NUM.COMITE_SANCIONADOR));
				mapaErrores.put(TIPO_IMPUESTO_NULL, esCampoNullByRows(exc, COL_NUM.TIPO_IMPUESTO));
				mapaErrores.put(TIPO_IMPUESTO_NOT_EXISTS, tipoImpuestoNotExistsByRow(exc));
				mapaErrores.put(TIPO_APLICABLE_NULL, esCampoNullByRows(exc, COL_NUM.TIPO_APLICABLE));
				mapaErrores.put(FECHA_VENTA_NULL, esCampoNullByRows(exc, COL_NUM.FECHA_VENTA));
				mapaErrores.put(CODIGO_UNICO_OFERTA_NULL, esCampoNullByRows(exc, COL_NUM.CODIGO_UNICO_OFERTA));
				mapaErrores.put(TIPO_DOCUMENTO_TITULAR_NOT_EXISTS, tipoDocumentoNotExistsByrow(exc, 1));
				mapaErrores.put(TIPO_DOCUMENTO_TITULAR_2_NOT_EXISTS, tipoDocumentoNotExistsByrow(exc, 2));
				mapaErrores.put(TIPO_DOCUMENTO_TITULAR_3_NOT_EXISTS, tipoDocumentoNotExistsByrow(exc, 3));
				mapaErrores.put(TIPO_DOCUMENTO_TITULAR_4_NOT_EXISTS, tipoDocumentoNotExistsByrow(exc, 4));
				mapaErrores.put(USER_GESTOR_COMERCIALIZACION_NULL, esCampoNullByRows(exc, COL_NUM.USU_GESTOR_COMERCIALIZACION));
				mapaErrores.put(USER_NO_GESTOR_COMERCIALIZACION, userNotGestorComercializacionByRows(exc));
				mapaErrores.put(CODIGO_PRESCRIPTOR_NULL, esCampoNullByRows(exc, COL_NUM.CODIGO_PRESCRIPTOR));
				mapaErrores.put(CODIGO_PRESCRIPTOR_NOT_EXISTS, codigoPrescriptorNotExistsByRows(exc));
				mapaErrores.put(NUMERO_URSUS_TITULAR_NULL, esCampoNullByRows(exc, COL_NUM.NUMERO_URSUS_TITULAR));
 				mapaErrores.put(ACTIVOS_CARTERA_CAIXABANK_BANKIA, existenActivosConCarteraCaixabankBankia(exc)); 
				mapaErrores.put(ACTIVOS_DIFERENTES_SUBCARTERAS, existenActivosDiferentesSubcarterasEnAgrupacion(exc));
				mapaErrores.put(PORCENTAJE_COMPRA_TITULAR_NULL, esCampoNullByRows(exc, COL_NUM.PORCENTAJE_COMPRA_TITULAR));
				mapaErrores.put(CARTERA_OBLIGATORIA, esCampoNullByRows(exc, COL_NUM.CODIGO_CARTERA));
				mapaErrores.put(FECHA_INGRESO_CHEQUE_OBLIGATORIA, existenActivosDeBHSinFechaIngresoCheque(exc));
				mapaErrores.put(TITULARES_DIFERENTES, validarTitualresOferta(exc));
				mapaErrores.put(GESTORES_DIFERENTES, existenGestoresDiferentesEnAgrupacion(exc));
				mapaErrores.put(PRESCRIPTORES_DIFERENTES, existenPrescriptoresDiferentesEnAgrupacion(exc));
				mapaErrores.put(FORMATO_FECHA_CHEQUE_INVALIDO, esFechaValidaByRows(exc, COL_NUM.FECHA_INGRESO_CHEQUE));
				mapaErrores.put(FORMATO_FECHA_VENTA_INVALIDO, esFechaValidaByRows(exc, COL_NUM.FECHA_VENTA));
				mapaErrores.put(TIPOS_APLICABLES_DIFERENTES, existenTiposAplicablesDiferentesEnAgrupacion(exc));
				mapaErrores.put(TIPO_DOC_OBLIGATORIO, esCampoNullByRows(exc, COL_NUM.TIPO_DOCUMENTO_TITULAR));
				// mapaErrores.put(TIPO_DOC_OBLIGATORIO,
				// esCampoNullByRows(exc,COL_NUM.TIPO_DOCUMENTO_TITULAR_2));
				// mapaErrores.put(TIPO_DOC_OBLIGATORIO,
				// esCampoNullByRows(exc,COL_NUM.TIPO_DOCUMENTO_TITULAR_3));
				// mapaErrores.put(TIPO_DOC_OBLIGATORIO,
				// esCampoNullByRows(exc,COL_NUM.TIPO_DOCUMENTO_TITULAR_4));
				mapaErrores.put(DOC_OBLIGATORIO, esCampoNullByRows(exc, COL_NUM.DOC_IDENTIFICACION_TITULAR));
				// mapaErrores.put(DOC_OBLIGATORIO,
				// esCampoNullByRows(exc,COL_NUM.DOC_IDENTIFICACION_TITULAR_2));
				// mapaErrores.put(DOC_OBLIGATORIO,
				// esCampoNullByRows(exc,COL_NUM.DOC_IDENTIFICACION_TITULAR_3));
				// mapaErrores.put(DOC_OBLIGATORIO,
				// esCampoNullByRows(exc,COL_NUM.DOC_IDENTIFICACION_TITULAR_4));
				mapaErrores.put(PAIS_NO_EXISTE, existePais(exc));
				mapaErrores.put(PROVINCIA_NO_EXISTE, existeProvincia(exc));
				mapaErrores.put(MUNICIPIO_NO_EXISTE, existeMunicipio(exc));
				mapaErrores.put(OBLIGATORIO_DATOS_LOCALIZACION, datosLocalizacionTitularObligatorios(exc));
				mapaErrores.put(OBLIGATORIO_DATOS_RTE, datosRepresentantesObligatorios(exc));

				for (Entry<String, List<Integer>> registro : mapaErrores.entrySet()) {
					if (!registro.getValue().isEmpty()) {
						dtoValidacionContenido.setFicheroTieneErrores(true);
						dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
						break;
					}
				}
		}
		exc.cerrar();
		return dtoValidacionContenido;
	}

	@Override
	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda,
			MSVBusinessValidators contentValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);

		if ((contentValidators != null) && (contentValidators.getValidatorForColumn(nombreColumna.trim()) != null)) {
			MSVColumnValidator v = contentValidators.getValidatorForColumn(nombreColumna.trim());
			MSVValidationResult result = validationRunner.runValidation(v, contenidoCelda);
			resultado.setValido(result.isValid());
			resultado.setErroresFila(result.getErrorMessage());
		}
		return resultado;
	}

	@Override
	protected ResultadoValidacion validaContenidoFila(Map<String, String> mapaDatos, List<String> listaCabeceras,
			MSVBusinessCompositeValidators compositeValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);

		if (compositeValidators != null) {
			List<MSVMultiColumnValidator> listaValidadores = compositeValidators.getValidatorForColumns(listaCabeceras);
			if (listaValidadores != null) {
				MSVValidationResult result = validationRunner.runCompositeValidation(listaValidadores, mapaDatos);
				resultado.setValido(result.isValid());
				resultado.setErroresFila(result.getErrorMessage());
			}
		}
		return resultado;
	}

	private List<Integer> isActiveNotExistsByRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA))
							&& !particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> activoEnAgrupacionRestringida(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)) && particularValidator
							.activoEnAgrupacionRestringida(Long.valueOf(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA))))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> sinOfertasTramitadasByRow(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)) && particularValidator
							.existeOfertaAprobadaActivo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA))) {
						listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> titularesAgrupacionByRow(MSVHojaExcel exc) {
		Map<String, String> titularesMap = new HashMap<String, String>();
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int x = COL_NUM.DATOS_PRIMERA_FILA; x < this.numFilasHoja; x++) {
			try {
				if (!titularesMap.containsKey(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA))) {
					titularesMap.put(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA),
							exc.dameCelda(x, COL_NUM.NUMERO_URSUS_TITULAR));
				} else {
					if (!exc.dameCelda(x, COL_NUM.NUMERO_URSUS_TITULAR)
							.equals(titularesMap.get(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA)))) {
						titularesMap.put(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA), "error");
					}
				}
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if (titularesMap.get(exc.dameCelda(i, COL_NUM.CODIGO_UNICO_OFERTA)).equals("error")) {
					listaFilas.add(i);
				}
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return listaFilas;
	}

	private List<Integer> maxAgrupadoByRow(MSVHojaExcel exc) {

		Map<String, Integer> ocurrencias = new HashMap<String, Integer>();
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int x = COL_NUM.DATOS_PRIMERA_FILA; x < this.numFilasHoja; x++) {
			try {
				if (ocurrencias.containsKey(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA))) {
					ocurrencias.put(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA),
							ocurrencias.get(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA)) + 1);
				} else {
					ocurrencias.put(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA), 1);
				}
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if (ocurrencias.get(exc.dameCelda(i, COL_NUM.CODIGO_UNICO_OFERTA)) > 40) {
					listaFilas.add(i);
				}
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return listaFilas;
	}

	private List<Integer> titularInformadoSinURSUSByRow(MSVHojaExcel exc, Integer titularOpcional) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				try {
					if (titularOpcional == 2) {
						if (Checks.esNulo(exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_2))
								&& (!Checks.esNulo(exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_2))
										|| !Checks.esNulo(exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_2))
										|| !Checks.esNulo(exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_2))
										|| !Checks.esNulo(exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_2))
										|| !Checks.esNulo(exc.dameCelda(i, COL_NUM.NUMERO_URSUS_CONYUGE_TITULAR_2)))) {
							listaFilas.add(i);
						}

					} else if (titularOpcional == 3) {
						if (Checks.esNulo(exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_3))
								&& (!Checks.esNulo(exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_3))
										|| !Checks.esNulo(exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_3))
										|| !Checks.esNulo(exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_3))
										|| !Checks.esNulo(exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_3))
										|| !Checks.esNulo(exc.dameCelda(i, COL_NUM.NUMERO_URSUS_CONYUGE_TITULAR_3)))) {
							listaFilas.add(i);
						}
					} else if (titularOpcional == 4) {
						if (Checks.esNulo(exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_4))
								&& (!Checks.esNulo(exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_4))
										|| !Checks.esNulo(exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_4))
										|| !Checks.esNulo(exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_4))
										|| !Checks.esNulo(exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_4))
										|| !Checks.esNulo(exc.dameCelda(i, COL_NUM.NUMERO_URSUS_CONYUGE_TITULAR_4)))) {
							listaFilas.add(i);
						}
					}

				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> comiteSancionadorNotExistsByRow(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.COMITE_SANCIONADOR)) && !particularValidator
							.existeComiteSancionador(exc.dameCelda(i, COL_NUM.COMITE_SANCIONADOR))) {
						listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> tipoImpuestoNotExistsByRow(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.TIPO_IMPUESTO))
							&& !particularValidator.existeTipoimpuesto(exc.dameCelda(i, COL_NUM.TIPO_IMPUESTO))) {
						listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> tipoDocumentoNotExistsByrow(MSVHojaExcel exc, Integer titular) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		int numero_columna = -1;

		switch (titular) {

		case 1:
			numero_columna = COL_NUM.TIPO_DOCUMENTO_TITULAR;
			break;
		case 2:
			numero_columna = COL_NUM.TIPO_DOCUMENTO_TITULAR_2;
			break;
		case 3:
			numero_columna = COL_NUM.TIPO_DOCUMENTO_TITULAR_3;
			break;
		case 4:
			numero_columna = COL_NUM.TIPO_DOCUMENTO_TITULAR_4;
			break;
		}

		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, numero_columna))
							&& !particularValidator.existeTipoDocumentoByCod(exc.dameCelda(i, numero_columna))) {
						listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
			return listaFilas;
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}

		return listaFilas;

	}

	private List<Integer> userNotGestorComercializacionByRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.COMITE_SANCIONADOR)) && !particularValidator
							.existeGestorComercialByUsername(exc.dameCelda(i, COL_NUM.USU_GESTOR_COMERCIALIZACION))) {
						listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> codigoPrescriptorNotExistsByRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.COMITE_SANCIONADOR)) && !particularValidator
							.existeCodigoPrescriptor(exc.dameCelda(i, COL_NUM.CODIGO_PRESCRIPTOR))) {
						listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}

		return listaFilas;
	}

	// Validador de campos obligatorios, debido a las cabeceras no se valida con
	// el formato de db

	private List<Integer> esCampoNullByRows(MSVHojaExcel exc, Integer campo) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String celda;
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				celda = COL_NUM.PRECIO_VENTA == campo ? Double.valueOf(exc.dameCelda(i, campo)).toString() : exc.dameCelda(i, campo);
				if (Checks.esNulo(celda)) {
					listaFilas.add(i);
				}
			} catch (Exception e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}

	private List<Integer> esFechaValidaByRows(MSVHojaExcel exc, Integer campo) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		String valorDate = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				valorDate = exc.dameCelda(i, campo);

				// Si el valor Date no se puede obtener adecuadamente se lanza
				// error para esa línea.
				if (!Checks.esNulo(valorDate)) {
					ft.setLenient(false);
					ParsePosition p = new ParsePosition(0);
					ft.parse(valorDate, p);
					if (p.getIndex() < valorDate.length()) {
						throw new ParseException(valorDate, p.getIndex());
					}
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	private List<Integer> existenActivosDiferentesSubcarterasEnAgrupacion(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		HashMap<String, String> ofertasSubcarteras = new HashMap<String, String>();
		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				String codigoOferta = exc.dameCelda(i, COL_NUM.CODIGO_UNICO_OFERTA);
				String codigoSubcartera = particularValidator.getSubcartera(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA));
				if (ofertasSubcarteras.containsKey(codigoOferta)) {
					if (!ofertasSubcarteras.get(codigoOferta).equals(codigoSubcartera)) {
						listaFilas.add(i);
					}
				} else {
					ofertasSubcarteras.put(codigoOferta, codigoSubcartera);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return listaFilas;
	}
	
	private List<Integer> existenActivosConCarteraCaixabankBankia(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		HashMap<String, String> numActivoCarteras = new HashMap<String, String>();
		String CODIGO_CARTERA_BANKIA = "03";
		
		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				Integer codigoCarteraExcel = Integer.valueOf(exc.dameCelda(i, COL_NUM.CODIGO_CARTERA));
				String codigoCarteraBbdd = particularValidator.getCartera(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA));
				//Se compara desde nuestra BBDD y el excel, por si la cartera difiere entre ella, en ambos casos si la cartera es
				//BANKIA se  da el aviso
				if(CODIGO_CARTERA_BANKIA.equals(codigoCarteraBbdd) ||  Integer.valueOf(CODIGO_CARTERA_BANKIA) == codigoCarteraExcel) {
						listaFilas.add(i);
						
				}
		
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> existenGestoresDiferentesEnAgrupacion(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		HashMap<String, String> ofertasGestores = new HashMap<String, String>();
		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				String codigoOferta = exc.dameCelda(i, COL_NUM.CODIGO_UNICO_OFERTA);
				String gestor = exc.dameCelda(i, COL_NUM.USU_GESTOR_COMERCIALIZACION);
				if (gestor == null) {
					gestor = "";
				}
				if (ofertasGestores.containsKey(codigoOferta)) {
					if (!ofertasGestores.get(codigoOferta).equals(gestor)) {
						listaFilas.add(i);
					}
				} else {
					ofertasGestores.put(codigoOferta, gestor);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> existenPrescriptoresDiferentesEnAgrupacion(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		HashMap<String, String> ofertasPrescriptores = new HashMap<String, String>();
		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				String codigoOferta = exc.dameCelda(i, COL_NUM.CODIGO_UNICO_OFERTA);
				String prescriptor = exc.dameCelda(i, COL_NUM.CODIGO_PRESCRIPTOR);
				if (prescriptor == null) {
					prescriptor = "";
				}
				if (ofertasPrescriptores.containsKey(codigoOferta)) {
					if (!ofertasPrescriptores.get(codigoOferta).equals(prescriptor)) {
						listaFilas.add(i);
					}
				} else {
					ofertasPrescriptores.put(codigoOferta, prescriptor);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> existenTiposAplicablesDiferentesEnAgrupacion(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		HashMap<String, String> ofertasTiposinpositivos = new HashMap<String, String>();
		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				String codigoOferta = exc.dameCelda(i, COL_NUM.CODIGO_UNICO_OFERTA);
				String tipoImpuesto = exc.dameCelda(i, COL_NUM.TIPO_IMPUESTO);
				String tipoAplicable = exc.dameCelda(i, COL_NUM.TIPO_APLICABLE);
				String tipoImpositivo = "";
				if (tipoImpuesto != null && !tipoImpuesto.isEmpty()) {
					tipoImpositivo = tipoImpositivo + tipoImpuesto;
				}
				if (tipoAplicable != null && !tipoAplicable.isEmpty()) {
					tipoImpositivo = tipoImpositivo + tipoAplicable;
				}

				if (ofertasTiposinpositivos.containsKey(codigoOferta)) {
					if (!ofertasTiposinpositivos.get(codigoOferta).equals(tipoImpositivo)) {
						listaFilas.add(i);
					}
				} else {
					ofertasTiposinpositivos.put(codigoOferta, tipoImpositivo);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> existenActivosDeBHSinFechaIngresoCheque(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				String codigoSubcartera = particularValidator.getSubcartera(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA));
				String fechaIngresoCheque = exc.dameCelda(i, COL_NUM.FECHA_INGRESO_CHEQUE);
				if (codigoSubcartera != null && codigoSubcartera.equals("06")) {
					if (fechaIngresoCheque == null || fechaIngresoCheque.isEmpty()) {
						listaFilas.add(i);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> validarTitualresOferta(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		HashMap<String, String> ofertasTitulares = new HashMap<String, String>();
		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				String codigoOferta = exc.dameCelda(i, COL_NUM.CODIGO_UNICO_OFERTA);

				String infoTitulares = "";

				// primer titular
				if (exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR) != null
						&& !exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR).isEmpty()) {
					infoTitulares = exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR);
				}
				if (exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR) != null
						&& !exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR);
				}
				if (exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR) != null
						&& !exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR);
				}
				if (exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR) != null
						&& !exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR);
				}
				if (exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR) != null
						&& !exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR);
				}
				if (exc.dameCelda(i, COL_NUM.PORCENTAJE_COMPRA_TITULAR) != null
						&& !exc.dameCelda(i, COL_NUM.PORCENTAJE_COMPRA_TITULAR).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.PORCENTAJE_COMPRA_TITULAR);
				}
				// segundo titular
				if (exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_2) != null
						&& !exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_2).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_2);
				}
				if (exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_2) != null
						&& !exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_2).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_2);
				}
				if (exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_2) != null
						&& !exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_2).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_2);
				}
				if (exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_2) != null
						&& !exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_2).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_2);
				}
				if (exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_2) != null
						&& !exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_2).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_2);
				}
				if (exc.dameCelda(i, COL_NUM.PORCENTAJE_COMPRA_TITULAR_2) != null
						&& !exc.dameCelda(i, COL_NUM.PORCENTAJE_COMPRA_TITULAR_2).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.PORCENTAJE_COMPRA_TITULAR_2);
				}
				// tercer titular
				if (exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_3) != null
						&& !exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_3).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_3);
				}
				if (exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_3) != null
						&& !exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_3).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_3);
				}
				if (exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_3) != null
						&& !exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_3).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_3);
				}
				if (exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_3) != null
						&& !exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_3).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_3);
				}
				if (exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_3) != null
						&& !exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_3).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_3);
				}
				if (exc.dameCelda(i, COL_NUM.PORCENTAJE_COMPRA_TITULAR_3) != null
						&& !exc.dameCelda(i, COL_NUM.PORCENTAJE_COMPRA_TITULAR_3).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.PORCENTAJE_COMPRA_TITULAR_3);
				}
				// cuarto titular
				if (exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_4) != null
						&& !exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_4).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_4);
				}
				if (exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_4) != null
						&& !exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_4).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_4);
				}
				if (exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_4) != null
						&& !exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_4).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_4);
				}
				if (exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_4) != null
						&& !exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_4).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_4);
				}
				if (exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_4) != null
						&& !exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_4).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_3);
				}
				if (exc.dameCelda(i, COL_NUM.PORCENTAJE_COMPRA_TITULAR_4) != null
						&& !exc.dameCelda(i, COL_NUM.PORCENTAJE_COMPRA_TITULAR_4).isEmpty()) {
					infoTitulares = infoTitulares + exc.dameCelda(i, COL_NUM.PORCENTAJE_COMPRA_TITULAR_4);
				}

				infoTitulares = infoTitulares.trim();

				if (ofertasTitulares.containsKey(codigoOferta)) {
					if (infoTitulares != null && ofertasTitulares.get(codigoOferta) != null
							&& !infoTitulares.equals(ofertasTitulares.get(codigoOferta))) {
						listaFilas.add(i);
					}
				} else {
					ofertasTitulares.put(codigoOferta, infoTitulares);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return listaFilas;
	}
	
	private List<Integer> existePais(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				String pais = exc.dameCelda(i, COL_NUM.PAIS_TITULAR);
				String paisRte = exc.dameCelda(i, COL_NUM.PAIS_TITULAR);
				if(pais != null && !pais.isEmpty()) {
					Boolean resultado = particularValidator.existePais(pais);
					if(resultado == null || !resultado) {
						listaFilas.add(i);
					}else {
						if(paisRte != null && !paisRte.isEmpty()) {
							resultado = particularValidator.existePais(paisRte);
							if(resultado == null || !resultado) {
								listaFilas.add(i);
							}else {
								String pais2 = exc.dameCelda(i, COL_NUM.PAIS_TITULAR_2);
								String paisRte2 = exc.dameCelda(i, COL_NUM.PAIS_TITULAR_2);
								if(pais2 != null && !pais2.isEmpty()) {
									Boolean resultado2 = particularValidator.existePais(pais2);
									if(resultado2 == null || !resultado2) {
										listaFilas.add(i);
									}else {
										if(paisRte2 != null && !paisRte2.isEmpty()) {
											resultado2 = particularValidator.existePais(paisRte2);
											if(resultado2 == null || !resultado2) {
												listaFilas.add(i);
											}
										}else {
											String pais3 = exc.dameCelda(i, COL_NUM.PAIS_TITULAR_3);
											String paisRte3 = exc.dameCelda(i, COL_NUM.PAIS_TITULAR_3);
											if(pais3 != null && !pais3.isEmpty()) {
												Boolean resultado3 = particularValidator.existePais(pais3);
												if(resultado3 == null || !resultado3) {
													listaFilas.add(i);
												}else {
													if(paisRte3 != null && !paisRte3.isEmpty()) {
														resultado3 = particularValidator.existePais(paisRte3);
														if(resultado3 == null || !resultado3) {
															listaFilas.add(i);
														}
													}else {
														String pais4 = exc.dameCelda(i, COL_NUM.PAIS_TITULAR_4);
														String paisRte4 = exc.dameCelda(i, COL_NUM.PAIS_TITULAR_4);
														if(pais3 != null && !pais4.isEmpty()) {
															Boolean resultado4 = particularValidator.existePais(pais4);
															if(resultado4 == null || !resultado4) {
																listaFilas.add(i);
															}else {
																if(paisRte4 != null && !paisRte4.isEmpty()) {
																	resultado4 = particularValidator.existePais(paisRte4);
																	if(resultado4 == null || !resultado4) {
																		listaFilas.add(i);
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
				
				
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> existeProvincia(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				String provincia = exc.dameCelda(i, COL_NUM.PROVINCIA_TITULAR);
				String provinciaRte = exc.dameCelda(i, COL_NUM.PROVINCIA_RTE_TITULAR);
				if(provincia != null && !provincia.isEmpty()) {
					Boolean resultado = particularValidator.existeProvinciaByCodigo(provincia);
					if(resultado == null || !resultado) {
						listaFilas.add(i);
					}else {
						if(provinciaRte != null && !provinciaRte.isEmpty()) {
							resultado = particularValidator.existeProvinciaByCodigo(provinciaRte);
							if(resultado == null || !resultado) {
								listaFilas.add(i);
							}else {
								String provincia2 = exc.dameCelda(i, COL_NUM.PROVINCIA_TITULAR_2);
								String provinciaRte2 = exc.dameCelda(i, COL_NUM.PROVINCIA_RTE_TITULAR_2);
								if(provincia2 != null && !provincia2.isEmpty()) {
									Boolean resultado2 = particularValidator.existeProvinciaByCodigo(provincia2);
									if(resultado2 == null || !resultado2) {
										listaFilas.add(i);
									}else {
										if(provinciaRte2 != null && !provinciaRte2.isEmpty()) {
											resultado2 = particularValidator.existeProvinciaByCodigo(provinciaRte2);
											if(resultado2 == null || !resultado2) {
												listaFilas.add(i);
											}
										}else {
											String provincia3 = exc.dameCelda(i, COL_NUM.PROVINCIA_TITULAR_3);
											String provinciaRte3 = exc.dameCelda(i, COL_NUM.PROVINCIA_RTE_TITULAR_3);
											if(provincia3 != null && !provincia3.isEmpty()) {
												Boolean resultado3 = particularValidator.existeProvinciaByCodigo(provincia3);
												if(resultado3 == null || !resultado3) {
													listaFilas.add(i);
												}else {
													if(provinciaRte3 != null && !provinciaRte3.isEmpty()) {
														resultado3 = particularValidator.existeProvinciaByCodigo(provinciaRte3);
														if(resultado3 == null || !resultado3) {
															listaFilas.add(i);
														}
													}else {
														String provincia4 = exc.dameCelda(i, COL_NUM.PROVINCIA_TITULAR_4);
														String provinciaRte4 = exc.dameCelda(i, COL_NUM.PROVINCIA_RTE_TITULAR_4);
														if(provincia4 != null && !provincia4.isEmpty()) {
															Boolean resultado4 = particularValidator.existeProvinciaByCodigo(provincia4);
															if(resultado4 == null || !resultado4) {
																listaFilas.add(i);
															}else {
																if(provinciaRte4 != null && !provinciaRte4.isEmpty()) {
																	resultado4 = particularValidator.existeProvinciaByCodigo(provinciaRte4);
																	if(resultado4 == null || !resultado4) {
																		listaFilas.add(i);
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
				
				
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> existeMunicipio(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				String municipio = exc.dameCelda(i, COL_NUM.MUNICIPIO_TITULAR);
				String municipioRte = exc.dameCelda(i, COL_NUM.MUNICIPIO_RTE_TITULAR);
				String provincia = exc.dameCelda(i, COL_NUM.PROVINCIA_TITULAR);
				String provinciaRte = exc.dameCelda(i, COL_NUM.PROVINCIA_RTE_TITULAR);
				if(municipio != null && !municipio.isEmpty() && provincia != null && !provincia.isEmpty()) {
					Boolean resultado = particularValidator.existeMunicipioDeProvinciaByCodigo(provincia, municipio);
					if(resultado == null || !resultado) {
						listaFilas.add(i);
					}else {
						if(municipioRte != null && !municipioRte.isEmpty() && provinciaRte != null && !provinciaRte.isEmpty()) {
							resultado = particularValidator.existeMunicipioDeProvinciaByCodigo(provinciaRte, municipioRte);
							if(resultado == null || !resultado) {
								listaFilas.add(i);
							}else {
								String municipio2 = exc.dameCelda(i, COL_NUM.MUNICIPIO_TITULAR_2);
								String municipioRte2 = exc.dameCelda(i, COL_NUM.MUNICIPIO_RTE_TITULAR_2);
								String provincia2 = exc.dameCelda(i, COL_NUM.PROVINCIA_TITULAR_2);
								String provinciaRte2 = exc.dameCelda(i, COL_NUM.PROVINCIA_RTE_TITULAR_2);
								if(municipio2 != null && !municipio2.isEmpty() && provincia2 != null && !provincia2.isEmpty()) {
									Boolean resultado2 = particularValidator.existeMunicipioDeProvinciaByCodigo(provincia2, municipio2);
									if(resultado2 == null || !resultado2) {
										listaFilas.add(i);
									}else {
										if(municipioRte2 != null && !municipioRte2.isEmpty() && provinciaRte2 != null && !provinciaRte2.isEmpty()) {
											resultado = particularValidator.existeMunicipioDeProvinciaByCodigo(provinciaRte2, municipioRte2);
											if(resultado2 == null || !resultado2) {
												listaFilas.add(i);
											}else {
												String municipio3 = exc.dameCelda(i, COL_NUM.MUNICIPIO_TITULAR_3);
												String municipioRte3 = exc.dameCelda(i, COL_NUM.MUNICIPIO_RTE_TITULAR_3);
												String provincia3 = exc.dameCelda(i, COL_NUM.PROVINCIA_TITULAR_3);
												String provinciaRte3 = exc.dameCelda(i, COL_NUM.PROVINCIA_RTE_TITULAR_3);
												if(municipio3 != null && !municipio3.isEmpty() && provincia3 != null && !provincia3.isEmpty()) {
													Boolean resultado3 = particularValidator.existeMunicipioDeProvinciaByCodigo(provincia3, municipio3);
													if(resultado3 == null || !resultado3) {
														listaFilas.add(i);
													}else {
														if(municipioRte3 != null && !municipioRte3.isEmpty() && provinciaRte3 != null && !provinciaRte3.isEmpty()) {
															resultado = particularValidator.existeMunicipioDeProvinciaByCodigo(provinciaRte3, municipioRte3);
															if(resultado3 == null || !resultado3) {
																listaFilas.add(i);
															}else {
																String municipio4 = exc.dameCelda(i, COL_NUM.MUNICIPIO_TITULAR_4);
																String municipioRte4 = exc.dameCelda(i, COL_NUM.MUNICIPIO_RTE_TITULAR_4);
																String provincia4 = exc.dameCelda(i, COL_NUM.PROVINCIA_TITULAR_4);
																String provinciaRte4 = exc.dameCelda(i, COL_NUM.PROVINCIA_RTE_TITULAR_4);
																if(municipio4 != null && !municipio4.isEmpty() && provincia4 != null && !provincia4.isEmpty()) {
																	Boolean resultado4 = particularValidator.existeMunicipioDeProvinciaByCodigo(provincia4, municipio4);
																	if(resultado4 == null || !resultado4) {
																		listaFilas.add(i);
																	}else {
																		if(municipioRte4 != null && !municipioRte4.isEmpty() && provinciaRte4 != null && !provinciaRte4.isEmpty()) {
																			resultado = particularValidator.existeMunicipioDeProvinciaByCodigo(provinciaRte4, municipioRte4);
																			if(resultado4 == null || !resultado4) {
																				listaFilas.add(i);
																			}else {
																				
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
				
				
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> datosLocalizacionTitularObligatorios(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				String pais = exc.dameCelda(i, COL_NUM.PAIS_TITULAR);
				String provincia = exc.dameCelda(i, COL_NUM.PROVINCIA_TITULAR);
				String municipio = exc.dameCelda(i, COL_NUM.MUNICIPIO_TITULAR);
				String direccion = exc.dameCelda(i, COL_NUM.DIRECCION_TITULAR);
				if (direccion == null || direccion.isEmpty() || pais == null || pais.isEmpty() || (CODIGO_PAIS_ESPANYA.equals(pais) 
						&& (provincia == null || provincia.isEmpty() || municipio == null || municipio.isEmpty()))) {
					listaFilas.add(i);
					
				}else if(exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_2) != null && !exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_2).isEmpty()){				
					String pais2 = exc.dameCelda(i, COL_NUM.PAIS_TITULAR_2);
					String provincia2 = exc.dameCelda(i, COL_NUM.PROVINCIA_TITULAR_2);
					String municipio2 = exc.dameCelda(i, COL_NUM.MUNICIPIO_TITULAR_2);
					String direccion2 = exc.dameCelda(i, COL_NUM.DIRECCION_TITULAR_2);
					if (direccion2 == null || direccion2.isEmpty() || pais2 == null || pais2.isEmpty() || (CODIGO_PAIS_ESPANYA.equals(pais2) 
							&& (provincia2 == null || provincia2.isEmpty() || municipio2 == null || municipio2.isEmpty()))) {
						listaFilas.add(i);
						
					}else if(exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_3) != null && !exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_3).isEmpty()){
						String pais3 = exc.dameCelda(i, COL_NUM.PAIS_TITULAR_3);
						String provincia3 = exc.dameCelda(i, COL_NUM.PROVINCIA_TITULAR_3);
						String municipio3 = exc.dameCelda(i, COL_NUM.MUNICIPIO_TITULAR_3);
						String direccion3 = exc.dameCelda(i, COL_NUM.DIRECCION_TITULAR_3);
						if (direccion3 == null || direccion3.isEmpty() || pais3 == null || pais3.isEmpty() || (CODIGO_PAIS_ESPANYA.equals(pais3) 
								&& (provincia3 == null || provincia3.isEmpty() || municipio3 == null || municipio3.isEmpty()))) {
							listaFilas.add(i);
						}else if(exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_4) != null && !exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_4).isEmpty()){
							String pais4 = exc.dameCelda(i, COL_NUM.PAIS_TITULAR_4);
							String provincia4 = exc.dameCelda(i, COL_NUM.PROVINCIA_TITULAR_4);
							String municipio4 = exc.dameCelda(i, COL_NUM.MUNICIPIO_TITULAR_4);
							String direccion4 = exc.dameCelda(i, COL_NUM.DIRECCION_TITULAR_4);
							if (direccion4 == null || direccion4.isEmpty() || pais4 == null || pais4.isEmpty() || (CODIGO_PAIS_ESPANYA.equals(pais4) 
									&& (provincia4 == null || provincia4.isEmpty() || municipio4 == null || municipio4.isEmpty()))) {
								listaFilas.add(i);
							}
						}
					}
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> datosRepresentantesObligatorios(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		try {
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				String razonSocial = exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR);
				String tipoDocRte = exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_RTE_TITULAR);
				String docRte = exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_RTE_TITULAR);
				String nombreRte = exc.dameCelda(i, COL_NUM.NOMBRE_RTE_TITULAR);
				String razonSocialRte = exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_RTE_TITULAR);
				String paisRte = exc.dameCelda(i, COL_NUM.PAIS_RTE_TITULAR);
				String provinciaRte = exc.dameCelda(i, COL_NUM.PROVINCIA_RTE_TITULAR);
				String municipioRte = exc.dameCelda(i, COL_NUM.MUNICIPIO_RTE_TITULAR);
				if (razonSocial != null && !razonSocial.isEmpty()
						&& (tipoDocRte == null || tipoDocRte.isEmpty() || docRte == null || docRte.isEmpty() 
							|| paisRte == null || paisRte.isEmpty()
							|| (nombreRte == null || nombreRte.isEmpty() || ((razonSocialRte == null || razonSocialRte.isEmpty()) && nombreRte.isEmpty()))
							|| (CODIGO_PAIS_ESPANYA.equals(paisRte) && (provinciaRte == null || provinciaRte.isEmpty() 
							|| municipioRte == null || municipioRte.isEmpty())))) {
					listaFilas.add(i);
				}else if(exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_2) != null && !exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_2).isEmpty()){
					String razonSocial2 = exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_2);
					String tipoDocRte2 = exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_RTE_TITULAR_2);
					String docRte2 = exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_RTE_TITULAR_2);
					String nombreRte2 = exc.dameCelda(i, COL_NUM.NOMBRE_RTE_TITULAR_2);
					String razonSocialRte2 = exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_RTE_TITULAR_2);
					String paisRte2 = exc.dameCelda(i, COL_NUM.PAIS_RTE_TITULAR_2);
					String provinciaRte2 = exc.dameCelda(i, COL_NUM.PROVINCIA_RTE_TITULAR_2);
					String municipioRte2 = exc.dameCelda(i, COL_NUM.MUNICIPIO_RTE_TITULAR_2);
					if (razonSocial2 != null && !razonSocial2.isEmpty()
							&& (tipoDocRte2 == null || tipoDocRte2.isEmpty() || docRte2 == null || docRte2.isEmpty() 
								|| paisRte2 == null || paisRte2.isEmpty()
								|| (nombreRte2 == null || nombreRte2.isEmpty() || ((razonSocialRte2 == null || razonSocialRte2.isEmpty()) && nombreRte2.isEmpty()))
								|| (CODIGO_PAIS_ESPANYA.equals(paisRte2) && (provinciaRte2 == null || provinciaRte2.isEmpty() 
								|| municipioRte2 == null || municipioRte2.isEmpty())))) {
						listaFilas.add(i);
					}else if(exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_3) != null && !exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_3).isEmpty()){
						String razonSocial3 = exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_3);
						String tipoDocRte3 = exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_RTE_TITULAR_3);
						String docRte3 = exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_RTE_TITULAR_3);
						String nombreRte3 = exc.dameCelda(i, COL_NUM.NOMBRE_RTE_TITULAR_3);
						String razonSocialRte3 = exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_RTE_TITULAR_3);
						String paisRte3 = exc.dameCelda(i, COL_NUM.PAIS_RTE_TITULAR_3);
						String provinciaRte3 = exc.dameCelda(i, COL_NUM.PROVINCIA_RTE_TITULAR_3);
						String municipioRte3 = exc.dameCelda(i, COL_NUM.MUNICIPIO_RTE_TITULAR_3);
						if (razonSocial3 != null && !razonSocial3.isEmpty()
								&& (tipoDocRte3 == null || tipoDocRte3.isEmpty() || docRte3 == null || docRte3.isEmpty() 
									|| paisRte3 == null || paisRte3.isEmpty()
									|| (nombreRte3 == null || nombreRte3.isEmpty() || ((razonSocialRte3 == null || razonSocialRte3.isEmpty()) && nombreRte3.isEmpty()))
									|| (CODIGO_PAIS_ESPANYA.equals(paisRte3) && (provinciaRte3 == null || provinciaRte3.isEmpty() 
									|| municipioRte3 == null || municipioRte3.isEmpty())))) {
							listaFilas.add(i);
						}else if(exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_4) != null && !exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_4).isEmpty()){
							String razonSocial4 = exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_4);
							String tipoDocRte4 = exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_RTE_TITULAR_4);
							String docRte4 = exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_RTE_TITULAR_4);
							String nombreRte4 = exc.dameCelda(i, COL_NUM.NOMBRE_RTE_TITULAR_4);
							String razonSocialRte4 = exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_RTE_TITULAR_4);
							String paisRte4 = exc.dameCelda(i, COL_NUM.PAIS_RTE_TITULAR_4);
							String provinciaRte4 = exc.dameCelda(i, COL_NUM.PROVINCIA_RTE_TITULAR_4);
							String municipioRte4 = exc.dameCelda(i, COL_NUM.MUNICIPIO_RTE_TITULAR_4);
							if (razonSocial4 != null && !razonSocial4.isEmpty()
									&& (tipoDocRte4 == null || tipoDocRte4.isEmpty() || docRte4 == null || docRte4.isEmpty() 
										|| paisRte4 == null || paisRte4.isEmpty()
										|| (nombreRte4 == null || nombreRte4.isEmpty() || ((razonSocialRte4 == null || razonSocialRte4.isEmpty()) && nombreRte4.isEmpty()))
										|| (CODIGO_PAIS_ESPANYA.equals(paisRte4) && (provinciaRte4 == null || provinciaRte4.isEmpty() 
										|| municipioRte4 == null || municipioRte4.isEmpty())))) {
								listaFilas.add(i);
							}
						}
					}
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return listaFilas;
	}

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
	
}
