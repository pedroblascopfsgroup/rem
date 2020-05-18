package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
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
public class MSVTacticoEspartaPublicacionesValidator extends MSVExcelValidatorAbstract {
		
	public static final String NUM_ACTIVO_NO_EXISTE = "El número del activo no existe.";
	public static final String NUM_ACTIVO_NO_PERTENECE_A_SAREB = "El número del activo no pertenece a SAREB.";
	
	//Mensajes de errores de los campos de fechas
	public static final String FECHA_TAPIADO_ERROR = "El formato de la fecha del campo 'Fecha tapiado' debe de ser: dd/mm/yyyy.";
	public static final String FECHA_COLOCACION_PUERTA_ANTIOCUPA_ERROR = "El formato de la fecha del campo 'Fecha colocación puerta antiocupa' debe de ser: dd/mm/yyyy.";
	public static final String FECHA_DE_INSCRIPCION_ERROR = "El formato de la fecha del campo 'Fecha de inscripción' debe de ser: dd/mm/yyyy.";
	public static final String FECHA_POSESION_ERROR = "El formato de la fecha del campo 'Fecha de posesión' debe de ser: dd/mm/yyyy.";
	public static final String FECHA_TITULO_ERROR = "El formato de la fecha del campo 'Fecha de título' debe de ser: dd/mm/yyyy.";
	
	//Mensajes de errores de los campos booleanos
	public static final String ACTIVO_INSCRITO_DIVISION_HORIZONTAL_ERROR = "El campo 'Activo inscrito en división horizontal' solo puede estar rellenado con 'S' para si y 'N' para no.";
	public static final String TAPIADO_ERROR = "El campo 'Tapiado' solo puede estar rellenado con 'S' para si y 'N' para no.";
	public static final String PUERTA_ANTIOCUPA_ERROR = "El campo 'Puerta anti ocupa' solo puede estar rellenado con 'S' para si y 'N' para no.";
	public static final String VPO_ERROR = "El campo 'VPO' solo puede estar rellenado con 'S' para si y 'N' para no.";
	public static final String OCUPADO_ERROR = "El campo 'Ocupado' solo puede estar rellenado con 'S' para si y 'N' para no.";
	public static final String CON_TITULO_ERROR = "El campo 'Con título' solo puede estar rellenado con 'S' para si y 'N' para no.";
	public static final String CON_CARGAS_ERROR = "El campo 'Con cargas' solo puede estar rellenado con 'S' para si y 'N' para no.";
	public static final String INFORME_COMERCIAL_APROBADO_ERROR = "El campo 'Informe comercial aprobado' solo puede estar rellenado con 'S' para si y 'N' para no.";
	
	
	
	
	
	public static final String CON_TITULO_NO_PUEDE_ESTAR_VACIO = "El campo 'Con título' no puede estar vacío si el campo 'Ocupado' está a si.";
	public static final String FECHA_TAPIADO_NO_PUEDE_ESTAR_VACIO = "El campo 'Fecha tapiado' tiene que estar rellenado con el formato 'dd/mm/yyyy' si el campo 'Tapiado' está a si.";
	public static final String FECHA_COLOCACION_PUERTA_ANTIOCUPA_NO_PUEDE_ESTAR_VACIO = "El campo 'Fecha colocación puerta antiocupa' tiene que estar rellenado con el formato 'dd/mm/yyyy' si el campo 'Puerta antiocupa' está a si.";
	public static final String FECHA_TAPIADO_NO_PUEDE_SER_SUPERIOR_A_LA_ACTUAL = "El campo 'Fecha tapiado' no puede ser superior a la fecha actual.";
	public static final String FECHA_COLOCACION_PUERTA_ANTIOCUPA_NO_PUEDE_SER_SUPERIOR_A_LA_ACTUAL = "El campo 'Fecha colocación puerta antiocupa' no puede ser superior a la fecha actual.";
	public static final String FECHA_INSCRIPCION_NO_PUEDE_SER_SUPERIOR_A_LA_ACTUAL = "El campo 'Fecha de inscripción' no puede ser superior a la fecha actual.";
	public static final String FECHA_INSCRIPCION_TIENE_QUE_SER_SUPERIOR_A_FECHA_TITULO = "El campo 'Fecha de inscripción' tiene que ser superior al campo 'Fecha título'.";
	public static final String FECHA_TITULO_NO_PUEDE_SER_SUPERIOR_A_LA_ACTUAL = "El campo 'Fecha título' no puede ser superior a la fecha actual.";
	public static final String ESTADO_FISICO_DEL_ACTIVO_NO_EXISTE = "El campo 'Estado físico del activo' no existe.";
	public static final String SITUACION_DEL_TITULO_NO_EXISTE = "El campo 'Situación del título' no existe.";
	
	public static final Integer COL_NUM_ACTIVO = 0;
	public static final Integer COL_ESTADO_FISICO_DEL_ACTIVO = 1;
	public static final Integer COL_ACTIVO_INSCRITO_DIVISION_HORIZONTAL = 2;
	public static final Integer COL_TAPIADO = 3;
	public static final Integer COL_FECHA_TAPIADO = 4;
	public static final Integer COL_PUERTA_ANTIOCUPA = 5;
	public static final Integer COL_FECHA_COLOCACION_PUERTA_ANTIOCUPA = 6;
	public static final Integer COL_VPO = 7;
	public static final Integer COL_OCUPADO = 8;
	public static final Integer COL_CON_TITULO = 9;
	public static final Integer COL_CON_CARGAS = 10;
	public static final Integer COL_INFORME_COMERCIAL_APROBADO = 11;
	public static final Integer COL_FECHA_DE_INSCRIPCION = 12;
	public static final Integer COL_FECHA_POSESION = 13;
	public static final Integer COL_SITUACION_TITULO = 14;
	public static final Integer COL_FECHA_TITULO = 15;
	private static final String[] listaValidos = { "S", "N", "SI", "NO" };
	private static final String[] listaValidosPositivos = { "S", "SI" };
	
	
	
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
			mapaErrores.put(NUM_ACTIVO_NO_EXISTE, isNumActivoNotExistsRows(exc));
			mapaErrores.put(NUM_ACTIVO_NO_PERTENECE_A_SAREB, isActivoSareb(exc));
			
			
			mapaErrores.put(FECHA_TAPIADO_ERROR, isFechaValidator(exc, COL_FECHA_TAPIADO));
			mapaErrores.put(FECHA_COLOCACION_PUERTA_ANTIOCUPA_ERROR, isFechaValidator(exc, COL_FECHA_COLOCACION_PUERTA_ANTIOCUPA));
			mapaErrores.put(FECHA_DE_INSCRIPCION_ERROR, isFechaValidator(exc, COL_FECHA_DE_INSCRIPCION));
			mapaErrores.put(FECHA_POSESION_ERROR, isFechaValidator(exc, COL_FECHA_POSESION));
			mapaErrores.put(FECHA_TITULO_ERROR, isFechaValidator(exc, COL_FECHA_TITULO));
			
			
			mapaErrores.put(ACTIVO_INSCRITO_DIVISION_HORIZONTAL_ERROR, isBooleanValidator(exc, COL_ACTIVO_INSCRITO_DIVISION_HORIZONTAL));
			mapaErrores.put(TAPIADO_ERROR, isBooleanValidator(exc, COL_TAPIADO));
			mapaErrores.put(PUERTA_ANTIOCUPA_ERROR, isBooleanValidator(exc, COL_PUERTA_ANTIOCUPA));
			mapaErrores.put(VPO_ERROR, isBooleanValidator(exc, COL_VPO));
			mapaErrores.put(OCUPADO_ERROR, isBooleanValidator(exc, COL_OCUPADO));
			mapaErrores.put(CON_TITULO_ERROR, perteneceDiccionarioDDTipoTitulo(exc, COL_CON_TITULO));
			mapaErrores.put(CON_CARGAS_ERROR, isBooleanValidator(exc, COL_CON_CARGAS));
			mapaErrores.put(INFORME_COMERCIAL_APROBADO_ERROR, isBooleanValidator(exc, COL_INFORME_COMERCIAL_APROBADO));
			
			
			mapaErrores.put(CON_TITULO_NO_PUEDE_ESTAR_VACIO, isOcupadoAndNotTitulo(exc));
			mapaErrores.put(FECHA_TAPIADO_NO_PUEDE_ESTAR_VACIO, isTapiadoAndNotFechaTapiado(exc));
			mapaErrores.put(FECHA_COLOCACION_PUERTA_ANTIOCUPA_NO_PUEDE_ESTAR_VACIO, isPuertaAntiocupaAndNotFechaColocacion(exc));
			mapaErrores.put(FECHA_TAPIADO_NO_PUEDE_SER_SUPERIOR_A_LA_ACTUAL, isFechaMenorActual(exc, COL_FECHA_TAPIADO));
			mapaErrores.put(FECHA_COLOCACION_PUERTA_ANTIOCUPA_NO_PUEDE_SER_SUPERIOR_A_LA_ACTUAL, isFechaMenorActual(exc, COL_FECHA_COLOCACION_PUERTA_ANTIOCUPA));
			mapaErrores.put(FECHA_INSCRIPCION_NO_PUEDE_SER_SUPERIOR_A_LA_ACTUAL, isFechaMenorActual(exc, COL_FECHA_DE_INSCRIPCION));
			mapaErrores.put(FECHA_INSCRIPCION_TIENE_QUE_SER_SUPERIOR_A_FECHA_TITULO, isFechaInscripcionMayorFechaTitulo(exc, COL_FECHA_DE_INSCRIPCION, COL_FECHA_TITULO));
			mapaErrores.put(FECHA_TITULO_NO_PUEDE_SER_SUPERIOR_A_LA_ACTUAL, isFechaMenorActual(exc, COL_FECHA_TITULO));
			mapaErrores.put(ESTADO_FISICO_DEL_ACTIVO_NO_EXISTE, existeEstadoFisicoActivo(exc, COL_ESTADO_FISICO_DEL_ACTIVO));
			mapaErrores.put(SITUACION_DEL_TITULO_NO_EXISTE, existeSituacionTitulo(exc, COL_SITUACION_TITULO));

			if (!mapaErrores.get(NUM_ACTIVO_NO_EXISTE).isEmpty() 
					|| !mapaErrores.get(NUM_ACTIVO_NO_PERTENECE_A_SAREB).isEmpty()
					|| !mapaErrores.get(ACTIVO_INSCRITO_DIVISION_HORIZONTAL_ERROR).isEmpty()
					|| !mapaErrores.get(TAPIADO_ERROR).isEmpty()
					|| !mapaErrores.get(PUERTA_ANTIOCUPA_ERROR).isEmpty()
					|| !mapaErrores.get(VPO_ERROR).isEmpty()
					|| !mapaErrores.get(OCUPADO_ERROR).isEmpty()
					|| !mapaErrores.get(CON_TITULO_ERROR).isEmpty()
					|| !mapaErrores.get(CON_CARGAS_ERROR).isEmpty()
					|| !mapaErrores.get(INFORME_COMERCIAL_APROBADO_ERROR).isEmpty()
					|| !mapaErrores.get(CON_TITULO_NO_PUEDE_ESTAR_VACIO).isEmpty()
					|| !mapaErrores.get(FECHA_TAPIADO_NO_PUEDE_ESTAR_VACIO).isEmpty()
					|| !mapaErrores.get(FECHA_COLOCACION_PUERTA_ANTIOCUPA_NO_PUEDE_ESTAR_VACIO).isEmpty()
					|| !mapaErrores.get(FECHA_TAPIADO_NO_PUEDE_SER_SUPERIOR_A_LA_ACTUAL).isEmpty()
					|| !mapaErrores.get(FECHA_COLOCACION_PUERTA_ANTIOCUPA_NO_PUEDE_SER_SUPERIOR_A_LA_ACTUAL).isEmpty()
					|| !mapaErrores.get(FECHA_INSCRIPCION_NO_PUEDE_SER_SUPERIOR_A_LA_ACTUAL).isEmpty()
					|| !mapaErrores.get(FECHA_INSCRIPCION_TIENE_QUE_SER_SUPERIOR_A_FECHA_TITULO).isEmpty()
					|| !mapaErrores.get(FECHA_TITULO_NO_PUEDE_SER_SUPERIOR_A_LA_ACTUAL).isEmpty()
					|| !mapaErrores.get(ESTADO_FISICO_DEL_ACTIVO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(SITUACION_DEL_TITULO_NO_EXISTE).isEmpty()
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
	
	private boolean esBorrar(String cadena) {
		return cadena.toUpperCase().trim().equals("X");
	}
	
	private boolean esFechaMenorActualValidator(String fecha, Date fechaActual) throws ParseException {
		Date fechaExcel = null;
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
		
		fechaExcel = formato.parse(fecha);
		
		return fechaExcel.before(fechaActual);
	}
	
	private List<Integer> isNumActivoNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_ACTIVO)) && Boolean.FALSE.equals(particularValidator.existeActivo(exc.dameCelda(i, COL_NUM_ACTIVO))))
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
	
	private List<Integer> isActivoSareb(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_ACTIVO)) && Boolean.FALSE.equals(particularValidator.esActivoSareb(exc.dameCelda(i, COL_NUM_ACTIVO))))
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
	
	private List<Integer> isOcupadoAndNotTitulo(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     
                     if(Checks.esNulo(exc.dameCelda(i, COL_CON_TITULO)) 
                             && !Checks.esNulo(exc.dameCelda(i, COL_OCUPADO))
                             && Arrays.asList(listaValidosPositivos).contains(exc.dameCelda(i, COL_OCUPADO).toUpperCase()))
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
	
	private List<Integer> isTapiadoAndNotFechaTapiado(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     
                     if(!Checks.esNulo(exc.dameCelda(i, COL_TAPIADO))
                             && Arrays.asList(listaValidosPositivos).contains(exc.dameCelda(i, COL_TAPIADO).toUpperCase())
                             && (Checks.esNulo(exc.dameCelda(i, COL_FECHA_TAPIADO)) 
                            		 || esBorrar(exc.dameCelda(i, COL_FECHA_TAPIADO))))
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
	
	private List<Integer> isPuertaAntiocupaAndNotFechaColocacion(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     
                     if(!Checks.esNulo(exc.dameCelda(i, COL_PUERTA_ANTIOCUPA))
                             && Arrays.asList(listaValidosPositivos).contains(exc.dameCelda(i, COL_PUERTA_ANTIOCUPA).toUpperCase())
                             && (Checks.esNulo(exc.dameCelda(i, COL_FECHA_COLOCACION_PUERTA_ANTIOCUPA)) 
                            		 || esBorrar(exc.dameCelda(i, COL_FECHA_COLOCACION_PUERTA_ANTIOCUPA))))
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
	
	private List<Integer> isFechaMenorActual(MSVHojaExcel exc, Integer col){
        List<Integer> listaFilas = new ArrayList<Integer>();
        Date fechaActual = new Date();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                	 String celda = exc.dameCelda(i, col);
                     
                     if(!Checks.esNulo(celda)
                             && !esBorrar(celda)
                             && esFechaValida(celda)
                             && !esFechaMenorActualValidator(celda, fechaActual))
                    	 
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
	
	private List<Integer> isFechaInscripcionMayorFechaTitulo(MSVHojaExcel exc, Integer colFechaInscripcion, Integer colFechaTitulo){
        List<Integer> listaFilas = new ArrayList<Integer>();

    		Date fechaInscripcion = null;
    		Date fechaTitulo = null;
    		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                	String celdaFechaInscripcion = exc.dameCelda(i, colFechaInscripcion);
                	String celdaFechaTitulo = exc.dameCelda(i, colFechaTitulo);
                	
                	if(esBorrar(celdaFechaInscripcion) || esBorrar(celdaFechaTitulo)) {
                		 return listaFilas; 
                	}else {
                	if(celdaFechaInscripcion != null && !celdaFechaInscripcion.isEmpty() 
                			&& celdaFechaTitulo != null && !celdaFechaTitulo.isEmpty()
                			&& !esBorrar(celdaFechaInscripcion) && !esBorrar(celdaFechaTitulo)) {
                		fechaInscripcion = formato.parse(celdaFechaInscripcion);
                		fechaTitulo = formato.parse(celdaFechaTitulo);                		
                	}
                	
                     
                     if(!Checks.esNulo(celdaFechaInscripcion)
                             && esFechaValida(celdaFechaInscripcion)
                             && !Checks.esNulo(celdaFechaTitulo)
                             && esFechaValida(celdaFechaTitulo)
                             && !fechaInscripcion.after(fechaTitulo))
                    	 
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
	
	private List<Integer> existeEstadoFisicoActivo(MSVHojaExcel exc, Integer col){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                	 String celda = exc.dameCelda(i, col);
                	 
                     if(!Checks.esNulo(celda)  
                             && Boolean.FALSE.equals(particularValidator.perteneceDDEstadoActivo(celda)))
                    	 
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
	
	private List<Integer> existeSituacionTitulo(MSVHojaExcel exc, Integer col){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                	 String celda = exc.dameCelda(i, col);
                	 
                     if(!Checks.esNulo(celda)  
                             && Boolean.FALSE.equals(particularValidator.existeSituacionTitulo(celda)))
                    	 
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
		if(esBorrar(fecha))
			return true;
		try {
			SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
			ft.parse(fecha);
		} catch (ParseException e) {
			logger.error(e.getMessage());
			return false;
		}
		return true;
	}
		
	private List<Integer> perteneceDiccionarioDDTipoTitulo(MSVHojaExcel exc, Integer col) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		 try{
			for(int i=1; i<this.numFilasHoja;i++){ 
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_CON_TITULO)) && !particularValidator.perteneceADiccionarioConTitulo(exc.dameCelda(i, COL_CON_TITULO))){
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
	
}
