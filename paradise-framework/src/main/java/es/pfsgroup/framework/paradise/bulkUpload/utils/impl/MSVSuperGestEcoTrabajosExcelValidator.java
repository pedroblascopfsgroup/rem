package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVAltaActivosExcelValidator.COL_NUM;

@Component
public class MSVSuperGestEcoTrabajosExcelValidator extends MSVExcelValidatorAbstract {
	
	private static final String TRABAJO_NO_EXISTE = "msg.error.masivo.trabajo.no.existe";
	private static final String TRABAJO_TIENE_GASTOS = "msg.error.masivo.trabajo.tiene.gastos";
	private static final String PRECIO_UNITARIO_VALOR_INVALIDO = "msg.error.masivo.precio.unitario.valor.invalido";
	private static final String IMPORTE_TOTAL_VALOR_INVALIDO= "msg.error.masivo.importe.total.valor.invalido"; 
	private static final String IMPORTE_TOTAL_INCORRECTO = "msg.error.masivo.importe.total.incorrecto";
	private static final String SUMATORIO_IMPORTE_TOTAL_INCORRECTO = "msg.error.masivo.sumatorio.importe.total.incorrecto";
	private static final String SUMATORIO_IMPORTE_TOTAL_VALOR_INVALIDO = "msg.error.masivo.sumatorio.importe.total.valor.invalido";
	private static final String ORDEN_TRABAJOS_INCORRECTO = "msg.error.masivo.orden.trabajos.incorrecto";
	private static final String TIPO_TARIFA_NO_EXISTE = "msg.error.masivo.tipo.tarifa.no.existe";
	private static final String TIPO_TARIFA_INVALIDO = "msg.error.masivo.tipo.tarifa.invalido";
	private static final String TIPO_TARIFA_NO_INDICADA = "msg.error.masivo.tipo.tarifa.no.indicada";
	private static final String TRABAJO_TARIFADO = "msg.error.masivo.orden.trabajo.tarifado";

	
	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		
		static final int COL_NUM_TRABAJO = 0;
		static final int COL_TIPO_TARIFA = 1;
		static final int COL_PRECIO_UNITARIO = 2;
		static final int COL_MEDICION = 3;
		static final int COL_IMPORTE_TOTAL = 4;
		static final int COL_SUMATORIO_IMPORTE_TOTAL = 5;	
	}

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
	
	private double sumImporteTotal=0;
	
	private int contadorFilas=0;
	
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

			mapaErrores.put(messageServices.getMessage(ORDEN_TRABAJOS_INCORRECTO), isInvalidOrder(exc));
			mapaErrores.put(messageServices.getMessage(TRABAJO_NO_EXISTE), isWorkNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(TRABAJO_TIENE_GASTOS), isWorkHaveExpensesRows(exc));
			mapaErrores.put(messageServices.getMessage(TRABAJO_TARIFADO), incorrectNumberOfRate(exc));
			mapaErrores.put(messageServices.getMessage(PRECIO_UNITARIO_VALOR_INVALIDO), isNumberRows(exc,COL_NUM.COL_PRECIO_UNITARIO));
			mapaErrores.put(messageServices.getMessage(IMPORTE_TOTAL_INCORRECTO), importeTotalisValidRow(exc));
			mapaErrores.put(messageServices.getMessage(IMPORTE_TOTAL_VALOR_INVALIDO), isNumberRows(exc,COL_NUM.COL_IMPORTE_TOTAL));
			mapaErrores.put(messageServices.getMessage(SUMATORIO_IMPORTE_TOTAL_VALOR_INVALIDO), isNumberRows(exc,COL_NUM.COL_SUMATORIO_IMPORTE_TOTAL));
			mapaErrores.put(messageServices.getMessage(SUMATORIO_IMPORTE_TOTAL_INCORRECTO), summationIncorrect(exc));
			mapaErrores.put(messageServices.getMessage(TIPO_TARIFA_INVALIDO), tipeOfRateValid(exc));
			mapaErrores.put(messageServices.getMessage(TIPO_TARIFA_NO_EXISTE), tipeOfRateExists(exc));
			mapaErrores.put(messageServices.getMessage(TIPO_TARIFA_NO_INDICADA), isTipeOfRateNullRows(exc));
			
			if (!mapaErrores.get(messageServices.getMessage(TRABAJO_NO_EXISTE)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(TRABAJO_TIENE_GASTOS)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(IMPORTE_TOTAL_VALOR_INVALIDO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(TRABAJO_TARIFADO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(PRECIO_UNITARIO_VALOR_INVALIDO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(SUMATORIO_IMPORTE_TOTAL_VALOR_INVALIDO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ORDEN_TRABAJOS_INCORRECTO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(SUMATORIO_IMPORTE_TOTAL_INCORRECTO)).isEmpty()
				    || !mapaErrores.get(messageServices.getMessage(TIPO_TARIFA_NO_EXISTE)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(IMPORTE_TOTAL_INCORRECTO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(TIPO_TARIFA_INVALIDO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(TIPO_TARIFA_NO_INDICADA)).isEmpty()) 
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
	
	private List<Integer> isInvalidOrder(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<Long> trabajos = new ArrayList<Long>();

		try{
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				
				try {
					if(trabajos.size()!=0) {
						if(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO)) != trabajos.get(trabajos.size()- 1) && trabajos.contains(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO)))) {
							listaFilas.add(i);
						}else {
							trabajos.add(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO)));
						}
							
					 }else {
						 trabajos.add(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO)));
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
	
	private List<Integer> isWorkNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
				    // Modifico la función particularValidator.existeTrabajo pues retornaba lógica confusa.
					if(Boolean.FALSE.equals(particularValidator.existeTrabajo(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO))))
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
	
	private List<Integer> isWorkHaveExpensesRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.existeGastoTrabajo(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO)))
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
	
	private List<Integer> incorrectNumberOfRate(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<Long> trabajos = new ArrayList<Long>();

		try{
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				
				try {
					if(trabajos.size()!=0) {
						if(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO)) == trabajos.get(trabajos.size() - 1)) {
							contadorFilas ++;
							if(i == (this.numFilasHoja -1)) {
								if(particularValidator.compararNumeroFilasTrabajo(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO),contadorFilas)) {
									listaFilas.add(i);
								}								
							}
						} else {
							contadorFilas =1;
							trabajos.add(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO)));
							if(particularValidator.compararNumeroFilasTrabajo(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO),1)) {
								if(particularValidator.compararNumeroFilasTrabajo(exc.dameCelda(i-1, COL_NUM.COL_NUM_TRABAJO),contadorFilas)) {
									listaFilas.add(i);
								}
							}
						}	
					} else {
						contadorFilas =1;
						trabajos.add(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO)));
						if(i+1 == this.numFilasHoja) {
							if(particularValidator.compararNumeroFilasTrabajo(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO),contadorFilas)) {
								listaFilas.add(i);
							}	
						}
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
	
	private List<Integer> tipeOfRateValid(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.compararNumeroFilasTrabajo(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO),1)) {
						if(particularValidator.tipoTarifaValido(exc.dameCelda(i, COL_NUM.COL_TIPO_TARIFA),exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO))) {
							listaFilas.add(i);
						}
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
	
	private List<Integer> tipeOfRateExists(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.compararNumeroFilasTrabajo(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO),1)) {
						if(particularValidator.existeTipoTarifa(exc.dameCelda(i, COL_NUM.COL_TIPO_TARIFA))) {
							listaFilas.add(i);
						}	
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
	
	private List<Integer> isNumberRows(MSVHojaExcel exc, int columna) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precio = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				
				String value = exc.dameCelda(i, columna);
				if(value != null && !value.isEmpty()){
					if(value.contains(",")){
						value = value.replace(",", ".");
					}
				}
				
				precio = !Checks.esNulo(value)
						? Double.parseDouble(value) : null;

				// Si el precio no es un número válido.
				if ((!Checks.esNulo(precio) && precio.isNaN()) || precio < 0)
					listaFilas.add(i);
			} catch (NumberFormatException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
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
	
	private List<Integer> summationIncorrect(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<Long> trabajos = new ArrayList<Long>();
		List<Integer> filasSumatorio = new ArrayList<Integer>();
		
		try{
			for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
				
				try {
					if(trabajos.size()!=0) {
						if(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO)) == trabajos.get(trabajos.size()-1)) {
							sumImporteTotal = Double.parseDouble(exc.dameCelda(i, COL_NUM.COL_IMPORTE_TOTAL)) + sumImporteTotal;
							filasSumatorio.add(i);			
							if(i+1 == this.numFilasHoja) {
								for (int x = 0; x < filasSumatorio.size(); x++) {
									if(Double.parseDouble(exc.dameCelda(filasSumatorio.get(x), COL_NUM.COL_SUMATORIO_IMPORTE_TOTAL)) != sumImporteTotal){
										listaFilas.add(filasSumatorio.get(x));
									}  
								}
							}
						} else {							
							trabajos.add(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO)));
							for (int x = 0; x < filasSumatorio.size(); x++) {
								if(Double.parseDouble(exc.dameCelda(filasSumatorio.get(x), COL_NUM.COL_SUMATORIO_IMPORTE_TOTAL)) != sumImporteTotal){
									listaFilas.add(filasSumatorio.get(x));
								}  
							}
						      
							sumImporteTotal = Double.parseDouble(exc.dameCelda(i, COL_NUM.COL_IMPORTE_TOTAL));
							filasSumatorio.clear();
							  
							if(this.numFilasHoja == i+1) {
								if(Double.parseDouble(exc.dameCelda(i, COL_NUM.COL_SUMATORIO_IMPORTE_TOTAL)) != Double.parseDouble(exc.dameCelda(i, COL_NUM.COL_IMPORTE_TOTAL)) ) {
									listaFilas.add(i);
								}
							} else {
								if(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO)) != Long.parseLong(exc.dameCelda(i+1, COL_NUM.COL_NUM_TRABAJO))) {
									if(Double.parseDouble(exc.dameCelda(i, COL_NUM.COL_SUMATORIO_IMPORTE_TOTAL)) != Double.parseDouble(exc.dameCelda(i, COL_NUM.COL_IMPORTE_TOTAL)) ) {
										listaFilas.add(i);
									}
								} else {
									filasSumatorio.add(i);
								}
							}	
						}
					} else {
						trabajos.add(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO)));
						sumImporteTotal = Double.parseDouble(exc.dameCelda(i, COL_NUM.COL_IMPORTE_TOTAL));
						
						if(this.numFilasHoja <= 2) {
							if(Double.parseDouble(exc.dameCelda(i, COL_NUM.COL_SUMATORIO_IMPORTE_TOTAL)) != Double.parseDouble(exc.dameCelda(i, COL_NUM.COL_IMPORTE_TOTAL)) ) {
								listaFilas.add(i);
							}
						} else {
							filasSumatorio.add(i);
						}
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
	
	
	private List<Integer> importeTotalisValidRow(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(Double.parseDouble(exc.dameCelda(i, COL_NUM.COL_IMPORTE_TOTAL)) != Double.parseDouble(exc.dameCelda(i, COL_NUM.COL_PRECIO_UNITARIO)) * Double.parseDouble(exc.dameCelda(i, COL_NUM.COL_MEDICION))) {
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
		
	private File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private List<Integer> isTipeOfRateNullRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();				
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.compararNumeroFilasTrabajo(exc.dameCelda(i, COL_NUM.COL_NUM_TRABAJO),1)) {
						if(exc.dameCelda(i, COL_NUM.COL_TIPO_TARIFA).trim()==null || exc.dameCelda(i, COL_NUM.COL_TIPO_TARIFA).trim().equals("")){
							listaFilas.add(i);
						}
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
	
	private int getLengthDecimal(String value) {
		if(value != null && !value.isEmpty()){
			if(value.contains(",")){
				value = value.replace(",", ".");
				}
				DecimalFormat df = new DecimalFormat("#.00");
				return (df.format(Double.parseDouble(value)).length()-1);
		}
		return (Integer) null;	
		
	}	
}

