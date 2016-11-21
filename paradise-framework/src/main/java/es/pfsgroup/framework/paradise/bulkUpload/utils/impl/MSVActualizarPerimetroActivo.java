package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
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
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;


@Component
public class MSVActualizarPerimetroActivo extends MSVExcelValidatorAbstract {
		
	//Textos con errores de validacion
	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_NOT_ACTUALIZABLE = "El estado del activo no puede actualizarse al indicado.";
	public static final String VALID_PERIMETRO_TIPO_COMERCIALIZACION = "Debe indicar un codigo valido para el tipo de comercializacion";
	public static final String VALID_PERIMETRO_RESPUESTA_SN = "En columnas cuyo nombre acaba en SN, debe indicar como valor la letra 'S' (Si) o la letra 'N' (No).";
	public static final String VALID_PERIMETRO_MOTIVO_CON_COMERCIAL = "Debe indicar un codigo valido para el motivo de inclusion comercial";
	public static final String VALID_PERIMETRO_MOTIVO_SIN_COMERCIAL = "Debe indicar un codigo valido para el motivo de exclusion comercial";
	public static final String VALID_PERIMETRO_FUERA_RESTO_CHECKS_NO = "Si indica 'N' en la columna 'En Perimetro Haya', el resto de columnas de tipo SN no pueden tener el valor 'S'.";
	public static final String VALID_PERIMETRO_FORMALIZAR_SEGUN_COMERCIAL = "Si indica 'N' en la columna 'Comercializar' no puede marcar 'S' en la columna 'Formalizar'";
	public static final String VALID_PERIMETRO_DESTINO_COMERCIAL = "Debe indicar un codigo valido para el destino comercial";
	public static final String VALID_PERIMETRO_TIPO_ALQUILER = "Debe indicar un codigo valido para el tipo de alquiler";
	public static final String VALID_PERIMETRO_FORMALIZAR_ACTIVO_COMERCIALIZABLE = "No puede indicar 'S' en la columna 'Formalizar' porque el activo no es comercializable";
	
	//Posicion fija de Columnas excel, para validaciones especiales de diccionario
	public static final int COL_NUM_EN_PERIMETRO_SN = 1;
	public static final int COL_NUM_CON_GESTION_SN = 2;
	public static final int COL_NUM_CON_COMERCIAL_SN = 4;
	public static final int COL_NUM_MOTIVO_CON_COMERCIAL = 5;
	public static final int COL_NUM_MOTIVO_SIN_COMERCIAL = 6;
	public static final int COL_NUM_TIPO_COMERCIALIZACION = 7;
	public static final int COL_NUM_DESTINO_COMERCIAL = 8;
	public static final int COL_NUM_TIPO_ALQUILER = 9;
	public static final int COL_NUM_CON_FORMALIZAR_SN = 10;

    protected final Log logger = LogFactory.getLog(getClass());
    
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
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	

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
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
//			if (!isActiveExists(exc)){
				Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
				mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
				mapaErrores.put(VALID_PERIMETRO_TIPO_COMERCIALIZACION, getPerimetroTipoComerRows(exc));
				mapaErrores.put(VALID_PERIMETRO_MOTIVO_CON_COMERCIAL, getPerimetroConComerRows(exc));
//				mapaErrores.put(VALID_PERIMETRO_MOTIVO_SIN_COMERCIAL, getPerimetroSinComerRows(exc));
				mapaErrores.put(VALID_PERIMETRO_RESPUESTA_SN, getPerimetroRespuestaSNRows(exc));
				mapaErrores.put(VALID_PERIMETRO_FUERA_RESTO_CHECKS_NO, getFueraPerimetroIsRestoChecksNegativos(exc));
				mapaErrores.put(VALID_PERIMETRO_FORMALIZAR_SEGUN_COMERCIAL, getFormalizarConComercial(exc));
				mapaErrores.put(VALID_PERIMETRO_DESTINO_COMERCIAL, getPerimetroConDestinoComercial(exc));
				mapaErrores.put(VALID_PERIMETRO_TIPO_ALQUILER, getPerimetroTipoAlquilerRows(exc));
				mapaErrores.put(VALID_PERIMETRO_FORMALIZAR_ACTIVO_COMERCIALIZABLE, getFormalizarActivoNoComercializable(exc));
				
				try{
					if(!mapaErrores.get(ACTIVE_NOT_EXISTS).isEmpty() 								||
							!mapaErrores.get(VALID_PERIMETRO_TIPO_COMERCIALIZACION).isEmpty() 		||
							!mapaErrores.get(VALID_PERIMETRO_MOTIVO_CON_COMERCIAL).isEmpty()  		||
//							!mapaErrores.get(VALID_PERIMETRO_MOTIVO_SIN_COMERCIAL).isEmpty()  		||
							!mapaErrores.get(VALID_PERIMETRO_RESPUESTA_SN).isEmpty() 		  		||
							!mapaErrores.get(VALID_PERIMETRO_FUERA_RESTO_CHECKS_NO).isEmpty() 		||
							!mapaErrores.get(VALID_PERIMETRO_FORMALIZAR_SEGUN_COMERCIAL).isEmpty() 	|| 
							!mapaErrores.get(VALID_PERIMETRO_DESTINO_COMERCIAL).isEmpty()			||
							!mapaErrores.get(VALID_PERIMETRO_TIPO_ALQUILER).isEmpty() 				||
							!mapaErrores.get(VALID_PERIMETRO_FORMALIZAR_ACTIVO_COMERCIALIZABLE).isEmpty() ) {
						
						dtoValidacionContenido.setFicheroTieneErrores(true);
						exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
						String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
						FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
						dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
					}
				} catch (Exception e) {
					logger.error(e.getMessage());
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
			logger.error(e.getMessage());
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
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
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
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	
	private List<Integer> getPerimetroTipoComerRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro de perimetro tiene un Tipo de comercializacion valido.
		// Codigos validos 00 (ninguno) 01 (Singular) 02 (Retail) 
		try{
			String codigoTipoComercial = null;
			for(int i=1; i<exc.getNumeroFilas();i++){
				if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_TIPO_COMERCIALIZACION)))
					codigoTipoComercial = exc.dameCelda(i, COL_NUM_TIPO_COMERCIALIZACION).substring(0, 2);
				else 
					codigoTipoComercial = null;
				
				if(!(Checks.esNulo(codigoTipoComercial) || "01".equals(codigoTipoComercial) || "02".equals(codigoTipoComercial)) )
					listaFilas.add(i);
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getPerimetroConComerRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro de perimetro tiene un motivo "con" comercializacion valido.
		// Codigos validos 00 (ninguno) 01 (ordinario) 02 (pdv) 03 (performing) 
		try{
			String codigoMotivoConComercial = null;
			for(int i=1; i<exc.getNumeroFilas();i++){

				if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_MOTIVO_CON_COMERCIAL)))
					codigoMotivoConComercial = exc.dameCelda(i, COL_NUM_MOTIVO_CON_COMERCIAL).substring(0, 2);
				else 
					codigoMotivoConComercial = null;
				
				if(!(Checks.esNulo(codigoMotivoConComercial) || "01".equals(codigoMotivoConComercial) || "02".equals(codigoMotivoConComercial) || "03".equals(codigoMotivoConComercial) ) )
					listaFilas.add(i);
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getPerimetroSinComerRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro de perimetro tiene un motivo "sin" comercializacion valido.
		// Codigos validos 00 (ninguno) 01 (V.P.O Auto) 02 (perdido) 03 (desistido) ... 63 (no comer. pte. propuesta) 
		try{
			Integer codigoMotivoSinComercial = 0;
			for(int i=1; i<exc.getNumeroFilas();i++){
				codigoMotivoSinComercial = exc.dameCelda(i, COL_NUM_MOTIVO_SIN_COMERCIAL).isEmpty() ? Integer.valueOf(0) :
					Integer.valueOf(exc.dameCelda(i, COL_NUM_MOTIVO_SIN_COMERCIAL));
				if(codigoMotivoSinComercial < 0 || codigoMotivoSinComercial > 63)
					listaFilas.add(i);
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getPerimetroRespuestaSNRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		// Validacion que evalua si el registro de perimetro tiene columnas con una respuesta correcta de SN.
		// Codigos validos S (Si) N (No) 
		try{
			String valorEnPerimetro = "-";
			String valorConGestion = "-";
			String valorConComercial = "-";
			String valorConFormalizar = "-";
			
			for(int i=1; i<exc.getNumeroFilas();i++){
				
				//Columnas EN_PERIMETRO, CON_GESTION, CON_COMERCIAL
				// Si la celda no tiene valor, debe validarse correctamente
				// Si la S o la N van en minusculas, deben ser valores validos
				// No deben tenerse en cuenta espacios en blanco
				valorEnPerimetro = exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).trim().toUpperCase();
				valorConGestion = exc.dameCelda(i, COL_NUM_CON_GESTION_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_GESTION_SN).trim().toUpperCase();
				valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();
				valorConFormalizar = exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).trim().toUpperCase();
				
				// Valida valores correctos de los campos S/N/<nulo>
				if(!("S".equals(valorEnPerimetro) || "N".equals(valorEnPerimetro) || "-".equals(valorEnPerimetro))
						|| !("S".equals(valorConGestion) || "N".equals(valorConGestion) || "-".equals(valorConGestion))
						|| !("S".equals(valorConComercial) || "N".equals(valorConComercial) || "-".equals(valorConComercial))
						|| !("S".equals(valorConFormalizar) || "N".equals(valorConFormalizar) || "-".equals(valorConFormalizar))
						)
					listaFilas.add(i);
			
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getFueraPerimetroIsRestoChecksNegativos(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro indica que NO esta dentro del perimetro, ha de comprobar
		// que el resto de CHECKS no esten activados afirmativamente
		try{
			String valorEnPerimetro = "-";
			for(int i=1; i<exc.getNumeroFilas();i++){
				
				valorEnPerimetro = exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).trim().toUpperCase();
				if("N".equals(valorEnPerimetro)) {
					
					String valorConGestion = exc.dameCelda(i, COL_NUM_CON_GESTION_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_GESTION_SN).trim().toUpperCase();
					String valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();
					String valorConFormalizar = exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).trim().toUpperCase();
				
					if("S".equals(valorConGestion) || "S".equals(valorConComercial) || "S".equals(valorConFormalizar) )
						listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getFormalizarConComercial(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		/* Validacion que evalua en el caso de poner valor S/N en Formalizar cummpla con: 
		 * - Si Formalizar viene informado, comercializar debe venir informado
		 * - Si Comercializar(N) ==> Formalizar(N)
		 */
		try{
			String valorConFormalizar = "-";
			for(int i=1; i<exc.getNumeroFilas();i++){
				
				valorConFormalizar = exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).trim().toUpperCase();
				if(!"-".equals(valorConFormalizar)) {
					
					String valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();				
					if("N".equals(valorConComercial) && "S".equals(valorConFormalizar) )
						listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getPerimetroConDestinoComercial(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro de perimetro tiene un motivo "con" comercializacion valido.
		// Codigos validos 00 (ninguno) 01 (Venta) 02 (Alquiler y venta) 03 (Alquiler) 
		try{
			String codigoDestinoComercial = null;
			for(int i=1; i<exc.getNumeroFilas();i++){

				if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL)))
					codigoDestinoComercial = exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL).substring(0, 2);
				else 
					codigoDestinoComercial = null;
				
				if(!(Checks.esNulo(codigoDestinoComercial) || "01".equals(codigoDestinoComercial) || "02".equals(codigoDestinoComercial) || "03".equals(codigoDestinoComercial) ) )
					listaFilas.add(i);
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getPerimetroTipoAlquilerRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro de perimetro tiene un motivo "con" comercializacion valido.
		// Codigos validos 00 (ninguno) 01 (Ordinario) 02 (Con opción a compra) 03 (Fondo social) 04 (Especial) 
		try{
			String codigoTipoAlquiler = null;
			for(int i=1; i<exc.getNumeroFilas();i++){

				if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_TIPO_ALQUILER)))
					codigoTipoAlquiler = exc.dameCelda(i, COL_NUM_TIPO_ALQUILER).substring(0, 2);
				else 
					codigoTipoAlquiler = null;
				
				if(!(Checks.esNulo(codigoTipoAlquiler) || "01".equals(codigoTipoAlquiler) || "02".equals(codigoTipoAlquiler) || "03".equals(codigoTipoAlquiler) || "04".equals(codigoTipoAlquiler) ) )
					listaFilas.add(i);
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getFormalizarActivoNoComercializable(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		/* Validacion que evalua en el caso de poner valor S en Formalizar y no informar Comercializar.
		 * Comprueba que el activo sea comercializable para poder activar Formalizar.
		 */
		try{
			String valorConFormalizar = "-";
			String valorConComercializar = "-";
			for(int i=1; i<exc.getNumeroFilas();i++){
				
				valorConFormalizar = exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).trim().toUpperCase();
				if("S".equals(valorConFormalizar)) {
					
					String valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();				
					if("-".equals(valorConComercial) ) {
						
						if(particularValidator.isActivoNoComercializable(exc.dameCelda(i, 0)));
							listaFilas.add(i);
					}
				}
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
}