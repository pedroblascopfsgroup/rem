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
public class MSVSuperDiscPublicacionesExcelValidator extends MSVExcelValidatorAbstract {
	
	private static final String ACTIVO_NO_EXISTE = "msg.error.masivo.listado.validator.activos.deben.existir";
	private static final String ESTADO_ACTIVO_INVALIDO = "msg.error.masivo.err.cartera.activo";
	private static final String VALORES_NO_VALIDOS_OCUPADO = "msg.error.masivo.superficies.err.superficie.construida";
	private static final String VALORES_NO_VALIDOS_CON_TITULO = "msg.error.masivo.superficies.err.superficie.util";
	private static final String VALORES_NO_VALIDOS_TAPIADO = "msg.error.masivo.superficies.err.repercusion.eecc";
	private static final String VALORES_NO_VALIDOS_OTROS = "msg.error.masivo.superficies.err.parcela";
	private static final String VALORES_NO_VALIDOS_OTROS_MOTIVOS = "msg.error.masivo.superficies.err.parcela";
	private static final String VALORES_ACTIVO_INTEGRADO_NO_VALIDO = "msg.error.masivo.superficies.err.parcela";
	
	private	static final int FILA_CABECERA = 0;
	private	static final int DATOS_PRIMERA_FILA = 1;
		
	private	static final int COL_ACTIVO = 0;
	private	static final int COL_ESTADO_FISICO_ACTIVO = 1;
	private	static final int COL_OCUPADO = 2;
	private	static final int COL_CON_TITULO = 3;
	private	static final int COL_ESTADO_TAPIADO = 4;
	private static final int COL_OTROS = 5;
	private static final int COL_OTROS_MOTIVOS = 6;
	private static final int COL_ACTIVO_INTEGRADO = 7;
	

	

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
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), isActiveNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(ESTADO_ACTIVO_INVALIDO), perteneceDDEstadoActivo(exc));
			mapaErrores.put(messageServices.getMessage(VALORES_NO_VALIDOS_OCUPADO), isOcupadoValorSiNo(exc));
			mapaErrores.put(messageServices.getMessage(VALORES_NO_VALIDOS_CON_TITULO), isConTitulo(exc));
			mapaErrores.put(messageServices.getMessage(VALORES_NO_VALIDOS_TAPIADO), isTapiado(exc));
			mapaErrores.put(messageServices.getMessage(VALORES_NO_VALIDOS_OTROS), valorOtros(exc));
			mapaErrores.put(messageServices.getMessage(VALORES_NO_VALIDOS_OTROS_MOTIVOS), valorOtrosMotivos(exc));
			mapaErrores.put(messageServices.getMessage(VALORES_ACTIVO_INTEGRADO_NO_VALIDO), valorActivoInscrito(exc));
			
			
			if (!mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ESTADO_ACTIVO_INVALIDO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(VALORES_NO_VALIDOS_OCUPADO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(VALORES_NO_VALIDOS_CON_TITULO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(VALORES_NO_VALIDOS_TAPIADO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(VALORES_NO_VALIDOS_OTROS)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(VALORES_NO_VALIDOS_OTROS_MOTIVOS)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(VALORES_ACTIVO_INTEGRADO_NO_VALIDO)).isEmpty())

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
	
	/**
	 * Comprueba si el activo existe o esta borrado
	 * @param exc
	 * @return listado filas erroneas
	 */
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.existeActivo(exc.dameCelda(i, COL_ACTIVO)))
					listaFilas.add(i);
			} catch (ParseException e) {
				listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		}
		return listaFilas;
	}

	/**
	 * Comprueba el estado pertenece al diccionario DD_EAC_ESTADO_ACTIVO
	 * @param exc
	 * @return listado filas erroneas
	 */
	
	private List<Integer> perteneceDDEstadoActivo(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
		
			try {
				if (!particularValidator.perteneceDDEstadoActivo(exc.dameCelda(i, COL_ESTADO_FISICO_ACTIVO)))
					listaFilas.add(i);
			} catch (ParseException e) {
				listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		}
		return listaFilas;
	}
	/**
	 * Comprueba el campo ocupado tiene valor de SI/NO S/N 
	 * @param exc
	 * @return listado filas erroneas
	 */
	private List<Integer> isOcupadoValorSiNo(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<String> listaStringValidos = new ArrayList<String>();
		
		listaStringValidos.add("SI");
		listaStringValidos.add("NO");
		listaStringValidos.add("S");
		listaStringValidos.add("N");
		
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if(!esArroba(exc.dameCelda(i, COL_OCUPADO)) && !listaStringValidos.contains((exc.dameCelda(i, COL_OCUPADO)).toUpperCase())) {
					listaFilas.add(i);
				}
			} catch (ParseException e) {
				listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		}
		return listaFilas;
	}
	
	/**
	 * Comprueba el campo conTitulo tiene valor dependiendo del campo ocupado
	 * @param exc
	 * @return listado filas erroneas
	 */

	private List<Integer> isConTitulo(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		List<String> listaStringValidosSi = new ArrayList<String>();
		List<String> listaStringValidosNo = new ArrayList<String>();
		
		listaStringValidosSi.add("SI");
		listaStringValidosSi.add("S");
		
		listaStringValidosNo.add("NO");
		listaStringValidosNo.add("N");
		
		
		
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if(esArroba(exc.dameCelda(i, COL_OCUPADO))) {
					if(!esArroba(exc.dameCelda(i, COL_CON_TITULO))) {
						listaFilas.add(i);
					}
				}
				else if(!particularValidator.perteneceDDTipoTituloTPA(exc.dameCelda(i, COL_CON_TITULO))){
					listaFilas.add(i);
				}else{
					 if(listaStringValidosSi.contains((exc.dameCelda(i, COL_OCUPADO)).toUpperCase())) {
						if(!particularValidator.conTituloOcupadoSi(exc.dameCelda(i, COL_CON_TITULO))) {
							listaFilas.add(i);
						}
					}else if(listaStringValidosNo.contains((exc.dameCelda(i, COL_OCUPADO)).toUpperCase())) {
						if(!particularValidator.conTituloOcupadoNo(exc.dameCelda(i, COL_CON_TITULO))) {
							listaFilas.add(i);
						}
				}
			}
			} catch (ParseException e) {
				listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		}
		return listaFilas;
	}
	
	private List<Integer> isTapiado(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<String> listaStringValidos = new ArrayList<String>();
		
		listaStringValidos.add("SI");
		listaStringValidos.add("NO");
		listaStringValidos.add("S");
		listaStringValidos.add("N");
		
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if(!listaStringValidos.contains((exc.dameCelda(i, COL_ESTADO_TAPIADO)).toUpperCase())) {
					listaFilas.add(i);
				}
				//
			} catch (ParseException e) {
				listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		}
		return listaFilas;
	}
	private List<Integer> valorOtros(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<String> listaStringValidos = new ArrayList<String>();
		
		listaStringValidos.add("SI");
		listaStringValidos.add("NO");
		listaStringValidos.add("S");
		listaStringValidos.add("N");
		
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if(!listaStringValidos.contains((exc.dameCelda(i, COL_OTROS)).toUpperCase())) {
					listaFilas.add(i);
				}
				//
			} catch (ParseException e) {
				listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		}
		return listaFilas;
	}
	
	private List<Integer> valorOtrosMotivos(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<String> listaStringValidos = new ArrayList<String>();
		
		listaStringValidos.add("SI");
		listaStringValidos.add("S");
		
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if(esArroba(exc.dameCelda(i, COL_OTROS)) && !esArroba(exc.dameCelda(i, COL_OTROS_MOTIVOS))) {
					listaFilas.add(i);
				}
				if(!listaStringValidos.contains((exc.dameCelda(i, COL_OTROS)).toUpperCase()) && !Checks.esNulo(exc.dameCelda(i, COL_OTROS_MOTIVOS))) {
					listaFilas.add(i);
				}
			} catch (ParseException e) {
				listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		}
		return listaFilas;
	}
	
	private List<Integer> valorActivoInscrito(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<String> listaStringValidos = new ArrayList<String>();
		
		listaStringValidos.add("SI");
		listaStringValidos.add("NO");
		listaStringValidos.add("S");
		listaStringValidos.add("N");
		
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if(!listaStringValidos.contains((exc.dameCelda(i, COL_ACTIVO_INTEGRADO)).toUpperCase())) {
					listaFilas.add(i);
				}
				//
			} catch (ParseException e) {
				listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
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
	
	private boolean esArroba(String cadena) {
		return cadena.trim().equals("@");
	}
}

