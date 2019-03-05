package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
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
public class MSVValidatorIndicadorActivoAlquiler extends MSVExcelValidatorAbstract {
	
		// Textos con errores de validacion
		public static final String ACTIVO_NO_EXISTE = "msg.error.masivo.activo.no.existe";
		public static final String ACTIVO_VENDIDO = "msg.error.masivo.activo.esta.vendido";
		public static final String ACTIVO_NO_PUBLICABLE = "msg.error.masivo.activo.no.es.publicable";
		public static final String ACTIVO_NO_COMERCIALIZABLE = "msg.error.masivo.activo.no.es.comercializable";
		public static final String ACTIVO_DESTINO_COMERCIAL_ALQUILER = "msg.error.masivo.activo.no.tiene.destino.comercial.alquiler";
		public static final String MOSTRAR_PRECIO_CARACTER_INVALIDO = "msg.error.masivo.mostrar.precio.invalido";
		public static final String PUBLICAR_SIN_PRECIO_CARACTER_INVALIDO = "msg.error.masivo.publicar.sin.precio.invalido";
		
		private static final int POSICION_COLUMNA_ID_ACTIVO_HAYA = 0;
		private static final int POSICION_COLUMNA_MOSTRAR_PRECIO = 1;
		private static final int POSICION_COLUMNA_PUBLICAR_SIN_PRECIO = 2;
		
		private static final String COD_SI = "S";
		private static final String COD_NO = "N";
		private static final String COD_VACIO = "";
		
		@Autowired
		private MSVExcelParser excelParser;
		
		@Autowired
		private MSVBusinessValidationFactory validationFactory;
		
		@Autowired
		private MSVProcesoApi msvProcesoApi;
		
		@Autowired
		private MSVBusinessValidationRunner validationRunner;
		
		@Autowired
		private ParticularValidatorApi particularValidator;
		
		@Autowired
		private ExcelRepoApi excelRepoApi;
		
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
				this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
			} 
			catch (Exception e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			}
			
			if (!dtoValidacionContenido.getFicheroTieneErrores()) {
				
				Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
				mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), isActiveNotExistsRows(exc));
				mapaErrores.put(messageServices.getMessage(ACTIVO_VENDIDO), isActivoVendido(exc));
				mapaErrores.put(messageServices.getMessage(ACTIVO_NO_PUBLICABLE), isActivoPublicable(exc));
				mapaErrores.put(messageServices.getMessage(ACTIVO_NO_COMERCIALIZABLE), isActivoComercializable(exc));
				mapaErrores.put(messageServices.getMessage(ACTIVO_DESTINO_COMERCIAL_ALQUILER), isActivoDestinoComercialAlquiler(exc));
				mapaErrores.put(messageServices.getMessage(MOSTRAR_PRECIO_CARACTER_INVALIDO), isMostrarPrecioCaracterInvalido(exc));
				mapaErrores.put(messageServices.getMessage(PUBLICAR_SIN_PRECIO_CARACTER_INVALIDO), isPublicarSinPrecioCaracterInvalido(exc));

				if (!mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).isEmpty()
						|| !mapaErrores.get(messageServices.getMessage(ACTIVO_VENDIDO)).isEmpty()
						|| !mapaErrores.get(messageServices.getMessage(ACTIVO_NO_PUBLICABLE)).isEmpty()
						|| !mapaErrores.get(messageServices.getMessage(ACTIVO_NO_COMERCIALIZABLE)).isEmpty()
						|| !mapaErrores.get(messageServices.getMessage(ACTIVO_DESTINO_COMERCIAL_ALQUILER)).isEmpty()
						|| !mapaErrores.get(messageServices.getMessage(MOSTRAR_PRECIO_CARACTER_INVALIDO)).isEmpty()
						|| !mapaErrores.get(messageServices.getMessage(PUBLICAR_SIN_PRECIO_CARACTER_INVALIDO)).isEmpty()) {
					
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
		
		private File recuperarPlantilla(Long idTipoOperacion)  {
			try {
				FileItem fileItem = excelRepoApi.dameExcelByTipoOperacion(idTipoOperacion);
				return fileItem.getFile();
			} 
			catch (FileNotFoundException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			}
			return null;
		}
		
		private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
			List<Integer> listaFilas = new ArrayList<Integer>();
			
			int i = 0;
			try {
				for (i = 1 ; i < this.numFilasHoja ; i++){
					if(!particularValidator.existeActivo(exc.dameCelda(i, POSICION_COLUMNA_ID_ACTIVO_HAYA)))
						listaFilas.add(i);
				}
			} 
			catch (Exception e) {
				if (i != 0) listaFilas.add(i);
				logger.error(e.getMessage());
				e.printStackTrace();
			}
			
			return listaFilas;
		}
		
		private List<Integer> isActivoVendido(MSVHojaExcel exc){
			
			List<Integer> listaFilas = new ArrayList<Integer>();
			
			int i = 0;
			try {
				for (i = 1 ; i < this.numFilasHoja ; i++){
					if(particularValidator.isActivoVendido(exc.dameCelda(i, POSICION_COLUMNA_ID_ACTIVO_HAYA)))
						listaFilas.add(i);
				}
			} 
			catch (Exception e) {
				if (i != 0) listaFilas.add(i);
				logger.error(e.getMessage());
				e.printStackTrace();
			}
			
			return listaFilas;
			
		}
		
		private List<Integer> isActivoPublicable(MSVHojaExcel exc){
			
			List<Integer> listaFilas = new ArrayList<Integer>();
			
			int i = 0;
			try {
				for (i = 1 ; i < this.numFilasHoja ; i++){
					if(particularValidator.isActivoNoPublicable(exc.dameCelda(i, POSICION_COLUMNA_ID_ACTIVO_HAYA)))
						listaFilas.add(i);
				}
			} 
			catch (Exception e) {
				if (i != 0) listaFilas.add(i);
				logger.error(e.getMessage());
				e.printStackTrace();
			}
			
			return listaFilas;
			
		}

		private List<Integer> isActivoComercializable(MSVHojaExcel exc){
			
			List<Integer> listaFilas = new ArrayList<Integer>();
			
			int i = 0;
			try {
				for (i = 1 ; i < this.numFilasHoja ; i++){
					if(particularValidator.isActivoNoComercializable(exc.dameCelda(i, POSICION_COLUMNA_ID_ACTIVO_HAYA)))
						listaFilas.add(i);
				}
			} 
			catch (Exception e) {
				if (i != 0) listaFilas.add(i);
				logger.error(e.getMessage());
				e.printStackTrace();
			}
			
			return listaFilas;
			
		}

		private List<Integer> isActivoDestinoComercialAlquiler(MSVHojaExcel exc){
			
			List<Integer> listaFilas = new ArrayList<Integer>();
			
			int i = 0;
			try {
				for (i = 1 ; i < this.numFilasHoja ; i++){
					if(particularValidator.isActivoDestinoComercialNoAlquiler(exc.dameCelda(i, POSICION_COLUMNA_ID_ACTIVO_HAYA)))
						listaFilas.add(i);
				}
			} 
			catch (Exception e) {
				if (i != 0) listaFilas.add(i);
				logger.error(e.getMessage());
				e.printStackTrace();
			}
			
			return listaFilas;
			
		}
		
		private List<Integer> isMostrarPrecioCaracterInvalido(MSVHojaExcel exc){
			
			List<Integer> listaFilas = new ArrayList<Integer>();
			
			int i = 0;
			try {
				for (i = 1 ; i < this.numFilasHoja ; i++){
					String celda = exc.dameCelda(i, POSICION_COLUMNA_MOSTRAR_PRECIO);
					if (	!COD_SI.equalsIgnoreCase(celda) 
							&& !COD_NO.equalsIgnoreCase(celda)
							&& !COD_VACIO.equals(celda) 
						) {
						listaFilas.add(i);
					}
				}
			} 
			catch (Exception e) {
				if (i != 0) listaFilas.add(i);
				logger.error(e.getMessage());
				e.printStackTrace();
			}
			
			return listaFilas;
			
		}
		
		private List<Integer> isPublicarSinPrecioCaracterInvalido(MSVHojaExcel exc){
			
			List<Integer> listaFilas = new ArrayList<Integer>();
			
			int i = 0;
			try {
				for (i = 1 ; i < this.numFilasHoja ; i++){
					String celda = exc.dameCelda(i, POSICION_COLUMNA_PUBLICAR_SIN_PRECIO);
					if (	!COD_SI.equalsIgnoreCase(celda) 
							&& !COD_NO.equalsIgnoreCase(celda)
							&& !COD_VACIO.equals(celda) 
						) {
						listaFilas.add(i);
					}
				}
			} 
			catch (Exception e) {
				if (i != 0) listaFilas.add(i);
				logger.error(e.getMessage());
				e.printStackTrace();
			}
			
			return listaFilas;
			
		}
		
}
