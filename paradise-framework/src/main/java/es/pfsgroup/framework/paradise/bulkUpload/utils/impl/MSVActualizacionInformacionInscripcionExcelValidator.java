package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
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
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVControlTributosExcelValidator.COL_NUM;

@Component
public class MSVActualizacionInformacionInscripcionExcelValidator extends MSVExcelValidatorAbstract {
		
	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		static final int NUM_COLS = 8;
		static final int ACT_NUM_ACTIVO = 0;
		static final int SITUACION_TITULO = 1;
		static final int FECHA_ENTREGA_TITULO_GESTORIA = 2;
		static final int FECHA_PRESENTACION_HACIENDA = 3;
		static final int FECHA_INSCRIPCION_REGISTRO = 4;
		static final int FECHA_RETIRADA_REGISTRO = 5;
		static final int FECHA_NOTA_SIMPLE = 6;
		static final int ACCION = 7;
		
	};

	static final String situacionTramitacion = "01";
	static final String situacionInscrito = "02";
	static final String situacionSubsanar = "06";

	static final String accionAnyadir = "01";
	static final String accionModificar = "03";
	static final String accionBorrar = "02";

	public static final String ACTIVO_NO_EXISTE = "El activo debe existir.";
	public static final String ACTIVO_ACCION_NO_PERMITIDA = "No se puede realizar la acción indicada con el activo solicitado.";
	public static final String ACCION_NO_EXISTE = "La acción no existe o no es válida.";
	public static final String ACTIVO_CARTERA_BANKIA = "El activo pertenece a la cartera bankia.";
	public static final String SITUACION_TITULO_NO_EXISTE = "La situación de titulo no existe o no es válida.";
	public static final String FORMATO_FECHA_ENTREGA_TITULO_INVALIDO = "La fecha de entrega de titulo no contiene un formato válido.";
	public static final String FORMATO_FECHA_PRESENTACION_INVALIDO = "La fecha de presentación no contiene un formato válido.";
	public static final String FORMATO_FECHA_INSCRIPCION_INVALIDO = "La fecha de inscripción no contiene un formato válido.";
	public static final String FORMATO_FECHA_RETIRADA_INVALIDO = "La fecha de retirada no contiene un formato válido.";
	public static final String FORMATO_FECHA_NOTA_SIMPLE_INVALIDO = "La fecha nota simple no contiene un formato válido.";
	public static final String FECHA_INSCRIPCION_OBLIGATORIA = "La fecha de inscripción es obligatoria para los activos con estado inscrito.";
	
	public static final String CODIGO_FASES_PUBLICACION = "CMIN";

	Map<String, List<Integer>> mapaErrores;
	
	private List<Integer> listaErroresActivoNoExiste;
	private List<Integer> listaErroresActivoAccionNoValida;
	private List<Integer> listaErroresFechaInscripcionObligatoria;
	
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
		
		if (!dtoValidacionContenido.getFicheroTieneErrores() && !ValidarConjunto(exc)) {
			
			
					dtoValidacionContenido.setFicheroTieneErrores(true);
					dtoValidacionContenido
							.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
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
	
	private File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}

	private boolean ValidarConjunto(MSVHojaExcel exc) {
		boolean esCorrecto = true;
		mapaErrores = new HashMap<String, List<Integer>>();
		ArrayList<ArrayList<Integer>> listasError = new ArrayList<ArrayList<Integer>>();
		ArrayList<Integer> errList = null;
		listaErroresActivoNoExiste = new ArrayList<Integer>();
		listaErroresActivoAccionNoValida = new ArrayList<Integer>();
		listaErroresFechaInscripcionObligatoria = new ArrayList<Integer>();
		String celda;
		
		for(int columna = 0; columna < COL_NUM.NUM_COLS; columna++) {
			listasError.add(columna, new ArrayList<Integer>());
		}
		
		for(int fila = COL_NUM.DATOS_PRIMERA_FILA; fila < this.numFilasHoja; fila++) {
			try {
				
				Boolean existeActivo = particularValidator.existeActivo(exc.dameCelda(fila, COL_NUM.ACT_NUM_ACTIVO));
				Boolean existeActivoTitulo = particularValidator.existeActivoTitulo(exc.dameCelda(fila, COL_NUM.ACT_NUM_ACTIVO));
				Boolean existeAccion = particularValidator.esAccionValido(exc.dameCelda(fila, COL_NUM.ACCION));
				Boolean esCarteraNoBankia = particularValidator.existeActivoNoBankia(exc.dameCelda(fila, COL_NUM.ACT_NUM_ACTIVO));
				if (existeActivo && existeAccion) {

					String codAccion = exc.dameCelda(fila, COL_NUM.ACCION);
					// --------------------------VALIDACION-----------------------------// 
					// ----------------------------AÑADIR-------------------------------//
					if (accionAnyadir.equals(codAccion)) {
						for (int columna = 0; columna < COL_NUM.NUM_COLS; columna++) {
							errList = listasError.get(columna);
							celda = exc.dameCelda(fila, columna);
							boolean valorOK = true;
							
							switch(columna) {
							case COL_NUM.ACT_NUM_ACTIVO:
								if(existeActivoTitulo) {
									listaErroresActivoAccionNoValida.add(fila);
									esCorrecto = false;
								}
								valorOK = esCarteraNoBankia;
								break;
								
							case COL_NUM.SITUACION_TITULO:
								if(!Checks.esNulo(celda)){
									valorOK = particularValidator.existeEstadoTitulo(celda);
									String celdaFechaInscipcion = exc.dameCelda(fila, COL_NUM.FECHA_INSCRIPCION_REGISTRO);
									if(situacionInscrito.equals(celda) && !esFechaValida(celdaFechaInscipcion, false)) {
										listaErroresFechaInscripcionObligatoria.add(fila);
										esCorrecto = false;
									}
								}								
								break;
								
							case COL_NUM.FECHA_ENTREGA_TITULO_GESTORIA:
							case COL_NUM.FECHA_INSCRIPCION_REGISTRO:
							case COL_NUM.FECHA_NOTA_SIMPLE:
							case COL_NUM.FECHA_PRESENTACION_HACIENDA:
							case COL_NUM.FECHA_RETIRADA_REGISTRO:
								valorOK = Checks.esNulo(celda) || esFechaValida(celda, false);
								break;
							}
							
							if(!valorOK) {
								errList.add(fila);
								esCorrecto = false;
							}
						}
					} 
					// --------------------------VALIDACION-----------------------------// 
					// ----------------------------BORRAR-------------------------------//
					else if (accionBorrar.equals(codAccion)) {
						if (!existeActivoTitulo) {
							listaErroresActivoAccionNoValida.add(fila);
							esCorrecto = false;
						}

						if (!esCarteraNoBankia) {
							errList = listasError.get(COL_NUM.ACT_NUM_ACTIVO);
							errList.add(fila);
							esCorrecto = false;
						}
					}
					// --------------------------VALIDACION-----------------------------//
					// --------------------------MODIFICAR------------------------------//
					else if (accionModificar.equals(codAccion)) {
						for (int columna = 0; columna < COL_NUM.NUM_COLS; columna++) {
							errList = listasError.get(columna);
							celda = exc.dameCelda(fila, columna);
							boolean valorOK = true;
							
							switch(columna) {
							case COL_NUM.ACT_NUM_ACTIVO:
								if(!existeActivoTitulo) {
									listaErroresActivoAccionNoValida.add(fila);
									esCorrecto = false;
								}
								valorOK = esCarteraNoBankia;
								break;
								
							case COL_NUM.SITUACION_TITULO:
								if(!Checks.esNulo(celda) && !esEquis(celda)){
									valorOK = particularValidator.existeEstadoTitulo(celda);
									String celdaFechaInscipcion = exc.dameCelda(fila, COL_NUM.FECHA_INSCRIPCION_REGISTRO);
									if(situacionInscrito.equals(celda) && !esFechaValida(celdaFechaInscipcion, false)) {
										listaErroresFechaInscripcionObligatoria.add(fila);
										esCorrecto = false;
									}
								}
								break;
								
							case COL_NUM.FECHA_ENTREGA_TITULO_GESTORIA:
							case COL_NUM.FECHA_INSCRIPCION_REGISTRO:
							case COL_NUM.FECHA_NOTA_SIMPLE:
							case COL_NUM.FECHA_PRESENTACION_HACIENDA:
							case COL_NUM.FECHA_RETIRADA_REGISTRO:
								valorOK = Checks.esNulo(celda) || esFechaValida(celda, true);								
								break;
							}
							
							if(!valorOK) {
								errList.add(fila);
								esCorrecto = false;
							}
						
						}
					}
				} else {
					if (!existeActivo) {
						listaErroresActivoNoExiste.add(fila);
						esCorrecto = false;
					}
					if (!existeAccion) {
						errList = listasError.get(COL_NUM.ACCION);
						errList.add(fila);
						esCorrecto = false;
					}
				}
			} catch (ParseException e) {
				if (errList == null) {
					errList = listasError.get(0);
				}
				errList.add(fila);
				logger.error(e.getMessage());
				esCorrecto = false;
			} catch (Exception e) {
				if (errList == null) {
					errList = listasError.get(0);
				}
				errList.add(0);
				logger.error(e.getMessage());
				esCorrecto = false;
			}
		}
		if (!esCorrecto) {
			mapaErrores.put(ACTIVO_NO_EXISTE, listaErroresActivoNoExiste);
			mapaErrores.put(ACTIVO_ACCION_NO_PERMITIDA, listaErroresActivoAccionNoValida);
			mapaErrores.put(ACCION_NO_EXISTE, listasError.get(COL_NUM.ACCION));
			mapaErrores.put(ACTIVO_CARTERA_BANKIA, listasError.get(COL_NUM.ACT_NUM_ACTIVO));
			mapaErrores.put(SITUACION_TITULO_NO_EXISTE, listasError.get(COL_NUM.SITUACION_TITULO));
			mapaErrores.put(FORMATO_FECHA_ENTREGA_TITULO_INVALIDO, listasError.get(COL_NUM.FECHA_ENTREGA_TITULO_GESTORIA));
			mapaErrores.put(FORMATO_FECHA_PRESENTACION_INVALIDO, listasError.get(COL_NUM.FECHA_PRESENTACION_HACIENDA));
			mapaErrores.put(FORMATO_FECHA_INSCRIPCION_INVALIDO, listasError.get(COL_NUM.FECHA_INSCRIPCION_REGISTRO));
			mapaErrores.put(FORMATO_FECHA_RETIRADA_INVALIDO, listasError.get(COL_NUM.FECHA_RETIRADA_REGISTRO));
			mapaErrores.put(FORMATO_FECHA_NOTA_SIMPLE_INVALIDO, listasError.get(COL_NUM.FECHA_NOTA_SIMPLE));
			mapaErrores.put(FECHA_INSCRIPCION_OBLIGATORIA, listaErroresFechaInscripcionObligatoria);
		}
		
		return esCorrecto;
		
	}
	
	private boolean esFechaValida(String fecha, boolean modificar) {
		
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		if(!Checks.esNulo(fecha)) {
			if (modificar && esEquis(fecha)) {
				return esEquis(fecha);
			}
			try {
				ft.parse(fecha);
			} catch (ParseException e) {
				logger.error(e.getMessage());
				return false;
			}
			return true;
		}
		return false;
	}
	
	private boolean esEquis(String cadena) {
		return cadena.trim().equalsIgnoreCase("X");
	}
}

