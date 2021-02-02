package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.Checks;
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
public class MSVActualizacionCamposConvivenciaSarebValidator extends MSVExcelValidatorAbstract {

	private static final String CAMPO_NO_EXISTE = "msg.error.masivo.convivencia.sareb.no.campo";
	private static final String ACTIVO_NO_EXISTE = "msg.error.masivo.convivencia.sareb.no.activo";
	private static final String DEPENCENCIA_SUBTIPO_REGISTRO = "msg.error.masivo.convivencia.sareb.vacio.subtipo";
	private static final String SUBTIPO_NO_EXISTE = "msg.error.masivo.convivencia.sareb.no.subtipo";
	private static final String IDENTIFICADOR_SUBTIPO_NO_EXISTE = "msg.error.masivo.convivencia.sareb.no.identificador";
	private static final String VALOR_NUEVO = "msg.error.masivo.convivencia.sareb.valor.nuevo";
	private static final String CAMPO_FECHA = "msg.error.masivo.convivencia.sareb.incorrecto.fecha";
	private static final String CAMPO_DECIMAL = "msg.error.masivo.convivencia.sareb.incorrecto.decimal";
	private static final String CAMPO_SINO = "msg.error.masivo.convivencia.sareb.incorrecto.boolean";
	private static final String CAMPO_DICCIONARIO = "msg.error.masivo.convivencia.sareb.incorrecto.dd";
	private static final String CAMPO_NUMERICO = "msg.error.masivo.convivencia.sareb.incorrecto.numerico";
	
	
	private static final int FILA_CABECERA = 0;
	private static final int FILA_DATOS = 1;

	private static final int NUM_COLS = 8;	
	private static final int COL_NUM_ACTIVO = 0;
	private static final int COL_SUB_REGISTRO = 1;
	private static final int COL_ID_SUB_REGISTRO = 2;
	private static final int COL_CAMPO = 3;
	private static final int COL_VALOR_ACTUAL = 4;
	private static final int COL_VALOR_NUEVO = 5;
	private static final int COL_NUEVO = 7;
	
	private Integer numFilasHoja;	
	private Map<String, List<Integer>> mapaErrores;	
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

	@Resource
	MessageService messageServices;

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
			mapaErrores.put(messageServices.getMessage(CAMPO_NO_EXISTE), isCampoNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), isActiveNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(SUBTIPO_NO_EXISTE), isSubtipoRegistroNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(DEPENCENCIA_SUBTIPO_REGISTRO), isSubtipoDependienteExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(IDENTIFICADOR_SUBTIPO_NO_EXISTE), isIdentificadorRegistroNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(CAMPO_FECHA), isTipoCampoFecha(exc));
			mapaErrores.put(messageServices.getMessage(CAMPO_DICCIONARIO), isTipoCampoDiccionario(exc));
			mapaErrores.put(messageServices.getMessage(CAMPO_NUMERICO), isTipoCampoNumerico(exc));
			mapaErrores.put(messageServices.getMessage(CAMPO_DECIMAL), isTipoCampoDecimal(exc));
			mapaErrores.put(messageServices.getMessage(CAMPO_SINO), isTipoCampoSiNo(exc));
			mapaErrores.put(messageServices.getMessage(VALOR_NUEVO), isNuevoCorrecto(exc));
			
			
			

			
			for (Entry<String, List<Integer>> registros : mapaErrores.entrySet()) {
				if(!registros.getValue().isEmpty()) {
					dtoValidacionContenido.setFicheroTieneErrores(true);
					dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
					break;
				}
			}		
		}
		exc.cerrar();
		
		
		return dtoValidacionContenido;
	}	

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
	
	private List<Integer> isCampoNotExistsRows(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!particularValidator.existeCampo(exc.dameCelda(i, COL_CAMPO)))
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
	
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.existeActivo(exc.dameCelda(i, COL_NUM_ACTIVO)))
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
	
	private List<Integer> isSubtipoRegistroNotExistsRows(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_SUB_REGISTRO)) 
	                            && Boolean.FALSE.equals(particularValidator.perteneceADiccionarioSubtipoRegistro(exc.dameCelda(i, COL_SUB_REGISTRO))))
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
	
	private List<Integer> isSubtipoDependienteExistsRows(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_SUB_REGISTRO)) && (Checks.esNulo(exc.dameCelda(i, COL_ID_SUB_REGISTRO)) || Checks.esNulo(exc.dameCelda(i, COL_NUEVO)))
	                    		|| !Checks.esNulo(exc.dameCelda(i, COL_ID_SUB_REGISTRO)) && (Checks.esNulo(exc.dameCelda(i, COL_SUB_REGISTRO)) || Checks.esNulo(exc.dameCelda(i, COL_NUEVO)))
	                    		|| !Checks.esNulo(exc.dameCelda(i, COL_NUEVO)) && (Checks.esNulo(exc.dameCelda(i, COL_SUB_REGISTRO)) || Checks.esNulo(exc.dameCelda(i, COL_ID_SUB_REGISTRO))))
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
	
	private List<Integer> isIdentificadorRegistroNotExistsRows(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_SUB_REGISTRO)) && !Checks.esNulo(exc.dameCelda(i, COL_ID_SUB_REGISTRO)) 
	                    		&& (!Checks.esNulo(exc.dameCelda(i, COL_NUEVO)) ? Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 0 : false)
	                    		&& Boolean.FALSE.equals(particularValidator.existeIdentificadorSubregistro(exc.dameCelda(i, COL_SUB_REGISTRO), exc.dameCelda(i, COL_ID_SUB_REGISTRO))))
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
	
	private List<Integer> isNuevoCorrecto(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_SUB_REGISTRO)) && !Checks.esNulo(exc.dameCelda(i, COL_ID_SUB_REGISTRO)) 
	                    		&& (!Checks.esNulo(exc.dameCelda(i, COL_NUEVO)) ? !(Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 1 || Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 0) : false))
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
	
	private List<Integer> isTipoCampoNumerico(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();
	       String codigoCampo = "";
	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_CAMPO)) && !Checks.esNulo(exc.dameCelda(i, COL_VALOR_NUEVO))) 
	                    		//&& (!Checks.esNulo(exc.dameCelda(i, COL_NUEVO)) ? !(Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 1 || Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 0) : false))
	                        codigoCampo = particularValidator.getCodigoTipoDato(exc.dameCelda(i, COL_CAMPO));
	                    	if ("04".equals(codigoCampo)) {
								if (!esNumerico(exc.dameCelda(i, COL_VALOR_NUEVO)))
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
	
	private List<Integer> isTipoCampoDecimal(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();
	       String codigoCampo = "";
	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_CAMPO)) && !Checks.esNulo(exc.dameCelda(i, COL_VALOR_NUEVO))) 
	                    		//&& (!Checks.esNulo(exc.dameCelda(i, COL_NUEVO)) ? !(Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 1 || Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 0) : false))
	                        codigoCampo = particularValidator.getCodigoTipoDato(exc.dameCelda(i, COL_CAMPO));
	                    	if ("03".equals(codigoCampo)) {
								if (!esDecimal(exc.dameCelda(i, COL_VALOR_NUEVO)))
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
	
	private List<Integer> isTipoCampoDiccionario(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();
	       String codigoCampo = "";
	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_CAMPO)) && !Checks.esNulo(exc.dameCelda(i, COL_VALOR_NUEVO))) 
	                    		//&& (!Checks.esNulo(exc.dameCelda(i, COL_NUEVO)) ? !(Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 1 || Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 0) : false))
	                        codigoCampo = particularValidator.getCodigoTipoDato(exc.dameCelda(i, COL_CAMPO));
	                    	if ("05".equals(codigoCampo)) {
								if (!exc.dameCelda(i, COL_VALOR_NUEVO).matches("[0-9]+")) {
									listaFilas.add(i);
								}else if (!particularValidator.existeDiccionarioByTipoCampo(exc.dameCelda(i, COL_CAMPO), exc.dameCelda(i, COL_VALOR_NUEVO))) {
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
	
	private List<Integer> isTipoCampoSiNo(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();
	       String codigoCampo = "";
	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_CAMPO)) && !Checks.esNulo(exc.dameCelda(i, COL_VALOR_NUEVO))) 
	                    		//&& (!Checks.esNulo(exc.dameCelda(i, COL_NUEVO)) ? !(Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 1 || Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 0) : false))
	                        codigoCampo = particularValidator.getCodigoTipoDato(exc.dameCelda(i, COL_CAMPO));
	                    	if ("01".equals(codigoCampo)) {
								if (Integer.parseInt(exc.dameCelda(i, COL_VALOR_NUEVO)) != 1 && Integer.parseInt(exc.dameCelda(i, COL_VALOR_NUEVO)) != 0 ) 
									listaFilas.add(i);
							}
	                } catch (ParseException e) {
	                    listaFilas.add(i);
	                } catch (NumberFormatException n) {
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
	
	private List<Integer> isTipoCampoFecha(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();
	       String codigoCampo = "";
	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_CAMPO)) && !Checks.esNulo(exc.dameCelda(i, COL_VALOR_NUEVO))) 
	                    		//&& (!Checks.esNulo(exc.dameCelda(i, COL_NUEVO)) ? !(Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 1 || Integer.parseInt(exc.dameCelda(i, COL_NUEVO)) == 0) : false))
	                        codigoCampo = particularValidator.getCodigoTipoDato(exc.dameCelda(i, COL_CAMPO));
	                    	if ("02".equals(codigoCampo)) {
								if (!esFecha(exc.dameCelda(i, COL_VALOR_NUEVO)))
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
	
	private boolean esDecimal(String valor) {

		try {
			Double.valueOf(valor.replaceAll(",","."));
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	private boolean esNumerico(String valor) {
		
		try {
			Long.parseLong(valor);
			return true;
		} catch (Exception e) {
			return false;
		}
				
	}
	private boolean esFecha(String valor) {
		
		SimpleDateFormat formato = new SimpleDateFormat("yyyy/MM/dd");
		Date fecha = null;
		
		try {
			fecha = formato.parse(valor);
			return true;
		} catch (Exception e) {
			return false;
		}
		
			
	}

	@Override
	public Integer getNumFilasHoja() {
		// TODO Auto-generated method stub
		return null;
	}

	
}
