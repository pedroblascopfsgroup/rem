package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.Normalizer;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
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
public class MSVValidatorConfiguracionPeriodosVoluntarios extends MSVExcelValidatorAbstract {
	private static final String TIPO_DE_IMPUESTO_NO_EXISTE = "msg.error.masivo.periodo.voluntarios.campo.tipodeimpuesto";
	private static final String PERIODICIDAD_NO_EXISTE = "msg.error.masivo.periodo.voluntarios.campo.periodicidad";
	private static final String CALCULO_NO_EXISTE = "msg.error.masivo.periodo.voluntarios.campo.calculo";
	private static final String POBLACION_NO_EXISTE = "msg.error.masivo.periodo.voluntarios.campo.localidad";
	private static final String MUNICIPIO_NO_EXISTE = "msg.error.masivo.periodo.voluntarios.campo.municipio";
	private static final String POBLACION_Y_MUNICIPIO_NO_COINCIDEN = "msg.error.masivo.periodo.voluntarios.campo.municipio.localidad.no.coincide";
	
	public static final String COD_AGUA = "103"; 
	public static final String COD_ALCANTARILLADO = "104"; 
	public static final String COD_BASURA = "105"; 
	public static final String COD_EXACCIONES_MUNICIPALES = "106"; 
	public static final String COD_OTRAS_TASAS_MUNICIPALES = "107"; 
	public static final String COD_TASA_CANALONES = "108"; 
	public static final String COD_TASA_INCENDIOS = "109"; 
	public static final String COD_REGULACION_CATASTRAL = "110"; 
	public static final String COD_TASAS_ADMINISTRATIVAS = "111"; 
	public static final String COD_TRIBUTO_METROPOLITANO_MOVILIDAD = "112"; 
	public static final String COD_VADO = "113"; 

	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;

		static final int COL_NUM_POBLACION = 0;
		static final int COL_NUM_MUNICIPIO = 1;
		static final int COL_NUM_TIPO_DE_IMPUESTO = 2;
		static final int COL_NUM_FECHA_INICIO = 3;
		static final int COL_NUM_FECHA_FIN = 4;
		static final int COL_NUM_PERIODICIDAD = 5;
		static final int COL_NUM_CALCULO = 6;
	}

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
	private MSVBusinessValidationFactory validationFactory;

	private Integer numFilasHoja;

	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		if (dtoFile.getIdTipoOperacion() == null) {
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = new MSVDtoValidacion();
		dtoValidacionContenido.setFicheroTieneErrores(false);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());

		// Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		// Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(messageServices.getMessage(TIPO_DE_IMPUESTO_NO_EXISTE), existeTipoDeImpuesto(exc));
			mapaErrores.put(messageServices.getMessage(PERIODICIDAD_NO_EXISTE), existePeriodicidad(exc));
			mapaErrores.put(messageServices.getMessage(CALCULO_NO_EXISTE), existeCalculo(exc));
			mapaErrores.put(messageServices.getMessage(POBLACION_NO_EXISTE), existePoblacion(exc));
			mapaErrores.put(messageServices.getMessage(MUNICIPIO_NO_EXISTE), existeMunicipio(exc));
			mapaErrores.put(messageServices.getMessage(POBLACION_Y_MUNICIPIO_NO_COINCIDEN), coincideMunicipioPoblacion(exc));

			for (Entry<String, List<Integer>> registros : mapaErrores.entrySet()) {
				if (!registros.getValue().isEmpty()) {
					dtoValidacionContenido.setFicheroTieneErrores(true);
					dtoValidacionContenido
							.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
					break;
				}
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

	private List<Integer> existeTipoDeImpuesto(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		final String IBIURBANA = "01";
		final String IBIRUSTICA = "02";
		final String OTRASTASAS = "17";

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {

				String columnaTipoImpuesto = exc.dameCelda(i, COL_NUM.COL_NUM_TIPO_DE_IMPUESTO);

				if (!particularValidator.existeCodImpuesto(columnaTipoImpuesto)
						|| !(IBIURBANA.equals(columnaTipoImpuesto) 
							|| 	IBIRUSTICA.equals(columnaTipoImpuesto)
							|| 	OTRASTASAS.equals(columnaTipoImpuesto) 
							|| 	COD_AGUA.equals(columnaTipoImpuesto) 
							|| 	COD_ALCANTARILLADO.equals(columnaTipoImpuesto)
							||	COD_BASURA.equals(columnaTipoImpuesto)
							||	COD_EXACCIONES_MUNICIPALES.equals(columnaTipoImpuesto) 
							||	COD_OTRAS_TASAS_MUNICIPALES.equals(columnaTipoImpuesto)
							||	COD_TASA_CANALONES.equals(columnaTipoImpuesto) 
							||	COD_TASA_INCENDIOS.equals(columnaTipoImpuesto) 
							||	COD_REGULACION_CATASTRAL.equals(columnaTipoImpuesto)
							||	COD_TASAS_ADMINISTRATIVAS.equals(columnaTipoImpuesto) 
							|| 	COD_TRIBUTO_METROPOLITANO_MOVILIDAD.equals(columnaTipoImpuesto)
							|| 	COD_VADO.equals(columnaTipoImpuesto))
					)
					listaFilas.add(i);

			}

		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> existePeriodicidad(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		final String variosPeriodos = "08";

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				String columnaPeriocidad = exc.dameCelda(i, COL_NUM.COL_NUM_PERIODICIDAD);
				if (columnaPeriocidad!= null)
					if (!particularValidator.existePeriodicidad(columnaPeriocidad)
							|| variosPeriodos.equals(columnaPeriocidad))
						listaFilas.add(i);

			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> existeCalculo(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				String columnaCalculo = exc.dameCelda(i, COL_NUM.COL_NUM_CALCULO);

				if (columnaCalculo != null)
					if (!particularValidator.existeCalculo(columnaCalculo))
						listaFilas.add(i);

			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> existePoblacion(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				String columnaPoblacion = exc.dameCelda(i, COL_NUM.COL_NUM_POBLACION);
			

				if ((columnaPoblacion != null) && !columnaPoblacion.isEmpty())
					if (!particularValidator.existePoblacionByDescripcion(columnaPoblacion))
						listaFilas.add(i);

			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> existeMunicipio(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				String columnaMunicipio = exc.dameCelda(i, COL_NUM.COL_NUM_MUNICIPIO);
				if ((columnaMunicipio!=null) && !columnaMunicipio.isEmpty()) {
					if (!particularValidator.existeMunicipioByDescripcion(columnaMunicipio))
						listaFilas.add(i);

				}
					
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> coincideMunicipioPoblacion(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				String columnaMunicipio = exc.dameCelda(i, COL_NUM.COL_NUM_MUNICIPIO);
				String columnaPoblacion = exc.dameCelda(i, COL_NUM.COL_NUM_POBLACION);
				if (((columnaMunicipio !=null && columnaPoblacion!=null)&& (!columnaMunicipio.isEmpty() && !columnaPoblacion.isEmpty()))) {
					if (!particularValidator.relacionPoblacionLocalidad(columnaPoblacion,columnaMunicipio))
						listaFilas.add(i);

				}
				
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	

	
	
}
