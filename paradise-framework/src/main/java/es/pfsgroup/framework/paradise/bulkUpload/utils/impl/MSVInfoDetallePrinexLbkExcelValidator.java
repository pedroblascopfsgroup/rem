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
	
	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_NULL = "El campo código no puede estar vacío";

	public static final String FICHERO_VACIO = "El fichero debe tener al menos una fila. La primera columna es obligatoria.";
	
	public static final class COL_NUM{
		
		public static final int FILA_CABECERA = 1;
		public static final int DATOS_PRIMERA_FILA = 2;
		
		//Datos excel
		public static final int GPV_NUM_GASTO_HAYA =1;
		public static final int GPL_FECHA_CONTABLE =2;
		public static final int GPL_DIARIO_CONTB =3;
		public static final int GPL_D347 =4;
		public static final int GPL_DELEGACION =5;
		public static final int GPL_BASE_RETENCION =6;
		public static final int GPL_PROCENTAJE_RETEN =7;
		public static final int GPL_IMPORTE_RENTE =8;
		public static final int GPL_APLICAR_RETENCION =9;
		public static final int GPL_BASE_IRPF =10;
		public static final int GPL_PROCENTAJE_IRPF =11;
		public static final int GPL_IMPORTE_IRPF =12;
		public static final int GPL_CLAVE_IRPF =13;
		public static final int GPL_SUBCLAVE_IRPF =14;
		public static final int GPL_CEUTA =15;
		public static final int GPL_CTA_IVAD =16;
		public static final int GPL_SCTA_IVAD =17;
		public static final int GPL_CONDICIONES =18;
		public static final int GPL_CTA_BANCO =19;
		public static final int GPL_SCTA_BANCO =2;
		public static final int GPL_CTA_EFECTOS =21;
		public static final int GPL_SCTA_EFECTOS =22;
		public static final int GPL_APUNTE =23;
		public static final int GPL_CENTRODESTINO =24;
		public static final int GPL_TIPO_FRA_SII =25;
		public static final int GPL_CLAVE_RE =26;
		public static final int GPL_CLAVE_RE_AD1 =27;
		public static final int GPL_CLAVE_RE_AD2 =28;
		public static final int GPL_TIPO_OP_INTRA =29;
		public static final int GPL_DESC_BIENES =30;
		public static final int GPL_DESCRIPCION_OP =31;
		public static final int GPL_SIMPLIFICADA =32;
		public static final int GPL_FRA_SIMPLI_IDEN =33;
		public static final int GPL_DIARIO1 =34;
		public static final int GPL_DIARIO2 =35;
		public static final int GPL_TIPO_PARTIDA =36;
		public static final int GPL_APARTADO =37;
		public static final int GPL_CAPITULO =38;
		public static final int GPL_PARTIDA =39;
		public static final int GPL_CTA_GASTO =40;
		public static final int GPL_SCTA_GASTO =41;
		public static final int GPL_REPERCUTIR =42;
		public static final int GPL_CONCEPTO_FAC =43;
		public static final int GPL_FECHA_FAC =44;
		public static final int GPL_COD_COEF =45;
		public static final int GPL_CODI_DIAR_IVA_V =46;
		public static final int GPL_PCTJE_IVA_V =47;
		public static final int GPL_NOMBRE =48;
		public static final int GPL_CARACTERISTICA =49;
	
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
				
				if(!mapaErrores.get(GASTO_NOT_EXISTS).isEmpty() || !mapaErrores.get(GASTO_NULL).isEmpty()){
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
		return null;
	}
	
	@Override
	protected ResultadoValidacion validaContenidoFila(Map<String, String> mapaDatos, List<String> listaCabeceras,
			MSVBusinessCompositeValidators compositeValidators) {
		return null;
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
}
