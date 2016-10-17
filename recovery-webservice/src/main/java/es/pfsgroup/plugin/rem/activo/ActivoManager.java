package es.pfsgroup.plugin.rem.activo;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import es.capgemini.pfs.upload.dto.DtoFileUpload;
import es.capgemini.pfs.users.UsuarioManager;
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
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoValoraciones;
import es.pfsgroup.plugin.rem.model.ActivoInformeComercialHistoricoMediador;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoReglasPublicacionAutomatica;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CompradorExpediente.CompradorExpedientePk;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoReglasPublicacionAutomatica;
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
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPrecios;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.plugin.rem.model.DtoPropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.DtoTasacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Formalizacion;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.PropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.TitularesAdicionalesOferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaProveedoresActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaPublicacionActivo;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.PortalesDto;
import es.pfsgroup.plugin.rem.service.TabActivoService;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;
import es.pfsgroup.plugin.rem.visita.dao.VisitaDao;

@Service("activoManager")
public class ActivoManager extends BusinessOperationOverrider<ActivoApi> implements ActivoApi {
	
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
	
	@Autowired
	private UvemManagerApi uvemManagerApi;

	@Override
	public String managerName() {
		return "activoManager";
	}

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private DiccionarioTargetClassMap diccionarioTargetClassMap;
	
	@Autowired
	private UsuarioManager usuarioApi;

	@Autowired
	private RestApi restApi;

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

		// Actualiza los check de Admisión, Gestión y Situacion Comercial del activo
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
						DDEstadosVisitaOferta estadoVisitaOferta = (DDEstadosVisitaOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosVisitaOferta.class, DDEstadosVisitaOferta.ESTADO_VISITA_OFERTA_REALIZADA);
						oferta.setEstadoVisitaOferta(estadoVisitaOferta);
					} else {
						DDEstadosVisitaOferta estadoVisitaOferta = (DDEstadosVisitaOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosVisitaOferta.class, DDEstadosVisitaOferta.ESTADO_VISITA_OFERTA_PENDIENTE);
						oferta.setEstadoVisitaOferta(estadoVisitaOferta);
					}
					
					genericDao.save(Oferta.class, oferta);

				}
			}
			
			nuevoExpediente.setOferta(oferta);
			DDEstadosExpedienteComercial estadoExpediente = (DDEstadosExpedienteComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class, "01");
			nuevoExpediente.setEstado(estadoExpediente);
			nuevoExpediente.setNumExpediente(activoDao.getNextNumOferta());
			nuevoExpediente.setTrabajo(trabajo);
			
			
			
			
			//Creación de formalización y condicionantes. Evita errores en los trámites al preguntar por datos de algunos de estos objetos y aún no esten creados. Para ello creamos los objetos vacios con el unico
			//fin que se cree la fila.
			Formalizacion nuevaFormalizacion= new Formalizacion();
			nuevaFormalizacion.setAuditoria(Auditoria.getNewInstance());
			nuevaFormalizacion.setExpediente(nuevoExpediente);
			nuevoExpediente.setFormalizacion(nuevaFormalizacion);
			
			CondicionanteExpediente nuevoCondicionante= new CondicionanteExpediente();
			nuevoCondicionante.setAuditoria(Auditoria.getNewInstance());
			nuevoCondicionante.setExpediente(nuevoExpediente);
			nuevoExpediente.setCondicionante(nuevoCondicionante);
			
//			genericDao.save(ExpedienteComercial.class, nuevoExpediente);
			
			crearCompradores(oferta, nuevoExpediente);
			
			genericDao.save(ExpedienteComercial.class, nuevoExpediente);
			
			crearGastosExpediente(nuevoExpediente,oferta);
					
		}catch(Exception ex) {
			logger.error(ex.getMessage());
			return false;
		}
		
		return true;
		
	}
	
	
	public boolean crearCompradores(Oferta oferta, ExpedienteComercial nuevoExpediente){
		
		if(!Checks.esNulo(oferta.getCliente())){
			//Busca un comprador con el mismo dni que el cliente de la oferta
			Filter filtroComprador = genericDao.createFilter(FilterType.EQUALS, "documento", oferta.getCliente().getDocumento());
			Comprador compradorBusqueda = genericDao.get(Comprador.class, filtroComprador);
			List<CompradorExpediente> listaCompradoresExpediente= new ArrayList<CompradorExpediente>();
			CompradorExpediente compradorExpedienteNuevo= new CompradorExpediente();
			
			//si ya existe un comprador con dicho dni, crea una nueva relación Comprador-Expediente
			if(!Checks.esNulo(compradorBusqueda)){
				
				CompradorExpedientePk pk= new CompradorExpedientePk();
				pk.setComprador(compradorBusqueda);
				pk.setExpediente(nuevoExpediente);			
				compradorExpedienteNuevo.setPrimaryKey(pk);
				compradorExpedienteNuevo.setTitularReserva(0);
				compradorExpedienteNuevo.setTitularContratacion(1);
								
				listaCompradoresExpediente.add(compradorExpedienteNuevo);
			}
			else{ //Si no existe un comprador con dicho dni, lo crea, añade los datos posibles del cliente comercial y crea una nueva relación Comprador-Expediente 
				
				Comprador nuevoComprador= new Comprador();
				nuevoComprador.setClienteComercial(oferta.getCliente());
				nuevoComprador.setDocumento(oferta.getCliente().getDocumento());
				nuevoComprador.setNombre(oferta.getCliente().getNombre());
				nuevoComprador.setApellidos(oferta.getCliente().getApellidos());
				nuevoComprador.setTipoDocumento(oferta.getCliente().getTipoDocumento());
				nuevoComprador.setTelefono1(oferta.getCliente().getTelefono1());
				nuevoComprador.setTelefono2(oferta.getCliente().getTelefono2());
				nuevoComprador.setEmail(oferta.getCliente().getEmail());
				nuevoComprador.setDireccion(oferta.getCliente().getDireccion());
				
				if(!Checks.esNulo(oferta.getCliente().getMunicipio())){
					nuevoComprador.setLocalidad(oferta.getCliente().getMunicipio());
				}
				if(!Checks.esNulo(oferta.getCliente().getProvincia())){
					nuevoComprador.setProvincia(oferta.getCliente().getProvincia());
				}

				nuevoComprador.setCodigoPostal(oferta.getCliente().getCodigoPostal());
				
				genericDao.save(Comprador.class, nuevoComprador);
				
				CompradorExpedientePk pk= new CompradorExpedientePk();
				pk.setComprador(nuevoComprador);
				pk.setExpediente(nuevoExpediente);
				compradorExpedienteNuevo.setPrimaryKey(pk);
				compradorExpedienteNuevo.setTitularReserva(0);
				compradorExpedienteNuevo.setTitularContratacion(1);
								
				listaCompradoresExpediente.add(compradorExpedienteNuevo);
			}
			
			//Se recorre todos los titulares adicionales, estos tambien se crean como compradores y su relacion Comprador-Expediente con la diferencia de que los campos 
			//TitularReserva y TitularContratacion estan al contrario. Por decirlo de alguna forma son "Compradores secundarios"
			for(TitularesAdicionalesOferta titularAdicional: oferta.getTitularesAdicionales()){
				
				Filter filtroCompradorAdicional = genericDao.createFilter(FilterType.EQUALS, "documento", titularAdicional.getDocumento());
				Comprador compradorBusquedaAdicional = genericDao.get(Comprador.class, filtroCompradorAdicional);
				
				if(!Checks.esNulo(compradorBusquedaAdicional)){
					CompradorExpediente compradorExpedienteAdicionalNuevo= new CompradorExpediente();
					CompradorExpedientePk pk= new CompradorExpedientePk();
					
					pk.setComprador(compradorBusquedaAdicional);
					pk.setExpediente(nuevoExpediente);
					compradorExpedienteAdicionalNuevo.setPrimaryKey(pk);
					compradorExpedienteAdicionalNuevo.setTitularReserva(1);
					compradorExpedienteAdicionalNuevo.setTitularContratacion(0);
										
					listaCompradoresExpediente.add(compradorExpedienteAdicionalNuevo);
				}
				else{
					Comprador nuevoCompradorAdicional= new Comprador();
					CompradorExpediente compradorExpedienteAdicionalNuevo= new CompradorExpediente();
					
					nuevoCompradorAdicional.setDocumento(titularAdicional.getDocumento());
					nuevoCompradorAdicional.setNombre(titularAdicional.getNombre());
					nuevoCompradorAdicional.setTipoDocumento(titularAdicional.getTipoDocumento());
					genericDao.save(Comprador.class, nuevoCompradorAdicional);
					
					CompradorExpedientePk pk= new CompradorExpedientePk();
					
					pk.setComprador(nuevoCompradorAdicional);
					pk.setExpediente(nuevoExpediente);
					compradorExpedienteAdicionalNuevo.setPrimaryKey(pk);
					compradorExpedienteAdicionalNuevo.setTitularReserva(1);
					compradorExpedienteAdicionalNuevo.setTitularContratacion(0);
										
					listaCompradoresExpediente.add(compradorExpedienteAdicionalNuevo);
					
				}
				
			}
				
			//Una vez creadas las relaciones Comprador-Expediente se añaden al nuevo expediente
			nuevoExpediente.setCompradores(listaCompradoresExpediente);
			
			return true;
		}
		
		return false;
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
		
		return deleteValoracionPrecioConGuardadoEnHistorico(id,true);
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean deleteValoracionPrecioConGuardadoEnHistorico(Long id, Boolean guardadoEnHistorico) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoValoraciones activoValoracion = genericDao.get(ActivoValoraciones.class, filtro);
		
		if(guardadoEnHistorico) {
			saveActivoValoracionHistorico(activoValoracion);
			activoDao.deleteValoracionById(id);
		}
		else if(!Checks.esNulo(activoValoracion.getGestor()) && !adapter.getUsuarioLogado().equals(activoValoracion.getGestor())) {
			//Si el usuario logado es distinto al que ha creado la valoracion, no puede borrarla sin historico
			return false;
		}
		else {
			//Al anular el precio vigente, se hace un borrado lógico, y no se inserta en el histórico
			genericDao.deleteById(ActivoValoraciones.class, id);
		}

		return true;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.upload")
	@Transactional(readOnly = false)
	public String upload(WebFileItem webFileItem) throws Exception {

		return upload2(webFileItem, null);

	}
	
	@Override
	@BusinessOperation(overrides = "activoManager.uploadDocumento")
	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, Activo activoEntrada, String matricula) throws Exception {
		Activo activo=null;
		DDTipoDocumentoActivo tipoDocumento=null;;
		
		if(Checks.esNulo(activoEntrada)){
			activo = get(Long.parseLong(webFileItem.getParameter("idEntidad")));
			
			if (webFileItem.getParameter("tipo") == null)
				throw new Exception("Tipo no valido");
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
			tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class,filtro);
		}
		else{
			activo =activoEntrada;
			if(!Checks.esNulo(matricula)){
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class,filtro);
			}
		}
		
		try{
			if(!Checks.esNulo(activo) && !Checks.esNulo(tipoDocumento) ) {
			
				Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());
		
				ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo();
				adjuntoActivo.setAdjunto(adj);
				adjuntoActivo.setActivo(activo);
		
				adjuntoActivo.setIdDocRestClient(idDocRestClient);
				
				adjuntoActivo.setTipoDocumentoActivo(tipoDocumento);
		
				adjuntoActivo.setContentType(webFileItem.getFileItem().getContentType());
		
				adjuntoActivo.setTamanyo(webFileItem.getFileItem().getLength());
		
				adjuntoActivo.setNombre(webFileItem.getFileItem().getFileName());
		
				adjuntoActivo.setDescripcion(webFileItem.getParameter("descripcion"));
		
				adjuntoActivo.setFechaDocumento(new Date());
		
				Auditoria.save(adjuntoActivo);
		
				activo.getAdjuntos().add(adjuntoActivo);
		
				activoDao.save(activo);
			} else {
				throw new Exception("No se ha encontrado activo o tipo para relacionar adjunto");
			}
		}catch(Exception e){
			logger.error(e.getMessage());
		}
	
		return null;
		
	}

	@Override
	@BusinessOperation(overrides = "activoManager.upload2")
	@Transactional(readOnly = false)
	public String upload2(WebFileItem webFileItem, Long idDocRestClient) throws Exception {
		
		return uploadDocumento(webFileItem, idDocRestClient, null, null);

//		Activo activo = get(Long.parseLong(webFileItem.getParameter("idEntidad")));
//
//		Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());
//
//		ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo();
//		adjuntoActivo.setAdjunto(adj);
//		adjuntoActivo.setActivo(activo);
//
//		adjuntoActivo.setIdDocRestClient(idDocRestClient);
//
//		if (webFileItem.getParameter("tipo") == null)
//			throw new Exception("Tipo no valido");
//
//		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
//		DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class,
//				filtro);
//		adjuntoActivo.setTipoDocumentoActivo(tipoDocumento);
//
//		adjuntoActivo.setContentType(webFileItem.getFileItem().getContentType());
//
//		adjuntoActivo.setTamanyo(webFileItem.getFileItem().getLength());
//
//		adjuntoActivo.setNombre(webFileItem.getFileItem().getFileName());
//
//		adjuntoActivo.setDescripcion(webFileItem.getParameter("descripcion"));
//
//		adjuntoActivo.setFechaDocumento(new Date());
//
//		Auditoria.save(adjuntoActivo);
//
//		activo.getAdjuntos().add(adjuntoActivo);
//
//		activoDao.save(activo);
//
//		return null;
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
	private Activo tareaExternaToActivo(TareaExterna tareaExterna) {
		Activo activo = null;
		Trabajo trabajo = trabajoApi.tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			activo = trabajo.getActivo();
		}
		return activo;
	}
	
		
	public Boolean checkAdmisionAndGestion(TareaExterna tareaExterna){
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", tareaExternaToActivo(tareaExterna));
		VBusquedaPublicacionActivo publicacionActivo = genericDao.get(VBusquedaPublicacionActivo.class, filtro);
		
		return (publicacionActivo.getAdmision() && publicacionActivo.getGestion());
		
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

		condicionantesDisponibilidad.setOtro(dtoCondicionanteDisponibilidad.getOtro());

		genericDao.save(ActivoSituacionPosesoria.class, condicionantesDisponibilidad);
		
		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean updateCondicionantesDisponibilidad(Long idActivo) {
		// Actualizar estado disponibilidad comercial. Se realiza despues de haber guardado el cambio en los estados condicionantes.
		Activo activo = activoDao.get(idActivo);
		updaterState.updaterStateDisponibilidadComercial(activo);
		
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
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "id", condicion.getId());
				if(!Checks.esNulo(condicion.getActivo())) {
					beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "idActivo", condicion.getActivo().getId());
				}
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "texto", condicion.getTexto());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "fechaDesde", condicion.getFechaDesde());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "fechaHasta", condicion.getFechaHasta());
				if(!Checks.esNulo(condicion.getUsuarioAlta())){
					beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "usuarioAlta",condicion.getUsuarioAlta().getUsername());
				}
				if(!Checks.esNulo(condicion.getUsuarioBaja())){
					beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "usuarioBaja",condicion.getUsuarioBaja().getUsername());
				}
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
	public Boolean createCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica) {
		ActivoCondicionEspecifica condicionEspecifica = new ActivoCondicionEspecifica();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoCondicionEspecifica.getIdActivo());

		Activo activo = genericDao.get(Activo.class, filtro);

		try {
			beanUtilNotNull.copyProperty(condicionEspecifica, "texto", dtoCondicionEspecifica.getTexto());
			beanUtilNotNull.copyProperty(condicionEspecifica, "fechaDesde", new Date());
			beanUtilNotNull.copyProperty(condicionEspecifica, "usuarioAlta", adapter.getUsuarioLogado());
			beanUtilNotNull.copyProperty(condicionEspecifica, "activo", activo);
			
			// Actualizar la fehca de la anterior condición.
			ActivoCondicionEspecifica condicionAnterior = activoDao.getUltimaCondicion(dtoCondicionEspecifica.getIdActivo());
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

		if(!Checks.esNulo(condicionEspecifica)) {
			try {
				beanUtilNotNull.copyProperty(condicionEspecifica, "texto", dtoCondicionEspecifica.getTexto());
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
	
			genericDao.save(ActivoCondicionEspecifica.class, condicionEspecifica);
	
			return true;
		} else {
			return false;
		}
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean darDeBajaCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoCondicionEspecifica.getId()));
		ActivoCondicionEspecifica condicionEspecifica = genericDao.get(ActivoCondicionEspecifica.class, filtro);

		if(!Checks.esNulo(condicionEspecifica)) {
			try {
				beanUtilNotNull.copyProperty(condicionEspecifica, "fechaHasta", new Date());
				beanUtilNotNull.copyProperty(condicionEspecifica, "usuarioBaja", adapter.getUsuarioLogado());
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
	
			genericDao.save(ActivoCondicionEspecifica.class, condicionEspecifica);
	
			return true;
		} else {
			return false;
		}
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
		Order order = new Order(OrderType.DESC, "id");
		List<ActivoInformeComercialHistoricoMediador> listaHistoricoMediador = genericDao
				.getListOrdered(ActivoInformeComercialHistoricoMediador.class, order, filtro);
		
		List<DtoHistoricoMediador> listaDtoHistoricoMediador = new ArrayList<DtoHistoricoMediador>();
		
		for (ActivoInformeComercialHistoricoMediador historico : listaHistoricoMediador) {
			DtoHistoricoMediador dtoHistoricoMediador = new DtoHistoricoMediador();
			try {
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "id", historico.getId());
				beanUtilNotNull.copyProperty(dtoHistoricoMediador, "idActivo", idActivo);
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
	@Transactional(readOnly = false)
	public Boolean createHistoricoMediador(DtoHistoricoMediador dto) {
		ActivoInformeComercialHistoricoMediador historicoMediador = new ActivoInformeComercialHistoricoMediador();
		Activo activo = null;
		
		if(!Checks.esNulo(dto.getIdActivo())) {
			activo = activoDao.get(dto.getIdActivo());
		}
		
		try {
			// Terminar periodo de vigencia del último proveedor (fecha hasta).
			if(!Checks.esNulo(activo)) {
				Filter activoIDFiltro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				Order order = new Order(OrderType.DESC, "id");
				List<ActivoInformeComercialHistoricoMediador> historicoMediadorlist = genericDao.getListOrdered(ActivoInformeComercialHistoricoMediador.class, order, activoIDFiltro);
				if(!Checks.estaVacio(historicoMediadorlist)) {
					ActivoInformeComercialHistoricoMediador historicoAnteriorMediador = historicoMediadorlist.get(0); // El primero es el de ID más alto (el último).
					beanUtilNotNull.copyProperty(historicoAnteriorMediador, "fechaHasta", new Date());
					genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoAnteriorMediador);
				}
			}

			// Generar la nueva entrada de HistoricoMediador.
			beanUtilNotNull.copyProperty(historicoMediador, "fechaDesde", new Date());
			beanUtilNotNull.copyProperty(historicoMediador, "activo", activo);
			
			if(!Checks.esNulo(dto.getMediador())) {
				Filter proveedorFiltro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getMediador()));
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, proveedorFiltro);
				beanUtilNotNull.copyProperty(historicoMediador, "mediadorInforme", proveedor);
				
				// Asignar el nuevo proveedor de tipo mediador al activo, informacion comercial.
				if(!Checks.esNulo(activo.getInfoComercial())) {
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "mediadorInforme", proveedor);
					genericDao.save(Activo.class, activo);
				}
			}

			genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediador);
			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			return false;
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			return false;
		}
		
		return true;
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
		// si alguno de ellos es de publicación/publicación forzada.
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.ASC, "id");
		List<ActivoHistoricoEstadoPublicacion> listaEstadosPublicacion = genericDao
				.getListOrdered(ActivoHistoricoEstadoPublicacion.class, order, filtro);
		
		int dias = 0;
		boolean despublicado = false;
		
		for (ActivoHistoricoEstadoPublicacion estado : listaEstadosPublicacion) {
			if(!Checks.esNulo(estado.getEstadoPublicacion())){
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
	public boolean isActivoIncluidoEnPerimetro(Long idActivo) {
		
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
	public PerimetroActivo getPerimetroByIdActivo(Long idActivo) {
		
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		PerimetroActivo perimetroActivo = (PerimetroActivo) genericDao.get(PerimetroActivo.class, filtroActivo);
		
		//Si no existia un registro de activo bancario, crea un nuevo
		if(Checks.esNulo(perimetroActivo)){
			perimetroActivo = new PerimetroActivo();
			perimetroActivo.setAuditoria(new Auditoria());
			//Si no existia perimetro en BBDD, se deben tomar todas las condiciones marcadas
			perimetroActivo.setAplicaTramiteAdmision(1);
			perimetroActivo.setAplicaGestion(1);
			perimetroActivo.setAplicaAsignarMediador(1);
			perimetroActivo.setAplicaComercializar(1);
			perimetroActivo.setAplicaFormalizar(1);
		}
		
		return perimetroActivo;
		
	}
	
	@Override
	public ActivoBancario getActivoBancarioByIdActivo(Long idActivo) {

		//Obtiene el registro de ActivoBancario para el activo dado
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		ActivoBancario activoBancario = (ActivoBancario) genericDao.get(ActivoBancario.class, filtroActivo);
		
		//Si no existia un registro de activo bancario, crea un nuevo
		if(Checks.esNulo(activoBancario)){
			activoBancario = new ActivoBancario();
			activoBancario.setAuditoria(new Auditoria());
		}
		
		return activoBancario;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public PerimetroActivo saveOrUpdatePerimetroActivo(PerimetroActivo perimetroActivo) {
		try{

			if (!Checks.esNulo(perimetroActivo.getId())) {
				// update
				perimetroActivo.getAuditoria().setFechaModificar(new Date());
				perimetroActivo.getAuditoria().setUsuarioModificar(adapter.getUsuarioLogado().getUsername());
				genericDao.update(PerimetroActivo.class, perimetroActivo);
			} else {
				// insert
				perimetroActivo.getAuditoria().setFechaCrear(new Date());
				perimetroActivo.getAuditoria().setUsuarioCrear(adapter.getUsuarioLogado().getUsername());
				genericDao.save(PerimetroActivo.class, perimetroActivo);
			}

		}catch(Exception ex){
			logger.error(ex.getMessage());
			ex.printStackTrace();
		}
		
		return perimetroActivo;
	}
	
	@Override
	@Transactional(readOnly = false)
	public Activo updateActivoAsistida(Activo activo){
		//Actualizamos el perímetro
		PerimetroActivo perimetro = getPerimetroByIdActivo(activo.getId());
		
		if(Checks.esNulo(perimetro.getActivo()))
			perimetro.setActivo(activo);
		
		updatePerimetroAsistida(perimetro);
		
		//Bloqueamos los precios para que el activo no salga en los procesos automáticos. Esto podría ir en un proceso al dar de alta el activo.
		activo.setBloqueoPrecioFechaIni(new Date());
		activo.setGestorBloqueoPrecio(adapter.getUsuarioLogado());
		
		saveOrUpdate(activo);
		return activo;
	}
	
	@Override
	@Transactional(readOnly = false)
	public PerimetroActivo updatePerimetroAsistida(PerimetroActivo perimetroActivo){
		perimetroActivo.setIncluidoEnPerimetro(1);
		perimetroActivo.setAplicaAsignarMediador(0);
		perimetroActivo.setAplicaComercializar(1);
		perimetroActivo.setAplicaFormalizar(1);
		perimetroActivo.setAplicaGestion(0);
		perimetroActivo.setAplicaTramiteAdmision(0);
		perimetroActivo.setFechaAplicaComercializar(new Date());
		perimetroActivo.setFechaAplicaFormalizar(new Date());
		
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoComercializacion.CODIGO_ASISTIDA);
		DDMotivoComercializacion motivoComercializacion = genericDao.get(DDMotivoComercializacion.class, filtro);
		perimetroActivo.setMotivoAplicaComercializar(motivoComercializacion);
		
		saveOrUpdatePerimetroActivo(perimetroActivo);
		
		return perimetroActivo;
	}
	
	@Override
	@Transactional(readOnly = false)
	public ActivoBancario saveOrUpdateActivoBancario(ActivoBancario activoBancario) {
		try{
			if (!Checks.esNulo(activoBancario.getId())) {
				// update
				activoBancario.getAuditoria().setFechaModificar(new Date());
				activoBancario.getAuditoria().setUsuarioModificar(adapter.getUsuarioLogado().getUsername());
				genericDao.update(ActivoBancario.class, activoBancario);
			} else {
				// insert
				activoBancario.getAuditoria().setFechaCrear(new Date());
				activoBancario.getAuditoria().setUsuarioCrear(adapter.getUsuarioLogado().getUsername());
				genericDao.save(ActivoBancario.class, activoBancario);
			}

		}catch(Exception ex){
			logger.error(ex.getMessage());
			ex.printStackTrace();
		}
		
		return activoBancario;
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

	public boolean crearGastosExpediente(ExpedienteComercial nuevoExpediente, Oferta oferta){
		
		try{
			List<DDAccionGastos> accionesGastos= new ArrayList<DDAccionGastos>();
			DDAccionGastos accionGastoPrescripcion= (DDAccionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_PRESCRIPCION);
			DDAccionGastos accionGastoColaboracion= (DDAccionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_COLABORACION);
			DDAccionGastos accionGastoDoblePrescripcion= (DDAccionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_DOBLE_PRESCRIPCION);
			accionesGastos.add(accionGastoPrescripcion);
			accionesGastos.add(accionGastoColaboracion);
			
			if(!Checks.esNulo(oferta.getApiResponsable())){
				accionesGastos.add(accionGastoDoblePrescripcion);
			}
			
			for(DDAccionGastos accionGasto: accionesGastos){
				GastosExpediente gastoExpediente= new GastosExpediente();
				gastoExpediente.setAccionGastos(accionGasto);
				gastoExpediente.setExpediente(nuevoExpediente);
				
				DDDestinatarioGasto destinatarioGasto= (DDDestinatarioGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDDestinatarioGasto.class, DDDestinatarioGasto.CODIGO_HAYA);
				gastoExpediente.setDestinatarioGasto(destinatarioGasto);
				
				if(accionGasto.getCodigo().equals(DDAccionGastos.CODIGO_COLABORACION)){
					if(!Checks.esNulo(oferta.getCustodio())){
						gastoExpediente.setNombre(oferta.getCustodio().getNombre());
						gastoExpediente.setCodigo(oferta.getCustodio().getCodProveedorUvem());
						gastoExpediente.setProveedor(oferta.getCustodio());
					}
					else if(!Checks.esNulo(oferta.getFdv())){
						gastoExpediente.setNombre(oferta.getFdv().getNombre());
						gastoExpediente.setCodigo(oferta.getFdv().getCodProveedorUvem());
						gastoExpediente.setProveedor(oferta.getFdv());
					}
				}
				
				else if(accionGasto.getCodigo().equals(DDAccionGastos.CODIGO_PRESCRIPCION)){
					if(!Checks.esNulo(oferta.getPrescriptor())){
						gastoExpediente.setNombre(oferta.getPrescriptor().getNombre());
						gastoExpediente.setCodigo(oferta.getPrescriptor().getCodProveedorUvem());
						gastoExpediente.setProveedor(oferta.getPrescriptor());
					}
				}
				
				else if(accionGasto.getCodigo().equals(DDAccionGastos.CODIGO_DOBLE_PRESCRIPCION)){
					if(!Checks.esNulo(oferta.getApiResponsable())){
						gastoExpediente.setNombre(oferta.getApiResponsable().getNombre());
						gastoExpediente.setCodigo(oferta.getApiResponsable().getCodProveedorUvem());
						gastoExpediente.setProveedor(oferta.getApiResponsable());
					}
				}
				
				genericDao.save(GastosExpediente.class, gastoExpediente);
			}
		}catch(Exception ex) {
			logger.error(ex.getMessage());
			return false;
		}
		
		return true;
	}
	
	@Override
	public boolean isIntegradoAgrupacionAsistida(Activo activo) {

		for(ActivoAgrupacionActivo agrupacionActivo : activo.getAgrupaciones()) {

			Date fechaFinVigencia = agrupacionActivo.getAgrupacion().getFechaFinVigencia();
			fechaFinVigencia = !Checks.esNulo(fechaFinVigencia) ? new Date(fechaFinVigencia.getTime()) : null;
			
			if(!Checks.esNulo(agrupacionActivo.getAgrupacion().getTipoAgrupacion()) && 
				agrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA) &&
				!Checks.esNulo(fechaFinVigencia) && fechaFinVigencia.after(new Date())) 
			{
				return true;
			}
		}
		
		return false;
	}
	
	@Override
	public boolean isActivoAsistido(Activo activo){
		if(!Checks.esNulo(activo.getSubcartera()))
			if(DDSubcartera.CODIGO_CAJ_ASISTIDA.equals(activo.getSubcartera().getCodigo())
					|| DDSubcartera.CODIGO_SAR_ASISTIDA.equals(activo.getSubcartera().getCodigo())
					|| DDSubcartera.CODIGO_BAN_ASISTIDA.equals(activo.getSubcartera().getCodigo()))
						return true;
		return false;
	}

	@Override
	public Integer getNumActivosPublicadosByAgrupacion(List<ActivoAgrupacionActivo> activos) {
		
		Integer contador = 0;
		
		for(ActivoAgrupacionActivo activoAgrupacion : activos) {
			if(!Checks.esNulo(activoAgrupacion.getActivo().getEstadoPublicacion())) {
				
				String codEstadoPublicacion = activoAgrupacion.getActivo().getEstadoPublicacion().getCodigo();
				if(codEstadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO) || codEstadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO) ||
					codEstadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO) || codEstadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO) ||
					codEstadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO)) 
				{
					contador++;
				}
			}	
		}
		
		return contador;
	}



	@Override
	@Transactional(readOnly = false)
	public Boolean solicitarTasacion(Long idActivo) throws Exception {
		int tasacionID;
		
		try{
			Activo activo = activoDao.get(idActivo);
			if(!Checks.esNulo(activo)) {
				// Se especifica bankia por que tan solo se va a poder demandar la tasación desde bankia.
				tasacionID = uvemManagerApi.ejecutarSolicitarTasacion(activo.getNumActivoUvem(), adapter.getUsuarioLogado().getUsername(), "BANKIA");
			} else {
				return false;
			}
		}catch(Exception e){
			e.printStackTrace();
			throw new Exception("No se ha podido obtener la tasación");
		}
		
		if(!Checks.esNulo(tasacionID)){
			try{
				Activo activo = activoDao.get(idActivo);
			
				if(!Checks.esNulo(activo)) {
					// Generar un 'BIE_VALORACION' con el 'BIEN_ID' del activo.
					NMBValoracionesBien valoracionBien = new NMBValoracionesBien();
					beanUtilNotNull.copyProperty(valoracionBien, "bien", activo.getBien());
					valoracionBien = genericDao.save(NMBValoracionesBien.class, valoracionBien);
					
					if(!Checks.esNulo(valoracionBien)) {
						// Generar una tasacion con el ID de activo y el ID de la valoracion del bien.
						ActivoTasacion tasacion = new ActivoTasacion();
						
						beanUtilNotNull.copyProperty(tasacion, "idExterno", tasacionID);
						beanUtilNotNull.copyProperty(tasacion, "activo", activo);
						beanUtilNotNull.copyProperty(tasacion, "valoracionBien", valoracionBien);
						
						genericDao.save(ActivoTasacion.class, tasacion);
					}
				}
			}catch(Exception e){
				e.printStackTrace();
				return false;
			}
		} else {
			throw new Exception("No se ha podido obtener la tasación");
		}

		return true;
	}

	@Override
	public DtoTasacion getSolicitudTasacionBankia(Long id) {
		ActivoTasacion activoTasacion = activoDao.getActivoTasacion(id);
		DtoTasacion dtoTasacion = new DtoTasacion();
		if(!Checks.esNulo(activoTasacion)) {
			
			try {
				beanUtilNotNull.copyProperty(dtoTasacion, "id", activoTasacion.getId());
				beanUtilNotNull.copyProperty(dtoTasacion, "fechaSolicitudTasacion", activoTasacion.getAuditoria().getFechaCrear());
				beanUtilNotNull.copyProperty(dtoTasacion, "gestorSolicitud", activoTasacion.getAuditoria().getUsuarioCrear());
				beanUtilNotNull.copyProperty(dtoTasacion, "externoID", activoTasacion.getIdExterno());
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
		}
		
		return dtoTasacion;
	}
	
	@Override
	@BusinessOperationDefinition("activoManager.comprobarActivoComercializable")
	public Boolean comprobarActivoComercializable(Long idActivo) {
		PerimetroActivo perimetro = this.getPerimetroByIdActivo(idActivo);
		
		return perimetro.getAplicaComercializar() == 1 ? true : false;
	}
   
	@Override
	@BusinessOperationDefinition("activoManager.comprobarObligatoriosDesignarMediador")
	public String comprobarObligatoriosDesignarMediador(Long idActivo) throws Exception {

		Activo activo = this.get(idActivo);
		String mensaje = new String();

		// Validaciones datos obligatorios correspondientes a Publicacion / Informe comercial
		// del activo
		// Validación mediador
		if (Checks.esNulo(activo.getInfoComercial()) || Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
			mensaje = mensaje.concat(
					messageServices.getMessage("tramite.admision.DesignarMediador.validacionPre.mediador"));
		}

		if (!Checks.esNulo(mensaje)) {
			mensaje = messageServices.getMessage("tramite.admision.DesignarMediador.validacionPre.debeInformar")
					.concat(mensaje);
		}

		return mensaje;
	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> saveOrUpdate(List<PortalesDto> listaPortalesDto) {
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		HashMap<String, List<String>> errorsList = null;
		ActivoSituacionPosesoria activoSituacionPosesoria = null;
		Map<String, Object> map = null;
		Activo activo = null;
		for (int i = 0; i < listaPortalesDto.size(); i++) {

			PortalesDto portalesDto = listaPortalesDto.get(i);
			errorsList = restApi.validateRequestObject(portalesDto, TIPO_VALIDACION.INSERT);
			map = new HashMap<String, Object>();
			if (errorsList.size() == 0) {

				activo = this.getByNumActivo(portalesDto.getIdActivoHaya());
				Usuario user = usuarioApi.get(portalesDto.getIdUsuarioRemAccion());

				if (activo.getSituacionPosesoria() == null) {

					Date fechaCrear = new Date();
					activoSituacionPosesoria = new ActivoSituacionPosesoria();
					activoSituacionPosesoria.getAuditoria().setUsuarioCrear(user.getUsername());
					activoSituacionPosesoria.getAuditoria().setFechaCrear(fechaCrear);
					activoSituacionPosesoria.setActivo(activo);
					activo.setSituacionPosesoria(activoSituacionPosesoria);

				}

				activoSituacionPosesoria = activo.getSituacionPosesoria();
				activoSituacionPosesoria.setPublicadoPortalExterno(portalesDto.getPublicado());

				Date fechaMod = new Date();
				activoSituacionPosesoria.getAuditoria().setUsuarioModificar(user.getUsername());
				activoSituacionPosesoria.getAuditoria().setFechaModificar(fechaMod);

				if (this.saveOrUpdate(activo)) {
					map.put("idActivoHaya", portalesDto.getIdActivoHaya());
					map.put("idUsuarioRemAccion", portalesDto.getIdUsuarioRemAccion());
					map.put("success", true);
				} else {
					map.put("idActivoHaya", portalesDto.getIdActivoHaya());
					map.put("idUsuarioRemAccion", portalesDto.getIdUsuarioRemAccion());
					map.put("success", false);
				}
			} else {
				map.put("idActivoHaya", portalesDto.getIdActivoHaya());
				map.put("idUsuarioRemAccion", portalesDto.getIdUsuarioRemAccion());
				map.put("success", false);
				map.put("invalidFields", errorsList);
			}
			listaRespuesta.add(map);
		}
		return listaRespuesta;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoReglasPublicacionAutomatica> getReglasPublicacionAutomatica(DtoReglasPublicacionAutomatica dto) {
		Page p = genericDao.getPage(ActivoReglasPublicacionAutomatica.class, dto);
		List<ActivoReglasPublicacionAutomatica> reglas = (List<ActivoReglasPublicacionAutomatica>) p.getResults();
		List<DtoReglasPublicacionAutomatica> reglasDto = new ArrayList<DtoReglasPublicacionAutomatica>();
		
		for(ActivoReglasPublicacionAutomatica regla : reglas) {
			DtoReglasPublicacionAutomatica nuevoDto = new DtoReglasPublicacionAutomatica();
			try {
				beanUtilNotNull.copyProperty(nuevoDto, "idRegla", regla.getId());
				beanUtilNotNull.copyProperty(nuevoDto, "incluidoAgrupacionAsistida", regla.getIncluidoAgrupacionAsistida());
				if(!Checks.esNulo(regla.getCartera())) {
					beanUtilNotNull.copyProperty(nuevoDto, "carteraCodigo", regla.getCartera().getCodigo());
				}
				if(!Checks.esNulo(regla.getTipoActivo())) {
					beanUtilNotNull.copyProperty(nuevoDto, "tipoActivoCodigo", regla.getTipoActivo().getCodigo());
				}
				if(!Checks.esNulo(regla.getSubtipoActivo())) {
					beanUtilNotNull.copyProperty(nuevoDto, "subtipoActivoCodigo", regla.getSubtipoActivo().getCodigo());
				}
				
				nuevoDto.setTotalCount(p.getTotalCount());
				
				reglasDto.add(nuevoDto);
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
		}
		return reglasDto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto) {
		ActivoReglasPublicacionAutomatica arpa = new ActivoReglasPublicacionAutomatica();
		
		try {
			beanUtilNotNull.copyProperty(arpa, "incluidoAgrupacionAsistida", dto.getIncluidoAgrupacionAsistida());
			if(!Checks.esNulo(dto.getCarteraCodigo())) {
				DDCartera cartera = (DDCartera) utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class, dto.getCarteraCodigo());
				beanUtilNotNull.copyProperty(arpa, "cartera", cartera);
			}
			if(!Checks.esNulo(dto.getTipoActivoCodigo())) {
				DDTipoActivo tipo = (DDTipoActivo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoActivo.class, dto.getTipoActivoCodigo());
				beanUtilNotNull.copyProperty(arpa, "tipoActivo", tipo);
			}
			if(!Checks.esNulo(dto.getSubtipoActivoCodigo())) {
				DDSubtipoActivo subtipo = (DDSubtipoActivo) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoActivo.class, dto.getSubtipoActivoCodigo());
				beanUtilNotNull.copyProperty(arpa, "subtipoActivo", subtipo);
			}
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			return false;
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			return false;
		}
		
		genericDao.save(ActivoReglasPublicacionAutomatica.class, arpa);
		
		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto) {
		if(Checks.esNulo(dto.getIdRegla())){
			return false;
		}
		Filter reglaIDFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdRegla()));
		ActivoReglasPublicacionAutomatica arpa = genericDao.get(ActivoReglasPublicacionAutomatica.class, reglaIDFilter);
		
		if(Checks.esNulo(arpa)) {
			return false;
		}
		
		try {
			beanUtilNotNull.copyProperty(arpa, "auditoria.borrado", "1");
			beanUtilNotNull.copyProperty(arpa, "auditoria.fechaBorrar", new Date());
			beanUtilNotNull.copyProperty(arpa, "auditoria.usuarioBorrar", adapter.getUsuarioLogado().getUsername());
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			return false;
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			return false;
		}
		
		genericDao.save(ActivoReglasPublicacionAutomatica.class, arpa);
		
		return true;
	}

	public List<VBusquedaProveedoresActivo> getProveedorByActivo(Long idActivo){
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo",idActivo.toString());
		List<VBusquedaProveedoresActivo> listadoProveedores = genericDao.getList(VBusquedaProveedoresActivo.class, filtro);
		
		
		return listadoProveedores;
		
	}
	
	public List<VBusquedaGastoActivo> getGastoByActivo(Long idActivo, Long idProveedor){
			
		List<VBusquedaGastoActivo> vGastosActivos= new ArrayList<VBusquedaGastoActivo>();
		
		if(!Checks.esNulo(idActivo) && !Checks.esNulo(idProveedor)){
			Filter filtroGastoActivo = genericDao.createFilter(FilterType.EQUALS, "idActivo",idActivo);
			Filter filtroGastoProveedor = genericDao.createFilter(FilterType.EQUALS, "idProveedor",idProveedor);
			vGastosActivos= genericDao.getList(VBusquedaGastoActivo.class, filtroGastoActivo,filtroGastoProveedor);
		}
		
		return vGastosActivos;
	}

}