package es.pfsgroup.plugin.rem.activo;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoValoraciones;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoActivoDatosRegistrales;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPrecios;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.service.TabActivoService;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;



@Service("activoManager")
public class ActivoManager extends BusinessOperationOverrider<ActivoApi> implements ActivoApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
	protected static final Log logger = LogFactory.getLog(ActivoManager.class);
	
	@Resource
    MessageService messageServices;
	
	@Autowired
	private Executor executor;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private ActivoAdapter activoAdapter;
	
    @Autowired
    private GenericAdapter adapter;
	
	@Autowired
	private UploadAdapter uploadAdapter;
    
	@Autowired
	private UpdaterStateApi updaterState;
	
	@Autowired
	private TabActivoFactoryApi tabActivoFactory;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
		
	@Override
	public String managerName() {
		return "activoManager";
	}

	@Autowired
	private FuncionManager funcionManager;

	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private DiccionarioTargetClassMap diccionarioTargetClassMap;
	
    BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

    
	@Override
	@BusinessOperation(overrides = "activoManager.get")
	public Activo get(Long id) {
		return activoDao.get(id);
	}
	
	@Override
	@BusinessOperation(overrides = "activoManager.saveOrUpdate")
	@Transactional
	public boolean saveOrUpdate(Activo activo) {
		activoDao.saveOrUpdate(activo);
		
		//Actualiza los check de Admisión y Gestión
		updaterState.updaterStates(activo);
		
		return true;
	}
	
	@Override
	@BusinessOperation(overrides = "activoManager.getListActivos")
	public Page getListActivos(DtoActivoFilter dto, Usuario usuarioLogado) {
		return activoDao.getListActivos(dto, usuarioLogado);
	}
	
	@Override
	@BusinessOperation(overrides = "activoManager.getListHistoricoPresupuestos")
	public Page getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto, Usuario usuarioLogado) {
		return activoDao.getListHistoricoPresupuestos(dto, usuarioLogado);
	}

	
	@Override
	@BusinessOperation(overrides = "activoManager.isIntegradoAgrupacionRestringida")
	public boolean isIntegradoAgrupacionRestringida(Long id, Usuario usuarioLogado) {
		Integer contador = activoDao.isIntegradoAgrupacionRestringida(id, usuarioLogado);
		if (contador > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	@Override
	@BusinessOperation(overrides = "activoManager.isIntegradoAgrupacionObraNueva")
	public boolean isIntegradoAgrupacionObraNueva(Long id, Usuario usuarioLogado) {
		Integer contador = activoDao.isIntegradoAgrupacionObraNueva(id, usuarioLogado);
		if (contador > 0) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	@BusinessOperation(overrides = "activoManager.deleteAdjunto")
	@Transactional(readOnly = false)
    public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		
		Activo activo = get(dtoAdjunto.getIdActivo());
		ActivoAdjuntoActivo adjunto = activo.getAdjunto(dtoAdjunto.getId());
		
	    if (adjunto == null) { return false; }
	    activo.getAdjuntos().remove(adjunto);
	    activoDao.save(activo);
	    
	    return true;
	}
	
	@Override
	@BusinessOperation(overrides = "activoManager.savePrecioVigente")
	@Transactional(readOnly = false)
    public boolean savePrecioVigente(DtoPrecioVigente dto) {

			
		ActivoValoraciones activoValoracion = null;
		Usuario usuarioLogado = adapter.getUsuarioLogado();
		boolean resultado = true;
		
		Activo activo = get(dto.getIdActivo());
		
		try {
			// Si no hay idPrecioVigente creamos precio
			if(Checks.esNulo(dto.getIdPrecioVigente())) {
				
				saveActivoValoracion(activo, activoValoracion, dto);
				
			} else {
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdPrecioVigente());
				activoValoracion = genericDao.get(ActivoValoraciones.class, filtro);
				saveActivoValoracion(activo, activoValoracion, dto);
				
			}
		} catch(Exception ex) {
			logger.error(ex.getMessage());
			resultado = false;
		}

	    return resultado;
	}
	
	@Override
	@BusinessOperation(overrides = "activoManager.saveActivoValoracion")
	@Transactional(readOnly = false)
	public boolean saveActivoValoracion(Activo activo, ActivoValoraciones activoValoracion, DtoPrecioVigente dto) {
		
		// Actualizacion Valoracion existente
		if (!Checks.esNulo(activoValoracion)){
			// Si ya existia una valoracion, actualizamos el importe que se ha modificado por web
			// Pero antes, pasa la valoracion anterior al historico
			saveActivoValoracionHistorico (activoValoracion);

			// Actualiza la valoracion: nuevo importe y nuevo periodo de vigencia
			activoValoracion.setImporte(dto.getImporte());
			activoValoracion.setFechaInicio(dto.getFechaInicio());
			activoValoracion.setFechaFin(dto.getFechaFin());
			activoValoracion.setFechaCarga(new Date());
			
			genericDao.update(ActivoValoraciones.class, activoValoracion);
			
		} else {
			
			// Si no existia una valoracion del tipo indicado, crea una nueva valoracion de este tipo (para un activo)
			ActivoValoraciones activoValoracionNuevo = new ActivoValoraciones();
			DDTipoPrecio tipoPrecio = (DDTipoPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPrecio.class, dto.getCodigoTipoPrecio());
			
			activoValoracionNuevo.setActivo(activo);
			activoValoracionNuevo.setTipoPrecio(tipoPrecio);
			activoValoracionNuevo.setImporte(dto.getImporte());
			activoValoracionNuevo.setFechaInicio(dto.getFechaInicio());
			activoValoracionNuevo.setFechaFin(dto.getFechaFin());
			activoValoracionNuevo.setFechaAprobacion(null);
			activoValoracionNuevo.setFechaCarga(new Date());
			activoValoracion.setGestor(adapter.getUsuarioLogado());
			
			genericDao.save(ActivoValoraciones.class, activoValoracionNuevo);
		}
		
		return true;
	}
	
	@Transactional(readOnly = false)
	private boolean saveActivoValoracionHistorico(ActivoValoraciones activoValoracion) {
		
		ActivoHistoricoValoraciones historicoValoracion = new ActivoHistoricoValoraciones();
		
		historicoValoracion.setActivo(activoValoracion.getActivo());
		historicoValoracion.setTipoPrecio(activoValoracion.getTipoPrecio());
		historicoValoracion.setImporte(activoValoracion.getImporte());
		historicoValoracion.setFechaInicio(activoValoracion.getFechaInicio());
		historicoValoracion.setFechaFin(activoValoracion.getFechaFin());
		historicoValoracion.setFechaAprobacion(activoValoracion.getFechaAprobacion());
		historicoValoracion.setFechaCarga(activoValoracion.getFechaCarga());
		historicoValoracion.setGestor(activoValoracion.getGestor());
		historicoValoracion.setObservaciones(activoValoracion.getObservaciones());
		
		genericDao.save(ActivoHistoricoValoraciones.class, historicoValoracion);
		
		return true;
	}
	
	@Override
	@Transactional(readOnly = false)
    public boolean deleteValoracionPrecio(Long id) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoValoraciones activoValoracion = genericDao.get(ActivoValoraciones.class, filtro);
		saveActivoValoracionHistorico(activoValoracion);		
		//genericDao.deleteById(ActivoValoraciones.class, id);		
		activoDao.deleteValoracionById(id);
		
		return true;
	}
	
	
	@Override
	@BusinessOperation(overrides = "activoManager.upload")
	@Transactional(readOnly = false)
	public String upload(WebFileItem webFileItem) throws Exception {

		return upload2(webFileItem, null);

	}

	@Override
	@BusinessOperation(overrides = "activoManager.upload2")
	@Transactional(readOnly = false)
	public String upload2(WebFileItem webFileItem, Long idDocRestClient) throws Exception {
		
		Activo activo = get(Long.parseLong(webFileItem.getParameter("idEntidad")));
		
		Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());
		
		ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo();
		adjuntoActivo.setAdjunto(adj);
		adjuntoActivo.setActivo(activo);
		
		adjuntoActivo.setIdDocRestClient(idDocRestClient);
		
		if (webFileItem.getParameter("tipo") == null) throw new Exception("Tipo no valido");
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
		DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class, filtro);
		adjuntoActivo.setTipoDocumentoActivo(tipoDocumento);
		
		adjuntoActivo.setContentType(webFileItem.getFileItem().getContentType());
		
		adjuntoActivo.setTamanyo(webFileItem.getFileItem().getLength());

		adjuntoActivo.setNombre(webFileItem.getFileItem().getFileName());				

		adjuntoActivo.setDescripcion(webFileItem.getParameter("descripcion"));				
		
		adjuntoActivo.setFechaDocumento(new Date());

		Auditoria.save(adjuntoActivo);
        
		activo.getAdjuntos().add(adjuntoActivo);		
			
		activoDao.save(activo);
		
		return null;
	}
	
	@Override
	@BusinessOperation(overrides = "activoManager.uploadFoto")
	@Transactional(readOnly = false)
	public String uploadFoto(WebFileItem fileItem) {
			
			Activo activo = get(Long.parseLong(fileItem.getParameter("idEntidad")));
			
			//ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo(fileItem.getFileItem());
			
			ActivoFoto activoFoto = new ActivoFoto(fileItem.getFileItem());
			
			activoFoto.setActivo(activo);
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
			DDTipoFoto tipoFoto = (DDTipoFoto) genericDao.get(DDTipoFoto.class, filtro);
			
			activoFoto.setTipoFoto(tipoFoto);
						
			activoFoto.setTamanyo(fileItem.getFileItem().getLength());
			
			activoFoto.setNombre(fileItem.getFileItem().getFileName());

			activoFoto.setDescripcion(fileItem.getParameter("descripcion"));
			
			activoFoto.setPrincipal(Boolean.valueOf(fileItem.getParameter("principal")));
			
			activoFoto.setFechaDocumento(new Date());
			
			activoFoto.setInteriorExterior(Boolean.valueOf(fileItem.getParameter("interiorExterior")));
			
			Integer orden = activoDao.getMaxOrdenFotoById(Long.parseLong(fileItem.getParameter("idEntidad")));
			orden++;
			activoFoto.setOrden(orden);

			Auditoria.save(activoFoto);
	        
			activo.getFotos().add(activoFoto);		
				
			activoDao.save(activo);
					
		return null;

	}

	@Override
    @BusinessOperationDefinition("activoManager.download")
	public FileItem download(Long id) throws Exception {
		
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoAdjuntoActivo adjuntoActivo = (ActivoAdjuntoActivo) genericDao.get(ActivoAdjuntoActivo.class, filter);
		
		/*if (adjuntoActivo == null) throw new Exception("Adjunto no encontrado");
		
		FileItem fileItem = uploadAdapter.findOneBLOB(id);
		fileItem.setContentType(adjuntoActivo.getContentType());
		fileItem.setLength(adjuntoActivo.getTamanyo());
		fileItem.setFileName(adjuntoActivo.getNombre());*/
		
		return adjuntoActivo.getAdjunto().getFileItem();
	}
	
	@Override
	@BusinessOperationDefinition("activoManager.getComboInferiorMunicipio")
	public List<DDUnidadPoblacional> getComboInferiorMunicipio(String codigoMunicipio)
	{
		return activoDao.getComboInferiorMunicipio(codigoMunicipio);
	}

	@Override
    @BusinessOperationDefinition("activoManager.getMaxOrdenFotoById")
	public Integer getMaxOrdenFotoById(Long id) {

		return activoDao.getMaxOrdenFotoById(id);
	}
	
	@Override
    @BusinessOperationDefinition("activoManager.getMaxOrdenFotoByIdSubdivision")
	public Integer getMaxOrdenFotoByIdSubdivision(Long idEntidad, BigDecimal hashSdv) {

		return activoDao.getMaxOrdenFotoByIdSubdivision(idEntidad, hashSdv);
	}
	
	@Override
    @BusinessOperationDefinition("activoManager.getUltimoPresupuesto")
	public Long getUltimoPresupuesto(Long id) {

		return activoDao.getUltimoPresupuesto(id);
	}

	@BusinessOperationDefinition("activoManager.comprobarPestanaCheckingInformacion")
	public Boolean comprobarPestanaCheckingInformacion(Long idActivo){
		Activo activo = this.get(idActivo);
		if(!Checks.esNulo(activo.getTipoActivo()) &&
				!Checks.esNulo(activo.getSubtipoActivo()) &&
				!Checks.esNulo(activo.getDivHorizontal()) &&
				!Checks.esNulo(activo.getGestionHre()) && 
				!Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getTipoVia()) && 
				!Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getNombreVia()) && 
				!Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getCodPostal()) && 
				!Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getLocalidad()) && 
				!Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getPoblacion()) && 
				!Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getPais()) && 
				!Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getLocalidad()) &&
				!Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro())  &&
				!Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getNumFinca()) &&
				!Checks.esNulo(activo.getVpo()) &&
				!Checks.esNulo(activo.getOrigen()) &&
				!Checks.esNulo(activo.getPropietariosActivo()) &&
				comprobarPropietario(activo.getPropietariosActivo()) && 
				!Checks.esNulo(activo.getCatastro()) &&
				comprobarCatastro(activo.getCatastro())
				)
			return true;
		else
			return false;
	}

	@Override
	@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivo")
	public Boolean comprobarExisteAdjuntoActivo(Long idActivo, String codigoDocumento){

		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter codigoDocumentoFilter = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo.codigo", codigoDocumento);

		ActivoAdjuntoActivo adjuntoActivo = (ActivoAdjuntoActivo) genericDao.get(ActivoAdjuntoActivo.class, idActivoFilter, codigoDocumentoFilter);

		if (!Checks.esNulo(adjuntoActivo) && !Checks.esNulo(adjuntoActivo.getId())){
			return true;
		} else {
			return false;
		}
	}
	
	@Override
	@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivoTarea")
	public Boolean comprobarExisteAdjuntoActivoTarea(TareaExterna tarea){		
		Trabajo trabajo = trabajoApi.getTrabajoByTareaExterna(tarea);
		
		return comprobarExisteAdjuntoActivo(trabajo.getActivo().getId(), diccionarioTargetClassMap.getTipoDocumento(trabajo.getSubtipoTrabajo().getCodigo()));
	}

	private Boolean comprobarPropietario(List<ActivoPropietarioActivo> listadoPropietario){
		for (ActivoPropietarioActivo propietario : listadoPropietario) {
			 if(Checks.esNulo(propietario.getPropietario()) || Checks.esNulo(propietario.getPorcPropiedad()) || Checks.esNulo(propietario.getTipoGradoPropiedad()) )
				 return false;
			}
		return true;
	}
	
	private Boolean comprobarCatastro(List<ActivoCatastro> listadoCatastro){
		for (ActivoCatastro catastro : listadoCatastro) {
			if(Checks.esNulo(catastro.getRefCatastral()))
				return false;
		}
		return true;
	}
	
	/**
	 * Devuelve TRUE si el activo tiene fecha de posesión
	 *
	 * @param  idActivo  identificador del Activo
	 * @return	boolean
	 */
	@Override
	@BusinessOperationDefinition("activoManager.comprobarExisteFechaPosesionActivo")
	public Boolean comprobarExisteFechaPosesionActivo(Long idActivo) throws Exception{
		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);

		ActivoSituacionPosesoria situacionPosesoriaActivo = (ActivoSituacionPosesoria) genericDao.get(ActivoSituacionPosesoria.class, idActivoFilter);

		if (!Checks.esNulo(situacionPosesoriaActivo) && !Checks.esNulo(situacionPosesoriaActivo.getFechaTomaPosesion())){
			return true;
		} else {
			return false;
		}

	}
	
	/**
	 * Sirve para comprobar si el activo está vendido
	 */
	public Boolean isVendido(Long idActivo){
		Activo activo = get(idActivo);
		
		return DDSituacionComercial.CODIGO_VENDIDO.equals(activo.getSituacionComercial().getCodigo());
			
	}
	
	/**
	 * Devuelve mensaje de validación indicando los campos obligatorios que no han sido informados
	 * en la pestaña "Checking Información"
	 *
	 * @param  idActivo  identificador del Activo
	 * @return	String
	 */
	@Override
	@BusinessOperationDefinition("activoManager.comprobarObligatoriosCheckingInfoActivo")
	public String comprobarObligatoriosCheckingInfoActivo(Long idActivo) throws Exception{
		
		String mensaje = new String();
		final Integer CODIGO_INSCRITA = 1;
		final Integer CODIGO_NO_INSCRITA = 0;
		
		Activo activo = get(idActivo);
		
		DtoActivoDatosRegistrales activoDatosRegistrales = (DtoActivoDatosRegistrales) tabActivoFactory.getService(TabActivoService.TAB_DATOS_REGISTRALES).getTabData(activo);
		DtoActivoFichaCabecera activoCabecera = (DtoActivoFichaCabecera) tabActivoFactory.getService(TabActivoService.TAB_DATOS_BASICOS).getTabData(activo);
		
		//Validaciones datos obligatorios correspondientes a datos registrales del activo
		if (!Checks.esNulo(activoDatosRegistrales)){

			if(DDTipoTituloActivo.tipoTituloJudicial.equals(activoDatosRegistrales.getTipoTituloCodigo())){
				//Solo para Activos que tengan una titulación de tipo judicial, se valida
				//Valida obligatorio: Tipo Juzgado
				if (Checks.esNulo(activoDatosRegistrales.getTipoJuzgadoCodigo())){
					mensaje = mensaje.concat(messageServices.getMessage("tramite.admision.CheckingInformacion.validacionPre.tipoJuzgado"));
				}
				
				//Valida obligatorio: Poblacion Juzgado
				if (Checks.esNulo(activoDatosRegistrales.getTipoPlazaCodigo())){
					mensaje = mensaje.concat(messageServices.getMessage("tramite.admision.CheckingInformacion.validacionPre.poblacionJuzgado"));
				}
			}
		
			if (CODIGO_NO_INSCRITA.equals(activoDatosRegistrales.getDivHorInscrito())){
				//EstadoDivHorizonal no inscrita: Estado si no inscrita
				if (Checks.esNulo(activoDatosRegistrales.getEstadoDivHorizontalCodigo())){
					mensaje = mensaje.concat(messageServices.getMessage("tramite.admision.CheckingInformacion.validacionPre.estadoNoInscrito"));
				}
			}
		}
		
		//Validaciones datos obligatorios correspondientes a cabecera del activo
		if (!Checks.esNulo(activoCabecera)){
			
			//Validación longitud Codigo Postal
			if (!Checks.esNulo(activoCabecera.getCodPostal()) && activoCabecera.getCodPostal().length() < 5){
				mensaje = mensaje.concat(messageServices.getMessage("tramite.admision.CheckingInformacion.validacionPre.codPostal"));
			}
		}
		
		if (!Checks.esNulo(mensaje)){
			mensaje = messageServices.getMessage("tramite.admision.CheckingInformacion.validacionPre.debeInformar").concat(mensaje);
		}
		
		return mensaje;
	}
	
	@Override
	public VCondicionantesDisponibilidad getCondicionantesDisponibilidad(Long idActivo){
		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo);
		VCondicionantesDisponibilidad condicionantesDisponibilidad = (VCondicionantesDisponibilidad) genericDao.get(VCondicionantesDisponibilidad.class, idActivoFilter);

		return condicionantesDisponibilidad;
	}
	
	@Override
	public List<DtoCondicionEspecifica> getCondicionEspecificaByActivo(Long idActivo){
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.DESC, "id");
		List<ActivoCondicionEspecifica> listaCondicionesEspecificas = genericDao.getListOrdered(ActivoCondicionEspecifica.class, order, filtro);
		
		List<DtoCondicionEspecifica> listaDtoCondicionesEspecificas = new ArrayList<DtoCondicionEspecifica>();
		
		for(ActivoCondicionEspecifica condicion : listaCondicionesEspecificas){
			DtoCondicionEspecifica dtoCondicionEspecifica = new DtoCondicionEspecifica();
			try {
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "idActivo", condicion.getActivo().getId());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "texto", condicion.getTexto());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "fechaDesde", condicion.getFechaDesde());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "fechaHasta", condicion.getFechaHasta());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "usuarioAlta", !Checks.esNulo(condicion.getUsuarioAlta())?condicion.getUsuarioAlta().getUsername():"");
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "usuarioBaja", !Checks.esNulo(condicion.getUsuarioBaja())?condicion.getUsuarioBaja().getUsername():"");
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			listaDtoCondicionesEspecificas.add(dtoCondicionEspecifica);
		}
		return listaDtoCondicionesEspecificas;
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean createCondicionEspecifica(Long idActivo, DtoCondicionEspecifica dtoCondicionEspecifica){
		ActivoCondicionEspecifica condicionEspecifica = new ActivoCondicionEspecifica();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
		
		Activo activo = genericDao.get(Activo.class, filtro);
		
		try{
			beanUtilNotNull.copyProperty(condicionEspecifica, "texto", dtoCondicionEspecifica.getTexto());
			beanUtilNotNull.copyProperty(condicionEspecifica, "fechaDesde", new Date());
			condicionEspecifica.setUsuarioAlta(adapter.getUsuarioLogado());
			condicionEspecifica.setActivo(activo);
			ActivoCondicionEspecifica condicionAnterior = activoDao.getUltimaCondicion(idActivo);
			if(!Checks.esNulo(condicionAnterior)){
				beanUtilNotNull.copyProperty(condicionAnterior, "fechaHasta", new Date());
				condicionAnterior.setUsuarioBaja(adapter.getUsuarioLogado());
				genericDao.save(ActivoCondicionEspecifica.class, condicionAnterior);
			}
			
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		genericDao.save(ActivoCondicionEspecifica.class, condicionEspecifica);
		
		return true;
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean saveCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica){
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoCondicionEspecifica.getId()));		
		ActivoCondicionEspecifica condicionEspecifica = genericDao.get(ActivoCondicionEspecifica.class, filtro);
		
		try{
			beanUtilNotNull.copyProperty(condicionEspecifica, "texto", dtoCondicionEspecifica.getTexto());
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		genericDao.save(ActivoCondicionEspecifica.class, condicionEspecifica);
		
		return true;
	}
	
	
	@Override
	public DtoPage getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto) {
		
		Page page =  activoDao.getHistoricoValoresPrecios(dto);
		
		List<ActivoHistoricoValoraciones> lista = (List<ActivoHistoricoValoraciones>) page.getResults();
		List<DtoHistoricoPrecios> historicos = new ArrayList<DtoHistoricoPrecios>();
		
		for (ActivoHistoricoValoraciones historico: lista) {
			
			DtoHistoricoPrecios dtoHistorico = new DtoHistoricoPrecios(historico);
			historicos.add(dtoHistorico);
		}
		

		return new DtoPage(historicos, page.getTotalCount());
		
	}

	
}