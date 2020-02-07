/**
 * @author carlos.augusto@pfsgroup.es
 */

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

import org.apache.commons.lang.StringUtils;
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
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVEnvioBurofaxExcelValidator.COL_NUM;


@Component
public class MSVActualizacionFormalizacionExcelValidator extends  MSVExcelValidatorAbstract{
	private static final String NUM_EXPEDIENTE_COMERCIAL_NO_EXISTE = "msg.error.masivo.formalizacion.no.existe.expediente";
	private static final String FINANCIACION_COMPROBACION = "msg.error.masivo.formalizacion.no.existe.financiacion";
	private static final String ENTIDAD_FINANCIERA = "msg.error.masivo.formalizacion.no.existe.entidad.financiero";
	private static final String NUM_EXPEDIENTE_NO_PERTENECE_A_ACTIVO_VENTA = "msg.error.masivo.formalizacion.no.existe.expediente.venta";
	private static final String NUM_EXPEDIENTE_NO_VENDIDO = "msg.error.masivo.formalizacion.no.existe.expediente.vendido";
	private static final String TIPO_FINANCIACION = "msg.error.masivo.formalizacion.no.existe.expediente.tipo.financiacion";
	private static final String NUM_EXPEDIENTE_NUMERICO = "msg.error.masivo.formalizacion.numero.expediente.numerico";
	private static final String ENTIDAD_FINANCIERA_OBLIGATORIA = "msg.error.masivo.formalizacion.financiacion.si.obligatorio.entidad.financiera";
	

	private String CHECK_VALOR_SI = "SI";
	private String CHECK_VALOR_NO = "NO";
	//COLUMNAS
	private static final int COL_NUM_EXPEDIENTE_COMERCIAL = 0;
	private static final int COL_FINANCIACION = 1;
	private static final int COL_ENTIDAD_FINANCIERA = 2;
	private static final int COL_NUM_EXPEDIENTE = 3;
	private static final int COL_TIPO_DE_FINANCIACION = 4;

	@Resource
    private MessageService messageServices;

	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;		
	
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
			//CAMPOS OBLIGATORIOS FALTAN
			mapaErrores.put(messageServices.getMessage(NUM_EXPEDIENTE_COMERCIAL_NO_EXISTE), existeNumExpedienteComercial(exc));
			mapaErrores.put(messageServices.getMessage(FINANCIACION_COMPROBACION), isSioNo(exc,COL_FINANCIACION));
			mapaErrores.put(messageServices.getMessage(ENTIDAD_FINANCIERA), existeEntidadFinanciera(exc));		
			mapaErrores.put(messageServices.getMessage(NUM_EXPEDIENTE_NO_PERTENECE_A_ACTIVO_VENTA), perteneceOfertaVenta(exc));
			mapaErrores.put(messageServices.getMessage(NUM_EXPEDIENTE_NO_VENDIDO), existenActivosVendidos(exc));
			mapaErrores.put(messageServices.getMessage(TIPO_FINANCIACION), existeTipoDeFinanciacion(exc));	
			mapaErrores.put(messageServices.getMessage(NUM_EXPEDIENTE_NUMERICO), numExpedienteNumerico(exc));
			mapaErrores.put(messageServices.getMessage(ENTIDAD_FINANCIERA_OBLIGATORIA), obligatoriedadSiFinanciacion(exc));
				
			if (!mapaErrores.get(messageServices.getMessage(NUM_EXPEDIENTE_COMERCIAL_NO_EXISTE)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(FINANCIACION_COMPROBACION)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ENTIDAD_FINANCIERA)).isEmpty()				
					|| !mapaErrores.get(messageServices.getMessage(NUM_EXPEDIENTE_NO_PERTENECE_A_ACTIVO_VENTA)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(NUM_EXPEDIENTE_NO_VENDIDO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(TIPO_FINANCIACION)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(NUM_EXPEDIENTE_NUMERICO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ENTIDAD_FINANCIERA_OBLIGATORIA)).isEmpty())
			
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

	private List<Integer> existeNumExpedienteComercial(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i = 0;
		try {
			for (i = 1; i < this.numFilasHoja; i++) {
				
				if (!particularValidator.existeExpedienteComercial((exc.dameCelda(i, COL_NUM_EXPEDIENTE_COMERCIAL)))) {
					listaFilas.add(i);
				}	
			}
		} catch (ParseException e) {
			listaFilas.add(i);

		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());			
			e.printStackTrace();
		}
		
		return listaFilas;
	}

	private List<Integer> perteneceOfertaVenta(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i = 0;
		try{
			for( i=1; i<this.numFilasHoja;i++){		
				if(!particularValidator.perteneceOfertaVenta((exc.dameCelda(i, COL_NUM_EXPEDIENTE_COMERCIAL))))
					listaFilas.add(i);
			}
		} catch (ParseException e) {
			listaFilas.add(i);	
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> existenActivosVendidos(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i =0;
		try{
			for( i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.activosVendidos((exc.dameCelda(i, COL_NUM_EXPEDIENTE_COMERCIAL))))
					listaFilas.add(i);
			}
		} catch (ParseException e) {
			listaFilas.add(i);
		
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> isSioNo(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String valorBool = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				valorBool = exc.dameCelda(i, columnNumber);

				// Si el valor Boolean no se corresponde con el estándar.
				if (!Checks.esNulo(valorBool) && (!valorBool.equalsIgnoreCase("S") && !valorBool.equalsIgnoreCase("N")
						&& !valorBool.equalsIgnoreCase(CHECK_VALOR_SI) && !valorBool.equalsIgnoreCase(CHECK_VALOR_NO) &&  !valorBool.trim().equals("@")  )) {
					listaFilas.add(i);
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	private List<Integer> existeEntidadFinanciera(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.existeEntidadFinanciera(exc.dameCelda(i, COL_ENTIDAD_FINANCIERA)) && !exc.dameCelda(i, COL_ENTIDAD_FINANCIERA).trim().equals("@"))								
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
		}

		return listaFilas;
	}
	
	private List<Integer> existeTipoDeFinanciacion(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i=0;		
		try{
			for(i=1; i<this.numFilasHoja;i++){				
				if(!particularValidator.existeTipoDeFinanciacion(exc.dameCelda(i, COL_TIPO_DE_FINANCIACION))   &&  !exc.dameCelda(i, COL_TIPO_DE_FINANCIACION).trim().equals("@"))
					listaFilas.add(i);
			}
		}catch (ParseException e) {
			listaFilas.add(i);
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> numExpedienteNumerico(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i=0;		
		try{
			for(i=1; i<this.numFilasHoja;i++){				
				if(!StringUtils.isNumeric((exc.dameCelda(i, COL_NUM_EXPEDIENTE))) && !exc.dameCelda(i, COL_NUM_EXPEDIENTE).trim().equals("@"))
					listaFilas.add(i);
			}
		}catch (ParseException e) {
			listaFilas.add(i);
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> obligatoriedadSiFinanciacion(MSVHojaExcel exc){
			List<Integer> listaFilas = new ArrayList<Integer>();
			int i = 0;
			try {
				for (i = 1; i < this.numFilasHoja; i++) {
					
					if(exc.dameCelda(i, COL_FINANCIACION).equals(CHECK_VALOR_SI) && exc.dameCelda(i, COL_ENTIDAD_FINANCIERA).isEmpty()) {				
						listaFilas.add(i);
					}
				}
			} catch (ParseException e) {
				listaFilas.add(i);
	
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
				e.printStackTrace();
			}
			
			return listaFilas;
	}
}