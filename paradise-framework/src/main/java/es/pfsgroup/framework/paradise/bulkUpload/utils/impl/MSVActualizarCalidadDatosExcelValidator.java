package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
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
public class MSVActualizarCalidadDatosExcelValidator extends MSVExcelValidatorAbstract {

	private final String CHECK_IDENTIFICADOR = "msg.error.masivo.calidad.datos.identificador.no.valido";
	private final String CHECK_CAMPO = "msg.error.masivo.calidad.datos.campo.no.valido";
	private final String CHECK_VALOR = "msg.error.masivo.calidad.datos.valor.no.valido";	

	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int NUM_COLS = 3;

	private final int COL_IDENTIFICADOR = 0;
	private final int COL_CAMPO = 1;
	private final int COL_VALOR = 2;
	
	private final String CAMPO_SUBTIPO_ACTIVO = "05";
	private final String CODIGO_APARTAMENTO_TURISTICO = "40";
	private final String CODIGO_HOSTELERO = "41";
	private final String CODIGO_SUELO_URBANO_NO_CONSOLIDADO = "42";
	
	private final String CODIGO_ANYADIR_A_PROMOCION = "29";
	private final String CODIGO_ELIMINAR_DE_PROMOCION = "30";

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

	Map<String, List<Integer>> mapaErrores;

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();

		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVActualizarCalidadDatosExcelValidator::validarContenidoFichero -> idTipoOperacion no puede ser null");
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
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		if (!dtoValidacionContenido.getFicheroTieneErrores() && !validarFichero(exc)) {
			dtoValidacionContenido.setFicheroTieneErrores(true);
			dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
		}
		exc.cerrar();
		return dtoValidacionContenido;
	}

	private boolean validarFichero(MSVHojaExcel exc) {
		boolean esCorrecto = true;
		mapaErrores = new HashMap<String, List<Integer>>();
		ArrayList<ArrayList<Integer>> listasError = new ArrayList<ArrayList<Integer>>();
		ArrayList<Integer> errList = null;		
		String celda, tipoCampo;
		boolean valorOK = true;
		
		for (int columna = 0; columna < NUM_COLS; columna++) {
			listasError.add(columna, new ArrayList<Integer>());
		}		
		
		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			tipoCampo = null;
			try {
				for (int columna = 0; columna < NUM_COLS; columna++) {
					errList = listasError.get(columna);					
					celda = exc.dameCelda(fila, columna);
					

					switch (columna) {
					case COL_IDENTIFICADOR:
						valorOK = !Checks.esNulo(celda) && particularValidator.existeActivo(celda) ;
						break;

					case COL_CAMPO:
						tipoCampo = particularValidator.getValidacionCampoCDC(celda);
						valorOK = !Checks.esNulo(tipoCampo);						
						break;
						
					case COL_VALOR:
						valorOK = Checks.esNulo(celda) 	|| (tipoCampo != null && esValorCorrectoCDC(tipoCampo, celda)) 
								&& (tipoCampo != null && comprobarCarteraYSubtipo(exc.dameCelda(fila, COL_CAMPO), exc.dameCelda(fila, COL_IDENTIFICADOR), celda) 
								&& comprobarEsPromocion(exc.dameCelda(fila, COL_CAMPO), celda));
						break;						
					}

					if (!valorOK) {
						errList.add(fila);
						esCorrecto = false;
					}

				}

			} catch (ParseException e) {
				errList.add(fila);
				esCorrecto = false;
				logger.error(e.getMessage());
			} catch (Exception e) {
				errList.add(0);
				esCorrecto = false;
				logger.error(e.getMessage());
			}
		}
		
		if (!esCorrecto) {
			mapaErrores.put(messageServices.getMessage(CHECK_IDENTIFICADOR), listasError.get(COL_IDENTIFICADOR));
			mapaErrores.put(messageServices.getMessage(CHECK_CAMPO), listasError.get(COL_CAMPO));
			mapaErrores.put(messageServices.getMessage(CHECK_VALOR), listasError.get(COL_VALOR));		
		}
		return esCorrecto;
	}

	private boolean esValorCorrectoCDC(String tipoCampo, String celda) {
		boolean esCorrecto = true;
		if ("F".equalsIgnoreCase(tipoCampo)) {
			try {
				DateFormat.toDate(celda);
			} catch (ParseException e) {
				esCorrecto = false;
				logger.error(e.getMessage());
			}
		}
		return esCorrecto;
	}
	
	private boolean comprobarCarteraYSubtipo(String codigoCampo, String numeroActivo, String celda) {
		boolean esCorrecto = true;
		List<String> listaCodigos = Arrays.asList(CODIGO_APARTAMENTO_TURISTICO,CODIGO_HOSTELERO,CODIGO_SUELO_URBANO_NO_CONSOLIDADO);
		if (CAMPO_SUBTIPO_ACTIVO.equals(codigoCampo) && (numeroActivo != null && !particularValidator.esActivoBBVA(numeroActivo))) {
			String codigoSubtipo = particularValidator.sacarCodigoSubtipoActivo(celda);
			if (codigoSubtipo == null || listaCodigos.contains(codigoSubtipo)) {
				esCorrecto = false;	
			}
		}
		return esCorrecto;
	}
	
	private boolean comprobarEsPromocion(String codigoCampo, String celda) {
		Boolean esCorrecto = true;
		Pattern pattern = Pattern.compile("-?\\d+(\\.\\d+)?");
		
		if ((CODIGO_ANYADIR_A_PROMOCION.equals(codigoCampo) || CODIGO_ELIMINAR_DE_PROMOCION.equals(codigoCampo)) && !pattern.matcher(celda).matches()) {
			return !esCorrecto;
		} else {
			return esCorrecto;
		}
	}

	@Override
	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda, MSVBusinessValidators contentValidators) {
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
	protected ResultadoValidacion validaContenidoFila(Map<String, String> mapaDatos, List<String> listaCabeceras, MSVBusinessCompositeValidators compositeValidators) {
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

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
	
}
