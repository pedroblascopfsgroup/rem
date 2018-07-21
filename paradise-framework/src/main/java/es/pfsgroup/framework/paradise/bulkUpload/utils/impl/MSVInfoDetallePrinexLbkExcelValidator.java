package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
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
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.dto.ResultadoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVVentaDeCarteraExcelValidator.COL_NUM;



@Component
public class MSVInfoDetallePrinexLbkExcelValidator extends MSVExcelValidatorAbstract{


	public static final String GASTO_NOT_EXISTS = "El gasto no existe (campo GPV_NUM_GASTO_HAYA).";
	public static final String GASTO_NULL = "El campo GPV_NUM_GASTO_HAYA no puede estar vacío";

	public static final String FORMATO_FECHA_CONTABLE_INVALIDO = "El campo GPL_FECHA_CONTABLE tiene un formato incorrecto";
	public static final String FORMATO_FECHA_FAC_INVALIDO = "El campo GPL_FECHA_FAC tiene un formato incorrecto";
	
	public static final String GPV_NUM_GASTO_HAYA_IS_NAN = "El campo GPV_NUM_GASTO_HAYA_IS_NAN no tiene un formato numérico válido";
	public static final String GPL_BASE_RETENCION_IS_NAN = "El campo GPL_BASE_RETENCION_IS_NAN no tiene un formato numérico válido";
	public static final String GPL_PROCENTAJE_RETEN_IS_NAN = "El campo GPL_PROCENTAJE_RETEN_IS_NAN no tiene un formato numérico válido";
	public static final String GPL_IMPORTE_RENTE_IS_NAN = "El campo GPL_IMPORTE_RENTE_IS_NAN no tiene un formato numérico válido";
	public static final String GPL_BASE_IRPF_IS_NAN = "El campo GPL_BASE_IRPF_IS_NAN no tiene un formato numérico válido";
	public static final String GPL_PROCENTAJE_IRPF_IS_NAN = "El campo GPL_PROCENTAJE_IRPF_IS_NAN no tiene un formato numérico válido";
	public static final String GPL_IMPORTE_IRPF_IS_NAN = "El campo GPL_IMPORTE_IRPF_IS_NAN no tiene un formato numérico válido";
	public static final String GPL_PCTJE_IVA_V_IS_NAN = "El campo GPL_PCTJE_IVA_V_IS_NAN no tiene un formato numérico válido";
	
	public static final String FICHERO_VACIO = "El fichero debe tener al menos una fila. La primera columna es obligatoria.";
	
	public static final class COL_NUM{
		
		public static final int FILA_CABECERA = 0;
		public static final int DATOS_PRIMERA_FILA = 1;
		
		//Datos excel
		public static final int GPV_NUM_GASTO_HAYA =0;
		public static final int GPL_FECHA_CONTABLE =1;
		public static final int GPL_DIARIO_CONTB =2;
		public static final int GPL_D347 =3;
		public static final int GPL_DELEGACION =4;
		public static final int GPL_BASE_RETENCION =5;
		public static final int GPL_PROCENTAJE_RETEN =6;
		public static final int GPL_IMPORTE_RENTE =7;
		public static final int GPL_APLICAR_RETENCION =8;
		public static final int GPL_BASE_IRPF =9;
		public static final int GPL_PROCENTAJE_IRPF =10;
		public static final int GPL_IMPORTE_IRPF =11;
		public static final int GPL_CLAVE_IRPF =12;
		public static final int GPL_SUBCLAVE_IRPF =13;
		public static final int GPL_CEUTA =14;
		public static final int GPL_CTA_IVAD =15;
		public static final int GPL_SCTA_IVAD =16;
		public static final int GPL_CONDICIONES =17;
		public static final int GPL_CTA_BANCO =18;
		public static final int GPL_SCTA_BANCO =19;
		public static final int GPL_CTA_EFECTOS =20;
		public static final int GPL_SCTA_EFECTOS =21;
		public static final int GPL_APUNTE =22;
		public static final int GPL_CENTRODESTINO =23;
		public static final int GPL_TIPO_FRA_SII =24;
		public static final int GPL_CLAVE_RE =25;
		public static final int GPL_CLAVE_RE_AD1 =26;
		public static final int GPL_CLAVE_RE_AD2 =27;
		public static final int GPL_TIPO_OP_INTRA =28;
		public static final int GPL_DESC_BIENES =29;
		public static final int GPL_DESCRIPCION_OP =30;
		public static final int GPL_SIMPLIFICADA =31;
		public static final int GPL_FRA_SIMPLI_IDEN =32;
		public static final int GPL_DIARIO1 =33;
		public static final int GPL_DIARIO2 =34;
		public static final int GPL_TIPO_PARTIDA =35;
		public static final int GPL_APARTADO =36;
		public static final int GPL_CAPITULO =37;
		public static final int GPL_PARTIDA =38;
		public static final int GPL_CTA_GASTO =39;
		public static final int GPL_SCTA_GASTO =40;
		public static final int GPL_REPERCUTIR =41;
		public static final int GPL_CONCEPTO_FAC =42;
		public static final int GPL_FECHA_FAC =43;
		public static final int GPL_COD_COEF =44;
		public static final int GPL_CODI_DIAR_IVA_V =45;
		public static final int GPL_PCTJE_IVA_V =46;
		public static final int GPL_NOMBRE =47;
		public static final int GPL_CARACTERISTICA =48;
	
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
			if(this.numFilasHoja > COL_NUM.DATOS_PRIMERA_FILA){
				mapaErrores.put(GASTO_NULL, esCampoNullByRows(exc, COL_NUM.GPV_NUM_GASTO_HAYA));
				mapaErrores.put(GASTO_NOT_EXISTS, isGastoNotExistsByRows(exc));
				mapaErrores.put(FORMATO_FECHA_CONTABLE_INVALIDO, esFechaValidaByRows(exc, COL_NUM.GPL_FECHA_CONTABLE));
				mapaErrores.put(FORMATO_FECHA_FAC_INVALIDO, esFechaValidaByRows(exc, COL_NUM.GPL_FECHA_FAC));
				mapaErrores.put(GPV_NUM_GASTO_HAYA_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.GPV_NUM_GASTO_HAYA)); 
				mapaErrores.put(GPL_BASE_RETENCION_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.GPL_BASE_RETENCION)); 
				mapaErrores.put(GPL_PROCENTAJE_RETEN_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.GPL_PROCENTAJE_RETEN)); 
				mapaErrores.put(GPL_IMPORTE_RENTE_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.GPL_IMPORTE_RENTE)); 
				mapaErrores.put(GPL_BASE_IRPF_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.GPL_BASE_IRPF)); 
				mapaErrores.put(GPL_PROCENTAJE_IRPF_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.GPL_PROCENTAJE_IRPF)); 
				mapaErrores.put(GPL_IMPORTE_IRPF_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.GPL_IMPORTE_IRPF)); 
				mapaErrores.put(GPL_PCTJE_IVA_V_IS_NAN, isColumnNANPrecioIncorrectoByRows(exc, COL_NUM.GPL_PCTJE_IVA_V)); 
				
				if( !mapaErrores.get(GASTO_NOT_EXISTS).isEmpty() || 
					!mapaErrores.get(GASTO_NULL).isEmpty() ||
					!mapaErrores.get(FORMATO_FECHA_CONTABLE_INVALIDO).isEmpty() ||
					!mapaErrores.get(FORMATO_FECHA_FAC_INVALIDO).isEmpty() ||
					!mapaErrores.get(GPV_NUM_GASTO_HAYA_IS_NAN).isEmpty() ||
					!mapaErrores.get(GPL_BASE_RETENCION_IS_NAN).isEmpty() ||
					!mapaErrores.get(GPL_PROCENTAJE_RETEN_IS_NAN).isEmpty() ||
					!mapaErrores.get(GPL_IMPORTE_RENTE_IS_NAN).isEmpty() ||
					!mapaErrores.get(GPL_BASE_IRPF_IS_NAN).isEmpty() ||
					!mapaErrores.get(GPL_PROCENTAJE_IRPF_IS_NAN).isEmpty() ||
					!mapaErrores.get(GPL_IMPORTE_IRPF_IS_NAN).isEmpty() ||
					!mapaErrores.get(GPL_PCTJE_IVA_V_IS_NAN).isEmpty()
				){
						dtoValidacionContenido.setFicheroTieneErrores(true);
						exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
						String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
						FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
						dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
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
	
	private List<Integer> isColumnNANPrecioIncorrectoByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precio = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				
				String value = exc.dameCelda(i, columnNumber);
				if(value != null && !value.isEmpty()){
					if(value.contains(",")){
						value = value.replace(",", ".");
					}
				}
				
				precio = !Checks.esNulo(value)
						? Double.parseDouble(value) : null;

				// Si el precio no es un número válido.
				if ((!Checks.esNulo(precio) && precio.isNaN()))
					listaFilas.add(i);
			} catch (NumberFormatException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
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
	
}
