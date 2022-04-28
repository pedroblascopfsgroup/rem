package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
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
public class MSVAgrupacionObraNuevaExcelValidator extends MSVExcelValidatorAbstract {
	
	public static final String ACTIVE_NOT_SHARING_PLACE = "Todos los activos no comparten la misma PROVINCIA, MUNICIPIO, CP y CARTERA.";
	public static final class ACTIVOS_NO_MISMA_LOCALIZACION { static int codigoError = 1; static String mensajeError = "msg.error.masivo.agrupar.activos.obranueva.activos.agrupacion.diferente.localizacion";};
	public static final String ACTIVO_NO_EXISTE = "msg.error.masivo.agrupar.activos.asistida.activo.noExiste";
	public static final String ACTIVO_EN_AGRUPACION = "msg.error.masivo.agrupar.activos.asistida.activo.enAgrupacion";
	public static final String ACTIVO_EN_OTRA_AGRUPACION = "msg.error.masivo.agrupar.activos.asistida.activo.enOtraAgrupacion";
	public static final String ERROR_ACTIVO_DISTINTO_PROPIETARIO = "msg.error.masivo.agrupar.activos.propietarios.no.coinciden";
	public static final String ERROR_AGRUPACION_DND = "msg.error.masivo.agrupar.activos.proyecto.dnd";
	
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
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	private Integer numFilasHoja;

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
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
			// Validaciones de grupo, para todos los activos de una agrupacion en el excel:
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), activesNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_EN_AGRUPACION), activosEnAgrupacionRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_EN_OTRA_AGRUPACION), activosEnOtraAgrupacionRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVOS_NO_MISMA_LOCALIZACION.mensajeError), activosAgrupMultipleValidacionRows(exc, ACTIVOS_NO_MISMA_LOCALIZACION.codigoError));
			//mapaErrores.put(messageServices.getMessage(ERROR_ACTIVO_DISTINTO_PROPIETARIO), comprobarDistintoPropietario(exc));
			mapaErrores.put(messageServices.getMessage(ERROR_AGRUPACION_DND), isAgrupacionONDnd(exc));
			
			if (!mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_EN_AGRUPACION)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_EN_OTRA_AGRUPACION)).isEmpty() 
					|| !mapaErrores.get(messageServices.getMessage(ACTIVOS_NO_MISMA_LOCALIZACION.mensajeError)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ERROR_AGRUPACION_DND)).isEmpty()) {

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
	
	
	// Comprobaciones para todos los activos de una misma agrupacion indicada en el excel (no existente en BBDD todavia): ---
	
		/**
		 * Recorre la lista excel para validar los grupos de activos que conforman cada agrupacion
		 * La validacion que ejecuta la que se indique por parametro y devolvera una lista de erores
		 * con las agrupaciones que tengan algun activo que no cumpla con la validacion
		 * @param exc Una hoja excel con datos, del tipo MSVHojaExcel
		 * @return
		 */
		private List<Integer> activosAgrupMultipleValidacionRows(MSVHojaExcel exc, int codigoValidacionMultiple) {
			List<Integer> listaFilasError = new ArrayList<Integer>();
			List<Long> listaNumAgrupaciones = new ArrayList<Long>();

			String inSqlGrupoActivos = new String();

			try{
				
				
				// Se recorre todo el excel para extraer las distintas agrupaciones en una lista
				for(int a=1; a<this.numFilasHoja; a++){
					listaNumAgrupaciones.add(Long.parseLong(exc.dameCelda(a, 0)));
				}
				// Se toman precauciones para crear una lista con agrupaciones unicas,
				Set<Long> uniqueSetNumAgrupaciones =  new HashSet<Long>(listaNumAgrupaciones); 
				List<Long> uniqueListNumAgrupaciones = new ArrayList<Long>(uniqueSetNumAgrupaciones);
				
				// Se recorre todo el excel para crear un Hashmap clave: numAgrup, valores: List<Long> numActivo
				// Se recorre varias veces, 1 vez por cada numAgrup, para buscar en todo el excel, todos los numActivo relacionados
				HashMap<Long,List<Long>> numActivosNumAgrup = new HashMap<Long,List<Long>>();
				// Por cada agrupacion
				for(Long numAgrupacion : uniqueListNumAgrupaciones){
					// Se recorre el excel en busca de activos
					List<Long> numActivos = new ArrayList<Long>();
					for(int a=1; a<this.numFilasHoja; a++){
						// Si es una fila de la agrupacion que se esta evaluando, se anota el activo
						if(numAgrupacion.equals(Long.parseLong(exc.dameCelda(a, 0))))
							numActivos.add(Long.parseLong(exc.dameCelda(a, 1)));				
					}
					numActivosNumAgrup.put(numAgrupacion, numActivos);
				}

				// Se recorre toda la lista de agrupaciones unica, para procesar por la validacion los activos de cada agrup.
				for(Long numAgrupacion : uniqueListNumAgrupaciones){
					if(!Checks.esNulo(numActivosNumAgrup.get(numAgrupacion))){
						
						//Genera en un String separados por comas, los num activos encontrados para la agrupacion
						inSqlGrupoActivos = serializaFiltroInListaSql(numActivosNumAgrup.get(numAgrupacion));

						// Busca en BBDD si la agrupacion pudiera ya tener activos asociados y extrae 1 de ellos
						String inSqlActivosEnAgrupacion = particularValidator.getOneNumActivoAgrupacionRaw(String.valueOf(numAgrupacion));
						if(!Checks.esNulo(inSqlActivosEnAgrupacion)) 
							inSqlGrupoActivos = inSqlGrupoActivos.concat(",").concat(inSqlActivosEnAgrupacion);
						
						// Lanza la validacion para el grupo completo de num activos de la agrupacion (BBDD+excel), con un filtro IN de SQL
						// La validacion que se lanza es la que se ha indicado por parametro, solo se lanza 1 de ellas.						
						
						// Validacion misma localizacion
						if(codigoValidacionMultiple == ACTIVOS_NO_MISMA_LOCALIZACION.codigoError &&
								!particularValidator.esActivosMismaLocalizacion(inSqlGrupoActivos))
							listaFilasError.add(getNumPrimeraFilaAgrupacionError(exc, numAgrupacion));

					}
				}

			} catch (Exception e) {
				listaFilasError.add(0);
				logger.error(e.getMessage());
				e.printStackTrace();
			}
			
			return listaFilasError;
	}
		
	private String serializaFiltroInListaSql(List<Long> listaNumeros){
		String listaSerializadaFiltroSql = new String();
		
		int i=0;
		while(i<(listaNumeros.size()-1)){
			listaSerializadaFiltroSql = listaSerializadaFiltroSql.concat(String.valueOf(listaNumeros.get(i))).concat(", ");
			i++;
		}
		if (i <= listaNumeros.size()){
			listaSerializadaFiltroSql = listaSerializadaFiltroSql.concat(String.valueOf(listaNumeros.get(i)));
		}
		return listaSerializadaFiltroSql;
	}
	
	private Integer getNumPrimeraFilaAgrupacionError(MSVHojaExcel exc, Long numAgrupacion){
		Integer numFilaError = null;
		
		// Recorre de nuevo el excel, en busca de la fila en la que se encuentra el primer caso de la agrupacion
		// para agregar el texto
		int a=1;
		Boolean filaEncontrada = false;
		try {
			while (a<this.numFilasHoja && !filaEncontrada){
				if(numAgrupacion.equals(Long.parseLong(exc.dameCelda(a, 0)))){
					// En el excel, Agrega un texto de validacion en la primera fila de cada agrupacion
					numFilaError = a;
					filaEncontrada = true;
				}
				a++;
			}
		} catch (NumberFormatException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return numFilaError;
	}	
	
	// Validaciones para activos de la lista excel	
	private List<Integer> activesNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosEnAgrupacionRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		Long numActivo;
		Long numAgrupacion;
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				numAgrupacion = Long.parseLong(exc.dameCelda(i, 0));
				numActivo = Long.parseLong(exc.dameCelda(i, 1));
				if(particularValidator.esActivoEnAgrupacion(numActivo, numAgrupacion))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}

	private List<Integer> activosEnOtraAgrupacionRows(MSVHojaExcel exc) {
		
		List<Integer> listaFilas = new ArrayList<Integer>();
		Long numActivo;
		Long numAgrupacion;
		
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				numAgrupacion = Long.parseLong(exc.dameCelda(i, 0));
				numActivo = Long.parseLong(exc.dameCelda(i, 1));
				//Valida que el activo no este en una agrupacion de obra nueva(01) o que ya este en una asistida(13)
				if(particularValidator.esActivoEnOtraAgrupacionNoCompatible(numActivo, numAgrupacion, "01,13"))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}		

	private List<Integer> comprobarDistintoPropietario(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for (i = 1; i < this.numFilasHoja; i++) {
				String numAgrupacion = String.valueOf(Long.parseLong(exc.dameCelda(i, 0)));
				String numActivo = String.valueOf(Long.parseLong(exc.dameCelda(i, 1)));
				if (particularValidator.comprobarDistintoPropietario(numActivo, numAgrupacion))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0)
				listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}	

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
	
	private List<Integer> isAgrupacionONDnd(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for (i = 1; i < this.numFilasHoja; i++) {
				if (particularValidator.isAgrupacionONDnd(Long.parseLong(exc.dameCelda(i, 0))))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0)
				listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}
	
}
