package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
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
public class MSVAgrupacionRestringidoExcelValidator extends MSVExcelValidatorAbstract {

	private static final String SEPARATOR = ", ";

	private static final String CODIGO_TIPO_AGRUPACION_RESTRINGIDA = "02";

	public static final String ACTIVE_NOT_SHARING_PLACE = "Todos los activos no comparten la misma PROVINCIA, MUNICIPIO, CP, CARTERA y PROPIETARIO.";
	
	public static final String ACTIVE_IN_AGRUPACION_RESTRINGIDA = "Los siguientes activos pertenecen ya a una agrupación restringida: ";
	
	public static final String ERROR_ACTIVO_DISTINTO_PROPIETARIO = "El propietario del activo es distinto al propietario de la agrupación";
	
	public static final String ACTIVO_ESTADO_PUBLICACION_DISTINTO = "El activo tiene un estado de publicación distinto al de la agrupación.";

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
			logger.error(e.getMessage(), e);
		}
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			List<String> listaErrores = new ArrayList<String>();
			if (!isActiveSharingPlace(exc)) {
				dtoValidacionContenido.setFicheroTieneErrores(true);
				listaErrores.add(ACTIVE_NOT_SHARING_PLACE);
			}
			
			/*if (!comprobarDistintoPropietario(exc)) {
				dtoValidacionContenido.setFicheroTieneErrores(true);
				listaErrores.add(ERROR_ACTIVO_DISTINTO_PROPIETARIO);
			}*/
			
			if (!comprobarEstadoPublicacionActivoAgrupacion(exc)) {
				dtoValidacionContenido.setFicheroTieneErrores(true);
				listaErrores.add(ACTIVO_ESTADO_PUBLICACION_DISTINTO);
			}
			
			String[] activosEnAgrupacion = isActiveInAgrupacionRestringida(exc);
			if (activosEnAgrupacion != null) {
				String errorString = buildMsgWithData(ACTIVE_IN_AGRUPACION_RESTRINGIDA, activosEnAgrupacion);
				if (errorString != null) {
					dtoValidacionContenido.setFicheroTieneErrores(true);
					listaErrores.add(errorString);
				}
			}
			
			if (dtoValidacionContenido.getFicheroTieneErrores()) {
				exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
				String nomFicheroErrores = exc.crearExcelErrores(listaErrores);
				FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
				dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
			}
		}
		exc.cerrar();
		
		
		return dtoValidacionContenido;
	}

	private String buildMsgWithData(String msg, String[] data) {
		if (data == null) {
			return null;
		}
		
		StringBuilder b = null;
		for (String num : data) {
			if (b != null) {
				b.append(SEPARATOR + num);
			} else {
				b = new StringBuilder(msg + num);
			}
		}
		return (b != null) ? b.toString() : null;
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
			logger.error("No se ha podido recuperar la plantilla", e);
		}
		return null;
	}
	
	private boolean isActiveSharingPlace(MSVHojaExcel exc) {
		try {
			if (this.numFilasHoja<3) return true;
			int i = 1;
			String numAgr = exc.dameCelda(i, 0);
			String location = particularValidator.getCarteraLocationByNumAgr(numAgr);
			boolean isFound = false;
			String tmp = null;
			while (!isFound && i < this.numFilasHoja ) {				
				tmp = particularValidator.getCarteraLocationTipPatrimByNumAct(exc.dameCelda(i, 1));
				if (location == null) {
					location = tmp;
				}
				if (tmp==null || !tmp.equals(location)) return false;
				i++;
			}
		} catch (Exception e) {
			logger.error("No se ha podido comprobar la dirección de los activos", e);
			return false;
		}
		
		return true;
	}
	
	private String[] isActiveInAgrupacionRestringida(MSVHojaExcel exc) {
		ArrayList<String> activos = new ArrayList<String>();
		try {
			if (this.numFilasHoja<3) return null;
			int i = 1;
			
			while (i < this.numFilasHoja ) {				
				String numActivo = exc.dameCelda(i, 1);
				if (particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(numActivo), CODIGO_TIPO_AGRUPACION_RESTRINGIDA)) {
					activos.add(numActivo);
				}
				i++;
			}
		} catch (Exception e) {
			throw new RuntimeException("No se ha podido comprobar si los activos están en otras agrupaciones restringidas", e);
		}
		
		return activos.isEmpty() ? null : activos.toArray(new String[]{});
	}

	private boolean comprobarDistintoPropietario(MSVHojaExcel exc) {

		int i = 0;
		try {
			for (i = 1; i < this.numFilasHoja; i++) {
				String numAgrupacion = String.valueOf(Long.parseLong(exc.dameCelda(i, 0)));
				String numActivo = String.valueOf(Long.parseLong(exc.dameCelda(i, 1)));
				if (particularValidator.comprobarDistintoPropietario(numActivo, numAgrupacion))
					return false;
			}
		} catch (Exception e) {
			if (i != 0)
			return false;
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return true;
	}
	
	private boolean comprobarEstadoPublicacionActivoAgrupacion(MSVHojaExcel exc) {
		
		int i = 0;
		try {
			for (i = 1; i < this.numFilasHoja; i++) {
				String numAgrupacion = String.valueOf(Long.parseLong(exc.dameCelda(i, 0)));
				String numActivo = String.valueOf(Long.parseLong(exc.dameCelda(i, 1)));
				if (!particularValidator.isMismoTipoComercializacionActivoPrincipalAgrupacion(numActivo, numAgrupacion)) {
					return false;
				} else {
					if (!particularValidator.isMismoEpuActivoPrincipalAgrupacion(numActivo, numAgrupacion))
						return false;
				}
			}
		} catch (Exception e) {
			if (i != 0)
				return false;
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return true;
	}
	
}
