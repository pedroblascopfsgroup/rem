package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
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
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVAltaActivosTPExcelValidator.COL_NUM;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

@Component
public class MSVAltaActivosExcelValidator extends MSVExcelValidatorAbstract {

	// Constantes
	public static final String DESTINO_COMERCIAL_CODIGO_ALQUILER_VENTA = "02";
	public static final String DESTINO_COMERCIAL_CODIGO_SOLO_ALQUILER = "03";
	public static final String DESTINO_COMERCIAL_CODIGO_ALQUILER_OPCION_COMPRA = "04";
	public static final String CODIGO_CARTERA_SAREB = "02";
	public static final String TIPO_TITULO_COLATERAL_LIQUIDACION_COLATERALES = "04";

	// Textos con errores de validacion
	public static final String ACTIVE_EXISTS = "El activo existe.";
	public static final String ACTIVE_IS_NULL = "El activo no puede ser nulo.";
	public static final String CARTERA_IS_NULL = "La cartera del activo no puede estar vacío.";
	public static final String CARTERA_NOT_EXISTS = "La cartera indicada no existe";
	public static final String SUBCARTERA_IS_NULL = "La subcartera del activo no puede estar vacia";
	public static final String SUBCARTERA_NOT_EXISTS = "La subcartera indicada no existe";
	public static final String SUBCARTERA_CARTERA_INCORRECTA = "La subcartera no pertenece a la cartera indicada";
	public static final String TIPO_TITULO_IS_NULL = "El tipo de título del activo no puede estar vacío.";
	public static final String TIPO_TITULO_CARTERA_INCORRECTA = "No de puede dar de alta dicho tipo de activo para la cartera indicada";
	public static final String SUBTIPO_TITULO_IS_NULL = "El subtipo de título del activo no puede estar vacío.";
	public static final String SUBTIPO_TITULO_INCORRECTO = "El subtipo de título no coincide con el tipo de título.";
	public static final String NUM_ACTIVO_CARTERA_IS_NULL = "El número de activo de cartera no puede estar vacío.";
	public static final String NUM_BIEN_RECOVERY_IS_NULL = "El número de bien recovery no puede estar vacío.";
	public static final String ID_ASUNTO_RECOVERY_IS_NULL = "El ID asunto recovery no puede estar vacío.";
	public static final String TIPO_ACTIVO_IS_NULL = "El tipo de activo no puede estar vacío.";
	public static final String TIPO_ACTIVO_NOT_EXISTS = "El tipo de activo indicado no existe.";
	public static final String SUBTIPO_ACTIVO_NOT_EXISTS = "El subtipo de activo indicado no existe.";
	public static final String SUBTIPO_ACTIVO_IS_NULL = "El subtipo de activo no puede estar vacío.";
	public static final String ESTADO_FISICO_ACTIVO_IS_NULL = "El estado físico del activo no puede estar vacío.";
	public static final String EST_FISICO_NOT_EXISTS = "El código estado físico indicado no existe";
	public static final String USO_DOMINANTE_ACTIVO_IS_NULL = "El uso dominante del activo no puede estar vacío.";
	public static final String USO_DOMINANTE_ACTIVO_NOT_EXISTS = "El uso dominante del activo indicado no existe.";
	public static final String DESC_ACTIVO_IS_NULL = "La descripción del activo no puede estar vacío.";
	public static final String TIPO_VIA_IS_NULL = "El tipo de vía no puede estar vacía.";
	public static final String TIPO_VIA_NOT_EXISTS = "El código tipo de vía indicado no existe";
	public static final String NOMBRE_VIA_IS_NULL = "El nombre de la vía no puede estar vacía.";
	public static final String NUM_VIA_IS_NULL = "El número de la vía no puede estar vacía.";
	public static final String PROVINCIA_IS_NULL = "El código de provincia no puede estar vacía";
	public static final String PROVINCIA_NOT_EXISTS = "El código de provincia indicado no existe";
	public static final String MUNICIPIO_IS_NULL = "El código de municipio no puede estar vacío";
	public static final String UNIDAD_INFERIOR_MUNICIPIO_IS_NULL = "La unidad inferior al municipio no puede estar vacía.";
	public static final String CODIGO_POSTAL_IS_NULL = "El código postal no puede estar vacío.";
	public static final String DESTINO_COMERCIAL_IS_NULL = "El destino comercial no puede estar vacío.";
	public static final String DESTINO_COMERCIAL_NOT_EXISTS = "El código destino comercial indicado no existe";
	public static final String TIPO_ALQUILER_IS_NULL = "El tipo de alquiler no puede estar vacío si el destino comercial incluye alquiler.";
	public static final String TIPO_ALQUILER_NOT_EXISTS = "El código tipo de alquiler indicado no existe";
	public static final String NUM_PRESTAMO_IS_NULL = "El número de prestamo no puede estar vacío.";
	public static final String ESTADO_EXP_RIESGO_NOT_EXISTS = "El número de estado de expediente de riesgo indicado no existe.";
	public static final String NIF_SOCIEDAD_ACREEDORA_IS_NULL = "El NIF de la sociedad acreedora no puede estar vacío.";
	public static final String CODIGO_SOCIEDAD_ACREEDORA_IS_NULL = "El código de la sociedad acreedora no puede estar vacío.";
	public static final String NOMBRE_SOCIEDAD_ACREEDORA_IS_NULL = "El nombre de la sociedad acreedora no puede estar vacío.";
	public static final String ID_GARANTIA_IS_NULL = "El ID de garantía no puede estar vacío";
	public static final String POBL_REGISTRO_IS_NULL = "La población del registro no puede estar vacía.";
	public static final String NUM_REGISTRO_IS_NULL = "El número de registro no puede estar vacío.";
	public static final String TOMO_IS_NULL = "El tomo no puede estar vacío";
	public static final String LIBRO_IS_NULL = "El libro no puede estar vacío";
	public static final String FOLIO_IS_NULL = "El folio no puede estar vacío";
	public static final String FINCA_IS_NULL = "La finca no puede estar vacía.";
	public static final String NIF_PROPIETARIO_IS_NULL = "El NIF de propietario no puede estar vacío.";
	public static final String GRADO_PROPIEDAD_NOT_EXISTS = "El código grado de propiedad indicado no existe";
	public static final String REFERENCIA_CATASTRAL_IS_NULL = "La referencia catastral no puede estar vacía.";
	public static final String VPO_IS_NULL = "El VPO no puede estar vacío.";
	public static final String CALIFICACION_CEE_NOT_EXISTS = "El tipo de calificación energética indicado no existe";
	public static final String NIF_MEDIADOR_IS_NULL = "El NIF mediador no puede estar vacío.";
	public static final String PRECIO_MINIMO_IS_NULL = "El precio mínimo no puede estar vacío.";
	public static final String PRECIO_VENTA_WEB_IS_NULL = "El precio de venta web no puede estar vacío.";
	public static final String PRECIO_MINIMO_IS_NAN = "El importe indicado en precio mínimo no es un valor numérico correcto";
	public static final String PRECIO_VENTA_WEB_IS_NAN = "El importe indicado en precio venta web no es un valor numérico correcto";
	public static final String VALOR_TASACION_IS_NAN = "El importe indicado en el valor de tasación no es un valor numérico correcto";
	public static final String PRECIO_MINIMO_IS_ZERO = "El importe indicado en el precio mínimo ha de ser mayor a 0";
	public static final String PRECIO_VENTA_WEB_IS_ZERO = "El importe indicado en el precio mínimo ha de ser mayor a 0";
	public static final String VALOR_TASACION_IS_ZERO = "El importe indicado en el precio mínimo ha de ser mayor a 0";
	public static final String INTEGRADO_DIVISION_HORIZONTAL_NOT_BOOL = "El valor indicado en INTEGRADO DIVISION HORIZONTAL no es un valor Si/No correcto";
	public static final String GARAJE_ANEJO_NOT_BOOL = "El valor indicado en GARAJE ANEJO no es un valor Si/No correcto";
	public static final String TRASTERO_ANEJO_NOT_BOOL = "El valor indicado en TRASTERO ANEJO no es un valor Si/No correcto";
	public static final String FECHA_TASACION_DATE_FORMAT = "El valor indicado en FECHA TASACIÓN no cumple con el formato de fecha correcto (DD/MM/AAAA)";
	public static final String SOCIEDAD_ACREEDORA_NOT_EXISTS = "El NIF indicado para la sociedad acreedora no se encuentra dado de alta";
	public static final String MEDIADOR_NOT_EXISTS = "El NIF indicado para el mediador no se encuentra dado de alta";
	public static final String CODIGO_SOCIEDAD_ACREEDORA_IS_NAN = "El código de la sociedad acreedora no tiene un formato numérico válido";
	public static final String NUM_ACTIVO_HAYA_IS_NAN = "El código haya del activo no tiene un formato numérico válido";
	public static final String TIPO_TITULO_IS_NAN = "El tipo de título del activo no tiene un formato numérico válido";
	public static final String NUM_ACTIVO_CARTERA_IS_NAN = "El número de activo por cartera no tiene un formato numérico válido";
	public static final String NUM_BIEN_RECOVERY_IS_NAN = "El número del bien en recovery no tiene un formato numérico válido";
	public static final String ID_ASUNTO_RECOVERY_IS_NAN = "El ID del asunto en recovery no tiene un formato numérico válido";
	public static final String ID_GARANTIA_IS_NAN = "El ID de garantía no tiene un formato numérico válido";
	public static final String TOMO_REGISTRO_IS_NAN = "El tomo del registro no tiene un formato numérico válido";
	public static final String LIBRO_REGISTRO_IS_NAN = "El libro del registro no tiene un formato numérico válido";
	public static final String FOLIO_REGISTRO_IS_NAN = "El folio del registro no tiene un formato numérico válido";
	public static final String SUPERFICIE_CONSTRUIDA_REGISTRO_IS_NAN = "La superficie construida indicada del registro no tiene un formato numérico válido";
	public static final String SUPERFICIE_UTIL_REGISTRO_IS_NAN = "La superficie útil no tiene un formato numérico válido";
	public static final String SUPERFICIE_REPERCUSION_EECC_REGISTRO_IS_NAN = "La superficie con repercusión no tiene un formato numérico válido";
	public static final String PARCELA_REGISTRO_IS_NAN = "La parcela del registro no tiene un formato numérico válido";
	public static final String PORCENTAJE_IS_NAN = "El porcentaje de propiedad no tiene un formato numérico válido";
	public static final String PORCENTAJE_SUPERIOR = "El porcentaje de propiedad no se encuentra en un rango válido";
	public static final String CODIGO_POSTAL_IS_NAN = "El código postal no tiene un formato numérico válido o no contiene 5 posiciones";
	public static final String MUNICIPIO_NOT_EXISTS = "El código de municipio especificado no existe";
	public static final String UNIDAD_INFERIOR_MUNICIPIO_NOT_EXISTS = "El código de la unidad inferior al municipio especificado no existe";
	public static final String TIPO_DE_COMERCIALIZACION_INCORRECTO = "El tipo de comercialización es incorrecto";
	public static final String TIPO_DE_COMERCIALIZACION_IS_NULL = "El tipo de comercialización no puede estar vacía";

	// Posicion fija de Columnas excel, para cualquier referencia por posicion
	public static final class COL_NUM {
		static final int FILA_CABECERA = 2;
		static final int DATOS_PRIMERA_FILA = 3;

		static final int NUM_ACTIVO_HAYA = 0;
		static final int COD_CARTERA = 1;
		static final int COD_SUBCARTERA = 2;
		static final int COD_TIPO_TITULO = 3;
		static final int COD_SUBTIPO_TITULO = 4;
		static final int NUM_ACTIVO_CARTERA = 5; // (UVEM, PRINEX, SAREB)
		static final int NUM_BIEN_RECOVERY = 6;
		static final int ID_ASUNTO_RECOVERY = 7;
		static final int COD_TIPO_ACTIVO = 8;
		static final int COD_SUBTIPO_ACTIVO = 9;
		static final int COD_ESTADO_FISICO = 10;
		static final int COD_USO_DOMINANTE = 11;
		static final int DESC_ACTIVO = 12;

		static final int COD_TIPO_VIA = 13;
		static final int NOMBRE_VIA = 14;
		static final int NUM_VIA = 15;
		static final int ESCALERA = 16;
		static final int PLANTA = 17;
		static final int PUERTA = 18;
		static final int COD_PROVINCIA = 19;
		static final int COD_MUNICIPIO = 20;
		static final int COD_UNIDAD_MUNICIPIO = 21;
		static final int CODPOSTAL = 22;

		static final int COD_DESTINO_COMER = 23;
		static final int COD_TIPO_ALQUILER = 24;
		static final int COD_TIPO_DE_COMERCIALIZACION = 25;

		static final int NUM_PRESTAMO = 26; // (MATRIZ, DIVIDIDO)
		static final int ESTADO_EXP_RIESGO = 27;
		static final int NIF_SOCIEDAD_ACREEDORA = 28;
		static final int CODIGO_SOCIEDAD_ACREEDORA = 29;
		static final int NOMBRE_SOCIEDAD_ACREEDORA = 30;
		static final int DIRECCION_SOCIEDAD_ACREEDORA = 31;
		static final int IMPORTE_DEUDA = 32;
		static final int ID_GARANTIA = 33;

		static final int POBL_REGISTRO = 34;
		static final int NUM_REGISTRO = 35;
		static final int TOMO = 36;
		static final int LIBRO = 37;
		static final int FOLIO = 38;
		static final int FINCA = 39;
		static final int IDUFIR_CRU = 40;
		static final int SUPERFICIE_CONSTRUIDA_M2 = 41;
		static final int SUPERFICIE_UTIL_M2 = 42;
		static final int SUPERFICIE_REPERCUSION_EE_CC = 43;
		static final int PARCELA = 44; // (INCLUIDA OCUPADA EDIFICACION)
		static final int ES_INTEGRADO_DIV_HORIZONTAL = 45;

		static final int NIF_PROPIETARIO = 46;
		static final int GRADO_PROPIEDAD = 47;
		static final int PERCENT_PROPIEDAD = 48;

		static final int REF_CATASTRAL = 49;
		static final int VPO = 50;
		static final int CALIFICACION_CEE = 51;

		static final int NIF_MEDIADOR = 52;
		static final int VIVIENDA_NUM_PLANTAS = 53;
		static final int VIVIENDA_NUM_BANYOS = 54;
		static final int VIVIENDA_NUM_ASEOS = 55;
		static final int VIVIENDA_NUM_DORMITORIOS = 56;
		static final int TRASTERO_ANEJO = 57;
		static final int GARAJE_ANEJO = 58;
		static final int ASCENSOR = 59;

		static final int PRECIO_MINIMO = 60;
		static final int PRECIO_VENTA_WEB = 61;
		static final int VALOR_TASACION = 62;
		static final int FECHA_TASACION = 63;
	};

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private MSVExcelParser excelParser;

	@Autowired
	private MSVBusinessValidationRunner validationRunner;

	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Resource
	MessageService messageServices;

	@Autowired
	private MSVProcesoApi msvProcesoApi;

	private Integer numFilasHoja;
	
	private DecimalFormat format;

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile)
			throws RowsExceededException, IllegalArgumentException, WriteException, IOException {
		if (dtoFile.getIdTipoOperacion() == null) {
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}

		// El masivo de propuesta NO REALIZA las validaciones de contenido y
		// formato
		// que se realizan por defecto en todos los masivos
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = new MSVDtoValidacion();
		dtoValidacionContenido.setFicheroTieneErrores(false);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());

		// Validaciones especificas no contenidas en el fichero Excel de
		// validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		// Obtenemos el numero de filas reales que tiene la hoja excel a
		// examinar
		this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);

		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(ACTIVE_EXISTS, isActiveExistsRows(exc));
			mapaErrores.put(ACTIVE_IS_NULL, isColumnNullByRows(exc, COL_NUM.NUM_ACTIVO_HAYA));
			mapaErrores.put(CARTERA_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_CARTERA));
			mapaErrores.put(SUBCARTERA_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_SUBCARTERA));
			mapaErrores.put(SUBCARTERA_CARTERA_INCORRECTA, isCarteraCorrecta(exc, COL_NUM.COD_SUBCARTERA));
			mapaErrores.put(TIPO_TITULO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_TIPO_TITULO));
			mapaErrores.put(TIPO_TITULO_CARTERA_INCORRECTA, isTituloCarteraCorrecta(exc, COL_NUM.COD_TIPO_TITULO));
			mapaErrores.put(SUBTIPO_TITULO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_SUBTIPO_TITULO));
			mapaErrores.put(SUBTIPO_TITULO_INCORRECTO, isTituloCorrecto(exc, COL_NUM.COD_SUBTIPO_TITULO));
			mapaErrores.put(TIPO_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_TIPO_ACTIVO));
			mapaErrores.put(TIPO_ACTIVO_NOT_EXISTS, tipoActivoNotExistsByRows(exc, COL_NUM.COD_TIPO_ACTIVO));
			mapaErrores.put(SUBTIPO_ACTIVO_NOT_EXISTS, subtipoActivoNotExistsByRows(exc, COL_NUM.COD_SUBTIPO_ACTIVO));
			mapaErrores.put(SUBTIPO_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_SUBTIPO_ACTIVO));
			mapaErrores.put(NUM_ACTIVO_CARTERA_IS_NULL, isColumnNullByRows(exc, COL_NUM.NUM_ACTIVO_CARTERA));
			mapaErrores.put(NUM_BIEN_RECOVERY_IS_NULL, isColumnNullByRows(exc, COL_NUM.NUM_BIEN_RECOVERY));
			mapaErrores.put(ID_ASUNTO_RECOVERY_IS_NULL, isColumnNullByRows(exc, COL_NUM.ID_ASUNTO_RECOVERY));
			mapaErrores.put(ESTADO_FISICO_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_ESTADO_FISICO));
			mapaErrores.put(EST_FISICO_NOT_EXISTS, estFisicoNotExistsByRows(exc, COL_NUM.COD_ESTADO_FISICO));
			mapaErrores.put(USO_DOMINANTE_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_USO_DOMINANTE));
			mapaErrores.put(USO_DOMINANTE_ACTIVO_NOT_EXISTS, usoDominanteNotExistsByRows(exc, COL_NUM.COD_USO_DOMINANTE));
			mapaErrores.put(DESC_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.DESC_ACTIVO));
			mapaErrores.put(TIPO_VIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_TIPO_VIA));
			mapaErrores.put(TIPO_VIA_NOT_EXISTS, tipoViaNotExistsByRows(exc, COL_NUM.COD_TIPO_VIA));
			mapaErrores.put(NOMBRE_VIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.NOMBRE_VIA));
			mapaErrores.put(NUM_VIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.NUM_VIA));
			mapaErrores.put(PROVINCIA_NOT_EXISTS, codProvinciaNotExistsByRows(exc, COL_NUM.COD_PROVINCIA));
			mapaErrores.put(PROVINCIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_PROVINCIA));
			mapaErrores.put(UNIDAD_INFERIOR_MUNICIPIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_UNIDAD_MUNICIPIO));
			mapaErrores.put(CODIGO_POSTAL_IS_NULL, isColumnNullByRows(exc, COL_NUM.CODPOSTAL));
			mapaErrores.put(DESTINO_COMERCIAL_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_DESTINO_COMER));
			mapaErrores.put(DESTINO_COMERCIAL_NOT_EXISTS, destComercialNotExistsByRows(exc, COL_NUM.COD_DESTINO_COMER));
			mapaErrores.put(TIPO_ALQUILER_IS_NULL,
					isTipoAlquilerNullConDestinoComercialAlquilerByRows(exc, COL_NUM.COD_TIPO_ALQUILER));
			mapaErrores.put(TIPO_ALQUILER_NOT_EXISTS, tipoAlquilerNotExistsByRows(exc, COL_NUM.COD_TIPO_ALQUILER));
			mapaErrores.put(TIPO_DE_COMERCIALIZACION_INCORRECTO, isTipoDeComercializacionCorrecto(exc, COL_NUM.COD_TIPO_DE_COMERCIALIZACION));
			mapaErrores.put(TIPO_DE_COMERCIALIZACION_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_TIPO_DE_COMERCIALIZACION));
			mapaErrores.put(NUM_PRESTAMO_IS_NULL, isColumnNullByRows(exc, COL_NUM.NUM_PRESTAMO));
			mapaErrores.put(ESTADO_EXP_RIESGO_NOT_EXISTS, estadoExpRiesgoNotExistsByRows(exc, COL_NUM.ESTADO_EXP_RIESGO));
			mapaErrores.put(NIF_SOCIEDAD_ACREEDORA_IS_NULL, isColumnNullByRows(exc, COL_NUM.NIF_SOCIEDAD_ACREEDORA));
			mapaErrores.put(CODIGO_SOCIEDAD_ACREEDORA_IS_NULL,
					isColumnNullByRows(exc, COL_NUM.CODIGO_SOCIEDAD_ACREEDORA));
			mapaErrores.put(NOMBRE_SOCIEDAD_ACREEDORA_IS_NULL,
					isColumnNullByRows(exc, COL_NUM.NOMBRE_SOCIEDAD_ACREEDORA));
			mapaErrores.put(ID_GARANTIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.ID_GARANTIA));
			mapaErrores.put(POBL_REGISTRO_IS_NULL, isColumnNullByRows(exc, COL_NUM.POBL_REGISTRO));
			mapaErrores.put(NUM_REGISTRO_IS_NULL, isColumnNullByRows(exc, COL_NUM.NUM_REGISTRO));
			mapaErrores.put(TOMO_IS_NULL, isColumnNullByRows(exc, COL_NUM.TOMO));
			mapaErrores.put(LIBRO_IS_NULL, isColumnNullByRows(exc, COL_NUM.LIBRO));
			mapaErrores.put(FOLIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.FOLIO));
			mapaErrores.put(FINCA_IS_NULL, isColumnNullByRows(exc, COL_NUM.FINCA));
			mapaErrores.put(NIF_PROPIETARIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.NIF_PROPIETARIO));
			mapaErrores.put(GRADO_PROPIEDAD_NOT_EXISTS, gradoPropiedadNotExistsByRows(exc, COL_NUM.GRADO_PROPIEDAD));
			mapaErrores.put(REFERENCIA_CATASTRAL_IS_NULL, isColumnNullByRows(exc, COL_NUM.REF_CATASTRAL));
			mapaErrores.put(VPO_IS_NULL, isColumnNullByRows(exc, COL_NUM.VPO));
			mapaErrores.put(CALIFICACION_CEE_NOT_EXISTS, calificacionNotExistsByRows(exc, COL_NUM.CALIFICACION_CEE));
			mapaErrores.put(NIF_MEDIADOR_IS_NULL, isColumnNullByRows(exc, COL_NUM.NIF_MEDIADOR));
			mapaErrores.put(PRECIO_MINIMO_IS_NULL, isColumnNullByRows(exc, COL_NUM.PRECIO_MINIMO));
			mapaErrores.put(PRECIO_VENTA_WEB_IS_NULL, isColumnNullByRows(exc, COL_NUM.PRECIO_VENTA_WEB));
			mapaErrores.put(PRECIO_MINIMO_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.PRECIO_MINIMO));
			mapaErrores.put(PRECIO_VENTA_WEB_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.PRECIO_VENTA_WEB));
			mapaErrores.put(VALOR_TASACION_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.VALOR_TASACION));
			mapaErrores.put(PRECIO_MINIMO_IS_ZERO, isColumnZeroPrecioIncorrectoByRows(exc, COL_NUM.PRECIO_MINIMO));
			mapaErrores.put(PRECIO_VENTA_WEB_IS_ZERO,
					isColumnZeroPrecioIncorrectoByRows(exc, COL_NUM.PRECIO_VENTA_WEB));
			mapaErrores.put(VALOR_TASACION_IS_ZERO, isColumnZeroPrecioIncorrectoByRows(exc, COL_NUM.VALOR_TASACION));
			mapaErrores.put(INTEGRADO_DIVISION_HORIZONTAL_NOT_BOOL,
					isColumnNotBoolByRows(exc, COL_NUM.ES_INTEGRADO_DIV_HORIZONTAL));
			mapaErrores.put(GARAJE_ANEJO_NOT_BOOL, isColumnNotBoolByRows(exc, COL_NUM.GARAJE_ANEJO));
			mapaErrores.put(TRASTERO_ANEJO_NOT_BOOL, isColumnNotBoolByRows(exc, COL_NUM.TRASTERO_ANEJO));
			mapaErrores.put(FECHA_TASACION_DATE_FORMAT, isColumnNotDateByRows(exc, COL_NUM.FECHA_TASACION));
			mapaErrores.put(SOCIEDAD_ACREEDORA_NOT_EXISTS,
					sociedadAcreedoraNotExistsByRows(exc, COL_NUM.NIF_SOCIEDAD_ACREEDORA));
			mapaErrores.put(MEDIADOR_NOT_EXISTS, mediadorNotExistsByRows(exc, COL_NUM.NIF_MEDIADOR));
			mapaErrores.put(NUM_ACTIVO_HAYA_IS_NAN, isColumnNANByRows(exc, COL_NUM.NUM_ACTIVO_HAYA));
			mapaErrores.put(TIPO_TITULO_IS_NAN, isColumnNANByRows(exc, COL_NUM.COD_TIPO_TITULO));
			mapaErrores.put(NUM_ACTIVO_CARTERA_IS_NAN, isColumnNANByRows(exc, COL_NUM.NUM_ACTIVO_CARTERA));
			mapaErrores.put(NUM_BIEN_RECOVERY_IS_NAN, isColumnNANByRows(exc, COL_NUM.NUM_BIEN_RECOVERY));
			mapaErrores.put(ID_ASUNTO_RECOVERY_IS_NAN, isColumnNANByRows(exc, COL_NUM.ID_ASUNTO_RECOVERY));
			mapaErrores.put(CODIGO_SOCIEDAD_ACREEDORA_IS_NAN,
					isColumnNANByRows(exc, COL_NUM.CODIGO_SOCIEDAD_ACREEDORA));
			mapaErrores.put(ID_GARANTIA_IS_NAN, isColumnNANByRows(exc, COL_NUM.ID_GARANTIA));
			mapaErrores.put(TOMO_REGISTRO_IS_NAN, isColumnNANByRows(exc, COL_NUM.TOMO));
			mapaErrores.put(LIBRO_REGISTRO_IS_NAN, isColumnNANByRows(exc, COL_NUM.LIBRO));
			mapaErrores.put(FOLIO_REGISTRO_IS_NAN, isColumnNANByRows(exc, COL_NUM.FOLIO));
			mapaErrores.put(SUPERFICIE_CONSTRUIDA_REGISTRO_IS_NAN,
					isColumnFloatNANByRows(exc, COL_NUM.SUPERFICIE_CONSTRUIDA_M2));
			mapaErrores.put(SUPERFICIE_UTIL_REGISTRO_IS_NAN, isColumnFloatNANByRows(exc, COL_NUM.SUPERFICIE_UTIL_M2));
			mapaErrores.put(SUPERFICIE_REPERCUSION_EECC_REGISTRO_IS_NAN,
					isColumnFloatNANByRows(exc, COL_NUM.SUPERFICIE_REPERCUSION_EE_CC));
			mapaErrores.put(PARCELA_REGISTRO_IS_NAN, isColumnFloatNANByRows(exc, COL_NUM.PARCELA));
			mapaErrores.put(PORCENTAJE_IS_NAN, isColumnFloatNANByRows(exc, COL_NUM.PERCENT_PROPIEDAD));
			mapaErrores.put(PORCENTAJE_SUPERIOR, isColumnPorcentajeSuperiorByRows(exc, COL_NUM.PERCENT_PROPIEDAD));
			mapaErrores.put(CODIGO_POSTAL_IS_NAN, isColumnCodigoPostalValido(exc, COL_NUM.CODPOSTAL));
			mapaErrores.put(MUNICIPIO_NOT_EXISTS, isCodigoMunicipioValido(exc, COL_NUM.COD_MUNICIPIO));
			mapaErrores.put(MUNICIPIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_MUNICIPIO));
			mapaErrores.put(UNIDAD_INFERIOR_MUNICIPIO_NOT_EXISTS,
					isCodigoUnidadInferiorMunicipioValido(exc, COL_NUM.COD_UNIDAD_MUNICIPIO));
			mapaErrores.put(CARTERA_NOT_EXISTS, carteraNotExistsByRows(exc, COL_NUM.COD_CARTERA));
			mapaErrores.put(SUBCARTERA_NOT_EXISTS, subcarteraNotExistsByRows(exc, COL_NUM.COD_SUBCARTERA));

			if (!mapaErrores.get(ACTIVE_EXISTS).isEmpty() || !mapaErrores.get(ACTIVE_IS_NULL).isEmpty()
					|| !mapaErrores.get(CARTERA_IS_NULL).isEmpty()
					|| !mapaErrores.get(SUBCARTERA_IS_NULL).isEmpty()
					|| !mapaErrores.get(SUBCARTERA_CARTERA_INCORRECTA).isEmpty()
					|| !mapaErrores.get(TIPO_TITULO_IS_NULL).isEmpty()
					|| !mapaErrores.get(TIPO_TITULO_CARTERA_INCORRECTA).isEmpty()
					|| !mapaErrores.get(SUBTIPO_TITULO_INCORRECTO).isEmpty()
					|| !mapaErrores.get(SUBTIPO_TITULO_IS_NULL).isEmpty()
					|| !mapaErrores.get(TIPO_ACTIVO_IS_NULL).isEmpty()
					|| !mapaErrores.get(TIPO_ACTIVO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUBTIPO_ACTIVO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUBTIPO_ACTIVO_IS_NULL).isEmpty()
					|| !mapaErrores.get(NUM_ACTIVO_CARTERA_IS_NULL).isEmpty()
					|| !mapaErrores.get(NUM_BIEN_RECOVERY_IS_NULL).isEmpty()
					|| !mapaErrores.get(ID_ASUNTO_RECOVERY_IS_NULL).isEmpty()
					|| !mapaErrores.get(ESTADO_FISICO_ACTIVO_IS_NULL).isEmpty()
					|| !mapaErrores.get(EST_FISICO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(USO_DOMINANTE_ACTIVO_IS_NULL).isEmpty()
					|| !mapaErrores.get(USO_DOMINANTE_ACTIVO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(DESC_ACTIVO_IS_NULL).isEmpty() || !mapaErrores.get(TIPO_VIA_IS_NULL).isEmpty()
					|| !mapaErrores.get(NUM_VIA_IS_NULL).isEmpty() || !mapaErrores.get(NOMBRE_VIA_IS_NULL).isEmpty()
					|| !mapaErrores.get(PROVINCIA_IS_NULL).isEmpty()
					|| !mapaErrores.get(PROVINCIA_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(MUNICIPIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(MUNICIPIO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(UNIDAD_INFERIOR_MUNICIPIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(CODIGO_POSTAL_IS_NULL).isEmpty()
					|| !mapaErrores.get(DESTINO_COMERCIAL_IS_NULL).isEmpty()
					|| !mapaErrores.get(DESTINO_COMERCIAL_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(TIPO_ALQUILER_IS_NULL).isEmpty()
					|| !mapaErrores.get(TIPO_DE_COMERCIALIZACION_INCORRECTO).isEmpty()
					|| !mapaErrores.get(TIPO_DE_COMERCIALIZACION_IS_NULL).isEmpty()
					|| !mapaErrores.get(NUM_PRESTAMO_IS_NULL).isEmpty()
					|| !mapaErrores.get(NIF_SOCIEDAD_ACREEDORA_IS_NULL).isEmpty()
					|| !mapaErrores.get(CODIGO_SOCIEDAD_ACREEDORA_IS_NULL).isEmpty()
					|| !mapaErrores.get(NOMBRE_SOCIEDAD_ACREEDORA_IS_NULL).isEmpty()
					|| !mapaErrores.get(ID_GARANTIA_IS_NULL).isEmpty()
					|| !mapaErrores.get(POBL_REGISTRO_IS_NULL).isEmpty()
					|| !mapaErrores.get(NUM_REGISTRO_IS_NULL).isEmpty()
					|| !mapaErrores.get(TOMO_IS_NULL).isEmpty()
					|| !mapaErrores.get(LIBRO_IS_NULL).isEmpty()
					|| !mapaErrores.get(FOLIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(NIF_PROPIETARIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(GRADO_PROPIEDAD_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(REFERENCIA_CATASTRAL_IS_NULL).isEmpty()
					|| !mapaErrores.get(VPO_IS_NULL).isEmpty() || !mapaErrores.get(PRECIO_MINIMO_IS_NULL).isEmpty()
					|| !mapaErrores.get(CALIFICACION_CEE_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(NIF_MEDIADOR_IS_NULL).isEmpty()
					|| !mapaErrores.get(PRECIO_MINIMO_IS_NAN).isEmpty()
					|| !mapaErrores.get(PRECIO_VENTA_WEB_IS_NAN).isEmpty()
					|| !mapaErrores.get(VALOR_TASACION_IS_NAN).isEmpty()
					|| !mapaErrores.get(PRECIO_MINIMO_IS_ZERO).isEmpty()
					|| !mapaErrores.get(PRECIO_VENTA_WEB_IS_ZERO).isEmpty()
					|| !mapaErrores.get(VALOR_TASACION_IS_ZERO).isEmpty()
					|| !mapaErrores.get(GARAJE_ANEJO_NOT_BOOL).isEmpty()
					|| !mapaErrores.get(TRASTERO_ANEJO_NOT_BOOL).isEmpty()
					|| !mapaErrores.get(FECHA_TASACION_DATE_FORMAT).isEmpty()
					|| !mapaErrores.get(SOCIEDAD_ACREEDORA_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(MEDIADOR_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(PRECIO_VENTA_WEB_IS_NULL).isEmpty()
					|| !mapaErrores.get(CODIGO_SOCIEDAD_ACREEDORA_IS_NAN).isEmpty()
					|| !mapaErrores.get(NUM_ACTIVO_HAYA_IS_NAN).isEmpty()
					|| !mapaErrores.get(NUM_ACTIVO_CARTERA_IS_NAN).isEmpty()
					|| !mapaErrores.get(NUM_BIEN_RECOVERY_IS_NAN).isEmpty()
					|| !mapaErrores.get(ID_ASUNTO_RECOVERY_IS_NAN).isEmpty()
					|| !mapaErrores.get(ID_GARANTIA_IS_NAN).isEmpty()
					|| !mapaErrores.get(TOMO_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(LIBRO_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(FOLIO_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(SUPERFICIE_CONSTRUIDA_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(SUPERFICIE_UTIL_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(SUPERFICIE_REPERCUSION_EECC_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(PARCELA_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(PORCENTAJE_IS_NAN).isEmpty() || !mapaErrores.get(CODIGO_POSTAL_IS_NAN).isEmpty()
					|| !mapaErrores.get(PORCENTAJE_SUPERIOR).isEmpty() || !mapaErrores.get(FINCA_IS_NULL).isEmpty()
					|| !mapaErrores.get(UNIDAD_INFERIOR_MUNICIPIO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(UNIDAD_INFERIOR_MUNICIPIO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(UNIDAD_INFERIOR_MUNICIPIO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(CARTERA_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUBCARTERA_NOT_EXISTS).isEmpty()) {

				dtoValidacionContenido.setFicheroTieneErrores(true);
				exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
				String nomFicheroErrores = exc.crearExcelErroresMejoradoByHojaAndFilaCabecera(mapaErrores, 0,
						COL_NUM.FILA_CABECERA);
				FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
				dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
			}
		}
		exc.cerrar();

		return dtoValidacionContenido;
	}

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

	/**
	 * Realiza validaciones multivalor con diferentes valores de la fila
	 * 
	 * @param mapaDatos
	 * @param compositeValidators
	 * @return
	 */
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

	private List<Integer> isActiveExistsRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for (i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
				if (particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)))
					listaFilas.add(i);
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error(e.getMessage(),e);
			listaFilas.add(i);
		}

		return listaFilas;
	}

	/**
	 * Método genérico para comprobar si el valor de una columna está informado
	 * o no.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> isColumnNullByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (Checks.esNulo(exc.dameCelda(i, columnNumber))) {
					listaFilas.add(i);
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	/**
	 * Método que comprueba si el destino comercial es de algún tipo de alquiler
	 * para posteriormente comprobar si el tipo de alquiler se encuentra
	 * informado.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> isTipoAlquilerNullConDestinoComercialAlquilerByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String codDestinoComercial = exc.dameCelda(i, COL_NUM.COD_DESTINO_COMER);
				if (codDestinoComercial.equals(DESTINO_COMERCIAL_CODIGO_ALQUILER_OPCION_COMPRA)
						|| codDestinoComercial.equals(DESTINO_COMERCIAL_CODIGO_ALQUILER_VENTA)
						|| codDestinoComercial.equals(DESTINO_COMERCIAL_CODIGO_SOLO_ALQUILER)) {

					if (Checks.esNulo(exc.dameCelda(i, columnNumber)))
						listaFilas.add(i);
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	/**
	 * Método genérico para comprobar si el importe de una columna, normalmente
	 * para precios, es de tipo numérico.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> isColumnNANPrecioIncorrectoByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precio = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				
				String value = exc.dameCelda(i, columnNumber);
				if(value != null && !value.isEmpty()){
					if(value.contains(",")){
						value = value.replace(",", ".");
					}
				}
				
				precio = !Checks.esNulo(value)
						? Double.parseDouble(value) : null;

				// Si el precio no es un número válido.
				if ((!Checks.esNulo(precio) && precio.isNaN()))
					listaFilas.add(i);
			} catch (NumberFormatException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	/**
	 * Método genérico para comprobar si el importe de una columna, normalmente
	 * para precios, se encuentra por encima de 0.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> isColumnZeroPrecioIncorrectoByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precio = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String value = exc.dameCelda(i, columnNumber);
				if(value != null && !value.isEmpty()){
					if(value.contains(",")){
						value = value.replace(",", ".");
					}
				}
				precio = !Checks.esNulo(value) ? Double.parseDouble(value) : null;

				// Si el precio no se encuentra por encima de 0.
				if ((!Checks.esNulo(precio) && precio.compareTo(0.0D) <= 0))
					listaFilas.add(i);
			} catch (NumberFormatException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	/**
	 * Método genérico para comprobar si el valor de una columna es de tipo
	 * Boolean mediante los carácteres 's' o 'si' para True y 'n' o 'no' para
	 * False.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> isColumnNotBoolByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String valorBool = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				valorBool = exc.dameCelda(i, columnNumber);

				// Si el valor Boolean no se corresponde con el estándar.
				if (!Checks.esNulo(valorBool) && (!valorBool.equalsIgnoreCase("s") && !valorBool.equalsIgnoreCase("n")
						&& !valorBool.equalsIgnoreCase("si") && !valorBool.equalsIgnoreCase("no"))) {
					listaFilas.add(i);
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	/**
	 * Método genérico para comprobar si el valor de una columna se puede
	 * convertir a un objeto Date.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> isColumnNotDateByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		String valorDate = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				valorDate = exc.dameCelda(i, columnNumber);

				// Si el valor Date no se puede obtener adecuadamente se lanza
				// error para esa línea.
				if (!Checks.esNulo(valorDate)) {
					ft.parse(valorDate);
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	/**
	 * Este método comprueba si el NIF indicado en la excel para la sociedad
	 * acreedora se encuentra dado de alta en la DB.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> sociedadAcreedoraNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (particularValidator.existeActivoAsociado(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA))) {
					if(!particularValidator.existeSociedadAcreedora(exc.dameCelda(i, columnNumber))) {
						listaFilas.add(i);
					}
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	/**
	 * Este método comprueba si el código estado físico indicado en la excel se
	 * encuentra dado de alta en la DB.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> estFisicoNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeEstadoFisicoByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	/**
	 * Este método comprueba si el uso dominante indicado en la excel se
	 * encuentra dado de alta en la DB.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> usoDominanteNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeUsoDominanteByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	/**
	 * Este método comprueba si el certificado energético indicado en la excel se
	 * encuentra dado de alta en la DB.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> tipoViaNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeTipoViaByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	/**
	 * Este método comprueba si el código provincia indicado en la excel se
	 * encuentra dado de alta en la DB.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> codProvinciaNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeProvinciaByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	/**
	 * Este método comprueba si el código destino comercial indicado en la excel se
	 * encuentra dado de alta en la DB.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> destComercialNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeDestComercialByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	/**
	 * Este método comprueba si el código tipo alquiler indicado en la excel se
	 * encuentra dado de alta en la DB.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> tipoAlquilerNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeTipoAlquilerByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	/**
	 * Este método comprueba si el código estado expediente riesgo indicado en la excel se
	 * encuentra dado de alta en la DB.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> estadoExpRiesgoNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeEstadoExpRiesgoByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	/**
	 * Este método comprueba si el NIF indicado en la excel para el mediador se
	 * encuentra dado de alta en la DB.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> mediadorNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeProveedorMediadorByNIFConFVD(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	/**
	 * Este método comprueba si el código de grado de propiedad indicado en la excel se
	 * encuentra dado de alta en la DB.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> gradoPropiedadNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeGradoPropiedadByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	/**
	 * Este método comprueba si el certificado energético indicado en la excel se
	 * encuentra dado de alta en la DB.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> calificacionNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeCalifEnergeticaByDesc(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	/**
	 * Método genérico para comprobar si el valor de una columna es de tipo
	 * númerico valido.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> isColumnNANByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String valor = exc.dameCelda(i, columnNumber);
				if (Checks.esNulo(valor) || !StringUtils.isNumeric(valor)) {
					listaFilas.add(i);
				}
			} catch (NumberFormatException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	private List<Integer> isColumnFloatNANByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String valor = exc.dameCelda(i, columnNumber);
				if (!Checks.esNulo(valor)) {
					if(valor.contains("%")){
						valor = valor.replace("%", "");
					}
					Float f = Float.valueOf(valor);
					if (f.isNaN()) {
						listaFilas.add(i);
					}
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	private List<Integer> isColumnPorcentajeSuperiorByRows(MSVHojaExcel exc, int columnNumber)
			throws IllegalArgumentException, IOException {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String valor = exc.dameCelda(i, columnNumber);
				if (!Checks.esNulo(valor)) {
					if(valor.contains("%")){
						valor = valor.replace("%", "");
					}
					Float f = Float.valueOf(valor);
					if (f < 0 || f > 100) {
						listaFilas.add(i);
					}
				}
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			} catch (NumberFormatException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	private List<Integer> isColumnCodigoPostalValido(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String valor = exc.dameCelda(i, columnNumber);
				if (Checks.esNulo(valor) || !StringUtils.isNumeric(valor)) {
					listaFilas.add(i);
				} else if (!Checks.esNulo(valor) && (valor.length() != 5)) {
					listaFilas.add(i);
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}

	private List<Integer> isCodigoMunicipioValido(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeMunicipioByCodigo(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	private List<Integer> subtipoActivoNotExistsByRows(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if(!particularValidator.existeSubtipoActivoByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e){
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e){
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e){
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}
		
		return listaFilas;
	}
	
	private List<Integer> tipoActivoNotExistsByRows(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if (!particularValidator.existeTipoActivoByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e){
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e){
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e){
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}
		
		return listaFilas;
	}

	private List<Integer> isCodigoUnidadInferiorMunicipioValido(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeUnidadInferiorMunicipioByCodigo(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	private List<Integer> isCarteraCorrecta(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String subcartera = exc.dameCelda(i, columnNumber);

				if(!Checks.esNulo(subcartera) && !particularValidator.subcarteraPerteneceCartera(subcartera, exc.dameCelda(i, columnNumber-1))) {
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
	
	private List<Integer> isTituloCorrecto(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.subtipoPerteneceTipoTitulo(exc.dameCelda(i, columnNumber), exc.dameCelda(i, columnNumber-1))){
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
	
	private List<Integer> isTituloCarteraCorrecta(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if(TIPO_TITULO_COLATERAL_LIQUIDACION_COLATERALES.equals(exc.dameCelda(i, columnNumber)) && 
						!CODIGO_CARTERA_SAREB.equals(exc.dameCelda(i, columnNumber-2))){
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
	
	private List<Integer> isTipoDeComercializacionCorrecto(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!Checks.esNulo(exc.dameCelda(i, columnNumber)) && !exc.dameCelda(i, columnNumber).equals("01") && !exc.dameCelda(i, columnNumber).equals("02")){
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
	
	private List<Integer> carteraNotExistsByRows(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if (!particularValidator.existeCarteraByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e){
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e){
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e){
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}
		
		return listaFilas;
	}
	
	private List<Integer> subcarteraNotExistsByRows(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if (!particularValidator.existeSubCarteraByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e){
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e){
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e){
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}
		
		return listaFilas;
	}

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
	
}