package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
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
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;


@Component
public class MSVAltaActivosTPExcelValidator extends MSVExcelValidatorAbstract{
	
	// Constantes
	public static final String DESTINO_COMERCIAL_CODIGO_ALQUILER_VENTA = "02";
	public static final String DESTINO_COMERCIAL_CODIGO_SOLO_ALQUILER = "03";
	public static final String DESTINO_COMERCIAL_CODIGO_ALQUILER_OPCION_COMPRA = "04";

	// Textos con errores de validacion
	public static final String ACTIVE_EXISTS = "El activo existe.";
	public static final String ACTIVE_IS_NULL = "El activo no puede ser nulo.";
	public static final String SUBCARTERA_IS_NULL = "La subcartera del activo no puede estar vacío.";
	public static final String SUBCARTERA_NOT_EXISTS = "La subcartera no existe";
	public static final String SUBTIPO_TITULO_IS_NULL = "El subtipo de título del activo no puede estar vacío.";
	public static final String SUBTIPO_TITULO_NOT_EXISTS = "El código subtipo de título del activo indicado no existe";
	public static final String NUM_ACT_EXTERNO_IS_NULL = "El número de activo externo no puede estar vacío";
	public static final String TIPO_ACTIVO_IS_NULL = "El tipo de activo no puede estar vacío.";
	public static final String TIPO_ACTIVO_NOT_EXISTS = "El tipo de activo no existe";
	public static final String SUBTIPO_ACTIVO_IS_NULL = "El subtipo de activo no puede estar vacío.";
	public static final String SUBTIPO_ACTIVO_NOT_EXISTS = "El subtipo de activo no existe";
	public static final String ESTADO_FISICO_ACTIVO_IS_NULL = "El estado físico del activo no puede estar vacío.";
	public static final String EST_FISICO_NOT_EXISTS = "El código estado físico indicado no existe";
	public static final String USO_DOMINANTE_ACTIVO_IS_NULL = "El uso dominante del activo no puede estar vacío.";
	public static final String USO_DOMINANTE_ACTIVO_NOT_EXISTS = "El uso dominante del activo indicado no existe.";
	public static final String DESC_ACTIVO_IS_NULL = "La descripción del activo no puede estar vacío.";
	public static final String TIPO_VIA_IS_NULL = "El tipo de vía no puede estar vacía.";
	public static final String TIPO_VIA_NOT_EXISTS = "El código tipo de vía indicado no existe";
	public static final String NOMBRE_VIA_IS_NULL = "El nombre de la vía no puede estar vacía.";
	public static final String NUM_VIA_IS_NULL = "El número de la vía no puede estar vacía.";
	public static final String UNIDAD_INFERIOR_MUNICIPIO_IS_NULL = "La unidad inferior al municipio no puede estar vacía.";
	public static final String CODIGO_POSTAL_IS_NULL = "El código postal no puede estar vacío.";
	public static final String DESTINO_COMERCIAL_NOT_EXISTS = "El código destino comercial indicado no existe";
	public static final String DESTINO_COMERCIAL_IS_NULL = "El destino comercial no puede estar vacío.";
	public static final String TIPO_ALQUILER_IS_NULL = "El tipo de alquiler no puede estar vacío si el destino comercial es \"Alquiler\" o \"Alquiler y venta\".";
	public static final String TIPO_ALQUILER_NOT_EXISTS = "El código tipo de alquiler indicado no existe";
	public static final String NUM_PRESTAMO_IS_NULL = "El número de prestamo no puede estar vacío.";
	public static final String NIF_SOCIEDAD_ACREEDORA_IS_NULL = "El NIF de la sociedad acreedora no puede estar vacío.";
	public static final String CODIGO_SOCIEDAD_ACREEDORA_IS_NULL = "El código de la sociedad acreedora no puede estar vacío.";
	public static final String NOMBRE_SOCIEDAD_ACREEDORA_IS_NULL = "El nombre de la sociedad acreedora no puede estar vacío.";
	public static final String POBL_REGISTRO_IS_NULL = "La población del registro no puede estar vacía.";
	public static final String NUM_REGISTRO_IS_NULL = "El número de registro no puede estar vacío.";
	public static final String FINCA_IS_NULL = "La finca no puede estar vacía.";
	public static final String NIF_PROPIETARIO_IS_NULL = "El NIF de propietario no puede estar vacío.";
	public static final String REFERENCIA_CATASTRAL_IS_NULL = "La referencia catastral no puede estar vacía.";
	public static final String VPO_IS_NULL = "El VPO no puede estar vacío.";
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
	public static final String MEDIADOR_IS_NULL = "El NIF para el mediador no puede estar vacío";
	public static final String CODIGO_SOCIEDAD_ACREEDORA_IS_NAN = "El código de la sociedad acreedora no tiene un formato numérico válido";
	public static final String NUM_ACTIVO_HAYA_IS_NAN = "El código haya del activo no tiene un formato numérico válido";
	public static final String NUM_ACTIVO_CARTERA_IS_NAN = "El número de activo por cartera no tiene un formato numérico válido";
	public static final String NUM_BIEN_RECOVERY_IS_NAN = "El número del bien en recovery no tiene un formato numérico válido";
	public static final String ID_ASUNTO_RECOVERY_IS_NAN = "El ID del asunto en recovery no tiene un formato numérico válido";
	public static final String ID_GARANTIA_IS_NAN = "El ID de garantía no tiene un formato numérico válido";
	public static final String TOMO_REGISTRO_IS_NAN = "El tomo del registro no tiene un formato numérico válido";
	public static final String TOMO_IS_NULL = "El tomo no puede estar vacío";
	public static final String LIBRO_REGISTRO_IS_NAN = "El libro del registro no tiene un formato numérico válido";
	public static final String LIBRO_IS_NULL = "El libro no puede estar vacío";
	public static final String FOLIO_REGISTRO_IS_NAN = "El folio del registro no tiene un formato numérico válido";
	public static final String FOLIO_IS_NULL = "El folio no puede estar vacío";
	public static final String SUPERFICIE_CONSTRUIDA_REGISTRO_IS_NAN = "La superficie construida indicada del registro no tiene un formato numérico válido";
	public static final String SUPERFICIE_UTIL_REGISTRO_IS_NAN = "La superficie útil no tiene un formato numérico válido";
	public static final String SUPERFICIE_REPERCUSION_EECC_REGISTRO_IS_NAN = "La superficie con repercusión no tiene un formato numérico válido";
	public static final String PARCELA_REGISTRO_IS_NAN = "La parcela del registro no tiene un formato numérico válido";
	public static final String PORCENTAJE_IS_NAN = "El porcentaje de propiedad no tiene un formato numérico válido";
	public static final String PORCENTAJE_SUPERIOR = "El porcentaje de propiedad no se encuentra en un rango válido";
	public static final String CODIGO_POSTAL_IS_NAN = "El código postal no tiene un formato numérico válido o no contiene 5 posiciones";
	public static final String MUNICIPIO_NOT_EXISTS = "El código de municipio especificado no existe";
	public static final String MUNICIPIO_IS_NULL = "El código de municipio no puede estar vacío";
	public static final String PROVINCIA_IS_NULL = "El código de provincia no puede estar vacía";
	public static final String PROVINCIA_NOT_EXISTS = "El código de provincia indicado no existe";
	public static final String UNIDAD_INFERIOR_MUNICIPIO_NOT_EXISTS = "El código de la unidad inferior al municipio especificado no existe";
	public static final String GESTOR_COMERCIAL_IS_NULL = "El gestor comercial no puede estar vacío";
	public static final String GESTOR_COMERCIAL_NOT_EXISTS = "El gestor comercial no existe";
	public static final String SUPERVISOR_COMERCIAL_IS_NULL = "El supervisor comercial no puede estar vacío";
	public static final String SUPERVISOR_COMERCIAL_NOT_EXISTS = "El supervisor comercial no existe";
	public static final String GESTOR_FORMALIZACION_IS_NULL = "El gestor de formalización no puede estar vacío";
	public static final String GESTOR_FORMALIZACION_NOT_EXISTS = "El gestor de formalización no existe";
	public static final String SUPERVISOR_FORMALIZACION_IS_NULL = "El supervisor de formalización no puede estar vacío";
	public static final String SUPERVISOR_FORMALIZACION_NOT_EXISTS = "El supervisor de formalización no existe";
	public static final String GESTOR_ADMISION_IS_NULL = "El gestor de admisión no puede estar vacío";
	public static final String GESTOR_ADMISION_NOT_EXISTS ="El gestor de admisión no existe";
	public static final String GESTOR_ACTIVOS_IS_NULL = "El gestor de mantenimiento no puede estar vacío";
	public static final String GESTOR_ACTIVOS_NOT_EXISTS = "El gestor de mantenimiento no existe";
	public static final String GESTORIA_FORMALIZACION_IS_NULL = "La gestoría de formalización no puede estar vacía";
	public static final String GESTORIA_FORMALIZACION_NOT_EXISTS ="La gestoría de formalización no existe";
	public static final String TIPO_DE_COMERCIALIZACION_INCORRECTO = "El tipo de comercialización es incorrecto";
	public static final String TIPO_DE_COMERCIALIZACION_IS_NULL = "El tipo de comercialización no puede estar vacía";
	public static final String NIF_CIF_PROPIETARIO_IS_NULL = "El NIF/CIF del propietario no puede estar vacío";
	public static final String NIF_CIF_PROPIETARIO_NOT_EXISTS = "El NIF/CIF del propietario indicado no existe";
	public static final String CALIFICACION_CEE_NOT_EXISTS = "El tipo de calificación energética indicado no existe";
	public static final String GRADO_PROPIEDAD_NOT_EXISTS = "El código grado de propiedad indicado no existe";
	public static final String CLASE_ACTIVO_NOT_EXISTS = "La clase de activo indicada no existe";
	public static final String CLASE_ACTIVO_IS_NULL = "La clase de activo indicada no puede estar vacía"; 
	public static final String GESTORIA_FORMALIZACION_NOT_VALID = "La gestoría de formación introducida no es correcta, debe ser de Garsa, KNB, OGF, Montalvo, Pinos o F&F";

	// Posicion fija de Columnas excel, para cualquier referencia por posicion
	public static final class COL_NUM {
		static final int FILA_CABECERA = 1;
		static final int DATOS_PRIMERA_FILA = 2;
		
		//lalves
		static final int NUM_ACTIVO_HAYA = 0;
		static final int COD_CARTERA = 1;
		static final int COD_SUBTIPO_TITULO = 2;
		static final int NUM_ACTIVO_EXTERNO = 3;
		static final int COD_TIPO_ACTIVO = 4;
		static final int COD_SUBTIPO_ACTIVO = 5;
		static final int COD_ESTADO_FISICO = 6;
		static final int COD_USO_DOMINANTE = 7;
		static final int DESC_ACTIVO = 8;
		
		//Dirección
		static final int COD_TIPO_VIA = 9;
		static final int NOMBRE_VIA = 10;
		static final int NUM_VIA = 11;
		static final int ESCALERA = 12;
		static final int PLANTA = 13;
		static final int PUERTA = 14;
		static final int COD_PROVINCIA = 15;
		static final int COD_MUNICIPIO = 16;
		static final int COD_UNIDAD_MUNICIPIO = 17;
		static final int CODPOSTAL = 18;
		
		//Comercializacion
		static final int COD_DESTINO_COMER = 19;
		static final int COD_TIPO_ALQUILER = 20;
		static final int COD_TIPO_DE_COMERCIALIZACION = 21;
		
		//Inscripción
		static final int POBL_REGISTRO = 22;
		static final int NUM_REGISTRO = 23;
		static final int TOMO = 24;
		static final int LIBRO = 25;
		static final int FOLIO = 26;
		static final int FINCA = 27;
		static final int IDUFIR_CRU = 28;
		static final int SUPERFICIE_CONSTRUIDA_M2 = 29;
		static final int SUPERFICIE_UTIL_M2 = 30;
		static final int SUPERFICIE_REPERCUSION_EE_CC = 31;
		static final int PARCELA = 32; // (INCLUIDA OCUPADA EDIFICACION)
		static final int ES_INTEGRADO_DIV_HORIZONTAL = 33;
		
		//Titulo
		static final int NIF_PROPIETARIO = 34;
		static final int GRADO_PROPIEDAD = 35;
		static final int PERCENT_PROPIEDAD = 36;
		static final int PROP_ANTERIOR = 37;
		
		//
		static final int REF_CATASTRAL = 38;
		static final int VPO = 39;
		static final int CALIFICACION_CEE = 40;
		static final int CED_HABITABILIDAD = 41;
		
		//Información publicación
		static final int NIF_MEDIADOR = 42;
		static final int VIVIENDA_NUM_PLANTAS = 43;
		static final int VIVIENDA_NUM_BANYOS = 44;
		static final int VIVIENDA_NUM_ASEOS = 45;
		static final int VIVIENDA_NUM_DORMITORIOS = 46;
		static final int TRASTERO_ANEJO = 47;
		static final int GARAJE_ANEJO = 48;
		static final int ASCENSOR = 49;
		
		//Información precios
		static final int PRECIO_MINIMO = 50;
		static final int PRECIO_VENTA_WEB = 51;
		static final int VALOR_TASACION = 52;
		static final int FECHA_TASACION = 53;
		
		//Gestores del activo
		static final int GESTOR_COMERCIAL = 54;
		static final int SUPER_GESTOR_COMERCIAL = 55;
		static final int GESTOR_FORMALIZACION = 56;
		static final int SUPER_GESTOR_FORMALIZACION = 57;
		static final int GESTOR_ADMISION = 58;
		static final int GESTOR_ACTIVOS = 59;
		static final int GESTORIA_DE_FORMALIZACION= 60;
		
		//Datos relevantes admisión
		static final int FECHA_INSCRIPCION = 61;
		static final int FECHA_OBT_TITULO = 62;
		static final int FECHA_TOMA_POSESION = 63;
		static final int FECHA_LANZAMIENTO = 64;
		static final int OCUPADO = 65;
		static final int TIENE_TITULO = 66;
		static final int LLAVES = 67;
		static final int CARGAS = 68;
		
		//
		static final int CLASE_ACTIVO = 69;
		static final int FORMALIZACION = 70;
		
		//Datos propietarios
		static final int NOMBRE_PROPIETARIO = 71;
		static final int APELLIDO1_PROPIETARIO = 72;
		static final int APELLIDO2_PROPIETARIO = 73;
		static final int TIPO_PROPIETARIO = 74;
		static final int NIF_CIF_PROPIETARIO = 75;
	};

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
			mapaErrores.put(SUBCARTERA_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_CARTERA));
			mapaErrores.put(SUBCARTERA_NOT_EXISTS, subCarteraNotExistsByRows(exc,COL_NUM.COD_CARTERA));
			mapaErrores.put(SUBTIPO_TITULO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_SUBTIPO_TITULO));
			mapaErrores.put(NUM_ACT_EXTERNO_IS_NULL, isColumnNullByRows(exc,COL_NUM.NUM_ACTIVO_EXTERNO));
			mapaErrores.put(TIPO_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_TIPO_ACTIVO));
			mapaErrores.put(TIPO_ACTIVO_NOT_EXISTS, tipoActivoNotExistsByRows(exc,COL_NUM.COD_TIPO_ACTIVO));
			mapaErrores.put(SUBTIPO_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_SUBTIPO_ACTIVO));
			mapaErrores.put(SUBTIPO_ACTIVO_NOT_EXISTS, subtipoActivoNotExistsByRows(exc, COL_NUM.COD_SUBTIPO_ACTIVO));
			mapaErrores.put(ESTADO_FISICO_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_ESTADO_FISICO));
			mapaErrores.put(USO_DOMINANTE_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_USO_DOMINANTE));
			mapaErrores.put(DESC_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.DESC_ACTIVO));
			mapaErrores.put(TIPO_VIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_TIPO_VIA));
			mapaErrores.put(NOMBRE_VIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.NOMBRE_VIA));
			mapaErrores.put(NUM_VIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.NUM_VIA));
			mapaErrores.put(UNIDAD_INFERIOR_MUNICIPIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_UNIDAD_MUNICIPIO));
			mapaErrores.put(CODIGO_POSTAL_IS_NULL, isColumnNullByRows(exc, COL_NUM.CODPOSTAL));
			mapaErrores.put(DESTINO_COMERCIAL_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_DESTINO_COMER));
			mapaErrores.put(TIPO_DE_COMERCIALIZACION_INCORRECTO, isTipoDeComercializacionCorrecto(exc, COL_NUM.COD_TIPO_DE_COMERCIALIZACION));
			mapaErrores.put(TIPO_DE_COMERCIALIZACION_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_TIPO_DE_COMERCIALIZACION));
			mapaErrores.put(POBL_REGISTRO_IS_NULL, isColumnNullByRows(exc, COL_NUM.POBL_REGISTRO));
			mapaErrores.put(NUM_REGISTRO_IS_NULL, isColumnNullByRows(exc, COL_NUM.NUM_REGISTRO));
			mapaErrores.put(FINCA_IS_NULL, isColumnNullByRows(exc, COL_NUM.FINCA));
			mapaErrores.put(NIF_PROPIETARIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.NIF_PROPIETARIO));
			mapaErrores.put(REFERENCIA_CATASTRAL_IS_NULL, isColumnNullByRows(exc, COL_NUM.REF_CATASTRAL));
			mapaErrores.put(VPO_IS_NULL, isColumnNullByRows(exc, COL_NUM.VPO));
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

			mapaErrores.put(MEDIADOR_NOT_EXISTS, mediadorNotExistsByRows(exc, COL_NUM.NIF_MEDIADOR));
			mapaErrores.put(NUM_ACTIVO_HAYA_IS_NAN, isColumnNANByRows(exc, COL_NUM.NUM_ACTIVO_HAYA));

			mapaErrores.put(TOMO_REGISTRO_IS_NAN, isColumnNANByRows(exc, COL_NUM.TOMO));
			mapaErrores.put(LIBRO_REGISTRO_IS_NAN, isColumnNANByRows(exc, COL_NUM.LIBRO));
			mapaErrores.put(FOLIO_REGISTRO_IS_NAN, isColumnNANByRows(exc, COL_NUM.FOLIO));
			mapaErrores.put(SUPERFICIE_CONSTRUIDA_REGISTRO_IS_NAN,
					isColumnFloatNANByRows(exc, COL_NUM.SUPERFICIE_CONSTRUIDA_M2));
			mapaErrores.put(SUPERFICIE_UTIL_REGISTRO_IS_NAN, isColumnFloatNANByRows(exc, COL_NUM.SUPERFICIE_UTIL_M2));
			mapaErrores.put(SUPERFICIE_REPERCUSION_EECC_REGISTRO_IS_NAN,
					isColumnFloatNANByRows(exc, COL_NUM.SUPERFICIE_REPERCUSION_EE_CC));
			mapaErrores.put(GESTOR_COMERCIAL_IS_NULL, isColumnNullByRows(exc,COL_NUM.GESTOR_COMERCIAL));
			mapaErrores.put(GESTOR_COMERCIAL_NOT_EXISTS, gestorNotExistsByRows(exc, COL_NUM.GESTOR_COMERCIAL));
			mapaErrores.put(SUPERVISOR_COMERCIAL_IS_NULL, isColumnNullByRows(exc,COL_NUM.SUPER_GESTOR_COMERCIAL));
			mapaErrores.put(SUPERVISOR_COMERCIAL_NOT_EXISTS, gestorNotExistsByRows(exc,COL_NUM.SUPER_GESTOR_COMERCIAL));
			mapaErrores.put(GESTOR_FORMALIZACION_NOT_EXISTS, gestorNotExistsByRows(exc,COL_NUM.GESTOR_FORMALIZACION));
			mapaErrores.put(SUPERVISOR_FORMALIZACION_IS_NULL, isColumnNullByRows(exc,COL_NUM.SUPER_GESTOR_FORMALIZACION));
			mapaErrores.put(SUPERVISOR_FORMALIZACION_NOT_EXISTS, gestorNotExistsByRows(exc,COL_NUM.SUPER_GESTOR_FORMALIZACION));
			mapaErrores.put(GESTOR_ADMISION_IS_NULL, isColumnNullByRows(exc, COL_NUM.GESTOR_ADMISION));
			mapaErrores.put(GESTOR_ADMISION_NOT_EXISTS, gestorNotExistsByRows(exc,COL_NUM.GESTOR_ADMISION));
			mapaErrores.put(GESTOR_ACTIVOS_IS_NULL, isColumnNullByRows(exc,COL_NUM.GESTOR_ACTIVOS));
			mapaErrores.put(GESTOR_ACTIVOS_NOT_EXISTS, gestorNotExistsByRows(exc,COL_NUM.GESTOR_ACTIVOS));
			mapaErrores.put(GESTORIA_FORMALIZACION_NOT_EXISTS, gestorNotExistsByRows(exc,COL_NUM.GESTORIA_DE_FORMALIZACION));
			mapaErrores.put(GESTORIA_FORMALIZACION_NOT_VALID, esGestoriaDeFormalizacionCorrecta(exc,COL_NUM.GESTORIA_DE_FORMALIZACION));
			
			mapaErrores.put(PARCELA_REGISTRO_IS_NAN, isColumnFloatNANByRows(exc, COL_NUM.PARCELA));
			mapaErrores.put(PORCENTAJE_IS_NAN, isColumnFloatNANByRows(exc, COL_NUM.PERCENT_PROPIEDAD));
			mapaErrores.put(PORCENTAJE_SUPERIOR, isColumnPorcentajeSuperiorByRows(exc, COL_NUM.PERCENT_PROPIEDAD));
			mapaErrores.put(CODIGO_POSTAL_IS_NAN, isColumnCodigoPostalValido(exc, COL_NUM.CODPOSTAL));
			mapaErrores.put(MUNICIPIO_NOT_EXISTS, isCodigoMunicipioValido(exc, COL_NUM.COD_MUNICIPIO));
			mapaErrores.put(UNIDAD_INFERIOR_MUNICIPIO_NOT_EXISTS,
					isCodigoUnidadInferiorMunicipioValido(exc, COL_NUM.COD_UNIDAD_MUNICIPIO));
			
			mapaErrores.put(PROVINCIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_PROVINCIA));
			mapaErrores.put(MUNICIPIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_MUNICIPIO));
			mapaErrores.put(TOMO_IS_NULL, isColumnNullByRows(exc, COL_NUM.TOMO));
			mapaErrores.put(LIBRO_IS_NULL, isColumnNullByRows(exc, COL_NUM.LIBRO));
			mapaErrores.put(FOLIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.FOLIO));
			mapaErrores.put(MEDIADOR_IS_NULL, isColumnNullByRows(exc, COL_NUM.NIF_MEDIADOR));
			mapaErrores.put(NIF_CIF_PROPIETARIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.NIF_CIF_PROPIETARIO));
			mapaErrores.put(CLASE_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.CLASE_ACTIVO));
			mapaErrores.put(TIPO_ALQUILER_IS_NULL, isTipoAlquilerNullByRowsIfDestComAlq(exc, COL_NUM.COD_TIPO_ALQUILER, COL_NUM.COD_DESTINO_COMER));
			
			mapaErrores.put(CALIFICACION_CEE_NOT_EXISTS, calificacionNotExistsByRows(exc, COL_NUM.CALIFICACION_CEE));
			mapaErrores.put(USO_DOMINANTE_ACTIVO_NOT_EXISTS, usoDominanteNotExistsByRows(exc, COL_NUM.COD_USO_DOMINANTE));
			mapaErrores.put(GRADO_PROPIEDAD_NOT_EXISTS, gradoPropiedadNotExistsByRows(exc, COL_NUM.GRADO_PROPIEDAD));
			mapaErrores.put(DESTINO_COMERCIAL_NOT_EXISTS, destComercialNotExistsByRows(exc, COL_NUM.COD_DESTINO_COMER));
			mapaErrores.put(TIPO_ALQUILER_NOT_EXISTS, tipoAlquilerNotExistsByRows(exc, COL_NUM.COD_TIPO_ALQUILER));
			mapaErrores.put(TIPO_VIA_NOT_EXISTS, tipoViaNotExistsByRows(exc, COL_NUM.COD_TIPO_VIA));
			mapaErrores.put(SUBTIPO_TITULO_NOT_EXISTS, subtipoTituloNotExistsByRows(exc, COL_NUM.COD_SUBTIPO_TITULO));
			mapaErrores.put(PROVINCIA_NOT_EXISTS, codProvinciaNotExistsByRows(exc, COL_NUM.COD_PROVINCIA));
			mapaErrores.put(EST_FISICO_NOT_EXISTS, estFisicoNotExistsByRows(exc, COL_NUM.COD_ESTADO_FISICO));
			mapaErrores.put(NIF_CIF_PROPIETARIO_NOT_EXISTS, nifCifPropietarioNotExistsByRows(exc, COL_NUM.NIF_CIF_PROPIETARIO));
			mapaErrores.put(CLASE_ACTIVO_NOT_EXISTS, claseActivoNotExistsByRows(exc, COL_NUM.CLASE_ACTIVO));



			if (!mapaErrores.get(ACTIVE_EXISTS).isEmpty() || !mapaErrores.get(ACTIVE_IS_NULL).isEmpty() //ok
					|| !mapaErrores.get(SUBCARTERA_IS_NULL).isEmpty()
					|| !mapaErrores.get(SUBCARTERA_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUBTIPO_TITULO_IS_NULL).isEmpty()
					|| !mapaErrores.get(NUM_ACT_EXTERNO_IS_NULL).isEmpty()
					|| !mapaErrores.get(TIPO_ACTIVO_IS_NULL).isEmpty() 
					|| !mapaErrores.get(TIPO_ACTIVO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUBTIPO_ACTIVO_IS_NULL).isEmpty() 
					|| !mapaErrores.get(SUBTIPO_ACTIVO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(ESTADO_FISICO_ACTIVO_IS_NULL).isEmpty()
					|| !mapaErrores.get(USO_DOMINANTE_ACTIVO_IS_NULL).isEmpty()
					|| !mapaErrores.get(DESC_ACTIVO_IS_NULL).isEmpty()
					
					|| !mapaErrores.get(TIPO_VIA_IS_NULL).isEmpty()
					|| !mapaErrores.get(NUM_VIA_IS_NULL).isEmpty()
					|| !mapaErrores.get(NOMBRE_VIA_IS_NULL).isEmpty()
					//provincia
					|| !mapaErrores.get(UNIDAD_INFERIOR_MUNICIPIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(CODIGO_POSTAL_IS_NULL).isEmpty()
					
					|| !mapaErrores.get(DESTINO_COMERCIAL_IS_NULL).isEmpty()
					|| !mapaErrores.get(TIPO_DE_COMERCIALIZACION_INCORRECTO).isEmpty()
					|| !mapaErrores.get(TIPO_DE_COMERCIALIZACION_IS_NULL).isEmpty()
					|| !mapaErrores.get(POBL_REGISTRO_IS_NULL).isEmpty()
					|| !mapaErrores.get(NUM_REGISTRO_IS_NULL).isEmpty()
					|| !mapaErrores.get(NIF_PROPIETARIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(REFERENCIA_CATASTRAL_IS_NULL).isEmpty()
					|| !mapaErrores.get(VPO_IS_NULL).isEmpty()
					|| !mapaErrores.get(PRECIO_MINIMO_IS_NAN).isEmpty()
					|| !mapaErrores.get(PRECIO_MINIMO_IS_ZERO).isEmpty()
					|| !mapaErrores.get(GARAJE_ANEJO_NOT_BOOL).isEmpty()
					|| !mapaErrores.get(TRASTERO_ANEJO_NOT_BOOL).isEmpty()
					|| !mapaErrores.get(MEDIADOR_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(TOMO_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(LIBRO_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(FOLIO_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(PORCENTAJE_IS_NAN).isEmpty() 
					|| !mapaErrores.get(CODIGO_POSTAL_IS_NAN).isEmpty()
					|| !mapaErrores.get(MUNICIPIO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(FINCA_IS_NULL).isEmpty()
					|| !mapaErrores.get(GESTOR_COMERCIAL_IS_NULL).isEmpty()
					|| !mapaErrores.get(GESTOR_COMERCIAL_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUPERVISOR_COMERCIAL_IS_NULL).isEmpty()
					|| !mapaErrores.get(SUPERVISOR_COMERCIAL_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(GESTOR_FORMALIZACION_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUPERVISOR_FORMALIZACION_IS_NULL).isEmpty()
					|| !mapaErrores.get(SUPERVISOR_FORMALIZACION_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(GESTOR_ADMISION_IS_NULL).isEmpty()
					|| !mapaErrores.get(GESTOR_ADMISION_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(GESTOR_ACTIVOS_IS_NULL).isEmpty()
					|| !mapaErrores.get(GESTOR_ACTIVOS_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(GESTORIA_FORMALIZACION_NOT_EXISTS).isEmpty()					
					|| !mapaErrores.get(PROVINCIA_IS_NULL).isEmpty()
					|| !mapaErrores.get(MUNICIPIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(TOMO_IS_NULL).isEmpty()
					|| !mapaErrores.get(LIBRO_IS_NULL).isEmpty()
					|| !mapaErrores.get(FOLIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(MEDIADOR_IS_NULL).isEmpty()
					|| !mapaErrores.get(NIF_CIF_PROPIETARIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(NIF_CIF_PROPIETARIO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(EST_FISICO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(PROVINCIA_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUBTIPO_TITULO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(TIPO_VIA_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(TIPO_ALQUILER_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(DESTINO_COMERCIAL_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(GRADO_PROPIEDAD_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(CALIFICACION_CEE_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(CLASE_ACTIVO_IS_NULL).isEmpty()
					|| !mapaErrores.get(CLASE_ACTIVO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(TIPO_ALQUILER_IS_NULL).isEmpty()
					|| !mapaErrores.get(USO_DOMINANTE_ACTIVO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(GESTORIA_FORMALIZACION_NOT_VALID).isEmpty())
				{

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
				if (Checks.esNulo(exc.dameCelda(i, columnNumber)))
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
				logger.error(e.getMessage());
				listaFilas.add(i);
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
				precio = !Checks.esNulo(exc.dameCelda(i, columnNumber))
						? Double.parseDouble(exc.dameCelda(i, columnNumber)) : null;

				// Si el precio no se encuentra por encima de 0.
				if ((!Checks.esNulo(precio) && precio.compareTo(0.0D) <= 0))
					listaFilas.add(i);
			} catch (NumberFormatException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage());
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
				if (!particularValidator.existeSociedadAcreedora(exc.dameCelda(i, columnNumber)))
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
	 * Este método comprueba si el código tipo alquiler indicado en la excel es
	 * nulo si destino comercial contiene alquiler.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @param destCom
	 *            : número de columna destino comercial.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> isTipoAlquilerNullByRowsIfDestComAlq(MSVHojaExcel exc, int columnNumber, int destCom) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (particularValidator.destComercialContieneAlquiler(exc.dameCelda(i, destCom))) {
					if (Checks.esNulo(exc.dameCelda(i, columnNumber)))
						listaFilas.add(i);
				}
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
	 * Este método comprueba si el código subtipo titulo indicado en la excel se
	 * encuentra dado de alta en la DB.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> subtipoTituloNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeSubtipoTituloByCod(exc.dameCelda(i, columnNumber)))
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
	private List<Integer> claseActivoNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeClaseActivoByDesc(exc.dameCelda(i, columnNumber)))
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
	private List<Integer> nifCifPropietarioNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existePropietario(exc.dameCelda(i, columnNumber)))
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
	 * Este método comprueba que el código de cartera indicado se
	 * encuentra dado de alta en la DB
	 * 
	 * @param exc:
	 * 				: documento excel con los datos
	 * 
	 * @param columnNumber
	 * 				: número de la columna a comprobar
	 * 
	 * @return Devuelve una lista con los errores encontrados. Tantos registros como errores
	 * */
	
	private List<Integer> subCarteraNotExistsByRows(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i< numFilasHoja; i++){
			try {
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
	
	/**
	 * */
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
	
	/**
	 * Este método comprueba que el username indicado para el gestor se
	 * encuentra dado de alta en la DB
	 * 
	 * @param exc
	 * 				: documento excel con los datos
	 * 
	 * @param columnNumber
	 * 				: número de la columna a comprobar
	 * 
	 * @return Devuelve una lista con los errores encontrados. Tantos registros como errores
	 */
	
	private List<Integer> gestorNotExistsByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for(int i = COL_NUM.DATOS_PRIMERA_FILA; i< numFilasHoja; i++){
			try{
				switch (columnNumber) {
				case COL_NUM.GESTOR_COMERCIAL:
												if (!particularValidator.existeGestorComercialByUsername(exc.dameCelda(i, columnNumber))){
														listaFilas.add(i);
												}
												break;
				case COL_NUM.SUPER_GESTOR_COMERCIAL:
												if (!particularValidator.existeSupervisorComercialByUsername(exc.dameCelda(i, columnNumber))){
													listaFilas.add(i);
												}
												break;
				case COL_NUM.GESTOR_FORMALIZACION:
												if (!Checks.esNulo(exc.dameCelda(i, columnNumber))){
													if (!particularValidator.existeGestorFormalizacionByUsername(exc.dameCelda(i, columnNumber))){
														listaFilas.add(i);
													}
												}
												break;
				case COL_NUM.SUPER_GESTOR_FORMALIZACION:
												if (!particularValidator.existeSupervisorFormalizacionByUsername(exc.dameCelda(i, columnNumber))){
													listaFilas.add(i);
												}
												break;
				case COL_NUM.GESTOR_ADMISION:
												if (!particularValidator.existeGestorAdmisionByUsername(exc.dameCelda(i, columnNumber))){
													listaFilas.add(i);
												}
												break;
				case COL_NUM.GESTOR_ACTIVOS:
												if (!particularValidator.existeGestorActivosByUsername(exc.dameCelda(i, columnNumber))){
													listaFilas.add(i);
												}
												break;
				case COL_NUM.GESTORIA_DE_FORMALIZACION:
												if (!Checks.esNulo(exc.dameCelda(i, columnNumber))){
													if (!particularValidator.existeGestoriaDeFormalizacionByUsername(exc.dameCelda(i, columnNumber))){
														listaFilas.add(i);
													}
													
												}
												break;
				}
			}catch (IllegalArgumentException e){
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			}catch (IOException e){
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			}catch (ParseException e){
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
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
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
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			} catch (ParseException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
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
				logger.error(e.getMessage());
				listaFilas.add(i);
			} catch (NumberFormatException e) {
				logger.error(e.getMessage());
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

	private List<Integer> isCodigoMunicipioValido(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeMunicipioByCodigo(exc.dameCelda(i, columnNumber)))
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

	private List<Integer> isCodigoUnidadInferiorMunicipioValido(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeUnidadInferiorMunicipioByCodigo(exc.dameCelda(i, columnNumber)))
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
				logger.error(e.getMessage());
				listaFilas.add(i);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				logger.error(e.getMessage());
				listaFilas.add(i);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}
				
		return listaFilas;
	}
	
	private List<Integer> esGestoriaDeFormalizacionCorrecta(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for(int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				
				if (!Checks.esNulo(exc.dameCelda(i, columnNumber))){
					if (!particularValidator.esGestoriaDeFormalizacionCorrecta(exc.dameCelda(i, columnNumber))){
						listaFilas.add(i);
					}
				}
				
			}catch (IllegalArgumentException e){
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			}catch (IOException e){
				logger.error(e.getMessage());
				e.printStackTrace();
				listaFilas.add(i);
			}catch (ParseException e){
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
