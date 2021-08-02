package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
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
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
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
public class MSVActualizarPerimetroActivo extends MSVExcelValidatorAbstract {
		
	//Textos con errores de validacion
	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_NOT_ACTUALIZABLE = "El estado del activo no puede actualizarse al indicado.";
	public static final String VALID_PERIMETRO_TIPO_COMERCIALIZACION = "msg.error.masivo.actualizar.perimetro.activo.tipo.comercializacion";
	public static final String VALID_PERIMETRO_RESPUESTA_SN = "En columnas cuyo nombre acaba en SN, debe indicar como valor la letra 'S' (Si) o la letra 'N' (No).";
	public static final String VALID_PERIMETRO_MOTIVO_CON_COMERCIAL = "msg.error.masivo.actualizar.perimetro.activo.motivo.con.comercial";
	public static final String VALID_PERIMETRO_MOTIVO_SIN_COMERCIAL = "msg.error.masivo.actualizar.perimetro.activo.motivo.sin.comercial";
	public static final String VALID_PERIMETRO_FUERA_RESTO_CHECKS_NO = "msg.error.masivo.actualizar.perimetro.activo.fuera.resto.checks.no";
	public static final String VALID_PERIMETRO_FORMALIZAR_SEGUN_COMERCIAL = "Si indica 'N' en la columna 'Comercializar' no puede marcar 'S' en la columna 'Formalizar'";
	public static final String VALID_PERIMETRO_DESTINO_COMERCIAL = "msg.error.masivo.actualizar.perimetro.activo.destino.comercial";
	public static final String VALID_PERIMETRO_TIPO_ALQUILER = "msg.error.masivo.actualizar.perimetro.activo.tipo.alquiler";
	public static final String VALID_PERIMETRO_FORMALIZAR_ACTIVO_COMERCIALIZABLE = "No puede indicar 'S' en la columna 'Formalizar' porque el activo no es comercializable";
	public static final String VALID_PERIMETRO_COMERCIALIZACION_OFERTAS_VIVAS = "msg.error.masivo.actualizar.perimetro.activo.ofertas.vivas";
	public static final String VALID_PERIMETRO_FORMALIZACION_EXPEDIENTE_VIVO = "msg.error.masivo.actualizar.perimetro.activo.expediente.vivo";
	public static final String VALID_DESTINO_COMERCIAL_OFERTAS_VENTA_VIVAS = "msg.error.tipo.comercializacion.ofertas.vivas.venta";
	public static final String VALID_DESTINO_COMERCIAL_OFERTAS_ALQUILER_VIVAS = "msg.error.tipo.comercializacion.ofertas.vivas.alquiler";
	public static final String VALID_ACTIVO_FINANCIERO = "msg.error.masivo.actualizar.perimetro.activo.financiero";
	public static final String VALID_ACTIVO_MATRIZ = "msg.error.masivo.actualizar.perimetro.activo.matriz";
	public static final String VALID_ACTIVO_UA = "msg.error.masivo.actualizar.perimetro.activo.ua";
	public static final String VALID_EQUIPO_GESTION = "msg.error.masivo.actualizar.perimetro.activo.equipo.gestion";
	public static final String VALID_CESION_USO = "msg.error.masivo.actualizar.perimetro.activo.cesion.de.uso";
	public static final String VALID_ALQUILER_SOCIAL = "msg.error.masivo.actualizar.perimetro.activo.alquiler.social";
	
	public static final String VALID_SEGMENTO = "msg.error.masivo.actualizar.perimetro.activo.segmento";
	public static final String VALID_SEGMENTO_CRA_SCR = "msg.error.masivo.actualizar.perimetro.activo.segmento.cartera.subcartera"; 
	public static final String VALID_SEGMENTO_MACC = "msg.error.masivo.actualizar.perimetro.activo.segmento.macc";
	public static final String VALID_PERIMETRO_MACC = "msg.error.masivo.actualizar.perimetro.activo.macc";
	public static final String VALID_PERIMETRO_MACC_SIN_SEGMENTO = "msg.error.masivo.actualizar.perimetro.activo.macc.no.segmento";
	public static final String VALID_PERIMETRO_MACC_NO_ALQUILER = "msg.error.masivo.actualizar.perimetro.activo.macc.no.alquiler";		
	public static final String VALID_ACTIVO_NO_DIVARIAN = "msg.error.masivo.actualizar.perimetro.activo.subcartera.no.divarian";
	public static final String VALID_SEGMENTO_PERIMETRO_MACC = "msg.error.masivo.actualizar.perimetro.activo.macc.no.cambio.destino";

	public static final String VALID_MOTIVO_ADMISION = "msg.error.masivo.actualizar.perimetro.activo.admision.texto.no.relleno";
	public static final String ADMISION_ERROR = "msg.error.masivo.actualizar.perimetro.activo.admision.texto.no.valido";

	public static final String ON_EFECTOS_COMERCIALIZACION_ERROR = "msg.error.masivo.actualizar.perimetro.activo.on.efectos.comercializacion.texto.no.valido";
	public static final String ON_VALOR_INTRODUCIDO = "msg.error.masivo.actualizar.perimetro.activo.on.efectos.comercializacion.texto.ya.introducido";

	
	
	public static final String VALID_MOTIVO_RELLENO_CHECK_VISIBLE = "msg.error.masivo.actializar.perimetro.activo.motivo.gestion.check.visible";
	public static final String VALID_MOTIVO_CHECK_MARCADO = "msg.error.masivo.actializar.perimetro.activo.motivo.gestion.check.ya.activado";
	public static final String VALID_SI_CHECK_MARCADO ="msg.error.masivo.actializar.perimetro.activo.motivo.gestion.check.deberia.estar.relleno";
	public static final String VALID_FECHA_VENTA_EXTERNA ="msg.error.masivo.actializar.perimetro.activo.fecha.venta.externa";
	public static final String VALID_MACC_CON_CARGAS ="msg.error.masivo.actializar.perimetro.activo.macc.con.cargas";
	public static final String VALID_ESTADO_EXPEDIENTE="msg.error.masivo.actializar.perimetro.activo.estado.expediente";
	public static final String VALID_PERIMETRO_ESTA_HAYA = "msg.error.masivo.actualizar.perimetro.activo.ya.esta.haya";
	
	
	//Reglas comercialización
	public static final String VALID_AGRUPACION_RESTRINGIDA = "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.activo.no.principa.restringida";
	public static final String VALID_VALORES_EXCLUSION= "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.valid.valores.exclusion";	
	public static final String VALID_VALORES_CAMPOS_NO_MODIFICABLE_POR_USUARIOS = "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.no.modificable.usuarios";
	public static final String VALID_ACTIVO_VENDIDO_RESERVADO_FIRMADO = "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.estados.expedientes";
	public static final String VALID_ACTIVO_VENTA_EXTERNA = "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.fecha.venta.externa";
	public static final String VALID_ACTIVO_ESTADO_PUBLICACION = "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.estado.publicacion";
	public static final String VALID_ACTIVO_NO_COMERCIALIZABLE = "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.no.comercializable";
	public static final String VALID_ACTIVO_NO_VPO = "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.vpo";
	public static final String VALID_ACTIVO_PROPIETARIO_SOCIEDAD = "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.propietario.sociedad";
	public static final String VALID_ACTIVO_DESTINO_COMERCIAL = "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.destino.comercial";
	public static final String VALID_ACTIVO_CON_CARGAS = "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.con.cargas";
	public static final String VALID_ACTIVO_ALQUILER_SOCIAL = "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.alquiler.social";
	public static final String VALID_ACTIVO_OFERTAS_PENDIENTES ="msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.activo.ofertas.pendientes";
	public static final String VALID_ACTIVO_GESTION = "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.activo.gestion";
	public static final String VALID_MOTIVO_EXCLUIDO= "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.valid.motivo.exclusion";
	public static final String VALID_SUBFASE_PUBLICACION= "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.subfase.publicado";
	public static final String VALID_DESMARCAR_SIN_ERRORES= "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.desmarcar.sin.errores";
	public static final String VALID_MOTIVO_GESTION_COMERCIAL = "msg.error.masivo.actializar.perimetro.activo.motivo.gestion.comercial.no.valido";
	public static final String VALID_MOTIVO_GESTION_COMERCIAL_RELLENO = "msg.error.masivo.actializar.perimetro.activo.motivo.gestion.comercial.relleno.no.valido";
	public static final String VALID_FASE_PUBLICACION= "msg.error.masivo.actualizar.perimetro.activo.visibilidad.gestion.comercial.fase.publicado";

	//Posición de los datos
	private	static final int DATOS_PRIMERA_FILA = 1;
	
	//Posicion fija de Columnas excel, para validaciones especiales de diccionario
	public static final int COL_NUM_ACTIVO_HAYA = 0;
	public static final int COL_NUM_EN_PERIMETRO_SN = 1;
	public static final int COL_NUM_CON_GESTION_SN = 2;
	public static final int COL_NUM_CON_COMERCIAL_SN = 4;
	public static final int COL_NUM_MOTIVO_CON_COMERCIAL = 5;
	public static final int COL_NUM_MOTIVO_SIN_COMERCIAL = 6;
	public static final int COL_NUM_TIPO_COMERCIALIZACION = 7;
	public static final int COL_NUM_DESTINO_COMERCIAL = 8;
	public static final int COL_NUM_TIPO_ALQUILER = 9;
	public static final int COL_NUM_CON_FORMALIZAR_SN = 10;
	public static final int COL_NUM_CON_PUBLICAR_SN = 12;
	public static final int COL_NUM_CON_EQUIPO_GESTION = 14;
	public static final int COL_NUM_SEGMENTO = 15;
	public static final int COL_NUM_PERIMETRO_MACC = 16;
	public static final int COL_NUM_ADMISION = 17;
	public static final int COL_NUM_TXT_MOTIVO_ADMISION = 18;
	public static final int COL_NUM_CHECK_ON_EFECTOS_COMERCIALIZACION = 19;
	public static final int COL_NUM_VISIBLE_GESTION_COMERCIAL_SN = 20;
	public static final int COL_NUM_MOTIVO_EXCLUSION_INCLUSION_PERIMETRO_VISIBLE = 21;
	public static final int COL_NUM_EXCLUSION_VALIDACIONES = 22;
	public static final int COL_NUM_FECHA_CAMBIO = 23;


	// Codigos tipo comercializacion
	public static final String CODIGO_VENTA = "01";
    public static final String CODIGO_ALQUILER_VENTA = "02";
    public static final String CODIGO_SOLO_ALQUILER = "03";
    public static final String CODIGO_ALQUILER_OPCION_COMPRA = "04";
    
    private static final Integer CHECK_VALOR_SI = 1;
    private static final Integer CHECK_VALOR_NO = 0;
    private static final Integer CHECK_NO_CAMBIAR = -1;
    
    //Codigo para 
    private static final String CODIGO_DD_TIPO_MACC  = "03";
    
    private static final String[] listaValidos = { "S", "N", "SI", "NO" };
    private static final String[] listaValidosPositivos = { "S", "SI" };

    private static final String [] listaValidosNegativos = {"N" ,"NO"};

    private static final String EDITAR_EXCLUIR_VALIDACIONES = "EDITAR_EXCLUIR_VALIDACIONES";

    private static final String[]listaCodigosNoValidosSubfasePublicacion = {"15", "14", "12"};

    protected final Log logger = LogFactory.getLog(getClass());
    
    
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
		
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	
	@Resource
    MessageService messageServices;
	
	private Integer numFilasHoja;
	
	

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getRuta());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion()));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getRuta());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
//			if (!isActiveExists(exc)){
				Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
				mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
				mapaErrores.put(messageServices.getMessage(VALID_PERIMETRO_TIPO_COMERCIALIZACION), getPerimetroTipoComerRows(exc));
				mapaErrores.put(messageServices.getMessage(VALID_EQUIPO_GESTION), getPerimetroEquipoGestionRows(exc));
				mapaErrores.put(messageServices.getMessage(VALID_PERIMETRO_MOTIVO_CON_COMERCIAL), getPerimetroConComerRows(exc));
				mapaErrores.put(messageServices.getMessage(VALID_PERIMETRO_ESTA_HAYA), getYaEnPerimetroHaya(exc)); //METER AQUI
//				mapaErrores.put(messageServices.getMessage(VALID_PERIMETRO_MOTIVO_SIN_COMERCIAL), getPerimetroSinComerRows(exc));
				mapaErrores.put(VALID_PERIMETRO_RESPUESTA_SN, getPerimetroRespuestaSNRows(exc));
				mapaErrores.put(messageServices.getMessage(VALID_PERIMETRO_FUERA_RESTO_CHECKS_NO), getFueraPerimetroIsRestoChecksNegativos(exc));
				mapaErrores.put(VALID_PERIMETRO_FORMALIZAR_SEGUN_COMERCIAL, getFormalizarConComercial(exc));
				mapaErrores.put(messageServices.getMessage(VALID_PERIMETRO_DESTINO_COMERCIAL), getPerimetroConDestinoComercial(exc));
				mapaErrores.put(messageServices.getMessage(VALID_DESTINO_COMERCIAL_OFERTAS_VENTA_VIVAS), getOfertasVentaVivasRows(exc));
				mapaErrores.put(messageServices.getMessage(VALID_DESTINO_COMERCIAL_OFERTAS_ALQUILER_VIVAS), getOfertasAlquilerVivasRows(exc));
				mapaErrores.put(messageServices.getMessage(VALID_PERIMETRO_TIPO_ALQUILER), getPerimetroTipoAlquilerRows(exc));
				mapaErrores.put(VALID_PERIMETRO_FORMALIZAR_ACTIVO_COMERCIALIZABLE, getFormalizarActivoNoComercializable(exc));
				mapaErrores.put(messageServices.getMessage(VALID_PERIMETRO_COMERCIALIZACION_OFERTAS_VIVAS), getComercializarConOfertasVivas(exc));
				mapaErrores.put(messageServices.getMessage(VALID_PERIMETRO_FORMALIZACION_EXPEDIENTE_VIVO), getFormalizarConExpedienteVivo(exc));
 				mapaErrores.put(messageServices.getMessage(VALID_ACTIVO_FINANCIERO), isActivoFinanciero(exc));
				mapaErrores.put(messageServices.getMessage(VALID_ACTIVO_MATRIZ), isActivoMatriz(exc));
				mapaErrores.put(messageServices.getMessage(VALID_ACTIVO_UA), isUA(exc));
				mapaErrores.put(messageServices.getMessage(VALID_CESION_USO), isActivoEnCesionDeUso(exc));
				mapaErrores.put(messageServices.getMessage(VALID_ALQUILER_SOCIAL), isActivoEnAlquilerSocial(exc));
				mapaErrores.put(messageServices.getMessage(VALID_SEGMENTO), esSegmentoValido(exc));
				mapaErrores.put(messageServices.getMessage(VALID_SEGMENTO_CRA_SCR), perteneceSegmentoCraScr(exc));
				mapaErrores.put(messageServices.getMessage(VALID_SEGMENTO_MACC), esSegmentoMacc(exc));
				mapaErrores.put(messageServices.getMessage(VALID_PERIMETRO_MACC), esPerimetroValido(exc));
				mapaErrores.put(messageServices.getMessage(VALID_PERIMETRO_MACC_SIN_SEGMENTO), esSegmentoInformado(exc));
				mapaErrores.put(messageServices.getMessage(VALID_PERIMETRO_MACC_NO_ALQUILER), esPerimetroMaccDestinoAlquiler(exc));				
				mapaErrores.put(messageServices.getMessage(VALID_ACTIVO_NO_DIVARIAN), esSubcarteraDivarian(exc));
				mapaErrores.put(messageServices.getMessage(VALID_SEGMENTO_PERIMETRO_MACC), esPerimetorYSegmentoMACC(exc));
				mapaErrores.put(messageServices.getMessage(VALID_MOTIVO_ADMISION), estaRellenoCampoAdmision(exc));
				mapaErrores.put(messageServices.getMessage(ON_VALOR_INTRODUCIDO), isActivoObraNuevaConEfectosComercializacion(exc));
				mapaErrores.put(messageServices.getMessage(ON_EFECTOS_COMERCIALIZACION_ERROR), isBooleanValidator(exc, COL_NUM_CHECK_ON_EFECTOS_COMERCIALIZACION));
				mapaErrores.put(messageServices.getMessage(ADMISION_ERROR), isBooleanValidator(exc, COL_NUM_ADMISION));	

	
				this.erroresComercializacion(exc,mapaErrores);

				//ESTA DEBE SER LA ÚLTIMA SIEMPRE (sacarTodosLosErroresJerarquicos)
				this.sacarTodosLosErroresJerarquicos(exc, mapaErrores);

				for (Entry<String, List<Integer>> registro : mapaErrores.entrySet()) {
					if (!registro.getValue().isEmpty()) {
						dtoValidacionContenido.setFicheroTieneErrores(true);
						dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
						break;
					}
				}				
		}
		exc.cerrar();
		
		
		return dtoValidacionContenido;
	}


	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda, MSVBusinessValidators contentValidators) {
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

	/**
	 * Realiza validaciones multivalor con diferentes valores de la fila
	 * @param mapaDatos
	 * @param compositeValidators
	 * @return
	 */
	protected ResultadoValidacion validaContenidoFila(
			Map<String, String> mapaDatos,
			List<String> listaCabeceras,
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

	
	@SuppressWarnings("unused")
	private boolean isActiveExists(MSVHojaExcel exc){
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, 0)))
					return false;
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return true;
	}
	
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.existeActivo(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				} catch (ParseException e) {
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
	
	
	private List<Integer> getPerimetroTipoComerRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro de perimetro tiene un Tipo de comercializacion valido.
		// Codigos validos 00 (ninguno) 01 (Singular) 02 (Retail) 
		try{
			String codigoTipoComercial = null;
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_TIPO_COMERCIALIZACION)))
						codigoTipoComercial = exc.dameCelda(i, COL_NUM_TIPO_COMERCIALIZACION).substring(0, 2);
					else 
						codigoTipoComercial = null;
				} catch (ParseException e) {
					listaFilas.add(i);
				}
				
				if(!(Checks.esNulo(codigoTipoComercial) || "01".equals(codigoTipoComercial) || "02".equals(codigoTipoComercial)) )
					listaFilas.add(i);
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	
	private List<Integer> getPerimetroEquipoGestionRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro de perimetro tiene un eqipo gestion valido.
		try{
			String codigoEquipoGestion = null;
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_CON_EQUIPO_GESTION)))
						codigoEquipoGestion = exc.dameCelda(i, COL_NUM_CON_EQUIPO_GESTION).substring(0, 2);
					else 
						codigoEquipoGestion = null;
				} catch (ParseException e) {
					listaFilas.add(i);
				}
				
				if(!(Checks.esNulo(codigoEquipoGestion) || particularValidator.perteneceADiccionarioEquipoGestion(codigoEquipoGestion)) )
					listaFilas.add(i);
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getPerimetroConComerRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro de perimetro tiene un motivo "con" comercializacion valido.
		// Codigos validos 00 (ninguno) 01 (ordinario) 02 (pdv) 03 (performing) 
		try{
			String codigoMotivoConComercial = null;
			for(int i=1; i<this.numFilasHoja;i++){

				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_MOTIVO_CON_COMERCIAL)))
						codigoMotivoConComercial = exc.dameCelda(i, COL_NUM_MOTIVO_CON_COMERCIAL).substring(0, 2);
					else 
						codigoMotivoConComercial = null;
				} catch (ParseException e) {
					listaFilas.add(i);
				}
				
				if(!(Checks.esNulo(codigoMotivoConComercial) || "01".equals(codigoMotivoConComercial) || "02".equals(codigoMotivoConComercial) || "03".equals(codigoMotivoConComercial) ) )
					listaFilas.add(i);
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	//por programar
	private List<Integer> getYaEnPerimetroHaya(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		String comprobarHaya = null;
		try {
			
			for(int i=1; i<this.numFilasHoja;i++){
				comprobarHaya = exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).trim().toUpperCase();
				if ("S".equals(comprobarHaya)) {
					if (particularValidator.incluidoActivoIdOrigenBBVA(exc.dameCelda(i, COL_NUM_ACTIVO_HAYA))) {
						listaFilas.add(i);
					}
					
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	@SuppressWarnings("unused")
	private List<Integer> getPerimetroSinComerRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro de perimetro tiene un motivo "sin" comercializacion valido.
		// Codigos validos 00 (ninguno) 01 (V.P.O Auto) 02 (perdido) 03 (desistido) ... 63 (no comer. pte. propuesta) 
		try{
			Integer codigoMotivoSinComercial = 0;
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					codigoMotivoSinComercial = exc.dameCelda(i, COL_NUM_MOTIVO_SIN_COMERCIAL).isEmpty() ? Integer.valueOf(0) :
						Integer.valueOf(exc.dameCelda(i, COL_NUM_MOTIVO_SIN_COMERCIAL));
				} catch (ParseException e) {
					listaFilas.add(i);
				}
				if(codigoMotivoSinComercial < 0 || codigoMotivoSinComercial > 63)
					listaFilas.add(i);
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getPerimetroRespuestaSNRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		// Validacion que evalua si el registro de perimetro tiene columnas con una respuesta correcta de SN.
		// Codigos validos S (Si) N (No) 
		try{
			String valorEnPerimetro = "-";
			String valorConGestion = "-";
			String valorConComercial = "-";
			String valorConFormalizar = "-";
			String valorConPublicar = "-";

			for(int i=1; i<this.numFilasHoja;i++){
				
				//Columnas EN_PERIMETRO, CON_GESTION, CON_COMERCIAL, CON_FORMALIZAR, CON_PUBLICAR
				// Si la celda no tiene valor, debe validarse correctamente
				// Si la S o la N van en minusculas, deben ser valores validos
				// No deben tenerse en cuenta espacios en blanco
				try {
					valorEnPerimetro = exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).trim().toUpperCase();
					valorConGestion = exc.dameCelda(i, COL_NUM_CON_GESTION_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_GESTION_SN).trim().toUpperCase();
					valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();
					valorConFormalizar = exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).trim().toUpperCase();
					valorConPublicar = exc.dameCelda(i, COL_NUM_CON_PUBLICAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_PUBLICAR_SN).trim().toUpperCase();
					
					// Valida valores correctos de los campos S/N/<nulo>
					if(!("S".equals(valorEnPerimetro) || "N".equals(valorEnPerimetro) || "-".equals(valorEnPerimetro))
							|| !("S".equals(valorConGestion) || "N".equals(valorConGestion) || "-".equals(valorConGestion))
							|| !("S".equals(valorConComercial) || "N".equals(valorConComercial) || "-".equals(valorConComercial))
							|| !("S".equals(valorConFormalizar) || "N".equals(valorConFormalizar) || "-".equals(valorConFormalizar))
							|| !("S".equals(valorConPublicar) || "N".equals(valorConPublicar) || "-".equals(valorConPublicar))
							)
						listaFilas.add(i);
				} catch (ParseException e) {
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
	
	private List<Integer> getFueraPerimetroIsRestoChecksNegativos(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro indica que NO esta dentro del perimetro, ha de comprobar
		// que el resto de CHECKS no esten activados afirmativamente
		try{
			String valorEnPerimetro = "-";
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					valorEnPerimetro = exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).trim().toUpperCase();
					if("N".equals(valorEnPerimetro) || ("-".equals(valorEnPerimetro) && !particularValidator.esActivoIncluidoPerimetro(exc.dameCelda(i, 0)))) {
						
						String valorConGestion = exc.dameCelda(i, COL_NUM_CON_GESTION_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_GESTION_SN).trim().toUpperCase();
						String valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();
						String valorConFormalizar = exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).trim().toUpperCase();
						String valorConPublicar = exc.dameCelda(i, COL_NUM_CON_PUBLICAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_PUBLICAR_SN).trim().toUpperCase();

						if("S".equals(valorConGestion) || "S".equals(valorConComercial) || "S".equals(valorConFormalizar) || "S".equals(valorConPublicar))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
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
	
	private List<Integer> getFormalizarConComercial(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		/* Validacion que evalua en el caso de poner valor S/N en Formalizar cummpla con: 
		 * - Si Formalizar viene informado, comercializar debe venir informado
		 * - Si Comercializar(N) ==> Formalizar(N)
		 */
		try{
			String valorConFormalizar = "-";
			for(int i=1; i<this.numFilasHoja;i++){
				
				try {
					valorConFormalizar = exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).trim().toUpperCase();

					if(!"-".equals(valorConFormalizar)) {
						
						String valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();				
						if("N".equals(valorConComercial) && "S".equals(valorConFormalizar) )
							listaFilas.add(i);
					}
				} catch (ParseException e) {
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
	
	private List<Integer> getPerimetroConDestinoComercial(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro de perimetro tiene un motivo "con" comercializacion valido.
		// Codigos validos 00 (ninguno) 01 (Venta) 02 (Alquiler y venta) 03 (Alquiler) 
		try{
			String codigoDestinoComercial = null;
			for(int i=1; i<this.numFilasHoja;i++){

				try {

					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL))) {
						codigoDestinoComercial = exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL).substring(0, 2);
					} else {
						codigoDestinoComercial = null;
					}

					if(!(Checks.esNulo(codigoDestinoComercial) || "01".equals(codigoDestinoComercial) || "02".equals(codigoDestinoComercial) || "03".equals(codigoDestinoComercial) ) ) {
						listaFilas.add(i);
					}

				} catch (ParseException e) {
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
	
	private List<Integer> getPerimetroTipoAlquilerRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el registro de perimetro tiene un motivo "con" comercializacion valido.
		// Codigos validos 00 (ninguno) 01 (Ordinario) 02 (Con opción a compra) 03 (Fondo social) 04 (Especial) 
		try{
			String codigoTipoAlquiler = null;
			for(int i=1; i<this.numFilasHoja;i++){

				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_TIPO_ALQUILER)))
						codigoTipoAlquiler = exc.dameCelda(i, COL_NUM_TIPO_ALQUILER).substring(0, 2);
					else 
						codigoTipoAlquiler = null;
				} catch (ParseException e) {
					listaFilas.add(i);
				}
				
				if(!(Checks.esNulo(codigoTipoAlquiler) || "01".equals(codigoTipoAlquiler) || "02".equals(codigoTipoAlquiler) || "03".equals(codigoTipoAlquiler) || "04".equals(codigoTipoAlquiler) ) )
					listaFilas.add(i);
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getFormalizarActivoNoComercializable(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		/* Validacion que evalua en el caso de poner valor S en Formalizar y no informar Comercializar.
		 * Comprueba que el activo sea comercializable para poder activar Formalizar.
		 */
		try{
			String valorConFormalizar = "-";
			for(int i=1; i<this.numFilasHoja;i++){
				if(!Checks.esNulo(exc.dameCelda(i,COL_NUM_VISIBLE_GESTION_COMERCIAL_SN))) {
				
				try {
					valorConFormalizar = exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).trim().toUpperCase();
					if("S".equals(valorConFormalizar)) {
						
						String valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();				
						if("-".equals(valorConComercial) ) {
							
							if(particularValidator.isActivoNoComercializable(exc.dameCelda(i, 0)))
								listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getComercializarConOfertasVivas(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		/* Validacion que evalua en el caso de poner valor N en Comercializar (o en Perimetro).
		 * Comprueba que el activo NO tenga ofertas vivas, para poder quitarlo de comercialización.
		 */
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();	
					String valorEnPerimetro = exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).trim().toUpperCase();
					if("N".equals(valorConComercial) || "N".equals(valorEnPerimetro)) {
						
						if(particularValidator.existeActivoConOfertaViva(exc.dameCelda(i, 0)))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
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
	
	private List<Integer> getFormalizarConExpedienteVivo(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		/* Validacion que evalua en el caso de poner valor N en Formalizar (o en Comercializar, o en Perimetro)
		 * Comprueba que el activo NO tenga un expediente comercial vivo (con tareas activas), para poder sacarlo de formalización.
		 */
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String celdaExcluirValidaciones = exc.dameCelda(i, COL_NUM_EXCLUSION_VALIDACIONES);
					if((!Checks.esNulo(celdaExcluirValidaciones) && Arrays.asList(listaValidosNegativos).contains(celdaExcluirValidaciones.toUpperCase()))) {
					String valorConFormalizar= exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).trim().toUpperCase();
					String valorEnPerimetro = exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).trim().toUpperCase();
					String valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();	
					if("N".equals(valorConFormalizar) || "N".equals(valorEnPerimetro) || "N".equals(valorConComercial)) {
						
						if(particularValidator.existeActivoConExpedienteComercialVivo(exc.dameCelda(i, 0)))
							listaFilas.add(i);
					}
					}
				} catch (ParseException e) {
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


	private List<Integer> getOfertasVentaVivasRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		/**
		 * 		Validará que no se intenté cambiar de venta a alquiler un activo que tenga ofertas
		 *		de tipo venta vivas
		 */
		try{
			String codigoDestinoComercial = null;
			String codigoDestinoComercialActual = null;
			for(int i=1; i<this.numFilasHoja;i++){

				try {

					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL))) {
						codigoDestinoComercial = exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL).substring(0, 2);
					} else {
						codigoDestinoComercial = null;
					}

				  	codigoDestinoComercialActual = particularValidator.getCodigoDestinoComercialByNumActivo(exc.dameCelda(i, COL_NUM_ACTIVO_HAYA));

					if (!Checks.esNulo(codigoDestinoComercialActual) && !Checks.esNulo(codigoDestinoComercial)
							&& CODIGO_SOLO_ALQUILER.equals(codigoDestinoComercial)
							&& (CODIGO_VENTA.equals(codigoDestinoComercialActual)
									|| CODIGO_ALQUILER_VENTA.equals(codigoDestinoComercialActual))
							&& particularValidator.existeActivoConOfertaVentaViva("" + exc.dameCelda(i, COL_NUM_ACTIVO_HAYA))) {
						listaFilas.add(i);
					}

				} catch (ParseException e) {
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


	private List<Integer> getOfertasAlquilerVivasRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		/**
		 * 		Validará que no se intenté cambiar de alquiler a venta un activo que tenga ofertas
		 *		de tipo alquiler vivas
		 */
		try{
			String codigoDestinoComercial = null;
			String codigoDestinoComercialActual = null;
			for(int i=1; i<this.numFilasHoja;i++){

				try {

					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL))) {
						codigoDestinoComercial = exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL).substring(0, 2);
					} else {
						codigoDestinoComercial = null;
					}

				  	codigoDestinoComercialActual = particularValidator.getCodigoDestinoComercialByNumActivo(exc.dameCelda(i, COL_NUM_ACTIVO_HAYA));

					if (!Checks.esNulo(codigoDestinoComercialActual) && !Checks.esNulo(codigoDestinoComercial)
							&& CODIGO_VENTA.equals(codigoDestinoComercial)
							&& (CODIGO_SOLO_ALQUILER.equals(codigoDestinoComercialActual)
									|| CODIGO_ALQUILER_VENTA.equals(codigoDestinoComercialActual))
							&& particularValidator.existeActivoConOfertaAlquilerViva("" + exc.dameCelda(i, COL_NUM_ACTIVO_HAYA))) {
						listaFilas.add(i);
					}

				} catch (ParseException e) {
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
	
	private List<Integer> isActivoFinanciero(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.isActivoFinanciero(exc.dameCelda(i, COL_NUM_ACTIVO_HAYA)) && CHECK_VALOR_SI.equals(getCheckValue(exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN))))
						listaFilas.add(i);
				} catch (ParseException e) {
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

	private Integer getCheckValue(String cellValue){
		if(!Checks.esNulo(cellValue)){
			if("S".equalsIgnoreCase(cellValue) || String.valueOf(CHECK_VALOR_SI).equalsIgnoreCase(cellValue))
				return CHECK_VALOR_SI;
			else
				return CHECK_VALOR_NO;
		}
		return CHECK_NO_CAMBIAR;	
	}
	
	private List<Integer> isActivoMatriz(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.isActivoMatriz(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				} catch (ParseException e) {
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
	
	private List<Integer> isUA(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.isUA(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				} catch (ParseException e) {
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
	
	private List<Integer> isActivoEnCesionDeUso(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.isActivoEnCesionDeUso(exc.dameCelda(i, 0)))
						listaFilas.add(i); 
				} catch (ParseException e) {
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
	private List<Integer> isActivoEnAlquilerSocial(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String celdaExclusion = exc.dameCelda(i, COL_NUM_EXCLUSION_VALIDACIONES);
					if(Arrays.asList(listaValidosNegativos).contains(celdaExclusion.toUpperCase())) {
					if(particularValidator.isActivoEnPerimetroAlquilerSocial(exc.dameCelda(i, 0)))
						listaFilas.add(i);
					}
				} catch (ParseException e) {
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
	
	private List<Integer> esSegmentoValido(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				String celda = exc.dameCelda(i, COL_NUM_SEGMENTO);
				if (!Checks.esNulo(celda) && !particularValidator.esSegmentoValido(celda))
					listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}

	private List<Integer> esPerimetroValido(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaSN = { "SI", "S", "NO", "N" };
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				String celda = exc.dameCelda(i, COL_NUM_PERIMETRO_MACC);
				if (!Checks.esNulo(celda) && !Arrays.asList(listaSN).contains(celda.toUpperCase()))
					listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}

	private List<Integer> perteneceSegmentoCraScr(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
	
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				String celdaActivo = exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);		
				String celdaSegmento = exc.dameCelda(i, COL_NUM_SEGMENTO);
				
				if(celdaSegmento != null && !celdaSegmento.isEmpty() && !particularValidator.perteneceSegmentoCraScr(celdaSegmento, celdaActivo)) {
					listaFilas.add(i);
				}
			} catch (Exception e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	private List<Integer> esSubcarteraDivarian(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				String celdaActivo = exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);
				String celdaMacc = exc.dameCelda(i, COL_NUM_PERIMETRO_MACC);
				if (!Checks.esNulo(celdaMacc) && !particularValidator.esSubcarteraDivarian(celdaActivo))
					listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	private List<Integer> esSegmentoMacc(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaSi = { "SI", "S"};
		final String DD_TIPO_MACC = "03";
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				String celdaSegmento = exc.dameCelda(i, COL_NUM_SEGMENTO);
				String celdaMacc = exc.dameCelda(i, COL_NUM_PERIMETRO_MACC);
				if (!Checks.esNulo(celdaMacc) 
						&& Arrays.asList(listaSi).contains(celdaMacc.toUpperCase())
						&& !Checks.esNulo(celdaSegmento) && !DD_TIPO_MACC.equals(celdaSegmento)	)
					listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	private List<Integer> esPerimetroMaccDestinoAlquiler(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaSi = { "SI", "S" };
		final String DD_DESTINO_ALQUILER = "03";
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				String celdaDestinoComercial = exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL);
				String celdaMacc = exc.dameCelda(i, COL_NUM_PERIMETRO_MACC);
				String celdaActivo = exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);

				if (!Checks.esNulo(celdaMacc) && Arrays.asList(listaSi).contains(celdaMacc.toUpperCase())
						&&(!Checks.esNulo(celdaDestinoComercial) && !DD_DESTINO_ALQUILER.equals(celdaDestinoComercial)
								|| Checks.esNulo(celdaDestinoComercial) && !particularValidator.activoConDestinoComercialAlquiler(celdaActivo))) {
					listaFilas.add(i);				
				}
				
			} catch (Exception e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	private List<Integer> esSegmentoInformado(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaNo = { "NO", "N"};	
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				String celdaSegmento = exc.dameCelda(i, COL_NUM_SEGMENTO);
				String celdaMacc = exc.dameCelda(i, COL_NUM_PERIMETRO_MACC);
				String celdaActivo = exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);
				if (!Checks.esNulo(celdaMacc) 
						&& Arrays.asList(listaNo).contains(celdaMacc.toUpperCase())
						&& Checks.esNulo(celdaSegmento)	
						&& Boolean.FALSE.equals((particularValidator.esSubcarteraApple(celdaActivo))))
					listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	private List<Integer> esPerimetorYSegmentoMACC(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaSi = { "SI", "S" };
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				String celdaDestinoComercial = exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL);
				String celdaMacc = exc.dameCelda(i, COL_NUM_PERIMETRO_MACC);
				String celdaActivo = exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);
				String celdaSegmento = exc.dameCelda(i, COL_NUM_SEGMENTO);
				
				if (!Checks.esNulo(celdaMacc) && Arrays.asList(listaSi).contains(celdaMacc.toUpperCase())
						&&(!Checks.esNulo(celdaDestinoComercial) && !Checks.esNulo(celdaSegmento) && !Checks.esNulo(celdaActivo)
						&& CODIGO_DD_TIPO_MACC.equals(celdaSegmento) && !particularValidator.aCambiadoDestinoComercial(celdaActivo,celdaDestinoComercial))
						){
					listaFilas.add(i);				
				}
				
			} catch (Exception e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	private List<Integer> estaRellenoCampoAdmision(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				String celdaAdmision = exc.dameCelda(i, COL_NUM_ADMISION);
				String celdaMotivoAdmision = exc.dameCelda(i, COL_NUM_TXT_MOTIVO_ADMISION);
				
				if (!Checks.esNulo(celdaAdmision) && Arrays.asList(listaValidosPositivos).contains(celdaAdmision.toUpperCase())
						&&(Checks.esNulo(celdaMotivoAdmision))
					){
					listaFilas.add(i);				
				}
				
			} catch (Exception e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}
	
	private List<Integer> isBooleanValidator(MSVHojaExcel exc, Integer col){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String celda = exc.dameCelda(i, col);
					if(!Checks.esNulo(celda) && !Arrays.asList(listaValidos).contains(celda.toUpperCase()))
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
	

	
	
	private void modificarMapaErrores(Map<String,List<Integer>> mapaErrores, int fila, List<String> listaErrores) {
		List<Integer> aux = new ArrayList<Integer>();
		StringBuilder sb = new StringBuilder("");
		aux.add(fila);
		for (String error : listaErrores) {
			sb.append(error);
		}
		String key = sb.toString();
		if(mapaErrores.containsKey(key)) {
			mapaErrores.get(key).add(fila);
		}else {
			mapaErrores.put(key, aux);
		}
	}
	
	private void sacarTodosLosErroresJerarquicos(MSVHojaExcel exc, Map<String,List<Integer>> mapaErrores) {
		List<String> listaErroresCompleta = new ArrayList<String>(); 
		boolean pararComprobaciones = false;	
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		boolean usuHasFunction = particularValidator.userHasFunction(EDITAR_EXCLUIR_VALIDACIONES,usu.getId());
		List<String> listaCodSubfase = new ArrayList<String>();
		listaCodSubfase.addAll( Arrays.asList(listaCodigosNoValidosSubfasePublicacion));
		//List<String> listaCodSubfase = Arrays.asList(listaCodigosNoValidosSubfasePublicacion);
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				listaCodSubfase.clear();
				listaCodSubfase.addAll( Arrays.asList(listaCodigosNoValidosSubfasePublicacion));
				try {
					String visibleGestionComercial = exc.dameCelda(i,COL_NUM_VISIBLE_GESTION_COMERCIAL_SN);
					String celdaExcluirValidaciones = exc.dameCelda(i, COL_NUM_EXCLUSION_VALIDACIONES);
					String fechaCambio = exc.dameCelda(i,COL_NUM_FECHA_CAMBIO);
					String motivoExclusionValidaciones = exc.dameCelda(i, COL_NUM_MOTIVO_EXCLUSION_INCLUSION_PERIMETRO_VISIBLE);
					
				
					String activo= exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);
					List<String> listaErroresParaMarcar = new ArrayList<String>();
					
					if(!Checks.esNulo(celdaExcluirValidaciones) || !Checks.esNulo(visibleGestionComercial) || !Checks.esNulo(fechaCambio) || !Checks.esNulo(motivoExclusionValidaciones) ) {
						if(!usuHasFunction) {
							listaErroresCompleta.add(messageServices.getMessage(VALID_VALORES_CAMPOS_NO_MODIFICABLE_POR_USUARIOS));
							pararComprobaciones = true;
						}
						if(!pararComprobaciones) {
							if(particularValidator.activoEnAgrupacionRestringida(Long.parseLong(activo)) && !particularValidator.activoPrincipalEnAgrupacionRestringida(activo)) {
								listaErroresCompleta.add(messageServices.getMessage(VALID_AGRUPACION_RESTRINGIDA));
							}
							if(Checks.esNulo(visibleGestionComercial) && !Checks.esNulo(fechaCambio)) {
								listaErroresCompleta.add(messageServices.getMessage(VALID_SI_CHECK_MARCADO));
							}
							if(!Checks.esNulo(motivoExclusionValidaciones) && !particularValidator.existeCodigoMotivoAdmision(motivoExclusionValidaciones)) {
								listaErroresCompleta.add(messageServices.getMessage(VALID_MOTIVO_GESTION_COMERCIAL));
							}
							if(!Checks.esNulo(motivoExclusionValidaciones) && Checks.esNulo(celdaExcluirValidaciones)) {
								listaErroresCompleta.add(messageServices.getMessage(VALID_MOTIVO_GESTION_COMERCIAL_RELLENO));
							}
						}
					}
					if(!Checks.esNulo(celdaExcluirValidaciones) && !pararComprobaciones) {
						if(!Arrays.asList(listaValidos).contains(celdaExcluirValidaciones.toUpperCase())) {
							listaErroresCompleta.add(messageServices.getMessage(VALID_VALORES_EXCLUSION));
						}
						if(Arrays.asList(listaValidosPositivos).contains(celdaExcluirValidaciones.toUpperCase()) && Checks.esNulo(motivoExclusionValidaciones)) {
							listaErroresCompleta.add(messageServices.getMessage(VALID_MOTIVO_RELLENO_CHECK_VISIBLE));
						}
						
					}
					
					if(!Checks.esNulo(visibleGestionComercial) && !pararComprobaciones) {
						Boolean excluirValidaciones = null;
						if(!Arrays.asList(listaValidos).contains(visibleGestionComercial.toUpperCase())) {
							listaErroresCompleta.add(messageServices.getMessage(VALID_VALORES_EXCLUSION));
						}
						if(Checks.esNulo(celdaExcluirValidaciones)) {
							excluirValidaciones= particularValidator.getExcluirValidaciones(activo);
						}
						if(Arrays.asList(listaValidosNegativos).contains(celdaExcluirValidaciones.toUpperCase()) || (excluirValidaciones != null && !excluirValidaciones)) {
							if(particularValidator.isActivoSareb(activo)) {
								String comercializar = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN);
								if(!Checks.esNulo(comercializar)) {
									boolean comercializarBool = false;
									boolean visibilidadBool = false;
									if(Arrays.asList(listaValidosPositivos).contains(comercializar)) {
										comercializarBool = true;
									}
									if(Arrays.asList(listaValidosPositivos).contains(visibleGestionComercial)) {
										visibilidadBool = true;
									}
									if(comercializarBool != visibilidadBool) {
										listaErroresParaMarcar.add(messageServices.getMessage(VALID_ACTIVO_NO_COMERCIALIZABLE));
									}
								}else if(!particularValidator.aplicaComercializar(activo)) {
									listaErroresParaMarcar.add(messageServices.getMessage(VALID_ACTIVO_NO_COMERCIALIZABLE));
								}
							}else if(!particularValidator.isActivoPublicadoDependiendoSuTipoComercializacion(activo)) {
								if(particularValidator.isActivoDestinoComercialSoloAlquiler(activo)) {
									listaErroresParaMarcar.add(messageServices.getMessage(VALID_ACTIVO_ESTADO_PUBLICACION));
									pararComprobaciones = true;
								}
								if(!pararComprobaciones) {
									if(particularValidator.isActivoBankia(activo)) {
										listaErroresParaMarcar.add(messageServices.getMessage(VALID_ACTIVO_ESTADO_PUBLICACION));
										pararComprobaciones = true;	
									}else if(particularValidator.activoBBVAPerteneceSociedadParticipada(activo)) {
										listaErroresParaMarcar.add(messageServices.getMessage(VALID_ACTIVO_PROPIETARIO_SOCIEDAD));
									}else if(particularValidator.isActivoCajamar(activo)) {
										if(particularValidator.isCheckVisibleGestionComercial(activo)) {
											listaErroresParaMarcar.add(messageServices.getMessage(VALID_ACTIVO_GESTION));
										}
										if(particularValidator.estadoPublicacionCajamarPerteneceVPOYDistintoPublicado(activo)) {
											listaErroresParaMarcar.add(messageServices.getMessage(VALID_ACTIVO_NO_VPO));
										}
									}
									
								}
								if(!pararComprobaciones) {
									if(!particularValidator.tieneFechaVentaExterna(activo)){
										listaErroresParaMarcar.add(messageServices.getMessage(VALID_ACTIVO_VENTA_EXTERNA));
									}
									
									if(!particularValidator.aplicaComercializar(activo)) {
										listaErroresParaMarcar.add(messageServices.getMessage(VALID_ACTIVO_NO_COMERCIALIZABLE));
									}
									
									if(particularValidator.isActivoEnPerimetroAlquilerSocial(activo)) {
										listaErroresParaMarcar.add(messageServices.getMessage(VALID_ACTIVO_ALQUILER_SOCIAL));
									}
									
									boolean activoCerberus = particularValidator.isActivoCerberus(activo);
									if(activoCerberus) {
										listaCodSubfase.add("28");
										if(!particularValidator.validacionSubfasePublicacion(activo, listaCodSubfase)) {
											listaErroresParaMarcar.add(messageServices.getMessage(VALID_SUBFASE_PUBLICACION));
										}
									}else {
										
										if(!particularValidator.validacionSubfasePublicacion(activo, listaCodSubfase)) {
											listaErroresParaMarcar.add(messageServices.getMessage(VALID_SUBFASE_PUBLICACION));
										}
									}
									
									if(particularValidator.estadoExpedienteComercial(activo)) {
										listaErroresParaMarcar.add(messageServices.getMessage(VALID_ACTIVO_VENDIDO_RESERVADO_FIRMADO));
									}
									if(activoCerberus && particularValidator.tieneVigenteFasePublicacionIII(activo)) {
										listaErroresParaMarcar.add(messageServices.getMessage(VALID_FASE_PUBLICACION));
									}
								}
							}
	
							if(Arrays.asList(listaValidosNegativos).contains(visibleGestionComercial)) {  
								if(listaErroresParaMarcar.isEmpty()) {
									listaErroresParaMarcar.add(messageServices.getMessage(VALID_DESMARCAR_SIN_ERRORES));
								}else {
									listaErroresParaMarcar.clear();
								}
								if(!particularValidator.activoConOfertasTramitadas(activo)) {
									listaErroresCompleta.add(messageServices.getMessage(VALID_ACTIVO_OFERTAS_PENDIENTES));
								}
							}
							
							listaErroresCompleta.addAll(listaErroresParaMarcar);
						}	
					}
					
					
				}catch (ParseException e) {
					listaErroresCompleta.add(e.getMessage());
				}
				if(!listaErroresCompleta.isEmpty()) {
					this.modificarMapaErrores(mapaErrores, i, listaErroresCompleta);
				}
				
				listaErroresCompleta.clear();
				pararComprobaciones = false;
			}

		}catch (IllegalArgumentException e) {
			this.sacarErroresCatchGenericos(e.getMessage(), mapaErrores);
			e.printStackTrace();
		} catch (IOException e) {
			this.sacarErroresCatchGenericos(e.getMessage(), mapaErrores);
			e.printStackTrace();
		}
	}
	


	
	
	private List<Integer> isActivoObraNuevaConEfectosComercializacion(MSVHojaExcel exc){
				
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String celdaCOEfectos = exc.dameCelda(i, COL_NUM_CHECK_ON_EFECTOS_COMERCIALIZACION);
					String celdaActivo = exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);
					if(!Checks.esNulo(celdaCOEfectos) && Arrays.asList(listaValidos).contains(celdaCOEfectos.toUpperCase())){
						if(particularValidator.existeActivoConONMarcadoSi(celdaActivo)							
									&& Arrays.asList(listaValidosPositivos).contains(celdaCOEfectos.toUpperCase())) {
							listaFilas.add(i);
						}else if(!particularValidator.existeActivoConONMarcadoSi(celdaActivo)							
								&& Arrays.asList(listaValidosNegativos).contains(celdaCOEfectos.toUpperCase())) {
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
		


	private void sacarErroresCatchGenericos(String error, Map<String,List<Integer>> mapaErrores ) {
		List<String> errorCatch = new ArrayList<String>();
		errorCatch.add(error);
		this.modificarMapaErrores(mapaErrores, 0, errorCatch);
	}
	
	private void erroresComercializacion(MSVHojaExcel exc, Map<String,List<Integer>> mapaErrores) {
		List<String> listaErroresCompleta = new ArrayList<String>(); 
		
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String activo= exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);
					String comercializar = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN);
					if(!Checks.esNulo(comercializar) && particularValidator.isActivoSareb(activo) && particularValidator.activoEnAgrupacionRestringida(Long.parseLong(activo)) 
					&& !particularValidator.activoPrincipalEnAgrupacionRestringida(activo)) {
						listaErroresCompleta.add(messageServices.getMessage(VALID_AGRUPACION_RESTRINGIDA));
					}
				}catch (ParseException e) {
					listaErroresCompleta.add(e.getMessage());
				}
				
				if(!listaErroresCompleta.isEmpty()) {
					this.modificarMapaErrores(mapaErrores, i, listaErroresCompleta);
				}
				
				listaErroresCompleta.clear();
			}
			
		}catch (IllegalArgumentException e) {
			this.sacarErroresCatchGenericos(e.getMessage(), mapaErrores);
			e.printStackTrace();
		} catch (IOException e) {
			this.sacarErroresCatchGenericos(e.getMessage(), mapaErrores);
			e.printStackTrace();
		}
	}
	
}		

