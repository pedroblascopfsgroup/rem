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
	public static final String CARTERA_OBLIGATORIA = "El código de cartera no esta informado.";
	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_NULL = "El campo número activo no puede estar vacío";
	public static final String PRECIO_VENTA_NULL = "El campo precio de venta no puede estar vacío";
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

	public static final class COL_NUM {

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

		// Titular 2
		public static final int NOMBRE_TITULAR_2 = 22;
		public static final int RAZON_SOCIAL_TITULAR_2 = 23;
		public static final int TIPO_DOCUMENTO_TITULAR_2 = 24;
		public static final int DOC_IDENTIFICACION_TITULAR_2 = 25;
		public static final int NUMERO_URSUS_TITULAR_2 = 26;
		public static final int NUMERO_URSUS_CONYUGE_TITULAR_2 = 27;
		public static final int PORCENTAJE_COMPRA_TITULAR_2 = 28;
		public static final int REGIMEN_MATRIMONIAL_2 = 29;

		// Titular 3
		public static final int NOMBRE_TITULAR_3 = 30;
		public static final int RAZON_SOCIAL_TITULAR_3 = 31;
		public static final int TIPO_DOCUMENTO_TITULAR_3 = 32;
		public static final int DOC_IDENTIFICACION_TITULAR_3 = 33;
		public static final int NUMERO_URSUS_TITULAR_3 = 34;
		public static final int NUMERO_URSUS_CONYUGE_TITULAR_3 = 35;
		public static final int PORCENTAJE_COMPRA_TITULAR_3 = 36;
		public static final int REGIMEN_MATRIMONIAL_3 = 37;

		// Titular 4
		public static final int NOMBRE_TITULAR_4 = 38;
		public static final int RAZON_SOCIAL_TITULAR_4 = 39;
		public static final int TIPO_DOCUMENTO_TITULAR_4 = 40;
		public static final int DOC_IDENTIFICACION_TITULAR_4 = 41;
		public static final int NUMERO_URSUS_TITULAR_4 = 42;
		public static final int NUMERO_URSUS_CONYUGE_TITULAR_4 = 43;
		public static final int PORCENTAJE_COMPRA_TITULAR_4 = 44;
		public static final int REGIMEN_MATRIMONIAL_4 = 45;
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
			if (this.numFilasHoja > COL_NUM.DATOS_PRIMERA_FILA) {
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
				mapaErrores.put(USER_GESTOR_COMERCIALIZACION_NULL,
						esCampoNullByRows(exc, COL_NUM.USU_GESTOR_COMERCIALIZACION));
				mapaErrores.put(USER_NO_GESTOR_COMERCIALIZACION, userNotGestorComercializacionByRows(exc));
				mapaErrores.put(CODIGO_PRESCRIPTOR_NULL, esCampoNullByRows(exc, COL_NUM.CODIGO_PRESCRIPTOR));
				mapaErrores.put(CODIGO_PRESCRIPTOR_NOT_EXISTS, codigoPrescriptorNotExistsByRows(exc));
				mapaErrores.put(NUMERO_URSUS_TITULAR_NULL, esCampoNullByRows(exc, COL_NUM.NUMERO_URSUS_TITULAR));
				mapaErrores.put(PORCENTAJE_COMPRA_TITULAR_NULL,
						esCampoNullByRows(exc, COL_NUM.PORCENTAJE_COMPRA_TITULAR));
				mapaErrores.put(ACTIVOS_DIFERENTES_SUBCARTERAS, existenActivosDiferentesSubcarterasEnAgrupacion(exc));
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

				if (!mapaErrores.get(ACTIVE_NOT_EXISTS).isEmpty() || !mapaErrores.get(ACTIVE_NULL).isEmpty()
						|| !mapaErrores.get(PRECIO_VENTA_NULL).isEmpty()
						|| !mapaErrores.get(OFERTAS_TRAMITADAS).isEmpty()
						|| !mapaErrores.get(MAXIMO_AGRUPADOS).isEmpty()
						|| !mapaErrores.get(TITULARES_AGRUPACION).isEmpty()
						|| !mapaErrores.get(TITULAR_OPCIONAL_2).isEmpty()
						|| !mapaErrores.get(TITULAR_OPCIONAL_3).isEmpty()
						|| !mapaErrores.get(TITULAR_OPCIONAL_4).isEmpty()
						|| !mapaErrores.get(COMITE_SANCIONADOR_NULL).isEmpty()
						|| !mapaErrores.get(COMITE_SANCIONADOR_NOT_EXISTS).isEmpty()
						|| !mapaErrores.get(TIPO_IMPUESTO_NULL).isEmpty()
						|| !mapaErrores.get(TIPO_IMPUESTO_NOT_EXISTS).isEmpty()
						|| !mapaErrores.get(TIPO_APLICABLE_NULL).isEmpty()
						|| !mapaErrores.get(FECHA_VENTA_NULL).isEmpty()
						|| !mapaErrores.get(CODIGO_UNICO_OFERTA_NULL).isEmpty()
						|| !mapaErrores.get(TIPO_DOCUMENTO_TITULAR_NOT_EXISTS).isEmpty()
						|| !mapaErrores.get(TIPO_DOCUMENTO_TITULAR_2_NOT_EXISTS).isEmpty()
						|| !mapaErrores.get(TIPO_DOCUMENTO_TITULAR_3_NOT_EXISTS).isEmpty()
						|| !mapaErrores.get(TIPO_DOCUMENTO_TITULAR_4_NOT_EXISTS).isEmpty()
						|| !mapaErrores.get(USER_GESTOR_COMERCIALIZACION_NULL).isEmpty()
						|| !mapaErrores.get(USER_NO_GESTOR_COMERCIALIZACION).isEmpty()
						|| !mapaErrores.get(CODIGO_PRESCRIPTOR_NULL).isEmpty()
						|| !mapaErrores.get(CODIGO_PRESCRIPTOR_NOT_EXISTS).isEmpty()
						|| !mapaErrores.get(NUMERO_URSUS_TITULAR_NULL).isEmpty()
						|| !mapaErrores.get(PORCENTAJE_COMPRA_TITULAR_NULL).isEmpty()
						|| !mapaErrores.get(CARTERA_OBLIGATORIA).isEmpty()
						|| !mapaErrores.get(ACTIVOS_DIFERENTES_SUBCARTERAS).isEmpty()
						|| !mapaErrores.get(FECHA_INGRESO_CHEQUE_OBLIGATORIA).isEmpty()
						|| !mapaErrores.get(TITULARES_DIFERENTES).isEmpty()
						|| !mapaErrores.get(GESTORES_DIFERENTES).isEmpty()
						|| !mapaErrores.get(PRESCRIPTORES_DIFERENTES).isEmpty()
						|| !mapaErrores.get(FORMATO_FECHA_CHEQUE_INVALIDO).isEmpty()
						|| !mapaErrores.get(FORMATO_FECHA_VENTA_INVALIDO).isEmpty()
						|| !mapaErrores.get(TIPOS_APLICABLES_DIFERENTES).isEmpty()
						|| !mapaErrores.get(TIPO_DOC_OBLIGATORIO).isEmpty()
						|| !mapaErrores.get(DOC_OBLIGATORIO).isEmpty()
						|| !mapaErrores.get(ACTIVO_EN_AGRUPACION_RESTRINGIDA).isEmpty()) {
					dtoValidacionContenido.setFicheroTieneErrores(true);
					exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
					String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
					FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
					dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
				}
			} else {
				List<Integer> listaFilas = new ArrayList<Integer>();
				listaFilas.add(COL_NUM.DATOS_PRIMERA_FILA);
				mapaErrores.put(FICHERO_VACIO, listaFilas);

				dtoValidacionContenido.setFicheroTieneErrores(true);
				exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
				String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
				FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
				dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
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

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if (Checks.esNulo(exc.dameCelda(i, campo))) {
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

}
