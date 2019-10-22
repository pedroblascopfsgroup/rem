package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
public class MSVSuperDiscPublicacionesExcelValidator extends MSVExcelValidatorAbstract {
	
	private static final String ACTIVO_NO_EXISTE = "msg.error.masivo.disclaimer.activo";
	private static final String ESTADO_ACTIVO_INVALIDO = "msg.error.masivo.disclaimer.estado.fisico";
	private static final String VALORES_NO_VALIDOS_OCUPADO = "msg.error.masivo.disclaimer.ocupado";
	private static final String VALORES_NO_VALIDOS_CON_TITULO = "msg.error.masivo.disclaimer.titulo";
	private static final String VALORES_NO_VALIDOS_TAPIADO = "msg.error.masivo.disclaimer.tapiado";
	private static final String VALORES_NO_VALIDOS_OTROS = "msg.error.masivo.disclaimer.otros";
	private static final String VALORES_NO_VALIDOS_OTROS_MOTIVOS = "msg.error.masivo.disclaimer.motivo.otros";
	private static final String VALORES_ACTIVO_INTEGRADO_NO_VALIDO = "msg.error.masivo.disclaimer.activo.integrado";
	private static final String VALOR_CAMPO_ESTADO_NO_VALIDO = "msg.error.masivo.disclaimer.estado";
	private static final String VALOR_CAMPO_ESTADO_NO_INTEGRADO_NO_VALIDO = "msg.error.masivo.disclaimer.estado.sino.inscrito";	
	
	private	static final int FILA_CABECERA = 0;
	private	static final int DATOS_PRIMERA_FILA = 1;
		
	private	static final int COL_ACTIVO = 0;
	private	static final int COL_ESTADO_FISICO_ACTIVO = 1;
	private	static final int COL_OCUPADO = 2;
	private	static final int COL_CON_TITULO = 3;
	private	static final int COL_ESTADO_TAPIADO = 4;
	private static final int COL_OTROS = 5;
	private static final int COL_OTROS_MOTIVOS = 6;
	private static final int COL_ACTIVO_INTEGRADO = 7;
	private static final int COL_DIVISION_HORIZONTAL_INTEGRADO = 8; //Col. Estado
	private static final int COL_ESTADO_DIVISION_HORIZONTAL = 9; //Col. Estado si no está inscrita
	
	

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
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
	private Integer numFilasHoja;	
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		
		List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recogerPlantilla(dtoFile.getIdTipoOperacion()));
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
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), isActiveNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(ESTADO_ACTIVO_INVALIDO), perteneceDDEstadoActivo(exc));
			mapaErrores.put(messageServices.getMessage(VALORES_NO_VALIDOS_OCUPADO), isOcupadoValorSiNo(exc));
			mapaErrores.put(messageServices.getMessage(VALORES_NO_VALIDOS_CON_TITULO), isConTitulo(exc));
			mapaErrores.put(messageServices.getMessage(VALORES_NO_VALIDOS_TAPIADO), isTapiado(exc));
			mapaErrores.put(messageServices.getMessage(VALORES_NO_VALIDOS_OTROS), valorOtros(exc));
			mapaErrores.put(messageServices.getMessage(VALORES_NO_VALIDOS_OTROS_MOTIVOS), valorOtrosMotivos(exc));
			mapaErrores.put(messageServices.getMessage(VALORES_ACTIVO_INTEGRADO_NO_VALIDO), valorActivoInscrito(exc));
			mapaErrores.put(messageServices.getMessage(VALOR_CAMPO_ESTADO_NO_VALIDO), campoEstado(exc));
			mapaErrores.put(messageServices.getMessage(VALOR_CAMPO_ESTADO_NO_INTEGRADO_NO_VALIDO), campoEstadoNoIntegrado(exc));
			
			Set<String> keySet = mapaErrores.keySet();			
			for (String key : keySet) {				
				if(!Checks.estaVacio(mapaErrores.get(key))) {
					dtoValidacionContenido.setFicheroTieneErrores(true);
					dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
				}
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
	
	/**
	 * Comprueba si el activo existe o esta borrado
	 * @param exc
	 * @return listado filas erroneas
	 */
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String celdaActivo;

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				celdaActivo = exc.dameCelda(i, COL_ACTIVO);
				if (!particularValidator.existeActivo(celdaActivo))
					listaFilas.add(i);
			} catch (ParseException e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}

	/**
	 * Comprueba el estado pertenece al diccionario DD_EAC_ESTADO_ACTIVO
	 * @param exc
	 * @return listado filas erroneas
	 */	
	private List<Integer> perteneceDDEstadoActivo(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String celdaEstadoActivo;

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				celdaEstadoActivo = exc.dameCelda(i, COL_ESTADO_FISICO_ACTIVO);
				if (!particularValidator.perteneceDDEstadoActivo(celdaEstadoActivo))
					listaFilas.add(i);
			} catch (ParseException e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	/**
	 * Comprueba el campo ocupado
	 * @param exc
	 * @return listado filas erroneas
	 */
	private List<Integer> isOcupadoValorSiNo(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaValidos = { "SI", "S", "NO", "N", "@" };
		String celda;

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				celda = exc.dameCelda(i, COL_OCUPADO);
				if (!Arrays.asList(listaValidos).contains(celda.toUpperCase())) {
					listaFilas.add(i);
				}
			} catch (ParseException e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}

	/**
	 * Comprueba el campo conTitulo tiene valor dependiendo del campo ocupado
	 * 
	 * @param exc
	 * @return listado filas erroneas
	 */
	private List<Integer> isConTitulo(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		final String DD_TPA_SI ="01";
		final String DD_TPA_NO ="02";
		final String DD_TPA_NO_CON_INDICIOS ="03";		
		
		String[] listaSi = { "SI", "S" };
		String[] listaNo = { "NO", "N" };
		String celdaOcupado;
		String celdaConTitulo;
		String celdaActivo;
		boolean celdaMal;

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {

			celdaMal = false;

			try {
				celdaOcupado = exc.dameCelda(i, COL_OCUPADO);
				celdaConTitulo = exc.dameCelda(i, COL_CON_TITULO);

				// Comprobar '@' en campo Ocupado
				if (esArroba(celdaOcupado)) {

					if (!esArroba(celdaConTitulo) && !celdaConTitulo.isEmpty()) {
						celdaMal = true;
					}

				} else {
					// Comprobar si el valor es posible
					// Ocupado SI
					if (Arrays.asList(listaSi).contains(celdaOcupado.toUpperCase())) {

						if (Checks.esNulo(celdaConTitulo)
								|| !particularValidator.perteneceDDTipoTituloTPA(celdaConTitulo)
								|| !particularValidator.conTituloOcupadoSi(celdaConTitulo)) {
							celdaMal = true;
						} else {

							// Con titulo es diferente a SI
							if (!celdaConTitulo.equals(DD_TPA_SI)) {

								// comprobar estado de posesion del activo
								celdaActivo = exc.dameCelda(i, COL_ACTIVO);

								if (particularValidator.conPosesion(celdaActivo) && !celdaConTitulo.equals(DD_TPA_NO)) {
									celdaMal = true;
								}

								if (!particularValidator.conPosesion(celdaActivo) && !celdaConTitulo.equals(DD_TPA_NO_CON_INDICIOS)) {
									celdaMal = true;
								}

							}

						}

						// Ocupado NO
					} else if (Arrays.asList(listaNo).contains(celdaOcupado.toUpperCase())) {

						if (!esArroba(celdaConTitulo) && !celdaConTitulo.isEmpty()) {
							celdaMal = true;
						}

					}
				}

				if (celdaMal) {
					listaFilas.add(i);
				}

			} catch (ParseException e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	/**
	 * Comprueba el campo Tapiado
	 * 
	 * @param exc
	 * @return listado filas erroneas
	 */
	private List<Integer> isTapiado(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaValidos = { "SI", "S", "NO", "N" };
		String celdaTapiado;

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				celdaTapiado = exc.dameCelda(i, COL_ESTADO_TAPIADO);
				if (!Arrays.asList(listaValidos).contains(celdaTapiado.toUpperCase())) {
					listaFilas.add(i);
				}

			} catch (ParseException e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	/**
	 * Comprueba el campo Otros
	 * 
	 * @param exc
	 * @return listado filas erroneas
	 */
	private List<Integer> valorOtros(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaValidos = { "SI", "S", "NO", "N" ,"@"};
		String celdaOtros;

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				celdaOtros = exc.dameCelda(i, COL_OTROS);
				if (!Arrays.asList(listaValidos).contains(celdaOtros.toUpperCase())) {
					listaFilas.add(i);
				}

			} catch (ParseException e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	/**
	 * Comprueba el campo Motivo Otros
	 * 
	 * @param exc
	 * @return listado filas erroneas
	 */
	private List<Integer> valorOtrosMotivos(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaValidos = { "SI", "S" };
		String[] listaNo = { "NO", "N" };
		String celdaOtrosMotivos;
		String celdaOtros;
		boolean celdaMal;

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				celdaMal = false;
				celdaOtrosMotivos = exc.dameCelda(i, COL_OTROS_MOTIVOS);
				celdaOtros = exc.dameCelda(i, COL_OTROS);

				if (Arrays.asList(listaValidos).contains(celdaOtros.toUpperCase())
						&& (celdaOtrosMotivos.isEmpty() || esArroba(celdaOtrosMotivos))) {
					celdaMal = true;
				}

				if ((esArroba(celdaOtros) || Checks.esNulo(celdaOtros)) && !Checks.esNulo(celdaOtrosMotivos)
						&& !esArroba(celdaOtrosMotivos)) {
					celdaMal = true;
				}

				if (Arrays.asList(listaNo).contains(celdaOtros.toUpperCase())
						&& (!Checks.esNulo(celdaOtrosMotivos) && !esArroba(celdaOtrosMotivos))) {
					celdaMal = true;
				}

				if (celdaMal) {
					listaFilas.add(i);
				}
			} catch (ParseException e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	/**
	 * Comprueba el campo Activo Integrado
	 * 
	 * @param exc
	 * @return listado filas erroneas
	 */
	private List<Integer> valorActivoInscrito(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaValidos = { "SI", "S", "NO", "N", "@" };
		String celdaActivoIntegrado;

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				celdaActivoIntegrado = exc.dameCelda(i, COL_ACTIVO_INTEGRADO);
				if (!Arrays.asList(listaValidos).contains(celdaActivoIntegrado.toUpperCase())) {
					listaFilas.add(i);
				}

			} catch (ParseException e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	/**
	 * Comprueba el campo Estado
	 * 
	 * @param exc
	 * @return listado filas erroneas
	 */
	private List<Integer> campoEstado(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaValidos = { "INSCRITA", "NO INSCRITA" };
		String[] listaValidosActivoSI = { "SI", "S" };
		String[] listaValidosActivoNO = { "NO", "N", "@" };
		String celdaEstado;
		String celdaActivoIntegrado;
		boolean celdaMal;

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				celdaMal = false;
				celdaEstado = exc.dameCelda(i, COL_DIVISION_HORIZONTAL_INTEGRADO);
				celdaActivoIntegrado = exc.dameCelda(i, COL_ACTIVO_INTEGRADO);

				if (Arrays.asList(listaValidosActivoSI).contains(celdaActivoIntegrado.toUpperCase())
						&& !Arrays.asList(listaValidos).contains(celdaEstado.toUpperCase())) {
					celdaMal = true;
				}
				if ((Arrays.asList(listaValidosActivoNO).contains(celdaActivoIntegrado.toUpperCase())
						|| Checks.esNulo(celdaActivoIntegrado))
						&& (!Checks.esNulo(celdaEstado) && !esArroba(celdaEstado))) {
					celdaMal = true;
				}
				if (!Arrays.asList(listaValidosActivoSI).contains(celdaActivoIntegrado.toUpperCase())
						&& !Arrays.asList(listaValidosActivoNO).contains(celdaActivoIntegrado.toUpperCase())
						&& !Checks.esNulo(celdaActivoIntegrado)) {
					celdaMal = true;
				}

				if (celdaMal) {
					listaFilas.add(i);
				}

			} catch (ParseException e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	/**
	 * Comprueba el campo Estado No Integrado
	 * 
	 * @param exc
	 * @return listado filas erroneas
	 */
	private List<Integer> campoEstadoNoIntegrado(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaValidos = { "NO INSCRITA" };
		String celdaEstado;
		String celdaEstadoNoIntegrado;

		boolean celdaMal;

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				celdaMal = false;
				celdaEstado = exc.dameCelda(i, COL_DIVISION_HORIZONTAL_INTEGRADO);
				celdaEstadoNoIntegrado = exc.dameCelda(i, COL_ESTADO_DIVISION_HORIZONTAL);

				if (Arrays.asList(listaValidos).contains(celdaEstado.toUpperCase())
						&& (!particularValidator.perteneceDDEstadoDivHorizontal(celdaEstadoNoIntegrado))) {
					celdaMal = true;
				}
				if (esArroba(celdaEstado)
						&& (!Checks.esNulo(celdaEstadoNoIntegrado) && !esArroba(celdaEstadoNoIntegrado))) {
					celdaMal = true;
				}
				if (Checks.esNulo(celdaEstado) && !Checks.esNulo(celdaEstadoNoIntegrado)
						&& !esArroba(celdaEstadoNoIntegrado)) {
					celdaMal = true;
				}
				if (!Arrays.asList(listaValidos).contains(celdaEstado.toUpperCase()) && !esArroba(celdaEstado)
						&& !Checks.esNulo(celdaEstado) && !Checks.esNulo(celdaEstadoNoIntegrado)) {
					celdaMal = true;
				}
				if (celdaMal) {
					listaFilas.add(i);
				}

			} catch (ParseException e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	private File recogerPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			logger.error(e.getMessage());
		}
		return null;
	}
	
	private boolean esArroba(String cadena) {
		return cadena.trim().equals("@");
	}
}

