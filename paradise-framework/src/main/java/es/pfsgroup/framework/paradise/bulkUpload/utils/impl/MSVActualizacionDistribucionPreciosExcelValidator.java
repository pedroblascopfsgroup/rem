package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
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
	public static final String ACTIVO_NO_PERTENECE_EXPEDIENTE_COMERCIAL = "El activo no pertenece al expediente comercial";
	public static final String EXPEDIENTE_NO_VENTA = "El expediente que se está actualizando no es de tipo venta";
	public static final String EXPEDIENTE_VALIDO_APROBADO = "El expediente seleccionado se encuentra en estado aprobado";
	public static final String EXPEDIENTE_VALIDO_FIRMADO = "El expediente seleccionado se encuentra en estado firmado";
	public static final String EXPEDIENTE_VALIDO_RESERVADO= "El expediente seleccionado se encuentra en estado reservado";
	public static final String EXPEDIENTE_VALIDO_VENDIDO= "El expediente seleccionado se encuentra en estado vendido";
	public static final String EXPEDIENTE_VALIDO_ANULADO= "El expediente seleccionado se encuentra en estado anulado";
	
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
	private UsuarioApi usuarioApi;
	
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
			mapaErrores.put(ACTIVO_NO_PERTENECE_EXPEDIENTE_COMERCIAL, activoConRelacionExpedienteComercial(exc));
			mapaErrores.put(EXPEDIENTE_COMERCIAL_FALTAN_ACTIVOS, isAllActivosOferta(exc));
			mapaErrores.put(EXPEDIENTE_NO_VENTA, isExpedienteVenta(exc));
			mapaErrores.put(EXPEDIENTE_VALIDO_APROBADO, isExpedienteValidoAprobado(exc));
			mapaErrores.put(EXPEDIENTE_VALIDO_FIRMADO, esExpedienteValidoFirmado(exc));
			mapaErrores.put(EXPEDIENTE_VALIDO_RESERVADO, esExpedienteValidoReservado(exc));
			mapaErrores.put(EXPEDIENTE_VALIDO_VENDIDO, esExpedienteValidoVendido(exc));
			mapaErrores.put(EXPEDIENTE_VALIDO_ANULADO, esExpedienteValidoAnulado(exc));
			
			if (!mapaErrores.get(EXPEDIENTE_COMERCIAL_NO_EXISTE).isEmpty() 
					|| !mapaErrores.get(ACTIVO_NO_PERTENECE_EXPEDIENTE_COMERCIAL).isEmpty()
					|| !mapaErrores.get(ACTIVO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(ACTIVO_NO_DISPONE_IMPORTE_ASOCIADO).isEmpty()
					|| !mapaErrores.get(SUMA_ACTIVOS_DISTINTA_IMPORTE_TOTAL_OFERTA).isEmpty()
					|| !mapaErrores.get(EXPEDIENTE_COMERCIAL_FALTAN_ACTIVOS).isEmpty()
					|| !mapaErrores.get(EXPEDIENTE_NO_VENTA).isEmpty()
					|| !mapaErrores.get(EXPEDIENTE_VALIDO_APROBADO).isEmpty()
					|| !mapaErrores.get(EXPEDIENTE_VALIDO_FIRMADO).isEmpty()
					|| !mapaErrores.get(EXPEDIENTE_VALIDO_RESERVADO).isEmpty()
					|| !mapaErrores.get(EXPEDIENTE_VALIDO_VENDIDO).isEmpty()
					|| !mapaErrores.get(EXPEDIENTE_VALIDO_ANULADO).isEmpty()
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
	
	private List<Integer> activoConRelacionExpedienteComercial(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO))
							&&  !particularValidator.activoConRelacionExpedienteComercial(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE), exc.dameCelda(i, COL_NUM.ACT_NUM_ACTIVO))
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
					if (!Checks.esNulo(numExpediente) && !Checks.esNulo(numActivo) && particularValidator.activoConRelacionExpedienteComercial(numExpediente, numActivo)){
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
						
						sumaImportes = Math.round(sumaImportes * 100) / 100d;
						
					}
							
					if (!Checks.esNulo(numActivo) 
						&& particularValidator.existeActivo(numActivo) 
						&& particularValidator.existeExpedienteComercial(numExpediente)
						&& particularValidator.isTotalOfertaDistintoSumaActivos(sumaImportes, numExpediente)
						&& particularValidator.activoConRelacionExpedienteComercial(numExpediente, numActivo)
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
	
	private List<Integer> isExpedienteVenta(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))
							&&  !particularValidator.esExpedienteVenta(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))
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
	
	
	//aprobado, ni reservado
	private List<Integer> isExpedienteValidoAprobado(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))
							&& particularValidator.esExpedienteValidoAprobado(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))) {
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
	
	
	//-----------------------------------------------------------
	
	//firmado 
	private List<Integer> esExpedienteValidoFirmado(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))
							&& particularValidator.esExpedienteValidoFirmado(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))) {
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
	
	
	//  reservado 
	private List<Integer> esExpedienteValidoReservado(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))
							&& particularValidator.esExpedienteValidoReservado(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))) {
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
	
	//vendido
	private List<Integer> esExpedienteValidoVendido(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		Usuario usuario = usuarioApi.getUsuarioLogado();
		Boolean esGestorFormalizacion = msvProcesoApi.tienePerfilPorCodigo("HAYAGESTFORM", usuario);
		Boolean esGestorFormalizacionDos = msvProcesoApi.tienePerfilPorCodigo("GFORM", usuario);
		
		if (!esGestorFormalizacion && !esGestorFormalizacionDos) {
			try {
				for (int i = 1; i < this.numFilasHoja; i++) {
					try {
						if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))
								&& particularValidator.esExpedienteValidoVendido(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))) {
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
		} 
		
		return listaFilas;
	}
	
	
	//Anulado
	private List<Integer> esExpedienteValidoAnulado(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))
							&& particularValidator.esExpedienteValidoAnulado(exc.dameCelda(i, COL_NUM.EXP_NUM_EXPEDIENTE))) {
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
	
	//------------------------------------------------------------------------------------------------------------------------
	
	
	
	@Override
	public Integer getNumFilasHoja() {
		return numFilasHoja;
	}

	public void setNumFilasHoja(Integer numFilasHoja) {
		this.numFilasHoja = numFilasHoja;
	}
}
