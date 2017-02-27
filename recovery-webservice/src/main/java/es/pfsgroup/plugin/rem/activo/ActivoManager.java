package es.pfsgroup.plugin.rem.activo;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.sql.SQLException;
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
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
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
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoCargasApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.condiciontanteo.CondicionTanteoApi;
import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoCargas;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoValoraciones;
import es.pfsgroup.plugin.rem.model.ActivoInformeComercialHistoricoMediador;
import es.pfsgroup.plugin.rem.model.ActivoIntegrado;
import es.pfsgroup.plugin.rem.model.ActivoLlave;
import es.pfsgroup.plugin.rem.model.ActivoMovimientoLlave;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoReglasPublicacionAutomatica;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CompradorExpediente.CompradorExpedientePk;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoActivoCargas;
import es.pfsgroup.plugin.rem.model.DtoActivoDatosRegistrales;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivoIntegrado;
import es.pfsgroup.plugin.rem.model.DtoActivosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoComercialActivo;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPrecios;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoLlaves;
import es.pfsgroup.plugin.rem.model.DtoMovimientoLlave;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.plugin.rem.model.DtoPropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoReglasPublicacionAutomatica;
import es.pfsgroup.plugin.rem.model.DtoTasacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Formalizacion;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.PropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.TitularesAdicionalesOferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaProveedoresActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaPublicacionActivo;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencion;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCargaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedorHonorario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PRINCIPAL;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PROPIEDAD;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.SITUACION;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.TIPO;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.File;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.PortalesDto;
import es.pfsgroup.plugin.rem.service.TabActivoService;
import es.pfsgroup.plugin.rem.tareasactivo.TareaActivoManager;
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

	@Autowired
	GestorDocumentalFotosApi gestorDocumentalFotos;

	@Autowired
	private ActivoCargasApi activoCargasApi;

	@Autowired
	private OfertaApi ofertaApi;

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

	@Autowired
	private TareaActivoManager tareaActivoManager;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Autowired
	private List<CondicionTanteoApi> condiciones;

	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	private static final String AVISO_MENSAJE_ACTIVO_EN_LOTE_COMERCIAL = "activo.aviso.aceptatar.oferta.activo.dentro.lote.comercial";

	@Override
	@BusinessOperation(overrides = "activoManager.get")
	public Activo get(Long id) {
		return activoDao.get(id);
	}

	@Override
	public Activo getByNumActivo(Long id) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numActivo", id);
		return genericDao.get(Activo.class, filter);
	}

	@Override
	public Activo getByNumActivoUvem(Long id) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numActivoUvem", id);
		return genericDao.get(Activo.class, filter);
	}

	@Override
	@BusinessOperation(overrides = "activoManager.saveOrUpdate")
	@Transactional
	public boolean saveOrUpdate(Activo activo) {
		activoDao.saveOrUpdate(activo);

		// Actualiza los check de Admisión, Gestión y Situacion Comercial del
		// activo
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

		Activo activo = get(dtoAdjunto.getIdEntidad());
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

			ExpedienteComercial expediente = expedienteComercialApi.getExpedienteComercialResetPBC(activo);
			if (!Checks.esNulo(expediente)) {
				ofertaApi.resetPBC(expediente);
			}

		} catch (Exception ex) {
			logger.error("Error en activoManager",ex);
			resultado = false;
		}

		return resultado;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.saveOfertaActivo")
	@Transactional(readOnly = false)
	public boolean saveOfertaActivo(DtoOfertaActivo dto) throws JsonViewerException {

		boolean resultado = true;
		// Si el activo pertenece a un lote comercial, no se pueden aceptar
		// ofertas de forma individual en el activo
		if (activoAgrupacionActivoDao.activoEnAgrupacionLoteComercial(dto.getIdActivo())) {
			throw new JsonViewerException(messageServices.getMessage(AVISO_MENSAJE_ACTIVO_EN_LOTE_COMERCIAL));
		}

		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdOferta());
			Oferta oferta = genericDao.get(Oferta.class, filtro);

			DDEstadoOferta tipoOferta = (DDEstadoOferta) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDEstadoOferta.class, dto.getCodigoEstadoOferta());

			oferta.setEstadoOferta(tipoOferta);

			// Al aceptar la oferta, se crea el trabajo de sancion oferta y el
			// expediente comercial
			if (DDEstadoOferta.CODIGO_ACEPTADA.equals(tipoOferta.getCodigo())) {
				List<Activo> listaActivos = new ArrayList<Activo>();
				for (ActivoOferta activoOferta : oferta.getActivosOferta()) {
					listaActivos.add(activoOferta.getPrimaryKey().getActivo());
				}
				DDSubtipoTrabajo subtipoTrabajo = (DDSubtipoTrabajo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSubtipoTrabajo.class, this.getSubtipoTrabajoByOferta(oferta));
				Trabajo trabajo = trabajoApi.create(subtipoTrabajo, listaActivos, null);

				crearExpediente(oferta, trabajo);
			}

			genericDao.update(Oferta.class, oferta);

		} catch (Exception ex) {
			logger.error("Error en activoManager",ex);
			resultado = false;
		}

		return resultado;
	}

	public boolean crearExpediente(Oferta oferta, Trabajo trabajo) {

		try {
			ExpedienteComercial nuevoExpediente = new ExpedienteComercial();

			if (!Checks.esNulo(oferta.getVisita())) {
				DDEstadosVisitaOferta estadoVisitaOferta = (DDEstadosVisitaOferta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDEstadosVisitaOferta.class,
								DDEstadosVisitaOferta.ESTADO_VISITA_OFERTA_REALIZADA);
				oferta.setEstadoVisitaOferta(estadoVisitaOferta);
			} else {
				DDEstadosVisitaOferta estadoVisitaOferta = (DDEstadosVisitaOferta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDEstadosVisitaOferta.class,
								DDEstadosVisitaOferta.ESTADO_VISITA_OFERTA_PENDIENTE);
				oferta.setEstadoVisitaOferta(estadoVisitaOferta);
			}

			genericDao.save(Oferta.class, oferta);

			nuevoExpediente.setOferta(oferta);
			DDEstadosExpedienteComercial estadoExpediente = (DDEstadosExpedienteComercial) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class, "01");
			nuevoExpediente.setEstado(estadoExpediente);
			nuevoExpediente.setNumExpediente(activoDao.getNextNumExpedienteComercial());
			nuevoExpediente.setTrabajo(trabajo);

			// Creación de formalización y condicionantes. Evita errores en los
			// trámites al preguntar por datos de algunos de estos objetos y aún
			// no esten creados. Para ello creamos los objetos vacios con el
			// unico
			// fin que se cree la fila.
			Formalizacion nuevaFormalizacion = new Formalizacion();
			nuevaFormalizacion.setAuditoria(Auditoria.getNewInstance());
			nuevaFormalizacion.setExpediente(nuevoExpediente);
			nuevoExpediente.setFormalizacion(nuevaFormalizacion);

			CondicionanteExpediente nuevoCondicionante = new CondicionanteExpediente();
			nuevoCondicionante.setAuditoria(Auditoria.getNewInstance());
			nuevoCondicionante.setExpediente(nuevoExpediente);
			// Comprobamos si tiene derecho de tanteo
			boolean noCumple = false;
			for (CondicionTanteoApi condicion : condiciones) {
				if (!condicion.checkCondicion(oferta.getActivoPrincipal()))
					noCumple = true;
			}
			if (!noCumple)
				nuevoCondicionante.setSujetoTanteoRetracto(1);

			nuevoExpediente.setCondicionante(nuevoCondicionante);

			// Establecer la fecha de aceptación/alta a ahora.
			nuevoExpediente.setFechaAlta(new Date());

			crearCompradores(oferta, nuevoExpediente);

			genericDao.save(ExpedienteComercial.class, nuevoExpediente);

			crearGastosExpediente(nuevoExpediente, oferta);

			// Se asigna un gestor de Formalización al crear un nuevo
			// expediente.
			asignarGestorYSupervisorFormalizacionToExpediente(nuevoExpediente);

		} catch (Exception ex) {
			logger.error("Error en activoManager",ex);
			return false;
		}

		return true;
	}

	public boolean crearCompradores(Oferta oferta, ExpedienteComercial nuevoExpediente) {

		if (!Checks.esNulo(oferta.getCliente())) {
			// Busca un comprador con el mismo dni que el cliente de la oferta
			Filter filtroComprador = genericDao.createFilter(FilterType.EQUALS, "documento",
					oferta.getCliente().getDocumento());
			Comprador compradorBusqueda = genericDao.get(Comprador.class, filtroComprador);
			List<CompradorExpediente> listaCompradoresExpediente = new ArrayList<CompradorExpediente>();
			CompradorExpediente compradorExpedienteNuevo = new CompradorExpediente();

			// si ya existe un comprador con dicho dni, crea una nueva relación
			// Comprador-Expediente
			if (!Checks.esNulo(compradorBusqueda)) {

				CompradorExpedientePk pk = new CompradorExpedientePk();
				pk.setComprador(compradorBusqueda);
				pk.setExpediente(nuevoExpediente);
				compradorExpedienteNuevo.setPrimaryKey(pk);
				compradorExpedienteNuevo.setTitularReserva(0);
				compradorExpedienteNuevo.setTitularContratacion(1);
				compradorExpedienteNuevo.setPorcionCompra(100.00);

				listaCompradoresExpediente.add(compradorExpedienteNuevo);
			} else { // Si no existe un comprador con dicho dni, lo crea, añade
						// los datos posibles del cliente comercial y crea una
						// nueva relación Comprador-Expediente

				Comprador nuevoComprador = new Comprador();
				nuevoComprador.setClienteComercial(oferta.getCliente());
				nuevoComprador.setDocumento(oferta.getCliente().getDocumento());
				nuevoComprador.setNombre(oferta.getCliente().getNombre());
				nuevoComprador.setApellidos(oferta.getCliente().getApellidos());
				nuevoComprador.setTipoDocumento(oferta.getCliente().getTipoDocumento());
				nuevoComprador.setTelefono1(oferta.getCliente().getTelefono1());
				nuevoComprador.setTelefono2(oferta.getCliente().getTelefono2());
				nuevoComprador.setEmail(oferta.getCliente().getEmail());
				nuevoComprador.setDireccion(oferta.getCliente().getDireccion());

				if (!Checks.esNulo(oferta.getCliente().getMunicipio())) {
					nuevoComprador.setLocalidad(oferta.getCliente().getMunicipio());
				}
				if (!Checks.esNulo(oferta.getCliente().getProvincia())) {
					nuevoComprador.setProvincia(oferta.getCliente().getProvincia());
				}

				nuevoComprador.setCodigoPostal(oferta.getCliente().getCodigoPostal());

				genericDao.save(Comprador.class, nuevoComprador);

				CompradorExpedientePk pk = new CompradorExpedientePk();
				pk.setComprador(nuevoComprador);
				pk.setExpediente(nuevoExpediente);
				compradorExpedienteNuevo.setPrimaryKey(pk);
				compradorExpedienteNuevo.setTitularReserva(0);
				compradorExpedienteNuevo.setTitularContratacion(1);
				compradorExpedienteNuevo.setPorcionCompra(100.00);

				listaCompradoresExpediente.add(compradorExpedienteNuevo);
			}

			// Se recorre todos los titulares adicionales, estos tambien se
			// crean como compradores y su relacion Comprador-Expediente con la
			// diferencia de que los campos
			// TitularReserva y TitularContratacion estan al contrario. Por
			// decirlo de alguna forma son "Compradores secundarios"
			for (TitularesAdicionalesOferta titularAdicional : oferta.getTitularesAdicionales()) {

				Filter filtroCompradorAdicional = genericDao.createFilter(FilterType.EQUALS, "documento",
						titularAdicional.getDocumento());
				Comprador compradorBusquedaAdicional = genericDao.get(Comprador.class, filtroCompradorAdicional);

				if (!Checks.esNulo(compradorBusquedaAdicional)) {
					CompradorExpediente compradorExpedienteAdicionalNuevo = new CompradorExpediente();
					CompradorExpedientePk pk = new CompradorExpedientePk();

					pk.setComprador(compradorBusquedaAdicional);
					pk.setExpediente(nuevoExpediente);
					compradorExpedienteAdicionalNuevo.setPrimaryKey(pk);
					compradorExpedienteAdicionalNuevo.setTitularReserva(1);
					compradorExpedienteAdicionalNuevo.setTitularContratacion(0);
					compradorExpedienteAdicionalNuevo.setPorcionCompra(100.00);

					listaCompradoresExpediente.add(compradorExpedienteAdicionalNuevo);
				} else {
					Comprador nuevoCompradorAdicional = new Comprador();
					CompradorExpediente compradorExpedienteAdicionalNuevo = new CompradorExpediente();

					nuevoCompradorAdicional.setDocumento(titularAdicional.getDocumento());
					nuevoCompradorAdicional.setNombre(titularAdicional.getNombre());
					nuevoCompradorAdicional.setTipoDocumento(titularAdicional.getTipoDocumento());
					genericDao.save(Comprador.class, nuevoCompradorAdicional);

					CompradorExpedientePk pk = new CompradorExpedientePk();

					pk.setComprador(nuevoCompradorAdicional);
					pk.setExpediente(nuevoExpediente);
					compradorExpedienteAdicionalNuevo.setPrimaryKey(pk);
					compradorExpedienteAdicionalNuevo.setTitularReserva(1);
					compradorExpedienteAdicionalNuevo.setTitularContratacion(0);
					compradorExpedienteAdicionalNuevo.setPorcionCompra(100.00);

					listaCompradoresExpediente.add(compradorExpedienteAdicionalNuevo);

				}

			}

			// Una vez creadas las relaciones Comprador-Expediente se añaden al
			// nuevo expediente
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
				// Si ya existia una valoracion, actualizamos los datos
				// Pero antes, pasa la valoracion anterior al historico si se ha
				// modificado el precio o las fechas.

				if ((!Checks.esNulo(dto.getFechaFin()) && !dto.getFechaFin().equals(activoValoracion.getFechaFin()))
						|| (!Checks.esNulo(activoValoracion.getFechaFin()) && Checks.esNulo(dto.getFechaFin()))
						|| (!Checks.esNulo(dto.getFechaInicio())
								&& !dto.getFechaInicio().equals(activoValoracion.getFechaInicio()))
						|| (!Checks.esNulo(dto.getImporte())
								&& !dto.getImporte().equals(activoValoracion.getImporte()))) {
					saveActivoValoracionHistorico(activoValoracion);
				}

				beanUtilNotNull.copyProperties(activoValoracion, dto);

				activoValoracion.setFechaCarga(new Date());

				// Si los nuevos datos no traen observaciones (null),
				// debe quitar las escritas para el precio o valoracion anterior
				// activoValoracion.setObservaciones(dto.getObservaciones());

				activoValoracion.setGestor(adapter.getUsuarioLogado());

				genericDao.update(ActivoValoraciones.class, activoValoracion);

			} else {

				// Si no existia una valoracion del tipo indicado, crea una
				// nueva
				// valoracion de este tipo (para un activo)
				activoValoracion = new ActivoValoraciones();
				beanUtilNotNull.copyProperties(activoValoracion, dto);
				activoValoracion.setFechaCarga(new Date());

				DDTipoPrecio tipoPrecio = (DDTipoPrecio) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoPrecio.class, dto.getCodigoTipoPrecio());

				activoValoracion.setActivo(activo);
				activoValoracion.setTipoPrecio(tipoPrecio);
				activoValoracion.setGestor(adapter.getUsuarioLogado());

				genericDao.save(ActivoValoraciones.class, activoValoracion);
			}

			if (DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(dto.getCodigoTipoPrecio())) {
				// Actualizar el tipoComercialización del activo
				updaterState.updaterStateTipoComercializacion(activo);
			}

		} catch (Exception ex) {
			logger.error("Error en activoManager",ex);
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
		historicoValoracion.setFechaFin(new Date());
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

		return deleteValoracionPrecioConGuardadoEnHistorico(id, true);
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteValoracionPrecioConGuardadoEnHistorico(Long id, Boolean guardadoEnHistorico) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoValoraciones activoValoracion = genericDao.get(ActivoValoraciones.class, filtro);

		if (guardadoEnHistorico) {
			saveActivoValoracionHistorico(activoValoracion);
			activoDao.deleteValoracionById(id);
		} else if (!Checks.esNulo(activoValoracion.getGestor())
				&& !adapter.getUsuarioLogado().equals(activoValoracion.getGestor())) {
			// Si el usuario logado es distinto al que ha creado la valoracion,
			// no puede borrarla sin historico
			return false;
		} else {
			// Al anular el precio vigente, se hace un borrado lógico, y no se
			// inserta en el histórico
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
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, Activo activoEntrada, String matricula)
			throws Exception {
		Activo activo = null;
		DDTipoDocumentoActivo tipoDocumento = null;
		;

		if (Checks.esNulo(activoEntrada)) {
			activo = get(Long.parseLong(webFileItem.getParameter("idEntidad")));

			if (webFileItem.getParameter("tipo") == null)
				throw new Exception("Tipo no valido");

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
			tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class, filtro);
		} else {
			activo = activoEntrada;
			if (!Checks.esNulo(matricula)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class, filtro);
			}
		}

		try {
			if (!Checks.esNulo(activo) && !Checks.esNulo(tipoDocumento)) {

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
		} catch (Exception e) {
			logger.error("Error en activoManager",e);
		}

		return null;

	}

	@Override
	@BusinessOperation(overrides = "activoManager.upload2")
	@Transactional(readOnly = false)
	public String upload2(WebFileItem webFileItem, Long idDocRestClient) throws Exception {

		return uploadDocumento(webFileItem, idDocRestClient, null, null);

		// Activo activo =
		// get(Long.parseLong(webFileItem.getParameter("idEntidad")));
		//
		// Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());
		//
		// ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo();
		// adjuntoActivo.setAdjunto(adj);
		// adjuntoActivo.setActivo(activo);
		//
		// adjuntoActivo.setIdDocRestClient(idDocRestClient);
		//
		// if (webFileItem.getParameter("tipo") == null)
		// throw new Exception("Tipo no valido");
		//
		// Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
		// webFileItem.getParameter("tipo"));
		// DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo)
		// genericDao.get(DDTipoDocumentoActivo.class,
		// filtro);
		// adjuntoActivo.setTipoDocumentoActivo(tipoDocumento);
		//
		// adjuntoActivo.setContentType(webFileItem.getFileItem().getContentType());
		//
		// adjuntoActivo.setTamanyo(webFileItem.getFileItem().getLength());
		//
		// adjuntoActivo.setNombre(webFileItem.getFileItem().getFileName());
		//
		// adjuntoActivo.setDescripcion(webFileItem.getParameter("descripcion"));
		//
		// adjuntoActivo.setFechaDocumento(new Date());
		//
		// Auditoria.save(adjuntoActivo);
		//
		// activo.getAdjuntos().add(adjuntoActivo);
		//
		// activoDao.save(activo);
		//
		// return null;
	}

	@Override
	public String uploadFoto(File fileItem) throws Exception {
		try {
			if (fileItem.getMetadata().get("id_activo_haya") == null) {
				throw new Exception("La foto no tiene activo");				
			}
			if (fileItem.getMetadata().get("tipo") == null) {
				throw new Exception("La foto no tiene tipo");
			}
			Long numActivo = Long.valueOf(fileItem.getMetadata().get("id_activo_haya"));
			Activo activo = this.getByNumActivo(numActivo);
			if (activo != null) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
						fileItem.getMetadata().get("tipo"));
				DDTipoFoto tipoFoto = (DDTipoFoto) genericDao.get(DDTipoFoto.class, filtro);
				if (tipoFoto == null) {
					throw new Exception("El tipo no existe");
				}
				Integer orden = null;
				if (fileItem.getMetadata().containsKey("orden")) {
					orden = Integer.valueOf(fileItem.getMetadata().get("orden"));
				} else {
					orden = activoDao.getMaxOrdenFotoById(activo.getId())+1;
				}

				ActivoFoto activoFoto = activoAdapter.getFotoActivoByRemoteId(fileItem.getId());
				if (activoFoto == null) {
					activoFoto = new ActivoFoto(fileItem);
				}
				activoFoto.setActivo(activo);

				activoFoto.setTipoFoto(tipoFoto);

				activoFoto.setNombre(fileItem.getBasename());
				if (fileItem.getMetadata().containsKey("descripcion")) {
					activoFoto.setDescripcion(fileItem.getMetadata().get("descripcion"));
				}
				if (fileItem.getMetadata().containsKey("principal")
						&& fileItem.getMetadata().get("principal").equals("1")) {
					activoFoto.setPrincipal(Boolean.TRUE);
				} else {
					activoFoto.setPrincipal(Boolean.FALSE);
				}
				Date fechaSubida = new Date();
				if (fileItem.getMetadata().containsKey("fecha_subida")) {
					try {
						fechaSubida = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S")
								.parse(fileItem.getMetadata().get("fecha_subida"));
					} catch (Exception e) {
						logger.error("El webservice del Gestor documental ha enviado una fecha sin formato");
					}
				}

				activoFoto.setFechaDocumento(fechaSubida);

				if (fileItem.getMetadata().containsKey("interior_exterior")) {
					if (fileItem.getMetadata().get("interior_exterior").equals("1")) {
						activoFoto.setInteriorExterior(Boolean.TRUE);
					} else {
						activoFoto.setInteriorExterior(Boolean.FALSE);
					}
				}

				activoFoto.setOrden(orden);

				Auditoria.save(activoFoto);

				activo.getFotos().add(activoFoto);

				activoDao.save(activo);
				logger.debug("Foto procesada para el activo "+activo.getNumActivo());
			} else {
				throw new Exception("La foto esta asociada a un activo inexistente");
			}
		} catch (Exception e) {
			logger.error("Error insertando/actualizando foto",e);
			throw new Exception(e.getMessage());

		}
		return null;
	}

	@Override
	@BusinessOperation(overrides = "activoManager.uploadFoto")
	@Transactional(readOnly = false)
	public String uploadFoto(WebFileItem fileItem) {

		Activo activo = this.get(Long.parseLong(fileItem.getParameter("idEntidad")));
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
		DDTipoFoto tipoFoto = (DDTipoFoto) genericDao.get(DDTipoFoto.class, filtro);
		// ActivoAdjuntoActivo adjuntoActivo = new
		// ActivoAdjuntoActivo(fileItem.getFileItem());
		TIPO tipo = null;
		FileResponse fileReponse;
		ActivoFoto activoFoto;
		SITUACION situacion;
		PRINCIPAL principal = null;
		Integer orden = activoDao.getMaxOrdenFotoById(Long.parseLong(fileItem.getParameter("idEntidad")));
		orden++;
		try {
			if (gestorDocumentalFotos.isActive()) {
				if (tipoFoto.getCodigo().equals("01")) {
					tipo = TIPO.WEB;
				} else if (tipoFoto.getCodigo().equals("02")) {
					tipo = TIPO.TECNICA;
				} else if (tipoFoto.getCodigo().equals("03")) {
					tipo = TIPO.TESTIGO;
				}
				if (Boolean.valueOf(fileItem.getParameter("principal"))) {
					principal = PRINCIPAL.SI;
				} else {
					principal = PRINCIPAL.NO;
				}
				if (Boolean.valueOf(fileItem.getParameter("interiorExterior"))) {
					situacion = SITUACION.INTERIOR;
				} else {
					situacion = SITUACION.EXTERIOR;
				}
				fileReponse = gestorDocumentalFotos.upload(fileItem.getFileItem().getFile(),
						fileItem.getFileItem().getFileName(), PROPIEDAD.ACTIVO, activo.getNumActivo(), tipo,
						fileItem.getParameter("descripcion"), principal, situacion, orden);
				activoFoto = new ActivoFoto(fileReponse.getData());

			} else {
				activoFoto = new ActivoFoto(fileItem.getFileItem());
			}

			activoFoto.setActivo(activo);

			activoFoto.setTipoFoto(tipoFoto);

			activoFoto.setTamanyo(fileItem.getFileItem().getLength());

			activoFoto.setNombre(fileItem.getFileItem().getFileName());

			activoFoto.setDescripcion(fileItem.getParameter("descripcion"));

			activoFoto.setPrincipal(Boolean.valueOf(fileItem.getParameter("principal")));

			activoFoto.setFechaDocumento(new Date());

			activoFoto.setInteriorExterior(Boolean.valueOf(fileItem.getParameter("interiorExterior")));

			activoFoto.setOrden(orden);

			Auditoria.save(activoFoto);

			activo.getFotos().add(activoFoto);

			activoDao.save(activo);
		} catch (Exception e) {
			logger.error("Error en activoManager",e);
		}

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
	public Long getPresupuestoActual(Long id) {

		return activoDao.getPresupuestoActual(id);
	}

	@BusinessOperationDefinition("activoManager.getUltimoHistoricoPresupuesto")
	public Long getUltimoHistoricoPresupuesto(Long id) {

		return activoDao.getUltimoHistoricoPresupuesto(id);
	}

	@BusinessOperationDefinition("activoManager.checkHayPresupuestoEjercicioActual")
	public boolean checkHayPresupuestoEjercicioActual(Long idActivo) {

		return !Checks.esNulo(activoDao.getPresupuestoActual(idActivo));
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
		} else {
			TareaActivo tareaActivo = tareaActivoManager.getByIdTareaExterna(tareaExterna.getId());
			activo = tareaActivo.getTramite().getActivo();
		}
		return activo;
	}

	public Boolean checkAdmisionAndGestion(TareaExterna tareaExterna) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", tareaExternaToActivo(tareaExterna).getId());
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
	public Boolean saveCondicionantesDisponibilidad(Long idActivo,
			DtoCondicionantesDisponibilidad dtoCondicionanteDisponibilidad) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		ActivoSituacionPosesoria condicionantesDisponibilidad = genericDao.get(ActivoSituacionPosesoria.class, filtro);

		condicionantesDisponibilidad.setOtro(dtoCondicionanteDisponibilidad.getOtro());

		genericDao.save(ActivoSituacionPosesoria.class, condicionantesDisponibilidad);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean updateCondicionantesDisponibilidad(Long idActivo) {
		// Actualizar estado disponibilidad comercial. Se realiza despues de
		// haber guardado el cambio en los estados condicionantes.
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
				if (!Checks.esNulo(condicion.getActivo())) {
					beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "idActivo", condicion.getActivo().getId());
				}
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "texto", condicion.getTexto());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "fechaDesde", condicion.getFechaDesde());
				beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "fechaHasta", condicion.getFechaHasta());
				if (!Checks.esNulo(condicion.getUsuarioAlta())) {
					beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "usuarioAlta",
							condicion.getUsuarioAlta().getUsername());
				}
				if (!Checks.esNulo(condicion.getUsuarioBaja())) {
					beanUtilNotNull.copyProperty(dtoCondicionEspecifica, "usuarioBaja",
							condicion.getUsuarioBaja().getUsername());
				}
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager",e);
			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager",e);
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
			ActivoCondicionEspecifica condicionAnterior = activoDao
					.getUltimaCondicion(dtoCondicionEspecifica.getIdActivo());
			if (!Checks.esNulo(condicionAnterior)) {
				beanUtilNotNull.copyProperty(condicionAnterior, "fechaHasta", new Date());
				condicionAnterior.setUsuarioBaja(adapter.getUsuarioLogado());
				genericDao.save(ActivoCondicionEspecifica.class, condicionAnterior);
			}

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager",e);
		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager",e);
		}

		genericDao.save(ActivoCondicionEspecifica.class, condicionEspecifica);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean saveCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoCondicionEspecifica.getId()));
		ActivoCondicionEspecifica condicionEspecifica = genericDao.get(ActivoCondicionEspecifica.class, filtro);

		if (!Checks.esNulo(condicionEspecifica)) {
			try {
				beanUtilNotNull.copyProperty(condicionEspecifica, "texto", dtoCondicionEspecifica.getTexto());
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager",e);
			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager",e);
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

		if (!Checks.esNulo(condicionEspecifica)) {
			try {
				beanUtilNotNull.copyProperty(condicionEspecifica, "fechaHasta", new Date());
				beanUtilNotNull.copyProperty(condicionEspecifica, "usuarioBaja", adapter.getUsuarioLogado());
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager",e);
			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager",e);
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
				if (!Checks.esNulo(estado.getActivo())) {
					beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "idActivo", estado.getActivo().getId());
				}
				beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "fechaDesde", estado.getFechaDesde());
				beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "fechaHasta", estado.getFechaHasta());
				if (!Checks.esNulo(estado.getPortal())) {
					beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "portal", estado.getPortal().getDescripcion());
				} else {
					beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "portal", "-");
				}
				if (!Checks.esNulo(estado.getTipoPublicacion())) {
					beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "tipoPublicacion",
							estado.getTipoPublicacion().getDescripcion());
				} else {
					beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "tipoPublicacion", "-");
				}
				if (!Checks.esNulo(estado.getEstadoPublicacion())) {
					beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "estadoPublicacion",
							estado.getEstadoPublicacion().getDescripcion());
				}
				beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "motivo", estado.getMotivo());
				beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "usuario", estado.getAuditoria().getUsuarioCrear());
				// Calcular los días que ha estado en un estado eliminando el
				// tiempo de las fechas.
				int dias = 0;
				if (!Checks.esNulo(estado.getFechaDesde()) && !Checks.esNulo(estado.getFechaHasta())) {
					SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
					Date fechaHastaSinTiempo = sdf.parse(sdf.format(estado.getFechaHasta()));
					Date fechaDesdeSinTiempo = sdf.parse(sdf.format(estado.getFechaDesde()));
					Long diferenciaMilis = fechaHastaSinTiempo.getTime() - fechaDesdeSinTiempo.getTime();
					Long diferenciaDias = diferenciaMilis / (1000 * 60 * 60 * 24);
					dias = Integer.valueOf(diferenciaDias.intValue());
				}
				beanUtilNotNull.copyProperty(dtoEstadoPublicacion, "diasPeriodo", dias);
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager",e);
			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager",e);
			} catch (ParseException e) {
				logger.error("Error en activoManager",e);
			}

			listaDtoEstadosPublicacion.add(dtoEstadoPublicacion);
		}
		return listaDtoEstadosPublicacion;
	}

	@Override
	public List<DtoEstadosInformeComercialHistorico> getEstadoInformeComercialByActivo(Long idActivo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.ASC, "id");
		List<ActivoEstadosInformeComercialHistorico> listaEstadoInfoComercial = genericDao
				.getListOrdered(ActivoEstadosInformeComercialHistorico.class, order, filtro);

		List<DtoEstadosInformeComercialHistorico> listaDtoEstadosInfoComercial = new ArrayList<DtoEstadosInformeComercialHistorico>();

		for (ActivoEstadosInformeComercialHistorico estado : listaEstadoInfoComercial) {
			DtoEstadosInformeComercialHistorico dtoEstadosInfoComercial = new DtoEstadosInformeComercialHistorico();
			try {
				beanUtilNotNull.copyProperty(dtoEstadosInfoComercial, "id", idActivo);
				if (!Checks.esNulo(estado.getEstadoInformeComercial())) {
					beanUtilNotNull.copyProperty(dtoEstadosInfoComercial, "estadoInfoComercial",
							estado.getEstadoInformeComercial().getDescripcion());
				}
				beanUtilNotNull.copyProperty(dtoEstadosInfoComercial, "motivo", estado.getMotivo());
				beanUtilNotNull.copyProperty(dtoEstadosInfoComercial, "fecha", estado.getFecha());
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager",e);
			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager",e);
			}

			listaDtoEstadosInfoComercial.add(dtoEstadosInfoComercial);
		}

		return listaDtoEstadosInfoComercial;
	}

	public boolean isInformeComercialAceptado(Activo activo){
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Order order = new Order(OrderType.DESC, "id");
		List<ActivoEstadosInformeComercialHistorico> activoEstadoInfComercialHistoricoList = genericDao.getListOrdered(ActivoEstadosInformeComercialHistorico.class, order, filter);
		if(!Checks.estaVacio(activoEstadoInfComercialHistoricoList)) {
			ActivoEstadosInformeComercialHistorico historico = activoEstadoInfComercialHistoricoList.get(0);
			
			if(historico.getEstadoInformeComercial().getCodigo().equals(
					DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_ACEPTACION) ) 
				return true;
		}
		
		return false;
	}
	
	
	@Override
	public List<DtoHistoricoMediador> getHistoricoMediadorByActivo(Long idActivo) {
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
				if (!Checks.esNulo(historico.getMediadorInforme())) {
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "codigo",
							historico.getMediadorInforme().getId());
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "mediador",
							historico.getMediadorInforme().getNombre());
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "telefono",
							historico.getMediadorInforme().getTelefono1());
					beanUtilNotNull.copyProperty(dtoHistoricoMediador, "email",
							historico.getMediadorInforme().getEmail());
				}
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager",e);
			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager",e);
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

		if (!Checks.esNulo(dto.getIdActivo())) {
			activo = activoDao.get(dto.getIdActivo());
		}

		try {
			// Terminar periodo de vigencia del último proveedor (fecha hasta).
			if (!Checks.esNulo(activo)) {
				Filter activoIDFiltro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				Order order = new Order(OrderType.DESC, "id");
				List<ActivoInformeComercialHistoricoMediador> historicoMediadorlist = genericDao
						.getListOrdered(ActivoInformeComercialHistoricoMediador.class, order, activoIDFiltro);
				if (!Checks.estaVacio(historicoMediadorlist)) {
					ActivoInformeComercialHistoricoMediador historicoAnteriorMediador = historicoMediadorlist.get(0); // El
																														// primero
																														// es
																														// el
																														// de
																														// ID
																														// más
																														// alto
																														// (el
																														// último).
					beanUtilNotNull.copyProperty(historicoAnteriorMediador, "fechaHasta", new Date());
					genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoAnteriorMediador);
				}
			}

			// Generar la nueva entrada de HistoricoMediador.
			beanUtilNotNull.copyProperty(historicoMediador, "fechaDesde", new Date());
			beanUtilNotNull.copyProperty(historicoMediador, "activo", activo);

			if (!Checks.esNulo(dto.getMediador())) {
				Filter proveedorFiltro = genericDao.createFilter(FilterType.EQUALS, "id",
						Long.parseLong(dto.getMediador()));
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, proveedorFiltro);
				beanUtilNotNull.copyProperty(historicoMediador, "mediadorInforme", proveedor);

				// Asignar el nuevo proveedor de tipo mediador al activo,
				// informacion comercial.
				if (!Checks.esNulo(activo.getInfoComercial())) {
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "mediadorInforme", proveedor);
					genericDao.save(Activo.class, activo);
				}
			}

			genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediador);

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager",e);
			return false;
		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager",e);
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
	public boolean publicarActivo(Long idActivo) throws SQLException {
		return publicarActivo(idActivo, null);
	}

	@Override
	public boolean publicarActivo(Long idActivo, String motivo) throws SQLException {

		DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion = new DtoCambioEstadoPublicacion();
		dtoCambioEstadoPublicacion.setActivo(idActivo);
		dtoCambioEstadoPublicacion.setMotivoPublicacion(motivo);
		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);

		return activoEstadoPublicacionApi.publicacionChangeState(dtoCambioEstadoPublicacion);
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
		// Obtener los estados y sumar los dias de cada fase aplicando criterio
		// de funcional además comprobar
		// si alguno de ellos es de publicación/publicación forzada.
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.ASC, "id");
		List<ActivoHistoricoEstadoPublicacion> listaEstadosPublicacion = genericDao
				.getListOrdered(ActivoHistoricoEstadoPublicacion.class, order, filtro);

		int dias = 0;
		boolean despublicado = false;

		for (ActivoHistoricoEstadoPublicacion estado : listaEstadosPublicacion) {
			if (!Checks.esNulo(estado.getEstadoPublicacion())) {
				if (despublicado
						&& (DDEstadoPublicacion.CODIGO_PUBLICADO.equals(estado.getEstadoPublicacion().getCodigo())
								|| DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO
										.equals(estado.getEstadoPublicacion().getCodigo()))) {
					// Si el estado anterior es despublicado y el actual es
					// publicado, se reinicia el contador de días.
					despublicado = false;
					dias = 0;

				} else if (DDEstadoPublicacion.CODIGO_DESPUBLICADO.equals(estado.getEstadoPublicacion().getCodigo())) {
					// Si el estado es despublicado se marca para la siguiente
					// iteración.
					despublicado = true;

				} else if (!DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO
						.equals(estado.getEstadoPublicacion().getCodigo())) {
					if (!Checks.esNulo(estado.getFechaDesde()) && !Checks.esNulo(estado.getFechaHasta())) {
						// Cualquier otro estado distinto a publicado oculto
						// sumará días de publicación.
						try {
							SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
							Date fechaHastaSinTiempo = sdf.parse(sdf.format(estado.getFechaHasta()));
							Date fechaDesdeSinTiempo = sdf.parse(sdf.format(estado.getFechaDesde()));
							Long diferenciaMilis = fechaHastaSinTiempo.getTime() - fechaDesdeSinTiempo.getTime();
							Long diferenciaDias = diferenciaMilis / (1000 * 60 * 60 * 24);
							dias += Integer.valueOf(diferenciaDias.intValue());
						} catch (ParseException e) {
							logger.error("Error en activoManager",e);
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
	public List<DtoPropuestaActivosVinculados> getPropuestaActivosVinculadosByActivo(
			DtoPropuestaActivosVinculados dto) {
		Page p = activoDao.getPropuestaActivosVinculadosByActivo(dto);
		List<PropuestaActivosVinculados> activosVinculados = (List<PropuestaActivosVinculados>) p.getResults();
		List<DtoPropuestaActivosVinculados> dtoActivosVinculados = new ArrayList<DtoPropuestaActivosVinculados>();

		for (PropuestaActivosVinculados vinculado : activosVinculados) {
			DtoPropuestaActivosVinculados nuevoDto = new DtoPropuestaActivosVinculados();
			try {
				beanUtilNotNull.copyProperty(nuevoDto, "id", vinculado.getId());
				beanUtilNotNull.copyProperty(nuevoDto, "activoVinculadoNumero",
						vinculado.getActivoVinculado().getNumActivo());
				beanUtilNotNull.copyProperty(nuevoDto, "activoVinculadoID", vinculado.getActivoVinculado().getId());
				beanUtilNotNull.copyProperty(nuevoDto, "totalCount", p.getTotalCount());
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager",e);
			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager",e);
			}

			if (!Checks.esNulo(nuevoDto)) {
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

		if (Checks.esNulo(activoVinculado) || Checks.esNulo(activoOrigen)) {
			// No se ha encontrado algún activo. El activo origen por ID. El
			// activo vinculado por numero de activo.
			return false;
		}

		try {
			beanUtilNotNull.copyProperty(propuestaActivosVinculados, "activoOrigen", activoOrigen);
			beanUtilNotNull.copyProperty(propuestaActivosVinculados, "activoVinculado", activoVinculado);
		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager",e);
		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager",e);
		}

		genericDao.save(PropuestaActivosVinculados.class, propuestaActivosVinculados);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deletePropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto) {
		Long id;

		try {
			id = Long.parseLong(dto.getId());
		} catch (NumberFormatException e) {
			logger.error("Error en activoManager",e);
			return false;
		}

		PropuestaActivosVinculados activoVinculado = activoDao.getPropuestaActivosVinculadosByID(id);

		if (!Checks.esNulo(activoVinculado)) {
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
		perimetros = genericDao.getListOrdered(PerimetroActivo.class, order, filtro);

		if (Checks.estaVacio(perimetros) || perimetros.get(0).getIncluidoEnPerimetro() == 1) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public PerimetroActivo getPerimetroByIdActivo(Long idActivo) {

		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		PerimetroActivo perimetroActivo = (PerimetroActivo) genericDao.get(PerimetroActivo.class, filtroActivo);

		// Si no existia un registro de activo bancario, crea un nuevo
		if (Checks.esNulo(perimetroActivo)) {
			perimetroActivo = new PerimetroActivo();
			Auditoria auditoria = new Auditoria();
			auditoria.setUsuarioCrear("REM");
			auditoria.setFechaCrear(new Date());
			perimetroActivo.setAuditoria(auditoria);
			Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
			Activo activo = genericDao.get(Activo.class, filterActivo);
			if (!Checks.esNulo(activo))
				perimetroActivo.setActivo(activo);
			// Si no existia perimetro en BBDD, por defecto esta INCLUIDO en
			// perimetro
			// y se deben tomar todas las condiciones como marcadas
			perimetroActivo.setIncluidoEnPerimetro(1);
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

		// Obtiene el registro de ActivoBancario para el activo dado
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		ActivoBancario activoBancario = (ActivoBancario) genericDao.get(ActivoBancario.class, filtroActivo);

		// Si no existia un registro de activo bancario, crea un nuevo
		if (Checks.esNulo(activoBancario)) {
			activoBancario = new ActivoBancario();
			activoBancario.setAuditoria(new Auditoria());
		}

		return activoBancario;

	}

	@Override
	@Transactional(readOnly = false)
	public PerimetroActivo saveOrUpdatePerimetroActivo(PerimetroActivo perimetroActivo) {
		try {

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

		} catch (Exception ex) {
			logger.error("Error en activoManager",ex);
		}

		return perimetroActivo;
	}

	@Override
	@Transactional(readOnly = false)
	public Activo updateActivoAsistida(Activo activo) {
		// Actualizamos el perímetro
		PerimetroActivo perimetro = getPerimetroByIdActivo(activo.getId());

		if (Checks.esNulo(perimetro.getActivo()))
			perimetro.setActivo(activo);

		updatePerimetroAsistida(perimetro);

		// Bloqueamos los precios para que el activo no salga en los procesos
		// automáticos. Esto podría ir en un proceso al dar de alta el activo.
		activo.setBloqueoPrecioFechaIni(new Date());
		activo.setGestorBloqueoPrecio(adapter.getUsuarioLogado());

		DDTipoComercializar tipoComercializar = (DDTipoComercializar) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDTipoComercializar.class, DDTipoComercializar.CODIGO_RETAIL);
		if (!Checks.esNulo(tipoComercializar)) {
			activo.setTipoComercializar(tipoComercializar);
		}

		DDTipoComercializacion tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDTipoComercializacion.class, DDTipoComercializacion.CODIGO_VENTA);
		if (!Checks.esNulo(tipoComercializacion)) {
			activo.setTipoComercializacion(tipoComercializacion);
		}

		saveOrUpdate(activo);
		return activo;
	}

	@Override
	@Transactional(readOnly = false)
	public PerimetroActivo updatePerimetroAsistida(PerimetroActivo perimetroActivo) {
		perimetroActivo.setIncluidoEnPerimetro(1);
		perimetroActivo.setAplicaAsignarMediador(0);
		perimetroActivo.setAplicaComercializar(1);
		perimetroActivo.setAplicaFormalizar(0);
		perimetroActivo.setAplicaGestion(0);
		perimetroActivo.setAplicaTramiteAdmision(0);
		perimetroActivo.setFechaAplicaComercializar(new Date());

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoComercializacion.CODIGO_ASISTIDA);
		DDMotivoComercializacion motivoComercializacion = genericDao.get(DDMotivoComercializacion.class, filtro);
		perimetroActivo.setMotivoAplicaComercializar(motivoComercializacion);

		saveOrUpdatePerimetroActivo(perimetroActivo);

		return perimetroActivo;
	}

	@Override
	@Transactional(readOnly = false)
	public ActivoBancario saveOrUpdateActivoBancario(ActivoBancario activoBancario) {
		try {
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

		} catch (Exception ex) {
			logger.error("Error en activoManager",ex);
		}

		return activoBancario;
	}

	@Override
	public boolean isActivoConOfertaByEstado(Activo activo, String codEstado) {

		if (!Checks.estaVacio(activo.getOfertas())) {
			for (ActivoOferta activoOferta : activo.getOfertas()) {
				if (activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals(codEstado)) {
					return true;
				}
			}
		}

		return false;
	}

	@Override
	public boolean isActivoConReservaByEstado(Activo activo, String codEstado) {

		for (Reserva reserva : this.getReservasByActivo(activo)) {

			if (!Checks.esNulo(reserva.getEstadoReserva())
					&& reserva.getEstadoReserva().getCodigo().equals(codEstado)) {
				return true;
			}
		}

		return false;
	}

	@Override
	public List<Reserva> getReservasByActivo(Activo activo) {

		List<Reserva> reservas = new ArrayList<Reserva>();

		if (!Checks.estaVacio(activo.getOfertas())) {
			for (ActivoOferta activoOferta : activo.getOfertas()) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id",
						activoOferta.getPrimaryKey().getOferta().getId());
				ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);

				if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getReserva())) {
					reservas.add(expediente.getReserva());
				}
			}
		}

		return reservas;
	}

	@Override
	public boolean isActivoVendido(Activo activo) {

		if (!Checks.estaVacio(activo.getOfertas())) {
			for (ActivoOferta activoOferta : activo.getOfertas()) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id",
						activoOferta.getPrimaryKey().getOferta().getId());
				ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);

				if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getFormalizacion())
						&& !Checks.esNulo(expediente.getFormalizacion().getFechaEscritura())) {
					return true;
				}
			}
		}

		return false;
	}

	public boolean crearGastosExpediente(ExpedienteComercial nuevoExpediente, Oferta oferta) {

		try {
			List<GastosExpediente> gastosExpediente = new ArrayList<GastosExpediente>();
			DDTipoProveedorHonorario tipoProveedorMediador = (DDTipoProveedorHonorario) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDTipoProveedorHonorario.class,
							DDTipoProveedorHonorario.CODIGO_MEDIADOR);
			DDTipoProveedorHonorario tipoProveedorfdv = (DDTipoProveedorHonorario) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_FVD);
			DDTipoProveedorHonorario tipoProveedorOficinaBankia = (DDTipoProveedorHonorario) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDTipoProveedorHonorario.class,
							DDTipoProveedorHonorario.CODIGO_OFICINA_BANKIA);
			DDTipoProveedorHonorario tipoProveedorOficinaCajamar = (DDTipoProveedorHonorario) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDTipoProveedorHonorario.class,
							DDTipoProveedorHonorario.CODIGO_OFICINA_CAJAMAR);

			if (!Checks.esNulo(oferta.getVisita())) {
				// Custodio
				if (!Checks.esNulo(oferta.getCustodio()) && Checks.esNulo(oferta.getVisita().getApiCustodio())) { // Oferta
																													// tiene
																													// y
																													// visita
																													// no
					DDAccionGastos accionGastoColaboracion = (DDAccionGastos) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_COLABORACION);
					GastosExpediente gastoExpedienteCustodio = anyadirGastoExpediente(oferta, accionGastoColaboracion,
							nuevoExpediente);
					gastosExpediente.add(gastoExpedienteCustodio);
				} else if (Checks.esNulo(oferta.getCustodio()) && !Checks.esNulo(oferta.getVisita().getApiCustodio())) { // Oferta
																															// no
																															// tiene
																															// y
																															// visita
																															// si
					oferta.setCustodio(oferta.getVisita().getApiCustodio());
					DDAccionGastos accionGastoColaboracion = (DDAccionGastos) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_COLABORACION);
					GastosExpediente gastoExpedienteCustodio = anyadirGastoExpediente(oferta, accionGastoColaboracion,
							nuevoExpediente);
					gastosExpediente.add(gastoExpedienteCustodio);
				} else if (!Checks.esNulo(oferta.getCustodio())
						&& !Checks.esNulo(oferta.getVisita().getApiCustodio())) { // ambos
																					// tiene
																					// y
																					// son
																					// iguales
					if (oferta.getCustodio().getId().equals(oferta.getVisita().getApiCustodio().getId())) {
						DDAccionGastos accionGastoColaboracion = (DDAccionGastos) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_COLABORACION);
						GastosExpediente gastoExpedienteCustodio = anyadirGastoExpediente(oferta,
								accionGastoColaboracion, nuevoExpediente);
						gastosExpediente.add(gastoExpedienteCustodio);
					}
				}

				// FDV
				if (!Checks.esNulo(oferta.getFdv()) && Checks.esNulo(oferta.getVisita().getFdv())) {// Oferta
																									// tiene
																									// y
																									// visita
																									// no
					DDAccionGastos accionGastoColaboracion = (DDAccionGastos) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_COLABORACION);
					GastosExpediente gastoExpedienteFdv = anyadirGastoExpediente(oferta, accionGastoColaboracion,
							nuevoExpediente);
					gastosExpediente.add(gastoExpedienteFdv);
				} else if (Checks.esNulo(oferta.getFdv()) && !Checks.esNulo(oferta.getVisita().getFdv())) {// Oferta
																											// no
																											// tiene
																											// y
																											// visita
																											// si
					oferta.setFdv(oferta.getVisita().getFdv());
					DDAccionGastos accionGastoColaboracion = (DDAccionGastos) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_COLABORACION);
					GastosExpediente gastoExpedienteFdv = anyadirGastoExpediente(oferta, accionGastoColaboracion,
							nuevoExpediente);
					gastosExpediente.add(gastoExpedienteFdv);
				} else if (!Checks.esNulo(oferta.getFdv()) && !Checks.esNulo(oferta.getVisita().getFdv())) {// ambos
																											// tiene
																											// y
																											// son
																											// iguales
					if (oferta.getFdv().getId().equals(oferta.getVisita().getFdv().getId())) {
						DDAccionGastos accionGastoColaboracion = (DDAccionGastos) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_COLABORACION);
						GastosExpediente gastoExpedienteFdv = anyadirGastoExpediente(oferta, accionGastoColaboracion,
								nuevoExpediente);
						gastosExpediente.add(gastoExpedienteFdv);
					}
				}

				// PRESCRIPTOR
				if (!Checks.esNulo(oferta.getPrescriptor()) && Checks.esNulo(oferta.getVisita().getPrescriptor())) {// Oferta
																													// tiene
																													// y
																													// visita
																													// no
					DDAccionGastos accionGastoPrescripcion = (DDAccionGastos) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_PRESCRIPCION);
					GastosExpediente gastoExpedientePrescriptor = anyadirGastoExpediente(oferta,
							accionGastoPrescripcion, nuevoExpediente);
					gastosExpediente.add(gastoExpedientePrescriptor);
				} else if (Checks.esNulo(oferta.getPrescriptor())
						&& !Checks.esNulo(oferta.getVisita().getPrescriptor())) {// Oferta
																					// no
																					// tiene
																					// y
																					// visita
																					// si
					oferta.setPrescriptor(oferta.getVisita().getPrescriptor());
					DDAccionGastos accionGastoPrescripcion = (DDAccionGastos) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_PRESCRIPCION);
					GastosExpediente gastoExpedientePrescriptor = anyadirGastoExpediente(oferta,
							accionGastoPrescripcion, nuevoExpediente);
					gastosExpediente.add(gastoExpedientePrescriptor);
				} else if (!Checks.esNulo(oferta.getPrescriptor())
						&& !Checks.esNulo(oferta.getVisita().getPrescriptor())) {// ambos
																					// tiene
																					// y
																					// son
																					// iguales
					if (oferta.getPrescriptor().getId().equals(oferta.getVisita().getPrescriptor().getId())) {
						DDAccionGastos accionGastoPrescripcion = (DDAccionGastos) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_PRESCRIPCION);
						GastosExpediente gastoExpedientePrescriptor = anyadirGastoExpediente(oferta,
								accionGastoPrescripcion, nuevoExpediente);
						gastosExpediente.add(gastoExpedientePrescriptor);
					}
				}

				// RESPONSABLE
				if (!Checks.esNulo(oferta.getApiResponsable())
						&& Checks.esNulo(oferta.getVisita().getApiResponsable())) {// Oferta
																					// tiene
																					// y
																					// visita
																					// no
					DDAccionGastos accionResponsableCliente = (DDAccionGastos) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE);
					GastosExpediente gastoExpedienteResponsable = anyadirGastoExpediente(oferta,
							accionResponsableCliente, nuevoExpediente);
					gastosExpediente.add(gastoExpedienteResponsable);
				} else if (Checks.esNulo(oferta.getApiResponsable())
						&& !Checks.esNulo(oferta.getVisita().getApiResponsable())) {// Oferta
																					// no
																					// tiene
																					// y
																					// visita
																					// si
					oferta.setApiResponsable(oferta.getVisita().getApiResponsable());
					DDAccionGastos accionResponsableCliente = (DDAccionGastos) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE);
					GastosExpediente gastoExpedienteResponsable = anyadirGastoExpediente(oferta,
							accionResponsableCliente, nuevoExpediente);
					gastosExpediente.add(gastoExpedienteResponsable);
				} else if (!Checks.esNulo(oferta.getApiResponsable())
						&& !Checks.esNulo(oferta.getVisita().getApiResponsable())) {// ambos
																					// tiene
																					// y
																					// son
																					// iguales
					if (oferta.getApiResponsable().getId().equals(oferta.getVisita().getApiResponsable().getId())) {
						DDAccionGastos accionResponsableCliente = (DDAccionGastos) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDAccionGastos.class,
										DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE);
						GastosExpediente gastoExpedienteResponsable = anyadirGastoExpediente(oferta,
								accionResponsableCliente, nuevoExpediente);
						gastosExpediente.add(gastoExpedienteResponsable);
					}
				}
			} else {
				if (!Checks.esNulo(oferta.getCustodio())) {
					DDAccionGastos accionGastoColaboracion = (DDAccionGastos) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_COLABORACION);
					GastosExpediente gastoExpedienteCustodio = anyadirGastoExpediente(oferta, accionGastoColaboracion,
							nuevoExpediente);
					gastosExpediente.add(gastoExpedienteCustodio);
				}
				if (!Checks.esNulo(oferta.getFdv())) {
					DDAccionGastos accionGastoColaboracion = (DDAccionGastos) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_COLABORACION);
					GastosExpediente gastoExpedienteFdv = anyadirGastoExpediente(oferta, accionGastoColaboracion,
							nuevoExpediente);
					gastosExpediente.add(gastoExpedienteFdv);
				}
				if (!Checks.esNulo(oferta.getPrescriptor())) {
					DDAccionGastos accionGastoPrescripcion = (DDAccionGastos) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_PRESCRIPCION);
					GastosExpediente gastoExpedientePrescriptor = anyadirGastoExpediente(oferta,
							accionGastoPrescripcion, nuevoExpediente);
					gastosExpediente.add(gastoExpedientePrescriptor);
				}
				if (!Checks.esNulo(oferta.getApiResponsable())) {
					DDAccionGastos accionResponsableCliente = (DDAccionGastos) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE);
					GastosExpediente gastoExpedienteResponsable = anyadirGastoExpediente(oferta,
							accionResponsableCliente, nuevoExpediente);
					gastosExpediente.add(gastoExpedienteResponsable);
				}
			}

			// Añadir los tipos de proveedores que coincidan con los tipos
			// proveedores honorarios
			for (GastosExpediente gastoExpediente : gastosExpediente) {
				ActivoProveedor proveedor = gastoExpediente.getProveedor();
				if (!Checks.esNulo(proveedor) && !Checks.esNulo(proveedor.getTipoProveedor())) {
					if (proveedor.getTipoProveedor().getCodigo().equals(DDTipoProveedorHonorario.CODIGO_MEDIADOR)) {
						gastoExpediente.setTipoProveedor(tipoProveedorMediador);
					}
				}
				if (!Checks.esNulo(proveedor) && !Checks.esNulo(proveedor.getTipoProveedor())) {
					if (proveedor.getTipoProveedor().getCodigo().equals(DDTipoProveedorHonorario.CODIGO_FVD)) {
						gastoExpediente.setTipoProveedor(tipoProveedorfdv);
					}
				}
				if (!Checks.esNulo(proveedor) && !Checks.esNulo(proveedor.getTipoProveedor())) {
					if (proveedor.getTipoProveedor().getCodigo()
							.equals(DDTipoProveedorHonorario.CODIGO_OFICINA_BANKIA)) {
						gastoExpediente.setTipoProveedor(tipoProveedorOficinaBankia);
					}
				}
				if (!Checks.esNulo(proveedor) && !Checks.esNulo(proveedor.getTipoProveedor())) {
					if (proveedor.getTipoProveedor().getCodigo()
							.equals(DDTipoProveedorHonorario.CODIGO_OFICINA_CAJAMAR)) {
						gastoExpediente.setTipoProveedor(tipoProveedorOficinaCajamar);

					}
				}

				genericDao.save(GastosExpediente.class, gastoExpediente);
			}

		} catch (Exception ex) {
			logger.error("Error en activoManager",ex);
			return false;
		}

		return true;
	}

	@Override
	public boolean isIntegradoAgrupacionAsistida(Activo activo) {

		for (ActivoAgrupacionActivo agrupacionActivo : activo.getAgrupaciones()) {

			Date fechaFinVigencia = agrupacionActivo.getAgrupacion().getFechaFinVigencia();
			fechaFinVigencia = !Checks.esNulo(fechaFinVigencia) ? new Date(fechaFinVigencia.getTime()) : null;

			if (!Checks.esNulo(agrupacionActivo.getAgrupacion().getTipoAgrupacion())
					&& agrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo()
							.equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)
					&& !Checks.esNulo(fechaFinVigencia) && fechaFinVigencia.after(new Date())) {
				return true;
			}
		}

		return false;
	}

	@Override
	public boolean isIntegradoAgrupacionComercial(Activo activo) {

		for (ActivoAgrupacionActivo agrupacionActivo : activo.getAgrupaciones()) {

			Date fechaBaja = agrupacionActivo.getAgrupacion().getFechaBaja();
			fechaBaja = !Checks.esNulo(fechaBaja) ? new Date(fechaBaja.getTime()) : null;

			if (!Checks.esNulo(agrupacionActivo.getAgrupacion().getTipoAgrupacion())
					&& agrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo()
							.equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)
					&& (!Checks.esNulo(fechaBaja) ? fechaBaja.after(new Date()) : true)) {
				return true;
			}
		}

		return false;
	}

	@Override
	public boolean isActivoAsistido(Activo activo) {
		if (!Checks.esNulo(activo.getSubcartera()))
			if (DDSubcartera.CODIGO_CAJ_ASISTIDA.equals(activo.getSubcartera().getCodigo())
					|| DDSubcartera.CODIGO_SAR_ASISTIDA.equals(activo.getSubcartera().getCodigo())
					|| DDSubcartera.CODIGO_BAN_ASISTIDA.equals(activo.getSubcartera().getCodigo()))
				return true;
		return false;
	}

	@Override
	public Integer getNumActivosPublicadosByAgrupacion(List<ActivoAgrupacionActivo> activos) {

		Integer contador = 0;

		for (ActivoAgrupacionActivo activoAgrupacion : activos) {
			if (!Checks.esNulo(activoAgrupacion.getActivo().getEstadoPublicacion())) {

				String codEstadoPublicacion = activoAgrupacion.getActivo().getEstadoPublicacion().getCodigo();
				if (codEstadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO)
						|| codEstadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO)
						|| codEstadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO)
						|| codEstadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO)
						|| codEstadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO)) {
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

		try {
			Activo activo = activoDao.get(idActivo);
			if (!Checks.esNulo(activo)) {
				// Se especifica bankia por que tan solo se va a poder demandar
				// la tasación desde bankia.
				tasacionID = uvemManagerApi.ejecutarSolicitarTasacion(activo.getNumActivoUvem(),
						adapter.getUsuarioLogado());
			} else {
				return false;
			}
		} catch (Exception e) {
			logger.error("Error en activoManager",e);
			throw new Exception("El servicio de solicitud de tasaciones no está disponible en estos momentos");
		}

		if (!Checks.esNulo(tasacionID)) {
			try {
				Activo activo = activoDao.get(idActivo);

				if (!Checks.esNulo(activo)) {
					// Generar un 'BIE_VALORACION' con el 'BIEN_ID' del activo.
					NMBValoracionesBien valoracionBien = new NMBValoracionesBien();
					valoracionBien.setBien(activo.getBien());
					valoracionBien = genericDao.save(NMBValoracionesBien.class, valoracionBien);

					if (!Checks.esNulo(valoracionBien)) {
						// Generar una tasacion con el ID de activo y el ID de
						// la valoracion del bien.
						ActivoTasacion tasacion = new ActivoTasacion();

						beanUtilNotNull.copyProperty(tasacion, "idExterno", tasacionID);
						beanUtilNotNull.copyProperty(tasacion, "activo", activo);
						beanUtilNotNull.copyProperty(tasacion, "valoracionBien", valoracionBien);

						genericDao.save(ActivoTasacion.class, tasacion);
						// Actualizar el tipoComercialización del activo
						updaterState.updaterStateTipoComercializacion(activo);
					}
				}
			} catch (Exception e) {
				logger.error("Error en activoManager",e);
				throw new Exception("Error al procesar su solicitud");
			}
		} else {
			throw new Exception("El servicio de solicitud de tasaciones no está disponible en estos momentos");
		}

		return true;
	}

	@Override
	public DtoTasacion getSolicitudTasacionBankia(Long id) {
		ActivoTasacion activoTasacion = activoDao.getActivoTasacion(id);
		DtoTasacion dtoTasacion = new DtoTasacion();
		if (!Checks.esNulo(activoTasacion)) {

			try {
				beanUtilNotNull.copyProperty(dtoTasacion, "idSolicitudREM", activoTasacion.getId());
				beanUtilNotNull.copyProperty(dtoTasacion, "fechaSolicitudTasacion",
						activoTasacion.getAuditoria().getFechaCrear());
				beanUtilNotNull.copyProperty(dtoTasacion, "gestorSolicitud",
						activoTasacion.getAuditoria().getUsuarioCrear());
				beanUtilNotNull.copyProperty(dtoTasacion, "externoID", activoTasacion.getIdExterno());
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager",e);
			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager",e);
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

		// Validaciones datos obligatorios correspondientes a Publicacion /
		// Informe comercial
		// del activo
		// Validación mediador
		if (Checks.esNulo(activo.getInfoComercial()) || Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
			mensaje = mensaje
					.concat(messageServices.getMessage("tramite.admision.DesignarMediador.validacionPre.mediador"));
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
		HashMap<String, String> errorsList = null;
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

		for (ActivoReglasPublicacionAutomatica regla : reglas) {
			DtoReglasPublicacionAutomatica nuevoDto = new DtoReglasPublicacionAutomatica();
			try {
				beanUtilNotNull.copyProperty(nuevoDto, "idRegla", regla.getId());
				beanUtilNotNull.copyProperty(nuevoDto, "incluidoAgrupacionAsistida",
						regla.getIncluidoAgrupacionAsistida());
				if (!Checks.esNulo(regla.getCartera())) {
					beanUtilNotNull.copyProperty(nuevoDto, "carteraCodigo", regla.getCartera().getCodigo());
				}
				if (!Checks.esNulo(regla.getTipoActivo())) {
					beanUtilNotNull.copyProperty(nuevoDto, "tipoActivoCodigo", regla.getTipoActivo().getCodigo());
				}
				if (!Checks.esNulo(regla.getSubtipoActivo())) {
					beanUtilNotNull.copyProperty(nuevoDto, "subtipoActivoCodigo", regla.getSubtipoActivo().getCodigo());
				}

				nuevoDto.setTotalCount(p.getTotalCount());

				reglasDto.add(nuevoDto);
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager",e);
			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager",e);
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
			if (!Checks.esNulo(dto.getCarteraCodigo())) {
				DDCartera cartera = (DDCartera) utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class,
						dto.getCarteraCodigo());
				beanUtilNotNull.copyProperty(arpa, "cartera", cartera);
			}
			if (!Checks.esNulo(dto.getTipoActivoCodigo())) {
				DDTipoActivo tipo = (DDTipoActivo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoActivo.class,
						dto.getTipoActivoCodigo());
				beanUtilNotNull.copyProperty(arpa, "tipoActivo", tipo);
			}
			if (!Checks.esNulo(dto.getSubtipoActivoCodigo())) {
				DDSubtipoActivo subtipo = (DDSubtipoActivo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSubtipoActivo.class, dto.getSubtipoActivoCodigo());
				beanUtilNotNull.copyProperty(arpa, "subtipoActivo", subtipo);
			}
		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager",e);
			return false;
		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager",e);
			return false;
		}

		genericDao.save(ActivoReglasPublicacionAutomatica.class, arpa);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto) {
		if (Checks.esNulo(dto.getIdRegla())) {
			return false;
		}
		Filter reglaIDFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdRegla()));
		ActivoReglasPublicacionAutomatica arpa = genericDao.get(ActivoReglasPublicacionAutomatica.class, reglaIDFilter);

		if (Checks.esNulo(arpa)) {
			return false;
		}

		try {
			beanUtilNotNull.copyProperty(arpa, "auditoria.borrado", "1");
			beanUtilNotNull.copyProperty(arpa, "auditoria.fechaBorrar", new Date());
			beanUtilNotNull.copyProperty(arpa, "auditoria.usuarioBorrar", adapter.getUsuarioLogado().getUsername());
		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager",e);
			return false;
		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager",e);
			return false;
		}

		genericDao.save(ActivoReglasPublicacionAutomatica.class, arpa);

		return true;
	}

	public List<VBusquedaProveedoresActivo> getProveedorByActivo(Long idActivo) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo.toString());
		List<VBusquedaProveedoresActivo> listadoProveedores = genericDao.getList(VBusquedaProveedoresActivo.class,
				filtro);

		return listadoProveedores;

	}

	public List<VBusquedaGastoActivo> getGastoByActivo(Long idActivo, Long idProveedor) {

		List<VBusquedaGastoActivo> vGastosActivos = new ArrayList<VBusquedaGastoActivo>();

		if (!Checks.esNulo(idActivo) && !Checks.esNulo(idProveedor)) {
			Filter filtroGastoActivo = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo);
			Filter filtroGastoProveedor = genericDao.createFilter(FilterType.EQUALS, "idProveedor", idProveedor);
			vGastosActivos = genericDao.getList(VBusquedaGastoActivo.class, filtroGastoActivo, filtroGastoProveedor);
		}

		return vGastosActivos;
	}

	@Override
	public Oferta tieneOfertaAceptada(Activo activo) {
		List<ActivoOferta> listaActivoOferta = activo.getOfertas();
		int i = 0;
		Oferta ofertaAux = null;
		Oferta ofertaAceptada = null;
		if (!Checks.estaVacio(listaActivoOferta)) {
			while (i < listaActivoOferta.size() && ofertaAceptada == null) {
				ActivoOferta tmp = listaActivoOferta.get(i);
				i++;
				ofertaAux = tmp.getPrimaryKey().getOferta();
				if (DDEstadoOferta.CODIGO_ACEPTADA.equals(ofertaAux.getEstadoOferta().getCodigo())) {
					ExpedienteComercial expediente = expedienteComercialApi
							.expedienteComercialPorOferta(ofertaAux.getId());
					if (!Checks.esNulo(expediente)) { // Si el expediente está
														// aprobado (o estados
														// posteriores).
						if (DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.ALQUILADO.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(expediente.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.BLOQUEO_ADM.equals(expediente.getEstado().getCodigo()))
							ofertaAceptada = ofertaAux;
					}
				}
			}
		}
		return ofertaAceptada;
	}

	private Trabajo tareaExternaToTrabajo(TareaExterna tareaExterna) {
		Trabajo trabajo = null;
		TareaActivo tareaActivo = tareaActivoManager.getByIdTareaExterna(tareaExterna.getId());
		if (!Checks.esNulo(tareaActivo)) {
			ActivoTramite tramite = tareaActivo.getTramite();
			if (!Checks.esNulo(tramite)) {
				trabajo = tramite.getTrabajo();
			}
		}
		return trabajo;
	}

	@Override
	public Boolean checkTiposDistintos(TareaExterna tareaExterna) {
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		Activo activo;
		if (!Checks.esNulo(trabajo))
			activo = trabajo.getActivo();
		else
			activo = ((TareaActivo) tareaExterna.getTareaPadre()).getActivo();

		if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoActivo())) {
			if (!Checks.esNulo(activo.getInfoComercial())) {
				if (!Checks.esNulo(activo.getInfoComercial().getTipoActivo()))
					return (!activo.getTipoActivo().getCodigo()
							.equals(activo.getInfoComercial().getTipoActivo().getCodigo()));
			}
		}
		return true;
	}

	@Override
	public Boolean checkTiposDistintos(Activo activo) {
		if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoActivo())) {
			if (!Checks.esNulo(activo.getInfoComercial())) {
				if (!Checks.esNulo(activo.getInfoComercial().getTipoActivo()))
					return (!activo.getTipoActivo().getCodigo()
							.equals(activo.getInfoComercial().getTipoActivo().getCodigo()));
			}
		}
		return true;
	}

	public GastosExpediente anyadirGastoExpediente(Oferta oferta, DDAccionGastos accionGasto,
			ExpedienteComercial nuevoExpediente) {

		GastosExpediente gastoExpediente = new GastosExpediente();
		gastoExpediente.setNombre(oferta.getCustodio().getNombre());
		gastoExpediente.setCodigo(oferta.getCustodio().getCodProveedorUvem());
		gastoExpediente.setProveedor(oferta.getCustodio());
		gastoExpediente.setAccionGastos(accionGasto);
		gastoExpediente.setExpediente(nuevoExpediente);

		return gastoExpediente;

	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoActivoIntegrado> getProveedoresByActivoIntegrado(DtoActivoIntegrado dtoActivoIntegrado) {
		Filter activoIDFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id",
				Long.parseLong(dtoActivoIntegrado.getIdActivo()));
		Page page = genericDao.getPage(ActivoIntegrado.class, dtoActivoIntegrado, activoIDFilter);
		List<ActivoIntegrado> activosIntegrados = (List<ActivoIntegrado>) page.getResults();
		List<DtoActivoIntegrado> dtoList = new ArrayList<DtoActivoIntegrado>();
		for (ActivoIntegrado activoIntegrado : activosIntegrados) {
			DtoActivoIntegrado dto = new DtoActivoIntegrado();
			try {
				beanUtilNotNull.copyProperty(dto, "id", activoIntegrado.getId());
				if (!Checks.esNulo(activoIntegrado.getProveedor())) {
					beanUtilNotNull.copyProperty(dto, "idProveedor", activoIntegrado.getProveedor().getId());
					beanUtilNotNull.copyProperty(dto, "pagosRetenidos", activoIntegrado.getRetenerPago());
					beanUtilNotNull.copyProperty(dto, "codigoProveedorRem",
							activoIntegrado.getProveedor().getCodigoProveedorRem());
					beanUtilNotNull.copyProperty(dto, "nifProveedor",
							activoIntegrado.getProveedor().getDocIdentificativo());
					beanUtilNotNull.copyProperty(dto, "nombreProveedor", activoIntegrado.getProveedor().getNombre());
					if (!Checks.esNulo(activoIntegrado.getProveedor().getEstadoProveedor())) {
						beanUtilNotNull.copyProperty(dto, "estadoProveedorDescripcion",
								activoIntegrado.getProveedor().getEstadoProveedor().getDescripcion());
					}

					if (!Checks.esNulo(activoIntegrado.getProveedor().getTipoProveedor())) {
						beanUtilNotNull.copyProperty(dto, "subtipoProveedorDescripcion",
								activoIntegrado.getProveedor().getTipoProveedor().getDescripcion());
					}
				}
				beanUtilNotNull.copyProperty(dto, "participacion", activoIntegrado.getParticipacion());
				beanUtilNotNull.copyProperty(dto, "fechaInclusion", activoIntegrado.getFechaInclusion());
				beanUtilNotNull.copyProperty(dto, "fechaExclusion", activoIntegrado.getFechaExclusion());
				beanUtilNotNull.copyProperty(dto, "observaciones", activoIntegrado.getObservaciones());

				beanUtilNotNull.copyProperty(dto, "totalCount", page.getTotalCount());
			} catch (IllegalAccessException e) {
				logger.error("Error en activoManager",e);
			} catch (InvocationTargetException e) {
				logger.error("Error en activoManager",e);
			}

			dtoList.add(dto);
		}

		return dtoList;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createActivoIntegrado(DtoActivoIntegrado dto) {

		try {
			if (!Checks.esNulo(dto.getCodigoProveedorRem())) {
				ActivoIntegrado activoIntegrado = new ActivoIntegrado();

				if (!Checks.esNulo(dto.getCodigoProveedorRem())) {
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
							Long.parseLong(dto.getCodigoProveedorRem()));
					ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filter);
					activoIntegrado.setProveedor(proveedor);
				}

				if (!Checks.esNulo(dto.getIdActivo())) {
					Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "id",
							Long.parseLong(dto.getIdActivo()));
					Activo activo = genericDao.get(Activo.class, filterActivo);
					activoIntegrado.setActivo(activo);
				}

				activoIntegrado.setObservaciones(dto.getObservaciones());
				if (!Checks.esNulo(dto.getParticipacion())) {
					activoIntegrado.setParticipacion(Double.parseDouble(dto.getParticipacion()));
				}
				activoIntegrado.setFechaInclusion(dto.getFechaInclusion());
				activoIntegrado.setFechaExclusion(dto.getFechaExclusion());
				if (!Checks.esNulo(dto.getRetenerPagos())) {
					if (dto.getRetenerPagos()) {
						activoIntegrado.setRetenerPago(1);
					} else {
						activoIntegrado.setRetenerPago(0);
					}
				}

				if (!Checks.esNulo(dto.getMotivoRetencionPago())) {
					DDMotivoRetencion motivoRetencion = (DDMotivoRetencion) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDMotivoRetencion.class, dto.getMotivoRetencionPago());
					activoIntegrado.setMotivoRetencion(motivoRetencion);
				}

				activoIntegrado.setFechaRetencionPago(dto.getFechaRetencionPago());
				genericDao.save(ActivoIntegrado.class, activoIntegrado);
				return true;

			}
		} catch (Exception e) {
			logger.error("Error en activoManager",e);
			return false;
		}

		return false;

	}

	public DtoActivoIntegrado getActivoIntegrado(String id) {
		DtoActivoIntegrado dto = new DtoActivoIntegrado();

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(id));
		ActivoIntegrado activoIntegrado = genericDao.get(ActivoIntegrado.class, filter);

		if (!Checks.esNulo(activoIntegrado)) {

			if (!Checks.esNulo(activoIntegrado.getActivo())) {
				dto.setIdActivo(activoIntegrado.getActivo().getId().toString());
			}

			if (!Checks.esNulo(activoIntegrado.getProveedor())) {
				if (!Checks.esNulo(activoIntegrado.getProveedor().getCodigoProveedorRem())) {
					dto.setCodigoProveedorRem(activoIntegrado.getProveedor().getCodigoProveedorRem().toString());
				}
				dto.setNombreProveedor(activoIntegrado.getProveedor().getNombre());
				dto.setNifProveedor(activoIntegrado.getProveedor().getDocIdentificativo());
				if (!Checks.esNulo(activoIntegrado.getProveedor().getTipoProveedor()) && !Checks
						.esNulo(activoIntegrado.getProveedor().getTipoProveedor().getTipoEntidadProveedor())) {
					dto.setSubtipoProveedorDescripcion(activoIntegrado.getProveedor().getTipoProveedor()
							.getTipoEntidadProveedor().getDescripcion());
				}
			}

			dto.setObservaciones(activoIntegrado.getObservaciones());
			if (!Checks.esNulo(activoIntegrado.getParticipacion())) {
				dto.setParticipacion(activoIntegrado.getParticipacion().toString());
			}
			dto.setFechaInclusion(activoIntegrado.getFechaInclusion());
			dto.setFechaExclusion(activoIntegrado.getFechaExclusion());
			if (!Checks.esNulo(activoIntegrado.getRetenerPago())) {
				if (activoIntegrado.getRetenerPago() == 1) {
					dto.setRetenerPagos(true);
				} else {
					dto.setRetenerPagos(false);
				}
			}

			if (!Checks.esNulo(activoIntegrado.getMotivoRetencion())) {
				dto.setMotivoRetencionPago(activoIntegrado.getMotivoRetencion().getCodigo());
			}
			dto.setFechaRetencionPago(activoIntegrado.getFechaRetencionPago());

		}

		return dto;

	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateActivoIntegrado(DtoActivoIntegrado dto) {

		try {
			Filter filterActivoIntegrado = genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(dto.getId()));
			ActivoIntegrado activoIntegrado = genericDao.get(ActivoIntegrado.class, filterActivoIntegrado);

			beanUtilNotNull.copyProperties(activoIntegrado, dto);

			if (!Checks.esNulo(dto.getCodigoProveedorRem())) {
				Filter filterProveedor = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
						Long.parseLong(dto.getCodigoProveedorRem()));
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filterProveedor);
				activoIntegrado.setProveedor(proveedor);
			}

			if (!Checks.esNulo(dto.getIdActivo())) {
				Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "id",
						Long.parseLong(dto.getIdActivo()));
				Activo activo = genericDao.get(Activo.class, filterActivo);
				activoIntegrado.setActivo(activo);
			}

			if (!Checks.esNulo(dto.getObservaciones())) {
				activoIntegrado.setObservaciones(dto.getObservaciones());
			}

			if (!Checks.esNulo(dto.getParticipacion())) {
				activoIntegrado.setParticipacion(Double.parseDouble(dto.getParticipacion()));
			}
			if (!Checks.esNulo(dto.getRetenerPagos())) {
				if (dto.getRetenerPagos()) {
					activoIntegrado.setRetenerPago(1);
				} else {
					activoIntegrado.setRetenerPago(0);
					activoIntegrado.setMotivoRetencion(null);
					activoIntegrado.setFechaRetencionPago(null);
				}
			}

			if (!Checks.esNulo(dto.getMotivoRetencionPago())) {
				DDMotivoRetencion motivoRetencion = (DDMotivoRetencion) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDMotivoRetencion.class, dto.getMotivoRetencionPago());
				activoIntegrado.setMotivoRetencion(motivoRetencion);
			}

			genericDao.update(ActivoIntegrado.class, activoIntegrado);
			return true;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public int cantidadOfertas(Activo activo) {
		int res = 0;
		for (ActivoOferta activoOferta : activo.getOfertas()) {
			if (activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals("01")
					|| activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals("04")) {
				res++;
			}
		}
		return res;
	}

	@Override
	public Double mayorOfertaRecibida(Activo activo) {
		Double importeMax = new Double(0);
		for (ActivoOferta activoOferta : activo.getOfertas()) {
			if (activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals("01")
					|| activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals("04")) {
				if (Double.compare(activoOferta.getPrimaryKey().getOferta().getImporteOferta(), importeMax) > 0) {
					importeMax = activoOferta.getPrimaryKey().getOferta().getImporteOferta();
				}
			}
		}
		return importeMax;
	}

	@Override
	public boolean checkVPO(TareaExterna tareaExterna) {
		Activo activo = tareaExternaToActivo(tareaExterna);
		return ("1".equals(activo.getVpo()));
	}

	@Override
	@SuppressWarnings("unchecked")
	public DtoPage getListLlavesByActivo(DtoLlaves dto) {

		Page page = activoDao.getLlavesByActivo(dto);

		List<DtoLlaves> llaves = new ArrayList<DtoLlaves>();

		for (ActivoLlave llave : (List<ActivoLlave>) page.getResults()) {

			DtoLlaves dtoLlave = this.llavesToDto(llave);
			llaves.add(dtoLlave);
		}

		return new DtoPage(llaves, page.getTotalCount());
	}

	private DtoLlaves llavesToDto(ActivoLlave llave) {
		DtoLlaves dtoLLave = new DtoLlaves();

		try {
			BeanUtils.copyProperties(dtoLLave, llave);

			if (!Checks.esNulo(llave.getActivo())) {
				BeanUtils.copyProperty(dtoLLave, "idActivo", llave.getActivo().getId().toString());
			}

		} catch (IllegalAccessException ex) {
			logger.error("Error en activoManager",ex);
		} catch (InvocationTargetException ex) {
			logger.error("Error en activoManager",ex);
		}

		return dtoLLave;
	}

	@Override
	@SuppressWarnings("unchecked")
	public DtoPage getListMovimientosLlaveByLlave(WebDto dto, Long idLlave, Long idActivo) {

		Page page;
		if (!Checks.esNulo(idLlave))
			page = activoDao.getListMovimientosLlaveByLlave(dto, idLlave);
		else
			page = activoDao.getListMovimientosLlaveByActivo(dto, idActivo);

		List<DtoMovimientoLlave> movimientos = new ArrayList<DtoMovimientoLlave>();

		for (ActivoMovimientoLlave movimiento : (List<ActivoMovimientoLlave>) page.getResults()) {

			DtoMovimientoLlave dtoMov = this.movimientoToDto(movimiento);

			movimientos.add(dtoMov);
		}

		return new DtoPage(movimientos, page.getTotalCount());
	}

	private DtoMovimientoLlave movimientoToDto(ActivoMovimientoLlave movimiento) {

		DtoMovimientoLlave dtoMov = new DtoMovimientoLlave();

		try {
			BeanUtils.copyProperties(dtoMov, movimiento);

			if (!Checks.esNulo(movimiento.getActivoLlave())) {
				BeanUtils.copyProperty(dtoMov, "idLlave", movimiento.getActivoLlave().getId().toString());
				BeanUtils.copyProperty(dtoMov, "numLlave", movimiento.getActivoLlave().getNumLlave());
			}

			if (!Checks.esNulo(movimiento.getTipoTenedor())) {
				BeanUtils.copyProperty(dtoMov, "codigoTipoTenedor", movimiento.getTipoTenedor().getCodigo());
				BeanUtils.copyProperty(dtoMov, "descripcionTipoTenedor", movimiento.getTipoTenedor().getDescripcion());
			}

		} catch (IllegalAccessException ex) {
			logger.error("Error en activoManager",ex);
		} catch (InvocationTargetException ex) {
			logger.error("Error en activoManager",ex);
		}

		return dtoMov;
	}

	@Override
	@Transactional(readOnly = false)
	public void actualizarFechaYEstadoCargaPropuesta(Long idPropuesta) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numPropuesta", idPropuesta);
		PropuestaPrecio propuesta = genericDao.get(PropuestaPrecio.class, filtro);

		propuesta.setFechaCarga(new Date());

		DDEstadoPropuestaPrecio estado = (DDEstadoPropuestaPrecio) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadoPropuestaPrecio.class, DDEstadoPropuestaPrecio.ESTADO_CARGADA);
		propuesta.setEstado(estado);

		genericDao.update(PropuestaPrecio.class, propuesta);
	}

	@Override
	public ActivoTasacion getTasacionMasReciente(Activo activo) {

		ActivoTasacion tasacionMasReciente = null;

		if (!Checks.estaVacio(activo.getTasacion())) {
			tasacionMasReciente = activo.getTasacion().get(0);
			Date fechaValorTasacionMasReciente = new Date();
			if (tasacionMasReciente.getValoracionBien().getFechaValorTasacion() != null) {
				fechaValorTasacionMasReciente = tasacionMasReciente.getValoracionBien().getFechaValorTasacion();
			}
			for (int i = 0; i < activo.getTasacion().size(); i++) {
				ActivoTasacion tas = activo.getTasacion().get(i);
				if (tas.getValoracionBien().getFechaValorTasacion() != null) {
					if (tas.getValoracionBien().getFechaValorTasacion().after(fechaValorTasacionMasReciente)) {
						fechaValorTasacionMasReciente = tas.getValoracionBien().getFechaValorTasacion();
						tasacionMasReciente = tas;
					}
				}
			}
		}

		return tasacionMasReciente;
	}

	@Override
	public ActivoValoraciones getValoracionAprobadoVenta(Activo activo) {

		List<ActivoValoraciones> listActivoValoracion = activo.getValoracion();
		if (!Checks.estaVacio(listActivoValoracion)) {
			for (ActivoValoraciones valoracion : listActivoValoracion) {
				if (DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(valoracion.getTipoPrecio().getCodigo())) {
					return valoracion;
				}
			}
		}

		return null;
	}

	@Override
	public Boolean getDptoPrecio(Activo activo) {
		return activoDao.getDptoPrecio(activo);
	}

	@Override
	public DtoComercialActivo getComercialActivo(DtoComercialActivo dto) {

		if (Checks.esNulo(dto.getId())) {
			return dto;
		}

		Activo activo = activoDao.get(Long.parseLong(dto.getId()));
		dto.setExpedienteComercialVivo(false);

		try {
			if (!Checks.esNulo(activo.getSituacionComercial())) {
				beanUtilNotNull.copyProperty(dto, "situacionComercialCodigo",
						activo.getSituacionComercial().getCodigo());
			}

			// Obtener oferta aceptada. Si tiene, establecer expediente
			// comercial vivo a true.
			Oferta oferta = this.tieneOfertaAceptada(activo);
			if (!Checks.esNulo(oferta)) {
				dto.setExpedienteComercialVivo(true);
				// Obtener expediente comercial de la oferta aprobado.
				ExpedienteComercial exp = genericDao.get(ExpedienteComercial.class,
						genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));
				// Obtener datos de venta en REM.
				if (!Checks.esNulo(exp)) {
					beanUtilNotNull.copyProperty(dto, "fechaVenta", exp.getFechaVenta());

					Double importe = null;

					if (!Checks.esNulo(oferta.getImporteContraOferta())) {
						importe = oferta.getImporteContraOferta();
					} else {
						importe = oferta.getImporteOferta();
					}
					for (ActivoOferta activoOferta : oferta.getActivosOferta()) {
						if (activo.getId().equals(activoOferta.getPrimaryKey().getActivo().getId())) {
							importe = activoOferta.getImporteActivoOferta();
						}
					}

					beanUtilNotNull.copyProperty(dto, "importeVenta", importe);
				}
			}

			// Si no existe oferta aceptada con expediente obtener datos de
			// posible venta externa a REM.
			if (!dto.getExpedienteComercialVivo()) {
				beanUtilNotNull.copyProperty(dto, "expedienteComercialVivo", false);
				if (!Checks.esNulo(activo.getFechaVentaExterna())) {
					beanUtilNotNull.copyProperty(dto, "fechaVenta", activo.getFechaVentaExterna());
				}
				if (!Checks.esNulo(activo.getImporteVentaExterna())) {
					beanUtilNotNull.copyProperty(dto, "importeVenta", activo.getImporteVentaExterna());
				}
			}

			if (!Checks.esNulo(activo.getObservacionesVentaExterna())) {
				beanUtilNotNull.copyProperty(dto, "observaciones", activo.getObservacionesVentaExterna());
			}

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager",e);
		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager",e);
		}

		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveComercialActivo(DtoComercialActivo dto) {

		if (Checks.esNulo(dto.getId())) {
			return false;
		}

		Activo activo = activoDao.get(Long.parseLong(dto.getId()));

		try {
			beanUtilNotNull.copyProperty(activo, "fechaVentaExterna", dto.getFechaVenta());
			if (!Checks.esNulo(activo.getFechaVentaExterna())) {
				DDSituacionComercial situacionComercial = (DDSituacionComercial) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSituacionComercial.class, DDSituacionComercial.CODIGO_VENDIDO);
				if (!Checks.esNulo(situacionComercial)) {
					activo.setSituacionComercial(situacionComercial);
				}
			}
		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager",e);
			return false;
		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager",e);
			return false;
		}
		if (!Checks.esNulo(dto.getImporteVenta())) {
			activo.setImporteVentaExterna(dto.getImporteVenta());
			DDSituacionComercial situacionComercial = (DDSituacionComercial) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDSituacionComercial.class, DDSituacionComercial.CODIGO_VENDIDO);
			if (!Checks.esNulo(situacionComercial)) {
				activo.setSituacionComercial(situacionComercial);
			}
		} else {
			activo.setImporteVentaExterna(null);
		}
		activo.setObservacionesVentaExterna(dto.getObservaciones());

		activoDao.save(activo);

		return true;
	}

	public boolean isIntegradoAgrupacionObraNuevaOrAsistida(Activo activo) {
		Integer contador = activoDao.isIntegradoAgrupacionObraNuevaOrAsistida(activo.getId());
		if (contador > 0) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public Double getImporteValoracionActivoByCodigo(Activo activo, String codTipoPrecio) {

		List<ActivoValoraciones> listActivoValoracion = activo.getValoracion();
		if (!Checks.estaVacio(listActivoValoracion)) {
			for (ActivoValoraciones valoracion : listActivoValoracion) {
				if (codTipoPrecio.equals(valoracion.getTipoPrecio().getCodigo())
						&& (Checks.esNulo(valoracion.getFechaFin()) || valoracion.getFechaFin().after(new Date()))) {
					return valoracion.getImporte();
				}
			}
		}

		return null;
	}

	@Override
	public String getSubtipoTrabajoByOferta(Oferta oferta) {
		if (oferta.getTipoOferta().getCodigo().equals(DDTipoOferta.CODIGO_VENTA)) {
			return DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_VENTA;
		} else
			return DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_ALQUILER;
	}

	@Transactional(readOnly = false)
	public Boolean saveActivoCarga(DtoActivoCargas cargaDto) {

		ActivoCargas cargaSeleccionada = null;

		if (!Checks.esNulo(cargaDto.getIdActivoCarga())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", cargaDto.getIdActivoCarga());
			cargaSeleccionada = (ActivoCargas) genericDao.get(ActivoCargas.class, filtro);
		} else {
			cargaSeleccionada = new ActivoCargas();

			Activo activo = get(cargaDto.getIdActivo());
			cargaSeleccionada.setActivo(activo);
			NMBBienCargas cargaBien = new NMBBienCargas();
			DDTipoCarga tipoCargaBien = (DDTipoCarga) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCarga.class,
					"0");
			cargaBien.setTipoCarga(tipoCargaBien);
			cargaBien.setBien(activo.getBien());
			cargaBien.setEconomica(false);
			genericDao.save(NMBBienCargas.class, cargaBien);
			cargaSeleccionada.setCargaBien(cargaBien);
		}

		try {

			beanUtilNotNull.copyProperties(cargaSeleccionada, cargaDto);
			beanUtilNotNull.copyProperties(cargaSeleccionada.getCargaBien(), cargaDto);

			if (!Checks.esNulo(cargaDto.getEstadoCodigo())) {
				DDSituacionCarga situacionCarga = (DDSituacionCarga) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSituacionCarga.class, cargaDto.getEstadoCodigo());
				cargaSeleccionada.getCargaBien().setSituacionCarga(situacionCarga);

			}
			if (!Checks.esNulo(cargaDto.getEstadoEconomicaCodigo())) {
				DDSituacionCarga situacionCarga = (DDSituacionCarga) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSituacionCarga.class, cargaDto.getEstadoEconomicaCodigo());
				cargaSeleccionada.getCargaBien().setSituacionCargaEconomica(situacionCarga);
			}
			if (!Checks.esNulo(cargaDto.getTipoCargaCodigo())) {
				DDTipoCargaActivo tipoCarga = (DDTipoCargaActivo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoCargaActivo.class, cargaDto.getTipoCargaCodigo());
				cargaSeleccionada.setTipoCargaActivo(tipoCarga);
			}

			if (!Checks.esNulo(cargaDto.getSubtipoCargaCodigo())) {
				DDSubtipoCarga subtipoCarga = (DDSubtipoCarga) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSubtipoCarga.class, cargaDto.getSubtipoCargaCodigo());
				cargaSeleccionada.setSubtipoCarga(subtipoCarga);
			}

		} catch (IllegalAccessException e) {
			logger.error("Error en activoManager",e);
		} catch (InvocationTargetException e) {
			logger.error("Error en activoManager",e);
		}

		activoCargasApi.saveOrUpdate(cargaSeleccionada);
		// genericDao.save(ActivoCargas.class, cargaSeleccionada);

		return true;

	}

	@Override
	@Transactional(readOnly = false)
	public Boolean deleteCarga(DtoActivoCargas dto) {

		genericDao.deleteById(ActivoCargas.class, dto.getIdActivoCarga());

		return true;

	}

	@Override
	public void calcularRatingActivo(Long idActivo) {
		activoDao.actualizarRatingActivo(idActivo, usuarioApi.getUsuarioLogado().getUsername());
	}

	@SuppressWarnings("static-access")
	private void asignarGestorYSupervisorFormalizacionToExpediente(ExpedienteComercial expediente) {
		GestorEntidadDto dto = new GestorEntidadDto();
		dto.setIdEntidad(expediente.getId());
		dto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);

		// TODO: Hasta saber que criterios necesitamos para elegir un usuario u
		// otro, asignamos el gestor/supervisor de GRUPO.
		this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_GESTOR_FORMALIZACION, "GESTFORM", dto);
		this.agregarTipoGestorYUsuarioEnDto(gestorExpedienteComercialApi.CODIGO_SUPERVISOR_FORMALIZACION, "SUPFORM",
				dto);
	}

	private void agregarTipoGestorYUsuarioEnDto(String codTipoGestor, String username, GestorEntidadDto dto) {

		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", codTipoGestor));
		Usuario usu = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", username));

		if (!Checks.esNulo(tipoGestor) && !Checks.esNulo(usu)) {
			dto.setIdTipoGestor(tipoGestor.getId());
			dto.setIdUsuario(usu.getId());
			gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(dto);
		}
	}
}
