package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
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
public class MSVValidatorEstadosAdmision extends MSVExcelValidatorAbstract {
	
	private static final String ACTIVO_NO_EXISTE = "msg.error.masivo.listado.validator.activos.deben.existir";
	private static final String ACTIVO_FUERA_PERIMETRO_HAYA = "msg.error.masivo.actualizar.perimetro.activo";
	private static final String ACTIVO_FUERA_PERIMETRO_ADMISION = "msg.error.masivo.admision.validar.perimetro";
	private static final String ESTADO_ADMISION_VALIDO = "msg.error.masivo.admision.estado";
	private static final String SUBESTADO_ADMISION_VALIDO = "msg.error.masivo.admision.subestado";
	private static final String SUBESTADO_EN_ESTADO_ADMISION_VALIDO = "msg.error.masivo.admision.subestado.en.estado";
	private static final String RELACION_ESTADO_SUBESTADO_ADMISION_VALIDO = "msg.error.masivo.admision.relacio.estado.subestado";
	private static final String ACTIVO_REPETIDO = "msg.error.masivo.admision.activo.repetido";
	
	private static final int FILA_CABECERA = 0;
	private static final int FILA_DATOS = 1;
	private static final int COL_NUM_ACTIVO = 0;
	private static final int COL_ESTADO= 1;
	private static final int COL_SUBESTADO= 2;
	
	private Map<String, List<Integer>> mapaErrores;
	private Integer numFilasHoja;
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Resource
    private MessageService messageServices;

	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();
		if (idTipoOperacion == null) {
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		List<String> lista = recuperarFormato(idTipoOperacion);
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getRuta());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(idTipoOperacion));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(idTipoOperacion));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(idTipoOperacion));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(idTipoOperacion);
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getRuta());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(FILA_CABECERA, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			generarMapaErrores();
			
			if (!validarFichero(exc)) {
				dtoValidacionContenido.setFicheroTieneErrores(true);
				dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
			}
		}
		exc.cerrar();
		
		return dtoValidacionContenido;
	}
	
	private boolean validarFichero(MSVHojaExcel exc) {
		boolean esCorrecto = true;
		
		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
				String numActivo = exc.dameCelda(fila, COL_NUM_ACTIVO);
				boolean activoExiste = particularValidator.existeActivo(numActivo);
				
				if(activoExiste) {
					String estadoAdmision = exc.dameCelda(fila, COL_ESTADO);
					String subestadoAdmision = exc.dameCelda(fila, COL_SUBESTADO);
					
					if (!particularValidator.esActivoIncluidoPerimetro(numActivo)) {
						mapaErrores.get(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO_HAYA)).add(fila);
						esCorrecto = false;
					}
					if (activoRepetido(exc, numActivo, fila)) {
						mapaErrores.get(messageServices.getMessage(ACTIVO_REPETIDO)).add(fila);
						esCorrecto = false;
					}
					if (!particularValidator.esActivoIncluidoPerimetroAdmision(numActivo)) {
						mapaErrores.get(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO_ADMISION)).add(fila);
						esCorrecto = false;
					}
					if (!particularValidator.estadoAdmisionValido(estadoAdmision)) {
						mapaErrores.get(messageServices.getMessage(ESTADO_ADMISION_VALIDO)).add(fila);
						esCorrecto = false;
					}
					if (!particularValidator.estadoConSubestadosAdmisionValido(estadoAdmision) && (subestadoAdmision != null && !subestadoAdmision.isEmpty())) {
						mapaErrores.get(messageServices.getMessage(SUBESTADO_EN_ESTADO_ADMISION_VALIDO)).add(fila);
						esCorrecto = false;
					} else {
						if (!particularValidator.subestadoAdmisionValido(subestadoAdmision) && (subestadoAdmision != null && !subestadoAdmision.isEmpty())) {
							mapaErrores.get(messageServices.getMessage(SUBESTADO_ADMISION_VALIDO)).add(fila);
							esCorrecto = false;
						}
					}
					if (!particularValidator.relacionEstadoSubestadoAdmisionValido(estadoAdmision, subestadoAdmision)) {
						mapaErrores.get(messageServices.getMessage(RELACION_ESTADO_SUBESTADO_ADMISION_VALIDO)).add(fila);
						esCorrecto = false;
					}
				} else {
					mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).add(fila);
					esCorrecto = false;
				}
			} catch (Exception e) {
				logger.error(e.getMessage());
				esCorrecto = false;
			}
		}
		
		return esCorrecto;
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
	protected ResultadoValidacion validaContenidoFila(Map<String, String> mapaDatos, List<String> listaCabeceras, MSVBusinessCompositeValidators compositeValidators) {
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
	
	private void generarMapaErrores() {
		mapaErrores = new HashMap<String,List<Integer>>();
		mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO_HAYA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO_ADMISION), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ESTADO_ADMISION_VALIDO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(SUBESTADO_ADMISION_VALIDO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(SUBESTADO_EN_ESTADO_ADMISION_VALIDO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(RELACION_ESTADO_SUBESTADO_ADMISION_VALIDO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ACTIVO_REPETIDO), new ArrayList<Integer>());
	}
	
	private Boolean activoRepetido(MSVHojaExcel exc, String numActivoActual, int fila) {
		List<String> listaActivos = listadoActivos(exc);
		Boolean result = false;	
		listaActivos.remove(fila-1);
		
		
		if(numActivoActual != null 
				&& !listaActivos.isEmpty()
				&& listaActivos.contains(numActivoActual)) {
			result = true;
		}
		return result;
	}
	
	private List<String> listadoActivos(MSVHojaExcel exc){
		List<String> listaActivos = new ArrayList<String>();
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(exc.dameCelda(i, COL_NUM_ACTIVO) != null) {
						listaActivos.add(exc.dameCelda(i, COL_NUM_ACTIVO));
					}
				}catch (ParseException e) {
					e.printStackTrace();
	            }
			}
		}catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
		
		return listaActivos;
	}
	
}