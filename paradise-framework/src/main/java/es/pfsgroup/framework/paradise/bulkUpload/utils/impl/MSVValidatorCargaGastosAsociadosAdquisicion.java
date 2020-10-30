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
public class MSVValidatorCargaGastosAsociadosAdquisicion extends MSVExcelValidatorAbstract {

	private final String CHECK_NUM_ACTIVO_NO_EXISTE = "msg.error.masivo.gastos.asociados.adquisicion.activo.no.valido";
	private final String CHECK_NUM_ACTIVO_FUERA_PERIMETRO_HAYA = "msg.error.masivo.gastos.asociados.adquisicion.activo.fuera.phaya";
	private final String CHECK_NUM_ACTIVO_FUERA_PERIMETRO_ADMISION = "msg.error.masivo.gastos.asociados.adquisicion.activo.fuera.padmision";
	private final String CHECK_TIPO_GASTO_INCORRECTO = "msg.error.masivo.gastos.asociados.adquisicion.gasto.no.valido";
	
	private static final String COD_ITP ="01";
	private static final String COD_PLUSVALIA_ADQUISICION ="02";
	private static final String COD_NOTARIA ="03";
	private static final String COD_REGISTRO ="04";
	private static final String COD_OTROS_GASTOS ="05";
	
	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int NUM_COLS = 6;

	private final int COL_NUM_ACTIVO_HAYA = 0;
	private final int COL_TIPO_GASTO = 1;
	private final int COL_F_SOLICITUD = 2;
	private final int COL_F_PAGO = 3;
	private final int COL_IMPORTE = 4;
	private final int COL_OBSERVACIONES = 5;
	
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
					"MSVActualizarPerimetroActivos::validarContenidoFichero -> idTipoOperacion no puede ser null");
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
		mapaErrores.put(messageServices.getMessage(CHECK_NUM_ACTIVO_FUERA_PERIMETRO_HAYA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_NUM_ACTIVO_FUERA_PERIMETRO_ADMISION), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(CHECK_TIPO_GASTO_INCORRECTO), new ArrayList<Integer>());
		
	}
	
	private boolean validarFichero(MSVHojaExcel exc) {
		boolean esCorrecto = true;
		
		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			esCorrecto = true;
			try {
 				
				String numActivo = exc.dameCelda(fila, COL_NUM_ACTIVO_HAYA);			
				boolean activoExiste = particularValidator.existeActivo(numActivo);
 				
				if(activoExiste) {

					String tipoGasto = exc.dameCelda(fila, COL_TIPO_GASTO);
					
					/*
					 * Validacion que evalua si el activo está incluido en perímetro de haya.
					 */
					if(!particularValidator.esActivoIncluidoPerimetro(numActivo)) {
						mapaErrores.get(messageServices.getMessage(CHECK_NUM_ACTIVO_FUERA_PERIMETRO_HAYA)).add(fila);
						esCorrecto = false;
					}
	
					/*
					 * Validacion que evalua si el activo está incluido en perímetro de admisión.
					 */					
					if (!particularValidator.esActivoIncluidoPerimetroAdmision(numActivo)) {
						mapaErrores.get(messageServices.getMessage(CHECK_NUM_ACTIVO_FUERA_PERIMETRO_ADMISION)).add(fila);
						esCorrecto = false;
					}
	
					/*
					 * Validacion que evalua si el tipo de gasto indicado es correcto.
					 */
					List<String> codigosValidos = Arrays.asList(COD_ITP,COD_PLUSVALIA_ADQUISICION,COD_NOTARIA,COD_REGISTRO,COD_OTROS_GASTOS);
					if (tipoGasto == null || !codigosValidos.contains(tipoGasto)) {
						mapaErrores.get(messageServices.getMessage(CHECK_TIPO_GASTO_INCORRECTO)).add(fila);
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

}



