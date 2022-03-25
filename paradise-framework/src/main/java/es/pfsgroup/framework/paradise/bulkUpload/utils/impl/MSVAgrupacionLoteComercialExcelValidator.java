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
public class MSVAgrupacionLoteComercialExcelValidator extends MSVExcelValidatorAbstract {

	// Textos de validaciones para cada activo
	public static final String ACTIVO_NO_EXISTE = "msg.error.masivo.agrupar.activos.asistida.activo.noExiste";
	public static final String ACTIVO_EN_OTRA_AGRUPACION = "msg.error.masivo.agrupar.activos.asistida.activo.enOtraAgrupacion";
	public static final String ACTIVO_OFERTAS_ACEPTADAS = "msg.error.masivo.agrupar.activos.asistida.oferta.aceptada";
	public static final String ACTIVO_VENDIDO = "msg.error.masivo.agrupar.activos.asistida.activo.vendido";
	public static final String ACTIVO_SIN_PROPIETARIO = "msg.error.masivo.agrupar.activos.asistida.activo.sinPropietario";
	public static final String ACTIVO_NO_COMERCIALIZABLE = "msg.error.masivo.agrupar.activos.no.comercializables";
	public static final String ERROR_ACTIVO_CANARIAS = "msg.error.masivo.agrupar.activos.agr.canaria.act.canaria";
	public static final String ERROR_ACTIVO_DISTINTO_PROPIETARIO = "msg.error.masivo.agrupar.activos.propietarios.no.coinciden";
	public static final String ERROR_ACTIVO_CON_OFERTA_TRAMITADA = "msg.error.masivo.agrupar.activos.oferta.tramitada";
	public static final String ACTIVO_DESTINO_COMERCIAL_ALQUILER = "msg.error.masivo.activo.destino.comercial.alquiler";
	public static final String ACTIVO_FUERA_PERIMETRO = "msg.error.masivo.activo.fuera.perimetro";
	public static final String ACTIVO_OFERTAS_VIVAS = "msg.error.masivo.activo.ofertas.vivas";
	public static final String ACTIVO_LOTE_COMERCIAL_VIVO = "msg.error.masivo.activo.en.lote.comercial.vivo";
	//public static final String ACTIVO_ALQUILADO = "msg.error.masivo.activo.alquilado";
	public static final String AGRUPACION_NO_EXISTE = "msg.error.masivo.agrupar.agrupacion.no.existe";
	public static final String AGRUPACION_NO_TIPO_COMERCIAL_VENTA = "msg.error.masivo.agrupar.agrupacion.no.tipo.comercial.venta";
	public static final String ACTIVO_DISTINTA_SUBCARTERA = "msg.error.masivo.activo.distinta.subcartera";
	public static final String ACTIVO_PERIODO_CONCURRENCIA = "msg.error.masivo.agrupar.activos.concurrencia";

	// Validaciones de activo NO utilizadas porque no esta definido como validar en esos casos al incluir en lotes comerciales
	/*
	public static final String ACTIVO_INCLUIDO_PERIMETRO = "msg.error.masivo.agrupar.activos.asistida.activo.incluidoPerimetro";
	public static final String ACTIVO_NO_ASISTIDO = "msg.error.masivo.agrupar.activos.asistida.activo.noAsistido";
	public static final String ACTIVO_NO_FINANCIERO = "msg.error.masivo.agrupar.activos.asistida.activo.noFinanciero";
	public static final String ACTIVO_NO_MISMO_TIPO_COMERCIAL = "msg.error.masivo.agrupar.activos.asistida.activo.agrupacion.diferente.tipoComercial";
	 */
	
	// Textos de validaciones para grupos de activos (de las agrupaciones), estas variables llevan aparejado un texto y un codigo. Necesario para metodo comun
	public static final class AGRUPACION_ACTIVOS_SIN_OFERTAS_ACEPTADAS { static int codigoError = 1; static String mensajeError = "msg.error.masivo.agrupar.activos.asistida.activos.agrupacion.ofertas.aceptadas";};
	//public static final class AGRUPACION_ACTIVOS_NO_MISMO_PROPIETARIO { static int codigoError = 2; static String mensajeError = "msg.error.masivo.agrupar.activos.asistida.activos.agrupacion.diferente.propietario";};
	public static final class ACTIVOS_NO_MISMA_CARTERA { static int codigoError = 2; static String mensajeError = "msg.error.masivo.agrupar.activos.asistida.activos.agrupacion.diferente.cartera";};

	public static final class AGRUPACIONES_CON_BAJA { static int codigoError = 3; static String mensajeError = "msg.error.masivo.agrupar.activos.asistida.activos.agrupacion.conBaja";};


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
			

			// Validaciones individuales activo por activo:
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), activesNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_PERIODO_CONCURRENCIA), activosEnPeriodoDeConcurrencia(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_EN_OTRA_AGRUPACION), activosEnOtraAgrupacionRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_OFERTAS_ACEPTADAS), activosConVentaOfertaRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_VENDIDO), activosVendidosRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_SIN_PROPIETARIO), activosSinPropietariosRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_COMERCIALIZABLE), activosNoComercializablesRows(exc));
			mapaErrores.put(messageServices.getMessage(ERROR_ACTIVO_CANARIAS), distintosTiposImpuesto(exc));
			mapaErrores.put(messageServices.getMessage(ERROR_ACTIVO_CON_OFERTA_TRAMITADA), activoConOfertasTramitadas(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_DESTINO_COMERCIAL_ALQUILER), activosDestinoComercialAlquilerRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO), activosFueraPerimetroRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_OFERTAS_VIVAS), activosConOfertasVivasRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_LOTE_COMERCIAL_VIVO), activosEnLoteComercialVivoRows(exc));
			//mapaErrores.put(messageServices.getMessage(ACTIVO_ALQUILADO), activosSituacionComercialAlquiladoRows(exc));
			mapaErrores.put(messageServices.getMessage(AGRUPACION_NO_EXISTE), agrupacionNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(AGRUPACION_NO_TIPO_COMERCIAL_VENTA), agrupacionNoTipoComercialVentaRows(exc));
			mapaErrores.put(messageServices.getMessage(ERROR_ACTIVO_DISTINTO_PROPIETARIO), comprobarDistintoPropietario(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_DISTINTA_SUBCARTERA), activosDistintaSubcartera(exc));

			
			// mapaErrores.put(messageServices.getMessage(ACTIVO_INCLUIDO_PERIMETRO), activosIncluidosPerimetroRows(exc));
			// mapaErrores.put(messageServices.getMessage(ACTIVO_NO_FINANCIERO),activosFinancierosRows(exc));
			
			// Validaciones de grupo, para todos los activos de una agrupacion en el excel:
			mapaErrores.put(messageServices.getMessage(AGRUPACIONES_CON_BAJA.mensajeError), activosAgrupMultipleValidacionRows(exc, AGRUPACIONES_CON_BAJA.codigoError));
			mapaErrores.put(messageServices.getMessage(ACTIVOS_NO_MISMA_CARTERA.mensajeError), activosAgrupMultipleValidacionRows(exc, ACTIVOS_NO_MISMA_CARTERA.codigoError));
			mapaErrores.put(messageServices.getMessage(AGRUPACION_ACTIVOS_SIN_OFERTAS_ACEPTADAS.mensajeError), activosAgrupMultipleValidacionRows(exc, AGRUPACION_ACTIVOS_SIN_OFERTAS_ACEPTADAS.codigoError));


			if (!mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_PERIODO_CONCURRENCIA)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_EN_OTRA_AGRUPACION)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_OFERTAS_ACEPTADAS)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_VENDIDO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_SIN_PROPIETARIO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_NO_COMERCIALIZABLE)).isEmpty() 
				 // || !mapaErrores.get(messageServices.getMessage(ACTIVO_INCLUIDO_PERIMETRO)).isEmpty()
				 // || !mapaErrores.get(messageServices.getMessage(ACTIVO_NO_FINANCIERO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(AGRUPACIONES_CON_BAJA.mensajeError)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVOS_NO_MISMA_CARTERA.mensajeError)).isEmpty()
					|| !mapaErrores
							.get(messageServices.getMessage(AGRUPACION_ACTIVOS_SIN_OFERTAS_ACEPTADAS.mensajeError))
							.isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ERROR_ACTIVO_CANARIAS)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ERROR_ACTIVO_CON_OFERTA_TRAMITADA)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_DESTINO_COMERCIAL_ALQUILER)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_OFERTAS_VIVAS)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_LOTE_COMERCIAL_VIVO)).isEmpty()
				//	|| !mapaErrores.get(messageServices.getMessage(ACTIVO_ALQUILADO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(AGRUPACION_NO_EXISTE)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(AGRUPACION_NO_TIPO_COMERCIAL_VENTA)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ERROR_ACTIVO_DISTINTO_PROPIETARIO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_DISTINTA_SUBCARTERA)).isEmpty()
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
				// Valida que el activo no est� actualmente en una agrupacion comercial(14).
				if(particularValidator.esActivoEnOtraAgrupacionNoCompatible(numActivo, numAgrupacion, "14"))
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
			for(i=1; i<this.numFilasHoja;i++){
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
	
	private List<Integer> activosSinPropietariosRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.esActivoConPropietario(exc.dameCelda(i, 1)))
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
			for(i=1; i<this.numFilasHoja;i++){
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
	
	private List<Integer> activosAsistidosRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.esActivoAsistido(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosFinancierosRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.esActivoFinanciero(exc.dameCelda(i, 1)))
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
					
					// Validacion agrupacion dada de baja
					if(codigoValidacionMultiple == AGRUPACIONES_CON_BAJA.codigoError &&
							particularValidator.esAgrupacionConBaja(String.valueOf(numAgrupacion)))
						listaFilasError.add(getNumPrimeraFilaAgrupacionError(exc, numAgrupacion));
					
					// Validacion misma cartera
					if(codigoValidacionMultiple == ACTIVOS_NO_MISMA_CARTERA.codigoError &&
							!particularValidator.esActivosMismaCartera(inSqlGrupoActivos, numAgrupacion.toString()))
						listaFilasError.add(getNumPrimeraFilaAgrupacionError(exc, numAgrupacion));

					// Validacion agrupacion y activos sin ofertas aceptadas
					
					// Esta validación peta para los casos de más de 1000 activos, la solución alternativa es hacer la carga
					// de 1000 en 1000, ya que si modificamos la función esActivosOfertasAceptadas por un bucle que recorriera 
					// la lista de activos para evitar el limite de 1000 de la clausura IN(), se bajaría la eficiencia/velocidad
					// de ejecución y posiblemente provoque un timeout.
					// Tampoco se puede cambiar la clausura IN() por EXIST(), porque el número de los activos vienen en una lista 
					// de tipo String.
					if(codigoValidacionMultiple == AGRUPACION_ACTIVOS_SIN_OFERTAS_ACEPTADAS.codigoError &&
							particularValidator.esActivosOfertasAceptadas(inSqlGrupoActivos, String.valueOf(numAgrupacion)))
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

	
	private List<Integer> distintosTiposImpuesto(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			String numAgrupacion = String.valueOf(Long.parseLong(exc.dameCelda(1, 0)));

			// Comprobamos que la agrupación no este vacía
			if (!particularValidator.agrupacionEstaVacia(numAgrupacion)) {
				for (i = 1; i < this.numFilasHoja; i++) {
					String numActivo = String.valueOf(Long.parseLong(exc.dameCelda(i, 1)));
					if (particularValidator.distintosTiposImpuesto(numActivo, numAgrupacion))
						listaFilas.add(i);
				}
			} else {
				List<String> activosList = new ArrayList<String>();
				for (i = 1; i < this.numFilasHoja; i++) {
					activosList.add(String.valueOf(Long.parseLong(exc.dameCelda(i, 1))));
				}
				
				if(particularValidator.distintosTiposImpuestoAgrupacionVacia(activosList)) 
					listaFilas.add(1);
				
			}
		} catch (Exception e) {
			if (i != 0)
				listaFilas.add(i);
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

	private List<Integer> activoConOfertasTramitadas(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for (i = 1; i < this.numFilasHoja; i++) {
				String numActivo = String.valueOf(Long.parseLong(exc.dameCelda(i, 1)));
				if (!particularValidator.activoConOfertasTramitadas(numActivo))
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
	
	
	private List<Integer> activosDestinoComercialAlquilerRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.activoConDestinoComercialAlquiler(exc.dameCelda(i, 1)))
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
	
	private List<Integer> agrupacionNoTipoComercialVentaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.existeAgrupacion(exc.dameCelda(i, 0)) && !particularValidator.esAgrupacionTipoComercialVenta(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
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

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
	
}
