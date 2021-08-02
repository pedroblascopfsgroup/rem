package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
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
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationRunner;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVValidationResult;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVMultiColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVFicheroDao;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.dto.ResultadoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;



@Component
public class MSVInfoDetallePrinexLbkExcelValidator extends MSVExcelValidatorAbstract{


	public static final String GASTO_NOT_EXISTS = "El gasto no existe (campo GPV_NUM_GASTO_HAYA).";
	public static final String GASTO_NULL = "El campo GPV_NUM_GASTO_HAYA no puede estar vacío";
	public static final String GASTO_NOT_LIBERBANK = "El gasto no es de la cartera Unicaja";

	public static final String FORMATO_FECHA_CONTABLE_INVALIDO = "El campo GPL_FECHA_CONTABLE tiene un formato incorrecto";
	public static final String FORMATO_FECHA_FAC_INVALIDO = "El campo GPL_FECHA_FAC tiene un formato incorrecto";
	
	public static final String FICHERO_VACIO = "El fichero debe tener al menos una fila. La primera columna es obligatoria.";
	
	public static final String PORCENTAJE_IRPF_SUPERIOR_100 = "El porcentaje IRPF es superior a 100";
	public static final String PORCENTAJE_IRPF_INFERIOR_0 = "El porcentaje IRPF es menor que 0";
	
	public static final String PORCENTAJE_RETEN_SUPERIOR_100 = "El porcentaje retención es superior a 100";
	public static final String PORCENTAJE_RETEN_INFERIOR_0 = "El porcentaje retención es menor que 0";
	
	public static final String PORCENTAJE_IVA_SUPERIOR_100 = "El porcentaje iva es superior a 100";
	public static final String PORCENTAJE_IVA_INFERIOR_0 = "El porcentaje iva es menor que 0";
	
	public static final String NOT_PAIR_GASTO_ACTIVO = "El gasto indicado no pertenece al activo indicado";
	public static final String PROMOCION_NOT_EXISTS = "La promocion indicada no existe";
	
	public static final String DIARIO1_VALORES_POSIBLES = "Los valores válidos para el campo Diario 1 són: Vacío,1,2,20 y 60";
	public static final String DIARIO2_VALORES_POSIBLES = "Los valores válidos para el campo Diario 2 són: Vacío y 60";
	public static final String DIARIO1_VS_DIARIO2 = "No es posible cumplimentar en campo Diario 2 si el campo Diario 1 está vacío";
	
	public static final class COL_NUM{
		
		public static final int FILA_CABECERA = 0;
		public static final int DATOS_PRIMERA_FILA = 1;
		
		//Datos excel
		public static final int GPV_NUM_GASTO_HAYA =0;
		public static final int ACT_NUM_ACTIVO_HAYA =1;
		public static final int GPL_PROYECTO =2;
		public static final int GPL_TIPO_INMUEBLE =3;
		public static final int GPL_CLAVE_1 =4;
		public static final int GPL_CLAVE_2 =5;
		public static final int GPL_CLAVE_3 =6;
		public static final int GPL_CLAVE_4 =7;
		public static final int GPL_IMPORTE_GASTO =8;
		public static final int GPL_FECHA_CONTABLE =9;
		public static final int GPL_DIARIO_CONTB =10;
		public static final int GPL_D347 =11;
		public static final int GPL_DELEGACION =12;
		public static final int GPL_BASE_RETENCION =13;
		public static final int GPL_PROCENTAJE_RETEN =14;
		public static final int GPL_IMPORTE_RENTE =15;
		public static final int GPL_APLICAR_RETENCION =16;
		public static final int GPL_BASE_IRPF =17;
		public static final int GPL_PROCENTAJE_IRPF =18;
		public static final int GPL_IMPORTE_IRPF =19;
		public static final int GPL_CLAVE_IRPF =20;
		public static final int GPL_SUBCLAVE_IRPF =21;
		public static final int GPL_CEUTA =22;
		public static final int GPL_CTA_IVAD =23;
		public static final int GPL_SCTA_IVAD =24;
		public static final int GPL_CONDICIONES =25;
		public static final int GPL_CTA_BANCO =26;
		public static final int GPL_SCTA_BANCO =27;
		public static final int GPL_CTA_EFECTOS =28;
		public static final int GPL_SCTA_EFECTOS =29;
		public static final int GPL_APUNTE =30;
		public static final int GPL_CENTRODESTINO =31;
		public static final int GPL_TIPO_FRA_SII =32;
		public static final int GPL_CLAVE_RE =33;
		public static final int GPL_CLAVE_RE_AD1 =34;
		public static final int GPL_CLAVE_RE_AD2 =35;
		public static final int GPL_TIPO_OP_INTRA =36;
		public static final int GPL_DESC_BIENES =37;
		public static final int GPL_DESCRIPCION_OP =38;
		public static final int GPL_SIMPLIFICADA =39;
		public static final int GPL_FRA_SIMPLI_IDEN =40;
		public static final int GPL_DIARIO1 =41;
		public static final int GPL_DIARIO1_BASE = 42;
		public static final int GPL_DIARIO1_TIPO = 43;
		public static final int GPL_DIARIO1_CUOTA = 44;
		public static final int GPL_DIARIO2 =45;
		public static final int GPL_DIARIO2_BASE = 46;
		public static final int GPL_DIARIO2_TIPO = 47;
		public static final int GPL_DIARIO2_CUOTA = 48;
		public static final int GPL_TIPO_PARTIDA =49;
		public static final int GPL_APARTADO =50;
		public static final int GPL_CAPITULO =51;
		public static final int GPL_PARTIDA =52;
		public static final int GPL_CTA_GASTO =53;
		public static final int GPL_SCTA_GASTO =54;
		public static final int GPL_REPERCUTIR =55;
		public static final int GPL_CONCEPTO_FAC =56;
		public static final int GPL_FECHA_FAC =57;
		public static final int GPL_COD_COEF =58;
		public static final int GPL_CODI_DIAR_IVA_V =59;
		public static final int GPL_PCTJE_IVA_V =60;
		public static final int GPL_NOMBRE =61;
		public static final int GPL_CARACTERISTICA =62;
	
	}
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private ParticularValidatorApi particularValidator;

	@Resource
	MessageService messageServices;

	@Autowired
	private MSVProcesoApi msvProcesoApi;
	
	@Autowired
	private MSVFicheroDao ficheroDao;
	
	private Integer numFilasHoja;
	
	
	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception{

		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = new MSVDtoValidacion();
		dtoValidacionContenido.setFicheroTieneErrores(false);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		
		try{
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		}catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		if(!dtoValidacionContenido.getFicheroTieneErrores()){
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			Map<String, List<Integer>> mapaCount = new HashMap<String, List<Integer>>();
			if(this.numFilasHoja > COL_NUM.DATOS_PRIMERA_FILA){
				mapaErrores.put(GASTO_NULL, esCampoNullByRows(exc, COL_NUM.GPV_NUM_GASTO_HAYA));
				mapaErrores.put(GASTO_NOT_EXISTS, isGastoNotExistsByRows(exc));
				mapaErrores.put(FORMATO_FECHA_CONTABLE_INVALIDO, esFechaValidaByRows(exc, COL_NUM.GPL_FECHA_CONTABLE));
				mapaErrores.put(FORMATO_FECHA_FAC_INVALIDO, esFechaValidaByRows(exc, COL_NUM.GPL_FECHA_FAC));
				mapaErrores.put(PORCENTAJE_IRPF_SUPERIOR_100, isPorcentajeSuperiorA100(exc,COL_NUM.GPL_PROCENTAJE_IRPF));
				mapaErrores.put(PORCENTAJE_IRPF_INFERIOR_0, isPorcentajeInferiorA0(exc,COL_NUM.GPL_PROCENTAJE_IRPF));
				mapaErrores.put(PORCENTAJE_RETEN_SUPERIOR_100, isPorcentajeSuperiorA100(exc,COL_NUM.GPL_PROCENTAJE_RETEN));
				mapaErrores.put(PORCENTAJE_RETEN_INFERIOR_0, isPorcentajeInferiorA0(exc,COL_NUM.GPL_PROCENTAJE_RETEN));
				mapaErrores.put(PORCENTAJE_IVA_SUPERIOR_100, isPorcentajeSuperiorA100(exc,COL_NUM.GPL_PCTJE_IVA_V));
				mapaErrores.put(PORCENTAJE_IVA_INFERIOR_0, isPorcentajeInferiorA0(exc,COL_NUM.GPL_PCTJE_IVA_V));
				mapaErrores.put(GASTO_NOT_LIBERBANK, isGastoNotLiberbankByRows(exc));
				mapaErrores.put(NOT_PAIR_GASTO_ACTIVO, esParGastoActivo(exc, COL_NUM.GPV_NUM_GASTO_HAYA, COL_NUM.ACT_NUM_ACTIVO_HAYA));
				mapaErrores.put(PROMOCION_NOT_EXISTS, existePromocion(exc, COL_NUM.GPL_PROYECTO));
				mapaErrores.put(DIARIO1_VALORES_POSIBLES, validaDiario1(exc, COL_NUM.GPL_DIARIO1));
				mapaErrores.put(DIARIO2_VALORES_POSIBLES, validaDiario2(exc, COL_NUM.GPL_DIARIO2));
				mapaErrores.put(DIARIO1_VS_DIARIO2, validaDiario1Diario2(exc, COL_NUM.GPL_DIARIO1, COL_NUM.GPL_DIARIO2));
				mapaCount.put("fin", countNumGastos(exc, COL_NUM.GPV_NUM_GASTO_HAYA));
				
				if( !mapaErrores.get(GASTO_NOT_EXISTS).isEmpty() || 
					!mapaErrores.get(GASTO_NULL).isEmpty() ||
					!mapaErrores.get(FORMATO_FECHA_CONTABLE_INVALIDO).isEmpty() ||
					!mapaErrores.get(FORMATO_FECHA_FAC_INVALIDO).isEmpty() ||
					!mapaErrores.get(PORCENTAJE_IRPF_SUPERIOR_100).isEmpty()||
					!mapaErrores.get(PORCENTAJE_IRPF_INFERIOR_0).isEmpty()||
					!mapaErrores.get(PORCENTAJE_RETEN_SUPERIOR_100).isEmpty()||
					!mapaErrores.get(PORCENTAJE_RETEN_INFERIOR_0).isEmpty()||
					!mapaErrores.get(PORCENTAJE_IVA_SUPERIOR_100).isEmpty()||
					!mapaErrores.get(PORCENTAJE_IVA_INFERIOR_0).isEmpty()||
					!mapaErrores.get(GASTO_NOT_LIBERBANK).isEmpty()||
					!mapaErrores.get(NOT_PAIR_GASTO_ACTIVO).isEmpty()||
					!mapaErrores.get(PROMOCION_NOT_EXISTS).isEmpty()||
					!mapaErrores.get(DIARIO1_VALORES_POSIBLES).isEmpty()||
					!mapaErrores.get(DIARIO2_VALORES_POSIBLES).isEmpty() ||
					!mapaErrores.get(DIARIO1_VS_DIARIO2).isEmpty()
				){
						dtoValidacionContenido.setFicheroTieneErrores(true);
						exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
						String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
						FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
						dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
				}else {
					dtoValidacionContenido.setFicheroTieneErrores(false);
					exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
					String nomFichero = exc.crearExcelValidadoCount(mapaCount, 0, 0);
					FileItem fileItem = new FileItem(new File(nomFichero));
					MSVDocumentoMasivo archivo = ficheroDao.findByIdProceso(dtoFile.getProcessId());
					archivo.setContenidoFichero(fileItem);
				}
			}else{
				List<Integer> listaFilas = new ArrayList<Integer>();
				listaFilas.add(COL_NUM.DATOS_PRIMERA_FILA);
				mapaErrores.put(FICHERO_VACIO, listaFilas);
	
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
	
	private List<Integer> esCampoNullByRows(MSVHojaExcel exc, Integer campo){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for(int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++){
			try {
				if(Checks.esNulo(exc.dameCelda(i, campo))){
					listaFilas.add(i);
				}
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return listaFilas;
	}
	
	private List<Integer> isGastoNotExistsByRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i= COL_NUM.DATOS_PRIMERA_FILA; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.GPV_NUM_GASTO_HAYA)) && !particularValidator.existeGasto(exc.dameCelda(i, COL_NUM.GPV_NUM_GASTO_HAYA)))
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
	
	private List<Integer> isGastoNotLiberbankByRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i= COL_NUM.DATOS_PRIMERA_FILA; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.GPV_NUM_GASTO_HAYA)) && !particularValidator.esGastoDeLiberbank(exc.dameCelda(i, COL_NUM.GPV_NUM_GASTO_HAYA)))
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
	
	private List<Integer> esFechaValidaByRows(MSVHojaExcel exc, Integer campo){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		String valorDate = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				valorDate = exc.dameCelda(i, campo);

				// Si el valor Date no se puede obtener adecuadamente se lanza
				// error para esa línea.
				if (!Checks.esNulo(valorDate)) {
					ft.setLenient(false);
					ParsePosition p = new ParsePosition( 0 );
					ft.parse(valorDate,p);
					if(p.getIndex() < valorDate.length()) {
						  throw new ParseException( valorDate, p.getIndex() );
					}
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	private List<Integer> isPorcentajeSuperiorA100(MSVHojaExcel exc,Integer columna){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for(int i=1; i<this.numFilasHoja;i++){
			try{
				if (!Checks.esNulo(exc.dameCelda(i, columna))) {
					Double porcentaje = Double.parseDouble(exc.dameCelda(i, columna));
					if(porcentaje > 100.00){
						listaFilas.add(i);
					}
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		
		
		return listaFilas;
	}
	
	private List<Integer> isPorcentajeInferiorA0(MSVHojaExcel exc,Integer columna){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for(int i=1; i<this.numFilasHoja;i++){
			try{
				if (!Checks.esNulo(exc.dameCelda(i, columna))) {
					Double porcentaje = Double.parseDouble(exc.dameCelda(i,columna));
					if(porcentaje < 0.0){
						listaFilas.add(i);
					}
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		
		
		return listaFilas;
	}
	
	private List<Integer> esParGastoActivo(MSVHojaExcel exc, Integer numGasto, Integer idActivo){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for(int i = 1; i<this.numFilasHoja; i++){
			try{
				if(!Checks.esNulo(exc.dameCelda(i, numGasto)) && !Checks.esNulo(exc.dameCelda(i, idActivo))){
					if(!particularValidator.esParGastoActivo(exc.dameCelda(i, numGasto), exc.dameCelda(i, idActivo))){
						listaFilas.add(i);
					}
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return listaFilas;
	}
	
	private List<Integer> existePromocion(MSVHojaExcel exc, Integer promocion){
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<String> valoresValidos = Arrays.asList("9000", "9001", "9002", "9005", "9006");
		
		for(int i = 1; i<this.numFilasHoja; i++){
			try{
				String valor = exc.dameCelda(i, promocion);
				if(!Checks.esNulo(valor) && !valoresValidos.contains(valor)){
					if(!particularValidator.existePromocion(exc.dameCelda(i, promocion))){
						listaFilas.add(i);
					}
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return listaFilas;
	}
	
	
	private List<Integer> validaDiario1(MSVHojaExcel exc, Integer columna){
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<String> valoresValidos = Arrays.asList("1", "2", "20", "60");
		for(int i = 1; i<this.numFilasHoja; i++){
			try{
				String valor = exc.dameCelda(i, columna);
				if(!Checks.esNulo(valor) && !valoresValidos.contains(valor)){
					listaFilas.add(i);
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return listaFilas;
	}
	
	private List<Integer> validaDiario2(MSVHojaExcel exc, Integer columna){
		List<Integer> listaFilas = new ArrayList<Integer>();
		List<String> valoresValidos = Arrays.asList("60");
		for(int i = 1; i<this.numFilasHoja; i++){
			try{
				String valor = exc.dameCelda(i, columna);
				if(!Checks.esNulo(valor) && !valoresValidos.contains(valor)){
					listaFilas.add(i);
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return listaFilas;
	}
	
	private List<Integer> validaDiario1Diario2(MSVHojaExcel exc, Integer columnaDiario1, Integer columnaDiario2){
		List<Integer> listaFilas = new ArrayList<Integer>();
		for(int i = 1; i<this.numFilasHoja; i++){
			try{
				String valorDiario1 = exc.dameCelda(i, columnaDiario1);
				String valorDiario2 = exc.dameCelda(i, columnaDiario2);
				if(Checks.esNulo(valorDiario1) && !Checks.esNulo(valorDiario2)){
					listaFilas.add(i);
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return listaFilas;
	}
	private List<Integer> countNumGastos(MSVHojaExcel exc, Integer colNumGasto){		
		Map<String, Integer> mapaCount = new HashMap<String, Integer>();
		for(int i = 1; i<this.numFilasHoja; i++){
			try{
				String valorNumGasto = exc.dameCelda(i, colNumGasto);
				if(mapaCount.containsKey(valorNumGasto)) {
					mapaCount.remove(valorNumGasto);
				}
				mapaCount.put(valorNumGasto, i);
				
				
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return new ArrayList<Integer>(mapaCount.values());
	}

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
	
}
