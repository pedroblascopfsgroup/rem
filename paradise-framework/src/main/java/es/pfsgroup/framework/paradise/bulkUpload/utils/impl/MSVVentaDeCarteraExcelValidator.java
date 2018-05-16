package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
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
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelRepoApi;
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
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;


@Component
public class MSVVentaDeCarteraExcelValidator extends MSVExcelValidatorAbstract{

	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_NULL = "El campo número activo no puede estar vacío";
	public static final String PRECIO_VENTA_NULL = "El campo precio de venta no puede estar vacío";
	public static final String OFERTAS_TRAMITADAS = "El activo no tiene ofertas tramitadas";
	public static final String MAXIMO_AGRUPADOS = "El número máximo de activos que pueden agruparse en una oferta es de 40";
	public static final String TITULARES_AGRUPACION = "El primer titular de cada grupo debe ser el mismo";
	public static final String TITULAR_OPCIONAL_2 = "Si el titular opcional (2o titular) viene informado, se debe rellenar su número URSUS";
	public static final String TITULAR_OPCIONAL_3 = "Si el titular opcional (3er titular) viene informado, se debe rellenar su número URSUS";
	public static final String TITULAR_OPCIONAL_4 = "Si el titular opcional (4o titular) viene informado, se debe rellenar su número URSUS";
	
	public static final String COMITE_SANCIONADOR_NOT_EXISTS = "El comité sancionador indicado no existe";
	public static final String COMITE_SANCIONADOR_NULL = "El campo comité sancionador no puede estar vacío";
	public static final String TIPO_IMPUESTO_NULL = "El campo tipo impuesto no puede estar vacío";
	public static final String TIPO_IMPUESTO_NOT_EXISTS = "El tipo de impuesto indicado no existe";
	public static final String TIPO_APLICABLE_NULL = "El campo tipo aplicable no puede estar vacio";
	public static final String FECHA_VENTA_NULL = "El campo fecha venta no puede estar vacío";
	public static final String CODIGO_UNICO_OFERTA_NULL = "El campo código único oferta no puede estar vacío";
	public static final String TIPO_DOCUMENTO_TITULAR_NOT_EXISTS = "El tipo de documento indicado del primer titular no existe";
	public static final String TIPO_DOCUMENTO_TITULAR_2_NOT_EXISTS = "El tipo de documento indicado del segundo titular no existe";
	public static final String TIPO_DOCUMENTO_TITULAR_3_NOT_EXISTS = "El tipo de documento indicado del tercer titular no existe";
	public static final String TIPO_DOCUMENTO_TITULAR_4_NOT_EXISTS = "El tipo de documento indicado del cuarto titular no existe";
	public static final String USER_GESTOR_COMERCIALIZACION_NULL = "El campo usuario gestor comercialización no puede estar vacío";
	public static final String USER_NO_GESTOR_COMERCIALIZACION = "No existe el gestor de comercialización indicado";
	public static final String CODIGO_PRESCRIPTOR_NULL = "El campo código prescriptor no puede estar vacío";
	public static final String CODIGO_PRESCRIPTOR_NOT_EXISTS = "El código presciptor indicado no existe";
	
	public static final String NUMERO_URSUS_TITULAR_NULL = "El campo número URSUS del 1er titular no puede estar vacío";
	public static final String PORCENTAJE_COMPRA_TITULAR_NULL = "El campo % compra del 1er titular no puede estar vacío";
	
	public static final String FICHERO_VACIO = "El fichero debe tener al menos una fila. La primera columna es obligatoria.";
	
	public static final class COL_NUM{
		
		static final int FILA_CABECERA = 2;
		static final int DATOS_PRIMERA_FILA = 3;
		
		//Datos Activo
		static final int NUM_ACTIVO_HAYA = 0;
		static final int PRECIO_VENTA = 1;
		
		//Información expediente comercial
		static final int COMITE_SANCIONADOR = 2;
		static final int TIPO_IMPUESTO = 3;
		static final int TIPO_APLICABLE = 4;
		static final int FECHA_VENTA = 5;
		static final int FECHA_INGRESO_CHEQUE=6;
		
		//Datos Oferta
			//Identificacion
		static final int CODIGO_UNICO_OFERTA = 7;
		static final int USU_GESTOR_COMERCIALIZACION = 8;
		
			//Prescriptor
		static final int CODIGO_PRESCRIPTOR = 9;
		
			//Titular
		static final int NOMBRE_TITULAR = 10;
		static final int RAZON_SOCIAL_TITULAR= 11;
		static final int TIPO_DOCUMENTO_TITULAR= 12;
		static final int DOC_IDENTIFICACION_TITULAR = 13;
		static final int NUMERO_URSUS_TITULAR = 14;
		static final int NUMERO_URSUS_CONYUGE_TITULAR = 15;
		static final int PORCENTAJE_COMPRA_TITULAR = 16;
		
			//Titular 2
		static final int NOMBRE_TITULAR_2 = 17;
		static final int RAZON_SOCIAL_TITULAR_2= 18;
		static final int TIPO_DOCUMENTO_TITULAR_2= 19;
		static final int DOC_IDENTIFICACION_TITULAR_2 = 20;
		static final int NUMERO_URSUS_TITULAR_2 = 21;
		static final int NUMERO_URSUS_CONYUGE_TITULAR_2 = 22;
		static final int PORCENTAJE_COMPRA_TITULAR_2 = 23;
		
			//Titular 3
		static final int NOMBRE_TITULAR_3 = 24;
		static final int RAZON_SOCIAL_TITULAR_3= 25;
		static final int TIPO_DOCUMENTO_TITULAR_3= 26;
		static final int DOC_IDENTIFICACION_TITULAR_3 = 27;
		static final int NUMERO_URSUS_TITULAR_3 = 28;
		static final int NUMERO_URSUS_CONYUGE_TITULAR_3 = 29;
		static final int PORCENTAJE_COMPRA_TITULAR_3 = 30;
		
			//Titular 4
		static final int NOMBRE_TITULAR_4 = 31;
		static final int RAZON_SOCIAL_TITULAR_4= 32;
		static final int TIPO_DOCUMENTO_TITULAR_4= 33;
		static final int DOC_IDENTIFICACION_TITULAR_4 = 34;
		static final int NUMERO_URSUS_TITULAR_4 = 35;
		static final int NUMERO_URSUS_CONYUGE_TITULAR_4 = 36;
		static final int PORCENTAJE_COMPRA_TITULAR_4 = 37;
	}
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;

	@Autowired
	private ParticularValidatorApi particularValidator;

	@Resource
	MessageService messageServices;

	@Autowired
	private MSVProcesoApi msvProcesoApi;

	private Integer numFilasHoja;
	
	
	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception{
		/*
		List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion()));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		*/
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
				mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsByRows(exc));
				mapaErrores.put(ACTIVE_NULL, esCampoNullByRows(exc, COL_NUM.NUM_ACTIVO_HAYA));
				mapaErrores.put(PRECIO_VENTA_NULL, esCampoNullByRows(exc, COL_NUM.PRECIO_VENTA));
				mapaErrores.put(OFERTAS_TRAMITADAS, sinOfertasTramitadasByRow(exc));
				mapaErrores.put(MAXIMO_AGRUPADOS, maxAgrupadoByRow(exc));
				mapaErrores.put(TITULARES_AGRUPACION, titularesAgrupacionByRow(exc));
				mapaErrores.put(TITULAR_OPCIONAL_2, titularInformadoSinURSUSByRow(exc,2));
				mapaErrores.put(TITULAR_OPCIONAL_3, titularInformadoSinURSUSByRow(exc,3));
				mapaErrores.put(TITULAR_OPCIONAL_4, titularInformadoSinURSUSByRow(exc,4));
				mapaErrores.put(COMITE_SANCIONADOR_NOT_EXISTS, comiteSancionadorNotExistsByRow(exc));
				mapaErrores.put(COMITE_SANCIONADOR_NULL, esCampoNullByRows(exc, COL_NUM.COMITE_SANCIONADOR));
				mapaErrores.put(TIPO_IMPUESTO_NULL, esCampoNullByRows(exc, COL_NUM.TIPO_IMPUESTO));
				mapaErrores.put(TIPO_IMPUESTO_NOT_EXISTS, tipoImpuestoNotExistsByRow(exc));
				mapaErrores.put(TIPO_APLICABLE_NULL, esCampoNullByRows(exc, COL_NUM.TIPO_APLICABLE));
				mapaErrores.put(FECHA_VENTA_NULL, esCampoNullByRows(exc,COL_NUM.FECHA_VENTA));
				mapaErrores.put(CODIGO_UNICO_OFERTA_NULL, esCampoNullByRows(exc,COL_NUM.CODIGO_UNICO_OFERTA));
				mapaErrores.put(TIPO_DOCUMENTO_TITULAR_NOT_EXISTS, tipoDocumentoNotExistsByrow(exc,1));
				mapaErrores.put(TIPO_DOCUMENTO_TITULAR_2_NOT_EXISTS, tipoDocumentoNotExistsByrow(exc,2));
				mapaErrores.put(TIPO_DOCUMENTO_TITULAR_3_NOT_EXISTS, tipoDocumentoNotExistsByrow(exc,3));
				mapaErrores.put(TIPO_DOCUMENTO_TITULAR_4_NOT_EXISTS, tipoDocumentoNotExistsByrow(exc,4));
				mapaErrores.put(USER_GESTOR_COMERCIALIZACION_NULL, esCampoNullByRows(exc,COL_NUM.USU_GESTOR_COMERCIALIZACION));
				mapaErrores.put(USER_NO_GESTOR_COMERCIALIZACION, userNotGestorComercializacionByRows(exc));
				mapaErrores.put(CODIGO_PRESCRIPTOR_NULL, esCampoNullByRows(exc,COL_NUM.CODIGO_PRESCRIPTOR));
				mapaErrores.put(CODIGO_PRESCRIPTOR_NOT_EXISTS, codigoPrescriptorNotExistsByRows(exc));
				mapaErrores.put(NUMERO_URSUS_TITULAR_NULL, esCampoNullByRows(exc,COL_NUM.NUMERO_URSUS_TITULAR));
				mapaErrores.put(PORCENTAJE_COMPRA_TITULAR_NULL, esCampoNullByRows(exc,COL_NUM.PORCENTAJE_COMPRA_TITULAR));
				
				
				if(!mapaErrores.get(ACTIVE_NOT_EXISTS).isEmpty()
						||!mapaErrores.get(ACTIVE_NULL).isEmpty()
						||!mapaErrores.get(PRECIO_VENTA_NULL).isEmpty()
						||!mapaErrores.get(OFERTAS_TRAMITADAS).isEmpty()
						||!mapaErrores.get(MAXIMO_AGRUPADOS).isEmpty()
						||!mapaErrores.get(TITULARES_AGRUPACION).isEmpty()
						||!mapaErrores.get(TITULAR_OPCIONAL_2).isEmpty()
						||!mapaErrores.get(TITULAR_OPCIONAL_3).isEmpty()
						||!mapaErrores.get(TITULAR_OPCIONAL_4).isEmpty()
						||!mapaErrores.get(COMITE_SANCIONADOR_NULL).isEmpty()
						||!mapaErrores.get(COMITE_SANCIONADOR_NOT_EXISTS).isEmpty()
						||!mapaErrores.get(TIPO_IMPUESTO_NULL).isEmpty()
						||!mapaErrores.get(TIPO_IMPUESTO_NOT_EXISTS).isEmpty()
						||!mapaErrores.get(TIPO_APLICABLE_NULL).isEmpty()
						||!mapaErrores.get(FECHA_VENTA_NULL).isEmpty()
						||!mapaErrores.get(CODIGO_UNICO_OFERTA_NULL).isEmpty()
						||!mapaErrores.get(TIPO_DOCUMENTO_TITULAR_NOT_EXISTS).isEmpty()
						||!mapaErrores.get(TIPO_DOCUMENTO_TITULAR_2_NOT_EXISTS).isEmpty()
						||!mapaErrores.get(TIPO_DOCUMENTO_TITULAR_3_NOT_EXISTS).isEmpty()
						||!mapaErrores.get(TIPO_DOCUMENTO_TITULAR_4_NOT_EXISTS).isEmpty()
						||!mapaErrores.get(USER_GESTOR_COMERCIALIZACION_NULL).isEmpty()
						||!mapaErrores.get(USER_NO_GESTOR_COMERCIALIZACION).isEmpty()
						||!mapaErrores.get(CODIGO_PRESCRIPTOR_NULL).isEmpty()
						||!mapaErrores.get(CODIGO_PRESCRIPTOR_NOT_EXISTS).isEmpty()
						||!mapaErrores.get(NUMERO_URSUS_TITULAR_NULL).isEmpty()
						||!mapaErrores.get(PORCENTAJE_COMPRA_TITULAR_NULL).isEmpty()
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
	
	private File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private List<Integer> isActiveNotExistsByRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i= COL_NUM.DATOS_PRIMERA_FILA; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)) && !particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)))
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
	
	private List<Integer> sinOfertasTramitadasByRow(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++){
				try{
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)) && particularValidator.existeOfertaAprobadaActivo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA))){
						listaFilas.add(i);
					} 
				}catch (ParseException e){
					listaFilas.add(i);
				}
			}
		}catch (IllegalArgumentException e){
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e){
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> titularesAgrupacionByRow(MSVHojaExcel exc){
		Map<String,String> titularesMap = new HashMap<String,String>();
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for(int x = COL_NUM.DATOS_PRIMERA_FILA; x < this.numFilasHoja; x++){
			try {
				if(!titularesMap.containsKey(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA))){
					titularesMap.put(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA), exc.dameCelda(x, COL_NUM.NUMERO_URSUS_TITULAR));
				}else{
					if(!exc.dameCelda(x, COL_NUM.NUMERO_URSUS_TITULAR).equals(titularesMap.get(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA)))){
						titularesMap.put(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA), "error");
					}
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
		
		for(int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++){
			try {
				if(titularesMap.get(exc.dameCelda(i, COL_NUM.CODIGO_UNICO_OFERTA)).equals("error")){
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
	
	private List<Integer> maxAgrupadoByRow(MSVHojaExcel exc){
		
		Map<String, Integer> ocurrencias = new HashMap<String, Integer>();
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for(int x = COL_NUM.DATOS_PRIMERA_FILA; x < this.numFilasHoja; x ++){
			try {
				if(ocurrencias.containsKey(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA))){
					ocurrencias.put(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA), ocurrencias.get(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA))+1);
				}else{
					ocurrencias.put(exc.dameCelda(x, COL_NUM.CODIGO_UNICO_OFERTA),1);
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
			
		for(int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++){
			try {
				if(ocurrencias.get(exc.dameCelda(i, COL_NUM.CODIGO_UNICO_OFERTA)) > 40){
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
	
	private List<Integer> titularInformadoSinURSUSByRow(MSVHojaExcel exc, Integer titularOpcional){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++){
				try{
					if(titularOpcional == 2){
						if(Checks.esNulo(exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_2)) && (!Checks.esNulo(exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_2)) || !Checks.esNulo(exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_2)) || !Checks.esNulo(exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_2)) || !Checks.esNulo(exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_2)) || !Checks.esNulo(exc.dameCelda(i, COL_NUM.NUMERO_URSUS_CONYUGE_TITULAR_2)))){
							listaFilas.add(i);
						}
						
					}else if(titularOpcional == 3){
						if(Checks.esNulo(exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_3)) && (!Checks.esNulo(exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_3)) || !Checks.esNulo(exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_3)) || !Checks.esNulo(exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_3)) || !Checks.esNulo(exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_3)) || !Checks.esNulo(exc.dameCelda(i, COL_NUM.NUMERO_URSUS_CONYUGE_TITULAR_3)))){
							listaFilas.add(i);
						}
					}else if(titularOpcional == 4){
						if(Checks.esNulo(exc.dameCelda(i, COL_NUM.NUMERO_URSUS_TITULAR_4)) && (!Checks.esNulo(exc.dameCelda(i, COL_NUM.NOMBRE_TITULAR_4)) || !Checks.esNulo(exc.dameCelda(i, COL_NUM.RAZON_SOCIAL_TITULAR_4)) || !Checks.esNulo(exc.dameCelda(i, COL_NUM.TIPO_DOCUMENTO_TITULAR_4)) || !Checks.esNulo(exc.dameCelda(i, COL_NUM.DOC_IDENTIFICACION_TITULAR_4)) || !Checks.esNulo(exc.dameCelda(i, COL_NUM.NUMERO_URSUS_CONYUGE_TITULAR_4)))){
							listaFilas.add(i);
						}
					}
					
				}catch (ParseException e){
					listaFilas.add(i);
				}
			}
		}catch (IllegalArgumentException e){
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e){
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		
		return listaFilas;
	}
	
	private List<Integer> comiteSancionadorNotExistsByRow(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++){
				try{
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COMITE_SANCIONADOR)) && !particularValidator.existeComiteSancionador(exc.dameCelda(i, COL_NUM.COMITE_SANCIONADOR))){
						listaFilas.add(i);
					} 
				}catch (ParseException e){
					listaFilas.add(i);
				}
			}
		}catch (IllegalArgumentException e){
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e){
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> tipoImpuestoNotExistsByRow(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++){
				try{
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.TIPO_IMPUESTO)) && !particularValidator.existeTipoimpuesto(exc.dameCelda(i, COL_NUM.TIPO_IMPUESTO))){
						listaFilas.add(i);
					} 
				}catch (ParseException e){
					listaFilas.add(i);
				}
			}
		}catch (IllegalArgumentException e){
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e){
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> tipoDocumentoNotExistsByrow(MSVHojaExcel exc, Integer titular){
		List<Integer> listaFilas = new ArrayList<Integer>();
		int numero_columna = -1;
		
		switch(titular){
		
		case 1: 
			numero_columna = COL_NUM.TIPO_DOCUMENTO_TITULAR;
			break;
		case 2: 
			numero_columna = COL_NUM.TIPO_DOCUMENTO_TITULAR_2;
			break;
		case 3:
			numero_columna = COL_NUM.TIPO_DOCUMENTO_TITULAR_3;
			break;
		case 4:
			numero_columna = COL_NUM.TIPO_DOCUMENTO_TITULAR_4;
			break;
		}
		
		try{
			for(int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++){
				try{
					if(!Checks.esNulo(exc.dameCelda(i, numero_columna)) && !particularValidator.existeTipoDocumentoByCod(exc.dameCelda(i, numero_columna))){
						listaFilas.add(i);
					} 
				}catch (ParseException e){
					listaFilas.add(i);
				}
			}
			return listaFilas;
		}catch (IllegalArgumentException e){
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e){
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
		
	}
	
	private List<Integer> userNotGestorComercializacionByRows(MSVHojaExcel exc){		
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++){
				try{
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COMITE_SANCIONADOR)) && !particularValidator.existeGestorComercialByUsername(exc.dameCelda(i, COL_NUM.USU_GESTOR_COMERCIALIZACION))){
						listaFilas.add(i);
					} 
				}catch (ParseException e){
					listaFilas.add(i);
				}
			}
		}catch (IllegalArgumentException e){
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e){
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> codigoPrescriptorNotExistsByRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++){
				try{
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COMITE_SANCIONADOR)) && !particularValidator.existeCodigoPrescriptor(exc.dameCelda(i, COL_NUM.CODIGO_PRESCRIPTOR))){
						listaFilas.add(i);
					} 
				}catch (ParseException e){
					listaFilas.add(i);
				}
			}
		}catch (IllegalArgumentException e){
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e){
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	
	//Validador de campos obligatorios, debido a las cabeceras no se valida con el formato de db
	
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
	
}
