package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
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
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
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
public class MSVValidatorCargaCamposAccesibilidad extends MSVExcelValidatorAbstract {

	private final String CHECK_NUM_ACTIVO_NO_EXISTE = "msg.error.masivo.campos.accesibilidad.activo.no.valido";
	private final String CHECK_TAPIADO_SI = "msg.error.masivo.campos.accesibilidad.tapiado.si";
	private final String CHECK_TAPIADO_NO = "msg.error.masivo.campos.accesibilidad.tapiado.no";
	private final String CHECK_CAMPOS_CORRECTOS_TAPIADO="msg.error.masivo.campos.accesibilidad.generico.valores.correctos.tapiado";
	private final String CHECK_F_TAPIADO="msg.error.masivo.campos.accesibilidad.tapiado.vacio";
	
	private final String CHECK_PUERTA_ANTIOCUPA_SI ="msg.error.masivo.campos.accesibilidad.puerta.antiocupa.si";
	private final String CHECK_PUERTA_ANTIOCUPA_NO ="msg.error.masivo.campos.accesibilidad.puerta.antiocupa.no";
	private final String CHECK_CAMPOS_CORRECTOS_PUERTA_ANTIOCUPA="msg.error.masivo.campos.accesibilidad.generico.valores.correctos.puerta.antiocupa";
	private final String CHECK_F_PUERTA_ANTIOCUPA="msg.error.masivo.campos.accesibilidad.puerta.antiocupa.vacio";
	
	private final String CHECK_ALARMA_SI="msg.error.masivo.campos.accesibilidad.alarma.si";
	private final String CHECK_ALARMA_SI_DESINSTALACION="msg.error.masivo.campos.accesibilidad.alarma.si.desisntalacion";
	private final String CHECK_F_ALARMA="msg.error.masivo.campos.accesibilidad.alarma.f.vacia";
	private final String CHECK_ALARMA_NO="msg.error.masivo.campos.accesibilidad.alarma.no";
	private final String CHECK_ALARMA_NO_DESINSTALACION="msg.error.masivo.campos.accesibilidad.alarma.no.desisntalacion";
	private final String CHECK_CAMPOS_CORRECTOS_ALARMA="msg.error.masivo.campos.accesibilidad.generico.valores.correctos.alarma";
	
	private final String CHECK_VIGILANCIA_SI="msg.error.masivo.campos.accesibilidad.vigilancia.si";
	private final String CHECK_VIGILANCIA_SI_DESINSTALACION="msg.error.masivo.campos.accesibilidad.vigilancia.si.desinstalacion";
	private final String CHECK_F_VIGILANCIA="msg.error.masivo.campos.accesibilidad.vigilancia.f.vacia";
	private final String CHECK_VIGILANCIA_NO="msg.error.masivo.campos.accesibilidad.vigilancia.no";
	private final String CHECK_VIGILANCIA_NO_DESINSTALACION="msg.error.masivo.campos.accesibilidad.alarma.no.desisntalacion";
	private final String CHECK_CAMPOS_CORRECTOS_VIGILANCIA="msg.error.masivo.campos.accesibilidad.generico.valores.correctos.vigilancia";
	
	
	
	private static final String COD_VALIDOS_S ="S";
	private static final String COD_VALIDOS_SI ="SI";
	private static final String COD_VALIDOS_SI_MINUSCULA ="Si";
	private static final String COD_VALIDOS_SI_MINUSCULA_2 ="sI";
	private static final String COD_VALIDOS_SI_NUMERICO = "01";
	
	private static final String COD_VALIDOS_N ="N";
	private static final String COD_VALIDOS_NO ="NO";
	private static final String COD_VALIDOS_NO_MINUSCULA ="No";
	private static final String COD_VALIDOS_NO_MINUSCULA_2 ="nO";
	private static final String COD_VALIDOS_NO_NUMERICO = "02";
	
	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int NUM_COLS = 11;

	private final int COL_NUM_ACTIVO_HAYA = 0;
	private final int COL_TAPIADO = 1;
	private final int COL_F_TAPIADO = 2;
	private final int COL_PUERTA_ANTIOCUPA = 3;
	private final int COL_F_COLOCACION_PUERTA_ANTIOCUPA = 4;
	private final int COL_ALARMA = 5;
	private final int COL_F_INSTALACION_ALARMA = 6;
	private final int COL_F_DESINSTALACION_ALARMA = 7;
	private final int COL_VIGILANCIA = 8;
	private final int COL_F_INSTALACION_VIGILANCIA= 9;
	private final int COL_F_DESINSTALACION_VIGILANCIA = 10;
	
	private Map<String, List<Integer>> mapaErrores;
	

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
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();		
		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVActualizadorCargaCamposAccesibilidad -> idTipoOperacion no puede ser null");
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
		
		mapaErrores.put(messageServices.getMessage(CHECK_NUM_ACTIVO_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_TAPIADO_SI), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_TAPIADO_NO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_PUERTA_ANTIOCUPA_SI), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_PUERTA_ANTIOCUPA_NO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_ALARMA_SI), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_ALARMA_SI_DESINSTALACION), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_VIGILANCIA_SI), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_VIGILANCIA_SI_DESINSTALACION), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_F_ALARMA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_F_VIGILANCIA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_ALARMA_NO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_ALARMA_NO_DESINSTALACION), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_VIGILANCIA_NO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_VIGILANCIA_NO_DESINSTALACION), new ArrayList<Integer>());
		
		mapaErrores.put(messageServices.getMessage(CHECK_CAMPOS_CORRECTOS_TAPIADO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_F_TAPIADO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_CAMPOS_CORRECTOS_PUERTA_ANTIOCUPA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_F_PUERTA_ANTIOCUPA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_CAMPOS_CORRECTOS_ALARMA), new ArrayList<Integer>());	
		mapaErrores.put(messageServices.getMessage(CHECK_CAMPOS_CORRECTOS_VIGILANCIA), new ArrayList<Integer>());
		
	}
	
	private boolean validarFichero(MSVHojaExcel exc) {
		boolean esCorrecto = true;
		
		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
 				
				String numActivo = exc.dameCelda(fila, COL_NUM_ACTIVO_HAYA);		
				String colTapiado = exc.dameCelda(fila, COL_TAPIADO);	
				String colFTapiado = exc.dameCelda(fila, COL_F_TAPIADO);	
				String colPuertaAntiocupa = exc.dameCelda(fila, COL_PUERTA_ANTIOCUPA);	
				String colFColocacionPuertaAntiocupa = exc.dameCelda(fila, COL_F_COLOCACION_PUERTA_ANTIOCUPA);	
				String colConAlarma = exc.dameCelda(fila, COL_ALARMA);	
				String colFInstalacionAlarma = exc.dameCelda(fila, COL_F_INSTALACION_ALARMA);	
				String colFDesinstalacionAlarma = exc.dameCelda(fila, COL_F_DESINSTALACION_ALARMA);	
				String colConVigilancia = exc.dameCelda(fila, COL_VIGILANCIA);	
				String colFInstalacionVigilancia = exc.dameCelda(fila, COL_F_INSTALACION_VIGILANCIA);	
				String colFDesinstalacionVigilancia = exc.dameCelda(fila, COL_F_DESINSTALACION_VIGILANCIA);	
				List<String> codigosValidos = Arrays.asList(COD_VALIDOS_S,COD_VALIDOS_SI,COD_VALIDOS_SI_MINUSCULA,COD_VALIDOS_SI_MINUSCULA_2,COD_VALIDOS_SI_NUMERICO);
				List<String> codigosNoValidos = Arrays.asList(COD_VALIDOS_N,COD_VALIDOS_NO,COD_VALIDOS_NO_MINUSCULA,COD_VALIDOS_NO_MINUSCULA_2,COD_VALIDOS_NO_NUMERICO);
				List<String> codigosCorrectos = Arrays.asList(COD_VALIDOS_S,COD_VALIDOS_SI,COD_VALIDOS_SI_MINUSCULA,COD_VALIDOS_SI_MINUSCULA_2,COD_VALIDOS_SI_NUMERICO,COD_VALIDOS_N,COD_VALIDOS_NO,COD_VALIDOS_NO_MINUSCULA,COD_VALIDOS_NO_MINUSCULA_2,COD_VALIDOS_NO_NUMERICO);
				boolean activoExiste = particularValidator.existeActivo(numActivo);
				 		
				if(activoExiste) {
					
					
					if(!colTapiado.isEmpty() || colTapiado!=null) {							
						if(codigosValidos.contains(colTapiado) && colFTapiado.isEmpty()) {
							mapaErrores.get(messageServices.getMessage(CHECK_TAPIADO_SI)).add(fila);
							esCorrecto = false;
						}
						if(codigosNoValidos.contains(colTapiado) && !colFTapiado.isEmpty()) {
							mapaErrores.get(messageServices.getMessage(CHECK_TAPIADO_NO)).add(fila);
							esCorrecto = false;
						}
						
					}
					if(colTapiado.isEmpty() || colTapiado==null) {
						if(colFTapiado!=null && !colFTapiado.isEmpty()) {
							mapaErrores.get(messageServices.getMessage(CHECK_F_TAPIADO)).add(fila);
							esCorrecto = false;
						}
					}
					
					if(!colTapiado.isEmpty() && colTapiado!=null) {
						if(!codigosCorrectos.contains(colTapiado)) {
							mapaErrores.get(messageServices.getMessage(CHECK_CAMPOS_CORRECTOS_TAPIADO)).add(fila);
							esCorrecto = false;
						}
					}
					
					
					if(!colPuertaAntiocupa.isEmpty() || colPuertaAntiocupa!=null) {
						if(codigosValidos.contains(colPuertaAntiocupa) && colFColocacionPuertaAntiocupa.isEmpty()) {
							mapaErrores.get(messageServices.getMessage(CHECK_PUERTA_ANTIOCUPA_SI)).add(fila);
							esCorrecto = false;
						}
						if(codigosNoValidos.contains(colPuertaAntiocupa) && !colFColocacionPuertaAntiocupa.isEmpty() ) {
							mapaErrores.get(messageServices.getMessage(CHECK_PUERTA_ANTIOCUPA_NO)).add(fila);
							esCorrecto = false;
						}
					}
					
					if(!colPuertaAntiocupa.isEmpty() && colPuertaAntiocupa!=null) {
						if(!codigosCorrectos.contains(colPuertaAntiocupa)) {
							mapaErrores.get(messageServices.getMessage(CHECK_CAMPOS_CORRECTOS_PUERTA_ANTIOCUPA)).add(fila);
							esCorrecto = false;
						}
					}
					if(colPuertaAntiocupa.isEmpty() || colPuertaAntiocupa==null) {
						if(colFColocacionPuertaAntiocupa!=null && !colFColocacionPuertaAntiocupa.isEmpty()) {
							mapaErrores.get(messageServices.getMessage(CHECK_F_PUERTA_ANTIOCUPA)).add(fila);
							esCorrecto = false;
						}
					}
					
					//SI
					if(!colConAlarma.isEmpty()) {
						if(codigosValidos.contains(colConAlarma) && colFInstalacionAlarma.isEmpty()) {
							mapaErrores.get(messageServices.getMessage(CHECK_ALARMA_SI)).add(fila);
							esCorrecto = false;
						}
						if(codigosValidos.contains(colConAlarma) && !colFDesinstalacionAlarma.isEmpty()){
							mapaErrores.get(messageServices.getMessage(CHECK_ALARMA_SI_DESINSTALACION)).add(fila);
							esCorrecto = false;
						}
					}
					
					
					if(!colConVigilancia.isEmpty()) {
						if(codigosValidos.contains(colConVigilancia) && colFInstalacionVigilancia.isEmpty()) {
							mapaErrores.get(messageServices.getMessage(CHECK_VIGILANCIA_SI)).add(fila);
							esCorrecto = false;
						}
						if(codigosValidos.contains(colConVigilancia) && !colFDesinstalacionVigilancia.isEmpty()){
							mapaErrores.get(messageServices.getMessage(CHECK_VIGILANCIA_SI_DESINSTALACION)).add(fila);
							esCorrecto = false;
						}
					}
					
					if(!colConAlarma.isEmpty() && colConAlarma!=null) {
						if(!codigosCorrectos.contains(colConAlarma)) {
							mapaErrores.get(messageServices.getMessage(CHECK_CAMPOS_CORRECTOS_ALARMA)).add(fila);
							esCorrecto = false;
						}
					}
					
					if(!colConVigilancia.isEmpty() && colConVigilancia!=null) {
						if(!codigosCorrectos.contains(colConVigilancia)) {
							mapaErrores.get(messageServices.getMessage(CHECK_CAMPOS_CORRECTOS_VIGILANCIA)).add(fila);
							esCorrecto = false;
						}
					}
					//NO
					if(!colConAlarma.isEmpty()) {
						if(codigosNoValidos.contains(colConAlarma) && !colFInstalacionAlarma.isEmpty()) {
							mapaErrores.get(messageServices.getMessage(CHECK_ALARMA_NO)).add(fila);
							esCorrecto = false;
						}
						if(codigosNoValidos.contains(colConAlarma) && colFDesinstalacionAlarma.isEmpty()){
							mapaErrores.get(messageServices.getMessage(CHECK_ALARMA_NO_DESINSTALACION)).add(fila);
							esCorrecto = false;
						}
					}
					
					
					if(!colConVigilancia.isEmpty()) {
						if(codigosNoValidos.contains(colConVigilancia) && !colFInstalacionVigilancia.isEmpty()) {
							mapaErrores.get(messageServices.getMessage(CHECK_VIGILANCIA_NO)).add(fila);
							esCorrecto = false;
						}
						if(codigosNoValidos.contains(colConVigilancia) && colFDesinstalacionVigilancia.isEmpty()){
							mapaErrores.get(messageServices.getMessage(CHECK_VIGILANCIA_NO_DESINSTALACION)).add(fila);
							esCorrecto = false;
						}
					}
					//VACIOS
					/*if(colConAlarma.isEmpty() && (colFInstalacionAlarma!=null || colFDesinstalacionAlarma!=null)) {
						mapaErrores.get(messageServices.getMessage(CHECK_F_ALARMA)).add(fila);
						esCorrecto = false;
					}*/
					if(colConAlarma.isEmpty()) {
						if((colFInstalacionAlarma!=null && !colFInstalacionAlarma.isEmpty()) || (colFDesinstalacionAlarma!=null && !colFDesinstalacionAlarma.isEmpty())){
							mapaErrores.get(messageServices.getMessage(CHECK_F_ALARMA)).add(fila);
							esCorrecto = false;
						}
					}
				
						
					if(colConVigilancia.isEmpty() && (
							(colFInstalacionVigilancia!=null && !colFInstalacionVigilancia.isEmpty()) || (colFDesinstalacionVigilancia!=null && !colFDesinstalacionVigilancia.isEmpty()))) {
						mapaErrores.get(messageServices.getMessage(CHECK_F_VIGILANCIA)).add(fila);
						esCorrecto = false;
					}
					
					
				}
				else {
					mapaErrores.get(messageServices.getMessage(CHECK_NUM_ACTIVO_NO_EXISTE)).add(fila);
					esCorrecto = false;
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

}



