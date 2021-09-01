package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
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
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationFactory;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidators;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.dto.ResultadoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;


@Component
public class MSVConfiguracionRecomendacionValidator extends MSVExcelValidatorAbstract {

	private final String ERROR_CARTERA_INVALID = "msg.error.masivo.cartera.invalid";
	private final String ERROR_CARTERA_EMPTY = "msg.error.masivo.cartera.empty";
	private final String ERROR_SUBCARTERA_INVALID = "msg.error.masivo.subcartera.invalid";
	private final String ERROR_SUBCARTERA_EMPTY = "msg.error.masivo.subcartera.empty";
	private final String ERROR_TIPO_COMERCIALIZACION_INVALID = "msg.error.masivo.tipo.comercializacion.invalid";
	private final String ERROR_TIPO_COMERCIALIZACION_EMPTY = "msg.error.masivo.tipo.comercializacion.empty";
	private final String ERROR_EQUIPO_GESTION_INVALID = "msg.error.masivo.equipo.gestion.invalid";
	private final String ERROR_EQUIPO_GESTION_EMPTY = "msg.error.masivo.equipo.gestion.empty";
	private final String ERROR_RECOMENDACION_INVALID = "msg.error.masivo.recomendacion.invalid";
	private final String ERROR_NUMBER_INVALID = "msg.error.masivo.number.invalid";
	
	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int NUM_COLS = 7;

	private final int COL_CARTERA = 0;
	private final int COL_SUBCARTERA = 1;
	private final int COL_TIPO_COMERCIALIZACION = 2;
	private final int COL_EQUIPO_GESTION = 3;
	private final int COL_DESCUENTO = 4;
	private final int COL_IMPORTE_MINIMO = 5;
	private final int COL_RECOMENDACION = 6;
	
	private Map<String, List<Integer>> mapaErrores;
	

	@Resource
	private MessageService messageServices;

	@Autowired
	private MSVExcelParser excelParser;

	@Autowired
	private ParticularValidatorApi particularValidator;

	@Autowired
	private MSVProcesoApi msvProcesoApi;

	@Autowired
	private MSVBusinessValidationFactory validationFactory;

	private Integer numFilasHoja;

	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();		
		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVConfiguracionRecomendacionValidator -> idTipoOperacion no puede ser null");
		}
		
		List<String> lista = recuperarFormato(idTipoOperacion);
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getRuta());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(idTipoOperacion));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(idTipoOperacion));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(idTipoOperacion));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(idTipoOperacion);
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(FILA_CABECERA, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			generarMapaErrores();
			
			if (!validarFichero(exc)) {
 				dtoValidacionContenido.setFicheroTieneErrores(true);
				dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
 			}

		}
			
		exc.cerrar();
		
		return dtoValidacionContenido;
	}
	
	private void generarMapaErrores() {				
		mapaErrores = new HashMap<String,List<Integer>>();
		
		mapaErrores.put(messageServices.getMessage(ERROR_CARTERA_EMPTY), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_CARTERA_INVALID), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_SUBCARTERA_INVALID), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_SUBCARTERA_EMPTY), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_NUMBER_INVALID), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_TIPO_COMERCIALIZACION_EMPTY), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_TIPO_COMERCIALIZACION_INVALID), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_EQUIPO_GESTION_EMPTY), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_EQUIPO_GESTION_INVALID), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_RECOMENDACION_INVALID), new ArrayList<Integer>());
		
	}
	
	private boolean validarFichero(MSVHojaExcel exc) {
		boolean esCorrecto = true;
		
		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
 				
				String cartera = exc.dameCelda(fila, COL_CARTERA);		
				String subcartera = exc.dameCelda(fila, COL_SUBCARTERA);	
				String tipoComercializacion = exc.dameCelda(fila, COL_TIPO_COMERCIALIZACION);	
				String equipoGestion = exc.dameCelda(fila, COL_EQUIPO_GESTION);	
				String descuento = exc.dameCelda(fila, COL_DESCUENTO);	
				String importeMinimo = exc.dameCelda(fila, COL_IMPORTE_MINIMO);	
				String recomendacion = exc.dameCelda(fila, COL_RECOMENDACION);	
				 		
				if(cartera.isEmpty() || cartera == null || cartera == "") {	
					mapaErrores.get(messageServices.getMessage(ERROR_CARTERA_EMPTY)).add(fila);
					esCorrecto = false;
				} else {
					if(!particularValidator.existeCarteraByCod(cartera)) {
						mapaErrores.get(messageServices.getMessage(ERROR_CARTERA_INVALID)).add(fila);
						esCorrecto = false;
					}				
				}
				
				if(subcartera.isEmpty() || subcartera == null || subcartera == "") {	
					mapaErrores.get(messageServices.getMessage(ERROR_SUBCARTERA_EMPTY)).add(fila);
					esCorrecto = false;
				} else {
					if(!particularValidator.existeSubCarteraByCod(subcartera)) {
						mapaErrores.get(messageServices.getMessage(ERROR_SUBCARTERA_INVALID)).add(fila);
						esCorrecto = false;
					} else if (!particularValidator.subcarteraPerteneceCartera(subcartera, cartera)) {
						mapaErrores.get(messageServices.getMessage(ERROR_SUBCARTERA_INVALID)).add(fila);
						esCorrecto = false;
					}
				}	
				
				if(tipoComercializacion.isEmpty() || tipoComercializacion == null || tipoComercializacion == "") {	
					mapaErrores.get(messageServices.getMessage(ERROR_TIPO_COMERCIALIZACION_EMPTY)).add(fila);
					esCorrecto = false;
				} else {
					if(!particularValidator.existeDestComercialByCod(tipoComercializacion)) {
						mapaErrores.get(messageServices.getMessage(ERROR_TIPO_COMERCIALIZACION_INVALID)).add(fila);
						esCorrecto = false;
					}				
				}
				
				if(equipoGestion.isEmpty() || equipoGestion == null || equipoGestion == "") {	
					mapaErrores.get(messageServices.getMessage(ERROR_EQUIPO_GESTION_EMPTY)).add(fila);
					esCorrecto = false;
				} else {
					if(!particularValidator.perteneceADiccionarioEquipoGestion(equipoGestion)) {
						mapaErrores.get(messageServices.getMessage(ERROR_EQUIPO_GESTION_INVALID)).add(fila);
						esCorrecto = false;
					}				
				}
				
				if(!descuento.isEmpty() && descuento != null && descuento != "") {	
					if(esNumeroCeroOrNan(descuento)) {
						mapaErrores.get(messageServices.getMessage(ERROR_NUMBER_INVALID)).add(fila);
						esCorrecto = false;
					}
				} 
				
				if(!importeMinimo.isEmpty() && importeMinimo != null && importeMinimo != "") {	
					if(esNumeroCeroOrNan(importeMinimo)) {
						mapaErrores.get(messageServices.getMessage(ERROR_NUMBER_INVALID)).add(fila);
						esCorrecto = false;
					}
				} 
				
				if(!recomendacion.isEmpty() && recomendacion != null && recomendacion != "") {	
					if(!particularValidator.existeRecomendacionByCod(recomendacion)) {
						mapaErrores.get(messageServices.getMessage(ERROR_RECOMENDACION_INVALID)).add(fila);
						esCorrecto = false;
					}				
				}

			} catch (Exception e) {
				logger.error(e.getMessage());
	 			esCorrecto = false;
			}
 		}
 
		return esCorrecto;
 	}

	@Override
	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda,
			MSVBusinessValidators contentValidators) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected ResultadoValidacion validaContenidoFila(Map<String, String> mapaDatos, List<String> listaCabeceras,
			MSVBusinessCompositeValidators compositeValidators) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Integer getNumFilasHoja() {
		// TODO Auto-generated method stub
		return this.numFilasHoja;
	}
	
	private boolean esNumeroCeroOrNan(String numero) {

		if(numero != null && !numero.isEmpty()){
			if(numero.contains(",")){
				numero = numero.replace(",", ".");
			}
		}
		
		Double number = !Checks.esNulo(numero) ? Double.parseDouble(numero) : null;

		if ((!Checks.esNulo(number) && !number.isNaN() 
				&& number.compareTo(0.0D) > 0)) return true;
		return false;
	}

}



