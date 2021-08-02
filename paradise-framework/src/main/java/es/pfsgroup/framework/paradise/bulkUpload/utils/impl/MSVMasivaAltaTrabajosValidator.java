package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import es.pfsgroup.commons.utils.HQLBuilder;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import bsh.ParseException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.adapter.TareaAdapter;
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
import es.pfsgroup.framework.paradise.http.client.HttpSimpleGetRequest;
import net.sf.json.JSONObject;


@Component
public class MSVMasivaAltaTrabajosValidator extends MSVExcelValidatorAbstract {

		
	//
	private final String VALIDAR_FILA_EXCEPTION = "msg.error.masivo.gestores.exception";
	private final String ACTIVO_NO_EXISTE = "msg.error.masivo.gestores.activo.no.existe";
	private final String ACTIVO_NO_ESTA_RELLENO = "msg.error.masivo.gestores.api.cambios.activo";
	private final String ACTIVO_FUERA_PERIMETRO="msg.error.masivo.alta.trabajos.perimetro.marcado";
	private final String PROVEEDOR_FUERA_CARTERA="msg.error.masivo.alta.trabajos.proveedor.cartera.activo";
	private final String NO_ES_PROVEEDOR_CONTACTO="msg.error.masivo.alta.trabajos.proveedor.contacto";
	private final String NO_EXISTE_TAREA="msg.error.masivo.alta.trabajos.id.tarea";
	private final String NO_ES_COD_TARIFA="msg.error.masivo.alta.trabajos.codigo.tarifa";
	private final String NO_ES_USUARIO_VALIDO="msg.error.masivo.gestores.usuario.no.corresponde";
	private final String TRABAJO_NO_EXISTE="msg.error.masivo.alta.trabajos.codigo.trabajo.erroneo";
	private final String SUBTRABAJO_NO_EXISTE="msg.error.masivo.alta.trabajos.codigo.subtrabajo.erroneo";
	private final String INC_REL_TRABAJO_SUBTRABAJO="msg.error.masivo.alta.trabajos.relacion.trabajo.subtrabajo";
	private final String TRABAJO_NO_RELLENO="msg.error.masivo.alta.trabajos.trabajo.vacio";
	private final String SUBTRABAJO_NO_RELLENO="msg.error.masivo.alta.trabajos.subtrabajo.vacio";
	private final String PROVEEDOR_NO_RELLENO="msg.error.masivo.alta.trabajos.proveedor.vacio";
	private final String PROVEEDOR_CONTACTO_NO_RELLENO="msg.error.masivo.alta.trabajos.proveedor.contacto.vacio";
	private final String AREA_PETICIONARIA_NO_RELLENO="msg.error.masivo.alta.trabajos.area.peticionaria.vacio";
	private final String APLICA_COMITE_NO_RELLENO="msg.error.masivo.alta.trabajos.aplica.comite.vacio";
	private final String NO_RELAC_PROV_PROVCONTACT="msg.error.masivo.alta.trabajos.relacion.prov.provcontact";
	private final String ERROR_FORMATO_IDTAREA="msg.error.masivo.alta.trabajos.campo.id.tarea";
	private final String ERROR_COD_AREA_PETIC="msg.error.masivo.alta.trabajos.error.cod.area.peticionaria";
	private final String ERROR_FORMATO_APLICA_COMITE="msg.error.masivo.alta.trabajos.error.formato.aplica.comite";
	private final String ERROR_RESOLUCION_COMITE="msg.error.masivo.alta.trabajos.error.resolucion.comite";
	private final String ERROR_FECHA_RESOLUCION_COMITE="msg.error.masivo.alta.trabajos.error.fecha.resolucion.comite";
	private final String ERROR_FECHA_FORMATO_INCORRECTO="msg.error.masivo.alta.trabajos.error.fecha.formato.incorrecto";
	private final String ERROR_FECHA_LIMITE_INCORRECTO="msg.error.masivo.alta.trabajos.error.fecha.limite.incorrecto";
	private final String ERROR_HORA_FORMATO_INCORRECTO="msg.error.masivo.alta.trabajos.error.hora.formato.incorrecto";
	private final String ERROR_ID_RESOLUCION_COMITE="msg.error.masivo.alta.trabajos.id.resolucion.comite";
	private final String ERROR_COD_TARIFA="msg.error.masivo.alta.trabajos.error.cod.tarifa";
	private final String ERROR_FECHA_CONCRETA_SUBTIPOS="msg.error.masivo.alta.trabajos.error.fecha.concreta.subtipo.trabajo";
	private final String ERROR_HORA_FECHA_CONCRETA="msg.error.masivo.alta.trabajos.error.fecha.hora.concreta";
	private final String ERROR_FORMATO_TARIFA_PLANA="msg.error.masivo.alta.trabajos.error.formato.tarifa.plana";
	private final String ERROR_FORMATO_URGENTE="msg.error.masivo.alta.trabajos.error.formato.urgente";
	private final String ERROR_FORMATO_RIESGO_TERCEROS="msg.error.masivo.alta.trabajos.error.formato.riesgo.terceros";
	private final String ERROR_FORMATO_SINIESTRO="msg.error.masivo.alta.trabajos.error.formato.siniestro";
	private final String ERROR_TARIFA_CARTERA_ACTIVO="msg.error.masivo.alta.trabajos.error.tarifa.cartera.activo";
	private final String PROVEEDOR_EN_CARTERA_ACTIVO="msg.error.masiva.alta.trabajos.error.proveedor.cartera.activo";
	private final String ERROR_IDTAREA_NO_EXISTE="msg.error.masivo.alta.trabajos.error.id.tarea.no.existe.webservice";
	private final String ACTIVO_EN_TRAMITE="msg.error.masivo.alta.trabajos.error.activo.en.tramite";
	
	
	//
	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int NUM_COLS = 22;	

	private final int COL_ID_ACTIVO = 0;
	private final int COL_TIPO_TRABAJO = 1;
	private final int COL_SUBTIPO_TRABAJO = 2;
	private final int COL_PROVEEDOR = 3;
	private final int COL_PROVEEDOR_CONTACTO = 4;
	private final int COL_ID_TAREA = 5;
	private final int COL_AREA_PETICIONARIA = 6;
	private final int COL_APLICA_COMITE = 7;
	private final int COL_RES_COMITE = 8;
	private final int COL_FECHA_RES_COMITE = 9;
	private final int COL_ID_RES_COMITE = 10;
	private final int COL_ID_TARIFA = 11;
	private final int COL_FECHA_CONCRETA = 12;
	private final int COL_HORA_CONCRETA = 13;
	private final int COL_FECHA_TOPE = 14;
	private final int COL_IMPORTE_PRESUPUESTO = 15;
	private final int COL_REFERENCIA_PRESUPUESTO = 16;
	private final int COL_TARIFA_PLANA = 17;
	private final int COL_URGENTE = 18;
	private final int COL_RIESGO_TERCEROS = 19;
	private final int COL_SINIESTRO = 20;
	private final int COL_DESCRIPCION = 21;
	
	private Integer numFilasHoja;	
	private Map<String, List<Integer>> mapaErrores;	
	private final Log logger = LogFactory.getLog(getClass());
	
	private final String tipTrabajoActTecnica ="03";
	private final String tipoTrabajoObtDocu ="02";

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
	
	@Autowired
	private TareaAdapter tareaAdapter;

	@Resource
	MessageService messageServices;

	@Autowired
	private GenericABMDao genericDao;
	
	
	private List<String> comprobacionTrue = Arrays.asList("S","SI");
	private List<String> comprobacionFalse = Arrays.asList("N","NO");
	
	
	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();

		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVActualizarGestores::validarContenidoFichero -> idTipoOperacion no puede ser null");
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
	
	private boolean validarFichero(MSVHojaExcel exc) {
		final String CODIGO_REAM_MANTENIMIENTO = "01";
		final String CODIGO_REAM_SEGURIDAD = "02";
		final String CODIGO_RAM = "03";
		final String CODIGO_EDIFICACIÓN = "04";
		
		final String CODIGO_NO = "NO";
		final String CODIGO_SI = "SI";
		
		final String SOLICITADO="SOL";
		final String APROBADO="APR";
		final String RECHAZADO="REC";
		
		final String COD_PAQUETE="PAQ";
		final String COD_TOMA_POSESION="57";
		
		List<String> listaCodSubtrabajos = Arrays.asList(COD_PAQUETE,COD_TOMA_POSESION);
		
		List<String> listaResolucionComite = Arrays.asList(SOLICITADO,APROBADO,RECHAZADO);
		

		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		SimpleDateFormat formatoHora = new SimpleDateFormat("HH:mm");
		Date fechaMax = new Date();
		try {
			fechaMax = ft.parse("31/12/2099");
		} catch (java.text.ParseException e1) {
			e1.printStackTrace();
		}
		boolean esCorrecto = true;

		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
				
				String idActivo = exc.dameCelda(fila, COL_ID_ACTIVO);
				String tipoTrabajo = exc.dameCelda(fila, COL_TIPO_TRABAJO);
				String subtipoTrabajo = exc.dameCelda(fila, COL_SUBTIPO_TRABAJO);
				String proveedor = exc.dameCelda(fila, COL_PROVEEDOR); 
				String proveedorContacto = exc.dameCelda(fila, COL_PROVEEDOR_CONTACTO);
				String idTarea = exc.dameCelda(fila, COL_ID_TAREA);
				String areaPeticionaria = exc.dameCelda(fila, COL_AREA_PETICIONARIA);
				String aplicaComite= exc.dameCelda(fila, COL_APLICA_COMITE);
				String resolucionComite= exc.dameCelda(fila, COL_RES_COMITE);
				String fechaResolucionComite= exc.dameCelda(fila, COL_FECHA_RES_COMITE);
				String idResolucionComite= exc.dameCelda(fila, COL_ID_RES_COMITE);
				String codTarifa= exc.dameCelda(fila, COL_ID_TARIFA);
				String fechaConcreta = exc.dameCelda(fila, COL_FECHA_CONCRETA);
				String horaConcreta = exc.dameCelda(fila, COL_HORA_CONCRETA);
				String fechaTope = exc.dameCelda(fila, COL_FECHA_TOPE);
				String importePresupuesto = exc.dameCelda(fila, COL_IMPORTE_PRESUPUESTO);
				String referenciaPresupuesto = exc.dameCelda(fila, COL_REFERENCIA_PRESUPUESTO);
				String tarifaPlana= exc.dameCelda(fila, COL_TARIFA_PLANA);
				String urgente= exc.dameCelda(fila, COL_URGENTE);
				String riesgoTerceros= exc.dameCelda(fila, COL_RIESGO_TERCEROS);
				String siniestro = exc.dameCelda(fila, COL_SINIESTRO);
				String descripcion = exc.dameCelda(fila, COL_DESCRIPCION);
				

				if (!isSuperGestEdiHayaGesAct()) {
					mapaErrores.get(messageServices.getMessage(NO_ES_USUARIO_VALIDO)).add(fila);
					esCorrecto = false;
				}
//				//CAMPOS NULOS
//				if (Checks.esNulo(idActivo)) {
//					mapaErrores.get(messageServices.getMessage(ACTIVO_NO_ESTA_RELLENO)).add(fila);
//					esCorrecto = false;
//				}
//				if (Checks.esNulo(tipoTrabajo)) {
//					mapaErrores.get(messageServices.getMessage(TRABAJO_NO_RELLENO)).add(fila);
//					esCorrecto = false;
//				}
//				if (Checks.esNulo(subtipoTrabajo)) {
//					mapaErrores.get(messageServices.getMessage(SUBTRABAJO_NO_RELLENO)).add(fila);
//					esCorrecto = false;
//				}
//				if (Checks.esNulo(proveedor)) {
//					mapaErrores.get(messageServices.getMessage(PROVEEDOR_NO_RELLENO)).add(fila);
//					esCorrecto = false;
//				}
//				if (Checks.esNulo(proveedorContacto)) {
//					mapaErrores.get(messageServices.getMessage(PROVEEDOR_CONTACTO_NO_RELLENO)).add(fila);
//					esCorrecto = false;
//				}
//				if (Checks.esNulo(areaPeticionaria)) {
//					mapaErrores.get(messageServices.getMessage(AREA_PETICIONARIA_NO_RELLENO)).add(fila);
//					esCorrecto = false;
//				}
//				if (Checks.esNulo(aplicaComite)) {
//					mapaErrores.get(messageServices.getMessage(APLICA_COMITE_NO_RELLENO)).add(fila);
//					esCorrecto = false;
//				}
				//CAMPOS NO NULOS
				if (!Checks.esNulo(idActivo) && !Checks.esNulo(tipoTrabajo) 
						&& !tipTrabajoActTecnica.equals(tipoTrabajo) 
						&& particularValidator.esActivoEnTramite(idActivo)) {
					mapaErrores.get(messageServices.getMessage(ACTIVO_EN_TRAMITE)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(idActivo) && !particularValidator.existeActivo(idActivo)) {
					mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(idActivo) && !particularValidator.esActivoIncluidoPerimetro(idActivo)) {
					mapaErrores.get(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(tipoTrabajo) && !(tipTrabajoActTecnica.equals(tipoTrabajo) || tipoTrabajoObtDocu.equals(tipoTrabajo))) {
					
					mapaErrores.get(messageServices.getMessage(TRABAJO_NO_EXISTE)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(subtipoTrabajo) && !particularValidator.existeSubtrabajoByCodigo(subtipoTrabajo)) {
					mapaErrores.get(messageServices.getMessage(SUBTRABAJO_NO_EXISTE)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(subtipoTrabajo) && !Checks.esNulo(tipoTrabajo) 
						&& !particularValidator.esSubtrabajoByCodTrabajoByCodSubtrabajo(tipoTrabajo, subtipoTrabajo)) {
					mapaErrores.get(messageServices.getMessage(INC_REL_TRABAJO_SUBTRABAJO)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(proveedor) && !Checks.esNulo(proveedorContacto) 
						&& !particularValidator.existeProveedorAndProveedorContacto(proveedor, proveedorContacto)) {
					mapaErrores.get(messageServices.getMessage(NO_RELAC_PROV_PROVCONTACT)).add(fila);
					esCorrecto = false;
				}
				
				if (!Checks.esNulo(proveedor) &&  !Checks.esNulo(idActivo)  
						&& particularValidator.existeProveedorEnCarteraActivo(proveedor,idActivo)) {
					mapaErrores.get(messageServices.getMessage(PROVEEDOR_EN_CARTERA_ACTIVO)).add(fila);
					esCorrecto = false;
				}

				if (!Checks.esNulo(idTarea)){
					try {
						Long idTareaParse =Long.parseLong(idTarea);
					} catch (NumberFormatException e) {
						mapaErrores.get(messageServices.getMessage(ERROR_FORMATO_IDTAREA)).add(fila);
						esCorrecto = false;
					}
				}
			
				
				//VALIDACION WEBSERVICE
				if (!Checks.esNulo(idTarea)){
					Object request = getExisteTareaWebServiceHaya(idTarea);
					if (!TareaAdapter.DEV.equals(request)) {
						JSONObject requestJson = (JSONObject) request;
						if (requestJson != null 
								&& requestJson.containsKey("tareaExistente")
								&& Boolean.FALSE.equals(requestJson.getBoolean("tareaExistente"))) {
							mapaErrores.get(messageServices.getMessage(ERROR_IDTAREA_NO_EXISTE)).add(fila);
							esCorrecto = false;
							
						}
						
					}
				}
				//
				if (!Checks.esNulo(areaPeticionaria)){
					List<String> listaCodigos = Arrays.asList(CODIGO_EDIFICACIÓN,CODIGO_RAM,CODIGO_REAM_MANTENIMIENTO,CODIGO_REAM_SEGURIDAD);
					if (!listaCodigos.contains(areaPeticionaria)){
						mapaErrores.get(messageServices.getMessage(ERROR_COD_AREA_PETIC)).add(fila);
						esCorrecto = false;
					}
				}
				
				if (!Checks.esNulo(aplicaComite)) {
					if (!comprobacionTrue.contains(aplicaComite.toUpperCase()) && !comprobacionFalse.contains(aplicaComite.toUpperCase())) {
						mapaErrores.get(messageServices.getMessage(ERROR_FORMATO_APLICA_COMITE)).add(fila);
						esCorrecto = false;
					}
				}
				
				if (!Checks.esNulo(aplicaComite)) { //PARA RESOLUCION COMITE
					if (CODIGO_SI.equalsIgnoreCase(aplicaComite) && (resolucionComite == null || !listaResolucionComite.contains(resolucionComite))) {
						mapaErrores.get(messageServices.getMessage(ERROR_RESOLUCION_COMITE)).add(fila);
						esCorrecto = false;
					}
				}
				if (!Checks.esNulo(fechaResolucionComite)) {
					try {
						Date fechaResCom = ft.parse(fechaResolucionComite);
						
						if (fechaResCom == null && (APROBADO.equalsIgnoreCase(resolucionComite) || RECHAZADO.equalsIgnoreCase(resolucionComite))) {
							mapaErrores.get(messageServices.getMessage(ERROR_FECHA_RESOLUCION_COMITE)).add(fila);
							esCorrecto = false;
						}
					} catch (Exception e) {
						mapaErrores.get(messageServices.getMessage(ERROR_FECHA_FORMATO_INCORRECTO)).add(fila);
						esCorrecto = false;
					}
				}
				if (!Checks.esNulo(fechaResolucionComite) && Checks.esNulo(idResolucionComite)) {
					mapaErrores.get(messageServices.getMessage(ERROR_ID_RESOLUCION_COMITE)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(codTarifa) && particularValidator.existeTipoTarifa(codTarifa)) {
					mapaErrores.get(messageServices.getMessage(ERROR_COD_TARIFA)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(codTarifa) && !Checks.esNulo(idActivo) && !particularValidator.esTarifaEnCarteradelActivo(codTarifa,idActivo)) {
					mapaErrores.get(messageServices.getMessage(ERROR_TARIFA_CARTERA_ACTIVO)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(fechaConcreta)) {
					try {
						Date fechaConcretaparse = ft.parse(fechaConcreta);
						if (fechaConcretaparse == null && listaCodSubtrabajos.contains(subtipoTrabajo)) {
							mapaErrores.get(messageServices.getMessage(ERROR_FECHA_CONCRETA_SUBTIPOS)).add(fila);
							esCorrecto = false;
						}
					} catch (Exception e) {
						mapaErrores.get(messageServices.getMessage(ERROR_FECHA_FORMATO_INCORRECTO)).add(fila);
						esCorrecto = false;
					}
				}
				if (!Checks.esNulo(fechaConcreta) && !Checks.esNulo(horaConcreta)) {
					try {
						Date horaConcrateParse = formatoHora.parse(horaConcreta);
						if (horaConcrateParse == null && fechaConcreta != null) {
							mapaErrores.get(messageServices.getMessage(ERROR_HORA_FECHA_CONCRETA)).add(fila);
							esCorrecto = false;
						}
					} catch (Exception e) {
						mapaErrores.get(messageServices.getMessage(ERROR_HORA_FORMATO_INCORRECTO)).add(fila);
						esCorrecto = false;
					}
				}
				if (!Checks.esNulo(fechaTope)) {
					try {
						Date fechaTopeparse = ft.parse(fechaTope);
						if(fechaTopeparse.before(new Date()) || fechaTopeparse.after(fechaMax)){
							mapaErrores.get(messageServices.getMessage(ERROR_FECHA_LIMITE_INCORRECTO)).add(fila);
							esCorrecto = false;
						}
					} catch (java.text.ParseException e) {
						mapaErrores.get(messageServices.getMessage(ERROR_FECHA_FORMATO_INCORRECTO)).add(fila);
						esCorrecto = false;
					} catch (Exception e) {
						ArrayList<Integer> errores = new ArrayList<Integer>();
						errores.add(fila);
						mapaErrores.put(e.toString(), errores);
						esCorrecto = false;
					}
				}								
				if (!Checks.esNulo(tarifaPlana)) {
					if (!CODIGO_NO.equalsIgnoreCase(tarifaPlana) && !CODIGO_SI.equalsIgnoreCase(tarifaPlana)) {
						mapaErrores.get(messageServices.getMessage(ERROR_FORMATO_TARIFA_PLANA)).add(fila);
						esCorrecto = false;
					}
				}				
				if (!Checks.esNulo(urgente)) {
					if (!CODIGO_NO.equalsIgnoreCase(urgente) && !CODIGO_SI.equalsIgnoreCase(urgente)) {
						mapaErrores.get(messageServices.getMessage(ERROR_FORMATO_URGENTE)).add(fila);
						esCorrecto = false;
					}
				}				
				if (!Checks.esNulo(riesgoTerceros)) {
					if (!CODIGO_NO.equalsIgnoreCase(riesgoTerceros) && !CODIGO_SI.equalsIgnoreCase(riesgoTerceros)) {
						mapaErrores.get(messageServices.getMessage(ERROR_FORMATO_RIESGO_TERCEROS)).add(fila);
						esCorrecto = false;
					}
				}				
				if (!Checks.esNulo(siniestro)) {
					if (!CODIGO_NO.equalsIgnoreCase(siniestro) && !CODIGO_SI.equalsIgnoreCase(siniestro)) {
						mapaErrores.get(messageServices.getMessage(ERROR_FORMATO_SINIESTRO)).add(fila);
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

	private boolean isSuperGestEdiHayaGesAct() {
		final String USUARIOHAYAGESACT = "HAYAGESACT";
		final String USUARIOSUPER = "HAYASUPER";
		final String USUARIOGESTEDI = "GESTEDI";
		Perfil perfilHayaGesAct = genericDao.get(Perfil.class, genericDao.createFilter(FilterType.EQUALS, "codigo", USUARIOHAYAGESACT));
		Perfil perfilGestedi = genericDao.get(Perfil.class, genericDao.createFilter(FilterType.EQUALS, "codigo", USUARIOGESTEDI));
		Perfil perfilSuper = genericDao.get(Perfil.class, genericDao.createFilter(FilterType.EQUALS, "codigo", USUARIOSUPER));
		
		Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		ZonaUsuarioPerfil usuarioPerfilGestEdi = genericDao.get(ZonaUsuarioPerfil.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario", usu),
				genericDao.createFilter(FilterType.EQUALS, "perfil", perfilGestedi),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		ZonaUsuarioPerfil usuarioPerfilHayaGesAct = genericDao.get(ZonaUsuarioPerfil.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario", usu),
				genericDao.createFilter(FilterType.EQUALS, "perfil", perfilHayaGesAct),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		ZonaUsuarioPerfil usuarioSuper = genericDao.get(ZonaUsuarioPerfil.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario", usu),
				genericDao.createFilter(FilterType.EQUALS, "perfil", perfilSuper),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		return usuarioPerfilGestEdi != null || usuarioSuper != null || usuarioPerfilHayaGesAct != null;
	}
	
	private void generarMapaErrores() {
		mapaErrores = new HashMap<String, List<Integer>>();
		mapaErrores.put(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_FUERA_CARTERA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(NO_ES_PROVEEDOR_CONTACTO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(NO_EXISTE_TAREA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(NO_ES_COD_TARIFA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(NO_ES_USUARIO_VALIDO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ACTIVO_NO_ESTA_RELLENO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(VALIDAR_FILA_EXCEPTION), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(TRABAJO_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(SUBTRABAJO_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(INC_REL_TRABAJO_SUBTRABAJO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(TRABAJO_NO_RELLENO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(SUBTRABAJO_NO_RELLENO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_NO_RELLENO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_CONTACTO_NO_RELLENO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(AREA_PETICIONARIA_NO_RELLENO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(APLICA_COMITE_NO_RELLENO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(NO_RELAC_PROV_PROVCONTACT), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_FORMATO_IDTAREA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_COD_AREA_PETIC), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_FORMATO_APLICA_COMITE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_RESOLUCION_COMITE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_FECHA_RESOLUCION_COMITE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_FECHA_FORMATO_INCORRECTO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_HORA_FORMATO_INCORRECTO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_ID_RESOLUCION_COMITE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_COD_TARIFA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_FECHA_CONCRETA_SUBTIPOS), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_HORA_FECHA_CONCRETA), new ArrayList<Integer>());		
		mapaErrores.put(messageServices.getMessage(ERROR_FORMATO_TARIFA_PLANA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_FORMATO_URGENTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_FORMATO_RIESGO_TERCEROS), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_FORMATO_SINIESTRO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_TARIFA_CARTERA_ACTIVO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_EN_CARTERA_ACTIVO), new ArrayList<Integer>());		
		mapaErrores.put(messageServices.getMessage(ERROR_IDTAREA_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ACTIVO_EN_TRAMITE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ERROR_FECHA_LIMITE_INCORRECTO), new ArrayList<Integer>());

	}
	

	public Object getExisteTareaWebServiceHaya(String idTareaHaya) {
		String endpoint = tareaAdapter.getExisteTareaHayaEndpoint();
		if (TareaAdapter.DEV.equals(endpoint)) {
			return TareaAdapter.DEV;
		}else {
			endpoint += idTareaHaya;
			HttpSimpleGetRequest request = new HttpSimpleGetRequest(endpoint);
			return request.get();
		}
	}
	
	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
	
}
