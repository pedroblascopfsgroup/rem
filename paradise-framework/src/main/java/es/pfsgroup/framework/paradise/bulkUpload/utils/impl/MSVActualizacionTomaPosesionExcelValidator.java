package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
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
import org.apache.commons.lang.StringUtils;
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
public class MSVActualizacionTomaPosesionExcelValidator extends MSVExcelValidatorAbstract {

	private static final String CHECK_ACTIVO_VALIDO = "msg.error.masivo.posesion.err.activo.no.valido";
	private static final String CHECK_TIPO_ADJ = "msg.error.masivo.posesion.err.tipo.adjudicacion.erronea";
	private static final String CHECK_F_TITULO = "msg.error.masivo.posesion.err.fecha.titulo";
	private static final String CHECK_F_FIRMEZA = "msg.error.masivo.posesion.err.fecha.firmeza.titulo";
	private static final String CHECK_VALOR_ADQ = "msg.error.masivo.posesion.err.valor.asquisicion";
	private static final String CHECK_NOMBRE = "msg.error.masivo.posesion.err.nombre";
	private static final String CHECK_NUM_EXP = "msg.error.masivo.posesion.err.numero.expediente";
	private static final String CHECK_EXP_DEFECTOS = "msg.error.masivo.posesion.err.expediente.con.defectos";
	private static final String CHECK_ENT_EJEC_HIPO = "msg.error.masivo.posesion.err.entidad.ejec.hipotecaria";
	private static final String CHECK_EST_ADJ = "msg.error.masivo.posesion.err.estado.adjudicacion"; 
	private static final String CHECK_F_AUTOADJ = "msg.error.masivo.posesion.err.fecha.autoadjudicacion";
	private static final String CHECK_F_FIRMEZA_AUTOADJ = "msg.error.masivo.posesion.err.fecha.firmeza.autoadjudicacion";
	private static final String CHECK_F_SENYAL_ADJ = "msg.error.masivo.posesion.err.fecha.senyal.adjudicacion";
	private static final String CHECK_F_REALIZ_POS = "msg.error.masivo.posesion.err.fecha.realizacion.posesion";
	private static final String CHECK_LANZ_NECESARIO = "msg.error.masivo.posesion.err.lanzamiento.necesario";
	private static final String CHECK_F_SENYAL_LANZ = "msg.error.masivo.posesion.err.fecha.senyal.lanzamiento";
	private static final String CHECK_F_LANZ_EFECTUADO = "msg.error.masivo.posesion.err.fecha.lanzamiento.efectuado";
	private static final String CHECK_F_SOL_MORATORIA = "msg.error.masivo.posesion.err.fecha.solicitud.moratoria";
	private static final String CHECK_RES_MORATORIA = "msg.error.masivo.posesion.err.resolucion.moratoria";
	private static final String CHECK_F_RES_MORATORIA = "msg.error.masivo.posesion.err.fecha.resolucion.moratoria";
	private static final String CHECK_IMPORTE_ADJ = "msg.error.masivo.posesion.err.importe.adjudicacion";
	private static final String CHECK_TIPO_JUZGADO = "msg.error.masivo.posesion.err.tipo.juzgado";
	private static final String CHECK_POBLACION_JUZGADO = "msg.error.masivo.posesion.err.poblacion.juzgado";
	private static final String CHECK_NUM_AUTOS = "msg.error.masivo.posesion.err.numero.autos";
	private static final String CHECK_PROCURADOR = "msg.error.masivo.posesion.err.procurador";
	private static final String CHECK_LETRADO = "msg.error.masivo.posesion.err.letrado";
	private static final String CHECK_ID_ASUNTOS = "msg.error.masivo.posesion.err.id.asuntos";
	private static final String CHECK_EXP_JUD_DEFECTO = "msg.error.masivo.posesion.err.expendiente.judicial.con.defecto";
	
	private static final String CHECK_CONTIENE_JUDICIAL = "msg.error.masivo.posesion.err.contiene.judicial";
	private static final String CHECK_CONTIENE_NOTARIAL = "msg.error.masivo.posesion.err.contiene.notarial";
	
	private static final int FILA_DATOS = 1;

	private static final int NUM_COLS = 28;

	private static final int COL_ID_ACTIVO = 0;
	private static final int COL_TIPO_ADJ = 1;
	private static final int COL_F_TITULO = 2;
	private static final int COL_F_FIRMEZA_TITULO = 3;
	private static final int COL_VALOR_ADQ = 4;
	private static final int COL_NOMBRE = 5;
	private static final int COL_NUM_EXP = 6;
	private static final int COL_EXP_DEFECTOS = 7;
	private static final int COL_ENT_EJEC_HIPOTECARIA = 8;
	private static final int COL_EST_ADJ = 9;
	private static final int COL_F_AUTOADJ = 10;
	private static final int COL_F_FIRMEZA_AUTOADJ = 11;
	private static final int COL_F_SENYAL_ADJ = 12;
	private static final int COL_F_REALIZ_POS = 13;
	private static final int COL_LANZ_NECESARIO = 14;
	private static final int COL_F_SENYAL_LANZ = 15;
	private static final int COL_F_LANZ_EFECTUADO= 16;
	private static final int COL_F_SOL_MORATORIA = 17;
	private static final int COL_RES_MORATORIA = 18;
	private static final int COL_F_RES_MORATORIA = 19;
	private static final int COL_IMPORTE_ADJ = 20;
	private static final int COL_TIPO_JUZGADO = 21;
	private static final int COL_POBLACION_JUZGADO = 22;
	private static final int COL_NUM_AUTOS = 23;
	private static final int COL_PROCURADOR = 24;
	private static final int COL_LETRADO = 25;
	private static final int COL_ID_ASUNTOS = 26;
	private static final int COL_EXP_JUD_DEFECTO = 27;
	
	
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

	private Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
	private ArrayList<ArrayList<Integer>> listasError = new ArrayList<ArrayList<Integer>>();
	
	private ArrayList<Integer> errAdj = new ArrayList<Integer>();
	private ArrayList<Integer> errJudicial = new ArrayList<Integer>();
	private ArrayList<Integer> errNotarial = new ArrayList<Integer>();
	
	
	
	private int[] columnasNotariales = {
			 COL_F_TITULO,
			 COL_F_FIRMEZA_TITULO,
			 COL_VALOR_ADQ,
			 COL_NOMBRE,
			 COL_NUM_EXP,
			 COL_EXP_DEFECTOS,	 
	};
	
	private int[] columnasJudiciales = {
			 COL_ENT_EJEC_HIPOTECARIA,
			 COL_EST_ADJ,
			 COL_F_AUTOADJ,
			 COL_F_FIRMEZA_AUTOADJ,
			 COL_F_SENYAL_ADJ,
			 COL_F_REALIZ_POS,
			 COL_LANZ_NECESARIO,
			 COL_F_SENYAL_LANZ,
			 COL_F_LANZ_EFECTUADO,
			 COL_F_SOL_MORATORIA,
			 COL_RES_MORATORIA,
			 COL_F_RES_MORATORIA,
			 COL_IMPORTE_ADJ,
			 COL_TIPO_JUZGADO,
			 COL_POBLACION_JUZGADO,
			 COL_NUM_AUTOS,
			 COL_PROCURADOR,
			 COL_LETRADO,
			 COL_ID_ASUNTOS,
			 COL_EXP_JUD_DEFECTO
	};
	
	

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();

		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVActualizacionTomaPosesionExcelValidator::validarContenidoFichero -> idTipoOperacion no puede ser null");
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
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		if (!dtoValidacionContenido.getFicheroTieneErrores() && !validarFichero(exc)) {
			dtoValidacionContenido.setFicheroTieneErrores(true);
			dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
		}
		exc.cerrar();
		return dtoValidacionContenido;
	}

	private boolean validarFichero(MSVHojaExcel exc) {
		boolean esCorrecto = true;
		ArrayList<Integer> errList = null;
		
		String[] listaValidos = { "SI", "NO" };
		String[] listaResMoratoria = { "01", "02" };
		String[] listaEstAdj = { "01", "02", "03" };
		
		String celda;
		
		errAdj.clear();
		errJudicial.clear();
		errNotarial.clear();		

		for (int columna = 0; columna < NUM_COLS; columna++) {
			listasError.add(columna, new ArrayList<Integer>());
		}

		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
				for (int columna = 0; columna < NUM_COLS; columna++) {
					errList = listasError.get(columna);
					celda = exc.dameCelda(fila, columna);
					boolean valorOK = true;

					switch (columna) {
					
					case COL_ID_ACTIVO:
						valorOK = !Checks.esNulo(celda) && particularValidator.existeActivo(celda) && !particularValidator.esActivoBankia(celda);
						break;

					case COL_TIPO_ADJ:								
						valorOK = !Checks.esNulo(celda) && checkAdjudicacion(fila, celda, exc) && checkAdjudicacionCorrecta(fila, exc);
						break;
						
					case COL_F_TITULO:
					case COL_F_FIRMEZA_TITULO:
					case COL_F_AUTOADJ:
					case COL_F_FIRMEZA_AUTOADJ:
					case COL_F_SENYAL_ADJ:				
					case COL_F_REALIZ_POS:
					case COL_F_SENYAL_LANZ:
					case COL_F_LANZ_EFECTUADO:
					case COL_F_SOL_MORATORIA:
					case COL_F_RES_MORATORIA:
						valorOK = Checks.esNulo(celda) || esBorrar(celda) || esFechaValida(celda);
						break;
						
					case COL_EXP_JUD_DEFECTO:
					case COL_LANZ_NECESARIO:	
					case COL_EXP_DEFECTOS:						
						valorOK = Checks.esNulo(celda) || esBorrar(celda) || Arrays.asList(listaValidos).contains(celda.toUpperCase());						
						break;
					
					case COL_VALOR_ADQ:
					case COL_IMPORTE_ADJ:
						valorOK = Checks.esNulo(celda) || esBorrar(celda) || esNumericoDecimal(celda);
						break;
					
					case COL_ID_ASUNTOS:
						valorOK = Checks.esNulo(celda) || esBorrar(celda) || StringUtils.isNumeric(celda);
						break;
									
					case COL_EST_ADJ:						
						valorOK = Checks.esNulo(celda) || esBorrar(celda) || Arrays.asList(listaEstAdj).contains(celda);				
						break;
						
					case COL_RES_MORATORIA:						
						valorOK = Checks.esNulo(celda) || esBorrar(celda) || Arrays.asList(listaResMoratoria).contains(celda);						
						break;
						
					case COL_ENT_EJEC_HIPOTECARIA:
						valorOK = Checks.esNulo(celda) || esBorrar(celda)  || particularValidator.existeEntidadHipotecaria(celda);						
						break;
					
					case COL_TIPO_JUZGADO:
						valorOK = Checks.esNulo(celda) || esBorrar(celda)  || particularValidator.existeTipoJuzgado(celda);						
						break;
						
					case COL_POBLACION_JUZGADO:
						valorOK = Checks.esNulo(celda) || esBorrar(celda)  || particularValidator.existePoblacionJuzgado(celda);						
						break;
						
					case COL_NUM_EXP:	
					case COL_NOMBRE:				
					case COL_NUM_AUTOS:
					case COL_PROCURADOR:
					case COL_LETRADO:
						valorOK = true;
						break;

					}

					if (!valorOK && COL_TIPO_ADJ != columna) {
						errList.add(fila);
						esCorrecto = false;
					} else if (!valorOK && COL_TIPO_ADJ == columna) {
						esCorrecto = false;
					}

				}

			} catch (ParseException e) {
				esCorrecto = false;
				errList.add(fila);
				logger.error(e.getMessage());
			} catch (Exception e) {
				esCorrecto = false;
				errList.add(0);
				logger.error(e.getMessage());
			}
		}
		
		if (!esCorrecto) {				
			mapaErrores.put(messageServices.getMessage(CHECK_ACTIVO_VALIDO), listasError.get(COL_ID_ACTIVO));
			mapaErrores.put(messageServices.getMessage(CHECK_F_TITULO), listasError.get(COL_F_TITULO));
			mapaErrores.put(messageServices.getMessage(CHECK_F_FIRMEZA), listasError.get(COL_F_FIRMEZA_TITULO));
			mapaErrores.put(messageServices.getMessage(CHECK_VALOR_ADQ), listasError.get(COL_VALOR_ADQ));
			mapaErrores.put(messageServices.getMessage(CHECK_NOMBRE), listasError.get(COL_NOMBRE));
			mapaErrores.put(messageServices.getMessage(CHECK_NUM_EXP), listasError.get(COL_NUM_EXP));
			mapaErrores.put(messageServices.getMessage(CHECK_EXP_DEFECTOS), listasError.get(COL_EXP_DEFECTOS));
			mapaErrores.put(messageServices.getMessage(CHECK_ENT_EJEC_HIPO), listasError.get(COL_ENT_EJEC_HIPOTECARIA));
			mapaErrores.put(messageServices.getMessage(CHECK_EST_ADJ), listasError.get(COL_EST_ADJ));
			mapaErrores.put(messageServices.getMessage(CHECK_F_AUTOADJ), listasError.get(COL_F_AUTOADJ));
			mapaErrores.put(messageServices.getMessage(CHECK_F_FIRMEZA_AUTOADJ), listasError.get(COL_F_FIRMEZA_AUTOADJ));
			mapaErrores.put(messageServices.getMessage(CHECK_F_SENYAL_ADJ), listasError.get(COL_F_SENYAL_ADJ));
			mapaErrores.put(messageServices.getMessage(CHECK_F_REALIZ_POS), listasError.get(COL_F_REALIZ_POS));
			mapaErrores.put(messageServices.getMessage(CHECK_LANZ_NECESARIO), listasError.get(COL_LANZ_NECESARIO));
			mapaErrores.put(messageServices.getMessage(CHECK_F_SENYAL_LANZ), listasError.get(COL_F_SENYAL_LANZ));
			mapaErrores.put(messageServices.getMessage(CHECK_F_LANZ_EFECTUADO), listasError.get(COL_F_LANZ_EFECTUADO));
			mapaErrores.put(messageServices.getMessage(CHECK_F_SOL_MORATORIA), listasError.get(COL_F_SOL_MORATORIA));
			mapaErrores.put(messageServices.getMessage(CHECK_RES_MORATORIA), listasError.get(COL_RES_MORATORIA));
			mapaErrores.put(messageServices.getMessage(CHECK_F_RES_MORATORIA), listasError.get(COL_F_RES_MORATORIA));
			mapaErrores.put(messageServices.getMessage(CHECK_IMPORTE_ADJ), listasError.get(COL_IMPORTE_ADJ));
			mapaErrores.put(messageServices.getMessage(CHECK_TIPO_JUZGADO), listasError.get(COL_TIPO_JUZGADO));
			mapaErrores.put(messageServices.getMessage(CHECK_POBLACION_JUZGADO), listasError.get(COL_POBLACION_JUZGADO));
			mapaErrores.put(messageServices.getMessage(CHECK_NUM_AUTOS), listasError.get(COL_NUM_AUTOS));
			mapaErrores.put(messageServices.getMessage(CHECK_PROCURADOR), listasError.get(COL_PROCURADOR));
			mapaErrores.put(messageServices.getMessage(CHECK_LETRADO), listasError.get(COL_LETRADO));
			mapaErrores.put(messageServices.getMessage(CHECK_ID_ASUNTOS), listasError.get(COL_ID_ASUNTOS));
			mapaErrores.put(messageServices.getMessage(CHECK_EXP_JUD_DEFECTO), listasError.get(COL_EXP_JUD_DEFECTO));
			
			mapaErrores.put(messageServices.getMessage(CHECK_TIPO_ADJ), errAdj);
			mapaErrores.put(messageServices.getMessage(CHECK_CONTIENE_NOTARIAL), errJudicial);
			mapaErrores.put(messageServices.getMessage(CHECK_CONTIENE_JUDICIAL), errNotarial);
						
		}
		return esCorrecto;
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
	
	private boolean checkAdjudicacionCorrecta(int fila,  MSVHojaExcel exc) {
		boolean respuesta = true;
		try {
			String numActivo = exc.dameCelda(fila, COL_ID_ACTIVO);
			String tipoAdjudicacion = exc.dameCelda(fila, COL_TIPO_ADJ);
			
			if ("01".equals(tipoAdjudicacion) && !particularValidator.verificaTipoDeAdjudicacion(numActivo, tipoAdjudicacion)) {
				errJudicial.add(fila);
				respuesta = false;

				
			}else if("02".equals(tipoAdjudicacion) && !particularValidator.verificaTipoDeAdjudicacion(numActivo, tipoAdjudicacion)){
				errNotarial.add(fila);
				respuesta = false;
			}
		}catch (Exception e){
			logger.error(e.getMessage());
			respuesta = false;
		}
		return respuesta;
	}
	
	private boolean checkAdjudicacion(int fila, String codigo, MSVHojaExcel exc) {
		try {
			// 01 judicial			
			if (codigo.equals("01")) {
				for (int i = 0; i < columnasNotariales.length; i++) {
					if (!Checks.esNulo(exc.dameCelda(fila, columnasNotariales[i]))) {	
						errJudicial.add(fila);
						return false;
					} 
				}
				return true;
			// 02 notarial
			} else if (codigo.equals("02")) {
				for (int i = 0; i < columnasJudiciales.length; i++) {
					if (!Checks.esNulo(exc.dameCelda(fila, columnasJudiciales[i]))) {
						errNotarial.add(fila);
						return false;
					} 
				}
				return true;
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			return false;			
		}
		errAdj.add(fila);
		return false;

	}
	
	private boolean esBorrar(String cadena) {
		return cadena.toUpperCase().trim().equals("X");
	}
	
	private boolean esFechaValida(String fecha) {
		Integer yearSize = getLengthOfYear(fecha);
		return !(!Checks.esNulo(fecha) && (yearSize == null || yearSize > 4));
	}

	private Integer getLengthOfYear(String date) {
		Integer yearSize = null;
		if (date != null) {
			String[] dateArray = date.split("\\/");
			String year = dateArray == null ? null : dateArray[dateArray.length - 1];
			yearSize = year == null ? null : year.length();
		}
		return yearSize;
	}
	
	private boolean esNumericoDecimal(String numero) {
		return  numero.matches("^[-+]?[0-9]*[,.]?[0-9]+");
	}
	
}
