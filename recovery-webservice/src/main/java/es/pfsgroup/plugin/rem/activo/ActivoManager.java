package es.pfsgroup.plugin.rem.activo;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
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
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoValoraciones;
import es.pfsgroup.plugin.rem.model.ActivoInformeComercialHistoricoMediador;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoActivoDatosRegistrales;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPrecios;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.plugin.rem.model.DtoPropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.PropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.service.TabActivoService;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;
import es.pfsgroup.plugin.rem.visita.dao.VisitaDao;

@Service("activoManager")
public class ActivoManager extends BusinessOperationOverrider<ActivoApi> implements ActivoApi {

	private final String ESTADO_PORTALES_EXTERNOS_PUBLICADO = "Ha estado publicado";
	private final String ESTADO_PORTALES_EXTERNOS_NO_PUBLICADO = "No ha estado publicado";
	
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

	protected static final Log logger = LogFactory.getLog(ActivoManager.class);

	@Resource
	MessageService messageServices;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoDao activoDao;
	
    @Autowired
    private GenericAdapter adapter;
    
    @Autowired
    private ActivoAdapter activoAdapter;

	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private UpdaterStateApi updaterState;

	@Autowired
	private TabActivoFactoryApi tabActivoFactory;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private VisitaDao visitasDao;

	@Override
	public String managerName() {
		return "activoManager";
	}

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
	public Activo getByNumActivo(Long id){
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numActivo", id);
		return genericDao.get(Activo.class, filter);
	}
	
	@Override
	@BusinessOperation(overrides = "activoManager.saveOrUpdate")
	@Transactional
	public boolean saveOrUpdate(Activo activo) {
		activoDao.saveOrUpdate(activo);

		// Actualiza los check de Admisión y Gestión
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

		if (adjunto == null) {
			return false;
		}
		activo.getAdjuntos().remove(adjunto);
		activoDao.save(activo);

		return true;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.savePrecioVigente")
	@Transactional(readOnly = false)
	public boolean savePrecioVigente(DtoPrecioVigente dto) {
		ActivoValoraciones activoValoracion = null;
		boolean resultado = true;

		Activo activo = get(dto.getIdActivo());

		try {
			// Si no hay idPrecioVigente creamos precio
			if (Checks.esNulo(dto.getIdPrecioVigente())) {

				saveActivoValoracion(activo, activoValoracion, dto);

			} else {

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdPrecioVigente());
				activoValoracion = genericDao.get(ActivoValoraciones.class, filtro);
				saveActivoValoracion(activo, activoValoracion, dto);

			}
		} catch (Exception ex) {
			logger.error(ex.getMessage());
			resultado = false;
		}

		return resultado;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.saveOfertaActivo")
	@Transactional(readOnly = false)
    public boolean saveOfertaActivo(DtoOfertaActivo dto) {
		
		boolean resultado = true;
		
		try{
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdOferta());
			Oferta oferta = genericDao.get(Oferta.class, filtro);
			
			DDEstadoOferta tipoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, dto.getEstadoOferta());
			
			oferta.setEstadoOferta(tipoOferta);
			
			//Si el estado de la oferta cambia a Aceptada cambiamos el resto de estados a Congelada excepto los que ya estuvieran en Rechazada
			if(DDEstadoOferta.CODIGO_ACEPTADA.equals(tipoOferta.getCodigo())){
				List<VOfertasActivosAgrupacion> listaOfertas= activoAdapter.getListOfertasActivos(dto.getIdActivo());
				
				for(VOfertasActivosAgrupacion vOferta: listaOfertas){
					
					if(!vOferta.getIdOferta().equals(dto.getIdOferta().toString())){
						Filter filtroOferta = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(vOferta.getIdOferta()));
						Oferta ofertaFiltro = genericDao.get(Oferta.class, filtroOferta);
						
						DDEstadoOferta vTipoOferta = ofertaFiltro.getEstadoOferta();
						if(!DDEstadoOferta.CODIGO_RECHAZADA.equals(vTipoOferta.getCodigo())){
							DDEstadoOferta vTipoOfertaActualizar = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_CONGELADA);
							ofertaFiltro.setEstadoOferta(vTipoOfertaActualizar);
						}
					}
				}

				List<Activo>listaActivos= new ArrayList<Activo>();
				for(ActivoOferta activoOferta: oferta.getActivosOferta()){
					listaActivos.add(activoOferta.getPrimaryKey().getActivo());
				}
				DDSubtipoTrabajo subtipoTrabajo= (DDSubtipoTrabajo) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoTrabajo.class, DDSubtipoTrabajo.CODIGO_SANCION_OFERTA);
				Trabajo trabajo= trabajoApi.create(subtipoTrabajo, listaActivos, null);
				
				crearExpediente(oferta, trabajo);
				
			}
			
			genericDao.update(Oferta.class, oferta);
			
		}catch(Exception ex) {
			logger.error(ex.getMessage());
			resultado = false;
		}
		

	    return resultado;
	}
	
	public boolean crearExpediente(Oferta oferta, Trabajo trabajo){
		
		try{
			ExpedienteComercial nuevoExpediente= new ExpedienteComercial();
			List<Visita> listaVisitasCliente = new ArrayList<Visita>();
			
			// Si el activo principal de la oferta aceptada tiene visitas, 
			// asociamos la visita más reciente del mismo cliente comercial a la oferta
			if(!Checks.esNulo(oferta.getActivoPrincipal())) {
				if(!Checks.esNulo(oferta.getActivoPrincipal().getVisitas()) && !oferta.getActivoPrincipal().getVisitas().isEmpty()) {
					
					for(Visita v: oferta.getActivoPrincipal().getVisitas() ) {
						
						if(oferta.getCliente().getDocumento().equals(v.getCliente().getDocumento())) {
							listaVisitasCliente.add(v);
						}
					}
					
					if(!listaVisitasCliente.isEmpty()) {
						oferta.setVisita(listaVisitasCliente.get(0));			
						genericDao.save(Oferta.class, oferta);
					}

				}
			}
			
			nuevoExpediente.setOferta(oferta);
			DDEstadosExpedienteComercial estadoExpediente = (DDEstadosExpedienteComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class, "01");
			nuevoExpediente.setEstado(estadoExpediente);
			nuevoExpediente.setNumExpediente(activoDao.getNextNumOferta());
			nuevoExpediente.setTrabajo(trabajo);
			genericDao.save(ExpedienteComercial.class, nuevoExpediente);
			
		}catch(Exception ex) {
			logger.error(ex.getMessage());
			return false;
		}
		
		return true;
		
	}
	
	
	
	@Override
	@BusinessOperation(overrides = "activoManager.saveActivoValoracion")
	@Transactional(readOnly = false)
	public boolean saveActivoValoracion(Activo activo, ActivoValoraciones activoValoracion, DtoPrecioVigente dto) {
		try {
		
			// Actualizacion Valoracion existente
			if (!Checks.esNulo(activoValoracion)) {
				// Si ya existia una valoracion, actualizamos el importe que se ha
				// modificado por web
				// Pero antes, pasa la valoracion anterior al historico
				saveActivoValoracionHistorico(activoValoracion);
				
				beanUtilNotNull.copyProperties(activoValoracion, dto);
				activoValoracion.setFechaCarga(new Date());
				
				genericDao.update(ActivoValoraciones.class, activoValoracion);
	
			} else {
	
				// Si no existia una valoracion del tipo indicado, crea una nueva
				// valoracion de este tipo (para un activo)
				activoValoracion = new ActivoValoraciones();
				beanUtilNotNull.copyProperties(activoValoracion, dto);
				activoValoracion.setFechaCarga(new Date());
				
				DDTipoPrecio tipoPrecio = (DDTipoPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPrecio.class,
						dto.getCodigoTipoPrecio());
	
				activoValoracion.setActivo(activo);
				activoValoracion.setTipoPrecio(tipoPrecio);
				activoValoracion.setGestor(adapter.getUsuarioLogado());
	
				genericDao.save(ActivoValoraciones.class, activoValoracion);
			}
			
		} catch (Exception ex) {
			logger.error(ex.getMessage());
			return false;
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
		// genericDao.deleteById(ActivoValoraciones.class, id);
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

		if (webFileItem.getParameter("tipo") == null)
			throw new Exception("Tipo no valido");

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
		DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class,
				filtro);
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

		// ActivoAdjuntoActivo adjuntoActivo = new
		// ActivoAdjuntoActivo(fileItem.getFileItem());

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

		/*
		 * if (adjuntoActivo == null) throw new Exception(
		 * "Adjunto no encontrado");
		 * 
		 * FileItem fileItem = uploadAdapter.findOneBLOB(id);
		 * fileItem.setContentType(adjuntoActivo.getContentType());
		 * fileItem.setLength(adjuntoActivo.getTamanyo());
		 * fileItem.setFileName(adjuntoActivo.getNombre());
		 */

		return adjuntoActivo.getAdjunto().getFileItem();
	}

	@Override
	@BusinessOperationDefinition("activoManager.getComboInferiorMunicipio")
	public List<DDUnidadPoblacional> getComboInferiorMunicipio(String codigoMunicipio) {
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
	public Boolean comprobarPestanaCheckingInformacion(Long idActivo) {
		Activo activo = this.get(idActivo);
		if (!Checks.esNulo(activo.getTipoActivo()) && !Checks.esNulo(activo.getSubtipoActivo())
				&& !Checks.esNulo(activo.getDivHorizontal()) && !Checks.esNulo(activo.getGestionHre())
				&& !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getTipoVia())
				&& !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getNombreVia())
				&& !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getCodPostal())
				&& !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getLocalidad())
				&& !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getPoblacion())
				&& !Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getPais())
				&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getLocalidad())
				&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro())
				&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getNumFinca())
				&& !Checks.esNulo(activo.getVpo()) && !Checks.esNulo(activo.getOrigen())
				&& !Checks.esNulo(activo.getPropietariosActivo())
				&& comprobarPropietario(activo.getPropietariosActivo()) && !Checks.esNulo(activo.getCatastro())
				&& comprobarCatastro(activo.getCatastro()))
			return true;
		else
			return false;
	}

	@Override
	@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivo")
	public Boolean comprobarExisteAdjuntoActivo(Long idActivo, String codigoDocumento) {

		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter codigoDocumentoFilter = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo.codigo",
				codigoDocumento);

		// ActivoAdjuntoActivo adjuntoActivo = (ActivoAdjuntoActivo)
		// genericDao.get(ActivoAdjuntoActivo.class, idActivoFilter,
		// codigoDocumentoFilter);
		List<ActivoAdjuntoActivo> adjuntosActivo = genericDao.getList(ActivoAdjuntoActivo.class, idActivoFilter,
				codigoDocumentoFilter);

		if (!Checks.estaVacio(adjuntosActivo)) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	@BusinessOperationDefinition("activoManager.comprobarExisteAdjuntoActivoTarea")
	public Boolean comprobarExisteAdjuntoActivoTarea(TareaExterna tarea) {
		Trabajo trabajo = trabajoApi.getTrabajoByTareaExterna(tarea);

		return comprobarExisteAdjuntoActivo(trabajo.getActivo().getId(),
				diccionarioTargetClassMap.getTipoDocumento(trabajo.getSubtipoTrabajo().getCodigo()));
	}

	private Boolean comprobarPropietario(List<ActivoPropietarioActivo> listadoPropietario) {
		for (ActivoPropietarioActivo propietario : listadoPropietario) {
			if (Checks.esNulo(propietario.getPropietario()) || Checks.esNulo(propietario.getPorcPropiedad())
					|| Checks.esNulo(propietario.getTipoGradoPropiedad()))
				return false;
		}
		return true;
	}

	private Boolean comprobarCatastro(List<ActivoCatastro> listadoCatastro) {
		for (ActivoCatastro catastro : listadoCatastro) {
			if (Checks.esNulo(catastro.getRefCatastral()))
				return false;
		}
		return true;
	}

	/**
	 * Devuelve TRUE si el activo tiene fecha de posesión
	 *
	 * @param idActivo
	 *            identificador del Activo
	 * @return boolean
	 */
	@Override
	@BusinessOperationDefinition("activoManager.comprobarExisteFechaPosesionActivo")
	public Boolean comprobarExisteFechaPosesionActivo(Long idActivo) throws Exception {
		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);

		ActivoSituacionPosesoria situacionPosesoriaActivo = (ActivoSituacionPosesoria) genericDao
				.get(ActivoSituacionPosesoria.class, idActivoFilter);

		if (!Checks.esNulo(situacionPosesoriaActivo)
				&& !Checks.esNulo(situacionPosesoriaActivo.getFechaTomaPosesion())) {
			return true;
		} else {
			return false;
		}

	}

	/**
	 * Sirve para comprobar si el activo está vendido
	 */
	public Boolean isVendido(Long idActivo) {
		Activo activo = get(idActivo);

		return DDSituacionComercial.CODIGO_VENDIDO.equals(activo.getSituacionComercial().getCodigo());

	}

	/**
	 * Devuelve mensaje de validación indicando los campos obligatorios que no
	 * han sido informados en la pestaña "Checking Información"
	 *
	 * @param idActivo
	 *            identificador del Activo
	 * @return String
	 */
	@SuppressWarnings("unused")
	@Override
	@BusinessOperationDefinition("activoManager.comprobarObligatoriosCheckingInfoActivo")
	public String comprobarObligatoriosCheckingInfoActivo(Long idActivo) throws Exception {

		String mensaje = new String();
		final Integer CODIGO_INSCRITA = 1;
		final Integer CODIGO_NO_INSCRITA = 0;

		Activo activo = get(idActivo);

		DtoActivoDatosRegistrales activoDatosRegistrales = (DtoActivoDatosRegistrales) tabActivoFactory
				.getService(TabActivoService.TAB_DATOS_REGISTRALES).getTabData(activo);
		DtoActivoFichaCabecera activoCabecera = (DtoActivoFichaCabecera) tabActivoFactory
				.getService(TabActivoService.TAB_DATOS_BASICOS).getTabData(activo);

		// Validaciones datos obligatorios correspondientes a datos registrales
		// del activo
		if (!Checks.esNulo(activoDatosRegistrales)) {

			if (DDTipoTituloActivo.tipoTituloJudicial.equals(activoDatosRegistrales.getTipoTituloCodigo())) {
				// Solo para Activos que tengan una titulación de tipo judicial,
				// se valida
				// Valida obligatorio: Tipo Juzgado
				if (Checks.esNulo(activoDatosRegistrales.getTipoJuzgadoCodigo())) {
					mensaje = mensaje.concat(messageServices
							.getMessage("tramite.admision.CheckingInformacion.validacionPre.tipoJuzgado"));
				}

				// Valida obligatorio: Poblacion Juzgado
				if (Checks.esNulo(activoDatosRegistrales.getTipoPlazaCodigo())) {
					mensaje = mensaje.concat(messageServices
							.getMessage("tramite.admision.CheckingInformacion.validacionPre.poblacionJuzgado"));
				}
			}

			if (CODIGO_NO_INSCRITA.equals(activoDatosRegistrales.getDivHorInscrito())) {
				// EstadoDivHorizonal no inscrita: Estado si no inscrita
				if (Checks.esNulo(activoDatosRegistrales.getEstadoDivHorizontalCodigo())) {
					mensaje = mensaje.concat(messageServices
							.getMessage("tramite.admision.CheckingInformacion.validacionPre.estadoNoInscrito"));
				}
			}
		}

		// Validaciones datos obligatorios correspondientes a cabecera del
		// activo
		if (!Checks.esNulo(activoCabecera)) {

			// Validación longitud Codigo Postal
			if (!Checks.esNulo(activoCabecera.getCodPostal()) && activoCabecera.getCodPostal().length() < 5) {
				mensaje = mensaje.concat(
						messageServices.getMessage("tramite.admision.CheckingInformacion.validacionPre.codPostal"));
			}
		}

		if (!Checks.esNulo(mensaje)) {
			mensaje = messageServices.getMessage("tramite.admision.CheckingInformacion.validacionPre.debeInformar")
					.concat(mensaje);
		}

		return mensaje;
	}

	@Override
	public VCondicionantesDisponibilidad getCondicionantesDisponibilidad(Long idActivo) {
		Filter idActivoFilter = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo);
		VCondicionantesDisponibilidad condicionantesDisponibilidad = (VCondicionantesDisponibilidad) genericDao
				.get(VCondicionantesDisponibilidad.class, idActivoFilter);

		return condicionantesDisponibilidad;
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean saveCondicionantesDisponibilidad(Long idActivo, DtoCondicionantesDisponibilidad dtoCondicionanteDisponibilidad) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		ActivoSituacionPosesoria condicionantesDisponibilidad = genericDao.get(ActivoSituacionPosesoria.class, filtro);

		try {
			beanUtilNotNull.copyProperty(condicionantesDisponibilidad, "otro", dtoCondicionanteDisponibilidad.getOtro());
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			return false;
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			return false;
		}

		genericDao.save(ActivoSituacionPosesoria.class, condicionantesDisponibilidad);
		
		return true;
	}

	@Override
	public List<DtoCondicionEspecifica> getCondicionEspecificaByActivo(Long idActivo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.DESC, "id");
		List<ActivoCondicionEspecifica> listaCondicionesEspecificas = genericDao
				.getListOrdered(ActivoCondicionEspecifica.class, order, filtro);

		List<DtoCondicionEspecifica> listaDtoCondicionesEspecificas = new ArrayList<DtoCondicionEspecifica>();

		for (ActivoCondicionEspecifica condicion : listaCondicionesEspecificas) {
			DtoCondicionEspecifica dtoCondicionEspecifica = new DtoCondicionEspecifica();
			try {
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "idActivo", condicion.getActivo().getId());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "texto", condicion.getTexto());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "fechaDesde", condicion.getFechaDesde());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "fechaHasta", condicion.getFechaHasta());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "usuarioAlta",
						!Checks.esNulo(condicion.getUsuarioAlta()) ? condicion.getUsuarioAlta().getUsername() : "");
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "usuarioBaja",
						!Checks.esNulo(condicion.getUsuarioBaja()) ? condicion.getUsuarioBaja().getUsername() : "");
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}

			listaDtoCondicionesEspecificas.add(dtoCondicionEspecifica);
		}
		return listaDtoCondicionesEspecificas;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean createCondicionEspecifica(Long idActivo, DtoCondicionEspecifica dtoCondicionEspecifica) {
		ActivoCondicionEspecifica condicionEspecifica = new ActivoCondicionEspecifica();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);

		Activo activo = genericDao.get(Activo.class, filtro);

		try {
			beanUtilNotNull.copyProperty(condicionEspecifica, "texto", dtoCondicionEspecifica.getTexto());
			beanUtilNotNull.copyProperty(condicionEspecifica, "fechaDesde", new Date());
			condicionEspecifica.setUsuarioAlta(adapter.getUsuarioLogado());
			condicionEspecifica.setActivo(activo);
			ActivoCondicionEspecifica condicionAnterior = activoDao.getUltimaCondicion(idActivo);
			if (!Checks.esNulo(condicionAnterior)) {
				beanUtilNotNull.copyProperty(condicionAnterior, "fechaHasta", new Date());
				condicionAnterior.setUsuarioBaja(adapter.getUsuarioLogado());
				genericDao.save(ActivoCondicionEspecifica.class, condicionAnterior);
			}

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		genericDao.save(ActivoCondicionEspecifica.class, condicionEspecifica);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean saveCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoCondicionEspecifica.getId()));
		ActivoCondicionEspecifica condicionEspecifica = genericDao.get(ActivoCondicionEspecifica.class, filtro);

		try {
			beanUtilNotNull.copyProperty(condicionEspecifica, "texto", dtoCondicionEspecifica.getTexto());
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		genericDao.save(ActivoCondicionEspecifica.class, condicionEspecifica);

		return true;
	}

	@Override
	public DtoPage getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto) {

		Page page = activoDao.getHistoricoValoresPrecios(dto);

		@SuppressWarnings("unchecked")
		List<ActivoHistoricoValoraciones> lista = (List<ActivoHistoricoValoraciones>) page.getResults();
		List<DtoHistoricoPrecios> historicos = new ArrayList<DtoHistoricoPrecios>();

		for (ActivoHistoricoValoraciones historico : lista) {

			DtoHistoricoPrecios dtoHistorico = new DtoHistoricoPrecios(historico);
			historicos.add(dtoHistorico);
		}

		return new DtoPage(historicos, page.getTotalCount());

	}

	@Override
	public List<DtoEstadoPublicacion> getEstadoPublicacionByActivo(Long idActivo) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.DESC, "id");
		List<ActivoHistoricoEstadoPublicacion> listaEstadosPublicacion = genericDao
				.getListOrdered(ActivoHistoricoEstadoPublicacion.class, order, filtro);

		List<DtoEstadoPublicacion> listaDtoEstadosPublicacion = new ArrayList<DtoEstadoPublicacion>();

		for (ActivoHistoricoEstadoPublicacion estado : listaEstadosPublicacion) {
			DtoEstadoPublicacion dtoEstadoPublicacion = new DtoEstadoPublicacion();
			try {
				if(!Checks.esNulo(estado.getActivo())) {
					beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "idActivo", estado.getActivo().getId());
				}
				beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "fechaDesde", estado.getFechaDesde());
				beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "fechaHasta", estado.getFechaHasta());
				if(!Checks.esNulo(estado.getPortal())) {
					beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "portal", estado.getPortal().getDescripcion());
				} else {
					beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "portal", "-");
				}
				if(!Checks.esNulo(estado.getTipoPublicacion())) {
					beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "tipoPublicacion", estado.getTipoPublicacion().getDescripcion());
				} else {
					beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "tipoPublicacion", "-");
				}
				if(!Checks.esNulo(estado.getEstadoPublicacion())) {
					beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "estadoPublicacion", estado.getEstadoPublicacion().getDescripcion());
				}
				beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "motivo", estado.getMotivo());
				// Calcular los días que ha estado en un estado eliminando el tiempo de las fechas.
				int dias = 0;
				if(!Checks.esNulo(estado.getFechaDesde()) && !Checks.esNulo(estado.getFechaHasta())){
					SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
				    Date fechaHastaSinTiempo = sdf.parse(sdf.format(estado.getFechaHasta()));
				    Date fechaDesdeSinTiempo = sdf.parse(sdf.format(estado.getFechaDesde()));
				    Long diferenciaMilis = fechaHastaSinTiempo.getTime() - fechaDesdeSinTiempo.getTime();
					Long diferenciaDias = diferenciaMilis / (1000 * 60 * 60 * 24);
					dias = Integer.valueOf(diferenciaDias.intValue());
				}
				beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "diasPeriodo", dias);
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			} catch (ParseException e) {
				e.printStackTrace();
			}

			listaDtoEstadosPublicacion.add(dtoEstadoPublicacion);
		}
		return listaDtoEstadosPublicacion;
	}
	
	@Override
	public List<DtoEstadosInformeComercialHistorico> getEstadoInformeComercialByActivo(Long idActivo){
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.ASC, "id");
		List<ActivoEstadosInformeComercialHistorico> listaEstadoInfoComercial = genericDao
				.getListOrdered(ActivoEstadosInformeComercialHistorico.class, order, filtro);
		
		List<DtoEstadosInformeComercialHistorico> listaDtoEstadosInfoComercial = new ArrayList<DtoEstadosInformeComercialHistorico>();
		
		for (ActivoEstadosInformeComercialHistorico estado : listaEstadoInfoComercial) {
			DtoEstadosInformeComercialHistorico dtoEstadosInfoComercial = new DtoEstadosInformeComercialHistorico();
			try {
				beanUtilNotNull.copyProperty(dtoEstadosInfoComercial, "id", idActivo);
				if(!Checks.esNulo(estado.getEstadoInformeComercial())){
					beanUtilNotNull.copyProperty(dtoEstadosInfoComercial, "estadoInfoComercial", estado.getEstadoInformeComercial().getDescripcion());
				}
				beanUtilNotNull.copyProperty(dtoEstadosInfoComercial, "motivo", estado.getMotivo());
				beanUtilNotNull.copyProperty(dtoEstadosInfoComercial, "fecha", estado.getFecha());
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
			
			listaDtoEstadosInfoComercial.add(dtoEstadosInfoComercial);
		}
		
		return listaDtoEstadosInfoComercial;
	}
	
	@Override
	public List<DtoHistoricoMediador> getHistoricoMediadorByActivo(Long idActivo){
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.ASC, "id");
		List<ActivoInformeComercialHistoricoMediador> listaHistoricoMediador = genericDao
				.getListOrdered(ActivoInformeComercialHistoricoMediador.class, order, filtro);
		
		List<DtoHistoricoMediador> listaDtoHistoricoMediador = new ArrayList<DtoHistoricoMediador>();
		
		for (ActivoInformeComercialHistoricoMediador historico : listaHistoricoMediador) {
			DtoHistoricoMediador dtoHistoricoMediador = new DtoHistoricoMediador();
			try {
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "id", idActivo);
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "fechaDesde", historico.getFechaDesde());
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "fechaHasta", historico.getFechaHasta());
				if(!Checks.esNulo(historico.getMediadorInforme())){
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "codigo", historico.getMediadorInforme().getId());
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "mediador", historico.getMediadorInforme().getNombre());
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "telefono", historico.getMediadorInforme().getTelefono1());
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "email", historico.getMediadorInforme().getEmail());
				}
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
			
			listaDtoHistoricoMediador.add(dtoHistoricoMediador);
		}
		
		return listaDtoHistoricoMediador;
	}

	@Override
	public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro) {

		return activoDao.getPropuestas(dtoPropuestaFiltro);
	}

	@Override
	public Page getActivosPublicacion(DtoActivosPublicacion dtoActivosPublicacion) {

		return activoDao.getActivosPublicacion(dtoActivosPublicacion);
	}

	@Override
	public ActivoHistoricoEstadoPublicacion getUltimoHistoricoEstadoPublicacion(Long activoID) {

		return activoDao.getUltimoHistoricoEstadoPublicacion(activoID);
	}

	@Override
	public Visita insertOrUpdateVisitaActivo(Visita visita) throws IllegalAccessException, InvocationTargetException {
		if (visita.getId() != null) {
			// insert
			Long newId = visitasDao.save(visita);
			visita.setId(newId);
		} else {
			// update
			Visita toUpdate = visitasDao.get(visita.getId());
			BeanUtils.copyProperties(toUpdate, visita);
			visitasDao.update(toUpdate);
		}
		return visita;
	}

	@Override
	public DtoDatosPublicacion getDatosPublicacionByActivo(Long idActivo) {
		// Obtener los estados y sumar los dias de cada fase aplicando criterio de funcional además comprobar
		// si alguno de ellos es de publicación/publicación forzada y especificar estado publicación en portales externos.
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.ASC, "id");
		List<ActivoHistoricoEstadoPublicacion> listaEstadosPublicacion = genericDao
				.getListOrdered(ActivoHistoricoEstadoPublicacion.class, order, filtro);
		
		int dias = 0;
		boolean despublicado = false;
		boolean estadoPublicacionPortalesExternos = false;
		
		for (ActivoHistoricoEstadoPublicacion estado : listaEstadosPublicacion) {
			if(!Checks.esNulo(estado.getEstadoPublicacion())){
				if(DDEstadoPublicacion.CODIGO_PUBLICADO.equals(estado.getEstadoPublicacion().getCodigo()) || 
						DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(estado.getEstadoPublicacion().getCodigo())){
					// Comprobar si ha estado publicado en algún estado para especificarlo en estado publicación portales externos.
					estadoPublicacionPortalesExternos = true;
				}
				
				if(despublicado && (DDEstadoPublicacion.CODIGO_PUBLICADO.equals(estado.getEstadoPublicacion().getCodigo()) || 
						DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(estado.getEstadoPublicacion().getCodigo()))){
					// Si el estado anterior es despublicado y el actual es publicado, se reinicia el contador de días.
					despublicado = false;
					dias = 0;
					
				} else if(DDEstadoPublicacion.CODIGO_DESPUBLICADO.equals(estado.getEstadoPublicacion().getCodigo())) {
					// Si el estado es despublicado se marca para la siguiente iteración.
					despublicado = true;
					
				} else if(!DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO.equals(estado.getEstadoPublicacion().getCodigo())){
					if(!Checks.esNulo(estado.getFechaDesde()) && !Checks.esNulo(estado.getFechaHasta())){
						// Cualquier otro estado distinto a publicado oculto sumará días de publicación.
						try{
						SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
					    Date fechaHastaSinTiempo = sdf.parse(sdf.format(estado.getFechaHasta()));
					    Date fechaDesdeSinTiempo = sdf.parse(sdf.format(estado.getFechaDesde()));
					    Long diferenciaMilis = fechaHastaSinTiempo.getTime() - fechaDesdeSinTiempo.getTime();
						Long diferenciaDias = diferenciaMilis / (1000 * 60 * 60 * 24);
						dias += Integer.valueOf(diferenciaDias.intValue());
						}catch(ParseException e){
							e.printStackTrace();
						}
					}
				}
			}
		}
		
		// Rellenar dto.
		DtoDatosPublicacion dto = new DtoDatosPublicacion();
		dto.setIdActivo(idActivo);
		dto.setTotalDiasPublicado(dias);
		if(estadoPublicacionPortalesExternos){
			dto.setPortalesExternos(this.ESTADO_PORTALES_EXTERNOS_PUBLICADO);
		} else {
			dto.setPortalesExternos(this.ESTADO_PORTALES_EXTERNOS_NO_PUBLICADO);
		}
		return dto;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoPropuestaActivosVinculados> getPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto) {
		Page p = activoDao.getPropuestaActivosVinculadosByActivo(dto);
		List<PropuestaActivosVinculados> activosVinculados = (List<PropuestaActivosVinculados>) p.getResults();
		List<DtoPropuestaActivosVinculados> dtoActivosVinculados = new ArrayList<DtoPropuestaActivosVinculados>();
		
		for(PropuestaActivosVinculados vinculado: activosVinculados) {
			DtoPropuestaActivosVinculados nuevoDto = new DtoPropuestaActivosVinculados();
			try {
				beanUtilNotNull.copyProperty(nuevoDto, "id", vinculado.getId());
				beanUtilNotNull.copyProperty(nuevoDto, "activoVinculadoNumero", vinculado.getActivoVinculado().getNumActivo());
				beanUtilNotNull.copyProperty(nuevoDto, "activoVinculadoID", vinculado.getActivoVinculado().getId());
				beanUtilNotNull.copyProperty(nuevoDto, "totalCount", p.getTotalCount());
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
			
			if(!Checks.esNulo(nuevoDto)) {
				dtoActivosVinculados.add(nuevoDto);
			}
		}

		return dtoActivosVinculados;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto) {
		PropuestaActivosVinculados propuestaActivosVinculados = new PropuestaActivosVinculados();
		Activo activoOrigen = activoDao.get(dto.getActivoOrigenID());
		Activo activoVinculado = activoDao.getActivoByNumActivo(dto.getActivoVinculadoNumero());
		
		if(Checks.esNulo(activoVinculado) || Checks.esNulo(activoOrigen)){
			// No se ha encontrado algún activo. El activo origen por ID. El activo vinculado por numero de activo.
			return false;
		}
		
		try {
			beanUtilNotNull.copyProperty(propuestaActivosVinculados, "activoOrigen", activoOrigen);
			beanUtilNotNull.copyProperty(propuestaActivosVinculados, "activoVinculado", activoVinculado);
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		genericDao.save(PropuestaActivosVinculados.class, propuestaActivosVinculados);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deletePropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto) {
		Long id;
		
		try{
			id = Long.parseLong(dto.getId());
		} catch(NumberFormatException e) {
			e.printStackTrace();
			return false;
		}
		
		PropuestaActivosVinculados activoVinculado = activoDao.getPropuestaActivosVinculadosByID(id);
		
		if(!Checks.esNulo(activoVinculado)) {
			activoVinculado.getAuditoria().setBorrado(true);
			activoVinculado.getAuditoria().setFechaBorrar(new Date());
			activoVinculado.getAuditoria().setUsuarioBorrar(adapter.getUsuarioLogado().getUsername());
			genericDao.update(PropuestaActivosVinculados.class, activoVinculado);
			return true;
		}
		
		return false;
	}
	
	@Override
	public boolean isActivoDentroPerimetro(Long idActivo) {
		
		List<PerimetroActivo> perimetros = new ArrayList<PerimetroActivo>();
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.DESC, "auditoria.fechaCrear");
		perimetros = genericDao.getListOrdered(PerimetroActivo.class,order,filtro);
		
		if(Checks.estaVacio(perimetros) || perimetros.get(0).getIncluidoEnPerimetro() == 1) {
			return true;
		}
		else {
			return false;
		}
	}
	
	@Override
	public boolean isActivoConOfertaByEstado(Activo activo, String codEstado) {
		
		if(!Checks.estaVacio(activo.getOfertas())) {
			for(ActivoOferta activoOferta: activo.getOfertas()) {
				if(activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals(codEstado)) {
					return true;
				}
			}
		}
		
		return false;
	}
	
	@Override
	public boolean isActivoConReservaByEstado(Activo activo, String codEstado) {
		
		for(Reserva reserva : this.getReservasByActivo(activo)) {
			
			if(!Checks.esNulo(reserva.getEstadoReserva()) && reserva.getEstadoReserva().getCodigo().equals(codEstado)) {
				return true;
			}
		}
		
		return false;
	}
	
	@Override
	public List<Reserva> getReservasByActivo(Activo activo) {
		
		List<Reserva> reservas = new ArrayList<Reserva>();
		
		if(!Checks.estaVacio(activo.getOfertas())) {
			for(ActivoOferta activoOferta: activo.getOfertas()) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id",activoOferta.getPrimaryKey().getOferta().getId());
				ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);
				
				if(!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getReserva())) {
					reservas.add(expediente.getReserva());
				}
			}
		}
		
		return reservas;
	}
	
	@Override
	public boolean isActivoVendido(Activo activo) {
		
		if(!Checks.estaVacio(activo.getOfertas())) {
			for(ActivoOferta activoOferta: activo.getOfertas()) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id",activoOferta.getPrimaryKey().getOferta().getId());
				ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);
				
				if(!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getFormalizacion()) && !Checks.esNulo(expediente.getFormalizacion().getFechaEscritura())) {
					return true;
				}
			}
		}
		
		return false;
	}
}