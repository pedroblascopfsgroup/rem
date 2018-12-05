package es.pfsgroup.plugin.rem.expedienteComercial;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.controller.ExpedienteComercialController;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.BloqueoActivoFormalizacion;
import es.pfsgroup.plugin.rem.model.ComparecienteVendedor;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CompradorExpediente.CompradorExpedientePk;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.CondicionesActivo;
import es.pfsgroup.plugin.rem.model.DtoActivosExpediente;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoExpediente;
import es.pfsgroup.plugin.rem.model.DtoBloqueosFinalizacion;
import es.pfsgroup.plugin.rem.model.DtoClienteUrsus;
import es.pfsgroup.plugin.rem.model.DtoComparecienteVendedor;
import es.pfsgroup.plugin.rem.model.DtoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoCondicionesActivoExpediente;
import es.pfsgroup.plugin.rem.model.DtoDatosBasicosOferta;
import es.pfsgroup.plugin.rem.model.DtoEntregaReserva;
import es.pfsgroup.plugin.rem.model.DtoFichaExpediente;
import es.pfsgroup.plugin.rem.model.DtoFormalizacionFinanciacion;
import es.pfsgroup.plugin.rem.model.DtoFormalizacionResolucion;
import es.pfsgroup.plugin.rem.model.DtoGastoExpediente;
import es.pfsgroup.plugin.rem.model.DtoInformeJuridico;
import es.pfsgroup.plugin.rem.model.DtoListadoGestores;
import es.pfsgroup.plugin.rem.model.DtoModificarCompradores;
import es.pfsgroup.plugin.rem.model.DtoNotarioContacto;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoObtencionDatosFinanciacion;
import es.pfsgroup.plugin.rem.model.DtoPosicionamiento;
import es.pfsgroup.plugin.rem.model.DtoReserva;
import es.pfsgroup.plugin.rem.model.DtoSubsanacion;
import es.pfsgroup.plugin.rem.model.DtoTanteoActivoExpediente;
import es.pfsgroup.plugin.rem.model.DtoTanteoYRetractoOferta;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.DtoUsuario;
import es.pfsgroup.plugin.rem.model.EntidadProveedor;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Formalizacion;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.GestorSustituto;
import es.pfsgroup.plugin.rem.model.InformeJuridico;
import es.pfsgroup.plugin.rem.model.ObservacionesExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.Posicionamiento;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.Subsanaciones;
import es.pfsgroup.plugin.rem.model.TanteoActivoExpediente;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.TextosOferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VActivoOfertaImporte;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;
import es.pfsgroup.plugin.rem.model.VListadoActivosExpediente;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDAdministracion;
import es.pfsgroup.plugin.rem.model.dd.DDAreaBloqueo;
import es.pfsgroup.plugin.rem.model.dd.DDCanalPrescripcion;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDDevolucionReserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDevolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoFinanciacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosDesbloqueo;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoBloqueo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedorHonorario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRiesgoClase;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;
import es.pfsgroup.plugin.rem.model.dd.DDTiposDocumentos;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.model.dd.DDTiposTextoOferta;
import es.pfsgroup.plugin.rem.reserva.dao.ReservaDao;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDataDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaUVEMDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;
import es.pfsgroup.plugin.rem.rest.dto.ResultadoInstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularUVEMDto;

@Service("expedienteComercialManager")
public class ExpedienteComercialManager extends BusinessOperationOverrider<ExpedienteComercialApi> implements ExpedienteComercialApi {

	protected static final Log logger = LogFactory.getLog(ExpedienteComercialManager.class);
	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	private static final String TANTEO_CONDICIONES_TRANSMISION = "msg.defecto.oferta.tanteo.condiciones.transmision";
	private static final String VISITA_SIN_RELACION_OFERTA = "oferta.validacion.numVisita";
	private static final String PROVEDOR_NO_EXISTE_O_DISTINTO_TIPO = "El proveedor indicado no existe, o no es del tipo indicado";
	private static final int NUMERO_DIAS_VENCIMIENTO = 45;
	private static final String PERFIL_GESTOR_FORMALIZACION = "HAYAGESTFORM";
	private static final String PERFIL_GESTORIA_FORMALIZACION = "GESTIAFORM";
	private static final String PERFIL_SUPERVISOR_FORMALIZACION = "HAYASUPFORM";
	private static final String PERFIL_GESTOR_MINUTAS = "GESMIN";
	private static final String PERFIL_SUPERVISOR_MINUTAS = "SUPMIN";
	private static final String PESTANA_FICHA = "ficha";
	private static final String PESTANA_DATOSBASICOS_OFERTA = "datosbasicosoferta";
	private static final String PESTANA_TANTEO_Y_RETRACTO_OFERTA = "ofertatanteoyretracto";
	private static final String PESTANA_RESERVA = "reserva";
	private static final String PESTANA_CONDICIONES = "condiciones";
	private static final String PESTANA_FORMALIZACION = "formalizacion";
	private static final String TAR_INFORME_JURIDICO = "Informe jurídico";
	@Resource
	private MessageService messageServices;

	// Textos a mostrar por defecto
	public static final Integer NUMERO_DIAS_VENCIMIENTO_SAREB = 40;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private ReservaDao reservaDao;

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;

	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private UvemManagerApi uvemManagerApi;

	@Autowired
	private ActivoTramiteDao tramiteDao;

	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteApi;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private ActivoApi activoApi;
	
	
    @Autowired
    private TareaActivoApi tareaActivoApi;
    
    @Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	@Override
	public String managerName() {
		return "expedienteComercialManager";
	}
	
	@Autowired
	private MSVRawSQLDao rawDao;

	@Override
	public ExpedienteComercial findOne(Long id) {
		return expedienteComercialDao.get(id);
	}
	
	@Override
	public ExpedienteComercial findOneTransactional(Long id) {
		TransactionStatus transaction = null;
		ExpedienteComercial expediente = null;
		try{
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			expediente = this.findOne(id);
			transactionManager.commit(transaction);
		}catch(Exception e){
			logger.error("error buscando el eco", e);
			transactionManager.rollback(transaction);
		}

		return expediente;
	}

	@Override
	public ExpedienteComercial findOneByNumExpediente(Long numExpediente) {
		return expedienteComercialDao.getExpedienteComercialByNumeroExpediente(numExpediente);
	}

	@Override
	public ExpedienteComercial findOneByTrabajo(Trabajo trabajo) {
		return expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());
	}

	@Override
	public ExpedienteComercial findOneByOferta(Oferta oferta) {
		return expedienteComercialDao.getExpedienteComercialByIdOferta(oferta.getId());
	}

	@Override
	public boolean isComiteSancionadorHaya(Trabajo trabajo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "comiteSancion.codigo", DDComiteSancion.CODIGO_HAYA_SAREB);
		Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro, filtro2);

		return !Checks.esNulo(expediente);
	}

	@Override
	public Object getTabExpediente(Long id, String tab) {
		ExpedienteComercial expediente = this.findOne(id);

		WebDto dto = null;

		if (PESTANA_FICHA.equals(tab)) {
			dto = expedienteToDtoFichaExpediente(expediente);
		} else if (PESTANA_DATOSBASICOS_OFERTA.equals(tab)) {
			dto = expedienteToDtoDatosBasicosOferta(expediente);
		} else if (PESTANA_TANTEO_Y_RETRACTO_OFERTA.equals(tab)) {
			dto = expedienteToDtoTanteoYRetractoOferta(expediente);
		} else if (PESTANA_RESERVA.equals(tab)) {
			dto = expedienteToDtoReserva(expediente);
		} else if (PESTANA_CONDICIONES.equals(tab)) {
			dto = expedienteToDtoCondiciones(expediente);
		} else if (PESTANA_FORMALIZACION.equals(tab)) {
			dto = expedienteToDtoFormalizacion(expediente);
		}

		return dto;
	}

	@Override
	public List<DtoTextosOferta> getListTextosOfertaById(Long idExpediente) {
		ExpedienteComercial expediente = findOne(idExpediente);
		Oferta oferta = expediente.getOferta();
		List<Dictionary> tiposTexto = genericAdapter.getDiccionario("tiposTextoOferta");
		Long idOferta = null;

		if (!Checks.esNulo(oferta)) {
			idOferta = oferta.getId();
		}

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", idOferta);
		List<TextosOferta> lista = genericDao.getList(TextosOferta.class, filtro);
		List<DtoTextosOferta> textos = new ArrayList<DtoTextosOferta>();

		for (TextosOferta textoOferta : lista) {
			DtoTextosOferta texto = new DtoTextosOferta();
			texto.setId(textoOferta.getId());
			texto.setCampoDescripcion(textoOferta.getTipoTexto().getDescripcion());
			texto.setCampoCodigo(textoOferta.getTipoTexto().getCodigo());
			texto.setTexto(textoOferta.getTexto());
			textos.add(texto);
			// Solamente habrá un tipo de texto por oferta, de esta manera conseguimos tener en la lista todos los tipos, tengan valor o no.
			tiposTexto.remove(textoOferta.getTipoTexto());
		}

		// Añadimos los tipos que no han sido nunca creados para esta oferta
		long contador = -1L;
		for (Dictionary tipoTextoOferta : tiposTexto) {
			DtoTextosOferta texto = new DtoTextosOferta();
			texto.setId(contador--);
			texto.setCampoDescripcion(tipoTextoOferta.getDescripcion());
			texto.setCampoCodigo(tipoTextoOferta.getCodigo());
			textos.add(texto);
		}

		return textos;
	}

	@Override
	public List<DtoEntregaReserva> getListEntregasReserva(Long id) {
		ExpedienteComercial expediente = findOne(id);
		List<DtoEntregaReserva> lista = new ArrayList<DtoEntregaReserva>();

		if (!Checks.esNulo(expediente.getReserva())) {
			for (EntregaReserva entrega : expediente.getReserva().getEntregas()) {
				DtoEntregaReserva entregaReserva = new DtoEntregaReserva();

				try {
					beanUtilNotNull.copyProperties(entregaReserva, entrega);
					beanUtilNotNull.copyProperty(entregaReserva, "idEntrega", entrega.getId());
					beanUtilNotNull.copyProperty(entregaReserva, "fechaCobro", entrega.getFechaEntrega());

				} catch (IllegalAccessException e) {
					logger.error("error en expedienteComercialManager", e);

				} catch (InvocationTargetException e) {
					logger.error("error en expedienteComercialManager", e);
				}

				lista.add(entregaReserva);
			}
		}

		return lista;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveTextoOferta(DtoTextosOferta dto, Long idEntidad) {
		TextosOferta textoOferta;

		ExpedienteComercial expedienteComercial = findOne(idEntidad);
		Oferta oferta = expedienteComercial.getOferta();

		if (dto.getId() < 0) {
			// Estamos creando un texto que no existía.
			textoOferta = new TextosOferta();
			textoOferta.setOferta(oferta);
			textoOferta.setTexto(dto.getTexto());
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCampoCodigo());
			DDTiposTextoOferta tipoTexto = genericDao.get(DDTiposTextoOferta.class, filtro);
			textoOferta.setTipoTexto(tipoTexto);

		} else {
			// Modificamos un texto existente
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getId());
			textoOferta = genericDao.get(TextosOferta.class, filtro);
			textoOferta.setTexto(dto.getTexto());
		}

		genericDao.save(TextosOferta.class, textoOferta);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveDatosBasicosOferta(DtoDatosBasicosOferta dto, Long idExpediente) {
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		Oferta oferta = expedienteComercial.getOferta();

		if (!Checks.esNulo(dto.getEstadoCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoCodigo());
			DDEstadoOferta estado = genericDao.get(DDEstadoOferta.class, filtro);
			oferta.setEstadoOferta(estado);
		}

		if (!Checks.esNulo(dto.getTipoOfertaCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoOfertaCodigo());
			DDTipoOferta tipoOferta = genericDao.get(DDTipoOferta.class, filtro);
			oferta.setTipoOferta(tipoOferta);
		}

		if (!Checks.esNulo(dto.getEstadoVisitaOfertaCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoVisitaOfertaCodigo());
			DDEstadosVisitaOferta estadoVisitaOferta = genericDao.get(DDEstadosVisitaOferta.class, filtro);
			oferta.setEstadoVisitaOferta(estadoVisitaOferta);
		}

		if (!Checks.esNulo(dto.getCanalPrescripcionCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCanalPrescripcionCodigo());
			DDCanalPrescripcion canalPrescripcion = genericDao.get(DDCanalPrescripcion.class, filtro);
			oferta.setCanalPrescripcion(canalPrescripcion);
		}

		if (("").equals(dto.getCanalPrescripcionCodigo())) {
			oferta.setCanalPrescripcion(null);
		}

		if (!Checks.esNulo(dto.getComitePropuestoCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getComitePropuestoCodigo());
			DDComiteSancion comitePropuesto = genericDao.get(DDComiteSancion.class, filtro);
			expedienteComercial.setComitePropuesto(comitePropuesto);
		}

		if (!Checks.esNulo(dto.getComiteSancionadorCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getComiteSancionadorCodigo());
			DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filtro);
			expedienteComercial.setComiteSancion(comiteSancion);
			expedienteComercial.setComiteSuperior(comiteSancion);
		}

		if (!Checks.esNulo(dto.getNumVisita())) {
			Filter filtroVisita = genericDao.createFilter(FilterType.EQUALS, "numVisitaRem", Long.parseLong(dto.getNumVisita()));
			Filter filtroActivoVisita = genericDao.createFilter(FilterType.EQUALS, "activo.id", oferta.getActivoPrincipal().getId());
			Visita visita = genericDao.get(Visita.class, filtroVisita, filtroActivoVisita);

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expedienteComercial.getId());
			List<GastosExpediente> lista = genericDao.getList(GastosExpediente.class, filtro);

			if (!Checks.esNulo(visita)) {
				oferta.setVisita(visita);

				DDEstadosVisitaOferta estadoVisitaOferta = (DDEstadosVisitaOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosVisitaOferta.class, DDEstadosVisitaOferta
				.ESTADO_VISITA_OFERTA_REALIZADA);
				oferta.setEstadoVisitaOferta(estadoVisitaOferta);

				if (!Checks.esNulo(visita.getApiCustodio()) && Checks.esNulo(oferta.getCustodio())) {
					// Si la visita tiene custodio y la oferta no, lo copiamos.
					oferta.setCustodio(visita.getApiCustodio());

				} else if (!Checks.esNulo(visita.getApiCustodio()) && !Checks.esNulo(oferta.getCustodio())) {
					// si la visita tiene custodio y la oferta también, si son diferentes lo borramos de los honorarios.
					if (!visita.getApiCustodio().getId().equals(oferta.getCustodio().getId())) {
						for (GastosExpediente gasto : lista) {
							if (gasto.getAccionGastos().getCodigo().equals(DDAccionGastos.CODIGO_COLABORACION)) {
								genericDao.deleteById(GastosExpediente.class, gasto.getId());
							}
						}
					}
				}

				if (!Checks.esNulo(visita.getApiResponsable()) && Checks.esNulo(oferta.getApiResponsable())) {
					// Si la visita tiene custodio y la oferta no, lo copiamos.
					oferta.setApiResponsable(visita.getApiResponsable());

				} else if (!Checks.esNulo(visita.getApiResponsable()) && !Checks.esNulo(oferta.getApiResponsable())) {
					// Si la visita tiene custodio y la oferta también, si son diferentes lo borramos de los honorarios.
					if (!visita.getApiResponsable().getId().equals(oferta.getApiResponsable().getId())) {
						for (GastosExpediente gasto : lista) {
							if (gasto.getAccionGastos().getCodigo().equals(DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE)) {
								genericDao.deleteById(GastosExpediente.class, gasto.getId());
							}
						}
					}
				}

				if (!Checks.esNulo(visita.getFdv()) && Checks.esNulo(oferta.getFdv())) {
					// Si la visita tiene custodio y la oferta no, lo copiamos.
					oferta.setFdv(visita.getFdv());

				} else if (!Checks.esNulo(visita.getFdv()) && !Checks.esNulo(oferta.getFdv())) {
					// Si la visita tiene custodio y la oferta también, si son diferentes lo borramos de los honorarios.
					if (!visita.getFdv().getId().equals(oferta.getFdv().getId())) {
						for (GastosExpediente gasto : lista) {
							if (gasto.getAccionGastos().getCodigo().equals(DDAccionGastos.CODIGO_COLABORACION)) {
								genericDao.deleteById(GastosExpediente.class, gasto.getId());
							}
						}
					}
				}

				if (!Checks.esNulo(visita.getPrescriptor()) && Checks.esNulo(oferta.getPrescriptor())) {
					// Si la visita tiene custodio y la oferta no, lo copiamos.
					oferta.setPrescriptor(visita.getPrescriptor());
				}

				genericDao.save(Oferta.class, oferta);

			} else {
				throw new JsonViewerException(messageServices.getMessage(VISITA_SIN_RELACION_OFERTA));
			}
		}

		if ("".equals(dto.getNumVisita())) oferta.setVisita(null);

		if (!Checks.esNulo(dto.getImporteOferta())) {
			ofertaApi.resetPBC(expedienteComercial, false);
		}



		try {
			beanUtilNotNull.copyProperties(oferta, dto);

		} catch (IllegalAccessException e) {
			logger.error("error en expedienteComercialManager", e);

		} catch (InvocationTargetException e) {
			logger.error("error en expedienteComercialManager", e);
		}

		expedienteComercial.setOferta(oferta);
		
		Activo activo = oferta.getActivoPrincipal();

		if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getCartera()) && !Checks.esNulo(dto.getImporteOferta()) && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())){
			expedienteComercial.setComiteSancion(ofertaApi.calculoComiteLiberbank(oferta));
		}

		ofertaApi.updateStateDispComercialActivosByOferta(oferta);

		genericDao.save(ExpedienteComercial.class, expedienteComercial);

		// Si se ha modificado el importe de la oferta o de la contraoferta actualizamos el listado de activos.
		// También se actualiza el importe de la reserva. Actualizar honorarios para el nuevo importe de contraoferta u oferta.
		if (!Checks.esNulo(dto.getImporteOferta()) || !Checks.esNulo(dto.getImporteContraOferta())) {
			this.updateParticipacionActivosOferta(oferta);
			this.actualizarImporteReservaPorExpediente(expedienteComercial);
			this.actualizarHonorariosPorExpediente(expedienteComercial.getId());
		}


		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveOfertaTanteoYRetracto(DtoTanteoYRetractoOferta dtoTanteoYRetractoOferta, Long idExpediente) {
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		Oferta oferta = null;

		if (!Checks.esNulo(expedienteComercial)) oferta = expedienteComercial.getOferta();

		if (!Checks.esNulo(oferta)) {
			try {
				beanUtilNotNull.copyProperties(oferta, dtoTanteoYRetractoOferta);

				if (!Checks.esNulo(dtoTanteoYRetractoOferta.getResultadoTanteoCodigo()))
					oferta.setResultadoTanteo((DDResultadoTanteo) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoTanteo.class, dtoTanteoYRetractoOferta.getResultadoTanteoCodigo()));

			} catch (IllegalAccessException e) {
				logger.error("error en expedienteComercialManager", e);

			} catch (InvocationTargetException e) {
				logger.error("error en expedienteComercialManager", e);
			}
		}

		genericDao.save(Oferta.class, oferta);

		return true;
	}

	private DtoFichaExpediente expedienteToDtoFichaExpediente(ExpedienteComercial expediente) {
		DtoFichaExpediente dto = new DtoFichaExpediente();
		Oferta oferta;
		Activo activo = null;
		Reserva reserva;
		CondicionanteExpediente condiciones;

		if (!Checks.esNulo(expediente)) {
			reserva = expediente.getReserva();
			oferta = expediente.getOferta();
			condiciones = expediente.getCondicionante();

			if (!Checks.esNulo(condiciones)) {
				dto.setSolicitaReserva(condiciones.getSolicitaReserva());
			}

			if (!Checks.esNulo(oferta)) {
				activo = oferta.getActivoPrincipal();
			}

			dto.setId(expediente.getId());

			if (!Checks.esNulo(oferta) && !Checks.esNulo(activo)) {
				dto.setNumExpediente(expediente.getNumExpediente());
				if (!Checks.esNulo(activo.getCartera())) {
					dto.setEntidadPropietariaDescripcion(activo.getCartera().getDescripcion());
					dto.setEntidadPropietariaCodigo(activo.getCartera().getCodigo());
				}

				if(!Checks.esNulo(activo.getSubcartera())) {
					dto.setSubcarteraCodigo(activo.getSubcartera().getCodigo());
				}

				if (!Checks.esNulo(oferta.getTipoOferta())) {
					dto.setTipoExpedienteDescripcion(oferta.getTipoOferta().getDescripcion());
					dto.setTipoExpedienteCodigo(oferta.getTipoOferta().getCodigo());

					if (DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
						dto.setImporte(!Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteContraOferta() : oferta.getImporteOferta());

					} else if (DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())) {
						dto.setImporte(oferta.getImporteOferta());
					}
				}

				dto.setPropietario(activo.getFullNamePropietario());

				if (!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
					dto.setMediador(activo.getInfoComercial().getMediadorInforme().getNombre());
				}

				dto.setImporte(!Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteContraOferta() : oferta.getImporteOferta());

				if (!Checks.esNulo(expediente.getCompradorPrincipal())) {
					dto.setComprador(expediente.getCompradorPrincipal().getFullName());
				}

				if (!Checks.esNulo(expediente.getEstado())) {
					dto.setEstado(expediente.getEstado().getDescripcion());
					dto.setCodigoEstado(expediente.getEstado().getCodigo());
				}

				dto.setFechaAlta(expediente.getFechaAlta());
				dto.setFechaAltaOferta(oferta.getFechaAlta());
				dto.setFechaSancion(expediente.getFechaSancion());

				if (!Checks.esNulo(expediente.getReserva())) {
					dto.setFechaReserva(expediente.getReserva().getFechaFirma());
				}

				if (!Checks.esNulo(oferta.getAgrupacion())) {
					dto.setIdAgrupacion(oferta.getAgrupacion().getId());
					dto.setNumEntidad(oferta.getAgrupacion().getNumAgrupRem());

				} else {
					dto.setIdActivo(activo.getId());
					dto.setNumEntidad(activo.getNumActivo());
				}

				if (!Checks.esNulo(expediente.getUltimoPosicionamiento())) {
					dto.setFechaPosicionamiento(expediente.getUltimoPosicionamiento().getFechaPosicionamiento());
				}

				if (!Checks.esNulo(expediente.getMotivoAnulacion())) {
					dto.setCodMotivoAnulacion(expediente.getMotivoAnulacion().getCodigo());
					dto.setDescMotivoAnulacion(expediente.getMotivoAnulacion().getDescripcion());
				}

				dto.setFechaAnulacion(expediente.getFechaAnulacion());

				if (!Checks.esNulo(reserva)) {
					if (!Checks.esNulo(reserva.getEstadoDevolucion())) {
						dto.setEstadoDevolucionCodigo(reserva.getEstadoDevolucion().getCodigo());
					}

					if (!Checks.esNulo(reserva.getDevolucionReserva())) {
						dto.setCodDevolucionReserva(reserva.getDevolucionReserva().getCodigo());
					}

					if (!Checks.esNulo(reserva.getEstadoReserva())) {
						dto.setEstadoReserva(reserva.getEstadoReserva().getDescripcion());
					}
				}

				dto.setPeticionarioAnulacion(expediente.getPeticionarioAnulacion());
				dto.setFechaContabilizacionPropietario(expediente.getFechaContabilizacionPropietario());
				dto.setFechaDevolucionEntregas(expediente.getFechaDevolucionEntregas());
				dto.setImporteDevolucionEntregas(expediente.getImporteDevolucionEntregas());

				if (!Checks.esNulo(expediente.getCondicionante())) {
					Integer tieneReserva = expediente.getCondicionante().getSolicitaReserva();
					dto.setTieneReserva(!Checks.esNulo(tieneReserva) && tieneReserva == 1);

					Integer ocultar = expediente.getCondicionante().getSujetoTanteoRetracto();
					dto.setOcultarPestTanteoRetracto(Checks.esNulo(ocultar) || ocultar != 1);
				}

				if (!Checks.esNulo(expediente.getFechaInicioAlquiler())) {
					dto.setFechaInicioAlquiler(expediente.getFechaInicioAlquiler());
				}

				if (!Checks.esNulo(expediente.getFechaFinAlquiler())) {
					dto.setFechaFinAlquiler(expediente.getFechaFinAlquiler());
				}

				if (!Checks.esNulo(expediente.getImporteRentaAlquiler())) {
					dto.setImporteRentaAlquiler(expediente.getImporteRentaAlquiler());
				}

				if (!Checks.esNulo(expediente.getNumContratoAlquiler())) {
					dto.setNumContratoAlquiler(expediente.getNumContratoAlquiler());
				}

				if (!Checks.esNulo(expediente.getFechaPlazoOpcionCompraAlquiler())) {
					dto.setFechaPlazoOpcionCompraAlquiler(expediente.getFechaPlazoOpcionCompraAlquiler());
				}

				if (!Checks.esNulo(expediente.getPrimaOpcionCompraAlquiler())) {
					dto.setPrimaOpcionCompraAlquiler(expediente.getPrimaOpcionCompraAlquiler());
				}

				if (!Checks.esNulo(expediente.getPrecioOpcionCompraAlquiler())) {
					dto.setPrecioOpcionCompraAlquiler(expediente.getPrecioOpcionCompraAlquiler());
				}

				if (!Checks.esNulo(expediente.getCondicionesOpcionCompraAlquiler())) {
					dto.setCondicionesOpcionCompraAlquiler(expediente.getCondicionesOpcionCompraAlquiler());
				}

				if (!Checks.esNulo(expediente.getConflictoIntereses())) {
					dto.setConflictoIntereses(expediente.getConflictoIntereses());
				}

				if (!Checks.esNulo(expediente.getRiesgoReputacional())) {
					dto.setRiesgoReputacional(expediente.getRiesgoReputacional());
				}

				if (!Checks.esNulo(expediente.getEstadoPbc())) {
					dto.setEstadoPbc(expediente.getEstadoPbc());
				}

				if (!Checks.esNulo(expediente.getFechaVenta())) {
					dto.setFechaVenta(expediente.getFechaVenta());
				}

				if (!Checks.esNulo(activo.getTipoComercializacion())) {
					DDTipoAlquiler tipoAlquiler = (DDTipoAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoAlquiler.class, DDTipoAlquiler.CODIGO_ALQUILER_OPCION_COMPRA);
					if (tipoAlquiler.equals(activo.getTipoAlquiler())) {
						dto.setAlquilerOpcionCompra(1);
					} else {
						dto.setAlquilerOpcionCompra(0);
					}
				}

				if (Checks.esNulo(expediente.getBloqueado()) || 0 == expediente.getBloqueado()) {
					dto.setBloqueado(false);
				} else {
					dto.setBloqueado(true);
				}
			}
		}

		return dto;
	}

	private DtoDatosBasicosOferta expedienteToDtoDatosBasicosOferta(ExpedienteComercial expediente) {
		DtoDatosBasicosOferta dto = new DtoDatosBasicosOferta();
		Oferta oferta = expediente.getOferta();

		dto.setIdOferta(oferta.getId());
		dto.setNumOferta(oferta.getNumOferta());

		if (!Checks.esNulo(oferta.getTipoOferta())) {
			dto.setTipoOfertaDescripcion(oferta.getTipoOferta().getDescripcion());
			dto.setTipoOfertaCodigo(oferta.getTipoOferta().getCodigo());
		}

		dto.setFechaNotificacion(oferta.getFechaNotificacion());
		dto.setFechaAlta(oferta.getFechaAlta());

		if (!Checks.esNulo(oferta.getEstadoOferta())) {
			dto.setEstadoDescripcion(oferta.getEstadoOferta().getDescripcion());
			dto.setEstadoCodigo(oferta.getEstadoOferta().getCodigo());
		}

		if (!Checks.esNulo(oferta.getPrescriptor())) {
			dto.setPrescriptor(oferta.getPrescriptor().getNombre());
		}

		dto.setImporteOferta(oferta.getImporteOferta());
		dto.setImporteContraOferta(oferta.getImporteContraOferta());

		if (!Checks.esNulo(oferta.getVisita())) {
			dto.setNumVisita(oferta.getVisita().getNumVisitaRem().toString());
		}

		if (!Checks.esNulo(oferta.getEstadoVisitaOferta())) {
			dto.setEstadoVisitaOfertaCodigo(oferta.getEstadoVisitaOferta().getCodigo());
			dto.setEstadoVisitaOfertaDescripcion(oferta.getEstadoVisitaOferta().getDescripcion());
		}

		// antiguo canal prescriptor
		if (!Checks.esNulo(oferta.getCanalPrescripcion())) {
			dto.setCanalPrescripcionCodigo(oferta.getCanalPrescripcion().getCodigo());
			dto.setCanalPrescripcionDescripcion(oferta.getCanalPrescripcion().getDescripcion());
		}

		if (!Checks.esNulo(expediente.getComitePropuesto())) {
			dto.setComitePropuestoCodigo(expediente.getComitePropuesto().getCodigo());
		}

		if (!Checks.esNulo(expediente.getComiteSancion())) {
			dto.setComiteSancionadorCodigo(expediente.getComiteSancion().getCodigo());
		}

		// nuevo canal prescriptor
		if (!Checks.esNulo(oferta.getPrescriptor())) {
			dto.setCanalPrescripcionDescripcion(oferta.getPrescriptor().getTipoProveedor().getDescripcion());
		} else {
			dto.setCanalPrescripcionDescripcion(null);
		}

		if (!Checks.esNulo(oferta.getOfertaExpress())) {
			dto.setOfertaExpress(oferta.getOfertaExpress() ? "Si" : "No");
		}

		if (!Checks.esNulo(oferta.getNecesitaFinanciacion())) {
			dto.setNecesitaFinanciacion(oferta.getNecesitaFinanciacion() ? "Si" : "No");
		}

		dto.setObservaciones(oferta.getObservaciones());

		if(!Checks.esNulo(oferta.getVentaDirecta())){
			dto.setVentaCartera(oferta.getVentaDirecta() ? "Si" : "No");
		}

		return dto;
	}

	private DtoTanteoYRetractoOferta expedienteToDtoTanteoYRetractoOferta(ExpedienteComercial expediente) {
		DtoTanteoYRetractoOferta dtoTanteoYRetractoOferta = new DtoTanteoYRetractoOferta();
		Oferta oferta = null;

		if (!Checks.esNulo(expediente)) oferta = expediente.getOferta();

		if (!Checks.esNulo(oferta)) {
			try {
				beanUtilNotNull.copyProperties(dtoTanteoYRetractoOferta, oferta);
				dtoTanteoYRetractoOferta.setIdOferta(oferta.getId());

				if (!Checks.esNulo(oferta.getResultadoTanteo())) {
					dtoTanteoYRetractoOferta.setResultadoTanteoCodigo(oferta.getResultadoTanteo().getCodigo());
					dtoTanteoYRetractoOferta.setResultadoTanteoDescripcion(oferta.getResultadoTanteo().getDescripcion());
				}

				if (Checks.esNulo(oferta.getCondicionesTransmision())) dtoTanteoYRetractoOferta.setCondicionesTransmision(messageServices.getMessage(TANTEO_CONDICIONES_TRANSMISION));

			} catch (IllegalAccessException e) {
				logger.error("error en expedienteComercialManager", e);

			} catch (InvocationTargetException e) {
				logger.error("error en expedienteComercialManager", e);
			}
		}

		return dtoTanteoYRetractoOferta;
	}

	private DtoReserva expedienteToDtoReserva(ExpedienteComercial expediente) {
		DtoReserva dto = new DtoReserva();

		Reserva reserva = expediente.getReserva();

		if (!Checks.esNulo(reserva)) {
			dto.setIdReserva(reserva.getId());
			dto.setNumReserva(reserva.getNumReserva());
			dto.setFechaEnvio(reserva.getFechaEnvio());
			dto.setFechaFirma(reserva.getFechaFirma());
			dto.setFechaVencimiento(reserva.getFechaVencimiento());
			if (!Checks.esNulo(reserva.getEstadoReserva())) {
				dto.setEstadoReservaDescripcion(reserva.getEstadoReserva().getDescripcion());
				dto.setEstadoReservaCodigo(reserva.getEstadoReserva().getCodigo());
			}

			if (!Checks.esNulo(reserva.getTipoArras())) {
				dto.setTipoArrasCodigo(reserva.getTipoArras().getCodigo());

			} else {
				if (!Checks.esNulo(expediente.getOferta()) && !Checks.esNulo(expediente.getOferta().getActivoPrincipal()) && !Checks.esNulo(expediente.getOferta().getActivoPrincipal().getCartera())
				&& DDCartera.CODIGO_CARTERA_CAJAMAR.equals(expediente.getOferta().getActivoPrincipal().getCartera().getCodigo())) {
					dto.setTipoArrasCodigo(DDTiposArras.CONFIRMATORIAS);
				}
			}

			if (!Checks.esNulo(expediente.getCondicionante())) {
				dto.setConImpuesto(expediente.getCondicionante().getReservaConImpuesto());
				dto.setImporte(expediente.getCondicionante().getImporteReserva());
			}

			if (!Checks.esNulo(expediente.getOferta().getSucursal())) {
				dto.setCodigoSucursal(expediente.getOferta().getSucursal().getCodProveedorUvem().substring(4));
				dto.setSucursal(expediente.getOferta().getSucursal().getNombre() + " (" + expediente.getOferta().getSucursal().getTipoProveedor().getDescripcion() + ")");
			}

			dto.setCartera(expediente.getOferta().getActivoPrincipal().getCartera().getCodigo());
		}

		return dto;
	}

	@Override
	@SuppressWarnings("unchecked")
	public DtoPage getListObservaciones(Long idExpediente, WebDto dto) {
		Page page = expedienteComercialDao.getObservacionesByExpediente(idExpediente, dto);

		List<DtoObservacion> observaciones = new ArrayList<DtoObservacion>();

		for (ObservacionesExpedienteComercial observacion : (List<ObservacionesExpedienteComercial>) page.getResults()) {
			DtoObservacion dtoObservacion = observacionToDto(observacion);
			observaciones.add(dtoObservacion);
		}

		return new DtoPage(observaciones, page.getTotalCount());
	}


	@Transactional(readOnly = false)
	public boolean saveObservacion(DtoObservacion dtoObservacion) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoObservacion.getId()));
		ObservacionesExpedienteComercial observacion = genericDao.get(ObservacionesExpedienteComercial.class, filtro);

		try {
			beanUtilNotNull.copyProperties(observacion, dtoObservacion);
			genericDao.save(ObservacionesExpedienteComercial.class, observacion);

		} catch (IllegalAccessException e) {
			logger.error("error en expedienteComercialManager", e);

		} catch (InvocationTargetException e) {
			logger.error("error en expedienteComercialManager", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean createObservacion(DtoObservacion dtoObservacion, Long idExpediente) {
		ObservacionesExpedienteComercial observacion = new ObservacionesExpedienteComercial();
		observacion.setObservacion(dtoObservacion.getObservacion());
		observacion.setFecha(new Date());
		observacion.setUsuario(genericAdapter.getUsuarioLogado());
		observacion.setExpediente(this.findOne(idExpediente));
		genericDao.save(ObservacionesExpedienteComercial.class, observacion);

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteObservacion(Long idObservacion) {
		genericDao.deleteById(ObservacionesExpedienteComercial.class, idObservacion);

		return true;
	}

	private DtoObservacion observacionToDto(ObservacionesExpedienteComercial observacion) {
		DtoObservacion observacionDto = new DtoObservacion();

		try {
			String nombreCompleto = observacion.getUsuario().getNombre();
			Long idUsuario = observacion.getUsuario().getId();

			if (observacion.getUsuario().getApellido1() != null) {
				nombreCompleto += observacion.getUsuario().getApellido1();

				if (observacion.getUsuario().getApellido2() != null) {
					nombreCompleto += observacion.getUsuario().getApellido2();
				}
			}

			if (!Checks.esNulo(observacion.getAuditoria().getFechaModificar())) {
				observacionDto.setFechaModificacion(observacion.getAuditoria().getFechaModificar());
			}

			BeanUtils.copyProperties(observacionDto, observacion);
			observacionDto.setNombreCompleto(nombreCompleto);
			observacionDto.setIdUsuario(idUsuario);

		} catch (IllegalAccessException e) {
			logger.error("error en expedienteComercialManager", e);

		} catch (InvocationTargetException e) {
			logger.error("error en expedienteComercialManager", e);
		}

		return observacionDto;
	}

	@Override
	public DtoPage getActivosExpediente(Long idExpediente) {
		ExpedienteComercial expediente = findOne(idExpediente);
		List<DtoActivosExpediente> activos = new ArrayList<DtoActivosExpediente>();
		List<ActivoOferta> activosExpediente = expediente.getOferta().getActivosOferta();
		List<Activo> listaActivosExpediente = new ArrayList<Activo>();

		// Se crea un mapa para cada dato que se quiere obtener
		Map<Long, Double> activoPorcentajeParti = new HashMap<Long, Double>();
		Map<Long, Double> activoPrecioAprobado = new HashMap<Long, Double>();
		Map<Long, Double> activoPrecioMinimo = new HashMap<Long, Double>();
		Map<Long, Double> activoImporteParticipacion = new HashMap<Long, Double>();

		// Recorre los activos de la oferta y los añade a la lista de activos a mostrar
		for (ActivoOferta activoOferta : activosExpediente) {
			listaActivosExpediente.add(activoOferta.getPrimaryKey().getActivo());
			if (!Checks.esNulo(activoOferta.getPorcentajeParticipacion())) {
				activoPorcentajeParti.put(activoOferta.getPrimaryKey().getActivo().getId(), activoOferta.getPorcentajeParticipacion());
				if (!Checks.esNulo(activoOferta.getImporteActivoOferta())) {
					activoImporteParticipacion.put(activoOferta.getPrimaryKey().getActivo().getId(), (activoOferta.getImporteActivoOferta()));
				}
			}
		}

		// Por cada activo recorre todas sus valoraciones para adquirir el precio aprobado de venta y el precio mínimo autorizado
		for (Activo activo : listaActivosExpediente) {
			for (ActivoValoraciones valoracion : activo.getValoracion()) {
				if (DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(valoracion.getTipoPrecio().getCodigo())) {
					activoPrecioAprobado.put(activo.getId(), valoracion.getImporte());
				}

				if (DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO.equals(valoracion.getTipoPrecio().getCodigo())) {
					activoPrecioMinimo.put(activo.getId(), valoracion.getImporte());
				}
			}

			// Convierte todos los datos obtenidos en un dto
			DtoActivosExpediente dtoActivo = activosToDto(activo, activoPorcentajeParti, activoPrecioAprobado, activoPrecioMinimo, activoImporteParticipacion);

			// calculamos los pilotos de tanteos,condiciones y bloqueos
			DtoInformeJuridico dtoInfoJuridico = this.getFechaEmisionInfJuridico(idExpediente, dtoActivo.getIdActivo());
			if (dtoInfoJuridico == null || dtoInfoJuridico.getFechaEmision() == null) {
				dtoActivo.setBloqueos(2);// pendiente

			} else {
				if (dtoInfoJuridico.getResultadoBloqueo() != null && dtoInfoJuridico.getResultadoBloqueo().equals(InformeJuridico.RESULTADO_FAVORABLE)) {
					dtoActivo.setBloqueos(1);
				} else {
					dtoActivo.setBloqueos(0);
				}
			}

			DtoCondicionesActivoExpediente condiciones = this.getCondicionesActivoExpediete(idExpediente, dtoActivo.getIdActivo());
			if (condiciones.getSituacionPosesoriaCodigo() != null && condiciones.getSituacionPosesoriaCodigoInformada() != null && condiciones.getSituacionPosesoriaCodigo().equals(condiciones
			.getSituacionPosesoriaCodigoInformada()) && condiciones.getPosesionInicial() != null && condiciones.getPosesionInicialInformada() != null && condiciones.getPosesionInicial().equals
			(condiciones.getPosesionInicialInformada()) && condiciones.getEstadoTitulo() != null && condiciones.getEstadoTituloInformada() != null && condiciones.getEstadoTitulo().equals(condiciones
			.getEstadoTituloInformada())) {
				dtoActivo.setCondiciones(1);
			} else {
				dtoActivo.setCondiciones(0);
			}

			CondicionanteExpediente condicionantes = expediente.getCondicionante();
			if (condicionantes != null) {
				if (condicionantes.getSujetoTanteoRetracto() != null && 0 == condicionantes.getSujetoTanteoRetracto()) {
					dtoActivo.setTanteos(3);

				} else {
					dtoActivo.setTanteos(3);
					List<TanteoActivoExpediente> tanteosExpediente = expediente.getTanteoActivoExpediente();
					int contTanteosActivo = 0;
					int contTanteosActivoRenunciado = 0;
					for (TanteoActivoExpediente tanteo : tanteosExpediente) {
						if (tanteo.getActivo().getId().equals(activo.getId())) {
								contTanteosActivo++;
							if (tanteo.getResultadoTanteo() != null) {
								if (tanteo.getResultadoTanteo().getCodigo().equals(DDResultadoTanteo.CODIGO_EJERCIDO)) {
									dtoActivo.setTanteos(2);
									break;
								} else if (DDResultadoTanteo.CODIGO_RENUNCIADO.equals(tanteo.getResultadoTanteo().getCodigo())) {
									contTanteosActivoRenunciado++;
								}
							} else {
								dtoActivo.setTanteos(0);
							}
						}
					}

					if (contTanteosActivo > 0 && contTanteosActivo == contTanteosActivoRenunciado) {
						dtoActivo.setTanteos(1);
					}
				}
			}

			activos.add(dtoActivo);
		}

		return new DtoPage(activos, activos.size());
	}

	@Override
	public DtoPage getActivosExpedienteVista(Long idExpediente) {
		List<VListadoActivosExpediente> listadoActivos = genericDao.getList(VListadoActivosExpediente.class,
				genericDao.createFilter(FilterType.EQUALS, "idExpediente", idExpediente));

		return new DtoPage(listadoActivos, listadoActivos.size());
	}

	/**
	 * Convierte una entidad Activo a objeto dto.
	 *
	 * @param activo: entidad a convertir a objeto
	 * @return Devuelve un dto con los datos de la entidad recibida.
	 */
	private DtoActivosExpediente activosToDto(Activo activo, Map<Long, Double> activoPorcentajeParti, Map<Long, Double> activoPrecioAprobado, Map<Long, Double> activoPrecioMinimo, Map<Long, Double>
	activoImporteParticipacion) {
		DtoActivosExpediente dtoActivo = new DtoActivosExpediente();
		dtoActivo.setIdActivo(activo.getId());
		dtoActivo.setNumActivo(activo.getNumActivo());

		if (!Checks.esNulo(activo.getSubtipoActivo())) {
			dtoActivo.setSubtipoActivo(activo.getSubtipoActivo().getDescripcion());
		}

		if (!Checks.esNulo(activo.getTipoActivo())) {
			dtoActivo.setTipoActivo(activo.getTipoActivo().getDescripcion());
		}

		if (!Checks.estaVacio(activoPorcentajeParti)) {
			dtoActivo.setPorcentajeParticipacion(activoPorcentajeParti.get(activo.getId()));
		}

		if (!Checks.estaVacio(activoPrecioAprobado)) {
			dtoActivo.setPrecioAprobadoVenta(activoPrecioAprobado.get(activo.getId()));
		}

		if (!Checks.estaVacio(activoPrecioMinimo)) {
			dtoActivo.setPrecioMinimo(activoPrecioMinimo.get(activo.getId()));
		}

		if (!Checks.estaVacio(activoImporteParticipacion)) {
			dtoActivo.setImporteParticipacion((activoImporteParticipacion.get(activo.getId())));
		}

		if (activo.getMunicipio() != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activo.getMunicipio());
			Localidad localidad = genericDao.get(Localidad.class, filtro);
			dtoActivo.setMunicipio(localidad.getDescripcion());
			dtoActivo.setProvincia(localidad.getProvincia().getDescripcion());
		}

		if (activo.getDireccion() != null) {
			dtoActivo.setDireccion(activo.getDireccion());
		}

		if (!Checks.esNulo(activo.getInfoRegistral()) && !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien())) {
			dtoActivo.setFincaRegistral(activo.getInfoRegistral().getInfoRegistralBien().getNumFinca());
		}

		return dtoActivo;
	}

	public FileItem getFileItemAdjunto(DtoAdjuntoExpediente dtoAdjunto) {
		ExpedienteComercial expediente = findOne(dtoAdjunto.getIdExpediente());
		AdjuntoExpedienteComercial adjuntoExpediente = expediente.getAdjunto(dtoAdjunto.getId());

		FileItem fileItem = adjuntoExpediente.getAdjunto().getFileItem();
		fileItem.setContentType(adjuntoExpediente.getContentType());
		fileItem.setFileName(adjuntoExpediente.getNombre());

		return adjuntoExpediente.getAdjunto().getFileItem();
	}

	@Override
	public List<DtoAdjuntoExpediente> getAdjuntos(Long idExpediente) {
		List<DtoAdjuntoExpediente> listaAdjuntos = new ArrayList<DtoAdjuntoExpediente>();

		try {
			ExpedienteComercial expediente = findOne(idExpediente);

			for (AdjuntoExpedienteComercial adjunto : expediente.getAdjuntos()) {
				DtoAdjuntoExpediente dto = new DtoAdjuntoExpediente();

				BeanUtils.copyProperties(dto, adjunto);
				dto.setIdExpediente(expediente.getId());
				dto.setDescripcionTipo(adjunto.getTipoDocumentoExpediente().getDescripcion());
				dto.setDescripcionSubtipo(adjunto.getSubtipoDocumentoExpediente().getDescripcion());
				dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());

				listaAdjuntos.add(dto);
			}

		} catch (InvocationTargetException e) {
			logger.error("error en expedienteComercialManager", e);

		} catch (IllegalAccessException e) {
			logger.error("error en expedienteComercialManager", e);
		}

		return listaAdjuntos;
	}

	@Override
	public Boolean comprobarExisteAdjuntoExpedienteComercial(Long idTrabajo, String codigoDocumento) {
		Filter filtroTrabajoEC = genericDao.createFilter(FilterType.EQUALS, "expediente.trabajo.id", idTrabajo);
		Filter filtroAdjuntoSubtipoCodigo = genericDao.createFilter(FilterType.EQUALS, "subtipoDocumentoExpediente.codigo", codigoDocumento);

		List<AdjuntoExpedienteComercial> adjuntos = genericDao.getList(AdjuntoExpedienteComercial.class, filtroTrabajoEC, filtroAdjuntoSubtipoCodigo);

		return !Checks.estaVacio(adjuntos);
	}

	@Override
	@Transactional(readOnly = false)
	public String upload(WebFileItem fileItem) throws Exception {
		return uploadDocumento(fileItem, null, null, null);
	}

	@Override
	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem fileItem, Long idDocRestClient,
			ExpedienteComercial expedienteComercialEntrada, String matricula) throws Exception {
		ExpedienteComercial expedienteComercial;
		DDTipoDocumentoExpediente tipoDocumento = null;

		if (Checks.esNulo(expedienteComercialEntrada)) {
			expedienteComercial = findOne(Long.parseLong(fileItem.getParameter("idEntidad")));

			if (fileItem.getParameter("tipo") == null) {
				throw new Exception("Tipo no valido");
			}

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
			tipoDocumento = genericDao.get(DDTipoDocumentoExpediente.class, filtro);

		} else {
			expedienteComercial = expedienteComercialEntrada;
			if (!Checks.esNulo(matricula)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				tipoDocumento = genericDao.get(DDTipoDocumentoExpediente.class, filtro);
			}
		}

		// Subida de adjunto al Expediente Comercial
		ActivoAdjuntoActivo adjuntoActivo = null;

		if (fileItem.getFileItem().getLength() == 0) {
			throw new JsonViewerException("Está intentando adjuntar un fichero vacio");
		}

		Adjunto adj = uploadAdapter.saveBLOB(fileItem.getFileItem());

		AdjuntoExpedienteComercial adjuntoExpediente = new AdjuntoExpedienteComercial();
		adjuntoExpediente.setAdjunto(adj);

		adjuntoExpediente.setExpediente(expedienteComercial);

		// Establecer tipo y subtipo del adjunto a subir.
		adjuntoExpediente.setTipoDocumentoExpediente(tipoDocumento);

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("subtipo"));
		adjuntoExpediente.setSubtipoDocumentoExpediente(genericDao.get(DDSubtipoDocumentoExpediente.class, filtro));

		adjuntoExpediente.setContentType(fileItem.getFileItem().getContentType());
		adjuntoExpediente.setTamanyo(fileItem.getFileItem().getLength());
		adjuntoExpediente.setNombre(fileItem.getFileItem().getFileName());
		adjuntoExpediente.setDescripcion(fileItem.getParameter("descripcion"));
		adjuntoExpediente.setFechaDocumento(new Date());
		adjuntoExpediente.setIdDocRestClient(idDocRestClient);
		Auditoria.save(adjuntoExpediente);

		expedienteComercial.getAdjuntos().add(adjuntoExpediente);

		genericDao.save(ExpedienteComercial.class, expedienteComercial);

		for (ActivoOferta activoOferta : expedienteComercial.getOferta().getActivosOferta()) {
			if (!Checks.esNulo(adjuntoExpediente) && !Checks.esNulo(adjuntoExpediente.getSubtipoDocumentoExpediente())
					&& !Checks.esNulo(adjuntoExpediente.getSubtipoDocumentoExpediente().getMatricula())) {
				Activo activo = activoOferta.getPrimaryKey().getActivo();
				activoAdapter.uploadDocumento(fileItem, activo,
						adjuntoExpediente.getSubtipoDocumentoExpediente().getMatricula());
				if (activo.getAdjuntos() != null && activo.getAdjuntos().size() > 0) {
					adjuntoActivo = activo.getAdjuntos().get(activo.getAdjuntos().size() - 1);
				}
			}
		}

		if (!Checks.esNulo(adjuntoActivo)) {
			adjuntoExpediente.setIdDocRestClient(adjuntoActivo.getIdDocRestClient());
			genericDao.update(AdjuntoExpedienteComercial.class, adjuntoExpediente);
		}

		return null;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		ExpedienteComercial expediente = findOne(dtoAdjunto.getIdEntidad());
		AdjuntoExpedienteComercial adjunto = expediente.getAdjunto(dtoAdjunto.getId());

		if (adjunto == null) {
			return false;
		}

		expediente.getAdjuntos().remove(adjunto);
		genericDao.save(ExpedienteComercial.class, expediente);

		return true;
	}

	@Override
	public Page getCompradoresByExpediente(Long idExpediente, WebDto dto) {
		return expedienteComercialDao.getCompradoresByExpediente(idExpediente, dto);
	}

	@Override
	public VBusquedaDatosCompradorExpediente getDatosCompradorById(String idCom, String idExp) {
		Filter filtroCom = genericDao.createFilter(FilterType.EQUALS, "id", idCom);
		Filter filtroEco = genericDao.createFilter(FilterType.EQUALS, "idExpedienteComercial", idExp);

		return genericDao.get(VBusquedaDatosCompradorExpediente.class, filtroCom, filtroEco);
	}

	private DtoCondiciones expedienteToDtoCondiciones(ExpedienteComercial expediente) {
		DtoCondiciones dto = new DtoCondiciones();
		CondicionanteExpediente condiciones = expediente.getCondicionante();

		// Si el expediente pertenece a una agrupación miramos el activo principal
		if (!Checks.esNulo(expediente.getOferta().getAgrupacion())) {
			Activo activoPrincipal = expediente.getOferta().getActivoPrincipal();

			if (!Checks.esNulo(activoPrincipal)) {
				dto.setFechaUltimaActualizacion(activoPrincipal.getFechaRevisionCarga());
				dto.setVpo(activoPrincipal.getVpo());

				if (!Checks.esNulo(activoPrincipal.getSituacionPosesoria())) {
					dto.setFechaTomaPosesion(activoPrincipal.getSituacionPosesoria().getFechaTomaPosesion());
					dto.setOcupado(activoPrincipal.getSituacionPosesoria().getOcupado());
					dto.setConTitulo(activoPrincipal.getSituacionPosesoria().getConTitulo());
					if (!Checks.esNulo(activoPrincipal.getSituacionPosesoria().getTipoTituloPosesorio())) {
						dto.setTipoTitulo(activoPrincipal.getSituacionPosesoria().getTipoTituloPosesorio().getDescripcion());
					}
				}
			}

		} else {
			Activo activo = expediente.getOferta().getActivosOferta().get(0).getPrimaryKey().getActivo();

			if (!Checks.esNulo(activo)) {
				dto.setFechaUltimaActualizacion(activo.getFechaRevisionCarga());
				dto.setVpo(activo.getVpo());

				if (!Checks.esNulo(activo.getSituacionPosesoria())) {
					dto.setFechaTomaPosesion(activo.getSituacionPosesoria().getFechaTomaPosesion());
					dto.setOcupado(activo.getSituacionPosesoria().getOcupado());
					dto.setConTitulo(activo.getSituacionPosesoria().getConTitulo());
					if (!Checks.esNulo(activo.getSituacionPosesoria().getTipoTituloPosesorio())) {
						dto.setTipoTitulo(activo.getSituacionPosesoria().getTipoTituloPosesorio().getDescripcion());
					}
				}
			}
		}

		if (!Checks.esNulo(condiciones)) {
			// Económicas-Financiación
			dto.setSolicitaFinanciacion(condiciones.getSolicitaFinanciacion());
			if (!Checks.esNulo(condiciones.getEstadoFinanciacion())) {
				dto.setEstadosFinanciacion(condiciones.getEstadoFinanciacion().getCodigo());
			}
			dto.setEntidadFinanciacion(condiciones.getEntidadFinanciacion());
			dto.setFechaInicioExpediente(condiciones.getFechaInicioExpediente());
			dto.setFechaInicioFinanciacion(condiciones.getFechaInicioFinanciacion());
			dto.setFechaFinFinanciacion(condiciones.getFechaFinFinanciacion());

			// Económicas-Reserva
			dto.setSolicitaReserva(condiciones.getSolicitaReserva());
			if (!Checks.esNulo(condiciones.getTipoCalculoReserva())) {
				dto.setTipoCalculo(condiciones.getTipoCalculoReserva().getCodigo());
			}
			dto.setPorcentajeReserva(condiciones.getPorcentajeReserva());
			dto.setPlazoFirmaReserva(condiciones.getPlazoFirmaReserva());
			dto.setImporteReserva(condiciones.getImporteReserva());

			// Economicas-Fiscales
			if (!Checks.esNulo(condiciones.getTipoImpuesto())) {
				dto.setTipoImpuestoCodigo(condiciones.getTipoImpuesto().getCodigo());
			}
			dto.setTipoAplicable(condiciones.getTipoAplicable());
			dto.setRenunciaExencion(condiciones.getRenunciaExencion());
			if (!Checks.esNulo(condiciones.getReservaConImpuesto())) {
				if (condiciones.getReservaConImpuesto() == 0) {
					dto.setReservaConImpuesto(false);
				} else {
					dto.setReservaConImpuesto(true);
				}
			}
			dto.setOperacionExenta(condiciones.getOperacionExenta());
			dto.setInversionDeSujetoPasivo(condiciones.getInversionDeSujetoPasivo());
			// Economicas-Gastos Compraventa
			dto.setGastosPlusvalia(condiciones.getGastosPlusvalia());
			if (!Checks.esNulo(condiciones.getTipoPorCuentaPlusvalia())) {
				dto.setPlusvaliaPorCuentaDe(condiciones.getTipoPorCuentaPlusvalia().getCodigo());
			}
			dto.setGastosNotaria(condiciones.getGastosNotaria());
			if (!Checks.esNulo(condiciones.getTipoPorCuentaNotaria())) {
				dto.setNotariaPorCuentaDe(condiciones.getTipoPorCuentaNotaria().getCodigo());
			}
			dto.setGastosOtros(condiciones.getGastosOtros());
			if (!Checks.esNulo(condiciones.getTipoPorCuentaGastosOtros())) {
				dto.setGastosCompraventaOtrosPorCuentaDe(condiciones.getTipoPorCuentaGastosOtros().getCodigo());
			}

			// Economicas-Gastos Alquiler
			dto.setGastosIbi(condiciones.getGastosIbi());
			if (!Checks.esNulo(condiciones.getTipoPorCuentaIbi())) {
				dto.setIbiPorCuentaDe(condiciones.getTipoPorCuentaIbi().getCodigo());
			}
			dto.setGastosComunidad(condiciones.getGastosComunidad());
			if (!Checks.esNulo(condiciones.getTipoPorCuentaComunidadAlquiler())) {
				dto.setComunidadPorCuentaDe(condiciones.getTipoPorCuentaComunidadAlquiler().getCodigo());
			}
			dto.setGastosSuministros(condiciones.getGastosSuministros());
			if (!Checks.esNulo(condiciones.getTipoPorCuentaSuministros())) {
				dto.setSuministrosPorCuentaDe(condiciones.getTipoPorCuentaSuministros().getCodigo());
			}

			// Economicas-Cargas pendientes
			dto.setImpuestos(condiciones.getCargasImpuestos());
			if (!Checks.esNulo(condiciones.getTipoPorCuentaImpuestos())) {
				dto.setImpuestosPorCuentaDe(condiciones.getTipoPorCuentaImpuestos().getCodigo());
			}
			dto.setComunidades(condiciones.getCargasComunidad());
			if (!Checks.esNulo(condiciones.getTipoPorCuentaComunidad())) {
				dto.setComunidadesPorCuentaDe(condiciones.getTipoPorCuentaComunidad().getCodigo());
			}
			dto.setCargasOtros(condiciones.getCargasOtros());
			if (!Checks.esNulo(condiciones.getTipoPorCuentaCargasOtros())) {
				dto.setCargasPendientesOtrosPorCuentaDe(condiciones.getTipoPorCuentaCargasOtros().getCodigo());
			}

			// Juridicas-situacion del activo
			if (!Checks.esNulo(condiciones.getSujetoTanteoRetracto())) {
				dto.setSujetoTramiteTanteo(condiciones.getSujetoTanteoRetracto() == 1);
			}
			dto.setEstadoTramite(condiciones.getEstadoTramite());

			// Juridicas-Requerimientos del comprador
			if (!Checks.esNulo(condiciones.getEstadoTitulo())) {
				dto.setEstadoTituloCodigo(condiciones.getEstadoTitulo().getCodigo());
			}
			dto.setPosesionInicial((condiciones.getPosesionInicial()));
			if (!Checks.esNulo(condiciones.getSituacionPosesoria())) {
				dto.setSituacionPosesoriaCodigo(condiciones.getSituacionPosesoria().getCodigo());
			}

			dto.setRenunciaSaneamientoEviccion(condiciones.getRenunciaSaneamientoEviccion());
			dto.setRenunciaSaneamientoVicios(condiciones.getRenunciaSaneamientoVicios());

			// Condicionantes administrativos
			dto.setProcedeDescalificacion(condiciones.getProcedeDescalificacion());
			if (!Checks.esNulo(condiciones.getTipoPorCuentaDescalificacion())) {
				dto.setProcedeDescalificacionPorCuentaDe(condiciones.getTipoPorCuentaDescalificacion().getCodigo());
			}
			dto.setLicencia(condiciones.getLicencia());
			if (!Checks.esNulo(condiciones.getTipoPorCuentaLicencia())) {
				dto.setLicenciaPorCuentaDe(condiciones.getTipoPorCuentaLicencia().getCodigo());
			}
		}

		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveCondicionesExpediente(DtoCondiciones dto, Long idExpediente) {
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		CondicionanteExpediente condiciones = expedienteComercial.getCondicionante();

		if (!Checks.esNulo(condiciones)) {
			condiciones = dtoCondicionantestoCondicionante(condiciones, dto);
			expedienteComercial.setCondicionante(condiciones);

		} else {
			condiciones = new CondicionanteExpediente();
			condiciones.setExpediente(expedienteComercial);
			condiciones = dtoCondicionantestoCondicionante(condiciones, dto);
			expedienteComercial.setCondicionante(condiciones);
		}

		genericDao.save(CondicionanteExpediente.class, condiciones);

		createReservaExpediente(expedienteComercial);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public CondicionesActivo crearCondicionesActivoExpediente(Activo activo, ExpedienteComercial expediente) {
		// Como este método es para la creación del expediente crea directamente las condiciones, no busca si ya existen condiciones del Expediente-Activo.
		CondicionesActivo condicionesActivo = new CondicionesActivo();
		condicionesActivo.setActivo(activo);
		condicionesActivo.setExpediente(expediente);
		condicionesActivo.setAuditoria(Auditoria.getNewInstance());

		// Activos de Cajamar, deben copiar las condiciones informadas del activo en las condiciones al comprador.
		if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getCartera()) && DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())) {
			if (activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getFechaTomaPosesion() != null) {
				condicionesActivo.setPosesionInicial(1);

			} else {
				condicionesActivo.setPosesionInicial(0);
			}

			if (activo.getTitulo() != null && activo.getTitulo().getEstado() != null) {
				condicionesActivo.setEstadoTitulo(activo.getTitulo().getEstado());
			}

			if (activo.getSituacionPosesoria() != null) {
				if (activo.getSituacionPosesoria().getOcupado() != null && activo.getSituacionPosesoria().getOcupado().equals(0)) {
					DDSituacionesPosesoria situacionPosesoriaLibre = (DDSituacionesPosesoria) utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionesPosesoria.class, DDSituacionesPosesoria
					.SITUACION_POSESORIA_LIBRE);
					condicionesActivo.setSituacionPosesoria(situacionPosesoriaLibre);

				} else if (activo.getSituacionPosesoria().getOcupado() != null && activo.getSituacionPosesoria().getOcupado().equals(1) && activo.getSituacionPosesoria()
				.getConTitulo() != null && activo.getSituacionPosesoria().getConTitulo().equals(1)) {
					DDSituacionesPosesoria situacionPosesoriaOcupadoTitulo = (DDSituacionesPosesoria) utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionesPosesoria.class,
					DDSituacionesPosesoria.SITUACION_POSESORIA_OCUPADO_CON_TITULO);
					condicionesActivo.setSituacionPosesoria(situacionPosesoriaOcupadoTitulo);

				} else if (activo.getSituacionPosesoria().getOcupado() != null && activo.getSituacionPosesoria().getOcupado().equals(1) && activo.getSituacionPosesoria()
				.getConTitulo() != null && activo.getSituacionPosesoria().getConTitulo().equals(0)) {
					DDSituacionesPosesoria situacionPosesoriaOcupadoSinTitulo = (DDSituacionesPosesoria) utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionesPosesoria.class,
					DDSituacionesPosesoria.SITUACION_POSESORIA_OCUPADO_SIN_TITULO);
					condicionesActivo.setSituacionPosesoria(situacionPosesoriaOcupadoSinTitulo);
				}
			}
		}

		genericDao.save(CondicionesActivo.class, condicionesActivo);

		return condicionesActivo;
	}

	@Override
	@Transactional(readOnly = false)
	public Reserva createReservaExpediente(ExpedienteComercial expediente) {
		CondicionanteExpediente condiciones = expediente.getCondicionante();
		Reserva reserva = expediente.getReserva();

		if (!Checks.esNulo(condiciones.getSolicitaReserva()) && Checks.esNulo(reserva)) {
			if (condiciones.getSolicitaReserva() == 1) {
				reserva = new Reserva();
				DDEstadosReserva estadoReserva = (DDEstadosReserva) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosReserva.class, DDEstadosReserva.CODIGO_PENDIENTE_FIRMA);
				reserva.setEstadoReserva(estadoReserva);
				reserva.setExpediente(expediente);
				reserva.setNumReserva(reservaDao.getNextNumReservaRem());
				reserva.setAuditoria(Auditoria.getNewInstance());
			}
		}

		if (!Checks.esNulo(reserva)) genericDao.save(Reserva.class, reserva);

		// Actualiza la disponibilidad comercial del activo
		ofertaApi.updateStateDispComercialActivosByOferta(expediente.getOferta());

		return reserva;
	}

	/**
	 * Este método inyecta los datos del dto hacia la entidad CondicionanteExpediente. Convierte códigos a entidades si es necesario.
	 *
	 * @param condiciones: entidad a la que inyectar los datos.
	 * @param dto: objeto del que se obtienen los datos.
	 * @return Devuelve una entidad CondicionanteExpediente rellena con los datos del dto.
	 */
	private CondicionanteExpediente dtoCondicionantestoCondicionante(CondicionanteExpediente condiciones, DtoCondiciones dto) {
		try {
			beanUtilNotNull.copyProperties(condiciones, dto);

			if (!Checks.esNulo(dto.getEstadosFinanciacion())) {
				DDEstadoFinanciacion estadoFinanciacion = (DDEstadoFinanciacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoFinanciacion.class, dto.getEstadosFinanciacion());
				condiciones.setEstadoFinanciacion(estadoFinanciacion);
			}
			// Reserva
			if (dto.getTipoCalculo() != null) {
				DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCalculo.class, dto.getTipoCalculo());
				if (!Checks.esNulo(tipoCalculo)) {
					condiciones.setTipoCalculoReserva(tipoCalculo);
					if (DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO.equals(tipoCalculo.getCodigo())) {
						condiciones.setPorcentajeReserva(null);
					}

				} else {
					condiciones.setTipoCalculoReserva(null);
					condiciones.setPorcentajeReserva(null);
					condiciones.setImporteReserva(null);
					condiciones.setPlazoFirmaReserva(null);
				}
			}

			// Fiscales
			if (!Checks.esNulo(dto.getTipoImpuestoCodigo())) {
				DDTiposImpuesto tipoImpuesto = (DDTiposImpuesto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposImpuesto.class, dto.getTipoImpuestoCodigo());
				condiciones.setTipoImpuesto(tipoImpuesto);
			}

			if (!Checks.esNulo(dto.getReservaConImpuesto())) {
				if (!dto.getReservaConImpuesto()) {
					condiciones.setReservaConImpuesto(0);
				} else {
					condiciones.setReservaConImpuesto(1);
				}
			}

			if (!Checks.esNulo(dto.getRenunciaExencion()) || !Checks.esNulo(dto.getReservaConImpuesto()) || !Checks.esNulo(dto.getTipoImpuestoCodigo()) || !Checks.esNulo(dto.getTipoAplicable())) {
				// Si se cambia algún dato del apartado Fiscales.
				ofertaApi.resetPBC(condiciones.getExpediente(), false);
			}

			if (!Checks.esNulo(dto.getOperacionExenta())) {
				condiciones.setOperacionExenta(dto.getOperacionExenta());
			}

			if (!Checks.esNulo(dto.getInversionDeSujetoPasivo())) {
				condiciones.setInversionDeSujetoPasivo(dto.getInversionDeSujetoPasivo());
			}

			// Gastos CompraVenta
			if (!Checks.esNulo(dto.getPlusvaliaPorCuentaDe()) || "".equals(dto.getPlusvaliaPorCuentaDe())) {
				if ("".equals(dto.getPlusvaliaPorCuentaDe())) {
					condiciones.setGastosPlusvalia(null);
				}

				DDTiposPorCuenta tipoPorCuentaPlusvalia = (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getPlusvaliaPorCuentaDe());
				condiciones.setTipoPorCuentaPlusvalia(tipoPorCuentaPlusvalia);
			}

			if (!Checks.esNulo(dto.getNotariaPorCuentaDe()) || "".equals(dto.getNotariaPorCuentaDe())) {
				if ("".equals(dto.getNotariaPorCuentaDe())) {
					condiciones.setGastosNotaria(null);
				}

				DDTiposPorCuenta tipoPorCuentaNotaria = (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getNotariaPorCuentaDe());
				condiciones.setTipoPorCuentaNotaria(tipoPorCuentaNotaria);
			}

			if (!Checks.esNulo(dto.getGastosCompraventaOtrosPorCuentaDe()) || "".equals(dto.getGastosCompraventaOtrosPorCuentaDe())) {
				if ("".equals(dto.getGastosCompraventaOtrosPorCuentaDe())) {
					condiciones.setGastosOtros(null);
				}

				DDTiposPorCuenta tipoPorCuentaGCVOtros = (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getGastosCompraventaOtrosPorCuentaDe());
				condiciones.setTipoPorCuentaGastosOtros(tipoPorCuentaGCVOtros);
			}

			// Gastos Alquiler
			if (!Checks.esNulo(dto.getIbiPorCuentaDe()) || "".equals(dto.getIbiPorCuentaDe())) {
				if ("".equals(dto.getIbiPorCuentaDe())) {
					condiciones.setGastosIbi(null);
				}

				DDTiposPorCuenta tipoPorCuentaIbi = (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getIbiPorCuentaDe());
				condiciones.setTipoPorCuentaIbi(tipoPorCuentaIbi);
			}

			if (!Checks.esNulo(dto.getComunidadPorCuentaDe()) || "".equals(dto.getComunidadPorCuentaDe())) {
				if ("".equals(dto.getComunidadPorCuentaDe())) {
					condiciones.setGastosComunidad(null);
				}

				DDTiposPorCuenta tipoPorCuentaComunidad = (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getComunidadPorCuentaDe());
				condiciones.setTipoPorCuentaComunidadAlquiler(tipoPorCuentaComunidad);
			}

			if (!Checks.esNulo(dto.getSuministrosPorCuentaDe()) || "".equals(dto.getSuministrosPorCuentaDe())) {
				if ("".equals(dto.getSuministrosPorCuentaDe())) {
					condiciones.setGastosSuministros(null);
				}

				DDTiposPorCuenta tipoPorCuentaSuministros = (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getSuministrosPorCuentaDe());
				condiciones.setTipoPorCuentaSuministros(tipoPorCuentaSuministros);
			}

			// Cargas pendientes
			if (!Checks.esNulo(dto.getImpuestosPorCuentaDe())) {
				DDTiposPorCuenta tipoPorCuentaImpuestos = (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getImpuestosPorCuentaDe());
				condiciones.setTipoPorCuentaImpuestos(tipoPorCuentaImpuestos);
			}

			if (!Checks.esNulo(dto.getComunidadesPorCuentaDe())) {
				DDTiposPorCuenta tipoPorCuentaComunidad = (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getComunidadesPorCuentaDe());
				condiciones.setTipoPorCuentaComunidad(tipoPorCuentaComunidad);
			}

			if (!Checks.esNulo(dto.getCargasPendientesOtrosPorCuentaDe()) || "".equals(dto.getCargasPendientesOtrosPorCuentaDe())) {
				if ("".equals(dto.getCargasPendientesOtrosPorCuentaDe())) {
					condiciones.setCargasOtros(null);
				}

				DDTiposPorCuenta tipoPorCuentaCPOtros = (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getCargasPendientesOtrosPorCuentaDe());
				condiciones.setTipoPorCuentaCargasOtros(tipoPorCuentaCPOtros);
			}

			// Requerimientos del comprador
			if (!Checks.esNulo(dto.getEstadoTituloCodigo())) {
				DDEstadoTitulo estadoTitulo = (DDEstadoTitulo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoTitulo.class, dto.getEstadoTituloCodigo());
				condiciones.setEstadoTitulo(estadoTitulo);
			}

			if (dto.getSituacionPosesoriaCodigo() != null) {
				DDSituacionesPosesoria situacionPosesoria = (DDSituacionesPosesoria) utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionesPosesoria.class, dto.getSituacionPosesoriaCodigo());
				if (!Checks.esNulo(situacionPosesoria)) {
					condiciones.setSituacionPosesoria(situacionPosesoria);
				} else {
					condiciones.setSituacionPosesoria(null);
				}
			}

			// Condiciones administrativas
			if (!Checks.esNulo(dto.getProcedeDescalificacionPorCuentaDe()) || "".equals(dto.getProcedeDescalificacionPorCuentaDe())) {
				DDTiposPorCuenta tipoPorCuentaDescalificacion = (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getProcedeDescalificacionPorCuentaDe());
				condiciones.setTipoPorCuentaDescalificacion(tipoPorCuentaDescalificacion);
			}

			if (!Checks.esNulo(dto.getLicenciaPorCuentaDe()) || "".equals(dto.getLicenciaPorCuentaDe())) {
				DDTiposPorCuenta tipoPorCuentaLicencia = (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getLicenciaPorCuentaDe());
				condiciones.setTipoPorCuentaLicencia(tipoPorCuentaLicencia);
			}

			// Jurídicas-situación del activo
			if (!Checks.esNulo(dto.getSujetoTramiteTanteo())) {
				condiciones.setSujetoTanteoRetracto(dto.getSujetoTramiteTanteo() ? 1 : 0);
			}

		} catch (IllegalAccessException e) {
			logger.error("error en expedienteComercialManager", e);
			return condiciones;

		} catch (InvocationTargetException e) {
			logger.error("error en expedienteComercialManager", e);
			return condiciones;
		}

		return condiciones;
	}

	public DtoPage getPosicionamientosExpediente(Long idExpediente) {
		ExpedienteComercial expediente = findOne(idExpediente);

		List<Posicionamiento> listaPosicionamientos = expediente.getPosicionamientos();
		List<DtoPosicionamiento> posicionamientos = new ArrayList<DtoPosicionamiento>();

		Comparator<Posicionamiento> comparador = Collections.reverseOrder();
		Collections.sort(listaPosicionamientos, comparador);

		for (Posicionamiento posicionamiento : listaPosicionamientos) {
			DtoPosicionamiento posicionamientoDto = posicionamientoToDto(posicionamiento);
			posicionamientos.add(posicionamientoDto);
		}

		Collections.sort(posicionamientos);

		return new DtoPage(posicionamientos, posicionamientos.size());
	}

	/**
	 * Este método devuelve un objeto dto relleno con los datos de la entidad Posicionamiento que recibe.
	 *
	 * @param posicionamiento: entidad de la que obtener los datos para transladra al dto.
	 * @return Devuelve un objeto dto con los datos rellenos.
	 */
	private DtoPosicionamiento posicionamientoToDto(Posicionamiento posicionamiento) {
		DtoPosicionamiento posicionamientoDto = new DtoPosicionamiento();

		try {
			beanUtilNotNull.copyProperties(posicionamientoDto, posicionamiento);
			beanUtilNotNull.copyProperty(posicionamientoDto, "idPosicionamiento", posicionamiento.getId());
			beanUtilNotNull.copyProperty(posicionamientoDto, "horaAviso", posicionamiento.getFechaAviso());
			beanUtilNotNull.copyProperty(posicionamientoDto, "horaPosicionamiento", posicionamiento.getFechaPosicionamiento());
			beanUtilNotNull.copyProperty(posicionamientoDto, "fechaAlta", posicionamiento.getAuditoria().getFechaCrear());
			beanUtilNotNull.copyProperty(posicionamientoDto, "fechaFinPosicionamiento", posicionamiento.getFechaFinPosicionamiento());

			if (!Checks.esNulo(posicionamiento.getNotario())) beanUtilNotNull.copyProperty(posicionamientoDto, "idProveedorNotario", posicionamiento.getNotario().getId());

		} catch (IllegalAccessException e) {
			logger.error("error en expedienteComercialManager", e);

		} catch (InvocationTargetException e) {
			logger.error("error en expedienteComercialManager", e);
		}

		return posicionamientoDto;
	}

	/**
	 * Este método devuelve una entidad Posicionamiento rellena con los datos del objeto dto que recibe.
	 *
	 * @param dto: objeto dto del que obtener los datos.
	 * @param posicionamiento: entidad a rellenar con los datos del dto.
	 * @return Devuelve una entidad Posicionamiento con los datos rellenos.
	 */
	private Posicionamiento dtoToPosicionamiento(DtoPosicionamiento dto, Posicionamiento posicionamiento) {
		try {
			beanUtilNotNull.copyProperty(posicionamiento, "motivoAplazamiento", dto.getMotivoAplazamiento());
			beanUtilNotNull.copyProperty(posicionamiento, "fechaAviso", dto.getFechaHoraAviso());
			beanUtilNotNull.copyProperty(posicionamiento, "fechaPosicionamiento", dto.getFechaHoraPosicionamiento());

		} catch (IllegalAccessException e) {
			logger.error("Error en ExpedienteComercialManager", e);


		} catch (InvocationTargetException e) {
			logger.error("Error en ExpedienteComercialManager", e);
		}

		if (!Checks.esNulo(dto.getIdProveedorNotario())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdProveedorNotario());
			ActivoProveedor notario = genericDao.get(ActivoProveedor.class, filtro);
			posicionamiento.setNotario(notario);
		}

		posicionamiento.setMotivoAplazamiento(dto.getMotivoAplazamiento());

		return posicionamiento;
	}

	public DtoPage getComparecientesExpediente(Long idExpediente) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		List<ComparecienteVendedor> listaComparecientes = genericDao.getList(ComparecienteVendedor.class, filtro);

		List<DtoComparecienteVendedor> comparecientes = new ArrayList<DtoComparecienteVendedor>();

		for (ComparecienteVendedor compareciente : listaComparecientes) {
			DtoComparecienteVendedor comparecienteDto = comparecienteToDto(compareciente);
			comparecientes.add(comparecienteDto);
		}

		return new DtoPage(comparecientes, comparecientes.size());
	}

	/**
	 * Este método devuelve un objeto dto relleno con los datos de la entidad ComparecienteVendedor que recibe.
	 *
	 * @param compareciente: entidad de la que obtener los datos para rellenar el dto.
	 * @return Devuelve un objeto dto relleno.
	 */
	private DtoComparecienteVendedor comparecienteToDto(ComparecienteVendedor compareciente) {
		DtoComparecienteVendedor comparecienteDto = new DtoComparecienteVendedor();
		comparecienteDto.setNombre(compareciente.getNombre());
		comparecienteDto.setDireccion((compareciente.getDireccion()));
		comparecienteDto.setTelefono(compareciente.getEmail());
		comparecienteDto.setEmail((compareciente.getEmail()));
		comparecienteDto.setTipoCompareciente(compareciente.getTipoCompareciente().getDescripcion());

		return comparecienteDto;
	}

	public DtoPage getSubsanacionesExpediente(Long idExpediente) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		List<Subsanaciones> listaSubsanaciones = genericDao.getList(Subsanaciones.class, filtro);

		List<DtoSubsanacion> subsanaciones = new ArrayList<DtoSubsanacion>();

		for (Subsanaciones subsanacion : listaSubsanaciones) {
			DtoSubsanacion subsanacionDto = subsanacionToDto(subsanacion);
			subsanaciones.add(subsanacionDto);
		}

		return new DtoPage(subsanaciones, subsanaciones.size());
	}

	/**
	 * Este método devuelve un objeto dto con los datos rellenos de la entidad Subsanaciones que recibe.
	 *
	 * @param subsanacion: entidad de la que obtener los datos.
	 * @return Devuelve un objeto dto con los datos rellenos.
	 */
	private DtoSubsanacion subsanacionToDto(Subsanaciones subsanacion) {
		DtoSubsanacion subsanacionDto = new DtoSubsanacion();
		subsanacionDto.setFechaPeticion(subsanacion.getFechaPeticion());
		subsanacionDto.setPeticionario(subsanacion.getPeticionario());
		subsanacionDto.setMotivo(subsanacion.getMotivo());
		subsanacionDto.setEstado(subsanacion.getEstado().getDescripcion());
		subsanacionDto.setGastosSubsanacion(subsanacion.getGastosSubsanacion());
		subsanacionDto.setGastosInscripcion(subsanacion.getGastosInscripcion());

		return subsanacionDto;
	}

	/**
	 * Este método devuelve un objeto dto con los datos rellenos de la entidad ExpedienteComercial que recibe.
	 *
	 * @param expediente: entidad de la que obtener los datos.
	 * @return Devuelve un objeto relleno con datos.
	 */
	private DtoFormalizacionResolucion expedienteToDtoFormalizacion(ExpedienteComercial expediente) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId());
		List<Formalizacion> listaResolucionFormalizacion = genericDao.getList(Formalizacion.class, filtro);

		DtoFormalizacionResolucion formalizacionDto = new DtoFormalizacionResolucion();

		// Un expediente de venta solo puede tener una resolución, en el extraño caso que tenga más de una elegimos la primera.
		if (listaResolucionFormalizacion.size() > 0) {
			formalizacionDto = formalizacionToDto(listaResolucionFormalizacion.get(0));
		}

		// Comprobar si se habilita el botón de 'generación hoja de datos'.
		boolean permitirGenerarHoja = true;
		// Se permitie hoja de datos si el expediente está bloqueado.
		if (expediente.getBloqueado() == null || expediente.getBloqueado().equals(0)) {
			permitirGenerarHoja = false;
		}

		formalizacionDto.setGeneracionHojaDatos(permitirGenerarHoja);

		return formalizacionDto;
	}

	/**
	 * Este método devuelve un objeto dto con los datos rellenos de la entidad Formalizacion que recibe.
	 *
	 * @param formalizacion: entidad de la que obtener los datos.
	 * @return Devuelve un objeto dto con los datos rellenos.
	 */
	private DtoFormalizacionResolucion formalizacionToDto(Formalizacion formalizacion) {
		DtoFormalizacionResolucion resolucionDto = new DtoFormalizacionResolucion();
		resolucionDto.setPeticionario(formalizacion.getPeticionario());
		resolucionDto.setMotivoResolucion(formalizacion.getMotivoResolucion());
		resolucionDto.setGastosCargo(formalizacion.getGastosCargo());
		resolucionDto.setFormaPago(formalizacion.getFormaPago());
		resolucionDto.setFechaPeticion(formalizacion.getFechaPeticion());
		resolucionDto.setFechaResolucion(formalizacion.getFechaResolucion());
		resolucionDto.setImporte(formalizacion.getImporte());
		resolucionDto.setFechaPago(formalizacion.getFechaPago());
		this.rellenarDatosVentaFormalizacion(formalizacion, resolucionDto);

		return resolucionDto;
	}

	/**
	 * Este método rellena los datos del objeto dto DtoFormalizacionResolucion que recibe con los datos de las tareas obtenidas en base al trabajo de la entidad formalización.
	 * @param formalizacion: entidad de la que obtener el expediente y de ahí el trabajo y por último las tareas de los trámites del trabajo.
	 * @param resolucionDto: objeto dto al que rellenar con los datos de las tareas.
	 */
	private void rellenarDatosVentaFormalizacion(Formalizacion formalizacion, DtoFormalizacionResolucion resolucionDto) {
		List<ActivoTramite> listaTramites = tramiteDao.getTramitesByTipoAndTrabajo(formalizacion.getExpediente().getTrabajo().getId(), ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA);

		if (!Checks.estaVacio(listaTramites)) {
			List<TareaExterna> listaTareas = activoTareaExternaApi.getTareasByIdTramite(listaTramites.get(0).getId());
			TareaExterna tex = null;

			for (TareaExterna tarea : listaTareas) {
				if (tarea.getTareaProcedimiento().getCodigo().equals("T013_FirmaPropietario")) {
					tex = tarea;
					break;
				}
			}

			if (!Checks.esNulo(tex)) {
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

				try {
					String fechaFirma = activoTramiteApi.getTareaValorByNombre(tex.getValores(), "fechaFirma");
					if(!Checks.esNulo(fechaFirma)){
						resolucionDto.setFechaVenta(df.parse(fechaFirma));
					}

				} catch (ParseException e) {
					logger.error("error en expedienteComercialManager", e);
				}

				resolucionDto.setNumProtocolo(activoTramiteApi.getTareaValorByNombre(tex.getValores(), "numProtocolo"));
			}
		}
	}

	@Override
	@Transactional(readOnly = true)
	public ExpedienteComercial expedienteComercialPorOferta(Long idOferta) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", idOferta);

		return genericDao.get(ExpedienteComercial.class, filtro);
	}

	@Override
	@Transactional(readOnly = false)
	public boolean addEntregaReserva(EntregaReserva entregaReserva, Long idExpedienteComercial) {
		ExpedienteComercial expedienteComercial = findOne(idExpedienteComercial);
		Reserva reserva = expedienteComercial.getReserva();

		if (reserva == null) {
			reserva = new Reserva();
			Auditoria auditoria = Auditoria.getNewInstance();
			reserva.setExpediente(expedienteComercial);
			reserva.setNumReserva(reservaDao.getNextNumReservaRem());
			reserva.setAuditoria(auditoria);
			expedienteComercial.setReserva(reserva);
			genericDao.save(ExpedienteComercial.class, expedienteComercial);
			expedienteComercial = findOne(idExpedienteComercial);
			reserva = expedienteComercial.getReserva();
		}

		entregaReserva.setReserva(reserva);

		genericDao.save(EntregaReserva.class, entregaReserva);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateEstadoDevolucionReserva(ExpedienteComercial expedienteComercial, String codEstadoDevolucionReserva) throws Exception {
		DDEstadoDevolucion estadoDevolucionReserva = (DDEstadoDevolucion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoDevolucion.class, codEstadoDevolucionReserva);

		if (!Checks.esNulo(estadoDevolucionReserva)) {
			if (expedienteComercial.getReserva() != null) {
				expedienteComercial.getReserva().setEstadoDevolucion(estadoDevolucionReserva);
			}

		} else {
			throw new Exception("El codigo del estado de la dev no exite");
		}

		return this.update(expedienteComercial);
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateEstadoReserva(ExpedienteComercial expedienteComercial, String codEstadoReserva) throws Exception{
		if(!Checks.esNulo(codEstadoReserva)){
			DDEstadosReserva estadoReserva = (DDEstadosReserva) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosReserva.class, codEstadoReserva);
			if(!Checks.esNulo(estadoReserva)){
				if(!Checks.esNulo(expedienteComercial.getReserva())){
					expedienteComercial.getReserva().setEstadoReserva(estadoReserva);
				}
			}else{
				throw new Exception("El codigo del estado de la reserva no existe");
			}
			return this.update(expedienteComercial);
		}else{
			return this.update(expedienteComercial);
		}
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateEstadoExpedienteComercial(ExpedienteComercial expedienteComercial, String codEstadoExpedienteComercial) throws Exception {
		DDEstadosExpedienteComercial estadoExpedienteComercial = (DDEstadosExpedienteComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class,
				codEstadoExpedienteComercial);

		if (!Checks.esNulo(estadoExpedienteComercial)) {
			if (!Checks.esNulo(expedienteComercial)) {
				expedienteComercial.setEstado(estadoExpedienteComercial);
			}

		} else {
			throw new Exception("El codigo del estado del expediente comercial no existe");
		}

		return this.update(expedienteComercial);
	}

	@Transactional(readOnly = false)
	private void resetReservaEstadoPrevioResolucionExpediente(ExpedienteComercial expedienteComercial, String codigoReserva) throws Exception{
		Reserva reserva = expedienteComercial.getReserva();
		reserva.setIndicadorDevolucionReserva(null);
		reserva.setDevolucionReserva(null);
		this.updateEstadoReserva(expedienteComercial, codigoReserva);
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateExpedienteComercialEstadoPrevioResolucionExpediente(ExpedienteComercial expedienteComercial, String codigoTareaActual, String codigoTareaSalto, Boolean botonDeshacerAnulacion) throws Exception{
		if(codigoTareaSalto.equals(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA)
				&& codigoTareaActual.equals(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION)
				&& botonDeshacerAnulacion){
			this.resetReservaEstadoPrevioResolucionExpediente(expedienteComercial, null);
			this.updateEstadoExpedienteComercial(expedienteComercial, DDEstadosExpedienteComercial.EN_TRAMITACION);

			return this.update(expedienteComercial);
		}else if(codigoTareaActual.equals(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION)
				|| codigoTareaActual.equals(ComercialUserAssigantionService.CODIGO_T013_PENDIENTE_DEVOLUCION)
				|| codigoTareaActual.equals(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION)){
			this.resetReservaEstadoPrevioResolucionExpediente(expedienteComercial, DDEstadosReserva.CODIGO_FIRMADA);
			this.updateEstadoExpedienteComercial(expedienteComercial, DDEstadosExpedienteComercial.RESERVADO);

			return this.update(expedienteComercial);
		}

		return false;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean update(ExpedienteComercial expedienteComercial) {
		try {
			genericDao.update(ExpedienteComercial.class, expedienteComercial);

		} catch (Exception e) {
			logger.error("error en expedienteComercialManager", e);
			return false;
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveReserva(DtoReserva dto, Long idExpediente) {
		ExpedienteComercial expediente = findOne(idExpediente);
		Reserva reserva = expediente.getReserva();

		try {
			beanUtilNotNull.copyProperties(reserva, dto);
			if (!Checks.esNulo(dto.getTipoArrasCodigo())) {
				DDTiposArras tipoArras = (DDTiposArras) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposArras.class, dto.getTipoArrasCodigo());
				reserva.setTipoArras(tipoArras);
			}

			if (!Checks.esNulo(dto.getCodigoSucursal())) {
				String codigoCartera = "";
				if (expediente.getOferta().getActivoPrincipal().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)) codigoCartera = "2038";
				else if (expediente.getOferta().getActivoPrincipal().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CAJAMAR)) codigoCartera = "3058";
				Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "codProveedorUvem", codigoCartera + dto.getCodigoSucursal());
				expediente.getOferta().setSucursal(genericDao.get(ActivoProveedor.class, filtroProveedor));
				genericDao.save(Oferta.class, expediente.getOferta());
			}

			if(!Checks.esNulo(dto.getEstadoReservaCodigo())) {
				reserva.setEstadoReserva(genericDao.get(DDEstadosReserva.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoReservaCodigo())));
			}

			genericDao.save(Reserva.class, reserva);

		} catch (IllegalAccessException e) {
			logger.error("error en expedienteComercialManager", e);
			return false;

		} catch (InvocationTargetException e) {
			logger.error("error en expedienteComercialManager", e);
			return false;
		}

		return true;
	}

	public List<DtoGastoExpediente> getHonorariosActivoByOfertaAceptada(Oferta oferta, Activo activo) {
		List<DtoGastoExpediente> resultado = new ArrayList<DtoGastoExpediente>();
		ExpedienteComercial expediente = findOneByOferta(oferta);
		if(expediente != null && activo != null){
			resultado = getHonorarios(expediente.getId(), activo.getId());
		}		
		return resultado;
	}

	public List<DtoGastoExpediente> getHonorarios(Long idExpediente, Long idActivo) {
		List<DtoGastoExpediente> honorarios = new ArrayList<DtoGastoExpediente>();

		// TODO: filtrar por activo si lo recibimos.
		ExpedienteComercial expediente = findOne(idExpediente);

		List<GastosExpediente> gastosExpediente = expediente.getHonorarios();

		// Añadir al dto
		for (GastosExpediente gasto : gastosExpediente) {
			DtoGastoExpediente gastoExpedienteDto = new DtoGastoExpediente();

			if (!Checks.esNulo(gasto.getAccionGastos())) {
				gastoExpedienteDto.setDescripcionTipoComision(gasto.getAccionGastos().getDescripcion());
				gastoExpedienteDto.setCodigoTipoComision(gasto.getAccionGastos().getCodigo());
			}

			gastoExpedienteDto.setId(gasto.getId().toString());

			if (!Checks.esNulo(gasto.getProveedor())) {
				gastoExpedienteDto.setProveedor(gasto.getProveedor().getNombre());
				gastoExpedienteDto.setCodigoProveedorRem(gasto.getProveedor().getCodigoProveedorRem());
			}

			if (!Checks.esNulo(gasto.getTipoProveedor())) {
				gastoExpedienteDto.setTipoProveedor(gasto.getTipoProveedor().getDescripcion());
				gastoExpedienteDto.setCodigoTipoProveedor((gasto.getTipoProveedor().getCodigo()));
			}

			gastoExpedienteDto.setCodigoId((gasto.getCodigo()));

			if (!Checks.esNulo(gasto.getTipoCalculo())) {
				gastoExpedienteDto.setCodigoTipoCalculo(gasto.getTipoCalculo().getCodigo());
				gastoExpedienteDto.setTipoCalculo(gasto.getTipoCalculo().getDescripcion());
			}

			gastoExpedienteDto.setImporteCalculo(gasto.getImporteCalculo());
			gastoExpedienteDto.setHonorarios(gasto.getImporteFinal());
			gastoExpedienteDto.setObservaciones(gasto.getObservaciones());

			if (!Checks.esNulo(gasto.getActivo())) {
				gastoExpedienteDto.setIdActivo(gasto.getActivo().getId());
				gastoExpedienteDto.setNumActivo(gasto.getActivo().getNumActivo());

				for (ActivoOferta activoOferta : expediente.getOferta().getActivosOferta()) {
					if (activoOferta.getPrimaryKey().getActivo().equals(gasto.getActivo())) {
						gastoExpedienteDto.setParticipacionActivo(activoOferta.getImporteActivoOferta());
					}
				}
			}

			if (Checks.esNulo(idActivo)) {
				honorarios.add(gastoExpedienteDto);

			} else if (idActivo.equals(gastoExpedienteDto.getIdActivo())) {
				honorarios.add(gastoExpedienteDto);
			}
		}

		return honorarios;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveFichaComprador(VBusquedaDatosCompradorExpediente dto) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		Comprador comprador = genericDao.get(Comprador.class, filtro);

		try {
			if (!Checks.esNulo(comprador)) {
				boolean reiniciarPBC = false;

				comprador.setIdCompradorUrsus(dto.getNumeroClienteUrsus());
				comprador.setIdCompradorUrsusBh(dto.getNumeroClienteUrsusBh());

				if (!Checks.esNulo(dto.getCodTipoPersona())) {
					DDTiposPersona tipoPersona = (DDTiposPersona) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPersona.class, dto.getCodTipoPersona());
					comprador.setTipoPersona(tipoPersona);
				}

				// Datos de identificación
				if (!Checks.esNulo(dto.getApellidos())) {
					reiniciarPBC = true;
				}

				comprador.setApellidos(dto.getApellidos());

				if (!Checks.esNulo(dto.getCodTipoDocumento())) {
					DDTipoDocumento tipoDocumentoComprador = (DDTipoDocumento) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumento());
					comprador.setTipoDocumento(tipoDocumentoComprador);
				}

				if (!Checks.esNulo(dto.getNombreRazonSocial())) {
					reiniciarPBC = true;
				}

				comprador.setNombre(dto.getNombreRazonSocial());

				if (!Checks.esNulo(dto.getProvinciaCodigo())) {
					DDProvincia provincia = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class, dto.getProvinciaCodigo());
					comprador.setProvincia(provincia);
					reiniciarPBC = true;
				}

				if (!Checks.esNulo(dto.getMunicipioCodigo())) {
					Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
					Localidad localidad = genericDao.get(Localidad.class, filtroLocalidad);
					comprador.setLocalidad(localidad);
					reiniciarPBC = true;
				}

				if (!Checks.esNulo(dto.getCodigoPostal())) {
					reiniciarPBC = true;
				}

				comprador.setCodigoPostal(dto.getCodigoPostal());

				if (!Checks.esNulo(dto.getNumDocumento())) {
					comprador.setDocumento(dto.getNumDocumento());
					reiniciarPBC = true;
				}

				if (!Checks.esNulo(dto.getDireccion())) {
					reiniciarPBC = true;
				}

				comprador.setDireccion(dto.getDireccion());

				if (!Checks.esNulo(dto.getTelefono1())) {
					comprador.setTelefono1(dto.getTelefono1());
				}

				if (!Checks.esNulo(dto.getTelefono2())) {
					comprador.setTelefono2(dto.getTelefono2());
				}

				if (!Checks.esNulo(dto.getEmail())) {
					comprador.setEmail(dto.getEmail());
				}

				Filter filtroExpedienteComercial = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdExpedienteComercial()));
				ExpedienteComercial expedienteComercial = genericDao.get(ExpedienteComercial.class, filtroExpedienteComercial);

				for (CompradorExpediente compradorExpediente : expedienteComercial.getCompradores()) {
					if (compradorExpediente.getPrimaryKey().getComprador().getId().equals(Long.parseLong(dto.getId())) && compradorExpediente.getPrimaryKey().getExpediente().getId().equals(Long
							.parseLong(dto.getIdExpedienteComercial()))) {

						if (!Checks.esNulo(dto.getPorcentajeCompra())) {
							compradorExpediente.setPorcionCompra(dto.getPorcentajeCompra());
						}

						if (!Checks.esNulo(dto.getTitularContratacion())) {
							compradorExpediente.setTitularContratacion(dto.getTitularContratacion());

							if (dto.getTitularContratacion() == 1) {
								compradorExpediente.setTitularReserva(0);
							} else if (dto.getTitularContratacion() == 0) {
								compradorExpediente.setTitularReserva(1);
							}
						}

						// Nexos
						if (!Checks.esNulo(dto.getCodEstadoCivil())) {
							DDEstadosCiviles estadoCivil = (DDEstadosCiviles) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosCiviles.class, dto.getCodEstadoCivil());
							compradorExpediente.setEstadoCivil(estadoCivil);
							reiniciarPBC = true;
						}

						compradorExpediente.setDocumentoConyuge(dto.getDocumentoConyuge());

						if (!Checks.esNulo(dto.getRelacionAntDeudor())) {
							compradorExpediente.setRelacionAntDeudor(dto.getRelacionAntDeudor());
						}

						compradorExpediente.setRelacionHre(dto.getRelacionHre());

						if (!Checks.esNulo(dto.getCodigoRegimenMatrimonial())) {
							DDRegimenesMatrimoniales regimenMatrimonial = (DDRegimenesMatrimoniales) utilDiccionarioApi.dameValorDiccionarioByCod(DDRegimenesMatrimoniales.class, dto
									.getCodigoRegimenMatrimonial());
							compradorExpediente.setRegimenMatrimonial(regimenMatrimonial);
							reiniciarPBC = true;
						}

						if (!Checks.esNulo(dto.getAntiguoDeudor())) {
							compradorExpediente.setAntiguoDeudor(dto.getAntiguoDeudor());
						}

						// Datos representante
						if (!Checks.esNulo(dto.getCodTipoDocumentoRte())) {
							DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumentoRte());
							compradorExpediente.setTipoDocumentoRepresentante(tipoDocumento);
						}

						compradorExpediente.setNombreRepresentante(dto.getNombreRazonSocialRte());
						compradorExpediente.setApellidosRepresentante(dto.getApellidosRte());

						if (!Checks.esNulo(dto.getProvinciaRteCodigo())) {
							DDProvincia provinciaRte = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class, dto.getProvinciaRteCodigo());
							compradorExpediente.setProvinciaRepresentante(provinciaRte);
						}

						if (!Checks.esNulo(dto.getMunicipioRteCodigo())) {
							Filter filtroLocalidadRte = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioRteCodigo());
							Localidad localidadRte = (Localidad) genericDao.get(Localidad.class, filtroLocalidadRte);
							compradorExpediente.setLocalidadRepresentante(localidadRte);
						}

						compradorExpediente.setCodigoPostalRepresentante(dto.getCodigoPostalRte());
						compradorExpediente.setDocumentoRepresentante(dto.getNumDocumentoRte());
						compradorExpediente.setDireccionRepresentante(dto.getDireccionRte());
						compradorExpediente.setTelefono1Representante(dto.getTelefono1Rte());
						compradorExpediente.setTelefono2Representante(dto.getTelefono2Rte());
						compradorExpediente.setEmailRepresentante(dto.getEmailRte());

						if (!Checks.esNulo(dto.getCodigoPais())) {
							Filter filtroPais = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoPais());
							DDPaises pais = genericDao.get(DDPaises.class, filtroPais);
							compradorExpediente.setPais(pais);
						}

						if (!Checks.esNulo(dto.getCodigoPaisRte())) {
							Filter filtroPaisRte = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoPaisRte());
							DDPaises paisRte = genericDao.get(DDPaises.class, filtroPaisRte);
							compradorExpediente.setPaisRte(paisRte);
						}

						if (!Checks.esNulo(dto.getCodigoGradoPropiedad())) {
							Filter filtroGradoPropiedad = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoGradoPropiedad());
							DDTipoGradoPropiedad gradoPropiedad = genericDao.get(DDTipoGradoPropiedad.class, filtroGradoPropiedad);
							compradorExpediente.setGradoPropiedad(gradoPropiedad);
						}

						genericDao.save(Comprador.class, comprador);
						genericDao.update(CompradorExpediente.class, compradorExpediente);
					}
				}

				if (reiniciarPBC) {
					ofertaApi.resetPBC(expedienteComercial, false);
				}
			}

		} catch (NumberFormatException e) {
			logger.error("error en expedienteComercialManager", e);
			return false;
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean marcarCompradorPrincipal(Long idComprador, Long idExpedienteComercial) {
		Filter filterLista = genericDao.createFilter(FilterType.EQUALS, "primaryKey.expediente.id", idExpedienteComercial);
		List<CompradorExpediente> listaCompradores = genericDao.getList(CompradorExpediente.class, filterLista);

		for (CompradorExpediente compradorExpediente : listaCompradores) {
			if (idComprador.equals(compradorExpediente.getPrimaryKey().getComprador().getId())) {
				compradorExpediente.setTitularContratacion(1);
				genericDao.update(CompradorExpediente.class, compradorExpediente);

			} else {
				compradorExpediente.setTitularContratacion(0);
				genericDao.update(CompradorExpediente.class, compradorExpediente);

			}
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public void actualizarHonorariosPorExpediente(Long idExpediente) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		List<GastosExpediente> gastosExpediente = genericDao.getList(GastosExpediente.class, filtro);

		for (GastosExpediente gastoExpediente : gastosExpediente) {
			// Solo actualizar los importes finales si el gasto utiliza porcentajes sobre el importe de oferta o contra-oferta.
			if (DDTipoCalculo.TIPO_CALCULO_PORCENTAJE.equals(gastoExpediente.getTipoCalculo().getCodigo())) {
				Oferta oferta = gastoExpediente.getExpediente().getOferta();


				Double calculoImporteC = gastoExpediente.getImporteCalculo();
				
				Long idActivo = gastoExpediente.getActivo().getId();
				
				for(ActivoOferta activoOferta : oferta.getActivosOferta()){
					if(!Checks.esNulo(activoOferta.getImporteActivoOferta())){
						if(activoOferta.getPrimaryKey().getActivo().getId().equals(idActivo)){
							Double honorario = (activoOferta.getImporteActivoOferta() * calculoImporteC / 100);
							gastoExpediente.setImporteFinal(honorario);
						}
					}
				}

				genericDao.save(GastosExpediente.class, gastoExpediente);
			}
		}
	}

	@Transactional(readOnly = false)
	public boolean saveHonorario(DtoGastoExpediente dtoGastoExpediente) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoGastoExpediente.getId()));
		GastosExpediente gastoExpediente = genericDao.get(GastosExpediente.class, filtro);

		if (!Checks.esNulo(dtoGastoExpediente.getCodigoTipoComision())) {
			DDAccionGastos acciongasto = (DDAccionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDAccionGastos.class, dtoGastoExpediente.getCodigoTipoComision());
			if (!Checks.esNulo(acciongasto)) {
				gastoExpediente.setAccionGastos(acciongasto);
			}
		}

		if (!Checks.esNulo(dtoGastoExpediente.getCodigoTipoCalculo())) {
			DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCalculo.class, dtoGastoExpediente.getCodigoTipoCalculo());
			gastoExpediente.setTipoCalculo(tipoCalculo);
		}

		DDTipoProveedorHonorario tipoProveedor = null;

		if (!Checks.esNulo(dtoGastoExpediente.getCodigoTipoProveedor())) {
			Filter filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoGastoExpediente.getCodigoTipoProveedor());
			tipoProveedor = genericDao.get(DDTipoProveedorHonorario.class, filtroTipoProveedor);
		}

		if (!Checks.esNulo(tipoProveedor)) {
			if (DDTipoProveedorHonorario.CODIGO_OFICINA_BANKIA.equals(tipoProveedor.getCodigo()) || DDTipoProveedorHonorario.CODIGO_OFICINA_CAJAMAR.equals(tipoProveedor.getCodigo())) {
				// Si es de estos tipos no puede haber proveedor.
				gastoExpediente.setProveedor(null);
				dtoGastoExpediente.setIdProveedor(null);
			}
			gastoExpediente.setTipoProveedor(tipoProveedor);
		}

		if (!Checks.esNulo(dtoGastoExpediente.getCodigoProveedorRem())) {
			Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", dtoGastoExpediente.getCodigoProveedorRem());
			ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroProveedor);

			if (Checks.esNulo(proveedor) || !proveedor.getTipoProveedor().getCodigo().equals(dtoGastoExpediente.getCodigoTipoProveedor())) {
				throw new JsonViewerException(ExpedienteComercialManager.PROVEDOR_NO_EXISTE_O_DISTINTO_TIPO);
			}

			gastoExpediente.setProveedor(proveedor);
		}

		gastoExpediente.setImporteCalculo(dtoGastoExpediente.getImporteCalculo());
		gastoExpediente.setImporteFinal(dtoGastoExpediente.getHonorarios());
		gastoExpediente.setObservaciones(dtoGastoExpediente.getObservaciones());

		if (!Checks.esNulo(dtoGastoExpediente.getIdActivo())) {
			Activo activo = null;

			for (ActivoOferta activoOferta : gastoExpediente.getExpediente().getOferta().getActivosOferta()) {
				if (activoOferta.getPrimaryKey().getActivo().getId().equals(dtoGastoExpediente.getIdActivo())) {
					activo = activoOferta.getPrimaryKey().getActivo();
				}
			}

			gastoExpediente.setActivo(activo);
		}

		genericDao.save(GastosExpediente.class, gastoExpediente);

		return true;
	}

	@Transactional(readOnly = true)
	public DDEstadosExpedienteComercial getDDEstadosExpedienteComercialByCodigo(String codigo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);

		return genericDao.get(DDEstadosExpedienteComercial.class, filtro);
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveFichaExpediente(DtoFichaExpediente dto, Long idExpediente) {
		ExpedienteComercial expedienteComercial = findOne(idExpediente);

		if (!Checks.esNulo(expedienteComercial)) {
			boolean actualizarEstadoPublicacion = false;

			try {
				beanUtilNotNull.copyProperties(expedienteComercial, dto);

				if(!Checks.esNulo(dto.getCodigoEstado())) {
					expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoEstado())));
				}

				if (Checks.esNulo(dto.getEstadoPbc()) || !Checks.esNulo(dto.getConflictoIntereses()) || !Checks.esNulo(dto.getRiesgoReputacional())) {
					ofertaApi.resetPBC(expedienteComercial, false);
				}

				if (!Checks.esNulo(dto.getCodMotivoAnulacion())) {
					DDMotivoAnulacionExpediente motivoAnulacionExpediente = (DDMotivoAnulacionExpediente) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoAnulacionExpediente.class, dto
					.getCodMotivoAnulacion());
					expedienteComercial.setMotivoAnulacion(motivoAnulacionExpediente);
					actualizarEstadoPublicacion = true;
				}

				if (!Checks.esNulo(expedienteComercial.getReserva())) {
					if (!Checks.esNulo(dto.getEstadoDevolucionCodigo())) {
						DDEstadoDevolucion estadoDevolucion = (DDEstadoDevolucion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoDevolucion.class, dto.getEstadoDevolucionCodigo());
						expedienteComercial.getReserva().setEstadoDevolucion(estadoDevolucion);

						if (dto.getEstadoDevolucionCodigo().equals(DDEstadoDevolucion.ESTADO_DEVUELTA)) {
							if(Checks.esNulo(dto.getCodigoEstado())) {
								expedienteComercial.setEstado(
										(DDEstadosExpedienteComercial) utilDiccionarioApi.dameValorDiccionarioByCod(
												DDEstadosExpedienteComercial.class, DDEstadosExpedienteComercial.ANULADO));
							}
							expedienteComercial.setFechaVenta(null);
							expedienteComercial.getReserva().setEstadoReserva((DDEstadosReserva) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosReserva.class, DDEstadosReserva
							.CODIGO_RESUELTA_DEVUELTA));
							expedienteComercial.getOferta().setEstadoOferta((DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_RECHAZADA));
						}
						// Descongelamos el resto de ofertas del activo.
						ofertaApi.descongelarOfertas(expedienteComercial);
						actualizarEstadoPublicacion = true;
					}

					if (!Checks.esNulo(dto.getFechaReserva())) {
						expedienteComercial.getReserva().setFechaFirma(dto.getFechaReserva());
					}
				}

				if (!Checks.esNulo(expedienteComercial.getUltimoPosicionamiento()) && !Checks.esNulo(dto.getFechaPosicionamiento())) {
					expedienteComercial.getUltimoPosicionamiento().setFechaPosicionamiento(dto.getFechaPosicionamiento());
				}

				if(!Checks.esNulo(dto.getCodigoComiteSancionador())){
					expedienteComercial.setComiteSancion((DDComiteSancion) utilDiccionarioApi.dameValorDiccionarioByCod(DDComiteSancion.class, dto.getCodigoComiteSancionador()));
				}

				if (expedienteComercial.getId() != null) {
					genericDao.update(ExpedienteComercial.class, expedienteComercial);

				} else {
					genericDao.save(Reserva.class, expedienteComercial.getReserva());
					genericDao.save(Oferta.class, expedienteComercial.getOferta());
					genericDao.save(ExpedienteComercial.class, expedienteComercial);
				}

				if (actualizarEstadoPublicacion) {
					for (ActivoOferta activoOferta : expedienteComercial.getOferta().getActivosOferta()) {
						activoAdapter.actualizarEstadoPublicacionActivo(activoOferta.getPrimaryKey().getActivo().getId());
					}
				}

			} catch (IllegalAccessException e) {
				logger.error("error en expedienteComercialManager", e);

			} catch (InvocationTargetException e) {
				logger.error("error en expedienteComercialManager", e);

			} catch (Exception e) {
				logger.error("error en expedienteComercialManager", e);
			}
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveEntregaReserva(DtoEntregaReserva dto, Long idExpediente) {
		ExpedienteComercial expedienteComercial = findOne(idExpediente);

		try {
			if (!Checks.esNulo(expedienteComercial)) {
				EntregaReserva entrega = new EntregaReserva();
				beanUtilNotNull.copyProperties(entrega, dto);
				beanUtilNotNull.copyProperty(entrega, "fechaEntrega", dto.getFechaCobro());
				entrega.setReserva(expedienteComercial.getReserva());

				expedienteComercial.getReserva().getEntregas().add(entrega);

				genericDao.save(EntregaReserva.class, entrega);

				genericDao.update(ExpedienteComercial.class, expedienteComercial);
			}

		} catch (IllegalAccessException e) {
			logger.error("error en expedienteComercialManager", e);

		} catch (InvocationTargetException e) {
			logger.error("error en expedienteComercialManager", e);
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateEntregaReserva(DtoEntregaReserva dto, Long idExpediente) {
		ExpedienteComercial expedienteComercial = findOne(idExpediente);

		for (EntregaReserva entrega : expedienteComercial.getReserva().getEntregas()) {
			try {
				if (entrega.getId().equals(dto.getIdEntrega())) {
					beanUtilNotNull.copyProperties(entrega, dto);
					if (!Checks.esNulo(dto.getFechaCobro())) {
						entrega.setFechaEntrega(dto.getFechaCobro());
					}

					if ("".equals(dto.getFechaCobro())) {
						entrega.setFechaEntrega(null);
					}

					genericDao.update(ExpedienteComercial.class, expedienteComercial);
				}

			} catch (IllegalAccessException e) {
				logger.error("error en expedienteComercialManager", e);
				return false;

			} catch (InvocationTargetException e) {
				logger.error("error en expedienteComercialManager", e);
				return false;
			}
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteEntregaReserva(Long idEntrega) {
		genericDao.deleteById(EntregaReserva.class, idEntrega);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createComprador(VBusquedaDatosCompradorExpediente dto, Long idExpediente) {
		Filter filtroComprador = genericDao.createFilter(FilterType.EQUALS, "documento", dto.getNumDocumento());
		Comprador compradorBusqueda = genericDao.get(Comprador.class, filtroComprador);

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idExpediente);
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);
		CompradorExpediente compradorExpediente = new CompradorExpediente();
		compradorExpediente.setBorrado(false);

		if (!Checks.esNulo(compradorBusqueda)) {
			CompradorExpedientePk pk = new CompradorExpedientePk();
			pk.setComprador(compradorBusqueda);
			pk.setExpediente(expediente);
			compradorExpediente.setPrimaryKey(pk);
			compradorExpediente.setPorcionCompra(dto.getPorcentajeCompra());

			if (!Checks.esNulo(dto.getCodigoRegimenMatrimonial())) {
				Filter filtroRegimenMatrimonial = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoRegimenMatrimonial());
				DDRegimenesMatrimoniales regimenMatrimonial = genericDao.get(DDRegimenesMatrimoniales.class, filtroRegimenMatrimonial);
				if (!Checks.esNulo(regimenMatrimonial)) compradorExpediente.setRegimenMatrimonial(regimenMatrimonial);
			}

			if (!Checks.esNulo(dto.getCodEstadoCivil())) {
				Filter filtroEstadoCivil = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodEstadoCivil());
				DDEstadosCiviles estadoCivil = genericDao.get(DDEstadosCiviles.class, filtroEstadoCivil);
				if (!Checks.esNulo(estadoCivil)) compradorExpediente.setEstadoCivil(estadoCivil);
			}

			if (!Checks.esNulo(dto.getTitularContratacion())) {
				compradorExpediente.setTitularContratacion(dto.getTitularContratacion());

			} else {
				compradorExpediente.setTitularContratacion(0);
			}

			compradorExpediente.setBorrado(false);

			if (!Checks.esNulo(dto.getCodTipoPersona())) {
				DDTiposPersona tipoPersona = (DDTiposPersona) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPersona.class, dto.getCodTipoPersona());
				compradorExpediente.getPrimaryKey().getComprador().setTipoPersona(tipoPersona);
			}

			if (!Checks.esNulo(dto.getNumeroClienteUrsus())) {
				compradorBusqueda.setIdCompradorUrsus(dto.getNumeroClienteUrsus());
			}

			if (!Checks.esNulo(dto.getNumeroClienteUrsusBh())) {
				compradorBusqueda.setIdCompradorUrsusBh(dto.getNumeroClienteUrsusBh());
			}

			expediente.getCompradores().add(compradorExpediente);



			genericDao.save(ExpedienteComercial.class, expediente);

			ofertaApi.resetPBC(expediente, true);

			return true;
		} else {

			try {
				Comprador comprador = new Comprador();

				if (!Checks.esNulo(dto.getNumeroClienteUrsus())) {
					comprador.setIdCompradorUrsus(dto.getNumeroClienteUrsus());
				}

				if (!Checks.esNulo(dto.getNumeroClienteUrsusBh())) {
					comprador.setIdCompradorUrsusBh(dto.getNumeroClienteUrsusBh());
				}

				if (!Checks.esNulo(dto.getCodTipoPersona())) {
					DDTiposPersona tipoPersona = (DDTiposPersona) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPersona.class, dto.getCodTipoPersona());
					comprador.setTipoPersona(tipoPersona);
				}

				// Datos de identificación
				if (!Checks.esNulo(dto.getApellidos())) {
					comprador.setApellidos(dto.getApellidos());
				}

				if (!Checks.esNulo(dto.getCodTipoDocumento())) {
					DDTipoDocumento tipoDocumentoComprador = (DDTipoDocumento) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumento());
					comprador.setTipoDocumento(tipoDocumentoComprador);
				}

				if (!Checks.esNulo(dto.getNombreRazonSocial())) {
					comprador.setNombre(dto.getNombreRazonSocial());
				}

				if (!Checks.esNulo(dto.getProvinciaCodigo())) {
					DDProvincia provincia = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class, dto.getProvinciaCodigo());
					comprador.setProvincia(provincia);
				}

				if (!Checks.esNulo(dto.getMunicipioCodigo())) {
					Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
					Localidad localidad = genericDao.get(Localidad.class, filtroLocalidad);
					comprador.setLocalidad(localidad);
				}

				if (!Checks.esNulo(dto.getCodigoPostal())) {
					comprador.setCodigoPostal(dto.getCodigoPostal());
				}

				if (!Checks.esNulo(dto.getNumDocumento())) {
					comprador.setDocumento(dto.getNumDocumento());
				}

				if (!Checks.esNulo(dto.getDireccion())) {
					comprador.setDireccion(dto.getDireccion());
				}

				if (!Checks.esNulo(dto.getTelefono1())) {
					comprador.setTelefono1(dto.getTelefono1());
				}

				if (!Checks.esNulo(dto.getTelefono2())) {
					comprador.setTelefono2(dto.getTelefono2());
				}

				if (!Checks.esNulo(dto.getEmail())) {
					comprador.setEmail(dto.getEmail());
				}

				if (!Checks.esNulo(dto.getTitularReserva())) {
					compradorExpediente.setTitularReserva(dto.getTitularReserva());
				}

				compradorExpediente.setPorcionCompra(dto.getPorcentajeCompra());

				if (!Checks.esNulo(dto.getTitularContratacion())) {
					compradorExpediente.setTitularContratacion(dto.getTitularContratacion());

				} else {
					compradorExpediente.setTitularContratacion(0);
				}

				// Nexos
				if (!Checks.esNulo(dto.getCodEstadoCivil())) {
					DDEstadosCiviles estadoCivil = (DDEstadosCiviles) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosCiviles.class, dto.getCodEstadoCivil());
					compradorExpediente.setEstadoCivil(estadoCivil);
				}

				if (!Checks.esNulo(dto.getDocumentoConyuge())) {
					compradorExpediente.setDocumentoConyuge(dto.getDocumentoConyuge());
				}

				if (!Checks.esNulo(dto.getRelacionAntDeudor())) {
					compradorExpediente.setRelacionAntDeudor(dto.getRelacionAntDeudor());
				}

				if (!Checks.esNulo(dto.getRelacionHre())) {
					compradorExpediente.setRelacionHre(dto.getRelacionHre());
				}

				if (!Checks.esNulo(dto.getCodigoRegimenMatrimonial())) {
					DDRegimenesMatrimoniales regimenMatrimonial = (DDRegimenesMatrimoniales) utilDiccionarioApi.dameValorDiccionarioByCod(DDRegimenesMatrimoniales.class, dto
					.getCodigoRegimenMatrimonial());
					compradorExpediente.setRegimenMatrimonial(regimenMatrimonial);
				}

				if (!Checks.esNulo(dto.getAntiguoDeudor())) {
					compradorExpediente.setAntiguoDeudor(dto.getAntiguoDeudor());
				}

				// Datos representante
				if (!Checks.esNulo(dto.getCodTipoDocumentoRte())) {
					DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumentoRte());
					compradorExpediente.setTipoDocumentoRepresentante(tipoDocumento);
				}

				if (!Checks.esNulo(dto.getNombreRazonSocialRte())) {
					compradorExpediente.setNombreRepresentante(dto.getNombreRazonSocialRte());
				}

				if (!Checks.esNulo(dto.getApellidosRte())) {
					compradorExpediente.setApellidosRepresentante(dto.getApellidosRte());
				}

				if (!Checks.esNulo(dto.getProvinciaRteCodigo())) {
					DDProvincia provinciaRte = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class, dto.getProvinciaRteCodigo());
					compradorExpediente.setProvinciaRepresentante(provinciaRte);
				}

				if (!Checks.esNulo(dto.getMunicipioRteCodigo())) {
					Filter filtroLocalidadRte = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioRteCodigo());
					Localidad localidadRte = genericDao.get(Localidad.class, filtroLocalidadRte);
					compradorExpediente.setLocalidadRepresentante(localidadRte);
				}

				if (!Checks.esNulo(dto.getCodigoPostalRte())) {
					compradorExpediente.setCodigoPostalRepresentante(dto.getCodigoPostalRte());
				}

				if (!Checks.esNulo(dto.getNumDocumentoRte())) {
					compradorExpediente.setDocumentoRepresentante(dto.getNumDocumentoRte());
				}

				if (!Checks.esNulo(dto.getDireccionRte())) {
					compradorExpediente.setDireccionRepresentante(dto.getDireccionRte());
				}

				if (!Checks.esNulo(dto.getTelefono1Rte())) {
					compradorExpediente.setTelefono1Representante(dto.getTelefono1Rte());
				}

				if (!Checks.esNulo(dto.getTelefono2Rte())) {
					compradorExpediente.setTelefono2Representante(dto.getTelefono2Rte());
				}

				if (!Checks.esNulo(dto.getEmailRte())) {
					compradorExpediente.setEmailRepresentante(dto.getEmailRte());
				}

				if (!Checks.esNulo(dto.getCodigoPais())) {
					Filter filtroPais = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoPais());
					DDPaises pais = genericDao.get(DDPaises.class, filtroPais);
					compradorExpediente.setPais(pais);
				}

				if (!Checks.esNulo(dto.getCodigoPaisRte())) {
					Filter filtroPaisRte = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoPaisRte());
					DDPaises paisRte = genericDao.get(DDPaises.class, filtroPaisRte);
					compradorExpediente.setPaisRte(paisRte);
				}

				if (!Checks.esNulo(dto.getCodigoGradoPropiedad())) {
					Filter filtroGradoPropiedad = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoGradoPropiedad());
					DDTipoGradoPropiedad gradoPropiedad = genericDao.get(DDTipoGradoPropiedad.class, filtroGradoPropiedad);
					compradorExpediente.setGradoPropiedad(gradoPropiedad);
				}

				CompradorExpedientePk pk = new CompradorExpedientePk();
				pk.setComprador(comprador);
				pk.setExpediente(expediente);
				compradorExpediente.setPrimaryKey(pk);

				genericDao.save(Comprador.class, comprador);
				expediente.getCompradores().add(compradorExpediente);

				genericDao.save(ExpedienteComercial.class, expediente);

				ofertaApi.resetPBC(expediente, true);

				return true;

			} catch (Exception e) {
				logger.error("error en expedienteComercialManager", e);
				return false;
			}
		}
	}

	@Override
	public String consultarComiteSancionador(Long idExpediente) throws Exception {
		Long porcentajeImpuesto = null;

		try {
			ExpedienteComercial expediente = findOne(idExpediente);
			if (!Checks.esNulo(expediente.getCondicionante())) {
				if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
					porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable().longValue();
				}
			}

			InstanciaDecisionDto instancia = expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto, null);

			ResultadoInstanciaDecisionDto resultadoDto = uvemManagerApi.consultarInstanciaDecision(instancia);

			return resultadoDto.getCodigoComite();

		} catch (JsonViewerException jve) {
			logger.info("error controlado en expedienteComercialManager", jve);
			throw jve;
		} catch (Exception e) {
			logger.error("error en expedienteComercialManager", e);
			throw e;
		}
	}

	@Override
	public DDComiteSancion comiteSancionadorByCodigo(String codigo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);

		return genericDao.get(DDComiteSancion.class, filtro);
	}

	@SuppressWarnings("unused")
	@Deprecated
	private InstanciaDecisionDto expedienteComercialToInstanciaDecision(ExpedienteComercial expediente) {
		InstanciaDecisionDto instancia = new InstanciaDecisionDto();
		Oferta oferta = expediente.getOferta();
		Activo activo = oferta.getActivoPrincipal();

		boolean solicitaFinanciacion = false;
		short tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_SIN_IMPUESTO;

		if (!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getSolicitaFinanciacion())) {
			solicitaFinanciacion = BooleanUtils.toBoolean(expediente.getCondicionante().getSolicitaFinanciacion());
		}

		Integer numActivoEspecial = Checks.esNulo(activo.getNumActivoUvem()) ? 0 : activo.getNumActivoUvem().intValue();
		Long importe = Checks.esNulo(oferta.getImporteContraOferta()) ? Double.valueOf(oferta.getImporteOferta() * 100).longValue() : Double.valueOf(oferta.getImporteContraOferta() * 100).longValue();

		if (!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getTipoImpuesto())) {
			String tipoImpuestoCodigo = expediente.getCondicionante().getTipoImpuesto().getCodigo();
			if (DDTiposImpuesto.TIPO_IMPUESTO_IVA.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IVA;
			if (DDTiposImpuesto.TIPO_IMPUESTO_IGIC.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IGIC;
			if (DDTiposImpuesto.TIPO_IMPUESTO_IPSI.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IPSI;
			if (DDTiposImpuesto.TIPO_IMPUESTO_ITP.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_ITP;
		}

		InstanciaDecisionDataDto instData = new InstanciaDecisionDataDto();
		instData.setIdentificadorActivoEspecial(numActivoEspecial);
		instData.setImporteConSigno(importe);
		instData.setTipoDeImpuesto(tipoDeImpuesto);

		List<InstanciaDecisionDataDto> instanciaList = new ArrayList<InstanciaDecisionDataDto>();
		instanciaList.add(instData);

		instancia.setCodigoDeOfertaHaya("0");
		instancia.setFinanciacionCliente(solicitaFinanciacion);
		instancia.setData(instanciaList);

		return instancia;
	}

	public InstanciaDecisionDto expedienteComercialToInstanciaDecisionList(ExpedienteComercial expediente, Long porcentajeImpuesto, String codComiteSuperior) throws Exception {
		String tipoImpuestoCodigo;
		InstanciaDecisionDto instancia = new InstanciaDecisionDto();
		BigDecimal importeXActivo = null;
		short tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_SIN_IMPUESTO;
		List<InstanciaDecisionDataDto> instanciaList = new ArrayList<InstanciaDecisionDataDto>();
		boolean solicitaFinanciacion = false;

		Oferta oferta = expediente.getOferta();
		if (Checks.esNulo(oferta)) {
			throw new JsonViewerException("No existe oferta para el expediente.");
		}

		if(oferta.getVentaDirecta() != null){
			instancia.setOfertaVentaCartera(oferta.getVentaDirecta());
		}else{
			instancia.setOfertaVentaCartera(false);
		}

		List<ActivoOferta> listaActivos = oferta.getActivosOferta();
		if (Checks.esNulo(listaActivos) || (!Checks.esNulo(listaActivos) && listaActivos.size() == 0)) {
			throw new JsonViewerException("No hay activos para la oferta indicada.");
		}

		if (Checks.esNulo(porcentajeImpuesto)) {
			throw new JsonViewerException("No se ha indicado el porcentaje de impuesto en el campo Tipo aplicable.");
		}
		
		Double importeTotal = Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteOferta()
				: oferta.getImporteContraOferta();
		//Double sumatorioImporte = new Double(0);

		BigDecimal sumatorioImporte = new BigDecimal(0);

		for (ActivoOferta listaActivo : listaActivos) {
			Activo activo = listaActivo.getPrimaryKey().getActivo();
			if (Checks.esNulo(activo)) {
				throw new JsonViewerException("No se ha podido obtener el activo.");
			}

			if (Checks.esNulo(activo.getNumActivoUvem())) {
				throw new JsonViewerException("El activo no tiene número de UVEM.");
			}

			if (!Checks.esNulo(listaActivo.getImporteActivoOferta())) {
				importeXActivo = new BigDecimal(String.valueOf(listaActivo.getImporteActivoOferta()));
			} else {
				importeXActivo = new BigDecimal(0);
			}
			//importeXActivo = listaActivos.get(i).getImporteActivoOferta();

			sumatorioImporte = sumatorioImporte.add(importeXActivo);

			InstanciaDecisionDataDto instData = new InstanciaDecisionDataDto();
			// ImportePorActivo
			//instData.setImporteConSigno(Double.valueOf(num.format(importeXActivo*100)).longValue());
			instData.setImporteConSigno(importeXActivo.multiply(new BigDecimal(100)).longValue());
			// NumActivoUvem
			instData.setIdentificadorActivoEspecial(Integer.valueOf(activo.getNumActivoUvem().toString()));

			// TipoImpuesto
			if (!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getTipoImpuesto())) {
				tipoImpuestoCodigo = expediente.getCondicionante().getTipoImpuesto().getCodigo();
				if (DDTiposImpuesto.TIPO_IMPUESTO_IVA.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IVA;
				if (DDTiposImpuesto.TIPO_IMPUESTO_IGIC.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IGIC;
				if (DDTiposImpuesto.TIPO_IMPUESTO_IPSI.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IPSI;
				if (DDTiposImpuesto.TIPO_IMPUESTO_ITP.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_ITP;

			}

			if (!Checks.esNulo(tipoDeImpuesto)) {
				instData.setTipoDeImpuesto(tipoDeImpuesto);
			} else {
				throw new JsonViewerException("No se ha indicado el tipo de impuesto.");
			}

			if (!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getRenunciaExencion())) {
				instData.setRenunciaExencion(expediente.getCondicionante().getRenunciaExencion());
			}

			// PorcentajeImpuesto
			if (!Checks.esNulo(porcentajeImpuesto)) {
				instData.setPorcentajeImpuesto(porcentajeImpuesto.intValue());
			}
			instanciaList.add(instData);
		}

		if (!importeTotal.equals(sumatorioImporte.doubleValue())) {
			throw new JsonViewerException("La suma de los importes es diferente al importe de la oferta");
		}

		// SolicitaFinaciacion
		if (!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getSolicitaFinanciacion())) {
			solicitaFinanciacion = BooleanUtils.toBoolean(expediente.getCondicionante().getSolicitaFinanciacion());
		}

		instancia.setFinanciacionCliente(solicitaFinanciacion);
		// OfertaHRE
		instancia.setCodigoDeOfertaHaya(oferta.getNumOferta().toString());
		instancia.setData(instanciaList);

		TitularDto titularPrincipal = null;
		Comprador compradorPrincipal = expediente.getCompradorPrincipal();
		// seteamos la lista de titulares
		List<TitularDto> titulares = new ArrayList<TitularDto>();

		if (expediente.getCompradores() != null && expediente.getCompradores().size() > 0) {
			for (CompradorExpediente comprador : expediente.getCompradores()) {
				//si no esta de baja
				if (comprador.getFechaBaja() == null) {
					TitularDto titular = new TitularDto();
					Comprador primaryKey = comprador.getPrimaryKey().getComprador();

					Activo activoPrincipal = expediente.getOferta().getActivoPrincipal();

					String codigoSubcartera = activoPrincipal.getSubcartera().getCodigo();

					if (DDSubcartera.CODIGO_BAN_BH.equals(codigoSubcartera)) {
						Long idCompradorUrsusBh = primaryKey.getIdCompradorUrsusBh();
						if (!Checks.esNulo(idCompradorUrsusBh)) {
							titular.setNumeroUrsus(idCompradorUrsusBh);
						}
					} else {
						Long idCompradorUrsus = primaryKey.getIdCompradorUrsus();
						if (!Checks.esNulo(idCompradorUrsus)) {
							titular.setNumeroUrsus(idCompradorUrsus);
						}
					}

					titular.setTitularContratacion(comprador.getTitularContratacion());

					if (primaryKey.getTipoDocumento() != null) {
						DDTipoDocumento tipoDoc = primaryKey.getTipoDocumento();
						titular.setTipoDocumentoCliente(traducitTipoDoc(tipoDoc.getCodigo()));
					}

					titular.setNombreCompletoCliente(primaryKey.getFullName());
					titular.setNumeroDocumento(primaryKey.getDocumento());
					titular.setPorcentajeCompra(comprador.getPorcionCompra());

					if (comprador.getDocumentoConyuge() != null && !comprador.getDocumentoConyuge().isEmpty()) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento", comprador.getDocumentoConyuge());
						Comprador compradorConyuge = genericDao.get(Comprador.class, filtro);
						if (compradorConyuge != null) {
							if(compradorConyuge.getIdCompradorUrsus() != null){
								titular.setConyugeNumeroUrsus(compradorConyuge.getIdCompradorUrsus());
							}else if(compradorConyuge.getIdCompradorUrsusBh() != null){
								titular.setConyugeNumeroUrsus(compradorConyuge.getIdCompradorUrsusBh());
							}

						}
					}

					if (!primaryKey.equals(compradorPrincipal)) titulares.add(titular);
					else titularPrincipal = titular;
				}
			}
		}

		if (!Checks.esNulo(titularPrincipal)) titulares.add(0, titularPrincipal);
		instancia.setTitulares(titulares);

		// info de la reserva
		if (!Checks.esNulo(expediente.getCondicionante())) {
			if (expediente.getCondicionante().getImporteReserva() == null) {
				instancia.setImporteReserva(0D);

			} else {
				instancia.setImporteReserva(expediente.getCondicionante().getImporteReserva());
			}

			if (expediente.getCondicionante().getReservaConImpuesto() != null && expediente.getCondicionante().getReservaConImpuesto().equals(1)) {
				instancia.setImpuestosReserva(true);

			} else {
				instancia.setImpuestosReserva(false);
			}

		} else {
			instancia.setImporteReserva(0D);
			instancia.setImpuestosReserva(false);
		}

		if (instancia.getImporteReserva() != null && instancia.getImporteReserva().compareTo(0D) != 0 && expediente.getReserva() != null && expediente.getReserva().getTipoArras() !=
		null) {
			instancia.setCodTipoArras(expediente.getReserva().getTipoArras().getCodigo());
		}

		//MOD3
		List<GastosExpediente> gastosExpediente = expediente.getHonorarios();

		if (!Checks.estaVacio(gastosExpediente)) {
			for (GastosExpediente gastoExp : gastosExpediente) {
				if (!Checks.esNulo(gastoExp.getAccionGastos()) && DDAccionGastos.CODIGO_PRESCRIPCION.equals(gastoExp.getAccionGastos().getCodigo())) {
					if (!Checks.esNulo(gastoExp.getProveedor()) && DDTipoProveedor.COD_OFICINA_BANKIA.equals(gastoExp.getProveedor().getTipoProveedor().getCodigo())) {
						instancia.setCodigoProveedorUvem(gastoExp.getProveedor().getCodigoApiProveedor());
						break;
					}
				}
			}
		}

		if (!Checks.esNulo(codComiteSuperior) && DDSiNo.SI.equals(codComiteSuperior)) {
			instancia.setCodComiteSuperior(DDComiteSancion.CODIGO_BANKIA_DGVIER);
		}

		DDSubcartera subcartera = getCodigoSubCarteraExpediente(expediente.getId());
		if (!Checks.esNulo(subcartera)) {
			if (DDSubcartera.CODIGO_BAN_BH.equals(subcartera.getCodigo())) {
				instancia.setQcenre(DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA_HABITAT);

			} else {
				instancia.setQcenre(DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA);
			}
		}

		if (oferta.getAgrupacion() != null) {
			instancia.setOfertaAgrupacion(true);
			if(oferta.getIdUvem() != null ){
				instancia.setCodigoAgrupacionInmueble(Integer.valueOf(oferta.getIdUvem().toString()));
			}
		}

		return instancia;
	}

	/**
	 * Traduce el tipo de documento REM al char aceptado por los sw de BANKIA.
	 *
	 * @param codigoTipoDoc
	 * @return
	 * @throws Exception
	 */
	private char traducitTipoDoc(String codigoTipoDoc) throws Exception {
		char result = ' ';
		if (codigoTipoDoc.equals("01")) {
			result = '1';
		} else if (codigoTipoDoc.equals("02")) {
			result = '2';
		} else if (codigoTipoDoc.equals("03")) {
			result = '3';
		} else if (codigoTipoDoc.equals("04")) {
			result = '4';
		} else if (codigoTipoDoc.equals("05")) {
			result = '5';
		} else if (codigoTipoDoc.equals("06")) {
			result = '7';
		} else if (codigoTipoDoc.equals("07")) {
			result = '8';
		} else if (codigoTipoDoc.equals("08")) {
			result = '9';
		} else if (codigoTipoDoc.equals("09")) {
			result = 'F';
		} else if (codigoTipoDoc.equals("10")) {
			result = 'J';
		} else if (codigoTipoDoc.equals("12")) {
			result = 'J';
		} else {
			throw new JsonViewerException("Tipo de documento no soportado");
		}
		return result;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createPosicionamiento(DtoPosicionamiento dto, Long idEntidad) {
		ExpedienteComercial expediente = findOne(idEntidad);
		Posicionamiento posicionamiento = new Posicionamiento();
		List<Posicionamiento> lista = expediente.getPosicionamientos();

		if (lista.isEmpty()) {
			posicionamiento = dtoToPosicionamiento(dto, posicionamiento);
			posicionamiento.setExpediente(expediente);

			genericDao.save(Posicionamiento.class, posicionamiento);

			return true;

		} else {
			boolean hayPosicionamientoVigente = false;

			for (Posicionamiento p : lista) {
				if (Checks.esNulo(p.getFechaFinPosicionamiento()) && Checks.esNulo(p.getMotivoAplazamiento())) {
					hayPosicionamientoVigente = true;
				}
			}

			if (!hayPosicionamientoVigente) {
				posicionamiento = dtoToPosicionamiento(dto, posicionamiento);
				posicionamiento.setExpediente(expediente);

				genericDao.save(Posicionamiento.class, posicionamiento);
				return true;
			}

			return false;
		}
	}

	@Override
	@Transactional(readOnly = false)
	public boolean savePosicionamiento(DtoPosicionamiento dto) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdPosicionamiento());
		Posicionamiento posicionamiento = genericDao.get(Posicionamiento.class, filtro);
		posicionamiento = dtoToPosicionamiento(dto, posicionamiento);

		if (!Checks.esNulo(posicionamiento.getMotivoAplazamiento())) {
			posicionamiento.setFechaFinPosicionamiento(new Date());
		}

		genericDao.update(Posicionamiento.class, posicionamiento);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deletePosicionamiento(Long idPosicionamiento) {
		Filter filtroPosicionamiento = genericDao.createFilter(FilterType.EQUALS, "id", idPosicionamiento);
		Posicionamiento posicionamiento = genericDao.get(Posicionamiento.class, filtroPosicionamiento);

		if (!Checks.esNulo(posicionamiento)) {
			posicionamiento.setFechaFinPosicionamiento(new Date());
			genericDao.update(Posicionamiento.class, posicionamiento);
		}

		return true;
	}

	@Override
	public List<DtoNotarioContacto> getContactosNotario(Long idProveedor) {
		List<DtoNotarioContacto> listaNotariosContactos = new ArrayList<DtoNotarioContacto>();

		Filter filtroProveedorId = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", idProveedor);
		List<ActivoProveedorContacto> listaContactos = genericDao.getList(ActivoProveedorContacto.class, filtroProveedorId);

		Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "id", idProveedor);
		ActivoProveedor notarioProveedor = genericDao.get(ActivoProveedor.class, filtroId);

		DtoNotarioContacto notarioContactoDto;
		for (ActivoProveedorContacto notarioContacto : listaContactos) {
			// Toma los datos de ActivoProveedorContacto
			notarioContactoDto = activoProveedorContactoToNotariosContactoDto(notarioContacto);
			listaNotariosContactos.add(notarioContactoDto);
		}

		// A la lista obtenida, agrega los datos de ActivoProveedor
		for (DtoNotarioContacto notarioContacto : listaNotariosContactos) {
			addActivoProveedorToNotariosContactoDto(notarioProveedor, notarioContacto);
		}

		return listaNotariosContactos;
	}

	/**
	 * Este método añade al objeto dto los datos de la entidad proveedor.
	 *
	 * @param notario: entidad de la que obtener los datos.
	 * @param notarioContacto: objeto al que trasladar los datos.
	 */
	private void addActivoProveedorToNotariosContactoDto(ActivoProveedor notario, DtoNotarioContacto notarioContacto) {
		notarioContacto.setId(notario.getId());

		if (!Checks.esNulo(notario.getNombre())) {
			notarioContacto.setNombreProveedor(notario.getNombre());
		} else {
			notarioContacto.setNombreProveedor(notario.getNombreComercial());
		}

		notarioContacto.setDireccion(notario.getDireccion());

		if (!Checks.esNulo(notario.getProvincia())) {
			notarioContacto.setProvincia(notario.getProvincia().getDescripcion());
		}

		if (!Checks.esNulo(notario.getLocalidad())) {
			notarioContacto.setLocalidad(notario.getLocalidad().getDescripcion());
		}

		notarioContacto.setCodigoPostal(String.valueOf(notario.getCodigoPostal()));
	}

	/**
	 * Este método genera un nuevo objeto dto, lo rellena con los datos de la entidad ActivoProveedorContacto y devuelve el objeto.
	 *
	 * @param notarioContacto: entidad de la que obtener los datos.
	 * @return Devuelve un objeto dto relleno.
	 */
	private DtoNotarioContacto activoProveedorContactoToNotariosContactoDto(ActivoProveedorContacto notarioContacto) {
		DtoNotarioContacto notarioContactoDto = new DtoNotarioContacto();
		notarioContactoDto.setIdContacto(notarioContacto.getId());
		notarioContactoDto.setPersonaContacto(notarioContacto.getNombre());
		notarioContactoDto.setCargo(notarioContacto.getCargo());
		notarioContactoDto.setTelefono1(notarioContacto.getTelefono1());
		notarioContactoDto.setTelefono2(notarioContacto.getTelefono2());
		notarioContactoDto.setFax(notarioContacto.getFax());
		notarioContactoDto.setEmail(notarioContacto.getEmail());

		return notarioContactoDto;
	}

	public DatosClienteDto buscarNumeroUrsus(String numeroDocumento, String tipoDocumento, String idExpediente) throws Exception {
		DtoClienteUrsus compradorUrsus = new DtoClienteUrsus();
		String tipoDoc = null;

		if (!Checks.esNulo(tipoDocumento)) {
			if (DDTiposDocumentos.DNI.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.DNI;
			if (DDTiposDocumentos.CIF.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.CIF;
			if (DDTiposDocumentos.NIF.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.DNI;
			if (DDTiposDocumentos.TARJETA_RESIDENTE.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.TARJETA_RESIDENTE;
			if (DDTiposDocumentos.PASAPORTE.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.PASAPORTE;
			if (DDTiposDocumentos.CIF_EXTRANJERO.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.CIF_EXTRANJERO;
			if (DDTiposDocumentos.DNI_EXTRANJERO.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.DNI_EXTRANJERO;
			if (DDTiposDocumentos.TARJETA_DIPLOMATICA.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.TARJETA_DIPLOMATICA;
			if (DDTiposDocumentos.MENOR.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.MENOR;
			if (DDTiposDocumentos.OTROS_PERSONA_FISICA.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.OTROS_PERSONA_FISICA;
			if (DDTiposDocumentos.OTROS_PESONA_JURIDICA.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.OTROS_PESONA_JURIDICA;
		}

		if (!Checks.esNulo(numeroDocumento)) {
			compradorUrsus.setNumDocumento(numeroDocumento);
		}

		compradorUrsus.setTipoDocumento(tipoDoc);

		if (!Checks.esNulo(idExpediente)) {
			DDSubcartera subcarteraExpediente = getCodigoSubCarteraExpediente(Long.parseLong(idExpediente));

			if (!Checks.esNulo(subcarteraExpediente) && DDSubcartera.CODIGO_BAN_BH.equals(subcarteraExpediente.getCodigo())) {
				compradorUrsus.setQcenre(DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA_HABITAT);
			} else {
				compradorUrsus.setQcenre(DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA);
			}
		}

		DatosClienteDto dtoDatosCliente;
		try {
			dtoDatosCliente = uvemManagerApi.ejecutarDatosClientePorDocumento(compradorUrsus);

			if (Checks.esNulo(dtoDatosCliente.getDniNifDelTitularDeLaOferta())) {
				throw new JsonViewerException("Cliente Ursus no encontrado");
			}

		} catch (JsonViewerException e) {
			logger.error("error en expedienteComercialManager", e);
			throw e;

		} catch (Exception e) {
			logger.error("error en expedienteComercialManager", e);
			throw e;
		}

		return dtoDatosCliente;
	}

	@Override
	public List<DatosClienteDto> buscarClientesUrsus(String numeroDocumento, String tipoDocumento, String idExpediente) throws Exception {
		List<DatosClienteDto> lista = new ArrayList<DatosClienteDto>();
		String tipoDoc = null;

		try {
			if (Checks.esNulo(numeroDocumento) || Checks.esNulo(tipoDocumento)) {
				return lista;
			}

			if (!Checks.esNulo(tipoDocumento)) {
				if (DDTiposDocumentos.DNI.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.DNI;
				if (DDTiposDocumentos.CIF.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.CIF;
				if (DDTiposDocumentos.NIF.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.DNI;
				if (DDTiposDocumentos.TARJETA_RESIDENTE.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.TARJETA_RESIDENTE;
				if (DDTiposDocumentos.PASAPORTE.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.PASAPORTE;
				if (DDTiposDocumentos.CIF_EXTRANJERO.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.CIF_EXTRANJERO;
				if (DDTiposDocumentos.DNI_EXTRANJERO.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.DNI_EXTRANJERO;
				if (DDTiposDocumentos.TARJETA_DIPLOMATICA.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.TARJETA_DIPLOMATICA;
				if (DDTiposDocumentos.MENOR.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.MENOR;
				if (DDTiposDocumentos.OTROS_PERSONA_FISICA.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.OTROS_PERSONA_FISICA;
				if (DDTiposDocumentos.OTROS_PESONA_JURIDICA.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.OTROS_PESONA_JURIDICA;
			}

			if (!Checks.esNulo(idExpediente)) {
				DDSubcartera subcarteraExpediente = getCodigoSubCarteraExpediente(Long.parseLong(idExpediente));
				if (!Checks.esNulo(subcarteraExpediente) && DDSubcartera.CODIGO_BAN_BH.equals(subcarteraExpediente.getCodigo())) {
					lista = uvemManagerApi.ejecutarNumCliente(numeroDocumento, tipoDoc, DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA_HABITAT);
				} else {
					lista = uvemManagerApi.ejecutarNumCliente(numeroDocumento, tipoDoc, DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA);
				}
			}

		} catch (Exception e) {
			logger.error("error en expedienteComercialManager", e);
			throw e;
		}

		return lista;
	}

	@Override
	public DatosClienteDto buscarDatosClienteNumeroUrsus(String numeroUrsus, String idExpediente) throws Exception {
		DatosClienteDto datosClienteDto = null;

		try {
			Integer numURSUS = Integer.parseInt(numeroUrsus);
			if (!Checks.esNulo(idExpediente)) {
				DDSubcartera subcarteraExpediente = getCodigoSubCarteraExpediente(Long.parseLong(idExpediente));
				if (!Checks.esNulo(subcarteraExpediente) && DDSubcartera.CODIGO_BAN_BH.equals(subcarteraExpediente.getCodigo())) {
					datosClienteDto = uvemManagerApi.ejecutarDatosCliente(numURSUS, DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA_HABITAT);
				} else {
					datosClienteDto = uvemManagerApi.ejecutarDatosCliente(numURSUS, DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA);
				}
			}

		} catch (NumberFormatException nfe) {
			logger.error("error en expedienteComercialManager", nfe);

		} catch (Exception e) {
			logger.error("error en expedienteComercialManager", e);
			throw e;
		}

		return datosClienteDto;
	}

	@Override
	public Page getComboProveedoresExpediente(String codigoTipoProveedor, String nombreBusqueda, String idActivo, WebDto dto) {
		String codigoProvinciaActivo = null;
		List<Long> proveedoresIDporCartera = new ArrayList<Long>();

		if (!Checks.esNulo(idActivo)) {
			Activo activo = activoAdapter.getActivoById(Long.parseLong(idActivo));
			codigoProvinciaActivo = activo.getProvincia();

			if (!Checks.esNulo(activo.getCartera())) {
				Filter filtroEntidad = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", activo.getCartera().getCodigo());
				List<EntidadProveedor> epList = genericDao.getList(EntidadProveedor.class, filtroEntidad);
				for (EntidadProveedor e : epList) {
					proveedoresIDporCartera.add(e.getProveedor().getId());
				}
			}
		}

		return expedienteComercialDao.getComboProveedoresExpediente(codigoTipoProveedor, nombreBusqueda, codigoProvinciaActivo, proveedoresIDporCartera, dto);
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createHonorario(DtoGastoExpediente dto, Long idEntidad) {
		ExpedienteComercial expediente = findOne(idEntidad);
		GastosExpediente gastoExpediente = new GastosExpediente();

		if (!Checks.esNulo(dto.getCodigoTipoComision())) {
			Filter filtroAccionGasto = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoTipoComision());
			DDAccionGastos accionGastos = genericDao.get(DDAccionGastos.class, filtroAccionGasto);
			gastoExpediente.setAccionGastos(accionGastos);
		}

		if (!Checks.esNulo(dto.getCodigoTipoProveedor())) {
			Filter filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoTipoProveedor());
			DDTipoProveedorHonorario tipoProveedor = genericDao.get(DDTipoProveedorHonorario.class, filtroTipoProveedor);
			gastoExpediente.setTipoProveedor(tipoProveedor);
		}

		if (!Checks.esNulo(dto.getCodigoProveedorRem())) {
			Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", dto.getCodigoProveedorRem());
			ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroProveedor);

			if (Checks.esNulo(proveedor) || Checks.esNulo(proveedor.getTipoProveedor()) || !proveedor.getTipoProveedor().getCodigo().equals(dto.getCodigoTipoProveedor())) {
				throw new JsonViewerException(ExpedienteComercialManager.PROVEDOR_NO_EXISTE_O_DISTINTO_TIPO);
			}

			gastoExpediente.setProveedor(proveedor);
		}

		if (!Checks.esNulo(dto.getCodigoTipoCalculo())) {
			Filter filtroTipoCalculo = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoTipoCalculo());
			DDTipoCalculo tipoCalculo = genericDao.get(DDTipoCalculo.class, filtroTipoCalculo);
			gastoExpediente.setTipoCalculo(tipoCalculo);
		}

		gastoExpediente.setImporteCalculo(dto.getImporteCalculo());
		gastoExpediente.setImporteFinal(dto.getHonorarios());
		gastoExpediente.setObservaciones(dto.getObservaciones());
		gastoExpediente.setExpediente(expediente);

		if (!Checks.esNulo(dto.getIdActivo())) {
			Activo activo = null;

			for (ActivoOferta activoOferta : expediente.getOferta().getActivosOferta()) {
				if (activoOferta.getPrimaryKey().getActivo().getId().equals(dto.getIdActivo())) {
					activo = activoOferta.getPrimaryKey().getActivo();
				}
			}
			gastoExpediente.setActivo(activo);
		}

		genericDao.save(GastosExpediente.class, gastoExpediente);

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteHonorario(Long idHonorario) {
		genericDao.deleteById(GastosExpediente.class, idHonorario);

		return true;
	}

	@Override
	public OfertaUVEMDto createOfertaOVEM(Oferta oferta, ExpedienteComercial expedienteComercial) throws Exception {
		Double importeReserva = null;
		DecimalFormat num = new DecimalFormat("###.##");

		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		OfertaUVEMDto ofertaUVEM = new OfertaUVEMDto();
		if (oferta.getTipoOferta() != null) {
			ofertaUVEM.setCodOpcion(oferta.getTipoOferta().getCodigo());
		}
		if (oferta.getNumOferta() != null) {
			ofertaUVEM.setCodOfertaHRE(oferta.getNumOferta().toString());
		}
		if (oferta.getPrescriptor() != null) {
			ofertaUVEM.setCodPrescriptor(oferta.getPrescriptor().getCodigoApiProveedor());
		}

		if (condExp != null) {
			importeReserva = condExp.getImporteReserva();
			if (importeReserva != null) {
				ofertaUVEM.setImporteReserva(num.format(importeReserva));
			}
		}

		Double importeTotal = Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteOferta() : oferta.getImporteContraOferta();
		if (importeTotal != null) {
			ofertaUVEM.setImporteVenta(num.format(importeTotal));
		}

		// Siempre se enviará 00000 (Bankia) para el servicio de consulta del cobro de la reserva y de la venta.
		ofertaUVEM.setEntidad("00000");

		if (!Checks.esNulo(condExp) && !Checks.esNulo(condExp.getReservaConImpuesto()) && condExp.getReservaConImpuesto() == 1) {
			ofertaUVEM.setImpuestos("S");
		} else {
			ofertaUVEM.setImpuestos("N");
		}

		if (expedienteComercial.getReserva() != null) {
			if (expedienteComercial.getReserva().getTipoArras() != null) {
				if (DDTiposArras.CONFIRMATORIAS.equals(expedienteComercial.getReserva().getTipoArras().getCodigo())) {
					ofertaUVEM.setArras("A");
				} else {
					ofertaUVEM.setArras("B");
				}

			} else {
				ofertaUVEM.setArras("");
			}
		}

		return ofertaUVEM;
	}

	@Override
	public ArrayList<TitularUVEMDto> obtenerListaTitularesUVEM(ExpedienteComercial expedienteComercial) throws Exception {
		ArrayList<TitularUVEMDto> listaTitularUVEM = new ArrayList<TitularUVEMDto>();
		TitularUVEMDto titularPrincipal = null;
		Comprador compradorPrincipal = expedienteComercial.getCompradorPrincipal();

		for (int k = 0; k < expedienteComercial.getCompradores().size(); k++) {
			CompradorExpediente compradorExpediente = expedienteComercial.getCompradores().get(k);
			TitularUVEMDto titularUVEM = new TitularUVEMDto();

			Activo activoPrincipal = expedienteComercial.getOferta().getActivoPrincipal();

			String codigoSubcartera = activoPrincipal.getSubcartera().getCodigo();

			//Si es Bankia Habitat
			if (DDSubcartera.CODIGO_BAN_BH.equals(codigoSubcartera)) {
				Long idCompradorUrsusBh = compradorExpediente.getPrimaryKey().getComprador().getIdCompradorUrsusBh();
				if (!Checks.esNulo(idCompradorUrsusBh)) {
					titularUVEM.setCliente(idCompradorUrsusBh.toString());
				}

				if (!Checks.esNulo(compradorExpediente.getDocumentoConyuge())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento", compradorExpediente.getDocumentoConyuge());
					Filter filtro2 = genericDao.createFilter(FilterType.NOTNULL, "idCompradorUrsusBh");
					List<Comprador> conyuges = genericDao.getList(Comprador.class, filtro,filtro2);
					Comprador conyuge = null;
					if(conyuges != null && conyuges.size()>0){
						conyuge = conyuges.get(0);
					}
					if(!Checks.esNulo(conyuge) && !Checks.esNulo(conyuge.getIdCompradorUrsus())) {
						titularUVEM.setConyuge(conyuge.getIdCompradorUrsusBh().toString());
					}
				}

			//Si no es Bankia Habitat
			} else {
				Long idCompradorUrsus = compradorExpediente.getPrimaryKey().getComprador().getIdCompradorUrsus();
				if (!Checks.esNulo(idCompradorUrsus)) {
					titularUVEM.setCliente(idCompradorUrsus.toString());
				}

				if (!Checks.esNulo(compradorExpediente.getDocumentoConyuge())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento", compradorExpediente.getDocumentoConyuge());
					Filter filtro2 = genericDao.createFilter(FilterType.NOTNULL, "idCompradorUrsus");
					List<Comprador> conyuges = genericDao.getList(Comprador.class, filtro,filtro2);
					Comprador conyuge = null;
					if(conyuges != null && conyuges.size()>0){
						conyuge = conyuges.get(0);
					}
					if(!Checks.esNulo(conyuge) && !Checks.esNulo(conyuge.getIdCompradorUrsus())) {
						titularUVEM.setConyuge(conyuge.getIdCompradorUrsus().toString());
					}
				}
			}

			if (compradorExpediente.getPorcionCompra() != null) {
				titularUVEM.setPorcentaje(compradorExpediente.getPorcionCompra().toString());
			}

			if(!compradorPrincipal.equals(compradorExpediente.getPrimaryKey().getComprador())){
				listaTitularUVEM.add(titularUVEM);
			} else {
				titularPrincipal = titularUVEM;
			}
		}

		if (!Checks.esNulo(titularPrincipal)) listaTitularUVEM.add(0, titularPrincipal);

		return listaTitularUVEM;
	}

	@Override
	public boolean checkCompradoresTienenNumeroUrsus(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);

		if (Checks.esNulo(activoTramite)) {
			return false;
		}

		if (!Checks.esNulo(activoTramite.getActivo()) && activoTramite.getActivo().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)) {
			Trabajo trabajo = activoTramite.getTrabajo();
			if (Checks.esNulo(trabajo)) {
				return false;
			}

			ExpedienteComercial expedienteComercial = expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());
			if (Checks.esNulo(expedienteComercial)) {
				return false;
			}

			for (int k = 0; k < expedienteComercial.getCompradoresAlta().size(); k++) {
				CompradorExpediente compradorExpediente = expedienteComercial.getCompradoresAlta().get(k);
				if (Checks.esNulo(compradorExpediente.getPrimaryKey().getComprador().getIdCompradorUrsus())
						&& Checks.esNulo(compradorExpediente.getPrimaryKey().getComprador().getIdCompradorUrsusBh())) {
					return false;
				}
			}
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteCompradorExpediente(Long idExpediente, Long idComprador) {
		try {
			Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "primaryKey.expediente.id", idExpediente);
			Filter filtroComprador = genericDao.createFilter(FilterType.EQUALS, "primaryKey.comprador.id", idComprador);

			CompradorExpediente compradorExpediente = genericDao.get(CompradorExpediente.class, filtroExpediente, filtroComprador);

			if (!Checks.esNulo(compradorExpediente)) {
				if (!Checks.esNulo(compradorExpediente.getTitularContratacion())) {
					if (compradorExpediente.getTitularContratacion() == 0) {
						expedienteComercialDao.deleteCompradorExpediente(idExpediente, idComprador);
						ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", idExpediente));
						ofertaApi.resetPBC(expediente, true);
					}

				} else {
					throw new JsonViewerException("Operación no permitida, por ser el titular de la contratación");
				}

			} else {
				throw new JsonViewerException("Error al eliminar comprador");
			}

		} catch (JsonViewerException e) {
			logger.error("error en expedienteComercialManager", e);
			throw e;
		} catch (Exception e) {
			logger.error("error en expedienteComercialManager", e);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean updateActivoExpediente(DtoActivosExpediente dto, Long id) {
		ExpedienteComercial expedienteComercial = findOne(id);
		Oferta oferta = expedienteComercial.getOferta();
		Double importeOferta = !Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteContraOferta()
				: oferta.getImporteOferta();

		try {
			List<ActivoOferta> activosOferta = expedienteComercial.getOferta().getActivosOferta();
			for (ActivoOferta activoOferta : activosOferta) {
				if (activoOferta.getPrimaryKey().getActivo().getId().equals(dto.getIdActivo())
						|| activoOferta.getPrimaryKey().getActivo().getNumActivo().equals(dto.getNumActivo())) {

					if (!Checks.esNulo(dto.getIdActivo())) {
						if (!Checks.esNulo(dto.getImporteParticipacion())) {
							activoOferta.setImporteActivoOferta(dto.getImporteParticipacion());
							activoOferta
									.setPorcentajeParticipacion(100 / (importeOferta / dto.getImporteParticipacion()));
						}
					} else if (!Checks.esNulo(dto.getNumActivo())) {
						if (!Checks.esNulo(dto.getImporteParticipacion())) {
							activoOferta.setImporteActivoOferta(dto.getImporteParticipacion());
							activoOferta
									.setPorcentajeParticipacion(100 / (importeOferta / dto.getImporteParticipacion()));
						}
					}
				}
			}
			expedienteComercialDao.save(expedienteComercial);

		} catch (Exception e) {
			logger.error("error en expedienteComercialManager", e);
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean updateParticipacionActivosOferta(Oferta oferta) {
		Double importeOferta = !Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteContraOferta() : oferta.getImporteOferta();

		try {
			List<ActivoOferta> activosOferta = oferta.getActivosOferta();
			for (ActivoOferta activoOferta : activosOferta) {
				if (!Checks.esNulo(activoOferta.getPorcentajeParticipacion())) {
					activoOferta.setImporteActivoOferta((importeOferta * activoOferta.getPorcentajeParticipacion()) / 100);
				}
			}

		} catch (Exception e) {
			logger.error("error en expedienteComercialManager", e);
			return false;
		}

		return true;
	}

	@Override
	public List<DtoBloqueosFinalizacion> getBloqueosFormalizacion(DtoBloqueosFinalizacion dto) {
		List<DtoBloqueosFinalizacion> bloqueosdto = new ArrayList<DtoBloqueosFinalizacion>();

		if (!Checks.esNulo(dto.getIdExpediente())) {
			if (!Checks.esNulo(dto.getId())) {
				List<BloqueoActivoFormalizacion> bloqueos = genericDao.getList(BloqueoActivoFormalizacion.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", Long.parseLong(dto
				.getIdExpediente())), genericDao.createFilter(FilterType.EQUALS, "activo.id", Long.parseLong(dto.getId())));

				for (BloqueoActivoFormalizacion bloqueo : bloqueos) {
					DtoBloqueosFinalizacion bloqueoDto = new DtoBloqueosFinalizacion();

					try {
						beanUtilNotNull.copyProperty(bloqueoDto, "id", bloqueo.getId().toString());

						if (!Checks.esNulo(bloqueo.getActivo())) {
							beanUtilNotNull.copyProperty(bloqueoDto, "numActivo", bloqueo.getActivo().getNumActivo());
						}

						if (!Checks.esNulo(bloqueo.getArea())) {
							beanUtilNotNull.copyProperty(bloqueoDto, "areaBloqueoCodigo", bloqueo.getArea().getCodigo());
						}

						if (!Checks.esNulo(bloqueo.getTipo())) {
							beanUtilNotNull.copyProperty(bloqueoDto, "tipoBloqueoCodigo", bloqueo.getTipo().getCodigo());
						}

						if (!Checks.esNulo(bloqueo.getAuditoria())) {
							beanUtilNotNull.copyProperty(bloqueoDto, "fechaAlta", bloqueo.getAuditoria().getFechaCrear());
							beanUtilNotNull.copyProperty(bloqueoDto, "usuarioAlta", bloqueo.getAuditoria().getUsuarioCrear());
							beanUtilNotNull.copyProperty(bloqueoDto, "fechaBaja", bloqueo.getAuditoria().getFechaBorrar());
							beanUtilNotNull.copyProperty(bloqueoDto, "usuarioBaja", bloqueo.getAuditoria().getUsuarioBorrar());
						}

						if (!Checks.esNulo(bloqueo.getSolucionarBloqueo())) {
							beanUtilNotNull.copyProperty(bloqueoDto, "acuerdoCodigo", bloqueo.getSolucionarBloqueo());
						}

						bloqueosdto.add(bloqueoDto);

					} catch (IllegalAccessException e) {
						logger.error("Error en ExpedienteComercialManager", e);
					} catch (InvocationTargetException e) {
						logger.error("Error en ExpedienteComercialManager", e);
					}
				}
			}
		}

		return bloqueosdto;
	}

	@SuppressWarnings("static-access")
	@Override
	@Transactional(readOnly = false)
	public boolean createBloqueoFormalizacion(DtoBloqueosFinalizacion dto, Long idActivo) {
		try {
			BloqueoActivoFormalizacion bloqueo = new BloqueoActivoFormalizacion();
			BloqueoActivoFormalizacion bloqueoExistente = genericDao.get(BloqueoActivoFormalizacion.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo), genericDao.createFilter
					(FilterType.EQUALS, "expediente.id", Long.parseLong(dto.getIdExpediente())), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false), genericDao.createFilter(FilterType
					.EQUALS, "area.codigo", dto.getAreaBloqueoCodigo()), genericDao.createFilter(FilterType.EQUALS, "tipo.codigo", dto.getTipoBloqueoCodigo()), genericDao.createFilter(FilterType.EQUALS,
					"solucionarBloqueo", dto.getAcuerdoCodigo()));

			if (Checks.esNulo(bloqueoExistente)) {
				if (!Checks.esNulo(idActivo)) {
					Activo activo = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id", idActivo));
					if (!Checks.esNulo(activo)) {
						bloqueo.setActivo(activo);
					}
				}

				if (!Checks.esNulo(dto.getAreaBloqueoCodigo())) {
					DDAreaBloqueo area = (DDAreaBloqueo) utilDiccionarioApi.dameValorDiccionarioByCod(DDAreaBloqueo.class, dto.getAreaBloqueoCodigo());
					if (!Checks.esNulo(area)) {
						bloqueo.setArea(area);
					}
				}

				if (!Checks.esNulo(dto.getTipoBloqueoCodigo())) {
					DDTipoBloqueo tipo = (DDTipoBloqueo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoBloqueo.class, dto.getTipoBloqueoCodigo());
					if (!Checks.esNulo(tipo)) {
						bloqueo.setTipo(tipo);
					}
				}

				if (!Checks.esNulo(dto.getIdExpediente())) {
					ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdExpediente())));
					if (!Checks.esNulo(expediente)) {
						bloqueo.setExpediente(expediente);
					}
				}

				if (!Checks.esNulo(dto.getAcuerdoCodigo())) {
					bloqueo.setSolucionarBloqueo(dto.getAcuerdoCodigo());
					if ("0".equals(dto.getAcuerdoCodigo())) {
						if (Checks.esNulo(bloqueo.getAuditoria())) {
							bloqueo.setAuditoria(Auditoria.getNewInstance());
						}
						bloqueo.getAuditoria().delete(bloqueo);
					}
				}

				genericDao.save(BloqueoActivoFormalizacion.class, bloqueo);
			}

		} catch (NumberFormatException e) {
			logger.error("Error en ExpedienteComercialManager", e);
			return false;
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteBloqueoFormalizacion(DtoBloqueosFinalizacion dto) {
		if (!Checks.esNulo(dto.getId())) {
			BloqueoActivoFormalizacion bloqueo = genericDao.get(BloqueoActivoFormalizacion.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId())));
			if (!Checks.esNulo(bloqueo)) {
				if (!Checks.esNulo(bloqueo.getAuditoria())) {
					Usuario usuario = genericAdapter.getUsuarioLogado();
					if (!Checks.esNulo(usuario)) {
						bloqueo.getAuditoria().setUsuarioBorrar(usuario.getUsername());
					}

					bloqueo.getAuditoria().setFechaBorrar(new Date());
					bloqueo.getAuditoria().setBorrado(true);
				}
			}
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateBloqueoFormalizacion(DtoBloqueosFinalizacion dto) {
		if (!Checks.esNulo(dto.getId())) {
			BloqueoActivoFormalizacion bloqueo = genericDao.get(BloqueoActivoFormalizacion.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId())));
			if (!Checks.esNulo(bloqueo)) {
				if (!Checks.esNulo(dto.getAcuerdoCodigo())) {
					if ("0".equals(dto.getAcuerdoCodigo())) {
						bloqueo.setSolucionarBloqueo(dto.getAcuerdoCodigo());
						this.deleteBloqueoFormalizacion(dto);
					}
				}
			}
		}

		return true;
	}

	@Override
	public ExpedienteComercial getExpedienteComercialResetPBC(Activo activo) {
		List<ActivoOferta> listaOfertas = activo.getOfertas();

		if (!Checks.estaVacio(listaOfertas)) {
			for (ActivoOferta activoOferta : listaOfertas) {
				Oferta oferta = activoOferta.getPrimaryKey().getOferta();

				if (DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
					ExpedienteComercial expediente = expedienteComercialPorOferta(oferta.getId());

					if (!DDEstadosExpedienteComercial.EN_TRAMITACION.equals(expediente.getEstado().getCodigo()) && !DDEstadosExpedienteComercial.PTE_SANCION.equals(expediente.getEstado().getCodigo()
					) && !DDEstadosExpedienteComercial.CONTRAOFERTADO.equals(expediente.getEstado().getCodigo()) && !DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
					&& !DDEstadosExpedienteComercial.DENEGADO.equals(expediente.getEstado().getCodigo()) && !DDEstadosExpedienteComercial.ANULADO.equals(expediente.getEstado().getCodigo()))
						return expediente;
				}
			}
		}

		return null;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean obtencionDatosPrestamo(DtoObtencionDatosFinanciacion dto) throws Exception {
		try {
			ExpedienteComercial expediente = this.findOne(Long.parseLong(dto.getIdExpediente()));

			Formalizacion formalizacion = expediente.getFormalizacion();

			if (!Checks.esNulo(formalizacion)) {
				String numExpedienteRiesgo = dto.getNumExpediente();
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodTipoRiesgo());
				DDTipoRiesgoClase tipoRiesgo = genericDao.get(DDTipoRiesgoClase.class, filtro);

				if (!Checks.esNulo(numExpedienteRiesgo) && !Checks.esNulo(tipoRiesgo)) {
					Long capitalConcedido;
					capitalConcedido = uvemManagerApi.consultaDatosPrestamo(numExpedienteRiesgo, Integer.parseInt(tipoRiesgo.getCodigo()));

					if (!Checks.esNulo(capitalConcedido)) {
						formalizacion.setCapitalConcedido(capitalConcedido.doubleValue() / 100);
						formalizacion.setNumExpediente(numExpedienteRiesgo);
						formalizacion.setTipoRiesgoClase(tipoRiesgo);

						genericDao.save(Formalizacion.class, formalizacion);

						return true;
					}
				} else {
					throw new Exception("En número del expediente y el tipo de riesgo han de estar informados");
				}
			} else {
				throw new Exception("Este expediente no tiene formalización");
			}

		} catch (Exception e) {
			logger.error("Error en la obtención de datos de préstamo.", e);
			throw new JsonViewerException(e.getMessage());
		}

		return false;
	}

	@Override
	public DtoFormalizacionFinanciacion getFormalizacionFinanciacion(DtoFormalizacionFinanciacion dto) {
		if (Checks.esNulo(dto.getId())) {
			return null;
		}

		ExpedienteComercial expediente = this.findOne(Long.parseLong(dto.getId()));
		if (!Checks.esNulo(expediente)) {
			// Bankia.
			Formalizacion formalizacion = expediente.getFormalizacion();

			if (!Checks.esNulo(formalizacion)) {
				dto.setNumExpedienteRiesgo(formalizacion.getNumExpediente());

				if (!Checks.esNulo(formalizacion.getTipoRiesgoClase())) {
					dto.setTiposFinanciacionCodigo(formalizacion.getTipoRiesgoClase().getCodigo());
					dto.setTiposFinanciacionCodigoBankia(formalizacion.getTipoRiesgoClase().getCodigo());
				}

				if (!Checks.esNulo(formalizacion.getCapitalConcedido())) {
					dto.setCapitalConcedido(formalizacion.getCapitalConcedido());
				}
			}

			// Financiación.
			CondicionanteExpediente condiciones = expediente.getCondicionante();

			if (!Checks.esNulo(condiciones)) {
				dto.setSolicitaFinanciacion(condiciones.getSolicitaFinanciacion());

				if(!Checks.esNulo(dto.getSolicitaFinanciacion()) && dto.getSolicitaFinanciacion() > 0 && Checks.esNulo(dto.getCapitalConcedido())){
					dto.setCapitalConcedido(expediente.getCompradores().get(0).getImporteFinanciado());
				}

				if (!Checks.esNulo(condiciones.getEstadoFinanciacion())) {
					dto.setEstadosFinanciacion(condiciones.getEstadoFinanciacion().getCodigo());
					dto.setEstadosFinanciacionBankia(condiciones.getEstadoFinanciacion().getCodigo());
				}

				dto.setEntidadFinanciacion(condiciones.getEntidadFinanciacion());
				dto.setFechaInicioExpediente(condiciones.getFechaInicioExpediente());
				dto.setFechaInicioFinanciacion(condiciones.getFechaInicioFinanciacion());
				dto.setFechaFinFinanciacion(condiciones.getFechaFinFinanciacion());
			}
		}

		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveFormalizacionFinanciacion(DtoFormalizacionFinanciacion dto) {
		if (Checks.esNulo(dto.getId())) {
			return false;
		}

		ExpedienteComercial expediente = this.findOne(Long.parseLong(dto.getId()));
		if (!Checks.esNulo(expediente)) {
			if (Checks.esNulo(expediente.getCondicionante())) expediente.setCondicionante(new CondicionanteExpediente());
			CondicionanteExpediente condiciones = expediente.getCondicionante();

			if (!Checks.esNulo(condiciones)) {
				if (!Checks.esNulo(dto.getSolicitaFinanciacion())) {
					condiciones.setSolicitaFinanciacion(dto.getSolicitaFinanciacion());
				}

				if (!Checks.esNulo(dto.getEstadosFinanciacion()) || !Checks.esNulo(dto.getEstadosFinanciacionBankia())) {
					if (!Checks.esNulo(dto.getEstadosFinanciacion())) {
						DDEstadoFinanciacion estadoFinanciacion = (DDEstadoFinanciacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoFinanciacion.class, dto.getEstadosFinanciacion());
						condiciones.setEstadoFinanciacion(estadoFinanciacion);
					}

					if (!Checks.esNulo(dto.getEstadosFinanciacionBankia())) {
						DDEstadoFinanciacion estadoFinanciacionBankia = (DDEstadoFinanciacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoFinanciacion.class, dto
						.getEstadosFinanciacionBankia());
						condiciones.setEstadoFinanciacion(estadoFinanciacionBankia);
					}
				}

				if (!Checks.esNulo(dto.getEntidadFinanciacion())) {
					condiciones.setEntidadFinanciacion(dto.getEntidadFinanciacion());
				}

				if (!Checks.esNulo(dto.getFechaInicioExpediente())) {
					condiciones.setFechaInicioExpediente(dto.getFechaInicioExpediente());
				}

				if (!Checks.esNulo(dto.getFechaInicioFinanciacion())) {
					condiciones.setFechaInicioFinanciacion(dto.getFechaInicioFinanciacion());
				}

				if (!Checks.esNulo(dto.getFechaFinFinanciacion())) {
					condiciones.setFechaFinFinanciacion(dto.getFechaFinFinanciacion());
				}

				genericDao.save(CondicionanteExpediente.class, condiciones);
			}

			Formalizacion formalizacion = expediente.getFormalizacion();

			if (!Checks.esNulo(formalizacion)) {
				if (!Checks.esNulo(dto.getNumExpedienteRiesgo())) {
					formalizacion.setNumExpediente(dto.getNumExpedienteRiesgo());
				}

				if (!Checks.esNulo(dto.getTiposFinanciacionCodigo()) || !Checks.esNulo(dto.getTiposFinanciacionCodigoBankia())) {
					if (!Checks.esNulo(dto.getTiposFinanciacionCodigo())) {
						DDTipoRiesgoClase tipoFinanciacion = (DDTipoRiesgoClase) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoRiesgoClase.class, dto.getTiposFinanciacionCodigo());
						formalizacion.setTipoRiesgoClase(tipoFinanciacion);
					}

					if (!Checks.esNulo(dto.getTiposFinanciacionCodigoBankia())) {
						DDTipoRiesgoClase tipoFinanciacionBankia = (DDTipoRiesgoClase) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoRiesgoClase.class, dto.getTiposFinanciacionCodigoBankia());
						formalizacion.setTipoRiesgoClase(tipoFinanciacionBankia);
					}
				}

				genericDao.save(Formalizacion.class, formalizacion);
			}
		}

		return true;
	}

	@Override
	public List<DtoUsuario> getComboUsuarios(long idTipoGestor) {
		return activoAdapter.getComboUsuarios(idTipoGestor);
	}

	@Override
	public Boolean insertarGestorAdicional(GestorEntidadDto dto) {
		dto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
		return gestorExpedienteApi.insertarGestorAdicionalExpedienteComercial(dto);
	}

	@Override
	public List<DtoListadoGestores> getGestores(Long idExpediente) {
		GestorEntidadDto gestorEntidadDto = new GestorEntidadDto();
		gestorEntidadDto.setIdEntidad(idExpediente);
		gestorEntidadDto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);

		List<GestorEntidadHistorico> gestoresEntidad = gestorExpedienteApi.getListGestoresAdicionalesHistoricoData(gestorEntidadDto);

		List<DtoListadoGestores> listadoGestoresDto = new ArrayList<DtoListadoGestores>();

		for (GestorEntidadHistorico gestor : gestoresEntidad) {
			DtoListadoGestores dtoGestor = new DtoListadoGestores();

			try {
				BeanUtils.copyProperties(dtoGestor, gestor);
				BeanUtils.copyProperties(dtoGestor, gestor.getUsuario());
				BeanUtils.copyProperties(dtoGestor, gestor.getTipoGestor());
				BeanUtils.copyProperty(dtoGestor, "id", gestor.getId());

				GestorSustituto gestorSustituto = getGestorSustitutoVigente(gestor);

				if (!Checks.esNulo(gestorSustituto)) {
					dtoGestor.setApellidoNombre(dtoGestor.getApellidoNombre().concat(" (")
							.concat(gestorSustituto.getUsuarioGestorSustituto().getApellidoNombre()).concat(")"));
				}

			} catch (IllegalAccessException e) {
				logger.error("error en expedienteComercialManager", e);
			} catch (InvocationTargetException e) {
				logger.error("error en expedienteComercialManager", e);
			}

			listadoGestoresDto.add(dtoGestor);
		}

		return listadoGestoresDto;
	}

	@Override
	public List<EXTDDTipoGestor> getComboTipoGestor() {
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		List<EXTDDTipoGestor> listAllTiposGestor = genericDao.getListOrdered(EXTDDTipoGestor.class, order, genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		List<EXTDDTipoGestor> listTiposGestor = new ArrayList<EXTDDTipoGestor>();

		if (!Checks.estaVacio(listAllTiposGestor)) {
			for (EXTDDTipoGestor tipoGestor : listAllTiposGestor) {
				if (Arrays.asList(gestorExpedienteApi.getCodigosTipoGestorExpedienteComercial()).contains(tipoGestor.getCodigo())) listTiposGestor.add(tipoGestor);
			}
		}

		return listTiposGestor;
	}

	@Override
	public boolean isExpedienteComercialVivoByActivo(Activo activo) {
		List<ActivoOferta> listaOfertas = activo.getOfertas();

		if (!Checks.estaVacio(listaOfertas)) {
			for (ActivoOferta activoOferta : listaOfertas) {
				Oferta oferta = activoOferta.getPrimaryKey().getOferta();

				if (!Checks.esNulo(oferta.getEstadoOferta()) && DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
					ExpedienteComercial expediente = this.expedienteComercialPorOferta(oferta.getId());

					if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getTrabajo())) {
						List<ActivoTramite> listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(expediente.getTrabajo().getId());

						for (ActivoTramite tramite : listaTramites) {
							List<TareaProcedimiento> tareasActivas = activoTramiteApi.getTareasActivasByIdTramite(tramite.getId());

							if (!Checks.esNulo(tareasActivas)) return true;
						}
					}
				}
			}
		}

		return false;
	}

	@Override
	public ExpedienteComercial getExpedientePorActivo(Activo activo) {
		List<ActivoOferta> listaOfertas = activo.getOfertas();

		if (!Checks.estaVacio(listaOfertas)) {
			for (ActivoOferta activoOferta : listaOfertas) {
				Oferta oferta = activoOferta.getPrimaryKey().getOferta();

				if (!Checks.esNulo(oferta.getEstadoOferta()) && DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
					return this.expedienteComercialPorOferta(oferta.getId());
				}
			}
		}

		return null;
	}

	@Override
	@Transactional(readOnly = false)
	public GastosExpediente creaGastoExpediente(ExpedienteComercial expediente, Oferta oferta, Activo activo, String codigoColaboracion) {
		GastosExpediente gastoExpediente = new GastosExpediente();
		DtoGastoExpediente dtoGastoExpediente = ofertaApi.calculaHonorario(oferta, codigoColaboracion, activo);

		if (!Checks.esNulo(codigoColaboracion)) {
			DDAccionGastos acciongasto = (DDAccionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDAccionGastos.class, codigoColaboracion);

			if (!Checks.esNulo(acciongasto)) {
				gastoExpediente.setAccionGastos(acciongasto);
			}
		}

		if (!Checks.esNulo(dtoGastoExpediente.getCodigoTipoCalculo())) {
			DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCalculo.class, dtoGastoExpediente.getCodigoTipoCalculo());
			gastoExpediente.setTipoCalculo(tipoCalculo);
		}

		if (!Checks.esNulo(dtoGastoExpediente.getIdProveedor())) {
			Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", dtoGastoExpediente.getIdProveedor());
			ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroProveedor);
			gastoExpediente.setProveedor(proveedor);

			DDTipoProveedorHonorario tipoProveedor = null;

			if (!Checks.esNulo(proveedor) && !Checks.esNulo(proveedor.getTipoProveedor())) {
				if (proveedor.getTipoProveedor().getCodigo().equals(DDTipoProveedorHonorario.CODIGO_MEDIADOR)) {
					tipoProveedor = (DDTipoProveedorHonorario) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_MEDIADOR);
				} else if (proveedor.getTipoProveedor().getCodigo().equals(DDTipoProveedorHonorario.CODIGO_FVD)) {
					tipoProveedor = (DDTipoProveedorHonorario) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_FVD);
				} else if (proveedor.getTipoProveedor().getCodigo().equals(DDTipoProveedorHonorario.CODIGO_OFICINA_BANKIA)) {
					tipoProveedor = (DDTipoProveedorHonorario) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_OFICINA_BANKIA);
				} else if (proveedor.getTipoProveedor().getCodigo().equals(DDTipoProveedorHonorario.CODIGO_OFICINA_CAJAMAR)) {
					tipoProveedor = (DDTipoProveedorHonorario) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_OFICINA_CAJAMAR);
				}

				gastoExpediente.setTipoProveedor(tipoProveedor);
			}
		}

		gastoExpediente.setImporteCalculo(dtoGastoExpediente.getImporteCalculo());
		gastoExpediente.setImporteFinal(dtoGastoExpediente.getHonorarios());
		gastoExpediente.setExpediente(expediente);
		gastoExpediente.setActivo(activo);

		genericDao.save(GastosExpediente.class, gastoExpediente);

		return gastoExpediente;
	}

	public List<DtoActivosExpediente> getComboActivos(Long idExpediente) {
		ExpedienteComercial expediente = findOne(idExpediente);
		List<DtoActivosExpediente> listaActivos = new ArrayList<DtoActivosExpediente>();
		List<ActivoOferta> activosExpediente = expediente.getOferta().getActivosOferta();

		for (ActivoOferta activoOferta : activosExpediente) {
			Activo activo = activoOferta.getPrimaryKey().getActivo();

			DtoActivosExpediente dto = new DtoActivosExpediente();
			dto.setIdActivo(activo.getId());
			dto.setNumActivo(activo.getNumActivo());
			dto.setImporteParticipacion(activoOferta.getImporteActivoOferta());
			Oferta oferta = activoOferta.getPrimaryKey().getOferta();

			if (!Checks.esNulo(oferta.getImporteContraOferta())) {
				dto.setImporteParticipacion(oferta.getImporteContraOferta());
			} else {
				dto.setImporteParticipacion(oferta.getImporteOferta());
			}

			listaActivos.add(dto);
		}

		return listaActivos;
	}

	@Transactional(readOnly = false)
	@Override
	public void actualizarImporteReservaPorExpediente(ExpedienteComercial expediente) {
		// Si el expediente tiene reserva.
		if (!Checks.esNulo(expediente.getReserva())) {
			// El cálculo de reserva es del tipo porcentaje.
			CondicionanteExpediente condicionanteExpediente = expediente.getCondicionante();

			if (!Checks.esNulo(condicionanteExpediente) && !Checks.esNulo(condicionanteExpediente.getTipoCalculoReserva()) && condicionanteExpediente.getTipoCalculoReserva().getCodigo().equals
			(DDTipoCalculo.TIPO_CALCULO_PORCENTAJE)) {
				// Comprobar si tiene importe contraoferta, en su defecto, usar importe oferta.
				if (!Checks.esNulo(expediente.getOferta().getImporteContraOferta())) {
					Double importeContraOferta = expediente.getOferta().getImporteContraOferta();
					Double porcentajeReserva = condicionanteExpediente.getPorcentajeReserva();
					porcentajeReserva = porcentajeReserva / 100;
					Double resultado = porcentajeReserva * importeContraOferta;
					condicionanteExpediente.setImporteReserva(resultado);
					genericDao.save(CondicionanteExpediente.class, condicionanteExpediente);

				} else {
					Double importeOferta = expediente.getOferta().getImporteOferta();
					Double porcentajeReserva = condicionanteExpediente.getPorcentajeReserva();
					porcentajeReserva = porcentajeReserva / 100;
					Double resultado = porcentajeReserva * importeOferta;
					condicionanteExpediente.setImporteReserva(resultado);
					genericDao.save(CondicionanteExpediente.class, condicionanteExpediente);
				}
			}
		}
	}

	@Override
	public Boolean checkInformeJuridicoFinalizado(Long idTramite) {

		ActivoTramite tramite = activoTramiteApi.get(idTramite);

		List<TareaActivo> tareasActivas = tareaActivoApi.getTareasActivoByIdTramite(tramite.getId());
		Boolean informeJuridicoFinalizado = false;
		Boolean tieneTareaInformeJuridico = false;

		for (TareaActivo tarea : tareasActivas) {
			Filter filterTar = genericDao.createFilter(FilterType.EQUALS, "id", tarea.getId());
			TareaNotificacion tareaNotificacion = genericDao.get(TareaNotificacion.class, filterTar);
			if (TAR_INFORME_JURIDICO.equals(tareaNotificacion.getTarea())){
				if (tareaNotificacion.getTareaFinalizada()){
					informeJuridicoFinalizado = true;
				}
				tieneTareaInformeJuridico = true;
			}
		}

		if (informeJuridicoFinalizado || !tieneTareaInformeJuridico){
			return true;
		}else {
			return false;
		}
	}

	@Override
	public Boolean checkImporteParticipacion(Long idTramite) {
		BigDecimal totalImporteParticipacionActivos = new BigDecimal(0);

		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);
		if (activoTramite == null) {
			return false;
		}

		Trabajo trabajo = activoTramite.getTrabajo();
		if (trabajo == null) {
			return false;
		}

		ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());
		if (expediente == null) {
			return false;
		}

		Oferta oferta = expediente.getOferta();
		if (oferta == null) {
			return false;
		}

		List<VActivoOfertaImporte> activosOfertas = this.getListActivosOfertaImporte(oferta.getId());

		Double importeExpediente = oferta.getImporteContraOferta() != null ? oferta.getImporteContraOferta() : oferta.getImporteOferta();
		if (importeExpediente == null) {
			return false;
		}

		for (VActivoOfertaImporte activoOferta : activosOfertas) {
			if (!Checks.esNulo(activoOferta.getImporteActivoOferta())) {
				totalImporteParticipacionActivos = totalImporteParticipacionActivos
						.add(BigDecimal.valueOf(activoOferta.getImporteActivoOferta()));
			}
		}

		return importeExpediente.equals(totalImporteParticipacionActivos.doubleValue());
	}

	private List<VActivoOfertaImporte> getListActivosOfertaImporte(Long id) {
		//Filter
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta", id);

		//Declarar lista + genericDao.getList
		List<VActivoOfertaImporte> listaActOfrImp = genericDao.getList(VActivoOfertaImporte.class, filtro);

		return listaActOfrImp;
	}

	public DtoCondicionesActivoExpediente getCondicionesActivoExpediete(Long idExpediente, Long idActivo) {
		Activo activo = activoAdapter.getActivoById(idActivo);

		DtoCondicionesActivoExpediente resultado = new DtoCondicionesActivoExpediente();
		resultado.setEcoId(idExpediente);
		resultado.setIdActivo(idActivo);

		if (activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getFechaTomaPosesion() != null) {
			resultado.setPosesionInicialInformada(1);
		} else {
			resultado.setPosesionInicialInformada(0);
		}

		if (activo.getTitulo() != null && activo.getTitulo().getEstado() != null) {
			resultado.setEstadoTituloInformada(activo.getTitulo().getEstado().getCodigo());
		}

		if (activo.getSituacionPosesoria() != null) {
			if (Checks.esNulo(activo.getSituacionPosesoria().getOcupado())) activo.getSituacionPosesoria().setOcupado(0);
			if (Checks.esNulo(activo.getSituacionPosesoria().getConTitulo())) activo.getSituacionPosesoria().setConTitulo(0);
			if (activo.getSituacionPosesoria().getOcupado() != null
					&& activo.getSituacionPosesoria().getOcupado().equals(Integer.valueOf(0))) {
				resultado.setSituacionPosesoriaCodigoInformada("01");

			} else if (activo.getSituacionPosesoria().getOcupado() != null && activo.getSituacionPosesoria().getOcupado().equals(1) && activo.getSituacionPosesoria().getConTitulo() != null &&
					activo.getSituacionPosesoria().getConTitulo().equals(1)) {
				resultado.setSituacionPosesoriaCodigoInformada("02");

			} else if (activo.getSituacionPosesoria().getOcupado() != null && activo.getSituacionPosesoria().getOcupado().equals(1) && activo.getSituacionPosesoria().getConTitulo() != null &&
					activo.getSituacionPosesoria().getConTitulo().equals(0)) {
				resultado.setSituacionPosesoriaCodigoInformada("03");
			}
		}

		// informada al comprador
		// Si las condiciones al comprador no están informadas en cartera CAJAMAR, estas se copian del activo.
		CondicionesActivo condicionesActivo = genericDao.get(CondicionesActivo.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo),
				genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente));

		if (condicionesActivo != null) {
			if (condicionesActivo.getEstadoTitulo() != null) {
				resultado.setEstadoTitulo(condicionesActivo.getEstadoTitulo().getCodigo());
			}

			resultado.setEviccion(condicionesActivo.getRenunciaSaneamientoEviccion());

			if (!Checks.esNulo(condicionesActivo.getPosesionInicial())) {
				resultado.setPosesionInicial(condicionesActivo.getPosesionInicial());
			}

			if (condicionesActivo.getSituacionPosesoria() != null) {
				resultado.setSituacionPosesoriaCodigo(condicionesActivo.getSituacionPosesoria().getCodigo());
			}

			resultado.setViciosOcultos(condicionesActivo.getRenunciaSaneamientoVicios());
		}

		return resultado;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean guardarCondicionesActivoExpediente(DtoCondicionesActivoExpediente condiciones) {
		boolean altaNueva = false;
		Activo activo = activoAdapter.getActivoById(condiciones.getIdActivo());
		ExpedienteComercial expediente = this.findOne(condiciones.getEcoId());
		CondicionesActivo condicionesActivo = genericDao.get(CondicionesActivo.class, genericDao.createFilter(FilterType.EQUALS, "activo", activo),
				genericDao.createFilter(FilterType.EQUALS, "expediente", expediente));

		if (condicionesActivo == null) {
			condicionesActivo = new CondicionesActivo();
			condicionesActivo.setActivo(activo);
			condicionesActivo.setExpediente(expediente);
			altaNueva = true;
		}

		if (!Checks.esNulo(condiciones.getEstadoTitulo())) {
			DDEstadoTitulo estadoTitulo = genericDao.get(DDEstadoTitulo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", condiciones.getEstadoTitulo()));

			if (!Checks.esNulo(estadoTitulo)) {
				condicionesActivo.setEstadoTitulo(estadoTitulo);
			}
		}

		if (condiciones.getEviccion() != null) {
			condicionesActivo.setRenunciaSaneamientoEviccion(condiciones.getEviccion());
		}

		if (condiciones.getPosesionInicial() != null) {
			condicionesActivo.setPosesionInicial(condiciones.getPosesionInicial());
		}

		if (!Checks.esNulo(condiciones.getSituacionPosesoriaCodigo())) {
			DDSituacionesPosesoria situacionPosesoria = genericDao.get(DDSituacionesPosesoria.class, genericDao.createFilter(FilterType.EQUALS, "codigo",
					condiciones.getSituacionPosesoriaCodigo()));

			if (!Checks.esNulo(situacionPosesoria)) {
				condicionesActivo.setSituacionPosesoria(situacionPosesoria);
			}
		}

		if (condiciones.getViciosOcultos() != null) {
			condicionesActivo.setRenunciaSaneamientoVicios(condiciones.getViciosOcultos());
		}

		if (altaNueva) {
			genericDao.save(CondicionesActivo.class, condicionesActivo);
		} else {
			genericDao.update(CondicionesActivo.class, condicionesActivo);
		}

		return true;
	}

	@Override
	public List<DtoTanteoActivoExpediente> getTanteosPorActivoExpediente(Long idExpediente, Long idActivo) {
		List<DtoTanteoActivoExpediente> tanteosList = new ArrayList<DtoTanteoActivoExpediente>();

		ExpedienteComercial expediente = findOne(idExpediente);

		List<TanteoActivoExpediente> tanteosExpediente = expediente.getTanteoActivoExpediente();

		// Añadir al dto
		for (TanteoActivoExpediente tanteo : tanteosExpediente) {
			if (tanteo.getActivo() != null && tanteo.getActivo().getId().equals(idActivo)) {
				DtoTanteoActivoExpediente tanteoDto = new DtoTanteoActivoExpediente();
				tanteoDto.setId(String.valueOf(tanteo.getId()));

				if (!Checks.esNulo(tanteo.getAdminitracion())) {
					tanteoDto.setCodigoTipoAdministracion(tanteo.getAdminitracion().getCodigo());
					tanteoDto.setDescTipoAdministracion(tanteo.getAdminitracion().getDescripcion());
				}

				tanteoDto.setFechaComunicacion(tanteo.getFechaComunicacion());
				tanteoDto.setFechaRespuesta(tanteo.getFechaContestacion());
				tanteoDto.setNumeroExpediente(tanteo.getNumExpediente());
				if (tanteo.getSolicitudVisita() != null) {
					tanteoDto.setSolicitaVisitaCodigo(tanteo.getSolicitudVisita());

					if (tanteo.getSolicitudVisita().equals(0)) {
						tanteoDto.setSolicitaVisita("No");
					} else {
						tanteoDto.setSolicitaVisita("Si");
					}
				}

				tanteoDto.setFechaVisita(tanteo.getFechaVisita());
				tanteoDto.setFechaFinTanteo(tanteo.getFechaFinTanteo());

				if (!Checks.esNulo(tanteo.getResultadoTanteo())) {
					tanteoDto.setCodigoTipoResolucion(tanteo.getResultadoTanteo().getCodigo());
					tanteoDto.setDescTipoResolucion(tanteo.getResultadoTanteo().getDescripcion());
				}

				tanteoDto.setFechaVencimiento(tanteo.getFechaVencimientoResol());
				tanteoDto.setFechaResolucion(tanteo.getFechaResolucion());
				tanteoDto.setIdActivo(tanteo.getActivo().getId());
				tanteoDto.setEcoId(tanteo.getExpediente().getId());
				tanteoDto.setCondicionesTransmision(tanteo.getCondicionesTx());

				tanteosList.add(tanteoDto);
			}
		}

		return tanteosList;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean guardarTanteoActivo(DtoTanteoActivoExpediente tanteoActivoDto) {
		TanteoActivoExpediente tanteoActivo;

		if (tanteoActivoDto.getId() == null || tanteoActivoDto.getId().isEmpty() || !StringUtils.isNumeric(tanteoActivoDto.getId())) {
			tanteoActivo = new TanteoActivoExpediente();
			tanteoActivo.setExpediente(this.findOne(tanteoActivoDto.getEcoId()));
			tanteoActivo.setActivo(activoAdapter.getActivoById(tanteoActivoDto.getIdActivo()));

			if (Checks.esNulo(tanteoActivoDto.getCondicionesTransmision())) {
				tanteoActivo.setCondicionesTx("Comprador asume la situación física, jurídica, registral, urbanística y administrativa existente");
			}

		} else {
			tanteoActivo = genericDao.get(TanteoActivoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(tanteoActivoDto.getId())));
		}

		if (!Checks.esNulo(tanteoActivoDto.getCondicionesTransmision())) {
			tanteoActivo.setCondicionesTx(tanteoActivoDto.getCondicionesTransmision());
		}

		if (!Checks.esNulo(tanteoActivoDto.getCodigoTipoAdministracion())) {
			DDAdministracion administracion = genericDao.get(DDAdministracion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tanteoActivoDto.getCodigoTipoAdministracion()));
			if (!Checks.esNulo(administracion)) {
				tanteoActivo.setAdminitracion(administracion);
			}
		}

		if (!Checks.esNulo(tanteoActivoDto.getFechaComunicacion()) && tanteoActivoDto.getFechaComunicacion().getTime() > 0) {
			tanteoActivo.setFechaComunicacion(tanteoActivoDto.getFechaComunicacion());
		}

		if (!Checks.esNulo(tanteoActivoDto.getFechaRespuesta()) && tanteoActivoDto.getFechaRespuesta().getTime() > 0) {
			tanteoActivo.setFechaContestacion(tanteoActivoDto.getFechaRespuesta());
		}

		if (tanteoActivoDto.getNumeroExpediente() != null) {
			tanteoActivo.setNumExpediente(tanteoActivoDto.getNumeroExpediente());
		}

		if (tanteoActivoDto.getSolicitaVisita() != null && !tanteoActivoDto.getSolicitaVisita().isEmpty()) {
			if (tanteoActivoDto.getSolicitaVisita().equals("No")) {
				tanteoActivo.setSolicitudVisita(0);
			} else {
				tanteoActivo.setSolicitudVisita(1);
			}
		}

		if (tanteoActivoDto.getSolicitaVisitaCodigo() != null) {
			tanteoActivo.setSolicitudVisita(tanteoActivoDto.getSolicitaVisitaCodigo());
		}

		if (!Checks.esNulo(tanteoActivoDto.getFechaVisita()) && tanteoActivoDto.getFechaVisita().getTime() > 0) {
			tanteoActivo.setFechaVisita(tanteoActivoDto.getFechaVisita());
		}

		if (!Checks.esNulo(tanteoActivoDto.getCodigoTipoResolucion())) {
			DDResultadoTanteo resultadoTanteo = genericDao.get(DDResultadoTanteo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tanteoActivoDto.getCodigoTipoResolucion()));

			if (!Checks.esNulo(resultadoTanteo)) {
				tanteoActivo.setResultadoTanteo(resultadoTanteo);
				actualizarFVencimientoReservaTanteosRenunciados(tanteoActivo, null);
			}
		}

		if (!Checks.esNulo(tanteoActivoDto.getFechaVencimiento()) && tanteoActivoDto.getFechaVencimiento().getTime() > 0) {
			tanteoActivo.setFechaVencimientoResol(tanteoActivoDto.getFechaVencimiento());
		}

		if (!Checks.esNulo(tanteoActivoDto.getFechaResolucion()) && tanteoActivoDto.getFechaResolucion().getTime() > 0) {
			tanteoActivo.setFechaResolucion(tanteoActivoDto.getFechaResolucion());
		}

		Calendar cal;
		if (!Checks.esNulo(tanteoActivoDto.getFechaRespuesta()) && tanteoActivoDto.getFechaRespuesta().getTime() > 0 && !Checks.esNulo(tanteoActivoDto.getFechaVisita()) && tanteoActivoDto
		.getFechaVisita().getTime() > 0) {
			if (!Checks.esNulo(tanteoActivoDto.getSolicitaVisitaCodigo()) && tanteoActivoDto.getSolicitaVisitaCodigo().equals(1)) {
				if (tanteoActivoDto.getFechaSolicitudVisita() == null) {
					tanteoActivoDto.setFechaSolicitudVisita(new Date());
				}

				cal = Calendar.getInstance();
				cal.setTime(tanteoActivoDto.getFechaRespuesta());
				cal.add(Calendar.DATE, 16);

				if (tanteoActivoDto.getFechaVisita().compareTo(cal.getTime()) < 0) {
					cal = Calendar.getInstance();
					cal.setTime(tanteoActivoDto.getFechaRespuesta());
					cal.add(Calendar.DATE, 15);
					tanteoActivo.setFechaFinTanteo(cal.getTime());

				} else {
					long diferencia = tanteoActivoDto.getFechaVisita().getTime() - tanteoActivoDto.getFechaRespuesta().getTime();
					long dias = diferencia / (1000 * 60 * 60 * 24);
					cal = Calendar.getInstance();
					cal.setTime(tanteoActivoDto.getFechaRespuesta());
					cal.add(Calendar.DATE, (int) dias);
					tanteoActivo.setFechaFinTanteo(cal.getTime());
				}

			} else {
				cal = Calendar.getInstance();
				cal.setTime(tanteoActivoDto.getFechaComunicacion());
				cal.add(Calendar.MONTH, 2);
				tanteoActivo.setFechaFinTanteo(cal.getTime());
			}

		} else {
			cal = Calendar.getInstance();
			cal.setTime(tanteoActivoDto.getFechaComunicacion());
			cal.add(Calendar.MONTH, 2);
			tanteoActivo.setFechaFinTanteo(cal.getTime());
		}

		if (tanteoActivo.getId() == null) {
			genericDao.save(TanteoActivoExpediente.class, tanteoActivo);
		} else {
			genericDao.update(TanteoActivoExpediente.class, tanteoActivo);
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public void actualizarFVencimientoReservaTanteosRenunciados(TanteoActivoExpediente tanteoActivo,
			List<TanteoActivoExpediente> tanteosActivo) {
		
		Activo activo = null;
		Boolean todosRenunciados = true;
		Date fechaResolucionMayor = null;

		if (!Checks.esNulo(tanteoActivo)) {
			if (!Checks.esNulo(tanteoActivo.getResultadoTanteo()) && DDResultadoTanteo.CODIGO_RENUNCIADO.equals(tanteoActivo.getResultadoTanteo().getCodigo())) {
				if (!Checks.esNulo(tanteoActivo.getExpediente()) && !Checks.esNulo(tanteoActivo.getExpediente().getCondicionante())) {
					if ((Integer.valueOf(1).equals(tanteoActivo.getExpediente().getCondicionante().getSujetoTanteoRetracto()))) {
						List<TanteoActivoExpediente> tanteosExpediente = tanteoActivo.getExpediente().getTanteoActivoExpediente();
						if (!Checks.estaVacio(tanteosExpediente)) {
							fechaResolucionMayor = tanteosExpediente.get(0).getFechaResolucion();
						}

						for (TanteoActivoExpediente tanteo : tanteosExpediente) {
							activo = tanteo.getActivo();
							if (!Checks.esNulo(tanteo.getResultadoTanteo())) {
								if (!DDResultadoTanteo.CODIGO_RENUNCIADO.equals(tanteo.getResultadoTanteo().getCodigo())) {
									todosRenunciados = false;
									break;
								}

							} else {
								todosRenunciados = false;
								break;
							}

							Date fechaResolucion = tanteo.getFechaResolucion();
							if (!Checks.esNulo(fechaResolucionMayor) && !Checks.esNulo(fechaResolucion) && fechaResolucion.after(fechaResolucionMayor)) {
								fechaResolucionMayor = fechaResolucion;
							}
						}

						if (todosRenunciados && !Checks.esNulo(fechaResolucionMayor)) {
							Calendar calendar = Calendar.getInstance();
							calendar.setTime(fechaResolucionMayor);
							if(!Checks.esNulo(activo) && DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo())) {
								calendar.add(Calendar.DAY_OF_YEAR, NUMERO_DIAS_VENCIMIENTO_SAREB);
							}else {
								calendar.add(Calendar.DAY_OF_YEAR, NUMERO_DIAS_VENCIMIENTO);
							}
							this.actualizaFechaVencimientoReserva(tanteoActivo.getExpediente().getReserva(), calendar.getTime());

						} else {
							this.actualizaFechaVencimientoReserva(tanteoActivo.getExpediente().getReserva(), null);
						}
					}
				}

			} else {
				this.actualizaFechaVencimientoReserva(tanteoActivo.getExpediente().getReserva(), null);
			}

		} else if (!Checks.esNulo(tanteosActivo) && !Checks.estaVacio(tanteosActivo)) {
			fechaResolucionMayor = tanteosActivo.get(0).getFechaResolucion();

			for (TanteoActivoExpediente tanteo : tanteosActivo) {
				activo = tanteo.getActivo();
				if (!Checks.esNulo(tanteo.getResultadoTanteo())) {
					if (!DDResultadoTanteo.CODIGO_RENUNCIADO.equals(tanteo.getResultadoTanteo().getCodigo())) {
						todosRenunciados = false;
						break;
					}

				} else {
					todosRenunciados = false;
					break;
				}

				Date fechaResolucion = tanteo.getFechaResolucion();
				if (!Checks.esNulo(fechaResolucionMayor) && !Checks.esNulo(fechaResolucion) && fechaResolucion.after(fechaResolucionMayor)) {
					fechaResolucionMayor = fechaResolucion;
				}
			}

			if (todosRenunciados && !Checks.esNulo(fechaResolucionMayor)) {
				ExpedienteComercial expediente = tanteosActivo.get(0).getExpediente();
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(fechaResolucionMayor);
				if(!Checks.esNulo(activo) && DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo())) {
					calendar.add(Calendar.DAY_OF_YEAR, NUMERO_DIAS_VENCIMIENTO_SAREB);
				}else {
					calendar.add(Calendar.DAY_OF_YEAR, NUMERO_DIAS_VENCIMIENTO);
				}
				this.actualizaFechaVencimientoReserva(expediente.getReserva(), calendar.getTime());
			}

		}
	}

	/**
	 * Este método actualiza la fecha de vencimiento de la reserva si la reserva no es nula.
	 *
	 * @param reserva: entidad reserva.
	 * @param fechaVencimiento: fecha a actualizar en el campo fecha de vencimiento de la reserva.
	 */
	private void actualizaFechaVencimientoReserva(Reserva reserva, Date fechaVencimiento) {
		if (!Checks.esNulo(reserva)) {
			reserva.setFechaVencimiento(fechaVencimiento);
		}
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteTanteoActivo(Long idTanteo) {
		boolean resultado = false;
		TanteoActivoExpediente tanteo = genericDao.get(TanteoActivoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "id", idTanteo));

		if (tanteo.getFechaContestacion() == null) {
			genericDao.deleteById(TanteoActivoExpediente.class, idTanteo);
			resultado = true;
		}

		return resultado;
	}

	@Override
	public DtoInformeJuridico getFechaEmisionInfJuridico(Long idExpediente, Long idActivo) {
		DtoInformeJuridico dto = new DtoInformeJuridico();

		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", idExpediente);
		Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		List<InformeJuridico> listInformeJuridico = genericDao.getList(InformeJuridico.class, filtro1, filtro2);

		if (!Checks.estaVacio(listInformeJuridico)) {
			InformeJuridico informeJuridico = listInformeJuridico.get(0);

			Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "expediente.id", informeJuridico.getExpedienteComercial().getId());
			Filter filtro4 = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
			List<BloqueoActivoFormalizacion> bloqueos = genericDao.getList(BloqueoActivoFormalizacion.class, filtro3, filtro4);

			if (!Checks.esNulo(informeJuridico.getFechaEmision())) {
				// No calcular el estado del informe hasta que se haya introducido fecha de emisión.
				dto.setResultadoBloqueo(InformeJuridico.RESULTADO_FAVORABLE);

				if (!Checks.estaVacio(bloqueos)) {
					for (BloqueoActivoFormalizacion bloqueo : bloqueos) {
						if (Checks.esNulo(bloqueo.getAuditoria().getUsuarioBorrar())) dto.setResultadoBloqueo(InformeJuridico.RESULTADO_DESFAVORABLE);

					}
				}
			}

			dto.setFechaEmision(informeJuridico.getFechaEmision());
			dto.setIdActivo(informeJuridico.getActivo().getId());
			dto.setIdExpediente(informeJuridico.getExpedienteComercial().getId());

		} else {
			dto.setFechaEmision(null);
			dto.setIdActivo(idActivo);
			dto.setIdExpediente(idExpediente);
		}

		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean guardarInformeJuridico(DtoInformeJuridico dto) {
		InformeJuridico inJu =genericDao.get(InformeJuridico.class, genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", dto.getIdExpediente()),
				genericDao.createFilter(FilterType.EQUALS, "activo.id", dto.getIdActivo()));

		if (Checks.esNulo(inJu)) {
			inJu = new InformeJuridico();
			inJu.setActivo(activoAdapter.getActivoById(dto.getIdActivo()));
			inJu.setExpedienteComercial(this.findOne(dto.getIdExpediente()));
			inJu.setFechaEmision(dto.getFechaEmision());

		} else {
			if (!Checks.esNulo(dto.getFechaEmision())) {
				inJu.setFechaEmision(dto.getFechaEmision());
			}
		}

		if (inJu.getId() == null) {
			genericDao.save(InformeJuridico.class, inJu);
		} else {
			genericDao.update(InformeJuridico.class, inJu);
		}

		return true;
	}

	@Override
	public String validaBloqueoExpediente(Long idExpediente) {
		String codigoError = "";

		ExpedienteComercial expediente = this.findOne(idExpediente);
		// Validamos condiciones jurídicas.
		if (expediente.getEstadoPbc() == null || expediente.getEstadoPbc().equals(0) || expediente.getRiesgoReputacional() == null || expediente.getRiesgoReputacional().equals
		(Integer.valueOf(1)) || expediente.getConflictoIntereses() == null || expediente.getConflictoIntereses().equals(1)) {
			codigoError = "imposible.bloquear.responsabilidad.corporativa";

		} else {
			// Validamos los bloqueos
			List<ActivoOferta> activosExpediente = expediente.getOferta().getActivosOferta();
			boolean bloqueoVigente = false;

			for (ActivoOferta activoOferta : activosExpediente) {
				Activo activo = activoOferta.getPrimaryKey().getActivo();
				DtoInformeJuridico dtoInfoJuridico = this.getFechaEmisionInfJuridico(idExpediente, activo.getId());

				if (dtoInfoJuridico != null && dtoInfoJuridico.getResultadoBloqueo() != null && dtoInfoJuridico.getResultadoBloqueo().equals(InformeJuridico.RESULTADO_DESFAVORABLE)) {
					bloqueoVigente = true;
					break;
				}
			}
			if (bloqueoVigente) {
				codigoError = "imposible.bloquear.bloqueo.vigente";
			} else {
				// validamos los tanteos
				List<TanteoActivoExpediente> tanteosExpediente = expediente.getTanteoActivoExpediente();
				int contTanteos = 0;
				int contTanteosRenunciado = 0;
				for (TanteoActivoExpediente tanteo : tanteosExpediente) {
					contTanteos++;
					if (tanteo.getResultadoTanteo() != null) {
						if (tanteo.getResultadoTanteo().getCodigo().equals(DDResultadoTanteo.CODIGO_EJERCIDO)) {
							break;
						} else if (tanteo.getResultadoTanteo().getCodigo().equals(DDResultadoTanteo.CODIGO_RENUNCIADO)) {
							contTanteosRenunciado++;
						}
					}
				}

				if (contTanteos != contTanteosRenunciado) {
					codigoError = "imposible.bloquear.tanteos.vigentes";
				} else {
					// validamos condiciones
					boolean seCumplenCondiciones = true;
					for (ActivoOferta activoOferta : activosExpediente) {
						Activo activo = activoOferta.getPrimaryKey().getActivo();
						DtoCondicionesActivoExpediente condiciones = this.getCondicionesActivoExpediete(idExpediente, activo.getId());

						if (condiciones.getSituacionPosesoriaCodigo() != null && condiciones.getSituacionPosesoriaCodigoInformada() != null && condiciones.getSituacionPosesoriaCodigo().equals
						(condiciones.getSituacionPosesoriaCodigoInformada()) && condiciones.getPosesionInicial() != null && condiciones.getPosesionInicialInformada() != null & condiciones
						.getPosesionInicial().equals(condiciones.getPosesionInicialInformada()) && condiciones.getEstadoTitulo() != null && condiciones.getEstadoTituloInformada() != null &&
						condiciones.getEstadoTitulo().equals(condiciones.getEstadoTituloInformada())) {
							seCumplenCondiciones = true;

						} else {
							seCumplenCondiciones = false;
							break;
						}
					}

					if (!seCumplenCondiciones) {
						codigoError = "imposible.bloquear.condiciones";
					} else {
						// validamos fecha posicionamiento
						if (expediente.getPosicionamientos() == null || expediente.getPosicionamientos().size() < 1) {
							codigoError = "imposible.bloquear.fecha.posicionamiento";
						} else {
							// el usuario logado tiene que ser gestoria
							Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

							if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(expediente.getOferta().getActivoPrincipal().getCartera().getCodigo())) {
								if (!genericAdapter.tienePerfil(PERFIL_GESTOR_MINUTAS, usuarioLogado) && !genericAdapter.tienePerfil(PERFIL_SUPERVISOR_MINUTAS, usuarioLogado) && !genericAdapter
								.isSuper(usuarioLogado) && !genericAdapter.tienePerfil(PERFIL_GESTOR_FORMALIZACION, usuarioLogado)
								&& !genericAdapter.tienePerfil(PERFIL_GESTORIA_FORMALIZACION, usuarioLogado)) {
									codigoError = "imposible.bloquear.expediente.cajamar";

								} else {
									// la financiación tiene que estar informada
									DtoFormalizacionFinanciacion financiacion = new DtoFormalizacionFinanciacion();
									financiacion.setId(String.valueOf(idExpediente));
									financiacion = this.getFormalizacionFinanciacion(financiacion);
									if (Checks.esNulo(financiacion.getSolicitaFinanciacion())) {
										codigoError = "imposible.bloquear.financiacion.no.informada";
									}
								}

							} else {
								if (!genericAdapter.isGestoria(usuarioLogado) && !genericAdapter.isSuper(usuarioLogado) && !genericAdapter.tienePerfil(PERFIL_GESTOR_FORMALIZACION, usuarioLogado) &&
								!genericAdapter.tienePerfil(PERFIL_SUPERVISOR_FORMALIZACION, usuarioLogado)) {
									codigoError = "imposible.bloquear.no.es.gestoria";

								} else {
									// la financiación tiene que estar informada
									DtoFormalizacionFinanciacion financiacion = new DtoFormalizacionFinanciacion();
									financiacion.setId(String.valueOf(idExpediente));
									financiacion = this.getFormalizacionFinanciacion(financiacion);
									if (Checks.esNulo(financiacion.getSolicitaFinanciacion())) {
										codigoError = "imposible.bloquear.financiacion.no.informada";
									}
								}
							}
						}
					}
				}
			}
		}

		return codigoError;
	}

	@Override
	@Transactional(readOnly = false)
	public void bloquearExpediente(Long idExpediente) {
		ExpedienteComercial expediente = this.findOne(idExpediente);
		expediente.setBloqueado(1);

		genericDao.update(ExpedienteComercial.class, expediente);

		try {
			// notificamos por correo a los interesados
			Posicionamiento posicionamiento = expediente.getUltimoPosicionamiento();
			ArrayList<String> mailsPara = this.obtnerEmailsBloqueoExpediente(expediente);
			String asunto = "Bloqueo del expediente comercial ".concat(String.valueOf(expediente.getNumExpediente()));
			String cuerpo = "El expediente ".concat(String.valueOf(expediente.getNumExpediente())) + " se ha posicionado correctamente para su firma el" + " día #Fecha_posicionamiento a las " +
			 "#Hora_posicionamiento en la notaría #Notaria";

			if (posicionamiento != null) {
				DateFormat dfDia = new SimpleDateFormat("dd/MM/yyyy");
				DateFormat dfHora = new SimpleDateFormat("HH:mm");

				if (posicionamiento.getFechaPosicionamiento() != null) {
					String fechaPos = dfDia.format(posicionamiento.getFechaPosicionamiento());
					cuerpo = cuerpo.replace("#Fecha_posicionamiento", fechaPos);
					String horaPos = dfHora.format(posicionamiento.getFechaPosicionamiento());
					cuerpo = cuerpo.replace("#Hora_posicionamiento", horaPos);
				}

				if (posicionamiento.getNotario() != null) {
					cuerpo = cuerpo.replace("#Notaria", posicionamiento.getNotario().getNombre());

					if (posicionamiento.getNotario().getDireccion() != null) {
						cuerpo = cuerpo.concat(", situado en ").concat(posicionamiento.getNotario().getDireccion());
					}
				}
			}

			genericAdapter.sendMail(mailsPara, new ArrayList<String>(), asunto, cuerpo);

		} catch (Exception e) {
			logger.error("No se podido notificar por correo el bloqueo del expediente", e);
		}
	}

	@Override
	public String validaDesbloqueoExpediente(Long idExpediente) {
		String codigoError = "";
		ExpedienteComercial expediente = this.findOne(idExpediente);

		if (expediente.getEstado() != null && expediente.getEstado().getCodigo().equals(DDEstadosExpedienteComercial.VENDIDO)) {
			codigoError = "imposible.desbloquear.vendido";
		}

		return codigoError;
	}

	@Override
	@Transactional(readOnly = false)
	public void desbloquearExpediente(Long idExpediente, String motivoCodigo, String motivoDescLibre) {
		ExpedienteComercial expediente = this.findOne(idExpediente);
		DDMotivosDesbloqueo motivoDesbloqueo = null;

		if (!Checks.esNulo(expediente)) {
			expediente.setBloqueado(0);

			if (!Checks.esNulo(motivoCodigo)) {
				motivoDesbloqueo = genericDao.get(DDMotivosDesbloqueo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", motivoCodigo));

				if (!Checks.esNulo(motivoDesbloqueo)) {
					expediente.setMotivoDesbloqueo(motivoDesbloqueo);
				}
			}

			expediente.setMotivoDesbloqueoDescLibre(motivoDescLibre);
			genericDao.update(ExpedienteComercial.class, expediente);

			try {
				if ((motivoDescLibre == null || motivoDescLibre.isEmpty()) && motivoDesbloqueo != null) {
					motivoDescLibre = motivoDesbloqueo.getDescripcionLarga();
				}

				// notificamos por correo a los interesados
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				ArrayList<String> mailsPara = this.obtnerEmailsBloqueoExpediente(expediente);
				String asunto = "Desbloqueo del expediente comercial ".concat(String.valueOf(expediente.getNumExpediente()));
				String cuerpo = "El expediente ".concat(String.valueOf(expediente.getNumExpediente())) + " se ha desbloqueado por el usuario #Usuario_logado por motivo: #Motivo";

				cuerpo = cuerpo.replace("#Usuario_logado", usuarioLogado.getApellidoNombre());
				cuerpo = cuerpo.replace("#Motivo", motivoDescLibre);
				genericAdapter.sendMail(mailsPara, new ArrayList<String>(), asunto, cuerpo);

			} catch (Exception e) {
				logger.error("No se podido notificar por correo el desbloqueo del expediente", e);
			}
		}
	}

	/**
	 * Este método obtiene la dirección de email de diferentes figuras del expediente.
	 *
	 * @param expediente: entidad expediente.
	 * @return Devuelve una lista de direcciones de correo.
	 */
	private ArrayList<String> obtnerEmailsBloqueoExpediente(ExpedienteComercial expediente) {
		ArrayList<String> mailsPara = new ArrayList<String>();

		if (expediente.getOferta() != null && expediente.getOferta().getPrescriptor() != null && expediente.getOferta().getPrescriptor().getEmail() != null) {
			mailsPara.add(expediente.getOferta().getPrescriptor().getEmail());
		}

		String correoMediador = null;
		if (expediente.getTrabajo() != null && !Checks.esNulo(expediente.getTrabajo().getMediador())) {
			correoMediador = expediente.getTrabajo().getMediador().getEmail();
		}

		if (!Checks.esNulo(correoMediador)) {
			mailsPara.add(correoMediador);
		}

		if (expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null) {
			Usuario gestorActivoBackoffice = gestorActivoApi.getGestorByActivoYTipo(expediente.getOferta().getActivoPrincipal(), GestorActivoApi.CODIGO_GESTOR_BACKOFFICE);

			if (gestorActivoBackoffice != null && gestorActivoBackoffice.getEmail() != null) {
				mailsPara.add(gestorActivoBackoffice.getEmail());
			}
		}

		return mailsPara;
	}

	@Override
	public boolean checkExpedienteBloqueado(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);

		if (!Checks.esNulo(activoTramite)) {
			Trabajo trabajo = activoTramite.getTrabajo();

			if (!Checks.esNulo(trabajo)) {
				ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());
				return (new Integer(1).equals(expediente.getBloqueado()));
			}
		}

		return false;
	}

	@Override
	public boolean checkExpedienteFechaChequeLiberbank(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);
		if (!Checks.esNulo(activoTramite) && !Checks.esNulo(activoTramite.getActivo()) && !Checks.esNulo(activoTramite.getActivo().getCartera()) && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activoTramite.getActivo().getCartera().getCodigo())) {
			Trabajo trabajo = activoTramite.getTrabajo();
			if (!Checks.esNulo(trabajo)) {
				ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());
				return !Checks.esNulo(expediente.getFechaContabilizacionPropietario());
			}
		}

		return true;
	}

	public boolean reservaFirmada(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);
		if (!Checks.esNulo(activoTramite)) {
			Trabajo trabajo = activoTramite.getTrabajo();
			if (!Checks.esNulo(trabajo)) {
				ExpedienteComercial expediente = expedienteComercialDao
						.getExpedienteComercialByTrabajo(trabajo.getId());
				if (!Checks.esNulo(expediente.getReserva()) 
						&& !Checks.esNulo(expediente.getReserva().getEstadoReserva()) ){
					return expediente.getReserva().getEstadoReserva().getCodigo().equals(DDEstadosReserva.CODIGO_FIRMADA);
				}
			}
		}
		return false;
	}

	public boolean checkActivoNoFormalizar(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);
		if (!Checks.esNulo(activoTramite)) {
			Activo activo = activoTramite.getActivo();
			if (!Checks.esNulo(activo)) {
				PerimetroActivo pac = genericDao.get(PerimetroActivo.class, genericDao.createFilter(FilterType.EQUALS, "activo", activo));
				return pac.getAplicaFormalizar() == 0;
			}
		}
		return false;
	}

	@Override
	public boolean checkEstadoExpedienteDistintoAnulado(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);

		if (!Checks.esNulo(activoTramite)) {
			Trabajo trabajo = activoTramite.getTrabajo();

			if (!Checks.esNulo(trabajo)) {
				ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());

				if (!Checks.esNulo(expediente.getEstado())) {
					return DDEstadosExpedienteComercial.ANULADO.equals(expediente.getEstado().getCodigo());
				}
			}
		}

		return false;
	}

	@Override
	public boolean importeExpedienteMenorPreciosMinimosActivos(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);

		if (!Checks.esNulo(activoTramite)) {
			Trabajo trabajo = activoTramite.getTrabajo();

			if (!Checks.esNulo(trabajo) && isComiteSancionadorHaya(trabajo)) {
					ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());

					if (!Checks.esNulo(expediente)) {
						Oferta oferta = expediente.getOferta();

						if (!Checks.esNulo(oferta)) {
							Double importeExpediente = oferta.getImporteContraOferta() != null ? oferta.getImporteContraOferta() : oferta.getImporteOferta();
							List<Activo> activos = activoTramite.getActivos();
							Double precioMinimo = 0.00D;

							if (!Checks.estaVacio(activos)) {
								for (Activo activo : activos) {
									precioMinimo += activoApi.getImporteValoracionActivoByCodigo(activo, DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO);
								}
							}

							return importeExpediente < precioMinimo;
						}
					}
			}
		}

		return false;
	}

	/**
	 * Este método genera un objeto dto de decisión en base al ID de expediente que recibe.
	 *
	 * @param idExpediente: ID de la entidad expediente.
	 * @return Devuelve un objeto dto InstanciaDecisionDto.
	 * @throws Exception: Devuelve una excepción si algo no se ha procesado correctamente.
	 */
	private InstanciaDecisionDto creaInstanciaDecisionDto(Long idExpediente) throws Exception {
		try {
			ExpedienteComercial expediente = findOne(idExpediente);
			Long porcentajeImpuesto = null;

			if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getCondicionante())) {
				if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
					porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable().longValue();
				}
			}

			return expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto, null);

		} catch (JsonViewerException jve) {
			logger.info("error controlado en expedienteComercialManager", jve);
			throw jve;

		} catch (Exception e) {
			logger.error("error en expedienteComercialManager", e);
			throw e;
		}
	}

	@Override
	public void enviarTitularesUvem(Long idExpediente) throws Exception {
		InstanciaDecisionDto instancia = creaInstanciaDecisionDto(idExpediente);
		instancia.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_TITULARES);
		logger.info("------------ LLAMADA WS MOD3(TITULARES) -----------------");
		uvemManagerApi.modificarInstanciaDecisionTres(instancia);
	}


	@Override
	public void enviarHonorariosUvem(Long idExpediente) throws Exception {
		InstanciaDecisionDto instancia = creaInstanciaDecisionDto(idExpediente);
		instancia.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_HONORARIOS);
		logger.info("------------ LLAMADA WS MOD3(HONORARIOS) -----------------");
		uvemManagerApi.modificarInstanciaDecisionTres(instancia);
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateEstadosResolucionDevolucion(ExpedienteComercial expedienteComercial, ResolucionComiteDto dto) {
		DDEstadosExpedienteComercial estadoExpedienteComercial = (DDEstadosExpedienteComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class,
		DDEstadosExpedienteComercial.EN_DEVOLUCION);
		DDEstadosReserva estadoReserva = (DDEstadosReserva) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosReserva.class, DDEstadosReserva.CODIGO_PENDIENTE_DEVOLUCION);
		expedienteComercial.setEstado(estadoExpedienteComercial);

		if (!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getReserva())) {
			Reserva reserva = expedienteComercial.getReserva();
			reserva.setIndicadorDevolucionReserva(1);

			if (dto.getPenitenciales() != null && dto.getPenitenciales().equals("3")) {
				DDDevolucionReserva estadoDevolucionReserva = (DDDevolucionReserva) utilDiccionarioApi.dameValorDiccionarioByCod(DDDevolucionReserva.class, DDDevolucionReserva.CODIGO_SI_SIMPLES);
				reserva.setDevolucionReserva(estadoDevolucionReserva);
			}

			if (dto.getPenitenciales() != null && dto.getPenitenciales().equals("4")) {
				DDDevolucionReserva estadoDevolucionReserva = (DDDevolucionReserva) utilDiccionarioApi.dameValorDiccionarioByCod(DDDevolucionReserva.class, DDDevolucionReserva.CODIGO_SI_DUPLICADOS);
				reserva.setDevolucionReserva(estadoDevolucionReserva);
			}

			reserva.setEstadoReserva(estadoReserva);
		}

		return this.update(expedienteComercial);
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateEstadosResolucionNoDevolucion(ExpedienteComercial expedienteComercial, ResolucionComiteDto dto) {
		DDEstadosExpedienteComercial estadoExpedienteComercial = (DDEstadosExpedienteComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class,
		DDEstadosExpedienteComercial.ANULADO);
		expedienteComercial.setFechaVenta(null);
		DDEstadosReserva estadoReserva = (DDEstadosReserva) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosReserva.class, DDEstadosReserva.CODIGO_RESUELTA_POSIBLE_REINTEGRO);
		expedienteComercial.setEstado(estadoExpedienteComercial);

		if (!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getReserva())) {
			Reserva reserva = expedienteComercial.getReserva();
			reserva.setIndicadorDevolucionReserva(0);
			DDDevolucionReserva estadoDevolucionReserva = (DDDevolucionReserva) utilDiccionarioApi.dameValorDiccionarioByCod(DDDevolucionReserva.class, DDDevolucionReserva.CODIGO_NO);
			reserva.setDevolucionReserva(estadoDevolucionReserva);
			reserva.setEstadoReserva(estadoReserva);
		}

		return this.update(expedienteComercial);
	}

	@Override
	public DDSubcartera getCodigoSubCarteraExpediente(Long idExpediente){
		
		DDSubcartera subcartera= null;
		
		if(!Checks.esNulo(idExpediente)){
			ExpedienteComercial expediente = findOne(idExpediente);
			if(!Checks.esNulo(expediente)) {
				subcartera = expediente.getOferta().getActivosOferta().get(0).getPrimaryKey().getActivo().getSubcartera();
			}
		}

		return subcartera;
	}

	@Override
	public void enviarCondicionantesEconomicosUvem(Long idExpediente) throws Exception {
		InstanciaDecisionDto instancia = creaInstanciaDecisionDto(idExpediente);
		instancia.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_CONDICIONANTES_ECONOMICOS);
		logger.info("------------ LLAMADA WS MOD3(CONDICIONANTES ECONOMICOS) -----------------");
		uvemManagerApi.modificarInstanciaDecisionTres(instancia);
		logger.info("------------ LLAMADA WS REALIZADA CON EXITO -----------------");
	}

	@Transactional(readOnly = true)
	private GestorSustituto getGestorSustitutoVigente(GestorEntidadHistorico gestor) {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal", gestor.getUsuario());

		try {
			List<GestorSustituto> gestoresSustitutos = genericDao.getList(GestorSustituto.class, filter);

			for (GestorSustituto sustituto : gestoresSustitutos) {
				if (!Checks.esNulo(sustituto.getFechaFin())) {
					if (sustituto.getFechaFin().after(new Date()) || DateUtils.isSameDay(sustituto.getFechaFin(), new Date())) {
						return sustituto;
					}
				} else {
					return sustituto;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	@Override
	public Boolean checkFechaVenta(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);
		if (activoTramite == null) {
			return false;
		}

		Trabajo trabajo = activoTramite.getTrabajo();
		if (trabajo == null) {
			return false;
		}

		ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());
		if (expediente == null) {
			return false;
		}

		if(checkAgrupacionAsistida(activoTramite.getActivo())) {
			return true;
		}

		if(expediente.getFechaContabilizacionPropietario() != null){
			return true;
		}else{
			return false;
		}
	}

	private Boolean checkAgrupacionAsistida(Activo activo) {
		Date fechaHoy = new Date();

		try{
			if(!Checks.esNulo(activo)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo", activo);
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "agrupacion.eliminado", 0);
				List<ActivoAgrupacionActivo> lista = genericDao.getList(ActivoAgrupacionActivo.class, filtro, filtro2);
				ActivoAgrupacionActivo aga = lista.get(0);
				if(!Checks.esNulo(aga)) {
					ActivoAgrupacion agr = aga.getAgrupacion();
					if(!Checks.esNulo(agr) && DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agr.getTipoAgrupacion().getCodigo())) {
						if(fechaHoy.compareTo(agr.getFechaInicioVigencia()) >= 0 && fechaHoy.compareTo(agr.getFechaFinVigencia()) <= 0) {
							return true;
						}
					}
				}

			}

		}catch(Exception e){
			return false;
		}

		return false;
	}

	@Override
	public DtoModificarCompradores vistaADtoModCompradores (VBusquedaDatosCompradorExpediente vista){
		DtoModificarCompradores comprador = new DtoModificarCompradores();

		try {
			beanUtilNotNull.copyProperties(comprador, vista);

			comprador.setEsBH(esBH(vista.getIdExpedienteComercial()));
			comprador.setEntidadPropietariaCodigo(getCodigoCarteraExpediente(vista.getIdExpedienteComercial()));

		} catch (Exception e) {
			e.printStackTrace();
		}

		return comprador;
	}

	@Override
	public Boolean esBH(String idExpediente){
		Long id = Long.parseLong(idExpediente);

		return DDSubcartera.CODIGO_BAN_BH.equals(getCodigoSubCarteraExpediente(id).getCodigo());
	}

	@SuppressWarnings("unchecked")
	@Override
	public String getCodigoCarteraExpediente(String idExpediente) {
		Long id = Long.parseLong(idExpediente);
		String cartera= null;

		if(!Checks.esNulo(id)){
			DtoPage dto= this.getActivosExpediente(id);
			List<DtoActivosExpediente> dtosActivos= (List<DtoActivosExpediente>) dto.getResults();
			if(!Checks.estaVacio(dtosActivos)){
				Activo primerActivo = activoApi.get(dtosActivos.get(0).getIdActivo());
				if(!Checks.esNulo(primerActivo)){
					cartera = primerActivo.getCartera().getCodigo();
				}
			}
		}

		return cartera;
	}
	
	@Override
	public Long getIdByNumExpOrNumOfr(Long numBusqueda, String campo) {
		
		Long idExpediente = null;
		
		try {	
			if(ExpedienteComercialController.CAMPO_EXPEDIENTE.equals(campo)) {
				idExpediente = Long.parseLong(rawDao.getExecuteSQL("SELECT ECO_ID FROM ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE =" + numBusqueda + " AND BORRADO = 0"));	
			}else {
				Long idOferta = Long.parseLong(rawDao.getExecuteSQL("SELECT OFR_ID FROM OFR_OFERTAS WHERE OFR_NUM_OFERTA = " + numBusqueda + " AND BORRADO = 0"));
				
				idExpediente = Long.parseLong(rawDao.getExecuteSQL("SELECT ECO_ID FROM ECO_EXPEDIENTE_COMERCIAL WHERE OFR_ID = " + idOferta + " AND BORRADO = 0"));	
			}	
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	
		return idExpediente;
		
	}
	
	@Override
	public Long getNumExpByNumOfr(Long numBusqueda) {
		
		Long numExpediente = null;
		
		Long idOferta = Long.parseLong(rawDao.getExecuteSQL("SELECT OFR_ID FROM OFR_OFERTAS WHERE OFR_NUM_OFERTA = " + numBusqueda + " AND BORRADO = 0"));
		
		numExpediente = Long.parseLong(rawDao.getExecuteSQL("SELECT ECO_NUM_EXPEDIENTE FROM ECO_EXPEDIENTE_COMERCIAL WHERE OFR_ID = " + idOferta + " AND BORRADO = 0"));	
	
		return numExpediente;
		
	}
}

