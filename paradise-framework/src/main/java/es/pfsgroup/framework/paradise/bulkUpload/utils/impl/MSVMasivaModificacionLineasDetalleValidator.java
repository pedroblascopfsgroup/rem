package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
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
public class MSVMasivaModificacionLineasDetalleValidator extends MSVExcelValidatorAbstract{
	
	private static final String GASTO_NO_EXISTE = "El gasto no existe";
	private static final String ACTIVO_NO_EXISTE = "El activo no existe";
	private static final String BANKIA_MAS_DE_UNA_LINEA = "La cartera CaixaBank no puede tener más de una línea";
	private static final String ACCION_BORRAR_ID_LINEA_REQUERIDO = "El id de línea es requerido si el tipo de acción es 'Borrar'";
	private static final String ID_LINEA_EXISTE = "El id de línea no existe";
	private static final String SUBTIPO_DIFERENTE_GASTO = "El subtipo es de un tipo diferente del gasto";
	private static final String YA_EXISTE_UN_SUBTIPO_TIPO_IMPOSITIVO_TIPO_IMPUESTO = "Ya existe una línea con el mismo subtipo de gasto, tipo impositivo y tipo impuesto";
	private static final String SUMA_100 = "La suma de participaciones no es el 100%";
	private static final String TIPO_IMPUESTO_NO_EXISTE = "El tipo de impuesto no existe";
	private static final String ELEMENTO_SIN_PARTICIPACION = "El elemento no tiene participación";
	private static final String PARTICIPACION_SIN_ELEMENTO = "La participación no tiene ningún elemento";
	private static final String ELEMENTO_SIN_TIPO = "El elemento no tiene tipo";
	private static final String TIPO_SIN_ELEMENTO = "El tipo no tiene ningún elemento";
	private static final String SUBTIPO_GASTO_NO_EXISTE ="El subtipo de gasto no existe";
	private static final String NO_EXISTE_AGRUPACION = "La agrupación no existe";
	private static final String AGRUPACION_GASTO_DIFERENTE_CARTERA = "La agrupación y el gasto no tienen el mismo propietario";
	private static final String ACTIVO_GASTO_DIFERENTE_CARTERA = "El activo o activo genérico y el gasto no tienen el mismo propietario";
	private static final String VALORES_SI_NO_EXENTA = "El campo operación exenta debe tener valor Si/No o estar vacío";
	private static final String VALORES_SI_NO_RENUNCIA = "Este campo renuncia exenta debe tener valor Si/No o estar vacío";
	private static final String VALORES_SI_NO_CRITERIO_CAJA = "El campo criterio caja debe tener valor Si/No o estar vacío";
	private static final String VALORES_CAMPO_ACCION = "El valor del campo de acción debe ser 'A', 'B', 'Añadir' o 'Borrar'";
	private static final String TIPO_ELEMENTO_NO_EXISTE = "El tipo de elemento no existe";
	private static final String GASTO_REFACTURADO_PADRE = "No se puede modificar un gasto padre";
	private static final String GASTOS_HIJOS = "No se puede modificar un gasto refacturado";
	private static final String GASTO_EN_MAL_ESTADO = "El estado del gasto debe ser 'Pendiente de autorizar' o 'Incompleto' o 'Rechazado";
	private static final String TIPO_IMPOS_IMPUEST_RELLENO = "Cuando el tipo impositivo está relleno el tipo impuesto debe estarlo, y viceversa.";
	private static final String SIN_ACTIVOS_NO_VALIDO_CARTERA = "Cuando el propietario es de la cartera: Sareb, Tango o Giants no se puede marcar como línea sin activos.";

	private static final String LINEA_SIN_ACTIVOS_CON_ACTIVOS = "Esta línea ha sido marcada sin activos y se le han añadido activos.";
	private static final String LINEA_SIN_ACTIVOS_REPETIDA = "Esta línea ya ha sido marcada como sin activos.";
	private static final String LINEA_SIN_ACTIVOS_CON_ID_PARTICIPACION = "Una línea marcada sin activos no puede tener ni Id elemento ni participación de elemento.";
	
	private static final String COLUMNA_TEXTO_PRIN_SUJETO ="Se ha cambiado la celda de Principal Sujeto a Impuesto a tipo texto";
	private static final String COLUMNA_TEXTO_PRIN_NO_SUJETO ="Se ha cambiado la celda de Principal No Sujeto a Impuesto a tipo texto";
	private static final String COLUMNA_TEXTO_IMPORTE_RECARGO ="Se ha cambiado la celda de Importe Recargo a tipo texto";
	private static final String COLUMNA_TEXTO_INTERES_DEMORA ="Se ha cambiado la celda de Interes de Demora a tipo texto";
	private static final String COLUMNA_TEXTO_COSTES ="Se ha cambiado la celda de Costes a tipo texto";
	private static final String COLUMNA_TEXTO_OTROS_INCREMENTOS ="Se ha cambiado la celda de Otros Incrementos a tipo texto";
	private static final String COLUMNA_TEXTO_PROVISIONES_Y_SUPLIDOS ="Se ha cambiado la celda de Provisiones y Suplidos a tipo texto";
	private static final String COLUMNA_TEXTO_TIPO_IMPOSITIVO ="Se ha cambiado la celda de Tipo Impositivo a tipo texto";
	private static final String COLUMNA_TEXTO_PRT_LINEA_DETALLE ="Se ha cambiado la celda de Participción en la linea de detalle a tipo texto";
	
	private static final String LINEA_BORRAR_REPETIDA ="Esta línea ya se ha marcado para borrar";
	private static final String LINEA_NO_EXISTE_EN_GASTO ="Esta línea no existe en el gasto";

	private static final String SUPLIDO_NO_MODIFICABLE = "El gasto es suplido. No se puede modificar";
	
	private static final String ACTIVO_REPETIDO_BANKIA = "El activo ya ha sido introducido en la línea de detalle";

	
	public static final Integer COL_ID_GASTO = 0;
	public static final Integer COL_ACCION_LINEA_DETALLE = 1;
	public static final Integer COL_ID_LINEA = 2;
	public static final Integer COL_SUBTIPO_GASTO = 3;
	public static final Integer COL_SUJETO_IMPUESTO = 4;
	public static final Integer COL_NO_SUJETO_IMPUESTO = 5;
	public static final Integer COL_TIPO_RECARGO = 6;
	public static final Integer COL_IMPORTE_RECARGO = 7;
	public static final Integer COL_INTERES_DEMORA= 8;
	public static final Integer COL_COSTES = 9;
	public static final Integer COL_OTROS_INCREMENTOS = 10;
	public static final Integer COL_PROVISIONES_SUPLIDOS = 11;
	public static final Integer COL_TIPO_IMPUESTO = 12;
	public static final Integer COL_OPERANCION_EXENTA = 13;
	public static final Integer COL_RENUNCIA_EXENCION = 14;
	public static final Integer COL_TIPO_IMPOSITIVO = 15;
	public static final Integer COL_CRITERIO_CAJA_IVA = 16;
	public static final Integer COL_ID_ELEMENTO = 17;
	public static final Integer COL_TIPO_ELEMENTO= 18;
	public static final Integer COL_PARTICIPACION_LINEA_DETALLE = 19;
	

	public static final String CHECK_VALOR_SI = "SI";
	public static final String VALOR_ACTIVO = "ACT";
	public static final String VALOR_AGRUPACION = "AGR";
	public static final String ACTIVO_GENERICO = "GEN";
	private static final String[] listaValidos = { "S", "N", "SI", "NO" };
	private static final String[] listaCampoAccion = { "AÑADIR", "BORRAR", "A", "B" };
	private static final String[] listaCampoAccionBorrar = { "BORRAR", "B", "Borrar", "b", "borrar" };
	private static final String[] listaCampoAccionAnyadir = { "A", "AÑADIR", "Añadir", "a", "añadir" };
	private static final String TIPO_ELEMENTO_SIN_ELEMENTO = "SIN";
	
	private static final String COD_SAREB = "02";
	private static final String COD_TANGO = "10";
	private static final String COD_GIANTS = "12";
	private static final String COD_LBK = "08";
	
	
	private Integer numFilasHoja;	

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
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {

			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(GASTO_NO_EXISTE, isGastoNotExistsRows(exc));
			mapaErrores.put(ACTIVO_NO_EXISTE, isExisteActivo(exc));
			mapaErrores.put(BANKIA_MAS_DE_UNA_LINEA, bankiaMasDeUnaLinea(exc));
			mapaErrores.put(ACCION_BORRAR_ID_LINEA_REQUERIDO, isAccionBorradoConIdLineaInformado(exc));
			mapaErrores.put(ID_LINEA_EXISTE, existIdLinea(exc));
			mapaErrores.put(SUBTIPO_GASTO_NO_EXISTE, subtipoGastoNoExiste(exc));
			mapaErrores.put(SUBTIPO_DIFERENTE_GASTO, subtipoGastoCorrespondeGasto(exc));
			mapaErrores.put(YA_EXISTE_UN_SUBTIPO_TIPO_IMPOSITIVO_TIPO_IMPUESTO, existeUnsubtipoGastoIgual(exc));
			mapaErrores.put(SUMA_100, participaciones(exc));
			mapaErrores.put(TIPO_IMPUESTO_NO_EXISTE, tipoImpuestoNoExiste(exc));
			mapaErrores.put(PARTICIPACION_SIN_ELEMENTO, participacionSinActivos(exc));
			mapaErrores.put(ELEMENTO_SIN_PARTICIPACION, activoSinParticipacion(exc));
			mapaErrores.put(ELEMENTO_SIN_TIPO, elementosSinTipo(exc));
			mapaErrores.put(TIPO_SIN_ELEMENTO, tipoSinElementos(exc));
			mapaErrores.put(NO_EXISTE_AGRUPACION, agrupacionNoExiste(exc));
			mapaErrores.put(AGRUPACION_GASTO_DIFERENTE_CARTERA, agrupacionGastoMismaCartera(exc));
			mapaErrores.put(ACTIVO_GASTO_DIFERENTE_CARTERA, activoGastoMismaCartera(exc));	
			mapaErrores.put(VALORES_SI_NO_EXENTA, valoresSiNoExenta(exc));
			mapaErrores.put(VALORES_SI_NO_RENUNCIA, valoresSiNoRenuncia(exc));
			mapaErrores.put(VALORES_SI_NO_CRITERIO_CAJA, valoresSiNoCriterioCaja(exc));
			mapaErrores.put(VALORES_CAMPO_ACCION, valoresCampoDeAccion(exc));
			mapaErrores.put(TIPO_ELEMENTO_NO_EXISTE, tipoElementoNoExiste(exc));	
			mapaErrores.put(GASTO_REFACTURADO_PADRE, gastoPadreNoEditable(exc));
			mapaErrores.put(GASTOS_HIJOS, gastoHijoNoEditable(exc));
			mapaErrores.put(GASTO_EN_MAL_ESTADO, gastoEstadoPendienteIncompleto(exc));
			mapaErrores.put(TIPO_IMPOS_IMPUEST_RELLENO, tipoImpositivoEimpuestoRellenos(exc));
			mapaErrores.put(SIN_ACTIVOS_NO_VALIDO_CARTERA, sinActivosNoValidoCartera(exc));
			mapaErrores.put(LINEA_SIN_ACTIVOS_CON_ACTIVOS, masUnaLineaSinActivos(exc));
			mapaErrores.put(LINEA_SIN_ACTIVOS_REPETIDA, lineaYaMarcadaSinActivos(exc));
			mapaErrores.put(LINEA_SIN_ACTIVOS_CON_ID_PARTICIPACION, lineaSinActivosElementoyPorcentajeVacio(exc));
			mapaErrores.put(COLUMNA_TEXTO_PRIN_SUJETO,comprobarDouble(exc,COL_SUJETO_IMPUESTO));
			mapaErrores.put(COLUMNA_TEXTO_PRIN_NO_SUJETO,comprobarDouble(exc,COL_NO_SUJETO_IMPUESTO));
			mapaErrores.put(COLUMNA_TEXTO_IMPORTE_RECARGO,comprobarDouble(exc,COL_IMPORTE_RECARGO));
			mapaErrores.put(COLUMNA_TEXTO_INTERES_DEMORA,comprobarDouble(exc,COL_INTERES_DEMORA));
			mapaErrores.put(COLUMNA_TEXTO_COSTES,comprobarDouble(exc,COL_COSTES));
			mapaErrores.put(COLUMNA_TEXTO_OTROS_INCREMENTOS,comprobarDouble(exc,COL_OTROS_INCREMENTOS));
			mapaErrores.put(COLUMNA_TEXTO_PROVISIONES_Y_SUPLIDOS,comprobarDouble(exc,COL_PROVISIONES_SUPLIDOS));
			mapaErrores.put(COLUMNA_TEXTO_TIPO_IMPOSITIVO,comprobarDouble(exc,COL_TIPO_IMPOSITIVO));
			mapaErrores.put(COLUMNA_TEXTO_PRT_LINEA_DETALLE,comprobarDouble(exc,COL_PARTICIPACION_LINEA_DETALLE));
			mapaErrores.put(LINEA_BORRAR_REPETIDA,borrarExisteLinea(exc));
			mapaErrores.put(LINEA_NO_EXISTE_EN_GASTO,lineaNoExisteEnGasto(exc));
			mapaErrores.put(SUPLIDO_NO_MODIFICABLE,suplidoNoModificable(exc));
			mapaErrores.put(ACTIVO_REPETIDO_BANKIA, activoRepetidoBankia(exc));




			
			
			if (!mapaErrores.get(GASTO_NO_EXISTE).isEmpty() 
					|| !mapaErrores.get(ACTIVO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(BANKIA_MAS_DE_UNA_LINEA).isEmpty()
					|| !mapaErrores.get(SUBTIPO_DIFERENTE_GASTO).isEmpty()
					|| !mapaErrores.get(YA_EXISTE_UN_SUBTIPO_TIPO_IMPOSITIVO_TIPO_IMPUESTO).isEmpty()
					|| !mapaErrores.get(SUMA_100).isEmpty()
					|| !mapaErrores.get(TIPO_IMPUESTO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(ELEMENTO_SIN_PARTICIPACION).isEmpty()
					|| !mapaErrores.get(PARTICIPACION_SIN_ELEMENTO).isEmpty()
					|| !mapaErrores.get(ELEMENTO_SIN_TIPO).isEmpty()
					|| !mapaErrores.get(TIPO_SIN_ELEMENTO).isEmpty()
					|| !mapaErrores.get(SUBTIPO_GASTO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(NO_EXISTE_AGRUPACION).isEmpty()
					|| !mapaErrores.get(AGRUPACION_GASTO_DIFERENTE_CARTERA).isEmpty()
					|| !mapaErrores.get(ACTIVO_GASTO_DIFERENTE_CARTERA).isEmpty()
					|| !mapaErrores.get(VALORES_SI_NO_EXENTA).isEmpty()
					|| !mapaErrores.get(VALORES_SI_NO_RENUNCIA).isEmpty()
					|| !mapaErrores.get(VALORES_SI_NO_CRITERIO_CAJA).isEmpty()
					|| !mapaErrores.get(VALORES_CAMPO_ACCION).isEmpty()
					|| !mapaErrores.get(TIPO_ELEMENTO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(GASTO_REFACTURADO_PADRE).isEmpty()
					|| !mapaErrores.get(GASTOS_HIJOS).isEmpty()
					|| !mapaErrores.get(GASTO_EN_MAL_ESTADO).isEmpty()
					|| !mapaErrores.get(TIPO_IMPOS_IMPUEST_RELLENO).isEmpty()
					|| !mapaErrores.get(SIN_ACTIVOS_NO_VALIDO_CARTERA).isEmpty()
					|| !mapaErrores.get(LINEA_SIN_ACTIVOS_CON_ACTIVOS).isEmpty()
					|| !mapaErrores.get(LINEA_SIN_ACTIVOS_REPETIDA).isEmpty()
					|| !mapaErrores.get(LINEA_SIN_ACTIVOS_CON_ID_PARTICIPACION).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_PRIN_SUJETO).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_PRIN_NO_SUJETO).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_IMPORTE_RECARGO).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_INTERES_DEMORA).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_COSTES).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_OTROS_INCREMENTOS).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_PROVISIONES_Y_SUPLIDOS).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_TIPO_IMPOSITIVO).isEmpty()
					|| !mapaErrores.get(COLUMNA_TEXTO_PRT_LINEA_DETALLE).isEmpty()
					|| !mapaErrores.get(LINEA_BORRAR_REPETIDA).isEmpty()
					|| !mapaErrores.get(LINEA_NO_EXISTE_EN_GASTO).isEmpty()
					|| !mapaErrores.get(SUPLIDO_NO_MODIFICABLE).isEmpty()
					|| !mapaErrores.get(ACTIVO_REPETIDO_BANKIA).isEmpty()

					
				){

		    
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

		if ((contentValidators != null) && (contentValidators.getValidatorForColumn(nombreColumna.trim()) != null)) {
			MSVColumnValidator v = contentValidators.getValidatorForColumn(nombreColumna.trim());
			MSVValidationResult result = validationRunner.runValidation(v, contenidoCelda);
			resultado.setValido(result.isValid());
			resultado.setErroresFila(result.getErrorMessage());
		}
		return resultado;
	}


	/**
	 * Realiza validaciones multivalor con diferentes valores de la fila
	 * 
	 * @param mapaDatos
	 * @param compositeValidators
	 * @return
	 */
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
	
	
	   private List<Integer> isGastoNotExistsRows(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) 
	                            && Boolean.FALSE.equals(particularValidator.existeGasto(exc.dameCelda(i, COL_ID_GASTO))))
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
	   
	   private List<Integer> isExisteActivo(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                    	if(!Checks.esNulo(exc.dameCelda(i,COL_TIPO_ELEMENTO)) && VALOR_ACTIVO.equalsIgnoreCase(exc.dameCelda(i,COL_TIPO_ELEMENTO)) 
                    			&& !Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)) && Boolean.FALSE.equals(particularValidator.existeActivo(exc.dameCelda(i, COL_ID_ELEMENTO)))) {
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
	   
	   private List<Integer> bankiaMasDeUnaLinea(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();
	   	   Float participacionTotal = 0f;
	   	   String participacionLinea = null;
	   	   String idLineaActual = null;
	   	   String idLineaAnterior = null;
	   	   boolean lineaBorrada = false; 
	   	   
            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                    	boolean tieneBorrar = false;
                        if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) && Boolean.TRUE.equals(particularValidator.perteneceGastoBankia(exc.dameCelda(i, COL_ID_GASTO)))
                        		&& Boolean.TRUE.equals(particularValidator.gastoTieneLineaDetalle(exc.dameCelda(i, COL_ID_GASTO)))) {
                        	if (!Checks.esNulo(exc.dameCelda(i, COL_ID_LINEA))) {
    	                		idLineaActual = exc.dameCelda(i, COL_ID_LINEA);
    	                		
    	                		if (!Checks.esNulo(idLineaAnterior) && !idLineaActual.equals(idLineaAnterior)) {
        	                		lineaBorrada = false;
        		                	
        		                	if (participacionTotal != 0) {
        		                		participacionTotal = 0f;
        		                	}
    	                		}
    	                	}
    	                	
    	                	if (Arrays.asList(listaCampoAccionBorrar).contains(exc.dameCelda(i, COL_ACCION_LINEA_DETALLE))) {
    	      
    	                		if (!Checks.esNulo(exc.dameCelda(i, COL_ID_LINEA))) {
    	                			idLineaAnterior = exc.dameCelda(i, COL_ID_LINEA);
    	                		}
    	                		
    	                		participacionLinea = exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE);
    	                		participacionTotal += Float.parseFloat(participacionLinea);
    	                		
    	                		if (participacionTotal == 100f) {
    	                			lineaBorrada = true;
    	                		}
    	                	} else if (Arrays.asList(listaCampoAccionAnyadir).contains(exc.dameCelda(i, COL_ACCION_LINEA_DETALLE)) && !lineaBorrada) {   	               
                        			listaFilas.add(i);
    	                		}
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
	   
	   private List<Integer> subtipoGastoCorrespondeGasto(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) && !Checks.esNulo(exc.dameCelda(i, COL_SUBTIPO_GASTO))
	                            && Boolean.FALSE.equals(particularValidator.subtipoGastoCorrespondeGasto(exc.dameCelda(i, COL_ID_GASTO),exc.dameCelda(i,COL_SUBTIPO_GASTO))))
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
	   
	   private List<Integer> existeUnsubtipoGastoIgual(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();
	   	   List<String> cadenaInformacion =  new ArrayList <String>();
	   	   Float participacionTotal = 0f;
	   	   String participacionLinea = null;
	   	   String idLineaActual = null;
	   	   String idLineaAnterior = null;
	   	   boolean lineaBorrada = false; 
	       
	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	            	
	                try {          
	                	if (!Checks.esNulo(exc.dameCelda(i, COL_ID_LINEA))) {
	                		idLineaActual = exc.dameCelda(i, COL_ID_LINEA);
	                		
	                		if (!Checks.esNulo(idLineaAnterior) && !idLineaActual.equals(idLineaAnterior)) {
    	                		lineaBorrada = false;
    		                	
    		                	if (participacionTotal != 0) {
    		                		participacionTotal = 0f;
    		                	}
	                		}
	                	}
	                	
	                	if (Arrays.asList(listaCampoAccionBorrar).contains(exc.dameCelda(i, COL_ACCION_LINEA_DETALLE))) {
	      
	                		if (!Checks.esNulo(exc.dameCelda(i, COL_ID_LINEA))) {
	                			idLineaAnterior = exc.dameCelda(i, COL_ID_LINEA);
	                		}
	                		
	                		participacionLinea = exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE);
	                		participacionTotal += Float.parseFloat(participacionLinea);
	                		
	                		if (participacionTotal == 100f) {
	                			lineaBorrada = true;
	                		}
	                		
	                	} else if (!Arrays.asList(listaCampoAccionBorrar).contains(exc.dameCelda(i, COL_ACCION_LINEA_DETALLE)) && !lineaBorrada) {
		                	String result = devolverCadenaInformacionCompleta
		                			(exc.dameCelda(i, COL_ACCION_LINEA_DETALLE), exc.dameCelda(i, COL_SUBTIPO_GASTO)
		                					,exc.dameCelda(i, COL_TIPO_IMPOSITIVO),exc.dameCelda(i, COL_TIPO_IMPUESTO)
		                					,exc.dameCelda(i, COL_ID_GASTO),exc.dameCelda(i, COL_TIPO_ELEMENTO),exc.dameCelda(i, COL_ID_ELEMENTO));
	
		                	String[] gastoSubtipoImpuestoActual = result.split(",");
		                	boolean existenBorradosAnteriores = false;
		                	boolean existeMatchAnterior = false;
		                	boolean filaErrorAnyadida = false;																	                      	
			                if(!Checks.estaVacio(cadenaInformacion)) {
		                		for (String cadena : cadenaInformacion) {
		                			String[] gastoSubtipoImpuesto = cadena.split(",");
		                			if(gastoSubtipoImpuesto[1].equalsIgnoreCase(gastoSubtipoImpuestoActual[1])) {
		                				
		                				if(gastoSubtipoImpuesto[0].equalsIgnoreCase(gastoSubtipoImpuestoActual[0]) 
		                					&& gastoSubtipoImpuesto.length > 2 && gastoSubtipoImpuestoActual.length > 2
		                					&& gastoSubtipoImpuesto[2].equalsIgnoreCase(gastoSubtipoImpuestoActual[2])) {
		                						listaFilas.add(i);
		                						filaErrorAnyadida = true;
		                						existeMatchAnterior = true;
		                						break;
		                				}else if(!Checks.esNulo(gastoSubtipoImpuesto[0]) && Arrays.asList(listaCampoAccionBorrar).contains(gastoSubtipoImpuesto[0].toUpperCase())) {
		                					existenBorradosAnteriores = true;
		                				}
		                			}
								}
			                }
			                cadenaInformacion.add(result);
			                if(!filaErrorAnyadida) {
				                if(existeMatchAnterior &&  !existenBorradosAnteriores) {
				                	listaFilas.add(i);
				                }else {
				                	if(Arrays.asList(listaCampoAccionAnyadir).contains(gastoSubtipoImpuestoActual[0].toUpperCase()) && !existenBorradosAnteriores) {
				                		if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) && !Checks.esNulo(exc.dameCelda(i, COL_SUBTIPO_GASTO))
				  			                   && Boolean.TRUE.equals(particularValidator.lineaSubtipoDeGastoRepetida(exc.dameCelda(i, COL_ID_GASTO), exc.dameCelda(i, COL_SUBTIPO_GASTO),exc.dameCelda(i, COL_TIPO_IMPOSITIVO),exc.dameCelda(i, COL_TIPO_IMPUESTO)))){
				                 			listaFilas.add(i);
				                 		}	       
				                	}
				                }
			                }
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
	   
	   public String devolverCadenaInformacionCompleta(String accion, String subtipoGasto, String tipoImpositivo, String tipoImpuesto, String gasto, String tipoElemento, String activo){ 
		   String cadena = accion + ",";
		   String activoTipo=",vacio";
		   
		   String subtipoGastoImpuestImpositivo = gastoSubtipoImpuestoImpositivo(subtipoGasto, tipoImpositivo, tipoImpuesto, gasto);
		   
		   if(TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento)) {
			   activo = "vacio";
		   }
		   if(!Checks.esNulo(tipoElemento) && !Checks.esNulo(activo)) {
			   activoTipo = "," + tipoElemento + "-" + activo;
		   }
		   
		   cadena = cadena + subtipoGastoImpuestImpositivo + activoTipo;
		   return cadena;
	   }
	   
	   private String gastoSubtipoImpuestoImpositivo(String subtipoGasto, String tipoImpositivo, String tipoImpuesto, String gasto) {
		   String subtipoGastoImpuestImpositivo = gasto + "-" + subtipoGasto;
		   
		   if(!Checks.esNulo(tipoImpuesto) && !Checks.esNulo(tipoImpositivo)) {
			   subtipoGastoImpuestImpositivo = subtipoGastoImpuestImpositivo + "-" +tipoImpuesto;
			   subtipoGastoImpuestImpositivo = subtipoGastoImpuestImpositivo + "-" + tipoImpositivo;
		   }
		   
		   return subtipoGastoImpuestImpositivo;
	   }
	   private List<Integer> participaciones(MSVHojaExcel exc){
		   List<Integer> listaFilas = new ArrayList<Integer>();
		   List<String> cadenaInformacionParticipacion =  new ArrayList <String>();
		   List<String> cadenaSinActivos =  new ArrayList <String>();
	        try{
	        	for(int i=1; i<this.numFilasHoja;i++){
	        		if(Arrays.asList(listaCampoAccionAnyadir).contains(exc.dameCelda(i, COL_ACCION_LINEA_DETALLE).toUpperCase())) {
						String participacion =  gastoSubtipoImpuestoImpositivo(exc.dameCelda(i, COL_SUBTIPO_GASTO), exc.dameCelda(i, COL_TIPO_IMPOSITIVO), exc.dameCelda(i, COL_TIPO_IMPUESTO), exc.dameCelda(i, COL_ID_GASTO));
						if(TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(exc.dameCelda(i, COL_TIPO_ELEMENTO))) {
							cadenaSinActivos.add(participacion);
						}else if( !Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)) && !Checks.esNulo(exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE))){
							participacion = participacion + "," + exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE);
							cadenaInformacionParticipacion.add(participacion);	
						}
	        		}
	        	}
	            for(int i=1; i<this.numFilasHoja;i++){
	            	if(!Checks.esNulo(exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE)) && !Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)) && Arrays.asList(listaCampoAccionAnyadir).contains(exc.dameCelda(i, COL_ACCION_LINEA_DETALLE).toUpperCase())) {
		            	String result =  gastoSubtipoImpuestoImpositivo(exc.dameCelda(i, COL_SUBTIPO_GASTO), exc.dameCelda(i, COL_TIPO_IMPOSITIVO), exc.dameCelda(i, COL_TIPO_IMPUESTO), exc.dameCelda(i, COL_ID_GASTO));
			            if(!cadenaSinActivos.contains(result)) {	
		            		result = result + "," + exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE);
			            	String[] participacionSeparadoActual = result.split(",");
			            	Double participacionLinea = 0.0;
			            	if(!Checks.estaVacio(cadenaInformacionParticipacion)) {
			            		for (String participacion : cadenaInformacionParticipacion) {
			            			String[] participacionSeparado = participacion.split(",");
			            			if(participacionSeparado[0].equalsIgnoreCase(participacionSeparadoActual[0])) {
			            				participacionLinea += Double.parseDouble(participacionSeparado[1]);
			            			}
								}
			            		BigDecimal porcentajeLinea = new BigDecimal(participacionLinea);
								porcentajeLinea = porcentajeLinea.setScale(2, BigDecimal.ROUND_HALF_UP);
								if(porcentajeLinea.compareTo(new BigDecimal(100.0)) != 0) {
									 listaFilas.add(i);
								}
			            	}else {
			            		listaFilas.add(i);
			            	}
			            }
	            	}
	            }
        	}
            catch (ParseException e) {
            	 listaFilas.add(0);
				e.printStackTrace();
            } catch (IllegalArgumentException e) {
                listaFilas.add(0);
                e.printStackTrace();
            } catch (IOException e) {
                listaFilas.add(0);
                e.printStackTrace();
            }
	        return listaFilas;   
	   }
	   
	   private List<Integer> tipoImpuestoNoExiste(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_TIPO_IMPUESTO)) 
	                            && Boolean.FALSE.equals(particularValidator.existeTipoimpuesto(exc.dameCelda(i, COL_TIPO_IMPUESTO))))
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
	   
	   private List<Integer> participacionSinActivos(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE)) && Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)))
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
	   
	   private List<Integer> activoSinParticipacion(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                	String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
	                    if(Checks.esNulo(exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE)) && !Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)))
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
	  
	   private List<Integer> tipoSinElementos(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                	String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
	                    if(!Checks.esNulo(tipoElemento)&& !TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento) 
	                    		&& Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)))
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
	   
	   private List<Integer> elementosSinTipo(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(Checks.esNulo(exc.dameCelda(i, COL_TIPO_ELEMENTO)) && !Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)))
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
	   
	   private List<Integer> subtipoGastoNoExiste(MSVHojaExcel exc){
		   List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_SUBTIPO_GASTO)) && Boolean.FALSE.equals(particularValidator.existeSubtipoGasto(exc.dameCelda(i, COL_SUBTIPO_GASTO)))) 
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
	   
	   private List<Integer> agrupacionNoExiste(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                    	if(!Checks.esNulo(exc.dameCelda(i,COL_TIPO_ELEMENTO)) && VALOR_AGRUPACION.equalsIgnoreCase(exc.dameCelda(i,COL_TIPO_ELEMENTO))
                    		&& !Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)) && Boolean.FALSE.equals(particularValidator.existeAgrupacion(exc.dameCelda(i, COL_ID_ELEMENTO)))) {
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
	   

	   private List<Integer> agrupacionGastoMismaCartera(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                    	if(!Checks.esNulo(exc.dameCelda(i,COL_TIPO_ELEMENTO)) && VALOR_AGRUPACION.equalsIgnoreCase(exc.dameCelda(i,COL_TIPO_ELEMENTO))
                    		&& !Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)) &&  Boolean.FALSE.equals(particularValidator.agrupacionSinActivos(exc.dameCelda(i, COL_ID_ELEMENTO)))) {
                			if(Boolean.FALSE.equals(particularValidator.esGastoYAgrupacionMismoPropietarioByNumGasto(exc.dameCelda(i, COL_ID_ELEMENTO), exc.dameCelda(i, COL_ID_GASTO)))){
                				listaFilas.add(i);
                			}	
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
	   
	   private List<Integer> activoGastoMismaCartera(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                    	if(!Checks.esNulo(exc.dameCelda(i,COL_TIPO_ELEMENTO)) 
                    		&& (VALOR_ACTIVO.equalsIgnoreCase(exc.dameCelda(i,COL_TIPO_ELEMENTO)) || ACTIVO_GENERICO.equalsIgnoreCase(exc.dameCelda(i,COL_TIPO_ELEMENTO)))
                    		&& !Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO))) {
                			if(Boolean.FALSE.equals(particularValidator.esGastoYActivoMismoPropietarioByNumGasto(exc.dameCelda(i, COL_ID_ELEMENTO), exc.dameCelda(i, COL_ID_GASTO), exc.dameCelda(i, COL_TIPO_ELEMENTO)))){
                				listaFilas.add(i);
                			}	
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
	   
	   private List<Integer> valoresSiNoExenta(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                    	if(!Checks.esNulo(exc.dameCelda(i,COL_OPERANCION_EXENTA)) 
                    		&& !Arrays.asList(listaValidos).contains(exc.dameCelda(i, COL_OPERANCION_EXENTA).toUpperCase())) {
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
	   
	   private List<Integer> valoresSiNoRenuncia(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                    	if(!Checks.esNulo(exc.dameCelda(i,COL_RENUNCIA_EXENCION)) 
                    		&& !Arrays.asList(listaValidos).contains(exc.dameCelda(i, COL_RENUNCIA_EXENCION).toUpperCase())) {
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
	   
	   private List<Integer> valoresSiNoCriterioCaja(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                    	if(!Checks.esNulo(exc.dameCelda(i,COL_CRITERIO_CAJA_IVA)) 
                    		&& !Arrays.asList(listaValidos).contains(exc.dameCelda(i, COL_CRITERIO_CAJA_IVA).toUpperCase())) {
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
	   
	   private List<Integer> valoresCampoDeAccion(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                    	if(!Checks.esNulo(exc.dameCelda(i,COL_ACCION_LINEA_DETALLE)) 
                    		&& !Arrays.asList(listaCampoAccion).contains(exc.dameCelda(i, COL_ACCION_LINEA_DETALLE).toUpperCase())) {
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
	   
	   private List<Integer> tipoElementoNoExiste(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_ID_ELEMENTO)) && !Checks.esNulo(exc.dameCelda(i, COL_TIPO_ELEMENTO)) 
	                    		&& Boolean.FALSE.equals(particularValidator.existeEntidadGasto(exc.dameCelda(i, COL_TIPO_ELEMENTO).toUpperCase())))
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
	   
	   private List<Integer> gastoPadreNoEditable(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) 
	                    		&& Boolean.TRUE.equals(particularValidator.esGastoRefacturadoPadre(exc.dameCelda(i, COL_ID_GASTO))))
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
	   
	   private List<Integer> gastoHijoNoEditable(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) 
	                    		&& Boolean.TRUE.equals(particularValidator.esGastoRefacturadoHijo(exc.dameCelda(i, COL_ID_GASTO))))
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

	private List<Integer> isAccionBorradoConIdLineaInformado(MSVHojaExcel exc) {
		 List<Integer> listaFilas = new ArrayList<Integer>();
        try{
            for(int i=1; i<this.numFilasHoja;i++){
            	String tipoAccion = exc.dameCelda(i, COL_ACCION_LINEA_DETALLE);
            	if (tipoAccion != null && Arrays.asList(listaCampoAccionBorrar).contains(tipoAccion)) {
            		boolean informado = Boolean.TRUE.equals(exc.dameCelda(i, COL_ID_LINEA) != null);
            		if (!informado) {
            			listaFilas.add(i);
            		}
            	}
            }
            } catch (Exception e) {
                listaFilas.add(0);
                e.printStackTrace();
            }
        return listaFilas;   
   }
	

	private List<Integer> existIdLinea(MSVHojaExcel exc) {
		 List<Integer> listaFilas = new ArrayList<Integer>();
	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	            	String idLinea = exc.dameCelda(i, COL_ID_LINEA);
	            	if (idLinea != null && !idLinea.isEmpty()) {
	            		boolean existe = Boolean.TRUE.equals(particularValidator.existeGastoConElIdLinea(exc.dameCelda(i, COL_ID_GASTO), idLinea));
	            		if (!existe) {
	            			listaFilas.add(i);
	            		}
	            	}
	            }
	            } catch (Exception e) {
	                listaFilas.add(0);
	                e.printStackTrace();
	            }
	        return listaFilas;   
	}


	   
	   private List<Integer> gastoEstadoPendienteIncompleto(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) 
	                    		&& Boolean.FALSE.equals(particularValidator.gastoEstadoIncompletoPendienteAutorizado(exc.dameCelda(i, COL_ID_GASTO))))
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
	   
	   private List<Integer> tipoImpositivoEimpuestoRellenos(MSVHojaExcel exc){
	        List<Integer> listaFilas = new ArrayList<Integer>();

	         try{
	        	 for(int i=1; i<this.numFilasHoja;i++){
	               if((!Checks.esNulo( exc.dameCelda(i, COL_TIPO_IMPOSITIVO)) && Checks.esNulo( exc.dameCelda(i, COL_TIPO_IMPUESTO))) ||
	                (Checks.esNulo( exc.dameCelda(i, COL_TIPO_IMPOSITIVO)) && !Checks.esNulo( exc.dameCelda(i, COL_TIPO_IMPUESTO)))) {
	            	   listaFilas.add(i);
	               }
	        	 }
	        	
	         } catch (IllegalArgumentException e) {
	             listaFilas.add(0);
	             e.printStackTrace();
	         } catch (IOException e) {
	             listaFilas.add(0);
	             e.printStackTrace();
	         } catch (ParseException e) {
	        	 listaFilas.add(0);
				e.printStackTrace();
			}
	         return listaFilas;   
		 }
	   
	   private List<Integer> sinActivosNoValidoCartera(MSVHojaExcel exc){
	        List<Integer> listaFilas = new ArrayList<Integer>();

	         try{
	        	 for(int i=1; i<this.numFilasHoja;i++){
	        		 String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
	        		 String docIdent = particularValidator.getDocIdentfPropietarioByNumGasto(exc.dameCelda(i, COL_ID_GASTO));
	         		 if(!Checks.esNulo(tipoElemento) && TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento)) {
	         			 List<String> listaCarteras = Arrays.asList(COD_SAREB, COD_GIANTS, COD_TANGO);
	         			 if(Boolean.TRUE.equals(particularValidator.propietarioPerteneceCartera(docIdent, listaCarteras))) {
	         				 listaFilas.add(i);
	         			 }
	         			 
	         		 }
	        	 }
	        	
	         } catch (IllegalArgumentException e) {
	             listaFilas.add(0);
	             e.printStackTrace();
	         } catch (IOException e) {
	             listaFilas.add(0);
	             e.printStackTrace();
	         } catch (ParseException e) {
	        	 listaFilas.add(0);
				e.printStackTrace();
			}
	         return listaFilas;   
		 }
	   
	   private List<Integer> masUnaLineaSinActivos(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
        	 List<String> listaCadenasSIN = new ArrayList<String>();
        	 for(int i=1; i<this.numFilasHoja;i++){
                String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
        		if(!Checks.esNulo(tipoElemento) && TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento)) {
					String cadenaSin =  gastoSubtipoImpuestoImpositivo(exc.dameCelda(i, COL_SUBTIPO_GASTO), exc.dameCelda(i, COL_TIPO_IMPOSITIVO), exc.dameCelda(i, COL_TIPO_IMPUESTO), exc.dameCelda(i, COL_ID_GASTO));
        			listaCadenasSIN.add(cadenaSin);
        		}
        	 }
        	 
        	 for(int i=1; i<this.numFilasHoja;i++){
	                String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
	                String gastoLinea =  gastoSubtipoImpuestoImpositivo(exc.dameCelda(i, COL_SUBTIPO_GASTO), exc.dameCelda(i, COL_TIPO_IMPOSITIVO), exc.dameCelda(i, COL_TIPO_IMPUESTO), exc.dameCelda(i, COL_ID_GASTO));
	        		if(listaCadenasSIN.contains(gastoLinea) && !Checks.esNulo(tipoElemento) && !TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento)) {
	        			listaFilas.add(i);
	        		}
	        	 }

         } catch (IllegalArgumentException e) {
             listaFilas.add(0);
             e.printStackTrace();
         } catch (IOException e) {
             listaFilas.add(0);
             e.printStackTrace();
         } catch (ParseException e) {
        	 listaFilas.add(0);
			e.printStackTrace();
		}
         return listaFilas;   
	 }
	   
	   
   private List<Integer> lineaYaMarcadaSinActivos(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
        	 List<String> listaCadenasSIN = new ArrayList<String>();
        	 for(int i=1; i<this.numFilasHoja;i++){
                String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
        		if(!Checks.esNulo(tipoElemento) && TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento)) {
					String cadenaSin =  gastoSubtipoImpuestoImpositivo(exc.dameCelda(i, COL_SUBTIPO_GASTO), exc.dameCelda(i, COL_TIPO_IMPOSITIVO), exc.dameCelda(i, COL_TIPO_IMPUESTO), exc.dameCelda(i, COL_ID_GASTO));
        			if(listaCadenasSIN.contains(cadenaSin)) {
        				listaFilas.add(i);
        			}else {
        				listaCadenasSIN.add(cadenaSin);
        			}	
        		}
        	 }
        	
         } catch (IllegalArgumentException e) {
             listaFilas.add(0);
             e.printStackTrace();
         } catch (IOException e) {
             listaFilas.add(0);
             e.printStackTrace();
         } catch (ParseException e) {
        	 listaFilas.add(0);
			e.printStackTrace();
		}
         return listaFilas;   
	 }
   
   private List<Integer> lineaSinActivosElementoyPorcentajeVacio(MSVHojaExcel exc){
       List<Integer> listaFilas = new ArrayList<Integer>();

        try{
       	 for(int i=1; i<this.numFilasHoja;i++){
               String tipoElemento = exc.dameCelda(i, COL_TIPO_ELEMENTO);
       		if(!Checks.esNulo(tipoElemento) && TIPO_ELEMENTO_SIN_ELEMENTO.equalsIgnoreCase(tipoElemento) &&
       		(!Checks.esNulo( exc.dameCelda(i, COL_ID_ELEMENTO)) || !Checks.esNulo( exc.dameCelda(i, COL_PARTICIPACION_LINEA_DETALLE)))) {
       			listaFilas.add(i);
       		}
       	 }
       	
        } catch (IllegalArgumentException e) {
        	
            listaFilas.add(0);
            e.printStackTrace();
        } catch (IOException e) {
            listaFilas.add(0);
            e.printStackTrace();
        } catch (ParseException e) {
       	 listaFilas.add(0);
			e.printStackTrace();
		}
        return listaFilas;   
	 }
   private List<Integer> comprobarDouble(MSVHojaExcel exc, int columna){
       List<Integer> listaFilas = new ArrayList<Integer>();

        try{
       	 for(int i=1; i<this.numFilasHoja;i++){
               String valorColumna = exc.dameCelda(i, columna);
               if(!Checks.esNulo(valorColumna)) {
            	  try {
            	    Double.parseDouble(valorColumna);
            	  }catch(NumberFormatException e){
            		listaFilas.add(i); 
            	  }
            	  
               }
       	 }
       	
        } catch (IllegalArgumentException e) {
        	
            listaFilas.add(0);
            e.printStackTrace();
        } catch (IOException e) {
            listaFilas.add(0);
            e.printStackTrace();
        } catch (ParseException e) {
       	 listaFilas.add(0);
			e.printStackTrace();
		}
        return listaFilas;   
	 }
   
   private List<Integer> borrarExisteLinea(MSVHojaExcel exc){
       List<Integer> listaFilas = new ArrayList<Integer>();
       List<String> errorRepetidos = new ArrayList<String>();
       
        try{
       	 for(int i=1; i<this.numFilasHoja;i++){
       		String tipoAccion = exc.dameCelda(i, COL_ACCION_LINEA_DETALLE);
       		if(tipoAccion != null && Arrays.asList(listaCampoAccionBorrar).contains(tipoAccion.toUpperCase()) && !Checks.esNulo(exc.dameCelda(i, COL_ID_LINEA))) {
        		if(!errorRepetidos.contains(exc.dameCelda(i, COL_ID_LINEA))) {
        			errorRepetidos.add(exc.dameCelda(i, COL_ID_LINEA));
        		}else {
        			listaFilas.add(i);
        		}
        	}
       	 }
       	
        } catch (IllegalArgumentException e) {
        	
            listaFilas.add(0);
            e.printStackTrace();
        } catch (IOException e) {
            listaFilas.add(0);
            e.printStackTrace();
        } catch (ParseException e) {
       	 listaFilas.add(0);
			e.printStackTrace();
		}
        return listaFilas;   
	 }

   private List<Integer> lineaNoExisteEnGasto(MSVHojaExcel exc){
       List<Integer> listaFilas = new ArrayList<Integer>();
       
        try{
       	 for(int i=1; i<this.numFilasHoja;i++){
       		String tipoAccion = exc.dameCelda(i, COL_ACCION_LINEA_DETALLE);
       		if(tipoAccion != null && Arrays.asList(listaCampoAccionBorrar).contains(tipoAccion.toUpperCase()) && !Checks.esNulo(exc.dameCelda(i, COL_ID_LINEA))
       		&& Boolean.FALSE.equals(particularValidator.existeLineaEnGasto(exc.dameCelda(i, COL_ID_LINEA), exc.dameCelda(i, COL_ID_GASTO)))) {
       			listaFilas.add(i);
        	}
       	 }
       	
        } catch (IllegalArgumentException e) {
        	
            listaFilas.add(0);
            e.printStackTrace();
        } catch (IOException e) {
            listaFilas.add(0);
            e.printStackTrace();
        } catch (ParseException e) {
       	 listaFilas.add(0);
			e.printStackTrace();
		}
        return listaFilas;   
	 }
   

   private List<Integer> suplidoNoModificable(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();
        
        try{
            for(int i=1; i<this.numFilasHoja;i++){
                try {
                    if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) 
                    		&& particularValidator.getGastoSuplidoConFactura(exc.dameCelda(i, COL_ID_GASTO)))
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

   @Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
   
   private List<Integer> activoRepetidoBankia(MSVHojaExcel exc){
       List<Integer> listaFilas = new ArrayList<Integer>();

        try{
            for(int i=1; i<this.numFilasHoja;i++){
                try {
                	boolean addError = false;
                	String tipoAccion = exc.dameCelda(i, COL_ACCION_LINEA_DETALLE);
                    if(!Checks.esNulo(exc.dameCelda(i, COL_ID_GASTO)) && Boolean.TRUE.equals(particularValidator.perteneceGastoBankia(exc.dameCelda(i, COL_ID_GASTO)))) {
                    	if(!Checks.esNulo(tipoAccion) && Arrays.asList(listaCampoAccionAnyadir).contains(tipoAccion.toUpperCase())) {
                        	for(int x = 1; x<i;x++) {
                        		if(exc.dameCelda(x, COL_ID_GASTO).equals(exc.dameCelda(i, COL_ID_GASTO)) && 
                        		Arrays.asList(listaCampoAccionAnyadir).contains(exc.dameCelda(x, COL_ACCION_LINEA_DETALLE).toUpperCase()) &&
                        		exc.dameCelda(x, COL_SUBTIPO_GASTO).equals(exc.dameCelda(i, COL_SUBTIPO_GASTO)) &&
                        		exc.dameCelda(x, COL_TIPO_IMPUESTO).equals(exc.dameCelda(i, COL_TIPO_IMPUESTO)) &&
                        		exc.dameCelda(x, COL_TIPO_IMPOSITIVO).equals(exc.dameCelda(i, COL_TIPO_IMPOSITIVO)) &&
                        		exc.dameCelda(x, COL_TIPO_ELEMENTO).equals(exc.dameCelda(i, COL_TIPO_ELEMENTO)) &&
                        		exc.dameCelda(x, COL_ID_ELEMENTO).equals(exc.dameCelda(i, COL_ID_ELEMENTO))
                        		) {
                        			listaFilas.add(i);
                        			addError = true;
                        			break;
                        		}
                        	}                       
                    	}
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

}