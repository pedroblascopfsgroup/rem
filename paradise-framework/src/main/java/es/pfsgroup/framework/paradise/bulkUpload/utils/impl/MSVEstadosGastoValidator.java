package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
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
public class MSVEstadosGastoValidator extends MSVExcelValidatorAbstract{

	private static final String CODIGO_SUBCARTERA_LIVING_CENTER = "161";
	
	private static final String CHECK_COD_APR_RECH_INCORRECTO = "msg.error.masivo.apr.rech.incorrecto";
	private static final String CHECK_GASTO_EXIST = "msg.error.masivo.gasto.exist";
	private static final String CHECK_MOTIVO_RECHAZO_INFORMADO = "msg.error.masivo.mot.rechazo.informado";
	private static final String CHECK_SIN_DOCUMENTO = "msg.error.masivo.sin.doc";
	private static final String CHECK_SIN_FACTURA = "msg.error.masivo.sin.factura";
	private static final String CHECK_SIN_LINEA_DET = "msg.error.masivo.sin.linea.detalle";
	private static final String CHECK_SIN_TIPO = "msg.error.masivo.sin.tipo";
	private static final String CHECK_SIN_SUBTIPO = "msg.error.masivo.sin.subtipo";
	private static final String CHECK_SIN_EMISOR = "msg.error.masivo.sin.emisor";
	private static final String CHECK_SIN_PROPIETARIO = "msg.error.masivo.sin.propietario";
	private static final String CHECK_SIN_FECHA_EMISIÓN = "msg.error.masivo.sin.fecha.emision";
	private static final String CHECK_SIN_TIPO_OPERACION = "msg.error.masivo.sin.tipo.operacion";
	private static final String CHECK_SIN_TIPO_PERIODICIDAD = "msg.error.masivo.sin.tipo.periodicidad";
	private static final String CHECK_SIN_CONCEPTO = "msg.error.masivo.sin.concepto";
	private static final String CHECK_SIN_IMPORTE = "msg.error.masivo.sin.importe";
	private static final String CHECK_SIN_IMPUESTO_IND = "msg.error.masivo.sin.impuesto.ind";
	private static final String CHECK_OBL_ACT_X_LINEA = "msg.error.masivo.sin.activo.por.linea";
	private static final String CHECK_CUENTA_CONTABLE_OBL_BBVA = "msg.error.masivo.cuante.contable.bbva";
	private static final String CHECK_OBL_CART_UNICAJA = "msg.error.masivo.obl.cartera.unicaja";
	private static final String CHECK_CUENTA_Y_PARTIDA = "msg.error.masivo.cuenta.partida";
	private static final String CHECK_RECH_SIN_PROPIETARIO = "msg.error.masivo.rech.sin.propietario";
	private static final String CHECK_GASTO_RET = "msg.error.masivo.gasto.ret";
	private static final String CHECK_GASTO_AGRUPADO = "msg.error.masivo.gasto.agrup";
	private static final String CHECK_GASTO_CARTERA_TANGO = "msg.error.masivo.gasto.cartera.tango";
	private static final String CHECK_GASTO_RECHAZADO_PROPIETARIO = "msg.error.masivo.gasto.rech.propietario";
	private static final String CHECK_AUT_SIN_ACTIVOS_O_CONT_CAIXA = "msg.error.masivo.aut.sin.activos.cont.caixa";
	private static final String CHECK_AUT_NO_FECHA_DEVENGO_LIVINGCENTER = "msg.error.masivo.aut.fecha.devengo.lc";
	private static final String CHECK_AUT_SIN_ID_ABONADO = "msg.error.masivo.aut.sin.id.abonado";
	private static final String CHECK_AUT_SIN_NIF_TITULAR_LIVINGCENTER = "msg.error.masivo.aut.sin.nif.titular.lc";
	private static final String CHECK_AUT_SUPLIDO_SIN_PRINCIPAL = "msg.error.masivo.aut.suplido.sin.principal";
	private static final String CHECK_AUT_SUPLIDO_SIN_SUPLIDOS_VINC = "msg.error.masivo.aut.suplido.sin.suplidos";
	private static final String CHECK_AUT_SUPLIDO_SIN_DATOS_PAGO_PRINCIPAL = "msg.error.masivo.aut.sin.datos.pago.principal";
	private static final String CHECK_RECH_GASTO_REFACTURADO = "msg.error.masivo.rech.gasto.refacturado";
	private static final String CHECK_RECH_GASTO_YA_RECHAZADO = "msg.error.masivo.rech.gasto.rechazado";
	private static final String CHECK_RECH_GASTOS_NO_AUT_ADMON = "msg.error.masivo.rech.no.aut.admon";
	private static final int COL_NUM_GASTO = 0;
	private static final int COL_AUT_RECH = 1;
	private static final int COL_MOT_RECH = 2;

	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final String COD_APR = "01";
	private final String COD_RECH = "02";

	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;
		
	@Resource
    MessageService messageServices;
	
	private Integer numFilasHoja;

	private Map<String, List<Integer>> mapaErrores;
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();
		if (idTipoOperacion == null) {
			throw new IllegalArgumentException("MSVEstadosGastoValidator -> idTipoOperacion no puede ser null");
		}

		List<String> lista = recuperarFormato(idTipoOperacion);
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getRuta());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(idTipoOperacion));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(idTipoOperacion));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(idTipoOperacion));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(idTipoOperacion);

		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(FILA_CABECERA, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			generarMapaErrores();

			if (!validarFichero(exc)) {
				dtoValidacionContenido.setFicheroTieneErrores(true);
				dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
			}

		}

		exc.cerrar();

		return dtoValidacionContenido;
	}

	private boolean validarFichero(MSVHojaExcel exc) {
		boolean esCorrecto = true;
		boolean validaAutorizaRechaza = true;

		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {

			try {
				String numGasto = exc.dameCelda(fila, COL_NUM_GASTO);
				String autorizaRechaza = exc.dameCelda(fila, COL_AUT_RECH);
				String motivoRechazo = exc.dameCelda(fila, COL_MOT_RECH);

				esCorrecto = validaGastosDatosGeneric(exc, fila, numGasto, autorizaRechaza, motivoRechazo);

				if(esCorrecto) {
					if(COD_APR.equals(autorizaRechaza)) {
						validaAutorizaRechaza = validaAutoriza(fila, numGasto);
					} else if(COD_RECH.equals(autorizaRechaza)) {
						validaAutorizaRechaza = validaRechaza(fila, numGasto);
					}
				}

			} catch (Exception e) {
				logger.error(e.getMessage());
				esCorrecto = false;
			}
		}

		return esCorrecto && validaAutorizaRechaza;
	}

	private boolean validaRechaza(int fila, String numGasto) {
		boolean rechaza = true;
		
		if(particularValidator.esGastoRefacturadoHijo(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_RECH_GASTO_REFACTURADO)).add(fila);
			rechaza = false;
		}
		if(particularValidator.esGastoRechazado(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_RECH_GASTO_YA_RECHAZADO)).add(fila);
			rechaza = false;
		}
		if(!particularValidator.esGastoAutorizadoAdministracion(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_RECH_GASTOS_NO_AUT_ADMON)).add(fila);
			rechaza = false;
		}
		
		return rechaza;
	}
	
	private boolean validaAutoriza(int fila, String numGasto) {
		boolean autoriza = true;
		
		if(particularValidator.esGastoPadreSuplido(numGasto) && !particularValidator.esGastoConSuplidosVinculados(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_AUT_SUPLIDO_SIN_SUPLIDOS_VINC)).add(fila);
			autoriza = false;
		}
		if(particularValidator.esGastoSuplido(numGasto)) {
			if(!particularValidator.esGastoSuplidoConPadreAutorizado(numGasto)){
				mapaErrores.get(messageServices.getMessage(CHECK_AUT_SUPLIDO_SIN_PRINCIPAL)).add(fila);
				autoriza = false;
			}
			if(!particularValidator.tieneGastoSuplidoNIFIgualGastoPadreNIF(numGasto) || !particularValidator.tieneGastoSuplidoAbonoCuenta(numGasto)){
				mapaErrores.get(messageServices.getMessage(CHECK_AUT_SUPLIDO_SIN_DATOS_PAGO_PRINCIPAL)).add(fila);
				autoriza = false;
			}
		}
		if(!particularValidator.tieneGastoAbonadoGasto(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_AUT_SIN_ID_ABONADO)).add(fila);
			return false;
		}
		if(particularValidator.esGastoCaixaBank(numGasto, null) && particularValidator.esGastoAlquiler(numGasto) && !particularValidator.tieneGastoActivosONumeroContrato(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_AUT_SIN_ACTIVOS_O_CONT_CAIXA)).add(fila);
			autoriza = false;
		}
		if(particularValidator.esGastoCaixaBank(numGasto, CODIGO_SUBCARTERA_LIVING_CENTER) && !particularValidator.tieneGastoFechaDevengoEspecialOFechaAnteriorAEmision(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_AUT_NO_FECHA_DEVENGO_LIVINGCENTER)).add(fila);
			autoriza = false;
		}
		if(particularValidator.esGastoCaixaBank(numGasto, CODIGO_SUBCARTERA_LIVING_CENTER) && !particularValidator.tieneGastoCampoObligatorioNIFTitularCartaPago(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_AUT_SIN_NIF_TITULAR_LIVINGCENTER)).add(fila);
			autoriza = false;
		}
		
		return autoriza;
	}

	private boolean validaGastosDatosGeneric(MSVHojaExcel exc, int fila, String numGasto, String autorizaRechaza, String motivoRechazo) {
		boolean esCorrecto = true;

		esCorrecto = validaDatosNoExistentes(exc, fila, numGasto, autorizaRechaza, motivoRechazo);

		if(esCorrecto) {

			if(particularValidator.yaRechazadoPropietarioGasto(numGasto)){
				mapaErrores.get(messageServices.getMessage(CHECK_GASTO_RECHAZADO_PROPIETARIO)).add(fila);
				esCorrecto = false;
			}
			if(particularValidator.carteraTangoGasto(numGasto)){
				mapaErrores.get(messageServices.getMessage(CHECK_GASTO_CARTERA_TANGO)).add(fila);
				esCorrecto = false;
			}
			if(particularValidator.esAgrupadoGasto(numGasto)){
				mapaErrores.get(messageServices.getMessage(CHECK_GASTO_AGRUPADO)).add(fila);
				esCorrecto = false;
			}
			if(particularValidator.esGastoBBVA(numGasto)){
				if(!particularValidator.tieneGastoCampoObligatorioCuentaContable(numGasto)) {
					mapaErrores.get(messageServices.getMessage(CHECK_CUENTA_CONTABLE_OBL_BBVA)).add(fila);
					esCorrecto = false;
				}
			} else if(particularValidator.esGastoUnicaja(numGasto)) {
				if(!particularValidator.tieneGastoCamposObligatoriosCuentaPartidaApartadoCapitulo(numGasto)) {
					mapaErrores.get(messageServices.getMessage(CHECK_OBL_CART_UNICAJA)).add(fila);
					esCorrecto = false;
				}
			} else if(!particularValidator.tieneGastoCamposObligatoriosCuentaPartida(numGasto)){
				mapaErrores.get(messageServices.getMessage(CHECK_CUENTA_Y_PARTIDA)).add(fila);
				esCorrecto = false;
			}
			if(particularValidator.tieneGastoTipoImpuestoIndirectoIncorrecto(numGasto)){
				mapaErrores.get(messageServices.getMessage(CHECK_SIN_IMPUESTO_IND)).add(fila);
				esCorrecto = false;
			}

		}

		return esCorrecto;
	}

	private Boolean validaDatosNoExistentes(MSVHojaExcel exc, int fila, String numGasto, String autorizaRechaza, String motivoRechazo) {
		boolean existeGasto = particularValidator.existeGasto(numGasto);
		boolean existeCodMotivoRechazo = particularValidator.existeMotivoRechazoGasto(motivoRechazo);

		if(!existeGasto){
			mapaErrores.get(messageServices.getMessage(CHECK_GASTO_EXIST)).add(fila);
			return false;
		}
		
		if(!COD_RECH.equals(autorizaRechaza) && !COD_APR.equals(autorizaRechaza)){
			mapaErrores.get(messageServices.getMessage(CHECK_COD_APR_RECH_INCORRECTO)).add(fila);
			return false;
		}

		if(COD_RECH.equals(autorizaRechaza) && motivoRechazo == null) {
			mapaErrores.get(messageServices.getMessage(CHECK_MOTIVO_RECHAZO_INFORMADO)).add(fila);
			return false;
		} else if(COD_RECH.equals(autorizaRechaza) && motivoRechazo != null && !existeCodMotivoRechazo) {
			mapaErrores.get(messageServices.getMessage(CHECK_MOTIVO_RECHAZO_INFORMADO)).add(fila);
			return false;
		}

		if(!particularValidator.tieneDocumentoGasto(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_SIN_DOCUMENTO)).add(fila);
			return false;
		}

		if(!particularValidator.tieneFacturaGasto(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_SIN_FACTURA)).add(fila);
			return false;
		}

		if(!particularValidator.tieneLineaDetalleGasto(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_SIN_LINEA_DET)).add(fila);
			return false;
		}
		
		if(!particularValidator.tieneGastoLineaDetalleEntidades(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_OBL_ACT_X_LINEA)).add(fila);
			return false;
		}

		if(!particularValidator.tieneTipoGasto(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_SIN_TIPO)).add(fila);
			return false;
		}

		if(!particularValidator.tieneEmisorGasto(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_SIN_EMISOR)).add(fila);
			return false;
		}

		if(!particularValidator.tienePropietarioGasto(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_SIN_PROPIETARIO)).add(fila);
			return false;
		}

		if(!particularValidator.tieneFechaEmisionGasto(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_SIN_FECHA_EMISIÓN)).add(fila);
			return false;
		}

		if(!particularValidator.tieneTipoOperacionGasto(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_SIN_TIPO_OPERACION)).add(fila);
			return false;
		}

		if(!particularValidator.tienePeriodicidadGasto(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_SIN_TIPO_PERIODICIDAD)).add(fila);
			return false;
		}

		if(!particularValidator.tieneConceptoGasto(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_SIN_CONCEPTO)).add(fila);
			return false;
		}

		if(!particularValidator.tieneImporteGasto(numGasto)){
			mapaErrores.get(messageServices.getMessage(CHECK_SIN_IMPORTE)).add(fila);
			return false;
		}

		if(particularValidator.estaEstadoNoPermitidoGasto(numGasto, "04") || particularValidator.estaEstadoNoPermitidoGasto(numGasto, "06")
				|| particularValidator.estaEstadoNoPermitidoGasto(numGasto, "07")){
			mapaErrores.get(messageServices.getMessage(CHECK_GASTO_RET)).add(fila);
			return false;
		}

		return true;
	}

	private void generarMapaErrores() {
		mapaErrores = new HashMap<String,List<Integer>>();

		mapaErrores.put(messageServices.getMessage(CHECK_GASTO_EXIST), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_COD_APR_RECH_INCORRECTO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_MOTIVO_RECHAZO_INFORMADO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_DOCUMENTO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_FACTURA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_LINEA_DET), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_TIPO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_SUBTIPO), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_EMISOR), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_PROPIETARIO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_FECHA_EMISIÓN), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_TIPO_OPERACION), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_TIPO_PERIODICIDAD), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_CONCEPTO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_IMPORTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_SIN_IMPUESTO_IND), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_OBL_ACT_X_LINEA), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_CUENTA_CONTABLE_OBL_BBVA), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_OBL_CART_UNICAJA), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_CUENTA_Y_PARTIDA), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_RECH_SIN_PROPIETARIO), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_GASTO_RET), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_GASTO_AGRUPADO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_GASTO_CARTERA_TANGO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_GASTO_RECHAZADO_PROPIETARIO), new ArrayList<Integer>());

		//AUTORIZAR
		mapaErrores.put(messageServices.getMessage(CHECK_AUT_SIN_ACTIVOS_O_CONT_CAIXA), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_AUT_NO_FECHA_DEVENGO_LIVINGCENTER), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_AUT_SIN_ID_ABONADO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_AUT_SIN_NIF_TITULAR_LIVINGCENTER), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_AUT_SUPLIDO_SIN_PRINCIPAL), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_AUT_SUPLIDO_SIN_SUPLIDOS_VINC), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_AUT_SUPLIDO_SIN_DATOS_PAGO_PRINCIPAL), new ArrayList<Integer>());//

		//RECHAZO
		mapaErrores.put(messageServices.getMessage(CHECK_RECH_GASTO_REFACTURADO), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_RECH_GASTO_YA_RECHAZADO), new ArrayList<Integer>());//
		mapaErrores.put(messageServices.getMessage(CHECK_RECH_GASTOS_NO_AUT_ADMON), new ArrayList<Integer>());//


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

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
		
}
