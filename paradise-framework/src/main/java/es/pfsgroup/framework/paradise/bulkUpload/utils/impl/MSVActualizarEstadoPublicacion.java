package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
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
public class MSVActualizarEstadoPublicacion extends MSVExcelValidatorAbstract {
		
	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_NOT_ACTUALIZABLE = "El estado del activo no puede actualizarse al indicado.";
	public static final String ACTIVE_NOT_PREPUBLICABLE = "El activo no reúne las condiciones para ser publicado (Admisión, Gestión, Informe comercial aceptado).";

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
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
//			if (!isActiveExists(exc)){
				Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
				mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
				mapaErrores.put(ACTIVE_NOT_ACTUALIZABLE, isActiveNotActualizableRows(exc,operacionMasiva));
				
				//Errores especificos para publicaciones ordinarias
				if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PUBLICAR_ORDINARIA.equals(operacionMasiva.getCodigo())){
					mapaErrores.put(ACTIVE_NOT_PREPUBLICABLE, isActiveSinCondicionesPublicableRows(exc));					
				}

				
				try{
					if(!mapaErrores.get(ACTIVE_NOT_EXISTS).isEmpty() || 
							!mapaErrores.get(ACTIVE_NOT_ACTUALIZABLE).isEmpty() ||
							(!Checks.esNulo(mapaErrores.get(ACTIVE_NOT_PREPUBLICABLE)) && !mapaErrores.get(ACTIVE_NOT_PREPUBLICABLE).isEmpty()) ){
						dtoValidacionContenido.setFicheroTieneErrores(true);
						exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
						String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
						FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
						dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
//			}
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
	
	private boolean isActiveExists(MSVHojaExcel exc){
		try {
			for(int i=1; i<exc.getNumeroFilas();i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, 0)))
					return false;
			}
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return true;
	}
	
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, 0)))
					listaFilas.add(i);
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
	
	private List<Integer> isActiveNotActualizableRows(MSVHojaExcel exc, MSVDDOperacionMasiva operacionMasiva){
		List<Integer> listaFilas = new ArrayList<Integer>();

		try{
			for(int i=1; i<exc.getNumeroFilas();i++)
				if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PUBLICAR_ORDINARIA.equals(operacionMasiva.getCodigo()) ||
						MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PUBLICAR.equals(operacionMasiva.getCodigo()))
				{
					// Validación estado no publicado: Se valida que los activos estén "no publicados"
					// y si alguno no tuviera puesto el estado de publicación (null) debe tomarse como "no publicado" para validar
					if(!particularValidator.estadoNoPublicadoOrNull(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARACTIVO.equals(operacionMasiva.getCodigo())){
					if(!particularValidator.estadoOcultaractivo(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARACTIVO.equals(operacionMasiva.getCodigo())){
					if(!particularValidator.estadoDesocultaractivo(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARPRECIO.equals(operacionMasiva.getCodigo())){
					if(!particularValidator.estadoOcultarprecio(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARPRECIO.equals(operacionMasiva.getCodigo())){
					if(!particularValidator.estadoDesocultarprecio(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESPUBLICAR.equals(operacionMasiva.getCodigo())){
					if(!particularValidator.estadoDespublicar(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_AUTORIZAREDICION.equals(operacionMasiva.getCodigo())){
					if(!particularValidator.estadoAutorizaredicion(exc.dameCelda(i, 0)));
						listaFilas.add(i);
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
	
	private List<Integer> isActiveSinCondicionesPublicableRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		try{
			for(int i=1; i<exc.getNumeroFilas();i++){
				if(!particularValidator.isActivoPrePublicable(exc.dameCelda(i, 0))){
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