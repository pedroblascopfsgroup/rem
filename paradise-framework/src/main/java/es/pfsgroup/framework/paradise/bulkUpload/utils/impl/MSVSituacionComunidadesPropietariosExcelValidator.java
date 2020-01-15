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
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationRunner;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVValidationResult;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVMultiColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.dto.ResultadoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

@Component
public class MSVSituacionComunidadesPropietariosExcelValidator extends MSVExcelValidatorAbstract /*implements MSVLiberator */{

	@Autowired
	private ApiProxyFactory proxyFactory;
	

	// Textos con errores de validacion
	public static final String ACTIVE_EXISTS = "El activo propuesto no existe = ";
	public static final String ACTIVE_CPR_ID = "No se ha encontrado ninguna COMUNIDAD DE PROPIETARIOS asociada al activo = ";
	public static final String PROPIETARIOS_EXISTS = "No se ha encontrado ninguna comunidad de propietarios para el identificador = ";
	public static final String ESTADO_LOC_EXISTS = "No se ha encontrado ningun estado de localización para el idendificador = ";
	public static final String SUBESTADO_GESTION_EXISTS = "No se ha encontrado ningun subestado de gestión para el idendificador = ";
	public static final String FECHA_EMVIO = "EL formato de la fecha de envio de la carta comunicando vta a la comunidad no es correcto ";


	// Posicion fija de Columnas excel, para cualquier referencia por posicion
	public static final class COL_NUM {
		static final int FILA_CABECERA = 1;
		static final int DATOS_PRIMERA_FILA = 1;

		static final int NUM_ACTIVO_HAYA = 0;
		static final int ID_COMUNIDAD_PROPIETARIOS = 1;
		static final int FECHA_ENVIO_CARTA = 2;
		static final int ESTADO_LOC = 3;
		static final int SUBESTADO_GESTION = 4;
		
	}
	@Autowired
	ProcessAdapter processAdapter;

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private MSVExcelParser excelParser;

	@Autowired
	private MSVBusinessValidationRunner validationRunner;

	@Autowired
	private ParticularValidatorApi particularValidator;

	@Resource
	MessageService messageServices;

	@Autowired
	private MSVProcesoApi msvProcesoApi;

	private Integer numFilasHoja;
	

	
	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws RowsExceededException, IllegalArgumentException, WriteException, IOException {
		if (dtoFile.getIdTipoOperacion() == null) {
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}

		// El masivo de propuesta NO REALIZA las validaciones de contenido y
		// formato
		// que se realizan por defecto en todos los masivos
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = new MSVDtoValidacion();
		dtoValidacionContenido.setFicheroTieneErrores(false);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());

		// Validaciones especificas no contenidas en el fichero Excel de
		// validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		// Obtenemos el numero de filas reales que tiene la hoja excel a
		// examinar
		this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);

		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			Map<String, List<String>> mapaValores= new HashMap<String, List<String>>();


			mapaErrores.put(ACTIVE_CPR_ID , noExisteActivoEnPropietarios(exc));
			mapaErrores.put(ACTIVE_EXISTS , isActiveExistsRows(exc));

			mapaValores.put(ACTIVE_EXISTS , dameValorActivo(exc));
			mapaValores.put(ACTIVE_CPR_ID , dameValorActivoPropietario(exc));


			mapaErrores.put(PROPIETARIOS_EXISTS, isComunidadPropietariosExists(exc));
			mapaValores.put(PROPIETARIOS_EXISTS, dameValorPropietarios(exc));

			mapaErrores.put(FECHA_EMVIO, isColumnNotDateByRows(exc, COL_NUM.FECHA_ENVIO_CARTA));
			mapaErrores.put(ESTADO_LOC_EXISTS, isEstadoLocExists(exc));
			mapaValores.put(ESTADO_LOC_EXISTS, dameValorEstadoLoc(exc));
			mapaErrores.put(SUBESTADO_GESTION_EXISTS, isSubestadoGestionExists(exc));
			mapaValores.put(SUBESTADO_GESTION_EXISTS, dameValorSubestadoGestion(exc));
				if (!mapaErrores.get(ACTIVE_EXISTS).isEmpty() || !mapaErrores.get(PROPIETARIOS_EXISTS).isEmpty()
						|| !mapaErrores.get(FECHA_EMVIO).isEmpty()
						|| !mapaErrores.get(ESTADO_LOC_EXISTS).isEmpty() || !mapaErrores.get(ACTIVE_CPR_ID).isEmpty() 
						|| !mapaErrores.get(SUBESTADO_GESTION_EXISTS).isEmpty()) 
			 {

					dtoValidacionContenido.setFicheroTieneErrores(true);
					exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
					String nomFicheroErrores = exc.crearExcelErroresMejoradoByHojaAndFilaCabeceraConValores(mapaErrores,mapaValores, 0,
							COL_NUM.FILA_CABECERA);
					FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
					dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
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

	private List<Integer> isComunidadPropietariosExists(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for (i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
				if (!particularValidator.existeComunidadPropietarios(exc.dameCelda(i, COL_NUM.ID_COMUNIDAD_PROPIETARIOS)))
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

		return listaFilas;
	}
	
	private List<String> dameValorPropietarios(MSVHojaExcel exc) {
		List<String> listaFilas = new ArrayList<String>();

		int i = 0;
		try {
			for (i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
				if (!particularValidator.existeComunidadPropietarios(exc.dameCelda(i, COL_NUM.ID_COMUNIDAD_PROPIETARIOS)))
					listaFilas.add(exc.dameCelda(i, COL_NUM.ID_COMUNIDAD_PROPIETARIOS));
		
			
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error(e.getMessage(),e);
			listaFilas.add("error");
		}

		return listaFilas;
	}
	
	
	private List<Integer> isEstadoLocExists(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for (i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
				if (!particularValidator.existeEstadoLoc(exc.dameCelda(i, COL_NUM.ESTADO_LOC)))
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

		return listaFilas;
	}
	
	private List<String> dameValorEstadoLoc(MSVHojaExcel exc) {
		List<String> listaFilas = new ArrayList<String>();

		int i = 0;
		try {
			for (i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
				if (!particularValidator.existeEstadoLoc(exc.dameCelda(i, COL_NUM.ESTADO_LOC)))
					listaFilas.add(exc.dameCelda(i, COL_NUM.ESTADO_LOC));
			
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error(e.getMessage(),e);
			listaFilas.add("0");
		}

		return listaFilas;
	}
	private List<Integer> isSubestadoGestionExists(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for (i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
				if (!particularValidator.existeSubestadoGestion(exc.dameCelda(i, COL_NUM.SUBESTADO_GESTION)))
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

		return listaFilas;
	}
	
	private List<String> dameValorSubestadoGestion(MSVHojaExcel exc) {
		List<String> listaFilas = new ArrayList<String>();

		int i = 0;
		try {
			for (i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
				if (!particularValidator.existeSubestadoGestion(exc.dameCelda(i, COL_NUM.SUBESTADO_GESTION)))
					listaFilas.add(exc.dameCelda(i, COL_NUM.SUBESTADO_GESTION));
			
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error(e.getMessage(),e);
			listaFilas.add("0");
		}

		return listaFilas;
	}
	
	
	
	
	
	
	
	private List<Integer> isActiveExistsRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for (i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
				if (!particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)))
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

		return listaFilas;
	}
	
	private List<Integer> noExisteActivoEnPropietarios(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for (i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
				if (!particularValidator.existeActivoEnPropietarios(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA),exc.dameCelda(i, COL_NUM.ID_COMUNIDAD_PROPIETARIOS)))
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

		return listaFilas;
	}
	
	
	private List<String> dameValorActivo(MSVHojaExcel exc) {
		List<String> listaFilas = new ArrayList<String>();

		int i = 0;
		try {
			for (i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
				if (!particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)))
					listaFilas.add(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA));
			
					
				
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error(e.getMessage(),e);
			listaFilas.add("0");
		}
		
		
	
		

		return listaFilas;
	}
	private List<String> dameValorActivoPropietario(MSVHojaExcel exc) {
		List<String> listaFilas = new ArrayList<String>();

		int i = 0;
		try {
			for (i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
				if (!particularValidator.existeActivoEnPropietarios(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA),exc.dameCelda(i, COL_NUM.ID_COMUNIDAD_PROPIETARIOS)))
					listaFilas.add(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA));
			
					
				
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error(e.getMessage(),e);
			listaFilas.add("0");
		}
		
		
	
		

		return listaFilas;
	}
	
	
	//existeActivoEnPropietarios
	/**
	 * Método genérico para comprobar si el valor de una columna está informado
	 * o no.
	 * 
	 * @param exc
	 *            : documento excel con los datos.
	 * @param columnNumber
	 *            : número de columna a comprobar.
	 * @return Devuelve una lista con los errores econtrados. Tantos registros
	 *         como errores.
	 */
	private List<Integer> isColumnNullByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				if (Checks.esNulo(exc.dameCelda(i, columnNumber)))
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

	

	private List<Integer> isColumnNotDateByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		String valorDate = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				valorDate = exc.dameCelda(i, columnNumber);

				// Si el valor Date no se puede obtener adecuadamente se lanza
				// error para esa línea.
				if (!Checks.esNulo(valorDate)) {
					ft.parse(valorDate);
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




	
}
