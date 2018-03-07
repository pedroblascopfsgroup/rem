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
	public static final String CARTERA_IS_NULL = "La cartera del activo no puede estar vacío.";
	public static final String CARTERA_NOT_EXISTS = "La cartera no existe";
	public static final String SUBTIPO_TITULO_IS_NULL = "El subtipo de título del activo no puede estar vacío.";
	public static final String NUM_ACT_EXTERNO_IS_NULL = "El número de activo externo no puede estar vacío";
	public static final String TIPO_ACTIVO_IS_NULL = "El tipo de activo no puede estar vacío.";
	public static final String SUBTIPO_ACTIVO_IS_NULL = "El subtipo de activo no puede estar vacío.";
	public static final String ESTADO_FISICO_ACTIVO_IS_NULL = "El estado físico del activo no puede estar vacío.";
	public static final String USO_DOMINANTE_ACTIVO_IS_NULL = "El uso dominante del activo no puede estar vacío.";
	public static final String DESC_ACTIVO_IS_NULL = "La descripción del activo no puede estar vacío.";
	public static final String TIPO_VIA_IS_NULL = "El tipo de vía no puede estar vacía.";
	public static final String NOMBRE_VIA_IS_NULL = "El nombre de la vía no puede estar vacía.";
	public static final String NUM_VIA_IS_NULL = "El número de la vía no puede estar vacía.";
	public static final String UNIDAD_INFERIOR_MUNICIPIO_IS_NULL = "La unidad inferior al municipio no puede estar vacía.";
	public static final String CODIGO_POSTAL_IS_NULL = "El código postal no puede estar vacío.";
	public static final String DESTINO_COMERCIAL_IS_NULL = "El destino comercial no puede estar vacío.";
	public static final String TIPO_ALQUILER_IS_NULL = "El tipo de alquiler no puede estar vacío si el destino comercial incluye alquiler.";
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
	public static final String GESTOR_COMERCIAL_IS_NULL = "El gestor comercial no puede estar vacío";
	public static final String GESTOR_COMERCIAL_NOT_EXISTS = "El gestor comercial no existe";
	public static final String SUPERVISOR_COMERCIAL_IS_NULL = "El supervisor comercial no puede estar vacío";
	public static final String SUPERVISOR_COMERCIAL_NOT_EXISTS = "El supervisor comercial no existe";
	public static final String GESTOR_FORMALIZACION_IS_NULL = "El gestor de formalización no puede estar vacío";
	public static final String GESTOR_FORMALIZACION_NOT_EXISTS = "El supervisor de formalización no existe";
	public static final String SUPERVISOR_FORMALIZACION_IS_NULL = "El supervisor de formalización no puede estar vacío";
	public static final String SUPERVISOR_FORMALIZACION_NOT_EXISTS = "El supervisor de formalización no existe";
	public static final String GESTOR_ADMISION_IS_NULL = "El gestor de admisión no puede estar vacío";
	public static final String GESTOR_ADMISION_NOT_EXISTS ="El gestor de admisión no existe";
	public static final String GESTOR_ACTIVOS_IS_NULL = "El gestor de activos no puede estar vacío";
	public static final String GESTOR_ACTIVOS_NOT_EXISTS = "El gestor de activos no existe";
	public static final String GESTORIA_FORMALIZACION_IS_NULL = "La gestoría de formalización no puede estar vacía";
	public static final String GESTORIA_FORMALIZACION_NOT_EXISTS ="La gestoría de formalización no existe";
	

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
		
		//Inscripción
		static final int POBL_REGISTRO = 21;
		static final int NUM_REGISTRO = 22;
		static final int TOMO = 23;
		static final int LIBRO = 24;
		static final int FOLIO = 25;
		static final int FINCA = 26;
		static final int IDUFIR_CRU = 27;
		static final int SUPERFICIE_CONSTRUIDA_M2 = 28;
		static final int SUPERFICIE_UTIL_M2 = 29;
		static final int SUPERFICIE_REPERCUSION_EE_CC = 30;
		static final int PARCELA = 31; // (INCLUIDA OCUPADA EDIFICACION)
		static final int ES_INTEGRADO_DIV_HORIZONTAL = 32;
		
		//Titulo
		static final int NIF_PROPIETARIO = 33;
		static final int GRADO_PROPIEDAD = 34;
		static final int PERCENT_PROPIEDAD = 35;
		static final int PROP_ANTERIOR = 36;
		
		//
		static final int REF_CATASTRAL = 37;
		static final int VPO = 38;
		static final int CALIFICACION_CEE = 39;
		static final int CED_HABITABILIDAD = 40;
		
		//Información publicación
		static final int NIF_MEDIADOR = 41;
		static final int VIVIENDA_NUM_PLANTAS = 42;
		static final int VIVIENDA_NUM_BANYOS = 43;
		static final int VIVIENDA_NUM_ASEOS = 44;
		static final int VIVIENDA_NUM_DORMITORIOS = 45;
		static final int TRASTERO_ANEJO = 46;
		static final int GARAJE_ANEJO = 47;
		static final int ASCENSOR = 48;
		
		//Información precios
		static final int PRECIO_MINIMO = 49;
		static final int PRECIO_VENTA_WEB = 50;
		static final int VALOR_TASACION = 51;
		static final int FECHA_TASACION = 52;
		
		//Gestores del activo
		static final int GESTOR_COMERCIAL = 53;
		static final int SUPER_GESTOR_COMERCIAL = 54;
		static final int GESTOR_FORMALIZACION = 55;
		static final int SUPER_GESTOR_FORMALIZACION = 56;
		static final int GESTOR_ADMISION = 57;
		static final int GESTOR_ACTIVOS = 58;
		static final int GESTORIA_DE_FORMALIZACION= 59;
		
		//Datos relevantes admisión
		static final int FECHA_INSCRIPCION = 60;
		static final int FECHA_OBT_TITULO = 61;
		static final int FECHA_TOMA_POSESION = 62;
		static final int FECHA_LANZAMIENTO = 63;
		static final int OCUPADO = 64;
		static final int TIENE_TITULO = 65;
		static final int LLAVES = 66;
		static final int CARGAS = 67;
		
		//
		static final int TIPO_ACTIVO = 68;
		static final int FORMALIZACION = 69;
		
		//Datos propietarios
		static final int NOMBRE_PROPIETARIO = 70;
		static final int APELLIDO1_PROPIETARIO = 71;
		static final int APELLIDO2_PROPIETARIO = 72;
		static final int TIPO_PROPIETARIO = 73;
		static final int NIF_CIF_PROPIETARIO = 74;
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
			mapaErrores.put(CARTERA_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_CARTERA));
			mapaErrores.put(CARTERA_NOT_EXISTS, carteraNotExistsByRows(exc,COL_NUM.COD_CARTERA));
			mapaErrores.put(SUBTIPO_TITULO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_SUBTIPO_TITULO));
			mapaErrores.put(NUM_ACT_EXTERNO_IS_NULL, isColumnNullByRows(exc,COL_NUM.NUM_ACTIVO_EXTERNO));
			mapaErrores.put(TIPO_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_TIPO_ACTIVO));
			mapaErrores.put(SUBTIPO_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_SUBTIPO_ACTIVO));
			mapaErrores.put(ESTADO_FISICO_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_ESTADO_FISICO));
			mapaErrores.put(USO_DOMINANTE_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_USO_DOMINANTE));
			mapaErrores.put(DESC_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.DESC_ACTIVO));
			mapaErrores.put(TIPO_VIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_TIPO_VIA));
			mapaErrores.put(NOMBRE_VIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.NOMBRE_VIA));
			mapaErrores.put(NUM_VIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.NUM_VIA));
			mapaErrores.put(UNIDAD_INFERIOR_MUNICIPIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_UNIDAD_MUNICIPIO));
			mapaErrores.put(CODIGO_POSTAL_IS_NULL, isColumnNullByRows(exc, COL_NUM.CODPOSTAL));
			mapaErrores.put(DESTINO_COMERCIAL_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_DESTINO_COMER));
			mapaErrores.put(POBL_REGISTRO_IS_NULL, isColumnNullByRows(exc, COL_NUM.POBL_REGISTRO));
			mapaErrores.put(NUM_REGISTRO_IS_NULL, isColumnNullByRows(exc, COL_NUM.NUM_REGISTRO));
			mapaErrores.put(FINCA_IS_NULL, isColumnNullByRows(exc, COL_NUM.FINCA));
			mapaErrores.put(NIF_PROPIETARIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.NIF_PROPIETARIO));
			mapaErrores.put(REFERENCIA_CATASTRAL_IS_NULL, isColumnNullByRows(exc, COL_NUM.REF_CATASTRAL));
			mapaErrores.put(VPO_IS_NULL, isColumnNullByRows(exc, COL_NUM.VPO));
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
			mapaErrores.put(GESTOR_FORMALIZACION_IS_NULL, isColumnNullByRows(exc,COL_NUM.GESTOR_FORMALIZACION));
			mapaErrores.put(GESTORIA_FORMALIZACION_NOT_EXISTS, gestorNotExistsByRows(exc,COL_NUM.GESTOR_FORMALIZACION));
			mapaErrores.put(SUPERVISOR_FORMALIZACION_IS_NULL, isColumnNullByRows(exc,COL_NUM.SUPER_GESTOR_FORMALIZACION));
			mapaErrores.put(SUPERVISOR_FORMALIZACION_NOT_EXISTS, gestorNotExistsByRows(exc,COL_NUM.SUPER_GESTOR_FORMALIZACION));
			mapaErrores.put(GESTOR_ADMISION_IS_NULL, isColumnNullByRows(exc, COL_NUM.GESTOR_ADMISION));
			mapaErrores.put(GESTOR_ADMISION_NOT_EXISTS, gestorNotExistsByRows(exc,COL_NUM.GESTOR_ADMISION));
			mapaErrores.put(GESTOR_ACTIVOS_IS_NULL, isColumnNullByRows(exc,COL_NUM.GESTOR_ACTIVOS));
			mapaErrores.put(GESTOR_ACTIVOS_NOT_EXISTS, gestorNotExistsByRows(exc,COL_NUM.GESTOR_ACTIVOS));
			mapaErrores.put(GESTORIA_FORMALIZACION_IS_NULL, isColumnNullByRows(exc,COL_NUM.GESTORIA_DE_FORMALIZACION));
			mapaErrores.put(GESTORIA_FORMALIZACION_NOT_EXISTS, gestorNotExistsByRows(exc,COL_NUM.GESTORIA_DE_FORMALIZACION));
			
			mapaErrores.put(PARCELA_REGISTRO_IS_NAN, isColumnFloatNANByRows(exc, COL_NUM.PARCELA));
			mapaErrores.put(PORCENTAJE_IS_NAN, isColumnFloatNANByRows(exc, COL_NUM.PERCENT_PROPIEDAD));
			mapaErrores.put(PORCENTAJE_SUPERIOR, isColumnPorcentajeSuperiorByRows(exc, COL_NUM.PERCENT_PROPIEDAD));
			mapaErrores.put(CODIGO_POSTAL_IS_NAN, isColumnCodigoPostalValido(exc, COL_NUM.CODPOSTAL));
			mapaErrores.put(MUNICIPIO_NOT_EXISTS, isCodigoMunicipioValido(exc, COL_NUM.COD_MUNICIPIO));
			mapaErrores.put(UNIDAD_INFERIOR_MUNICIPIO_NOT_EXISTS,
					isCodigoUnidadInferiorMunicipioValido(exc, COL_NUM.COD_UNIDAD_MUNICIPIO));

			if (!mapaErrores.get(ACTIVE_EXISTS).isEmpty() || !mapaErrores.get(CARTERA_IS_NULL).isEmpty() //ok
					|| !mapaErrores.get(CARTERA_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUBTIPO_TITULO_IS_NULL).isEmpty() //ok
					|| !mapaErrores.get(NUM_ACT_EXTERNO_IS_NULL).isEmpty()
					|| !mapaErrores.get(TIPO_ACTIVO_IS_NULL).isEmpty() //ok 
					|| !mapaErrores.get(SUBTIPO_ACTIVO_IS_NULL).isEmpty() //ok 
					|| !mapaErrores.get(ESTADO_FISICO_ACTIVO_IS_NULL).isEmpty() //ok
					|| !mapaErrores.get(USO_DOMINANTE_ACTIVO_IS_NULL).isEmpty()//ok
					|| !mapaErrores.get(DESC_ACTIVO_IS_NULL).isEmpty() //ok
					
					|| !mapaErrores.get(TIPO_VIA_IS_NULL).isEmpty()//ok
					|| !mapaErrores.get(NUM_VIA_IS_NULL).isEmpty() //ok
					|| !mapaErrores.get(NOMBRE_VIA_IS_NULL).isEmpty()//ok
					//provincia
					|| !mapaErrores.get(UNIDAD_INFERIOR_MUNICIPIO_IS_NULL).isEmpty()//ok
					|| !mapaErrores.get(CODIGO_POSTAL_IS_NULL).isEmpty()//ok
					
					|| !mapaErrores.get(DESTINO_COMERCIAL_IS_NULL).isEmpty()//ok
					//|| !mapaErrores.get(TIPO_ALQUILER_IS_NULL).isEmpty()
					//|| !mapaErrores.get(NUM_PRESTAMO_IS_NULL).isEmpty()
					//|| !mapaErrores.get(NIF_SOCIEDAD_ACREEDORA_IS_NULL).isEmpty()
					//|| !mapaErrores.get(CODIGO_SOCIEDAD_ACREEDORA_IS_NULL).isEmpty()
					//|| !mapaErrores.get(NOMBRE_SOCIEDAD_ACREEDORA_IS_NULL).isEmpty()
					|| !mapaErrores.get(POBL_REGISTRO_IS_NULL).isEmpty()//ok
					|| !mapaErrores.get(NUM_REGISTRO_IS_NULL).isEmpty()//ok
					|| !mapaErrores.get(NIF_PROPIETARIO_IS_NULL).isEmpty()//ok
					|| !mapaErrores.get(REFERENCIA_CATASTRAL_IS_NULL).isEmpty()//ok
					|| !mapaErrores.get(VPO_IS_NULL).isEmpty() //ok
					|| !mapaErrores.get(PRECIO_MINIMO_IS_NULL).isEmpty()//ok
					|| !mapaErrores.get(PRECIO_MINIMO_IS_NAN).isEmpty()//ok
					//|| !mapaErrores.get(PRECIO_VENTA_WEB_IS_NAN).isEmpty()
					//|| !mapaErrores.get(VALOR_TASACION_IS_NAN).isEmpty()
					|| !mapaErrores.get(PRECIO_MINIMO_IS_ZERO).isEmpty()//ok
				//	|| !mapaErrores.get(PRECIO_VENTA_WEB_IS_ZERO).isEmpty()
					//|| !mapaErrores.get(VALOR_TASACION_IS_ZERO).isEmpty()
					|| !mapaErrores.get(GARAJE_ANEJO_NOT_BOOL).isEmpty()//ok
					|| !mapaErrores.get(TRASTERO_ANEJO_NOT_BOOL).isEmpty()//ok
					//|| !mapaErrores.get(FECHA_TASACION_DATE_FORMAT).isEmpty()
					//|| !mapaErrores.get(SOCIEDAD_ACREEDORA_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(MEDIADOR_NOT_EXISTS).isEmpty()//ok
					//|| !mapaErrores.get(PRECIO_VENTA_WEB_IS_NULL).isEmpty()
					//|| !mapaErrores.get(CODIGO_SOCIEDAD_ACREEDORA_IS_NAN).isEmpty()
					//|| !mapaErrores.get(NUM_ACTIVO_HAYA_IS_NAN).isEmpty()
					//|| !mapaErrores.get(NUM_ACTIVO_CARTERA_IS_NAN).isEmpty()
					//|| !mapaErrores.get(NUM_BIEN_RECOVERY_IS_NAN).isEmpty()
					//|| !mapaErrores.get(ID_ASUNTO_RECOVERY_IS_NAN).isEmpty()
					//|| !mapaErrores.get(ID_GARANTIA_IS_NAN).isEmpty()
					|| !mapaErrores.get(TOMO_REGISTRO_IS_NAN).isEmpty()//ok
					|| !mapaErrores.get(LIBRO_REGISTRO_IS_NAN).isEmpty()//ok
					|| !mapaErrores.get(FOLIO_REGISTRO_IS_NAN).isEmpty()//ok
					//|| !mapaErrores.get(SUPERFICIE_CONSTRUIDA_REGISTRO_IS_NAN).isEmpty()
					//|| !mapaErrores.get(SUPERFICIE_UTIL_REGISTRO_IS_NAN).isEmpty()
					//|| !mapaErrores.get(SUPERFICIE_REPERCUSION_EECC_REGISTRO_IS_NAN).isEmpty()
					//|| !mapaErrores.get(PARCELA_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(PORCENTAJE_IS_NAN).isEmpty() 
					|| !mapaErrores.get(CODIGO_POSTAL_IS_NAN).isEmpty()//ok
					|| !mapaErrores.get(MUNICIPIO_NOT_EXISTS).isEmpty()//ok
					//|| !mapaErrores.get(PORCENTAJE_SUPERIOR).isEmpty() 
					|| !mapaErrores.get(FINCA_IS_NULL).isEmpty() //ok
					|| !mapaErrores.get(GESTOR_COMERCIAL_IS_NULL).isEmpty()
					|| !mapaErrores.get(GESTOR_COMERCIAL_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUPERVISOR_COMERCIAL_IS_NULL).isEmpty()
					|| !mapaErrores.get(SUPERVISOR_COMERCIAL_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(GESTOR_FORMALIZACION_IS_NULL).isEmpty()
					|| !mapaErrores.get(GESTORIA_FORMALIZACION_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUPERVISOR_FORMALIZACION_IS_NULL).isEmpty()
					|| !mapaErrores.get(SUPERVISOR_FORMALIZACION_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(GESTOR_ADMISION_IS_NULL).isEmpty()
					|| !mapaErrores.get(GESTOR_ADMISION_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(GESTOR_ACTIVOS_IS_NULL).isEmpty()
					|| !mapaErrores.get(GESTOR_ACTIVOS_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(GESTORIA_FORMALIZACION_IS_NULL).isEmpty()
					|| !mapaErrores.get(GESTORIA_FORMALIZACION_NOT_EXISTS).isEmpty()					
					|| !mapaErrores.get(UNIDAD_INFERIOR_MUNICIPIO_NOT_EXISTS).isEmpty())//ok 
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
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
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
				if (!particularValidator.existeProveedorMediadorByNIF(exc.dameCelda(i, columnNumber)))
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
	
	private List<Integer> carteraNotExistsByRows(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i< numFilasHoja; i++){
			try {
				if (!particularValidator.existeCarteraByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
			} catch (IllegalArgumentException e){
				logger.error(e.getMessage());
				e.printStackTrace();
			} catch (IOException e){
				logger.error(e.getMessage());
				e.printStackTrace();
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
												if (!particularValidator.existeGestorFormalizacionByUsername(exc.dameCelda(i, columnNumber))){
													listaFilas.add(i);
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
												if (!particularValidator.existeGestoriaDeFormalizacionByUsername(exc.dameCelda(i, columnNumber))){
													listaFilas.add(i);
												}
												break;
				}
			}catch (IllegalArgumentException e){
				logger.error(e.getMessage());
				e.printStackTrace();
			}catch (IOException e){
				logger.error(e.getMessage());
				e.printStackTrace();
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
				listaFilas.add(i);
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

	private List<Integer> isCodigoMunicipioValido(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeMunicipioByCodigo(exc.dameCelda(i, columnNumber)))
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

	private List<Integer> isCodigoUnidadInferiorMunicipioValido(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!particularValidator.existeUnidadInferiorMunicipioByCodigo(exc.dameCelda(i, columnNumber)))
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

}
