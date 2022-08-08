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
public class MSVCambioApiValidator extends MSVExcelValidatorAbstract{

	private static final int ACT_NUM_ACTIVO = 0;
	private static final int PVE_COD_REM = 1;
	
	public static final String ACTIVO_NO_EXISTE = "msg.error.masivo.gestores.api.cambios.activo.no.existe";
	public static final String PROVEEDOR_NO_EXISTE = "msg.error.masivo.gestores.api.cambios.proveedor.no.existe";
	public static final String PROVEEDOR_DADO_DE_BAJA = "msg.error.masivo.gestores.api.cambios.proveedor.dado.de.baja";
	
	public static final String ACTIVO_NO_ESTA_RELLENO = "msg.error.masivo.gestores.api.cambios.activo.vacio";
	public static final String PRIMARIO_NO_EXISTE = "msg.error.masivo.gestores.api.primario.no.existe";
	
	public static final String PROVEEDOR_BLOQUEDO_PROVINCIA = "api.bloqueado.provincia";
	public static final String PROVEEDOR_BLOQUEDO_CARTERA = "api.bloqueado.cartera";
	public static final String PROVEEDOR_BLOQUEDO_LN = "api.bloqueado.tipo.comercializacion";
	public static final String PROVEEDOR_BLOQUEDO_ESPECIALIDAD = "api.bloqueado.especialidad";
	
	public static final String VALIDAR_FILA_EXCEPTION = "msg.error.masivo.gestores.exception";
	
	private Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
	
	private final int FILA_DATOS = 1;
	
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
			
			if (!dtoValidacionContenido.getFicheroTieneErrores()) {
				generarMapaErrores();
				if (!validarFichero(exc)) {
					dtoValidacionContenido.setFicheroTieneErrores(true);
					exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
					String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
					FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
					dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
				}
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
			MSVBusinessCompositeValidators compositeValidators)
	{
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
	
	public File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
	
	
	
	private boolean validarFichero(MSVHojaExcel exc) {
		final String CODIGO_MEDIADOR = "MED";
		final String PONER_NULL_A_APIS = "0";
		boolean esCorrecto = true;

		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
				String numActivo = exc.dameCelda(fila, ACT_NUM_ACTIVO);
				String codigoProveedorApi = exc.dameCelda(fila, PVE_COD_REM);

				if (Checks.esNulo(numActivo)) {
					mapaErrores.get(messageServices.getMessage(ACTIVO_NO_ESTA_RELLENO)).add(fila);
					esCorrecto = false;
				}
				
				if (!Checks.esNulo(numActivo) && !particularValidator.existeActivo(numActivo)) {
					mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).add(fila);
					esCorrecto = false;
				}

				if (Checks.esNulo(codigoProveedorApi) && !PONER_NULL_A_APIS.equals(codigoProveedorApi)
						&& !particularValidator.mediadorExisteVigente(codigoProveedorApi)) {
					mapaErrores.get(messageServices.getMessage(PROVEEDOR_NO_EXISTE)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(codigoProveedorApi) && !particularValidator.mediadorExisteVigente(codigoProveedorApi)) {
					mapaErrores.get(messageServices.getMessage(PROVEEDOR_DADO_DE_BAJA)).add(fila);
					esCorrecto = false;
				}
				if(!Checks.esNulo(codigoProveedorApi) && !Checks.esNulo(numActivo)) {
					if(particularValidator.apiBloqueadoProvincia(numActivo, codigoProveedorApi)) {
						mapaErrores.get(messageServices.getMessage(PROVEEDOR_BLOQUEDO_PROVINCIA)).add(fila);
						esCorrecto = false;
					}
					if(particularValidator.apiBloqueadoCartera(numActivo, codigoProveedorApi)) {
						mapaErrores.get(messageServices.getMessage(PROVEEDOR_BLOQUEDO_CARTERA)).add(fila);
						esCorrecto = false;
					}
					if(particularValidator.apiBloqueadoLineaDeNegocio(numActivo, codigoProveedorApi)) {
						mapaErrores.get(messageServices.getMessage(PROVEEDOR_BLOQUEDO_LN)).add(fila);
						esCorrecto = false;
					}
					if(particularValidator.apiBloqueadoEspecialidad(numActivo, codigoProveedorApi)) {
						mapaErrores.get(messageServices.getMessage(PROVEEDOR_BLOQUEDO_ESPECIALIDAD)).add(fila);
						esCorrecto = false;
					}
				}
				

			} catch (Exception e) {
				mapaErrores.get(messageServices.getMessage(VALIDAR_FILA_EXCEPTION)).add(fila);
				esCorrecto = false;
				logger.error(e.getMessage());
			}
		}

		return esCorrecto;
	}
	
	private void generarMapaErrores() {
		mapaErrores = new HashMap<String, List<Integer>>();
		mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_DADO_DE_BAJA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ACTIVO_NO_ESTA_RELLENO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PRIMARIO_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(VALIDAR_FILA_EXCEPTION), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_BLOQUEDO_PROVINCIA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_BLOQUEDO_CARTERA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_BLOQUEDO_LN), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_BLOQUEDO_ESPECIALIDAD), new ArrayList<Integer>());
	}

	
}