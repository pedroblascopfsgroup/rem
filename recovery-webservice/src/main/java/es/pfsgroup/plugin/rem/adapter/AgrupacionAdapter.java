package es.pfsgroup.plugin.rem.adapter;

import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVFicheroDao;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberatorsFactory;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDEstadoProceso;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVProcesoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoHistoricoPatrimonioDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionDao;
import es.pfsgroup.plugin.rem.activo.valoracion.dao.ActivoValoracionDao;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.clienteComercial.dao.ClienteComercialDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionObservacion;
import es.pfsgroup.plugin.rem.model.ActivoAsistida;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoCaixa;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoObraNueva;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPromocionAlquiler;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProyecto;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoRestringida;
import es.pfsgroup.plugin.rem.model.ActivoRestringidaAlquiler;
import es.pfsgroup.plugin.rem.model.ActivoRestringidaObrem;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.AdjuntoComprador;
import es.pfsgroup.plugin.rem.model.AgrupacionesVigencias;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteCompradorGDPR;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionGridFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.DtoComercialAgrupaciones;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoEstadoDisponibilidadComercial;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoUsuario;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GestorActivo;
import es.pfsgroup.plugin.rem.model.InfoAdicionalPersona;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaExclusionBulk;
import es.pfsgroup.plugin.rem.model.OfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.TmpClienteGDPR;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VAgrupacionActivosGestorComercial;
import es.pfsgroup.plugin.rem.model.VBusquedaVisitasDetalle;
import es.pfsgroup.plugin.rem.model.VCalculosActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.VCambioActivoPrecioPublicacionAgrupaciones;
import es.pfsgroup.plugin.rem.model.VCondicionantesAgrDisponibilidad;
import es.pfsgroup.plugin.rem.model.VFechasPubCanalesAgr;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionIncAnuladas;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDClaseOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoObraNueva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoGestionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDResponsableDocumentacionCliente;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;
import es.pfsgroup.plugin.rem.oferta.NotificationOfertaManager;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.thread.AnyadirQuitarActivoAgrObREMAsync;
import es.pfsgroup.plugin.rem.thread.LiberarFichero;
import es.pfsgroup.plugin.rem.thread.ReactivarActivosAgrupacion;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.plugin.rem.utils.MSVREMUtils;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidator;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidatorFactoryApi;
import es.pfsgroup.plugin.rem.validate.BusinessValidators;
import es.pfsgroup.recovery.api.UsuarioApi;

@Service
public class AgrupacionAdapter {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private MSVFicheroDao ficheroDao;

	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Autowired
	private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;

	@Autowired
	protected JBPMProcessManagerApi jbpmProcessManagerApi;

	@Autowired
	protected TipoProcedimientoManager tipoProcedimiento;

	@Autowired
	private ProveedoresApi proveedoresApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	private List<AgrupacionAvisadorApi> avisadores;

	@Autowired
	private MSVLiberatorsFactory factoriaLiberators;

	@Autowired
	private AgrupacionValidatorFactoryApi agrupacionValidatorFactory;

	@Autowired
	private UpdaterStateApi updaterState;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private NotificationOfertaManager notificationOfertaManager;

	@Autowired
	private MSVREMUtils msvREMUtils;

	@Resource
	private MessageService messageServices;

	@Autowired
	private ProcessAdapter processAdapter;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;

	@Autowired
	private ParticularValidatorApi particularValidator;

	
	@Autowired
	private ActivoValoracionDao activoValoracionDao;

	@Autowired
	private ActivoPatrimonioDao activoPatrimonioDao;

	@Autowired
	private ActivoPublicacionDao activoPublicacionDao;

	@Autowired
	private ActivoHistoricoPatrimonioDao activoHistoricoPatrimonioDao;
	
	@Autowired
	private ClienteComercialDao clienteComercialDao;

	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	@Autowired
	private GestorDocumentalFotosApi gestorDocumentalFotos;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

	@Autowired
	private ActivoAgrupacionDao activoAgrupacionDao;


	private final Log logger = LogFactory.getLog(getClass());

	public static final String OFERTA_INCOMPATIBLE_AGR_MSG = "El tipo de oferta es incompatible con el destino comercial de algún activo";
	public static final String OFERTA_INCOMPATIBLE_TIPO_AGR_MSG = "oferta.incompatible.tipo.agrupacion";
	public static final String OFERTA_AGR_LOTE_COMERCIAL_GESTORES_NULL_MSG = "No se puede aceptar la oferta debido a que no se encuentran todos los gestores asignados";
	public static final String PUBLICACION_ACTIVOS_AGRUPACION_ERROR_MSG = "No ha sido posible publicar. Algún activo no tiene las condiciones necesarias";
	public static final String PUBLICACION_MOTIVO_MSG = "Publicado desde agrupación";
	public static final String PUBLICACION_AGRUPACION_BAJA_ERROR_MSG = "No ha sido posible publicar. La agrupación está dada de baja";
	public static final String AGRUPACION_BAJA_ERROR_OFERTAS_VIVAS = "No ha sido posible dar de baja la agrupación. Existen ofertas vivas";
	public static final String AGRUPACION_CAMBIO_DEST_COMERCIAL_CON_OFERTAS_VIVAS = "No se puede cambiar el destino comercial de la agrupación porque tiene ofertas vivas";
	private static final Integer NO_ES_FORMALIZABLE = new Integer(0);
	private static final Integer ES_FORMALIZABLE = new Integer(1);
	private static final String TIPO_AGRUPACION_RESTRINGIDA = "02";
	private static final String TIPO_AGRUPACION_RESTRINGIDA_ALQUILER = "17";
	private static final String TIPO_AGRUPACION_RESTRINGIDA_OBREM = "18";
	private static final String TIPO_COMERCIAL_VENTA = "Venta";
	private static final String TIPO_COMERCIAL_VENTA_CODIGO = "14";
	private static final String TIPO_COMERCIAL_ALQUILER = "Alquiler";
	private static final String TIPO_GESTOR_COMERCIAL_VENTA = "GCOM";
	private static final String TIPO_GESTOR_COMERCIAL_ALQUILER = "GESTCOMALQ";
	public static final String AGRUPACION_CAMBIO_DEST_COMERCIAL_A_VENTA_CON_ALQUILADOS = "No se puede realizar el cambio de destino comercial debido a que la agrupación tiene activos alquilados con título";
	private static final String usuarioSuper = "HAYASUPER";
	//Errores para la validacion de una agrupacion de PROMOCION DE ALQUILER
	public static final String EXISTEN_UAS_CON_OFERTAS_VIVAS  = "Error: Hay Unidades Alquilables con ofertas vivas";
	public static final String EXISTEN_UAS_CON_TRABAJOS_NO_FINALIZADOS  = "Error: Hay Unidades Alquilables con trabajos por finalizar";
	// Errores validacion ventaVivas
	private static final String ACTIVO_OFERTAS_VIVAS = "Activo con ofertas vivas";
	private static final String ACTIVO_NO_INCLUIDO_PERIMETRO_ALQUILER = "Activo NO incluido en perímetro de alquiler";
	private static final String ACTIVO_SIN_PATRIMONIO_ACTIVO = "El activo no tiene patrimonio activo";
	private static final String TIPO_NO_PERMITIDO_ACTIVO_MATRIZ = "Tipo de activo NO permitido como activo Activo matriz";
	private static final String ACTIVO_VENDIDO = "Activo vendido";
	private static final String ACTIVO_SIN_SITUACION_COMERCIAL = "El activo no tiene situación comercial";
	private static final String ACTIVO_FUERA_PERIMETRO_HAYA = "El activo fuera del perímetro HAYA";
	private static final String ACTIVO_INEXISTENTE = "Activo inexistente";
	private static final String ACTIVO_ALQUILADO = "Activo alquilado";
	private static final String ACTIVO_SIN_ESTADO_ALQUILER = "El activo no tiene estado de alquiler";
	private static final String ACTIVO_SIN_GESTORES = "El activo NO tiene gestores";
	private static final String ACTIVO_SIN_GESTION = "Este activo NO está bajo su gestión";
	private static final String ACTIVO_SIN_GESTORES_ADECUADOS = "Este activo NO tiene los gestores adecuados para añadirlo a matriz de alquiler";
	private static final String ACTIVO_FUERA_AGRUPACION = "El activo no se encuentra dentro de la agrupación";
	private static final String ACTIVO_NO_YUBAI = "El activo no es de Yubai";
	private static final String ACTIVO_NO_OBRA_NUEVA = "El activo no es de obra nueva";
	private static final String TIPO_COMERCIALIZACION_NO_VALIDO = "El tipo de comercialización no es válido.";
	private static final String SI = "Si";
	private static final String NO = "No";
	private static final String MAYORISTA = "Mayorista";
	private static final String MINORISTA = "Minorista";

	public static final String SPLIT_VALUE = ";s;";
	
	SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yy");


	public DtoAgrupaciones getAgrupacionById(Long id) {

		DtoAgrupaciones dtoAgrupacion = new DtoAgrupaciones();

		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);

		Activo activoCero = null;
		if (agrupacion.getActivos() != null && !agrupacion.getActivos().isEmpty()) {
			activoCero = agrupacion.getActivos().get(0).getActivo();
		}
		
		
		VCalculosActivoAgrupacion agrupacionVistaCalculado = genericDao.get(VCalculosActivoAgrupacion.class, 
				genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", agrupacion.getId()));

		try {
			BeanUtils.copyProperties(dtoAgrupacion, agrupacion);
			
			if (agrupacionVistaCalculado != null) {
				if (agrupacionVistaCalculado.getNumActivosPublicados() != null) {
					BeanUtils.copyProperty(dtoAgrupacion, "numeroPublicados", agrupacionVistaCalculado.getNumActivosPublicados());
				}
				if (agrupacionVistaCalculado.getNumActivos() != null) {
					BeanUtils.copyProperty(dtoAgrupacion, "numeroActivos", agrupacionVistaCalculado.getNumActivos());
				}				
			}
						
			if (agrupacion.getTipoAgrupacion() != null) {

				BeanUtils.copyProperty(dtoAgrupacion, "tipoAgrupacionDescripcion",
						agrupacion.getTipoAgrupacion().getDescripcion());
				BeanUtils.copyProperty(dtoAgrupacion, "tipoAgrupacionCodigo",
						agrupacion.getTipoAgrupacion().getCodigo());

				// Si es de tipo 'Lote Comercial'
				if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupacion.getTipoAgrupacion().getCodigo())
						|| DDTipoAgrupacion.AGRUPACION_COMERCIAL_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
					ActivoLoteComercial agrupacionTemp = (ActivoLoteComercial) agrupacion;

					BeanUtils.copyProperties(dtoAgrupacion, agrupacionTemp);

					if (agrupacionTemp.getLocalidad() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "municipioDescripcion",
								agrupacionTemp.getLocalidad().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "municipioCodigo",
								agrupacionTemp.getLocalidad().getCodigo());
					}


					if (agrupacionTemp.getProvincia() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaDescripcion",
								agrupacionTemp.getProvincia().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaCodigo",
								agrupacionTemp.getProvincia().getCodigo());
					}

					if (!Checks.esNulo(agrupacionTemp.getUsuarioGestoriaFormalizacion())) {
						BeanUtils.copyProperty(dtoAgrupacion, "codigoGestoriaFormalizacion",
								agrupacionTemp.getUsuarioGestoriaFormalizacion().getId());
					}

					if (!Checks.esNulo(agrupacionTemp.getUsuarioGestorComercial())) {
						BeanUtils.copyProperty(dtoAgrupacion, "codigoGestorComercial",
								agrupacionTemp.getUsuarioGestorComercial().getId());
					}

					if (!Checks.esNulo(agrupacionTemp.getUsuarioGestorFormalizacion())) {
						BeanUtils.copyProperty(dtoAgrupacion, "codigoGestorFormalizacion",
								agrupacionTemp.getUsuarioGestorFormalizacion().getId());
					}

					if (!Checks.esNulo(agrupacionTemp.getUsuarioGestorComercialBackOffice())) {
						BeanUtils.copyProperty(dtoAgrupacion, "codigoGestorComercialBackOffice",
								agrupacionTemp.getUsuarioGestorComercialBackOffice().getId());
					}
					
					BeanUtils.copyProperty(dtoAgrupacion, "activosGencat", activoAgrupacionApi.countActivosAfectoGENCAT(agrupacion));

					if (!Checks.esNulo(agrupacion.getTipoAlquiler())) {
						BeanUtils.copyProperty(dtoAgrupacion, "tipoAlquilerCodigo", agrupacion.getTipoAlquiler().getCodigo());
					}

					if(agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
						BeanUtils.copyProperty(dtoAgrupacion, "subTipoComercial", TIPO_COMERCIAL_VENTA);
					}
					else
					{
						BeanUtils.copyProperty(dtoAgrupacion, "subTipoComercial", TIPO_COMERCIAL_ALQUILER);
					}

					//cogemos el tipo de comercializacion y la cartera del activo principal
					Activo act = agrupacion.getActivoPrincipal();
					if(Checks.esNulo(act) && activoCero != null){
						act = activoCero;
						if(!Checks.esNulo(act.getCartera())){
							BeanUtils.copyProperty(dtoAgrupacion, "codigoCartera", act.getCartera().getCodigo());
						}
						if( act.getActivoPublicacion() != null && !Checks.esNulo(act.getActivoPublicacion().getTipoComercializacion())){
							BeanUtils.copyProperty(dtoAgrupacion, "tipoComercializacionCodigo", act.getActivoPublicacion().getTipoComercializacion().getCodigo());
							BeanUtils.copyProperty(dtoAgrupacion, "tipoComercializacionDescripcion", act.getActivoPublicacion().getTipoComercializacion().getDescripcion());
						}
					}

				}

				// Si es de tipo 'Asistida'.
				else if (DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
					ActivoAsistida agrupacionTemp = (ActivoAsistida) agrupacion;

					BeanUtils.copyProperties(dtoAgrupacion, agrupacionTemp);

					if (agrupacionTemp.getLocalidad() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "municipioDescripcion",
								agrupacionTemp.getLocalidad().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "municipioCodigo",
								agrupacionTemp.getLocalidad().getCodigo());
					}

					if (agrupacionTemp.getProvincia() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaDescripcion",
								agrupacionTemp.getProvincia().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaCodigo",
								agrupacionTemp.getProvincia().getCodigo());
					}

					BeanUtils.copyProperty(dtoAgrupacion, "fechaFinVigencia", agrupacionTemp.getFechaFinVigencia());
					BeanUtils.copyProperty(dtoAgrupacion, "fechaInicioVigencia",
							agrupacionTemp.getFechaInicioVigencia());
				}

				// SI ES TIPO OBRA NUEVA
				else if (DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(agrupacion.getTipoAgrupacion().getCodigo())) {	
					ActivoObraNueva agrupacionTemp = (ActivoObraNueva) agrupacion;

					BeanUtils.copyProperties(dtoAgrupacion, agrupacionTemp);

					if (agrupacionTemp.getLocalidad() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "municipioDescripcion",
								agrupacionTemp.getLocalidad().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "municipioCodigo",
								agrupacionTemp.getLocalidad().getCodigo());
					}

					if (agrupacionTemp.getProvincia() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaDescripcion",
								agrupacionTemp.getProvincia().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaCodigo",
								agrupacionTemp.getProvincia().getCodigo());
					}

					if (agrupacionTemp.getEstadoObraNueva() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "estadoObraNuevaCodigo",
								agrupacionTemp.getEstadoObraNueva().getCodigo());
					}
					
					if (!Checks.esNulo(agrupacionTemp.getVentaPlano())){
						if(DDSinSiNo.CODIGO_SI.equals(agrupacionTemp.getVentaPlano().getCodigo())) {
							beanUtilNotNull.copyProperty(dtoAgrupacion, "ventaSobrePlano", true);
						}else {
							beanUtilNotNull.copyProperty(dtoAgrupacion, "ventaSobrePlano", false);
						}		
						
					}
					
					Boolean esYubai = false;
					if ( ((agrupacion.getActivoPrincipal() != null)  
						&& DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(agrupacion.getActivoPrincipal().getCartera().getCodigo())
						&& DDSubcartera.CODIGO_YUBAI.equals(agrupacion.getActivoPrincipal().getSubcartera().getCodigo()))){
						esYubai = true;
					} else if  (!Checks.estaVacio((agrupacion.getActivos())) 
					&& !Checks.esNulo(activoCero)
					&& !Checks.esNulo(activoCero.getCartera()) 
					&& !Checks.esNulo(!Checks.esNulo(activoCero.getSubcartera()))
					&& DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(activoCero.getCartera().getCodigo())
					&& DDSubcartera.CODIGO_YUBAI.equals(activoCero.getSubcartera().getCodigo())) {
							esYubai = true;
					}
						
					if (esYubai) {
						if(!Checks.esNulo(agrupacion.isComercializableConsPlano())){
							dtoAgrupacion.setComercializableConsPlano(agrupacion.isComercializableConsPlano());
						}
						
						if(!Checks.esNulo(agrupacion.isExistePiloto()) && agrupacion.isExistePiloto()) {
							dtoAgrupacion.setExistePiloto(agrupacion.isExistePiloto());

							Activo pisoPiloto = activoAgrupacionActivoApi.getPisoPilotoByIdAgrupacion(agrupacion.getId());
							if(!Checks.esNulo(pisoPiloto) && !Checks.esNulo(pisoPiloto.getId()) && !Checks.esNulo(pisoPiloto.getNumActivo())) {
								dtoAgrupacion.setPisoPiloto(pisoPiloto.getNumActivo());
							}
						}
						if(!Checks.esNulo(agrupacion.isEsVisitable())) {
							dtoAgrupacion.setEsVisitable(agrupacion.isEsVisitable());
						}
					}
					dtoAgrupacion.setEsGestorComercialEnActivo(esGestorComercial(agrupacion));
					// SI ES TIPO RESTRINGIDA VENTA
				} else if (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
					ActivoRestringida agrupacionTemp = (ActivoRestringida) agrupacion;

					BeanUtils.copyProperties(dtoAgrupacion, agrupacionTemp);

					if (agrupacionTemp.getLocalidad() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "municipioDescripcion",
								agrupacionTemp.getLocalidad().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "municipioCodigo",
								agrupacionTemp.getLocalidad().getCodigo());
					}

					if (agrupacionTemp.getProvincia() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaDescripcion",
								agrupacionTemp.getProvincia().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaCodigo",
								agrupacionTemp.getProvincia().getCodigo());
					}

					
					BeanUtils.copyProperty(dtoAgrupacion, "activosGencat", activoAgrupacionApi.countActivosAfectoGENCAT(agrupacion));

					if (!Checks.esNulo(agrupacion.getActivoPrincipal())) {
						BeanUtils.copyProperty(dtoAgrupacion, "idNumActivoPrincipal",
								agrupacion.getActivoPrincipal().getNumActivo());
					}
					Activo act = agrupacion.getActivoPrincipal();
					if(act!=null){
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", act.getId());
						PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtro);
						if (perimetroActivo != null) {
							if (perimetroActivo.getCheckGestorComercial() != null) {
								BeanUtils.copyProperty(dtoAgrupacion, "visibleGestionComercial",
										Boolean.TRUE.equals(perimetroActivo.getCheckGestorComercial()));
							}
							if (perimetroActivo.getExcluirValidaciones() != null) {
								BeanUtils.copyProperty(dtoAgrupacion, "marcaDeExcluido", DDSinSiNo.CODIGO_SI.equals(perimetroActivo.getExcluirValidaciones().getCodigo()) ? true : false);
							}
							if (perimetroActivo.getMotivoGestionComercial() != null) {
								BeanUtils.copyProperty(dtoAgrupacion, "motivoDeExcluidoCodigo",
										perimetroActivo.getMotivoGestionComercial().getCodigo());
							}
						}
					}
									
					Activo activoPrincipal = agrupacion.getActivoPrincipal();
					if(!Checks.esNulo(activoPrincipal)) {
						dtoAgrupacion.setTipoComercializacionCodigo(activoPrincipal.getActivoPublicacion().getTipoComercializacion().getCodigo());
						
						//Cálculo color de los indicadores para activo principal.
						if(DDTipoComercializacion.CODIGO_VENTA.equals(dtoAgrupacion.getTipoComercializacionCodigo())){
							dtoAgrupacion.setEstadoVenta(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAgrupacionVenta(activoPrincipal));
						}else if(DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(dtoAgrupacion.getTipoComercializacionCodigo())){	
							dtoAgrupacion.setEstadoAlquiler(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAgrupacionAlquiler(activoPrincipal));
						}else if(DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(dtoAgrupacion.getTipoComercializacionCodigo())){
							dtoAgrupacion.setEstadoVenta(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAgrupacionVenta(activoPrincipal));
							dtoAgrupacion.setEstadoAlquiler(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAgrupacionAlquiler(activoPrincipal));
						}
					}

					// SI ES TIPO RESTRINGIDA ALQUILER
				} else if (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
					ActivoRestringidaAlquiler agrupacionTemp = (ActivoRestringidaAlquiler) agrupacion;

					BeanUtils.copyProperties(dtoAgrupacion, agrupacionTemp);

					if (agrupacionTemp.getLocalidad() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "municipioDescripcion",
								agrupacionTemp.getLocalidad().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "municipioCodigo",
								agrupacionTemp.getLocalidad().getCodigo());
					}

					if (agrupacionTemp.getProvincia() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaDescripcion",
								agrupacionTemp.getProvincia().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaCodigo",
								agrupacionTemp.getProvincia().getCodigo());
					}

					
					BeanUtils.copyProperty(dtoAgrupacion, "activosGencat", activoAgrupacionApi.countActivosAfectoGENCAT(agrupacion));

					if (!Checks.esNulo(agrupacion.getActivoPrincipal())) {
						BeanUtils.copyProperty(dtoAgrupacion, "idNumActivoPrincipal",
								agrupacion.getActivoPrincipal().getNumActivo());
					}
					Activo act = agrupacion.getActivoPrincipal();
					if(act!=null){
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", act.getId());
						PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtro);
						if (perimetroActivo != null) {
							if (perimetroActivo.getCheckGestorComercial() != null) {
								BeanUtils.copyProperty(dtoAgrupacion, "visibleGestionComercial",
										Boolean.TRUE.equals(perimetroActivo.getCheckGestorComercial()));
							}
							if (perimetroActivo.getExcluirValidaciones() != null) {
								BeanUtils.copyProperty(dtoAgrupacion, "marcaDeExcluido", DDSinSiNo.CODIGO_SI.equals(perimetroActivo.getExcluirValidaciones().getCodigo()) ? true : false);
							}
							if (perimetroActivo.getMotivoGestionComercial() != null) {
								BeanUtils.copyProperty(dtoAgrupacion, "motivoDeExcluidoCodigo",
										perimetroActivo.getMotivoGestionComercial().getCodigo());
							}
						}
					}
									
					Activo activoPrincipal = agrupacion.getActivoPrincipal();
					if(!Checks.esNulo(activoPrincipal)) {
						dtoAgrupacion.setTipoComercializacionCodigo(activoPrincipal.getActivoPublicacion().getTipoComercializacion().getCodigo());
						
						//Cálculo color de los indicadores para activo principal.
						if(DDTipoComercializacion.CODIGO_VENTA.equals(dtoAgrupacion.getTipoComercializacionCodigo())){
							dtoAgrupacion.setEstadoVenta(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAgrupacionVenta(activoPrincipal));
						}else if(DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(dtoAgrupacion.getTipoComercializacionCodigo())){	
							dtoAgrupacion.setEstadoAlquiler(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAgrupacionAlquiler(activoPrincipal));
						}else if(DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(dtoAgrupacion.getTipoComercializacionCodigo())){
							dtoAgrupacion.setEstadoVenta(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAgrupacionVenta(activoPrincipal));
							dtoAgrupacion.setEstadoAlquiler(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAgrupacionAlquiler(activoPrincipal));
						}
					}

					// SI ES TIPO RESTRINGIDA OBREM
				} else if (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
					ActivoRestringidaObrem agrupacionTemp = (ActivoRestringidaObrem) agrupacion;

					BeanUtils.copyProperties(dtoAgrupacion, agrupacionTemp);

					if (agrupacionTemp.getLocalidad() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "municipioDescripcion",
								agrupacionTemp.getLocalidad().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "municipioCodigo",
								agrupacionTemp.getLocalidad().getCodigo());
					}

					if (agrupacionTemp.getProvincia() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaDescripcion",
								agrupacionTemp.getProvincia().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaCodigo",
								agrupacionTemp.getProvincia().getCodigo());
					}

					
					BeanUtils.copyProperty(dtoAgrupacion, "activosGencat", activoAgrupacionApi.countActivosAfectoGENCAT(agrupacion));

					if (!Checks.esNulo(agrupacion.getActivoPrincipal())) {
						BeanUtils.copyProperty(dtoAgrupacion, "idNumActivoPrincipal",
								agrupacion.getActivoPrincipal().getNumActivo());
					}
					Activo act = agrupacion.getActivoPrincipal();
					if(act!=null){
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", act.getId());
						PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtro);
						if (perimetroActivo != null) {
							if (perimetroActivo.getCheckGestorComercial() != null) {
								BeanUtils.copyProperty(dtoAgrupacion, "visibleGestionComercial",
										Boolean.TRUE.equals(perimetroActivo.getCheckGestorComercial()));
							}
							if (perimetroActivo.getExcluirValidaciones() != null) {
								BeanUtils.copyProperty(dtoAgrupacion, "marcaDeExcluido", DDSinSiNo.CODIGO_SI.equals(perimetroActivo.getExcluirValidaciones().getCodigo()) ? true : false);
							}
							if (perimetroActivo.getMotivoGestionComercial() != null) {
								BeanUtils.copyProperty(dtoAgrupacion, "motivoDeExcluidoCodigo",
										perimetroActivo.getMotivoGestionComercial().getCodigo());
							}
						}
					}
									
					Activo activoPrincipal = agrupacion.getActivoPrincipal();
					if(!Checks.esNulo(activoPrincipal)) {
						dtoAgrupacion.setTipoComercializacionCodigo(activoPrincipal.getActivoPublicacion().getTipoComercializacion().getCodigo());
						
						//Cálculo color de los indicadores para activo principal.
						if(DDTipoComercializacion.CODIGO_VENTA.equals(dtoAgrupacion.getTipoComercializacionCodigo())){
							dtoAgrupacion.setEstadoVenta(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAgrupacionVenta(activoPrincipal));
						}else if(DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(dtoAgrupacion.getTipoComercializacionCodigo())){	
							dtoAgrupacion.setEstadoAlquiler(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAgrupacionAlquiler(activoPrincipal));
						}else if(DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(dtoAgrupacion.getTipoComercializacionCodigo())){
							dtoAgrupacion.setEstadoVenta(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAgrupacionVenta(activoPrincipal));
							dtoAgrupacion.setEstadoAlquiler(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAgrupacionAlquiler(activoPrincipal));
						}
					}

				// SI ES TIPO PROYECTO
				} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_PROYECTO)) {
					ActivoProyecto proyectoTemp = (ActivoProyecto) agrupacion;

					BeanUtils.copyProperties(dtoAgrupacion, proyectoTemp);

					if (proyectoTemp.getLocalidad() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "municipioDescripcion", proyectoTemp.getLocalidad().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "municipioCodigo", proyectoTemp.getLocalidad().getCodigo());
					}

					if (proyectoTemp.getProvincia() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaDescripcion", proyectoTemp.getProvincia().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaCodigo", proyectoTemp.getProvincia().getCodigo());
					}

					if (proyectoTemp.getDobleGestorActivo() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "codigoGestorDobleActivo", proyectoTemp.getDobleGestorActivo().getId());
					}

					if (proyectoTemp.getGestorActivo() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "codigoGestorActivo", proyectoTemp.getGestorActivo().getId());
					}

					if (proyectoTemp.getCodigoPostal() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "codigoPostal", proyectoTemp.getCodigoPostal());
					}
					if (proyectoTemp.getEstadoActivo() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "estadoActivoCodigo", proyectoTemp.getEstadoActivo().getCodigo());
						dtoAgrupacion.setEstadoActivoCodigo(proyectoTemp.getEstadoActivo().getCodigo());
					}

					if (proyectoTemp.getTipoActivo()!= null) {
						BeanUtils.copyProperty(dtoAgrupacion, "tipoActivoCodigo", proyectoTemp.getTipoActivo().getCodigo());
					}

					if (proyectoTemp.getSubtipoActivo() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "subtipoActivoCodigo", proyectoTemp.getSubtipoActivo().getCodigo());
					}

					if (proyectoTemp.getGestorcomercial() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "codigoGestorComercial", proyectoTemp.getGestorcomercial().getId());
					}

					if (proyectoTemp.getCartera() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "cartera", proyectoTemp.getCartera().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "codigoCartera", proyectoTemp.getCartera().getCodigo());
					}
					
				} //SI ES DE TIPO COMERCIAL ALQUILER
				else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER)) {
					
					if(activoCero != null){
						BeanUtils.copyProperty(dtoAgrupacion, "cartera", activoCero.getCartera().getDescripcion());
					}

				} // SI ES TIPO PROMOCION ALQUILER 
				else if(agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER)) {


					ActivoPromocionAlquiler agrupacionTemp = (ActivoPromocionAlquiler) agrupacion;
					Activo am = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(id);
					
					BeanUtils.copyProperties(dtoAgrupacion, agrupacionTemp);
					
					if(!Checks.esNulo(am)) {
						BeanUtils.copyProperty(dtoAgrupacion, "activoMatriz", am.getNumActivo());
						BeanUtils.copyProperty(dtoAgrupacion, "codigoPostal", am.getCodPostal());
						BeanUtils.copyProperty(dtoAgrupacion, "municipioCodigo", am.getMunicipio());
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaCodigo", am.getProvincia());
						if(!Checks.esNulo(am.getLocalizacion().getLocalizacionBien().getProvincia())) {
							BeanUtils.copyProperty(dtoAgrupacion, "provinciaDescripcion", am.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion());
						}
							
						if(!Checks.esNulo(am.getLocalizacion().getLocalizacionBien().getLocalidad())) {
							BeanUtils.copyProperty(dtoAgrupacion, "municipioDescripcion", am.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion());
						}
					}
				
				}

				// TODO: Hacer cuando esté listo el activo principal dentro de
				// la agrupación

				Activo activoPrincipal = agrupacion.getActivoPrincipal();
				if(activoPrincipal != null) {
					PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activoPrincipal.getId());
					
					if(!Checks.esNulo(activoPrincipal.getSubcartera())){
						BeanUtils.copyProperty(dtoAgrupacion, "codSubcartera", activoPrincipal.getSubcartera().getCodigo());
					}
					
					if (perimetroActivo != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "incluidoEnPerimetro", perimetroActivo.getIncluidoEnPerimetro() == 1);
					}

					if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)
							|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)
							|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {
						boolean esMismoDestinoComercial = false;
						esMismoDestinoComercial = activoAgrupacionActivoDao.isTipoComercializacionesAgrupaciones(agrupacion.getId());						

						if (esMismoDestinoComercial) {
							if (activoPrincipal.getActivoPublicacion().getTipoComercializacion() != null) {
								BeanUtils.copyProperty(dtoAgrupacion, "tipoComercializacionDescripcion", activoPrincipal.getActivoPublicacion().getTipoComercializacion().getDescripcion());
							}
						} else {
							BeanUtils.copyProperty(dtoAgrupacion, "tipoComercializacionDescripcion", "El destino comercial es incoherente");
						}

						BeanUtils.copyProperty(dtoAgrupacion, "tipoComercializacionCodigo", activoPrincipal.getActivoPublicacion().getTipoComercializacion().getCodigo());

						if (!Checks.esNulo(agrupacion.getFechaBaja())) {
							BeanUtils.copyProperty(dtoAgrupacion, "estadoAlquilerDescripcion", !Checks.esNulo(activoPrincipal.getActivoPublicacion().getEstadoPublicacionAlquiler()) ? DDEstadoPublicacionAlquiler.DESCRIPCION_NO_PUBLICADO_ALQUILER : "");
							BeanUtils.copyProperty(dtoAgrupacion, "estadoVentaDescripcion", !Checks.esNulo(activoPrincipal.getActivoPublicacion().getEstadoPublicacionVenta()) ? DDEstadoPublicacionVenta.DESCRIPCION_NO_PUBLICADO_VENTA : "");
							BeanUtils.copyProperty(dtoAgrupacion, "estadoAlquilerCodigo", !Checks.esNulo(activoPrincipal.getActivoPublicacion().getEstadoPublicacionAlquiler()) ? DDEstadoPublicacionAlquiler.CODIGO_NO_PUBLICADO_ALQUILER : "");
							BeanUtils.copyProperty(dtoAgrupacion, "estadoVentaCodigo", !Checks.esNulo(activoPrincipal.getActivoPublicacion().getEstadoPublicacionVenta()) ? DDEstadoPublicacionVenta.CODIGO_NO_PUBLICADO_VENTA : "");
						} else if (!Checks.esNulo(activoPrincipal.getActivoPublicacion())) {
							BeanUtils.copyProperty(dtoAgrupacion, "estadoAlquilerDescripcion", !Checks.esNulo(activoPrincipal.getActivoPublicacion().getEstadoPublicacionAlquiler()) ? activoPrincipal.getActivoPublicacion().getEstadoPublicacionAlquiler().getDescripcion() : "");
							BeanUtils.copyProperty(dtoAgrupacion, "estadoVentaDescripcion", !Checks.esNulo(activoPrincipal.getActivoPublicacion().getEstadoPublicacionVenta()) ? activoPrincipal.getActivoPublicacion().getEstadoPublicacionVenta().getDescripcion() : "");
							BeanUtils.copyProperty(dtoAgrupacion, "estadoAlquilerCodigo", !Checks.esNulo(activoPrincipal.getActivoPublicacion().getEstadoPublicacionAlquiler()) ? activoPrincipal.getActivoPublicacion().getEstadoPublicacionAlquiler().getCodigo() : "");
							BeanUtils.copyProperty(dtoAgrupacion, "estadoVentaCodigo", !Checks.esNulo(activoPrincipal.getActivoPublicacion().getEstadoPublicacionVenta()) ? activoPrincipal.getActivoPublicacion().getEstadoPublicacionVenta().getCodigo() : "");
						}

						if (!Checks.esNulo(activoPrincipal.getTipoActivo())){
							BeanUtils.copyProperty(dtoAgrupacion, "tipoActivoPrincipalCodigo", activoPrincipal.getTipoActivo().getCodigo());
						}
					} else {
						if (activoPrincipal.getActivoPublicacion().getTipoComercializacion() != null) {
							BeanUtils.copyProperty(dtoAgrupacion, "tipoComercializacionDescripcion", activoPrincipal.getActivoPublicacion().getTipoComercializacion().getDescripcion());
							BeanUtils.copyProperty(dtoAgrupacion, "tipoComercializacionCodigo", activoPrincipal.getActivoPublicacion().getTipoComercializacion().getCodigo());
						}
					}

					if (!activoPrincipal.getPropietariosActivo().isEmpty()) {
						ActivoPropietario propietario = activoPrincipal.getPropietarioPrincipal();
						if (Checks.esNulo(propietario)) {
							BeanUtils.copyProperty(dtoAgrupacion, "propietario", propietario.getFullName());
						}
					}
				
					if (!Checks.esNulo(activoPrincipal.getCartera()) && !DDTipoAgrupacion.AGRUPACION_PROYECTO.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
						BeanUtils.copyProperty(dtoAgrupacion, "cartera", activoPrincipal.getCartera().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "codigoCartera", activoPrincipal.getCartera().getCodigo());

					} else if (!Checks.esNulo(agrupacion.getActivos()) && !agrupacion.getActivos().isEmpty() && !Checks.esNulo(activoCero.getCartera()) && !DDTipoAgrupacion.AGRUPACION_PROYECTO.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
						BeanUtils.copyProperty(dtoAgrupacion, "cartera", activoCero.getCartera().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "codigoCartera", activoCero.getCartera().getCodigo());
					}
					
					
					if(agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {			
						Filter filtroActPr = genericDao.createFilter(FilterType.EQUALS, "activo.id",
								activoPrincipal.getId());
						PerimetroActivo periAGA = genericDao.get(PerimetroActivo.class, filtroActPr);
						if(periAGA!= null && periAGA.getCheckGestorComercial()!= null && periAGA.getCheckGestorComercial()) {
							BeanUtils.copyProperty(dtoAgrupacion, "visibleGestionComercial",
								Boolean.TRUE.equals(periAGA.getCheckGestorComercial()));
						}
					}


				}else{
					 if (!Checks.esNulo(activoCero) && !Checks.esNulo(activoCero.getCartera()) && !DDTipoAgrupacion.AGRUPACION_PROYECTO.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
						BeanUtils.copyProperty(dtoAgrupacion, "cartera", activoCero.getCartera().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "codigoCartera", activoCero.getCartera().getCodigo());
					}
					 if(activoCero != null && !Checks.esNulo(activoCero.getSubcartera())){
						 BeanUtils.copyProperty(dtoAgrupacion, "codSubcartera", activoCero.getSubcartera().getCodigo());
					 }
					 if (!agrupacion.getActivos().isEmpty() && !Checks.esNulo(activoCero) && activoCero.getActivoPublicacion().getTipoComercializacion() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "tipoComercializacionDescripcion", activoCero.getActivoPublicacion().getTipoComercializacion().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "tipoComercializacionCodigo", activoCero.getActivoPublicacion().getTipoComercializacion().getCodigo());
					}
				}
				
				VCambioActivoPrecioPublicacionAgrupaciones vistaCambio = genericDao.get(VCambioActivoPrecioPublicacionAgrupaciones.class,
						genericDao.createFilter(FilterType.EQUALS, "id", agrupacion.getId()));
				if (vistaCambio != null) {
					dtoAgrupacion.setCambioEstadoActivo(vistaCambio.getCambioEstadoActivo());
					dtoAgrupacion.setCambioEstadoPrecio(vistaCambio.getCambioEstadoPrecio());
					dtoAgrupacion.setCambioEstadoPublicacion(vistaCambio.getCambioEstadoPublicacion());
				}				
				// Resolvemos si la agrupación será editable
				dtoAgrupacion.setEsEditable(true);
				if (!Checks.esNulo(agrupacion.getFechaBaja())) {
					dtoAgrupacion.setEsEditable(false);
				}

				// Si tiene alguna oferta != Estado.Rechazada ==> No se pueden
				// anyadir activos
				BeanUtils.copyProperty(dtoAgrupacion, "existenOfertasVivas", this.existenOfertasActivasEnAgrupacion(id));

				// Para permitir un nulo en isFormalizacion
				if (agrupacion.getIsFormalizacion() == null) {
					dtoAgrupacion.setIsFormalizacion(null);
				}

				if (!Checks.esNulo(agrupacion.getActivoAutorizacionTramitacionOfertas())) {
					beanUtilNotNull.copyProperty(dtoAgrupacion, "motivoAutorizacionTramitacionCodigo", agrupacion.getActivoAutorizacionTramitacionOfertas().getMotivoAutorizacionTramitacion().getCodigo());
					beanUtilNotNull.copyProperty(dtoAgrupacion, "observacionesAutoTram", agrupacion.getActivoAutorizacionTramitacionOfertas().getObservacionesAutoTram());
				}
				dtoAgrupacion.setTramitable(activoAgrupacionApi.isTramitable(agrupacion));
			}

		} catch (IllegalAccessException e) {
			logger.error("error en agrupacionAdapter", e);
		} catch (InvocationTargetException e) {
			logger.error("error en agrupacionAdapter", e);
		}

		return dtoAgrupacion;

	}



	public Long getAgrupacionIdByNumAgrupRem(Long numAgrupRem) {
		return activoAgrupacionApi.getAgrupacionIdByNumAgrupRem(numAgrupRem);
	}

	public Page getListActivosAgrupacionById(DtoAgrupacionFilter filtro, Long id,Boolean little) {
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		filtro.setAgrupacionId(String.valueOf(id));
		
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER)) {
			if(!Checks.esNulo(agrupacion.getActivos())) {
				for(ActivoAgrupacionActivo activo : agrupacion.getActivos()) {
					// Actualizar el tipoComercialización del activo
					if(activoDao.isUnidadAlquilable(activo.getActivo().getId()) && Checks.esNulo(activo.getActivo().getTipoComercializar())) {
						updaterState.updaterStateTipoComercializacion(activo.getActivo());
					}
				}
			}
		}
		
		try {
			Page listaActivos = activoAgrupacionApi.getListActivosAgrupacionById(filtro, usuarioLogado,little);
			
			return listaActivos;
		} catch (Exception e) {
			logger.error("error en agrupacionAdapter", e);
			return null;
		}
	}

	public DtoEstadoDisponibilidadComercial getListActivosAgrupacion(DtoAgrupacionFilter filtro, Long id) {

		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if(!Checks.esNulo(id)) {
			filtro.setAgrupacionId(String.valueOf(id));
		}

		try {
			DtoEstadoDisponibilidadComercial listaActivos = activoAgrupacionApi.getListActivosAgrupacionByIdActivo(filtro, usuarioLogado);
			return listaActivos;
		} catch (Exception e) {
			logger.error("error en agrupacionAdapter", e);
			return null;
		}
	}
	
	public Page getBusquedaAgrupacionesGrid(DtoAgrupacionGridFilter dto) {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		if (usuarioCartera != null) {
			dto.setCarteraCodigo(usuarioCartera.getCartera().getCodigo());
			if (usuarioCartera.getSubCartera() != null) {
				dto.setSubcarteraCodigo(usuarioCartera.getSubCartera().getCodigo());
			}
		}
		return activoAgrupacionDao.getBusquedaAgrupacionesGrid(dto);		
	}

	public Page getListAgrupaciones(DtoAgrupacionFilter dtoAgrupacionFilter) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
				
		if (!Checks.esNulo(usuarioCartera)){
			if(!Checks.esNulo(usuarioCartera.getSubCartera())){
				dtoAgrupacionFilter.setCodCartera(usuarioCartera.getCartera().getCodigo());
				dtoAgrupacionFilter.setSubcarteraCodigo(usuarioCartera.getSubCartera().getCodigo());
			}else{
				dtoAgrupacionFilter.setCodCartera(usuarioCartera.getCartera().getCodigo());
			}
		}

		Page temp = (Page) activoAgrupacionApi.getListAgrupaciones(dtoAgrupacionFilter, usuarioLogado);
		return temp;

	}

	public Object getAgrupacionByIdParcial(Long id, int pestana) {

		Activo activo = activoApi.get(id);

		// Pestaña 1: Ficha
		// Seteamos los campos a mano que no pueden copiarse con el
		// copyProperties debido a las referencias
		try {
			// 1: Cabecera
			if (pestana == 1) {

				DtoActivoFichaCabecera activoDto = new DtoActivoFichaCabecera();

				BeanUtils.copyProperties(activoDto, activo);
				if (activo.getLocalizacion() != null) {
					BeanUtils.copyProperties(activoDto, activo.getLocalizacion().getLocalizacionBien());
					BeanUtils.copyProperties(activoDto, activo.getLocalizacion());

					if (activo.getLocalizacion().getLocalizacionBien() != null
							&& activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null) {
						BeanUtils.copyProperty(activoDto, "tipoViaCodigo",
								activo.getLocalizacion().getLocalizacionBien().getTipoVia().getCodigo());
					}
					if (activo.getLocalizacion().getLocalizacionBien() != null
							&& activo.getLocalizacion().getLocalizacionBien().getPais() != null) {
						BeanUtils.copyProperty(activoDto, "paisCodigo",
								activo.getLocalizacion().getLocalizacionBien().getPais().getCodigo());
					}
					if (activo.getLocalizacion().getLocalizacionBien() != null
							&& activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null) {
						BeanUtils.copyProperty(activoDto, "municipioCodigo",
								activo.getLocalizacion().getLocalizacionBien().getLocalidad().getCodigo());
					}
					if (activo.getLocalizacion().getLocalizacionBien() != null
							&& activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional() != null) {
						BeanUtils.copyProperty(activoDto, "inferiorMunicipioCodigo",
								activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional().getCodigo());
					}
					if (activo.getLocalizacion().getLocalizacionBien() != null
							&& activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null
							&& activo.getLocalizacion().getLocalizacionBien().getLocalidad().getProvincia() != null) {
						BeanUtils.copyProperty(activoDto, "provinciaCodigo", activo.getLocalizacion()
								.getLocalizacionBien().getLocalidad().getProvincia().getCodigo());
					}

				}

				return activoDto;

			} else {

				DtoActivoFichaCabecera activoDto = new DtoActivoFichaCabecera();
				BeanUtils.copyProperties(activoDto, activo);
				return activoDto;

			}
		} catch (Exception e) {
			logger.error("error en agrupacionAdapter", e);
			return null;
		}

	}

	@Transactional(readOnly = false)
	public void createActivoAgrupacion(Long numActivo, Long idAgrupacion, Integer activoPrincipal, boolean ventaCartera)
			throws JsonViewerException, IllegalAccessException, InvocationTargetException {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo);
		Activo activo = genericDao.get(Activo.class, filter);
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(idAgrupacion);

		// Validaciones
		if (Checks.esNulo(agrupacion)) {
			throw new JsonViewerException("La agrupación no existe");
		}

		int num = activoAgrupacionActivoApi.numActivosPorActivoAgrupacion(agrupacion.getId());

		if (Checks.esNulo(activo)) {
			throw new JsonViewerException("El activo no existe");
		}

		Filter filterAga = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", agrupacion.getId());
		List <ActivoAgrupacionActivo> activoAgrupacion = genericDao.getList(ActivoAgrupacionActivo.class, filterAga);
		
		if (activoAgrupacion != null) {
			for (ActivoAgrupacionActivo activoAgrupacionActivo : activoAgrupacion) {
				if (activoAgrupacionActivo != null) {
					if (activoAgrupacionActivo.getActivo().getNumActivo().equals(activo.getNumActivo())) {
						throw new JsonViewerException("El activo se encuentra en la agrupacion");
					}
				}
			}
		}
		
		if (activo != null && activo.getNumActivo() != null) {
			if (agrupacion != null && 
					(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())
							|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())
							|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(agrupacion.getTipoAgrupacion().getCodigo()))) {
				if (activo.getCartera().getCodigo() != null && DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) {
					throw new JsonViewerException(BusinessValidators.ERROR_ACTIVO_CARTERA_BANKIA_TO_AGR_RESTRINGIDAS);
				}
			}
		}

		if (!Checks.esNulo(numActivo)) {
			if (!DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())
					&& !particularValidator.esActivoIncluidoPerimetro(Long.toString(numActivo))) {
				throw new JsonViewerException("El activo se encuetra fuera del perímetro HAYA");
			} else if (DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())
					&& particularValidator.esActivoIncluidoPerimetro(Long.toString(numActivo))) {
				throw new JsonViewerException("El activo se encuetra dentro del perímetro HAYA");
			}
		}

		if (!Checks.esNulo(agrupacion) && !Checks.esNulo(numActivo) && !Checks.esNulo(activo)) {

			// Agrupacion Comercial
			if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA.equals(agrupacion.getTipoAgrupacion().getCodigo())
					|| DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER
							.equals(agrupacion.getTipoAgrupacion().getCodigo())) {

				// El activo no es comercializable
				if (particularValidator.isActivoNoComercializable(Long.toString(numActivo))) {
					throw new JsonViewerException("El activo no es comercializable");
				}

				// El activo ya esta en una agrupacion comercial viva
				if (particularValidator.activoEnAgrupacionComercialViva(Long.toString(numActivo))) {
					throw new JsonViewerException("El activo está incluido en otro lote comercial vivo");
				}

				// Agrupacion Comercial - Alquiler
				if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER
						.equals(agrupacion.getTipoAgrupacion().getCodigo())) {

					// El activo tiene ofertas vivas
					if (particularValidator.existeActivoConExpedienteComercialVivo(Long.toString(numActivo))) {
						throw new JsonViewerException("El activo tiene ofertas individuales vivas");
					}

					// El activo es de alquiler
					if (DDTipoComercializacion.CODIGO_SOLO_ALQUILER
							.equals(activo.getActivoPublicacion().getTipoComercializacion().getCodigo())
							|| DDTipoComercializacion.CODIGO_ALQUILER_VENTA
									.equals(activo.getActivoPublicacion().getTipoComercializacion().getCodigo())) {

						// El activo esta alquilado
						if (particularValidator.esActivoAlquilado(Long.toString(numActivo))) {
							throw new JsonViewerException("El activo está alquilado");
						}

						// El tipo de alquiler de la agrupacion es null OR
						// El tipo de alquiler del activo es distinto al de la
						// agrupacion(Comercial - Alquiler)
						if (Checks.esNulo(agrupacion.getTipoAlquiler()) || (!Checks.esNulo(activo.getTipoAlquiler())
								&& !Checks.esNulo(agrupacion.getTipoAlquiler()) && !activo.getTipoAlquiler().getCodigo()
										.equals(agrupacion.getTipoAlquiler().getCodigo()))) {
							throw new JsonViewerException(
									"El tipo de alquiler del activo es distinto al de la agrupación");
						}
					}
				}

			}

			if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA.equals(agrupacion.getTipoAgrupacion().getCodigo())) {

				// existeOfertaAprobadaActivo
				// El activo tiene ofertas vivas
				if (particularValidator.existeOfertaAprobadaActivo(Long.toString(numActivo))) {
					throw new JsonViewerException("El activo tiene ofertas individuales vivas");
				}

				if (DDTipoComercializacion.CODIGO_SOLO_ALQUILER
						.equals(activo.getActivoPublicacion().getTipoComercializacion().getCodigo())) {
					throw new JsonViewerException(
							"El destino comercial del activo no coincide con el de la agrupación");
				}

			} else if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER
					.equals(agrupacion.getTipoAgrupacion().getCodigo())) {

				if (DDTipoComercializacion.CODIGO_VENTA
						.equals(activo.getActivoPublicacion().getTipoComercializacion().getCodigo())) {
					throw new JsonViewerException(
							"El destino comercial del activo no coincide con el de la agrupación");
				} else if (!Checks.esNulo(activo.getTipoAlquiler()) && !Checks.esNulo(agrupacion.getTipoAlquiler())) {
					if (!activo.getTipoAlquiler().getCodigo().equals(agrupacion.getTipoAlquiler().getCodigo())) {
						throw new JsonViewerException("El tipo de alquiler del activo es distinto al de la agrupación");
					}
				} else if (particularValidator.esActivoAlquilado(Long.toString(numActivo))) {
					throw new JsonViewerException("El activo está alquilado");
				}
			}
		}

		if (!Checks.esNulo(numActivo)) {
			if (particularValidator.activoEnAgrupacionComercialViva(Long.toString(numActivo))) {
				throw new JsonViewerException("El activo está incluido en otro lote comercial vivo");
			}
		}

		// Si el activo es de Liberbank, además debe ser de la misma subcartera
		if ((DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())
				|| DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo()))
				&& !Checks.estaVacio(agrupacion.getActivos())) {
			if (!Checks.esNulo(activo.getSubcartera())) {
				if (!agrupacion.getActivos().get(0).getActivo().getSubcartera().equals(activo.getSubcartera())) {
					throw new JsonViewerException(
							"El activo añadido tiene que tener la misma subcartera que los ya existentes");
				}
			} else {
				throw new JsonViewerException("El activo no se puede añadir por que no tiene subcartera");

			}
		}

		// Si la agrupación es asistida, el activo además de existir tiene
		// que ser asistido.
		if (DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			if (!activoApi.isActivoAsistido(activo)) {
				throw new JsonViewerException(AgrupacionValidator.ERROR_NOT_ASISTIDA);
			}
			// el activo no puede estar en otra agrupación asistida vigente
			if (activoAgrupacionApi.estaActivoEnOtraAgrupacionVigente(agrupacion, activo)) {
				throw new JsonViewerException(AgrupacionValidator.ERROR_EN_OTRA_ASISTIDA);
			}
		}

		if (DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(agrupacion.getTipoAgrupacion().getCodigo())
				&& activoApi.isActivoAsistido(activo)) {
			throw new JsonViewerException(AgrupacionValidator.ERROR_OBRANUEVA_NO_ASISTIDA);
		}

		// Si la agrupación es de tipo comercial y contiene ofertas, en
		// cualquier estado, rechazar el activo.
		if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupacion.getTipoAgrupacion().getCodigo())
				|| DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER
						.equals(agrupacion.getTipoAgrupacion().getCodigo())) {

			// Comprobamos no mezclar activos canarios y peninsulares
			distintosTiposImpuesto(agrupacion, activo);

			// Comprobamos que los activos son del mismo propietario
			comprobarDistintoPropietario(agrupacion, activo);

			List<Oferta> ofertasAgrupacion = agrupacion.getOfertas();
			if (tieneOfertasNoAnuladas(ofertasAgrupacion)) {
				throw new JsonViewerException(
						"No se puede alterar el listado de activos cuando la agrupación tiene ofertas");
			}
			// Si el activo es de tipo Formalizable, pero la agrupación en
			// la que lo vamos a meter NO lo es, lanzamos una Excepcion
			// Si el activo es no Formalizable, pero la agrupación en la que
			// lo vamos a meter SI que lo es, también lanzamos una Excepcion
			if (activoApi.esActivoFormalizable(activo.getNumActivo())
					&& NO_ES_FORMALIZABLE.equals(agrupacion.getIsFormalizacion())
					|| !activoApi.esActivoFormalizable(activo.getNumActivo())
							&& ES_FORMALIZABLE.equals(agrupacion.getIsFormalizacion())) {
				throw new JsonViewerException(AgrupacionValidator.ERROR_ACTIVO_NO_COMPARTE_FORMALIZACION);
			}

		}
		// Si es el primer activo, validamos si tenemos los datos necesarios
		// del activo, y modificamos la agrupación con esos datos
		if (num == 0) {
			activoAgrupacionValidate(activo, agrupacion);
			agrupacion = updateAgrupacionPrimerActivo(activo, agrupacion);
			activoAgrupacionApi.saveOrUpdate(agrupacion);
		}

		// Validaciones de agrupación
		agrupacionValidate(activo, agrupacion);

		if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupacion.getTipoAgrupacion().getCodigo())
				|| DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER
						.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			saveAgrupacionLoteComercial(activo, agrupacion);			
		} else if((DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupacion.getTipoAgrupacion().getCodigo()) ||
				DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())) &&
				activoAgrupacionApi.estaActivoEnAgrupacionRestringidaObRem(activo)) {
			Thread creacionAsincrona = new Thread(new AnyadirQuitarActivoAgrObREMAsync(activo.getId(), agrupacion.getId(),
					true, genericAdapter.getUsuarioLogado().getUsername()));

			creacionAsincrona.start();
		}else {
			ActivoAgrupacionActivo activoAgrupacionActivo = new ActivoAgrupacionActivo();
			activoAgrupacionActivo.setActivo(activo);
			activoAgrupacionActivo.setAgrupacion(agrupacion);
			Date today = new Date();
			activoAgrupacionActivo.setFechaInclusion(today);
			activoAgrupacionActivo.setPisoPiloto(false);
			activoAgrupacionActivoApi.save(activoAgrupacionActivo);
		}

		// Validaciones para las agrupaciones de tipo proyecto
		if (DDTipoAgrupacion.AGRUPACION_PROYECTO.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			ActivoProyecto proyecto = (ActivoProyecto) agrupacion;
			if (!activo.getCartera().equals(proyecto.getCartera())
					|| !activo.getProvincia().equals(proyecto.getProvincia().getCodigo())) {
				throw new JsonViewerException("El activo no tiene la misma Provincia o Cartera que la agrupación");
			}
			if (!Checks.esNulo(numActivo)) {
				if(particularValidator.activoEnAgrupacionProyecto(Long.toString(numActivo))) {
					throw new JsonViewerException(AgrupacionValidator.ERROR_EN_OTRA_PROYECTO);
				}
			}
		}
		
		// En asistidas hay que hacer una serie de actualizaciones
		// 'especiales'.
		if (DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			activoApi.updateActivoAsistida(activo);
		}

		if ((DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())
				|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())
				|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(agrupacion.getTipoAgrupacion().getCodigo())) &&
				!activoAgrupacionApi.estaActivoEnAgrupacionRestringidaObRem(activo)) {


			if (activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)) {
				throw new JsonViewerException(BusinessValidators.ERROR_ACTIVO_CARTERA_BANKIA_TO_AGR_RESTRINGIDAS);
			}

			boolean errorFlag = false;
			Activo activoP = agrupacion.getActivoPrincipal();
			if(activoP != null) {
				Filter filtroactivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				Filter filtroprincipal = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoP.getId());
				PerimetroActivo perimetroActivoActual = genericDao.get(PerimetroActivo.class, filtroactivo);
				PerimetroActivo perimetroActivoPrincipal = genericDao.get(PerimetroActivo.class, filtroprincipal);
				errorFlag = calculateEqualsPerimetros(perimetroActivoPrincipal, perimetroActivoActual);
						
				if(errorFlag) {
					throw new JsonViewerException("Los activos no tienen la misma situación para la visibilidad de gestión comercial");
				}
			}
			
			if (particularValidator.isMismoTcoActivoPrincipalAgrupacion(String.valueOf(numActivo),
					String.valueOf(agrupacion.getNumAgrupRem()))) {

				if (particularValidator.isMismoEpuActivoPrincipalAgrupacion(String.valueOf(numActivo),
						String.valueOf(agrupacion.getNumAgrupRem()))) {
					DtoDatosPublicacionAgrupacion dto = new DtoDatosPublicacionAgrupacion();
					dto.setIdActivo(activo.getId());
					ActivoAgrupacionActivo aga = activoApi
							.getActivoAgrupacionActivoAgrRestringidaPorActivoID(agrupacion.getActivoPrincipal().getId());
					if (aga != null) {
						activoEstadoPublicacionApi.setDatosPublicacionAgrupacion(aga.getAgrupacion().getId(), dto);
					}
	
					ActivoPublicacion activoPublicacionPrincipal = activoPublicacionDao
							.getActivoPublicacionPorIdActivo(agrupacion.getActivoPrincipal().getId());
					ActivoPublicacion activoPublicacion = activoPublicacionDao
							.getActivoPublicacionPorIdActivo(activo.getId());
					BeanUtils.copyProperty(activoPublicacion, "estadoPublicacionVenta",
							activoPublicacionPrincipal.getEstadoPublicacionVenta());
					BeanUtils.copyProperty(activoPublicacion, "estadoPublicacionAlquiler",
							activoPublicacionPrincipal.getEstadoPublicacionAlquiler());
					BeanUtils.copyProperty(activoPublicacion, "checkPublicarVenta",
							activoPublicacionPrincipal.getCheckPublicarVenta());
					BeanUtils.copyProperty(activoPublicacion, "checkPublicarAlquiler",
							activoPublicacionPrincipal.getCheckPublicarAlquiler());
					BeanUtils.copyProperty(activoPublicacion, "checkOcultarVenta",
							activoPublicacionPrincipal.getCheckOcultarVenta());
					BeanUtils.copyProperty(activoPublicacion, "checkOcultarAlquiler",
							activoPublicacionPrincipal.getCheckOcultarAlquiler());
					BeanUtils.copyProperty(activoPublicacion, "checkSinPrecioVenta",
							activoPublicacionPrincipal.getCheckSinPrecioVenta());
					BeanUtils.copyProperty(activoPublicacion, "checkSinPrecioAlquiler",
							activoPublicacionPrincipal.getCheckSinPrecioAlquiler());
					BeanUtils.copyProperty(activoPublicacion, "checkOcultarPrecioVenta",
							activoPublicacionPrincipal.getCheckOcultarPrecioVenta());
					BeanUtils.copyProperty(activoPublicacion, "checkOcultarPrecioAlquiler",
							activoPublicacionPrincipal.getCheckOcultarPrecioAlquiler());
					activoPublicacionDao.saveOrUpdate(activoPublicacion);
					
				} else {
					throw new JsonViewerException(BusinessValidators.ERROR_ESTADO_PUBLICACION_NOT_EQUAL);
				}
			} else {
				throw new JsonViewerException(BusinessValidators.ERROR_DESTINO_COMERCIAL_NOT_EQUAL);
			}
		}

		// Actualizar el tipoComercialización del activo
		updaterState.updaterStateTipoComercializacion(activo);

		// Actualizar el activo principal de la agrupación

		if (!Checks.esNulo(activoPrincipal)) {
			if (activoPrincipal == 1) {
				agrupacion.setActivoPrincipal(activo);
				activoAgrupacionApi.saveOrUpdate(agrupacion);
			}
		}
		
	
	}
	
	@Transactional(readOnly = false)
	public void createActivoAgrupacionMasivo(Long numActivo, Long idAgrupacion, Integer activoPrincipal, boolean ventaCartera)
			throws JsonViewerException {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo);
		Activo activo = genericDao.get(Activo.class, filter);
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(idAgrupacion);

		try {
			// Validaciones
			int num = activoAgrupacionActivoApi.numActivosPorActivoAgrupacion(agrupacion.getId());

			// Si es el primer activo, validamos si tenemos los datos necesarios
			// del activo, y modificamos la agrupación con esos datos
			if (num == 0) {
				activoAgrupacionValidate(activo, agrupacion);
				agrupacion = updateAgrupacionPrimerActivo(activo, agrupacion);
				activoAgrupacionApi.saveOrUpdate(agrupacion);
			}

			// Validaciones de agrupación
			agrupacionValidate(activo, agrupacion);

			ActivoAgrupacionActivo activoAgrupacionActivo = new ActivoAgrupacionActivo();
			activoAgrupacionActivo.setActivo(activo);
			activoAgrupacionActivo.setAgrupacion(agrupacion);
			Date today = new Date();
			activoAgrupacionActivo.setFechaInclusion(today);
			activoAgrupacionActivoApi.save(activoAgrupacionActivo);
			
			if (particularValidator.isMismoEpuActivoPrincipalAgrupacion(String.valueOf(numActivo), String.valueOf(agrupacion.getNumAgrupRem()))) {
				DtoDatosPublicacionAgrupacion dto = new DtoDatosPublicacionAgrupacion();
				dto.setIdActivo(activo.getId());

				ActivoAgrupacionActivo aga = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(agrupacion.getActivoPrincipal().getId());
				if (!Checks.esNulo(aga)) {
					activoEstadoPublicacionApi.setDatosPublicacionAgrupacionMasivo(aga.getAgrupacion().getId(), dto);
				}
			} else {
				throw new JsonViewerException(BusinessValidators.ERROR_ESTADO_PUBLICACION_NOT_EQUAL);
			}

			// Actualizar el tipoComercialización del activo
			updaterState.updaterStateTipoComercializacion(activo);

			// Actualizar el activo principal de la agrupación
			if (!Checks.esNulo(activoPrincipal)) {
				if (activoPrincipal == 1) {
					agrupacion.setActivoPrincipal(activo);
					activoAgrupacionApi.saveOrUpdate(agrupacion);
				}
			}

		} catch (JsonViewerException jve) {
			throw jve;
		} catch (Exception e) {
			logger.error(e);
			e.printStackTrace();
		}
	}
	
	private boolean calculateEqualsPerimetros(PerimetroActivo perimetroActivoPrincipal, PerimetroActivo perimetroActivoActual) {
		boolean errorFlag = false;	
		Boolean excluirValidacionesPrincipal = DDSinSiNo.cambioDiccionarioaBooleanoNativo(perimetroActivoPrincipal.getExcluirValidaciones());
		Boolean excluirValidacionesActual = DDSinSiNo.cambioDiccionarioaBooleanoNativo(perimetroActivoActual.getExcluirValidaciones());
		DDMotivoGestionComercial motivoGestionPrincipal = perimetroActivoPrincipal.getMotivoGestionComercial();
		DDMotivoGestionComercial motivoGestionActual = perimetroActivoActual.getMotivoGestionComercial();
		boolean perimetroActivoPrincipalBool = false;
		boolean perimetroActualPrincipalBool = false;
		if(perimetroActivoPrincipal.getCheckGestorComercial() != null) {
			perimetroActivoPrincipalBool = perimetroActivoPrincipal.getCheckGestorComercial();
		}
		if(perimetroActivoActual.getCheckGestorComercial() != null) {
			perimetroActualPrincipalBool = perimetroActivoActual.getCheckGestorComercial();
		}
		
		errorFlag = !(perimetroActivoPrincipalBool == perimetroActualPrincipalBool);
		
		if(!errorFlag) {
			errorFlag = !excluirValidacionesPrincipal == excluirValidacionesActual;
			if(!errorFlag) {
				if((motivoGestionPrincipal == null && motivoGestionActual != null) || (motivoGestionPrincipal != null && motivoGestionActual == null)) {
					errorFlag = true;
				}else if(motivoGestionPrincipal != null && motivoGestionActual != null) {
					errorFlag = !(motivoGestionPrincipal.getCodigo() == motivoGestionActual.getCodigo());
				}
			}
		}
		return errorFlag;
	}

	/**
	 * Este método guarda la relación de la agrupación lote comercial con el
	 * activo a incluir. Se examina si el activo a incluir pertenece a otra
	 * agrupación de tipo restringida y se obtiene una lista de activos
	 * incluidos en la misma para vincularlos por igual a la nueva agrupación.
	 * 
	 * @param activo
	 *            : activo a incluir en la agrupación lote comercial.
	 * @param agrupacion
	 *            : agrupación lote comercial en la que incluir el activo.
	 */
	private void saveAgrupacionLoteComercial(Activo activo, ActivoAgrupacion agrupacion) {
		// Obtener agrupaciones del activo.
		boolean incluidoAgrupacionRestringida = false;
		List<Activo> activosList = new ArrayList<Activo>();
		List<Activo> activosListActual = new ArrayList<Activo>();
		List<ActivoAgrupacionActivo> activosAgrupacionActual = activoAgrupacionActivoDao.getListActivoAgrupacionActivoByAgrupacionIDAndActivos(agrupacion.getId(), null);
		if(!Checks.estaVacio(activosAgrupacionActual)) {
			for(ActivoAgrupacionActivo aga : activosAgrupacionActual) {
				activosListActual.add(aga.getActivo());
			}
		}
		List<ActivoAgrupacionActivo> agrupacionesActivo = activo.getAgrupaciones();
		if (!Checks.estaVacio(agrupacionesActivo)) {

			for (ActivoAgrupacionActivo activoAgrupacionActivo : agrupacionesActivo) {
				if (!Checks.esNulo(activoAgrupacionActivo.getAgrupacion())
						&& !Checks.esNulo(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion())) {

					// Solo tratar con agrupaciones del tipo 'restringida'.
					if (activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)
							|| activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)
							|| activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {
					
						// Solo tratar con agrupaciones que no tengan informada 'fecha baja'.
						if(Checks.esNulo(activoAgrupacionActivo.getAgrupacion().getFechaBaja()) && 
								!Checks.esNulo(activoAgrupacionActivo.getAgrupacion().getActivos())){
							List<ActivoAgrupacionActivo> activosAgrupacion = activoAgrupacionActivo.getAgrupacion().getActivos();
							
							incluidoAgrupacionRestringida = true;
							if (!Checks.estaVacio(activosAgrupacion)) {
								// Obtener todos los activos de la agrupación
								// restringida en la que se encuentra el activo a
								// incluir en la agrupación lote comercial
								// y almacenar una nueva relación de la agrupación
								// lote comercial con cada activo.
								for (ActivoAgrupacionActivo activoAgrupacion : activosAgrupacion) {
									if (!activosList.contains(activoAgrupacion.getActivo()) 
											&& !activosListActual.contains(activoAgrupacion.getActivo())) {
										// Este bucle se realiza para evitar
										// posibles duplicados dado que un activo
										// puede estar en más de una agrupación de
										// tipo restringida.
										activosList.add(activoAgrupacion.getActivo());
									}
								}
							}
						}
					}
				}
			}
			
			if (!Checks.estaVacio(activosList)) {
				for (Activo act : activosList) {
					ActivoAgrupacionActivo nuevaRelacionAgrupacionActivo = new ActivoAgrupacionActivo();
					nuevaRelacionAgrupacionActivo.setActivo(act);
					nuevaRelacionAgrupacionActivo.setAgrupacion(agrupacion);
					Date today = new Date();
					nuevaRelacionAgrupacionActivo.setFechaInclusion(today);
					activoAgrupacionActivoApi.save(nuevaRelacionAgrupacionActivo);
				}
			}
		}

		if (!incluidoAgrupacionRestringida) {
			ActivoAgrupacionActivo nuevaRelacionAgrupacionActivo = new ActivoAgrupacionActivo();
			nuevaRelacionAgrupacionActivo.setActivo(activo);
			nuevaRelacionAgrupacionActivo.setAgrupacion(agrupacion);
			Date today = new Date();
			nuevaRelacionAgrupacionActivo.setFechaInclusion(today);
			activoAgrupacionActivoApi.save(nuevaRelacionAgrupacionActivo);
		}
	}

	private void agrupacionValidate(Activo activo, ActivoAgrupacion agrupacion) throws JsonViewerException {

		List<AgrupacionValidator> validators = agrupacionValidatorFactory
				.getServices(agrupacion.getTipoAgrupacion().getCodigo());

		for (AgrupacionValidator v : validators) {

			String errorResult = v.getValidationError(activo, agrupacion);

			if (errorResult != null && !errorResult.equals("")) {
				throw new JsonViewerException(errorResult);
			}
		}
	}

	/**
	 * Realiza las validaciones necesarias del activo para poderlo incluir en la
	 * agrupación
	 * 
	 * @param activo
	 *            Activo
	 * @param agrupacion
	 *            ActivoAgrupacion
	 */
	public void activoAgrupacionValidate(Activo activo, ActivoAgrupacion agrupacion) {

		NMBLocalizacionesBienInfo pobl = activo.getLocalizacionActual();

		if (Checks.esNulo(pobl.getLocalidad()))
			throw new JsonViewerException(BusinessValidators.ERROR_LOC_NULL);
		if (Checks.esNulo(pobl.getCodPostal()))
			throw new JsonViewerException(BusinessValidators.ERROR_CP_NULL);
		if (Checks.esNulo(pobl.getProvincia()))
			throw new JsonViewerException(BusinessValidators.ERROR_PROV_NULL);

		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_PROYECTO)) {

			if (Checks.esNulo(activo.getCartera()))
				throw new JsonViewerException(BusinessValidators.ERROR_CARTERA_NULL);

		} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {

			if (Checks.estaVacio(activo.getPropietariosActivo()))
				throw new JsonViewerException(BusinessValidators.ERROR_PROPIETARIO_NULL);

		}
	}

	public ActivoAgrupacion updateAgrupacionPrimerActivo(Activo activo, ActivoAgrupacion agrupacion) {

		NMBLocalizacionesBienInfo pobl = activo.getLocalizacionActual();

		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {
			ActivoObraNueva obraNueva = (ActivoObraNueva) agrupacion;
			obraNueva.setLocalidad(pobl.getLocalidad());
			obraNueva.setProvincia(pobl.getProvincia());
			obraNueva.setCodigoPostal(pobl.getCodPostal());
			return obraNueva;

		} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
			ActivoRestringida restringida = (ActivoRestringida) agrupacion;
			restringida.setLocalidad(pobl.getLocalidad());
			restringida.setProvincia(pobl.getProvincia());
			restringida.setCodigoPostal(pobl.getCodPostal());
			restringida.setActivoPrincipal(activo);
			return restringida;

		} else if(agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)) {
			ActivoRestringidaAlquiler restringidaAlquiler = (ActivoRestringidaAlquiler) agrupacion;
			restringidaAlquiler.setLocalidad(pobl.getLocalidad());
			restringidaAlquiler.setProvincia(pobl.getProvincia());
			restringidaAlquiler.setCodigoPostal(pobl.getCodPostal());
			restringidaAlquiler.setActivoPrincipal(activo);
			return restringidaAlquiler;
			
		} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {
			ActivoRestringidaObrem restringidaObrem = (ActivoRestringidaObrem) agrupacion;
			restringidaObrem.setLocalidad(pobl.getLocalidad());
			restringidaObrem.setProvincia(pobl.getProvincia());
			restringidaObrem.setCodigoPostal(pobl.getCodPostal());
			restringidaObrem.setActivoPrincipal(activo);
			return restringidaObrem;
			
		} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_PROYECTO)) {
			ActivoProyecto proyecto = (ActivoProyecto) agrupacion;
			proyecto.setLocalidad(pobl.getLocalidad());
			proyecto.setProvincia(pobl.getProvincia());
			proyecto.setCodigoPostal(pobl.getCodPostal());
			return proyecto;

		} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {
			ActivoAsistida asistida = (ActivoAsistida) agrupacion;
			asistida.setLocalidad(pobl.getLocalidad());
			asistida.setProvincia(pobl.getProvincia());
			asistida.setCodigoPostal(pobl.getCodPostal());
			return asistida;

		} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)
				|| DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())
				|| DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			ActivoLoteComercial loteComercial = (ActivoLoteComercial) agrupacion;
			// Copiamos "Municipio", "Código Postal", "Cartera", "Destino Comercial" y "Provincia"
			loteComercial.setLocalidad(pobl.getLocalidad());
			loteComercial.setProvincia(pobl.getProvincia());
			loteComercial.setCodigoPostal(pobl.getCodPostal());
			return loteComercial;
		}

		return agrupacion;
	}

	@Transactional(readOnly = false)
	public boolean marcarPrincipal(Long idAgrupacion, Long idActivo) {

		Activo activo = activoApi.get(idActivo);
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(idAgrupacion);

		try {

			// Si es RESTRINGIDA
			if (agrupacion.getTipoAgrupacion() != null ) {
				if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
					ActivoRestringida restringida = (ActivoRestringida) agrupacion;
					restringida.setActivoPrincipal(activo);
	
					activoAgrupacionApi.saveOrUpdate(restringida);
	
				} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)) {
					ActivoRestringidaAlquiler restringidaAlquiler = (ActivoRestringidaAlquiler) agrupacion;
					restringidaAlquiler.setActivoPrincipal(activo);
	
					activoAgrupacionApi.saveOrUpdate(restringidaAlquiler);
					
				} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {
					ActivoRestringidaObrem restringidaObrem = (ActivoRestringidaObrem) agrupacion;
					restringidaObrem.setActivoPrincipal(activo);
	
					activoAgrupacionApi.saveOrUpdate(restringidaObrem);
				}
			}

		} catch (Exception e) {
			logger.error("error en agrupacionAdapter", e);
		}

		return true;
		
	}

	@Transactional(readOnly = false)
	public boolean deleteOneActivoAgrupacionActivo(Long idAgrupacion, Long idActivo) throws JsonViewerException {

		ActivoAgrupacionActivo activoAgrupacionActivo = activoAgrupacionActivoApi.getByIdActivoAndIdAgrupacion(idActivo,
				idAgrupacion);
		ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(idActivo);
		if (!Checks.esNulo(activoAgrupacionActivo)) {
			// Para los activos pertenecientes a una agrupación de tipo lote
			// comercial.
			if (activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo()
					.equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
				// Solo continuar si la agrupación no contiene ofetas vivas.
				List<Oferta> ofertasAgrupacion = activoAgrupacionActivo.getAgrupacion().getOfertas();
				if (!tieneOfertasNoAnuladas(ofertasAgrupacion)) {
					List<ActivoOferta> ofertasActivo = activoAgrupacionActivo.getActivo().getOfertas();
					if (!Checks.estaVacio(ofertasActivo)) {
						// En cada oferta asignada al activo.
						for (ActivoOferta ofertaActivo : ofertasActivo) {
							if (!Checks.esNulo(ofertaActivo.getPrimaryKey())
									&& !Checks.esNulo(ofertaActivo.getPrimaryKey().getOferta())
									&& !Checks.esNulo(ofertaActivo.getPrimaryKey().getOferta().getEstadoOferta())) {
								// Si tiene expediente poner oferta ACEPTADA. Si
								// no
								// tiene poner oferta PENDIENTE
								try {
									if (ofertaActivo.getPrimaryKey().getOferta().getEstadoOferta().getCodigo()
											.equals(DDEstadoOferta.CODIGO_CONGELADA)) {
										ExpedienteComercial exp = expedienteComercialApi
												.findOneByOferta(ofertaActivo.getPrimaryKey().getOferta());
										if (!Checks.esNulo(exp)) {
											ofertaApi.descongelarOfertas(exp);
										} else {
											ofertaActivo.getPrimaryKey().getOferta()
													.setEstadoOferta(genericDao.get(DDEstadoOferta.class,
															genericDao.createFilter(FilterType.EQUALS, "codigo",
																	DDEstadoOferta.CODIGO_PENDIENTE)));
											genericDao.save(Oferta.class, ofertaActivo.getPrimaryKey().getOferta());
										}
									}
								} catch (Exception e) {
									logger.error("error descongelando ofertas", e);
								}
							}
						}
					}
					
					activoAgrupacionActivoApi.delete(activoAgrupacionActivo);
					
				} else {
					throw new JsonViewerException(
							"No se puede alterar el listado de activos cuando la agrupación tiene ofertas");
				}
			} else if (activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo()
					.equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA) && !Checks.esNulo(activoBancario)
					&& DDClaseActivoBancario.CODIGO_FINANCIERO.equals(activoBancario.getClaseActivo().getCodigo())) {
				PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(idActivo);
				if (!Checks.esNulo(perimetro)) {
					perimetro.setIncluidoEnPerimetro(BooleanUtils.toInteger(false));
					genericDao.save(PerimetroActivo.class, perimetro);
				}
				activoAgrupacionActivoApi.delete(activoAgrupacionActivo);
			} else if(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo()
					.equals(DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER)) {
				
				Long idActivoUA = activoAgrupacionActivo.getActivo().getId();
				String error = validarBajaActivosPA(activoAgrupacionActivo.getActivo());
				if (Checks.esNulo(error)) {

					Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivoUA);
					Activo activoActual = activoAgrupacionActivo.getActivo();
					PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtroActivo);
					ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, filtroActivo);
					
					if(!Checks.esNulo(activoPatrimonio)) {
						activoPatrimonio.setCheckHPM(false);
						
					}
					
					if (!Checks.esNulo(perimetroActivo)) {
						perimetroActivo.setActivo(activoActual);
						perimetroActivo.setIncluidoEnPerimetro(0);
						perimetroActivo.setAplicaTramiteAdmision(0);
						perimetroActivo.setAplicaGestion(0);
						perimetroActivo.setAplicaAsignarMediador(0);
						perimetroActivo.setAplicaComercializar(0);
						perimetroActivo.setAplicaFormalizar(0);
						perimetroActivo.setAplicaPublicar(false);
						
						genericDao.save(PerimetroActivo.class, perimetroActivo);
					}
	
						activoAgrupacionActivo.getAuditoria().setBorrado(true);
						activoAgrupacionActivo.getAuditoria().setFechaBorrar(new Date());
						activoAgrupacionActivo.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
						activoAgrupacionActivoApi.save(activoAgrupacionActivo);
				}
				else {
					throw new JsonViewerException(error);
				}
			}else if((DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())
					|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo()))
				&& activoAgrupacionApi.estaActivoEnAgrupacionRestringidaObRem(activoAgrupacionActivo.getActivo())) {
				Thread creacionAsincrona = new Thread(new AnyadirQuitarActivoAgrObREMAsync(activoAgrupacionActivo.getActivo().getId(),
						activoAgrupacionActivo.getAgrupacion().getId(),false, genericAdapter.getUsuarioLogado().getUsername()));

				creacionAsincrona.start();
			}
			else {
				activoAgrupacionActivoApi.delete(activoAgrupacionActivo);
			}
			return true;
		} else {
			throw new JsonViewerException("No ha sido posible eliminar el activo de la agrupación");
		}
	}
	
	private boolean tieneOfertasNoAnuladas(List<Oferta> ofertas){
		boolean resultado = false;
		if(ofertas != null && ofertas.size()>0){
			for(Oferta oferta : ofertas){
				if(oferta.getEstadoOferta() == null || !DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())){
					resultado = true;
					break;
				}
			}
		}
		return resultado;
	}

	@Transactional(readOnly = false)
	public boolean deleteActivoAgrupacion(Long id) throws JsonViewerException {

		ActivoAgrupacionActivo activoAgrupacionActivo = activoAgrupacionActivoApi.get(id);
		Activo activo = activoAgrupacionActivo.getActivo();
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(activoAgrupacionActivo.getAgrupacion().getId());

		int numActivos = activoAgrupacionActivoApi
				.numActivosPorActivoAgrupacion(activoAgrupacionActivo.getAgrupacion().getId());

		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {

			if (numActivos == 0) {
				throw new JsonViewerException("No hay ningún activo asociado a esta agrupación.");
			} else if (numActivos == 1) {
				throw new JsonViewerException(
						"El último activo de una agrupación no se puede eliminar. Intenta borrar toda la agrupación.");
			}

			if (DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_OFERTA.equals(activo.getSituacionComercial().getCodigo())
					|| DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_RESERVA
							.equals(activo.getSituacionComercial().getCodigo())) {
				throw new JsonViewerException("No se puede dar de baja un activo restringido si tiene ofertas VIVAS.");
			}
		}

		// Para los activos pertenecientes a una agrupación de tipo lote
		// comercial.
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
			// Obtener las agrupaciones donde se encuentra el activo a eliminar
			// de la agrupación lote comercial.
			boolean incluidoAgrupacionRestringida = false;
			List<ActivoAgrupacionActivo> agrupacionesActivo = activoAgrupacionActivo.getActivo().getAgrupaciones();
			if (!Checks.estaVacio(agrupacionesActivo)) {

				List<Long> activosID = new ArrayList<Long>();
				for (ActivoAgrupacionActivo activoAgrupaciones : agrupacionesActivo) {
					if (!Checks.esNulo(activoAgrupaciones.getAgrupacion())
							&& !Checks.esNulo(activoAgrupaciones.getAgrupacion().getTipoAgrupacion())) {

						// Para las agrupaciones de tipo restringido donde se
						// encuentre el activo.
						if (activoAgrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)
								|| activoAgrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)
								|| activoAgrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {
							incluidoAgrupacionRestringida = true;
							// Obtener una lista de activos por la agrupación.
							List<ActivoAgrupacionActivo> activosPorAgrupacionRestringida = activoAgrupaciones
									.getAgrupacion().getActivos();
							if (!Checks.estaVacio(activosPorAgrupacionRestringida)) {
								// Almacenar los ID de activos para contrastar
								// si se encuentran en la actual agrupación.
								for (ActivoAgrupacionActivo activosAgrupacion : activosPorAgrupacionRestringida) {
									if (!activosID.contains(activosAgrupacion.getActivo().getId())) {
										activosID.add(activosAgrupacion.getActivo().getId());
									}
								}
							}

							// Devolver estado de las ofertas de cada agrupación
							// afectada al estado de 'pendientes'.
							List<Oferta> ofertasAgrupacion = activoAgrupaciones.getAgrupacion().getOfertas();
							if (!Checks.estaVacio(ofertasAgrupacion)) {

								for (Oferta oferta : ofertasAgrupacion) {
									if (!Checks.esNulo(oferta.getEstadoOferta())) {

										if (oferta.getEstadoOferta().getCodigo()
												.equals(DDEstadoOferta.CODIGO_CONGELADA)) {
											DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi
													.dameValorDiccionarioByCod(DDEstadoOferta.class,
															DDEstadoOferta.CODIGO_PENDIENTE);
											oferta.setEstadoOferta(estadoOferta);
										}
									}
								}
							}
						}
					}
				}

				// Obtener una lista de asociaciones entre la agrupación lote
				// comercial y los activos obtenidos relacionados con el activo
				// a borrar.
				List<ActivoAgrupacionActivo> agrupacionesActivoABorrar = activoAgrupacionActivoDao
						.getListActivoAgrupacionActivoByAgrupacionIDAndActivos(agrupacion.getId(), activosID);
				if (!Checks.estaVacio(agrupacionesActivoABorrar)) {
					for (ActivoAgrupacionActivo agrupaciones : agrupacionesActivoABorrar) {
						activoAgrupacionActivoApi.delete(agrupaciones);
					}
				}
			}

			if (!incluidoAgrupacionRestringida) {
				List<ActivoOferta> ofertasActivo = activoAgrupacionActivo.getActivo().getOfertas();
				if (!Checks.estaVacio(ofertasActivo)) {
					// En cada oferta asignada al activo.
					for (ActivoOferta ofertaActivo : ofertasActivo) {
						if (!Checks.esNulo(ofertaActivo.getPrimaryKey())
								&& !Checks.esNulo(ofertaActivo.getPrimaryKey().getOferta())
								&& !Checks.esNulo(ofertaActivo.getPrimaryKey().getOferta().getEstadoOferta())) {
							// Si su estado es 'congelada' asignar nuevo estado
							// a 'pendiente'.
							if (ofertaActivo.getPrimaryKey().getOferta().getEstadoOferta().getCodigo()
									.equals(DDEstadoOferta.CODIGO_CONGELADA)) {
								DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi
										.dameValorDiccionarioByCod(DDEstadoOferta.class,
												DDEstadoOferta.CODIGO_PENDIENTE);
								ofertaActivo.getPrimaryKey().getOferta().setEstadoOferta(estadoOferta);
							}
						}
					}
				}
				activoAgrupacionActivoApi.delete(activoAgrupacionActivo);
			}
		}

		if (!agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
			try {
				if (activoAgrupacionActivo.getActivo().equals(agrupacion.getActivoPrincipal())) {
					agrupacion.setActivoPrincipal(null);
					genericDao.update(ActivoAgrupacion.class, agrupacion);
				}
				activoAgrupacionActivoApi.delete(activoAgrupacionActivo);
				if (numActivos == 1
						&& agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", agrupacion.getId());
					ActivoObraNueva obraNueva = genericDao.get(ActivoObraNueva.class, filtro);

					obraNueva.setProvincia(null);
					obraNueva.setCodigoPostal(null);
					obraNueva.setLocalidad(null);

					genericDao.update(ActivoObraNueva.class, obraNueva);
				}

			} catch (Exception e) {
				logger.error("error en agrupacionAdapter", e);
			}
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteActivosAgrupacion(Long[] id) {

		try {

			for (int i = 0; i < id.length; i++) {

				ActivoAgrupacionActivo activoAgrupacionActivo = activoAgrupacionActivoApi.get(id[i]);

				if (activoAgrupacionActivo.getActivo()
						.equals(activoAgrupacionActivo.getAgrupacion().getActivoPrincipal())) {
					activoAgrupacionActivo.getAgrupacion().setActivoPrincipal(null);
					genericDao.update(ActivoAgrupacion.class, activoAgrupacionActivo.getAgrupacion());
				}
				activoAgrupacionActivoApi.delete(activoAgrupacionActivo);
			}

		} catch (Exception e) {
			logger.error("error en agrupacionAdapter", e);
		}

		return true;

	}
	
	@Transactional(readOnly = false)
	public void deleteActivosUA(Long idActivoMatriz) {
		
		Filter filtroActivoMatriz = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivoMatriz);
		Filter filtroTipoAgrupacion = genericDao.createFilter(FilterType.EQUALS, "agrupacion.tipoAgrupacion.codigo", DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER);
		ActivoAgrupacionActivo agrupacion = genericDao.get(ActivoAgrupacionActivo.class, filtroActivoMatriz, filtroTipoAgrupacion);
		
		List<ActivoAgrupacionActivo> activoAgrupacionPA = new ArrayList<ActivoAgrupacionActivo>();
		Filter filtroAgrupacion = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", agrupacion.getAgrupacion().getId());
		Filter filtroActivosAgrupacion = genericDao.createFilter(FilterType.EQUALS, "principal", 0);
		activoAgrupacionPA = genericDao.getList(ActivoAgrupacionActivo.class, filtroAgrupacion, filtroActivosAgrupacion);
		
		if(!Checks.esNulo(idActivoMatriz)) {
			Filter filterIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivoMatriz);
			Filter filterIdAgrupacion = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", agrupacion.getId());
			ActivoAgrupacionActivo aga = genericDao.get(ActivoAgrupacionActivo.class, filterIdActivo, filterIdAgrupacion);
		
			if(!Checks.esNulo(aga)) {
				aga.setPrincipal(0);
			}
			activoAdapter.actualizarEstadoPublicacionActivo(idActivoMatriz);
		}
		if (!Checks.estaVacio(activoAgrupacionPA)) {
			
			for (ActivoAgrupacionActivo activo : activoAgrupacionPA) {
				Long idActivo = activo.getActivo().getId();
					Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
					Activo activoActual = activo.getActivo();
					PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtroActivo);
					ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, filtroActivo);
					
					if(!Checks.esNulo(activoPatrimonio)) {
						activoPatrimonio.setCheckHPM(false);
						
					}
					
					if (!Checks.esNulo(perimetroActivo)) {
						perimetroActivo.setActivo(activoActual);
						perimetroActivo.setIncluidoEnPerimetro(0);
						perimetroActivo.setAplicaTramiteAdmision(0);
						perimetroActivo.setAplicaGestion(0);
						perimetroActivo.setAplicaAsignarMediador(0);
						perimetroActivo.setAplicaComercializar(0);
						perimetroActivo.setAplicaFormalizar(0);
						perimetroActivo.setAplicaPublicar(false);
						
						genericDao.save(PerimetroActivo.class, perimetroActivo);
				}
			}
		}

		/*try {
			
			ActivoAgrupacion agrupacion = activoAgrupacionApi.get(idActivoMatriz);
			int tamano = agrupacion.getActivos().size();

			for (int i = 0; i < tamano; i++) {
				ActivoAgrupacionActivo activoAgrupacionActivo = activoAgrupacionActivoApi.get(agrupacion.getActivos().get(i).getId());

				if (activoAgrupacionActivo.getActivo().equals(activoAgrupacionActivo.getAgrupacion().getActivoPrincipal())) {
					activoAgrupacionActivo.getAgrupacion().setActivoPrincipal(null);
					genericDao.update(ActivoAgrupacion.class, activoAgrupacionActivo.getAgrupacion());
				}else{
					
					activoAgrupacionActivo.getAuditoria().setBorrado(true);
					activoAgrupacionActivo.getAuditoria().setFechaBorrar(new Date());
					activoAgrupacionActivo.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
					activoAgrupacionActivoApi.save(activoAgrupacionActivo);
					
					Long idActivoUA = activoAgrupacionActivo.getActivo().getId();
					Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivoUA);
					Activo activoActual = activoAgrupacionActivo.getActivo();
					PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtroActivo);
					
					if (!Checks.esNulo(perimetroActivo)) {
						perimetroActivo.setActivo(activoActual);
						perimetroActivo.setIncluidoEnPerimetro(0);
						perimetroActivo.setAplicaTramiteAdmision(0);
						perimetroActivo.setAplicaGestion(0);
						perimetroActivo.setAplicaAsignarMediador(0);
						perimetroActivo.setAplicaComercializar(0);
						perimetroActivo.setAplicaFormalizar(0);
						perimetroActivo.setAplicaPublicar(false);
						
						genericDao.save(PerimetroActivo.class, perimetroActivo);
					}

				}
			}

			agrupacion.getActivos().clear();
			agrupacion.setActivoPrincipal(null);
			activoAgrupacionApi.saveOrUpdate(agrupacion);

		} catch (Exception e) {
			logger.error("error en agrupacionAdapter", e);
		}

		return true;*/

	}

	@Transactional(readOnly = false)
	public boolean deleteAllActivosAgrupacion(Long id) {

		try {

			ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
			int tamano = agrupacion.getActivos().size();

			Long[] activosEliminar = new Long[tamano];
			for (int i = 0; i < tamano; i++) {
				activosEliminar[i] = agrupacion.getActivos().get(i).getId();
			}

			agrupacion.getActivos().clear();
			agrupacion.setActivoPrincipal(null);
			activoAgrupacionApi.saveOrUpdate(agrupacion);

			deleteActivosAgrupacion(activosEliminar);

		} catch (Exception e) {
			logger.error("error en agrupacionAdapter", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public DtoAgrupacionesCreateDelete createAgrupacion(DtoAgrupacionesCreateDelete dtoAgrupacion) throws Exception {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoAgrupacion.getTipoAgrupacion());
		DDTipoAgrupacion tipoAgrupacion = (DDTipoAgrupacion) genericDao.get(DDTipoAgrupacion.class, filtro);

		Long numAgrupacionRem = activoAgrupacionApi.getNextNumAgrupacionRemManual();

		dtoAgrupacion.setNumAgrupacionRem(numAgrupacionRem);

		// Si es OBRA NUEVA
		if (dtoAgrupacion.getTipoAgrupacion().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {

			ActivoObraNueva obraNueva = new ActivoObraNueva();

			obraNueva.setDescripcion(dtoAgrupacion.getDescripcion());
			obraNueva.setNombre(dtoAgrupacion.getNombre());
			obraNueva.setTipoAgrupacion(tipoAgrupacion);
			obraNueva.setFechaAlta(new Date());
			obraNueva.setNumAgrupRem(numAgrupacionRem);
			obraNueva.setDireccion(dtoAgrupacion.getDireccion());
			
			obraNueva.setComercializableConsPlano(false);
			obraNueva.setExistePiloto(false);
			obraNueva.setEsVisitable(false);

		    genericDao.save(ActivoObraNueva.class, obraNueva);

		    dtoAgrupacion.setId(obraNueva.getId().toString());

			// Si es RESTRINGIDA
		} else if (dtoAgrupacion.getTipoAgrupacion().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {

			ActivoRestringida restringida = new ActivoRestringida();

			restringida.setDescripcion(dtoAgrupacion.getDescripcion());
			restringida.setNombre(dtoAgrupacion.getNombre());
			restringida.setTipoAgrupacion(tipoAgrupacion);
			restringida.setFechaAlta(new Date());
			restringida.setNumAgrupRem(numAgrupacionRem);
			restringida.setDireccion(dtoAgrupacion.getDireccion());
			
			restringida.setComercializableConsPlano(false);
			restringida.setExistePiloto(false);
			restringida.setEsVisitable(false);
			
			genericDao.save(ActivoRestringida.class, restringida);

			dtoAgrupacion.setId(restringida.getId().toString());

			// Si es RESTRINGIDA ALQUIILER
		} else if (dtoAgrupacion.getTipoAgrupacion().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)) {

			ActivoRestringidaAlquiler restringidaAlquiler = new ActivoRestringidaAlquiler();

			restringidaAlquiler.setDescripcion(dtoAgrupacion.getDescripcion());
			restringidaAlquiler.setNombre(dtoAgrupacion.getNombre());
			restringidaAlquiler.setTipoAgrupacion(tipoAgrupacion);
			restringidaAlquiler.setFechaAlta(new Date());
			restringidaAlquiler.setNumAgrupRem(numAgrupacionRem);
			restringidaAlquiler.setDireccion(dtoAgrupacion.getDireccion());
			
			restringidaAlquiler.setComercializableConsPlano(false);
			restringidaAlquiler.setExistePiloto(false);
			restringidaAlquiler.setEsVisitable(false);
			
			genericDao.save(ActivoRestringidaAlquiler.class, restringidaAlquiler);

			dtoAgrupacion.setId(restringidaAlquiler.getId().toString());

			// Si es RESTRINGIDA OBREM
		} else if (dtoAgrupacion.getTipoAgrupacion().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {

			ActivoRestringidaObrem restringidaObrem = new ActivoRestringidaObrem();

			restringidaObrem.setDescripcion(dtoAgrupacion.getDescripcion());
			restringidaObrem.setNombre(dtoAgrupacion.getNombre());
			restringidaObrem.setTipoAgrupacion(tipoAgrupacion);
			restringidaObrem.setFechaAlta(new Date());
			restringidaObrem.setNumAgrupRem(numAgrupacionRem);
			restringidaObrem.setDireccion(dtoAgrupacion.getDireccion());
			
			restringidaObrem.setComercializableConsPlano(false);
			restringidaObrem.setExistePiloto(false);
			restringidaObrem.setEsVisitable(false);
			
			genericDao.save(ActivoRestringidaObrem.class, restringidaObrem);

			dtoAgrupacion.setId(restringidaObrem.getId().toString());

			// Si es PROYECTO
		} else if (dtoAgrupacion.getTipoAgrupacion().equals(DDTipoAgrupacion.AGRUPACION_PROYECTO)) {

			ActivoProyecto proyecto = new ActivoProyecto();
			proyecto.setDescripcion(dtoAgrupacion.getDescripcion());
			proyecto.setNombre(dtoAgrupacion.getNombre());
			proyecto.setTipoAgrupacion(tipoAgrupacion);
			proyecto.setFechaAlta(new Date());
			proyecto.setNumAgrupRem(numAgrupacionRem);
			proyecto.setDireccion(dtoAgrupacion.getDireccion());
			
			proyecto.setComercializableConsPlano(false);
			proyecto.setExistePiloto(false);
			proyecto.setEsVisitable(false);
			
			genericDao.save(ActivoProyecto.class, proyecto);
			
			dtoAgrupacion.setId(proyecto.getId().toString());

			// Si es ASISTIDA
		} else if (dtoAgrupacion.getTipoAgrupacion().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {

			ActivoAsistida asistida = new ActivoAsistida();

			asistida.setDescripcion(dtoAgrupacion.getDescripcion());
			asistida.setNombre(dtoAgrupacion.getNombre());
			asistida.setTipoAgrupacion(tipoAgrupacion);
			asistida.setFechaAlta(new Date());
			asistida.setFechaInicioVigencia(dtoAgrupacion.getFechaInicioVigencia());
			asistida.setFechaFinVigencia(dtoAgrupacion.getFechaFinVigencia());
			asistida.setNumAgrupRem(numAgrupacionRem);
			asistida.setDireccion(dtoAgrupacion.getDireccion());
			
			asistida.setComercializableConsPlano(false);
			asistida.setExistePiloto(false);
			asistida.setEsVisitable(false);
			
			genericDao.save(ActivoAsistida.class, asistida);
			
			dtoAgrupacion.setId(asistida.getId().toString());


			// Si es LOTE COMERCIAL
		} else if ((DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER.equals(dtoAgrupacion.getTipoAgrupacion()))
				|| (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA.equals(dtoAgrupacion.getTipoAgrupacion()))) {

			ActivoLoteComercial loteComercial = new ActivoLoteComercial();

			loteComercial.setDescripcion(dtoAgrupacion.getDescripcion());
			loteComercial.setNombre(dtoAgrupacion.getNombre());
			loteComercial.setTipoAgrupacion(tipoAgrupacion);
			loteComercial.setFechaAlta(new Date());
			loteComercial.setNumAgrupRem(numAgrupacionRem);
			loteComercial.setDireccion(dtoAgrupacion.getDireccion());
			loteComercial.setUsuarioGestorComercial(dtoAgrupacion.getGestorComercial());
			loteComercial.setDireccion(dtoAgrupacion.getDireccion());
			if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER.equals(dtoAgrupacion.getTipoAgrupacion())){
				DDTipoAlquiler tipoAlquiler = genericDao.get(DDTipoAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoAlquiler.CODIGO_NO_DEFINIDO));
				loteComercial.setTipoAlquiler(tipoAlquiler);
			}
			
			loteComercial.setComercializableConsPlano(false);
			loteComercial.setExistePiloto(false);
			loteComercial.setEsVisitable(false);
			
			if (!Checks.esNulo(dtoAgrupacion.getEsFormalizacion()) && dtoAgrupacion.getEsFormalizacion())
				loteComercial.setIsFormalizacion(1);
			
			genericDao.save(ActivoLoteComercial.class, loteComercial);

			dtoAgrupacion.setId(loteComercial.getId().toString());
			
			// Si es PROMOCION ALQUILER
		} 		else if (dtoAgrupacion.getTipoAgrupacion().equals(DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER)) {

			ActivoPromocionAlquiler promocionAlquiler = new ActivoPromocionAlquiler();

			promocionAlquiler.setDescripcion(dtoAgrupacion.getDescripcion());
			promocionAlquiler.setNombre(dtoAgrupacion.getNombre());
			promocionAlquiler.setTipoAgrupacion(tipoAgrupacion);
			promocionAlquiler.setFechaAlta(new Date());
			promocionAlquiler.setNumAgrupRem(numAgrupacionRem);
			promocionAlquiler.setDireccion(dtoAgrupacion.getDireccion());
			
			promocionAlquiler.setComercializableConsPlano(false);
			promocionAlquiler.setExistePiloto(false);
			promocionAlquiler.setEsVisitable(false);

		    genericDao.save(ActivoPromocionAlquiler.class, promocionAlquiler);

		    dtoAgrupacion.setId(promocionAlquiler.getId().toString());
		}

		return dtoAgrupacion;
	}

	@Transactional(readOnly = false)
	public boolean deleteAgrupacionById(DtoAgrupacionesCreateDelete dtoAgrupacion) {

		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(Long.valueOf(dtoAgrupacion.getId()));

		try {

			if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {

				genericDao.deleteById(ActivoObraNueva.class, Long.valueOf(dtoAgrupacion.getId()));

			} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {

				genericDao.deleteById(ActivoRestringida.class, Long.valueOf(dtoAgrupacion.getId()));

			} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)) {

			genericDao.deleteById(ActivoRestringidaAlquiler.class, Long.valueOf(dtoAgrupacion.getId()));

			} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {

			genericDao.deleteById(ActivoRestringidaObrem.class, Long.valueOf(dtoAgrupacion.getId()));

			} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_PROYECTO)) {

				genericDao.deleteById(ActivoProyecto.class, Long.valueOf(dtoAgrupacion.getId()));

			} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {

				genericDao.deleteById(ActivoAsistida.class, Long.valueOf(dtoAgrupacion.getId()));

			} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {

				genericDao.deleteById(ActivoLoteComercial.class, Long.valueOf(dtoAgrupacion.getId()));

			}

			// Después borra todos los ActivoAgrupacionActivo de esta Agrupación
			// y los guarda en el histórico
			List<ActivoAgrupacionActivo> list = agrupacion.getActivos();
			for (int i = 0; i < list.size(); i++) {
				activoAgrupacionActivoApi.delete(list.get(i));
			}

		} catch (Exception e) {
			logger.error("error en agrupacionAdapter", e);
		}

		return true;
	}

	public List<DtoObservacion> getListObservacionesAgrupacionById(Long id) {

		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		// DtoCarga cargaDto = new ArrayList<DtoCarga>();
		List<DtoObservacion> listaDtoObservaciones = new ArrayList<DtoObservacion>();

		if (agrupacion.getAgrupacionObservacion() != null) {

			for (int i = 0; i < agrupacion.getAgrupacionObservacion().size(); i++) {

				DtoObservacion observacionDto = new DtoObservacion();

				try {

					BeanUtils.copyProperties(observacionDto, agrupacion.getAgrupacionObservacion().get(i));
					String nombreCompleto = agrupacion.getAgrupacionObservacion().get(i).getUsuario().getNombre();
					Long idUsuario = agrupacion.getAgrupacionObservacion().get(i).getUsuario().getId();
					if (agrupacion.getAgrupacionObservacion().get(i).getUsuario().getApellido1() != null) {

						nombreCompleto += agrupacion.getAgrupacionObservacion().get(i).getUsuario().getApellido1();

						if (agrupacion.getAgrupacionObservacion().get(i).getUsuario().getApellido2() != null) {
							nombreCompleto += agrupacion.getAgrupacionObservacion().get(i).getUsuario().getApellido2();
						}

					}
					BeanUtils.copyProperty(observacionDto, "nombreCompleto", nombreCompleto);
					BeanUtils.copyProperty(observacionDto, "idUsuario", idUsuario);

				} catch (IllegalAccessException e) {
					logger.error("error en agrupacionAdapter", e);
				} catch (InvocationTargetException e) {
					logger.error("error en agrupacionAdapter", e);
				}
				listaDtoObservaciones.add(observacionDto);
			}
		}

		return listaDtoObservaciones;

	}

	public List<VBusquedaVisitasDetalle> getListVisitasAgrupacionById(Long id) {

		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		// DtoCarga cargaDto = new ArrayList<DtoCarga>();
		List<VBusquedaVisitasDetalle> visitasDetalles = new ArrayList<VBusquedaVisitasDetalle>();
		List<VBusquedaVisitasDetalle> visitasDetallesTemporal = new ArrayList<VBusquedaVisitasDetalle>();

		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {

			Activo activoPrincipal = agrupacion.getActivoPrincipal();
			if (activoPrincipal != null && activoPrincipal.getVisitas() != null) {

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo",
						agrupacion.getActivoPrincipal().getId().toString());
				visitasDetalles = genericDao.getList(VBusquedaVisitasDetalle.class, filtro);

				return visitasDetalles;
			}

		} else {
			for (int i = 0; i < agrupacion.getActivos().size(); i++) {

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo",
						agrupacion.getActivos().get(i).getActivo().getId().toString());
				visitasDetallesTemporal = genericDao.getList(VBusquedaVisitasDetalle.class, filtro);

				for (VBusquedaVisitasDetalle v : visitasDetallesTemporal) {
					visitasDetalles.add(v);
				}
			}
		}

		return visitasDetalles;

	}

	public List<VGridOfertasActivosAgrupacionIncAnuladas> getListOfertasAgrupacion(Long idAgrupacion) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", idAgrupacion);

		List<VGridOfertasActivosAgrupacionIncAnuladas> ofertasAgrupacion = genericDao.getList(VGridOfertasActivosAgrupacionIncAnuladas.class, filtro);

		return ofertasAgrupacion;

	}
	
	public boolean isRetail(ActivoAgrupacion agr){
		boolean resultado = false;
		if(agr != null && agr.getActivos() != null && agr.getActivos().size() > 0){
			for(ActivoAgrupacionActivo activo : agr.getActivos()){
				if(activo.getActivo().getTipoComercializar() != null && DDTipoComercializar.CODIGO_RETAIL.equals(activo.getActivo().getTipoComercializar().getCodigo())){
					resultado = true;
					break;
				}
			}
		}
		return resultado;
	}
	
	@Transactional(readOnly = false)
	public Oferta createOfertaAgrupacion(DtoOfertasFilter dto) throws Exception {

		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(dto.getIdAgrupacion());
		Activo activo = null;
		Oferta ofertaNueva = null;

		// Comprobar tipo oferta compatible con tipo agrupacion
		if (!Checks.esNulo(agrupacion) && !Checks.esNulo(agrupacion.getTipoAgrupacion())) {

				if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())
					&& DDTipoOferta.CODIGO_VENTA.equals(dto.getTipoOferta())) {

					throw new JsonViewerException(messageServices.getMessage(OFERTA_INCOMPATIBLE_TIPO_AGR_MSG));

				}

				if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA.equals(agrupacion.getTipoAgrupacion().getCodigo())
						&& DDTipoOferta.CODIGO_ALQUILER.equals(dto.getTipoOferta())) {

					throw new JsonViewerException(messageServices.getMessage(OFERTA_INCOMPATIBLE_TIPO_AGR_MSG));

				}

		}

		List<ActivoOferta> listaActOfr = new ArrayList<ActivoOferta>();

		for (ActivoAgrupacionActivo activos : agrupacion.getActivos()) {

			// Comprobar el tipo de destino comercial que tiene actualmente el
			// activo y contrastar con la oferta.
			if (!Checks.esNulo(activos.getActivo().getActivoPublicacion()) && !Checks.esNulo(activos.getActivo().getActivoPublicacion().getTipoComercializacion())) {
				String comercializacion = activos.getActivo().getActivoPublicacion().getTipoComercializacion().getCodigo();
				
				if(activo == null) {
					activo = activos.getActivo();
				}

				if (DDTipoOferta.CODIGO_VENTA.equals(dto.getTipoOferta())
						&& DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(comercializacion)) {
					throw new JsonViewerException(AgrupacionAdapter.OFERTA_INCOMPATIBLE_AGR_MSG);
				}

				if (DDTipoOferta.CODIGO_ALQUILER.equals(dto.getTipoOferta())
						&& DDTipoComercializacion.CODIGO_VENTA.equals(comercializacion)) {
					throw new JsonViewerException(AgrupacionAdapter.OFERTA_INCOMPATIBLE_AGR_MSG);
				}
			}
		}

		try {
			ClienteComercial clienteComercial = new ClienteComercial();

			String codigoEstado = this.getEstadoNuevaOferta(agrupacion);

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

			if (!Checks.esNulo(dto.getTipoPersona())) {
				DDTiposPersona tipoPersona = (DDTiposPersona) genericDao.get(DDTiposPersona.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoPersona()));
				if (!Checks.esNulo(tipoPersona)) {
					clienteComercial.setTipoPersona(tipoPersona);
				}
			}

			if (!Checks.esNulo(dto.getEstadoCivil())) {
				DDEstadosCiviles estadoCivil = (DDEstadosCiviles) genericDao.get(DDEstadosCiviles.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoCivil()));
				if (!Checks.esNulo(estadoCivil)) {
					clienteComercial.setEstadoCivil(estadoCivil);
				}
			}

			if (!Checks.esNulo(dto.getRegimenMatrimonial())) {
				DDRegimenesMatrimoniales regimen = (DDRegimenesMatrimoniales) genericDao.get(
						DDRegimenesMatrimoniales.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getRegimenMatrimonial()));
				if (!Checks.esNulo(regimen)) {
					clienteComercial.setRegimenMatrimonial(regimen);
				}
			}
			
			if (!Checks.esNulo(dto.getCesionDatos())) {
				clienteComercial.setCesionDatos(dto.getCesionDatos());
			}
			
			if (!Checks.esNulo(dto.getTransferenciasInternacionales())) {
				clienteComercial.setTransferenciasInternacionales(dto.getTransferenciasInternacionales());
			}
			
			if (!Checks.esNulo(dto.getComunicacionTerceros())) {
				clienteComercial.setComunicacionTerceros(dto.getComunicacionTerceros());
			}
			
			Filter filtroAdjunto = genericDao.createFilter(FilterType.NOTNULL, "idAdjunto");
			List<TmpClienteGDPR> tmpClienteGDPR = genericDao.getList(TmpClienteGDPR.class, 
					genericDao.createFilter(FilterType.EQUALS, "numDocumento", dto.getNumDocumentoCliente()), filtroAdjunto);
			if (!Checks.estaVacio(tmpClienteGDPR) && !Checks.esNulo(tmpClienteGDPR.get(0).getIdPersonaHaya())) {
				clienteComercial.setIdPersonaHaya(String.valueOf(tmpClienteGDPR.get(0).getIdPersonaHaya()));
			}else {
				tmpClienteGDPR = genericDao.getList(TmpClienteGDPR.class, 
						genericDao.createFilter(FilterType.EQUALS, "numDocumento", dto.getNumDocumentoCliente()));			
			
				if (!Checks.estaVacio(tmpClienteGDPR) && !Checks.esNulo(tmpClienteGDPR.get(0).getIdPersonaHaya())) {
					clienteComercial.setIdPersonaHaya(String.valueOf(tmpClienteGDPR.get(0).getIdPersonaHaya()));
				}
			}
			
			InfoAdicionalPersona iap = genericDao.get(InfoAdicionalPersona.class, genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya", clienteComercial.getIdPersonaHaya()));

			
			if(iap == null) {
				iap = new InfoAdicionalPersona();
				iap.setAuditoria(Auditoria.getNewInstance());
				iap.setIdPersonaHaya(clienteComercial.getIdPersonaHaya());
				clienteComercial.setInfoAdicionalPersona(iap);
			}else if(clienteComercial.getInfoAdicionalPersona() == null) {
				clienteComercial.setInfoAdicionalPersona(iap);
			}
			
			Filter filtro = null;
			if(dto.getFechaNacimientoConstitucion() != null) {
				clienteComercial.setFechaNacimiento(ft.parse(dto.getFechaNacimientoConstitucion()));
			}
			
			if(dto.getPaisNacimientoCompradorCodigo() != null) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPaisNacimientoCompradorCodigo());
				DDPaises pais = (DDPaises) genericDao.get(DDPaises.class, filtro);
				clienteComercial.setPaisNacimiento(pais);
			}
			if(dto.getLocalidadNacimientoCompradorCodigo() != null) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getLocalidadNacimientoCompradorCodigo());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
	
				clienteComercial.setLocalidadNacimiento(municipioNuevo);
			}
			
			if (dto.getProvinciaNacimiento() != null) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaNacimiento());
				DDProvincia provinciNacimiento = (DDProvincia) genericDao.get(DDProvincia.class, filtro);
				clienteComercial.setProvinciaNacimiento(provinciNacimiento);
			}
			
			if(dto.getCodigoPais() != null) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoPais());
				DDPaises pais = (DDPaises) genericDao.get(DDPaises.class, filtro);
				clienteComercial.setPais(pais);
			}
			if(dto.getProvinciaCodigo() != null) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
				DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);
				clienteComercial.setProvincia(provinciaNueva);
			}
			if(dto.getMunicipioCodigo() != null) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
	
				clienteComercial.setMunicipio(municipioNuevo);
			}
			
			if (dto.getCodigoPostalNacimiento() != null) {
				clienteComercial.setCodigoPostal(dto.getCodigoPostalNacimiento());
			}
			
			if (dto.getEmailNacimiento() != null) {
				clienteComercial.setEmail(dto.getEmailNacimiento());
			}
			
			if (dto.getTelefonoNacimiento1() != null) {
				clienteComercial.setTelefono1(dto.getTelefonoNacimiento1());
			}
			
			if (dto.getTelefonoNacimiento2() != null) {
				clienteComercial.setTelefono2(dto.getTelefonoNacimiento2());
			}
			
			clienteComercial.setDireccion(dto.getDireccion());
			if(clienteComercial.getInfoAdicionalPersona() != null) {
				clienteComercial.getInfoAdicionalPersona().setPrp(dto.getPrp());
			}
			
			genericDao.save(InfoAdicionalPersona.class, iap);

			
			genericDao.save(ClienteComercial.class, clienteComercial);

			Oferta oferta = new Oferta();
			if(TIPO_AGRUPACION_RESTRINGIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())
					|| TIPO_AGRUPACION_RESTRINGIDA_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())
					|| TIPO_AGRUPACION_RESTRINGIDA_OBREM.equals(agrupacion.getTipoAgrupacion().getCodigo())){
				oferta.setOrigen(OfertaApi.ORIGEN_REM);
			}

			oferta.setNumOferta(numOferta);
			oferta.setAgrupacion(agrupacion);
			
			if (!Checks.esNulo(dto.getImporteOferta())) {
				try{
					oferta.setImporteOferta(Double.valueOf(dto.getImporteOferta()));
				}catch(NumberFormatException ne){
					logger.warn("Formato numero incorrecto");
					oferta.setImporteOferta(Double.valueOf(dto.getImporteOferta().replace(",", ".")));
				}
				
			   
			}
			oferta.setEstadoOferta(estadoOferta);
			oferta.setTipoOferta(tipoOferta);
			oferta.setFechaAlta(new Date());

			List<OfertasAgrupadasLbk> ofertasAgrupadas = new ArrayList<OfertasAgrupadasLbk>();
		

			if (!Checks.esNulo(dto.getNumOferPrincipal()) || (Checks.esNulo(dto.getNumOferPrincipal()) && !Checks.esNulo(dto.getClaseOferta()))){
				// Se le pasa primero la oferta PRINCIPAL y luego la DEPENDIENTE, siendo la principal la que introduce el usuario y la dependiente la actual que estamos creando
				Oferta oferPrincipal = null;
				if (!Checks.esNulo(dto.getNumOferPrincipal())) {
					oferPrincipal = ofertaApi.getOfertaByNumOfertaRem(dto.getNumOferPrincipal());
					
					// Si la oferta que vamos a poner como principal es agrupada o individual, le cambiamos la clase
					if (!DDClaseOferta.CODIGO_OFERTA_PRINCIPAL.equals(oferPrincipal.getClaseOferta().getCodigo())) {
						ofertaApi.actualizaClaseOferta(oferPrincipal, DDClaseOferta.CODIGO_OFERTA_PRINCIPAL);
					}
				}
				ofertasAgrupadas = ofertaApi.buildListaOfertasAgrupadasLbk(oferPrincipal, oferta, dto.getClaseOferta());
			}
			
			oferta.setOfertasAgrupadas(ofertasAgrupadas);
			
			listaActOfr = ofertaApi.buildListaActivoOferta(null, agrupacion, oferta);

			oferta.setActivosOferta(listaActOfr);
			oferta.setCliente(clienteComercial);
			oferta.setPrescriptor((ActivoProveedor) proveedoresApi.searchProveedorCodigo(dto.getCodigoPrescriptor()));
			oferta.setOrigen("REM");
			oferta.setOfertaExpress(false);
			if (Checks.esNulo(dto.getVentaDirecta())){
				oferta.setVentaDirecta(false);
			} else {				
				oferta.setVentaDirecta(dto.getVentaDirecta());				
			}
			if(!Checks.esNulo(dto.getIdUvem())){
				oferta.setIdUvem(dto.getIdUvem());
			}
			
			if(!Checks.esNulo(dto.getClaseOferta())) {
				oferta.setClaseOferta(genericDao.get(DDClaseOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getClaseOferta())));
			} else if (DDTipoOferta.CODIGO_ALQUILER.equals(tipoOferta.getCodigo()) && activo != null && activo.getCartera() != null 
					&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())){
				DDClaseOferta clase = null;
				clase = genericDao.get(DDClaseOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDClaseOferta.CODIGO_OFERTA_INDIVIDUAL) );
				if(clase != null) {
					oferta.setClaseOferta(clase);
				}
			}
			

			oferta.setGestorComercialPrescriptor(ofertaApi.calcularGestorComercialPrescriptorOferta(oferta));
			
			oferta.setIdOfertaOrigen(dto.getIdOfertaOrigen());
			
			if(Checks.esNulo(dto.getOfrDocRespPrescriptor())) {
				oferta.setOfrDocRespPrescriptor(true);
			} else {
				oferta.setOfrDocRespPrescriptor(dto.getOfrDocRespPrescriptor());
			}
			
			String codigo = null;
			
			if(!oferta.getOfrDocRespPrescriptor()) {
				codigo = DDResponsableDocumentacionCliente.CODIGO_COMPRADORES;
			} else if(oferta.getOfrDocRespPrescriptor() && oferta.getPrescriptor() != null && oferta.getPrescriptor().getCodigoProveedorRem() == 2321) {
				codigo = DDResponsableDocumentacionCliente.CODIGO_GESTORCOMERCIAL;
			} else if(oferta.getOfrDocRespPrescriptor() && oferta.getPrescriptor() != null && oferta.getPrescriptor().getCodigoProveedorRem() != 2321) {
				codigo = DDResponsableDocumentacionCliente.CODIGO_PRESCRIPTOR;
			}
			
			if (codigo != null) {
				DDResponsableDocumentacionCliente respCodCliente = genericDao.get(DDResponsableDocumentacionCliente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigo));
				oferta.setRespDocCliente(respCodCliente);
			}
			
			ofertaNueva = genericDao.save(Oferta.class, oferta);
			
			if(activo != null && activo.getSubcartera() != null &&
					(DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo())
					|| DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))) {
				String codigoBulk = Double.parseDouble(dto.getImporteOferta()) > 750000d 
						? DDSinSiNo.CODIGO_SI : DDSinSiNo.CODIGO_NO;
				
				DDSinSiNo sino = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoBulk));
				OfertaExclusionBulk ofertaExclusionBulk = new OfertaExclusionBulk();
				
				ofertaExclusionBulk.setOferta(ofertaNueva);
				ofertaExclusionBulk.setExclusionBulk(sino);
				ofertaExclusionBulk.setFechaInicio(new Date());
				ofertaExclusionBulk.setUsuarioAccion(genericAdapter.getUsuarioLogado());
				
				genericDao.save(OfertaExclusionBulk.class, ofertaExclusionBulk);
			}			

			// Actualizamos la situacion comercial de los activos de la oferta
			ofertaApi.updateStateDispComercialActivosByOferta(oferta);

			notificationOfertaManager.sendNotification(oferta);
			
			if(TIPO_AGRUPACION_RESTRINGIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())
					|| TIPO_AGRUPACION_RESTRINGIDA_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())
					|| TIPO_AGRUPACION_RESTRINGIDA_OBREM.equals(agrupacion.getTipoAgrupacion().getCodigo())){
				Activo activoPrincipal = agrupacion.getActivoPrincipal();
				PerimetroActivo perActivo = genericDao.get(PerimetroActivo.class, genericDao.createFilter(FilterType.EQUALS,"activo.id", activoPrincipal.getId()), genericDao.createFilter(FilterType.EQUALS,"auditoria.borrado", false));
				if(!Checks.esNulo(perActivo.getAplicaFormalizar())){
					if(perActivo.getAplicaFormalizar().toString().equals(ES_FORMALIZABLE.toString())){
						if(!Checks.esNulo(agrupacion.getIsFormalizacion())){
							if(agrupacion.getIsFormalizacion().toString().equals(NO_ES_FORMALIZABLE.toString())){
								agrupacion.setIsFormalizacion(1);
								activoAgrupacionApi.saveOrUpdate(agrupacion);
							}
						}else{
							agrupacion.setIsFormalizacion(1);
							activoAgrupacionApi.saveOrUpdate(agrupacion);
						}
					}
				}
			}
			
			// HREOS-4937 -- 'General Data Protection Regulation'

			// Comprobamos si existe en la tabla CGD_CLIENTE_GDPR un registro con el mismo
			// número y tipo de documento
			List<ClienteGDPR> cliGDPR = genericDao.getList(ClienteGDPR.class,
					genericDao.createFilter(FilterType.EQUALS, "tipoDocumento.id", tipoDocumento.getId()),
					genericDao.createFilter(FilterType.EQUALS, "numDocumento", dto.getNumDocumentoCliente()));

			AdjuntoComprador docAdjunto = null;
			if (!Checks.esNulo(dto.getIdDocAdjunto())) {
				docAdjunto = genericDao.get(AdjuntoComprador.class,
						genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdDocAdjunto()));
			} 
			
			// Si existe pasamos la información al histórico y actualizamos el objeto con
			// los nuevos datos
			if (!Checks.estaVacio(cliGDPR) && cliGDPR.size() > 0) {

				// Primero historificamos los datos de ClienteGDPR en ClienteCompradorGDPR
				ClienteCompradorGDPR clienteCompradorGDPR = new ClienteCompradorGDPR();
				clienteCompradorGDPR.setTipoDocumento(cliGDPR.get(0).getTipoDocumento());
				clienteCompradorGDPR.setNumDocumento(cliGDPR.get(0).getNumDocumento());
				clienteCompradorGDPR.setCesionDatos(cliGDPR.get(0).getCesionDatos());
				clienteCompradorGDPR.setComunicacionTerceros(cliGDPR.get(0).getComunicacionTerceros());
				clienteCompradorGDPR.setTransferenciasInternacionales(cliGDPR.get(0).getTransferenciasInternacionales());
				if (!Checks.esNulo(cliGDPR.get(0).getAdjuntoComprador())) {
					clienteCompradorGDPR.setAdjuntoComprador(cliGDPR.get(0).getAdjuntoComprador());
				}

				genericDao.save(ClienteCompradorGDPR.class, clienteCompradorGDPR);

				for(ClienteGDPR clc : cliGDPR){
					// Despues se hace el update en ClienteGDPR
					clc.setCliente(clienteComercial);
					clc.setCesionDatos(dto.getCesionDatos());
					clc.setComunicacionTerceros(dto.getComunicacionTerceros());
					clc.setTransferenciasInternacionales(dto.getTransferenciasInternacionales());
	
					if (!Checks.esNulo(docAdjunto)) {
						clc.setAdjuntoComprador(docAdjunto);
					}
					genericDao.update(ClienteGDPR.class, clc);
	
					
				}
				clienteComercialDao.deleteTmpClienteByDocumento(cliGDPR.get(0).getNumDocumento());

				// Si no existe simplemente creamos e insertamos un nuevo objeto ClienteGDPR
			} else {
				ClienteGDPR clienteGDPR =  new ClienteGDPR();
				clienteGDPR.setCliente(clienteComercial);
				clienteGDPR.setTipoDocumento(tipoDocumento);
				clienteGDPR.setNumDocumento(dto.getNumDocumentoCliente());
				clienteGDPR.setCesionDatos(dto.getCesionDatos());
				clienteGDPR.setComunicacionTerceros(dto.getComunicacionTerceros());
				clienteGDPR.setTransferenciasInternacionales(dto.getTransferenciasInternacionales());
				
				if(!Checks.estaVacio(tmpClienteGDPR) && !Checks.esNulo(tmpClienteGDPR.get(0).getIdAdjunto())) {
					docAdjunto = genericDao.get(AdjuntoComprador.class,
							genericDao.createFilter(FilterType.EQUALS, "id", tmpClienteGDPR.get(0).getIdAdjunto()));
				}
				if (!Checks.esNulo(docAdjunto)) {
					clienteGDPR.setAdjuntoComprador(docAdjunto);
				}
				genericDao.save(ClienteGDPR.class, clienteGDPR);
								
				clienteComercialDao.deleteTmpClienteByDocumento(clienteGDPR.getNumDocumento());
			}

		} catch (Exception ex) {
			logger.error("error en agrupacionAdapter", ex);
			return null;
		}

		return ofertaNueva;
	}

	// public List<DtoActivoAviso> getAvisosActivoById(Long id) {
	// FIXME: Formatear aquí o en vista cuando se sepa el diseño.
	public DtoAviso getAvisosAgrupacionById(Long id) {

		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);

		// List<DtoAviso> listaAvisos = new ArrayList<DtoAviso>();
		DtoAviso avisosFormateados = new DtoAviso();
		avisosFormateados.setDescripcion("");

		for (AgrupacionAvisadorApi avisador : avisadores) {

			if (avisador.getAviso(agrupacion, usuarioLogado) != null
					&& avisador.getAviso(agrupacion, usuarioLogado).getDescripcion() != null) {
				avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() + "<div class='div-aviso red'>"
						+ avisador.getAviso(agrupacion, usuarioLogado).getDescripcion() + "</div>");
			}

		}

		return avisosFormateados;

	}

	public Boolean procesarMasivo(Long idProcess, Long idOperation) throws Exception {

		MSVDocumentoMasivo document = ficheroDao.findByIdProceso(idProcess);
		MSVProcesoMasivo proceso = document.getProcesoMasivo();
		if (proceso == null) {
			return false;
		} 			
		if (proceso.getEstadoProceso() != null && MSVDDEstadoProceso.CODIGO_VALIDADO.equals(proceso.getEstadoProceso().getCodigo())) {
			MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(document);
			MSVDDOperacionMasiva tipoOperacion = msvProcesoApi.getOperacionMasiva(idOperation);
			MSVLiberator lib = factoriaLiberators.dameLiberator(tipoOperacion);
			Integer numFilas = exc.getNumeroFilasByHoja(0,document.getProcesoMasivo().getTipoOperacion())-lib.getFilaInicial();			
			processAdapter.setStateProcessing(document.getProcesoMasivo().getId(),new Long(numFilas));
			Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			
			Thread liberarFicheroThread = new Thread(new LiberarFichero(idProcess, idOperation, usu.getUsername(), msvREMUtils.getExtraArgs()));
			liberarFicheroThread.start();

			Thread.sleep(1000);
			return true;
		} else {
			return false;
		}
	}

	@Transactional(readOnly = false)
	public boolean saveObservacionesAgrupacion(DtoObservacion dtoObservacion, Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoObservacion.getId()));
		ActivoAgrupacionObservacion agrupacionObservacion = genericDao.get(ActivoAgrupacionObservacion.class, filtro);

		try {

			beanUtilNotNull.copyProperties(agrupacionObservacion, dtoObservacion);
			genericDao.save(ActivoAgrupacionObservacion.class, agrupacionObservacion);

		} catch (IllegalAccessException e) {
			logger.error("error en agrupacionAdapter", e);
		} catch (InvocationTargetException e) {
			logger.error("error en agrupacionAdapter", e);
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean createObservacionesAgrupacion(DtoObservacion dtoObservacion, Long id) {

		ActivoAgrupacionObservacion agrupacionObservacion = new ActivoAgrupacionObservacion();
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		try {

			agrupacionObservacion.setObservacion(dtoObservacion.getObservacion());
			agrupacionObservacion.setFecha(new Date());
			agrupacionObservacion.setUsuario(usuarioLogado);
			agrupacionObservacion.setAgrupacion(agrupacion);

			ActivoAgrupacionObservacion observacionNueva = genericDao.save(ActivoAgrupacionObservacion.class,
					agrupacionObservacion);

			agrupacion.getAgrupacionObservacion().add(observacionNueva);
			activoAgrupacionApi.saveOrUpdate(agrupacion);

		} catch (Exception e) {
			logger.error("error en agrupacionAdapter", e);
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean deleteObservacionAgrupacion(Long idObservacion) {

		try {

			genericDao.deleteById(ActivoAgrupacionObservacion.class, idObservacion);

		} catch (Exception e) {
			logger.error("error en agrupacionAdapter", e);
		}

		return true;

	}
	
	@Transactional(readOnly = false)
	public void trazarCambioVigencia(Long id,Date fechaInicioVigencia,Date fechaFinVigencia) throws Exception{
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		if(agrupacion == null){
			throw new Exception("No existe la agrupacion");
		}
		
		if(fechaInicioVigencia != null && fechaFinVigencia != null){
			AgrupacionesVigencias agrVigencia = new AgrupacionesVigencias();
			agrVigencia.setAgrupacion(agrupacion);
			agrVigencia.setFechaInicio(fechaInicioVigencia);
			agrVigencia.setFechaFin(fechaFinVigencia);
			genericDao.save(AgrupacionesVigencias.class, agrVigencia);
		}
		
		
	}
	
	/**
	 * Valida un periodo de vigencia
	 * @param dto
	 * @param id
	 * @return 0 si es correcto, 1 faltan datos para validar, 2 fecha fin mayor que fecha inicio, 3 el inicio de la vigencia 
	 * es menor que el fin del periodo anterior, 4  alguno de los activos ya está incluido en otra agrupación asistida vigente
	 */
	public int validateVigencia(DtoAgrupaciones dto, Long id){
		int res = 0;
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		
		//Se saca fuera del if de abajo debido a sonar.
		if(agrupacion != null) {
			if(dto.getFechaFinVigencia() != null || dto.getFechaInicioVigencia() != null){
				if(dto.getFechaFinVigencia().compareTo(dto.getFechaInicioVigencia())<0){
					res = 2;
				}else{
					if(agrupacion.getFechaFinVigencia() != null && dto.getFechaInicioVigencia().compareTo(agrupacion.getFechaFinVigencia())<0){
						res = 3;
					}else if(activoAgrupacionApi.estaActivoEnOtraAgrupacionVigente(agrupacion,null)){
						res = 4;
					}
				}
			}else{
				res = 1;
			}
		}else {
			res = 1;
		}
		
		
		return res;
	}
	
	/**
	 * Valida que un activo es válido para ser activo matriz.
	 * @param activo id
	 * @return Bool cuando es un activo válido para ser activo matriz devuelve true, si no devuelve falso y lanza una excepción.
	 */
	
	public Boolean esActivoMatrizValido(Activo activo, ActivoAgrupacion agr) {
		if(!Checks.esNulo(activo)){
			PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
			if(!Checks.esNulo(perimetroActivo)) {
				if(activoApi.isActivoIncluidoEnPerimetro(activo.getId())) {
					if(!Checks.esNulo(activo.getSituacionComercial())) {
						if(!DDSituacionComercial.CODIGO_VENDIDO.equals(activo.getSituacionComercial().getCodigo())) {
							if(!DDTipoTituloActivo.UNIDAD_ALQUILABLE.equals(activo.getTipoTitulo().getCodigo())) {
								if(!Checks.esNulo(activoApi.getActivoPatrimonio(activo.getId()))) {
									if(!Checks.esNulo(activoApi.getActivoPatrimonio(activo.getId()).getCheckHPM())
											&& activoApi.getActivoPatrimonio(activo.getId()).getCheckHPM()){
										if(!particularValidator.existeActivoConOfertaVivaEstadoExpediente(Long.toString(activo.getNumActivo()))){
											Filter patrimonioFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
											ActivoPatrimonio patrimonioActivo = genericDao.get(ActivoPatrimonio.class, patrimonioFilter);
											if(!Checks.esNulo(patrimonioActivo) && !Checks.esNulo(patrimonioActivo.getTipoEstadoAlquiler())){
											if(!DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO.equals(patrimonioActivo.getTipoEstadoAlquiler().getCodigo())) {
												if (!Checks.estaVacio(activo.getAgrupaciones())) {
													List<ActivoAgrupacionActivo> listaAgrupaciones = activo.getAgrupaciones();
													
													for (ActivoAgrupacionActivo activoAgrupacionActivo : listaAgrupaciones) {
														if(Checks.esNulo(activoAgrupacionActivo.getAgrupacion().getFechaBaja())){
														
															if (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())
																	|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())
																	|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())) {
																throw new JsonViewerException("El activo pertenece a una agrupación restringida");
															} else if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())) {
																throw new JsonViewerException("El activo pertenece a un lote comercial de venta");
															} else if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())) {
																throw new JsonViewerException("El activo pertenece a una agrupación comercial de alquiler");
															} else if (DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())
																	&& !agr.equals(activoAgrupacionActivo.getAgrupacion())) {
																throw new JsonViewerException("El activo ya pertenece a otra agrupación de promoción de alquiler");
															}
														}
													}
												}
												Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
												List <Perfil> perfiles = usu.getPerfiles();
												if(!Checks.estaVacio(perfiles)) {
													for (Perfil perfil : perfiles) {
														if(usuarioSuper.equals(perfil.getCodigo())) {
															return Boolean.TRUE;
														}
													}
												}
													
												List<GestorActivo> gestores = genericDao.getList(GestorActivo.class,genericDao.createFilter(FilterType.EQUALS,"activo.id", activo.getId()),genericDao.createFilter(FilterType.EQUALS,"auditoria.borrado", false));
												
												Boolean esGestorOSupervisorAlquilerComercial = Boolean.FALSE;
												Boolean tieneGestores = Boolean.FALSE;
												if(!Checks.estaVacio(gestores)) {
													for (GestorActivo gestorActivo : gestores) {
														if (ActivoAdapter.CODIGO_SUPERVISOR_COMERCIAL_ALQUILER.equals(gestorActivo.getTipoGestor().getCodigo())
														|| ActivoAdapter.CODIGO_GESTOR_COMERCIAL_ALQUILER.equals(gestorActivo.getTipoGestor().getCodigo())) {
															tieneGestores = Boolean.TRUE;
															if (gestorActivo.getUsuario().getId().equals(usu.getId())) {
																esGestorOSupervisorAlquilerComercial = Boolean.TRUE;  
																break;
															}
														}
													}
													if(esGestorOSupervisorAlquilerComercial) {
														return Boolean.TRUE;
													}
													else if(!tieneGestores) {
														throw new JsonViewerException(ACTIVO_SIN_GESTORES_ADECUADOS);
													}
													else {
														throw new JsonViewerException(ACTIVO_SIN_GESTION);
													}
												}
												throw new JsonViewerException(ACTIVO_SIN_GESTORES);									
											}
											else {
												throw new JsonViewerException(ACTIVO_ALQUILADO);
												}
											}else {
												throw new JsonViewerException(ACTIVO_SIN_ESTADO_ALQUILER);
												}
										
										}else {
												throw new JsonViewerException(ACTIVO_OFERTAS_VIVAS);
										}
									}else {
										throw new JsonViewerException(ACTIVO_NO_INCLUIDO_PERIMETRO_ALQUILER);
									}
								}else {
									throw new JsonViewerException(ACTIVO_SIN_PATRIMONIO_ACTIVO);
								}
							}else { 
								throw new JsonViewerException(TIPO_NO_PERMITIDO_ACTIVO_MATRIZ);
							}
						}else {
							throw new JsonViewerException(ACTIVO_VENDIDO);
						}
					}else {
						throw new JsonViewerException(ACTIVO_SIN_SITUACION_COMERCIAL);
					}
				}else {
					throw new JsonViewerException(ACTIVO_FUERA_PERIMETRO_HAYA);
				}
			}else {
				throw new JsonViewerException(ACTIVO_NO_INCLUIDO_PERIMETRO_ALQUILER);
			}
		}else{
			throw new JsonViewerException(ACTIVO_INEXISTENTE);
			
		}

	}
	
	
	

	@Transactional(readOnly = false, rollbackFor=Exception.class)
	public String saveAgrupacion(DtoAgrupaciones dto, Long id) throws Exception {

		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		boolean vigenciaModificada = false;

		// Primero comprobamos si estamos dandola de baja y se cumplen todos los
		// requisitos para poder hacerlo

		if (!Checks.esNulo(dto.getFechaBaja())) {
			String error = validarBajaAgrupacion(agrupacion);

			if (!Checks.esNulo(error)) {
				throw new JsonViewerException(error);
			}	
		}
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {
			// si modificamos la vigencia nos guardamos la traza
			if (dto.getFechaInicioVigencia() != null) {
				if (agrupacion.getFechaInicioVigencia() == null
						|| !agrupacion.getFechaInicioVigencia().equals(dto.getFechaInicioVigencia())) {
					vigenciaModificada = true;
				}
			}
			if (dto.getFechaFinVigencia() != null) {
				if (agrupacion.getFechaFinVigencia() == null
						|| !agrupacion.getFechaFinVigencia().equals(dto.getFechaFinVigencia())) {
					vigenciaModificada = true;
				}
			}
			if (vigenciaModificada) {
				Date fechaInicioAux = agrupacion.getFechaInicioVigencia();
				Date fechaFinAux = agrupacion.getFechaFinVigencia();
				this.trazarCambioVigencia(id, fechaInicioAux, fechaFinAux);
			}
			if(!Checks.esNulo(dto.getAgrupacionEliminada())){
				agrupacion.setEliminado(BooleanUtils.toInteger(dto.getAgrupacionEliminada()));
			}
		}
		
		// SI ES TIPO PROMOCION ALQUILER
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER)) {
	
			ActivoPromocionAlquiler pa = (ActivoPromocionAlquiler) agrupacion;
			Long idAM = activoDao.getIdActivoMatriz(pa.getId());
			
			try {
				if (!permiteCambiarDestinoComercial(pa)) {
					return "false"+SPLIT_VALUE+OFERTA_INCOMPATIBLE_AGR_MSG;
				} else {
					beanUtilNotNull.copyProperties(pa, dto);
	
					if (dto.getMunicipioCodigo() != null) {
	
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
						Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
	
						pa.setLocalidad(municipioNuevo);
					}

					if (dto.getProvinciaCodigo() != null) {
	
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
						DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);
	
						pa.setProvincia(provinciaNueva);
					}
					
					if(!Checks.esNulo(dto.getActivoMatriz())) {
						Activo act = activoDao.getActivoByNumActivo(dto.getActivoMatriz());
						boolean esActivoMatrizValido = false;
						esActivoMatrizValido = esActivoMatrizValido(act, agrupacion);
						if(esActivoMatrizValido) {
							ActivoAgrupacionActivo aga=activoAgrupacionActivoDao.getAgrupacionPAByIdAgrupacion(id);
							
							if(Checks.esNulo(aga)) {
								aga = new ActivoAgrupacionActivo();
							}
							if(!Checks.esNulo(act.getDireccionCompleta())) {
								pa.setDireccion(act.getDireccionCompleta());
							}
							activoApi.actualizarOfertasTrabajosVivos(act);
							aga.setActivo(act);
							aga.setAgrupacion(pa);
							aga.setFechaInclusion(new Date());
							aga.setPrincipal(1);
							activoAdapter.actualizarEstadoPublicacionActivo(act.getId());
							activoAgrupacionActivoDao.saveOrUpdate(aga);
						}	
					}
					else if(Checks.esNulo(dto.getActivoMatriz()) && Checks.esNulo(dto.getDescripcion()) && Checks.esNulo(dto.getNombre()) &&
							Checks.esNulo(dto.getNumAgrupPrinexHPM()) && Checks.esNulo(dto.getFechaBaja())) {
							ActivoAgrupacionActivo aga = activoAgrupacionActivoDao.getAgrupacionPAByIdAgrupacion(id);
							pa.setDireccion(null);
							if(!Checks.esNulo(aga)) {
								activoAgrupacionActivoDao.deleteById(aga.getId());
							}
					}
					
					
					activoAgrupacionApi.saveOrUpdate(pa);
				}
				
				if (!Checks.esNulo(dto.getFechaBaja())) {
					List<ActivoAgrupacionActivo> activoAgrupacionPA = new ArrayList<ActivoAgrupacionActivo>();
					Filter filtroAgrupacion = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", agrupacion.getId());
					Filter filtroActivosAgrupacion = genericDao.createFilter(FilterType.EQUALS, "principal", 0);
					activoAgrupacionPA = genericDao.getList(ActivoAgrupacionActivo.class, filtroAgrupacion, filtroActivosAgrupacion);
					
					if(!Checks.esNulo(idAM)) {
						Filter filterIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idAM);
						Filter filterIdAgrupacion = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", agrupacion.getId());
						ActivoAgrupacionActivo aga = genericDao.get(ActivoAgrupacionActivo.class, filterIdActivo, filterIdAgrupacion);
					
						if(!Checks.esNulo(aga)) {
							activoAgrupacionActivoDao.deleteById(aga.getId());
							pa.setDireccion(null);
						}
						activoAdapter.actualizarEstadoPublicacionActivo(idAM);
					}
					if (!Checks.estaVacio(activoAgrupacionPA)) {
						
						for (ActivoAgrupacionActivo activo : activoAgrupacionPA) {
							Long idActivo = activo.getActivo().getId();
								Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
								Activo activoActual = activo.getActivo();
								PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtroActivo);
								ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, filtroActivo);
								
								if(!Checks.esNulo(activoPatrimonio)) {
									activoPatrimonio.setCheckHPM(false);
									
								}
								
								if (!Checks.esNulo(perimetroActivo)) {
									perimetroActivo.setActivo(activoActual);
									perimetroActivo.setIncluidoEnPerimetro(0);
									perimetroActivo.setAplicaTramiteAdmision(0);
									perimetroActivo.setAplicaGestion(0);
									perimetroActivo.setAplicaAsignarMediador(0);
									perimetroActivo.setAplicaComercializar(0);
									perimetroActivo.setAplicaFormalizar(0);
									perimetroActivo.setAplicaPublicar(false);
									
									genericDao.save(PerimetroActivo.class, perimetroActivo);
							}
						}
					}	
				}
	
			} catch (Exception e) {
				logger.error("error en agrupacionAdapter", e);
				throw new JsonViewerException(e.getMessage());
			}
		}

		// SI ES TIPO OBRA NUEVA
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {

			ActivoObraNueva obraNueva = (ActivoObraNueva) agrupacion;

			try {
				if(!permiteCambiarDestinoComercial(obraNueva))
				{
					return "false"+SPLIT_VALUE+OFERTA_INCOMPATIBLE_AGR_MSG;
				}
				else
				{
					beanUtilNotNull.copyProperties(obraNueva, dto);

					if (dto.getMunicipioCodigo() != null) {

						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
						Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);

						obraNueva.setLocalidad(municipioNuevo);
					}

					if (dto.getEstadoObraNuevaCodigo() != null) {

						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
								dto.getEstadoObraNuevaCodigo());
						DDEstadoObraNueva estadoNuevo = (DDEstadoObraNueva) genericDao.get(DDEstadoObraNueva.class, filtro);

						obraNueva.setEstadoObraNueva(estadoNuevo);

					}

					if (dto.getProvinciaCodigo() != null) {

						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
						DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);

						obraNueva.setProvincia(provinciaNueva);
					}
					
					if (!Checks.esNulo(dto.getPisoPiloto())){
						Activo pisoPiloto = activoAgrupacionActivoApi.getPisoPilotoByIdAgrupacion(id);
						
						if (!Checks.esNulo(pisoPiloto)) {
							Activo pisoPilotoOld = pisoPiloto;
							ActivoAgrupacionActivo aga_piloto;
							//Si se quiere definir un piso piloto pero no existe en la agrupación, mostramos mensaje de error
							pisoPiloto = this.isActivoValido(agrupacion, dto.getPisoPiloto());
							Filter filtro_piloto = genericDao.createFilter(FilterType.EQUALS, "activo.id", pisoPilotoOld.getId()); 
							aga_piloto = genericDao.get(ActivoAgrupacionActivo.class, filtro_piloto);
							if(!Checks.esNulo(aga_piloto)){
								aga_piloto.setPisoPiloto(false);
								activoAgrupacionActivoDao.saveOrUpdate(aga_piloto);
							}
							// Anyadir piso piloto nuevo
							filtro_piloto = genericDao.createFilter(FilterType.EQUALS, "activo.id", pisoPiloto.getId()); 
							aga_piloto = genericDao.get(ActivoAgrupacionActivo.class, filtro_piloto);
							if(!Checks.esNulo(aga_piloto)){
								aga_piloto.setPisoPiloto(true);
								activoAgrupacionActivoDao.saveOrUpdate(aga_piloto);
							}
						}else {
							pisoPiloto = this.isActivoValido(agrupacion, dto.getPisoPiloto());
							//Si no hay piso piloto definido y el seleccionado es de Yubai, procedemos a guardar los cambios
							Filter filtro_piloto = genericDao.createFilter(FilterType.EQUALS, "activo.id", pisoPiloto.getId());
							ActivoAgrupacionActivo aga_piloto = genericDao.get(ActivoAgrupacionActivo.class, filtro_piloto);
							if(!Checks.esNulo(aga_piloto)){
								aga_piloto.setPisoPiloto(true);
								agrupacion.setExistePiloto(true);
								activoAgrupacionActivoDao.saveOrUpdate(aga_piloto);
							}
						}
					}else {
						Activo pisoPiloto = activoAgrupacionActivoApi.getPisoPilotoByIdAgrupacion(id);
						if(!Checks.esNulo(pisoPiloto)) {
							ActivoAgrupacionActivo aga_piloto;
							Filter filtro_piloto = genericDao.createFilter(FilterType.EQUALS, "activo.id", pisoPiloto.getId()); 
							aga_piloto = genericDao.get(ActivoAgrupacionActivo.class, filtro_piloto);
							if(!Checks.esNulo(aga_piloto)){
								aga_piloto.setPisoPiloto(false);
								activoAgrupacionActivoDao.saveOrUpdate(aga_piloto);
							}
						}
					}
					if(!Checks.esNulo(dto.getEsVisitable())) {
						agrupacion.setEsVisitable(dto.getEsVisitable());
					}
					
					if(!Checks.esNulo(dto.getComercializableConsPlano())) {
						agrupacion.setComercializableConsPlano(dto.getComercializableConsPlano());
					}
					
					if(!Checks.esNulo(dto.getEmpresaPromotora())) {
						agrupacion.setEmpresaPromotora(dto.getEmpresaPromotora());
					}
					
					if(!Checks.esNulo(dto.getEmpresaComercializadora())) {
						agrupacion.setEmpresaComercializadora(dto.getEmpresaComercializadora());
					}
					
					if (!Checks.esNulo(dto.getVentaSobrePlano())){
						
						Filter filtroSi = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_SI);
						Filter filtroNo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_NO);
						
						if(dto.getVentaSobrePlano()) {
							obraNueva.setVentaPlano(genericDao.get(DDSinSiNo.class, filtroSi));
							
						}else {
							obraNueva.setVentaPlano(genericDao.get(DDSinSiNo.class, filtroNo));
						}
						

						List<ActivoAgrupacionActivo> listaActivos = obraNueva.getActivos();
						for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivos) {
							Activo activo=activoAgrupacionActivo.getActivo();
							if(dto.getVentaSobrePlano()) {
								activo.setVentaSobrePlano(genericDao.get(DDSinSiNo.class, filtroSi));
							}else {
								activo.setVentaSobrePlano(genericDao.get(DDSinSiNo.class, filtroNo));
							}
							
							activoDao.save(activo);
						}
						
					}
					
					activoAgrupacionApi.saveOrUpdate(obraNueva);
				}

			} catch (JsonViewerException jsonViewerException) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return "false"+SPLIT_VALUE+jsonViewerException.getMessage();
			} catch (Exception e) {
				logger.error("error en agrupacionAdapter", e);
				return "false";
			}
			
		} else {
			if (!Checks.esNulo(dto.getPisoPiloto())){
				//Si se quiere definir un piso piloto pero la agrupación no es de obra nueva, mostramos mensaje de error
				throw new JsonViewerException(ACTIVO_NO_OBRA_NUEVA);
			}
		}

		// Si es de tipo 'Lote Comercial-Venta'.
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
			ActivoLoteComercial loteComercial = (ActivoLoteComercial) agrupacion;

			try {
				beanUtilNotNull.copyProperties(loteComercial, dto);

				if (dto.getMunicipioCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
					Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);

					loteComercial.setLocalidad(municipioNuevo);
				}

				if (dto.getProvinciaCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
					DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);

					loteComercial.setProvincia(provinciaNueva);
				}

				if (!Checks.esNulo(dto.getCodigoGestoriaFormalizacion())) {
					Usuario usuario = proxyFactory.proxy(UsuarioApi.class).get(dto.getCodigoGestoriaFormalizacion());
					loteComercial.setUsuarioGestoriaFormalizacion(usuario);
				}
				if (!Checks.esNulo(dto.getCodigoGestorComercial())) {
					Usuario usuario = proxyFactory.proxy(UsuarioApi.class).get(dto.getCodigoGestorComercial());
					loteComercial.setUsuarioGestorComercial(usuario);
				}
				if (!Checks.esNulo(dto.getCodigoGestorFormalizacion())) {
					Usuario usuario = proxyFactory.proxy(UsuarioApi.class).get(dto.getCodigoGestorFormalizacion());
					loteComercial.setUsuarioGestorFormalizacion(usuario);
				}
				if (!Checks.esNulo(dto.getCodigoGestorComercialBackOffice())) {
					Usuario usuario = proxyFactory.proxy(UsuarioApi.class)
							.get(dto.getCodigoGestorComercialBackOffice());
					loteComercial.setUsuarioGestorComercialBackOffice(usuario);
				}
				// TODO: 1er comprovar si es pot canviar "formalizacion"

				activoAgrupacionApi.saveOrUpdate(loteComercial);

				List <Oferta> ofertasAgr = loteComercial.getOfertas();

				Boolean ofertaViva = false;

				DDTipoComercializacion tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoComercializacion.class, dto.getTipoComercializacionCodigo());

				if(!ofertaViva) {
					List<ActivoAgrupacionActivo> listaActivos = loteComercial.getActivos();

					if(!Checks.estaVacio(listaActivos)) {
						for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivos) {

						if(activoAgrupacionActivo.getActivo() != null && activoAgrupacionActivo.getActivo().getActivoPublicacion()!= null && tipoComercializacion != null){
								ActivoPublicacion activoPublicacion = activoAgrupacionActivo.getActivo().getActivoPublicacion();
								activoPublicacion.setTipoComercializacion(tipoComercializacion);
								Activo activo=activoAgrupacionActivo.getActivo();
								activo.setTipoComercializacion(tipoComercializacion);
								activoPublicacionDao.saveOrUpdate(activoPublicacion);
								genericDao.save(Activo.class, activo);
							}
						}
					}
				}
			}  catch (JsonViewerException jve) {
				return "false"+SPLIT_VALUE+jve.getMessage();
			} catch (Exception e) {
				logger.error("error en agrupacionAdapter", e);
				return "false";
			}
		}

		// Si es de tipo 'Lote Comercial-Alquiler'.
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER)) {
			ActivoLoteComercial loteComercial = (ActivoLoteComercial) agrupacion;

			try {
				beanUtilNotNull.copyProperties(loteComercial, dto);

				if (!Checks.esNulo(dto.getMunicipioCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
					Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);

					loteComercial.setLocalidad(municipioNuevo);
				}

				if (!Checks.esNulo(dto.getProvinciaCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
					DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);

					loteComercial.setProvincia(provinciaNueva);
				}

				if (!Checks.esNulo(dto.getTipoAlquilerCodigo())) {

					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoAlquilerCodigo());
					DDTipoAlquiler tipoAlquiler = (DDTipoAlquiler) genericDao.get(DDTipoAlquiler.class, filtro);

					loteComercial.setTipoAlquiler(tipoAlquiler);
				}


				if (!Checks.esNulo(dto.getCodigoGestorComercial())) {
					Usuario usuario = proxyFactory.proxy(UsuarioApi.class).get(dto.getCodigoGestorComercial());
					loteComercial.setUsuarioGestorComercial(usuario);
				}

				List <Oferta> ofertasAgr = loteComercial.getOfertas();

				Boolean ofertaViva = false;

				DDTipoComercializacion tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoComercializacion.class, dto.getTipoComercializacionCodigo());

				
				if(!ofertaViva && !Checks.esNulo(tipoComercializacion)) {
					List<ActivoAgrupacionActivo> listaActivos = loteComercial.getActivos();

					if(!Checks.estaVacio(listaActivos)) {
						for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivos) {
							ActivoPublicacion activoPublicacion = activoAgrupacionActivo.getActivo().getActivoPublicacion();
							activoPublicacion.setTipoComercializacion(tipoComercializacion);
							activoPublicacionDao.saveOrUpdate(activoPublicacion);
						}
					}
				}

				activoAgrupacionApi.saveOrUpdate(loteComercial);

			}  catch (JsonViewerException jve) {
				return "false"+SPLIT_VALUE+jve.getMessage();
			} catch (Exception e) {
				logger.error("error en agrupacionAdapter", e);
				return "false";
			}
		}

		// Si es de tipo 'Asistida'.
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {
			ActivoAsistida asistida = (ActivoAsistida) agrupacion;

			try {
				beanUtilNotNull.copyProperties(asistida, dto);
				if(vigenciaModificada){
					asistida.setFechaBaja(null);
				}

				if (dto.getMunicipioCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
					Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);

					asistida.setLocalidad(municipioNuevo);
				}

				if (dto.getProvinciaCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
					DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);

					asistida.setProvincia(provinciaNueva);
				}

				activoAgrupacionApi.saveOrUpdate(asistida);

			} catch (Exception e) {
				logger.error("error en agrupacionAdapter", e);
				return "false";
			}
		}

		// Si es de tipo 'Restringida'.
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {

			ActivoRestringida restringida = (ActivoRestringida) agrupacion;

			try
			{
				// Si el destino comercial = Alquiler y venta, no permitirá cambiar el destino comercial = venta
				Activo activoPrincipal = agrupacion.getActivoPrincipal();
				String codigoDestinoComercial = "";
				if(activoPrincipal != null && activoPrincipal.getActivoPublicacion() != null && activoPrincipal.getActivoPublicacion().getTipoComercializacion() != null){
					codigoDestinoComercial = activoPrincipal.getActivoPublicacion().getTipoComercializacion().getCodigo();
				}

				if (DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(codigoDestinoComercial)
						&& DDTipoComercializacion.CODIGO_VENTA.equals(dto.getTipoComercializacionCodigo())) {
					List<ActivoAgrupacionActivo> listaActivos = restringida.getActivos();

					if(!Checks.estaVacio(listaActivos)) {
						ActivoPatrimonio activoPatrimonio;
						for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivos) {
							activoPatrimonio = activoPatrimonioDao.getActivoPatrimonioByActivo(activoAgrupacionActivo.getActivo().getId());
							if (!Checks.esNulo(activoPatrimonio) && !Checks.esNulo(activoPatrimonio.getTipoEstadoAlquiler()) && DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO.equals(activoPatrimonio.getTipoEstadoAlquiler().getCodigo())) {
								return "false"+SPLIT_VALUE+AGRUPACION_CAMBIO_DEST_COMERCIAL_A_VENTA_CON_ALQUILADOS;
							}
						}
					}
				}

				if(!permiteCambiarDestinoComercial(restringida))
				{
					return "false"+SPLIT_VALUE+OFERTA_INCOMPATIBLE_AGR_MSG;
				}
				else
				{
					beanUtilNotNull.copyProperties(restringida, dto);

					if(dto.getMunicipioCodigo() != null)
					{
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
						Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
						restringida.setLocalidad(municipioNuevo);
					}
					if(dto.getProvinciaCodigo() != null)
					{
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
						DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);
						restringida.setProvincia(provinciaNueva);
					}

					activoAgrupacionApi.saveOrUpdate(restringida);

					List <Oferta> ofertasAgr = restringida.getOfertas();

					Boolean ofertaViva = false;
					Boolean ofertaVivaVenta = false;
					Boolean ofertaVivaAlquiler = false;
					String codigo = null;

					DDTipoComercializacion tipoComercializacion = null;
					
					if(dto.getTipoComercializacionCodigo() != null) {
						tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, dto.getTipoComercializacionCodigo());
					}else {
						Activo activoParaRestringida = null;
						if(restringida.getActivoPrincipal() != null) {
							activoParaRestringida = restringida.getActivoPrincipal();
						}else if(restringida.getActivos() != null && !restringida.getActivos().isEmpty()){
							activoParaRestringida = restringida.getActivos().get(0).getActivo();
						}	
						if(activoParaRestringida != null && activoParaRestringida.getActivoPublicacion() != null && activoParaRestringida.getActivoPublicacion().getTipoComercializacion() != null) {
							String tipoComercializacionString = activoParaRestringida.getActivoPublicacion().getTipoComercializacion().getCodigo();
							tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, tipoComercializacionString);
						}
					}


					if(!Checks.estaVacio(ofertasAgr)) {
						for(Oferta oferta : ofertasAgr) {
							if(DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
								ofertaViva = true;
								if(DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
									ofertaVivaVenta = true;
								}

								if(DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())) {
									ofertaVivaAlquiler = true;
								}
								break;
							}
						}
					}
					//HREOS-12346
					
					if(dto.getMarcaDeExcluido() != null || dto.getVisibleGestionComercial() != null) {
						Boolean excluirValidaciones = dto.getMarcaDeExcluido();
						Boolean checkGestorComercial = dto.getVisibleGestionComercial();
						for (ActivoAgrupacionActivo aga : agrupacion.getActivos()) {
							Map <Long,List<String>> map = recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(aga.getActivo(), checkGestorComercial, excluirValidaciones ,true);
							recalculoVisibilidadComercialApi.lanzarPrimerErrorSiTiene(map);
							
						}
					}
				
					saveActivosVisiblesGestionComercial(dto,id);

					
					if(!ofertaViva) {
						List<ActivoAgrupacionActivo> listaActivos = restringida.getActivos();

						if(!Checks.estaVacio(listaActivos)) {
							for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivos) {
								ActivoPatrimonio activoPatrimonio = activoPatrimonioDao.getActivoPatrimonioByActivo(activoAgrupacionActivo.getActivo().getId());
								ActivoPublicacion activoPublicacion = activoAgrupacionActivo.getActivo().getActivoPublicacion();
								Activo activo = activoPublicacion.getActivo();

								if(!ofertaVivaAlquiler || !ofertaVivaVenta) {
									ActivoHistoricoPatrimonio newActiHistPatrimonio = new ActivoHistoricoPatrimonio();
									if(!Checks.esNulo(activoPatrimonio)) {
										newActiHistPatrimonio.setActivo(activoPatrimonio.getActivo());
										newActiHistPatrimonio.setAdecuacionAlquiler(activoPatrimonio.getAdecuacionAlquiler());
										newActiHistPatrimonio.setCheckHPM(activoPatrimonio.getCheckHPM());
										newActiHistPatrimonio.setFechaFinAdecuacionAlquiler(new Date());
										newActiHistPatrimonio.setFechaFinHPM(new Date());
										newActiHistPatrimonio.setFechaInicioAdecuacionAlquiler(new Date());
										newActiHistPatrimonio.setFechaInicioHPM(new Date());
									}else {
										newActiHistPatrimonio.setCheckHPM(false);
										newActiHistPatrimonio.setFechaInicioHPM(new Date());
										newActiHistPatrimonio.setFechaFinAdecuacionAlquiler(new Date());
										newActiHistPatrimonio.setFechaFinHPM(new Date());
										newActiHistPatrimonio.setFechaInicioAdecuacionAlquiler(new Date());
										newActiHistPatrimonio.setActivo(activoAgrupacionActivo.getActivo());
									}
									activoHistoricoPatrimonioDao.saveOrUpdate(newActiHistPatrimonio);
								}

								if(Checks.esNulo(activoPatrimonio)) {
									activoPatrimonio = new ActivoPatrimonio();
									activoPatrimonio.setActivo(activoAgrupacionActivo.getActivo());
								}
								if(Checks.esNulo(activoPublicacion)) {
									activoPublicacion = new ActivoPublicacion();
									activoPublicacion.setActivo(activoAgrupacionActivo.getActivo());
								}

								if(dto.getTipoComercializacionCodigo() != null) {
									activoEstadoPublicacionApi.actualizarPublicacionActivoCambioTipoComercializacion(activo, dto.getTipoComercializacionCodigo());
								}
								
								if(!ofertaVivaAlquiler && DDTipoComercializacion.CODIGO_VENTA.equals(dto.getTipoComercializacionCodigo())) {
									activoPatrimonio.setCheckHPM(false);
								}

								if(!ofertaVivaVenta && DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(dto.getTipoComercializacionCodigo())) {
									activoPatrimonio.setCheckHPM(true);

								}

								if(DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(dto.getTipoComercializacionCodigo())) {
									activoPatrimonio.setCheckHPM(true);
								}


								if (!Checks.esNulo(activoPublicacion.getTipoComercializacion())) {
									switch(Integer.parseInt(activoPublicacion.getTipoComercializacion().getCodigo())) {
										case 1:
											codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA;
											break;
										case 2:
											codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_ALQUILER;
											break;
										case 3:
											codigo = DDSituacionComercial.CODIGO_DISPONIBLE_ALQUILER;
											break;
										default:
											break;
									}
								}


								String codigoSituacion = codigo;

								if(!Checks.esNulo(codigoSituacion)) {
									activo.setSituacionComercial((DDSituacionComercial)utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionComercial.class,codigoSituacion));
								}
								activoPatrimonioDao.saveOrUpdate(activoPatrimonio);
								activoPublicacionDao.saveOrUpdate(activoPublicacion);
								
								//HREOS-5090 Punto 93
								//Asignar Gestores al cambiar el destino comercial de la agrupación si pasamos de 'alquiler y venta' a 'alquiler'
								//Se descartan los cambios por que es lo que me han indicado desde producto, pero no lo borro por si en un futuro se utiliza
								/*if(DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(destino_comercial) && DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tipoComercializacion.getCodigo())) {

									Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "activo", activoAgrupacionActivo.getActivo());
									List<GestorActivo> gestores_activo  = (List<GestorActivo>) genericDao.getList(GestorActivo.class, filtro2);
									for(GestorActivo gest : gestores_activo) {
										if(TIPO_GESTOR_COMERCIAL_VENTA.equals(gest.getTipoGestor().getCodigo())) {
											//borramos el gestor del activo
											gestorActivoDao.delete(gest);
											//y agregamos el gestor al historico del activo
											Filter filt= genericDao.createFilter(FilterType.EQUALS, "activo", activoAgrupacionActivo.getActivo());
											Filter filt1 = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", TIPO_GESTOR_COMERCIAL_VENTA);
											Filter filt3 = genericDao.createFilter(FilterType.NULL, "fechaHasta");
											GestorActivoHistorico gah_g=genericDao.get(GestorActivoHistorico.class,filt,filt1,filt3);
											if(!Checks.esNulo(gah_g)) {
													gah_g.setFechaHasta(new Date());
													genericDao.update(GestorActivoHistorico.class, gah_g);
											}

										}else if(TIPO_SUPERVISOR_COMERCIAL_VENTA.equals(gest.getTipoGestor().getCodigo())) {
											//borramos el gestor del activo
											gestorActivoDao.delete(gest);
											//y agregamos el gestor al historico del activo
											Filter filt= genericDao.createFilter(FilterType.EQUALS, "activo", activoAgrupacionActivo.getActivo());
											Filter filt2 = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", TIPO_SUPERVISOR_COMERCIAL_VENTA);
											Filter filt3 = genericDao.createFilter(FilterType.NULL, "fechaHasta");

											GestorActivoHistorico gah_s=genericDao.get(GestorActivoHistorico.class,filt,filt2,filt3);
											if(!Checks.esNulo(gah_s)) {
													gah_s.setFechaHasta(new Date());
													genericDao.update(GestorActivoHistorico.class, gah_s);
											}
										}


									}

								}*/


							}
						}
					} else {
						if(tipoComercializacion  == null) {
							throw new JsonViewerException(TIPO_COMERCIALIZACION_NO_VALIDO);
						}else if (ofertaVivaAlquiler && DDTipoComercializacion.CODIGO_VENTA.equals(tipoComercializacion.getCodigo())) {
							throw new JsonViewerException(AGRUPACION_CAMBIO_DEST_COMERCIAL_CON_OFERTAS_VIVAS);
						} else if ( ofertaVivaVenta && DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tipoComercializacion.getCodigo())) {
							throw new JsonViewerException(AGRUPACION_CAMBIO_DEST_COMERCIAL_CON_OFERTAS_VIVAS);
						}
					}
				}
			} catch (JsonViewerException jve) {
				return "false"+SPLIT_VALUE+jve.getMessage();
			} catch (Exception e) {
				logger.error("error en agrupacionAdapter", e);
				return null;
			}
		}
		
		// Si es de tipo 'Restringida Alquiler'.
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)) {

			ActivoRestringidaAlquiler restringidaAlquiler = (ActivoRestringidaAlquiler) agrupacion;

			try
			{
				// Si el destino comercial = Alquiler y venta, no permitirá cambiar el destino comercial = venta
				Activo activoPrincipal = agrupacion.getActivoPrincipal();
				String codigoDestinoComercial = "";
				if(activoPrincipal != null && activoPrincipal.getActivoPublicacion() != null && activoPrincipal.getActivoPublicacion().getTipoComercializacion() != null){
					codigoDestinoComercial = activoPrincipal.getActivoPublicacion().getTipoComercializacion().getCodigo();
				}

				if (DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(codigoDestinoComercial)
						&& DDTipoComercializacion.CODIGO_VENTA.equals(dto.getTipoComercializacionCodigo())) {
					List<ActivoAgrupacionActivo> listaActivos = restringidaAlquiler.getActivos();

					if(!Checks.estaVacio(listaActivos)) {
						ActivoPatrimonio activoPatrimonio;
						for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivos) {
							activoPatrimonio = activoPatrimonioDao.getActivoPatrimonioByActivo(activoAgrupacionActivo.getActivo().getId());
							if (!Checks.esNulo(activoPatrimonio) && !Checks.esNulo(activoPatrimonio.getTipoEstadoAlquiler()) && DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO.equals(activoPatrimonio.getTipoEstadoAlquiler().getCodigo())) {
								return "false"+SPLIT_VALUE+AGRUPACION_CAMBIO_DEST_COMERCIAL_A_VENTA_CON_ALQUILADOS;
							}
						}
					}
				}

				if(!permiteCambiarDestinoComercial(restringidaAlquiler))
				{
					return "false"+SPLIT_VALUE+OFERTA_INCOMPATIBLE_AGR_MSG;
				}
				else
				{
					beanUtilNotNull.copyProperties(restringidaAlquiler, dto);

					if(dto.getMunicipioCodigo() != null)
					{
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
						Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
						restringidaAlquiler.setLocalidad(municipioNuevo);
					}
					if(dto.getProvinciaCodigo() != null)
					{
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
						DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);
						restringidaAlquiler.setProvincia(provinciaNueva);
					}

					activoAgrupacionApi.saveOrUpdate(restringidaAlquiler);

					List <Oferta> ofertasAgr = restringidaAlquiler.getOfertas();

					Boolean ofertaViva = false;
					Boolean ofertaVivaVenta = false;
					Boolean ofertaVivaAlquiler = false;
					String codigo = null;

					DDTipoComercializacion tipoComercializacion = null;
					
					if(dto.getTipoComercializacionCodigo() != null) {
						tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, dto.getTipoComercializacionCodigo());
					}else {
						Activo activoParaRestringida = null;
						if(restringidaAlquiler.getActivoPrincipal() != null) {
							activoParaRestringida = restringidaAlquiler.getActivoPrincipal();
						}else if(restringidaAlquiler.getActivos() != null && !restringidaAlquiler.getActivos().isEmpty()){
							activoParaRestringida = restringidaAlquiler.getActivos().get(0).getActivo();
						}	
						if(activoParaRestringida != null && activoParaRestringida.getActivoPublicacion() != null && activoParaRestringida.getActivoPublicacion().getTipoComercializacion() != null) {
							String tipoComercializacionString = activoParaRestringida.getActivoPublicacion().getTipoComercializacion().getCodigo();
							tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, tipoComercializacionString);
						}
					}


					if(!Checks.estaVacio(ofertasAgr)) {
						for(Oferta oferta : ofertasAgr) {
							if(DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
								ofertaViva = true;
								if(DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
									ofertaVivaVenta = true;
								}

								if(DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())) {
									ofertaVivaAlquiler = true;
								}
								break;
							}
						}
					}
					//HREOS-12346
					
					if(dto.getMarcaDeExcluido() != null || dto.getVisibleGestionComercial() != null) {
						Boolean excluirValidaciones = dto.getMarcaDeExcluido();
						Boolean checkGestorComercial = dto.getVisibleGestionComercial();
						for (ActivoAgrupacionActivo aga : agrupacion.getActivos()) {
							Map <Long,List<String>> map = recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(aga.getActivo(), checkGestorComercial, excluirValidaciones ,true);
							recalculoVisibilidadComercialApi.lanzarPrimerErrorSiTiene(map);
							
						}
					}
				
					saveActivosVisiblesGestionComercial(dto,id);

					
					if(!ofertaViva) {
						List<ActivoAgrupacionActivo> listaActivos = restringidaAlquiler.getActivos();

						if(!Checks.estaVacio(listaActivos)) {
							for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivos) {
								ActivoPatrimonio activoPatrimonio = activoPatrimonioDao.getActivoPatrimonioByActivo(activoAgrupacionActivo.getActivo().getId());
								ActivoPublicacion activoPublicacion = activoAgrupacionActivo.getActivo().getActivoPublicacion();
								Activo activo = activoPublicacion.getActivo();

								if(!ofertaVivaAlquiler || !ofertaVivaVenta) {
									ActivoHistoricoPatrimonio newActiHistPatrimonio = new ActivoHistoricoPatrimonio();
									if(!Checks.esNulo(activoPatrimonio)) {
										newActiHistPatrimonio.setActivo(activoPatrimonio.getActivo());
										newActiHistPatrimonio.setAdecuacionAlquiler(activoPatrimonio.getAdecuacionAlquiler());
										newActiHistPatrimonio.setCheckHPM(activoPatrimonio.getCheckHPM());
										newActiHistPatrimonio.setFechaFinAdecuacionAlquiler(new Date());
										newActiHistPatrimonio.setFechaFinHPM(new Date());
										newActiHistPatrimonio.setFechaInicioAdecuacionAlquiler(new Date());
										newActiHistPatrimonio.setFechaInicioHPM(new Date());
									}else {
										newActiHistPatrimonio.setCheckHPM(false);
										newActiHistPatrimonio.setFechaInicioHPM(new Date());
										newActiHistPatrimonio.setFechaFinAdecuacionAlquiler(new Date());
										newActiHistPatrimonio.setFechaFinHPM(new Date());
										newActiHistPatrimonio.setFechaInicioAdecuacionAlquiler(new Date());
										newActiHistPatrimonio.setActivo(activoAgrupacionActivo.getActivo());
									}
									activoHistoricoPatrimonioDao.saveOrUpdate(newActiHistPatrimonio);
								}

								if(Checks.esNulo(activoPatrimonio)) {
									activoPatrimonio = new ActivoPatrimonio();
									activoPatrimonio.setActivo(activoAgrupacionActivo.getActivo());
								}
								if(Checks.esNulo(activoPublicacion)) {
									activoPublicacion = new ActivoPublicacion();
									activoPublicacion.setActivo(activoAgrupacionActivo.getActivo());
								}

								if(dto.getTipoComercializacionCodigo() != null) {
									activoEstadoPublicacionApi.actualizarPublicacionActivoCambioTipoComercializacion(activo, dto.getTipoComercializacionCodigo());
								}
								
								if(!ofertaVivaAlquiler && DDTipoComercializacion.CODIGO_VENTA.equals(dto.getTipoComercializacionCodigo())) {
									activoPatrimonio.setCheckHPM(false);
								}

								if(!ofertaVivaVenta && DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(dto.getTipoComercializacionCodigo())) {
									activoPatrimonio.setCheckHPM(true);

								}

								if(DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(dto.getTipoComercializacionCodigo())) {
									activoPatrimonio.setCheckHPM(true);
								}


								if (!Checks.esNulo(activoPublicacion.getTipoComercializacion())) {
									switch(Integer.parseInt(activoPublicacion.getTipoComercializacion().getCodigo())) {
										case 1:
											codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA;
											break;
										case 2:
											codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_ALQUILER;
											break;
										case 3:
											codigo = DDSituacionComercial.CODIGO_DISPONIBLE_ALQUILER;
											break;
										default:
											break;
									}
								}


								String codigoSituacion = codigo;

								if(!Checks.esNulo(codigoSituacion)) {
									activo.setSituacionComercial((DDSituacionComercial)utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionComercial.class,codigoSituacion));
								}
								activoPatrimonioDao.saveOrUpdate(activoPatrimonio);
								activoPublicacionDao.saveOrUpdate(activoPublicacion);
								
								//HREOS-5090 Punto 93
								//Asignar Gestores al cambiar el destino comercial de la agrupación si pasamos de 'alquiler y venta' a 'alquiler'
								//Se descartan los cambios por que es lo que me han indicado desde producto, pero no lo borro por si en un futuro se utiliza
								/*if(DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(destino_comercial) && DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tipoComercializacion.getCodigo())) {

									Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "activo", activoAgrupacionActivo.getActivo());
									List<GestorActivo> gestores_activo  = (List<GestorActivo>) genericDao.getList(GestorActivo.class, filtro2);
									for(GestorActivo gest : gestores_activo) {
										if(TIPO_GESTOR_COMERCIAL_VENTA.equals(gest.getTipoGestor().getCodigo())) {
											//borramos el gestor del activo
											gestorActivoDao.delete(gest);
											//y agregamos el gestor al historico del activo
											Filter filt= genericDao.createFilter(FilterType.EQUALS, "activo", activoAgrupacionActivo.getActivo());
											Filter filt1 = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", TIPO_GESTOR_COMERCIAL_VENTA);
											Filter filt3 = genericDao.createFilter(FilterType.NULL, "fechaHasta");
											GestorActivoHistorico gah_g=genericDao.get(GestorActivoHistorico.class,filt,filt1,filt3);
											if(!Checks.esNulo(gah_g)) {
													gah_g.setFechaHasta(new Date());
													genericDao.update(GestorActivoHistorico.class, gah_g);
											}

										}else if(TIPO_SUPERVISOR_COMERCIAL_VENTA.equals(gest.getTipoGestor().getCodigo())) {
											//borramos el gestor del activo
											gestorActivoDao.delete(gest);
											//y agregamos el gestor al historico del activo
											Filter filt= genericDao.createFilter(FilterType.EQUALS, "activo", activoAgrupacionActivo.getActivo());
											Filter filt2 = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", TIPO_SUPERVISOR_COMERCIAL_VENTA);
											Filter filt3 = genericDao.createFilter(FilterType.NULL, "fechaHasta");

											GestorActivoHistorico gah_s=genericDao.get(GestorActivoHistorico.class,filt,filt2,filt3);
											if(!Checks.esNulo(gah_s)) {
													gah_s.setFechaHasta(new Date());
													genericDao.update(GestorActivoHistorico.class, gah_s);
											}
										}


									}

								}*/


							}
						}
					} else {
						if(tipoComercializacion  == null) {
							throw new JsonViewerException(TIPO_COMERCIALIZACION_NO_VALIDO);
						}else if (ofertaVivaAlquiler && DDTipoComercializacion.CODIGO_VENTA.equals(tipoComercializacion.getCodigo())) {
							throw new JsonViewerException(AGRUPACION_CAMBIO_DEST_COMERCIAL_CON_OFERTAS_VIVAS);
						} else if ( ofertaVivaVenta && DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tipoComercializacion.getCodigo())) {
							throw new JsonViewerException(AGRUPACION_CAMBIO_DEST_COMERCIAL_CON_OFERTAS_VIVAS);
						}
					}
				}
			} catch (JsonViewerException jve) {
				return "false"+SPLIT_VALUE+jve.getMessage();
			} catch (Exception e) {
				logger.error("error en agrupacionAdapter", e);
				return null;
			}
		}
		
		// Si es de tipo 'Restringida OBREM'.
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {

			ActivoRestringidaObrem restringidaObrem = (ActivoRestringidaObrem) agrupacion;

			try
			{
				// Si el destino comercial = Alquiler y venta, no permitirá cambiar el destino comercial = venta
				Activo activoPrincipal = agrupacion.getActivoPrincipal();
				String codigoDestinoComercial = "";
				if(activoPrincipal != null && activoPrincipal.getActivoPublicacion() != null && activoPrincipal.getActivoPublicacion().getTipoComercializacion() != null){
					codigoDestinoComercial = activoPrincipal.getActivoPublicacion().getTipoComercializacion().getCodigo();
				}

				if (DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(codigoDestinoComercial)
						&& DDTipoComercializacion.CODIGO_VENTA.equals(dto.getTipoComercializacionCodigo())) {
					List<ActivoAgrupacionActivo> listaActivos = restringidaObrem.getActivos();

					if(!Checks.estaVacio(listaActivos)) {
						ActivoPatrimonio activoPatrimonio;
						for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivos) {
							activoPatrimonio = activoPatrimonioDao.getActivoPatrimonioByActivo(activoAgrupacionActivo.getActivo().getId());
							if (!Checks.esNulo(activoPatrimonio) && !Checks.esNulo(activoPatrimonio.getTipoEstadoAlquiler()) && DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO.equals(activoPatrimonio.getTipoEstadoAlquiler().getCodigo())) {
								return "false"+SPLIT_VALUE+AGRUPACION_CAMBIO_DEST_COMERCIAL_A_VENTA_CON_ALQUILADOS;
							}
						}
					}
				}

				if(!permiteCambiarDestinoComercial(restringidaObrem))
				{
					return "false"+SPLIT_VALUE+OFERTA_INCOMPATIBLE_AGR_MSG;
				}
				else
				{
					beanUtilNotNull.copyProperties(restringidaObrem, dto);

					if(dto.getMunicipioCodigo() != null)
					{
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
						Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
						restringidaObrem.setLocalidad(municipioNuevo);
					}
					if(dto.getProvinciaCodigo() != null)
					{
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
						DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);
						restringidaObrem.setProvincia(provinciaNueva);
					}

					activoAgrupacionApi.saveOrUpdate(restringidaObrem);

					List <Oferta> ofertasAgr = restringidaObrem.getOfertas();

					Boolean ofertaViva = false;
					Boolean ofertaVivaVenta = false;
					Boolean ofertaVivaAlquiler = false;
					String codigo = null;

					DDTipoComercializacion tipoComercializacion = null;
					
					if(dto.getTipoComercializacionCodigo() != null) {
						tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, dto.getTipoComercializacionCodigo());
					}else {
						Activo activoParaRestringida = null;
						if(restringidaObrem.getActivoPrincipal() != null) {
							activoParaRestringida = restringidaObrem.getActivoPrincipal();
						}else if(restringidaObrem.getActivos() != null && !restringidaObrem.getActivos().isEmpty()){
							activoParaRestringida = restringidaObrem.getActivos().get(0).getActivo();
						}	
						if(activoParaRestringida != null && activoParaRestringida.getActivoPublicacion() != null && activoParaRestringida.getActivoPublicacion().getTipoComercializacion() != null) {
							String tipoComercializacionString = activoParaRestringida.getActivoPublicacion().getTipoComercializacion().getCodigo();
							tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, tipoComercializacionString);
						}
					}


					if(!Checks.estaVacio(ofertasAgr)) {
						for(Oferta oferta : ofertasAgr) {
							if(DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
								ofertaViva = true;
								if(DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
									ofertaVivaVenta = true;
								}

								if(DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())) {
									ofertaVivaAlquiler = true;
								}
								break;
							}
						}
					}
					//HREOS-12346
					
					if(dto.getMarcaDeExcluido() != null || dto.getVisibleGestionComercial() != null) {
						Boolean excluirValidaciones = dto.getMarcaDeExcluido();
						Boolean checkGestorComercial = dto.getVisibleGestionComercial();
						for (ActivoAgrupacionActivo aga : agrupacion.getActivos()) {
							Map <Long,List<String>> map = recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(aga.getActivo(), checkGestorComercial, excluirValidaciones ,true);
							recalculoVisibilidadComercialApi.lanzarPrimerErrorSiTiene(map);
							
						}
					}
				
					saveActivosVisiblesGestionComercial(dto,id);

					
					if(!ofertaViva) {
						List<ActivoAgrupacionActivo> listaActivos = restringidaObrem.getActivos();

						if(!Checks.estaVacio(listaActivos)) {
							for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivos) {
								ActivoPatrimonio activoPatrimonio = activoPatrimonioDao.getActivoPatrimonioByActivo(activoAgrupacionActivo.getActivo().getId());
								ActivoPublicacion activoPublicacion = activoAgrupacionActivo.getActivo().getActivoPublicacion();
								Activo activo = activoPublicacion.getActivo();

								if(!ofertaVivaAlquiler || !ofertaVivaVenta) {
									ActivoHistoricoPatrimonio newActiHistPatrimonio = new ActivoHistoricoPatrimonio();
									if(!Checks.esNulo(activoPatrimonio)) {
										newActiHistPatrimonio.setActivo(activoPatrimonio.getActivo());
										newActiHistPatrimonio.setAdecuacionAlquiler(activoPatrimonio.getAdecuacionAlquiler());
										newActiHistPatrimonio.setCheckHPM(activoPatrimonio.getCheckHPM());
										newActiHistPatrimonio.setFechaFinAdecuacionAlquiler(new Date());
										newActiHistPatrimonio.setFechaFinHPM(new Date());
										newActiHistPatrimonio.setFechaInicioAdecuacionAlquiler(new Date());
										newActiHistPatrimonio.setFechaInicioHPM(new Date());
									}else {
										newActiHistPatrimonio.setCheckHPM(false);
										newActiHistPatrimonio.setFechaInicioHPM(new Date());
										newActiHistPatrimonio.setFechaFinAdecuacionAlquiler(new Date());
										newActiHistPatrimonio.setFechaFinHPM(new Date());
										newActiHistPatrimonio.setFechaInicioAdecuacionAlquiler(new Date());
										newActiHistPatrimonio.setActivo(activoAgrupacionActivo.getActivo());
									}
									activoHistoricoPatrimonioDao.saveOrUpdate(newActiHistPatrimonio);
								}

								if(Checks.esNulo(activoPatrimonio)) {
									activoPatrimonio = new ActivoPatrimonio();
									activoPatrimonio.setActivo(activoAgrupacionActivo.getActivo());
								}
								if(Checks.esNulo(activoPublicacion)) {
									activoPublicacion = new ActivoPublicacion();
									activoPublicacion.setActivo(activoAgrupacionActivo.getActivo());
								}

								if(dto.getTipoComercializacionCodigo() != null) {
									activoEstadoPublicacionApi.actualizarPublicacionActivoCambioTipoComercializacion(activo, dto.getTipoComercializacionCodigo());
								}
								
								if(!ofertaVivaAlquiler && DDTipoComercializacion.CODIGO_VENTA.equals(dto.getTipoComercializacionCodigo())) {
									activoPatrimonio.setCheckHPM(false);
								}

								if(!ofertaVivaVenta && DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(dto.getTipoComercializacionCodigo())) {
									activoPatrimonio.setCheckHPM(true);

								}

								if(DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(dto.getTipoComercializacionCodigo())) {
									activoPatrimonio.setCheckHPM(true);
								}


								if (!Checks.esNulo(activoPublicacion.getTipoComercializacion())) {
									switch(Integer.parseInt(activoPublicacion.getTipoComercializacion().getCodigo())) {
										case 1:
											codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA;
											break;
										case 2:
											codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_ALQUILER;
											break;
										case 3:
											codigo = DDSituacionComercial.CODIGO_DISPONIBLE_ALQUILER;
											break;
										default:
											break;
									}
								}


								String codigoSituacion = codigo;

								if(!Checks.esNulo(codigoSituacion)) {
									activo.setSituacionComercial((DDSituacionComercial)utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionComercial.class,codigoSituacion));
								}
								activoPatrimonioDao.saveOrUpdate(activoPatrimonio);
								activoPublicacionDao.saveOrUpdate(activoPublicacion);
								
								//HREOS-5090 Punto 93
								//Asignar Gestores al cambiar el destino comercial de la agrupación si pasamos de 'alquiler y venta' a 'alquiler'
								//Se descartan los cambios por que es lo que me han indicado desde producto, pero no lo borro por si en un futuro se utiliza
								/*if(DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(destino_comercial) && DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tipoComercializacion.getCodigo())) {

									Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "activo", activoAgrupacionActivo.getActivo());
									List<GestorActivo> gestores_activo  = (List<GestorActivo>) genericDao.getList(GestorActivo.class, filtro2);
									for(GestorActivo gest : gestores_activo) {
										if(TIPO_GESTOR_COMERCIAL_VENTA.equals(gest.getTipoGestor().getCodigo())) {
											//borramos el gestor del activo
											gestorActivoDao.delete(gest);
											//y agregamos el gestor al historico del activo
											Filter filt= genericDao.createFilter(FilterType.EQUALS, "activo", activoAgrupacionActivo.getActivo());
											Filter filt1 = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", TIPO_GESTOR_COMERCIAL_VENTA);
											Filter filt3 = genericDao.createFilter(FilterType.NULL, "fechaHasta");
											GestorActivoHistorico gah_g=genericDao.get(GestorActivoHistorico.class,filt,filt1,filt3);
											if(!Checks.esNulo(gah_g)) {
													gah_g.setFechaHasta(new Date());
													genericDao.update(GestorActivoHistorico.class, gah_g);
											}

										}else if(TIPO_SUPERVISOR_COMERCIAL_VENTA.equals(gest.getTipoGestor().getCodigo())) {
											//borramos el gestor del activo
											gestorActivoDao.delete(gest);
											//y agregamos el gestor al historico del activo
											Filter filt= genericDao.createFilter(FilterType.EQUALS, "activo", activoAgrupacionActivo.getActivo());
											Filter filt2 = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", TIPO_SUPERVISOR_COMERCIAL_VENTA);
											Filter filt3 = genericDao.createFilter(FilterType.NULL, "fechaHasta");

											GestorActivoHistorico gah_s=genericDao.get(GestorActivoHistorico.class,filt,filt2,filt3);
											if(!Checks.esNulo(gah_s)) {
													gah_s.setFechaHasta(new Date());
													genericDao.update(GestorActivoHistorico.class, gah_s);
											}
										}


									}

								}*/


							}
						}
					} else {
						if(tipoComercializacion  == null) {
							throw new JsonViewerException(TIPO_COMERCIALIZACION_NO_VALIDO);
						}else if (ofertaVivaAlquiler && DDTipoComercializacion.CODIGO_VENTA.equals(tipoComercializacion.getCodigo())) {
							throw new JsonViewerException(AGRUPACION_CAMBIO_DEST_COMERCIAL_CON_OFERTAS_VIVAS);
						} else if ( ofertaVivaVenta && DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tipoComercializacion.getCodigo())) {
							throw new JsonViewerException(AGRUPACION_CAMBIO_DEST_COMERCIAL_CON_OFERTAS_VIVAS);
						}
					}
				}
			} catch (JsonViewerException jve) {
				return "false"+SPLIT_VALUE+jve.getMessage();
			} catch (Exception e) {
				logger.error("error en agrupacionAdapter", e);
				return null;
			}
		}

		// Si es de tipo 'Proyecto'.
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_PROYECTO)) {

			ActivoProyecto proyecto = (ActivoProyecto) agrupacion;

			try {

				beanUtilNotNull.copyProperties(proyecto, dto);



				if (dto.getMunicipioCodigo() != null) {

					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
					Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);

					proyecto.setLocalidad(municipioNuevo);
				}

				if (dto.getProvinciaCodigo() != null) {

					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
					DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);

					proyecto.setProvincia(provinciaNueva);
				}

				if (dto.getCodigoPostal() != null) {

					proyecto.setCodigoPostal(dto.getCodigoPostal());
				}

				if (dto.getTipoActivoCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoActivoCodigo() );
					DDTipoActivo tipoActivo = (DDTipoActivo) genericDao.get(DDTipoActivo.class, filtro);
					proyecto.setTipoActivo(tipoActivo);

				}

				if (dto.getSubtipoActivoCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getSubtipoActivoCodigo() );
					DDSubtipoActivo subTipoActivo = (DDSubtipoActivo) genericDao.get(DDSubtipoActivo.class, filtro);
					proyecto.setSubtipoActivo(subTipoActivo);

				}

				if (dto.getEstadoActivoCodigo() != null) {

					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoActivoCodigo());
					DDEstadoActivo estadoActivo = (DDEstadoActivo) genericDao.get(DDEstadoActivo.class, filtro);
					proyecto.setEstadoActivo(estadoActivo);

				}

				if(dto.getNombre() != null) {

					proyecto.setNombre(dto.getNombre());

				}

				if(dto.getDescripcion() != null) {

					proyecto.setDescripcion(dto.getDescripcion());
				}


				if (dto.getCodigoGestorActivo() != null) {

					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getCodigoGestorActivo());
					Usuario GestorActivo = genericDao.get(Usuario.class, filtro);
					proyecto.setGestorActivo(GestorActivo);

				}

				if (dto.getCodigoGestorDobleActivo() != null) {

					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getCodigoGestorDobleActivo());
					Usuario dobleGestorActivo = genericDao.get(Usuario.class, filtro);
					proyecto.setDobleGestorActivo(dobleGestorActivo);

				}

				if (dto.getCodigoGestorComercial() != null) {

					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getCodigoGestorComercial());
					Usuario gestorComercial = genericDao.get(Usuario.class, filtro);
					proyecto.setGestorcomercial(gestorComercial);

				}

				if (dto.getFechaBaja() != null) {

					proyecto.setFechaBaja(dto.getFechaBaja());
				}

				if (!Checks.esNulo(dto.getCodigoCartera())) {

					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoCartera());

					DDCartera cartera = genericDao.get(DDCartera.class, filtro);

					proyecto.setCartera(cartera);

				}

				activoAgrupacionApi.saveOrUpdate(proyecto);

			} catch (Exception e) {

				logger.error("error en agrupacionAdapter", e);
				return "false";
			}
		}

		//si modificamos la vigencia ejecutamos reactivación activos
		if(vigenciaModificada && agrupacion.getActivos() != null){
			// lo ejecutamos de forma asincrona, si hay muchos tarda em completar
			Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			Thread hiloReactivar = new Thread( new ReactivarActivosAgrupacion(agrupacion.getId(),usu.getUsername()));
			hiloReactivar.start();				
		}

		try {
			// HREOS-2552: Si damos de baja la agrupación Descongelamos las
			// ofertas congeladas en los activos de la grupacion
			if (!Checks.esNulo(dto.getFechaBaja())) {
				activoAgrupacionApi.descongelarOfertasActivoAgrupacion(agrupacion);
			}
		} catch (Exception e) {
			logger.error("error Descongelamos las ofertas congeladas en los activos de la agrupacion", e);
			return "false";
		}

		return "true";
	}

	private String validarBajaAgrupacion(ActivoAgrupacion agrupacion) {

		String error = null;
		
		if (existenOfertasActivasEnAgrupacion(agrupacion.getId()) 
				&& !DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())) {  
			error = AGRUPACION_BAJA_ERROR_OFERTAS_VIVAS;
		}else if (activoDao.isAgrupacionPromocionAlquiler(agrupacion.getId()) &&  ( activoDao.countUAsByIdAgrupacionPA(agrupacion.getId())> 0)) {
			ActivoAgrupacionActivo agaAM = genericDao.get(ActivoAgrupacionActivo.class, 
					genericDao.createFilter(FilterType.EQUALS, "agrupacion", agrupacion),
					genericDao.createFilter(FilterType.EQUALS, "principal", 1));
			
			if(agaAM != null){
				
				activoApi.actualizarOfertasTrabajosVivos(agaAM.getActivo());
				
				PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class,
						genericDao.createFilter(FilterType.EQUALS,"activo.id", agaAM.getActivo().getId()));
				
				Boolean tieneOfertasVivas = !Checks.esNulo(perimetroActivo.getOfertasVivas()) ? perimetroActivo.getOfertasVivas() : false;
				
				Boolean tieneTrabajosVivos = !Checks.esNulo(perimetroActivo.getTrabajosVivos()) ? perimetroActivo.getTrabajosVivos() : false;
				if (tieneOfertasVivas) {
					error = EXISTEN_UAS_CON_OFERTAS_VIVAS;
				}else if (tieneTrabajosVivos) {
					error = EXISTEN_UAS_CON_TRABAJOS_NO_FINALIZADOS;
				}
			}
				
		}
		
		

		return error;
	}
	
	private String validarBajaActivosPA(Activo activo) {

		String error = null;

			if (activoDao.activoUAsconOfertasVivas(activo.getId())) {
				error = EXISTEN_UAS_CON_OFERTAS_VIVAS;
			}else if (activoDao.activoUAsconTrabajos(activo.getId())) {
				error = EXISTEN_UAS_CON_TRABAJOS_NO_FINALIZADOS;
			}
				
		return error;
	}
	

	public List<ActivoFoto> getFotosActivosAgrupacionById(Long id) {

		return activoAgrupacionApi.getFotosActivosAgrupacionById(id);

	}

	protected DDTipoAgrupacion getTipoAgrupacion(Long id) {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", id);
		DDTipoAgrupacion tipoAgrupacion = genericDao.get(DDTipoAgrupacion.class, filter);

		return tipoAgrupacion;
	}

	// Devuelve verdadero si en la agrupación existe alguna Oferta activa
	// (estado != RECHAZADA)
	private Boolean existenOfertasActivasEnAgrupacion(Long idAgrupacion) {
		return activoAgrupacionActivoApi.existenOfertasActivasEnAgrupacion(idAgrupacion);
	}

	public List<DtoUsuario> getUsuariosPorCodTipoGestor(String codigoGestor) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoGestor);
		EXTDDTipoGestor tipoGestor = (EXTDDTipoGestor) genericDao.get(EXTDDTipoGestor.class, filtro);

		if (!Checks.esNulo(tipoGestor)) {
			return activoAdapter.getComboUsuarios(tipoGestor.getId());
		}

		return null;
	}
	
	public List<DtoUsuario> getUsuariosPorCodTipoGestor(String codigoGestor, Long agrId) {
		List<DtoUsuario> listaUsuariosDto = new ArrayList<DtoUsuario>();
		String cartera = "";
		String subCartera = "";
		Filter filtroAgrupacion = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", agrId);
		List<ActivoAgrupacionActivo> agrupacion = genericDao.getList(ActivoAgrupacionActivo.class, filtroAgrupacion);
		if(!Checks.estaVacio(agrupacion)) {
			if (!Checks.esNulo(agrupacion.get(0).getActivo()) && !Checks.esNulo(agrupacion.get(0).getActivo().getCartera())) {
				cartera = agrupacion.get(0).getActivo().getCartera().getCodigo();
				subCartera = agrupacion.get(0).getActivo().getSubcartera().getCodigo();
			}
	
			if(((DDCartera.CODIGO_CARTERA_EGEO.equals(cartera) && DDSubcartera.CODIGO_ZEUS.equals(subCartera))
					|| DDCartera.CODIGO_CARTERA_GALEON.equals(cartera)
					|| DDCartera.CODIGO_CARTERA_GIANTS.equals(cartera)
					|| DDCartera.CODIGO_CARTERA_HYT.equals(cartera)
					|| DDCartera.CODIGO_CARTERA_TANGO.equals(cartera)
					|| (DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(cartera) 
							&& (DDSubcartera.CODIGO_THIRD_PARTIES_QUITAS_ING.equals(subCartera) 
							|| DDSubcartera.CODIGO_THIRD_PARTIES_COMERCIAL_ING.equals(subCartera))
						))
					&& isRetail(agrupacion.get(0).getAgrupacion())
				){
				Usuario gestoBO = gestorActivoApi.getGestorByActivoYTipo(agrupacion.get(0).getActivo(), GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
				
				if (!Checks.esNulo(gestoBO)) {			
					try {
						DtoUsuario dtoUsuario = new DtoUsuario();
						BeanUtils.copyProperties(dtoUsuario, gestoBO);
						listaUsuariosDto.add(dtoUsuario);
					} catch (IllegalAccessException e) {
						logger.error("Error en ActivoAdapter", e);
					} catch (InvocationTargetException e) {
						logger.error("Error en ActivoAdapter", e);
					}
					return listaUsuariosDto;
				}			
			} else {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoGestor);
				EXTDDTipoGestor tipoGestor = (EXTDDTipoGestor) genericDao.get(EXTDDTipoGestor.class, filtro);
		
				if (!Checks.esNulo(tipoGestor)) {
					return activoAdapter.getComboUsuarios(tipoGestor.getId());
				}
			}
		}

		return null;
	}

	public List<DtoUsuario> getUsuariosPorCodTipoGestor(Long idAgr) {


		String codigoGestor;
		Filter filtroAgr = genericDao.createFilter(FilterType.EQUALS, "id", idAgr);
		ActivoAgrupacion activoAgrup=  (ActivoAgrupacion) genericDao.get(ActivoAgrupacion.class, filtroAgr);
		if(activoAgrup.getTipoAgrupacion().getCodigo().equals(TIPO_COMERCIAL_VENTA_CODIGO)) {

			codigoGestor=TIPO_GESTOR_COMERCIAL_VENTA;
		}
		else {
			codigoGestor=TIPO_GESTOR_COMERCIAL_ALQUILER;
		}

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoGestor);
		EXTDDTipoGestor tipoGestor = (EXTDDTipoGestor) genericDao.get(EXTDDTipoGestor.class, filtro);

		if (!Checks.esNulo(tipoGestor)) {
			return activoAdapter.getComboUsuarios(tipoGestor.getId());
		}

		return null;
	}


	public List<DtoUsuario> getUsuariosPorDobleCodTipoGestor(String codigoGestorEdi,String codigoGestorSu) {

		List<DtoUsuario> listaUsuariosDtoDobleActivo = new ArrayList<DtoUsuario>();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoGestorEdi);
		EXTDDTipoGestor tipoGestor = (EXTDDTipoGestor) genericDao.get(EXTDDTipoGestor.class, filtro);

		Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoGestorSu);
		EXTDDTipoGestor tipoGestor2 = (EXTDDTipoGestor) genericDao.get(EXTDDTipoGestor.class, filtro2);

		if (!Checks.esNulo(tipoGestor) && !Checks.esNulo(tipoGestor2) ) {

			for (DtoUsuario dtoUsuario : activoAdapter.getComboUsuarios(tipoGestor.getId())) {
				listaUsuariosDtoDobleActivo.add(dtoUsuario);
			}

			for (DtoUsuario dtoUsuario2 : activoAdapter.getComboUsuarios(tipoGestor2.getId())) {
				listaUsuariosDtoDobleActivo.add(dtoUsuario2);
			}

			return listaUsuariosDtoDobleActivo;

		}

		return null;
	}

	private String getEstadoNuevaOferta(ActivoAgrupacion agrupacion) {
		String codigoEstado = DDEstadoOferta.CODIGO_PENDIENTE;

		if (DDCartera.isCarteraBk(agrupacion.getActivos().get(0).getActivo().getCartera())) {
			codigoEstado = DDEstadoOferta.CODIGO_PDTE_DOCUMENTACION;
		}
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {
			List<Long> activosID = new ArrayList<Long>();
			for (ActivoAgrupacionActivo activosAgrupacion : agrupacion.getActivos()) {
				activosID.add(activosAgrupacion.getActivo().getId());
			}

			if (!Checks.estaVacio(activosID)
					&& activoAgrupacionActivoDao.algunActivoDeAgrRestringidaEnAgrLoteComercial(activosID)) {
				codigoEstado = DDEstadoOferta.CODIGO_CONGELADA;
			}
		}

		// Comprobar si la grupación tiene ofertas aceptadas para establecer la
		// nueva oferta en estado congelada.
		if (ofertaApi.isAgrupacionConOfertaYExpedienteBlocked(agrupacion)) {
			codigoEstado = DDEstadoOferta.CODIGO_CONGELADA;
		}

		return codigoEstado;
	}

	/**
	 * Este método obtiene una lista de usuarios filtrados por el tipo de gestor
	 * que recibe y por la cartera a la que pertenece la agrupación.
	 * 
	 * @param agrId:
	 *            ID de la agrupación.
	 * @param codigoGestor:
	 *            código del tipo de gestor.
	 * @return Devuelve una lista de usuarios.
	 */
	public List<DtoUsuario> getUsuariosPorTipoGestorYCarteraDelLoteComercial(Long agrId, String codigoGestor) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoGestor);
		EXTDDTipoGestor tipoGestor = (EXTDDTipoGestor) genericDao.get(EXTDDTipoGestor.class, filtro);

		ActivoAgrupacion activoAgrupacion = activoAgrupacionApi.get(agrId);

		if (!Checks.esNulo(tipoGestor) && !Checks.esNulo(activoAgrupacion)) {
			return activoAdapter.getComboUsuariosPorTipoGestorYCarteraDelLoteComercial(activoAgrupacion,
					tipoGestor.getId());
		}

		return null;
	}

	public boolean permiteEliminarAgrupacion(Long numAgrupacion) {
		
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(getAgrupacionIdByNumAgrupRem(numAgrupacion));
		List<ActivoTrabajo> listActivoTrabajo= new ArrayList<ActivoTrabajo>();
		List<Oferta> listOfertasAgrupacion= new ArrayList<Oferta>();
		if(!Checks.esNulo(agrupacion)){
			listOfertasAgrupacion= agrupacion.getOfertas();
			for(ActivoAgrupacionActivo activoAgrupacion: agrupacion.getActivos()){
				listActivoTrabajo.addAll(activoApi.getActivoTrabajos(activoAgrupacion.getActivo().getId()));
			}			
		}
		
		if(!Checks.estaVacio(listOfertasAgrupacion) || !Checks.estaVacio(listActivoTrabajo)){
			return false;
		}
		return true;		
	}

	public boolean permiteCambiarDestinoComercial(ActivoAgrupacion agrupacion)
	{
		if(!Checks.esNulo(agrupacion) && !Checks.esNulo(agrupacion.getActivoPrincipal()))
		{
			String tipoCodigo = getDiffTipoOfertaByTipoComercializacion(agrupacion);
			if(!Checks.esNulo(tipoCodigo) && !Checks.estaVacio(agrupacion.getActivoPrincipal().getOfertas()))
			{
				List<Oferta> ofertas = new ArrayList<Oferta>();
				List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();
				for(ActivoAgrupacionActivo act : activos)
				{
					for(ActivoOferta ao : act.getActivo().getOfertas())
					{
						ofertas.add(ao.getPrimaryKey().getOferta());
					}
				}
				if(activoTieneOfertaByTipoOfertaCodigo(ofertas, tipoCodigo))
				{
					return false;
				}
			}
		}
		return true;
	}

	public boolean activoTieneOfertaByTipoOfertaCodigo(List<Oferta> ofertas, String tipoCodigo)
	{
		for(Oferta oferta : ofertas)
		{
			if(ofertaApi.estaViva(oferta) && tipoCodigo.equals(oferta.getTipoOferta().getCodigo()))
			{
				return true;
			}
		}
		return false;
	}

	public String getDiffTipoOfertaByTipoComercializacion(ActivoAgrupacion agrupacion)
	{
		Activo activo = agrupacion.getActivoPrincipal();
		final String codigoActivo = activo.getActivoPublicacion().getTipoComercializacion().getCodigo();

		if(DDTipoComercializacion.CODIGO_VENTA.equals(codigoActivo))
		{
			return DDTipoOferta.CODIGO_ALQUILER;
		}
		else if(DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(codigoActivo))
		{
			return DDTipoOferta.CODIGO_VENTA;
		}
		return null;
	}

	public void distintosTiposImpuesto(ActivoAgrupacion agrupacion, Activo activo) {
		List<ActivoAgrupacionActivo> lista = agrupacion.getActivos();

		Boolean canarias = false;

		String codProvinciasCanarias[] = {"35", "38"};
		
		if(!Checks.esNulo(lista)) {
			if(lista.isEmpty() && Arrays.asList(codProvinciasCanarias).contains(activo.getProvincia())){
				canarias = true;
			}else{
				for (int i = 0; i < lista.size(); i++) {
					ActivoAgrupacionActivo aga = lista.get(i);

					Activo act = aga.getActivo();
					String codProvincia = act.getProvincia();

					if (Arrays.asList(codProvinciasCanarias).contains(codProvincia)) {
						canarias = true;
					}
				}
			}
			
			if (canarias) {
				if (!Arrays.asList(codProvinciasCanarias).contains(activo.getProvincia()))
					throw new JsonViewerException(AgrupacionValidator.ERROR_ACTIVO_NO_CANARIAS);
			} else {
				if (Arrays.asList(codProvinciasCanarias).contains(activo.getProvincia()))
					throw new JsonViewerException(AgrupacionValidator.ERROR_ACTIVO_CANARIAS);
			}
		}

	}
	
	private void comprobarDistintoPropietario(ActivoAgrupacion agrupacion, Activo activo) {

		Activo actAgr = null;
		
		if (!Checks.esNulo(agrupacion.getActivoPrincipal())) {
			actAgr = agrupacion.getActivoPrincipal();
		}else if(!Checks.esNulo(agrupacion.getActivos()) && !Checks.estaVacio(agrupacion.getActivos())){
			actAgr = agrupacion.getActivos().get(0).getActivo();
		}
		
			
		if (!Checks.esNulo(actAgr) && !actAgr.getPropietarioPrincipal().getId().equals(activo.getPropietarioPrincipal().getId()) ) {
			throw new JsonViewerException(AgrupacionValidator.ERROR_ACTIVO_DISTINTO_PROPIETARIO);
		}
		
		
	}

	public DtoDatosPublicacionAgrupacion getDatosPublicacionAgrupacion(Long id) {
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		Activo activoPrincipal = agrupacion.getActivoPrincipal();
		DtoDatosPublicacionAgrupacion dto = new DtoDatosPublicacionAgrupacion();
		if(!Checks.esNulo(activoPrincipal)) {
			dto = activoEstadoPublicacionApi.getDatosPublicacionAgrupacion(activoPrincipal.getId());
			Filter idAgrupacionFilter = genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", id);
			VCondicionantesAgrDisponibilidad vCondicionantesAgrDisponibilidad = genericDao.get(VCondicionantesAgrDisponibilidad.class, idAgrupacionFilter);
			Double precioWebVenta = 0.0;
			Double precioWebAlquiler = 0.0;
	
			try {
				precioWebVenta = activoValoracionDao.getImporteValoracionVentaWebPorIdAgrupacion(id);
				precioWebAlquiler = activoValoracionDao.getImporteValoracionRentaWebPorIdAgrupacion(id);
	
			} catch (Exception e) {
				logger.error("error al calcular precio de agrupacion en agrupacionAdapter", e);
			}
	
			dto.setPrecioWebVenta(precioWebVenta);
			dto.setPrecioWebAlquiler(precioWebAlquiler);
			if(!Checks.esNulo(activoPrincipal.getActivoPublicacion()) && !Checks.esNulo(activoPrincipal.getActivoPublicacion().getEstadoPublicacionAlquiler())) {
				dto.setCodigoEstadoPublicacionAlquiler(activoPrincipal.getActivoPublicacion().getEstadoPublicacionAlquiler().getCodigo());
			}
			if(!Checks.esNulo(activoPrincipal.getActivoPublicacion()) && !Checks.esNulo(activoPrincipal.getActivoPublicacion().getEstadoPublicacionVenta())) {
				dto.setCodigoEstadoPublicacionVenta(activoPrincipal.getActivoPublicacion().getEstadoPublicacionVenta().getCodigo());
			}
	
			dto.setRuina(vCondicionantesAgrDisponibilidad.getRuina());
			dto.setPendienteInscripcion(vCondicionantesAgrDisponibilidad.getPendienteInscripcion());
			dto.setObraNuevaSinDeclarar(vCondicionantesAgrDisponibilidad.getObraNuevaSinDeclarar());
			dto.setSinTomaPosesionInicial(vCondicionantesAgrDisponibilidad.getSinTomaPosesionInicial());
			dto.setProindiviso(vCondicionantesAgrDisponibilidad.getProindiviso());
			dto.setObraNuevaEnConstruccion(vCondicionantesAgrDisponibilidad.getObraNuevaEnConstruccion());
			dto.setOcupadoConTitulo(vCondicionantesAgrDisponibilidad.getOcupadoConTitulo());
			dto.setTapiado(vCondicionantesAgrDisponibilidad.getTapiado());
			dto.setOtro(vCondicionantesAgrDisponibilidad.getOtro());
			if(!Checks.esNulo(vCondicionantesAgrDisponibilidad.getOtro())) {
				dto.setComboOtro(1);
			} else {
				dto.setComboOtro(0);
			}
			dto.setEstadoCondicionadoCodigo(vCondicionantesAgrDisponibilidad.getEstadoCondicionadoCodigo());
			dto.setPortalesExternos(vCondicionantesAgrDisponibilidad.getPortalesExternos());
			dto.setOcupadoSinTitulo(vCondicionantesAgrDisponibilidad.getOcupadoSinTitulo());
			dto.setDivHorizontalNoInscrita(vCondicionantesAgrDisponibilidad.getDivHorizontalNoInscrita());
			dto.setIsCondicionado(vCondicionantesAgrDisponibilidad.getIsCondicionado());
			dto.setSinInformeAprobado(vCondicionantesAgrDisponibilidad.getSinInformeAprobado());
			dto.setVandalizado(vCondicionantesAgrDisponibilidad.getVandalizado());
			dto.setConCargas(vCondicionantesAgrDisponibilidad.getConCargas());
	
			dto.setDeshabilitarCheckPublicarVenta(activoEstadoPublicacionApi.getCheckPublicacionDeshabilitarAgrupacionVenta(agrupacion.getActivos()));
			dto.setDeshabilitarCheckOcultarVenta(activoEstadoPublicacionApi.getCheckOcultarDeshabilitarAgrupacionVenta(agrupacion.getActivos()));
			dto.setDeshabilitarCheckPublicarAlquiler(activoEstadoPublicacionApi.getCheckPublicacionDeshabilitarAgrupacionAlquiler(agrupacion.getActivos()));
			dto.setDeshabilitarCheckOcultarAlquiler(activoEstadoPublicacionApi.getCheckOcultarDeshabilitarAgrupacionAlquiler(agrupacion.getActivos()));
		}

		dto.setDeshabilitarCheckPublicarVenta(activoEstadoPublicacionApi.getCheckPublicacionDeshabilitarAgrupacionVenta(agrupacion.getActivos()));
		dto.setDeshabilitarCheckOcultarVenta(activoEstadoPublicacionApi.getCheckOcultarDeshabilitarAgrupacionVenta(agrupacion.getActivos()));
		dto.setDeshabilitarCheckPublicarAlquiler(activoEstadoPublicacionApi.getCheckPublicacionDeshabilitarAgrupacionAlquiler(agrupacion.getActivos()));
		dto.setDeshabilitarCheckOcultarAlquiler(activoEstadoPublicacionApi.getCheckOcultarDeshabilitarAgrupacionAlquiler(agrupacion.getActivos()));
		
		VFechasPubCanalesAgr canal = genericDao.get(VFechasPubCanalesAgr.class, genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", id));
		if ( canal != null ) {
			if ( canal.getFechaPrimeraPublicacionMin() != null ) {
				dto.setFechaPrimeraPublicacionMin(canal.getFechaPrimeraPublicacionMin());
			}
			if ( canal.getFechaUltimaPublicacionMin() != null ) {
				dto.setFechaUltimaPublicacionMin(canal.getFechaUltimaPublicacionMin());
			}
			if ( canal.getFechaPrimeraPublicacionMay() != null ) {
				dto.setFechaPrimeraPublicacionMay(canal.getFechaPrimeraPublicacionMay());
			}
			if ( canal.getFechaUltimaPublicacionMay() != null ) {
				dto.setFechaUltimaPublicacionMay(canal.getFechaUltimaPublicacionMay());
			}
		}

		return dto;
	}
	
	public Boolean calculodiasCambiosActivo(Date fechaIni){
		
		Boolean cumpleCond = Boolean.FALSE;
		Date fechaInicial=fechaIni;
		Date fechaFinal=new Date();
		Integer dias=(int) ((fechaFinal.getTime()-fechaInicial.getTime())/86400000);
		if (dias<7) {
			cumpleCond=Boolean.TRUE; 
		}
		
		return cumpleCond;
	} 
	
	@Transactional(readOnly = false)
	public boolean deleteCacheFotosAgr(Long idAgrupacion){
		if (gestorDocumentalFotos.isActive()) {
			List<ActivoFoto> listaFotos = activoAgrupacionApi.getFotosAgrupacionById(idAgrupacion);
			for(ActivoFoto foto : listaFotos){
				foto.getAuditoria().setBorrado(true);
				genericDao.save(ActivoFoto.class, foto);
			}		
		}
		return true;
	}
	
	/*
	 *  @param agrupacion Objecto ActivoAgrupacion
	 *  @param acticoNum número del activo
	 *  @return Activo or null
	 *  @throws Activo fuera de perímetro
	 *  @throws Activo no pertenece a Yubai
	 *  @throws Activo no de obtra nueva
	 * */
	private Activo isActivoValido(ActivoAgrupacion agrupacion, Long activoNum) throws JsonViewerException {
		Activo nuevoPisoPiloto = null; 
		if(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			for(ActivoAgrupacionActivo activo_aga : agrupacion.getActivos()){
				if(activo_aga.getActivo().getNumActivo().equals(activoNum)) {
					if(DDSubcartera.CODIGO_YUBAI.equals(activo_aga.getActivo().getSubcartera().getCodigo())){
						nuevoPisoPiloto = activo_aga.getActivo();
						break;
					}else {
						throw new JsonViewerException(ACTIVO_NO_YUBAI);
					}
				}
			}
		}else {
			throw new JsonViewerException(ACTIVO_NO_OBRA_NUEVA);
		}
		
		if(Checks.esNulo(nuevoPisoPiloto)) {
			throw new JsonViewerException(ACTIVO_FUERA_AGRUPACION);
		}
			
		return nuevoPisoPiloto;
	}

	public DtoComercialAgrupaciones getComercialAgrupacionById(Long id) {
		DtoComercialAgrupaciones dtoAgrupacion = new DtoComercialAgrupaciones();

		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		boolean necesidadArras = false;
		boolean canalMayoristaVenta = false;
		boolean canalMayoristaAlquiler = false;
		String canalVenta = "";
		String canalAlquiler = "";
		try {
			if (!Checks.esNulo(agrupacion.getActivoAutorizacionTramitacionOfertas())) {
			
				beanUtilNotNull.copyProperty(dtoAgrupacion, "motivoAutorizacionTramitacionCodigo", agrupacion.getActivoAutorizacionTramitacionOfertas().getMotivoAutorizacionTramitacion().getCodigo());
				beanUtilNotNull.copyProperty(dtoAgrupacion, "observacionesAutoTram", agrupacion.getActivoAutorizacionTramitacionOfertas().getObservacionesAutoTram());
			}
			
			dtoAgrupacion.setTramitable(activoAgrupacionApi.isTramitable(agrupacion));
		
		} catch (IllegalAccessException e) {
			logger.error("error en agrupacionAdapter", e);
		} catch (InvocationTargetException e) {
			logger.error("error en agrupacionAdapter", e);
		}
		
		if (DDCartera.isCarteraBk(agrupacion.getActivoPrincipal().getCartera()) && 
				(DDTipoAgrupacion.isRestringida(agrupacion.getTipoAgrupacion()) || DDTipoAgrupacion.isRestringidaAlquiler(agrupacion.getTipoAgrupacion())
				|| DDTipoAgrupacion.isRestringidaObrem(agrupacion.getTipoAgrupacion()))) {
			
			List<ActivoAgrupacionActivo> agaList = agrupacion.getActivos();
			
			if (agaList != null && agaList.size() > 0) {
				for (ActivoAgrupacionActivo activoAgrupacionActivo : agaList) {
					Activo aux = activoAgrupacionActivo.getActivo();
					ActivoCaixa auxActCaixa = genericDao.get(ActivoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", aux.getId()));
					if (auxActCaixa != null) {
						if (auxActCaixa.getNecesidadArras() != null && Boolean.TRUE.equals(auxActCaixa.getNecesidadArras())) {
							necesidadArras = true;
						}
						//CANAL VENTA
						//Minorista
						if (auxActCaixa.getCanalDistribucionVenta() != null 
								&& DDTipoComercializar.CODIGO_RETAIL.equals(auxActCaixa.getCanalDistribucionVenta().getCodigo())) {
							canalVenta = MINORISTA;
						}else if (auxActCaixa.getCanalDistribucionVenta() != null 
								&& DDTipoComercializar.CODIGO_SINGULAR.equals(auxActCaixa.getCanalDistribucionVenta().getCodigo())) {
							canalVenta = MAYORISTA;
							canalMayoristaVenta = true;
						}
						//CANAL Alquiler
						//Minorista
						if (auxActCaixa.getCanalDistribucionAlquiler() != null 
								&& DDTipoComercializar.CODIGO_RETAIL.equals(auxActCaixa.getCanalDistribucionAlquiler().getCodigo())) {
							canalAlquiler = MINORISTA;
						}else if (auxActCaixa.getCanalDistribucionAlquiler() != null 
								&& DDTipoComercializar.CODIGO_SINGULAR.equals(auxActCaixa.getCanalDistribucionAlquiler().getCodigo())) {
							canalAlquiler = MAYORISTA;
							canalMayoristaAlquiler = true;
						}
						
						/*if ((necesidadArras && canalMayoristaVenta) || (necesidadArras && canalMayoristaAlquiler)) {
							 break;
						}*/
					}
				}
			}
			
			if (necesidadArras) {
				dtoAgrupacion.setNecesidadArras(SI);
			}else {
				dtoAgrupacion.setNecesidadArras(NO);
			}
			if (canalMayoristaVenta) {
				canalVenta = MAYORISTA;
			}
			if (canalMayoristaAlquiler) {
				canalAlquiler = MAYORISTA;
			}
			
			dtoAgrupacion.setCanalVentaBc(canalVenta);
			dtoAgrupacion.setCanalAlquilerBc(canalAlquiler);
			
			if (agrupacion.getActivoPrincipal() != null && agrupacion.getActivoPrincipal().getCartera() != null) {
				dtoAgrupacion.setCodCartera(agrupacion.getActivoPrincipal().getCartera().getCodigo());
			}
			
			if (agrupacion.getTipoAgrupacion() != null) {
				dtoAgrupacion.setCodAgrupacion(agrupacion.getTipoAgrupacion().getCodigo());
			}
			
		}
			


		return dtoAgrupacion;
	}
	
	private Boolean esGestorComercial(ActivoAgrupacion agrupacion) {
		
		Usuario usu = genericAdapter.getUsuarioLogado();
		boolean esGestorComercial = false;
		
		Filter filtroAgrupacion = genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", agrupacion.getId());
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "idUsuario", usu.getId());		

		List<VAgrupacionActivosGestorComercial> vistaList = genericDao.getList(VAgrupacionActivosGestorComercial.class, filtroAgrupacion, filtroUsuario);				

		if (vistaList != null && !vistaList.isEmpty()) {
			esGestorComercial = true;
		}

		return esGestorComercial;
	}
	
	@Transactional(readOnly = false)
	public Oferta clonateOfertaAgrupacion(String idOferta) {
		return genericAdapter.clonateOferta(idOferta, true);
	}
	
	@Transactional(readOnly = false)
	public void saveActivosVisiblesGestionComercial(DtoAgrupaciones dto, Long id) {
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		String codigoSinSino;
		List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();
		if (activos != null && !activos.isEmpty()) {
			for (ActivoAgrupacionActivo ativoAgrupacionActivo : activos) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id",
						ativoAgrupacionActivo.getActivo().getId());
				PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtro);
				if (perimetroActivo != null) {
					if (dto.getVisibleGestionComercial() != null) {
						perimetroActivo.setCheckGestorComercial(dto.getVisibleGestionComercial());
					}
					if (dto.getMarcaDeExcluido() != null) {
						if (dto.getMarcaDeExcluido()) {
							codigoSinSino = DDSinSiNo.CODIGO_SI;
						}else {
							codigoSinSino = DDSinSiNo.CODIGO_NO;
							perimetroActivo.setMotivoGestionComercial(null);
						}
						Filter filtroDict = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoSinSino);
						DDSinSiNo ddSinSiNo = genericDao.get(DDSinSiNo.class, filtroDict);
						perimetroActivo.setExcluirValidaciones(ddSinSiNo);
					}
					if(dto.getMotivoDeExcluidoCodigo() != null && DDSinSiNo.cambioDiccionarioaBooleano(perimetroActivo.getExcluirValidaciones())) {
						Filter filtroMotivoExcluido = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMotivoDeExcluidoCodigo());
						DDMotivoGestionComercial ddtr1 = genericDao.get(DDMotivoGestionComercial.class, filtroMotivoExcluido);
						perimetroActivo.setMotivoGestionComercial(ddtr1);
					}
					genericDao.save(PerimetroActivo.class, perimetroActivo);
				}					
			}
		}
	}
	

	public ActivoAgrupacion getAgrupacionObjectById(Long id) {
		return genericDao.get(ActivoAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
	}

	@Transactional(readOnly = false)
	public boolean deleteAgrupacionesById(Long id) {
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		if (DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			genericDao.deleteById(ActivoObraNueva.class, id);
		} else if (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			genericDao.deleteById(ActivoRestringida.class, id);
		} else if (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			genericDao.deleteById(ActivoRestringidaAlquiler.class, id);
		} else if (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			genericDao.deleteById(ActivoRestringidaObrem.class, id);
		} else if (DDTipoAgrupacion.AGRUPACION_PROYECTO.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			genericDao.deleteById(ActivoProyecto.class, id);
		} else if (DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			genericDao.deleteById(ActivoAsistida.class, id);
		} else if (DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
			genericDao.deleteById(ActivoLoteComercial.class, id);
		}

		List<ActivoAgrupacionActivo> list = agrupacion.getActivos();
		if (!Checks.estaVacio(list)) {
			Iterator<ActivoAgrupacionActivo> iterator = list.iterator();
			while (iterator.hasNext()) {
				activoAgrupacionActivoApi.delete(iterator.next());
			}
		}
		return true;
	}
		
	@Transactional(readOnly = false)
	public DtoAgrupacionesCreateDelete createAgrupacionesGrid(DtoAgrupacionesCreateDelete dto) throws Exception {		
		dto.setTipoAgrupacion(dto.getTipoAgrupacionDescripcion());
		return this.createAgrupacion(dto);
	}
	

}