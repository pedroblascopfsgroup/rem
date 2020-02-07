package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
public class MSVActualizacionLPOExcelValidator extends MSVExcelValidatorAbstract{
	public static final class COL_NUM {
		static final int FILA_CABECERA = 1;
		static final int DATOS_PRIMERA_FILA = 2;
		static final int ACT_NUM_ACTIVO = 0;
		static final int ACT_ES_LPO = 1;
		static final int ACT_ESTADO = 2;
		static final int ACT_FECHA_SOLICITUD = 3;
		static final int ACT_FECHA_OBTENCION = 4;
		static final int ACT_FECHA_VALIDACION = 5;
	};

	public static final String ACTIVO_NO_EXISTE = "El activo no existe.";
	public static final String ACTIVO_NO_ESTADO_FISICO = "El activo debe estar en el estado físico producto terminado (obra nueva o segunda mano).";
	public static final String ACTIVO_NO_EN_PERIMETRO_HAYA = "El activo está fuera del perímetro de HAYA.";
	public static final String ACTIVO_ES_AM_Y_PERTENECE_PA_ACTIVA = "El activo es un Activo Matriz y pertenece a una Promoción de Alquiler activa, no se puede realizar la acción";
	public static final String ACTIVO_ES_UNIDAD_ALQUILABLE = "El activo es de tipo unidad alquilable, no se puede realizar la acción";
	public static final String ESTADO_INCORRECTO = "El código de estado no tiene un valor correcto";

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
			this.setNumFilasHoja(exc.getNumeroFilasByHoja(0, operacionMasiva));
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(ACTIVO_NO_EXISTE, isActiveNotExistsRows(exc));
			mapaErrores.put(ACTIVO_NO_ESTADO_FISICO, isProductoTerminadoNotExistsRows(exc));
			mapaErrores.put(ACTIVO_NO_EN_PERIMETRO_HAYA, isPerimetroHAYANotExistsRows(exc));
			mapaErrores.put(ACTIVO_ES_AM_Y_PERTENECE_PA_ACTIVA, isActivoMatrizPromoAlquilerNotExistsRows(exc));
			mapaErrores.put(ACTIVO_ES_UNIDAD_ALQUILABLE,isUnidadAlquilableNotExistsRows (exc));
			mapaErrores.put(ESTADO_INCORRECTO,noExisteEstado(exc));
			
			if (!mapaErrores.get(ACTIVO_NO_EXISTE).isEmpty() 
					|| !mapaErrores.get(ACTIVO_NO_ESTADO_FISICO).isEmpty()
					|| !mapaErrores.get(ACTIVO_NO_EN_PERIMETRO_HAYA).isEmpty()
					|| !mapaErrores.get(ACTIVO_ES_AM_Y_PERTENECE_PA_ACTIVA).isEmpty()
					|| !mapaErrores.get(ACTIVO_ES_UNIDAD_ALQUILABLE).isEmpty()
					|| !mapaErrores.get(ESTADO_INCORRECTO).isEmpty())
				{
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
	
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)) && !particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)))
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
	
	private List<Integer> isProductoTerminadoNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if (particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO))){
						if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)) && !particularValidator.esActivoProductoTerminado(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)))
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
	
	private List<Integer> isPerimetroHAYANotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if (particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO))){
						if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)) && !particularValidator.esActivoIncluidoPerimetro(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)))
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
	private List<Integer> isActivoMatrizPromoAlquilerNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if (particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO))){
						if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)) && particularValidator.isActivoMatriz(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)) 
								&& !particularValidator.existeActivoConExpedienteComercialVivo(exc.dameCelda(i,COL_NUM.ACT_NUM_ACTIVO)))
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
	//No es posible realizar esta acción para este tipo de activo (UA)
	private List<Integer> isUnidadAlquilableNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				
				try {
					if (particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO))){	
						if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)) && particularValidator.isUA(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)))
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
	
	private List<Integer> noExisteEstado(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				
				try {
					if (particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO))){	
						if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)) && particularValidator.noExisteEstado(exc.dameCelda(i, COL_NUM.ACT_ESTADO)))
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
	
	public Integer getNumFilasHoja() {
		return numFilasHoja;
	}

	public void setNumFilasHoja(Integer numFilasHoja) {
		this.numFilasHoja = numFilasHoja;
	}
}
