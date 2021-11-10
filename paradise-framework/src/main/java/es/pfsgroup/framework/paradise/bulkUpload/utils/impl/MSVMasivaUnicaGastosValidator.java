package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
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
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelRepoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationFactory;
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
public class MSVMasivaUnicaGastosValidator extends MSVExcelValidatorAbstract {
		
	public static final String ELEMENTOS_PERTENECER_MISMA_CARTERA = "Los elementos del gasto deben pertenecer al mismo propietario que el gasto.";
	public static final String TIPO_GASTO_NO_EXISTE = "El código introducido en el campo 'Tipo de Gasto' no existe";
	public static final String PERIODICIDAD_NO_EXISTE = "El código introducido en el campo 'Periodicidad del gasto' no existe";
	public static final String DESTINATARIO_NO_EXISTE = "El código introducido en el campo 'Destinatario' no existe";
	public static final String TIPO_OPERACION_NO_EXISTE = "El código introducido en el campo 'Tipo de operación' no existe";
	public static final String SUBTIPO_GASTO_NO_EXISTE = "El código introducido en el campo 'Subtipo de gasto' no existe";
	public static final String TIPO_RECARGO_NO_EXISTE = "El código introducido en el campo 'Tipo de recargo' no existe";
	public static final String TIPO_IMPUESTO_NO_EXISTE = "El código introducido en el campo 'Tipo de Impuesto' no existe";
	public static final String TIPO_ELEMENTO_NO_EXISTE = "El código introducido en el campo 'Tipo elemento' no existe";
	
	
	//Mensajes de errores de los campos de fechas
	public static final String F_EMISION_DEVENGO_ERROR = "El formato de la fecha del campo 'Fecha de emisión Devengo' debe de ser: dd/mm/yyyy.";
	public static final String F_CONEXION_ERROR = "El formato de la fecha del campo 'Fecha de conexión' debe de ser: dd/mm/yyyy.";
	
	//Mensajes de errores de los campos booleanos
	
	public static final String C_GASTO_REFACTURABLE_ERROR = "El campo 'Check Gasto Refacturable' solo puede estar rellenado con 'S' para sí y 'N' para no.";
	public static final String REPERCUTIBLE_INQUILINO_ERROR = "El campo 'Repercutible a Inquilino' solo puede estar rellenado con 'S' para sí y 'N' para no.";
	public static final String C_PAGO_CONEXION_ERROR = "El campo 'Check pago a conexión' solo puede estar rellenado con 'S' para sí y 'N' para no.";
	public static final String PLAN_VISITAS_ERROR = "El campo 'Plan visitas' solo puede estar rellenado con 'S' para sí y 'N' para no.";
	public static final String ACTIVABLE_ERROR = "El campo 'Activable' solo puede estar rellenado con 'S' para sí y 'N' para no.";
	public static final String OPERACION_EXENTA_ERROR = "El campo 'Operación Exenta' solo puede estar rellenado con 'S' para sí y 'N' para no.";
	public static final String RENUNCIA_EXENCION_ERROR = "El campo 'Renuncia a exención' solo puede estar rellenado con 'S' para sí y 'N' para no.";
	public static final String OPTA_CRITERIO_CAJA_IVA_ERROR = "El campo 'Opta por criterio de caja en IVA' solo puede estar rellenado con 'S' para sí y 'N' para no.";
	
	public static final String SUBTIPO_GASTO_CORRESPONDE_TIPO_GASTO= "El subtipo del gasto no corresponde con el tipo de gasto.";
	public static final String SI_TIPO_ELEMENTO_ES_ACT_ID_ELEMENTO_EXISTE= "El tipo de elemento es 'Activo' pero el id del elemento no existe.";
	public static final String IRPF_PORCENTAJE_VACIO= "Si el campo 'IRPF Base' está informado, 'IRPF Porcentaje' no puede estar vacío.";
	public static final String LBK_CLAVE_SUBCLAVE_VACIO= "Si el gasto es de Unicaja y el campo 'Retención garantía Base' está informado, los campos 'IRPF Clave' y 'IRPF Subclave' no pueden estar vacíos.";
	public static final String PARTICIPACION_AL_CIEN_PORCIENTO= "Dentro de cada grupo la participación de cada elemento debe sumar un total de 100%.";
	
	public static final String C_PAGO_CONEXION_SOLO_BANKIA= "El campo 'Check pago a conexión' solo se puede rellenar si el gasto es de CaixaBank";
	public static final String NUM_CONEXION_SOLO_BANKIA= "El campo 'Número de conexión' solo se puede rellenar si el gasto es de CaixaBank";
	public static final String F_CONEXION_SOLO_BANKIA= "El campo 'Fecha de conexión' solo se puede rellenar si el gasto es de CaixaBank";
	public static final String OFICINA_SOLO_BANKIA= "El campo 'Oficina' solo se puede rellenar si el gasto es de CaixaBank";
	public static final String IRPF_CLAVE_SOLO_LBK= "El campo 'IRPF Clave' solo se puede rellenar si el gasto es de Unicaja";
	public static final String IRPF_SUBCLAVE_SOLO_LBK= "El campo 'IRPF Subclave' solo se puede rellenar si el gasto es de Unicaja";
	public static final String PLAN_VISITAS_SOLO_LBK= "El campo 'Plan visitas' solo se puede rellenar si el gasto es de Unicaja";
	public static final String ACTIVABLE_SOLO_BBVA_LBK= "El campo 'Activable' solo se puede rellenar si el gasto es de BBVA o Unicaja";
	private static final String YA_EXISTE_UN_SUBTIPO_TIPO_IMPOSITIVO_TIPO_IMPUESTO = "Ya existe un gasto y una línea con el mismo subtipo de gasto, tipo impositivo, tipo impuesto y elemento";
	private static final String ELEMENTO_SIN_PARTICIPACION = "El elemento no tiene participación";
	private static final String PARTICIPACION_SIN_ELEMENTO = "La participación no tiene ningún elemento";
	private static final String ELEMENTO_SIN_TIPO = "El elemento no tiene tipo";
	private static final String TIPO_SIN_ELEMENTO = "El tipo no tiene ningún elemento";
	private static final String PROPIETARIO_NO_EXISTE= "El propietario no existe";
	private static final String EMISOR_NO_EXISTE= "El emisor no existe";
	private static final String PROVEEDOR_REM_NO_EXISTE= "El código proveedor REM no existe";
	private static final String IRPF_BASE_VACIA = "Si el campo 'IRPF Porcentaje' está informado, 'IRPF Base' no puede estar vacío.";
	private static final String LINEA_DIFERENTE_STG_TIM_TIIM = "A esta línea ya se le ha asignado anteriormente un subtipo de gasto, tipo impositivo y tipo de impuesto, debe coincidir.";
	private static final String GASTO_REPETIDO_BBDD = "El gasto ya existe";
	private static final String GASTO_REPETIDO_CARGA = "Gasto repetido";
	private static final String LINEA_SIN_ACTIVOS_CON_ACTIVOS = "Esta línea ha sido marcada sin activos y se le han añadido activos.";
	private static final String LINEA_SIN_ACTIVOS_REPETIDA = "Esta línea ya ha sido marcada como sin activos.";
	private static final String LINEA_SIN_ACTIVOS_CON_ID_PARTICIPACION = "Una línea marcada sin activos no puede tener ni Id elemento ni participación de elemento.";
	private static final String TIPO_IMPOS_IMPUEST_RELLENO = "Cuando el tipo impositivo está relleno el tipo impuesto debe estarlo, y viceversa.";
	private static final String SIN_ACTIVOS_NO_VALIDO_CARTERA = "Cuando el propietario es de la cartera: Sareb, Tango o Giants no se puede marcar como línea sin activos.";

	private static final String COLUMNA_TEXTO_RET_GARANTIA_PORCENTAJE="Se ha cambiado la celda de Retención garantía porcentje a tipo texto";
	private static final String COLUMNA_TEXTO_IRPF_BASE="Se ha cambiado la celda de IRPF Base a tipo texto";
	private static final String COLUMNA_TEXTO_IRPF_PORCENTAJE="Se ha cambiado la celda de IRPF Porcentaje a tipo texto";
	private static final String COLUMNA_TEXTO_PPAL_SUJETO_A_IMPUESTO="Se ha cambiado la celda de Principal sujeto a impuesto a tipo texto";
	private static final String COLUMNA_TEXTO_PPAL_NO_SUJETO_A_IMPUESTO="Se ha cambiado la celda de Principal no sujeto a impuesto a tipo texto";
	private static final String COLUMNA_TEXTO_IMPORTE_RECARGO="Se ha cambiado la celda de Importe recargo a tipo texto";
	private static final String COLUMNA_TEXTO_INTERES_DEMORA="Se ha cambiado la celda de Interes de demora a tipo texto";
	private static final String COLUMNA_TEXTO_COSTES="Se ha cambiado la celda de Costes a tipo texto";
	private static final String COLUMNA_TEXTO_OTROS_INCREMENTOS="Se ha cambiado la celda de Otros Incrementos a tipo texto";
	private static final String COLUMNA_TEXTO_PROVISIONES_Y_SUPLIDOS="Se ha cambiado la celda de Provisiones y suplidos a tipo texto";
	private static final String COLUMNA_TEXTO_TIPO_IMPOSITIVO="Se ha cambiado la celda de Tipo impositivo a tipo texto";
	private static final String COLUMNA_TEXTO_PARTI_LINEA_DETALLE="Se ha cambiado la celda de Participación en la linea de detalle a tipo texto";
	
	private static final String TIPO_RETENCION_NO_EXISTE="El tipo de retención no existe.";
	private static final String TIPO_RETENCION_VACIO="Si no esta relleno el campo Retención garantía porcentaje, el campo de tipo retención debe estar vacío.";
	private static final String TIPO_RETENCION_RELLENO="Si el campo Retención garantía porcentaje está relleno el campo de tipo debe estar relleno.";

	
	public static final Integer COL_ID_AGRUPADOR_GASTO = 0;
	public static final Integer COL_TIPO_GASTO = 1;
	public static final Integer COL_PEDIODICIDAD_GASTO = 2;
	public static final Integer COL_CONCEPTO_GASTO = 3;
	public static final Integer COL_IDENTIFICADOR_UNICO = 4;
	public static final Integer COL_NUM_FACTURA_LIQUIDACION = 5;
	public static final Integer COL_COD_PROVEEDOR_REM = 6;
	public static final Integer COL_NIF_EMISOR = 7;
	public static final Integer COL_DESTINATARIO = 8;
	public static final Integer COL_NIF_PROPIETARIO = 9;
	public static final Integer COL_F_EMISION_DEVENGO = 10;
	public static final Integer COL_TIPO_OPERACION = 11;
	public static final Integer COL_C_GASTO_REFACTURABLE = 12;
	public static final Integer COL_REPERCUTIBLE_INQUILINO = 13;
	public static final Integer COL_C_PAGO_CONEXION = 14;
	public static final Integer COL_NUM_CONEXION = 15;
	public static final Integer COL_F_CONEXION = 16;
	public static final Integer COL_OFICINA = 17;
	public static final Integer COL_RETENCION_GARANTIA_PORCENTAJE = 18;
	public static final Integer COL_TIPO_RETENCION = 19;
	public static final Integer COL_IRPF_BASE = 20;
	public static final Integer COL_IRPF_PORCENTAJE = 21;
	public static final Integer COL_IRPF_CLAVE = 22;
	public static final Integer COL_IRPF_SUBCLAVE = 23;
	public static final Integer COL_PLAN_VISITAS = 24;
	public static final Integer COL_ACTIVABLE = 25;
	public static final Integer COL_EJERCICIO = 26;
	public static final Integer COL_TIPO_COMISIONADO = 27;
	public static final Integer COL_COD_AGRUPACION_LINEA_DETALLE = 28;
	public static final Integer COL_SUBTIPO_GASTO = 29;
	public static final Integer COL_PRINCIPAL_SUJETO_IMPUESTOS = 30;
	public static final Integer COL_PRINCIPAL_NO_SUJETO_IMPUESTOS = 31;
	public static final Integer COL_TIPO_RECARGO = 32;
	public static final Integer COL_IMPORTE_RECARGO = 33;
	public static final Integer COL_INTERES_DEMORA = 34;
	public static final Integer COL_COSTES = 35;
	public static final Integer COL_OTROS_INCREMENTOS = 36;
	public static final Integer COL_PROVISIONES_Y_SUPLIDOS = 37;
	public static final Integer COL_TIPO_IMPUESTO = 38;
	public static final Integer COL_OPERACION_EXENTA = 39;
	public static final Integer COL_RENUNCIA_EXENCION = 40;
	public static final Integer COL_TIPO_IMPOSITIVO = 41;
	public static final Integer COL_OPTA_CRITERIO_CAJA_IVA = 42;
	public static final Integer COL_ID_ELEMENTO = 43;
	public static final Integer COL_TIPO_ELEMENTO = 44;
	public static final Integer COL_PARTICIPACION_LINEA_DETALLE = 45;

	
	

	
	private static final String[] listaValidos = { "S", "N", "SI", "NO" };
	private static final String[] listaValidosPositivos = { "S", "SI" };
	private static final String[] listaValidosNegativos = { "N", "NO" };
	private static final String TIPO_ELEMENTO_ACTIVO = "ACT";
	private static final String TIPO_ELEMENTO_ACTIVOGEN = "GEN";
	private static final String TIPO_ELEMENTO_AGRUPACION = "AGR";
	private static final String TIPO_ELEMENTO_SIN_ELEMENTO = "SIN";
	private static final String COD_BANKIA = "03";
	private static final String COD_LBK = "08";
	private static final String COD_BBVA = "16";
	
	private static final String COD_SAREB = "02";
	private static final String COD_TANGO = "10";
	private static final String COD_GIANTS = "12";
	
	
	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;
	
	@Resource
    MessageService messageServices;
	
	private Integer numFilasHoja;
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion()));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(TIPO_GASTO_NO_EXISTE, existeTipoGasto(exc, COL_TIPO_GASTO));
			mapaErrores.put(PERIODICIDAD_NO_EXISTE, existePeriodicidadGasto(exc, COL_PEDIODICIDAD_GASTO));
			mapaErrores.put(DESTINATARIO_NO_EXISTE, existeDestinatario(exc, COL_DESTINATARIO));
			mapaErrores.put(TIPO_OPERACION_NO_EXISTE, existeTipoOperacion(exc, COL_TIPO_OPERACION));
			mapaErrores.put(SUBTIPO_GASTO_NO_EXISTE, existeSubtipoGasto(exc, COL_SUBTIPO_GASTO));
			mapaErrores.put(TIPO_RECARGO_NO_EXISTE, existeTipoRecargo(exc, COL_TIPO_RECARGO));
			mapaErrores.put(TIPO_IMPUESTO_NO_EXISTE, existeTipoImpuesto(exc, COL_TIPO_IMPUESTO));
			mapaErrores.put(TIPO_ELEMENTO_NO_EXISTE, existeTipoElemento(exc, COL_TIPO_ELEMENTO));
			mapaErrores.put(C_GASTO_REFACTURABLE_ERROR, isBooleanValidator(exc, COL_C_GASTO_REFACTURABLE));
			mapaErrores.put(REPERCUTIBLE_INQUILINO_ERROR, isBooleanValidator(exc, COL_REPERCUTIBLE_INQUILINO));
			mapaErrores.put(C_PAGO_CONEXION_ERROR, isBooleanValidator(exc, COL_C_PAGO_CONEXION));
			mapaErrores.put(PLAN_VISITAS_ERROR, isBooleanValidator(exc, COL_PLAN_VISITAS));
			mapaErrores.put(ACTIVABLE_ERROR, isBooleanValidator(exc, COL_ACTIVABLE));
			mapaErrores.put(OPERACION_EXENTA_ERROR, isBooleanValidator(exc, COL_OPERACION_EXENTA));
			mapaErrores.put(RENUNCIA_EXENCION_ERROR, isBooleanValidator(exc, COL_RENUNCIA_EXENCION));
			mapaErrores.put(OPTA_CRITERIO_CAJA_IVA_ERROR, isBooleanValidator(exc, COL_OPTA_CRITERIO_CAJA_IVA));
			mapaErrores.put(F_EMISION_DEVENGO_ERROR, isFechaValidator(exc, COL_F_EMISION_DEVENGO));
			mapaErrores.put(F_CONEXION_ERROR, isFechaValidator(exc, COL_F_CONEXION));
			mapaErrores.put(SUBTIPO_GASTO_CORRESPONDE_TIPO_GASTO, subtipoPerteneceATipoGasto(exc));
			mapaErrores.put(SI_TIPO_ELEMENTO_ES_ACT_ID_ELEMENTO_EXISTE, siElementoActExiste(exc));
			mapaErrores.put(IRPF_PORCENTAJE_VACIO, esIrpfPorcentajeVacio(exc));
			mapaErrores.put(LBK_CLAVE_SUBCLAVE_VACIO, esLbkClaveSubclaveVacio(exc));
			mapaErrores.put(PARTICIPACION_AL_CIEN_PORCIENTO, participacionSumaCien(exc));
			mapaErrores.put(ELEMENTOS_PERTENECER_MISMA_CARTERA, elementoMismaCartera(exc));
			mapaErrores.put(C_PAGO_CONEXION_SOLO_BANKIA, campoSoloParaCarteraByCode(exc, COL_C_PAGO_CONEXION, COD_BANKIA));
			mapaErrores.put(NUM_CONEXION_SOLO_BANKIA, campoSoloParaCarteraByCode(exc, COL_NUM_CONEXION, COD_BANKIA));
			mapaErrores.put(F_CONEXION_SOLO_BANKIA, campoSoloParaCarteraByCode(exc, COL_F_CONEXION, COD_BANKIA));
			mapaErrores.put(OFICINA_SOLO_BANKIA, campoSoloParaCarteraByCode(exc, COL_OFICINA, COD_BANKIA));
			mapaErrores.put(IRPF_CLAVE_SOLO_LBK, campoSoloParaCarteraByCode(exc, COL_IRPF_CLAVE, COD_LBK));
			mapaErrores.put(IRPF_SUBCLAVE_SOLO_LBK, campoSoloParaCarteraByCode(exc, COL_IRPF_SUBCLAVE, COD_LBK));
			mapaErrores.put(PLAN_VISITAS_SOLO_LBK, campoSoloParaCarteraByCode(exc, COL_PLAN_VISITAS, COD_LBK));
			mapaErrores.put(ACTIVABLE_SOLO_BBVA_LBK, campoSoloParaMultiplesCarteras(exc, COL_ACTIVABLE));
			mapaErrores.put(YA_EXISTE_UN_SUBTIPO_TIPO_IMPOSITIVO_TIPO_IMPUESTO, existeUnsubtipoGastoIgual(exc));
			mapaErrores.put(ELEMENTO_SIN_PARTICIPACION, participacionSinActivos(exc));
			mapaErrores.put(PARTICIPACION_SIN_ELEMENTO, activoSinParticipacion(exc));
			mapaErrores.put(ELEMENTO_SIN_TIPO, elementosSinTipo(exc));
			mapaErrores.put(TIPO_SIN_ELEMENTO, tipoSinElementos(exc));
			mapaErrores.put(PROPIETARIO_NO_EXISTE, existePropietario(exc));
			mapaErrores.put(EMISOR_NO_EXISTE, existeEmisor(exc));
			mapaErrores.put(PROVEEDOR_REM_NO_EXISTE, existeCodProveedorRem(exc));
			mapaErrores.put(IRPF_BASE_VACIA, esIrpfBaseVacio(exc));
			mapaErrores.put(LINEA_DIFERENTE_STG_TIM_TIIM, mismaLineaDiferenteTipo(exc));
			mapaErrores.put(GASTO_REPETIDO_BBDD, gastoRepetidoBBDD(exc));
			mapaErrores.put(GASTO_REPETIDO_CARGA, gastoRepetidoEnCarga(exc));
			mapaErrores.put(LINEA_SIN_ACTIVOS_CON_ACTIVOS, masUnaLineaSinActivos(exc));
			mapaErrores.put(LINEA_SIN_ACTIVOS_REPETIDA, lineaYaMarcadaSinActivos(exc));
			mapaErrores.put(LINEA_SIN_ACTIVOS_CON_ID_PARTICIPACION, lineaSinActivosElementoyPorcentajeVacio(exc));
			mapaErrores.put(TIPO_IMPOS_IMPUEST_RELLENO, tipoImpositivoEimpuestoRellenos(exc));
			mapaErrores.put(SIN_ACTIVOS_NO_VALIDO_CARTERA, sinActivosNoValidoCartera(exc));
			mapaErrores.put(COLUMNA_TEXTO_RET_GARANTIA_PORCENTAJE,comprobarDouble(exc,COL_RETENCION_GARANTIA_PORCENTAJE));
			mapaErrores.put(COLUMNA_TEXTO_IRPF_BASE,comprobarDouble(exc,COL_IRPF_BASE));
			mapaErrores.put(COLUMNA_TEXTO_IRPF_PORCENTAJE,comprobarDouble(exc,COL_IRPF_PORCENTAJE));
			mapaErrores.put(COLUMNA_TEXTO_PPAL_SUJETO_A_IMPUESTO,comprobarDouble(exc,COL_PRINCIPAL_SUJETO_IMPUESTOS));
			mapaErrores.put(COLUMNA_TEXTO_PPAL_NO_SUJETO_A_IMPUESTO,comprobarDouble(exc,COL_PRINCIPAL_NO_SUJETO_IMPUESTOS));
			mapaErrores.put(COLUMNA_TEXTO_IMPORTE_RECARGO,comprobarDouble(exc,COL_IMPORTE_RECARGO));
			mapaErrores.put(COLUMNA_TEXTO_INTERES_DEMORA,comprobarDouble(exc,COL_INTERES_DEMORA));
			mapaErrores.put(COLUMNA_TEXTO_COSTES,comprobarDouble(exc,COL_COSTES));
			mapaErrores.put(COLUMNA_TEXTO_OTROS_INCREMENTOS,comprobarDouble(exc,COL_OTROS_INCREMENTOS));
			mapaErrores.put(COLUMNA_TEXTO_PROVISIONES_Y_SUPLIDOS,comprobarDouble(exc,COL_PROVISIONES_Y_SUPLIDOS));
			mapaErrores.put(COLUMNA_TEXTO_TIPO_IMPOSITIVO,comprobarDouble(exc,COL_TIPO_IMPOSITIVO));
			mapaErrores.put(COLUMNA_TEXTO_PARTI_LINEA_DETALLE,comprobarDouble(exc,COL_PARTICIPACION_LINEA_DETALLE));
			mapaErrores.put(TIPO_RETENCION_NO_EXISTE,tipoRetencionNoExiste(exc));
			mapaErrores.put(TIPO_RETENCION_VACIO,tipoRetencionVacio(exc));
			mapaErrores.put(TIPO_RETENCION_RELLENO,tipoRetencionRelleno(exc));



			if (!mapaErrores.get(TIPO_GASTO_NO_EXISTE).isEmpty() 
					|| !mapaErrores.get(PERIODICIDAD_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(DESTINATARIO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(TIPO_OPERACION_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(SUBTIPO_GASTO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(TIPO_RECARGO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(TIPO_IMPUESTO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(TIPO_ELEMENTO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(C_GASTO_REFACTURABLE_ERROR).isEmpty()
					|| !mapaErrores.get(REPERCUTIBLE_INQUILINO_ERROR).isEmpty()
					|| !mapaErrores.get(C_PAGO_CONEXION_ERROR).isEmpty()
					|| !mapaErrores.get(PLAN_VISITAS_ERROR).isEmpty()
					|| !mapaErrores.get(ACTIVABLE_ERROR).isEmpty()
					|| !mapaErrores.get(OPERACION_EXENTA_ERROR).isEmpty()
					|| !mapaErrores.get(RENUNCIA_EXENCION_ERROR).isEmpty()
					|| !mapaErrores.get(OPTA_CRITERIO_CAJA_IVA_ERROR).isEmpty()
					|| !mapaErrores.get(F_EMISION_DEVENGO_ERROR).isEmpty()
					|| !mapaErrores.get(F_CONEXION_ERROR).isEmpty()
					|| !mapaErrores.get(SUBTIPO_GASTO_CORRESPONDE_TIPO_GASTO).isEmpty()
					|| !mapaErrores.get(SI_TIPO_ELEMENTO_ES_ACT_ID_ELEMENTO_EXISTE).isEmpty()
					|| !mapaErrores.get(IRPF_PORCENTAJE_VACIO).isEmpty()
					|| !mapaErrores.get(LBK_CLAVE_SUBCLAVE_VACIO).isEmpty()
					|| !mapaErrores.get(PARTICIPACION_AL_CIEN_PORCIENTO).isEmpty()
					|| !mapaErrores.get(ELEMENTOS_PERTENECER_MISMA_CARTERA).isEmpty()
					|| !mapaErrores.get(YA_EXISTE_UN_SUBTIPO_TIPO_IMPOSITIVO_TIPO_IMPUESTO).isEmpty()
					|| !mapaErrores.get(ELEMENTO_SIN_PARTICIPACION).isEmpty()
					|| !mapaErrores.get(PARTICIPACION_SIN_ELEMENTO).isEmpty()
					|| !mapaErrores.get(ELEMENTO_SIN_TIPO).isEmpty()
					|| !mapaErrores.get(TIPO_SIN_ELEMENTO).isEmpty()
					|| !mapaErrores.get(PROPIETARIO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(EMISOR_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(IRPF_BASE_VACIA).isEmpty()
					|| !mapaErrores.get(LINEA_DIFERENTE_STG_TIM_TIIM).isEmpty()
					|| !mapaErrores.get(ACTIVABLE_SOLO_BBVA_LBK).isEmpty()
					|| !mapaErrores.get(GASTO_REPETIDO_BBDD).isEmpty()
					|| !mapaErrores.get(GASTO_REPETIDO_CARGA).isEmpty()
					|| !mapaErrores.get(LINEA_SIN_ACTIVOS_CON_ACTIVOS).isEmpty()
					|| !mapaErrores.get(LINEA_SIN_ACTIVOS_REPETIDA).isEmpty()
					|| !mapaErrores.get(LINEA_SIN_ACTIVOS_CON_ID_PARTICIPACION).isEmpty()
					|| !mapaErrores.get(TIPO_IMPOS_IMPUEST_RELLENO).isEmpty()
					|| !mapaErrores.get(SIN_ACTIVOS_NO_VALIDO_CARTERA).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_RET_GARANTIA_PORCENTAJE).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_IRPF_BASE).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_IRPF_PORCENTAJE).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_PPAL_NO_SUJETO_A_IMPUESTO).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_PPAL_SUJETO_A_IMPUESTO).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_IMPORTE_RECARGO).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_INTERES_DEMORA).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_COSTES).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_OTROS_INCREMENTOS).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_PROVISIONES_Y_SUPLIDOS).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_TIPO_IMPOSITIVO).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_PARTI_LINEA_DETALLE).isEmpty()
					|| !mapaErrores.get(TIPO_RETENCION_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(TIPO_RETENCION_VACIO).isEmpty()
					|| !mapaErrores.get(TIPO_RETENCION_RELLENO).isEmpty()

					){
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

	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda, MSVBusinessValidators contentValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);
		
		if ((contentValidators != null) && (contentValidators.getValidatorForColumn(nombreColumna.trim()) != null)){
			MSVColumnValidator v = contentValidators.getValidatorForColumn(nombreColumna.trim());
			MSVValidationResult result = validationRunner.runValidation(v,contenidoCelda);
			resultado.setValido(result.isValid());
			resultado.setErroresFila(result.getErrorMessage());
		}
		return resultado;
	}

	/**
	 * Realiza validaciones multivalor con diferentes valores de la fila
	 * @param mapaDatos
	 * @param compositeValidators
	 * @return
	 */
	protected ResultadoValidacion validaContenidoFila(
			Map<String, String> mapaDatos,
			List<String> listaCabeceras,
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
	
	public File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}

	private List<Integer> isFechaValidator(MSVHojaExcel exc, Integer col){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, col)) && !esFechaValida(exc.dameCelda(i, col)))
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
		
	private List<Integer> isBooleanValidator(MSVHojaExcel exc, Integer col){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String celda = exc.dameCelda(i, col);
					if(!Checks.esNulo(celda) && !Arrays.asList(listaValidos).contains(celda.toUpperCase()))
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
	
	private boolean esFechaValida(String fecha) {
		if(fecha == null || fecha.isEmpty()) {
			return false;
		}
		try {
			String[] fechaArray = fecha.split("/");
			if(fechaArray.length < 3 || 
					(fechaArray[0].length() != 2 || fechaArray[1].length() != 2 || fechaArray[2].length() != 4)) {
				return false;
			}
			if(Integer.parseInt(fechaArray[0]) > 31 || Integer.parseInt(fechaArray[1]) > 12) {
				return false;
			}
			SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
			ft.parse(fecha);
		}catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
	         return false;
		} catch (ParseException e) {
			logger.error(e.getMessage());
			return false;
		}
		return true;
	}
	
	private List<Integer> existeTipoGasto(MSVHojaExcel exc, Integer col){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                	 String celda = exc.dameCelda(i, col);
                	 
                     if(!Checks.esNulo(celda)  
                             && Boolean.FALSE.equals(particularValidator.existeTipoGastoByCod(celda)))
                    	 
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
	
	private List<Integer> existePeriodicidadGasto(MSVHojaExcel exc, Integer col){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                	 String celda = exc.dameCelda(i, col);
                	 
                     if(!Checks.esNulo(celda)  
                             && Boolean.FALSE.equals(particularValidator.existePeriodicidad(celda)))
                    	 
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
	
	private List<Integer> existeDestinatario(MSVHojaExcel exc, Integer col){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                	 String celda = exc.dameCelda(i, col);
                	 
                     if(!Checks.esNulo(celda)  
                             && Boolean.FALSE.equals(particularValidator.existeDestinatarioByCod(celda)))
                    	 
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
	
	private List<Integer> existeTipoOperacion(MSVHojaExcel exc, Integer col){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                	 String celda = exc.dameCelda(i, col);
                	 
                     if(!Checks.esNulo(celda)  
                             && Boolean.FALSE.equals(particularValidator.existeTipoOperacionGastoByCod(celda)))
                    	 
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
	
	private List<Integer> existeSubtipoGasto(MSVHojaExcel exc, Integer col){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                	 String celda = exc.dameCelda(i, col);
                	 
                     if(!Checks.esNulo(celda)  
                             && Boolean.FALSE.equals(particularValidator.existeCodImpuesto(celda)))
                    	 
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
	
	private List<Integer> existeTipoRecargo(MSVHojaExcel exc, Integer col){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                	 String celda = exc.dameCelda(i, col);
                	 
                     if(!Checks.esNulo(celda)  
                             && Boolean.FALSE.equals(particularValidator.existeTipoRecargoByCod(celda)))
                    	 
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
	
	private List<Integer> existeTipoImpuesto(MSVHojaExcel exc, Integer col){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                	 String celda = exc.dameCelda(i, col);
                	 
                     if(!Checks.esNulo(celda)  
                             && Boolean.FALSE.equals(particularValidator.existeTipoimpuesto(celda)))
                    	 
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
	
	private List<Integer> existeTipoElemento(MSVHojaExcel exc, Integer col){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                	 String celda = exc.dameCelda(i, col);
                	 
                     if(!Checks.esNulo(celda)  
                             && Boolean.FALSE.equals(particularValidator.existeTipoElementoByCod(celda)))
                    	 
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
	
	
	private List<Integer> subtipoPerteneceATipoGasto(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();
        

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     
                     if(!Checks.esNulo(exc.dameCelda(i, COL_TIPO_GASTO)) 
                             && !Checks.esNulo(exc.dameCelda(i, COL_SUBTIPO_GASTO))
                             && Boolean.FALSE.equals(particularValidator.subtipoPerteneceATipoGasto(exc.dameCelda(i, COL_TIPO_GASTO), exc.dameCelda(i, COL_SUBTIPO_GASTO))))
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
	
	private List<Integer> siElementoActExiste(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();
        

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     
                     if(!Checks.esNulo(exc.dameCelda(i, COL_TIPO_ELEMENTO))
                    		 && TIPO_ELEMENTO_ACTIVO.equals(exc.dameCelda(i, COL_TIPO_ELEMENTO))
                    		 && !Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO))
                    		 && Boolean.FALSE.equals(particularValidator.existeActivo(exc.dameCelda(i, COL_ID_ELEMENTO))))
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
	
	private List<Integer> esIrpfPorcentajeVacio(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     
                     if(!Checks.esNulo(exc.dameCelda(i, COL_IRPF_BASE)) 
                             && Checks.esNulo(exc.dameCelda(i, COL_IRPF_PORCENTAJE)))
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
	
	private List<Integer> esIrpfBaseVacio(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     
                     if(Checks.esNulo(exc.dameCelda(i, COL_IRPF_BASE)) 
                             && !Checks.esNulo(exc.dameCelda(i, COL_IRPF_PORCENTAJE)))
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
	private List<Integer> esLbkClaveSubclaveVacio(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     
                     if(!Checks.esNulo(exc.dameCelda(i, COL_IRPF_BASE)) 
                    		 && !Checks.esNulo(exc.dameCelda(i, COL_NIF_PROPIETARIO)) 
                    		 && Boolean.TRUE.equals(particularValidator.esPropietarioDeCarteraByCodigo(exc.dameCelda(i, COL_NIF_PROPIETARIO), "08"))//liberbank 
                             && (Checks.esNulo(exc.dameCelda(i, COL_IRPF_CLAVE))
                    	 	 || Checks.esNulo(exc.dameCelda(i, COL_IRPF_SUBCLAVE))))
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
	
	private List<Integer> participacionSumaCien(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();
        
         try{
        	 List<String> cadenaInformacionParticipacion =  new ArrayList <String>();
        	 List<String> listaSinActivos =  new ArrayList <String>();
        	 for(int i=1; i<this.numFilasHoja;i++){
				try {
					String agrupacionLineaGasto = exc.dameCelda(i,COL_ID_AGRUPADOR_GASTO) + "/" +  exc.dameCelda(i,COL_COD_AGRUPACION_LINEA_DETALLE);
					boolean noEntontrado = false;
					String auxiliar = null;
					if(!Checks.esNulo(exc.dameCelda(i,COL_TIPO_ELEMENTO)) 
						&& !TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(exc.dameCelda(i,COL_TIPO_ELEMENTO))) {
						if(!cadenaInformacionParticipacion.isEmpty()) {
							for (String string : cadenaInformacionParticipacion) {
								String[] lineaGasto = string.split("-");
								if(lineaGasto[0].equals(agrupacionLineaGasto)) {
									noEntontrado = false;
									if(!Checks.esNulo(exc.dameCelda(i,COL_PARTICIPACION_LINEA_DETALLE)) && lineaGasto.length == 2) {
										Double participacion = Double.valueOf(lineaGasto[1]);
										participacion = participacion + Double.valueOf(exc.dameCelda(i,COL_PARTICIPACION_LINEA_DETALLE));
										agrupacionLineaGasto = agrupacionLineaGasto + "-" + participacion.toString();
										auxiliar = string;		
									}else if (!Checks.esNulo(exc.dameCelda(i,COL_PARTICIPACION_LINEA_DETALLE))){
										agrupacionLineaGasto = agrupacionLineaGasto + "-" + exc.dameCelda(i,COL_PARTICIPACION_LINEA_DETALLE);
										auxiliar = string;
									}
								}else {
									noEntontrado = true;
								}
								if(auxiliar != null) {
									cadenaInformacionParticipacion.remove(auxiliar);
									cadenaInformacionParticipacion.add(agrupacionLineaGasto);
									break;
								}
							}
						}
						if(cadenaInformacionParticipacion.isEmpty() || noEntontrado) {
							if(!Checks.esNulo(exc.dameCelda(i,COL_PARTICIPACION_LINEA_DETALLE ))) {
								agrupacionLineaGasto = agrupacionLineaGasto + "-" + exc.dameCelda(i,COL_PARTICIPACION_LINEA_DETALLE);
							}
							cadenaInformacionParticipacion.add(agrupacionLineaGasto);
						}
					}else if(!Checks.esNulo(exc.dameCelda(i,COL_TIPO_ELEMENTO))){
						listaSinActivos.add(agrupacionLineaGasto);
					}
				} catch (ParseException e) {
					e.printStackTrace();
				}	
        	}
	        for(int i=1; i<this.numFilasHoja;i++){
	             try {
	            	 if(!Checks.esNulo(exc.dameCelda(i,COL_TIPO_ELEMENTO)) && !TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(exc.dameCelda(i,COL_TIPO_ELEMENTO))) {
						String agrupacionLineaGasto = exc.dameCelda(i,COL_ID_AGRUPADOR_GASTO) + "/" +   exc.dameCelda(i,COL_COD_AGRUPACION_LINEA_DETALLE);
		            	if(!listaSinActivos.contains(agrupacionLineaGasto)) {
							for (String string : cadenaInformacionParticipacion) {
			            		String[] lineaGasto = string.split("-");
								if(lineaGasto[0].equals(agrupacionLineaGasto) && lineaGasto.length == 2) {
									BigDecimal porcentajeLinea = new BigDecimal(lineaGasto[1]);
									porcentajeLinea = porcentajeLinea.setScale(2, BigDecimal.ROUND_HALF_UP);
									if(porcentajeLinea.compareTo(new BigDecimal(100.0)) != 0) {
										 listaFilas.add(i);
									}
									break;
								}
							}
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
	
	private List<Integer> elementoMismaCartera(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     
                	 if(!Checks.esNulo(exc.dameCelda(i, COL_NIF_PROPIETARIO)) && !Checks.esNulo(exc.dameCelda(i, COL_TIPO_ELEMENTO)) && !Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO))){
                		 if((TIPO_ELEMENTO_ACTIVO.equalsIgnoreCase(exc.dameCelda(i, COL_TIPO_ELEMENTO)) || TIPO_ELEMENTO_ACTIVOGEN.equalsIgnoreCase(exc.dameCelda(i, COL_TIPO_ELEMENTO)))
                				 && Boolean.FALSE.equals(particularValidator.esGastoYActivoMismoPropietario(exc.dameCelda(i, COL_NIF_PROPIETARIO), exc.dameCelda(i, COL_ID_ELEMENTO), exc.dameCelda(i, COL_TIPO_ELEMENTO)))) {
                			 listaFilas.add(i);
                		 } else if((TIPO_ELEMENTO_AGRUPACION.equalsIgnoreCase(exc.dameCelda(i, COL_TIPO_ELEMENTO)))
                				 && Boolean.FALSE.equals(particularValidator.esGastoYAgrupacionMismoPropietario(exc.dameCelda(i, COL_NIF_PROPIETARIO), exc.dameCelda(i, COL_ID_ELEMENTO)))) {
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
	
	private List<Integer> bankiaMasDeUnaLinea(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();
        HashMap<String, String> gastoLineaBkList = new HashMap<String, String>();
         try{

        	 for(int i=1; i<this.numFilasHoja;i++) {
        		 try {
        			boolean anyadir = true;
        			if(Boolean.TRUE.equals(particularValidator.esPropietarioDeCarteraByCodigo(exc.dameCelda(i, COL_NIF_PROPIETARIO), COD_BANKIA))){
        				String gasto = exc.dameCelda(i,COL_ID_AGRUPADOR_GASTO);
        				String linea = exc.dameCelda(i,COL_COD_AGRUPACION_LINEA_DETALLE);
        				for (Map.Entry<String, String> gastoLineaBk : gastoLineaBkList.entrySet()) {
        					if(gastoLineaBk.getKey().equalsIgnoreCase(gasto)) {
        						anyadir = false;
        						if(!gastoLineaBk.getValue().equalsIgnoreCase(linea)) {
        							listaFilas.add(i);
        						}
        					}
        				}
        				if(anyadir) {
        					gastoLineaBkList.put(exc.dameCelda(i,COL_ID_AGRUPADOR_GASTO), exc.dameCelda(i,COL_COD_AGRUPACION_LINEA_DETALLE));
        				}
        			}
				} catch (ParseException e) {
					
					
					e.printStackTrace();
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
	
	private List<Integer> campoSoloParaCarteraByCode(MSVHojaExcel exc, Integer campo, String cartera){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
            	 try {
            		 if(!Checks.esNulo(exc.dameCelda(i, COL_NIF_PROPIETARIO)) 
            				 && !Checks.esNulo(exc.dameCelda(i, campo))
            				 && Boolean.FALSE.equals(particularValidator.esPropietarioDeCarteraByCodigo(exc.dameCelda(i, COL_NIF_PROPIETARIO), cartera))) {
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
	
	private List<Integer> existeUnsubtipoGastoIgual(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();
	   	   List<String> cadenaInformacionList =  new ArrayList <String>();
	      

	        try{
	        	
	            for(int i=1; i<this.numFilasHoja;i++){
	            	
	                try {
	                	String  agrupacionLineaGasto = exc.dameCelda(i,COL_ID_AGRUPADOR_GASTO) + "/" +  exc.dameCelda(i,COL_COD_AGRUPACION_LINEA_DETALLE);
	                	String impuestoActivo = devolverCadenaInformacionCompleta(exc.dameCelda(i, COL_SUBTIPO_GASTO),exc.dameCelda(i, COL_TIPO_IMPOSITIVO),exc.dameCelda(i, COL_TIPO_IMPUESTO),exc.dameCelda(i, COL_TIPO_ELEMENTO),exc.dameCelda(i, COL_ID_ELEMENTO));
	                	String cadenaCompleta = agrupacionLineaGasto +"/"+impuestoActivo;
	                	
	                	if(cadenaInformacionList.contains(cadenaCompleta)) {
	                		listaFilas.add(i);
	                	}else{
	                		cadenaInformacionList.add(cadenaCompleta);
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
	
	public String devolverCadenaInformacionCompleta(String subtipoGasto, String tipoImpositivo, String tipoImpuesto, String tipoElemento, String activo){ 
		   String cadena = "";
		   String activoTipo=",vacio";
		   
		   String subtipoGastoImpuestImpositivo = gastoSubtipoImpuestoImpositivo(subtipoGasto, tipoImpositivo, tipoImpuesto);
		   

		   if(!Checks.esNulo(tipoElemento) && !Checks.esNulo(activo)) {
			   activoTipo = "," + tipoElemento + "-" + activo;
		   }
		   
		   cadena = cadena + subtipoGastoImpuestImpositivo + activoTipo;
		   return cadena;
	   }
	
	 private String gastoSubtipoImpuestoImpositivo(String subtipoGasto, String tipoImpositivo, String tipoImpuesto) {
		   String subtipoGastoImpuestImpositivo = subtipoGasto;
		   
		   if(!Checks.esNulo(tipoImpuesto) && !Checks.esNulo(tipoImpositivo)) {
			   subtipoGastoImpuestImpositivo = subtipoGastoImpuestImpositivo + "-" +tipoImpuesto;
			   subtipoGastoImpuestImpositivo = subtipoGastoImpuestImpositivo + "-" + tipoImpositivo;
		   }
		   
		   return subtipoGastoImpuestImpositivo;
	   }
	 
	 private List<Integer> participacionSinActivos(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE)) && Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)))
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
	 
	 private List<Integer> activoSinParticipacion(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(Checks.esNulo(exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE)) && !Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)))
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
	 
	 private List<Integer> elementosSinTipo(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(Checks.esNulo(exc.dameCelda(i, COL_TIPO_ELEMENTO)) && !Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)))
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
	 
	 private List<Integer> tipoSinElementos(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                	String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
	                    if(!Checks.esNulo(tipoElemento)&& !TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento) 
	                    		&& Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)))
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
	 
	 private List<Integer> existePropietario(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(Boolean.FALSE.equals(particularValidator.existePropietario(exc.dameCelda(i, COL_NIF_PROPIETARIO))))
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
	 
	 
	 private List<Integer> existeEmisor(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(Checks.esNulo(exc.dameCelda(i, COL_COD_PROVEEDOR_REM)) && !Checks.esNulo(exc.dameCelda(i, COL_NIF_EMISOR)) && Boolean.FALSE.equals(particularValidator.existeEmisor(exc.dameCelda(i, COL_NIF_EMISOR))))
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
	 
	 private List<Integer> existeCodProveedorRem(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_COD_PROVEEDOR_REM)) && Boolean.FALSE.equals(particularValidator.existeCodProveedorRem(exc.dameCelda(i, COL_COD_PROVEEDOR_REM))))
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
	 
	 
	 private List<Integer> mismaLineaDiferenteTipo(MSVHojaExcel exc){
	        List<Integer> listaFilas = new ArrayList<Integer>();
	        HashMap<String, String> gastoLineaBkList = new HashMap<String, String>();
	         try{

	        	 for(int i=1; i<this.numFilasHoja;i++) {
	        		 try {
	        			boolean anyadir = true;
        				String agrupacionLineaGasto = exc.dameCelda(i,COL_ID_AGRUPADOR_GASTO) + "/" +  exc.dameCelda(i,COL_COD_AGRUPACION_LINEA_DETALLE);
        				String subGastoTipoImpuestoImpos = gastoSubtipoImpuestoImpositivo(exc.dameCelda(i,COL_SUBTIPO_GASTO),exc.dameCelda(i,COL_TIPO_IMPOSITIVO), exc.dameCelda(i,COL_TIPO_IMPUESTO));
        				for (Map.Entry<String, String> gastoLineaBk : gastoLineaBkList.entrySet()) {
        					if(gastoLineaBk.getKey().equalsIgnoreCase(agrupacionLineaGasto)) {
        						anyadir = false;
        						if(!gastoLineaBk.getValue().equalsIgnoreCase(subGastoTipoImpuestoImpos)) {
        							listaFilas.add(i);
        						}
        					}
        				}
        				if(anyadir) {
        					gastoLineaBkList.put(agrupacionLineaGasto, subGastoTipoImpuestoImpos);
        				}
	        			
					} catch (ParseException e) {
						
						
						e.printStackTrace();
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
	 
	 private List<Integer> campoSoloParaMultiplesCarteras(MSVHojaExcel exc, Integer campo){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
            	 try {
            		 if(!Checks.esNulo(exc.dameCelda(i, COL_NIF_PROPIETARIO)) && !Checks.esNulo(exc.dameCelda(i, campo))
            			&& Boolean.FALSE.equals(particularValidator.esPropietarioDeCarteraByCodigo(exc.dameCelda(i, COL_NIF_PROPIETARIO), COD_LBK))
            			&& Boolean.FALSE.equals(particularValidator.esPropietarioDeCarteraByCodigo(exc.dameCelda(i, COL_NIF_PROPIETARIO), COD_BBVA))) 
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
	 
	 private List<Integer> gastoRepetidoBBDD(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
            	 try {
            		 if(particularValidator.gastoRepetido(exc.dameCelda(i, COL_NUM_FACTURA_LIQUIDACION),exc.dameCelda(i, COL_F_EMISION_DEVENGO),
            		 exc.dameCelda(i, COL_NIF_EMISOR),exc.dameCelda(i, COL_NIF_PROPIETARIO))) {
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
	 
	 private List<Integer> gastoRepetidoEnCarga(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
        	 List<String> listaCadenas = new ArrayList<String>();
        	 for(int i=1; i<this.numFilasHoja;i++){
        		 String cadena = createCadenaGastoRepetido(exc.dameCelda(i, COL_NUM_FACTURA_LIQUIDACION),
           				 exc.dameCelda(i, COL_NIF_EMISOR),exc.dameCelda(i, COL_NIF_PROPIETARIO),exc.dameCelda(i, COL_SUBTIPO_GASTO),
           				 exc.dameCelda(i, COL_TIPO_IMPUESTO),exc.dameCelda(i, COL_TIPO_IMPOSITIVO),exc.dameCelda(i, COL_ID_ELEMENTO),
           				 exc.dameCelda(i, COL_TIPO_ELEMENTO),Integer.toString(i));
        		 listaCadenas.add(cadena);
        	 }
             for(int i=1; i<this.numFilasHoja;i++){
            	 try {
            		String cadena = createCadenaGastoRepetido(exc.dameCelda(i, COL_NUM_FACTURA_LIQUIDACION),
           				 exc.dameCelda(i, COL_NIF_EMISOR),exc.dameCelda(i, COL_NIF_PROPIETARIO),exc.dameCelda(i, COL_SUBTIPO_GASTO),
           				 exc.dameCelda(i, COL_TIPO_IMPUESTO),exc.dameCelda(i, COL_TIPO_IMPOSITIVO),exc.dameCelda(i, COL_ID_ELEMENTO),
           				 exc.dameCelda(i, COL_TIPO_ELEMENTO),Integer.toString(i));
            		String[] cadenaActual = cadena.split("[$]");
            		for (String string : listaCadenas) {
						String[] lineaGasto = string.split("[$]");
						//para que no se compare consigo misma,despues comprueba que los datos no sean iguales
						if (!lineaGasto[8].equals(cadenaActual[8])) {
							if(lineaGasto[0].equals(cadenaActual[0]) && lineaGasto[1].equals(cadenaActual[1]) && lineaGasto[2].equals(cadenaActual[2]) &&
									lineaGasto[3].equals(cadenaActual[3]) && lineaGasto[4].equals(cadenaActual[4]) && lineaGasto[5].equals(cadenaActual[5]) && 
									lineaGasto[6].equals(cadenaActual[6]) && lineaGasto[7].equals(cadenaActual[7]) ) {
								listaFilas.add(i);
								break;
							}
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
         } catch (ParseException e) {
        	 listaFilas.add(0);
			e.printStackTrace();
		}
         return listaFilas;   
	 }

	 private String createCadenaGastoRepetido(String factura, String nifEmisor, String nifPropietario, String subtipoGasto, String tipoImpuesto,
			 String tipoImpositivo, String idElemento, String tipoElemento, String numRow){
		 String cadena = factura + "$" + nifEmisor + "$" + nifPropietario + "$" + subtipoGasto + "$" + tipoImpuesto + "$" + tipoImpositivo + "$"
				 + idElemento + "$" + tipoElemento + "$" + numRow;
		 return cadena;
	 }
	 
	private List<Integer> masUnaLineaSinActivos(MSVHojaExcel exc){
	        List<Integer> listaFilas = new ArrayList<Integer>();

	         try{
	        	 List<String> listaCadenasSIN = new ArrayList<String>();
	        	 for(int i=1; i<this.numFilasHoja;i++){
	                String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
	        		if(!Checks.esNulo(tipoElemento) && TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento)) {
	        			listaCadenasSIN.add(exc.dameCelda(i,COL_ID_AGRUPADOR_GASTO) + "/" +  exc.dameCelda(i,COL_COD_AGRUPACION_LINEA_DETALLE));
	        		}
	        	 }
	        	 
	        	 for(int i=1; i<this.numFilasHoja;i++){
		                String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
		                String gastoLinea = exc.dameCelda(i,COL_ID_AGRUPADOR_GASTO) + "/" +  exc.dameCelda(i,COL_COD_AGRUPACION_LINEA_DETALLE);
		        		if(listaCadenasSIN.contains(gastoLinea) && !Checks.esNulo(tipoElemento) && !TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento)) {
		        			listaFilas.add(i);
		        		}
		        	 }

	         } catch (IllegalArgumentException e) {
	             listaFilas.add(0);
	             e.printStackTrace();
	         } catch (IOException e) {
	             listaFilas.add(0);
	             e.printStackTrace();
	         } catch (ParseException e) {
	        	 listaFilas.add(0);
				e.printStackTrace();
			}
	         return listaFilas;   
		 }
	
	private List<Integer> lineaYaMarcadaSinActivos(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
        	 List<String> listaCadenasSIN = new ArrayList<String>();
        	 for(int i=1; i<this.numFilasHoja;i++){
                String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
        		if(!Checks.esNulo(tipoElemento) && TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento)) {
        			String lineaGasto = exc.dameCelda(i,COL_ID_AGRUPADOR_GASTO) + "/" +  exc.dameCelda(i,COL_COD_AGRUPACION_LINEA_DETALLE);
        			if(listaCadenasSIN.contains(lineaGasto)) {
        				listaFilas.add(i);
        			}else {
        				listaCadenasSIN.add(lineaGasto);
        			}	
        		}
        	 }
        	
         } catch (IllegalArgumentException e) {
             listaFilas.add(0);
             e.printStackTrace();
         } catch (IOException e) {
             listaFilas.add(0);
             e.printStackTrace();
         } catch (ParseException e) {
        	 listaFilas.add(0);
			e.printStackTrace();
		}
         return listaFilas;   
	 }
	
	private List<Integer> lineaSinActivosElementoyPorcentajeVacio(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
        	 for(int i=1; i<this.numFilasHoja;i++){
                String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
        		if(!Checks.esNulo(tipoElemento) && TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento) &&
        		(!Checks.esNulo( exc.dameCelda(i, COL_ID_ELEMENTO)) || !Checks.esNulo( exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE)))) {
        			listaFilas.add(i);
        		}
        	 }
        	
         } catch (IllegalArgumentException e) {
             listaFilas.add(0);
             e.printStackTrace();
         } catch (IOException e) {
             listaFilas.add(0);
             e.printStackTrace();
         } catch (ParseException e) {
        	 listaFilas.add(0);
			e.printStackTrace();
		}
         return listaFilas;   
	 }
	
	private List<Integer> tipoImpositivoEimpuestoRellenos(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
        	 for(int i=1; i<this.numFilasHoja;i++){
               if((!Checks.esNulo( exc.dameCelda(i, COL_TIPO_IMPOSITIVO)) && Checks.esNulo( exc.dameCelda(i, COL_TIPO_IMPUESTO))) ||
                (Checks.esNulo( exc.dameCelda(i, COL_TIPO_IMPOSITIVO)) && !Checks.esNulo( exc.dameCelda(i, COL_TIPO_IMPUESTO)))) {
            	   listaFilas.add(i);
               }
        	 }
        	
         } catch (IllegalArgumentException e) {
             listaFilas.add(0);
             e.printStackTrace();
         } catch (IOException e) {
             listaFilas.add(0);
             e.printStackTrace();
         } catch (ParseException e) {
        	 listaFilas.add(0);
			e.printStackTrace();
		}
         return listaFilas;   
	 }
	
	private List<Integer> sinActivosNoValidoCartera(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
        	 for(int i=1; i<this.numFilasHoja;i++){
        		 String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
        		 String docIdent = exc.dameCelda(i, COL_NIF_PROPIETARIO);
         		 if(!Checks.esNulo(tipoElemento) && TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento)) {
         			 List<String> listaCarteras = Arrays.asList(COD_SAREB, COD_GIANTS, COD_TANGO);
         			 if(Boolean.TRUE.equals(particularValidator.propietarioPerteneceCartera(docIdent, listaCarteras))) {
         				 listaFilas.add(i);
         			 }
         			 
         		 }
        	 }
        	
         } catch (IllegalArgumentException e) {
             listaFilas.add(0);
             e.printStackTrace();
         } catch (IOException e) {
             listaFilas.add(0);
             e.printStackTrace();
         } catch (ParseException e) {
        	 listaFilas.add(0);
			e.printStackTrace();
		}
         return listaFilas;   
	 }
	 private List<Integer> comprobarDouble(MSVHojaExcel exc, int columna){
       List<Integer> listaFilas = new ArrayList<Integer>();

        try{
       	 for(int i=1; i<this.numFilasHoja;i++){
       		 
               String valorColumna = exc.dameCelda(i, columna);
               if(!Checks.esNulo(valorColumna)) {
            	  try {
            	    Double.parseDouble(valorColumna);
            	  }catch(NumberFormatException e){
            		listaFilas.add(i); 
            	  }
            	  
               }
       	 }
       	
        } catch (IllegalArgumentException e) {
        	
            listaFilas.add(0);
            e.printStackTrace();
        } catch (IOException e) {
            listaFilas.add(0);
            e.printStackTrace();
        } catch (ParseException e) {
       	 listaFilas.add(0);
			e.printStackTrace();
		}
        return listaFilas;   
	 }
	 
	 private List<Integer> tipoRetencionNoExiste(MSVHojaExcel exc){
       List<Integer> listaFilas = new ArrayList<Integer>();

        try{
       	 for(int i=1; i<this.numFilasHoja;i++){
	       	  if(!Checks.esNulo(exc.dameCelda(i, COL_TIPO_RETENCION))  
	       		&& Boolean.FALSE.equals(particularValidator.existeTipoRetencion(exc.dameCelda(i, COL_TIPO_RETENCION)))) {
	       		  listaFilas.add(i);
	       	  }
       	 }
       	
        } catch (IllegalArgumentException e) {
        	
            listaFilas.add(0);
            e.printStackTrace();
        } catch (IOException e) {
            listaFilas.add(0);
            e.printStackTrace();
        } catch (ParseException e) {
       	 listaFilas.add(0);
			e.printStackTrace();
		}
        return listaFilas;   
	 }
	 
	 private List<Integer> tipoRetencionRelleno(MSVHojaExcel exc){
       List<Integer> listaFilas = new ArrayList<Integer>();

        try{
       	 for(int i=1; i<this.numFilasHoja;i++){
               if(Checks.esNulo(exc.dameCelda(i, COL_TIPO_RETENCION)) && !Checks.esNulo(exc.dameCelda(i, COL_RETENCION_GARANTIA_PORCENTAJE))) {
            	   listaFilas.add(i);
               }
       	 }
       	
        } catch (IllegalArgumentException e) {
        	
            listaFilas.add(0);
            e.printStackTrace();
        } catch (IOException e) {
            listaFilas.add(0);
            e.printStackTrace();
        } catch (ParseException e) {
       	 listaFilas.add(0);
			e.printStackTrace();
		}
        return listaFilas;   
	 }
	 
	 private List<Integer> tipoRetencionVacio(MSVHojaExcel exc){
       List<Integer> listaFilas = new ArrayList<Integer>();

        try{
       	 for(int i=1; i<this.numFilasHoja;i++){
               if(!Checks.esNulo(exc.dameCelda(i, COL_TIPO_RETENCION))  &&  Checks.esNulo(exc.dameCelda(i, COL_RETENCION_GARANTIA_PORCENTAJE))) {
            	   listaFilas.add(i);
               }
       	 }
       	
        } catch (IllegalArgumentException e) {
        	
            listaFilas.add(0);
            e.printStackTrace();
        } catch (IOException e) {
            listaFilas.add(0);
            e.printStackTrace();
        } catch (ParseException e) {
       	 listaFilas.add(0);
			e.printStackTrace();
		}
        return listaFilas;   
	 }
	 
	 @Override
	 public Integer getNumFilasHoja() {
		 return this.numFilasHoja;
	 }
}
