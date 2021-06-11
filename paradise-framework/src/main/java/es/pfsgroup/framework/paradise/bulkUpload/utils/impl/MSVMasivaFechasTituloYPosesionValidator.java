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
public class MSVMasivaFechasTituloYPosesionValidator extends MSVExcelValidatorAbstract {

	private final String ACTIVO_NO_EXISTE = "msg.error.masivo.fecha.titulo.fecha.posesion.activo.no.valido";
	private final String CHECK_NUM_ACTIVO_FUERA_PERIMETRO_HAYA = "msg.error.masivo.fecha.titulo.fecha.posesion.activo.fuera.haya";
	private final String ACTIVO_NO_ADJUDICACION_NO_FAMILIAR = "msg.error.masivo.fecha.titulo.fecha.posesion.activo.no.adjudicacion.judicial";
	private final String FECHA_POSESION_SUBCARTERA_ERRONEA = "msg.error.masivo.fecha.titulo.fecha.posesion.fecha.posesion.contenido.no.subcartera";
	private final String ACTIVO_UA = "msg.error.masivo.fecha.titulo.fecha.posesion.activo.ua";
	private final String FECHAS_VACIAS = "msg.error.masivo.fecha.titulo.fecha.posesion.campo.informado.no.vacio";
	
	
	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int NUM_COLS = 3;

	private static final String COD_NO_JUDICIAL ="02";

	
	private final int COL_NUM_ACTIVO_HAYA = 0;
	private final int COL_F_TITULO = 1;
	private final int COL_F_POSESION = 2;

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
					"MSVMasivaFechasTituloYPosesionValidator::validarContenidoFichero -> idTipoOperacion no puede ser null");
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
		
		mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_NUM_ACTIVO_FUERA_PERIMETRO_HAYA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ACTIVO_NO_ADJUDICACION_NO_FAMILIAR), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(FECHA_POSESION_SUBCARTERA_ERRONEA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ACTIVO_UA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(FECHAS_VACIAS), new ArrayList<Integer>());
	}
	
	private boolean validarFichero(MSVHojaExcel exc) {
		boolean esCorrecto = true;
		
		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			esCorrecto = true;
			try {
 				
				String numActivo = exc.dameCelda(fila, COL_NUM_ACTIVO_HAYA);			
				boolean activoExiste = particularValidator.existeActivo(numActivo);
				String fechaTitulo = exc.dameCelda(fila, COL_F_TITULO);
				String fechaPos = exc.dameCelda(fila, COL_F_POSESION);

				
 				
				if(activoExiste) {
					
				
					if(!particularValidator.esActivoIncluidoPerimetro(numActivo)) {
						mapaErrores.get(messageServices.getMessage(CHECK_NUM_ACTIVO_FUERA_PERIMETRO_HAYA)).add(fila);
						esCorrecto = false;
					}					
					if(!particularValidator.verificaTipoDeAdjudicacion(numActivo,COD_NO_JUDICIAL)) {
						mapaErrores.get(messageServices.getMessage(ACTIVO_NO_ADJUDICACION_NO_FAMILIAR)).add(fila);
						esCorrecto = false;
					}
					if(fechaPos != null && !particularValidator.esSubCarterasCerberusAppleDivarian(numActivo) && !particularValidator.esActivoSareb(numActivo)) {
						mapaErrores.get(messageServices.getMessage(FECHA_POSESION_SUBCARTERA_ERRONEA)).add(fila);
						esCorrecto = false;
					}
					if(particularValidator.esUnidadAlquilable(numActivo)) {
						mapaErrores.get(messageServices.getMessage(ACTIVO_UA)).add(fila);
						esCorrecto = false;
					}
					if((fechaPos == null || fechaPos.isEmpty() ) && (fechaTitulo == null || fechaTitulo.isEmpty())) {
						mapaErrores.get(messageServices.getMessage(FECHAS_VACIAS)).add(fila);
						esCorrecto = false;
					}
				}
				else {
					mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).add(fila);
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
		return this.numFilasHoja;
	}

}
