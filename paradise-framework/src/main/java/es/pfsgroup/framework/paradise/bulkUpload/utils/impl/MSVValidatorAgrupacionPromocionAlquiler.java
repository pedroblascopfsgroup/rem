package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
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
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
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
public class MSVValidatorAgrupacionPromocionAlquiler extends MSVExcelValidatorAbstract{
	
	public static final String PROMOCION_NO_EXISTE = "Promoción alquiler no existe";
	public static final String PROMOCION_DADA_DE_BAJA = "Promoción alquiler dada de baja";
	public static final String SIN_MA = "Promoción de alquiler sin activo matriz asociado";
	public static final String GESTOR_DIFIERE = "Promoción de alquiler no gestionada por usted";
	public static final String TIPOLOGIA_SUBTIPOLOGIA_ERRONEA = "Tipología/Subtipología del activo errónea";
	public static final String VIA_ERRONEA = "Tipo de vía erróneo";
	public static final String DIRECCION_INCOMPLETA = "Dirección incompleta";
	public static final String SUPERFICIES_CONSTRUIDA = "Sumatorio de las superficies construidas superior a la del activo matriz";
	public static final String SUPERFICIES_UTIL = "Sumatorio de las superficies útiles superior a la del activo matriz";
	public static final String PORCENTAJE_PARTICIPACION = "% de participación erróneo";
	public static final String PARTICIPACION_TOTAL= "El % de participación de las UAs supera el 100%";
	public static final String USUARIOSUPER = "HAYASUPER";
	public static final String ACTIVO_PERIODO_CONCURRENCIA = "msg.error.masivo.agrupar.activos.concurrencia";
	
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
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	private Integer numFilasHoja;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		if(Checks.esNulo(dtoFile.getIdTipoOperacion())){
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
		
		Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			mapaErrores.put(PROMOCION_NO_EXISTE, existePromocion(exc));
			mapaErrores.put(PROMOCION_DADA_DE_BAJA, esPromocionVigente(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_PERIODO_CONCURRENCIA), activosEnPeriodoDeConcurrencia(exc));
			mapaErrores.put(SIN_MA, tieneActimoMatriz(exc));
			mapaErrores.put(GESTOR_DIFIERE, esGestorSupervisorComercialAlquilerDelAM(exc));
			mapaErrores.put(TIPOLOGIA_SUBTIPOLOGIA_ERRONEA, esTipologiaSubtipologiaCorrecta(exc));
			mapaErrores.put(VIA_ERRONEA, esTipoViaCorrecto(exc));
			mapaErrores.put(DIRECCION_INCOMPLETA, esDireccionCompleta(exc));
			mapaErrores.put(SUPERFICIES_CONSTRUIDA, esSuperficieConstruidaCorrecta(exc));
			mapaErrores.put(SUPERFICIES_UTIL, esSuperficieUtilCorrecta(exc));
			mapaErrores.put(PORCENTAJE_PARTICIPACION, esPorcentajeCorrecto(exc));
			mapaErrores.put(PARTICIPACION_TOTAL, esPorcentajeTotalCorrecto(exc));
		}
		
		if(!mapaErrores.get(PROMOCION_NO_EXISTE).isEmpty()
				|| !mapaErrores.get(PROMOCION_DADA_DE_BAJA).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_PERIODO_CONCURRENCIA)).isEmpty()
				|| !mapaErrores.get(SIN_MA).isEmpty()
				|| !mapaErrores.get(GESTOR_DIFIERE).isEmpty()
				|| !mapaErrores.get(TIPOLOGIA_SUBTIPOLOGIA_ERRONEA).isEmpty()
				|| !mapaErrores.get(VIA_ERRONEA).isEmpty()
				|| !mapaErrores.get(DIRECCION_INCOMPLETA).isEmpty()
				|| !mapaErrores.get(SUPERFICIES_CONSTRUIDA).isEmpty()
				|| !mapaErrores.get(SUPERFICIES_UTIL).isEmpty()
				|| !mapaErrores.get(PORCENTAJE_PARTICIPACION).isEmpty()
				|| !mapaErrores.get(PARTICIPACION_TOTAL).isEmpty()){
			dtoValidacionContenido.setFicheroTieneErrores(true);
			exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
			String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
			FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
			dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
		}
		
		exc.cerrar();
		return dtoValidacionContenido;
	}
	
	//----Métodos genéricos
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
	
	 
	
	//----Métodos customizados
	//----Debido a que es la misma agrupacion en todos los registros de la carga, por tanto se comproba solamente una vez (1,0) en muchos de los siguientes métodos
	private List<Integer> existePromocion(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			if(!particularValidator.existeAgrupacionPA(exc.dameCelda(1, 0))){
				listaFilas.add(1);
			}
		}catch(Exception e){
			listaFilas.add(1);
		}
	
		return listaFilas;
	}
	
	private List<Integer> esPromocionVigente(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			if(particularValidator.existeAgrupacion(exc.dameCelda(1, 0)) && !particularValidator.esAgrupacionVigente(exc.dameCelda(1, 0))){
				listaFilas.add(1);
			}
		}catch(Exception e){
			listaFilas.add(1);
		}
		return listaFilas;
	}
	
	private List<Integer> tieneActimoMatriz(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			if(particularValidator.existeAgrupacion(exc.dameCelda(1, 0)) 
					&& particularValidator.esAgrupacionVigente(exc.dameCelda(1, 0))
					&& !particularValidator.tieneActivoMatriz(exc.dameCelda(1, 0))){
				listaFilas.add(1);
			}
		}catch(Exception e){
			listaFilas.add(1);
		}
		
		return listaFilas;
	}
	
	private List<Integer> esGestorSupervisorComercialAlquilerDelAM(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		String usernameLogado = msvProcesoApi.getUsername();
		
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		
		
		try{
			String numAgrupacion = exc.dameCelda(1, 0);
			if(particularValidator.existeAgrupacion(numAgrupacion) 
					&& particularValidator.esAgrupacionVigente(exc.dameCelda(1, 0))
					&& particularValidator.tieneActivoMatriz(exc.dameCelda(1, 0))){

				List<Perfil> perfiles = usu.getPerfiles();
				if(!Checks.estaVacio(perfiles)) {
					Perfil perfilSuper = genericDao.get(Perfil.class, genericDao.createFilter(FilterType.EQUALS, "codigo", USUARIOSUPER));
					if(!perfiles.contains(perfilSuper)) {
						for (Perfil perfil : perfiles) {
							String gestor = particularValidator.getGestorComercialAlquilerByAgrupacion(numAgrupacion);
							String supervisor = particularValidator.getSupervisorComercialAlquilerByAgrupacion(numAgrupacion);
							if((!usernameLogado.equals(gestor) && !usernameLogado.equals(supervisor))){
								listaFilas.add(1);
							}
						}
					}
				}
			}
		}catch(Exception e){
			listaFilas.add(1);
		}
		
		return listaFilas;
	}
	
	private List<Integer> esTipologiaSubtipologiaCorrecta(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		HashMap<String, List<String>> relacionTipoSubtipoActivo = new HashMap<String, List<String>>();
		List<String> subtiposDel01 = new ArrayList<String>(Arrays.asList("1","2","3","4"));
		List<String> subtiposDel02 = new ArrayList<String>(Arrays.asList("5","6","7","8","9","10","11","12"));
		List<String> subtiposDel03 = new ArrayList<String>(Arrays.asList("13","14","15","16"));
		List<String> subtiposDel04 = new ArrayList<String>(Arrays.asList("17","18"));
		List<String> subtiposDel05 = new ArrayList<String>(Arrays.asList("19","20","21","22"));
		List<String> subtiposDel06 = new ArrayList<String>(Arrays.asList("23"));
		List<String> subtiposDel07 = new ArrayList<String>(Arrays.asList("24","25","26"));
		relacionTipoSubtipoActivo.put("1", subtiposDel01);
		relacionTipoSubtipoActivo.put("2", subtiposDel02);
		relacionTipoSubtipoActivo.put("3", subtiposDel03);
		relacionTipoSubtipoActivo.put("4", subtiposDel04);
		relacionTipoSubtipoActivo.put("5", subtiposDel05);
		relacionTipoSubtipoActivo.put("6", subtiposDel06);
		relacionTipoSubtipoActivo.put("7", subtiposDel07);
		List<String> tiposActivo = new ArrayList<String>(Arrays.asList("1","2","3","4","5","6","7"));
		List<String> subtiposActivo = new ArrayList<String>(Arrays.asList("1","2","3","4","5","6","7","8","9","10","11","12"
				,"13","14","15","16","17","18","19","20","21","22","23","24","25","26"));
		
		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja; i++){
				try{
					String tipoActual = exc.dameCelda(i, 2);
					String subtipoActual = exc.dameCelda(i, 3);
					if(!tiposActivo.contains(tipoActual) || !subtiposActivo.contains(subtipoActual) || !relacionTipoSubtipoActivo.get(tipoActual).contains(subtipoActual)){
						listaFilas.add(i);
					}
				}catch(Exception e){
					listaFilas.add(i);
				}
			}
		}catch(Exception e){
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> esTipoViaCorrecto(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<String> tiposVia = new ArrayList<String>(Arrays.asList("CL","PL","AV","CT","UB","LU","PT","PA","PJ","CA"
				,"PG","RO","PR","CJ","CV","CN","CO","TV","RA",""));
		
		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja; i++){
				try{
					if(!tiposVia.contains(exc.dameCelda(i, 5))){
						listaFilas.add(i);
					}
				}catch(Exception e){
					listaFilas.add(i);
				}
			}
		}catch(Exception e){
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> esDireccionCompleta(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja; i++){
				try{
					String tipoViaActual = exc.dameCelda(i, 5);
					String nombreViaActual = exc.dameCelda(i, 6);
					if((Checks.esNulo(tipoViaActual) && !Checks.esNulo(nombreViaActual)) 
							|| (!Checks.esNulo(tipoViaActual) && Checks.esNulo(nombreViaActual))){
						listaFilas.add(i);
					}
				}catch(Exception e){
					listaFilas.add(i);
				}
			}
		}catch(Exception e){
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}

	
	private List<Integer> esSuperficieConstruidaCorrecta(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double sumaSuperficies = 0.0;
		Double superficieActivoMatriz = 0.0;
		Double superficiePromocionAlquilerActual = 0.0;
		
		int i = 0;
		try{
			if(particularValidator.existeAgrupacion(exc.dameCelda(1, 0)) 
					&& particularValidator.esAgrupacionVigente(exc.dameCelda(1, 0))
					&& particularValidator.tieneActivoMatriz(exc.dameCelda(1, 0))){
				for(i=1; i<this.numFilasHoja; i++){
					try{
						sumaSuperficies += Double.valueOf(exc.dameCelda(i, 11));
					}catch(Exception e){
						listaFilas.add(1);
					}
				}
				
				if(!Checks.esNulo(particularValidator.getSuperficieConstruidaActivoMatrizByAgrupacion(exc.dameCelda(1, 0)))){
					superficieActivoMatriz = 
							Double.valueOf(particularValidator.getSuperficieConstruidaActivoMatrizByAgrupacion(exc.dameCelda(1, 0)));
				}
				if(!Checks.esNulo(particularValidator.getSuperficieConstruidaPromocionAlquilerByAgrupacion(exc.dameCelda(1, 0)))){
					superficiePromocionAlquilerActual = 
							Double.valueOf(particularValidator.getSuperficieConstruidaPromocionAlquilerByAgrupacion(exc.dameCelda(1, 0)));
				}
				
				if((sumaSuperficies + superficiePromocionAlquilerActual) > superficieActivoMatriz){
					listaFilas.add(1);
				}
			}
		}catch(Exception e){
			if (i != 0) listaFilas.add(1);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> esSuperficieUtilCorrecta(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double sumaSuperficies = 0.0;
		Double superficieActivoMatriz = 0.0;
		Double superficiePromocionAlquilerActual = 0.0;
		
		int i = 0;
		try{
			if(particularValidator.existeAgrupacion(exc.dameCelda(1, 0)) 
					&& particularValidator.esAgrupacionVigente(exc.dameCelda(1, 0))
					&& particularValidator.tieneActivoMatriz(exc.dameCelda(1, 0))){
				for(i=1; i<this.numFilasHoja; i++){
					try{
						sumaSuperficies += Double.valueOf(exc.dameCelda(i, 12));
					}catch(Exception e){
						listaFilas.add(1);
					}
				}

				if(!Checks.esNulo(particularValidator.getSuperficieUtilActivoMatrizByAgrupacion(exc.dameCelda(1, 0)))){
					superficieActivoMatriz = 
							Double.valueOf(particularValidator.getSuperficieUtilActivoMatrizByAgrupacion(exc.dameCelda(1, 0)));
				}
				
				if(!Checks.esNulo(particularValidator.getSuperficieUtilPromocionAlquilerByAgrupacion(exc.dameCelda(1, 0)))){
					superficiePromocionAlquilerActual = 
							Double.valueOf(particularValidator.getSuperficieUtilPromocionAlquilerByAgrupacion(exc.dameCelda(1, 0)));
				}
				
				if((sumaSuperficies + superficiePromocionAlquilerActual) > superficieActivoMatriz){
					listaFilas.add(1);
				}

			}
		}catch(Exception e){
			if (i != 0) listaFilas.add(1);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> esPorcentajeCorrecto(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja; i++){
				try{
					Double porcentajeFila = Double.valueOf(exc.dameCelda(i, 13));
					if(porcentajeFila < 0.01 || porcentajeFila > 100){
						listaFilas.add(i);
					}
				}catch(Exception e){
					listaFilas.add(i);
				}
			}
		}catch(Exception e){
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> esPorcentajeTotalCorrecto(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double sumaPorcentaje = 0.0;
		Double porcentajeTotalActual = 0.0;
		
		int i = 0;
		try{
			if(particularValidator.existeAgrupacion(exc.dameCelda(1, 0)) 
					&& particularValidator.esAgrupacionVigente(exc.dameCelda(1, 0))
					&& particularValidator.tieneActivoMatriz(exc.dameCelda(1, 0))){
				if(!Checks.esNulo(particularValidator.getProcentajeTotalActualPromocionAlquiler(exc.dameCelda(1, 0)))){
					porcentajeTotalActual = Double.valueOf(particularValidator.getProcentajeTotalActualPromocionAlquiler(exc.dameCelda(1, 0)));
				}
				
				for(i=1; i<this.numFilasHoja; i++){
					try{
						sumaPorcentaje += Double.valueOf(exc.dameCelda(i, 13));
					}catch(Exception e){
						listaFilas.add(1);
					}
				}
				
				if((porcentajeTotalActual + sumaPorcentaje) > 100.00){
					listaFilas.add(1);
				}
			}
		}catch(Exception e){
			if (i != 0) listaFilas.add(1);
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
				if(particularValidator.isActivoEnConcurrencia(exc.dameCelda(i, 0)))
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
