package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
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
public class MSVMasivaDatosSobreGastoValidator extends MSVExcelValidatorAbstract {
	
	private final String ID_NO_EXISTE = "msg.error.masivo.gastos.id.no.existe";
	private final String ID_ENTIDAD_NULO = "msg.error.masivo.gastos.id.entidad.no.existe";
	private final String ID_ALB_NO_EXISTE ="msg.error.masivo.gastos.id.albaran.no.existe";
	private final String ID_PRE_NO_EXISTE = "msg.error.masivo.gastos.id.prefactura.no.existe";
	private final String ESTADO_GASTO_INCORRECTO = "msg.error.masivo.gastos.estado.incorrecto";
	private final String VALIDAR_FILA_EXCEPTION = "msg.error.masivo.gastos.exception";
	private final String FECHA_INCORRECTA = "msg.error.masivo.gastos.exception.fecha";
	private final String FECHAS_VACIAS = "msg.error.masivo.gastos.fechas.vacias";
	private final String SIN_FECHA_CONTABILIZADO = "msg.error.masivo.gastos.exception.gasto.sin.fecha.contabilizado";
	private final String SIN_FECHA_PAGADO = "msg.error.masivo.gastos.exception.gasto.sin.fecha.pagado";
	private final String ENTIDAD_INCORRECTA = "msg.error.masivo.gastos.exception.entidad.incorrecta";
	private final String GASTO_REPETIDO = "msg.error.masivo.gastos.exception.gasto.repetido";
	private final String MENSAJE_CUSTOM = "Estado invalido para el gasto perteneciente a la prefactura: ";
	private final String ID_PRO_NO_EXISTE = "msg.error.masivo.gastos.id.provision.no.existe";
	private final String MENSAJE_CUSTOM_PRG = "msg.error.masivo.gastos.estado.incorrecto.provision";
	

	private final String PAGADO= "05";
	private final String CONTABILIZADO= "04";
	private final String AUTORIZADO_ADMIN= "03";
	private final String NOMENGLATURA_GASTO_UNO = "G";
	private final String NOMENGLATURA_GASTO_DOS = "Gasto";
	private final String NOMENGLATURA_PREFACTURA_DOS = "Prefactura";
	private final String NOMENGLATURA_PREFACTURA_UNO = "P";
	private final String NOMENGLATURA_ALBARAN_UNO = "Albarán";
	private final String NOMENGLATURA_ALBARAN_DOS = "Albaran";
	private final String NOMENGLATURA_ALBARAN_TRES = "A";
	private final String NOMENCLATURA_PROVISION_UNO = "Pro";
	private final String NOMENCLATURA_PROVISION_DOS = "Provisión";
	private final String NOMENCLATURA_PROVISION_TRES = "Provision";

	private final String BORRAR = "X";

	private final String FECHAS_MULTIPLES = "msg.error.masivo.gastos.fechas.multiples";

	
	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int COL_ID_ENTIDAD = 0;
	private final int COL_ENTIDAD = 1;
	private final int COL_FECHA_CONTA = 2;
	private final int COL_FECHA_PAGO = 3;
	
	
	private Integer numFilasHoja;	
	private Map<String, List<Integer>> mapaErrores;	
	private final Log logger = LogFactory.getLog(getClass());

	

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

	
	private void generarMapaErrores() {
		mapaErrores = new HashMap<String, List<Integer>>();
		mapaErrores.put(messageServices.getMessage(ID_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(FECHA_INCORRECTA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(FECHAS_VACIAS), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ESTADO_GASTO_INCORRECTO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(VALIDAR_FILA_EXCEPTION), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(SIN_FECHA_CONTABILIZADO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(SIN_FECHA_PAGADO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ENTIDAD_INCORRECTA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(GASTO_REPETIDO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ID_ALB_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ID_PRE_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ID_ENTIDAD_NULO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ID_PRO_NO_EXISTE), new ArrayList<Integer>());
	}
	
	private void modificarMapaErrores(int fila, String pfa) {
		List<Integer> aux = new ArrayList<Integer>();
		aux.add(fila);
		mapaErrores.put(MENSAJE_CUSTOM+ pfa,aux);
	}
	
	private void modificarMapaErroresProvision(int fila, String provision) {
		List<Integer> aux = new ArrayList<Integer>();
		aux.add(fila);
		mapaErrores.put(messageServices.getMessage(MENSAJE_CUSTOM_PRG).concat(provision),aux);
	}
	
	private boolean validarFichero(MSVHojaExcel exc) {

		boolean esCorrecto = true;
		List<String> listaGastos = new ArrayList<String>();

		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
				List<String> listaEstadosValidos = Arrays.asList(new String[] { AUTORIZADO_ADMIN, PAGADO , CONTABILIZADO });
				String idEntidad = exc.dameCelda(fila, COL_ID_ENTIDAD);
				String entidad = exc.dameCelda(fila, COL_ENTIDAD);
				String fechaConta = exc.dameCelda(fila, COL_FECHA_CONTA);
				String fechaPago = exc.dameCelda(fila, COL_FECHA_PAGO);
				
				List<String> listaEntidades = 
						Arrays.asList(new String[] { NOMENGLATURA_GASTO_UNO.toLowerCase(), NOMENGLATURA_GASTO_DOS.toLowerCase(), 
						NOMENGLATURA_PREFACTURA_DOS.toLowerCase(), NOMENGLATURA_PREFACTURA_UNO.toLowerCase(), NOMENGLATURA_ALBARAN_UNO.toLowerCase(), 
						NOMENGLATURA_ALBARAN_DOS.toLowerCase(), NOMENGLATURA_ALBARAN_TRES.toLowerCase(), NOMENCLATURA_PROVISION_UNO.toLowerCase(),
						NOMENCLATURA_PROVISION_DOS.toLowerCase(), NOMENCLATURA_PROVISION_TRES.toLowerCase()});
				
				if(!listaEntidades.contains(entidad.toLowerCase())) {
					mapaErrores.get(messageServices.getMessage(ENTIDAD_INCORRECTA)).add(fila);
					esCorrecto = false;
				}else {
					if((NOMENGLATURA_GASTO_UNO.equalsIgnoreCase(entidad) || NOMENGLATURA_GASTO_DOS.equalsIgnoreCase(entidad)) && listaGastos.contains(idEntidad)) {
						mapaErrores.get(messageServices.getMessage(GASTO_REPETIDO)).add(fila);
						esCorrecto = false;
					}else {
						if(Checks.esNulo(idEntidad)) {
							mapaErrores.get(messageServices.getMessage(ID_ENTIDAD_NULO)).add(fila);
							esCorrecto = false;
						}else {
							listaGastos.add(idEntidad);
							if(NOMENGLATURA_PREFACTURA_DOS.equalsIgnoreCase(entidad) || NOMENGLATURA_PREFACTURA_UNO.equalsIgnoreCase(entidad)){
								if(!particularValidator.existePrefactura(idEntidad)) {
									mapaErrores.get(messageServices.getMessage(ID_PRE_NO_EXISTE)).add(fila);
									esCorrecto = false;
								}else {
									String estadoGasto = particularValidator.devolverEstadoGastoApartirDePrefactura(idEntidad);
									if(!listaEstadosValidos.contains(estadoGasto)) {
										modificarMapaErrores(fila,idEntidad);
										esCorrecto = false;
									}
								}
							}else if(NOMENGLATURA_ALBARAN_DOS.equalsIgnoreCase(entidad) || NOMENGLATURA_ALBARAN_UNO.equalsIgnoreCase(entidad) || NOMENGLATURA_ALBARAN_TRES.equalsIgnoreCase(entidad)) {
								if(!particularValidator.existeAlbaran(idEntidad)) {
									mapaErrores.get(messageServices.getMessage(ID_ALB_NO_EXISTE)).add(fila);
									esCorrecto = false;
								}else {
									List<String> listaPFA = particularValidator.getIdPrefacturasByNumAlbaran(idEntidad);
									for (String pfa : listaPFA) {
										String estadoGasto = particularValidator.devolverEstadoGastoApartirDePrefactura(pfa);
										if(!listaEstadosValidos.contains(estadoGasto)) {
											modificarMapaErrores(fila,pfa);
											esCorrecto = false;
										}
									}
								}
								
							}else if (NOMENGLATURA_GASTO_DOS.equalsIgnoreCase(entidad) || NOMENGLATURA_GASTO_UNO.equalsIgnoreCase(entidad)) {
								if(!particularValidator.existeGasto(idEntidad)) {
									mapaErrores.get(messageServices.getMessage(ID_NO_EXISTE)).add(fila);
									esCorrecto = false;
								}else {
									if (!this.esCorrectoEstadoGasto(idEntidad)) {
										mapaErrores.get(messageServices.getMessage(ESTADO_GASTO_INCORRECTO)).add(fila);
										esCorrecto = false;
									}
								}
							} else if (NOMENCLATURA_PROVISION_UNO.equalsIgnoreCase(entidad) || NOMENCLATURA_PROVISION_DOS.equalsIgnoreCase(entidad) || NOMENCLATURA_PROVISION_TRES.equalsIgnoreCase(entidad)) {
								if(!particularValidator.existeProvision(idEntidad)) {
									mapaErrores.get(messageServices.getMessage(ID_PRO_NO_EXISTE)).add(fila);
									esCorrecto = false;
								}else {
									List<String> gastos = particularValidator.getGastosByNumProvision(idEntidad);
									for (String gasto : gastos) {
										if (!this.esCorrectoEstadoGasto(gasto)) {
											modificarMapaErroresProvision(fila,idEntidad);
											esCorrecto = false;
										}
									}
								}
							}
							
							if(Checks.esNulo(fechaConta) && Checks.esNulo(fechaPago)) {
								mapaErrores.get(messageServices.getMessage(FECHAS_VACIAS)).add(fila);
								esCorrecto = false;
							}/*else {
								if (!this.comprobarFechas(fechaConta) || !this.comprobarFechas(fechaPago)) {
									mapaErrores.get(messageServices.getMessage(FECHA_INCORRECTA)).add(fila);
									esCorrecto = false;
								}
								//PREGUNTAR QUE PASA SI SON ALBARANES O PREFACTURAS
								if(BORRAR.equalsIgnoreCase(fechaConta) && !particularValidator.tieneGastoFechaContabilizado(idEntidad)) {
									mapaErrores.get(messageServices.getMessage(SIN_FECHA_CONTABILIZADO)).add(fila);
									esCorrecto = false;
								}
								if(BORRAR.equalsIgnoreCase(fechaPago) && !particularValidator.tieneGastoFechaPagado(idEntidad)) {
									mapaErrores.get(messageServices.getMessage(SIN_FECHA_PAGADO)).add(fila);
									esCorrecto = false;
								}
									
							}*/
						}
						
					}
				}



	

			} catch (Exception e) {
				mapaErrores.get(messageServices.getMessage(VALIDAR_FILA_EXCEPTION)).add(fila);
				esCorrecto = false;
				logger.error(e.getMessage());
			}
		}

		return esCorrecto;
	}
	
	

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();

		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVMasivaDatosSobreGastosValidator::validarContenidoFichero -> idTipoOperacion no puede ser null");
		}
		
		List<String> lista = recuperarFormato(idTipoOperacion);
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(idTipoOperacion));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(idTipoOperacion));
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(idTipoOperacion));
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(idTipoOperacion);

		// Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		// Obtenemos el numero de filas reales que tiene la hoja excel a examinar
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
	

	private boolean esCorrectoEstadoGasto(String idGasto) {
		String estadoGasto = particularValidator.devolverEstadoGasto(idGasto);
		List<String> listaEstadosValidos = Arrays.asList(new String[] { AUTORIZADO_ADMIN, PAGADO , CONTABILIZADO });
		if(!listaEstadosValidos.contains(estadoGasto)) {
			return false;
		}
		
		return true;
	}
	
	
	private boolean comprobarFechas(String fecha) {
		
		if(BORRAR.equalsIgnoreCase(fecha) || Checks.esNulo(fecha)) {
			return true;
		}
		
		try {
			SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            formatoFecha.setLenient(false);
            formatoFecha.parse(fecha);
		} catch (ParseException e) {
			return false;
		}
		
		return true;
	}
	
	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
}
