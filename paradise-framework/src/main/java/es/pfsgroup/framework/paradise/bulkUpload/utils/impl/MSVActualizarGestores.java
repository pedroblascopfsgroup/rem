package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
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
public class MSVActualizarGestores extends MSVExcelValidatorAbstract {
		
	public static final String ACTIVO_NO_EXISTE = "El activo no existe.";
	public static final String AGRUPACION_NO_EXISTE = "La agrupacion no existe.";
	public static final String EXPEDIENTE_COMERCIAL_NO_EXISTE = "El expediente comercial no existe.";
	public static final String TIPO_GESTOR_NO_EXISTE = "El tipo de gestor no existe.";
	public static final String USERNAME_NO_EXISTE = "El username no existe.";
	public static final String SOLO_UN_CAMPO_RELLENO = "Solo debe rellenar un campo: ACTIVO, AGRUPACION o EXPEDIENTE.";
	public static final String USUARIO_NO_ES_TIPO_GESTOR= "El usuario no corresponde con el Tipo de gestor";
	public static final String COMBINACION_GESTOR_CARTERA_ACAGEX_INVALIDA= "Combinación tipo de gestor- cartera - agrupación/activo/expediente invalida";
	public static final String MEDIADOR_NO_EXISTE = "El mediador introducido no existe o esta dado de baja en REM";
	public static final String EXPEDIENTE_MEDIADOR_NO_ACTUALIZA = "El mediador solo se puede actualizar en caso de activo o agrupación";
	
	public static final String GESTOR_MEDIADOR = "MED";
	
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
			// if (!isActiveExists(exc)){
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(ACTIVO_NO_EXISTE, isActiveNotExistsRows(exc));
			mapaErrores.put(AGRUPACION_NO_EXISTE, isAgrupacionNotExistsRows(exc));
			mapaErrores.put(EXPEDIENTE_COMERCIAL_NO_EXISTE, isExpedienteNotExistsRows(exc));
			mapaErrores.put(TIPO_GESTOR_NO_EXISTE, isTipoGestorNotExistsRows(exc));
			mapaErrores.put(USERNAME_NO_EXISTE, isUsuarioNotExistsRows(exc));
			mapaErrores.put(SOLO_UN_CAMPO_RELLENO, soloUnCampoRelleno(exc));
			mapaErrores.put(USUARIO_NO_ES_TIPO_GESTOR, usuarioEsTipoGestor(exc));
			mapaErrores.put(COMBINACION_GESTOR_CARTERA_ACAGEX_INVALIDA, combinacionGestorCarteraAcagexValida(exc));
			mapaErrores.put(MEDIADOR_NO_EXISTE, mediadorExiste(exc));
			mapaErrores.put(EXPEDIENTE_MEDIADOR_NO_ACTUALIZA, expedienteMediadorNoActualiza(exc));

			if (!mapaErrores.get(ACTIVO_NO_EXISTE).isEmpty() || !mapaErrores.get(AGRUPACION_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(EXPEDIENTE_COMERCIAL_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(TIPO_GESTOR_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(USERNAME_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(SOLO_UN_CAMPO_RELLENO).isEmpty()
					|| !mapaErrores.get(USUARIO_NO_ES_TIPO_GESTOR).isEmpty()
					|| !mapaErrores.get(COMBINACION_GESTOR_CARTERA_ACAGEX_INVALIDA).isEmpty()
					|| !mapaErrores.get(MEDIADOR_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(EXPEDIENTE_MEDIADOR_NO_ACTUALIZA).isEmpty()) {
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
	
	private File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}
		
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, 2)) && !particularValidator.existeActivo(exc.dameCelda(i, 2)))
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
	
	private List<Integer> isExpedienteNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, 4)) && !particularValidator.existeExpedienteComercial(exc.dameCelda(i, 4)))
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
	
	private List<Integer> isAgrupacionNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, 3)) && !particularValidator.existeAgrupacion(exc.dameCelda(i, 3)))
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
	
	private List<Integer> isTipoGestorNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!GESTOR_MEDIADOR.equals(exc.dameCelda(i, 0).toUpperCase()) && !particularValidator.existeTipoGestor(exc.dameCelda(i, 0))) {
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
	
	private List<Integer> isUsuarioNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, 1)) && !particularValidator.existeUsuario(exc.dameCelda(i, 1))) {
						listaFilas.add(i);
					}else if(Checks.esNulo(exc.dameCelda(i, 5))) {
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
	
	private List<Integer> soloUnCampoRelleno(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String numActivo= exc.dameCelda(i, 2);
					String numAgrupacion= exc.dameCelda(i, 3);
					String numExpediente= exc.dameCelda(i, 4);
					
					if((!Checks.esNulo(numActivo) && (!Checks.esNulo(numAgrupacion) || !Checks.esNulo(numExpediente))) ||
						(!Checks.esNulo(numAgrupacion) && (!Checks.esNulo(numActivo) || !Checks.esNulo(numExpediente))) ||
						(!Checks.esNulo(numExpediente) && (!Checks.esNulo(numActivo) || !Checks.esNulo(numAgrupacion))) ||
						(Checks.esNulo(numAgrupacion) && Checks.esNulo(numExpediente) && Checks.esNulo(numActivo))){
						
						listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		}catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
		
	}
	
	private List<Integer> usuarioEsTipoGestor(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String codigoTipoGestor= exc.dameCelda(i, 0);
					String username= exc.dameCelda(i, 1);
					
					if(!GESTOR_MEDIADOR.equals(exc.dameCelda(i, 0).toUpperCase()) && (!Checks.esNulo(codigoTipoGestor) || !Checks.esNulo(username))){
						if(!particularValidator.usuarioEsTipoGestor(username, codigoTipoGestor)){
							listaFilas.add(i);
						}
					}
					
					
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		}catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> combinacionGestorCarteraAcagexValida(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String numActivo= exc.dameCelda(i, 2);
					String numAgrupacion= exc.dameCelda(i, 3);
					String numExpediente= exc.dameCelda(i, 4);
					String codigoTipoGestor= exc.dameCelda(i, 0);
					String username= exc.dameCelda(i, 1);
					
					if(!GESTOR_MEDIADOR.equals(codigoTipoGestor.toUpperCase()) && (!Checks.esNulo(numAgrupacion) || !Checks.esNulo(numExpediente))){
						if(!particularValidator.combinacionGestorCarteraAcagexValida(codigoTipoGestor,numActivo,numAgrupacion,numExpediente)){
							listaFilas.add(i);
						}
					}
					
					
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		}catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
		
		
		
	}
	
	private List<Integer> mediadorExiste(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String codMediador = exc.dameCelda(i, 5);
					
					if(!Checks.esNulo(codMediador) && !particularValidator.mediadorExisteVigente(codMediador)) {
						listaFilas.add(i);
					}
					
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		}catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
		
	}
	
	private List<Integer> expedienteMediadorNoActualiza(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String codMediador = exc.dameCelda(i, 5);
					String numExpediente = exc.dameCelda(i, 4);
					
					if(!Checks.esNulo(codMediador) && !Checks.esNulo(numExpediente)) {
						listaFilas.add(i);
					}
					
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		}catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
}
