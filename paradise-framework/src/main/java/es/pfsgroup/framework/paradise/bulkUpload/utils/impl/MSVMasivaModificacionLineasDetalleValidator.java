package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.DecimalFormat;
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
import es.capgemini.pfs.utils.FormatUtils;
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
public class MSVMasivaModificacionLineasDetalleValidator extends MSVExcelValidatorAbstract{
	
	private static final String GASTO_NO_EXISTE = "El gasto no existe";
	private static final String ELEMENTO_CARTERA_DIFERENTE_GASTO = "La cartera de los elementos es diferente a la del gasto";
	private static final String ACTIVO_NO_EXISTE = "El activo no existe";
	private static final String BANKIA_MAS_DE_UNA_LINEA = "La cartera Bankia no puede tener más de una línea";
	private static final String SUBTIPO_DIFERENTE_GASTO = "El subtipo es de un tipo diferente del gasto";
	private static final String YA_EXISTE_UN_SUBTIPO_TIPO_IMPOSITIVO_TIPO_IMPUESTO = "Ya existe una línea con el mismo subtipo de gasto, tipo impositivo o tipo impuesto";
	private static final String SUMA_100 = "Combinación tipo de gestor- cartera - agrupación/activo/expediente invalida";

	public static final Integer COL_ID_GASTO = 0;
	public static final Integer COL_ACCION_LINEA_DETALLE = 1;
	public static final Integer COL_SUBTIPO_GASTO = 2;
	public static final Integer COL_SUJETO_IMPUESTO = 3;
	public static final Integer COL_NO_SUJETO_IMPUESTO = 4;
	public static final Integer COL_TIPO_RECARGO = 5;
	public static final Integer COL_IMPORTE_RECARGO = 6;
	public static final Integer COL_INTERES_DEMORA= 7;
	public static final Integer COL_COSTES = 8;
	public static final Integer COL_OTROS_INCREMENTOS = 9;
	public static final Integer COL_PROVISIONES_SUPLIDOS = 10;
	public static final Integer COL_TIPO_IMPUESTO = 11;
	public static final Integer COL_OPERANCION_EXENTA = 12;
	public static final Integer COL_RENUNCIA_EXENCION = 13;
	public static final Integer COL_TIPO_IMPOSITIVO = 14;
	public static final Integer COL_CRITERIO_CAJA_IVA = 15;
	public static final Integer COL_ID_ELEMENTO = 16;
	public static final Integer COL_TIPO_ELEMENTO= 17;
	public static final Integer COL_PARTICIPACION_LINEA_DETALLE = 18;

	
	private Integer numFilasHoja;	
	private List<String> subtipoGastoImpuestImpositivoList =  new ArrayList <String>();
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private MSVExcelParser excelParser;

	@Autowired
	private MSVBusinessValidationFactory validationFactory;

	@Autowired
	private MSVBusinessValidationRunner validationRunner;

	@Autowired
	private ParticularValidatorApi particularValidator;

	@Autowired
	private MSVProcesoApi msvProcesoApi;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Resource
	MessageService messageServices;

	@Autowired
	private GenericABMDao genericDao;

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
			mapaErrores.put(GASTO_NO_EXISTE, isGastoNotExistsRows(exc));
			mapaErrores.put(ELEMENTO_CARTERA_DIFERENTE_GASTO, isCarteraDiferenteGasto(exc));
			mapaErrores.put(ACTIVO_NO_EXISTE, isExisteActivo(exc));
			mapaErrores.put(BANKIA_MAS_DE_UNA_LINEA, bankiaMasDeUnaLinea(exc));
			mapaErrores.put(SUBTIPO_DIFERENTE_GASTO, subtipoGastoCorrespondeGasto(exc));
			mapaErrores.put(YA_EXISTE_UN_SUBTIPO_TIPO_IMPOSITIVO_TIPO_IMPUESTO, existeUnsubtipoGastoIgual(exc));
			mapaErrores.put(SUMA_100, participaciones(exc));

			if (!mapaErrores.get(GASTO_NO_EXISTE).isEmpty() 
			        || !mapaErrores.get(ELEMENTO_CARTERA_DIFERENTE_GASTO).isEmpty()
					|| !mapaErrores.get(ACTIVO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(BANKIA_MAS_DE_UNA_LINEA).isEmpty()
					|| !mapaErrores.get(SUBTIPO_DIFERENTE_GASTO).isEmpty()
					|| !mapaErrores.get(YA_EXISTE_UN_SUBTIPO_TIPO_IMPOSITIVO_TIPO_IMPUESTO).isEmpty()
					|| !mapaErrores.get(SUMA_100).isEmpty()) {

		    
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

		if ((contentValidators != null) && (contentValidators.getValidatorForColumn(nombreColumna.trim()) != null)) {
			MSVColumnValidator v = contentValidators.getValidatorForColumn(nombreColumna.trim());
			MSVValidationResult result = validationRunner.runValidation(v, contenidoCelda);
			resultado.setValido(result.isValid());
			resultado.setErroresFila(result.getErrorMessage());
		}
		return resultado;
	}


	/**
	 * Realiza validaciones multivalor con diferentes valores de la fila
	 * 
	 * @param mapaDatos
	 * @param compositeValidators
	 * @return
	 */
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
	
	
	   private List<Integer> isGastoNotExistsRows(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) 
	                            && Boolean.FALSE.equals(particularValidator.existeGasto(exc.dameCelda(i, COL_ID_GASTO))))
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
	   
	   private List<Integer> isCarteraDiferenteGasto(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                    	String numElemento = exc.dameCelda(i, COL_ID_ELEMENTO);
                        if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) 
                                && Boolean.FALSE.equals(particularValidator.mismaCarteraLineaDetalleGasto(exc.dameCelda(i, COL_ID_GASTO),numElemento)))
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
	   
	   private List<Integer> isExisteActivo(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                    	String tipoElemento = exc.dameCelda(i,COL_TIPO_ELEMENTO).toUpperCase();
                    	if(tipoElemento == "ACT") {
                        if(!Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)) 
                                && Boolean.FALSE.equals(particularValidator.existeActivo(exc.dameCelda(i, COL_ID_ELEMENTO))))
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
	   
	   private List<Integer> bankiaMasDeUnaLinea(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                    	boolean tieneBorrar = false;
                    	boolean addError = false;
                    	String tipoAccion = exc.dameCelda(i, COL_ACCION_LINEA_DETALLE);
                        if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) && Boolean.FALSE.equals(particularValidator.isActivoBankia(exc.dameCelda(i, COL_ID_GASTO)))) {
                        	if(tipoAccion == "Añadir") {
                        	for(int x = 1; x<i;x++) {
                        		if(exc.dameCelda(x, COL_ID_GASTO) == exc.dameCelda(i, COL_ID_GASTO) && exc.dameCelda(x, COL_ACCION_LINEA_DETALLE) == "Añadir") {
                        			listaFilas.add(i);
                        			addError = true;
                        			break;
                        		}
                        	}
                        	if(Boolean.FALSE.equals(particularValidator.gastoTieneLineaDetalle(exc.dameCelda(i, COL_ID_GASTO))) && !addError) {
                        		for(int x = 1; x<i;x++) {
                            		if(exc.dameCelda(x, COL_ID_GASTO) == exc.dameCelda(i, COL_ID_GASTO) && exc.dameCelda(x, COL_ACCION_LINEA_DETALLE) == "Borrar") {
                            			tieneBorrar = true;
                            			break;
                            		}
                            	}
                        		if(!tieneBorrar) {
                        			listaFilas.add(i);
                        		}
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
	   
	   private List<Integer> subtipoGastoCorrespondeGasto(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) && !Checks.esNulo(exc.dameCelda(i, COL_SUBTIPO_GASTO))
	                            && Boolean.FALSE.equals(particularValidator.subtipoGastoCorrespondeGasto(exc.dameCelda(i, COL_ID_GASTO),exc.dameCelda(i,COL_SUBTIPO_GASTO))))
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
	   
	   private List<Integer> existeUnsubtipoGastoIgual(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();
	       boolean addString = true;
	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                	String result = devolverSubGastoImpuestImpositivo(exc.dameCelda(i, COL_SUBTIPO_GASTO),exc.dameCelda(i, COL_TIPO_IMPOSITIVO),exc.dameCelda(i, COL_TIPO_IMPUESTO),exc.dameCelda(i, COL_ID_GASTO),exc.dameCelda(i, COL_OPERANCION_EXENTA),exc.dameCelda(i, COL_RENUNCIA_EXENCION));
	                	if(!Checks.estaVacio(subtipoGastoImpuestImpositivoList)) {
	                		for (String j : subtipoGastoImpuestImpositivoList) {
								if(j.equals(result)) {
								   addString = false;
								   listaFilas.add(i);
								   break;
								}
								
							}
	                		if(addString) {
	                		  subtipoGastoImpuestImpositivoList.add(result);
	                		}
	                	}else {
	                		subtipoGastoImpuestImpositivoList.add(result);
	                	}
	                	String[] separador = subtipoGastoImpuestImpositivoList.get(0).split("-");
	                	
	                	if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) && !Checks.esNulo(exc.dameCelda(i, COL_SUBTIPO_GASTO))
	                            && Boolean.FALSE.equals(particularValidator.lineaSubtipoDeGastoRepetida(separador[0],separador[1],separador[3],separador[2])))
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
	   
	   public String devolverSubGastoImpuestImpositivo(String subtipoGasto, String tipoImpositivo, String tipoImpuesto, String gasto, String operacionExenta, String renunciaExenta){ 
		   String subtipoGastoImpuestImpositivo = gasto + "-" + subtipoGasto;
		   
		   boolean exento = false;
		   
		   if ("Si".equalsIgnoreCase(operacionExenta))
			   exento = true;
		   
		   if ("Si".equalsIgnoreCase(renunciaExenta))
			   exento = false;
		   
		   if(!Checks.esNulo(tipoImpuesto) && !exento) {
			   subtipoGastoImpuestImpositivo = subtipoGastoImpuestImpositivo + "-" +tipoImpuesto;
			   if(!Checks.esNulo(tipoImpositivo)) {
				   subtipoGastoImpuestImpositivo = subtipoGastoImpuestImpositivo + "-" + tipoImpositivo;
			   }else {
				   subtipoGastoImpuestImpositivo = subtipoGastoImpuestImpositivo + "-" + "0";
			   }
			
		   }
		   return subtipoGastoImpuestImpositivo;
	   }
	   
	   private List<Integer> participaciones(MSVHojaExcel exc){
		   List<Integer> listaFilas = new ArrayList<Integer>();
	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                	String numGasto = exc.dameCelda(i, COL_ID_GASTO);
	                	int participacion = 0;
	                	participacion = participacion +  Integer.parseInt(exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE));
	                	for (int x = 0 ; x<i ; x++) {
	                		if (numGasto.equals(exc.dameCelda(x, COL_ID_GASTO))) {
	                			participacion = participacion +  Integer.parseInt(exc.dameCelda(x, COL_PARTICIPACION_LINEA_DETALLE));
	                			if(participacion > 100) {
	                				listaFilas.add(i);
	                				break;
	                			}
	                		}
	                	}
	                	
	                	if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO))
	                            && Boolean.FALSE.equals(particularValidator.participaciones(numGasto)))
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
	   
	   
	   
}