package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
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


@Component
public class MSVActualizacionDistribucionPreciosExcelValidator extends MSVExcelValidatorAbstract{
	public static final class COL_NUM {
		static final int FILA_CABECERA = 1;
		static final int DATOS_PRIMERA_FILA = 2;
		static final int ACT_NUM_ACTIVO = 1;
		static final int EXP_NUM_EXPEDIENTE = 0;
		static final int ACT_IMPORTE_ASOCIADO = 2;
		
	};
	public static final String EXPEDIENTE_COMERCIAL_NO_EXISTE = "El expediente comercial no existe";
	public static final String ACTIVO_NO_EXISTE = "El activo no existe.";
	public static final String ACTIVO_NO_DISPONE_IMPORTE_ASOCIADO = "El activo no dispone de un importe asociado";
	public static final String EXPEDIENTE_COMERCIAL_FALTAN_ACTIVOS = "Faltan activos en el expediente";
	public static final String SUMA_ACTIVOS_DISTINTA_IMPORTE_TOTAL_OFERTA = "La suma de los importes de participación de los distintos activos no coincide con el importe total de la oferta";
	
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
			mapaErrores.put(EXPEDIENTE_COMERCIAL_NO_EXISTE, isExpedienteNotExistsRows(exc));
			mapaErrores.put(ACTIVO_NO_EXISTE, isActiveNotExistsRows(exc));
			mapaErrores.put(ACTIVO_NO_DISPONE_IMPORTE_ASOCIADO, isActivoSinImporte(exc));
			mapaErrores.put(SUMA_ACTIVOS_DISTINTA_IMPORTE_TOTAL_OFERTA, isTotalOfertaDistintoSumaActivos(exc));
			mapaErrores.put(EXPEDIENTE_COMERCIAL_FALTAN_ACTIVOS, isAllActivosOferta(exc));
			
			if (!mapaErrores.get(EXPEDIENTE_COMERCIAL_NO_EXISTE).isEmpty() 
					|| !mapaErrores.get(ACTIVO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(ACTIVO_NO_DISPONE_IMPORTE_ASOCIADO).isEmpty()
					|| !mapaErrores.get(SUMA_ACTIVOS_DISTINTA_IMPORTE_TOTAL_OFERTA).isEmpty()
					|| !mapaErrores.get(EXPEDIENTE_COMERCIAL_FALTAN_ACTIVOS).isEmpty()
					
				)
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

	private File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
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
	
	private List<Integer> isExpedienteNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE)) 
							&& !particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE)))
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
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)) 
							&& !particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)))
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
		
	private List<Integer> isActivoSinImporte(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO))
							&& particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO)) 
							&& particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))
							&& particularValidator.isNullImporteActivos(exc.dameCelda(i,COL_NUM.EXP_NUM_EXPEDIENTE))
					){
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
	private List<Integer> isTotalOfertaDistintoSumaActivos(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		// Expedientes visitados
		List<String> listaExpedientes = new ArrayList<String>();
		String numExpediente=null;
		String numActivo = null;
		Boolean auxFilas[];
		auxFilas = new Boolean[this.numFilasHoja+1];
		double sumaImportes = 0.00;
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					numExpediente = exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE);
					numActivo = exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO);
					if (!Checks.esNulo(numExpediente) && !Checks.esNulo(numActivo)){
						for(int j=1; j<this.numFilasHoja;j++) {
							auxFilas[j] = false;
							if (!Checks.esNulo(exc.dameCelda(j, COL_NUM.EXP_NUM_EXPEDIENTE))
									&& !listaExpedientes.contains(numExpediente)
									&& !Checks.esNulo(exc.dameCelda(j, COL_NUM.ACT_IMPORTE_ASOCIADO))
									&& numExpediente.equals(exc.dameCelda(j, COL_NUM.EXP_NUM_EXPEDIENTE))
							)
							{
								sumaImportes += Double.parseDouble(exc.dameCelda(j, COL_NUM.ACT_IMPORTE_ASOCIADO));
								auxFilas[j] = true;
							}
						}
						
					}
							
					if (!Checks.esNulo(numActivo) 
						&& particularValidator.existeActivo(numActivo) 
						&& particularValidator.existeExpedienteComercial(numExpediente)
						&& particularValidator.isTotalOfertaDistintoSumaActivos(sumaImportes, numExpediente)
					){
						for (int j=1; j<this.numFilasHoja;j++) {
							if (auxFilas[j]) {
								if (!listaFilas.contains(j)) listaFilas.add(j);
							}
						}
					}
					sumaImportes=0.00;
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
	
	@SuppressWarnings("unused")
	private Hashtable <String, Integer> dameFilas(int columna, String valor, int columnaR, MSVHojaExcel exc){
		/* Dada una columna a comparar en una hoja, devuelve una tabla hash leyendo de columnaR, con los elementos
		 * coincidentes entre valor y columna, como valor de la tabla devuelve la posición en la hoja (el nº de fila.
		 */
		Hashtable <String, Integer> resp = new Hashtable <String, Integer>();
		try {
			String celda = "";
			for (int i=1;i<this.numFilasHoja;i++) {
				celda = exc.dameCelda(i, columna); 
				if (celda.equals(valor)) resp.put(exc.dameCelda(i, columnaR), i);
			}
		}catch (IOException e){
			logger.error("Error de E/S");
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			logger.error("Error en argumentos");
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error("Error en conversión (parseo)");
			e.printStackTrace();
		}
		return resp;
	}
	
	
	private List<Integer> isAllActivosOferta(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		// Expedientes visitados
		List<String> listaExpedientes = new ArrayList<String>();
		// Lista de activos a pasar a la consulta sql (isAllActivosEnOferta)
		Hashtable <String,Integer> listaActivos = new Hashtable <String, Integer>();
		// Variables para simplificar la llamada a la función dameCelda
		String numExpediente=null; 
		String numActivo = null;
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if (!Checks.esNulo(numExpediente=exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE)) 
							&& !Checks.esNulo(numActivo=exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO))
							&& !listaExpedientes.contains(numExpediente)
						) {
						
							if (!Checks.estaVacio(listaActivos=dameFilas(COL_NUM.EXP_NUM_EXPEDIENTE, numExpediente, COL_NUM.ACT_NUM_ACTIVO, exc)) && !listaExpedientes.contains(numExpediente)) {
								if (particularValidator.existeActivo(numActivo) 
										&& particularValidator.existeExpedienteComercial(numExpediente)
										&& particularValidator.existeActivo(numActivo)
										&& !particularValidator.isAllActivosEnOferta(numExpediente, listaActivos)
								){
										
										listaExpedientes.add(numExpediente);
										Enumeration <String> claves = listaActivos.keys();
										while (claves.hasMoreElements()) {
											listaFilas.add(listaActivos.get(claves.nextElement()));
										}
								}
							}
							listaActivos.clear();
						
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
