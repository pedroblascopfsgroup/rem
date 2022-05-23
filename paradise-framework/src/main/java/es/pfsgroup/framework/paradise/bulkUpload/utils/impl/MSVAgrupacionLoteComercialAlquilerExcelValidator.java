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

@Component
public class MSVAgrupacionLoteComercialAlquilerExcelValidator extends MSVExcelValidatorAbstract {
	
	public static final String AGRUPACION_NO_EXISTE = "msg.error.masivo.agrupar.agrupacion.no.existe";
	public static final String AGRUPACION_NO_TIPO_ALQUILER = "msg.error.masivo.agrupar.agrupacion.no.tipo.alquiler";
	public static final String ACTIVO_NO_EXISTE = "msg.error.masivo.agrupar.activos.asistida.activo.noExiste";
	public static final String ACTIVO_NO_COMERCIALIZABLE = "msg.error.masivo.agrupar.activos.no.comercializables";
	public static final String ACTIVO_DESTINO_COMERCIAL_VENTA = "msg.error.masivo.activo.destino.comercial.venta";
	public static final String ACTIVO_ALQUILADO = "msg.error.masivo.activo.alquilado";
	public static final String ACTIVO_FUERA_PERIMETRO = "msg.error.masivo.activo.fuera.perimetro";
	public static final String ACTIVO_DISTINTO_PROPIETARIO = "msg.error.masivo.activo.distinto.propietario";
	public static final String ACTIVO_DISTINTA_SUBCARTERA = "msg.error.masivo.activo.distinta.subcartera";
	public static final String ACTIVO_OFERTAS_VIVAS = "msg.error.masivo.activo.ofertas.vivas";
	public static final String ACTIVO_LOTE_COMERCIAL_VIVO = "msg.error.masivo.activo.en.lote.comercial.vivo";
	public static final String ERROR_ACTIVO_CANARIAS = "msg.error.masivo.agrupar.activos.agr.canaria.act.canaria";
	public static final String ACTIVO_DISTINTO_TIPO_ALQUILER = "msg.error.masivo.agrupar.activos.distinto.tipo.alquiler.agrupacion";
	public static final String ACTIVO_VENDIDO = "msg.error.masivo.agrupar.activos.asistida.activo.vendido";
	public static final String ACTIVO_PERIODO_CONCURRENCIA = "msg.error.masivo.agrupar.activos.concurrencia";
	public static final String ACTIVO_OFERTA_PERIODO_CONCURRENCIA = "msg.error.masivo.agrupar.activos.ofertas.concurrencia";
	public static final String AGRUPACION_PERIODO_CONCURRENCIA = "msg.error.masivo.agrupacion.concurrencia";
	public static final String AGRUPACION_OFERTA_PERIODO_CONCURRENCIA = "msg.error.masivo.agrupacion.ofertas.concurrencia";
	
	
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	@Resource
    MessageService messageServices;
	
	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;
	
	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Autowired
	private ExcelRepoApi excelRepo;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	private MSVHojaExcel excPlantilla = null;
	private Integer numFilasHoja;

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		
		getPlantillaExcel(dtoFile.getIdTipoOperacion());
		
		List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, this.excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		
		
		// Actualizamos el excel con la nueva info 
		// Parece que sobra porque más arriba hay una linea igual pero es necesario.
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			
			// Agrupación inexistente
			
			mapaErrores.put(messageServices.getMessage(AGRUPACION_NO_EXISTE), agrupacionNotExistsRows(exc));
			
			// Agrupación del tipo correcto
			
			mapaErrores.put(messageServices.getMessage(AGRUPACION_NO_TIPO_ALQUILER), agrupacionNoTipoAlquilerRows(exc));
			
			// Activo inexistente.
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), activesNotExistsRows(exc));
			
			// Activo vendido 
			
			mapaErrores.put(messageServices.getMessage(ACTIVO_VENDIDO), activosVendidosRows(exc));
			
			// Activo en periodo de concurrencia
			mapaErrores.put(messageServices.getMessage(ACTIVO_PERIODO_CONCURRENCIA), activosEnPeriodoDeConcurrencia(exc));
			
			// Activo con oferta en periodo de concurrencia
			mapaErrores.put(messageServices.getMessage(ACTIVO_OFERTA_PERIODO_CONCURRENCIA), activosConOfertaEnPeriodoDeConcurrencia(exc));
			
			//Agrupación en periodo de concurrencia
			mapaErrores.put(messageServices.getMessage(AGRUPACION_PERIODO_CONCURRENCIA), agrupacionEnPeriodoDeConcurrencia(exc));
			
			//Agrupacióncon ofertas en periodo de concurrencia
			mapaErrores.put(messageServices.getMessage(AGRUPACION_OFERTA_PERIODO_CONCURRENCIA), agrupacionConOfertaEnPeriodoDeConcurrencia(exc));
			
			// Activo fuera perímetro HAYA.
			mapaErrores.put(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO), activosFueraPerimetroRows(exc));
			
			// Activo NO comercializable.
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_COMERCIALIZABLE), activosNoComercializablesRows(exc));
			
			// Activo destino comercial "Venta".
			mapaErrores.put(messageServices.getMessage(ACTIVO_DESTINO_COMERCIAL_VENTA), activosDestinoComercialVentaRows(exc));
			
			//  Activo tipo de alquiler distinto al de la agrupación.
			mapaErrores.put(messageServices.getMessage(ACTIVO_DISTINTO_TIPO_ALQUILER), activosDistintoTipoAlquilerRows(exc));
			
			// Activo con ofertas individuales vivas.
			mapaErrores.put(messageServices.getMessage(ACTIVO_OFERTAS_VIVAS), activosConOfertasVivasRows(exc));
			
			// Activo en otro lote comercial vivo.
			mapaErrores.put(messageServices.getMessage(ACTIVO_LOTE_COMERCIAL_VIVO), activosEnLoteComercialVivoRows(exc));
			
			// Activo Alquilado.
			mapaErrores.put(messageServices.getMessage(ACTIVO_ALQUILADO), activosSituacionComercialAlquiladoRows(exc));
			
			// Activos sean de la misma Cartera
			mapaErrores.put(messageServices.getMessage(ACTIVOS_NO_MISMA_CARTERA.mensajeError), activosAgrupMultipleValidacionRows(exc, ACTIVOS_NO_MISMA_CARTERA.codigoError));
			
			// Activos sean de la península o Canarias.
			mapaErrores.put(messageServices.getMessage(ERROR_ACTIVO_CANARIAS), distintosTiposImpuesto(exc));
			
			// Activos sean del mismo Propietario.
			mapaErrores.put(messageServices.getMessage(ACTIVO_DISTINTO_PROPIETARIO), comprobarDistintoPropietario(exc));
			
			// Activos sean de la misma Subcartera.
			mapaErrores.put(messageServices.getMessage(ACTIVO_DISTINTA_SUBCARTERA), activosDistintaSubcartera(exc));
			
			
		}
		
		if (!mapaErrores.get(messageServices.getMessage(AGRUPACION_NO_EXISTE)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(AGRUPACION_NO_TIPO_ALQUILER)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_NO_COMERCIALIZABLE)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_DESTINO_COMERCIAL_VENTA)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_DISTINTO_TIPO_ALQUILER)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_OFERTAS_VIVAS)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_LOTE_COMERCIAL_VIVO)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_ALQUILADO)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVOS_NO_MISMA_CARTERA.mensajeError)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ERROR_ACTIVO_CANARIAS)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_DISTINTO_PROPIETARIO)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_DISTINTA_SUBCARTERA)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_VENDIDO)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_PERIODO_CONCURRENCIA)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_OFERTA_PERIODO_CONCURRENCIA)).isEmpty()
				) {
			
			dtoValidacionContenido.setFicheroTieneErrores(true);
			exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
			String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
			FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
			dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
			
		}
		
		exc.cerrar();

		return dtoValidacionContenido;
	}

	@Override
	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda,
			MSVBusinessValidators contentValidators) {

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
	
	private File recuperarPlantillaExcel(Long idTipoOperacion)  {
		try {
			FileItem fileItem = excelRepo.dameExcelByTipoOperacion(idTipoOperacion);
			// FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}

	private MSVHojaExcel getPlantillaExcel(Long idTipoOperacion) {
		
		if (this.excPlantilla == null) {
			this.excPlantilla = excelParser.getExcel(recuperarPlantillaExcel(idTipoOperacion));
		}
		
		return this.excPlantilla;
	}
	
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
	
	private List<Integer> agrupacionNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.existeAgrupacion(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> agrupacionNoTipoAlquilerRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.existeAgrupacion(exc.dameCelda(i, 0)) && !particularValidator.esAgrupacionTipoAlquiler(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosNoComercializablesRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.isActivoNoComercializable(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosDestinoComercialVentaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.activoConDestinoComercialVenta(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosSituacionComercialAlquiladoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.esActivoAlquilado(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosFueraPerimetroRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.existeActivo(exc.dameCelda(i, 1)) && !particularValidator.esActivoIncluidoPerimetro(exc.dameCelda(i, 1)))
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
				if (particularValidator.existeActivo(exc.dameCelda(i, 1)) && particularValidator.existeAgrupacion(numAgrupacion) 
						&& particularValidator.comprobarDistintoPropietario(numActivo, numAgrupacion))
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
	
	private List<Integer> activosDistintaSubcartera(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		
		try {
			
			String subcartPadre = particularValidator.getCodigoSubcarteraAgrupacion(exc.dameCelda(1, 0));
			
			for(i=1; i<this.numFilasHoja;i++){
				if(!Checks.esNulo(subcartPadre) && 
						particularValidator.existeActivo(exc.dameCelda(i, 1)) &&
						!subcartPadre.equals(particularValidator.getSubcartera(exc.dameCelda(i, 1)))) {
					listaFilas.add(i);
				}
					
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
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

					// Validacion misma cartera
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
	
	private List<Integer> activosConOfertasVivasRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.existeActivoConOfertaViva(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosDistintoTipoAlquilerRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			String numActivo;
			String numAgrupacion;
			for(i=1; i<this.numFilasHoja;i++){
				numActivo = exc.dameCelda(i, 1);
				numAgrupacion = exc.dameCelda(i, 0);
				if(particularValidator.existeActivo(numActivo) && particularValidator.existeAgrupacion(numAgrupacion) 
						&& !particularValidator.mismoTipoAlquilerActivoAgrupacion(numAgrupacion,numActivo))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosEnLoteComercialVivoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.activoEnAgrupacionComercialViva(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> distintosTiposImpuesto(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			String numAgrupacion = String.valueOf(Long.parseLong(exc.dameCelda(1, 0)));

			if (particularValidator.existeAgrupacion(numAgrupacion)) {
				
				// Comprobamos que la agrupación no este vacía
				if (!particularValidator.agrupacionEstaVacia(numAgrupacion)) {
					for (i = 1; i < this.numFilasHoja; i++) {
						String numActivo = String.valueOf(Long.parseLong(exc.dameCelda(i, 1)));
						if (particularValidator.existeActivo(numActivo) && particularValidator.existeAgrupacion(numAgrupacion)
								&& particularValidator.distintosTiposImpuesto(numActivo, numAgrupacion))
							listaFilas.add(i);
					}
				} else {
					List<String> activosList = new ArrayList<String>();
					for (i = 1; i < this.numFilasHoja; i++) {
						if (particularValidator.existeActivo(exc.dameCelda(i, 1))) {
							activosList.add(String.valueOf(Long.parseLong(exc.dameCelda(i, 1))));
						}
					}

					if(particularValidator.distintosTiposImpuestoAgrupacionVacia(activosList)) 
						listaFilas.add(1);
					
				}
				
			}
			
		} catch (Exception e) {
			if (i != 0)
				listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}
	
	private List<Integer> activosVendidosRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.esActivoVendido(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
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
