package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelRepoApi;
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
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;

@Component
public class MSVAgrupacionAsistidaPDVExcelValidator extends MSVExcelValidatorAbstract {
	
	// Textos de validaciones para cada activo
	public static final String ACTIVO_NO_EXISTE = "Activo no encontrado con este número de activo";
	public static final String ACTIVO_EN_AGRUPACION = "El Activo ya está incluido en la agrupación";
	public static final String ACTIVO_EN_OTRA_AGRUPACION = "Este activo ya pertenece a otra agrupación.";
	public static final String ACTIVO_OFERTAS_ACEPTADAS = "El activo tiene ofertas vivas";
	public static final String ACTIVO_INCLUIDO_PERIMETRO = "El activo debe ser un activo bancario de tipo financiero";

	// Textos de validaciones para grupos de activos, estas variables llevan aparejado un texto y un codigo. Necesario para metodo comun
	public static final class ACTIVOS_NO_MISMA_LOCALIZACION { static int codigoError = 1; static String mensajeError = "NO todos los activos de esta agrupación comparten la misma PROVINCIA, MUNICIPIO, CP y CARTERA.";};
	public static final class ACTIVOS_NO_MISMO_PROPIETARIO { static int codigoError = 2; static String mensajeError = "NO todos los activos de esta agrupación comparten el mismo PROPIETARIO";};

	public static final String ACTIVO_NO_MISMO_TIPO_COMERCIAL = "El tipo (alquiler/venta) del activo y la agrupación no coinciden.";
	public static final String ACTIVO_NO_ASISTIDO = "El activo no es asistido.";

	
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

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) {
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion()));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
			// Validaciones individuales activo por activo:
			mapaErrores.put(ACTIVO_NO_EXISTE, activesNotExistsRows(exc));
			mapaErrores.put(ACTIVO_EN_AGRUPACION, activosEnAgrupacionRows(exc));
			mapaErrores.put(ACTIVO_EN_OTRA_AGRUPACION, activosEnOtraAgrupacionRows(exc));
			mapaErrores.put(ACTIVO_OFERTAS_ACEPTADAS, activosConVentaOfertaRows(exc));
			mapaErrores.put(ACTIVO_INCLUIDO_PERIMETRO, activosIncluidosPerimetroRows(exc));
			
			// Validaciones de grupo, para todos los activos de una agrupacion en el excel:
			mapaErrores.put(ACTIVOS_NO_MISMA_LOCALIZACION.mensajeError, activosAgrupMultipleValidacionRows(exc, ACTIVOS_NO_MISMA_LOCALIZACION.codigoError));
			mapaErrores.put(ACTIVOS_NO_MISMO_PROPIETARIO.mensajeError, activosAgrupMultipleValidacionRows(exc, ACTIVOS_NO_MISMO_PROPIETARIO.codigoError));
						
			try{
				if(!mapaErrores.get(ACTIVO_NO_EXISTE).isEmpty() ||
						!mapaErrores.get(ACTIVO_EN_AGRUPACION).isEmpty() ||
						!mapaErrores.get(ACTIVO_EN_OTRA_AGRUPACION).isEmpty() ||
						!mapaErrores.get(ACTIVO_OFERTAS_ACEPTADAS).isEmpty() ||
						!mapaErrores.get(ACTIVO_INCLUIDO_PERIMETRO).isEmpty() ||
						!mapaErrores.get(ACTIVOS_NO_MISMA_LOCALIZACION.mensajeError).isEmpty() ||
						!mapaErrores.get(ACTIVOS_NO_MISMO_PROPIETARIO.mensajeError).isEmpty() ){
					dtoValidacionContenido.setFicheroTieneErrores(true);
					exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
					String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
					FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
					dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
				}
			} catch (Exception e) {
				logger.error(e.getMessage());
				e.printStackTrace();
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
	
	private File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
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
			while (a<exc.getNumeroFilas() && !filaEncontrada){
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
		}
		
		return numFilaError;
	}
	
	private List<Integer> activesNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<exc.getNumeroFilas();i++){
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
			for(i=1; i<exc.getNumeroFilas();i++){
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
			for(i=1; i<exc.getNumeroFilas();i++){
				numAgrupacion = Long.parseLong(exc.dameCelda(i, 0));
				numActivo = Long.parseLong(exc.dameCelda(i, 1));
				if(particularValidator.esActivoEnOtraAgrupacion(numActivo, numAgrupacion))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosConVentaOfertaRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<exc.getNumeroFilas();i++){
				if(particularValidator.esActivoConVentaOferta(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosIncluidosPerimetroRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<exc.getNumeroFilas();i++){
				if(particularValidator.esActivoIncluidoPerimetro(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
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
			for(int a=1; a<exc.getNumeroFilas(); a++){
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
				for(int a=1; a<exc.getNumeroFilas(); a++){
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
					if(codigoValidacionMultiple == ACTIVOS_NO_MISMA_LOCALIZACION.codigoError &&
							!particularValidator.esActivosMismaLocalizacion(inSqlGrupoActivos))
						listaFilasError.add(getNumPrimeraFilaAgrupacionError(exc, numAgrupacion));
					
					// Validacion mismo propietario
					if(codigoValidacionMultiple == ACTIVOS_NO_MISMO_PROPIETARIO.codigoError &&
							!particularValidator.esActivosMismoPropietario(inSqlGrupoActivos))
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


}
