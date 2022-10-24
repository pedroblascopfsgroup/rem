package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
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
public class MSVMasivaAltaBBVAValidator extends MSVExcelValidatorAbstract{
	
	// Constantes
	public static final String DESTINO_COMERCIAL_CODIGO_ALQUILER_VENTA = "02";
	public static final String DESTINO_COMERCIAL_CODIGO_SOLO_ALQUILER = "03";
	public static final String DESTINO_COMERCIAL_CODIGO_ALQUILER_OPCION_COMPRA = "04";

	// Textos con errores de validacion
	public static final String ACTIVE_EXISTS = "El activo existe.";
	public static final String SUBCARTERA_IS_NULL = "La subcartera del activo no puede estar vacío.";
	public static final String SUBCARTERA_NOT_EXISTS = "La subcartera no existe";
	public static final String SUBTIPO_TITULO_IS_NULL = "El subtipo de título del activo no puede estar vacío.";
	public static final String TIPO_ACTIVO_IS_NULL = "El tipo de activo no puede estar vacío.";
	public static final String TIPO_ACTIVO_NOT_EXISTS = "El tipo de activo no existe";
	public static final String SUBTIPO_ACTIVO_IS_NULL = "El subtipo de activo no puede estar vacío.";
	public static final String SUBTIPO_ACTIVO_NOT_EXISTS = "El subtipo de activo no existe";
	public static final String ESTADO_FISICO_ACTIVO_IS_NULL = "El estado físico del activo no puede estar vacío.";
	public static final String USO_DOMINANTE_ACTIVO_IS_NULL = "El uso dominante del activo no puede estar vacío.";
	public static final String DESC_ACTIVO_IS_NULL = "La descripción del activo no puede estar vacío.";
	public static final String TIPO_VIA_IS_NULL = "El tipo de vía no puede estar vacía.";
	public static final String NOMBRE_VIA_IS_NULL = "El nombre de la vía no puede estar vacía.";
	public static final String NUM_VIA_IS_NULL = "El número de la vía no puede estar vacía.";
	public static final String UNIDAD_INFERIOR_MUNICIPIO_IS_NULL = "La unidad inferior al municipio no puede estar vacía.";
	public static final String MUNICIPIO_IS_NULL = "El municipio no puede estar vacío";
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
	public static final String VPO_IS_NULL = "El VPO no puede estar vacío.";
	public static final String PRECIO_VENTA_WEB_IS_NULL = "El precio de venta web no puede estar vacío.";
	public static final String PRECIO_VENTA_WEB_IS_NAN = "El importe indicado en precio venta web no es un valor numérico correcto";
	public static final String VALOR_TASACION_IS_NAN = "El importe indicado en el valor de tasación no es un valor numérico correcto";
	public static final String PRECIO_VENTA_WEB_IS_ZERO = "El importe indicado en el precio mínimo ha de ser mayor a 0";
	public static final String VALOR_TASACION_IS_ZERO = "El importe indicado en el precio mínimo ha de ser mayor a 0";
	public static final String INTEGRADO_DIVISION_HORIZONTAL_NOT_BOOL = "El valor indicado en INTEGRADO DIVISION HORIZONTAL no es un valor Si/No correcto";
	public static final String GARAJE_ANEJO_NOT_BOOL = "El valor indicado en GARAJE ANEJO no es un valor Si/No correcto";
	public static final String TRASTERO_ANEJO_NOT_BOOL = "El valor indicado en TRASTERO ANEJO no es un valor Si/No correcto";
	public static final String FECHA_TASACION_DATE_FORMAT = "El valor indicado en FECHA TASACIÓN no cumple con el formato de fecha correcto (DD/MM/AAAA)";
	public static final String SOCIEDAD_ACREEDORA_NOT_EXISTS = "El NIF indicado para la sociedad acreedora no se encuentra dado de alta";
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
	public static final String GESTORIA_FORMALIZACION_IS_NULL = "La gestoría de formalización no puede estar vacía";
	public static final String GESTORIA_FORMALIZACION_NOT_EXISTS ="La gestoría de formalización no existe";
	public static final String TIPO_DE_COMERCIALIZACION_INCORRECTO = "El tipo de comercialización es incorrecto";
	public static final String TIPO_DE_TITULO_BBVA_IS_NULL = "El campo Tipo de Titulo (BBVA) no puede estar vacío";
	public static final String INDICADOR_ACTIVO_EPA_BBVA_IS_NULL ="El campo Indicador Activo EPA (BBVA) no puede estar vacío";
	public static final String NUM_ACTIVO_BBVA_IS_NAN = "El Número de Activo BBVA (BBVA) no tiene un formato numérico válido";
	//public static final String ID_APP_DIVARIAN_IS_NAN = "El ID App Divarian no tiene un formato numérico válido";
	public static final String ID_HAYA_ORIGEN_IS_NAN = "El ID HAYA Origen no tiene un formato numérico válido";
	public static final String EMPRESA_CM_IS_NAN = "El campo Empresa (Cuenta de mora) no tiene un formato numérico válido";
	public static final String OFICINA_CM_IS_NAN = "El campo Oficina (Cuenta de mora) no tiene un formato numérico válido";
	public static final String CONTRAPARTIDA_CM_IS_NAN = "El campo Contrapartida (Cuenta de mora) no tiene un formato numérico válido";
	public static final String FOLIO_CM_IS_NAN = "El campo Folio (Cuenta de mora) no tiene un formato numérico válido";
	public static final String CDPEN_CM_IS_NAN = "El campo CDPEN (Cuenta de mora) no tiene un formato numérico válido";
	public static final String FECHA_DE_CALIFICACION_DATE_FORMAT = "El campo Fecha de Calificación(VPO) no cumple con el formato de fecha correcto (DD/MM/AAAA)";
	public static final String FECHA_FIN_VIGENCIA = "El campo Fecha fin de vigencia (VPO) no cumple con el formato de fecha correcto (DD/MM/AAAA)";
	public static final String INDICADOR_ACTIVO_EPA_SI = "El campo Indicador Activo EPA esta marcado como si, debe introducir todos los campos de  (Cuenta de mora) ";
	public static final String TIPO_DE_TITULO_BBVA_NOT_EXISTS = "El campo Tipo de Titulo (BBVA) es incorrecto";
	public static final String SEGMENTO_BBVA = "El campo Segmento es incorrecto";
	public static final String TIPO_DE_TRANSMISION_BBVA ="EL campo Tipo de Transmision es incorrecto";
	public static final String TIPO_DE_ALTA_BBVA = "El campo tipo de Alta (BBVA) es incorrecto ";
	public static final String REGIMEN_DE_PROTECCION_VPO ="El campo Regimen de Protección es incorrecto";
	public static final String TIPO_DOCUMENTO_ACREDITADO = "El campo Tipo Documento Deudor Acreditado 1  es incorrecto";
	public static final String TIPO_DOCUMENTO_ACREDITADO2 = "El campo Tipo Documento Deudor Acreditado 2 es incorrecto";
	public static final String TIPO_DOCUMENTO_ACREDITADO3 = "El campo Tipo Documento Deudor Acreditado 3 es incorrecto";
	public static final String TIPO_DOCUMENTO_ACREDITADO4 = "El campo Tipo Documento Deudor Acreditado 4 es incorrecto";
	public static final String TIPO_DOCUMENTO_ACREDITADO5 = "El campo Tipo Documento Deudor Acreditado 5 es incorrecto";
	public static final String ACTIVO_ID_ORIGEN_HAYA_NO_EXISTE = "El Activo que esta introduciendo en ID Haya origen no existe";
	public static final String ACTIVO_ID_ORIGEN_SIN_GESTION = "El Activo que esta introduciendo en ID Haya origen esta vigente en REM";
	public static final String DEUDOR_ACREDITADO_CAMPOS_OB = "Revise los campos del deudor acreditado 1 si esta informado un campo de Tipo Documento, Nº Documento o Nombre/Razón social deben estar incluidos todos los campos.";
	public static final String DEUDOR_ACREDITADO_CAMPOS_OB2 = "Revise los campos del deudor acreditado 2 si esta informado un campo de Tipo Documento, Nº Documento o Nombre/Razón social deben estar incluidos todos los campos.";
	public static final String DEUDOR_ACREDITADO_CAMPOS_OB3 = "Revise los campos del deudor acreditado 3 si esta informado un campo de Tipo Documento, Nº Documento o Nombre/Razón social deben estar incluidos todos los campos.";
	public static final String DEUDOR_ACREDITADO_CAMPOS_OB4 = "Revise los campos del deudor acreditado 4 si esta informado un campo de Tipo Documento, Nº Documento o Nombre/Razón social deben estar incluidos todos los campos.";
	public static final String DEUDOR_ACREDITADO_CAMPOS_OB5 = "Revise los campos del deudor acreditado 5 si esta informado un campo de Tipo Documento, Nº Documento o Nombre/Razón social deben estar incluidos todos los campos.";
	public static final String NUM_ACTIVO_BBVA_REPETIDO = "El campo Número Activo BBVA tiene un valor que ya se ha introducido anteriormente";
	public static final String COD_COMERCIALIZACION_INCORRECTO="El campo Destino comercial es incorrecto.";
	public static final String NIF_CIF_PROPIETARIO_INCORRECTO ="El formato del NIF/CIF es incorrecto.";
	public static final String NIF_CIF_PROPIETARIO_IS_NULL ="El Campo NIF/CIF propietario no puede estar vacio .";
	public static final String PROVINCIA_IS_NULL="El Campo Provincia no puede estar vacio";
	public static final String TOMO_IS_NULL="El Campo Tomo no puede estar vacio";
	public static final String LIBRO_IS_NULL="El Campo Libro no puede estar vacio";
	public static final String FOLIO_IS_NULL="El Campo Folio no puede estar vacio";
	public static final String ID_HAYA_ORIGEN_WRONG_CARTERA ="El activo DEL ID_HAYA_ORIGEN debe de ser de la cartera BBVA o Divarian";
	public static final String ID_HAYA_ORIGEN_NO_VENDIDO_O_PERIMETRO ="El activo DEL ID_HAYA_ORIGEN debe estar vendido o fuera de perímetro. ";
	public static final String PROMOCION_AND_PROMOCION_EXISTENTE_VACIO ="Solo puede estar relleno el campo 'Promoción existente' o 'Promoción'. ";
	public static final String PROMOCION_AND_PROMOCION_EXISTENTE_RELLENO ="Al menos uno de los dos campos 'Promoción existente' o 'Promoción' deben estar rellenos . ";
	public static final String PROMOCION_EXISTENTE_NO_EXISTE ="La promoción existente no existe. ";
	public static final String CUENTA_MORA_VACIA ="Si 'Identificador de activo EPA' está a 'Si' los campos de cuenta mora deben estar rellenos. ";
	public static final String DATOS_REGISTRALES_YA_EXISTEN ="Ya existe otro activo con la misma información registral y esta línea no está autorizada. ";
	public static final String DATOS_REGISTRALES_REPETIDOS ="Se ha puesto una línea con la misma información registral y esta línea no está autorizada. ";
	public static final String SUBTIPO_TIPO_ACTIVO_NO_COINCIDE  ="El subtipo de activo no corresponde al tipo elegido. ";
	public static final String SUBTIPO_TIPO_TITULO_NO_COINCIDE ="La subtipología de título no pertenece a la tipología elegida. ";
	
	// Posicion fija de Columnas excel, para cualquier referencia por posicion
	public static final class COL_NUM {
		static final int FILA_CABECERA = 1;
		static final int DATOS_PRIMERA_FILA = 2;
		
        static final int NUM_ACTIVO_HAYA = 	0;
		static final int COD_PROMOCION_EXISTENTE = 	1;
		static final int COD_PROMOCION = 	2;
		static final int COD_SUBCARTERA = 	3;
		static final int COD_SUBTIPO_TITULO = 	4;
		static final int COD_TIPO_ACTIVO = 	5;
		static final int COD_SUBTIPO_ACTIVO = 	6;
		static final int COD_ESTADO_FISICO = 	7;
		static final int COD_USO_DOMINANTE = 	8;
		static final int DESC_ACTIVO = 	9;
		static final int COD_TIPO_VIA = 	10;
		static final int NOMBRE_VIA = 	11;
		static final int NUM_VIA = 	12;
		static final int ESCALERA = 	13;
		static final int PLANTA = 	14;
		static final int PUERTA = 	15;
		static final int COD_PROVINCIA = 	16;
		static final int COD_MUNICIPIO = 	17;
		static final int COD_UNIDAD_MUNICIPIO = 	18;
		static final int CODPOSTAL = 	19;
		static final int COD_DESTINO_COMER = 	20;
		static final int COD_TIPO_ALQUILER = 	21;
		static final int COD_TIPO_DE_COMERCIALIZACION = 	22;
		static final int POBL_REGISTRO = 	23;
		static final int NUM_REGISTRO = 	24;
		static final int TOMO = 	25;
		static final int LIBRO = 	26;
		static final int FOLIO = 	27;
		static final int FINCA = 	28;
		static final int AUTORIZACION = 	29;
		static final int IDUFIR_CRU = 	30;
		static final int SUPERFICIE_CONSTRUIDA_M2 = 	31;
		static final int SUPERFICIE_UTIL_M2 = 	32;
		static final int SUPERFICIE_REPERCUSION_EE_CC = 	33;
		static final int PARCELA =  34; // (INCLUIDA OCUPADA EDIFICACION)	
		static final int ES_INTEGRADO_DIV_HORIZONTAL = 	35;
		static final int NIF_PROPIETARIO = 	36;
		static final int GRADO_PROPIEDAD = 	37;
		static final int PERCENT_PROPIEDAD = 	38;
		static final int PROP_ANTERIOR = 	39;
		static final int REF_CATASTRAL = 	40;
		static final int VPO = 	41;
		static final int CALIFICACION_CEE = 	42;
		static final int CED_HABITABILIDAD = 	43;
		static final int NIF_MEDIADOR = 	44;
		static final int VIVIENDA_NUM_PLANTAS = 	45;
		static final int VIVIENDA_NUM_BANYOS = 	46;
		static final int VIVIENDA_NUM_ASEOS = 	47;
		static final int VIVIENDA_NUM_DORMITORIOS = 	48;
		static final int TRASTERO_ANEJO = 	49;
		static final int GARAJE_ANEJO = 	50;
		static final int ASCENSOR = 	51;
		static final int PRECIO_MINIMO = 	52;
		static final int PRECIO_VENTA_WEB = 	53;
		static final int VALOR_TASACION = 	54;
		static final int FECHA_TASACION = 	55;
		static final int GESTOR_COMERCIAL = 	56;
		static final int SUPER_GESTOR_COMERCIAL = 	57;
		static final int GESTOR_FORMALIZACION = 	58;
		static final int SUPER_GESTOR_FORMALIZACION = 	59;
		static final int GESTOR_ADMISION = 	60;
		static final int GESTOR_ACTIVOS = 	61;
		static final int GESTORIA_DE_FORMALIZACION= 	62;
		static final int FECHA_INSCRIPCION = 	63;
		static final int FECHA_OBT_TITULO = 	64;
		static final int FECHA_TOMA_POSESION = 	65;
		static final int FECHA_LANZAMIENTO = 	66;
		static final int OCUPADO = 	67;
		static final int TIENE_TITULO = 	68;
		static final int LLAVES = 	69;
		static final int CARGAS = 	70;
		static final int TIPO_ACTIVO = 	71;
		static final int FORMALIZACION = 	72;
		static final int NOMBRE_PROPIETARIO = 	73;
		static final int APELLIDO1_PROPIETARIO = 	74;
		static final int APELLIDO2_PROPIETARIO = 	75;
		static final int TIPO_PROPIETARIO = 	76;
		static final int NIF_CIF_PROPIETARIO = 	77;
		static final int TIPO_TITULO_BBVA = 	78;
		static final int SEGMENTO_BBVA = 	79;
		static final int ID_HAYA_ORIGEN_BBVA = 	80;
		static final int TIPO_TRANSMISION_BBVA = 	81;
		static final int TIPO_DE_ALTA_BBVA = 	82;
		static final int IUC_BBVA = 	83;
		static final int CEXPER_BBVA = 	84;
		static final int INDICADOR_ACTIVO_EPA_BBVA = 	85;
		static final int EMPRESA_CM = 	86;
		static final int OFICINA_CM = 	87;
		static final int CONTRAPARTIDA_CM = 	88;
		static final int FOLIO_CM = 	89;
		static final int CDPEN_CM = 	90;
		static final int REGIMEN_DE_PROTECCION_VPO = 	91;
		static final int DESCALIFICADO_VPO = 	92;
		static final int FECHA_CALIFICACION_VPO = 	93;
		static final int N_EXPEDIENTE_CALIFICACION_VPO = 	94;
		static final int F_FIN_VIGENCIA_VPO=	95;
		static final int PRECISA_COMUNICAR_VPO = 	96;
		static final int NECESARIO_INSCRIBIR_EN_REGISTRO_VPO = 	97;
		static final int TIPO_DOCUMENTO_DEUDOR1= 	98;
		static final int N_DOCUMENTO_DEUDOR1= 	99;
		static final int RAZON_SOCIAL_DEUDOR1 = 	100;
		static final int APELLIDO_DEUDOR1 = 	101;
		static final int APELLIDO2_DEUDOR1 = 	102;
		static final int TIPO_DOCUMENTO_DEUDOR2= 	103;
		static final int N_DOCUMENTO_DEUDOR2= 	104;
		static final int RAZON_SOCIAL_DEUDOR2 = 	105;
		static final int APELLIDO_DEUDOR2 = 	106;
		static final int APELLIDO2_DEUDOR2 = 	107;
		static final int TIPO_DOCUMENTO_DEUDOR3= 	108;
		static final int N_DOCUMENTO_DEUDOR3= 	109;
		static final int RAZON_SOCIAL_DEUDOR3 = 	110;
		static final int APELLIDO_DEUDOR3 = 	111;
		static final int APELLIDO2_DEUDOR3 = 	112;
		static final int TIPO_DOCUMENTO_DEUDOR4= 	113;
		static final int N_DOCUMENTO_DEUDOR4= 	114;
		static final int RAZON_SOCIAL_DEUDOR4 = 	115;
		static final int APELLIDO_DEUDOR4 = 	116;
		static final int APELLIDO2_DEUDOR4 = 	117;
		static final int TIPO_DOCUMENTO_DEUDOR5= 	118;
		static final int N_DOCUMENTO_DEUDOR5= 	119;
		static final int RAZON_SOCIAL_DEUDOR5 = 	120;
		static final int APELLIDO_DEUDOR5 = 	121;
		static final int APELLIDO2_DEUDOR5 = 	122;




	};

    private static final String[] listaValidosPositivos = { "S", "SI" };
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
			mapaErrores.put(SUBCARTERA_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_SUBCARTERA));
			mapaErrores.put(SUBCARTERA_NOT_EXISTS, subCarteraNotExistsByRows(exc,COL_NUM.COD_SUBCARTERA));
			mapaErrores.put(SUBTIPO_TITULO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_SUBTIPO_TITULO));
			mapaErrores.put(TIPO_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_TIPO_ACTIVO));
			mapaErrores.put(TIPO_ACTIVO_NOT_EXISTS, tipoActivoNotExistsByRows(exc,COL_NUM.COD_TIPO_ACTIVO));
			mapaErrores.put(SUBTIPO_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_SUBTIPO_ACTIVO));
			mapaErrores.put(SUBTIPO_ACTIVO_NOT_EXISTS, tipoSubActivoNotExistsByRows(exc, COL_NUM.COD_SUBTIPO_ACTIVO));
			mapaErrores.put(ESTADO_FISICO_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_ESTADO_FISICO));
			mapaErrores.put(USO_DOMINANTE_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_USO_DOMINANTE));
			mapaErrores.put(DESC_ACTIVO_IS_NULL, isColumnNullByRows(exc, COL_NUM.DESC_ACTIVO));
			mapaErrores.put(TIPO_VIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_TIPO_VIA));
			mapaErrores.put(NOMBRE_VIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.NOMBRE_VIA));
			mapaErrores.put(NUM_VIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.NUM_VIA));
			mapaErrores.put(UNIDAD_INFERIOR_MUNICIPIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_UNIDAD_MUNICIPIO));
			mapaErrores.put(MUNICIPIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_MUNICIPIO));
			mapaErrores.put(CODIGO_POSTAL_IS_NULL, isColumnNullByRows(exc, COL_NUM.CODPOSTAL));
			mapaErrores.put(DESTINO_COMERCIAL_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_DESTINO_COMER));
			mapaErrores.put(TIPO_DE_COMERCIALIZACION_INCORRECTO, isTipoDeComercializacionCorrecto(exc, COL_NUM.COD_TIPO_DE_COMERCIALIZACION));
			mapaErrores.put(POBL_REGISTRO_IS_NULL, isColumnNullByRows(exc, COL_NUM.POBL_REGISTRO));
			mapaErrores.put(NUM_REGISTRO_IS_NULL, isColumnNullByRows(exc, COL_NUM.NUM_REGISTRO));
			mapaErrores.put(FINCA_IS_NULL, isColumnNullByRows(exc, COL_NUM.FINCA));
			mapaErrores.put(NIF_PROPIETARIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.NIF_PROPIETARIO));
			mapaErrores.put(VPO_IS_NULL, isColumnNullByRows(exc, COL_NUM.VPO));
			mapaErrores.put(PRECIO_VENTA_WEB_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.PRECIO_VENTA_WEB));
			mapaErrores.put(VALOR_TASACION_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.VALOR_TASACION));
			mapaErrores.put(PRECIO_VENTA_WEB_IS_ZERO, isColumnZeroPrecioIncorrectoByRows(exc, COL_NUM.PRECIO_VENTA_WEB));
			mapaErrores.put(VALOR_TASACION_IS_ZERO, isColumnZeroPrecioIncorrectoByRows(exc, COL_NUM.VALOR_TASACION));
			mapaErrores.put(INTEGRADO_DIVISION_HORIZONTAL_NOT_BOOL, isColumnNotBoolByRows(exc, COL_NUM.ES_INTEGRADO_DIV_HORIZONTAL));
			mapaErrores.put(GARAJE_ANEJO_NOT_BOOL, isColumnNotBoolByRows(exc, COL_NUM.GARAJE_ANEJO));
			mapaErrores.put(TRASTERO_ANEJO_NOT_BOOL, isColumnNotBoolByRows(exc, COL_NUM.TRASTERO_ANEJO));
			mapaErrores.put(FECHA_TASACION_DATE_FORMAT, isColumnNotDateByRows(exc, COL_NUM.FECHA_TASACION));
			mapaErrores.put(NUM_ACTIVO_HAYA_IS_NAN, isColumnNANByRows(exc, COL_NUM.NUM_ACTIVO_HAYA));
			mapaErrores.put(TOMO_REGISTRO_IS_NAN, isColumnNANByRows(exc, COL_NUM.TOMO));
			mapaErrores.put(LIBRO_REGISTRO_IS_NAN, isColumnNANByRows(exc, COL_NUM.LIBRO));
			mapaErrores.put(FOLIO_REGISTRO_IS_NAN, isColumnNANByRows(exc, COL_NUM.FOLIO));
			mapaErrores.put(SUPERFICIE_CONSTRUIDA_REGISTRO_IS_NAN,isColumnFloatNANByRows(exc, COL_NUM.SUPERFICIE_CONSTRUIDA_M2));
			mapaErrores.put(SUPERFICIE_UTIL_REGISTRO_IS_NAN, isColumnFloatNANByRows(exc, COL_NUM.SUPERFICIE_UTIL_M2));
			mapaErrores.put(SUPERFICIE_REPERCUSION_EECC_REGISTRO_IS_NAN,isColumnFloatNANByRows(exc, COL_NUM.SUPERFICIE_REPERCUSION_EE_CC));
			mapaErrores.put(GESTORIA_FORMALIZACION_NOT_EXISTS, gestorNotExistsByRows(exc,COL_NUM.GESTORIA_DE_FORMALIZACION));
			mapaErrores.put(PARCELA_REGISTRO_IS_NAN, isColumnFloatNANByRows(exc, COL_NUM.PARCELA));
			mapaErrores.put(PORCENTAJE_IS_NAN, isColumnFloatNANByRows(exc, COL_NUM.PERCENT_PROPIEDAD));
			mapaErrores.put(PORCENTAJE_SUPERIOR, isColumnPorcentajeSuperiorByRows(exc, COL_NUM.PERCENT_PROPIEDAD));
			mapaErrores.put(CODIGO_POSTAL_IS_NAN, isColumnCodigoPostalValido(exc, COL_NUM.CODPOSTAL));
			mapaErrores.put(MUNICIPIO_NOT_EXISTS, isCodigoMunicipioValido(exc, COL_NUM.COD_MUNICIPIO));
			mapaErrores.put(UNIDAD_INFERIOR_MUNICIPIO_NOT_EXISTS, isCodigoUnidadInferiorMunicipioValido(exc, COL_NUM.COD_UNIDAD_MUNICIPIO));
			mapaErrores.put(TIPO_DE_TITULO_BBVA_IS_NULL, isColumnNullByRows(exc, COL_NUM.TIPO_TITULO_BBVA));
			mapaErrores.put(INDICADOR_ACTIVO_EPA_BBVA_IS_NULL, isColumnNullByRows(exc, COL_NUM.INDICADOR_ACTIVO_EPA_BBVA));
			mapaErrores.put(ID_HAYA_ORIGEN_IS_NAN, isColumnNANByRowsParaCampoSinObligacion(exc, COL_NUM.ID_HAYA_ORIGEN_BBVA));
			mapaErrores.put(EMPRESA_CM_IS_NAN, isColumnNANByRowsParaCampoSinObligacion(exc, COL_NUM.EMPRESA_CM));
			mapaErrores.put(OFICINA_CM_IS_NAN, isColumnNANByRowsParaCampoSinObligacion(exc, COL_NUM.OFICINA_CM));
			mapaErrores.put(CONTRAPARTIDA_CM_IS_NAN, isColumnNANByRowsParaCampoSinObligacion(exc, COL_NUM.CONTRAPARTIDA_CM));
			mapaErrores.put(FOLIO_CM_IS_NAN, isColumnNANByRowsParaCampoSinObligacion(exc, COL_NUM.FOLIO_CM));
			mapaErrores.put(CDPEN_CM_IS_NAN, isColumnNANByRowsParaCampoSinObligacion(exc, COL_NUM.CDPEN_CM));
			mapaErrores.put(FECHA_DE_CALIFICACION_DATE_FORMAT, isColumnNotDateByRows(exc, COL_NUM.FECHA_CALIFICACION_VPO));
			mapaErrores.put(FECHA_FIN_VIGENCIA, isColumnNotDateByRows(exc, COL_NUM.F_FIN_VIGENCIA_VPO));
			mapaErrores.put(INDICADOR_ACTIVO_EPA_SI, indicadorActivoEPARows(exc));
			mapaErrores.put(SEGMENTO_BBVA, tipoSegmentoBBVAByRows(exc, COL_NUM.SEGMENTO_BBVA));
			mapaErrores.put(TIPO_DE_TRANSMISION_BBVA, tipoDeTransmisionBBVAByRows(exc, COL_NUM.TIPO_TRANSMISION_BBVA));
			mapaErrores.put(REGIMEN_DE_PROTECCION_VPO, tipoDeRegimenDeProteccionByRows(exc, COL_NUM.REGIMEN_DE_PROTECCION_VPO));
			mapaErrores.put(TIPO_DOCUMENTO_ACREDITADO, tipoDeDocumentoDeudorAcreditado(exc, COL_NUM.TIPO_DOCUMENTO_DEUDOR1));
			mapaErrores.put(TIPO_DOCUMENTO_ACREDITADO2, tipoDeDocumentoDeudorAcreditado(exc, COL_NUM.TIPO_DOCUMENTO_DEUDOR2));
			mapaErrores.put(TIPO_DOCUMENTO_ACREDITADO3, tipoDeDocumentoDeudorAcreditado(exc, COL_NUM.TIPO_DOCUMENTO_DEUDOR3));
			mapaErrores.put(TIPO_DOCUMENTO_ACREDITADO4, tipoDeDocumentoDeudorAcreditado(exc, COL_NUM.TIPO_DOCUMENTO_DEUDOR4));
			mapaErrores.put(TIPO_DOCUMENTO_ACREDITADO5, tipoDeDocumentoDeudorAcreditado(exc, COL_NUM.TIPO_DOCUMENTO_DEUDOR5));
			mapaErrores.put(TIPO_DE_TITULO_BBVA_NOT_EXISTS, tipoTituloBBVAByRows(exc, COL_NUM.TIPO_TITULO_BBVA));
			mapaErrores.put(TIPO_DE_ALTA_BBVA, estipoDeAltaBBVA(exc, COL_NUM.TIPO_DE_ALTA_BBVA));
			mapaErrores.put(ACTIVO_ID_ORIGEN_HAYA_NO_EXISTE, existeActivoParaCMBBVA(exc, COL_NUM.ID_HAYA_ORIGEN_BBVA));
			mapaErrores.put(DEUDOR_ACREDITADO_CAMPOS_OB, bloquesDeudorAcreditadoRellenos(exc));
			mapaErrores.put(DEUDOR_ACREDITADO_CAMPOS_OB2, bloquesDeudorAcreditadoRellenos2(exc));
			mapaErrores.put(DEUDOR_ACREDITADO_CAMPOS_OB3, bloquesDeudorAcreditadoRellenos3(exc));
			mapaErrores.put(DEUDOR_ACREDITADO_CAMPOS_OB4, bloquesDeudorAcreditadoRellenos4(exc));
			mapaErrores.put(DEUDOR_ACREDITADO_CAMPOS_OB5, bloquesDeudorAcreditadoRellenos5(exc));
			mapaErrores.put(COD_COMERCIALIZACION_INCORRECTO, codigoComercializacionIncorrecto(exc, COL_NUM.COD_DESTINO_COMER));
			mapaErrores.put(NIF_CIF_PROPIETARIO_INCORRECTO, isCifNifValido(exc, COL_NUM.NIF_CIF_PROPIETARIO));
			mapaErrores.put(NIF_CIF_PROPIETARIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.NIF_CIF_PROPIETARIO));
			mapaErrores.put(PROVINCIA_IS_NULL, isColumnNullByRows(exc, COL_NUM.COD_PROVINCIA));
			mapaErrores.put(TOMO_IS_NULL, isColumnNullByRows(exc, COL_NUM.TOMO));
			mapaErrores.put(LIBRO_IS_NULL, isColumnNullByRows(exc, COL_NUM.LIBRO));
			mapaErrores.put(FOLIO_IS_NULL, isColumnNullByRows(exc, COL_NUM.FOLIO));
			mapaErrores.put(ID_HAYA_ORIGEN_WRONG_CARTERA, isBBVAoDivarian(exc, COL_NUM.ID_HAYA_ORIGEN_BBVA));
			mapaErrores.put(ID_HAYA_ORIGEN_WRONG_CARTERA, isNotVendidoFueraPerimetro(exc, COL_NUM.ID_HAYA_ORIGEN_BBVA));
			mapaErrores.put(PROMOCION_AND_PROMOCION_EXISTENTE_VACIO, promocionAndPromocionExistente(exc));
			mapaErrores.put(PROMOCION_AND_PROMOCION_EXISTENTE_RELLENO, promocionAndPromocionExistenteVacios(exc));
			mapaErrores.put(PROMOCION_EXISTENTE_NO_EXISTE, promocionExistenteNoExiste(exc));
			mapaErrores.put(CUENTA_MORA_VACIA, epaCuentaMora(exc, COL_NUM.INDICADOR_ACTIVO_EPA_BBVA));
			mapaErrores.put(DATOS_REGISTRALES_YA_EXISTEN, datosDelActivoYaExisten(exc));
			mapaErrores.put(DATOS_REGISTRALES_REPETIDOS, datosDelActivoRepetidos(exc));
			mapaErrores.put(SUBTIPO_TIPO_ACTIVO_NO_COINCIDE, subtipoTipoActivoNoCoincide(exc,COL_NUM.COD_TIPO_ACTIVO,COL_NUM.COD_SUBTIPO_ACTIVO));
			mapaErrores.put(SUBTIPO_TIPO_TITULO_NO_COINCIDE, subtipoTipoTituloNoCoincide(exc,COL_NUM.TIPO_TITULO_BBVA, COL_NUM.COD_SUBTIPO_TITULO));


			if (!mapaErrores.get(ACTIVE_EXISTS).isEmpty() || !mapaErrores.get(SUBCARTERA_IS_NULL).isEmpty() //ok
					|| !mapaErrores.get(SUBCARTERA_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUBTIPO_TITULO_IS_NULL).isEmpty()					
					|| !mapaErrores.get(TIPO_ACTIVO_IS_NULL).isEmpty() 
					|| !mapaErrores.get(TIPO_ACTIVO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(SUBTIPO_ACTIVO_IS_NULL).isEmpty() 
					|| !mapaErrores.get(SUBTIPO_ACTIVO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(ESTADO_FISICO_ACTIVO_IS_NULL).isEmpty()
					|| !mapaErrores.get(USO_DOMINANTE_ACTIVO_IS_NULL).isEmpty()
					|| !mapaErrores.get(DESC_ACTIVO_IS_NULL).isEmpty()
					|| !mapaErrores.get(DESC_ACTIVO_IS_NULL).isEmpty()
					|| !mapaErrores.get(SEGMENTO_BBVA).isEmpty()
					|| !mapaErrores.get(TIPO_VIA_IS_NULL).isEmpty()
					|| !mapaErrores.get(NUM_VIA_IS_NULL).isEmpty()
					//provincia
					|| !mapaErrores.get(UNIDAD_INFERIOR_MUNICIPIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(CODIGO_POSTAL_IS_NULL).isEmpty()
					
					|| !mapaErrores.get(DESTINO_COMERCIAL_IS_NULL).isEmpty()
					|| !mapaErrores.get(TIPO_DE_COMERCIALIZACION_INCORRECTO).isEmpty()
					|| !mapaErrores.get(POBL_REGISTRO_IS_NULL).isEmpty()
					|| !mapaErrores.get(COD_COMERCIALIZACION_INCORRECTO).isEmpty()

					|| !mapaErrores.get(DEUDOR_ACREDITADO_CAMPOS_OB).isEmpty()						
					|| !mapaErrores.get(DEUDOR_ACREDITADO_CAMPOS_OB2).isEmpty()
					|| !mapaErrores.get(DEUDOR_ACREDITADO_CAMPOS_OB3).isEmpty()
					|| !mapaErrores.get(DEUDOR_ACREDITADO_CAMPOS_OB4).isEmpty()
					|| !mapaErrores.get(DEUDOR_ACREDITADO_CAMPOS_OB5).isEmpty()
					
					|| !mapaErrores.get(NIF_PROPIETARIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(VPO_IS_NULL).isEmpty()
					|| !mapaErrores.get(GARAJE_ANEJO_NOT_BOOL).isEmpty()
					|| !mapaErrores.get(TRASTERO_ANEJO_NOT_BOOL).isEmpty()
					|| !mapaErrores.get(TOMO_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(LIBRO_REGISTRO_IS_NAN).isEmpty()
					|| !mapaErrores.get(FOLIO_REGISTRO_IS_NAN).isEmpty()
					//|| !mapaErrores.get(ID_APP_DIVARIAN_IS_NAN).isEmpty()
					|| !mapaErrores.get(ID_HAYA_ORIGEN_IS_NAN).isEmpty()
					|| !mapaErrores.get(EMPRESA_CM_IS_NAN).isEmpty()
					|| !mapaErrores.get(OFICINA_CM_IS_NAN).isEmpty()
					|| !mapaErrores.get(CONTRAPARTIDA_CM_IS_NAN).isEmpty()
					|| !mapaErrores.get(FOLIO_CM_IS_NAN).isEmpty()
					|| !mapaErrores.get(CDPEN_CM_IS_NAN).isEmpty()
					
					|| !mapaErrores.get(ACTIVO_ID_ORIGEN_HAYA_NO_EXISTE).isEmpty()					
					|| !mapaErrores.get(TIPO_DE_TRANSMISION_BBVA).isEmpty()
					|| !mapaErrores.get(REGIMEN_DE_PROTECCION_VPO).isEmpty()
					|| !mapaErrores.get(TIPO_DOCUMENTO_ACREDITADO).isEmpty()
					|| !mapaErrores.get(TIPO_DOCUMENTO_ACREDITADO2).isEmpty()
					|| !mapaErrores.get(TIPO_DOCUMENTO_ACREDITADO3).isEmpty()
					|| !mapaErrores.get(TIPO_DOCUMENTO_ACREDITADO4).isEmpty()
					|| !mapaErrores.get(TIPO_DOCUMENTO_ACREDITADO5).isEmpty()
				
					|| !mapaErrores.get(TIPO_DE_TITULO_BBVA_NOT_EXISTS).isEmpty()
					
					|| !mapaErrores.get(FECHA_DE_CALIFICACION_DATE_FORMAT).isEmpty()
					|| !mapaErrores.get(FECHA_FIN_VIGENCIA).isEmpty()
					|| !mapaErrores.get(INDICADOR_ACTIVO_EPA_SI).isEmpty()
					|| !mapaErrores.get(PROVINCIA_IS_NULL).isEmpty()
					|| !mapaErrores.get(TOMO_IS_NULL).isEmpty()
					|| !mapaErrores.get(LIBRO_IS_NULL).isEmpty()
					|| !mapaErrores.get(FOLIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(PORCENTAJE_IS_NAN).isEmpty() 
					|| !mapaErrores.get(CODIGO_POSTAL_IS_NAN).isEmpty()
					|| !mapaErrores.get(MUNICIPIO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(FINCA_IS_NULL).isEmpty()
					|| !mapaErrores.get(GESTORIA_FORMALIZACION_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(TIPO_DE_TITULO_BBVA_IS_NULL).isEmpty()
					|| !mapaErrores.get(INDICADOR_ACTIVO_EPA_BBVA_IS_NULL).isEmpty()
					|| !mapaErrores.get(TIPO_DE_ALTA_BBVA).isEmpty()
					|| !mapaErrores.get(UNIDAD_INFERIOR_MUNICIPIO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(NIF_CIF_PROPIETARIO_INCORRECTO).isEmpty()
					|| !mapaErrores.get(NIF_CIF_PROPIETARIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(MUNICIPIO_IS_NULL).isEmpty()
					|| !mapaErrores.get(PROMOCION_AND_PROMOCION_EXISTENTE_VACIO).isEmpty()
					|| !mapaErrores.get(PROMOCION_AND_PROMOCION_EXISTENTE_RELLENO).isEmpty()
					|| !mapaErrores.get(PROMOCION_EXISTENTE_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(CUENTA_MORA_VACIA).isEmpty()
					|| !mapaErrores.get(DATOS_REGISTRALES_YA_EXISTEN).isEmpty()
					|| !mapaErrores.get(DATOS_REGISTRALES_REPETIDOS).isEmpty()
					|| !mapaErrores.get(SUBTIPO_TIPO_ACTIVO_NO_COINCIDE).isEmpty()
					|| !mapaErrores.get(SUBTIPO_TIPO_TITULO_NO_COINCIDE).isEmpty()
					
					)		
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
				if (!particularValidator.existeProveedorMediadorByNIFConFVD(exc.dameCelda(i, columnNumber)))
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
	
	private List<Integer> subCarteraNotExistsByRows(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i< numFilasHoja; i++){
			try {
				if (!particularValidator.existeSubCarteraByCod(exc.dameCelda(i, columnNumber)))
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
	
	private List<Integer> tipoSubActivoNotExistsByRows(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if(!particularValidator.existeSubtipoActivoByCod(exc.dameCelda(i, columnNumber)))
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
				if ((exc.dameCelda(i, columnNumber) != null) && !exc.dameCelda(i, columnNumber).isEmpty()) {
					if (!particularValidator.existeMunicipioByCodigo(exc.dameCelda(i, columnNumber)))
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
	
	private List<Integer> isTipoDeComercializacionCorrecto(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
				
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (!Checks.esNulo(exc.dameCelda(i, columnNumber)) && !exc.dameCelda(i, columnNumber).equals("01") 
						&& !exc.dameCelda(i, columnNumber).equals("02")){
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
	
	private List<Integer> indicadorActivoEPARows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			
			try{
				if((exc.dameCelda(i, COL_NUM.INDICADOR_ACTIVO_EPA_BBVA).contains("s") || exc.dameCelda(i, COL_NUM.INDICADOR_ACTIVO_EPA_BBVA).contains("S")) ) {
					
			
					
					if(exc.dameCelda(i, COL_NUM.EMPRESA_CM)== null || exc.dameCelda(i, COL_NUM.EMPRESA_CM).isEmpty()
							|| exc.dameCelda(i, COL_NUM.OFICINA_CM)== null || exc.dameCelda(i, COL_NUM.OFICINA_CM).isEmpty()
							|| exc.dameCelda(i, COL_NUM.CONTRAPARTIDA_CM)== null || exc.dameCelda(i, COL_NUM.CONTRAPARTIDA_CM).isEmpty()
							|| exc.dameCelda(i, COL_NUM.FOLIO_CM)== null || exc.dameCelda(i, COL_NUM.FOLIO_CM).isEmpty()
							|| exc.dameCelda(i, COL_NUM.CDPEN_CM)== null || exc.dameCelda(i, COL_NUM.CDPEN_CM).isEmpty()
							) {
						listaFilas.add(i);
					}
					
				}
					
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
	

	private List<Integer> tipoTituloBBVAByRows(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if((exc.dameCelda(i, columnNumber) != null) && !exc.dameCelda(i, columnNumber).isEmpty()) {
				if(!particularValidator.esTipoDeTituloBBVA(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
				}
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
	
	private List<Integer> tipoSegmentoBBVAByRows(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if((exc.dameCelda(i, columnNumber) != null) && !exc.dameCelda(i, columnNumber).isEmpty()) {
				if(!particularValidator.esSegmentoValido(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
				}
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
	
	private List<Integer> tipoDeTransmisionBBVAByRows(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if((exc.dameCelda(i, columnNumber) != null) && !exc.dameCelda(i, columnNumber).isEmpty()) {
				if(!particularValidator.esTipoDeTransmisionBBVA(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
				}
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
	
	private List<Integer> tipoDeRegimenDeProteccionByRows(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if((exc.dameCelda(i, columnNumber) != null) && !exc.dameCelda(i, columnNumber).isEmpty()) {
				if(!particularValidator.esTipoRegimenProteccion(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
				}
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
	
	
	private List<Integer> tipoDeDocumentoDeudorAcreditado(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if((exc.dameCelda(i, columnNumber) != null) && !exc.dameCelda(i, columnNumber).isEmpty()) {
				if(!particularValidator.existeTipoDocumentoByCod(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
				}
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
	
	private List<Integer> estipoDeAltaBBVA(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if((exc.dameCelda(i, columnNumber) != null) && !exc.dameCelda(i, columnNumber).isEmpty()) {
				if(!particularValidator.esTipoAltaBBVAMenosAltaAutamatica(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
				}
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
	
	private List<Integer> existeActivoParaCMBBVA(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if((exc.dameCelda(i, columnNumber) != null) && !exc.dameCelda(i, columnNumber).isEmpty()) {
				
						if(!particularValidator.existeActivoParaCMBBVA(exc.dameCelda(i, columnNumber)))
							listaFilas.add(i);
					
				}
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
	


	private List<Integer> bloquesDeudorAcreditadoRellenos (MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
		
		try{
		if((exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR1)!=null && !exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR1).isEmpty()) ||
		 (exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR1)!=null && !exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR1).isEmpty() )|| 
		 (exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR1)!=null && !exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR1).isEmpty() )) {
				if(exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR1)== null || exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR1).isEmpty()
					|| exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR1)== null || exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR1).isEmpty()
					|| exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR1)== null || exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR1).isEmpty()
						
						){
						listaFilas.add(i);
					}
								
				
			}
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
	
	
	private List<Integer> bloquesDeudorAcreditadoRellenos2 (MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
		
		try{
		if((exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR2)!=null && !exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR2).isEmpty()) ||
		 (exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR2)!=null && !exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR2).isEmpty() )|| 
		 (exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR2)!=null && !exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR2).isEmpty() )) {
				if(exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR2)== null || exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR2).isEmpty()
					|| exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR2)== null || exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR2).isEmpty()
					|| exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR2)== null || exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR2).isEmpty()
						
						){
						listaFilas.add(i);
					}
								
				
			}
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
	
	private List<Integer> bloquesDeudorAcreditadoRellenos3 (MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
		
		try{
		if((exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR3)!=null && !exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR3).isEmpty()) ||
		 (exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR3)!=null && !exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR3).isEmpty() )|| 
		 (exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR3)!=null && !exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR3).isEmpty() )) {
				if(exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR3)== null || exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR3).isEmpty()
					|| exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR3)== null || exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR3).isEmpty()
					|| exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR3)== null || exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR3).isEmpty()
						
						){
						listaFilas.add(i);
					}
								
				
			}
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
	
	private List<Integer> bloquesDeudorAcreditadoRellenos4 (MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
		
		try{
		if((exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR4)!=null && !exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR4).isEmpty()) ||
		 (exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR4)!=null && !exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR4).isEmpty() )|| 
		 (exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR4)!=null && !exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR4).isEmpty() )) {
				if(exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR4)== null || exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR4).isEmpty()
					|| exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR4)== null || exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR4).isEmpty()
					|| exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR4)== null || exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR4).isEmpty()
						
						){
						listaFilas.add(i);
					}
								
				
			}
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
	
	private List<Integer> bloquesDeudorAcreditadoRellenos5 (MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
		
		try{
		if((exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR5)!=null && !exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR5).isEmpty()) ||
		 (exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR5)!=null && !exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR5).isEmpty() )|| 
		 (exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR5)!=null && !exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR5).isEmpty() )) {
				if(exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR5)== null || exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_DEUDOR5).isEmpty()
					|| exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR5)== null || exc.dameCelda(i, COL_NUM.N_DOCUMENTO_DEUDOR5).isEmpty()
					|| exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR5)== null || exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_DEUDOR5).isEmpty()
						
						){
						listaFilas.add(i);
					}
								
				
			}
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

	private List<Integer> isColumnNANByRowsParaCampoSinObligacion(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String valor = exc.dameCelda(i, columnNumber);
				if(valor!=null && !valor.isEmpty()) {
					if (Checks.esNulo(valor) || !StringUtils.isNumeric(valor)) {
						listaFilas.add(i);
					}
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
	
	
	private List<Integer> codigoComercializacionIncorrecto(MSVHojaExcel exc, int columnNumber){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++){
			try{
				if((exc.dameCelda(i, columnNumber) != null) && !exc.dameCelda(i, columnNumber).isEmpty()) {
				if(!particularValidator.codigoComercializacionIncorrecto(exc.dameCelda(i, columnNumber)))
					listaFilas.add(i);
				}
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
	
	private List<Integer> isCifNifValido(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if ((exc.dameCelda(i, columnNumber) != null) && !exc.dameCelda(i, columnNumber).isEmpty()) {
					if (!particularValidator.esNIFValido(exc.dameCelda(i, columnNumber)))
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
	
	private List<Integer> isBBVAoDivarian(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String valor = exc.dameCelda(i, columnNumber);
				if(!Checks.esNulo(valor)) {
					if (!particularValidator.esActivoBBVA(valor) && !particularValidator.esSubcarteraDivarian(valor)) {
						listaFilas.add(i);
					}
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
	
	private List<Integer> isNotVendidoFueraPerimetro(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String valor = exc.dameCelda(i, columnNumber);
				if(!Checks.esNulo(valor)) {
					if (!particularValidator.isActivoVendido(valor) && particularValidator.esActivoIncluidoPerimetro(valor)) {
						listaFilas.add(i);
					}
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
	
	private List<Integer> promocionAndPromocionExistente(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COD_PROMOCION_EXISTENTE)) && !Checks.esNulo(exc.dameCelda(i, COL_NUM.COD_PROMOCION))) {
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
	
	private List<Integer> promocionAndPromocionExistenteVacios(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if(Checks.esNulo(exc.dameCelda(i, COL_NUM.COD_PROMOCION_EXISTENTE)) && Checks.esNulo(exc.dameCelda(i, COL_NUM.COD_PROMOCION))) {
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
	
	private List<Integer> promocionExistenteNoExiste(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String valor = exc.dameCelda(i, COL_NUM.COD_PROMOCION_EXISTENTE);
				if(!Checks.esNulo(valor) && Boolean.FALSE.equals(particularValidator.existePromocionBBVA(valor))) {
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
	
	private List<Integer> epaCuentaMora (MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String valor = exc.dameCelda(i, columnNumber);
				if(!Checks.esNulo(valor) && Arrays.asList(listaValidosPositivos).contains(valor.toUpperCase())
					&& (Checks.esNulo(COL_NUM.EMPRESA_CM) || Checks.esNulo(COL_NUM.OFICINA_CM) || Checks.esNulo(COL_NUM.CONTRAPARTIDA_CM) 
						|| Checks.esNulo(COL_NUM.FOLIO_CM) || Checks.esNulo(COL_NUM.CDPEN_CM)
					)
				){
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
	

	private List<Integer> datosDelActivoYaExisten (MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if(!Arrays.asList(listaValidosPositivos).contains(exc.dameCelda(i, COL_NUM.AUTORIZACION).toUpperCase()) && Boolean.TRUE.equals(
					particularValidator.datosRegistralesRepetidos(exc.dameCelda(i, COL_NUM.REF_CATASTRAL),exc.dameCelda(i, COL_NUM.FINCA),exc.dameCelda(i, COL_NUM.FOLIO),exc.dameCelda(i, COL_NUM.LIBRO),
					exc.dameCelda(i, COL_NUM.TOMO),exc.dameCelda(i, COL_NUM.NUM_REGISTRO),exc.dameCelda(i, COL_NUM.POBL_REGISTRO)))){
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
	
	private List<Integer> datosDelActivoRepetidos (MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<String> listaDatos = new ArrayList<String>();
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String valor = transformarDatosRegistralesAString(exc, i);
				if(!listaDatos.contains(valor)) {
					listaDatos.add(valor);
				}else {
					if(!Arrays.asList(listaValidosPositivos).contains(exc.dameCelda(i, COL_NUM.AUTORIZACION).toUpperCase())) {
						listaFilas.add(i);
					}
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
	
	private String transformarDatosRegistralesAString(MSVHojaExcel exc, int i) throws IllegalArgumentException, IOException, ParseException {
		String todosLosDatos = "";
		if(Checks.esNulo(exc.dameCelda(i, COL_NUM.POBL_REGISTRO))) {
			todosLosDatos = todosLosDatos + "&" + exc.dameCelda(i, COL_NUM.POBL_REGISTRO);
		}
		if(Checks.esNulo(exc.dameCelda(i, COL_NUM.NUM_REGISTRO))) {
			todosLosDatos = todosLosDatos + "&" + exc.dameCelda(i, COL_NUM.NUM_REGISTRO);
		}
		if(Checks.esNulo(exc.dameCelda(i, COL_NUM.TOMO))) {
			todosLosDatos = todosLosDatos + "&" + exc.dameCelda(i, COL_NUM.TOMO);
		}
		if(Checks.esNulo(exc.dameCelda(i, COL_NUM.LIBRO))) {
			todosLosDatos = todosLosDatos + "&" + exc.dameCelda(i, COL_NUM.LIBRO);
		}
		if(Checks.esNulo(exc.dameCelda(i, COL_NUM.FOLIO))) {
			todosLosDatos = todosLosDatos + "&" + exc.dameCelda(i, COL_NUM.FOLIO);
		}
		if(Checks.esNulo(exc.dameCelda(i, COL_NUM.FINCA))) {
			todosLosDatos = todosLosDatos + "&" + exc.dameCelda(i, COL_NUM.FINCA);
		}
		if(Checks.esNulo(exc.dameCelda(i, COL_NUM.REF_CATASTRAL))) {
			todosLosDatos = todosLosDatos + "&" + exc.dameCelda(i, COL_NUM.REF_CATASTRAL);
		}
		
		
		return todosLosDatos;	
	}

	private List<Integer> subtipoTipoActivoNoCoincide (MSVHojaExcel exc, int colTipo, int colSubtipo) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String tipo = exc.dameCelda(i, colTipo);
				String subtipo = exc.dameCelda(i, colSubtipo);
				if(Boolean.FALSE.equals(particularValidator.subtipoPerteneceTipoActivo(subtipo, tipo))) {
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
	
	private List<Integer> subtipoTipoTituloNoCoincide (MSVHojaExcel exc, int colTipo, int colSubtipo) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String tipo = exc.dameCelda(i, colTipo);
				String subtipo = exc.dameCelda(i, colSubtipo);
				if(Boolean.FALSE.equals(particularValidator.subtipoPerteneceTipoTitulo(subtipo, tipo))) {
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

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
}