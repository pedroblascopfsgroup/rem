package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import es.pfsgroup.commons.utils.Checks;
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
public class MSVMasivaDatosSobreGastoValidator extends MSVExcelValidatorAbstract {
	
	private final String ID_NO_EXISTE = "msg.error.masivo.gastos.id.no.existe";
	private final String ESTADO_GASTO_INCORRECTO = "msg.error.masivo.gastos.estado.incorrecto";
	private final String VALIDAR_FILA_EXCEPTION = "msg.error.masivo.gastos.exception";
	private final String FECHA_INCORRECTA = "msg.error.masivo.gastos.exception.fecha";
	private final String FECHAS_VACIAS = "msg.error.masivo.gastos.fechas.vacias";
	private final String SIN_FECHA_CONTABILIZADO = "msg.error.masivo.gastos.exception.gasto.sin.fecha.contabilizado";
	private final String SIN_FECHA_PAGADO = "msg.error.masivo.gastos.exception.gasto.sin.fecha.pagado";
	
	

	private final String PAGADO= "05";
	private final String CONTABILIZADO= "04";
	private final String AUTORIZADO_ADMIN= "03";

	private final String BORRAR = "X";

	private final String FECHAS_MULTIPLES = "msg.error.masivo.gastos.fechas.multiples";

	
	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int COL_ID_GASTO = 0;
	private final int COL_FECHA_CONTA = 1;
	private final int COL_FECHA_PAGO = 2;
	
	
	private Integer numFilasHoja;	
	private Map<String, List<Integer>> mapaErrores;	
	private final Log logger = LogFactory.getLog(getClass());

	

	@Autowired
	private MSVExcelParser excelParser;

	@Autowired
	private MSVBusinessValidationFactory validationFactory;

	@Autowired
	private MSVBusinessValidationRunner validationRunner;

	@Autowired
	private ParticularValidatorApi particularValidator;

	@Autowired
	private MSVProcesoApi msvProcesoApi;


	@Resource
	MessageService messageServices;

	
	private void generarMapaErrores() {
		mapaErrores = new HashMap<String, List<Integer>>();
		mapaErrores.put(messageServices.getMessage(ID_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(FECHA_INCORRECTA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(FECHAS_VACIAS), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ESTADO_GASTO_INCORRECTO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(VALIDAR_FILA_EXCEPTION), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(SIN_FECHA_CONTABILIZADO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(SIN_FECHA_PAGADO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(FECHAS_MULTIPLES), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ESTADO_GASTO_INCORRECTO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(VALIDAR_FILA_EXCEPTION), new ArrayList<Integer>());

	}
	
	
	private boolean validarFichero(MSVHojaExcel exc) {

		boolean esCorrecto = true;

		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
				
				String idGasto = exc.dameCelda(fila, COL_ID_GASTO);
				String fechaConta = exc.dameCelda(fila, COL_FECHA_CONTA);
				String fechaPago = exc.dameCelda(fila, COL_FECHA_PAGO);


				if (!Checks.esNulo(idGasto) && (!particularValidator.existeGasto(idGasto))) {
					
					mapaErrores.get(messageServices.getMessage(ID_NO_EXISTE)).add(fila);
					esCorrecto = false;
				}else {
				
					if(Checks.esNulo(fechaConta) && Checks.esNulo(fechaPago)) {
						mapaErrores.get(messageServices.getMessage(FECHAS_VACIAS)).add(fila);
						esCorrecto = false;
					}else {
						if (!this.comprobarFechas(fechaConta) || !this.comprobarFechas(fechaPago)) {
							mapaErrores.get(messageServices.getMessage(FECHA_INCORRECTA)).add(fila);
							esCorrecto = false;
						}
						
						if(BORRAR.equalsIgnoreCase(fechaConta) && !particularValidator.tieneGastoFechaContabilizado(idGasto)) {
							mapaErrores.get(messageServices.getMessage(SIN_FECHA_CONTABILIZADO)).add(fila);
							esCorrecto = false;
						}
						if(BORRAR.equalsIgnoreCase(fechaPago) && !particularValidator.tieneGastoFechaPagado(idGasto)) {
							mapaErrores.get(messageServices.getMessage(SIN_FECHA_PAGADO)).add(fila);
							esCorrecto = false;
						}
						
					}
					
					if (!this.esCorrectoEstadoGasto(idGasto)) {
						mapaErrores.get(messageServices.getMessage(ESTADO_GASTO_INCORRECTO)).add(fila);
						esCorrecto = false;
					}
				}
		



	

			} catch (Exception e) {
				mapaErrores.get(messageServices.getMessage(VALIDAR_FILA_EXCEPTION)).add(fila);
				esCorrecto = false;
				logger.error(e.getMessage());
			}
		}

		return esCorrecto;
	}
	
	

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();

		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVMasivaDatosSobreGastosValidator::validarContenidoFichero -> idTipoOperacion no puede ser null");
		}
		
		List<String> lista = recuperarFormato(idTipoOperacion);
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(idTipoOperacion));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(idTipoOperacion));
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(idTipoOperacion));
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(idTipoOperacion);

		// Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		// Obtenemos el numero de filas reales que tiene la hoja excel a examinar
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

	@Override
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
	

	private boolean esCorrectoEstadoGasto(String idGasto) {
		String estadoGasto = particularValidator.devolverEstadoGasto(idGasto);
		List<String> listaEstadosValidos = Arrays.asList(new String[] { AUTORIZADO_ADMIN, PAGADO , CONTABILIZADO });
		if(!listaEstadosValidos.contains(estadoGasto)) {
			return false;
		}
		
		return true;
	}
	
	
	private boolean comprobarFechas(String fecha) {
		
		if(BORRAR.equalsIgnoreCase(fecha) || Checks.esNulo(fecha)) {
			return true;
		}
		
		try {
			SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            formatoFecha.setLenient(false);
            formatoFecha.parse(fecha);
		} catch (ParseException e) {
			return false;
		}
		
		return true;
	}


}
