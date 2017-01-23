package es.pfsgroup.plugin.rem.adapter;

import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAvisadorApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManagerApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoCargas;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.ActivoDistribucion;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoLlave;
import es.pfsgroup.plugin.rem.model.ActivoMovimientoLlave;
import es.pfsgroup.plugin.rem.model.ActivoObservacion;
import es.pfsgroup.plugin.rem.model.ActivoOcupanteLegal;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoOferta.ActivoOfertaPk;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.DtoActivoCargas;
import es.pfsgroup.plugin.rem.model.DtoActivoCatastro;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivoOcupanteLegal;
import es.pfsgroup.plugin.rem.model.DtoActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesActivo;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.DtoCondicionHistorico;
import es.pfsgroup.plugin.rem.model.DtoDistribucion;
import es.pfsgroup.plugin.rem.model.DtoFoto;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoIncrementoPresupuestoActivo;
import es.pfsgroup.plugin.rem.model.DtoListadoGestores;
import es.pfsgroup.plugin.rem.model.DtoListadoTareas;
import es.pfsgroup.plugin.rem.model.DtoListadoTramites;
import es.pfsgroup.plugin.rem.model.DtoLlaves;
import es.pfsgroup.plugin.rem.model.DtoMovimientoLlave;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoPresupuestoGraficoActivo;
import es.pfsgroup.plugin.rem.model.DtoPropietario;
import es.pfsgroup.plugin.rem.model.DtoTasacion;
import es.pfsgroup.plugin.rem.model.DtoTramite;
import es.pfsgroup.plugin.rem.model.DtoUsuario;
import es.pfsgroup.plugin.rem.model.DtoValoracion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.IncrementoPresupuesto;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VAdmisionDocumentos;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaPresupuestosActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaTramitesActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaVisitasDetalle;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.VPreciosVigentes;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTenedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;
import es.pfsgroup.plugin.rem.notificacion.api.AnotacionApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PRINCIPAL;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.SITUACION;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.OperationResultResponse;
import es.pfsgroup.plugin.rem.service.TabActivoDatosBasicos;
import es.pfsgroup.plugin.rem.service.TabActivoService;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;

@Service
public class ActivoAdapter {


    @Autowired 
    private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;
    
    @Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private coreextensionApi coreextensionApi;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;

	@Autowired
	private TareaActivoApi tareaActivoApi;

	@Autowired
	private JBPMActivoTramiteManagerApi jbpmActivoTramiteManagerApi;

	@Autowired
	protected JBPMProcessManagerApi jbpmProcessManagerApi;

	@Autowired
	protected TipoProcedimientoManager tipoProcedimiento;

	@Autowired
	private ActivoAvisadorApi activoAvisadorApi;

	@Autowired
	private TrabajoApi trabajoApi;

	@Resource
	private Properties appProperties;

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;

	@Autowired
	private DownloaderFactoryApi downloaderFactoryApi;

	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private TabActivoFactoryApi tabActivoFactory;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	GestorDocumentalFotosApi gestorDocumentalFotos;
	
	@Autowired
	private AnotacionApi anotacionApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Resource
    MessageService messageServices;

	//private static final String PROPIEDAD_ACTIVAR_REST_CLIENT = "rest.client.gestor.documental.activar";
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";
	public static final String OFERTA_INCOMPATIBLE_MSG = "El tipo de oferta es incompatible con el destino comercial del activo";
	private static final String AVISO_TITULO_GESTOR_COMERCIAL = "activo.aviso.titulo.cambio.gestor.comercial";
	private static final String AVISO_MENSAJE_GESTOR_COMERCIAL = "activo.aviso.descripcion.cambio.gestor.comercial";

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	protected static final Log logger = LogFactory.getLog(ActivoAdapter.class);

	public Activo getActivoById(Long id) {

		return activoApi.get(id);

	}

	/**
	 * Método que devuelve un DTO para la carga parcial de las pestañas de
	 * Activo
	 * 
	 * @param id
	 * @param pestana
	 * @return
	 */

	/*******************************************************************************************
	 * NOTA FASE II: El método getActivoByIdParcial se refactoriza utilizando
	 * una factoria. Ver this.getTabActivo. Cualquier cambio en FASE I deberá
	 * refactorizarse en el servicio que corresponda.
	 */
	/*******************************************************************************************/
	/*
	 * public Object getActivoByIdParcial(Long id, int pestana) {
	 * 
	 * Activo activo = activoApi.get(id);
	 * 
	 * // Pestaña 1: Cabecera 2: Datos registrales 3: Información Administrativa
	 * 4: Cargas 5: Situación Posesoria 6: Valoraciones y Precios 7: Información
	 * Comercial // Seteamos los campos a mano que no pueden copiarse con el
	 * copyProperties debido a las referencias try { // 1: Cabecera if (pestana
	 * == COD_PESTANA_CABECERA) {
	 * 
	 * DtoActivoFichaCabecera activoDto = new DtoActivoFichaCabecera();
	 * 
	 * BeanUtils.copyProperties(activoDto, activo);
	 * 
	 * if (activo.getLocalizacion() != null) {
	 * BeanUtils.copyProperties(activoDto,
	 * activo.getLocalizacion().getLocalizacionBien());
	 * BeanUtils.copyProperties(activoDto, activo.getLocalizacion());
	 * 
	 * if (activo.getLocalizacion().getLocalizacionBien() != null &&
	 * activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null) {
	 * BeanUtils.copyProperty(activoDto, "tipoViaCodigo",
	 * activo.getLocalizacion().getLocalizacionBien().getTipoVia().getCodigo());
	 * }
	 * 
	 * if (activo.getLocalizacion().getLocalizacionBien() != null &&
	 * activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null) {
	 * BeanUtils.copyProperty(activoDto, "tipoViaDescripcion",
	 * activo.getLocalizacion().getLocalizacionBien().getTipoVia().
	 * getDescripcion()); }
	 * 
	 * if (activo.getLocalizacion().getLocalizacionBien() != null &&
	 * activo.getLocalizacion().getLocalizacionBien().getPais() != null) {
	 * BeanUtils.copyProperty(activoDto, "paisCodigo",
	 * activo.getLocalizacion().getLocalizacionBien().getPais().getCodigo()); }
	 * if (activo.getLocalizacion().getLocalizacionBien() != null &&
	 * activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null) {
	 * BeanUtils.copyProperty(activoDto, "municipioCodigo",
	 * activo.getLocalizacion().getLocalizacionBien().getLocalidad().getCodigo()
	 * ); BeanUtils.copyProperty(activoDto, "municipioDescripcion",
	 * activo.getLocalizacion().getLocalizacionBien().getLocalidad().
	 * getDescripcion()); } if (activo.getLocalizacion().getLocalizacionBien()
	 * != null &&
	 * activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional() !=
	 * null) { BeanUtils.copyProperty(activoDto, "inferiorMunicipioCodigo",
	 * activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional().
	 * getCodigo()); BeanUtils.copyProperty(activoDto,
	 * "inferiorMunicipioDescripcion",
	 * activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional().
	 * getDescripcion()); } if (activo.getLocalizacion() != null &&
	 * activo.getLocalizacion().getLocalizacionBien() != null &&
	 * activo.getLocalizacion().getLocalizacionBien().getProvincia() != null) {
	 * BeanUtils.copyProperty(activoDto, "provinciaCodigo",
	 * activo.getLocalizacion().getLocalizacionBien().getProvincia().getCodigo()
	 * ); BeanUtils.copyProperty(activoDto, "provinciaDescripcion",
	 * activo.getLocalizacion().getLocalizacionBien().getProvincia().
	 * getDescripcion());
	 * 
	 * } if (activo.getCartera() != null) { BeanUtils.copyProperty(activoDto,
	 * "entidadPropietariaCodigo", activo.getCartera().getCodigo());
	 * BeanUtils.copyProperty(activoDto, "entidadPropietariaDescripcion",
	 * activo.getCartera().getDescripcion()); }
	 * 
	 * if (activo.getRating() != null ) { BeanUtils.copyProperty(activoDto,
	 * "rating", activo.getRating().getCodigo()); }
	 * 
	 * }
	 * 
	 * BeanUtils.copyProperty(activoDto, "propietario",
	 * activo.getFullNamePropietario());
	 * 
	 * if(activo.getTipoActivo() != null ) { BeanUtils.copyProperty(activoDto,
	 * "tipoActivoCodigo", activo.getTipoActivo().getCodigo());
	 * BeanUtils.copyProperty(activoDto, "tipoActivoDescripcion",
	 * activo.getTipoActivo().getDescripcion()); }
	 * 
	 * if (activo.getSubtipoActivo() != null ) {
	 * BeanUtils.copyProperty(activoDto, "subtipoActivoCodigo",
	 * activo.getSubtipoActivo().getCodigo()); BeanUtils.copyProperty(activoDto,
	 * "subtipoActivoDescripcion", activo.getSubtipoActivo().getDescripcion());
	 * }
	 * 
	 * if (activo.getTipoTitulo() != null) { BeanUtils.copyProperty(activoDto,
	 * "tipoTitulo", activo.getTipoTitulo().getDescripcion());
	 * BeanUtils.copyProperty(activoDto, "tipoTituloCodigo",
	 * activo.getTipoTitulo().getCodigo()); BeanUtils.copyProperty(activoDto,
	 * "tipoTituloDescripcion", activo.getTipoTitulo().getDescripcion()); }
	 * 
	 * if (activo.getSubtipoTitulo() != null) {
	 * BeanUtils.copyProperty(activoDto, "subtipoTitulo",
	 * activo.getSubtipoTitulo().getDescripcion());
	 * BeanUtils.copyProperty(activoDto, "subtipoTituloCodigo",
	 * activo.getSubtipoTitulo().getCodigo()); BeanUtils.copyProperty(activoDto,
	 * "subtipoTituloDescripcion", activo.getSubtipoTitulo().getDescripcion());
	 * }
	 * 
	 * if (activo.getCartera() != null) { BeanUtils.copyProperty(activoDto,
	 * "entidadPropietariaCodigo", activo.getCartera().getCodigo());
	 * BeanUtils.copyProperty(activoDto, "entidadPropietariaDescripcion",
	 * activo.getCartera().getDescripcion()); }
	 * 
	 * if (activo.getBien().getLocalizaciones() != null &&
	 * activo.getBien().getLocalizaciones().get(0).getLocalidad() != null) {
	 * BeanUtils.copyProperty(activoDto, "municipioDescripcion",
	 * activo.getBien().getLocalizaciones().get(0).getLocalidad().getDescripcion
	 * ()); }
	 * 
	 * if (activo.getEstadoActivo() != null) { BeanUtils.copyProperty(activoDto,
	 * "estadoActivoCodigo", activo.getEstadoActivo().getCodigo()); }
	 * 
	 * if (activo.getTipoUsoDestino() != null) {
	 * BeanUtils.copyProperty(activoDto, "tipoUsoDestinoCodigo",
	 * activo.getTipoUsoDestino().getCodigo());
	 * BeanUtils.copyProperty(activoDto, "tipoUsoDestinoDescripcion",
	 * activo.getTipoUsoDestino().getDescripcion()); }
	 * 
	 * if (activo.getComunidadPropietarios() != null) {
	 * BeanUtils.copyProperties(activoDto, activo.getComunidadPropietarios());
	 * BeanUtils.copyProperty(activoDto, "direccionComunidad",
	 * activo.getComunidadPropietarios().getDireccion());
	 * 
	 * 
	 * // if (activo.getComunidadPropietarios().getNumCuenta() != null) { // //
	 * String numCuentaTrim =
	 * activo.getComunidadPropietarios().getNumCuenta().trim(); //
	 * BeanUtils.copyProperty(activoDto, "numCuentaUno",
	 * numCuentaTrim.substring(0, 4)); // BeanUtils.copyProperty(activoDto,
	 * "numCuentaDos", numCuentaTrim.substring(4, 8)); //
	 * BeanUtils.copyProperty(activoDto, "numCuentaTres",
	 * numCuentaTrim.substring(8, 12)); // BeanUtils.copyProperty(activoDto,
	 * "numCuentaCuatro", numCuentaTrim.substring(12, 14)); //
	 * BeanUtils.copyProperty(activoDto, "numCuentaCinco",
	 * numCuentaTrim.substring(14)); // }
	 * 
	 * 
	 * }
	 * 
	 * if (activo.getInfoComercial() != null &&
	 * activo.getInfoComercial().getTipoInfoComercial() != null) {
	 * BeanUtils.copyProperty(activoDto, "tipoInfoComercialCodigo",
	 * activo.getInfoComercial().getTipoInfoComercial().getCodigo()); }
	 * 
	 * return activoDto;
	 * 
	 * // 2: Datos registrales } else if (pestana == COD_PESTANA_REGISTRAL) {
	 * 
	 * DtoActivoDatosRegistrales activoDto = new DtoActivoDatosRegistrales();
	 * 
	 * BeanUtils.copyProperties(activoDto, activo); if
	 * (activo.getInfoRegistral() != null) { BeanUtils.copyProperties(activoDto,
	 * activo.getInfoRegistral()); } if (activo.getAdjNoJudicial() != null) {
	 * BeanUtils.copyProperties(activoDto, activo.getAdjNoJudicial()); }
	 * 
	 * if (activo.getPdv() != null) { BeanUtils.copyProperties(activoDto,
	 * activo.getPdv()); }
	 * 
	 * if (activo.getTitulo() != null) { BeanUtils.copyProperties(activoDto,
	 * activo.getTitulo()); if (activo.getTitulo().getEstado() != null) { if
	 * (activo.getTitulo().getEstado() != null) {
	 * BeanUtils.copyProperty(activoDto, "estadoTitulo",
	 * activo.getTitulo().getEstado().getCodigo()); } } }
	 * 
	 * if (activo.getInfoRegistral() != null) {
	 * BeanUtils.copyProperties(activoDto,
	 * activo.getInfoRegistral().getInfoRegistralBien());
	 * 
	 * if (activo.getInfoRegistral().getEstadoDivHorizontal() != null ) {
	 * BeanUtils.copyProperty(activoDto, "estadoDivHorizontalCodigo",
	 * activo.getInfoRegistral().getEstadoDivHorizontal().getCodigo()); }
	 * 
	 * if(activo.getInfoRegistral().getDivHorInscrito() == null) {
	 * activoDto.setDivHorInscrito(null); }
	 * 
	 * if (activo.getInfoRegistral().getEstadoObraNueva() != null ) {
	 * BeanUtils.copyProperty(activoDto, "estadoObraNuevaCodigo",
	 * activo.getInfoRegistral().getEstadoObraNueva().getCodigo()); }
	 * 
	 * if (activo.getInfoRegistral().getInfoRegistralBien() != null &&
	 * activo.getInfoRegistral().getInfoRegistralBien().getLocalidad() != null)
	 * { BeanUtils.copyProperty(activoDto, "poblacionRegistro",
	 * activo.getInfoRegistral().getInfoRegistralBien().getLocalidad().getCodigo
	 * ()); }
	 * 
	 * if (activo.getInfoRegistral().getInfoRegistralBien() != null &&
	 * activo.getInfoRegistral().getInfoRegistralBien().getProvincia() != null)
	 * { BeanUtils.copyProperty(activoDto, "provinciaRegistro",
	 * activo.getInfoRegistral().getInfoRegistralBien().getProvincia().getCodigo
	 * ()); }
	 * 
	 * if (activo.getInfoRegistral().getInfoRegistralBien() != null &&
	 * activo.getInfoRegistral().getLocalidadAnterior() != null) {
	 * BeanUtils.copyProperty(activoDto, "localidadAnteriorCodigo",
	 * activo.getInfoRegistral().getLocalidadAnterior().getCodigo()); }
	 * 
	 * if (activo.getTipoTitulo() != null) { BeanUtils.copyProperty(activoDto,
	 * "tipoTituloCodigo", activo.getTipoTitulo().getCodigo()); } if
	 * (activo.getSubtipoTitulo() != null) { BeanUtils.copyProperty(activoDto,
	 * "subtipoTituloCodigo", activo.getSubtipoTitulo().getCodigo()); } if
	 * (activo.getCartera() != null) { BeanUtils.copyProperty(activoDto,
	 * "entidadPropietariaCodigo", activo.getCartera().getCodigo()); }
	 * 
	 * }
	 * 
	 * if (activo.getAdjJudicial() != null) {
	 * 
	 * BeanUtils.copyProperties(activoDto, activo.getAdjJudicial());
	 * 
	 * if (activo.getAdjJudicial().getAdjudicacionBien() != null) {
	 * BeanUtils.copyProperties(activoDto,
	 * activo.getAdjJudicial().getAdjudicacionBien());
	 * 
	 * if
	 * (activo.getAdjJudicial().getAdjudicacionBien().getEntidadAdjudicataria()
	 * != null) { BeanUtils.copyProperty(activoDto,
	 * "entidadAdjudicatariaCodigo",
	 * activo.getAdjJudicial().getAdjudicacionBien().getEntidadAdjudicataria().
	 * getCodigo()); }
	 * 
	 * }
	 * 
	 * if (activo.getAdjJudicial().getEntidadEjecutante() != null) {
	 * BeanUtils.copyProperty(activoDto, "entidadEjecutanteCodigo",
	 * activo.getAdjJudicial().getEntidadEjecutante().getCodigo()); }
	 * 
	 * if (activo.getAdjJudicial().getJuzgado() != null) {
	 * BeanUtils.copyProperty(activoDto, "tipoJuzgadoCodigo",
	 * activo.getAdjJudicial().getJuzgado().getCodigo()); }
	 * 
	 * if (activo.getAdjJudicial().getPlazaJuzgado() != null) {
	 * BeanUtils.copyProperty(activoDto, "tipoPlazaCodigo",
	 * activo.getAdjJudicial().getPlazaJuzgado().getCodigo()); }
	 * 
	 * if (activo.getAdjJudicial().getEstadoAdjudicacion() != null) {
	 * BeanUtils.copyProperty(activoDto, "estadoAdjudicacionCodigo",
	 * activo.getAdjJudicial().getEstadoAdjudicacion().getCodigo());
	 * 
	 * }
	 * 
	 * }
	 * 
	 * 
	 * return activoDto;
	 * 
	 * // 3: Información Administrativa } else if (pestana ==
	 * COD_PESTANA_ADMINISTRATIVA) {
	 * 
	 * DtoActivoInformacionAdministrativa activoDto = new
	 * DtoActivoInformacionAdministrativa();
	 * 
	 * if (activo.getInfoAdministrativa() != null) {
	 * BeanUtils.copyProperties(activoDto, activo.getInfoAdministrativa()); if
	 * (activo.getInfoAdministrativa().getTipoVpo() != null) {
	 * BeanUtils.copyProperty(activoDto, "tipoVpoId",
	 * activo.getInfoAdministrativa().getTipoVpo().getId());
	 * BeanUtils.copyProperty(activoDto, "tipoVpoCodigo",
	 * activo.getInfoAdministrativa().getTipoVpo().getCodigo());
	 * BeanUtils.copyProperty(activoDto, "tipoVpoDescripcion",
	 * activo.getInfoAdministrativa().getTipoVpo().getDescripcion()); } }
	 * 
	 * BeanUtils.copyProperty(activoDto, "vpo", activo.getVpo());
	 * 
	 * return activoDto;
	 * 
	 * // 4: Cargas } else if (pestana == COD_PESTANA_CARGAS) {
	 * 
	 * DtoActivoCargasTab activoDto = new DtoActivoCargasTab();
	 * BeanUtils.copyProperties(activoDto, activo);
	 * 
	 * return activoDto;
	 * 
	 * // 5: Situación Posesoria y llaves } else if (pestana ==
	 * COD_PESTANA_POSESORIA_LLAVES) {
	 * 
	 * DtoActivoSituacionPosesoria activoDto = new
	 * DtoActivoSituacionPosesoria(); if (activo != null){
	 * BeanUtils.copyProperty(activoDto, "necesarias",
	 * activo.getLlavesNecesarias()); BeanUtils.copyProperty(activoDto,
	 * "llaveHre", activo.getLlavesHre()); BeanUtils.copyProperty(activoDto,
	 * "fechaRecepcionLlave", activo.getFechaRecepcionLlaves());
	 * BeanUtils.copyProperty(activoDto, "numJuegos",
	 * activo.getNumJuegosLlaves()); }
	 * 
	 * if (activo.getSituacionPosesoria() != null) {
	 * beanUtilNotNull.copyProperties(activoDto,
	 * activo.getSituacionPosesoria()); if
	 * (activo.getSituacionPosesoria().getTipoTituloPosesorio() != null) {
	 * BeanUtils.copyProperty(activoDto, "tipoTituloPosesorioCodigo",
	 * activo.getSituacionPosesoria().getTipoTituloPosesorio().getCodigo()); } }
	 * /* //Añadir al DTO los atributos de llaves también
	 * 
	 * if (activo.getLlaves() != null) { for (int i = 0; i <
	 * activo.getLlaves().size(); i++) { try {
	 * 
	 * ActivoLlave llave = activo.getLlaves().get(i);
	 * BeanUtils.copyProperties(activoDto, llave); } catch (Exception e) {
	 * e.printStackTrace(); return null; } } }
	 * 
	 * return activoDto;
	 * 
	 * // 6: Valoraciones y Precios } else if (pestana ==
	 * COD_PESTANA_VALORACIONES_PRECIOS) {
	 * 
	 * //Ahora el valor de tasacion se obtiene de una relacion de 1 a N con lo
	 * que hay que mostrar un listado para las tasaciones //if
	 * (activo.getValoracion() != null &&
	 * activo.getValoracion().getValoracionBien() != null) {
	 * //activoDto.setImporteValorTasacion(activo.getValoracion().
	 * getValoracionBien().getImporteValorTasacion()); //}
	 * 
	 * DtoActivoValoraciones activoDto = new DtoActivoValoraciones();
	 * 
	 * if (activo.getAdjJudicial() != null &&
	 * activo.getAdjJudicial().getAdjudicacionBien() != null) {
	 * BeanUtils.copyProperty(activoDto, "importeAdjudicacion",
	 * activo.getAdjJudicial().getAdjudicacionBien().getImporteAdjudicacion());
	 * }
	 * 
	 * if (activo.getAdjNoJudicial() != null) {
	 * BeanUtils.copyProperty(activoDto, "valorAdquisicion",
	 * activo.getAdjNoJudicial().getValorAdquisicion()); }
	 * 
	 * if (activo.getValoracion() != null){
	 * 
	 * for (int i = 0; i < activo.getValoracion().size(); i++) { try {
	 * 
	 * ActivoValoraciones val = activo.getValoracion().get(i);
	 * 
	 * if(val.getFechaFin() == null){ if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("01")){
	 * beanUtilNotNull.copyProperty(activoDto, "importeNetoContProp",
	 * val.getImporte()); } if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("02")){
	 * beanUtilNotNull.copyProperty(activoDto, "importePropVenta",
	 * val.getImporte()); } if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("03")){
	 * beanUtilNotNull.copyProperty(activoDto, "importePropAlquiler",
	 * val.getImporte()); } if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("04")){
	 * beanUtilNotNull.copyProperty(activoDto, "importeMinPropVenta",
	 * val.getImporte()); } if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("05")){
	 * beanUtilNotNull.copyProperty(activoDto, "importeMinPropAlquiler",
	 * val.getImporte()); } if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("06")){
	 * beanUtilNotNull.copyProperty(activoDto, "importePublicacion",
	 * val.getImporte()); } if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("07")){
	 * beanUtilNotNull.copyProperty(activoDto, "importeEvento",
	 * val.getImporte()); } if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("08")){
	 * beanUtilNotNull.copyProperty(activoDto, "importeSubasta",
	 * val.getImporte()); } if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("09")){
	 * beanUtilNotNull.copyProperty(activoDto, "importeLegalVpo",
	 * val.getImporte()); } if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("10")){
	 * beanUtilNotNull.copyProperty(activoDto, "importeTasacionVenta",
	 * val.getImporte()); } if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("11")){
	 * beanUtilNotNull.copyProperty(activoDto, "importeEstimadoVenta",
	 * val.getImporte()); } if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("12")){
	 * beanUtilNotNull.copyProperty(activoDto, "importeEstimadoAlquiler",
	 * val.getImporte()); } }
	 * 
	 * } catch (IllegalAccessException e) { e.printStackTrace(); } catch
	 * (InvocationTargetException e) { e.printStackTrace(); } } }
	 * 
	 * try {
	 * 
	 * if (!Checks.estaVacio(activo.getTasacion())) { ActivoTasacion
	 * tasacionMasReciente = activo.getTasacion().get(0); Date
	 * fechaValorTasacionMasReciente = new Date(); if
	 * (tasacionMasReciente.getValoracionBien().getFechaValorTasacion() != null)
	 * { fechaValorTasacionMasReciente =
	 * tasacionMasReciente.getValoracionBien().getFechaValorTasacion(); } for
	 * (int i = 0; i < activo.getTasacion().size(); i++) { ActivoTasacion tas =
	 * activo.getTasacion().get(i); if
	 * (tas.getValoracionBien().getFechaValorTasacion() != null) { if
	 * (tas.getValoracionBien().getFechaValorTasacion().after(
	 * fechaValorTasacionMasReciente)) { fechaValorTasacionMasReciente =
	 * tas.getValoracionBien().getFechaValorTasacion(); tasacionMasReciente =
	 * tas; } } } beanUtilNotNull.copyProperty(activoDto,
	 * "importeValorTasacion",
	 * tasacionMasReciente.getValoracionBien().getImporteValorTasacion());
	 * beanUtilNotNull.copyProperty(activoDto, "fechaValorTasacion",
	 * tasacionMasReciente.getValoracionBien().getFechaValorTasacion()); if
	 * (tasacionMasReciente.getTipoTasacion() != null){
	 * beanUtilNotNull.copyProperty(activoDto, "tipoTasacionDescripcion",
	 * tasacionMasReciente.getTipoTasacion().getDescripcion()); }
	 * 
	 * 
	 * }
	 * 
	 * } catch (IllegalAccessException e) { e.printStackTrace(); } catch
	 * (InvocationTargetException e) { e.printStackTrace(); }
	 * 
	 * return activoDto;
	 * 
	 * // 7: Información Comercial } else if (pestana == COD_PESTANA_COMERCIAL)
	 * {
	 * 
	 * DtoActivoInformacionComercial activoDto = new
	 * DtoActivoInformacionComercial();
	 * 
	 * if (activo.getInfoComercial() != null) {
	 * BeanUtils.copyProperties(activoDto, activo.getInfoComercial());
	 * 
	 * if (activo.getInfoComercial().getEdificio() != null) {
	 * BeanUtils.copyProperties(activoDto,
	 * activo.getInfoComercial().getEdificio()); }
	 * 
	 * if (activo.getInfoComercial().getUbicacionActivo() != null) {
	 * BeanUtils.copyProperty(activoDto, "ubicacionActivoCodigo",
	 * activo.getInfoComercial().getUbicacionActivo()); }
	 * 
	 * if (activo.getInfoComercial().getTipoInfoComercial() != null) {
	 * BeanUtils.copyProperty(activoDto, "tipoInfoComercialCodigo",
	 * activo.getInfoComercial().getTipoInfoComercial().getCodigo()); }
	 * 
	 * if (activo.getInfoComercial().getUbicacionActivo() != null) {
	 * BeanUtils.copyProperty(activoDto, "ubicacionActivoCodigo",
	 * activo.getInfoComercial().getUbicacionActivo().getCodigo()); }
	 * 
	 * if (activo.getInfoComercial().getEstadoConstruccion() != null) {
	 * BeanUtils.copyProperty(activoDto, "estadoConstruccionCodigo",
	 * activo.getInfoComercial().getEstadoConstruccion().getCodigo()); }
	 * 
	 * if (activo.getInfoComercial().getEstadoConservacion() != null) {
	 * BeanUtils.copyProperty(activoDto, "estadoConservacionCodigo",
	 * activo.getInfoComercial().getEstadoConservacion().getCodigo()); }
	 * 
	 * if (activo.getInfoComercial().getEdificio() != null &&
	 * activo.getInfoComercial().getEdificio().getEstadoConservacionEdificio()
	 * != null) { BeanUtils.copyProperty(activoDto,
	 * "estadoConservacionEdificioCodigo",
	 * activo.getInfoComercial().getEdificio().getEstadoConservacionEdificio().
	 * getCodigo()); }
	 * 
	 * if (activo.getInfoComercial().getEdificio() != null &&
	 * activo.getInfoComercial().getEdificio().getTipoFachada() != null) {
	 * BeanUtils.copyProperty(activoDto, "tipoFachadaCodigo",
	 * activo.getInfoComercial().getEdificio().getTipoFachada().getCodigo()); }
	 * 
	 * if (activo.getInfoComercial().getMediadorInforme() != null) {
	 * BeanUtils.copyProperty(activoDto, "nombreMediador",
	 * activo.getInfoComercial().getMediadorInforme().getNombre());
	 * BeanUtils.copyProperty(activoDto, "telefonoMediador",
	 * activo.getInfoComercial().getMediadorInforme().getTelefono1());
	 * BeanUtils.copyProperty(activoDto, "emailMediador",
	 * activo.getInfoComercial().getMediadorInforme().getEmail()); }
	 * 
	 * if (activo.getInfoComercial() instanceof ActivoVivienda) { if
	 * (activo.getInfoComercial().getTipoInfoComercial() != null) {
	 * 
	 * if (((ActivoVivienda)activo.getInfoComercial()).getTipoVivienda() !=
	 * null) { BeanUtils.copyProperty(activoDto, "tipoViviendaCodigo",
	 * ((ActivoVivienda)activo.getInfoComercial()).getTipoVivienda().getCodigo()
	 * ); }
	 * 
	 * if (((ActivoVivienda)activo.getInfoComercial()).getTipoOrientacion() !=
	 * null) { BeanUtils.copyProperty(activoDto, "tipoOrientacionCodigo",
	 * ((ActivoVivienda)activo.getInfoComercial()).getTipoOrientacion().
	 * getCodigo()); }
	 * 
	 * if (((ActivoVivienda)activo.getInfoComercial()).getTipoRenta() != null) {
	 * BeanUtils.copyProperty(activoDto, "tipoRentaCodigo",
	 * ((ActivoVivienda)activo.getInfoComercial()).getTipoRenta().getCodigo());
	 * } } }
	 * 
	 * if (activo.getInfoComercial().getInfraestructura()!=null) {
	 * beanUtilNotNull.copyProperties(activoDto,
	 * activo.getInfoComercial().getInfraestructura()); }
	 * 
	 * if (activo.getInfoComercial().getCarpinteriaInterior()!=null) {
	 * beanUtilNotNull.copyProperties(activoDto,
	 * activo.getInfoComercial().getCarpinteriaInterior()); if
	 * (activo.getInfoComercial().getCarpinteriaInterior().getAcabadoCarpinteria
	 * ()!=null) { beanUtilNotNull.copyProperty(activoDto,
	 * "acabadoCarpinteriaCodigo",
	 * activo.getInfoComercial().getCarpinteriaInterior().getAcabadoCarpinteria(
	 * ).getCodigo()); } }
	 * 
	 * if (activo.getInfoComercial().getCarpinteriaExterior()!=null) {
	 * beanUtilNotNull.copyProperties(activoDto,
	 * activo.getInfoComercial().getCarpinteriaExterior()); }
	 * 
	 * if (activo.getInfoComercial().getParamentoVertical()!=null) {
	 * beanUtilNotNull.copyProperties(activoDto,
	 * activo.getInfoComercial().getParamentoVertical()); }
	 * 
	 * if (activo.getInfoComercial().getSolado()!=null) {
	 * beanUtilNotNull.copyProperties(activoDto,
	 * activo.getInfoComercial().getSolado()); }
	 * 
	 * if (activo.getInfoComercial().getCocina()!=null) {
	 * beanUtilNotNull.copyProperties(activoDto,
	 * activo.getInfoComercial().getCocina()); }
	 * 
	 * if (activo.getInfoComercial().getBanyo()!=null) {
	 * beanUtilNotNull.copyProperties(activoDto,
	 * activo.getInfoComercial().getBanyo()); }
	 * 
	 * if (activo.getInfoComercial().getInstalacion()!=null) {
	 * beanUtilNotNull.copyProperties(activoDto,
	 * activo.getInfoComercial().getInstalacion()); }
	 * 
	 * if (activo.getInfoComercial().getZonaComun()!=null) {
	 * beanUtilNotNull.copyProperties(activoDto,
	 * activo.getInfoComercial().getZonaComun()); } }
	 * 
	 * if (activo.getTipoActivo() != null) { BeanUtils.copyProperty(activoDto,
	 * "tipoActivoCodigo", activo.getTipoActivo().getCodigo()); }
	 * 
	 * return activoDto;
	 * 
	 * } //8: Precios y valores else if (pestana == 8) {
	 * 
	 * DtoActivoValoraciones valoracionesDto = new DtoActivoValoraciones();
	 * 
	 * BeanUtils.copyProperties(valoracionesDto, activo);
	 * 
	 * if (activo.getAdjJudicial() != null &&
	 * activo.getAdjJudicial().getAdjudicacionBien() != null) {
	 * BeanUtils.copyProperty(valoracionesDto, "importeAdjudicacion",
	 * activo.getAdjJudicial().getAdjudicacionBien().getImporteAdjudicacion());
	 * }
	 * 
	 * if (activo.getAdjNoJudicial() != null) {
	 * BeanUtils.copyProperty(valoracionesDto, "valorAdquisicion",
	 * activo.getAdjNoJudicial().getValorAdquisicion()); }
	 * 
	 * if (activo.getGestorBloqueoPrecio() != null) {
	 * BeanUtils.copyProperty(valoracionesDto, "gestorBloqueoPrecio",
	 * activo.getGestorBloqueoPrecio().getApellidoNombre()); }
	 * 
	 * if (activo.getValoracion() != null) {
	 * 
	 * for (int i = 0; i < activo.getValoracion().size(); i++) {
	 * ActivoValoraciones val = activo.getValoracion().get(i);
	 * 
	 * 
	 * if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("01"))
	 * beanUtilNotNull.copyProperty(valoracionesDto, "vnc", val.getImporte());
	 * 
	 * if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("14"))
	 * beanUtilNotNull.copyProperty(valoracionesDto, "valorReferencia",
	 * val.getImporte());
	 * 
	 * if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("15"))
	 * beanUtilNotNull.copyProperty(valoracionesDto, "precioTransferencia",
	 * val.getImporte());
	 * 
	 * if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("16"))
	 * beanUtilNotNull.copyProperty(valoracionesDto,
	 * "valorAsesoramientoLiquidativo", val.getImporte());
	 * 
	 * if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("17"))
	 * beanUtilNotNull.copyProperty(valoracionesDto, "vacbe", val.getImporte());
	 * 
	 * if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("19"))
	 * beanUtilNotNull.copyProperty(valoracionesDto, "fsvVenta",
	 * val.getImporte());
	 * 
	 * if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("20"))
	 * beanUtilNotNull.copyProperty(valoracionesDto, "fsvRenta",
	 * val.getImporte());
	 * 
	 * if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("11"))
	 * beanUtilNotNull.copyProperty(valoracionesDto, "valorEstimadoVenta",
	 * val.getImporte());
	 * 
	 * if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("12"))
	 * beanUtilNotNull.copyProperty(valoracionesDto, "valorEstimadoRenta",
	 * val.getImporte());
	 * 
	 * if(val.getTipoPrecio() != null &&
	 * val.getTipoPrecio().getCodigo().equalsIgnoreCase("09"))
	 * beanUtilNotNull.copyProperty(valoracionesDto, "valorLegalVpo",
	 * val.getImporte());
	 * 
	 * } }
	 * 
	 * if (activo.getTotalValorCatastralConst() != null) {
	 * beanUtilNotNull.copyProperty(valoracionesDto, "valorCatastralConst",
	 * activo.getTotalValorCatastralConst()); }
	 * 
	 * if (activo.getTotalValorCatastralSuelo() != null) {
	 * beanUtilNotNull.copyProperty(valoracionesDto, "valorCatastralSuelo",
	 * activo.getTotalValorCatastralSuelo()); }
	 * 
	 * return valoracionesDto;
	 * 
	 * } else {
	 * 
	 * DtoActivoFichaCabecera activoDto = new DtoActivoFichaCabecera();
	 * BeanUtils.copyProperties(activoDto, activo); return activoDto;
	 * 
	 * } } catch (Exception e) { e.printStackTrace(); return null; }
	 * 
	 * 
	 * }
	 */

	/********************************************************
	 * NOTA FASE II: Refactorizado en this.saveTabActivo
	 ********************************************************/
	/*
	 * saveActivo
	 * 
	 * @Transactional(readOnly = false) public boolean
	 * saveActivo(DtoActivoFichaCabecera dto, Long id) {
	 * 
	 * Activo activo = activoApi.get(id);
	 * 
	 * try {
	 * 
	 * beanUtilNotNull.copyProperties(activo, dto);
	 * 
	 * if (activo.getLocalizacion() == null) { activo.setLocalizacion(new
	 * ActivoLocalizacion()); activo.getLocalizacion().setActivo(activo); } if
	 * (activo.getLocalizacion().getLocalizacionBien() == null ){
	 * NMBLocalizacionesBien localizacionesVacia = new NMBLocalizacionesBien();
	 * localizacionesVacia.setBien(activo.getBien());
	 * activo.getLocalizacion().setLocalizacionBien(localizacionesVacia);
	 * 
	 * activo.getLocalizacion().setLocalizacionBien(genericDao.save(
	 * NMBLocalizacionesBien.class,
	 * activo.getLocalizacion().getLocalizacionBien()));
	 * 
	 * 
	 * }
	 * 
	 * beanUtilNotNull.copyProperties(activo.getLocalizacion(), dto);
	 * beanUtilNotNull.copyProperties(activo.getLocalizacion().
	 * getLocalizacionBien(), dto);
	 * 
	 * activo.setLocalizacion(genericDao.save(ActivoLocalizacion.class,
	 * activo.getLocalizacion()));
	 * 
	 * 
	 * if (activo.getComunidadPropietarios() == null) {
	 * activo.setComunidadPropietarios(new ActivoComunidadPropietarios()); }
	 * 
	 * beanUtilNotNull.copyProperties(activo.getComunidadPropietarios(), dto);
	 * beanUtilNotNull.copyProperty(activo.getComunidadPropietarios(),
	 * "direccion", dto.getDireccionComunidad());
	 * 
	 * 
	 * String cuentaUno = ""; String cuentaDos = ""; String cuentaTres = "";
	 * String cuentaCuatro = ""; String cuentaCinco = "";
	 * 
	 * if (dto.getNumCuentaUno() != null || dto.getNumCuentaDos() != null ||
	 * dto.getNumCuentaTres() != null || dto.getNumCuentaCuatro() != null ||
	 * dto.getNumCuentaCinco() != null) {
	 * 
	 * String numCuentaTrim = ""; if
	 * (activo.getComunidadPropietarios().getNumCuenta() != null) {
	 * numCuentaTrim = activo.getComunidadPropietarios().getNumCuenta().trim();
	 * }
	 * 
	 * if (dto.getNumCuentaUno() != null) { cuentaUno = dto.getNumCuentaUno(); }
	 * else if (activo.getComunidadPropietarios().getNumCuenta() != null) {
	 * cuentaUno = numCuentaTrim.substring(0, 4); }
	 * 
	 * if (dto.getNumCuentaDos() != null) { cuentaDos = dto.getNumCuentaDos(); }
	 * else if (activo.getComunidadPropietarios().getNumCuenta() != null) {
	 * cuentaDos = numCuentaTrim.substring(4, 8); }
	 * 
	 * if (dto.getNumCuentaTres() != null) { cuentaTres =
	 * dto.getNumCuentaTres(); } else if
	 * (activo.getComunidadPropietarios().getNumCuenta() != null) { cuentaTres =
	 * numCuentaTrim.substring(8, 12); }
	 * 
	 * if (dto.getNumCuentaCuatro() != null) { cuentaCuatro =
	 * dto.getNumCuentaCuatro(); } else if
	 * (activo.getComunidadPropietarios().getNumCuenta() != null) { cuentaCuatro
	 * = numCuentaTrim.substring(12, 14); }
	 * 
	 * if (dto.getNumCuentaCinco() != null) { cuentaCinco =
	 * dto.getNumCuentaCinco(); } else if
	 * (activo.getComunidadPropietarios().getNumCuenta() != null) { cuentaCinco
	 * = numCuentaTrim.substring(14); }
	 * 
	 * beanUtilNotNull.copyProperty(activo.getComunidadPropietarios(),
	 * "numCuenta", cuentaUno + cuentaDos + cuentaTres + cuentaCuatro +
	 * cuentaCinco);
	 * 
	 * }
	 * 
	 * activo.setComunidadPropietarios(genericDao.save(
	 * ActivoComunidadPropietarios.class, activo.getComunidadPropietarios()));
	 * 
	 * 
	 * 
	 * 
	 * if (dto.getPaisCodigo() != null) {
	 * 
	 * DDCicCodigoIsoCirbeBKP pais = (DDCicCodigoIsoCirbeBKP) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(
	 * DDCicCodigoIsoCirbeBKP.class, dto.getPaisCodigo());
	 * 
	 * activo.getLocalizacion().getLocalizacionBien().setPais(pais);
	 * 
	 * }
	 * 
	 * if (dto.getTipoViaCodigo() != null) {
	 * 
	 * Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
	 * dto.getTipoViaCodigo()); DDTipoVia tipoViaNueva = (DDTipoVia)
	 * genericDao.get(DDTipoVia.class, filtro);
	 * 
	 * activo.getLocalizacion().getLocalizacionBien().setTipoVia(tipoViaNueva);
	 * 
	 * }
	 * 
	 * if (dto.getProvinciaCodigo() != null) {
	 * 
	 * Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
	 * dto.getProvinciaCodigo()); DDProvincia provincia = (DDProvincia)
	 * genericDao.get(DDProvincia.class, filtro);
	 * 
	 * activo.getLocalizacion().getLocalizacionBien().setProvincia(provincia); }
	 * 
	 * if (dto.getMunicipioCodigo() != null) {
	 * 
	 * Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
	 * dto.getMunicipioCodigo()); Localidad municipioNuevo = (Localidad)
	 * genericDao.get(Localidad.class, filtro);
	 * 
	 * activo.getLocalizacion().getLocalizacionBien().setLocalidad(
	 * municipioNuevo); }
	 * 
	 * if (dto.getInferiorMunicipioCodigo() != null) {
	 * 
	 * Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
	 * dto.getInferiorMunicipioCodigo()); DDUnidadPoblacional inferiorNuevo =
	 * (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class, filtro);
	 * 
	 * activo.getLocalizacion().getLocalizacionBien().setUnidadPoblacional(
	 * inferiorNuevo); }
	 * 
	 * activo.getLocalizacion().setLocalizacionBien(genericDao.save(
	 * NMBLocalizacionesBien.class,
	 * activo.getLocalizacion().getLocalizacionBien()));
	 * 
	 * if (dto.getTipoActivoCodigo() != null) {
	 * 
	 * DDTipoActivo tipoActivo = (DDTipoActivo) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoActivo.class,
	 * dto.getTipoActivoCodigo());
	 * 
	 * activo.setTipoActivo(tipoActivo);
	 * 
	 * }
	 * 
	 * if (dto.getSubtipoActivoCodigo() != null) {
	 * 
	 * DDSubtipoActivo subtipoActivo = (DDSubtipoActivo) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDSubtipoActivo.
	 * class, dto.getSubtipoActivoCodigo());
	 * 
	 * activo.setSubtipoActivo(subtipoActivo);
	 * 
	 * }
	 * 
	 * if (dto.getTipoTitulo() != null) {
	 * 
	 * DDTipoTituloActivo tipoTitulo = (DDTipoTituloActivo) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoTituloActivo.
	 * class, dto.getTipoTitulo());
	 * 
	 * activo.setTipoTitulo(tipoTitulo);
	 * 
	 * }
	 * 
	 * if (dto.getTipoUsoDestinoCodigo() != null) {
	 * 
	 * DDTipoUsoDestino tipoUsoDestino = (DDTipoUsoDestino) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoUsoDestino.
	 * class, dto.getTipoUsoDestinoCodigo());
	 * 
	 * activo.setTipoUsoDestino(tipoUsoDestino);
	 * 
	 * }
	 * 
	 * if (dto.getEstadoActivoCodigo() != null) {
	 * 
	 * DDEstadoActivo estadoActivo = (DDEstadoActivo) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoActivo.
	 * class, dto.getEstadoActivoCodigo());
	 * 
	 * activo.setEstadoActivo(estadoActivo);
	 * 
	 * }
	 * 
	 * 
	 * 
	 * } catch (IllegalAccessException e) { e.printStackTrace(); } catch
	 * (InvocationTargetException e) { e.printStackTrace(); }
	 * 
	 * 
	 * activoApi.saveOrUpdate(activo);
	 * 
	 * 
	 * return true;
	 * 
	 * }
	 */

	/********************************************************
	 * NOTA FASE II: Refactorizado en this.saveTabActivo
	 ********************************************************/
	/*
	 * saveActivoInformacionAdministrativa
	 * 
	 * @Transactional(readOnly = false) public boolean
	 * saveActivoInformacionAdministrativa(DtoActivoInformacionAdministrativa
	 * activoDto, Long id) {
	 * 
	 * Activo activo = activoApi.get(id);
	 * 
	 * try {
	 * 
	 * if (activo.getInfoAdministrativa() == null) {
	 * activo.setInfoAdministrativa(new ActivoInfAdministrativa());
	 * activo.getInfoAdministrativa().setActivo(activo); }
	 * 
	 * beanUtilNotNull.copyProperties(activo.getInfoAdministrativa(),
	 * activoDto);
	 * 
	 * activo.setInfoAdministrativa(genericDao.save(ActivoInfAdministrativa.
	 * class, activo.getInfoAdministrativa()));
	 * 
	 * if (activoDto.getTipoVpoCodigo() != null) {
	 * 
	 * DDTipoVpo tipoVpo = (DDTipoVpo) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoVpo.class,
	 * activoDto.getTipoVpoCodigo());
	 * 
	 * activo.getInfoAdministrativa().setTipoVpo(tipoVpo);
	 * 
	 * }
	 * 
	 * 
	 * } catch (IllegalAccessException e) { e.printStackTrace(); } catch
	 * (InvocationTargetException e) { e.printStackTrace(); }
	 * 
	 * activoApi.saveOrUpdate(activo);
	 * 
	 * return true;
	 * 
	 * }
	 */

	/********************************************************
	 * NOTA FASE II: Refactorizado en this.saveTabActivo
	 ********************************************************/
	/*
	 * saveActivoInformacionComercial
	 * 
	 * @Transactional(readOnly = false) public boolean
	 * saveActivoInformacionComercial(DtoActivoInformacionComercial activoDto,
	 * Long id) {
	 * 
	 * Activo activo = activoApi.get(id);
	 * 
	 * try {
	 * 
	 * if (activo.getInfoComercial() == null) { activo.setInfoComercial(new
	 * ActivoInfoComercial()); activo.getInfoComercial().setActivo(activo); }
	 * 
	 * beanUtilNotNull.copyProperties(activo.getInfoComercial(), activoDto);
	 * 
	 * activo.setInfoComercial(genericDao.save(ActivoInfoComercial.class,
	 * activo.getInfoComercial()));
	 * 
	 * if (activoDto.getUbicacionActivoCodigo() != null) { DDUbicacionActivo
	 * ubicacionActivo = (DDUbicacionActivo) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDUbicacionActivo.
	 * class, activoDto.getUbicacionActivoCodigo());
	 * activo.getInfoComercial().setUbicacionActivo(ubicacionActivo); } if
	 * (activoDto.getEstadoConstruccionCodigo() != null) { DDEstadoConstruccion
	 * estadoConstruccion = (DDEstadoConstruccion) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoConstruccion
	 * .class, activoDto.getEstadoConstruccionCodigo());
	 * activo.getInfoComercial().setEstadoConstruccion(estadoConstruccion); } if
	 * (activoDto.getEstadoConservacionCodigo() != null) { DDEstadoConservacion
	 * estadoConservacion = (DDEstadoConservacion) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoConservacion
	 * .class, activoDto.getEstadoConservacionCodigo());
	 * activo.getInfoComercial().setEstadoConservacion(estadoConservacion); }
	 * 
	 * if (activo.getInfoComercial().getEdificio() == null) {
	 * activo.getInfoComercial().setEdificio(new ActivoEdificio()); }
	 * 
	 * beanUtilNotNull.copyProperties(activo.getInfoComercial().getEdificio(),
	 * activoDto);
	 * activo.getInfoComercial().getEdificio().setInfoComercial(activo.
	 * getInfoComercial());
	 * activo.getInfoComercial().setEdificio(genericDao.save(ActivoEdificio.
	 * class, activo.getInfoComercial().getEdificio()));
	 * 
	 * if (activoDto.getEstadoConservacionEdificioCodigo() != null) {
	 * 
	 * DDEstadoConservacion estadoConservacionEdificio = (DDEstadoConservacion)
	 * proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoConservacion
	 * .class, activoDto.getEstadoConservacionEdificioCodigo());
	 * 
	 * activo.getInfoComercial().getEdificio().setEstadoConservacionEdificio(
	 * estadoConservacionEdificio);
	 * 
	 * }
	 * 
	 * if (activoDto.getTipoFachadaCodigo() != null) {
	 * 
	 * DDTipoFachada tipoFachada = (DDTipoFachada) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoFachada.class,
	 * activoDto.getTipoFachadaCodigo());
	 * 
	 * activo.getInfoComercial().getEdificio().setTipoFachada(tipoFachada);
	 * 
	 * }
	 * 
	 * if (activo.getInfoComercial() instanceof ActivoVivienda) { if
	 * (activoDto.getTipoViviendaCodigo() != null) { DDTipoVivienda tipoVivienda
	 * = (DDTipoVivienda) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoVivienda.
	 * class, activoDto.getTipoViviendaCodigo());
	 * 
	 * ActivoVivienda vivienda = (ActivoVivienda) activo.getInfoComercial();
	 * vivienda.setTipoVivienda(tipoVivienda); } if
	 * (activoDto.getTipoRentaCodigo() != null) { DDTipoRenta tipoRenta =
	 * (DDTipoRenta) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoRenta.class,
	 * activoDto.getTipoRentaCodigo());
	 * 
	 * ActivoVivienda vivienda = (ActivoVivienda) activo.getInfoComercial();
	 * vivienda.setTipoRenta(tipoRenta); } if
	 * (activoDto.getTipoOrientacionCodigo() != null) { DDTipoOrientacion
	 * tipoOrientacion = (DDTipoOrientacion) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoOrientacion.
	 * class, activoDto.getTipoOrientacionCodigo());
	 * 
	 * ActivoVivienda vivienda = (ActivoVivienda) activo.getInfoComercial();
	 * vivienda.setTipoOrientacion(tipoOrientacion); }
	 * 
	 * } else if (activo.getInfoComercial() instanceof ActivoPlazaAparcamiento)
	 * { ActivoPlazaAparcamiento plazaAparcamiento = (ActivoPlazaAparcamiento)
	 * activo.getInfoComercial();
	 * 
	 * if (activoDto.getUbicacionAparcamientoCodigo() != null) {
	 * DDTipoUbicaAparcamiento ubicacionAparcamiento = (DDTipoUbicaAparcamiento)
	 * proxyFactory.proxy (UtilDiccionarioApi.class).dameValorDiccionarioByCod(
	 * DDTipoUbicaAparcamiento.class,
	 * activoDto.getUbicacionAparcamientoCodigo());
	 * 
	 * plazaAparcamiento.setUbicacionAparcamiento(ubicacionAparcamiento);
	 * 
	 * } if (activoDto.getTipoCalidadCodigo() != null) { DDTipoCalidad
	 * tipoCalidad = (DDTipoCalidad) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoCalidad.class,
	 * activoDto.getTipoRentaCodigo());
	 * 
	 * plazaAparcamiento.setTipoCalidad(tipoCalidad); }
	 * 
	 * activo.setInfoComercial(plazaAparcamiento);
	 * 
	 * } //No hace falta if para ActivoLocalComercial porque tiene diccionarios
	 * 
	 * } catch (IllegalAccessException e) { e.printStackTrace(); } catch
	 * (InvocationTargetException e) { e.printStackTrace(); }
	 * 
	 * activoApi.saveOrUpdate(activo);
	 * 
	 * return true;
	 * 
	 * }
	 */

	/********************************************************
	 * NOTA FASE II: Refactorizado en this.saveTabActivo
	 ********************************************************/
	/*
	 * saveValoresPreciosActivo
	 * 
	 * @Transactional(readOnly = false) public boolean
	 * saveValoresPreciosActivo(DtoActivoValoraciones valoracionesDto, Long id)
	 * {
	 * 
	 * Activo activo = activoApi.get(id); if (valoracionesDto.getBloqueoPrecio()
	 * != null) { if (valoracionesDto.getBloqueoPrecio() > 0) {
	 * activo.setBloqueoPrecioFechaIni(new Date()); Usuario usuarioLogado =
	 * genericAdapter.getUsuarioLogado();
	 * activo.setGestorBloqueoPrecio(usuarioLogado); } else {
	 * activo.setBloqueoPrecioFechaIni(null);
	 * activo.setGestorBloqueoPrecio(null); } }
	 * 
	 * 
	 * activoApi.saveOrUpdate(activo);
	 * 
	 * 
	 * return true;
	 * 
	 * }
	 */

	/********************************************************
	 * NOTA FASE II: Refactorizado en this.saveTabActivo
	 ********************************************************/
	/*
	 * saveActivoSituacionPosesoria
	 * 
	 * @Transactional(readOnly = false) public boolean
	 * saveActivoSituacionPosesoria(DtoActivoSituacionPosesoria activoDto, Long
	 * id) {
	 * 
	 * Activo activo = activoApi.get(id);
	 * 
	 * try {
	 * 
	 * if (activo.getSituacionPosesoria() == null) {
	 * 
	 * activo.setSituacionPosesoria(new ActivoSituacionPosesoria());
	 * activo.getSituacionPosesoria().setActivo(activo);
	 * 
	 * }
	 * 
	 * if(!Checks.esNulo(activoDto.getOcupado()) &&
	 * !BooleanUtils.toBoolean(activoDto.getOcupado())) {
	 * activoDto.setConTitulo(null); }
	 * 
	 * beanUtilNotNull.copyProperties(activo.getSituacionPosesoria(),
	 * activoDto);
	 * 
	 * activo.setSituacionPosesoria(genericDao.save(ActivoSituacionPosesoria.
	 * class, activo.getSituacionPosesoria()));
	 * 
	 * if (activoDto.getTipoTituloPosesorioCodigo() != null) {
	 * 
	 * DDTipoTituloPosesorio tipoTitulo = (DDTipoTituloPosesorio)
	 * proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionario(DDTipoTituloPosesorio.
	 * class, new Long(activoDto.getTipoTituloPosesorioCodigo()));
	 * 
	 * activo.getSituacionPosesoria().setTipoTituloPosesorio(tipoTitulo);
	 * 
	 * }
	 * 
	 * if (activoDto.getNecesarias()!=null) {
	 * activo.setLlavesNecesarias(activoDto.getNecesarias()); } if
	 * (activoDto.getLlaveHre()!=null) {
	 * activo.setLlavesHre(activoDto.getLlaveHre()); }
	 * 
	 * if (activoDto.getFechaRecepcionLlave()!=null) {
	 * activo.setFechaRecepcionLlaves(activoDto.getFechaRecepcionLlave()); } if
	 * (activoDto.getNumJuegos()!=null) {
	 * activo.setNumJuegosLlaves(Integer.valueOf(activoDto.getNumJuegos())); }
	 * 
	 * } catch (IllegalAccessException e) { e.printStackTrace(); } catch
	 * (InvocationTargetException e) { e.printStackTrace(); }
	 * 
	 * activoApi.saveOrUpdate(activo);
	 * 
	 * 
	 * return true;
	 * 
	 * }
	 */

	/********************************************************
	 * NOTA FASE II: Refactorizado en this.saveTabActivo
	 ********************************************************/
	/*
	 * saveActivoDatosRegistrales
	 * 
	 * @Transactional(readOnly = false) public boolean
	 * saveActivoDatosRegistrales(DtoActivoDatosRegistrales activoDto, Long id)
	 * {
	 * 
	 * Activo activo = activoApi.get(id);
	 * 
	 * try {
	 * 
	 * if (activo.getInfoRegistral() == null) { activo.setInfoRegistral(new
	 * ActivoInfoRegistral()); activo.getInfoRegistral().setActivo(activo);
	 * 
	 * }
	 * 
	 * if (activo.getInfoRegistral().getInfoRegistralBien() == null) {
	 * activo.getInfoRegistral().setInfoRegistralBien(new
	 * NMBInformacionRegistralBien());
	 * activo.getInfoRegistral().getInfoRegistralBien().setBien(activo.getBien()
	 * ); }
	 * 
	 * beanUtilNotNull.copyProperties(activo, activoDto);
	 * //beanUtilNotNull.copyProperties(activo.getInfoAdministrativa(),
	 * activoDto); beanUtilNotNull.copyProperties(activo.getInfoRegistral(),
	 * activoDto); beanUtilNotNull.copyProperties(activo.getInfoRegistral().
	 * getInfoRegistralBien(), activoDto);
	 * 
	 * if (activo.getTitulo() == null) { activo.setTitulo(new ActivoTitulo());
	 * activo.getTitulo().setActivo(activo); }
	 * 
	 * if (activoDto.getEstadoTitulo() != null) {
	 * 
	 * DDEstadoTitulo estadoTituloNuevo = (DDEstadoTitulo) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoTitulo.
	 * class, activoDto.getEstadoTitulo());
	 * 
	 * activo.getTitulo().setEstado(estadoTituloNuevo);
	 * 
	 * }
	 * 
	 * 
	 * // beanUtilNotNull.copyProperties(activo.getTitulo(), activoDto); //
	 * activo.setTitulo((genericDao.save(ActivoTitulo.class,
	 * activo.getTitulo()))); // // if
	 * (activo.getInfoRegistral().getEstadoDivHorizontal() == null) { //
	 * activo.getInfoRegistral().setEstadoDivHorizontal(new
	 * DDEstadoDivHorizontal()); // } // // if
	 * (activo.getInfoRegistral().getEstadoObraNueva() == null) { //
	 * activo.getInfoRegistral().setEstadoObraNueva(new DDEstadoObraNueva()); //
	 * } // // if (activo.getInfoRegistral().getLocalidadAnterior() == null) {
	 * // activo.getInfoRegistral().setLocalidadAnterior(new Localidad()); // }
	 * 
	 * 
	 * if (activo.getDivHorizontal() != 0) {
	 * 
	 * DDEstadoDivHorizontal estadoDivHorizontal = null;
	 * 
	 * if (activoDto.getEstadoDivHorizontalCodigo() != null) {
	 * 
	 * estadoDivHorizontal = (DDEstadoDivHorizontal) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(
	 * DDEstadoDivHorizontal.class, activoDto.getEstadoDivHorizontalCodigo()); }
	 * 
	 * activo.getInfoRegistral().setEstadoDivHorizontal(estadoDivHorizontal);
	 * 
	 * } else { activo.getInfoRegistral().setEstadoDivHorizontal(null);
	 * activo.getInfoRegistral().setDivHorInscrito(null); }
	 * 
	 * activo.getInfoRegistral().setInfoRegistralBien((genericDao.save(
	 * NMBInformacionRegistralBien.class,
	 * activo.getInfoRegistral().getInfoRegistralBien())));
	 * activo.setInfoRegistral((genericDao.save(ActivoInfoRegistral.class,
	 * activo.getInfoRegistral())));
	 * 
	 * if (activoDto.getEstadoObraNuevaCodigo() != null) {
	 * 
	 * DDEstadoObraNueva estadoObraNueva = (DDEstadoObraNueva)
	 * proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoObraNueva.
	 * class, activoDto.getEstadoObraNuevaCodigo());
	 * 
	 * activo.getInfoRegistral().setEstadoObraNueva(estadoObraNueva);
	 * 
	 * }
	 * 
	 * if (activoDto.getLocalidadAnteriorCodigo() != null) {
	 * 
	 * Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
	 * activoDto.getLocalidadAnteriorCodigo()); Localidad municipioNuevo =
	 * (Localidad) genericDao.get(Localidad.class, filtro);
	 * activo.getInfoRegistral().setLocalidadAnterior(municipioNuevo);
	 * 
	 * }
	 * 
	 * if (activoDto.getPoblacionRegistro() != null) {
	 * 
	 * Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
	 * activoDto.getPoblacionRegistro()); Localidad municipioNuevo = (Localidad)
	 * genericDao.get(Localidad.class, filtro);
	 * activo.getInfoRegistral().getInfoRegistralBien().setLocalidad(
	 * municipioNuevo);
	 * 
	 * }
	 * 
	 * if (activoDto.getPoblacionRegistro() != null) {
	 * 
	 * Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
	 * activoDto.getPoblacionRegistro()); Localidad municipioNuevo = (Localidad)
	 * genericDao.get(Localidad.class, filtro);
	 * activo.getInfoRegistral().getInfoRegistralBien().setLocalidad(
	 * municipioNuevo);
	 * activo.getInfoRegistral().getInfoRegistralBien().setProvincia(
	 * municipioNuevo.getProvincia());
	 * 
	 * }
	 * 
	 * activo.getInfoRegistral().setInfoRegistralBien((genericDao.save(
	 * NMBInformacionRegistralBien.class,
	 * activo.getInfoRegistral().getInfoRegistralBien())));
	 * activo.setInfoRegistral((genericDao.save(ActivoInfoRegistral.class,
	 * activo.getInfoRegistral())));
	 * 
	 * 
	 * if (activoDto.getTipoTituloCodigo() != null) {
	 * 
	 * DDTipoTituloActivo tipoTitulo = (DDTipoTituloActivo) proxyFactory.proxy
	 * (UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoTituloActivo.
	 * class, activoDto.getTipoTituloCodigo());
	 * 
	 * activo.setTipoTitulo(tipoTitulo);
	 * 
	 * }
	 * 
	 * if (activoDto.getSubtipoTituloCodigo() != null) {
	 * 
	 * DDSubtipoTituloActivo subtipoTitulo = (DDSubtipoTituloActivo)
	 * proxyFactory.proxy (UtilDiccionarioApi.class).dameValorDiccionarioByCod(
	 * DDSubtipoTituloActivo.class, activoDto.getSubtipoTituloCodigo());
	 * 
	 * activo.setSubtipoTitulo(subtipoTitulo);
	 * 
	 * }
	 * 
	 * if (activo.getTipoTitulo() != null) {
	 * 
	 * if (activo.getTipoTitulo().getCodigo().equals(DDTipoTituloActivo.
	 * tipoTituloNoJudicial)) {
	 * 
	 * if (activo.getAdjNoJudicial() == null) { activo.setAdjNoJudicial(new
	 * ActivoAdjudicacionNoJudicial());
	 * activo.getAdjNoJudicial().setActivo(activo); }
	 * beanUtilNotNull.copyProperties(activo.getAdjNoJudicial(), activoDto);
	 * 
	 * activo.setAdjNoJudicial((genericDao.save(ActivoAdjudicacionNoJudicial.
	 * class, activo.getAdjNoJudicial())));
	 * 
	 * } else if (activo.getTipoTitulo().getCodigo().equals(DDTipoTituloActivo.
	 * tipoTituloPDV)) {
	 * 
	 * if (activo.getPdv() == null) { activo.setPdv(new ActivoPlanDinVentas());
	 * activo.getPdv().setActivo(activo); }
	 * beanUtilNotNull.copyProperties(activo.getPdv(), activoDto);
	 * 
	 * activo.setPdv((genericDao.save(ActivoPlanDinVentas.class,
	 * activo.getPdv())));
	 * 
	 * } else if (activo.getTipoTitulo().getCodigo().equals(DDTipoTituloActivo.
	 * tipoTituloJudicial)) {
	 * 
	 * if (activo.getAdjJudicial() == null) { activo.setAdjJudicial(new
	 * ActivoAdjudicacionJudicial()); activo.getAdjJudicial().setActivo(activo);
	 * } beanUtilNotNull.copyProperties(activo.getAdjJudicial(), activoDto);
	 * 
	 * 
	 * if (activo.getAdjJudicial().getAdjudicacionBien() == null) {
	 * activo.getAdjJudicial().setAdjudicacionBien(new NMBAdjudicacionBien());
	 * activo.getAdjJudicial().getAdjudicacionBien().setBien(activo.getBien());
	 * }
	 * 
	 * beanUtilNotNull.copyProperties(activo.getAdjJudicial().
	 * getAdjudicacionBien(), activoDto);
	 * 
	 * activo.getAdjJudicial().setAdjudicacionBien((genericDao.save(
	 * NMBAdjudicacionBien.class,
	 * activo.getAdjJudicial().getAdjudicacionBien())));
	 * 
	 * 
	 * 
	 * if (activoDto.getEntidadAdjudicatariaCodigo() != null) {
	 * 
	 * Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
	 * activoDto.getEntidadAdjudicatariaCodigo()); DDEntidadAdjudicataria
	 * entidadAdjudicataria = (DDEntidadAdjudicataria)
	 * genericDao.get(DDEntidadAdjudicataria.class, filtro);
	 * 
	 * activo.getAdjJudicial().getAdjudicacionBien().setEntidadAdjudicataria(
	 * entidadAdjudicataria);
	 * 
	 * }
	 * 
	 * if (activoDto.getEntidadEjecutanteCodigo() != null) {
	 * 
	 * Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
	 * activoDto.getEntidadEjecutanteCodigo()); DDEntidadEjecutante
	 * entidadEjecutante = (DDEntidadEjecutante)
	 * genericDao.get(DDEntidadEjecutante.class, filtro);
	 * 
	 * activo.getAdjJudicial().setEntidadEjecutante(entidadEjecutante);
	 * 
	 * }
	 * 
	 * if (activoDto.getTipoJuzgadoCodigo() != null) {
	 * 
	 * Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
	 * activoDto.getTipoJuzgadoCodigo()); TipoJuzgado juzgado = (TipoJuzgado)
	 * genericDao.get(TipoJuzgado.class, filtro);
	 * 
	 * activo.getAdjJudicial().setJuzgado(juzgado); }
	 * 
	 * if (activoDto.getTipoPlazaCodigo() != null) {
	 * 
	 * Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
	 * activoDto.getTipoPlazaCodigo()); TipoPlaza plazaJuzgado = (TipoPlaza)
	 * genericDao.get(TipoPlaza.class, filtro);
	 * 
	 * activo.getAdjJudicial().setPlazaJuzgado(plazaJuzgado); }
	 * 
	 * if (activoDto.getEstadoAdjudicacionCodigo() != null) {
	 * 
	 * Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
	 * activoDto.getEstadoAdjudicacionCodigo()); DDEstadoAdjudicacion
	 * estadoAdjudicacion = (DDEstadoAdjudicacion)
	 * genericDao.get(DDEstadoAdjudicacion.class, filtro);
	 * 
	 * activo.getAdjJudicial().setEstadoAdjudicacion(estadoAdjudicacion); }
	 * 
	 * activo.getAdjJudicial().setAdjudicacionBien((genericDao.save(
	 * NMBAdjudicacionBien.class,
	 * activo.getAdjJudicial().getAdjudicacionBien())));
	 * activo.setAdjJudicial((genericDao.save(ActivoAdjudicacionJudicial.class,
	 * activo.getAdjJudicial())));
	 * 
	 * }
	 * 
	 * }
	 * 
	 * activoApi.saveOrUpdate(activo);
	 * 
	 * } catch (IllegalAccessException e) { e.printStackTrace(); } catch
	 * (InvocationTargetException e) { e.printStackTrace(); } catch (Exception
	 * e) { e.printStackTrace(); }
	 * 
	 * return true;
	 * 
	 * }
	 * 
	 */
	

	@Transactional(readOnly = false)
	public boolean saveDistribucion(DtoDistribucion dtoDistribucion, Long idDistribucion) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idDistribucion);
		ActivoDistribucion activoDistribucion = genericDao.get(ActivoDistribucion.class, filtro);

		try {

			beanUtilNotNull.copyProperties(activoDistribucion, dtoDistribucion);
			if (dtoDistribucion.getTipoHabitaculoCodigo() != null) {
				DDTipoHabitaculo tipoHabitaculo = (DDTipoHabitaculo) proxyFactory.proxy(UtilDiccionarioApi.class)
						.dameValorDiccionarioByCod(DDTipoHabitaculo.class, dtoDistribucion.getTipoHabitaculoCodigo());

				activoDistribucion.setTipoHabitaculo(tipoHabitaculo);
			}
			genericDao.save(ActivoDistribucion.class, activoDistribucion);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean saveCatastro(DtoActivoCatastro dtoCatastro, Long idCatastro) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idCatastro);
		ActivoCatastro activoCatastro = genericDao.get(ActivoCatastro.class, filtro);

		try {

			beanUtilNotNull.copyProperties(activoCatastro, dtoCatastro);
			genericDao.save(ActivoCatastro.class, activoCatastro);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean saveFoto(DtoFoto dtoFoto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoFoto.getId());
		ActivoFoto activoFoto = genericDao.get(ActivoFoto.class, filtro);
		boolean resultado = true;
		try {

			if (gestorDocumentalFotos.isActive()) {
				PRINCIPAL principal = null;
				SITUACION situacion = null;
				if (dtoFoto.getPrincipal() != null) {
					if (dtoFoto.getPrincipal()) {
						principal = PRINCIPAL.SI;
					} else {
						principal = PRINCIPAL.NO;
					}
				}
				if (dtoFoto.getInteriorExterior() != null) {
					if (dtoFoto.getInteriorExterior()) {
						situacion = SITUACION.INTERIOR;
					} else {
						situacion = SITUACION.EXTERIOR;
					}
				}
				FileResponse fileReponse = gestorDocumentalFotos.update(activoFoto.getRemoteId(), dtoFoto.getNombre(),
						null, dtoFoto.getDescripcion(), principal, situacion, dtoFoto.getOrden());
				if (fileReponse.getError() != null && !fileReponse.getError().isEmpty()) {
					throw new Exception(fileReponse.getError());
				}
			}
			beanUtilNotNull.copyProperties(activoFoto, dtoFoto);
			genericDao.save(ActivoFoto.class, activoFoto);

		} catch (Exception e) {
			logger.error(e);
			resultado = false;
		}

		return resultado;

	}

	@Transactional(readOnly = false)
	public boolean saveOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, Long idActivoOcupanteLegal) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idActivoOcupanteLegal);
		ActivoOcupanteLegal activoOcupanteLegal = genericDao.get(ActivoOcupanteLegal.class, filtro);

		try {

			beanUtilNotNull.copyProperties(activoOcupanteLegal, dtoOcupanteLegal);
			genericDao.save(ActivoOcupanteLegal.class, activoOcupanteLegal);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean deleteDistribucion(DtoDistribucion dtoDistribucion, Long idDistribucion) {

		try {
			genericDao.deleteById(ActivoDistribucion.class, idDistribucion);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteCatastro(DtoActivoCatastro dtoCatastro, Long idCatastro) {

		try {
			genericDao.deleteById(ActivoCatastro.class, idCatastro);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, Long idActivoOcupanteLegal) {

		try {
			genericDao.deleteById(ActivoOcupanteLegal.class, idActivoOcupanteLegal);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteObservacion(Long idObservacion) {

		try {

			genericDao.deleteById(ActivoObservacion.class, idObservacion);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean saveObservacionesActivo(DtoObservacion dtoObservacion) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoObservacion.getId()));
		ActivoObservacion activoObservacion = genericDao.get(ActivoObservacion.class, filtro);

		try {

			beanUtilNotNull.copyProperties(activoObservacion, dtoObservacion);
			genericDao.save(ActivoObservacion.class, activoObservacion);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean createObservacionesActivo(DtoObservacion dtoObservacion, Long idActivo) {

		ActivoObservacion activoObservacion = new ActivoObservacion();
		Activo activo = activoApi.get(idActivo);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		try {

			// beanUtilNotNull.copyProperties(activoObservacion,
			// dtoObservacion);
			activoObservacion.setObservacion(dtoObservacion.getObservacion());
			activoObservacion.setFecha(new Date());
			activoObservacion.setUsuario(usuarioLogado);
			activoObservacion.setActivo(activo);

			ActivoObservacion observacionNueva = genericDao.save(ActivoObservacion.class, activoObservacion);

			activo.getObservacion().add(observacionNueva);
			activoApi.saveOrUpdate(activo);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean createCondicionHistorico(DtoCondicionHistorico dtoCondicionHistorico, Long idActivo) {

		ActivoCondicionEspecifica activoCondicionEspecifica = new ActivoCondicionEspecifica();
		Activo activo = activoApi.get(idActivo);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		try {
			activoCondicionEspecifica.setFechaDesde(dtoCondicionHistorico.getFechaAlta());
			activoCondicionEspecifica.setUsuarioAlta(usuarioLogado);
			activoCondicionEspecifica.setTexto(dtoCondicionHistorico.getCondicion());
			activoCondicionEspecifica.setActivo(activo);

			genericDao.save(ActivoCondicionEspecifica.class, activoCondicionEspecifica);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createDistribucion(DtoDistribucion dtoDistribucion, Long idActivo) {

		ActivoDistribucion activoDistribucion = new ActivoDistribucion();
		Activo activo = activoApi.get(idActivo);
		ActivoInfoComercial infoComercial = activo.getInfoComercial();

		try {

			beanUtilNotNull.copyProperties(activoDistribucion, dtoDistribucion);
			if (dtoDistribucion.getTipoHabitaculoCodigo() != null) {
				DDTipoHabitaculo tipoHabitaculo = (DDTipoHabitaculo) proxyFactory.proxy(UtilDiccionarioApi.class)
						.dameValorDiccionarioByCod(DDTipoHabitaculo.class, dtoDistribucion.getTipoHabitaculoCodigo());

				activoDistribucion.setTipoHabitaculo(tipoHabitaculo);
			}
			activoDistribucion.setInfoComercial(infoComercial);
			ActivoDistribucion distribucionNueva = genericDao.save(ActivoDistribucion.class, activoDistribucion);

			ActivoVivienda viviendaTemp = (ActivoVivienda) activo.getInfoComercial();
			viviendaTemp.getDistribucion().add(distribucionNueva);
			activo.setInfoComercial(viviendaTemp);
			activoApi.saveOrUpdate(activo);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean createCatastro(DtoActivoCatastro dtoCatastro, Long idActivo) {

		ActivoCatastro activoCatastro = new ActivoCatastro();
		Activo activo = activoApi.get(idActivo);
		try {

			beanUtilNotNull.copyProperties(activoCatastro, dtoCatastro);
			activoCatastro.setActivo(activo);
			ActivoCatastro catastroNuevo = genericDao.save(ActivoCatastro.class, activoCatastro);

			activo.getCatastro().add(catastroNuevo);
			activoApi.saveOrUpdate(activo);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean createOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, Long idActivo) {

		ActivoOcupanteLegal activoOcupanteLegal = new ActivoOcupanteLegal();
		Activo activo = activoApi.get(idActivo);
		ActivoSituacionPosesoria situacionPosesoria = activo.getSituacionPosesoria();
		try {

			beanUtilNotNull.copyProperties(activoOcupanteLegal, dtoOcupanteLegal);
			activoOcupanteLegal.setSituacionPosesoria(situacionPosesoria);
			ActivoOcupanteLegal ocupanteLegalNuevo = genericDao.save(ActivoOcupanteLegal.class, activoOcupanteLegal);

			situacionPosesoria.getActivoOcupanteLegal().add(ocupanteLegalNuevo);
			activo.setSituacionPosesoria(situacionPosesoria);
			activoApi.saveOrUpdate(activo);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return true;

	}

	public List<DtoActivoCargas> getListCargasById(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoActivoCargas> listaDtoCarga = new ArrayList<DtoActivoCargas>();

		if (activo.getCargas() != null) {

			for (int i = 0; i < activo.getCargas().size(); i++) {
				DtoActivoCargas cargaDto = new DtoActivoCargas();
				try {
					ActivoCargas activoCarga = activo.getCargas().get(i);
					beanUtilNotNull.copyProperties(cargaDto, activoCarga);
					beanUtilNotNull.copyProperties(cargaDto, activoCarga.getCargaBien());
					beanUtilNotNull.copyProperty(cargaDto, "idActivoCarga", activoCarga.getId());
					
					if (activoCarga.getTipoCargaActivo() != null) {
						beanUtilNotNull.copyProperty(cargaDto, "tipoCargaDescripcion",activoCarga.getTipoCargaActivo().getDescripcion());
						beanUtilNotNull.copyProperty(cargaDto, "tipoCargaCodigo",activoCarga.getTipoCargaActivo().getCodigo());
					}
					if (activoCarga.getSubtipoCarga() != null) {
						beanUtilNotNull.copyProperty(cargaDto, "subtipoCargaDescripcion",activoCarga.getSubtipoCarga().getDescripcion());
						beanUtilNotNull.copyProperty(cargaDto, "subtipoCargaCodigo",activoCarga.getSubtipoCarga().getCodigo());
					}
					if (activoCarga.getCargaBien().getSituacionCarga() != null) {
						beanUtilNotNull.copyProperty(cargaDto, "estadoDescripcion",activoCarga.getCargaBien().getSituacionCarga().getDescripcion());
						beanUtilNotNull.copyProperty(cargaDto, "estadoCodigo",activoCarga.getCargaBien().getSituacionCarga().getCodigo());
					}
					if (activoCarga.getCargaBien().getSituacionCargaEconomica() != null){
						beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaDescripcion",activoCarga.getCargaBien().getSituacionCargaEconomica().getDescripcion());
						beanUtilNotNull.copyProperty(cargaDto, "estadoEconomicaCodigo",activoCarga.getCargaBien().getSituacionCargaEconomica().getCodigo());
					}

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoCarga.add(cargaDto);
			}
		}

		return listaDtoCarga;

	}
	
	public DtoActivoCargas getCargaById(Long id) {

		DtoActivoCargas dtoCarga = new DtoActivoCargas();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoCargas cargaSeleccionada = (ActivoCargas) genericDao.get(ActivoCargas.class, filtro);

		try {

			beanUtilNotNull.copyProperties(dtoCarga, cargaSeleccionada);
			beanUtilNotNull.copyProperties(dtoCarga, cargaSeleccionada.getCargaBien());

			if (cargaSeleccionada.getTipoCargaActivo() != null) {
				beanUtilNotNull.copyProperty(dtoCarga, "tipoCargaCodigo", cargaSeleccionada.getTipoCargaActivo().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "tipoCargaDesc",
						cargaSeleccionada.getTipoCargaActivo().getDescripcion());
				beanUtilNotNull.copyProperty(dtoCarga, "tipoCargaCodigoEconomica",
						cargaSeleccionada.getTipoCargaActivo().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "tipoCargaDescEconomica",
						cargaSeleccionada.getTipoCargaActivo().getDescripcion());
			}

			if (cargaSeleccionada.getSubtipoCarga() != null) {
				beanUtilNotNull.copyProperty(dtoCarga, "subtipoCargaCodigo", cargaSeleccionada.getSubtipoCarga().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "subtipoCargaDesc",
						cargaSeleccionada.getSubtipoCarga().getDescripcion());
				beanUtilNotNull.copyProperty(dtoCarga, "subtipoCargaCodigoEconomica",
						cargaSeleccionada.getSubtipoCarga().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "subtipoCargaDescEconomica",
						cargaSeleccionada.getSubtipoCarga().getDescripcion());
			}

			if (cargaSeleccionada.getCargaBien().getSituacionCarga() != null) {
				beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigo",
						cargaSeleccionada.getCargaBien().getSituacionCarga().getCodigo());
				beanUtilNotNull.copyProperty(dtoCarga, "situacionCargaCodigoEconomica",
						cargaSeleccionada.getCargaBien().getSituacionCarga().getCodigo());
			}

			beanUtilNotNull.copyProperty(dtoCarga, "titularEconomica", cargaSeleccionada.getCargaBien().getTitular());
			beanUtilNotNull.copyProperty(dtoCarga, "importeEconomicoEconomica",
					cargaSeleccionada.getCargaBien().getImporteEconomico());
			beanUtilNotNull.copyProperty(dtoCarga, "fechaCancelacionEconomica",
					cargaSeleccionada.getCargaBien().getFechaCancelacion());
			beanUtilNotNull.copyProperty(dtoCarga, "descripcionCargaEconomica", cargaSeleccionada.getDescripcionCarga());

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return dtoCarga;

	}

	public List<DtoDistribucion> getListDistribucionesById(Long id) {
		Activo activo = activoApi.get(id);
		List<DtoDistribucion> listaDtoDistribucion = new ArrayList<DtoDistribucion>();

		// if (activo.getInfoComercial() instanceof ActivoVivienda) {
		ActivoInfoComercial infoComercial = (ActivoInfoComercial) activo.getInfoComercial();

		if (infoComercial.getDistribucion() != null) {
			for (int i = 0; i < infoComercial.getDistribucion().size(); i++) {
				DtoDistribucion distribucionDto = new DtoDistribucion();
				try {
					ActivoDistribucion distribucion = infoComercial.getDistribucion().get(i);
					BeanUtils.copyProperties(distribucionDto, distribucion);
					BeanUtils.copyProperty(distribucionDto, "idDistribucion", distribucion.getId());
					if (distribucion.getTipoHabitaculo() != null) {
						distribucionDto.setTipoHabitaculoCodigo(distribucion.getTipoHabitaculo().getCodigo());
						distribucionDto.setTipoHabitaculoDescripcion(distribucion.getTipoHabitaculo().getDescripcion());
					}
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoDistribucion.add(distribucionDto);
			}
		}
		// }

		return listaDtoDistribucion;
	}

	public List<DtoObservacion> getListObservacionesById(Long id) {

		Activo activo = activoApi.get(id);
		// DtoCarga cargaDto = new ArrayList<DtoCarga>();
		List<DtoObservacion> listaDtoObservaciones = new ArrayList<DtoObservacion>();

		if (activo.getObservacion() != null) {

			for (int i = 0; i < activo.getObservacion().size(); i++) {

				DtoObservacion observacionDto = new DtoObservacion();

				try {

					BeanUtils.copyProperties(observacionDto, activo.getObservacion().get(i));

					if (activo.getObservacion().get(i).getUsuario() != null) {
						String nombreCompleto = activo.getObservacion().get(i).getUsuario().getNombre();
						Long idUsuario = activo.getObservacion().get(i).getUsuario().getId();
						if (activo.getObservacion().get(i).getUsuario().getApellido1() != null) {

							nombreCompleto += activo.getObservacion().get(i).getUsuario().getApellido1();

							if (activo.getObservacion().get(i).getUsuario().getApellido2() != null) {
								nombreCompleto += activo.getObservacion().get(i).getUsuario().getApellido2();
							}

						}

						BeanUtils.copyProperty(observacionDto, "nombreCompleto", nombreCompleto);
						BeanUtils.copyProperty(observacionDto, "idUsuario", idUsuario);
					}

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoObservaciones.add(observacionDto);
			}
		}

		return listaDtoObservaciones;

	}

	public List<DtoAgrupacionesActivo> getListAgrupacionesActivoById(Long id) {

		Activo activo = activoApi.get(id);

		List<DtoAgrupacionesActivo> listaDtoAgrupaciones = new ArrayList<DtoAgrupacionesActivo>();

		if (activo.getAgrupaciones() != null) {

			for (int i = 0; i < activo.getAgrupaciones().size(); i++) {
				DtoAgrupacionesActivo dtoActivoAgrupaciones = new DtoAgrupacionesActivo();
				try {

					BeanUtils.copyProperties(dtoActivoAgrupaciones, activo.getAgrupaciones().get(i));
					BeanUtils.copyProperties(dtoActivoAgrupaciones, activo.getAgrupaciones().get(i).getAgrupacion());

					BeanUtils.copyProperty(dtoActivoAgrupaciones, "fechaInclusion",
							activo.getAgrupaciones().get(i).getFechaInclusion());
					BeanUtils.copyProperty(dtoActivoAgrupaciones, "tipoAgrupacionDescripcion",
							activo.getAgrupaciones().get(i).getAgrupacion().getTipoAgrupacion().getDescripcion());
					BeanUtils.copyProperty(dtoActivoAgrupaciones, "tipoAgrupacionCodigo",
							activo.getAgrupaciones().get(i).getAgrupacion().getTipoAgrupacion().getCodigo());
					BeanUtils.copyProperty(dtoActivoAgrupaciones, "idAgrupacion",
							activo.getAgrupaciones().get(i).getAgrupacion().getId());
					BeanUtils.copyProperty(dtoActivoAgrupaciones, "numActivos",
							activo.getAgrupaciones().get(i).getAgrupacion().getActivos().size());
					BeanUtils.copyProperty(dtoActivoAgrupaciones, "numActivosPublicados",
							activoApi.getNumActivosPublicadosByAgrupacion(
									activo.getAgrupaciones().get(i).getAgrupacion().getActivos()));

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoAgrupaciones.add(dtoActivoAgrupaciones);

			}
		}

		return listaDtoAgrupaciones;

	}

	public List<VBusquedaVisitasDetalle> getListVisitasActivoById(Long id)
			throws IllegalAccessException, InvocationTargetException {

		Activo activo = activoApi.get(id);

		List<VBusquedaVisitasDetalle> visitasDetalles = new ArrayList<VBusquedaVisitasDetalle>();

		if (!Checks.esNulo(activo)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId().toString());
			visitasDetalles = genericDao.getList(VBusquedaVisitasDetalle.class, filtro);
		}

		return visitasDetalles;

	}

	public List<DtoActivoCatastro> getListCatastroById(Long id) {

		Activo activo = activoApi.get(id);
		// DtoCarga cargaDto = new ArrayList<DtoCarga>();
		List<DtoActivoCatastro> listaDtoCatastro = new ArrayList<DtoActivoCatastro>();

		if (activo.getInfoAdministrativa() != null && activo.getCatastro() != null) {

			for (int i = 0; i < activo.getCatastro().size(); i++) {
				DtoActivoCatastro catastroDto = new DtoActivoCatastro();
				try {
					BeanUtils.copyProperties(catastroDto, activo.getCatastro().get(i));
					BeanUtils.copyProperty(catastroDto, "idCatastro", activo.getCatastro().get(i).getId());

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoCatastro.add(catastroDto);

			}
		}

		return listaDtoCatastro;

	}

	public DtoActivoValoraciones getValoresPreciosActivoById(Long id) {

		Activo activo = activoApi.get(id);
		DtoActivoValoraciones valoracionesDto = new DtoActivoValoraciones();

		try {
			BeanUtils.copyProperties(valoracionesDto, activo);
			if (activo.getAdjJudicial() != null && activo.getAdjJudicial().getAdjudicacionBien() != null) {
				BeanUtils.copyProperty(valoracionesDto, "importeAdjudicacion",
						activo.getAdjJudicial().getAdjudicacionBien().getImporteAdjudicacion());
			}

			if (activo.getAdjNoJudicial() != null) {
				BeanUtils.copyProperty(valoracionesDto, "valorAdquisicion",
						activo.getAdjNoJudicial().getValorAdquisicion());
			}

			if (activo.getGestorBloqueoPrecio() != null) {
				BeanUtils.copyProperty(valoracionesDto, "gestorBloqueoPrecio",
						activo.getGestorBloqueoPrecio().getApellidoNombre());
			}
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return valoracionesDto;
	}

	public List<DtoActivoOcupanteLegal> getListOcupantesLegalesById(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoActivoOcupanteLegal> listaDtoOcupanteLegal = new ArrayList<DtoActivoOcupanteLegal>();

		if (activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getActivoOcupanteLegal() != null) {

			for (int i = 0; i < activo.getSituacionPosesoria().getActivoOcupanteLegal().size(); i++) {
				DtoActivoOcupanteLegal ocupanteLegalDto = new DtoActivoOcupanteLegal();
				try {
					BeanUtils.copyProperties(ocupanteLegalDto,
							activo.getSituacionPosesoria().getActivoOcupanteLegal().get(i));
					BeanUtils.copyProperty(ocupanteLegalDto, "idActivoOcupanteLegal",
							activo.getSituacionPosesoria().getActivoOcupanteLegal().get(i).getId());
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoOcupanteLegal.add(ocupanteLegalDto);

			}
		}

		return listaDtoOcupanteLegal;

	}

	public List<DtoAdmisionDocumento> getListDocumentacionAdministrativaById(Long id) {

		Activo activo = activoApi.get(id);

		List<DtoAdmisionDocumento> listaDtoAdmisionDocumento = new ArrayList<DtoAdmisionDocumento>();

		if (activo.getAdmisionDocumento() != null) {

			for (int i = 0; i < activo.getAdmisionDocumento().size(); i++) {
				DtoAdmisionDocumento catastroDto = new DtoAdmisionDocumento();
				try {

					BeanUtils.copyProperties(catastroDto, activo.getAdmisionDocumento().get(i));
					BeanUtils.copyProperty(catastroDto, "descripcionTipoDocumentoActivo", activo.getAdmisionDocumento()
							.get(i).getConfigDocumento().getTipoDocumentoActivo().getDescripcion());

					if (activo.getAdmisionDocumento() != null) {
						if (activo.getAdmisionDocumento().get(i).getTipoCalificacionEnergetica() != null) {
							BeanUtils.copyProperty(catastroDto, "tipoCalificacionCodigo",
									activo.getAdmisionDocumento().get(i).getTipoCalificacionEnergetica().getCodigo());
							BeanUtils.copyProperty(catastroDto, "tipoCalificacionDescripcion", activo
									.getAdmisionDocumento().get(i).getTipoCalificacionEnergetica().getDescripcion());
						}
					}

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoAdmisionDocumento.add(catastroDto);

			}
		}

		return listaDtoAdmisionDocumento;

	}

	public List<DtoFoto> getFotosById(Long id) {

		Activo activo = activoApi.get(id);

		List<DtoFoto> listaFotos = new ArrayList<DtoFoto>();

		if (activo.getFotos() != null) {

			for (int i = 0; i < activo.getFotos().size(); i++) {
				DtoFoto fotoDto = new DtoFoto();
				try {

					BeanUtils.copyProperties(fotoDto, activo.getFotos().get(i));
					BeanUtils.copyProperty(fotoDto, "fileItem", activo.getFotos().get(i).getAdjunto().getFileItem());
					BeanUtils.copyProperty(fotoDto, "path",
							activo.getFotos().get(i).getAdjunto().getFileItem().getFile().getPath());

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaFotos.add(fotoDto);

			}
		}

		return listaFotos;

	}

	public DtoTasacion getTasacionById(Long id) {

		DtoTasacion dtoTasacion = new DtoTasacion();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoTasacion tasacionSeleccionada = (ActivoTasacion) genericDao.get(ActivoTasacion.class, filtro);

		if (tasacionSeleccionada != null) {
			try {
				BeanUtils.copyProperties(dtoTasacion, tasacionSeleccionada);
				BeanUtils.copyProperties(dtoTasacion, tasacionSeleccionada.getValoracionBien());
				if (tasacionSeleccionada.getTipoTasacion() != null) {
					BeanUtils.copyProperty(dtoTasacion, "tipoTasacionDescripcion",
							tasacionSeleccionada.getTipoTasacion().getDescripcion());
				}
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
		}

		return dtoTasacion;
	}

	public ActivoFoto getFotoActivoById(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);

		return genericDao.get(ActivoFoto.class, filtro);

	}

	public ActivoFoto getFotoActivoByRemoteId(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "remoteId", id);
		return genericDao.get(ActivoFoto.class, filtro);

	}

	public List<ActivoFoto> getListFotosActivoById(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
		Order order = new Order(OrderType.ASC, "orden");

		return genericDao.getListOrdered(ActivoFoto.class, order, filtro);

	}

	public List<ActivoFoto> getListFotosActivoByIdOrderPrincipal(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
		Order order = new Order(OrderType.ASC, "principal, orden");

		return genericDao.getListOrdered(ActivoFoto.class, order, filtro);

	}

	public Page getActivos(DtoActivoFilter dtoActivoFiltro) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		if (!Checks.esNulo(usuarioCartera))
			dtoActivoFiltro.setEntidadPropietariaCodigo(usuarioCartera.getCartera().getCodigo());
		return (Page) activoApi.getListActivos(dtoActivoFiltro, usuarioLogado);
	}

	public List<DtoUsuario> getComboUsuarios(long idTipoGestor) {
		DespachoExterno despachoExterno = coreextensionApi.getListAllDespachos(idTipoGestor, false).get(0);
		List<Usuario> listaUsuarios = coreextensionApi.getListAllUsuariosData(despachoExterno.getId(), false);
		List<DtoUsuario> listaUsuariosDto = new ArrayList<DtoUsuario>();

		try {
			for (Usuario usuario : listaUsuarios) {
				DtoUsuario dtoUsuario = new DtoUsuario();
				BeanUtils.copyProperties(dtoUsuario, usuario);
				listaUsuariosDto.add(dtoUsuario);
			}
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		return listaUsuariosDto;
	}

	public List<DtoListadoGestores> getGestores(Long idActivo) {
		GestorEntidadDto gestorEntidadDto = new GestorEntidadDto();
		gestorEntidadDto.setIdEntidad(idActivo);
		gestorEntidadDto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO);
		List<GestorEntidadHistorico> gestoresEntidad = gestorActivoApi
				.getListGestoresAdicionalesHistoricoData(gestorEntidadDto);

		List<DtoListadoGestores> listadoGestoresDto = new ArrayList<DtoListadoGestores>();

		for (GestorEntidadHistorico gestor : gestoresEntidad) {
			DtoListadoGestores dtoGestor = new DtoListadoGestores();
			try {
				BeanUtils.copyProperties(dtoGestor, gestor);
				BeanUtils.copyProperties(dtoGestor, gestor.getUsuario());
				BeanUtils.copyProperties(dtoGestor, gestor.getTipoGestor());
				BeanUtils.copyProperty(dtoGestor, "id", gestor.getId());
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}

			listadoGestoresDto.add(dtoGestor);
		}

		return listadoGestoresDto;

	}

	public Boolean insertarGestorAdicional(GestorEntidadDto dto) {
		dto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO);
		return gestorActivoApi.insertarGestorAdicionalActivo(dto);
		//return true;
	}

	public List<DtoListadoTramites> getTramitesActivo(Long idActivo, WebDto webDto) {

		// List<ActivoTramite> tramitesActivo = (List<ActivoTramite>)
		// activoTramiteApi.getTramitesActivo(idActivo, webDto).getResults();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo);
		List<VBusquedaTramitesActivo> tramitesActivo = genericDao.getList(VBusquedaTramitesActivo.class, filtro);
		List<DtoListadoTramites> listadoTramitesDto = new ArrayList<DtoListadoTramites>();

		for (VBusquedaTramitesActivo tramite : tramitesActivo) {
			DtoListadoTramites dtoTramite = new DtoListadoTramites();
			try {
				beanUtilNotNull.copyProperties(dtoTramite, tramite);

			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
			listadoTramitesDto.add(dtoTramite);
		}

		return listadoTramitesDto;
	}

	public List<DtoPropietario> getListPropietarioById(Long id) {

		Activo activo = activoApi.get(id);
		List<DtoPropietario> listaDtoPropietarios = new ArrayList<DtoPropietario>();

		for (int i = 0; i < activo.getPropietariosActivo().size(); i++) {
			if (activo.getPropietariosActivo() != null && activo.getPropietariosActivo().size() > 0) {
				DtoPropietario propietarioDto = new DtoPropietario();
				ActivoPropietarioActivo propietario = activo.getPropietariosActivo().get(i);
				try {
					BeanUtils.copyProperties(propietarioDto, propietario);
					BeanUtils.copyProperties(propietarioDto, propietario.getPropietario());
					BeanUtils.copyProperty(propietarioDto, "nombreCompleto",
							propietario.getPropietario().getFullName());
					BeanUtils.copyProperty(propietarioDto, "idActivo", propietario.getActivo().getId());
					if (!Checks.esNulo(propietario.getTipoGradoPropiedad()))
						BeanUtils.copyProperty(propietarioDto, "tipoGradoPropiedadDescripcion",
								propietario.getTipoGradoPropiedad().getDescripcion());
					if (!Checks.esNulo(propietario.getPropietario().getLocalidad()))
						BeanUtils.copyProperty(propietarioDto, "localidadDescripcion",
								propietario.getPropietario().getLocalidad().getDescripcion());
					if (!Checks.esNulo(propietario.getPropietario().getProvincia()))
						BeanUtils.copyProperty(propietarioDto, "provinciaDescripcion",
								propietario.getPropietario().getProvincia().getDescripcion());
					if (!Checks.esNulo(propietario.getPropietario().getTipoPersona()))
						BeanUtils.copyProperty(propietarioDto, "tipoPersonaDescripcion",
								propietario.getPropietario().getTipoPersona().getDescripcion());
					if (!Checks.esNulo(propietario.getPropietario().getLocalidadContacto()))
						BeanUtils.copyProperty(propietarioDto, "localidadContactoDescripcion",
								propietario.getPropietario().getLocalidadContacto().getDescripcion());

					if (!Checks.esNulo(propietario.getPropietario().getProvinciaContacto()))
						BeanUtils.copyProperty(propietarioDto, "provinciaContactoDescripcion",
								propietario.getPropietario().getProvinciaContacto().getDescripcion());
					
					if (!Checks.esNulo(propietario.getPropietario().getTipoDocIdentificativo())) {
						BeanUtils.copyProperty(propietarioDto, "tipoDocIdentificativoDesc",
								propietario.getPropietario().getTipoDocIdentificativo().getDescripcion());
					}

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoPropietarios.add(propietarioDto);
			}

		}

		return listaDtoPropietarios;

	}

	public List<DtoValoracion> getListValoracionesById(Long id) {

		// FIXME Hacer el get bien del listado de cargas cuando estén las tablas
		// de activo.
		Activo activo = activoApi.get(id);
		List<DtoValoracion> listaDtoValoracion = new ArrayList<DtoValoracion>();

		for (int i = 0; i < activo.getValoracion().size(); i++) {
			if (activo.getValoracion() != null && activo.getValoracion().size() > 0) {
				DtoValoracion valoracionDto = new DtoValoracion();
				try {
					BeanUtils.copyProperties(valoracionDto, activo.getValoracion().get(i));
					BeanUtils.copyProperty(valoracionDto, "tipoPrecioCod",
							activo.getValoracion().get(i).getTipoPrecio().getCodigo());
					BeanUtils.copyProperty(valoracionDto, "tipoPrecioDescripcion",
							activo.getValoracion().get(i).getTipoPrecio().getDescripcion());

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoValoracion.add(valoracionDto);
			}

		}

		return listaDtoValoracion;

	}

	public List<DtoTasacion> getListTasacionById(Long id) {

		// FIXME Hacer el get bien del listado de cargas cuando estén las tablas
		// de activo.
		Activo activo = activoApi.get(id);
		List<DtoTasacion> listaDtoTasacion = new ArrayList<DtoTasacion>();

		if (activo.getTasacion() != null) {
			for (int i = 0; i < activo.getTasacion().size(); i++) {

				DtoTasacion tasacionDto = new DtoTasacion();
				try {
					BeanUtils.copyProperties(tasacionDto, activo.getTasacion().get(i));
					if (activo.getTasacion().get(i).getTipoTasacion() != null) {
						BeanUtils.copyProperty(tasacionDto, "tipoTasacionCodigo",
								activo.getTasacion().get(i).getTipoTasacion().getCodigo());
						BeanUtils.copyProperty(tasacionDto, "tipoTasacionDescripcion",
								activo.getTasacion().get(i).getTipoTasacion().getDescripcion());
					}
					if (activo.getTasacion().get(i).getValoracionBien() != null) {
						BeanUtils.copyProperty(tasacionDto, "fechaValorTasacion",
								activo.getTasacion().get(i).getValoracionBien().getFechaValorTasacion());
						BeanUtils.copyProperty(tasacionDto, "fechaSolicitudTasacion",
								activo.getTasacion().get(i).getValoracionBien().getFechaSolicitudTasacion());
						BeanUtils.copyProperty(tasacionDto, "importeValorTasacion",
								activo.getTasacion().get(i).getValoracionBien().getImporteValorTasacion());
					}
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoTasacion.add(tasacionDto);
			}
		}

		return listaDtoTasacion;

	}

	public DtoTramite getTramite(Long idTramite) {
		DtoTramite dtoTramite = new DtoTramite();
		ActivoTramite tramite = activoTramiteApi.get(idTramite);

		try {
			beanUtilNotNull.copyProperty(dtoTramite, "idTramite", tramite.getId());
			beanUtilNotNull.copyProperty(dtoTramite, "idTipoTramite", tramite.getTipoTramite().getId());
			beanUtilNotNull.copyProperty(dtoTramite, "tipoTramite", tramite.getTipoTramite().getDescripcion());
			if (!Checks.esNulo(tramite.getTramitePadre()))
				beanUtilNotNull.copyProperty(dtoTramite, "idTramitePadre", tramite.getTramitePadre().getId());
			beanUtilNotNull.copyProperty(dtoTramite, "idActivo", tramite.getActivo().getId());
			beanUtilNotNull.copyProperty(dtoTramite, "nombre", tramite.getTipoTramite().getDescripcion());
			beanUtilNotNull.copyProperty(dtoTramite, "estado", tramite.getEstadoTramite().getDescripcion());
			if (!Checks.esNulo(tramite.getTrabajo())) {
				beanUtilNotNull.copyProperty(dtoTramite, "idTrabajo", tramite.getTrabajo().getId());
				beanUtilNotNull.copyProperty(dtoTramite, "numTrabajo", tramite.getTrabajo().getNumTrabajo());
				beanUtilNotNull.copyProperty(dtoTramite, "tipoTrabajo",
						tramite.getTrabajo().getTipoTrabajo().getDescripcion());
				beanUtilNotNull.copyProperty(dtoTramite, "subtipoTrabajo",
						tramite.getTrabajo().getSubtipoTrabajo().getDescripcion());
			}
			if (!Checks.esNulo(tramite.getActivo().getTipoActivo()))
				beanUtilNotNull.copyProperty(dtoTramite, "tipoActivo",
						tramite.getActivo().getTipoActivo().getDescripcion());
			if (!Checks.esNulo(tramite.getActivo().getSubtipoActivo()))
				beanUtilNotNull.copyProperty(dtoTramite, "subtipoActivo",
						tramite.getActivo().getSubtipoActivo().getDescripcion());
			if (!Checks.esNulo(tramite.getActivo().getCartera()))
				beanUtilNotNull.copyProperty(dtoTramite, "cartera", tramite.getActivo().getCartera().getDescripcion());
			beanUtilNotNull.copyProperty(dtoTramite, "fechaInicio", tramite.getFechaInicio());
			if (!Checks.esNulo(tramite.getFechaFin()))
				beanUtilNotNull.copyProperty(dtoTramite, "fechaFinalizacion", tramite.getFechaFin());
			beanUtilNotNull.copyProperty(dtoTramite, "numActivo", tramite.getActivo().getNumActivo());
			beanUtilNotNull.copyProperty(dtoTramite, "esMultiActivo", tramite.getActivos().size() > 1 ? true : false);
			beanUtilNotNull.copyProperty(dtoTramite, "countActivos", tramite.getActivos().size());
			if (!Checks.esNulo(tramite.getTrabajo()))
				if (!DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(tramite.getTrabajo().getTipoTrabajo().getCodigo()))
					beanUtilNotNull.copyProperty(dtoTramite, "ocultarBotonCierre", true);
			if (!Checks.esNulo(tramite.getTrabajo()))
				if (!DDTipoTrabajo.CODIGO_COMERCIALIZACION.equals(tramite.getTrabajo().getTipoTrabajo().getCodigo()))
					beanUtilNotNull.copyProperty(dtoTramite, "ocultarBotonResolucion", true);
			beanUtilNotNull.copyProperty(dtoTramite, "tieneEC", false);
			if (!Checks.esNulo(tramite.getTrabajo())) {
				// Trabajos asociados con expediente comercial
				Filter filtroEC = genericDao.createFilter(FilterType.EQUALS, "trabajo.id",
						tramite.getTrabajo().getId());
				ExpedienteComercial expedienteComercial = genericDao.get(ExpedienteComercial.class, filtroEC);
				if (!Checks.esNulo(expedienteComercial)) {
					beanUtilNotNull.copyProperty(dtoTramite, "tieneEC", true);
					beanUtilNotNull.copyProperty(dtoTramite, "idExpediente", expedienteComercial.getId());
					beanUtilNotNull.copyProperty(dtoTramite, "descripcionEstadoEC",
							expedienteComercial.getEstado().getDescripcion());
					beanUtilNotNull.copyProperty(dtoTramite, "numEC", expedienteComercial.getNumExpediente());
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return dtoTramite;
	}

	public List<DtoListadoTareas> getTareasTramite(Long idTramite) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		List<TareaExterna> tareasTramite = new ArrayList<TareaExterna>();
		ActivoTramite tramite = activoTramiteApi.get(idTramite);

		if (!genericAdapter.isSuper(usuarioLogado)
				&& !gestorActivoApi.isSupervisorActivo(tramite.getActivo(), usuarioLogado))
			tareasTramite = activoTareaExternaApi.getActivasByIdTramite(idTramite, usuarioLogado);
		else
			tareasTramite = activoTareaExternaApi.getActivasByIdTramiteTodas(idTramite);

		List<DtoListadoTareas> tareasTramiteDto = new ArrayList<DtoListadoTareas>();

		for (TareaExterna tarea : tareasTramite) {
			DtoListadoTareas dtoListadoTareas = new DtoListadoTareas();
			TareaActivo tareaActivo = tareaActivoApi.get(tarea.getTareaPadre().getId());

			try {
				beanUtilNotNull.copyProperty(dtoListadoTareas, "id", tarea.getTareaPadre().getId());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "idTareaExterna", tarea.getId());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea",
						tarea.getTareaProcedimiento().getDescripcion());
				// beanUtilNotNull.copyProperty(dtoListadoTareas, "idTramite",
				// value);

				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaInicio", tarea.getTareaPadre().getFechaInicio());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaVenc", tarea.getTareaPadre().getFechaVenc());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaFin", tarea.getTareaPadre().getFechaFin());

				if (!Checks.esNulo(tareaActivo.getUsuario())) {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "idGestor", tareaActivo.getUsuario().getId());
					beanUtilNotNull.copyProperty(dtoListadoTareas, "gestor", tareaActivo.getUsuario().getUsername());
				}
				beanUtilNotNull.copyProperty(dtoListadoTareas, "subtipoTareaCodigoSubtarea",
						tareaActivo.getSubtipoTarea().getCodigoSubtarea());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "codigoTarea",
						tarea.getTareaProcedimiento().getCodigo());

			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
			tareasTramiteDto.add(dtoListadoTareas);
		}

		return tareasTramiteDto;

	}

	public List<DtoListadoTareas> getTareasTramiteHistorico(Long idTramite) {

		List<TareaActivo> tareasTramite = tareaActivoApi.getTareasActivoByIdTramite(idTramite);
		List<DtoListadoTareas> tareasTramiteDto = new ArrayList<DtoListadoTareas>();

		for (TareaActivo tareaActivo : tareasTramite) {
			DtoListadoTareas dtoListadoTareas = new DtoListadoTareas();

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tareaPadre.id", tareaActivo.getId());
			TareaExterna tareaExterna = genericDao.get(TareaExterna.class, filtro);

			try {
				beanUtilNotNull.copyProperty(dtoListadoTareas, "id", tareaActivo.getId());
				if (!Checks.esNulo(tareaExterna)) {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "idTareaExterna", tareaExterna.getId());
					beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea",
							tareaExterna.getTareaProcedimiento().getDescripcion());
				} else {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "tipoTarea", tareaActivo.getDescripcionTarea());
				}
				// beanUtilNotNull.copyProperty(dtoListadoTareas, "idTramite",
				// value);

				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaInicio", tareaActivo.getFechaInicio());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaVenc", tareaActivo.getFechaVenc());
				beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaFin", tareaActivo.getFechaFin());

				if (!Checks.esNulo(tareaActivo.getUsuario())) {
					beanUtilNotNull.copyProperty(dtoListadoTareas, "idGestor", tareaActivo.getUsuario().getId());
					beanUtilNotNull.copyProperty(dtoListadoTareas, "gestor", tareaActivo.getUsuario().getUsername());
				}
				beanUtilNotNull.copyProperty(dtoListadoTareas, "subtipoTareaCodigoSubtarea",
						tareaActivo.getSubtipoTarea().getCodigoSubtarea());

			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
			tareasTramiteDto.add(dtoListadoTareas);
		}

		return tareasTramiteDto;

	}

	/*
	 * Este método tiraba de la TEX, al añadir las prórrogas se ha tenido que
	 * modificar.
	 * 
	 * public List<DtoListadoTareas> getTareasTramiteHistorico(Long idTramite){
	 * 
	 * List<TareaExterna> tareasTramite =
	 * activoTareaExternaApi.getTareasByIdTramite(idTramite);
	 * List<DtoListadoTareas> tareasTramiteDto = new
	 * ArrayList<DtoListadoTareas>();
	 * 
	 * for(TareaExterna tarea : tareasTramite){ DtoListadoTareas
	 * dtoListadoTareas = new DtoListadoTareas(); TareaActivo tareaActivo =
	 * tareaActivoApi.get(tarea.getTareaPadre().getId());
	 * 
	 * try{ beanUtilNotNull.copyProperty(dtoListadoTareas, "id",
	 * tarea.getTareaPadre().getId());
	 * beanUtilNotNull.copyProperty(dtoListadoTareas, "idTareaExterna",
	 * tarea.getId()); beanUtilNotNull.copyProperty(dtoListadoTareas,
	 * "tipoTarea", tarea.getTareaProcedimiento().getDescripcion());
	 * //beanUtilNotNull.copyProperty(dtoListadoTareas, "idTramite", value);
	 * beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaInicio",
	 * tarea.getTareaPadre().getFechaInicio());
	 * beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaFin",
	 * tarea.getTareaPadre().getFechaFin());
	 * beanUtilNotNull.copyProperty(dtoListadoTareas, "fechaVenc",
	 * tarea.getTareaPadre().getFechaVenc());
	 * 
	 * if(!Checks.esNulo(tareaActivo.getUsuario())){
	 * beanUtilNotNull.copyProperty(dtoListadoTareas, "idGestor",
	 * tareaActivo.getUsuario().getId());
	 * beanUtilNotNull.copyProperty(dtoListadoTareas, "gestor",
	 * tareaActivo.getUsuario().getUsername()); }
	 * beanUtilNotNull.copyProperty(dtoListadoTareas,
	 * "subtipoTareaCodigoSubtarea",
	 * tareaActivo.getSubtipoTarea().getCodigoSubtarea());
	 * 
	 * } catch (IllegalAccessException e) { e.printStackTrace(); } catch
	 * (InvocationTargetException e) { e.printStackTrace(); }
	 * tareasTramiteDto.add(dtoListadoTareas); }
	 * 
	 * return tareasTramiteDto;
	 * 
	 * }
	 */

	public Long crearTramiteAdmision(Long idActivo) {

		TipoProcedimiento tprc = tipoProcedimiento.getByCodigo("T001"); // Trámite
																		// de
																		// admisión

		ActivoTramite tramite = jbpmActivoTramiteManagerApi.creaActivoTramite(tprc, activoApi.get(idActivo));
		Long idBpm = jbpmActivoTramiteManagerApi.lanzaBPMAsociadoATramite(tramite.getId());

		jbpmActivoTramiteManagerApi.paralizarTareasChecking(tramite);

		return idBpm;
	}

	public Long crearTramitePublicacion(Long idActivo) {

		TipoProcedimiento tprc = tipoProcedimiento.getByCodigo("T011");// Trámite
																		// de
																		// publicación

		ActivoTramite tramite = jbpmActivoTramiteManagerApi.creaActivoTramite(tprc, activoApi.get(idActivo));
		Long idBpm = jbpmActivoTramiteManagerApi.lanzaBPMAsociadoATramite(tramite.getId());

		return idBpm;
	}

	public List<VAdmisionDocumentos> getListAdmisionCheckDocumentos(Long idActivo) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo.toString());
		Order order = new Order(OrderType.ASC, "descripcionTipoDoc");

		return genericDao.getListOrdered(VAdmisionDocumentos.class, order, filtro);

	}

	public List<VOfertasActivosAgrupacion> getListOfertasActivos(Long idActivo) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo.toString());

		return genericDao.getList(VOfertasActivosAgrupacion.class, filtro);

	}

	public List<VPreciosVigentes> getPreciosVigentesById(Long idActivo) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo.toString());
		Order order = new Order(OrderType.ASC, "orden");

		return genericDao.getListOrdered(VPreciosVigentes.class, order, filtro);

	}

	@Transactional(readOnly = false)
	public boolean saveAdmisionDocumento(DtoAdmisionDocumento dtoAdmisionDocumento) {

		ActivoAdmisionDocumento activoAdmisionDocumento = null;

		if (dtoAdmisionDocumento.getIdAdmisionDoc() != null) {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdmisionDocumento.getIdAdmisionDoc());
			activoAdmisionDocumento = genericDao.get(ActivoAdmisionDocumento.class, filtro);

			if (!BooleanUtils.toBoolean(dtoAdmisionDocumento.getAplica())) {

				activoAdmisionDocumento.setAplica(false);
				activoAdmisionDocumento.setFechaObtencion(null);
				activoAdmisionDocumento.setFechaSolicitud(null);
				activoAdmisionDocumento.setFechaVerificado(null);
				activoAdmisionDocumento.setEstadoDocumento(null);
				activoAdmisionDocumento.setTipoCalificacionEnergetica(null);
				activoAdmisionDocumento.setNumDocumento(null);
				activoAdmisionDocumento.setFechaEtiqueta(null);
				activoAdmisionDocumento.setFechaEmision(null);
				activoAdmisionDocumento.setFechaCaducidad(null);

			} else {

				rellenaCheckingDocumentoAdmision(activoAdmisionDocumento, dtoAdmisionDocumento);
			}

			genericDao.update(ActivoAdmisionDocumento.class, activoAdmisionDocumento);

		} else {

			activoAdmisionDocumento = new ActivoAdmisionDocumento();

			rellenaCheckingDocumentoAdmision(activoAdmisionDocumento, dtoAdmisionDocumento);

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdmisionDocumento.getIdActivo());
			activoAdmisionDocumento.setActivo(genericDao.get(Activo.class, filtro));
			filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdmisionDocumento.getIdConfiguracionDoc());
			activoAdmisionDocumento.setConfigDocumento(genericDao.get(ActivoConfigDocumento.class, filtro));

			rellenaCheckingDocumentoAdmision(activoAdmisionDocumento, dtoAdmisionDocumento);
			genericDao.save(ActivoAdmisionDocumento.class, activoAdmisionDocumento);

		}

		return true;

	}

	private void rellenaCheckingDocumentoAdmision(ActivoAdmisionDocumento activoAdmisionDocumento,
			DtoAdmisionDocumento dtoAdmisionDocumento) {

		try {

			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "fechaObtencion",
					dtoAdmisionDocumento.getFechaObtencion());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "fechaSolicitud",
					dtoAdmisionDocumento.getFechaSolicitud());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "fechaVerificado",
					dtoAdmisionDocumento.getFechaVerificado());
			beanUtilNotNull.copyProperty(activoAdmisionDocumento, "aplica",
					BooleanUtils.toBoolean(dtoAdmisionDocumento.getAplica()));

			if (dtoAdmisionDocumento.getEstadoDocumento() != null) {
				DDEstadoDocumento estadoDocumento = (DDEstadoDocumento) proxyFactory.proxy(UtilDiccionarioApi.class)
						.dameValorDiccionarioByCod(DDEstadoDocumento.class, dtoAdmisionDocumento.getEstadoDocumento());
				activoAdmisionDocumento.setEstadoDocumento(estadoDocumento);
			}
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

	}

	public List<DtoAdjunto> getAdjuntosActivo(Long id)
			throws GestorDocumentalException, IllegalAccessException, InvocationTargetException {
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Activo activo = activoApi.get(id);
			listaAdjuntos =	gestorDocumentalAdapterApi.getAdjuntosActivo(activo);			
			
			for(DtoAdjunto adj: listaAdjuntos){
				ActivoAdjuntoActivo adjuntoActivo = activo.getAdjuntoGD(adj.getId());
				if(!Checks.esNulo(adjuntoActivo)) {
					if(!Checks.esNulo(adjuntoActivo.getTipoDocumentoActivo())) {
						adj.setDescripcionTipo(adjuntoActivo.getTipoDocumentoActivo().getDescripcion());
					}
					adj.setContentType(adjuntoActivo.getContentType());
					if(!Checks.esNulo(adjuntoActivo.getAuditoria())) {
						adj.setGestor(adjuntoActivo.getAuditoria().getUsuarioCrear());
					}
					adj.setTamanyo(adjuntoActivo.getTamanyo());
				}
			}		
			
		} else {
			listaAdjuntos = getAdjuntosActivo(id, listaAdjuntos);
		}
		return listaAdjuntos;
	}

	private List<DtoAdjunto> getAdjuntosActivo(Long id, List<DtoAdjunto> listaAdjuntos)
			throws IllegalAccessException, InvocationTargetException {
		Activo activo = activoApi.get(id);

		for (ActivoAdjuntoActivo adjunto : activo.getAdjuntos()) {
			DtoAdjunto dto = new DtoAdjunto();

			BeanUtils.copyProperties(dto, adjunto);
			dto.setIdEntidad(activo.getId());
			dto.setDescripcionTipo(adjunto.getTipoDocumentoActivo().getDescripcion());
			dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());

			listaAdjuntos.add(dto);
		}
		return listaAdjuntos;
	}

	public String uploadDocumento(WebFileItem webFileItem, Activo activoEntrada, String matricula) throws Exception {

		if (Checks.esNulo(activoEntrada)) {
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Activo activo = activoApi.get(Long.parseLong(webFileItem.getParameter("idEntidad")));
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
				DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo) genericDao
						.get(DDTipoDocumentoActivo.class, filtro);
				Long idDocRestClient = gestorDocumentalAdapterApi.upload(activo, webFileItem,
						usuarioLogado.getUsername(), tipoDocumento.getMatricula());
				activoApi.upload2(webFileItem, idDocRestClient);
			} else {
				activoApi.upload(webFileItem);
			}
		} else {
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo) genericDao
						.get(DDTipoDocumentoActivo.class, filtro);

				if (!Checks.esNulo(tipoDocumento)) {
					Long idDocRestClient = gestorDocumentalAdapterApi.upload(activoEntrada, webFileItem,
							usuarioLogado.getUsername(), tipoDocumento.getMatricula());
					activoApi.uploadDocumento(webFileItem, idDocRestClient, activoEntrada, matricula);
				}
			} else {
				activoApi.uploadDocumento(webFileItem, null, activoEntrada, matricula);
			}
		}
		return null;
	}

	public String upload(WebFileItem webFileItem) throws Exception {
		return uploadDocumento(webFileItem, null, null);
		// if(modoRestClient()) {
		// Activo activo =
		// activoApi.get(Long.parseLong(webFileItem.getParameter("idEntidad")));
		// Usuario usuarioLogado =
		// genericAdapter.getUsuarioLogado();
		//
		// Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
		// webFileItem.getParameter("tipo"));
		// DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo)
		// genericDao.get(DDTipoDocumentoActivo.class, filtro);
		// Long idDocRestClient = gestorDocumentalAdapterApi.upload(activo,
		// webFileItem, usuarioLogado.getUsername(),
		// tipoDocumento.getMatricula());
		// activoApi.upload2(webFileItem, idDocRestClient);
		// }else{
		// activoApi.upload(webFileItem);
		// }
		// return null;
	}

	public FileItem download(Long id) throws Exception {
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		return dl.getFileItem(id);
	}

	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		boolean borrado = false;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			try {
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			borrado = activoApi.deleteAdjunto(dtoAdjunto);
		}
		return borrado;
	}

	// MOVIDO A GENERIC MANAGER
	/*private boolean modoRestClient() {
		Boolean activar = Boolean.valueOf(appProperties.getProperty(PROPIEDAD_ACTIVAR_REST_CLIENT));
		if (activar == null) {
			activar = false;
		}
		return activar;
	}*/

	// public List<DtoActivoAviso> getAvisosActivoById(Long id) {
	// FIXME: Formatear aquí o en vista cuando se sepa el diseño.
	public DtoAviso getAvisosActivoById(Long id) {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		List<DtoAviso> avisos = activoAvisadorApi.getListActivoAvisador(id, usuarioLogado);

		DtoAviso avisosFormateados = new DtoAviso();
		avisosFormateados.setDescripcion("");
		for (int i = 0; i < avisos.size(); i++) {
			avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() + "<div class='div-aviso'>"
					+ avisos.get(i).getDescripcion() + "</div>");
		}

		return avisosFormateados;

	}

	@Transactional(readOnly = false)
	public boolean deleteFotosActivoById(Long[] id) {
		boolean resultado = true;
		try {

			for (int i = 0; i < id.length; i++) {
				ActivoFoto actvFoto = this.getFotoActivoById(id[i]);
				if (actvFoto.getRemoteId() != null) {
					OperationResultResponse reponseDelete = gestorDocumentalFotos.delete(actvFoto.getRemoteId());
					if (reponseDelete.getError() != null && !reponseDelete.getError().isEmpty()) {
						throw new Exception(reponseDelete.getError());
					}
				}
				genericDao.deleteById(ActivoFoto.class, actvFoto.getId());
			}

		} catch (Exception e) {
			logger.error(e);
			resultado = false;
		}

		return resultado;

	}

	public void deleteFotoByRemoteId(Long remoteId) {
		ActivoFoto actvFoto = this.getFotoActivoByRemoteId(remoteId);
		if (actvFoto != null) {
			genericDao.deleteById(ActivoFoto.class, actvFoto.getId());
		}else{
			logger.error("La foto con id remoto ".concat(remoteId.toString()).concat(" no existe"));
		}
		
	}

	/*
	 * public Page findAllHistoricoPresupuestos(DtoHistoricoPresupuestosFilter
	 * dtoPresupuestoFiltro) {
	 * 
	 * Usuario usuarioLogado =
	 * genericAdapter.getUsuarioLogado();
	 * 
	 * return (Page)
	 * activoApi.getListHistoricoPresupuestos(dtoPresupuestoFiltro,
	 * usuarioLogado); }
	 */

	@SuppressWarnings("unchecked")
	public DtoPage findAllHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dtoPresupuestoFiltro) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		Page pagePresupuestosActivo = activoApi.getListHistoricoPresupuestos(dtoPresupuestoFiltro, usuarioLogado);

		List<VBusquedaPresupuestosActivo> presupuestosActivo = (List<VBusquedaPresupuestosActivo>) pagePresupuestosActivo
				.getResults();

		for (VBusquedaPresupuestosActivo presupuesto : presupuestosActivo) {

			// Gastado + Pendiente de pago
			DtoActivosTrabajoFilter dtoFilter = new DtoActivosTrabajoFilter();

			dtoFilter.setIdActivo(presupuesto.getIdActivo());
			dtoFilter.setLimit(50000);
			dtoFilter.setStart(0);
			dtoFilter.setEstadoContable("1");

			Page vista = trabajoApi.getListActivos(dtoFilter);
			if (vista.getTotalCount() > 0) {

				List<VBusquedaActivosTrabajo> listaTemp = (List<VBusquedaActivosTrabajo>) vista.getResults();
				presupuesto.setDispuesto(new Double(0));
				for (VBusquedaActivosTrabajo activoTrabajoTemp : listaTemp) {

					presupuesto.setDispuesto(
							presupuesto.getDispuesto() + new Double(activoTrabajoTemp.getImporteParticipa()));
				}

			} else {
				presupuesto.setDispuesto(new Double(0));
			}

			if (Checks.esNulo(presupuesto.getSumaIncrementos())) {
				presupuesto.setSumaIncrementos(new Double(0));
			}

		}

		return new DtoPage(presupuestosActivo, pagePresupuestosActivo.getTotalCount());

	}

	// public List<DtoPresupuestoGraficoActivo>
	// findLastPresupuesto(DtoActivosTrabajoFilter dtoFilter) {
	@SuppressWarnings("unchecked")
	public DtoPresupuestoGraficoActivo findLastPresupuesto(DtoActivosTrabajoFilter dtoFilter) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		DtoPresupuestoGraficoActivo presupuestoGrafico = new DtoPresupuestoGraficoActivo();

		Long idPresupuesto = activoApi.getUltimoPresupuesto(Long.valueOf(dtoFilter.getIdActivo()));
		DtoHistoricoPresupuestosFilter dtoFiltroHistorico = new DtoHistoricoPresupuestosFilter();
		dtoFiltroHistorico.setIdActivo(dtoFilter.getIdActivo());
		dtoFiltroHistorico.setIdPresupuesto(idPresupuesto.toString());
		dtoFiltroHistorico.setLimit(1);
		dtoFiltroHistorico.setStart(0);

		VBusquedaPresupuestosActivo presupuestoActivo = (VBusquedaPresupuestosActivo) activoApi
				.getListHistoricoPresupuestos(dtoFiltroHistorico, usuarioLogado).getResults().get(0);

		// Disponible
		Page vista = trabajoApi.getListActivos(dtoFilter);
		if (vista.getTotalCount() > 0) {
			VBusquedaActivosTrabajo activoTrabajo = (VBusquedaActivosTrabajo) vista.getResults().get(0);
			presupuestoGrafico.setDisponible(new Double(activoTrabajo.getSaldoDisponible()));

			dtoFilter.setEstadoContable("1");

			// Gastado + Pendiente de pago
			vista = trabajoApi.getListActivos(dtoFilter);
			if (vista.getTotalCount() > 0) {

				List<VBusquedaActivosTrabajo> listaTemp = (List<VBusquedaActivosTrabajo>) vista.getResults();
				presupuestoGrafico.setGastado(new Double(0));
				for (VBusquedaActivosTrabajo activoTrabajoTemp : listaTemp) {

					presupuestoGrafico.setGastado(
							presupuestoGrafico.getGastado() + new Double(activoTrabajoTemp.getImporteParticipa()));

				}
				// activoTrabajo = (VBusquedaActivosTrabajo)
				// vista.getResults().get(0);

				// presupuestoGrafico.setGastado(new
				// Double(activoTrabajo.getImporteParticipa()));
			} else {
				presupuestoGrafico.setGastado(new Double(0));
			}

			// Pendiente de pago

			dtoFilter.setEstadoCodigo(DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO);
			vista = trabajoApi.getListActivos(dtoFilter);
			if (vista.getTotalCount() > 0) {
				// activoTrabajo = (VBusquedaActivosTrabajo)
				// vista.getResults().get(0);

				List<VBusquedaActivosTrabajo> listaTemp = (List<VBusquedaActivosTrabajo>) vista.getResults();
				presupuestoGrafico.setDispuesto(new Double(0));
				for (VBusquedaActivosTrabajo activoTrabajoTemp : listaTemp) {

					presupuestoGrafico.setDispuesto(
							presupuestoGrafico.getDispuesto() + new Double(activoTrabajoTemp.getImporteParticipa()));

				}

				// presupuestoGrafico.setDispuesto(new
				// Double(activoTrabajo.getImporteParticipa()));
			} else {
				presupuestoGrafico.setDispuesto(new Double(0));
			}

			presupuestoGrafico.setGastado(presupuestoGrafico.getGastado() - presupuestoGrafico.getDispuesto());
			presupuestoGrafico.setPresupuesto(presupuestoGrafico.getDisponible() + presupuestoGrafico.getDispuesto()
					+ presupuestoGrafico.getGastado());
			presupuestoGrafico.setDisponiblePorcentaje(
					Double.valueOf(((presupuestoGrafico.getDisponible() / presupuestoGrafico.getPresupuesto()) * 100)));
			presupuestoGrafico.setDispuestoPorcentaje(
					Double.valueOf(((presupuestoGrafico.getDispuesto() / presupuestoGrafico.getPresupuesto()) * 100)));
			presupuestoGrafico.setGastadoPorcentaje(
					Double.valueOf(((presupuestoGrafico.getGastado() / presupuestoGrafico.getPresupuesto()) * 100)));
			/*
			 * if ( (presupuestoGrafico.getDisponiblePorcentaje() +
			 * presupuestoGrafico.getDispuestoPorcentaje() +
			 * presupuestoGrafico.getGastadoPorcentaje()) != 100 ) {
			 * presupuestoGrafico.setDisponiblePorcentaje(presupuestoGrafico.
			 * getDisponiblePorcentaje() + 1); }
			 */

			presupuestoGrafico.setEjercicio(presupuestoActivo.getEjercicioAnyo());

		} else {

			if (presupuestoActivo.getSumaIncrementos() != null) {
				presupuestoGrafico.setDisponible(
						presupuestoActivo.getImporteInicial() + Double.valueOf(presupuestoActivo.getSumaIncrementos()));
			} else {
				presupuestoGrafico.setDisponible(presupuestoActivo.getImporteInicial());
			}
			presupuestoGrafico.setDisponiblePorcentaje(new Double(100));
			presupuestoGrafico.setEjercicio(presupuestoActivo.getEjercicioAnyo());
			presupuestoGrafico.setDispuesto(new Double(0));
			presupuestoGrafico.setGastado(new Double(0));
			presupuestoGrafico.setDispuestoPorcentaje(new Double(0));
			presupuestoGrafico.setGastadoPorcentaje(new Double(0));
			presupuestoGrafico.setPresupuesto(presupuestoGrafico.getDisponible());

		}

		return presupuestoGrafico;
		// return (Page)
		// activoApi.getListHistoricoPresupuestos(dtoPresupuestoFiltro,
		// usuarioLogado);
	}

	public List<DtoIncrementoPresupuestoActivo> findAllIncrementosPresupuestoById(Long idPresupuesto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "presupuestoActivo.id", idPresupuesto);
		Order order = new Order(OrderType.DESC, "fechaAprobacion");

		List<IncrementoPresupuesto> listaPresupuestos = genericDao.getListOrdered(IncrementoPresupuesto.class, order,
				filtro);
		List<DtoIncrementoPresupuestoActivo> listaDto = new ArrayList<DtoIncrementoPresupuestoActivo>();

		for (int i = 0; i < listaPresupuestos.size(); i++) {
			DtoIncrementoPresupuestoActivo dtoPresupuesto = new DtoIncrementoPresupuestoActivo();

			try {

				IncrementoPresupuesto incrementoPresupuesto = listaPresupuestos.get(i);
				BeanUtils.copyProperties(dtoPresupuesto, incrementoPresupuesto);

				beanUtilNotNull.copyProperty(dtoPresupuesto, "presupuestoActivoImporte",
						incrementoPresupuesto.getPresupuestoActivo().getImporteInicial());
				if (incrementoPresupuesto.getTrabajo() != null) {
					beanUtilNotNull.copyProperty(dtoPresupuesto, "codigoTrabajo",
							incrementoPresupuesto.getTrabajo().getNumTrabajo());
				}

			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}

			listaDto.add(dtoPresupuesto);
		}

		return listaDto;
	}

	public WebDto getTabActivo(Long id, String tab) throws IllegalAccessException, InvocationTargetException {

		TabActivoService tabActivoService = tabActivoFactory.getService(tab);
		Activo activo = activoApi.get(id);

		WebDto dto = tabActivoService.getTabData(activo);

		return dto;

	}

	@Transactional(readOnly = false)
	public boolean saveTabActivo(WebDto dto, Long id, String tab) {

		TabActivoService tabActivoService = tabActivoFactory.getService(tab);
		Activo activo = activoApi.get(id);

		activo = tabActivoService.saveTabActivo(activo, dto);

		activoApi.saveOrUpdate(activo);
		
		//Cambios dependientes que requieren que se hayan guardado previamente en el activo
		if(tabActivoService instanceof TabActivoDatosBasicos) {
			this.comprobacionesDatosFichaCabecera(activo, (DtoActivoFichaCabecera) dto);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createOfertaActivo(DtoOfertasFilter dto) throws Exception {
		Activo activo = activoApi.get(dto.getIdActivo());

		// Comprobar el tipo de destino comercial que tiene actualmente el
		// activo y contrastar con la oferta.
		if (!Checks.esNulo(activo.getTipoComercializacion())) {
			String comercializacion = activo.getTipoComercializacion().getCodigo();

			if (DDTipoOferta.CODIGO_VENTA.equals(dto.getTipoOferta())
					&& (!DDTipoComercializacion.CODIGO_VENTA.equals(comercializacion)
							&& !DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(comercializacion))) {
				throw new Exception(ActivoAdapter.OFERTA_INCOMPATIBLE_MSG);
			}

			if (DDTipoOferta.CODIGO_ALQUILER.equals(dto.getTipoOferta())
					&& (!DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(comercializacion)
							&& !DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(comercializacion))) {
				throw new Exception(ActivoAdapter.OFERTA_INCOMPATIBLE_MSG);
			}
		}
		
		try {
			Oferta oferta = new Oferta();
			ActivoOferta activoOferta = new ActivoOferta();
			ActivoOfertaPk activoOfertaPk = new ActivoOfertaPk();
			ClienteComercial clienteComercial = new ClienteComercial();

			/*
			 * if(!Checks.esNulo(activo.getAgrupaciones()) &&
			 * activo.getAgrupaciones().size()!=0){ for(ActivoAgrupacionActivo
			 * agrupaciones: activo.getAgrupaciones()){ ActivoAgrupacion
			 * agrupacion = agrupaciones.getAgrupacion();
			 * if(agrupacion.getActivoPrincipal().getId().equals(activo.getId())
			 * ){ oferta.setAgrupacion(agrupacion); } } }
			 */

			String codigoEstado = this.getEstadoNuevaOferta(activo);
			
			DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDEstadoOferta.class, codigoEstado);
			DDTipoOferta tipoOferta = (DDTipoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoOferta.class,
					dto.getTipoOferta());
			DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getTipoDocumento());
			Long numOferta = activoDao.getNextNumOferta();

			Long clcremid = activoDao.getNextClienteRemId();
			clienteComercial.setNombre(dto.getNombreCliente());
			clienteComercial.setApellidos(dto.getApellidosCliente());
			clienteComercial.setDocumento(dto.getNumDocumentoCliente());
			clienteComercial.setTipoDocumento(tipoDocumento);
			clienteComercial.setRazonSocial(dto.getRazonSocialCliente());
			clienteComercial.setIdClienteRem(clcremid);

			genericDao.save(ClienteComercial.class, clienteComercial);

			oferta.setNumOferta(numOferta);
			oferta.setImporteOferta(Double.valueOf(dto.getImporteOferta()));
			oferta.setEstadoOferta(estadoOferta);
			oferta.setTipoOferta(tipoOferta);
			oferta.setFechaAlta(new Date());
			oferta.setDesdeTanteo(dto.getDeDerechoTanteo());

			List<ActivoOferta> listaActivosOfertas = new ArrayList<ActivoOferta>();
			activoOfertaPk.setActivo(activo);
			activoOfertaPk.setOferta(oferta);
			activoOferta.setPrimaryKey(activoOfertaPk);
			activoOferta.setPorcentajeParticipacion(100.00);
			activoOferta.setImporteActivoOferta(oferta.getImporteOferta());
			listaActivosOfertas.add(activoOferta);
			oferta.setActivosOferta(listaActivosOfertas);

			oferta.setCliente(clienteComercial);

			genericDao.save(Oferta.class, oferta);
		} catch (Exception ex) {
			ex.printStackTrace();
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean saveLlave(DtoLlaves dto) {
		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		Filter llaveIDFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		ActivoLlave llave = genericDao.get(ActivoLlave.class, llaveIDFilter);

		if (!Checks.esNulo(llave)) {
			try {
				beanUtilNotNull.copyProperty(llave, "numLlave", dto.getNumLlave());
				beanUtilNotNull.copyProperty(llave, "codCentroLlave", dto.getCodCentroLlave());
				beanUtilNotNull.copyProperty(llave, "nomCentroLlave", dto.getNomCentroLlave());
				beanUtilNotNull.copyProperty(llave, "archivo1", dto.getArchivo1());
				beanUtilNotNull.copyProperty(llave, "archivo2", dto.getArchivo2());
				beanUtilNotNull.copyProperty(llave, "archivo3", dto.getArchivo3());
				beanUtilNotNull.copyProperty(llave, "juegoCompleto", dto.getJuegoCompleto());
				if (!Checks.esNulo(llave.getJuegoCompleto()) && llave.getJuegoCompleto() == 1)
					dto.setMotivoIncompleto("");
				beanUtilNotNull.copyProperty(llave, "motivoIncompleto", dto.getMotivoIncompleto());

			} catch (IllegalAccessException e) {
				e.printStackTrace();
				return false;
			} catch (InvocationTargetException e) {
				e.printStackTrace();
				return false;
			}
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteLlave(DtoLlaves dto) {
		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		Filter llaveIDFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		ActivoLlave llave = genericDao.get(ActivoLlave.class, llaveIDFilter);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		if (!Checks.esNulo(llave) && !Checks.esNulo(usuarioLogado)) {
			llave.getAuditoria().setBorrado(true);
			llave.getAuditoria().setFechaBorrar(new Date());
			llave.getAuditoria().setUsuarioBorrar(usuarioLogado.getUsername());
		} else {
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createLlave(DtoLlaves dto) {

		ActivoLlave llave = new ActivoLlave();

		Filter activoIdFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdActivo()));
		Activo activo = genericDao.get(Activo.class, activoIdFilter);
		if (Checks.esNulo(activo)) {
			return false;
		}

		try {
			beanUtilNotNull.copyProperty(llave, "activo", activo);
			beanUtilNotNull.copyProperty(llave, "codCentroLlave", dto.getCodCentroLlave());
			beanUtilNotNull.copyProperty(llave, "nomCentroLlave", dto.getNomCentroLlave());
			beanUtilNotNull.copyProperty(llave, "archivo1", dto.getArchivo1());
			beanUtilNotNull.copyProperty(llave, "archivo2", dto.getArchivo2());
			beanUtilNotNull.copyProperty(llave, "archivo3", dto.getArchivo3());
			beanUtilNotNull.copyProperty(llave, "juegoCompleto", dto.getJuegoCompleto());
			if (!Checks.esNulo(dto.getJuegoCompleto()) && dto.getJuegoCompleto() == 0)
				beanUtilNotNull.copyProperty(llave, "motivoIncompleto", dto.getMotivoIncompleto());
			beanUtilNotNull.copyProperty(llave, "numLlave", dto.getNumLlave());

			llave = genericDao.save(ActivoLlave.class, llave);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
			return false;
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createMovimientoLlave(DtoMovimientoLlave dto) {

		ActivoMovimientoLlave movimiento = new ActivoMovimientoLlave();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdLlave()));
		ActivoLlave llave = genericDao.get(ActivoLlave.class, filtro);

		if (Checks.esNulo(llave)) {
			return false;
		}

		DDTipoTenedor tipoTenedor = (DDTipoTenedor) proxyFactory.proxy(UtilDiccionarioApi.class)
				.dameValorDiccionarioByCod(DDTipoTenedor.class, dto.getCodigoTipoTenedor());

		try {
			beanUtilNotNull.copyProperties(movimiento, dto);
			beanUtilNotNull.copyProperty(movimiento, "activoLlave", llave);
			beanUtilNotNull.copyProperty(movimiento, "tipoTenedor", tipoTenedor);

			genericDao.save(ActivoMovimientoLlave.class, movimiento);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
			return false;
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean saveMovimientoLlave(DtoMovimientoLlave dto) {

		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		ActivoMovimientoLlave movimiento = genericDao.get(ActivoMovimientoLlave.class, filtro);

		if (!Checks.esNulo(movimiento)) {
			try {

				beanUtilNotNull.copyProperties(movimiento, dto);

				if (!Checks.esNulo(dto.getCodigoTipoTenedor())) {
					DDTipoTenedor tipoTenedor = (DDTipoTenedor) proxyFactory.proxy(UtilDiccionarioApi.class)
							.dameValorDiccionarioByCod(DDTipoTenedor.class, dto.getCodigoTipoTenedor());
					movimiento.setTipoTenedor(tipoTenedor);
				}

				// Datos auditoria
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				if (!Checks.esNulo(usuarioLogado)) {
					movimiento.getAuditoria().setFechaModificar(new Date());
					movimiento.getAuditoria().setUsuarioModificar(usuarioLogado.getUsername());
				} else {
					return false;
				}

			} catch (IllegalAccessException e) {
				e.printStackTrace();
				return false;
			} catch (InvocationTargetException e) {
				e.printStackTrace();
				return false;
			}
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteMovimientoLlave(DtoMovimientoLlave dto) {

		if (Checks.esNulo(dto.getId())) {
			return false;
		}
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		ActivoMovimientoLlave movimiento = genericDao.get(ActivoMovimientoLlave.class, filtro);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		// Datos auditoria
		if (!Checks.esNulo(movimiento) && !Checks.esNulo(usuarioLogado)) {
			movimiento.getAuditoria().setBorrado(true);
			movimiento.getAuditoria().setFechaBorrar(new Date());
			movimiento.getAuditoria().setUsuarioBorrar(usuarioLogado.getUsername());
		} else {
			return false;
		}

		return true;
	}
	
	/**
	 * Realiza comprobaciones y acciones a realizar por los datos modificados en la Ficha Cabecera
	 * @param activo
	 * @param dtoFicha
	 */
	private void comprobacionesDatosFichaCabecera(Activo activo, DtoActivoFichaCabecera dtoFicha) {
		
		//Comprueba si ha habido cambios en el Tipo Comercializar para actualizar el gestor comercial de las tareas
		if(!Checks.esNulo(dtoFicha.getTipoComercializarCodigo())) {
			this.comprobacionCambioTipoComercializacion(activo);
		}
	}
	
	private void comprobacionCambioTipoComercializacion(Activo activo) {
		
		String codGestorSingular = "GCOMSIN", codGestorRetail = "GCOMRET";
		Boolean isActivoRetail = DDTipoComercializar.CODIGO_RETAIL.equals(activo.getTipoComercializar().getCodigo());
		
		//Comprobamos que se pueda realizar el cambio, analizando tareas activas comerciales y si hay gestor adecuado en el activo
		if(gestorActivoApi.existeGestorEnActivo(activo, isActivoRetail ? codGestorRetail : codGestorSingular)) {
			if(gestorActivoApi.validarTramitesNoMultiActivo(activo.getId()))
				gestorActivoApi.actualizarTareas(activo.getId());
			else {
				//El activo pertenece a un trámite multiactivo, y por tanto no se puede cambiar el gestor en las taras, enviamos un aviso al gestor comercial anterior
				//Si ahora el activo es Retail, entonces antes era Singular. Y viceversa.
				String codComercialAnterior = isActivoRetail ? "GCOMSIN" : "GCOMRET";
				Usuario usuario = gestorActivoApi.getGestorComercialActual(activo,codComercialAnterior); 
				
				if(!Checks.esNulo(usuario) && activoTareaExternaApi.existenTareasActivasByTramiteAndTipoGestor(activo, "T013", codComercialAnterior)) {
					Notificacion notif  = new Notificacion();
					String tipoComercialDesc = !isActivoRetail ? DDTipoComercializar.DESCRIPCION_SINGULAR : DDTipoComercializar.DESCRIPCION_RETAIL;
					String tipoComercialDescAnterior = isActivoRetail ? DDTipoComercializar.DESCRIPCION_SINGULAR : DDTipoComercializar.DESCRIPCION_RETAIL;
					String[] datosDescripcion = {activo.getNumActivo().toString(),tipoComercialDescAnterior,tipoComercialDesc};
					String descripcion = messageServices.getMessage(AVISO_MENSAJE_GESTOR_COMERCIAL, datosDescripcion);
					
					notif.setIdActivo(activo.getId());
					notif.setDestinatario(usuario.getId());
					notif.setTitulo(messageServices.getMessage(AVISO_TITULO_GESTOR_COMERCIAL));
					notif.setDescripcion(descripcion);
					notif.setFecha(null);
					try {
						anotacionApi.saveNotificacion(notif);
					} catch (ParseException e) {
						logger.error("No se ha podido enviar el aviso por no poder cambiar el gestor comercial en las tareas: " + e);
						e.printStackTrace();
					}
				}
			}
		}
	}
	
	private String getEstadoNuevaOferta(Activo activo) {
		String codigoEstado = DDEstadoOferta.CODIGO_PENDIENTE;

		// Comprobar si el activo se encuentra en una agrupación de tipo 'lote comercial'.
		// Y que tenga oferta aceptada de expediente con estasdo (aprobado, reservado, en devolución)
		if(activoAgrupacionActivoDao.activoEnAgrupacionLoteComercial(activo.getId()) ||
				ofertaApi.isActivoConOfertaYExpedienteBlocked(activo)) {
			codigoEstado = DDEstadoOferta.CODIGO_CONGELADA;
		}
		
		return codigoEstado;
	}
}
