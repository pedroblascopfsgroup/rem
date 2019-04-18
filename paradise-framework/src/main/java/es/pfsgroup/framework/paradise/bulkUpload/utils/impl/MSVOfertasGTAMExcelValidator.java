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
public class MSVOfertasGTAMExcelValidator extends MSVExcelValidatorAbstract{
	
	public static final String OFERTA_NO_EXISTE = "The offer does not exist.";
	public static final String OFERTA_NO_ES_DE_GIANTS = "The offer does not belong to GIANTS.";
	public static final String OFERTA_NO_PENDIENTE_SANCION = "The offer is not pending sanction.";
	public static final String AGRUPACION_NO_EXISTE = "The group does not exists.";
	public static final String AGRUPACION_NO_ES_DE_GIANTS = "The group does not belong to GIANTS.";
	public static final String ACTIVO_NO_EXISTE = "The asset does not exist.";
	public static final String ACTIVO_NO_ES_DE_GIANT = "The asset does not belong to GIANTS.";
	public static final String RESPUESTA_OFERTA_INCORRECTA = "The status of the resolution is incorrect. (Must be 1, 2 or 3)";
	public static final String IMPORTE_CONTRAOFERTA_REQUERIDO = "The count offer amount must be filled.";
	public static final String TIPO_RESOLUCION_INCORRECTO = "The type of commitee's resolution is incorrect. (Must be 1 or 3)";
	public static final String TIPO_DE_CANCELACION_REQUERIDO = "The type of cancellation must be filled.";
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;
	
	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private ParticularValidatorApi particularValidator;
	
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
			mapaErrores.put(OFERTA_NO_EXISTE, isOfferExists(exc));
			mapaErrores.put(OFERTA_NO_ES_DE_GIANTS, isOfferOfGiants(exc));
			mapaErrores.put(OFERTA_NO_PENDIENTE_SANCION, esOfertaPendienteDeSancion(exc));
			mapaErrores.put(AGRUPACION_NO_EXISTE, isAgrupacionExists(exc));
			mapaErrores.put(AGRUPACION_NO_ES_DE_GIANTS, isAgrupacionOfGiants(exc));
			mapaErrores.put(ACTIVO_NO_EXISTE, isActivoExists(exc));
			mapaErrores.put(ACTIVO_NO_ES_DE_GIANT, isActivoOfGiants(exc));
			mapaErrores.put(RESPUESTA_OFERTA_INCORRECTA, validarRespuestaOferta(exc));
			mapaErrores.put(TIPO_RESOLUCION_INCORRECTO, validarTipoResolucion(exc));
			mapaErrores.put(TIPO_DE_CANCELACION_REQUERIDO, validarTipoCancelacion(exc));
			mapaErrores.put(IMPORTE_CONTRAOFERTA_REQUERIDO, validarImporteContraOferta(exc));

			if (!mapaErrores.get(OFERTA_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(OFERTA_NO_ES_DE_GIANTS).isEmpty()
					|| !mapaErrores.get(OFERTA_NO_PENDIENTE_SANCION).isEmpty()
					|| !mapaErrores.get(AGRUPACION_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(AGRUPACION_NO_ES_DE_GIANTS).isEmpty()
					|| !mapaErrores.get(ACTIVO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(ACTIVO_NO_ES_DE_GIANT).isEmpty()
					|| !mapaErrores.get(RESPUESTA_OFERTA_INCORRECTA).isEmpty()
					|| !mapaErrores.get(TIPO_RESOLUCION_INCORRECTO).isEmpty()
					|| !mapaErrores.get(TIPO_DE_CANCELACION_REQUERIDO).isEmpty()
					|| !mapaErrores.get(IMPORTE_CONTRAOFERTA_REQUERIDO).isEmpty()
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
	
	//-------Metodos genericos
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
	
	private File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	//-------Metodos customizados
	private List<Integer> isOfferExists(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja; i++){
				try {
					if(!particularValidator.existeOferta(exc.dameCelda(i, 0))){
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
	
	
	private List<Integer> isOfferOfGiants(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja; i++){
				try {
					if(!particularValidator.isOfferOfGiants(exc.dameCelda(i, 0))){
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
	
	private List<Integer> esOfertaPendienteDeSancion(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja; i++){
				try {
					if(!particularValidator.esOfertaPendienteDeSancion(exc.dameCelda(i, 0))){
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
	
	private List<Integer> isAgrupacionExists(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja; i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, 3)) && !particularValidator.existeAgrupacion(exc.dameCelda(i, 3))){
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
	
	private List<Integer> isAgrupacionOfGiants(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja; i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, 3)) && !particularValidator.existeAgrupacion(exc.dameCelda(i, 3))){
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
	
	private List<Integer> isActivoExists(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja; i++){
				try {
					if(!particularValidator.existeActivo(exc.dameCelda(i, 4))){
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
	
	private List<Integer> isActivoOfGiants(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja; i++){
				try {
					if(!particularValidator.isActivoOfGiants(exc.dameCelda(i, 4))){
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
	
	private List<Integer> validarRespuestaOferta(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja; i++){
				try {
					String respuestaOferta = exc.dameCelda(i, 6);
					if(!"1".equals(respuestaOferta) 
							&& !"2".equals(respuestaOferta)
							&& !"3".equals(respuestaOferta)){
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
	
	private List<Integer> validarTipoResolucion(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja; i++){
				try {
					String tipoResolucion = exc.dameCelda(i, 9);
					
					if(!"1".equals(tipoResolucion)
							&& !"3".equals(tipoResolucion)){
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
	
	private List<Integer> validarTipoCancelacion(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja; i++){
				try {
					String tipoCancelacion = exc.dameCelda(i, 11);
					String tipoResolucion = exc.dameCelda(i, 9);
					String estadoResolucion = exc.dameCelda(i, 6);
					
					if("1".equals(tipoResolucion) && "2".equals(estadoResolucion) && Checks.esNulo(tipoCancelacion)){
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
	
	private List<Integer> validarImporteContraOferta(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja; i++){
				try {
					String importeContraOferta = exc.dameCelda(i, 8);
					String tipoResolucion = exc.dameCelda(i, 9);
					
					if("3".equals(tipoResolucion) && Checks.esNulo(importeContraOferta)){
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
