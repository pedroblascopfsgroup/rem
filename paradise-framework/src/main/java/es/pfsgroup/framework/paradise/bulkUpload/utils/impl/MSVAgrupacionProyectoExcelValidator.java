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
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVAgrupacionLoteComercialExcelValidator.ACTIVOS_NO_MISMA_CARTERA;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVAgrupacionObraNuevaExcelValidator.ACTIVOS_NO_MISMA_LOCALIZACION;

@Component
public class MSVAgrupacionProyectoExcelValidator extends MSVExcelValidatorAbstract {

	// Textos de validaciones para cada activo
	public static final String ACTIVO_NO_EXISTE = "msg.error.masivo.agrupar.activos.asistida.activo.noExiste";
	public static final String ACTIVO_EN_AGRUPACION = "msg.error.masivo.agrupar.activos.asistida.activo.enAgrupacion";
	public static final String AGRUPACION_NO_PROYECTO = "msg.error.masivo.agrupar.activos.proyecto.agrupacion.tipo.diferente";
	public static final String ACTIVO_SIN_PROVINCIA = "msg.error.masivo.agrupar.activos.proyecto.activo.sin.provincia";
	public static final String ACTIVO_SIN_MUNICIPIO = "msg.error.masivo.agrupar.activos.proyecto.activo.sin.municipio";
	public static final String ACTIVO_AGRUPACION_CRA = "msg.error.masivo.agrupar.activos.proyecto.activos.agrupacion.diferentes.carteras";
	public static final String ACTIVO_AGRUPACION_LOC = "msg.error.masivo.agrupar.activos.proyecto.activos.agrupacion.diferentes.municipios";
	public static final String ACTIVO_AGRUPACION_PRV = "msg.error.masivo.agrupar.activos.proyecto.activos.agrupacion.diferentes.provincias";
	public static final String ACTIVO_TIENE_AGRUPACION = "msg.error.masivo.agrupar.activos.proyecto.activo.tiene.agrupacion.proyecto";
	public static final String ACTIVO_PERIODO_CONCURRENCIA = "msg.error.masivo.agrupar.activos.concurrencia";
	public static final String ACTIVO_OFERTA_PERIODO_CONCURRENCIA = "msg.error.masivo.agrupar.activos.ofertas.concurrencia";
	public static final String AGRUPACION_PERIODO_CONCURRENCIA = "msg.error.masivo.agrupacion.concurrencia";
	public static final String AGRUPACION_OFERTA_PERIODO_CONCURRENCIA = "msg.error.masivo.agrupacion.ofertas.concurrencia";
	public static final class ACTIVOS_NO_MISMA_CARTERA { static int codigoError = 2; static String mensajeError = "msg.error.masivo.agrupar.activos.asistida.activos.agrupacion.diferente.cartera";};

	protected final Log logger = LogFactory.getLog(getClass());

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

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		
		if (dtoFile.getIdTipoOperacion() == null)
		{
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
		} 
		catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();

			// Validaciones individuales activo por activo:
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), activesNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_PERIODO_CONCURRENCIA), activosEnPeriodoDeConcurrencia(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_OFERTA_PERIODO_CONCURRENCIA), activosConOfertaEnPeriodoDeConcurrencia(exc));
			mapaErrores.put(messageServices.getMessage(AGRUPACION_PERIODO_CONCURRENCIA), agrupacionEnPeriodoDeConcurrencia(exc));
			mapaErrores.put(messageServices.getMessage(AGRUPACION_OFERTA_PERIODO_CONCURRENCIA), agrupacionConOfertaEnPeriodoDeConcurrencia(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_EN_AGRUPACION), activosEnAgrupacionRows(exc));
			mapaErrores.put(messageServices.getMessage(AGRUPACION_NO_PROYECTO), agrupacionNoProyecto(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_SIN_PROVINCIA), activeSinProvincia(exc));
		//	mapaErrores.put(messageServices.getMessage(ACTIVO_SIN_MUNICIPIO), activeSinMunicipio(exc)); //Quitamos a petición de REMVIP-2168
			mapaErrores.put(messageServices.getMessage(ACTIVO_AGRUPACION_PRV), activoAgrupacionPRV(exc));
		//	mapaErrores.put(messageServices.getMessage(ACTIVO_AGRUPACION_LOC), activoAgrupacionLOC(exc)); //Quitamos a petición de REMVIP-2168
			mapaErrores.put(messageServices.getMessage(ACTIVO_TIENE_AGRUPACION), activoEnAgrupacionProyecto(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVOS_NO_MISMA_CARTERA.mensajeError), activosAgrupMultipleValidacionRows(exc, ACTIVOS_NO_MISMA_CARTERA.codigoError));

			if    (!mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_PERIODO_CONCURRENCIA)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_OFERTA_PERIODO_CONCURRENCIA)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(AGRUPACION_PERIODO_CONCURRENCIA)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(AGRUPACION_OFERTA_PERIODO_CONCURRENCIA)).isEmpty()
			    || !mapaErrores.get(messageServices.getMessage(ACTIVO_EN_AGRUPACION)).isEmpty()
			    || !mapaErrores.get(messageServices.getMessage(AGRUPACION_NO_PROYECTO)).isEmpty()
			    || !mapaErrores.get(messageServices.getMessage(ACTIVO_SIN_PROVINCIA)).isEmpty()
		//	    || !mapaErrores.get(messageServices.getMessage(ACTIVO_SIN_MUNICIPIO)).isEmpty() //Quitamos a petición de REMVIP-2168
			    || !mapaErrores.get(messageServices.getMessage(ACTIVO_AGRUPACION_PRV)).isEmpty()
		//	    || !mapaErrores.get(messageServices.getMessage(ACTIVO_AGRUPACION_LOC)).isEmpty()//Quitamos a petición de REMVIP-2168
			    || !mapaErrores.get(messageServices.getMessage(ACTIVO_TIENE_AGRUPACION)).isEmpty()
			    || !mapaErrores.get(messageServices.getMessage(ACTIVOS_NO_MISMA_CARTERA.mensajeError)).isEmpty() 
			) {
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
	
	
	/**
	 * 
	 *  Validaciones para los activos de la lista excel
	 *  
	 */
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
	
	private List<Integer> agrupacionNoProyecto(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.agrupacionEsProyecto(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}

	private List<Integer> activeSinProvincia(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.activoTienePRV(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activeSinMunicipio(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.activoTieneLOC(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activoAgrupacionPRV(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		Long numActivo;
		Long numAgrupacion;
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				numAgrupacion = Long.parseLong(exc.dameCelda(i, 0));
				numActivo = Long.parseLong(exc.dameCelda(i, 1));
				if(!particularValidator.esMismaProvincia(numActivo, numAgrupacion))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activoAgrupacionLOC(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		Long numActivo;
		Long numAgrupacion;
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				numAgrupacion = Long.parseLong(exc.dameCelda(i, 0));
				numActivo = Long.parseLong(exc.dameCelda(i, 1));
				if(!particularValidator.esMismaLocalidad(numActivo, numAgrupacion))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activoEnAgrupacionProyecto(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		Long numActivo;
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				numActivo = Long.parseLong(exc.dameCelda(i, 1));
				if(particularValidator.activoEnAgrupacionProyecto(Long.toString(numActivo)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}


	/**
	 * 
	 *  Comprobaciones para todos los activos de una misma agrupacion indicada en el excel (no existente en BBDD todavia)
	 *  
	 */
	
	
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

// TODO: Desde masivo, poder obtener listados de numeros de Activo asociados a agrupaciones en BBDD, para poder validar TODOS 
//       los activos que ya tuviera la agrupacion con los activos que se asocian con el excel de carga masiva
// ----
					// Busca en BBDD si la agrupacion pudiera ya tener activos asociados y extrae 1 de ellos
					String inSqlActivosEnAgrupacion = particularValidator.getOneNumActivoAgrupacionRaw(String.valueOf(numAgrupacion));
					if(!Checks.esNulo(inSqlActivosEnAgrupacion)) 
						inSqlGrupoActivos = inSqlGrupoActivos.concat(",").concat(inSqlActivosEnAgrupacion);
					
					// Lanza la validacion para el grupo completo de num activos de la agrupacion (BBDD+excel), con un filtro IN de SQL
					// La validacion que se lanza es la que se ha indicado por parametro, solo se lanza 1 de ellas.
					// Validacion misma localizacion
					/*if(codigoValidacionMultiple == ACTIVOS_NO_MISMA_LOCALIZACION.codigoError &&
							!particularValidator.esActivosMismaLocalizacion(inSqlGrupoActivos))
						listaFilasError.add(getNumPrimeraFilaAgrupacionError(exc, numAgrupacion));*/
					if(codigoValidacionMultiple == ACTIVOS_NO_MISMA_CARTERA.codigoError &&
							!particularValidator.esActivosMismaCartera(inSqlGrupoActivos, numAgrupacion.toString()))
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
	
	private List<Integer> activosEnPeriodoDeConcurrencia(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.isActivoEnConcurrencia(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosConOfertaEnPeriodoDeConcurrencia(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.isActivoConOfertaEnConcurrencia(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> agrupacionEnPeriodoDeConcurrencia(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.isAgrupacionEnConcurrencia(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> agrupacionConOfertaEnPeriodoDeConcurrencia(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.isAgrupacionConOfertaEnConcurrencia(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
	
}
