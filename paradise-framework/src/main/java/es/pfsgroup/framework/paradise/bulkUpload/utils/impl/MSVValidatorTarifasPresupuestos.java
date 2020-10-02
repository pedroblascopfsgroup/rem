package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.text.ParseException;
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
public class MSVValidatorTarifasPresupuestos extends MSVExcelValidatorAbstract {

	//ERRORES
	private final static String ERROR_TRABAJO_NO_EXISTE = "msg.error.masivo.tarifa.presupuesto.trabajo.no.existe";
	private final static String ERROR_TIPO_REGISTRO="msg.error.masivo.tarifa.presupuesto.tipo.registro.incorrecto";
	private final static String ERROR_TIPO_INCORRECTO_INFORMADO_TARIFA = "msg.error.masivo.tarifa.presupuesto.tipo.incorrecto.tarifa";
	private final static String ERROR_TIPO_INCORRECTO_INFORMADO_PRESUPUESTO = "msg.error.masivo.tarifa.presupuesto.tipo.incorrecto.presupuesto";
	private final static String ERROR_FALTAN_CAMPOS = "msg.error.masivo.tarifa.presupuesto.faltan.campos";
	private final static String ERROR_PROVEEDOR_NO_COINCIDE = "msg.error.masivo.tarifa.presupuesto.proveedor.no.coincide";
	private final static String ERROR_NO_EXISTE_CONFIGURACION_TARIFA="msg.error.masivo.tarifa.presupuesto.no.existe.configuracion.tarifa";
	private final static String ERROR_ESTADO_TRABAJO_INCORRECTO_TARIFA="msg.error.masivo-tarifa.presupuesto.estado.trabajo.incorrecto.tarifa";
	private final static String ERROR_ESTADO_TRABAJO_INCORRECTO_PRESUPUESTO="msg.error.masivo-tarifa.presupuesto.estado.trabajo.incorrecto.presupuesto";
	
	
	//CAMPOS
	private final static int FILA_DATOS = 1;
	private final static int NUM_COLS_ITER = 2; // Total de iteraciones
	private final static int COL_NUM_TRABAJO = 0;
	private final static int COL_TIPO_REGISTRO = 1;
	private final static int COL_COD_TARIFA = 2;
	private final static int COL_UNIDADES = 3;
	private final static int COL_COD_PROVEEDOR = 4;
	private final static int COL_REF_PRESUPUESTO = 5;
	private final static int COL_FECHA = 6;
	private final static int COL_IMPORTE = 7;
	private final static String TIPO_TARIFA = "TRF";
	private final static String TIPO_PRESUPUESTO = "PRS";
	private final static String CODIGO_ESTADO_FINALIZADO = "FIN";
	private final static String CODIGO_ESTADO_EN_CURSO = "CUR";
	
	private Integer numFilasHoja;
	private Map<String, List<Integer>> mapaErrores;
	private boolean validado = true;
	protected final Log logger = LogFactory.getLog(getClass());
	
	@Resource
	private MessageService messageServices;

	@Autowired
	private MSVExcelParser excelParser;

	@Autowired
	private MSVBusinessValidationRunner validationRunner;

	@Autowired
	private ParticularValidatorApi particularValidator;

	@Autowired
	private MSVProcesoApi msvProcesoApi;

	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();

		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVActualizacionDocAdministrativaExcelValidator::validarContenidoFichero -> idTipoOperacion no puede ser null");
		}

		List<String> lista = recuperarFormato(idTipoOperacion);
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(idTipoOperacion));
		MSVBusinessCompositeValidators compositeValidators = validationFactory
				.getCompositeValidators(getTipoOperacion(idTipoOperacion));
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(idTipoOperacion));
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators,
				compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(idTipoOperacion);

		// Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		// Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		if (!dtoValidacionContenido.getFicheroTieneErrores() && !validarFichero(exc)) {
			dtoValidacionContenido.setFicheroTieneErrores(true);
			dtoValidacionContenido
					.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
		}
		exc.cerrar();
		return dtoValidacionContenido;
	}

	private boolean validarFichero(MSVHojaExcel exc) {
		mapaErrores = new HashMap<String, List<Integer>>();
		
		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			
			try {
				for (int columna = 0; columna < NUM_COLS_ITER; columna++) {
					String celda = exc.dameCelda(fila, columna);
					boolean valorOK = true;
					switch (columna) {
					case COL_NUM_TRABAJO:
						valorOK = particularValidator.existeTrabajo(celda);
						if (valorOK) {
							String codigoEstadoTrabajo = particularValidator.getEstadoTrabajoByNumTrabajo(celda);
							
							if (!CODIGO_ESTADO_FINALIZADO.equals(codigoEstadoTrabajo)
									&& !CODIGO_ESTADO_EN_CURSO.equals(codigoEstadoTrabajo)) {
								this.validado = false;
								if (TIPO_TARIFA.equals(exc.dameCelda(fila, COL_TIPO_REGISTRO))) {
									addErrorToMap(ERROR_ESTADO_TRABAJO_INCORRECTO_TARIFA, fila);
									
								} else if (TIPO_TARIFA.equals(exc.dameCelda(fila, COL_TIPO_REGISTRO))) {
									addErrorToMap(ERROR_ESTADO_TRABAJO_INCORRECTO_PRESUPUESTO, fila);
									
								}
							}
						} else {
							this.validado = false;
							addErrorToMap(ERROR_TRABAJO_NO_EXISTE, fila);
						}
						break;
					case COL_TIPO_REGISTRO:
						valorOK = TIPO_TARIFA.equals(celda) || TIPO_PRESUPUESTO.equals(celda);
						if (valorOK) {
							doValidationAccordingType(celda, exc, fila);
						}else {
							this.validado = false;
							addErrorToMap(ERROR_TIPO_REGISTRO, fila);
						}
						break;
					}
					
					
				}
			} catch (ParseException e) {
				logger.error(e.getMessage());
			} catch (Exception e) {
				logger.error(e.getMessage());
			}
		}
		
		return this.validado;
	}

	private void doValidationAccordingType(String tipo, MSVHojaExcel exc, int fila) {
		try {
			String codigoTarifa = exc.dameCelda(fila, COL_COD_TARIFA);
			String unidades = exc.dameCelda(fila, COL_UNIDADES);
			String codProveedor = exc.dameCelda(fila, COL_COD_PROVEEDOR);
			String refPresupuesto = exc.dameCelda(fila, COL_REF_PRESUPUESTO);
			String fecha = exc.dameCelda(fila, COL_FECHA);
			String importe = exc.dameCelda(fila, COL_IMPORTE);
			
			if (TIPO_TARIFA.equals(tipo)) {
				if (codigoTarifa == null || unidades == null || codigoTarifa.isEmpty() || unidades.isEmpty()) {
					this.validado = false;
					addErrorToMap(ERROR_FALTAN_CAMPOS, fila);
				}
				if ((codProveedor != null && !codProveedor.isEmpty()) 
					|| (refPresupuesto != null && !refPresupuesto.isEmpty())
					|| (fecha != null && !fecha.isEmpty()) 
					|| (importe != null && !importe.isEmpty())) {
					this.validado = false;
					addErrorToMap(ERROR_TIPO_INCORRECTO_INFORMADO_TARIFA, fila);
				}
				if (!particularValidator.isTipoTarifaValidoEnConfiguracion(codigoTarifa, exc.dameCelda(fila, COL_NUM_TRABAJO))) {
					this.validado = false;
					addErrorToMap(ERROR_NO_EXISTE_CONFIGURACION_TARIFA, fila);
				}
			}else if (TIPO_PRESUPUESTO.equals(tipo)) {
				if ( (codigoTarifa != null && !codigoTarifa.isEmpty()) || (unidades != null && !unidades.isEmpty())) {
					this.validado = false;
					addErrorToMap(ERROR_TIPO_INCORRECTO_INFORMADO_PRESUPUESTO, fila);
				}
				if ((codProveedor == null || codProveedor.isEmpty()) 
					|| (refPresupuesto == null || refPresupuesto.isEmpty())
					|| (fecha == null || fecha.isEmpty()) 
					|| (importe == null || importe.isEmpty())) {
					this.validado = false;
					addErrorToMap(ERROR_FALTAN_CAMPOS, fila);
				}
				if ( (codProveedor != null && !codProveedor.isEmpty()) 
				&& !particularValidator.existeMismoProveedorContactoInformado(codProveedor, exc.dameCelda(fila, COL_NUM_TRABAJO))) {
					this.validado = false;
					addErrorToMap(ERROR_PROVEEDOR_NO_COINCIDE, fila);
				}
			}

		} catch (Exception e) {
			mapaErrores.put(e.getMessage(), new ArrayList<Integer>(Arrays.asList(fila)));
			logger.error(e.getMessage());
		}

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
	
	
	private void addErrorToMap(String key, int fila) {
		key = messageServices.getMessage(key);
		if (mapaErrores.containsKey(key)) {
			mapaErrores.get(key).add(fila);
		} else {
			mapaErrores.put(key, new ArrayList<Integer>(Arrays.asList(fila)));
		}
	}

}
