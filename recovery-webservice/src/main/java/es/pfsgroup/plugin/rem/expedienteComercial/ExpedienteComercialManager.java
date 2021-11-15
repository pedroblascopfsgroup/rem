package es.pfsgroup.plugin.rem.expedienteComercial;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.lang.reflect.Field;
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
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import es.pfsgroup.plugin.rem.constants.TareaProcedimientoConstants;
import es.pfsgroup.plugin.rem.model.dd.*;
import es.pfsgroup.plugin.rem.restclient.caixabc.CexDto;
import es.pfsgroup.plugin.rem.service.InterlocutorGenericService;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.mapping.results.Success;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PageImpl;
import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelRepoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.adapter.ExpedienteComercialAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.BoardingComunicacionApi;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesApi;
import es.pfsgroup.plugin.rem.api.GastosExpedienteApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.TramitacionOfertasApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteVentaApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.bulkAdvisoryNote.dao.BulkOfertaDao;
import es.pfsgroup.plugin.rem.clienteComercial.dao.ClienteComercialDao;
import es.pfsgroup.plugin.rem.controller.ExpedienteComercialController;
import es.pfsgroup.plugin.rem.expediente.condiciones.GastoRepercutido;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.impl.UpdaterServiceSancionOfertaResolucionExpediente;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.BulkOferta.BulkOfertaPk;
import es.pfsgroup.plugin.rem.model.CompradorExpediente.CompradorExpedientePk;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDAdministracion;
import es.pfsgroup.plugin.rem.model.dd.DDAreaBloqueo;
import es.pfsgroup.plugin.rem.model.dd.DDCanalPrescripcion;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseOferta;
import es.pfsgroup.plugin.rem.model.dd.DDComiteAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDDevolucionReserva;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadFinanciera;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadesAvalistas;
import es.pfsgroup.plugin.rem.model.dd.DDEquipoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDevolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoFinanciacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGestionPlusv;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCivilesURSUS;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDFuenteTestigos;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAmpliacionArras;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosDesbloqueo;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenComprador;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoCampo;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;
import es.pfsgroup.plugin.rem.model.dd.DDRiesgoOperacion;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDSnsSiNoNosabe;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTfnTipoFinanciacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoBloqueo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInquilino;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedorHonorario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRiesgoClase;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTratamiento;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;
import es.pfsgroup.plugin.rem.model.dd.DDTiposDocumentos;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.model.dd.DDTiposTextoOferta;
import es.pfsgroup.plugin.rem.oferta.NotificationOfertaManager;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.plusvalia.NotificationPlusvaliaManager;
import es.pfsgroup.plugin.rem.reserva.dao.ReservaDao;
import es.pfsgroup.plugin.rem.rest.dao.impl.GenericaRestDaoImp;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteProblemasVentaDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDataDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaUVEMDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;
import es.pfsgroup.plugin.rem.rest.dto.ResultadoInstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.TestigosOfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularUVEMDto;
import es.pfsgroup.plugin.rem.rest.dto.WSDevolBankiaDto;
import es.pfsgroup.plugin.rem.restclient.caixabc.ReplicarOfertaDto;
import es.pfsgroup.plugin.rem.service.InterlocutorCaixaService;
import es.pfsgroup.plugin.rem.tareasactivo.ValorTareaBC;
import es.pfsgroup.plugin.rem.thread.TramitacionOfertasAsync;
import es.pfsgroup.plugin.rem.utils.FileItemUtils;

@Service("expedienteComercialManager")
public class ExpedienteComercialManager extends BusinessOperationOverrider<ExpedienteComercialApi>
		implements ExpedienteComercialApi {

	protected static final Log logger = LogFactory.getLog(ExpedienteComercialManager.class);
	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	private static final String FECHA_1970 = "1970-01-01";

	private static final String TANTEO_CONDICIONES_TRANSMISION = "msg.defecto.oferta.tanteo.condiciones.transmision";
	private static final String VISITA_SIN_RELACION_OFERTA = "oferta.validacion.numVisita";
	private static final String PROVEDOR_NO_EXISTE_O_DISTINTO_TIPO = "El proveedor indicado no existe, o no es del tipo indicado";
	private static final int NUMERO_DIAS_VENCIMIENTO = 45;
	private static final String PERFIL_GESTOR_FORMALIZACION = "HAYAGESTFORM";
	private static final String PERFIL_GESTORIA_FORMALIZACION = "GESTIAFORM";
	private static final String PERFIL_SUPERVISOR_FORMALIZACION = "HAYASUPFORM";
	private static final String PERFIL_GESTOR_MINUTAS = "GESMIN";
	private static final String PERFIL_SUPERVISOR_MINUTAS = "SUPMIN";
	private static final String TAR_INFORME_JURIDICO = "Informe jurídico";
	private static final String PESTANA_FICHA = "ficha";
	private static final String PESTANA_DATOSBASICOS_OFERTA = "datosbasicosoferta";
	private static final String PESTANA_TANTEO_Y_RETRACTO_OFERTA = "ofertatanteoyretracto";
	private static final String PESTANA_RESERVA = "reserva";
	private static final String PESTANA_CONDICIONES = "condiciones";
	private static final String PESTANA_GARANTIAS = "garantias";
	private static final String PESTANA_FORMALIZACION = "formalizacion";
	private static final String PESTANA_SEGURO_RENTAS = "segurorentasexpediente";
	private static final String PESTANA_PLUSVALIA = "plusvalia";
	private static final String PESTANA_SCORING = "scoring";
	private static final String PESTANA_DOCUMENTOS = "documentos";
	private static final String FECHA_SEGURO_RENTA = "Fecha seguro de renta";
	private static final String FECHA_SCORING = "Fecha Scoring";
	private static final String NO_MOSTRAR = "null";
	private static final String ESTADO_PROCEDIMIENTO_FINALIZADO = "11";
	private static final String STR_MISSING_VALUE = "---";
	public static final Integer NUMERO_DIAS_VENCIMIENTO_SAREB = 40;
	private static final String DESCRIPCION_COMITE_HAYA = "Haya";
	private static final String PROBLEMA = "Problema";
	private static final String AVISO = "Aviso";
	private static final String TITULAR_NO_CLIENTE_URSUS = "TITULAR NO CLIENTE EN URSUS";
	private static final String OFERTA_SIN_GESTOR_COMERCIAL_ASIGNADO = "Oferta sin gestor comercial asignado, revise la parametrización";
	private static final String OFERTA_NA_LOTE = "N/A lote";
	private static final String OFERTA_DICCIONARIO_CODIGO_NULO = "0";
	private static final String RELACION_TIPO_DOCUMENTO_EXPEDIENTE = "d-e";
	private static final String OPERACION_ALTA = "Alta";

	// Codigo Estdo Civil URSUS
	private static final String DESCONOCIDO = "5";
	private static final String SOLTERO = "1";
	private static final String CASADO = "2";
	private static final String VIUDO = "4";
	private static final String SEPARADO_LEGAL = "6";
	private static final String RELIGIOSO = "7";
	private static final String DIVORCIADO = "3";
	private static final String NULIDAD_MATRIMONIAL = "8";

	// No existe ese código en REM
	private static final String NO_EXISTE_CODIGO_REM = "NoExisteEseCodigoEnRem";

	// Tareas
	private static final String T013_RESOLUCION_COMITE = "T013_ResolucionComite";
	private static final String T013_CIERRE_ECONOMICO = "T013_CierreEconomico";
	private static final String T017_CIERRE_ECONOMICO = "T017_CierreEconomico";
	private static final String T013_DEFINICION_OFERTA = "T013_DefinicionOferta";
	
	private static final String MENSAJE_BC = "Para el número del inmueble BC: ";
	private static final String CODIGO_TRAMITE_T015 = "T015";
	private static final String CODIGO_TRAMITE_T018 = "T018";

	private final String PERFIL_HAYASUPER = "HAYASUPER";
	private final String PERFIL_PERFGCONTROLLER = "PERFGCONTROLLER";
	private final String FUNCION_EDITAR_TAB_GESTION = "EDITAR_TAB_GESTION_ECONOMICA_EXPEDIENTES";
	private final String FUNCION_AV_ECO_BLOQ = "AV_ECO_BLOQ";
	
	private static final String COMPRADOR_BLOQUEADO = "compradorBloqueado";

	@Resource
	private MessageService messageServices;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private ReservaDao reservaDao;

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;

	@Autowired
	private ExpedienteComercialAdapter expedienteComercialAdapter;

	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private ActivoManager activoManager;

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

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private OfertaDao ofertaDao;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Resource
	private Properties appProperties;

	@Autowired
	private ActivoTareaExternaApi activoTareaExternaManagerApi;

	@Override
	public String managerName() {
		return "expedienteComercialManager";
	}

	@Autowired
	private MSVRawSQLDao rawDao;

	@Autowired
	private List<ExpedienteAvisadorApi> avisadores;

	@Autowired
	private ClienteComercialDao clienteComercialDao;

	@Autowired
	private GencatApi gencatApi;

	@Autowired
	private GenericaRestDaoImp genericaRestDaoImp;

	@Autowired
	private GastosExpedienteApi gastosExpedienteApi;

	@Autowired
	private NotificationPlusvaliaManager notificationPlusvaliaManager;
	
	@Autowired
	private FuncionesApi funcionApi;

	@Autowired
	private BulkOfertaDao bulkOfertaDao;
	
	@Autowired
	private TramitacionOfertasApi tramitacionOfertasManager;
	
	@Autowired
	private GestorActivoApi gestorActivoManager;

	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

	@Autowired
	private AgendaAdapter agendaAdapter;
	
	@Autowired
	private TramiteVentaApi tramiteVentaApi;
	
	@Autowired
	private TramiteAlquilerApi tramiteAlquilerApi;
	
	@Autowired
	private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
	
	@Autowired
	private BoardingComunicacionApi boardingComunicacionApi;

	@Autowired
	private InterlocutorGenericService interlocutorGenericService;
	
	@Override
	public ExpedienteComercial findOne(Long id) {
		return expedienteComercialDao.get(id);
	}

	@Autowired
	InterlocutorCaixaService interlocutorCaixaService;

	@Autowired
	ParticularValidatorApi particularValidatorApi;

	@Override
	public ExpedienteComercial findOneTransactional(Long id) {
		TransactionStatus transaction = null;
		ExpedienteComercial expediente = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			expediente = this.findOne(id);
			transactionManager.commit(transaction);
		} catch (Exception e) {
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
	public FileItem getAdvisoryNote() {
		FileItem advisoryNote = FileItemUtils.fromResource("docs/AN_Template_Modificada_MO.xlsx");
		advisoryNote.setFileName("AN_Template_Modificada_MO.xlsx");
		advisoryNote.setContentType(ExcelRepoApi.TIPO_EXCEL);

		return advisoryNote;
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
		boolean resultado = false;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);
		if (expediente.getComiteSancion() != null
				&& expediente.getComiteSancion().getDescripcion().trim().equals(DESCRIPCION_COMITE_HAYA)) {
			resultado = true;
		}

		return resultado;
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
		} else if (PESTANA_PLUSVALIA.equals(tab)) {
			dto = expedienteToDtoPlusvaliaVenta(expediente);
		} else if (PESTANA_SEGURO_RENTAS.equals(tab)) {
			dto = expedienteToDtoSeguroRentas(expediente);
		} else if (PESTANA_SCORING.equals(tab)) {
			dto = expedienteToDtoScoring(expediente);
		} else if (PESTANA_DOCUMENTOS.equals(tab)) {
			dto = expedienteToDtoDocumentos(expediente);
		} else if (PESTANA_GARANTIAS.equals(tab)) {
			dto = expedienteToDtoGarantias(expediente);
		}

		return dto;
	}

	@Override
	public List<DtoTextosOferta> getListTextosOfertaById(Long idExpediente) {
		ExpedienteComercial expediente = findOne(idExpediente);
		Oferta oferta = expediente.getOferta();
		List<Dictionary> tiposTexto = genericAdapter.getDiccionario("tiposTextoOferta");
		Long idOferta = null;
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

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
			
			Date recoDC = textoOferta.getTipoTexto().getCodigo().equals(DDTiposTextoOferta.TIPOS_TEXTO_OFERTA_RECOMENDACION_DC) ? oferta.getOfrFechaRecomendacionDc(): null;
			Date recoRC = textoOferta.getTipoTexto().getCodigo().equals(DDTiposTextoOferta.TIPOS_TEXTO_OFERTA_RECOMENDACION_RC) ? oferta.getOfrFechaRecomendacionRc() : null;
			
			String fecha = "-";
			if (!Checks.esNulo(recoDC)) {
				fecha = sdf.format(recoDC).toString();
			} else if(!Checks.esNulo(recoRC)){
				fecha = sdf.format(recoRC).toString();
			}
			texto.setFecha(!Checks.esNulo(textoOferta.getFecha()) ? sdf.format(textoOferta.getFecha()).toString() : fecha);
				
			textos.add(texto);
			// Solamente habrá un tipo de texto por oferta, de esta manera conseguimos tener
			// en la lista todos los tipos, tengan valor o no.
			tiposTexto.remove(textoOferta.getTipoTexto());
		}

		// Añadimos los tipos que no han sido nunca creados para esta oferta
		long contador = -1L;
		for (Dictionary tipoTextoOferta : tiposTexto) {
			DtoTextosOferta texto = new DtoTextosOferta();
			texto.setId(contador--);
			texto.setCampoDescripcion(tipoTextoOferta.getDescripcion());
			texto.setCampoCodigo(tipoTextoOferta.getCodigo());
			texto.setFecha("-");
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
	public boolean saveTextoOferta(DtoTextosOferta dto, Long idEntidad) throws UserException {
		TextosOferta textoOferta;

		ExpedienteComercial expedienteComercial = findOne(idEntidad);
		Oferta oferta = expedienteComercial.getOferta();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy"); 
		Date fecha = null;
		
		try {
			fecha = sdf.parse(dto.getFecha());
		} catch (ParseException e) {
			logger.error(e.getMessage());
		}

		if (dto.getId() < 0) {
			// Estamos creando un texto que no existía.
			textoOferta = new TextosOferta();
			textoOferta.setOferta(oferta);
			if (dto.getTexto() != null && dto.getTexto().length() > 2048) {
				throw new UserException("La longitud del texto no puede exceder los 2048 car&acute;cteres");
			}
			textoOferta.setTexto(dto.getTexto());
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCampoCodigo());
			DDTiposTextoOferta tipoTexto = genericDao.get(DDTiposTextoOferta.class, filtro);
			textoOferta.setTipoTexto(tipoTexto);
			textoOferta.setFecha(fecha);

		} else {
			// Modificamos un texto existente
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getId());
			textoOferta = genericDao.get(TextosOferta.class, filtro);
			textoOferta.setTexto(dto.getTexto());
			textoOferta.setFecha(fecha);
		}

		genericDao.save(TextosOferta.class, textoOferta);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveSeguroRentasExpediente(DtoSeguroRentas dto, Long idEntidad) {

		SeguroRentasAlquiler seguro = null;
		ExpedienteComercial expedienteComercial = findOne(idEntidad);

		if (expedienteComercial != null && expedienteComercial.getId() != null) {
			Filter filtroSeg = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expedienteComercial.getId());
			seguro = genericDao.get(SeguroRentasAlquiler.class, filtroSeg);
		}

		if (seguro == null) {
			seguro = new SeguroRentasAlquiler();
			seguro.setExpediente(expedienteComercial);
		}
		if (dto.getRevision() != null) {
			seguro.setEnRevision(dto.getRevision());
		}
		if (dto.getEstado() != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstado());
			DDResultadoCampo estadoSeguroRentas = genericDao.get(DDResultadoCampo.class, filtro);
			seguro.setResultadoSeguroRentas(estadoSeguroRentas);
		}
		if (dto.getEmailPoliza() != null) {
			seguro.setEmailPolizaAseguradora(dto.getEmailPoliza());
		}
		if (dto.getAseguradoras() != null) {
			seguro.setAseguradoras(dto.getAseguradoras());
		}
		if (dto.getComentarios() != null) {
			seguro.setComentarios(dto.getComentarios());
		}
		if (seguro.getId() != null) {
			try {
				genericDao.update(SeguroRentasAlquiler.class, seguro);
			} catch (Exception e) {
				logger.error("error en expedienteComercialManager", e);
			}
		} else {
			try {
				genericDao.save(SeguroRentasAlquiler.class, seguro);
			} catch (Exception e) {
				logger.error("error en expedienteComercialManager", e);
			}
		}
		return true;
	}

	@Override
	public List<GastosExpediente> getListaGastosExpedienteByIdExpediente(Long idExpediente) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		List<GastosExpediente> gastosExpediente = genericDao.getList(GastosExpediente.class, filtro);

		return gastosExpediente;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveDatosBasicosOferta(DtoDatosBasicosOferta dto, Long idExpediente) throws IllegalAccessException, InvocationTargetException {
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		Oferta oferta = expedienteComercial.getOferta();
		Visita visitaOferta = oferta.getVisita();
		Oferta ofertaPrincipal = null;
		DDClaseOferta claseOferta = null;
		DDRiesgoOperacion riesgoOperacion = null;
		Usuario usuarioModificador = genericAdapter.getUsuarioLogado();
		boolean pdteDocu = false;
		if(DDEstadoOferta.CODIGO_PENDIENTE_TITULARES.equals(dto.getEstadoCodigo())) {
			return false;
		}
		if(!Checks.esNulo(dto.getClaseOfertaCodigo())) {
			Filter f = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getClaseOfertaCodigo());
			claseOferta = genericDao.get(DDClaseOferta.class, f);
			
			if(Checks.esNulo(oferta.getClaseOferta()) && !Checks.esNulo(claseOferta))
				oferta.setClaseOferta(claseOferta);
		}
		
		if(dto.getNuevoNumOferPrincipal() != null) {
			ofertaPrincipal = ofertaApi.getOfertaByNumOfertaRem(dto.getNuevoNumOferPrincipal());
		}
		
		if(ofertaPrincipal != null) {
			compruebaEstadoAnyadirDependiente(ofertaPrincipal);
		}
		
		if(!Checks.esNulo(dto.getVentaCarteraCfv())) {
			oferta.setVentaCartera(dto.getVentaCarteraCfv());
		}
		
		if(!Checks.esNulo(dto.getOfertaEspecial())) {
			oferta.setOfertaEspecial(dto.getOfertaEspecial());
		}
		
		if(!Checks.esNulo(dto.getVentaSobrePlano())) {
			oferta.setVentaSobrePlano(dto.getVentaSobrePlano());
		}
		
		if(!Checks.esNulo(dto.getRiesgoOperacionCodigo())) {
			Filter r = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getRiesgoOperacionCodigo());
			riesgoOperacion = genericDao.get(DDRiesgoOperacion.class, r);
			
			if(riesgoOperacion != null) {
				oferta.setRiesgoOperacion(riesgoOperacion);
			}
		}

		if (!Checks.esNulo(dto.getEstadoCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoCodigo());
			DDEstadoOferta estado = genericDao.get(DDEstadoOferta.class, filtro);
			oferta.setEstadoOferta(estado);
			if (Checks.esNulo(oferta.getFechaOfertaPendiente()) 
					&& DDEstadoOferta.CODIGO_PENDIENTE.equals(estado.getCodigo())) oferta.setFechaOfertaPendiente(new Date());
			if (DDEstadoOferta.CODIGO_RECHAZADA.equals(dto.getEstadoCodigo())) {
				Activo act=expedienteComercial.getOferta().getActivoPrincipal();
				List<ActivoOferta> ofertasActivo=act.getOfertas();
				for(ActivoOferta ofer : ofertasActivo) {
					Long idOferta= ofer.getOferta();
					if(!idOferta.equals(oferta.getId())) {
						Oferta o = ofertaApi.getOfertaById(idOferta);
						DDEstadoOferta estOferta = o.getEstadoOferta();
						if (DDEstadoOferta.CODIGO_CONGELADA.equals(estOferta.getCodigo())) {
							Filter fil = genericDao.createFilter(FilterType.EQUALS, "codigo",
									DDEstadoOferta.CODIGO_PENDIENTE);
							if (DDCartera.isCarteraBk(act.getCartera()) && (Checks.esNulo(o.getCheckDocumentacion())
								|| !o.getCheckDocumentacion())) {
								fil = genericDao.createFilter(FilterType.EQUALS, "codigo",DDEstadoOferta.CODIGO_PDTE_DOCUMENTACION);
								pdteDocu = true;
							}
							DDEstadoOferta est = genericDao.get(DDEstadoOferta.class, fil);
							o.setEstadoOferta(est);
							if (Checks.esNulo(o.getFechaOfertaPendiente())) o.setFechaOfertaPendiente(new Date());
							genericDao.save(Oferta.class, o);
							if (pdteDocu) ofertaApi.llamadaPbc(o);
						}
					}
				}

				if (!Checks.esNulo(oferta.getAgrupacion())) {
					ActivoAgrupacion agrupacion = oferta.getAgrupacion();
					List<Oferta> ofertasVivasAgrupacion = ofertaDao.getListOtrasOfertasVivasAgr(oferta.getId(), agrupacion.getId());

					if ((agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA)
							|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER))
							&& !Checks.esNulo(ofertasVivasAgrupacion) && ofertasVivasAgrupacion.isEmpty()) {
						agrupacion.setFechaBaja(new Date());
						activoAgrupacionApi.saveOrUpdate(agrupacion);
					} 
				}

			}
		}
		//En este array se van a introducir las ofertas afectadas en los cambios de clases de ofertas de LBK pra recalcular su comite sancionador tomando en cuenta las modificaciones
		List<Oferta> listaOfertasLBK = new ArrayList<Oferta>();
		// Si estoy en una oferta dependiente que pasa a ser dependiente de otra oferta.
		if (Checks.esNulo(dto.getClaseOfertaCodigo())) {			
			if (!Checks.esNulo(dto.getNumOferPrincipal())) {
				try {				
					Oferta nuevaOfertaPrincipal = ofertaApi.getOfertaByNumOfertaRem(dto.getNumOferPrincipal());
										
					if(!Checks.esNulo(nuevaOfertaPrincipal)) {	
						if(!ofertaApi.ofertaConActivoYaIncluidoEnOfertaAgrupadaLbk(oferta, nuevaOfertaPrincipal))
						{
							// Si la nueva oferta principal es Individual, la cambio a principal.
							if(nuevaOfertaPrincipal.getClaseOferta().getCodigo().equals(DDClaseOferta.CODIGO_OFERTA_INDIVIDUAL)) {
								Filter filtroClaseOfertaPrincipal = genericDao.createFilter(FilterType.EQUALS, "codigo", DDClaseOferta.CODIGO_OFERTA_PRINCIPAL);
								DDClaseOferta claseOfertaPrincipal = genericDao.get(DDClaseOferta.class, filtroClaseOfertaPrincipal);						
								nuevaOfertaPrincipal.setClaseOferta(claseOfertaPrincipal);
								genericDao.update(Oferta.class, nuevaOfertaPrincipal);
							}					
							// Si la nueva oferta principal es Dependiente, la sacamos de la agrupacion actual y la convertimos en Principal.
							else if(nuevaOfertaPrincipal.getClaseOferta().getCodigo().equals(DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE)) {
								Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "ofertaDependiente.id", nuevaOfertaPrincipal.getId());	
								Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
								OfertasAgrupadasLbk ofertaAgrupadaLbk = genericDao.get(OfertasAgrupadasLbk.class, filtroId, filtroBorrado);
								
								//Nos guardamos la antigua oferta principal para poder calcular su comité despues de hacer los cambios
								listaOfertasLBK.add(ofertaAgrupadaLbk.getOfertaPrincipal());
								
								//Nos guardamos la antigua oferta principal de la oferta dependiente
								Filter filtroId2 = genericDao.createFilter(FilterType.EQUALS, "ofertaDependiente.id", oferta.getId());	
								Filter filtroBorrado2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
								OfertasAgrupadasLbk ofertaAgrupadaLbk2 = genericDao.get(OfertasAgrupadasLbk.class, filtroId2, filtroBorrado2);
								listaOfertasLBK.add(ofertaAgrupadaLbk2.getOfertaPrincipal());
								
								
								Auditoria auditoria = ofertaAgrupadaLbk.getAuditoria();
								auditoria.setBorrado(true);
								auditoria.setFechaBorrar(new Date());
								auditoria.setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
								ofertaAgrupadaLbk.setAuditoria(auditoria);					
								genericDao.update(OfertasAgrupadasLbk.class, ofertaAgrupadaLbk);							
								
								Filter filtroClaseOfertaPrincipal = genericDao.createFilter(FilterType.EQUALS, "codigo", DDClaseOferta.CODIGO_OFERTA_PRINCIPAL);
								DDClaseOferta claseOfertaPrincipal = genericDao.get(DDClaseOferta.class, filtroClaseOfertaPrincipal);						
								nuevaOfertaPrincipal.setClaseOferta(claseOfertaPrincipal);
								genericDao.update(Oferta.class, nuevaOfertaPrincipal);
							}
	
							// Ponemos borrado a 1 en la tabla relacional para sacarla de la agrupacion actual.
							Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "ofertaDependiente.id", oferta.getId());	
							Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
							OfertasAgrupadasLbk ofertaAgrupadaLbk = genericDao.get(OfertasAgrupadasLbk.class, filtroId, filtroBorrado);
							Auditoria auditoria = ofertaAgrupadaLbk.getAuditoria();
							auditoria.setBorrado(true);
							auditoria.setFechaBorrar(new Date());
							auditoria.setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
							ofertaAgrupadaLbk.setAuditoria(auditoria);					
							genericDao.update(OfertasAgrupadasLbk.class, ofertaAgrupadaLbk);
	
							// Creamos el nuevo registro en la tabla relacional para insertar la oferta a la otra agrupación.
							OfertasAgrupadasLbk nuevaOfertaAgrupadaLbk = new OfertasAgrupadasLbk();
							nuevaOfertaAgrupadaLbk.setOfertaDependiente(oferta);
							nuevaOfertaAgrupadaLbk.setOfertaPrincipal(nuevaOfertaPrincipal);						
							genericDao.save(OfertasAgrupadasLbk.class, nuevaOfertaAgrupadaLbk);
							//Nueva oferta principal
							listaOfertasLBK.add(nuevaOfertaPrincipal);
						}
						else {
							logger.error("La oferta que se está intentando introducir tiene un activo ya contenido en la agrupación.");
							return false;
						}
					} else {
						logger.error("La oferta introducida no existe.");
						return false;
					}
				} catch (Exception ex) {
					logger.error("Error al intentar cambiar la oferta principal.", ex);
					return false;
				}
			}
		}else if (!Checks.esNulo(dto.getClaseOfertaCodigo())){
			//Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getClaseOfertaCodigo());
			//DDClaseOferta dtoClaseOferta = genericDao.get(DDClaseOferta.class, filtro);
			
			// Si estoy en una oferta individual
			if (DDClaseOferta.CODIGO_OFERTA_INDIVIDUAL.equals(oferta.getClaseOferta().getCodigo())) {
				// Si estoy en una oferta individual que pasa a ser a principal
				if(DDClaseOferta.CODIGO_OFERTA_PRINCIPAL.equals(dto.getClaseOfertaCodigo())) {
					try {
						if(!Checks.esNulo(claseOferta))
							oferta.setClaseOferta(claseOferta);
					} catch (Exception ex) {
						logger.error("Error al intentar cambiar una oferta individual a principal.", ex);
						return false;
					}
				}
				// Si estoy en una oferta individual que pasa a ser dependiente
				else if(DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(dto.getClaseOfertaCodigo())) {
					try {							
						Oferta nuevaOfertaPrincipal = ofertaApi.getOfertaByNumOfertaRem(dto.getNuevoNumOferPrincipal());
						if(!Checks.esNulo(nuevaOfertaPrincipal)) {
							if(!ofertaApi.ofertaConActivoYaIncluidoEnOfertaAgrupadaLbk(oferta, nuevaOfertaPrincipal))
							{
								// Si la nueva oferta principal es Individual, la cambio a principal.
								if(nuevaOfertaPrincipal.getClaseOferta().getCodigo().equals(DDClaseOferta.CODIGO_OFERTA_INDIVIDUAL)) {
									Filter filtroClaseOfertaPrincipal = genericDao.createFilter(FilterType.EQUALS, "codigo", DDClaseOferta.CODIGO_OFERTA_PRINCIPAL);
									DDClaseOferta claseOfertaPrincipal = genericDao.get(DDClaseOferta.class, filtroClaseOfertaPrincipal);						
									nuevaOfertaPrincipal.setClaseOferta(claseOfertaPrincipal);
									genericDao.update(Oferta.class, nuevaOfertaPrincipal);
								}					
								// Si la nueva oferta principal es Dependiente, la sacamos de la agrupacion actual y la convertimos en Principal.
								else if(nuevaOfertaPrincipal.getClaseOferta().getCodigo().equals(DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE)) {
									Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "ofertaDependiente.id", nuevaOfertaPrincipal.getId());	
									Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
									OfertasAgrupadasLbk ofertaAgrupadaLbk = genericDao.get(OfertasAgrupadasLbk.class, filtroId, filtroBorrado);
									
									//Para recalcular el comite de la agrupacion de ofertas a la que se le extrae la oferta dependiente que será la nueva principal
									listaOfertasLBK.add(ofertaAgrupadaLbk.getOfertaPrincipal());
									
									Auditoria auditoria = ofertaAgrupadaLbk.getAuditoria();
									auditoria.setBorrado(true);
									auditoria.setFechaBorrar(new Date());
									auditoria.setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
									ofertaAgrupadaLbk.setAuditoria(auditoria);					
									genericDao.update(OfertasAgrupadasLbk.class, ofertaAgrupadaLbk);							
									
									Filter filtroClaseOfertaPrincipal = genericDao.createFilter(FilterType.EQUALS, "codigo", DDClaseOferta.CODIGO_OFERTA_PRINCIPAL);
									DDClaseOferta claseOfertaPrincipal = genericDao.get(DDClaseOferta.class, filtroClaseOfertaPrincipal);						
									nuevaOfertaPrincipal.setClaseOferta(claseOfertaPrincipal);
									genericDao.update(Oferta.class, nuevaOfertaPrincipal);
								}
								
								// Creamos el nuevo registro en la tabla relacional para insertar la oferta a la otra agrupación.
								if(!Checks.esNulo(claseOferta))
									oferta.setClaseOferta(claseOferta);
								OfertasAgrupadasLbk nuevaOfertaAgrupadaLbk = new OfertasAgrupadasLbk();
								nuevaOfertaAgrupadaLbk.setOfertaDependiente(oferta);
								nuevaOfertaAgrupadaLbk.setOfertaPrincipal(nuevaOfertaPrincipal);							
								genericDao.save(OfertasAgrupadasLbk.class, nuevaOfertaAgrupadaLbk);

								//Nueva oferta principal 
								listaOfertasLBK.add(nuevaOfertaPrincipal);
							}
							else {
								logger.error("La oferta que se está intentando introducir tiene un activo ya contenido en la agrupación.");
								return false;
							}
						} else {
							logger.error("La oferta introducida no existe.");
							return false;
						}
					} catch (Exception ex) {
						logger.error("Error al intentar cambiar una oferta individual a dependiente.", ex);
						return false;
					}
				}			
			} 
			// Si estoy en una oferta dependiente
			else if (DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(oferta.getClaseOferta().getCodigo())) {
				//Si estoy en una oferta dependiente que pasa a ser individual
				if(DDClaseOferta.CODIGO_OFERTA_INDIVIDUAL.equals(dto.getClaseOfertaCodigo())) {
					try {
						if(!Checks.esNulo(claseOferta))
							oferta.setClaseOferta(claseOferta);
						
						// Ponemos borrado a 1 en la tabla relacional para sacarla de la agrupacion actual.
						Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "ofertaDependiente.id", oferta.getId());	
						Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
						OfertasAgrupadasLbk ofertaAgrupadaLbk = genericDao.get(OfertasAgrupadasLbk.class, filtroId, filtroBorrado);
						
						Oferta ofrPrincipal = ofertaAgrupadaLbk.getOfertaPrincipal();
						
						//Nos guardamos la oferta principal de la agrupacion de ofertas a la que pertenecia la oferta dependiente para recalcular su comité
						listaOfertasLBK.add(ofertaAgrupadaLbk.getOfertaPrincipal());
						
						Auditoria auditoria = ofertaAgrupadaLbk.getAuditoria();
						auditoria.setBorrado(true);
						auditoria.setFechaBorrar(new Date());
						auditoria.setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
						ofertaAgrupadaLbk.setAuditoria(auditoria);					
						genericDao.update(OfertasAgrupadasLbk.class, ofertaAgrupadaLbk);
						
						ofertaApi.calculoComiteLBK(ofrPrincipal.getId(), null);
						
						//Recalculamos el comite de la oferta que ha salido de la agrupacion
						listaOfertasLBK.add(oferta);			
					} catch (Exception ex) {
						logger.error("Error al intentar cambiar una oferta dependiente a individual.", ex);
						return false;
					} 
				}
				//Si estoy en una oferta dependiente que pasa a ser principal
				else if(DDClaseOferta.CODIGO_OFERTA_PRINCIPAL.equals(dto.getClaseOfertaCodigo())) {
					try {
						if(!Checks.esNulo(claseOferta))
							oferta.setClaseOferta(claseOferta);
						
						// Ponemos borrado a 1 en la tabla relacional para sacarla de la agrupacion actual.
						Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "ofertaDependiente.id", oferta.getId());	
						Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
						OfertasAgrupadasLbk ofertaAgrupadaLbk = genericDao.get(OfertasAgrupadasLbk.class, filtroId, filtroBorrado);						
						
						//Nos guardamos la oferta principal de la agrupacion de ofertas a la que pertenecia la oferta dependiente para recalcular su comité
						listaOfertasLBK.add(ofertaAgrupadaLbk.getOfertaPrincipal());
										
						Auditoria auditoria = ofertaAgrupadaLbk.getAuditoria();
						auditoria.setBorrado(true);
						auditoria.setFechaBorrar(new Date());
						auditoria.setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
						ofertaAgrupadaLbk.setAuditoria(auditoria);					
						genericDao.update(OfertasAgrupadasLbk.class, ofertaAgrupadaLbk);			

						//Recalculamos el comite de la oferta que ha salido de la agrupacion
						listaOfertasLBK.add(oferta);	
					} catch (Exception ex) {
						logger.error("Error al intentar cambiar una oferta dependiente a principal.", ex);
						return false;
					} 
				}
			} 
			// Si estoy en una oferta principal
			else if (DDClaseOferta.CODIGO_OFERTA_PRINCIPAL.equals(oferta.getClaseOferta().getCodigo())) {
				//Si estoy en una oferta principal que pasa a ser individual
				if (DDClaseOferta.CODIGO_OFERTA_INDIVIDUAL.equals(dto.getClaseOfertaCodigo())) {
					try {	
						// Comprobamos que la oferta no tenga ofertas dependientes
						Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "ofertaPrincipal.id", oferta.getId());	
						Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
						List<OfertasAgrupadasLbk> ofertasAgrupadasLbk = genericDao.getList(OfertasAgrupadasLbk.class, filtroId, filtroBorrado);
						
						if(ofertasAgrupadasLbk.size() > 0) {
							throw new JsonViewerException("La oferta no puede cambiar a individual si tiene ofertas dependientes.");
						}
						
						if(!Checks.esNulo(claseOferta))
							oferta.setClaseOferta(claseOferta);						
					}catch (Exception ex) {
						logger.error("Error al intentar cambiar una oferta principal a individual.", ex);
						return false;
					}
				}
				//Si estoy en una oferta principal que pasa a ser dependiente
				else if(DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(dto.getClaseOfertaCodigo())) {
					try {											
						Oferta nuevaOfertaPrincipal = ofertaApi.getOfertaByNumOfertaRem(dto.getNuevoNumOferPrincipal());
						if(!Checks.esNulo(nuevaOfertaPrincipal)) {
							//Comprobamos si la oferta principal que va a pasar a dependiente tiene ofertas que dependan de esta o no.
							Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "ofertaPrincipal.id", oferta.getId());	
							Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);	
							List<OfertasAgrupadasLbk> ofertasAgrupadasLbk = genericDao.getList(OfertasAgrupadasLbk.class, filtroId, filtroBorrado);						
							
							// Si la oferta que va a pasar a dependiente no tiene ninguna oferta que dependa de ella, la hacemos dependiente de la nueva oferta principal.
							if(ofertasAgrupadasLbk.size() == 0){
								if(!ofertaApi.ofertaConActivoYaIncluidoEnOfertaAgrupadaLbk(oferta, nuevaOfertaPrincipal))
								{
									// Si la nueva oferta principal es Individual, la cambio a principal.
									if(nuevaOfertaPrincipal.getClaseOferta().getCodigo().equals(DDClaseOferta.CODIGO_OFERTA_INDIVIDUAL)) {
										Filter filtroClaseOfertaPrincipal = genericDao.createFilter(FilterType.EQUALS, "codigo", DDClaseOferta.CODIGO_OFERTA_PRINCIPAL);
										DDClaseOferta claseOfertaPrincipal = genericDao.get(DDClaseOferta.class, filtroClaseOfertaPrincipal);						
										nuevaOfertaPrincipal.setClaseOferta(claseOfertaPrincipal);
										genericDao.update(Oferta.class, nuevaOfertaPrincipal);	
																			
										if(!Checks.esNulo(claseOferta))
											oferta.setClaseOferta(claseOferta);
										
										//Recalculamos el comite de la nueva oferta principal y de la nueva dependiente
										listaOfertasLBK.add(nuevaOfertaPrincipal);	
									}					
									// Si la nueva oferta principal es Dependiente, la sacamos de la agrupacion actual y la convertimos en Principal.
									else if(nuevaOfertaPrincipal.getClaseOferta().getCodigo().equals(DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE)) {									
										OfertasAgrupadasLbk ofertaAgrupadaLbk = genericDao.get(OfertasAgrupadasLbk.class, 
												genericDao.createFilter(FilterType.EQUALS, "ofertaDependiente.id", nuevaOfertaPrincipal.getId()), 
												genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
										
										//Nos guardamos la antigua oferta principal para recalcular el comite de sus ofertas 
										//al extraer la oferta dependiente que va a ser la nueva principal
										listaOfertasLBK.add(ofertaAgrupadaLbk.getOfertaPrincipal());	
										//Nos guardamos la antigua oferta dependiente que va a ser la nueva oferta principal para recalcular el comite de la agrupacion
										listaOfertasLBK.add(ofertaAgrupadaLbk.getOfertaDependiente());	

										Auditoria auditoria = ofertaAgrupadaLbk.getAuditoria();
										auditoria.setBorrado(true);
										auditoria.setFechaBorrar(new Date());
										auditoria.setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
										ofertaAgrupadaLbk.setAuditoria(auditoria);					
										genericDao.update(OfertasAgrupadasLbk.class, ofertaAgrupadaLbk);
										
										Filter filtroClaseOfertaPrincipal = genericDao.createFilter(FilterType.EQUALS, "codigo", DDClaseOferta.CODIGO_OFERTA_PRINCIPAL);
										DDClaseOferta claseOfertaPrincipal = genericDao.get(DDClaseOferta.class, filtroClaseOfertaPrincipal);						
										nuevaOfertaPrincipal.setClaseOferta(claseOfertaPrincipal);
										genericDao.update(Oferta.class, nuevaOfertaPrincipal);
										
										if(!Checks.esNulo(claseOferta))
											oferta.setClaseOferta(claseOferta);
									}
									// Si la nueva oferta principal es principal, cambiamos la antigua principal a dependiente.
									else if(nuevaOfertaPrincipal.getClaseOferta().getCodigo().equals(DDClaseOferta.CODIGO_OFERTA_PRINCIPAL)) {
		
										if(!Checks.esNulo(claseOferta))
											oferta.setClaseOferta(claseOferta);
										//Recalculamos comite de la agrupacion de ofertas
										listaOfertasLBK.add(nuevaOfertaPrincipal);	

									}
									
									// Insertamos el nuevo registro de las dos ofertas cambiadas de "rol".
									OfertasAgrupadasLbk nuevaOfertaAgrupadaLbk = new OfertasAgrupadasLbk();
									nuevaOfertaAgrupadaLbk.setOfertaDependiente(oferta);
									nuevaOfertaAgrupadaLbk.setOfertaPrincipal(nuevaOfertaPrincipal);					
									genericDao.save(OfertasAgrupadasLbk.class, nuevaOfertaAgrupadaLbk);
									
								}
								else {
									logger.error("La oferta que se está intentando introducir tiene un activo ya contenido en la agrupación.");
									return false;
								}
							}
							// En caso de que la antigua oferta principal tenga ofertas que dependan de el. 
							else {
								// Comprobamos si la nueva oferta principal forma parte de la misma agrupación.
								boolean ofertaEnLaMismaAgrupacion = false;
								
								for(OfertasAgrupadasLbk ofr : ofertasAgrupadasLbk) {
									if(nuevaOfertaPrincipal.getId().equals(ofr.getOfertaDependiente().getId())) {
										ofertaEnLaMismaAgrupacion = true;
										break;
									}
								}
								// En caso de que pertenezca a la misma, se permutan los roles.
								if(ofertaEnLaMismaAgrupacion) {									
									// Ponemos borrado a 1 en la tabla relacional para hacer el cambio.
									Filter filtroIdPrincipal = genericDao.createFilter(FilterType.EQUALS, "ofertaPrincipal.id", oferta.getId());	
									Filter filtroIdDependiente = genericDao.createFilter(FilterType.EQUALS, "ofertaDependiente.id", nuevaOfertaPrincipal.getId());	
									OfertasAgrupadasLbk ofertaAgrupadaLbk = genericDao.get(OfertasAgrupadasLbk.class, filtroIdPrincipal, filtroIdDependiente, filtroBorrado);
									Auditoria auditoria = ofertaAgrupadaLbk.getAuditoria();
									auditoria.setBorrado(true);
									auditoria.setFechaBorrar(new Date());
									auditoria.setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
									ofertaAgrupadaLbk.setAuditoria(auditoria);					
									genericDao.update(OfertasAgrupadasLbk.class, ofertaAgrupadaLbk);
									
									// Volvemos a recoger la lista sin el valor que hemos borrado.
									ofertasAgrupadasLbk = genericDao.getList(OfertasAgrupadasLbk.class, filtroId, filtroBorrado);
									
									// Hacemos update cambiando el Id de la nueva oferta principal.
									for(OfertasAgrupadasLbk ofr : ofertasAgrupadasLbk) {
										ofr.setOfertaPrincipal(nuevaOfertaPrincipal);
										genericDao.update(OfertasAgrupadasLbk.class, ofr);
									}
									
									// Insertamos el nuevo registro de las dos ofertas cambiadas de "rol" entre sí.
									OfertasAgrupadasLbk nuevaOfertaAgrupadaLbk = new OfertasAgrupadasLbk();
									nuevaOfertaAgrupadaLbk.setOfertaDependiente(oferta);
									nuevaOfertaAgrupadaLbk.setOfertaPrincipal(nuevaOfertaPrincipal);									
									genericDao.save(OfertasAgrupadasLbk.class, nuevaOfertaAgrupadaLbk);
									
									// Actualizamos la clase de oferta de ambas.
									if(!Checks.esNulo(claseOferta))
										oferta.setClaseOferta(claseOferta);
									Filter filtroClaseOfertaPrincipal = genericDao.createFilter(FilterType.EQUALS, "codigo", DDClaseOferta.CODIGO_OFERTA_PRINCIPAL);
									DDClaseOferta claseOfertaPrincipal = genericDao.get(DDClaseOferta.class, filtroClaseOfertaPrincipal);
									nuevaOfertaPrincipal.setClaseOferta(claseOfertaPrincipal);
									genericDao.update(Oferta.class, nuevaOfertaPrincipal);
									
									//Recalculamos el comite de la agrupacion de ofertas despues de permutar la oferta principal con una de sus dependientes
									listaOfertasLBK.add(nuevaOfertaPrincipal);	
				
								} 
								// Si la oferta principal tiene ofertas dependientes, no puede pasar a ser dependiente de otra agrupacion que no sea la suya.
								else {
									throw new JsonViewerException("La oferta no puede cambiar a dependiente si tiene ofertas dependientes.");
								}
							}							
						} else {
							logger.error("La oferta introducida no existe.");
							return false;
							}
					}catch (Exception ex) {
						logger.error("Error al intentar cambiar una oferta principal a dependiente.", ex);
						return false;
					}
				}				
			}
		}
				
		//Se aplica el comité correspondiente a las ofertas añadidas a la lista
		if (!Checks.esNulo(listaOfertasLBK) && !listaOfertasLBK.isEmpty()) {
			ofertaApi.calculoComiteLBK(oferta.getId(), null);
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
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filtro, filtroBorrado);
			expedienteComercial.setComiteSancion(comiteSancion);
			expedienteComercial.setComiteSuperior(comiteSancion);
		}

		if (!Checks.esNulo(dto.getComiteSancionadorCodigoAlquiler())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
					dto.getComiteSancionadorCodigoAlquiler());
			DDComiteAlquiler comitesAlquiler = genericDao.get(DDComiteAlquiler.class, filtro);
			expedienteComercial.setComiteAlquiler(comitesAlquiler);
		}

		// HREOS-4360
		if (!Checks.esNulo(dto.getTipoAlquilerCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoAlquilerCodigo());
			DDTipoAlquiler tipoAlquiler = genericDao.get(DDTipoAlquiler.class, filtro);
			oferta.setTipoAlquiler(tipoAlquiler);
		}
		if (!Checks.esNulo(dto.getTipoInquilinoCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoInquilinoCodigo());
			DDTipoInquilino tipoInquilino = genericDao.get(DDTipoInquilino.class, filtro);
			oferta.setTipoInquilino(tipoInquilino);
		}
		oferta.setNumContratoPrinex(dto.getNumContratoPrinex());
		oferta.setRefCircuitoCliente(dto.getRefCircuitoCliente());

		if (!Checks.esNulo(dto.getNumVisita())) {
			Filter filtroVisita = genericDao.createFilter(FilterType.EQUALS, "numVisitaRem",
					Long.parseLong(dto.getNumVisita()));
			Filter filtroActivoVisita = genericDao.createFilter(FilterType.EQUALS, "activo.id",
					oferta.getActivoPrincipal().getId());
			Visita visita = genericDao.get(Visita.class, filtroVisita, filtroActivoVisita);

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expedienteComercial.getId());
			List<GastosExpediente> lista = genericDao.getList(GastosExpediente.class, filtro);

			if (dto.getNumeroContacto() != null) {
				visita.setNumeroContacto(dto.getNumeroContacto());
			}
			if (!Checks.esNulo(visita)) {
				oferta.setVisita(visita);

				DDEstadosVisitaOferta estadoVisitaOferta = (DDEstadosVisitaOferta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDEstadosVisitaOferta.class,
								DDEstadosVisitaOferta.ESTADO_VISITA_OFERTA_REALIZADA);
				oferta.setEstadoVisitaOferta(estadoVisitaOferta);

				if (!Checks.esNulo(visita.getApiCustodio()) && Checks.esNulo(oferta.getCustodio())) {
					// Si la visita tiene custodio y la oferta no, lo copiamos.
						MaestroDePersonas maestroDePersonas = new MaestroDePersonas();
						visita.getApiCustodio().setIdPersonaHaya(maestroDePersonas.getIdPersonaHayaByDocumentoProveedor(visita.getApiCustodio().getDocIdentificativo(),visita.getApiCustodio().getCodigoProveedorRem()));
						oferta.setCustodio(visita.getApiCustodio());
						genericDao.save(ActivoProveedor.class,visita.getApiCustodio());

				} else if (!Checks.esNulo(visita.getApiCustodio()) && !Checks.esNulo(oferta.getCustodio())) {
					// si la visita tiene custodio y la oferta también, si son diferentes lo
					// borramos de los honorarios.
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
					// Si la visita tiene custodio y la oferta también, si son diferentes lo
					// borramos de los honorarios.
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
					// Si la visita tiene custodio y la oferta también, si son diferentes lo
					// borramos de los honorarios.
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
					ActivoProveedor prescriptor = visita.getPrescriptor();
					if (prescriptor != null && prescriptor.getIdPersonaHaya() == null){
						MaestroDePersonas maestroDePersonas = new MaestroDePersonas();
						prescriptor.setIdPersonaHaya(maestroDePersonas.getIdPersonaHayaByDocumentoProveedor(prescriptor.getDocIdentificativo(),prescriptor.getCodigoProveedorRem()));
						genericDao.save(ActivoProveedor.class,prescriptor);
					}

					oferta.setPrescriptor(visita.getPrescriptor());
				}

				List<GastosExpediente> gastos = genericDao.getList(GastosExpediente.class,genericDao.createFilter(FilterType.EQUALS,
						"expediente.id", expedienteComercial.getId()));
				
				if(gastos == null || gastos.isEmpty()) {
					creaGastoExpediente(expedienteComercial, oferta, oferta.getActivoPrincipal());
				} else {
					actualizarGastosExpediente(expedienteComercial, oferta,null);
				}
				
				genericDao.save(Oferta.class, oferta);

			} else {
				throw new JsonViewerException(messageServices.getMessage(VISITA_SIN_RELACION_OFERTA));
			}
		}

		if ("".equals(dto.getNumVisita()))
			oferta.setVisita(null);

		if (!Checks.esNulo(dto.getImporteOferta())) {
			ofertaApi.resetPBC(expedienteComercial, false);
		}

		if(!Checks.esNulo(dto.getIdGestorComercialPrescriptor())) {
			if(dto.getIdGestorComercialPrescriptor().equals(0l)) {
				oferta.setGestorComercialPrescriptor(null);
			}else {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdGestorComercialPrescriptor());
				Usuario gestorComercialPrescriptor  = genericDao.get(Usuario.class, filtro);
				if(!Checks.esNulo(gestorComercialPrescriptor)) {
					oferta.setGestorComercialPrescriptor(gestorComercialPrescriptor);
				}
			}
		}

		try {
			beanUtilNotNull.copyProperties(oferta, dto);
			

		} catch (IllegalAccessException e) {
			logger.error("error en expedienteComercialManager", e);

		} catch (InvocationTargetException e) {
			logger.error("error en expedienteComercialManager", e);
		}

		OfertaExclusionBulk ofertaExclusionBulkNew = null;
		
		if (dto.getExclusionBulk() != null) {
			DDSinSiNo sino = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getExclusionBulk()));
			ofertaExclusionBulkNew = new OfertaExclusionBulk();
			OfertaExclusionBulk ofertaExclusionBulk = genericDao.get(OfertaExclusionBulk.class, 
					genericDao.createFilter(FilterType.EQUALS, "oferta", oferta),
					genericDao.createFilter(FilterType.NULL, "fechaFin"));
			
			if(ofertaExclusionBulk != null) {
				ofertaExclusionBulk.setFechaFin(new Date());
				genericDao.update(OfertaExclusionBulk.class, ofertaExclusionBulk);
			}
			
			ofertaExclusionBulkNew.setOferta(oferta);
			ofertaExclusionBulkNew.setExclusionBulk(sino);
			ofertaExclusionBulkNew.setFechaInicio(new Date());
			ofertaExclusionBulkNew.setUsuarioAccion(usuarioModificador);
			
			
		}		
		
		if(dto.getIdAdvisoryNote() != null) {
			BulkOferta blkOfr = bulkOfertaDao.findOne(null, expedienteComercial.getOferta().getId(), false);
			if(!StringUtils.isBlank(dto.getIdAdvisoryNote())) {					
				//Comprobamos que la oferta pertenezca a un Bulk.
				//Si todas las ofertas se encuentran en la misma tarea se podrá modificar
				if(ofertasEnLaMismaTarea(blkOfr)) {
					cambiarBulkOferta(oferta, dto, blkOfr);
				} else {
						throw new JsonViewerException("La Oferta de este activo no se encuentra en la misma Tarea que el resto de activos");
				}
			}else {
				//Borrado logico del anterior registro si procede
				Auditoria.delete(blkOfr);	
				bulkOfertaDao.update(blkOfr);
			}
		}

		
		if (!Checks.esNulo(dto.getNecesitaFinanciacion())) {
			DDSnsSiNoNosabe sns = genericDao.get(DDSnsSiNoNosabe.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getNecesitaFinanciacion()));
			oferta.setNecesitaFinanciar(sns);
		}

		expedienteComercial.setOferta(oferta);
	
		ofertaApi.updateStateDispComercialActivosByOferta(oferta);

		if(ofertaExclusionBulkNew != null) {
			genericDao.save(OfertaExclusionBulk.class, ofertaExclusionBulkNew);
		}
		OfertaCaixa ofrCx = oferta.getOfertaCaixa();
		if(ofrCx != null) {
			if(dto.getCheckListDocumentalCompleto() != null) {
				ofrCx.setCheckListDocumentalCompleto(dto.getCheckListDocumentalCompleto());
			}
			if(dto.getCheckSubasta() != null) {
				ofrCx.setCheckSubasta(dto.getCheckSubasta());
			}
			if(dto.getTipologiaVentaCod() != null) {
				ofrCx.setTipologiaVentaBc(genericDao.get(DDTipologiaVentaBc.class, genericDao.createFilter(FilterType.EQUALS,"codigo",  dto.getTipologiaVentaCod())));
			}
		}
		
		if(dto.getClasificacionCodigo() != null) {
			DDClasificacionContratoAlquiler clasificacion = genericDao.get(DDClasificacionContratoAlquiler.class, genericDao.createFilter(FilterType.EQUALS,"codigo",  dto.getClasificacionCodigo()));
			oferta.setClasificacion(clasificacion);
		}

		if(dto.getClaseContratoCodigo() != null){
			DDClaseContratoAlquiler claseContrato = genericDao.get(DDClaseContratoAlquiler.class, genericDao.createFilter(FilterType.EQUALS,"codigo",  dto.getClaseContratoCodigo()));
			oferta.setClaseContratoAlquiler(claseContrato);
		}
		
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		genericDao.save(Oferta.class, oferta);
		// Si se ha modificado el importe de la oferta o de la contraoferta actualizamos
		// el listado de activos.
		// También se actualiza el importe de la reserva. Actualizar honorarios para el
		// nuevo importe de contraoferta u oferta.

		if (!Checks.esNulo(dto.getImporteOferta()) || !Checks.esNulo(dto.getImporteContraOferta())) {
			this.updateParticipacionActivosOferta(oferta);
			this.actualizarImporteReservaPorExpediente(expedienteComercial);
			this.actualizarHonorariosPorExpediente(expedienteComercial.getId());
		}
		
		if ((!Checks.esNulo(dto.getNumVisita()) && ((!Checks.esNulo(visitaOferta) && Long.parseLong(dto.getNumVisita()) != visitaOferta.getNumVisitaRem()) || Checks.esNulo(visitaOferta)))
				|| !Checks.esNulo(dto.getImporteOferta())) {
			this.actualizarGastosExpediente(expedienteComercial, oferta, null);
		}
		
		if (dto.getImporteOferta() != null && DDCartera.CODIGO_CARTERA_BBVA.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", tramitacionOfertasManager.calcularComiteBBVA(oferta));
			DDComiteSancion comite = genericDao.get(DDComiteSancion.class, filtro);
			expedienteComercial.setComitePropuesto(comite);
			expedienteComercial.setComiteSancion(comite);
			genericDao.save(ExpedienteComercial.class, expedienteComercial);
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveOfertaTanteoYRetracto(DtoTanteoYRetractoOferta dtoTanteoYRetractoOferta, Long idExpediente) {
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		Oferta oferta = null;

		if (expedienteComercial != null) {
			oferta = expedienteComercial.getOferta();
		}

		if (oferta != null) {
			try {
				beanUtilNotNull.copyProperties(oferta, dtoTanteoYRetractoOferta);

				if (dtoTanteoYRetractoOferta.getResultadoTanteoCodigo() != null)
					oferta.setResultadoTanteo((DDResultadoTanteo) utilDiccionarioApi.dameValorDiccionarioByCod(
							DDResultadoTanteo.class, dtoTanteoYRetractoOferta.getResultadoTanteoCodigo()));

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
				dto.setIdOferta(oferta.getId());
			}

			dto.setId(expediente.getId());

			if (!Checks.esNulo(oferta) && !Checks.esNulo(activo)) {

				dto.setOrigen(oferta.getOrigen());

				if (DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
					if (!Checks.esNulo(expediente.getMotivoAnulacion())) {
						dto.setCodMotivoAnulacion(expediente.getMotivoAnulacion().getCodigo());
						dto.setDescMotivoAnulacion(expediente.getMotivoAnulacion().getDescripcion());
					}
				} else { // Alquiler
					if (!Checks.esNulo(expediente.getMotivoAnulacion())) {
						dto.setCodMotivoAnulacion(expediente.getMotivoAnulacion().getCodigo());
						dto.setDescMotivoAnulacion(expediente.getMotivoAnulacion().getDescripcion());
					} else if (!Checks.esNulo(expediente.getMotivoRechazo())) {
						dto.setCodMotivoRechazoExp(expediente.getMotivoRechazo().getCodigo());
						dto.setDescMotivoRechazoExp(expediente.getMotivoRechazo().getDescripcion());
					} else if (!Checks.esNulo(expediente.getMotivoAnulacionAlquiler())) {
						dto.setDescMotivoAnulacionAlq(expediente.getMotivoAnulacionAlquiler().getDescripcion());
						dto.setCodMotivoAnulacionAlq(expediente.getMotivoAnulacionAlquiler().getCodigo());
					}
				}

				dto.setNumExpediente(expediente.getNumExpediente());
				if (!Checks.esNulo(expediente.getTrabajo())) {
					dto.setIdTrabajo(expediente.getTrabajo().getId());
					dto.setEstadoTrabajo(expediente.getTrabajo().getEstado().getDescripcion());
					dto.setMotivoAnulacionTrabajo(expediente.getTrabajo().getMotivoRechazo());
					dto.setNumTrabajo(expediente.getTrabajo().getNumTrabajo());
				}

				if (!Checks.esNulo(activo.getCartera())) {
					dto.setEntidadPropietariaDescripcion(activo.getCartera().getDescripcion());
					dto.setEntidadPropietariaCodigo(activo.getCartera().getCodigo());
				}

				if (!Checks.esNulo(activo.getSubcartera())) {
					dto.setSubcarteraCodigo(activo.getSubcartera().getCodigo());
				}

				if (!Checks.esNulo(oferta.getTipoOferta())) {
					dto.setTipoExpedienteDescripcion(oferta.getTipoOferta().getDescripcion());
					dto.setTipoExpedienteCodigo(oferta.getTipoOferta().getCodigo());

					if (DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
						dto.setImporte(!Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteContraOferta()
								: oferta.getImporteOferta());

					} else if (DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())) {
						dto.setImporte(oferta.getImporteOferta());

						if (!Checks.esNulo(expediente.getTipoAlquiler())) {
							dto.setTipoAlquiler(expediente.getTipoAlquiler().getCodigo());
						}

						if (!Checks.esNulo(oferta.getTipoInquilino())) {
							dto.setTipoInquilino(oferta.getTipoInquilino().getCodigo());
						} else {
							if (!Checks.esNulo(expediente.getCompradorPrincipal())) {

								Filter filtro = genericDao.createFilter(FilterType.EQUALS, "comprador",
										expediente.getCompradorPrincipal().getId());
								Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "expediente",
										expediente.getId());
								CompradorExpediente compradorExpediente = genericDao.get(CompradorExpediente.class,
										filtro, filtro2);
								if (!Checks.esNulo(compradorExpediente.getTipoInquilino())) {
									if (!Checks.esNulo(compradorExpediente.getTipoInquilino().getDescripcion())) {
										dto.setTipoInquilino(compradorExpediente.getTipoInquilino().getCodigo());
									}
								}
							}
						}

						if (!Checks.esNulo(expediente.getEstado().getCodigo())) {
							dto.setEstaFirmado(
									DDEstadosExpedienteComercial.FIRMADO.equals(expediente.getEstado().getCodigo()));
						}
					}
				}

				dto.setPropietario(activo.getFullNamePropietario());

				if (!Checks.esNulo(activo.getInfoComercial())
						&& !Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
					dto.setMediador(activo.getInfoComercial().getMediadorInforme().getNombre());
				}

				dto.setImporte(!Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteContraOferta()
						: oferta.getImporteOferta());

				if (!Checks.esNulo(expediente.getCompradorPrincipal())) {
					dto.setComprador(expediente.getCompradorPrincipal().getFullName());
				}

				if (!Checks.esNulo(expediente.getFechaSancionComite())) {
					dto.setFechaSancionComite(expediente.getFechaSancionComite());
				}

				if (!Checks.esNulo(expediente.getEstado())) {
					dto.setEstado(expediente.getEstado().getDescripcion());
					dto.setCodigoEstado(expediente.getEstado().getCodigo());
				}

				dto.setFechaAlta(expediente.getFechaAlta());
				dto.setFechaAltaOferta(oferta.getFechaAlta());
				dto.setFechaSancion(expediente.getFechaSancion());
				dto.setFechaEnvioAdvisoryNote(expediente.getFechaEnvioAdvisoryNote());

				if (!Checks.esNulo(expediente.getFechaRecomendacionCes())) {
					dto.setFechaRecomendacionCes(expediente.getFechaRecomendacionCes());
				}

				if (!Checks.esNulo(expediente.getReserva())) {
					dto.setFechaReserva(expediente.getReserva().getFechaFirma());
				} else {
					Trabajo trabajo = expediente.getTrabajo();

					if (trabajo != null) {
						Activo act = trabajo.getActivo();
						if (act != null) {
							String valor = tareaActivoApi.getValorFechaSeguroRentaPorIdActivo(act.getId());
							if (valor != null && !valor.equals("")) {
								SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
								try {
									dto.setFechaReserva(sdf1.parse(valor));
								} catch (ParseException e) {
									logger.error("error calculando la fecha de reserva", e);
								}
							}
						}
					}
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
						dto.setEstadoReservaCod(reserva.getEstadoReserva().getCodigo());
					}
				}

				dto.setPeticionarioAnulacion(expediente.getPeticionarioAnulacion());
				dto.setFechaContabilizacionPropietario(expediente.getFechaContabilizacionPropietario());
				dto.setFechaDevolucionEntregas(expediente.getFechaDevolucionEntregas());
				dto.setImporteDevolucionEntregas(expediente.getImporteDevolucionEntregas());
				dto.setDefinicionOfertaFinalizada(false);

				if (!Checks.esNulo(expediente.getTrabajo()) && !Checks.esNulo(expediente.getTrabajo().getId())) {

					List<ActivoTramite> tramitesActivo = tramiteDao
							.getTramitesActivoTrabajoList(expediente.getTrabajo().getId());
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", "T015_DefinicionOferta");
					Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					TareaProcedimiento tap = genericDao.get(TareaProcedimiento.class, filtro, filtroBorrado);

					for (ActivoTramite actt : tramitesActivo) {
						List<TareaExterna> tareas = activoTareaExternaApi
								.getByIdTareaProcedimientoIdTramite(actt.getId(), tap.getId());
						for (TareaExterna t : tareas) {
							if (t.getTareaPadre().getTareaFinalizada()
									&& t.getTareaPadre().getAuditoria().isBorrado()) {
								List<TareaExternaValor> listaTareaExterna = activoTareaExternaApi
										.obtenerValoresTarea(t.getId());
								for (TareaExternaValor te : listaTareaExterna) {
									if (te.getNombre().equals("tipoTratamiento")
											&& DDTipoTratamiento.TIPO_TRATAMIENTO_SEGURO_DE_RENTAS
													.equals(te.getValor())) {
										dto.setDefinicionOfertaFinalizada(true);
										break;
									}

								}
							}
						}
					}
				}

				if (!Checks.esNulo(expediente.getCondicionante())) {
					Integer tieneReserva = expediente.getCondicionante().getSolicitaReserva();
					dto.setTieneReserva(!Checks.esNulo(tieneReserva) && tieneReserva == 1);

					Integer ocultar = expediente.getCondicionante().getSujetoTanteoRetracto();
					dto.setOcultarPestTanteoRetracto(!Checks.esNulo(ocultar) && ocultar == 1 ? false : true);

					if (Checks.esNulo(expediente.getReserva())) {
						dto.setFechaReserva(expediente.getCondicionante().getFechaFirma());
					}
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
				if (!Checks.esNulo(expediente.getEstadoPbcR())) {
					dto.setEstadoPbcR(expediente.getEstadoPbcR());
				}

				if (!Checks.esNulo(expediente.getFechaVenta())) {
					dto.setFechaVenta(expediente.getFechaVenta());
				}
				if(!Checks.esNulo(expediente.getFechaContabilizacionVenta())) {
					dto.setFechaContabilizacionVenta(expediente.getFechaContabilizacionVenta());
				}

				if (!Checks.esNulo(activo.getActivoPublicacion().getTipoComercializacion())) {
					// DDTipoAlquiler tipoAlquiler = (DDTipoAlquiler)
					// utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoAlquiler.class,
					// DDTipoAlquiler.CODIGO_ALQUILER_OPCION_COMPRA);

					if (activo.getTipoAlquiler() != null && DDTipoAlquiler.CODIGO_ALQUILER_OPCION_COMPRA
							.equals(activo.getTipoAlquiler().getCodigo())) {
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

				dto.setNoEsOfertaFinalGencat(Boolean.FALSE);

				List<OfertaGencat> ofertaGencats = genericDao.getList(OfertaGencat.class,
						genericDao.createFilter(FilterType.EQUALS, "oferta", oferta));
				if (!Checks.estaVacio(ofertaGencats)) {
					if (!Checks.esNulo(ofertaGencats.get(0).getIdOfertaAnterior())) {
						Long idOfertaAnterior = ofertaGencats.get(0).getIdOfertaAnterior();
						Oferta ofertaAnterior = genericDao.get(Oferta.class,
								genericDao.createFilter(FilterType.EQUALS, "id", idOfertaAnterior));
						Long numOfertaAnterior = ofertaAnterior.getNumOferta();
						dto.setIdOfertaAnterior(numOfertaAnterior);

					} else {
						dto.setNoEsOfertaFinalGencat(Boolean.TRUE);
					}

				} else {
					if (!Checks.estaVacio(expediente.getOferta().getActivosOferta())) {
						for (ActivoOferta actOferta : expediente.getOferta().getActivosOferta()) {
							VActivosAfectosGencat activoAfecto = genericDao.get(VActivosAfectosGencat.class,
									genericDao.createFilter(FilterType.EQUALS, "id", actOferta.getActivoId()));
							if (!Checks.esNulo(activoAfecto)) {
								dto.setNoEsOfertaFinalGencat(Boolean.TRUE);
							}
						}
					}
				}
				if (!Checks.esNulo(oferta.getFechaAprobacionProManzana())) {
					dto.setFechaAprobacionProManzana(oferta.getFechaAprobacionProManzana());
				}
								
				dto.setDefinicionOfertaScoring(false);

				if (!Checks.esNulo(expediente.getTrabajo()) && !Checks.esNulo(expediente.getTrabajo().getId())) {

					List<ActivoTramite> tramitesActivo = tramiteDao
							.getTramitesActivoTrabajoList(expediente.getTrabajo().getId());
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", "T015_DefinicionOferta");
					Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					TareaProcedimiento tap = genericDao.get(TareaProcedimiento.class, filtro, filtroBorrado);

					for (ActivoTramite actt : tramitesActivo) {
						List<TareaExterna> tareas = activoTareaExternaApi
								.getByIdTareaProcedimientoIdTramite(actt.getId(), tap.getId());
						for (TareaExterna t : tareas) {
							if (t.getTareaPadre().getTareaFinalizada()
									&& t.getTareaPadre().getAuditoria().isBorrado()) {
								List<TareaExternaValor> listaTareaExterna = activoTareaExternaApi
										.obtenerValoresTarea(t.getId());
								for (TareaExternaValor te : listaTareaExterna) {
									if (te.getNombre().equals("tipoTratamiento")
											&& DDTipoTratamiento.TIPO_TRATAMIENTO_SCORING.equals(te.getValor())) {
										dto.setDefinicionOfertaScoring(true);
										break;
									}

								}
							}
						}
					}
				}
				if (!Checks.estaVacio(expediente.getCompradores())) {
					Boolean problemasUrsus = hayProblemasURSUS(expediente.getId());
					if (!Checks.esNulo(problemasUrsus))
						dto.setProblemasUrsus(problemasUrsus);
				}
				if (!Checks.esNulo(expediente.getReserva())
						&& !Checks.esNulo(expediente.getReserva().getFechaContabilizacionReserva())) {
					dto.setFechaContabilizacionReserva(expediente.getReserva().getFechaContabilizacionReserva());
				}
				
				if(oferta.getOfertaCaixa() != null) {
					OfertaCaixa ofertaCaixa = oferta.getOfertaCaixa();
					if(ofertaCaixa.getEstadoComunicacionC4C() != null) {
						dto.setCodigoEstadoComunicacionC4C(ofertaCaixa.getEstadoComunicacionC4C().getCodigo());
					}
				}
				
				dto.setFinalizadoCierreEconomico(finalizadoCierreEconomico(expediente));
			}
			
			if(expediente.getEstadoBc() != null) {
				dto.setCodigoEstadoBc(expediente.getEstadoBc().getCodigo());
			}
			
			if (expediente.getEstadoPbcArras() != null) {
				dto.setEstadoPbcArras(expediente.getEstadoPbcArras());
			}
			
			if (expediente.getEstadoPbcCn() != null) {
				dto.setEstadoPbcCn(expediente.getEstadoPbcCn());
			}
			if (expediente.getFechaReservaDeposito() != null) {
				dto.setFechaReservaDeposito(expediente.getFechaReservaDeposito());
			}
			if (expediente.getFechaContabilizacion() != null) {
				dto.setFechaContabilizacion(expediente.getFechaContabilizacion());
			}
			
			if (!Checks.esNulo(expediente.getFechaFirmaContrato())) {
				dto.setFechaFirmaContrato(expediente.getFechaFirmaContrato());
			}
			
			if(expediente.getOferta() != null && expediente.getOferta().getClasificacion() != null) {
				dto.setClasificacionCodigo(expediente.getOferta().getClasificacion().getCodigo());
			}
			
			dto.setMesesDuracionCntAlquiler(expediente.getMesesDuracionCntAlquiler());
			dto.setDetalleAnulacionCntAlquiler(expediente.getDetalleAnulacionCntAlquiler());
			if(expediente.getMotivoRechazoAntiguoDeud() != null) {
				dto.setMotivoRechazoAntiguoDeudCod(expediente.getMotivoRechazoAntiguoDeud().getCodigo());
			}

			if (DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo()) || DDTipoOferta.CODIGO_ALQUILER_NO_COMERCIAL .equals(oferta.getTipoOferta().getCodigo())) {
				String valorPbcAlquiler = tareaActivoApi.getValorCampoTarea(ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_PBC_ALQUILER, expediente.getNumExpediente(), "comboResultado");
				valorPbcAlquiler = (valorPbcAlquiler != null ? valorPbcAlquiler : tareaActivoApi.getValorCampoTarea(ComercialUserAssigantionService.CODIGO_T015_PBC, expediente.getNumExpediente(), "comboResultado"));

				if (valorPbcAlquiler != null) {
					dto.setEstadoPbcAlquiler(Integer.parseInt(valorPbcAlquiler));
				}
			}
		}
		return dto;
	}

	private DtoDatosBasicosOferta expedienteToDtoDatosBasicosOferta(ExpedienteComercial expediente) {
		DtoDatosBasicosOferta dto = new DtoDatosBasicosOferta();
		Oferta oferta = expediente.getOferta();
		Boolean isMayoristaOSingular = false;

		dto.setIdOferta(oferta.getId());
		dto.setNumOferta(oferta.getNumOferta());

		if (oferta.getTipoOferta() != null) {
			dto.setTipoOfertaDescripcion(oferta.getTipoOferta().getDescripcion());
			dto.setTipoOfertaCodigo(oferta.getTipoOferta().getCodigo());
		}

		Boolean isCarteraLbkVenta = false;
		if (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
				&& DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
			isCarteraLbkVenta = true;
		}

		dto.setTieneInterlocutoresNoEnviados(tieneInterlocutoresNoEnviados(expediente));

		dto.setIsCarteraLbkVenta(isCarteraLbkVenta);
		Boolean isLbkOfertaComercialPrincipal = false;
		Boolean muestraOfertaComercial = false;
		if (isCarteraLbkVenta && oferta.getClaseOferta() != null && DDClaseOferta.CODIGO_OFERTA_PRINCIPAL.equals(oferta.getClaseOferta().getCodigo())) {
			isLbkOfertaComercialPrincipal = true;
			muestraOfertaComercial = true;
		}else if (isCarteraLbkVenta && oferta.getClaseOferta() != null && DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(oferta.getClaseOferta().getCodigo())) {
			muestraOfertaComercial = true;

		}
		dto.setIsLbkOfertaComercialPrincipal(isLbkOfertaComercialPrincipal);
		dto.setMuestraOfertaComercial(muestraOfertaComercial);

		Double importeTotalAgrupada = oferta.getImporteOferta();
		if (isCarteraLbkVenta && oferta.getClaseOferta() != null) {
			dto.setClaseOfertaDescripcion(oferta.getClaseOferta().getDescripcion());
			dto.setClaseOfertaCodigo(oferta.getClaseOferta().getCodigo());
			if (oferta.getClaseOferta() != null && DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(oferta.getClaseOferta().getCodigo())) {
				dto.setNumOferPrincipal(ofertaApi.getOfertaPrincipalById(oferta.getId()).getNumOferta());

			}else if (oferta.getClaseOferta() != null && DDClaseOferta.CODIGO_OFERTA_PRINCIPAL.equals(oferta.getClaseOferta().getCodigo())) {
				try {
					List<OfertasAgrupadasLbk> oferAgrupa = oferta.getOfertasAgrupadas();

					if(oferAgrupa != null) {
						for (OfertasAgrupadasLbk ofertaAgrupada : oferAgrupa) {
							if (oferta.getId() != ofertaAgrupada.getOfertaDependiente().getId()) {
								importeTotalAgrupada += ofertaAgrupada.getOfertaDependiente().getImporteOferta();
							}
						}
					}
				} catch (Exception ex) {
					logger.error("error al recuperar la lista de ofertas agrupadas", ex);
				}
			}
		}

		dto.setImporteTotal(importeTotalAgrupada);

		dto.setFechaNotificacion(oferta.getFechaNotificacion());
		dto.setFechaAlta(oferta.getFechaAlta());
		dto.setFechaOfertaPendiente(oferta.getFechaOfertaPendiente());

		if (oferta.getEstadoOferta() != null) {
			dto.setEstadoDescripcion(oferta.getEstadoOferta().getDescripcion());
			dto.setEstadoCodigo(oferta.getEstadoOferta().getCodigo());
		}

		if (oferta.getPrescriptor() != null) {
			dto.setPrescriptor(oferta.getPrescriptor().getNombre());
		}

		dto.setImporteOferta(oferta.getImporteOferta());
		dto.setImporteContraOferta(oferta.getImporteContraOferta());

		if (oferta.getVisita() != null) {
			dto.setNumVisita(oferta.getVisita().getNumVisitaRem().toString());
		}

		if (oferta.getEstadoVisitaOferta() != null) {
			dto.setEstadoVisitaOfertaCodigo(oferta.getEstadoVisitaOferta().getCodigo());
			dto.setEstadoVisitaOfertaDescripcion(oferta.getEstadoVisitaOferta().getDescripcion());
		}
		if (oferta.getVisita() != null && oferta.getVisita().getNumeroContacto() != null) {
			dto.setNumeroContacto(oferta.getVisita().getNumeroContacto());
		}

		// antiguo canal prescriptor
		if (oferta.getCanalPrescripcion() != null) {
			dto.setCanalPrescripcionCodigo(oferta.getCanalPrescripcion().getCodigo());
			dto.setCanalPrescripcionDescripcion(oferta.getCanalPrescripcion().getDescripcion());
		}

		if (expediente.getComitePropuesto() != null) {
			dto.setComitePropuestoCodigo(expediente.getComitePropuesto().getCodigo());
		}

		if (expediente.getComiteSancion() != null) {
			dto.setComiteSancionadorCodigo(expediente.getComiteSancion().getCodigo());
		}

		if (expediente.getComiteAlquiler() != null) {
			dto.setComiteSancionadorCodigoAlquiler(expediente.getComiteAlquiler().getCodigo());
		}

		// nuevo canal prescriptor
		if (oferta.getPrescriptor() != null) {
			dto.setCanalPrescripcionDescripcion(oferta.getPrescriptor().getTipoProveedor().getDescripcion());
		} else {
			dto.setCanalPrescripcionDescripcion(null);
		}

		if (oferta.getOfertaExpress() != null) {
			dto.setOfertaExpress(oferta.getOfertaExpress() ? "Si" : "No");
		}

		if (oferta.getNecesitaFinanciar() != null) {
			dto.setNecesitaFinanciacion(oferta.getNecesitaFinanciar().getCodigo());
		}

		dto.setObservaciones(oferta.getObservaciones());

		if (oferta.getVentaDirecta() != null) {
			dto.setVentaCartera(oferta.getVentaDirecta() ? "Si" : "No");
		}
		
		if(oferta.getOfertaEspecial() != null) {
			dto.setOfertaEspecial(oferta.getOfertaEspecial());
		}
		
		if(oferta.getVentaSobrePlano() != null) {
			dto.setVentaSobrePlano(oferta.getVentaSobrePlano());
		}
		
		if(oferta.getVentaCartera() != null) {
			dto.setVentaCarteraCfv(oferta.getVentaCartera());
		}
		
		if(oferta.getRiesgoOperacion() != null) {
			dto.setRiesgoOperacionCodigo(oferta.getRiesgoOperacion().getCodigo());
		}
		
		if(oferta.getRiesgoOperacion() != null) {
			dto.setRiesgoOperacionDescripcion(oferta.getRiesgoOperacion().getDescripcion());
		}

		// HREOS-4360
		if (oferta.getTipoAlquiler() != null) {
			dto.setTipoAlquilerCodigo(oferta.getTipoAlquiler().getCodigo());
		} else {
			dto.setTipoAlquilerCodigo(null);
		}
		if (oferta.getTipoInquilino() != null) {
			dto.setTipoInquilinoCodigo(oferta.getTipoInquilino().getCodigo());
		} else {
			dto.setTipoInquilinoCodigo(null);
		}
		if (oferta.getNumContratoPrinex() != null) {
			dto.setNumContratoPrinex(oferta.getNumContratoPrinex());
		} else {
			dto.setNumContratoPrinex(null);
		}
		if (oferta.getRefCircuitoCliente() != null) {
			dto.setRefCircuitoCliente(oferta.getRefCircuitoCliente());
		} else {
			dto.setRefCircuitoCliente(null);
		}				
		
		
		boolean isCerberusAppleOrArrowOrRemaining = 
				oferta != null && oferta.getActivoPrincipal() != null 						
				&& oferta.getActivoPrincipal().getCartera() != null 
				&& oferta.getActivoPrincipal().getSubcartera() != null
				&& DDCartera.CODIGO_CARTERA_CERBERUS.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
				&& (DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())
						|| DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())
						|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())); 
		
		
		dto.setIsCarteraCerberusApple(isCerberusAppleOrArrowOrRemaining);
		
		if(isCerberusAppleOrArrowOrRemaining) {
			
			dto.setFechaRespuestaCES(oferta.getFechaRespuestaCES() == null ? null : oferta.getFechaRespuestaCES());
			dto.setImporteContraofertaCES(oferta.getImporteContraofertaCES() == null ? null : oferta.getImporteContraofertaCES());
			dto.setFechaResolucionCES(oferta.getFechaResolucionCES() == null ? null : oferta.getFechaResolucionCES());
			dto.setFechaRespuesta(oferta.getFechaRespuesta() == null ? null : oferta.getFechaRespuesta());
			dto.setImporteContraofertaOfertanteCES(oferta.getImporteContraofertaOfertanteCES() == null ? null : oferta.getImporteContraofertaOfertanteCES());
		
		}		
		
		if(expediente.getEstado().getCodigo() != null 
		&& (!DDEstadosExpedienteComercial.EN_TRAMITACION.equals(expediente.getEstado().getCodigo()))
		&& isCarteraLbkVenta) {
			dto.setEstadoAprobadoLbk(true);
		}

		if (oferta.getActivoPrincipal() != null && oferta.getActivoPrincipal().getCartera() != null
				&& DDCartera.CODIGO_CARTERA_BANKIA.equals(oferta.getActivoPrincipal().getCartera().getCodigo())) {
			/// Comprobamos si la tarea Elevar a Sanción está activa

			dto.setPermiteProponer(false);

			if (expediente != null && expediente.getTrabajo() != null) {
				List<ActivoTramite> tramitesActivo = tramiteDao
						.getTramitesActivoTrabajoList(expediente.getTrabajo().getId());
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", "T015_ElevarASancion");
				Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
				TareaProcedimiento tap = genericDao.get(TareaProcedimiento.class, filtro, filtroBorrado);

				for (ActivoTramite actt : tramitesActivo) {
					if (!DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO
							.equals(actt.getEstadoTramite().getCodigo())
							&& !DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO
									.equals(actt.getEstadoTramite().getCodigo())
							&& !ESTADO_PROCEDIMIENTO_FINALIZADO.equals(actt.getEstadoTramite().getCodigo())) {
						List<TareaExterna> tareas = activoTareaExternaApi
								.getByIdTareaProcedimientoIdTramite(actt.getId(), tap.getId());
						for (TareaExterna t : tareas) {
							if (t.getTareaPadre().getTareaFinalizada()
									&& t.getTareaPadre().getAuditoria().isBorrado()) {
								dto.setPermiteProponer(true);
								break;
							}
						}
					}
				}
			}

		} else {
			dto.setPermiteProponer(false);
		}

		if (expediente != null) {
			dto.setIdEco(expediente.getId());
		}
		
		if (oferta.getActivoPrincipal().getEquipoGestion() != null) {
			if(DDEquipoGestion.CODIGO_MAYORISTA.equals(oferta.getActivoPrincipal().getEquipoGestion().getCodigo())) {
				isMayoristaOSingular = true;
			}
		} else if (oferta.getActivoPrincipal().getTipoComercializar() != null 
				&& DDTipoComercializar.CODIGO_SINGULAR.equals(oferta.getActivoPrincipal().getTipoComercializar().getCodigo())) {
			isMayoristaOSingular = true;
		}

		if (isMayoristaOSingular) {
			Usuario gestorComercialPrescriptor = gestorActivoApi.getGestorByActivoYTipo(oferta.getActivoPrincipal(), GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			if (gestorComercialPrescriptor != null) {
				if (oferta.getAgrupacion() != null)
					dto.setIdGestorComercialPrescriptor(0l);
				else
					dto.setIdGestorComercialPrescriptor(gestorComercialPrescriptor.getId());
			} else {
				dto.setIdGestorComercialPrescriptor(0l);
			}
		} else {
			if (oferta.getGestorComercialPrescriptor() != null && oferta.getGestorComercialPrescriptor().getId() != null) {
				dto.setIdGestorComercialPrescriptor(oferta.getGestorComercialPrescriptor().getId());
			} else {
				dto.setIdGestorComercialPrescriptor(0l);
			}
		}
		
		if(oferta.getOfertaSingular() != null) {
			dto.setOfertaSingular(oferta.getOfertaSingular() ? "Si" : "No");
		}

		if (oferta.getRespDocCliente() != null) {
			dto.setTipoResponsableCodigo(oferta.getRespDocCliente().getCodigo());
		}

		
		OfertaExclusionBulk ofertaExclusionBulk = genericDao.get(OfertaExclusionBulk.class, 
				genericDao.createFilter(FilterType.EQUALS, "oferta", oferta),
				genericDao.createFilter(FilterType.NULL, "fechaFin"));

		if(ofertaExclusionBulk != null) {
			dto.setExclusionBulk(ofertaExclusionBulk.getExclusionBulk().getCodigo());
		}
		dto.setIsAdvisoryNoteEnTareas(ofertaDao.tieneTareaActivaOrFinalizada("T017_AdvisoryNote", oferta.getNumOferta().toString()));
		dto.setTareaAdvisoryNoteFinalizada(ofertaDao.tieneTareaFinalizada("T017_AdvisoryNote", oferta.getNumOferta().toString()));
		dto.setTareaAutorizacionPropiedadFinalizada(ofertaDao.tieneTareaFinalizada("T017_ResolucionPROManzana", oferta.getNumOferta().toString()));
			
		

		BulkOferta blkOferta = bulkOfertaDao.findOne(null, oferta.getId(), false);
		if(!Checks.esNulo(blkOferta)) {
			BulkAdvisoryNote blkAn = genericDao.get(BulkAdvisoryNote.class,	genericDao.createFilter(FilterType.EQUALS, "id", blkOferta.getBulkAdvisoryNote().getId()));
			if (!Checks.esNulo(blkAn)) {
				dto.setIdAdvisoryNote(blkAn.getNumeroBulkAdvisoryNote());
				dto.setTipoBulkAdvisoryNote(blkAn.getTipoBulkAdvisoryNote().getId());
			}
		}
		
		if(oferta.getAgrupacion() != null && oferta.getAgrupacion().getTipoAgrupacion() != null && 
				DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA.equals(oferta.getAgrupacion().getTipoAgrupacion().getCodigo())) {
			ActivoLoteComercial agrupacionLoteCom = genericDao.get(ActivoLoteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", oferta.getAgrupacion().getId()));
			if(agrupacionLoteCom != null && agrupacionLoteCom.getUsuarioGestorComercialBackOffice() != null) {
				dto.setCorreoGestorBackoffice(agrupacionLoteCom.getUsuarioGestorComercialBackOffice().getEmail());
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", agrupacionLoteCom.getUsuarioGestorComercialBackOffice().getId());
				List<GestorSustituto> sustituto = genericDao.getList(GestorSustituto.class, filtro);
				if (!sustituto.isEmpty()) {
					 for (GestorSustituto gestorSustituto : sustituto) {
						if(System.currentTimeMillis() < gestorSustituto.getFechaFin().getTime()
								&& System.currentTimeMillis() > gestorSustituto.getFechaInicio().getTime()) {
							dto.setCorreoGestorBackoffice(gestorSustituto.getUsuarioGestorSustituto().getEmail());
							break;
						}
					}
				}			
			}
		} else if(oferta.getActivoPrincipal() != null) {
			Usuario usuarioBackOffice = gestorActivoManager.getGestorByActivoYTipo(oferta.getActivoPrincipal(), GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			if(usuarioBackOffice != null && usuarioBackOffice.getEmail() != null) {
				dto.setCorreoGestorBackoffice(usuarioBackOffice.getEmail());
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", usuarioBackOffice.getId());
				List<GestorSustituto> sustituto = genericDao.getList(GestorSustituto.class, filtro);
				if (!sustituto.isEmpty()) {
					 for (GestorSustituto gestorSustituto : sustituto) {
						if(System.currentTimeMillis() < gestorSustituto.getFechaFin().getTime()
								&& System.currentTimeMillis() > gestorSustituto.getFechaInicio().getTime()) {
							dto.setCorreoGestorBackoffice(gestorSustituto.getUsuarioGestorSustituto().getEmail());
							break;
						}
					}
				}
			}
		}
		if(oferta.getFechaCreacionOpSf() != null) {
			dto.setFechaCreacionOpSf(oferta.getFechaCreacionOpSf());
		}
		
		if (oferta != null) {
			dto.setIsEmpleadoCaixa(isEmpleadoCaixa(oferta));
			dto.setOpcionACompra(oferta.getOpcionACompra());
			dto.setValorCompra(oferta.getValorCompra());
			dto.setFechaVencimientoOpcionCompra(oferta.getFechaVencimientoOpcionCompra());
			if(oferta.getClasificacion() != null) {
				dto.setClasificacionCodigo(oferta.getClasificacion().getCodigo());
			}
			if(oferta.getOfertaCaixa() != null) {
				OfertaCaixa ofrCaixa = oferta.getOfertaCaixa();
				dto.setCheckListDocumentalCompleto(ofrCaixa.getCheckListDocumentalCompleto());
				dto.setCheckSubasta(ofrCaixa.getCheckSubasta());
				if (ofrCaixa.getCanalDistribucionBc() != null) {
					dto.setCanalDistribucionBc(ofrCaixa.getCanalDistribucionBc().getCodigo());
				}
				if(ofrCaixa.getTipologiaVentaBc() != null) {
					dto.setTipologiaVentaCod(ofrCaixa.getTipologiaVentaBc().getCodigo());
				}
			}

			DDTipoOfertaAlquiler tipoOfertaAlquiler = oferta.getTipoOfertaAlquiler();
			if(tipoOfertaAlquiler != null) {
				dto.setTipoOfertaAlquilerCodigo(tipoOfertaAlquiler.getCodigo());
			}
		}
		
		if(oferta.getOfertaCaixa() != null) {
			dto.setNumOfertaCaixa(oferta.getOfertaCaixa().getNumOfertaCaixa());
		}

		if(oferta.getClaseContratoAlquiler() != null){
			dto.setClaseContratoCodigo(oferta.getClaseContratoAlquiler().getCodigo());
		}

		return dto;
	}

	private DtoTanteoYRetractoOferta expedienteToDtoTanteoYRetractoOferta(ExpedienteComercial expediente) {
		DtoTanteoYRetractoOferta dtoTanteoYRetractoOferta = new DtoTanteoYRetractoOferta();
		Oferta oferta = null;

		if (!Checks.esNulo(expediente))
			oferta = expediente.getOferta();

		if (!Checks.esNulo(oferta)) {
			try {
				beanUtilNotNull.copyProperties(dtoTanteoYRetractoOferta, oferta);
				dtoTanteoYRetractoOferta.setIdOferta(oferta.getId());

				if (!Checks.esNulo(oferta.getResultadoTanteo())) {
					dtoTanteoYRetractoOferta.setResultadoTanteoCodigo(oferta.getResultadoTanteo().getCodigo());
					dtoTanteoYRetractoOferta
							.setResultadoTanteoDescripcion(oferta.getResultadoTanteo().getDescripcion());
				}

				if (Checks.esNulo(oferta.getCondicionesTransmision()))
					dtoTanteoYRetractoOferta
							.setCondicionesTransmision(messageServices.getMessage(TANTEO_CONDICIONES_TRANSMISION));

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
			dto.setFechaAmpliacionArras(reserva.getFechaAmpliacionArras());
			dto.setFechaVigenciaArras(reserva.getFechaVigenciaArras());
			dto.setSolicitudAmpliacionArras(reserva.getSolicitudAmpliacionArras());
			
			if(reserva.getMotivoAmpliacionArras() != null) {
				dto.setMotivoAmpliacionArrasCodigo(reserva.getMotivoAmpliacionArras().getCodigo());				
			}			

			if (!Checks.esNulo(reserva.getEstadoReserva())) {
				dto.setEstadoReservaDescripcion(reserva.getEstadoReserva().getDescripcion());
				dto.setEstadoReservaCodigo(reserva.getEstadoReserva().getCodigo());
			}

			if (!Checks.esNulo(reserva.getTipoArras())) {
				dto.setTipoArrasCodigo(reserva.getTipoArras().getCodigo());

			} else {
				if (!Checks.esNulo(expediente.getOferta())
						&& !Checks.esNulo(expediente.getOferta().getActivoPrincipal())
						&& !Checks.esNulo(expediente.getOferta().getActivoPrincipal().getCartera())
						&& DDCartera.CODIGO_CARTERA_CAJAMAR
								.equals(expediente.getOferta().getActivoPrincipal().getCartera().getCodigo())) {
					dto.setTipoArrasCodigo(DDTiposArras.CONFIRMATORIAS);
				}
			}

			if (!Checks.esNulo(expediente.getCondicionante())) {
				dto.setConImpuesto(expediente.getCondicionante().getReservaConImpuesto());
				dto.setImporte(expediente.getCondicionante().getImporteReserva());
			}

			if (!Checks.esNulo(expediente.getOferta().getSucursal())) {
				dto.setCodigoSucursal(expediente.getOferta().getSucursal().getCodProveedorUvem().substring(4));
				dto.setSucursal(expediente.getOferta().getSucursal().getNombre() + " ("
						+ expediente.getOferta().getSucursal().getTipoProveedor().getDescripcion() + ")");
			}

			dto.setCartera(expediente.getOferta().getActivoPrincipal().getCartera().getCodigo());
			
			dto.setFechaPropuestaProrrogaArras(reserva.getFechaPropuestaProrrogaArras());
			dto.setFechaComunicacionCliente(reserva.getFechaComunicacionCliente());
			dto.setFechaComunicacionClienteRescision(reserva.getFechaComunicacionClienteRescision());
			dto.setFechaFirmaRescision(reserva.getFechaFirmaRescision());
			
			if (reserva.getFechaContArras() != null) {
				dto.setFechaContabilizacionArras(reserva.getFechaContArras());
			}
		}
		CondicionesReserva condiciones = null;
		
		if(reserva != null) {
			condiciones = genericDao.get(CondicionesReserva.class, genericDao.createFilter(FilterType.EQUALS, "reserva.id", reserva.getId()));
		}
		
		if (condiciones != null) {
			if (condiciones.getAutorizacionVpo() != null) {
				dto.setAutorizacionVpo(condiciones.getAutorizacionVpo());
			}
			if (condiciones.getCargas() != null) {
				dto.setCargas(condiciones.getCargas());
			}
			if (condiciones.getInscripcionTitulo() != null) {
				dto.setInscripcionTitulo(condiciones.getInscripcionTitulo());
			}
			if (condiciones.getPosesion() != null) {
				dto.setPosesion(condiciones.getPosesion());
			}
			if (condiciones.getTanteoDL() != null) {
				dto.setTanteoDL(condiciones.getTanteoDL());
			}
			if (condiciones.getTemasCatastrales() != null) {
				dto.setTemasCatastrales(condiciones.getTemasCatastrales());
			}
			if (condiciones.getTemasTecnicos() != null) {
				dto.setTemasTecnicos(condiciones.getTemasTecnicos());
			}
		}
		MotivoRescinsionArras rescinsionArras = null;
		
		if(reserva != null) {
			rescinsionArras = genericDao.get(MotivoRescinsionArras.class, genericDao.createFilter(FilterType.EQUALS, "reserva.id", reserva.getId()));	
		}
		
		if (rescinsionArras != null) {
			if (rescinsionArras.getAutorizacionVpo() != null) {
				dto.setAutorizacionVpoMotivo(rescinsionArras.getAutorizacionVpo());
			}
			if (rescinsionArras.getCargas() != null) {
				dto.setCargasMotivo(rescinsionArras.getCargas());
			}
			if (rescinsionArras.getInscripcionTitulo() != null) {
				dto.setInscripcionTituloMotivo(rescinsionArras.getInscripcionTitulo());
			}
			if (rescinsionArras.getPosesion() != null) {
				dto.setPosesion(rescinsionArras.getPosesion());
			}
			if (rescinsionArras.getTanteoDL() != null) {
				dto.setTanteoDLMotivo(rescinsionArras.getTanteoDL());
			}
			if (rescinsionArras.getTemasCatastrales() != null) {
				dto.setTemasCatastralesMotivo(rescinsionArras.getTemasCatastrales());
			}
			if (rescinsionArras.getTemasTecnicos() != null) {
				dto.setTemasTecnicos(rescinsionArras.getTemasTecnicos());
			}
		}
		
		return dto;
	}

	@Override
	@SuppressWarnings("unchecked")
	public DtoPage getListObservaciones(Long idExpediente, WebDto dto) {
		Page page = expedienteComercialDao.getObservacionesByExpediente(idExpediente, dto);

		List<DtoObservacion> observaciones = new ArrayList<DtoObservacion>();

		for (ObservacionesExpedienteComercial observacion : (List<ObservacionesExpedienteComercial>) page
				.getResults()) {
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
				nombreCompleto += " " + observacion.getUsuario().getApellido1();

				if (observacion.getUsuario().getApellido2() != null) {
					nombreCompleto += " " + observacion.getUsuario().getApellido2();
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
				activoPorcentajeParti.put(activoOferta.getPrimaryKey().getActivo().getId(),
						activoOferta.getPorcentajeParticipacion());
				if (!Checks.esNulo(activoOferta.getImporteActivoOferta())) {
					activoImporteParticipacion.put(activoOferta.getPrimaryKey().getActivo().getId(),
							(activoOferta.getImporteActivoOferta()));
				}
			}
		}

		// Por cada activo recorre todas sus valoraciones para adquirir el precio
		// aprobado de venta y el precio mínimo autorizado
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
			DtoActivosExpediente dtoActivo = activosToDto(activo, activoPorcentajeParti, activoPrecioAprobado,
					activoPrecioMinimo, activoImporteParticipacion);

			this.pilotosToDto(dtoActivo, expediente);

			if (!Checks.esNulo(activo.getLocalizacion().getLocalizacionBien().getPuerta())) {
				dtoActivo.setPuerta(activo.getLocalizacion().getLocalizacionBien().getPuerta());
			}

			if (!Checks.esNulo(activo.getTotalSuperficieConstruida())) {
				dtoActivo.setSuperficieConstruida(activo.getTotalSuperficieConstruida());
			}

			if (!Checks.esNulo(activo.getSubtipoActivo())) {
				dtoActivo.setSubtipoActivo(activo.getSubtipoActivo().getDescripcion());
			}

			ActivoAgrupacion agr = expediente.getOferta().getAgrupacion();
			if (!Checks.esNulo(agr)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activoId", activo.getId());
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "agrupacionId", agr.getId());
				VActivosSubdivision vActSub = genericDao.get(VActivosSubdivision.class, filtro, filtro2);

				if (!Checks.esNulo(vActSub)) {
					Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "agrupacionId", agr.getId());
					Filter filtro4 = genericDao.createFilter(FilterType.EQUALS, "id", vActSub.getIdSubdivision());
					VSubdivisionesAgrupacion vSubAgr = genericDao.get(VSubdivisionesAgrupacion.class, filtro3, filtro4);

					if (!Checks.esNulo(vSubAgr) && !Checks.esNulo(vSubAgr.getDescripcion())) {
						dtoActivo.setSubdivision(vSubAgr.getDescripcion());
					}
				}
			}

			activos.add(dtoActivo);

		}

		return new DtoPage(activos, activos.size());
	}
	
	@Override
	public DtoPage getActivosExpedienteExcel(Long idExpediente, Boolean esExcelActivos) {
		ExpedienteComercial expediente = findOne(idExpediente);
		List<DtoActivosExpediente> activos = new ArrayList<DtoActivosExpediente>();
		
		Filter oferta = genericDao.createFilter(FilterType.EQUALS, "oferta", expediente.getOferta().getId());
		List<VActivoOfertaImporte> activosExpediente = genericDao.getList(VActivoOfertaImporte.class, oferta);

		for (VActivoOfertaImporte activo : activosExpediente) {
			DtoActivosExpediente dtoActivo = new DtoActivosExpediente();
			dtoActivo.setIdActivo(activo.getActivo());
			dtoActivo.setNumActivo(activo.getNumActivo());

			if (esExcelActivos) {
				this.pilotosToDto(dtoActivo, expediente);
			} else {
				dtoActivo.setImporteParticipacion(activo.getImporteActivoOferta());
			}
			
			activos.add(dtoActivo);
		}

		return new DtoPage(activos, activos.size());
	}

	@Override
	public DtoPage getActivosExpedienteVista(Long idExpediente) {
		List<VListadoActivosExpedienteGrid> listadoActivosGrid;
		List<VListadoActivosExpedienteBbvaGrid> listadoActivosBbvaGrid;
		DtoPage dtoListActivosExpediente = null;
		if (DDCartera.CODIGO_CARTERA_BBVA.equals(getCodigoCarteraExpediente(idExpediente))) {
			listadoActivosBbvaGrid = genericDao.getList(VListadoActivosExpedienteBbvaGrid.class,
					genericDao.createFilter(FilterType.EQUALS, "idExpediente", idExpediente));
			
			dtoListActivosExpediente = new DtoPage(listadoActivosBbvaGrid, listadoActivosBbvaGrid.size());
		} else {
			listadoActivosGrid = genericDao.getList(VListadoActivosExpedienteGrid.class,
				genericDao.createFilter(FilterType.EQUALS, "idExpediente", idExpediente));
			dtoListActivosExpediente = new DtoPage(listadoActivosGrid, listadoActivosGrid.size()); 
		}
		return dtoListActivosExpediente;	 
	}
	
	@Override
	public Boolean getActivoExpedienteEpa(ExpedienteComercial expediente) {
		
		List<ActivoOferta> listaActivosOferta = null;
		
		if(expediente != null && expediente.getOferta() != null && expediente.getOferta().getActivosOferta() != null) {
			listaActivosOferta = expediente.getOferta().getActivosOferta();
			if(listaActivosOferta.get(0) != null && listaActivosOferta.get(0).getPrimaryKey().getActivo() != null
					&& DDCartera.CODIGO_CARTERA_BBVA.equals(listaActivosOferta.get(0).getPrimaryKey().getActivo().getCartera().getCodigo())) {
				for (ActivoOferta activosOferta : listaActivosOferta) {
					Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activosOferta.getPrimaryKey().getActivo().getId());
					ActivoBbvaActivos activoBbva  = genericDao.get(ActivoBbvaActivos.class, filtroActivo);
					if(activoBbva != null && activoBbva.getActivoEpa() != null && DDSinSiNo.CODIGO_SI.equals(activoBbva.getActivoEpa().getCodigo())) {
						return true;
					}
				}
			} else {
				return false;
			}
		}
		return false;
	}
	
	@Override
	public Boolean getActivoExpedienteAlquilado(ExpedienteComercial expediente) {
		
		List<ActivoOferta> listaActivosOferta = null;
		
		if(expediente != null && expediente.getOferta() != null && expediente.getOferta().getActivosOferta() != null) {
			listaActivosOferta = expediente.getOferta().getActivosOferta();
			if(listaActivosOferta.get(0) != null && listaActivosOferta.get(0).getPrimaryKey().getActivo() != null
					&& DDCartera.CODIGO_CARTERA_BBVA.equals(listaActivosOferta.get(0).getPrimaryKey().getActivo().getCartera().getCodigo())) {
				for (ActivoOferta activosOferta : listaActivosOferta) {
					Activo activo = activosOferta.getPrimaryKey().getActivo();
					if (activo != null && activo.getSituacionPosesoria().getOcupado() == 1
							&& DDTipoTituloActivoTPA.tipoTituloSi
									.equals(activo.getSituacionPosesoria().getConTitulo().getCodigo())){
						return true;
					}
				}
			} else {
				return false;
			}
		}
		return false;
	}
	
	/**
	 * Convierte una entidad Activo a objeto dto.
	 *
	 * @param activo: entidad a convertir a objeto
	 * @return Devuelve un dto con los datos de la entidad recibida.
	 */
	private DtoActivosExpediente activosToDto(Activo activo, Map<Long, Double> activoPorcentajeParti,
			Map<Long, Double> activoPrecioAprobado, Map<Long, Double> activoPrecioMinimo,
			Map<Long, Double> activoImporteParticipacion) {
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

		if (!Checks.esNulo(activo.getInfoRegistral())
				&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien())) {
			dtoActivo.setFincaRegistral(activo.getInfoRegistral().getInfoRegistralBien().getNumFinca());
		}

		return dtoActivo;
	}
	
	private DtoActivosExpediente pilotosToDto(DtoActivosExpediente dtoActivo, ExpedienteComercial expediente) {
		DtoInformeJuridico dtoInfoJuridico = this.getFechaEmisionInfJuridico(expediente.getId(), dtoActivo.getIdActivo());
		if (dtoInfoJuridico == null || dtoInfoJuridico.getFechaEmision() == null) {
			dtoActivo.setBloqueos(2);// pendiente

		} else {
			if (dtoInfoJuridico.getResultadoBloqueo() != null
					&& dtoInfoJuridico.getResultadoBloqueo().equals(InformeJuridico.RESULTADO_FAVORABLE)) {
				dtoActivo.setBloqueos(1);
			} else {
				dtoActivo.setBloqueos(0);
			}
		}

		DtoCondicionesActivoExpediente condiciones = this.getCondicionesActivoExpediete(expediente.getId(),
				dtoActivo.getIdActivo());
		if (condiciones.getSituacionPosesoriaCodigo() != null
				&& condiciones.getSituacionPosesoriaCodigoInformada() != null
				&& condiciones.getSituacionPosesoriaCodigo()
						.equals(condiciones.getSituacionPosesoriaCodigoInformada())
				&& condiciones.getPosesionInicial() != null && condiciones.getPosesionInicialInformada() != null
				&& condiciones.getPosesionInicial().equals(condiciones.getPosesionInicialInformada())
				&& condiciones.getEstadoTitulo() != null && condiciones.getEstadoTituloInformada() != null
				&& condiciones.getEstadoTitulo().equals(condiciones.getEstadoTituloInformada())) {
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
					if (tanteo.getActivo().getId().equals(dtoActivo.getIdActivo())) {
						contTanteosActivo++;
						if (tanteo.getResultadoTanteo() != null) {
							if (tanteo.getResultadoTanteo().getCodigo().equals(DDResultadoTanteo.CODIGO_EJERCIDO)) {
								dtoActivo.setTanteos(2);
								break;
							} else if (DDResultadoTanteo.CODIGO_RENUNCIADO
									.equals(tanteo.getResultadoTanteo().getCodigo())) {
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
		List<AdjuntoExpedienteComercial> adjuntos = new ArrayList<AdjuntoExpedienteComercial>();
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			ExpedienteComercial expedienteComercial = this.findOneByTrabajo(trabajoApi.findOne(idTrabajo));
			if(expedienteComercial != null && expedienteComercial.getOferta() != null && expedienteComercial.getOferta().getTipoOferta() != null) {
				String codigoOferta = expedienteComercial.getOferta().getTipoOferta().getCodigo();
				try {
					listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosExpedienteComercial(expedienteComercial);
					Filter filterTipo = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoExpediente.tipoOferta.codigo",codigoOferta);
					for (DtoAdjunto adj : listaAdjuntos) {
						DDSubtipoDocumentoExpediente subtipoDocumento = genericDao.get(DDSubtipoDocumentoExpediente.class, 
								genericDao.createFilter(FilterType.EQUALS, "matricula", adj.getMatricula()), filterTipo);
						if (subtipoDocumento != null && codigoDocumento.equals(subtipoDocumento.getCodigo())) {
							return true;
						}
					}
				} catch (GestorDocumentalException gex) {
					logger.error(gex.getMessage(), gex);
				}
			}
		} else {
			Filter filtroTrabajoEC = genericDao.createFilter(FilterType.EQUALS, "expediente.trabajo.id", idTrabajo);
			Filter filtroAdjuntoSubtipoCodigo = genericDao.createFilter(FilterType.EQUALS,
					"subtipoDocumentoExpediente.codigo", codigoDocumento);
	
			adjuntos = genericDao.getList(AdjuntoExpedienteComercial.class,
					filtroTrabajoEC, filtroAdjuntoSubtipoCodigo);
		}
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
		} else {
			expedienteComercial = expedienteComercialEntrada;
		}

		if (fileItem.getParameter("tipo") == null) {
			throw new Exception("Tipo no valido");
		}

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
		tipoDocumento = genericDao.get(DDTipoDocumentoExpediente.class, filtro);

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

		Filter filtroSubtipo = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("subtipo"));
		adjuntoExpediente
				.setSubtipoDocumentoExpediente(genericDao.get(DDSubtipoDocumentoExpediente.class, filtroSubtipo));

		adjuntoExpediente.setContentType(fileItem.getFileItem().getContentType());
		adjuntoExpediente.setTamanyo(fileItem.getFileItem().getLength());
		adjuntoExpediente.setNombre(fileItem.getFileItem().getFileName());
		adjuntoExpediente.setDescripcion(fileItem.getParameter("descripcion"));
		adjuntoExpediente.setFechaDocumento(new Date());
		adjuntoExpediente.setIdDocRestClient(idDocRestClient);
		Auditoria.save(adjuntoExpediente);

		for (AdjuntoExpedienteComercial adjuntoExpedienteAux : expedienteComercial.getAdjuntos()) {
			if (DDSubtipoDocumentoExpediente.CODIGO_PRE_LIQUIDACION_ITP
					.equals(adjuntoExpedienteAux.getSubtipoDocumentoExpediente().getCodigo())
					&& DDSubtipoDocumentoExpediente.CODIGO_PRE_CONTRATO
							.equals(adjuntoExpediente.getSubtipoDocumentoExpediente().getCodigo())) {
				this.enviarCorreoSubidaDeContrato(expedienteComercial.getId());
			} else if (DDSubtipoDocumentoExpediente.CODIGO_PRE_CONTRATO
					.equals(adjuntoExpedienteAux.getSubtipoDocumentoExpediente().getCodigo())
					&& DDSubtipoDocumentoExpediente.CODIGO_PRE_LIQUIDACION_ITP
							.equals(adjuntoExpediente.getSubtipoDocumentoExpediente().getCodigo())) {
				this.enviarCorreoSubidaDeContrato(expedienteComercial.getId());
			}
		}

		expedienteComercial.getAdjuntos().add(adjuntoExpediente);

		genericDao.save(ExpedienteComercial.class, expedienteComercial);

		for (ActivoOferta activoOferta : expedienteComercial.getOferta().getActivosOferta()) {
			if (!Checks.esNulo(adjuntoExpediente) && !Checks.esNulo(adjuntoExpediente.getSubtipoDocumentoExpediente())
					&& !Checks.esNulo(adjuntoExpediente.getSubtipoDocumentoExpediente().getMatricula())) {
				Activo activo = activoApi.get(activoOferta.getPrimaryKey().getActivo().getId());
				activoAdapter.uploadDocumento(fileItem, activo,
						adjuntoExpediente.getSubtipoDocumentoExpediente().getMatricula(), null);
				// HREOS-5392
				// Se comprueba que el documento que sube es el de deposito despublicacion
				// activo
				// Se comprueba cartera Cerberus subcarteras Agora
				// Cambia la situación comercial a '04' Disponible para la venta con reserva de
				// cada activo incluido en la oferta del expediente
				// Lanza el SP para ocultar el/los activo/s con motivo Reservado
				if (DDSubtipoDocumentoExpediente.CODIGO_DEPOSITO_DESPUBLICACION_ACTIVO
						.equals(adjuntoExpediente.getSubtipoDocumentoExpediente().getCodigo())
						&& DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo())
						&& ((DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))
								|| (DDSubcartera.CODIGO_AGORA_FINANCIERO.equals(activo.getSubcartera().getCodigo()))
								|| (DDSubcartera.CODIGO_APPLE_INMOBILIARIO
										.equals(activo.getSubcartera().getCodigo())))) {
					activo.setSituacionComercial(genericDao.get(DDSituacionComercial.class, genericDao.createFilter(
							FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_RESERVA)));
					activoDao.publicarActivoConHistorico(activo.getId(),
							genericAdapter.getUsuarioLogado().getUsername(), null, true);
				}
				if (activo.getAdjuntos() != null && activo.getAdjuntos().size() > 0) {
					adjuntoActivo = activo.getAdjuntos().get(activo.getAdjuntos().size() - 1);
				}
			}
		}

		if (!Checks.esNulo(adjuntoActivo) && !Checks.esNulo(adjuntoActivo.getIdDocRestClient())) {
			adjuntoExpediente.setIdDocRestClient(adjuntoActivo.getIdDocRestClient());
			genericDao.update(AdjuntoExpedienteComercial.class, adjuntoExpediente);
		}

		return null;
	}

	@Override
	public Long uploadDocumentoGestorDocumental(ExpedienteComercial expedienteComercial, WebFileItem webFileItem,
			DDSubtipoDocumentoExpediente subtipoDocumento, String username) throws Exception {
		Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoExpedienteComercial(expedienteComercial,
				webFileItem, username, subtipoDocumento.getMatricula());
		if (!Checks.esNulo(idDocRestClient)) {
			uploadDocumento(webFileItem, idDocRestClient, expedienteComercial, null);
			String activos = webFileItem.getParameter("activos");
			String[] arrayActivos = null;

			if (activos != null && !activos.isEmpty()) {
				arrayActivos = activos.split(",");
			}
			if (arrayActivos != null && arrayActivos.length > 0) {
				CrearRelacionExpedienteDto crearRelacionExpedienteDto = new CrearRelacionExpedienteDto();
				crearRelacionExpedienteDto.setTipoRelacion(RELACION_TIPO_DOCUMENTO_EXPEDIENTE);
				String mat = subtipoDocumento.getMatricula();
				if (!Checks.esNulo(mat)) {
					String[] matSplit = mat.split("-");
					crearRelacionExpedienteDto.setCodTipoDestino(matSplit[0]);
					crearRelacionExpedienteDto.setCodClaseDestino(matSplit[1]);
				}
				crearRelacionExpedienteDto.setOperacion(OPERACION_ALTA);

				gestorDocumentalAdapterApi.crearRelacionActivosExpediente(expedienteComercial, idDocRestClient,
						arrayActivos, username, crearRelacionExpedienteDto);
				if (!Checks.esNulo(subtipoDocumento.getTipoDocumentoActivo())) {
					webFileItem.putParameter("tipo", subtipoDocumento.getTipoDocumentoActivo().getCodigo());
				}
				for (int i = 0; i < arrayActivos.length; i++) {
					Activo activoEntrada = activoApi.getByNumActivo(Long.parseLong(arrayActivos[i], 10));
					// Según item HREOS-2379:
					// Adjuntar el documento a la tabla de adjuntos del activo, pero sin subir el
					// documento realmente, sólo insertando la fila.
					File file = File.createTempFile("idDocRestClient[" + idDocRestClient + "]", ".pdf");
					BufferedWriter out = new BufferedWriter(new FileWriter(file));
					try {
						out.write("pfs");
					} finally {
						out.close();
					}
					FileItem fileItem = new FileItem();
					fileItem.setFileName("idDocRestClient[" + idDocRestClient + "]");
					fileItem.setFile(file);
					fileItem.setLength(file.length());
					webFileItem.setFileItem(fileItem);
					activoManager.uploadDocumento(webFileItem, idDocRestClient, activoEntrada,
							subtipoDocumento.getMatricula());
					if (!file.delete()) {
						logger.error("Imposible borrar temporal");
					}
				}
			}

			return idDocRestClient;
		}

		return null;
	}

	@Override
	@Transactional(readOnly = false)
	public void uploadDocumentosBulkGD(List<Long> listaIdsExpedientesCom, WebFileItem webFileItem,
			String codSubtipoDocumento, String username) throws Exception {

		TransactionStatus transaction = null;
		try {
			
			Filter filtroSubtipo = genericDao.createFilter(FilterType.EQUALS, "codigo", codSubtipoDocumento);
			DDSubtipoDocumentoExpediente sde = genericDao.get(DDSubtipoDocumentoExpediente.class, filtroSubtipo);

			if (!Checks.estaVacio(listaIdsExpedientesCom)) {
				for (Long idExpedienteComercial : listaIdsExpedientesCom) {
					transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
					ExpedienteComercial eco = findOne(idExpedienteComercial);
					// Este método contiene la comprobación del contenedor y en su defecto, lo crea.
					expedienteComercialAdapter.getAdjuntosExpedienteComercial(idExpedienteComercial);
					// Subida de documento al GD y a BBDD.
					uploadDocumentoGestorDocumental(eco, webFileItem, sde, username);
					transactionManager.commit(transaction);
				}
			}

		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
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
	@Transactional(readOnly = false)
	public Boolean existeDocSubtipo(WebFileItem fileItem, ExpedienteComercial expedienteComercialEntrada)
			throws Exception {

		Boolean existe = Boolean.FALSE;

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("subtipo"));
		DDSubtipoDocumentoExpediente subTipoDocumento = genericDao.get(DDSubtipoDocumentoExpediente.class, filtro);

		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
		DDTipoDocumentoExpediente tipoDocumento = (DDTipoDocumentoExpediente) genericDao
				.get(DDTipoDocumentoExpediente.class, filtroTipo);
		if (expedienteComercialDao.hayDocumentoSubtipo(Long.valueOf(fileItem.getParameter("idEntidad")),
				tipoDocumento.getId(), subTipoDocumento.getId()) >= 1) {

			existe = Boolean.TRUE;
		}
		;

		return existe;
	}

	@Override
	public Page getCompradoresByExpediente(Long idExpediente, WebDto dto) {
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		if (DDCartera.CODIGO_CARTERA_BANKIA
				.equals(expedienteComercial.getOferta().getActivoPrincipal().getCartera().getCodigo())) {
			PageImpl page = (PageImpl) expedienteComercialDao.getCompradoresByExpediente(idExpediente, dto, true);
			try {
				decorarPagina(page);
			} catch (VBusquedaCompradoresExpedienteDecoratorException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			return page;
		} else {
			return expedienteComercialDao.getCompradoresByExpediente(idExpediente, dto, false);
		}

	}
	
	@Override
	public Float getPorcentajeCompra(Long idExpediente) {
		return expedienteComercialDao.getPorcentajeCompra(idExpediente);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void decorarPagina(PageImpl pagina) throws VBusquedaCompradoresExpedienteDecoratorException {
		List results = pagina.getResults();
		pagina.setResults(decorarLista(results));
	}

	private List<?> decorarLista(List<Object[]> results) throws VBusquedaCompradoresExpedienteDecoratorException {
		List<VBusquedaCompradoresExpedienteDecorator> decorada = new ArrayList<VBusquedaCompradoresExpedienteDecorator>();
		for (Object[] item : results) {
			decorada.add(VBusquedaCompradoresExpedienteDecorator.buildFrom(item));
		}
		return decorada;
	}

	@Override
	public VBusquedaDatosCompradorExpediente getDatosCompradorById(Long idCom, Long idExp) {
		Filter filtroCom = genericDao.createFilter(FilterType.EQUALS, "id", idCom);
		Filter filtroEco = genericDao.createFilter(FilterType.EQUALS, "idExpedienteComercial", idExp);

		return genericDao.get(VBusquedaDatosCompradorExpediente.class, filtroCom, filtroEco);
	}

	@Override
	public VBusquedaDatosCompradorExpediente getDatCompradorById(Long idCom) {
		Filter filtroCom = genericDao.createFilter(FilterType.EQUALS, "id", idCom);

		return genericDao.getList(VBusquedaDatosCompradorExpediente.class, filtroCom).get(0);
	}

	private DtoCondiciones expedienteToDtoCondiciones(ExpedienteComercial expediente) {
		DtoCondiciones dto = new DtoCondiciones();
		CondicionanteExpediente condiciones = expediente.getCondicionante();
		DatosInformeFiscal informeFiscal = genericDao.get(DatosInformeFiscal.class, 
				genericDao.createFilter(FilterType.EQUALS,"oferta",expediente.getOferta()));

		Oferta oferta = expediente.getOferta();

		// Si el expediente pertenece a una agrupación miramos el activo principal
		if (!Checks.esNulo(expediente.getOferta().getAgrupacion())) {
			Activo activoPrincipal = expediente.getOferta().getActivoPrincipal();

			if (!Checks.esNulo(activoPrincipal)) {
				dto.setFechaUltimaActualizacion(activoPrincipal.getFechaRevisionCarga());
				dto.setVpo(activoPrincipal.getVpo());

				if (!Checks.esNulo(activoPrincipal.getSituacionPosesoria())) {
					dto.setFechaTomaPosesion(activoPrincipal.getSituacionPosesoria().getFechaTomaPosesion());
					dto.setOcupado(activoPrincipal.getSituacionPosesoria().getOcupado());
					if (!Checks.esNulo(activoPrincipal.getSituacionPosesoria().getConTitulo())) {
						dto.setConTitulo(activoPrincipal.getSituacionPosesoria().getConTitulo().getCodigo());
					}
					if (!Checks.esNulo(activoPrincipal.getSituacionPosesoria().getTipoTituloPosesorio())) {
						dto.setTipoTitulo(
								activoPrincipal.getSituacionPosesoria().getTipoTituloPosesorio().getDescripcion());
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
					if (!Checks.esNulo(activo.getSituacionPosesoria().getConTitulo())) {
						dto.setConTitulo(activo.getSituacionPosesoria().getConTitulo().getCodigo());
					}
					if (!Checks.esNulo(activo.getSituacionPosesoria().getTipoTituloPosesorio())) {
						dto.setTipoTitulo(activo.getSituacionPosesoria().getTipoTituloPosesorio().getDescripcion());
					}
				}
			}
		}

		if (!Checks.esNulo(condiciones)) {
			// Económicas-Financiación
			Integer solFinanciacion = null;
			if (!Checks.esNulo(condiciones.getSolicitaFinanciacion())){
				solFinanciacion = DDSnsSiNoNosabe.CODIGO_SI.equals(condiciones.getSolicitaFinanciacion().getCodigo()) ? 1 : 0;
			}
			dto.setSolicitaFinanciacion(solFinanciacion);
			if (!Checks.esNulo(condiciones.getEstadoFinanciacion())) {
				dto.setEstadosFinanciacion(condiciones.getEstadoFinanciacion().getCodigo());
			}
			dto.setEntidadFinanciacion(condiciones.getEntidadFinanciacion());
			dto.setFechaInicioExpediente(condiciones.getFechaInicioExpediente());
			dto.setFechaInicioFinanciacion(condiciones.getFechaInicioFinanciacion());
			dto.setFechaFinFinanciacion(condiciones.getFechaFinFinanciacion());

			// Económicas-Reserva
			dto.setSolicitaReserva(condiciones.getSolicitaReserva());
			if (!Checks.esNulo(condiciones.getDepositoReserva())) {
				dto.setDepositoReserva(condiciones.getDepositoReserva());
			}
			if (!Checks.esNulo(condiciones.getTipoCalculoReserva())) {
				dto.setTipoCalculo(condiciones.getTipoCalculoReserva().getCodigo());
			}
			dto.setPorcentajeReserva(condiciones.getPorcentajeReserva());
			dto.setPlazoFirmaReserva(condiciones.getPlazoFirmaReserva());
			dto.setImporteReserva(condiciones.getImporteReserva());

			// Economicas-Fiscales
			if (!Checks.esNulo(condiciones.getTipoImpuesto())) {
				if(oferta != null && oferta.getTipoOferta() != null && oferta.getTipoOferta().getCodigo() != null) {
					if(DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
						dto.setTipoImpuestoCodigo(condiciones.getTipoImpuesto().getCodigo());
					}else{
						dto.setTipoImpuestoCodigoAlq(condiciones.getTipoImpuesto().getCodigo());
					}
				}else{
					dto.setTipoImpuestoCodigo(condiciones.getTipoImpuesto().getCodigo());
				}

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

			// Condiciones expediente tipo alquiler
			if (!Checks.esNulo(condiciones.getMesesFianza())) {
				dto.setMesesFianza(condiciones.getMesesFianza());
			}

			if (!Checks.esNulo(condiciones.getImporteFianza())) {
				dto.setImporteFianza(condiciones.getImporteFianza());
			}

			if (!Checks.esNulo(condiciones.getFianzaActualizable())) {
				dto.setFianzaActualizable(condiciones.getFianzaActualizable());
			}

			if (!Checks.esNulo(condiciones.getMesesFianza())) {
				dto.setMesesFianza(condiciones.getMesesFianza());
			}

			if (!Checks.esNulo(condiciones.getMesesDeposito())) {
				dto.setMesesDeposito(condiciones.getMesesDeposito());
			}

			if (!Checks.esNulo(condiciones.getImporteDeposito())) {
				dto.setImporteDeposito(condiciones.getImporteDeposito());
			}

			if (!Checks.esNulo(condiciones.getDepositoActualizable())) {
				dto.setDepositoActualizable(condiciones.getDepositoActualizable());
			}

			if (!Checks.esNulo(condiciones.getAvalista())) {
				dto.setAvalista(condiciones.getAvalista());
			}

			if (!Checks.esNulo(condiciones.getEntidadBancariaFiador())) { // ############################### ERROR
																			// ###############
				dto.setCodigoEntidad(condiciones.getEntidadBancariaFiador().getCodigo());
			}

			if (!Checks.esNulo(condiciones.getDocumentoFiador())) {
				dto.setDocumentoFiador(condiciones.getDocumentoFiador());
			}

			if (!Checks.esNulo(condiciones.getImporteAval())) {
				Double aux = condiciones.getImporteAval();
				String importeAval = String.valueOf(aux);
				dto.setImporteAval(importeAval);
			}

			if (!Checks.esNulo(condiciones.getNumeroAval())) {
				Integer aux = condiciones.getNumeroAval();
				dto.setNumeroAval(aux);
			}
			if (!Checks.esNulo(condiciones.getRenunciaTanteo())) {
				dto.setRenunciaTanteo(condiciones.getRenunciaTanteo());
			}

			if (!Checks.esNulo(condiciones.getCarencia())) {
				dto.setCarencia(condiciones.getCarencia());
			}

			if (!Checks.esNulo(condiciones.getMesesCarencia())) {
				Integer aux = condiciones.getMesesCarencia();
				String mesesCarencia = String.valueOf(aux);
				dto.setMesesCarencia(mesesCarencia);
			}

			if (!Checks.esNulo(condiciones.getImporteCarencia())) {
				Double aux = condiciones.getImporteCarencia();
				String importeCarencia = String.valueOf(aux);
				dto.setImporteCarencia(importeCarencia);
			}

			if (!Checks.esNulo(condiciones.getBonificacion())) {
				dto.setBonificacion(condiciones.getBonificacion());
			}

			if (!Checks.esNulo(condiciones.getMesesBonificacion())) {
				Integer aux = condiciones.getMesesBonificacion();
				String mesesBonificacion = String.valueOf(aux);
				dto.setMesesBonificacion(mesesBonificacion);
			}

			if (!Checks.esNulo(condiciones.getImporteBonificacion())) {
				Double aux = condiciones.getImporteBonificacion();
				String importeBonificaicon = String.valueOf(aux);
				dto.setImporteBonificacion(importeBonificaicon);
			}

			if (!Checks.esNulo(condiciones.getDuracionBonificacion())) {
				Integer aux = condiciones.getDuracionBonificacion();
				String duracionBonificacion = String.valueOf(aux);
				dto.setDuracionBonificacion(duracionBonificacion);
			}

			if (!Checks.esNulo(condiciones.getGastosRepercutibles())) {
				dto.setGastosRepercutibles(condiciones.getGastosRepercutibles());
			}

			if (!Checks.esNulo(condiciones.getRepercutiblesComments())) {
				dto.setRepercutiblesComments(condiciones.getRepercutiblesComments());
			}

			if (!Checks.esNulo(condiciones.getEntidadComments())) {
				dto.setEntidadComments(condiciones.getEntidadComments());
			}

			if (!Checks.esNulo(condiciones.getEntidadComments())) {
				dto.setEntidadComments(condiciones.getEntidadComments());
			}

			if (!Checks.esNulo(condiciones.getCheckFijo())) {
				dto.setCheckFijo(condiciones.getCheckFijo());
			}
			if (!Checks.esNulo(condiciones.getFechaFijo())) {
				dto.setFechaFijo(condiciones.getFechaFijo());
			}

			dto.setIncrementoRentaFijo(condiciones.getIncrementoRentaFijo());

			if (!Checks.esNulo(condiciones.getCheckPorcentual())) {
				dto.setCheckPorcentual(condiciones.getCheckPorcentual());
			}

			if (!Checks.esNulo(condiciones.getCheckIPC())) {
				dto.setCheckIPC(condiciones.getCheckIPC());
			}
			if (!Checks.esNulo(condiciones.getPorcentaje())) {
				dto.setPorcentaje(condiciones.getPorcentaje());
			}
			if (!Checks.esNulo(condiciones.getCheckRevisionMercado())) {
				dto.setCheckRevisionMercado(condiciones.getCheckRevisionMercado());
			}
			if (!Checks.esNulo(condiciones.getRevisionMercadoFecha())) {
				dto.setRevisionMercadoFecha(condiciones.getRevisionMercadoFecha());
			}
			if (!Checks.esNulo(condiciones.getRevisionMercadoMeses())) {
				dto.setRevisionMercadoMeses(condiciones.getRevisionMercadoMeses());
			}
			if (!Checks.esNulo(condiciones.getTributosSobrePropiedad())) {
				dto.setTributosSobrePropiedad(condiciones.getTributosSobrePropiedad());
			}
			if (informeFiscal != null) {
				if (informeFiscal.getNecesidadIf() != null) {
					dto.setNecesidadIf(informeFiscal.getNecesidadIf());
				}
			}

			List<HistoricoCondicionanteExpediente> listaHistorico = condiciones.getListHistoricoCondiciones();
			if (!Checks.esNulo(listaHistorico)) {
				int numero_historico = 0;
				Date fechaMinima = new Date();
				for (HistoricoCondicionanteExpediente histC : listaHistorico) {
					if (histC.getFecha().compareTo(fechaMinima) > 0) {
						fechaMinima = histC.getFecha();
					}
					numero_historico++;
				}
				dto.setFechaMinima(fechaMinima);
				if (numero_historico >= 10)
					dto.setInsertarHistorico(false);
				else
					dto.setInsertarHistorico(true);
			}

		}
		
		dto.setFianzaExonerada(condiciones.getFianzaExonerada());
		dto.setFechaIngresoFianzaArrendatario(condiciones.getFechaIngresoFianzaArrendatario());
		dto.setDerechoCesionSubarriendo(condiciones.getDerechoCesionSubarriendo());
		
		
		dto.setVulnerabilidadDetectada(condiciones.getVulnerabilidadDetectada());
		if(condiciones.getRegimenFianzaCCAA() != null) {
			dto.setRegimenFianzaCCAACodigo(condiciones.getRegimenFianzaCCAA().getCodigo());
		}
		dto.setCertificaciones(condiciones.getCertificaciones());
		dto.setOfrNuevasCondiciones(condiciones.getOfrNuevasCondiciones());
		dto.setFianzaContratosSubrogados(condiciones.getFianzaContratosSubrogados());
		dto.setAdecuaciones(condiciones.getAdecuaciones());
		dto.setCntSuscritoPosteridadAdj(condiciones.getCntSuscritoPosteridadAdj());
		dto.setAntiguoDeudorLocalizable(condiciones.getAntiguoDeudorLocalizable());
		
		dto.setRentasCuenta(condiciones.getRentasCuenta());
		dto.setEntregasCuenta(condiciones.getEntregasCuenta());
		dto.setImporteEntregasCuenta(condiciones.getImporteEntregasCuenta());
		
		dto.setObligadoCumplimiento(condiciones.getObligadoCumplimiento());
		dto.setFechaPreavisoVencimientoCnt(condiciones.getFechaPreavisoVencimientoCnt());
		
		if(condiciones.getMetodoActualizacionRenta() != null) {
			dto.setMetodoActualizacionRentaCod(condiciones.getMetodoActualizacionRenta().getCodigo());
		}
		dto.setFechaActualizacion(condiciones.getFechaActualizacion());
		dto.setPeriodicidadMeses(condiciones.getPeriodicidadMeses());
		
		dto.setCheckIGC(condiciones.getCheckIGC());
		
		if(condiciones.getMesesDuracion() != null) {
			dto.setMesesDuracion(condiciones.getMesesDuracion());
		}
		
		if(oferta != null) {
			dto.setFechaInicioCnt(oferta.getFechaInicioContrato());
			dto.setFechaFinCnt(oferta.getFechaFinContrato());
		}
		

		if (condiciones.getTipoGrupoImpuesto() != null) {
			if(oferta != null && oferta.getTipoOferta() != null && oferta.getTipoOferta().getCodigo() != null) {
				if(DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
					dto.setTipoGrupoImpuestoCod(condiciones.getTipoGrupoImpuesto().getCodigo());
				}
				else {
					dto.setTipoGrupoImpuestoCodAlq(condiciones.getTipoGrupoImpuesto().getCodigo());
				}
			}else {
				dto.setTipoGrupoImpuestoCod(condiciones.getTipoGrupoImpuesto().getCodigo());
			}
		}
		
		boolean completada = false;
		dto.setBloqueDepositoEditable(false);
		if(expediente.getTrabajo() != null) {
			ActivoTramite tramite = tramiteDao.getTramiteComercialVigenteByTrabajoYCodTipoTramite(expediente.getTrabajo().getId(),CODIGO_TRAMITE_T015);
			if(tramite != null) {
				completada = tareaActivoApi.getSiTareaCompletada(tramite.getId(), ComercialUserAssigantionService.CODIGO_T015_SOLICITAR_GARANTIAS_ADICIONALES);
				
				if(completada) {
					dto.setBloqueDepositoEditable(false);
				}else {
					dto.setBloqueDepositoEditable(true);
				}	
			}
			
			tramite = tramiteDao.getTramiteComercialVigenteByTrabajoYCodTipoTramite(expediente.getTrabajo().getId(),CODIGO_TRAMITE_T018);
			if(tramite != null) {
				completada = tareaActivoApi.getSiTareaCompletada(tramite.getId(), ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_SOLICITAR_GARANTIAS_ADICIONALES);
				
				if(completada) {
					dto.setBloqueDepositoEditable(false);
				}else{
					dto.setBloqueDepositoEditable(true);
				}
			}
		}
		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public List<DtoTipoDocExpedientes> getTipoDocumentoExpediente(String tipoExpediente) {

		List<DtoTipoDocExpedientes> listDto = new ArrayList<DtoTipoDocExpedientes>();
		List<DDTipoDocumentoExpediente> listaTipDocExp = new ArrayList<DDTipoDocumentoExpediente>();

		if (!Checks.esNulo(tipoExpediente)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tipoOferta.codigo", tipoExpediente);
			listaTipDocExp = genericDao.getList(DDTipoDocumentoExpediente.class, filtro);
		}

		for (DDTipoDocumentoExpediente tipDocExp : listaTipDocExp) {
			DtoTipoDocExpedientes aux = new DtoTipoDocExpedientes();
			aux.setId(tipDocExp.getId());
			aux.setCodigo(tipDocExp.getCodigo());
			aux.setDescripcion(tipDocExp.getDescripcion());
			aux.setDescripcionLarga(tipDocExp.getDescripcionLarga());
			listDto.add(aux);
		}

		Collections.sort(listDto);
		return listDto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveCondicionesExpediente(DtoCondiciones dto, Long idExpediente) {
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		CondicionanteExpediente condiciones = expedienteComercial.getCondicionante();
		DDEntidadesAvalistas entidadAvalista = new DDEntidadesAvalistas();
		if (!Checks.esNulo(dto.getCodigoEntidad())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoEntidad());
			entidadAvalista = genericDao.get(DDEntidadesAvalistas.class, filtro);
		}
		if (!Checks.esNulo(condiciones)) {
			condiciones = dtoCondicionantestoCondicionante(condiciones, dto);
			expedienteComercial.setCondicionante(condiciones);
			if (!Checks.esNulo(dto.getCodigoEntidad())) {
				condiciones.setEntidadBancariaFiador(entidadAvalista);
			}
			if (!Checks.esNulo(condiciones.getSolicitaReserva()) && condiciones.getSolicitaReserva() == 0) {
				Reserva reserva = expedienteComercial.getReserva();
				if (!Checks.esNulo(reserva)) {
					reserva.getAuditoria().setBorrado(true);
					genericDao.update(Reserva.class, reserva);
				}
			} else {
				Reserva reserva = expedienteComercial.getReserva();
				if (!Checks.esNulo(reserva)) {
					reserva.getAuditoria().setBorrado(false);
					if (!Checks.esNulo(dto.getPlazoFirmaReserva()) && !Checks.esNulo(reserva.getFechaFirma())) {
						Calendar calendar = Calendar.getInstance();
						calendar.setTime(reserva.getFechaFirma());
						if(!Checks.esNulo(dto.getPlazoFirmaReserva())){
							calendar.add(Calendar.DAY_OF_YEAR, dto.getPlazoFirmaReserva());
						}
						reserva.setFechaVencimiento(calendar.getTime());
					}
					genericDao.update(Reserva.class, reserva);
				}

			}
			genericDao.save(CondicionanteExpediente.class, condiciones);
			createReservaExpediente(expedienteComercial);
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean savePlusvaliaVenta(DtoPlusvaliaVenta dto, Long idExpediente) {
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		PlusvaliaVentaExpedienteComercial plusvalia = new PlusvaliaVentaExpedienteComercial();
		plusvalia = (PlusvaliaVentaExpedienteComercial) genericDao.get(PlusvaliaVentaExpedienteComercial.class,
				genericDao.createFilter(FilterType.EQUALS, "expediente.id", expedienteComercial.getId()));

		if (!Checks.esNulo(plusvalia)) {
			plusvalia = dtoPlusvaliToPlusvalia(plusvalia, dto);
			genericDao.save(PlusvaliaVentaExpedienteComercial.class, plusvalia);

		} else {
			PlusvaliaVentaExpedienteComercial plusvaliaNueva = new PlusvaliaVentaExpedienteComercial();
			plusvaliaNueva.setExpediente(expedienteComercial);
			plusvaliaNueva.setExento(dto.getExento());
			plusvaliaNueva.setAutoliquidacion(dto.getAutoliquidacion());
			plusvaliaNueva.setFechaEscritoAyt(dto.getFechaEscritoAyt());
			plusvaliaNueva.setObservaciones(dto.getObservaciones());
			genericDao.save(PlusvaliaVentaExpedienteComercial.class, plusvaliaNueva);
		}

		createReservaExpediente(expedienteComercial);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public CondicionesActivo crearCondicionesActivoExpediente(Long idActivo, ExpedienteComercial expediente) {
		return this.crearCondicionesActivoExpediente(activoAdapter.getActivoById(idActivo), expediente);
	}

	@Override
	@Transactional(readOnly = false)
	public CondicionesActivo crearCondicionesActivoExpediente(Activo activo, ExpedienteComercial expediente) {
		// Como este método es para la creación del expediente crea directamente las
		// condiciones, no busca si ya existen condiciones del Expediente-Activo.
		CondicionesActivo condicionesActivo = new CondicionesActivo();
		condicionesActivo.setActivo(activo);
		condicionesActivo.setExpediente(expediente);
		condicionesActivo.setAuditoria(Auditoria.getNewInstance());

		// Activos de Cajamar, deben copiar las condiciones informadas del activo en las
		// condiciones al comprador.
		if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getCartera())
				&& DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())) {
			if (activo.getSituacionPosesoria() != null
					&& activo.getSituacionPosesoria().getFechaTomaPosesion() != null) {
				condicionesActivo.setPosesionInicial(1);

			} else {
				condicionesActivo.setPosesionInicial(0);
			}

			if (activo.getTitulo() != null && activo.getTitulo().getEstado() != null) {
				condicionesActivo.setEstadoTitulo(activo.getTitulo().getEstado());
			}

			if (activo.getSituacionPosesoria() != null) {
				if (activo.getSituacionPosesoria().getOcupado() != null
						&& activo.getSituacionPosesoria().getOcupado().equals(0)) {
					DDSituacionesPosesoria situacionPosesoriaLibre = (DDSituacionesPosesoria) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDSituacionesPosesoria.class,
									DDSituacionesPosesoria.SITUACION_POSESORIA_LIBRE);
					condicionesActivo.setSituacionPosesoria(situacionPosesoriaLibre);

				} else if (activo.getSituacionPosesoria().getOcupado() != null
						&& activo.getSituacionPosesoria().getOcupado().equals(1)
						&& !Checks.esNulo(activo.getSituacionPosesoria().getConTitulo())
						&& activo.getSituacionPosesoria().getConTitulo().getCodigo()
								.equals(DDTipoTituloActivoTPA.tipoTituloSi)) {
					DDSituacionesPosesoria situacionPosesoriaOcupadoTitulo = (DDSituacionesPosesoria) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDSituacionesPosesoria.class,
									DDSituacionesPosesoria.SITUACION_POSESORIA_OCUPADO_CON_TITULO);
					condicionesActivo.setSituacionPosesoria(situacionPosesoriaOcupadoTitulo);

				} else if (activo.getSituacionPosesoria().getOcupado() != null
						&& activo.getSituacionPosesoria().getOcupado().equals(1)
						&& activo.getSituacionPosesoria().getConTitulo() != null
						&& (DDTipoTituloActivoTPA.tipoTituloNo
								.equals(activo.getSituacionPosesoria().getConTitulo().getCodigo())
								|| activo.getSituacionPosesoria().getConTitulo()
										.equals(DDTipoTituloActivoTPA.tipoTituloNoConIndicios))) {
					DDSituacionesPosesoria situacionPosesoriaOcupadoSinTitulo = (DDSituacionesPosesoria) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDSituacionesPosesoria.class,
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
				DDEstadosReserva estadoReserva = (DDEstadosReserva) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDEstadosReserva.class, DDEstadosReserva.CODIGO_PENDIENTE_FIRMA);
				reserva.setEstadoReserva(estadoReserva);
				reserva.setExpediente(expediente);
				reserva.setNumReserva(reservaDao.getNextNumReservaRem());
				reserva.setAuditoria(Auditoria.getNewInstance());
				
				if(expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null && DDCartera.isCarteraBk(expediente.getOferta().getActivoPrincipal().getCartera())) {
					DDTiposArras tipoArras = (DDTiposArras) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposArras.class, DDTiposArras.PENITENCIALES);
					reserva.setTipoArras(tipoArras);
				}
				if (DDCartera.isCarteraBk(expediente.getOferta().getActivoPrincipal().getCartera())) {
					CondicionesReserva condicionesReserva = new CondicionesReserva();
					condicionesReserva.setAuditoria(Auditoria.getNewInstance());
					condicionesReserva.setReserva(reserva);
					genericDao.save(CondicionesReserva.class, condicionesReserva);
					
					MotivoRescinsionArras rescinsionArras = new MotivoRescinsionArras();
					rescinsionArras.setAuditoria(Auditoria.getNewInstance());
					rescinsionArras.setReserva(reserva);
					genericDao.save(MotivoRescinsionArras.class, rescinsionArras);
				}
				
			}
		}

		if (!Checks.esNulo(reserva))
			genericDao.save(Reserva.class, reserva);

		// Actualiza la disponibilidad comercial del activo
		ofertaApi.updateStateDispComercialActivosByOferta(expediente.getOferta());

		return reserva;
	}

	/**
	 * Este método inyecta los datos del dto hacia la entidad
	 * CondicionanteExpediente. Convierte códigos a entidades si es necesario.
	 *
	 * @param condiciones: entidad a la que inyectar los datos.
	 * @param dto:         objeto del que se obtienen los datos.
	 * @return Devuelve una entidad CondicionanteExpediente rellena con los datos
	 *         del dto.
	 */
	@Transactional(readOnly = false)
	private CondicionanteExpediente dtoCondicionantestoCondicionante(CondicionanteExpediente condiciones,
			DtoCondiciones dto) {
		try {
			ExpedienteComercial expediente = condiciones.getExpediente();
			boolean esVenta = true;

			if(expediente != null && expediente.getOferta() != null) {
				Oferta oferta = expediente.getOferta();
				if(oferta.getTipoOferta() != null && oferta.getTipoOferta().getCodigo() != null) {
					if(!DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
						esVenta = false;
					}
				}
			}
			beanUtilNotNull.copyProperties(condiciones, dto);

			if (!Checks.esNulo(dto.getEstadosFinanciacion())) {
				DDEstadoFinanciacion estadoFinanciacion = (DDEstadoFinanciacion) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDEstadoFinanciacion.class, dto.getEstadosFinanciacion());
				condiciones.setEstadoFinanciacion(estadoFinanciacion);
			}
			// Reserva
			if (dto.getTipoCalculo() != null) {
				DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoCalculo.class, dto.getTipoCalculo());
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
			if(esVenta){
				if (!Checks.esNulo(dto.getTipoImpuestoCodigo())) {
					DDTiposImpuesto tipoImpuesto = (DDTiposImpuesto) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTiposImpuesto.class, dto.getTipoImpuestoCodigo());
					condiciones.setTipoImpuesto(tipoImpuesto);
				}
			}else{
				if (!Checks.esNulo(dto.getTipoImpuestoCodigoAlq())) {
					DDTiposImpuesto tipoImpuesto = (DDTiposImpuesto) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTiposImpuesto.class, dto.getTipoImpuestoCodigoAlq());
					condiciones.setTipoImpuesto(tipoImpuesto);
				}
			}

			if (!Checks.esNulo(dto.getReservaConImpuesto())) {
				if (!dto.getReservaConImpuesto()) {
					condiciones.setReservaConImpuesto(0);
				} else {
					condiciones.setReservaConImpuesto(1);
				}
			}

			if (!Checks.esNulo(dto.getRenunciaExencion()) || !Checks.esNulo(dto.getReservaConImpuesto())
					|| !Checks.esNulo(dto.getTipoImpuestoCodigo()) || !Checks.esNulo(dto.getTipoAplicable())) {
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

				DDTiposPorCuenta tipoPorCuentaPlusvalia = (DDTiposPorCuenta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getPlusvaliaPorCuentaDe());
				condiciones.setTipoPorCuentaPlusvalia(tipoPorCuentaPlusvalia);
			}

			if (!Checks.esNulo(dto.getNotariaPorCuentaDe()) || "".equals(dto.getNotariaPorCuentaDe())) {
				if ("".equals(dto.getNotariaPorCuentaDe())) {
					condiciones.setGastosNotaria(null);
				}

				DDTiposPorCuenta tipoPorCuentaNotaria = (DDTiposPorCuenta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getNotariaPorCuentaDe());
				condiciones.setTipoPorCuentaNotaria(tipoPorCuentaNotaria);
			}

			if (!Checks.esNulo(dto.getGastosCompraventaOtrosPorCuentaDe())
					|| "".equals(dto.getGastosCompraventaOtrosPorCuentaDe())) {
				if ("".equals(dto.getGastosCompraventaOtrosPorCuentaDe())) {
					condiciones.setGastosOtros(null);
				}

				DDTiposPorCuenta tipoPorCuentaGCVOtros = (DDTiposPorCuenta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getGastosCompraventaOtrosPorCuentaDe());
				condiciones.setTipoPorCuentaGastosOtros(tipoPorCuentaGCVOtros);
			}

			// Gastos Alquiler
			if (!Checks.esNulo(dto.getIbiPorCuentaDe()) || "".equals(dto.getIbiPorCuentaDe())) {
				if ("".equals(dto.getIbiPorCuentaDe())) {
					condiciones.setGastosIbi(null);
				}

				DDTiposPorCuenta tipoPorCuentaIbi = (DDTiposPorCuenta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getIbiPorCuentaDe());
				condiciones.setTipoPorCuentaIbi(tipoPorCuentaIbi);
			}

			if (!Checks.esNulo(dto.getComunidadPorCuentaDe()) || "".equals(dto.getComunidadPorCuentaDe())) {
				if ("".equals(dto.getComunidadPorCuentaDe())) {
					condiciones.setGastosComunidad(null);
				}

				DDTiposPorCuenta tipoPorCuentaComunidad = (DDTiposPorCuenta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getComunidadPorCuentaDe());
				condiciones.setTipoPorCuentaComunidadAlquiler(tipoPorCuentaComunidad);
			}

			if (!Checks.esNulo(dto.getSuministrosPorCuentaDe()) || "".equals(dto.getSuministrosPorCuentaDe())) {
				if ("".equals(dto.getSuministrosPorCuentaDe())) {
					condiciones.setGastosSuministros(null);
				}

				DDTiposPorCuenta tipoPorCuentaSuministros = (DDTiposPorCuenta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getSuministrosPorCuentaDe());
				condiciones.setTipoPorCuentaSuministros(tipoPorCuentaSuministros);
			}

			// Cargas pendientes
			if (!Checks.esNulo(dto.getImpuestosPorCuentaDe())) {
				DDTiposPorCuenta tipoPorCuentaImpuestos = (DDTiposPorCuenta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getImpuestosPorCuentaDe());
				condiciones.setTipoPorCuentaImpuestos(tipoPorCuentaImpuestos);
			}

			if (!Checks.esNulo(dto.getComunidadesPorCuentaDe())) {
				DDTiposPorCuenta tipoPorCuentaComunidad = (DDTiposPorCuenta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getComunidadesPorCuentaDe());
				condiciones.setTipoPorCuentaComunidad(tipoPorCuentaComunidad);
			}

			if (!Checks.esNulo(dto.getCargasPendientesOtrosPorCuentaDe())
					|| "".equals(dto.getCargasPendientesOtrosPorCuentaDe())) {
				if ("".equals(dto.getCargasPendientesOtrosPorCuentaDe())) {
					condiciones.setCargasOtros(null);
				}

				DDTiposPorCuenta tipoPorCuentaCPOtros = (DDTiposPorCuenta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getCargasPendientesOtrosPorCuentaDe());
				condiciones.setTipoPorCuentaCargasOtros(tipoPorCuentaCPOtros);
			}

			// Requerimientos del comprador
			if (!Checks.esNulo(dto.getEstadoTituloCodigo())) {
				DDEstadoTitulo estadoTitulo = (DDEstadoTitulo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDEstadoTitulo.class, dto.getEstadoTituloCodigo());
				condiciones.setEstadoTitulo(estadoTitulo);
			}

			if (dto.getSituacionPosesoriaCodigo() != null) {
				DDSituacionesPosesoria situacionPosesoria = (DDSituacionesPosesoria) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSituacionesPosesoria.class, dto.getSituacionPosesoriaCodigo());
				if (!Checks.esNulo(situacionPosesoria)) {
					condiciones.setSituacionPosesoria(situacionPosesoria);
				} else {
					condiciones.setSituacionPosesoria(null);
				}
			}

			// Condiciones administrativas
			if (!Checks.esNulo(dto.getProcedeDescalificacionPorCuentaDe())
					|| "".equals(dto.getProcedeDescalificacionPorCuentaDe())) {
				DDTiposPorCuenta tipoPorCuentaDescalificacion = (DDTiposPorCuenta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getProcedeDescalificacionPorCuentaDe());
				condiciones.setTipoPorCuentaDescalificacion(tipoPorCuentaDescalificacion);
			}

			if (!Checks.esNulo(dto.getLicenciaPorCuentaDe()) || "".equals(dto.getLicenciaPorCuentaDe())) {
				DDTiposPorCuenta tipoPorCuentaLicencia = (DDTiposPorCuenta) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getLicenciaPorCuentaDe());
				condiciones.setTipoPorCuentaLicencia(tipoPorCuentaLicencia);
			}

			// Jurídicas-situación del activo
			if (!Checks.esNulo(dto.getSujetoTramiteTanteo())) {
				condiciones.setSujetoTanteoRetracto(dto.getSujetoTramiteTanteo() ? 1 : 0);
			}

			// Juridicas-situacion del activo
			if (!Checks.esNulo(dto.getSujetoTramiteTanteo())) {
				condiciones.setSujetoTanteoRetracto(dto.getSujetoTramiteTanteo() == true ? 1 : 0);
			}

			if (("").equals(dto.getImporteAval())) { // Checks.esNulo considera un string vacio como nulo
														// también....pero un dto puede devolver un string vacio/nulo.
				condiciones.setImporteAval(null); // En caso de String vacio QUIERO setear null en ImporteAval...
			} else if (!Checks.esNulo(dto.getImporteAval())) {
				String aux = dto.getImporteAval();
				Double importeAval = Double.parseDouble(aux);
				condiciones.setImporteAval(importeAval);
			}

			if (!Checks.esNulo(dto.getCarencia())) {
				condiciones.setCarencia(dto.getCarencia());
			}

			if (("").equals(dto.getMesesCarencia())) {
				condiciones.setMesesCarencia(null);
			} else if (!Checks.esNulo(dto.getMesesCarencia())) {
				String aux = dto.getMesesCarencia();
				Integer mesesCarencia = Integer.parseInt(aux);
				condiciones.setMesesCarencia(mesesCarencia);
			}

			if (("").equals(dto.getImporteCarencia())) {
				condiciones.setImporteCarencia(null);
			} else if (!Checks.esNulo(dto.getImporteCarencia())) {
				String aux = dto.getImporteCarencia();
				Double importeCarencia = Double.parseDouble(aux);
				condiciones.setImporteCarencia(importeCarencia);
			}

			if (!Checks.esNulo(dto.getGastosRepercutibles())) {
				condiciones.setGastosRepercutibles(dto.getGastosRepercutibles());
			}

			if (!Checks.esNulo(dto.getRepercutiblesComments())) {
				condiciones.setRepercutiblesComments(dto.getRepercutiblesComments());
			}

			if (!Checks.esNulo(dto.getEntidadComments())) {
				condiciones.setEntidadComments(dto.getEntidadComments());
			}

			if (!Checks.esNulo(dto.getBonificacion())) {
				condiciones.setBonificacion(dto.getBonificacion());
			}

			if (("").equals(dto.getMesesBonificacion())) {
				condiciones.setMesesBonificacion(null);
			} else if (!Checks.esNulo(dto.getMesesBonificacion())) {
				String aux = dto.getMesesBonificacion();
				Integer mesesBonificacion = Integer.parseInt(aux);
				condiciones.setMesesBonificacion(mesesBonificacion);
			}

			if (("").equals(dto.getImporteBonificacion())) {
				condiciones.setImporteBonificacion(null);
			} else if (!Checks.esNulo(dto.getImporteBonificacion())) {
				String aux = dto.getImporteBonificacion();
				Double importeBonificacion = Double.parseDouble(aux);
				condiciones.setImporteBonificacion(importeBonificacion);
			}
			/*
			 * if (("").equals(dto.getDuracionBonificacion())){
			 * condiciones.setDuracionBonificacion(null); }else if
			 * (!Checks.esNulo(dto.getDuracionBonificacion())) { String aux =
			 * dto.getDuracionBonificacion(); Integer duracionBonificacion =
			 * Integer.parseInt(aux);
			 * condiciones.setDuracionBonificacion(duracionBonificacion); }
			 */

			if (!Checks.esNulo(dto.getRenunciaTanteo())) {
				condiciones.setRenunciaTanteo(dto.getRenunciaTanteo());
			}
			if(dto.getDerechoCesionSubarriendo() != null) {
				condiciones.setDerechoCesionSubarriendo(dto.getDerechoCesionSubarriendo());
			}
			if(dto.getFianzaExonerada() != null) {
				condiciones.setFianzaExonerada(dto.getFianzaExonerada());
			}
			
			if(!Checks.isFechaNula(dto.getFechaIngresoFianzaArrendatario())) {
				condiciones.setFechaIngresoFianzaArrendatario(dto.getFechaIngresoFianzaArrendatario());
			}
			
			
			
			if(dto.getVulnerabilidadDetectada() != null) {
				condiciones.setVulnerabilidadDetectada(dto.getVulnerabilidadDetectada());
			}
			if(dto.getRegimenFianzaCCAACodigo() != null) {
				DDRegimenFianzaCCAA regimenFianzaCCAA = (DDRegimenFianzaCCAA) utilDiccionarioApi.dameValorDiccionarioByCod(DDRegimenFianzaCCAA.class, dto.getRegimenFianzaCCAACodigo());
				condiciones.setRegimenFianzaCCAA(regimenFianzaCCAA);
			}
			if(dto.getCertificaciones() !=null) {
				condiciones.setCertificaciones(dto.getCertificaciones());
			}
			if(dto.getOfrNuevasCondiciones() !=null) {
				condiciones.setOfrNuevasCondiciones(dto.getOfrNuevasCondiciones());
			}
			if(dto.getFianzaContratosSubrogados() !=null) {
				condiciones.setFianzaContratosSubrogados(dto.getFianzaContratosSubrogados());
			}
			if(dto.getAdecuaciones() !=null) {
				condiciones.setAdecuaciones(dto.getAdecuaciones());
			}
			if(dto.getCntSuscritoPosteridadAdj() !=null) {
				condiciones.setCntSuscritoPosteridadAdj(dto.getCntSuscritoPosteridadAdj());
			}
			if(dto.getAntiguoDeudorLocalizable() !=null) {
				condiciones.setAntiguoDeudorLocalizable(dto.getAntiguoDeudorLocalizable());
			}

			if(dto.getRentasCuenta() != null) {
				condiciones.setRentasCuenta(dto.getRentasCuenta());
			}
			if(dto.getEntregasCuenta() != null) {
				condiciones.setEntregasCuenta(dto.getEntregasCuenta());
			}
			if(dto.getImporteEntregasCuenta() != null) {
				condiciones.setImporteEntregasCuenta(dto.getImporteEntregasCuenta());
			}
			
			dto.setObligadoCumplimiento(condiciones.getObligadoCumplimiento());
			dto.setFechaPreavisoVencimientoCnt(condiciones.getFechaPreavisoVencimientoCnt());
			
			if(dto.getMetodoActualizacionRentaCod() != null) {
				DDMetodoActualizacionRenta metodoActualizacionRenta = (DDMetodoActualizacionRenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDMetodoActualizacionRenta.class, dto.getMetodoActualizacionRentaCod());
				condiciones.setMetodoActualizacionRenta(metodoActualizacionRenta);
				condiciones.setCheckIGC(null);
				condiciones.setCheckIPC(null);
				condiciones.setPeriodicidadMeses(null);
				condiciones.setFechaActualizacion(null);
			}
			
			if(dto.getCheckIGC() != null) {
				condiciones.setCheckIGC(dto.getCheckIGC());
			}
			if(dto.getPeriodicidadMeses() != null) {
				condiciones.setPeriodicidadMeses(dto.getPeriodicidadMeses());
			}
			if(!Checks.isFechaNula(dto.getFechaActualizacion())) {
				condiciones.setFechaActualizacion(dto.getFechaActualizacion());
			}
			if (dto.getCheckIPC() != null) {
				condiciones.setCheckIPC(dto.getCheckIPC());
			}
			
			if(dto.getMesesDuracion() != null) {
				condiciones.setMesesDuracion(dto.getMesesDuracion());
			}
			
			
			
			if(expediente != null) {
				Oferta oferta = expediente.getOferta();
				if(oferta != null) {
					if(!Checks.isFechaNula(dto.getFechaInicioCnt())) {
						oferta.setFechaInicioContrato(dto.getFechaInicioCnt());
					}
					if(!Checks.isFechaNula(dto.getFechaFinCnt())) {
						oferta.setFechaFinContrato(dto.getFechaFinCnt());
					}
					
					genericDao.save(Oferta.class, oferta);
				}
			}
			
			if (esVenta) {
				if (dto.getTipoGrupoImpuestoCod() != null) {
					DDGrupoImpuesto grupo = (DDGrupoImpuesto) utilDiccionarioApi.dameValorDiccionarioByCod(DDGrupoImpuesto.class, dto.getTipoGrupoImpuestoCod());
					if (grupo != null) {
						condiciones.setTipoGrupoImpuesto(grupo);
					}
					if (DDTiposImpuesto.TIPO_IMPUESTO_ITP.equals(condiciones.getTipoImpuesto().getCodigo())) {
						condiciones.setTipoGrupoImpuesto(null);
					}
				}
			}else {
				if (dto.getTipoGrupoImpuestoCodAlq() != null) {
					DDGrupoImpuesto grupo = (DDGrupoImpuesto) utilDiccionarioApi.dameValorDiccionarioByCod(DDGrupoImpuesto.class, dto.getTipoGrupoImpuestoCodAlq());
					if (grupo != null) {
						condiciones.setTipoGrupoImpuesto(grupo);
					}
					if (DDTiposImpuesto.TIPO_IMPUESTO_ITP.equals(condiciones.getTipoImpuesto().getCodigo())) {
						condiciones.setTipoGrupoImpuesto(null);
					}
				}
			}
			
		} catch (Exception ex) {
			logger.error("error en expedienteComercialManager", ex);
			return condiciones;

		}

		return condiciones;
	}

	public PlusvaliaVentaExpedienteComercial dtoPlusvaliToPlusvalia(PlusvaliaVentaExpedienteComercial condiciones,
			DtoPlusvaliaVenta dto) {
		try {
			beanUtilNotNull.copyProperties(condiciones, dto);

		} catch (Exception ex) {
			logger.error("error en expedienteComercialManager", ex);
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
	 * Este método devuelve un objeto dto relleno con los datos de la entidad
	 * Posicionamiento que recibe.
	 *
	 * @param posicionamiento: entidad de la que obtener los datos para transladra
	 *                         al dto.
	 * @return Devuelve un objeto dto con los datos rellenos.
	 */
	private DtoPosicionamiento posicionamientoToDto(Posicionamiento posicionamiento) {
		DtoPosicionamiento posicionamientoDto = new DtoPosicionamiento();
		if(posicionamiento != null) { 
			try {
				beanUtilNotNull.copyProperties(posicionamientoDto, posicionamiento);
				beanUtilNotNull.copyProperty(posicionamientoDto, "idPosicionamiento", posicionamiento.getId());
				beanUtilNotNull.copyProperty(posicionamientoDto, "horaAviso", posicionamiento.getFechaAviso());
				beanUtilNotNull.copyProperty(posicionamientoDto, "horaPosicionamiento",posicionamiento.getFechaPosicionamiento());
				beanUtilNotNull.copyProperty(posicionamientoDto, "fechaAlta", posicionamiento.getAuditoria().getFechaCrear());
				beanUtilNotNull.copyProperty(posicionamientoDto, "fechaFinPosicionamiento", posicionamiento.getFechaFinPosicionamiento());
	
				if (!Checks.esNulo(posicionamiento.getNotario())) {
					beanUtilNotNull.copyProperty(posicionamientoDto, "idProveedorNotario", posicionamiento.getNotario().getId());
				}
	
				if(posicionamiento.getValidacionBCPos() != null ) {
					beanUtilNotNull.copyProperty(posicionamientoDto, "validacionBCPosi", posicionamiento.getValidacionBCPos().getCodigo());
					beanUtilNotNull.copyProperty(posicionamientoDto, "validacionBCPosiDesc", posicionamiento.getValidacionBCPos().getDescripcion());
				}
				
				beanUtilNotNull.copyProperty(posicionamientoDto, "fechaEnvioPos", posicionamiento.getFechaEnvioPos());
				beanUtilNotNull.copyProperty(posicionamientoDto, "fechaValidacionBCPos", posicionamiento.getFechaValidacionBCPos());
				beanUtilNotNull.copyProperty(posicionamientoDto, "observacionesBcPo", posicionamiento.getObservacionesBcPos());
				beanUtilNotNull.copyProperty(posicionamientoDto, "observacionesRem", posicionamiento.getObservacionesRem());
				
				if (posicionamiento.getMotivoAnulacionBc() != null) {
					posicionamientoDto.setMotivoAnulacionBc(posicionamiento.getMotivoAnulacionBc().getDescripcion());
				}
				
			} catch (IllegalAccessException e) {
				logger.error("error en expedienteComercialManager", e);
	
			} catch (InvocationTargetException e) {
				logger.error("error en expedienteComercialManager", e);
			}
		}
		return posicionamientoDto;
	}

	/**
	 * Este método devuelve una entidad Posicionamiento rellena con los datos del
	 * objeto dto que recibe.
	 *
	 * @param dto:             objeto dto del que obtener los datos.
	 * @param posicionamiento: entidad a rellenar con los datos del dto.
	 * @return Devuelve una entidad Posicionamiento con los datos rellenos.
	 */
	private Posicionamiento dtoToPosicionamiento(DtoPosicionamiento dto, Posicionamiento posicionamiento) {
		try {
			beanUtilNotNull.copyProperty(posicionamiento, "motivoAplazamiento", dto.getMotivoAplazamiento());
			beanUtilNotNull.copyProperty(posicionamiento, "fechaAviso", dto.getFechaHoraAviso());

			if (!Checks.esNulo(dto.getFechaHoraFirma()) && (!(new Date(0)).equals(dto.getFechaHoraFirma()))) {
				beanUtilNotNull.copyProperty(posicionamiento, "fechaPosicionamiento", dto.getFechaHoraFirma());
			} else if (!Checks.esNulo(dto.getFechaHoraPosicionamiento())) {
				beanUtilNotNull.copyProperty(posicionamiento, "fechaPosicionamiento",
						dto.getFechaHoraPosicionamiento());
			}

			if(posicionamiento.getFechaPosicionamiento() == null && dto.getFechaPosicionamiento() != null){
				beanUtilNotNull.copyProperty(posicionamiento, "fechaPosicionamiento",
						dto.getFechaPosicionamiento());
			}

			beanUtilNotNull.copyProperty(posicionamiento, "lugarFirma", dto.getLugarFirma());
			if(dto.getObservacionesRem() != null) {
				beanUtilNotNull.copyProperty(posicionamiento, "observacionesRem", dto.getObservacionesRem());
			}

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

		if(dto.getValidacionBCPosi() != null) {
			DDMotivosEstadoBC dd = genericDao.get(DDMotivosEstadoBC.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getValidacionBCPosi()));
			if(dd != null) {
				posicionamiento.setValidacionBCPos(dd);
			}
		}
		posicionamiento.setMotivoAplazamiento(dto.getMotivoAplazamiento());
		
		if (dto.getMotivoAnulacionBc() != null) {
			DDMotivoAnulacionBC motAnulacionBc = genericDao.get(DDMotivoAnulacionBC.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMotivoAnulacionBc()));
			if (motAnulacionBc != null) {
				posicionamiento.setMotivoAnulacionBc(motAnulacionBc);
			}
		}

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
	 * Este método devuelve un objeto dto relleno con los datos de la entidad
	 * ComparecienteVendedor que recibe.
	 *
	 * @param compareciente: entidad de la que obtener los datos para rellenar el
	 *                       dto.
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
	 * Este método devuelve un objeto dto con los datos rellenos de la entidad
	 * Subsanaciones que recibe.
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
	 * Este método devuelve un objeto dto con los datos rellenos de la entidad
	 * ExpedienteComercial que recibe.
	 *
	 * @param expediente: entidad de la que obtener los datos.
	 * @return Devuelve un objeto relleno con datos.
	 */
	private DtoFormalizacionResolucion expedienteToDtoFormalizacion(ExpedienteComercial expediente) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId());
		List<Formalizacion> listaResolucionFormalizacion = genericDao.getList(Formalizacion.class, filtro);
		Oferta oferta = expediente.getOferta();
		DtoFormalizacionResolucion formalizacionDto = new DtoFormalizacionResolucion();

		// Un expediente de venta solo puede tener una resolución, en el extraño caso
		// que tenga más de una elegimos la primera.
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
		
		if (expediente.getFechaContabilizacion() != null) {
			formalizacionDto.setFechaContabilizacion(expediente.getFechaContabilizacion());
		}
		
		if (!Checks.esNulo(expediente.getFechaFirmaContrato())) {
			formalizacionDto.setFechaFirmaContrato(expediente.getFechaFirmaContrato());
		}
		
		if (!Checks.esNulo(expediente.getNumeroProtocolo())) {
			formalizacionDto.setNumeroProtocoloCaixa(expediente.getNumeroProtocolo());
		}
		
		if(oferta != null) {
			formalizacionDto.setFechaInicioCnt(oferta.getFechaInicioContrato());
			formalizacionDto.setFechaFinCnt(oferta.getFechaFinContrato());
		}
		
		return formalizacionDto;
	}

	private DtoPlusvaliaVenta expedienteToDtoPlusvaliaVenta(ExpedienteComercial expediente) {
		DtoPlusvaliaVenta dto = new DtoPlusvaliaVenta();
		PlusvaliaVentaExpedienteComercial plusvalia = genericDao.get(PlusvaliaVentaExpedienteComercial.class,
				genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId()));

		if (!Checks.esNulo(plusvalia)) {
			dto.setAutoliquidacion(plusvalia.getAutoliquidacion());
			dto.setExento(plusvalia.getExento());
			dto.setFechaEscritoAyt(plusvalia.getFechaEscritoAyt());
			dto.setObservaciones(plusvalia.getObservaciones());
		}

		return dto;
	}

	private DtoSeguroRentas expedienteToDtoSeguroRentas(ExpedienteComercial expediente) {
		DtoSeguroRentas seguroRentasDto = new DtoSeguroRentas();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId());
		SeguroRentasAlquiler seguroRentas = genericDao.get(SeguroRentasAlquiler.class, filtro);
		if (!Checks.esNulo(seguroRentas)) {
			seguroRentasDto.setId(seguroRentas.getId());

			if (!Checks.esNulo(seguroRentas.getEnRevision())) {
				seguroRentasDto.setRevision(seguroRentas.getEnRevision());
			}

			if (!Checks.esNulo(seguroRentas.getResultadoSeguroRentas())) {
				seguroRentasDto.setEstado(seguroRentas.getResultadoSeguroRentas().getDescripcion());
			} else {
				seguroRentasDto.setEstado("En trámite");
			}

			if (!Checks.esNulo(seguroRentas.getAseguradoras())) {
				ActivoProveedor aseguradora = genericDao.get(ActivoProveedor.class, genericDao
						.createFilter(FilterType.EQUALS, "id", Long.parseLong(seguroRentas.getAseguradoras())));

				seguroRentasDto.setAseguradoras(aseguradora.getNombre());
			}
			seguroRentasDto.setEmailPoliza(seguroRentas.getEmailPolizaAseguradora());
			seguroRentasDto.setComentarios(seguroRentas.getComentarios());

		}
		return seguroRentasDto;
	}

	public List<DtoHstcoSeguroRentas> getHstcoSeguroRentas(Long idExpediente) {

		List<DtoHstcoSeguroRentas> listaHstco = new ArrayList<DtoHstcoSeguroRentas>();
		SeguroRentasAlquiler seguroRentas = new SeguroRentasAlquiler();
		Filter filtroRentas = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		seguroRentas = genericDao.get(SeguroRentasAlquiler.class, filtroRentas);
		if (!Checks.esNulo(seguroRentas) && !Checks.esNulo(seguroRentas.getId())) {

			List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
			DtoAdjunto adjFinal = new DtoAdjunto();
			Usuario usuario = genericAdapter.getUsuarioLogado();
			Date fechaFinal = null;
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				ExpedienteComercial expedienteComercial = findOne(idExpediente);
				try {
					listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosExpedienteComercial(expedienteComercial);
					for (DtoAdjunto adj : listaAdjuntos) {
						AdjuntoExpedienteComercial adjuntoExpedienteComercial = expedienteComercial
								.getAdjuntoGD(adj.getId());
						if (!Checks.esNulo(adjuntoExpedienteComercial)
								&& DDSubtipoDocumentoExpediente.CODIGO_SEGURO_RENTAS.equals(
										adjuntoExpedienteComercial.getSubtipoDocumentoExpediente().getCodigo())) {
							if (Checks.esNulo(fechaFinal)
									|| adjuntoExpedienteComercial.getFechaDocumento().compareTo(fechaFinal) > 0) {
								fechaFinal = adjuntoExpedienteComercial.getFechaDocumento();
								adjFinal = adj;
							}

						}

					}
				} catch (GestorDocumentalException gex) {
					String[] error = gex.getMessage().split("-");
					if (error.length > 0 && (error[2].trim().contains("Error al obtener el activo, no existe"))) {

						Integer idExp;
						try {
							idExp = gestorDocumentalAdapterApi.crearExpedienteComercial(expedienteComercial,
									usuario.getUsername());
							logger.debug("GESTOR DOCUMENTAL [ crearExpediente para "
									+ expedienteComercial.getNumExpediente() + "]: ID EXPEDIENTE RECIBIDO " + idExp);
						} catch (GestorDocumentalException gexc) {
							gexc.printStackTrace();
							logger.debug(gexc.getMessage());
						}

					}
					try {
						throw gex;
					} catch (GestorDocumentalException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			} else {
				listaAdjuntos = getAdjuntosExp(idExpediente, listaAdjuntos);
				if (!Checks.esNulo(listaAdjuntos)) {
					for (DtoAdjunto adj : listaAdjuntos) {
						if (!Checks.esNulo(adj) && "Seguro rentas".equals(adj.getDescripcionSubtipo())) {
							if (Checks.esNulo(fechaFinal) || adj.getFechaDocumento().compareTo(fechaFinal) > 0) {
								fechaFinal = adj.getFechaDocumento();
								adjFinal = adj;
							}
						}

					}

				}

			}

			List<HistoricoSeguroRentasAlquiler> listaHistoricoSeguroRenta = new ArrayList<HistoricoSeguroRentasAlquiler>();
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "seguroRentasAlquiler.id", seguroRentas.getId());
			listaHistoricoSeguroRenta = genericDao.getList(HistoricoSeguroRentasAlquiler.class, filtro);
			for (HistoricoSeguroRentasAlquiler hist : listaHistoricoSeguroRenta) {
				DtoHstcoSeguroRentas aux = new DtoHstcoSeguroRentas();
				aux.setId(hist.getId());
				aux.setFechaSancion(hist.getFechaSancion());
				aux.setSolicitud(hist.getIdSolicitud());
				aux.setDocSco(adjFinal.getNombre());
				aux.setMesesFianza(hist.getMesesFianza());
				aux.setImporteFianza(hist.getImportFianza());
				aux.setProveedor(hist.getResultadoSeguroRentas().getDescripcion());
				aux.setIdentificador(adjFinal.getId());
				aux.setIdActivo(adjFinal.getId_activo());
				listaHstco.add(aux);
			}
		}
		return listaHstco;
		// beanUtilNotNull.copyProperty(entrega, "fechaEntrega", dto.getFechaCobro());
	}

	private List<DtoAdjunto> getAdjuntosExp(Long idExpediente, List<DtoAdjunto> listaAdjuntos) {
		try {
			ExpedienteComercial expediente = findOne(idExpediente);

			for (AdjuntoExpedienteComercial adjunto : expediente.getAdjuntos()) {
				DtoAdjunto dto = new DtoAdjunto();
				BeanUtils.copyProperties(dto, adjunto);
				dto.setIdEntidad(expediente.getId());
				dto.setDescripcionTipo(adjunto.getTipoDocumentoExpediente().getDescripcion());
				dto.setDescripcionSubtipo(adjunto.getSubtipoDocumentoExpediente().getDescripcion());
				dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());
				listaAdjuntos.add(dto);
			}

		} catch (Exception ex) {
			logger.error("error en expedienteComercialManager", ex);
		}
		return listaAdjuntos;
	}

	/**
	 * Este método devuelve un objeto dto con los datos rellenos de la entidad
	 * Formalizacion que recibe.
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
		resolucionDto.setVentaCondicionSupensiva(formalizacion.getVentaCondicionSupensiva());
		resolucionDto.setVentaPlazos(formalizacion.getVentaPlazos());
		resolucionDto.setCesionRemate(formalizacion.getCesionRemate());
		resolucionDto.setContratoPrivado(formalizacion.getContratoPrivado());
		this.rellenarDatosVentaFormalizacion(formalizacion, resolucionDto);

		return resolucionDto;
	}

	/**
	 * Este método rellena los datos del objeto dto DtoFormalizacionResolucion que
	 * recibe con los datos de las tareas obtenidas en base al trabajo de la entidad
	 * formalización.
	 *
	 * @param formalizacion: entidad de la que obtener el expediente y de ahí el
	 *                       trabajo y por último las tareas de los trámites del
	 *                       trabajo.
	 * @param resolucionDto: objeto dto al que rellenar con los datos de las tareas.
	 */
	private void rellenarDatosVentaFormalizacion(Formalizacion formalizacion,
			DtoFormalizacionResolucion resolucionDto) {
		if (formalizacion != null && formalizacion.getExpediente() != null
				&& formalizacion.getExpediente().getTrabajo() != null) {
			List<ActivoTramite> listaTramites = tramiteDao.getTramitesByTipoAndTrabajo(
					formalizacion.getExpediente().getTrabajo().getId(),
					ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA);

			if (listaTramites != null && !listaTramites.isEmpty()) {
				List<TareaExterna> listaTareas = activoTareaExternaApi.getTareasByIdTramite(listaTramites.get(0).getId());
				TareaExterna tex = null;

				for (TareaExterna tarea : listaTareas) {
					if (tarea.getTareaProcedimiento() != null
							&& tarea.getTareaProcedimiento().getCodigo().equals("T013_FirmaPropietario")) {
						tex = tarea;
						break;
					}
				}

				if (tex != null) {
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					try {
						String fechaFirma = activoTramiteApi.getTareaValorByNombre(tex.getValores(), "fechaFirma");
						if (fechaFirma != null) {
							resolucionDto.setFechaVenta(df.parse(fechaFirma));
						}
						resolucionDto.setNumProtocolo(
								activoTramiteApi.getTareaValorByNombre(tex.getValores(), "numProtocolo"));
					} catch (ParseException e) {
						logger.error("error en expedienteComercialManager", e);
					}
				}
			}
		}
	}

	@Override
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
	public boolean updateEstadoDevolucionReserva(ExpedienteComercial expedienteComercial,
			String codEstadoDevolucionReserva) throws Exception {
		DDEstadoDevolucion estadoDevolucionReserva = (DDEstadoDevolucion) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadoDevolucion.class, codEstadoDevolucionReserva);

		if (!Checks.esNulo(estadoDevolucionReserva)) {
			if (expedienteComercial.getReserva() != null) {
				expedienteComercial.getReserva().setEstadoDevolucion(estadoDevolucionReserva);
			}

		} else {
			throw new Exception("El codigo del estado de la dev no exite");
		}

		return this.update(expedienteComercial, false);
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateEstadoReserva(ExpedienteComercial expedienteComercial, String codEstadoReserva)
			throws Exception {
		if (!Checks.esNulo(codEstadoReserva)) {
			DDEstadosReserva estadoReserva = (DDEstadosReserva) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDEstadosReserva.class, codEstadoReserva);
			if (!Checks.esNulo(estadoReserva)) {
				if (!Checks.esNulo(expedienteComercial.getReserva())) {
					expedienteComercial.getReserva().setEstadoReserva(estadoReserva);
				}
			} else {
				throw new Exception("El codigo del estado de la reserva no existe");
			}
			return this.update(expedienteComercial, false);
		} else {
			return this.update(expedienteComercial, false);
		}
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateEstadoExpedienteComercial(ExpedienteComercial expedienteComercial,
			String codEstadoExpedienteComercial) throws Exception {
		DDEstadosExpedienteComercial estadoExpedienteComercial = (DDEstadosExpedienteComercial) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class, codEstadoExpedienteComercial);
		boolean paseAVendido = false;
		if (!Checks.esNulo(estadoExpedienteComercial)) {
			paseAVendido = DDEstadosExpedienteComercial.VENDIDO.equals(codEstadoExpedienteComercial);
			if (!Checks.esNulo(expedienteComercial)) {
				expedienteComercial.setEstado(estadoExpedienteComercial);
				recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

			}

		} else {
			throw new Exception("El codigo del estado del expediente comercial no existe");
		}

		return this.update(expedienteComercial, paseAVendido);
	}

	@Transactional(readOnly = false)
	private void resetReservaEstadoPrevioResolucionExpediente(ExpedienteComercial expedienteComercial,
			String codigoReserva) throws Exception {
		Reserva reserva = expedienteComercial.getReserva();
		reserva.setIndicadorDevolucionReserva(null);
		reserva.setDevolucionReserva(null);
		this.updateEstadoReserva(expedienteComercial, codigoReserva);
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateExpedienteComercialEstadoPrevioResolucionExpediente(ExpedienteComercial expedienteComercial,
			String codigoTareaActual, String codigoTareaSalto, Boolean botonDeshacerAnulacion) throws Exception {
		if (codigoTareaSalto.equals(ComercialUserAssigantionService.CODIGO_T013_DEFINICION_OFERTA)
				&& codigoTareaActual.equals(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION)
				&& botonDeshacerAnulacion) {
			this.resetReservaEstadoPrevioResolucionExpediente(expedienteComercial, null);
			this.updateEstadoExpedienteComercial(expedienteComercial, DDEstadosExpedienteComercial.EN_TRAMITACION);

			return this.update(expedienteComercial, false);
		} else if (codigoTareaActual.equals(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION)
				|| codigoTareaActual.equals(ComercialUserAssigantionService.CODIGO_T013_PENDIENTE_DEVOLUCION)
				|| codigoTareaActual
						.equals(ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION)) {
			this.resetReservaEstadoPrevioResolucionExpediente(expedienteComercial, DDEstadosReserva.CODIGO_FIRMADA);
			this.updateEstadoExpedienteComercial(expedienteComercial, DDEstadosExpedienteComercial.RESERVADO);

			return this.update(expedienteComercial, false);
		}

		return false;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean update(ExpedienteComercial expedienteComercial, boolean pasaAVendido) {
		try {

			if (pasaAVendido && expedienteComercial.getOferta() != null
					&& expedienteComercial.getOferta().getActivosOferta() != null
					&& !expedienteComercial.getOferta().getActivosOferta().isEmpty()) {
				for (ActivoOferta activoOferta : expedienteComercial.getOferta().getActivosOferta()) {
					activoApi.changeAndSavePlusvaliaEstadoGestionActivoById(activoOferta.getPrimaryKey().getActivo(),
							DDEstadoGestionPlusv.COD_EN_CURSO);
					notificationPlusvaliaManager.sendNotificationPlusvaliaLiquidacion(
							activoOferta.getPrimaryKey().getActivo(), expedienteComercial);

				}

			}

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
				DDTiposArras tipoArras = (DDTiposArras) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposArras.class,
						dto.getTipoArrasCodigo());
				reserva.setTipoArras(tipoArras);
			}
			
			if(dto.getMotivoAmpliacionArrasCodigo()!=null) {
				reserva.setMotivoAmpliacionArras(genericDao.get(DDMotivoAmpliacionArras.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMotivoAmpliacionArrasCodigo())));
			}

			if (!Checks.esNulo(dto.getCodigoSucursal())) {
				String codigoCartera = "";
				if (expediente.getOferta().getActivoPrincipal().getCartera().getCodigo()
						.equals(DDCartera.CODIGO_CARTERA_BANKIA))
					codigoCartera = "2038";
				else if (expediente.getOferta().getActivoPrincipal().getCartera().getCodigo()
						.equals(DDCartera.CODIGO_CARTERA_CAJAMAR))
					codigoCartera = "3058";
				Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "codProveedorUvem",
						codigoCartera + dto.getCodigoSucursal());
				expediente.getOferta().setSucursal(genericDao.get(ActivoProveedor.class, filtroProveedor));
				genericDao.save(Oferta.class, expediente.getOferta());
			}

			if (!Checks.esNulo(dto.getEstadoReservaCodigo())) {
				reserva.setEstadoReserva(genericDao.get(DDEstadosReserva.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoReservaCodigo())));
			}
			
			if(!Checks.isFechaNula(dto.getFechaPropuestaProrrogaArras())) {
				reserva.setFechaPropuestaProrrogaArras(dto.getFechaPropuestaProrrogaArras());
				reserva.setFechaAmpliacionArras(dto.getFechaPropuestaProrrogaArras());
			}
			if(!Checks.isFechaNula(dto.getFechaComunicacionCliente())) {
				reserva.setFechaComunicacionCliente(dto.getFechaComunicacionCliente());
			}
			
			if(!Checks.isFechaNula(dto.getFechaComunicacionClienteRescision())) {
				reserva.setFechaComunicacionClienteRescision(dto.getFechaComunicacionClienteRescision());
			}
			if(!Checks.isFechaNula(dto.getFechaFirmaRescision())) {
				reserva.setFechaFirmaRescision(dto.getFechaFirmaRescision());
			}
			
			if(!Checks.isFechaNula(dto.getFechaContabilizacionArras())) {
				reserva.setFechaContArras(dto.getFechaContabilizacionArras());
			}
			
			genericDao.save(Reserva.class, reserva);
			
			CondicionesReserva condiciones = genericDao.get(CondicionesReserva.class, genericDao.createFilter(FilterType.EQUALS, "reserva.id", reserva.getId()));
			
			if (condiciones == null && DDCartera.isCarteraBk(expediente.getOferta().getActivoPrincipal().getCartera())) {
				condiciones = new CondicionesReserva();
				condiciones.setAuditoria(Auditoria.getNewInstance());
				condiciones.setReserva(reserva);
			}
			
			if (condiciones != null) {
				if (dto.getAutorizacionVpo() != null) {
					condiciones.setAutorizacionVpo(dto.getAutorizacionVpo());
				}
				if (dto.getCargas() != null) {
					condiciones.setCargas(dto.getCargas());
				}
				if (dto.getInscripcionTitulo() != null) {
					condiciones.setInscripcionTitulo(dto.getInscripcionTitulo());
				}
				if (dto.getPosesion() != null) {
					condiciones.setPosesion(dto.getPosesion());
				}
				if (dto.getTanteoDL() != null) {
					condiciones.setTanteoDL(dto.getTanteoDL());
				}
				if (dto.getTemasCatastrales() != null) {
					condiciones.setTemasCatastrales(dto.getTemasCatastrales());
				}
				if (dto.getTemasTecnicos() != null) {
					condiciones.setTemasTecnicos(dto.getTemasTecnicos());
				}
				
				genericDao.save(CondicionesReserva.class, condiciones);
			}
			MotivoRescinsionArras rescinsionArras = genericDao.get(MotivoRescinsionArras.class, genericDao.createFilter(FilterType.EQUALS, "reserva.id", reserva.getId()));
			
			if (rescinsionArras == null && DDCartera.isCarteraBk(expediente.getOferta().getActivoPrincipal().getCartera())) {
				rescinsionArras = new MotivoRescinsionArras();
				rescinsionArras.setAuditoria(Auditoria.getNewInstance());
				rescinsionArras.setReserva(reserva);
			}
			
			if (rescinsionArras != null) {
				if (dto.getAutorizacionVpoMotivo() != null) {
					rescinsionArras.setAutorizacionVpo(dto.getAutorizacionVpoMotivo());
				}
				if (dto.getCargasMotivo() != null) {
					rescinsionArras.setCargas(dto.getCargasMotivo());
				}
				if (dto.getInscripcionTituloMotivo() != null) {
					rescinsionArras.setInscripcionTitulo(dto.getInscripcionTituloMotivo());
				}
				if (dto.getPosesionMotivo() != null) {
					rescinsionArras.setPosesion(dto.getPosesionMotivo());
				}
				if (dto.getTanteoDLMotivo() != null) {
					rescinsionArras.setTanteoDL(dto.getTanteoDLMotivo());
				}
				if (dto.getTemasCatastralesMotivo() != null) {
					rescinsionArras.setTemasCatastrales(dto.getTemasCatastralesMotivo());
				}
				if (dto.getTemasTecnicosMotivo() != null) {
					rescinsionArras.setTemasTecnicos(dto.getTemasTecnicosMotivo());
				}
				
				genericDao.save(MotivoRescinsionArras.class, rescinsionArras);
			}

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
		if (expediente != null && activo != null) {
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

			if (!Checks.esNulo(expediente.getOferta().getOrigenComprador())) {
				gastoExpedienteDto.setOrigenComprador(expediente.getOferta().getOrigenComprador().getDescripcion());
			}

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

			if (!Checks.esNulo(gasto.getImporteFinal())) {
				gastoExpedienteDto.setImporteFinal(gasto.getImporteFinal());
			}

			if (gasto.getImporteOriginal() != null) {
				gastoExpedienteDto.setImporteOriginal(gasto.getImporteOriginal());
			}

		}

		return honorarios;
	}

	// getHistoricoHonorarios

	public List<DtoHistoricoCondiciones> getHistoricoCondiciones(Long idExpediente) {
		List<DtoHistoricoCondiciones> dto = new ArrayList<DtoHistoricoCondiciones>();
		ExpedienteComercial expediente = findOne(idExpediente);
		if (!Checks.esNulo(expediente)) {
			CondicionanteExpediente condicion = expediente.getCondicionante();
			if (!Checks.esNulo(condicion)) {
				if (!Checks.esNulo(condicion.getFechaFijo()) && !Checks.esNulo(condicion.getIncrementoRentaFijo())) {
					DtoHistoricoCondiciones d1 = new DtoHistoricoCondiciones();
					d1.setFecha(condicion.getFechaFijo());
					d1.setIncrementoRenta(condicion.getIncrementoRentaFijo());
					dto.add(d1);
				}
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "condicionante.id", condicion.getId());
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
				Order order = new Order(GenericABMDao.OrderType.ASC, "fecha");
				List<HistoricoCondicionanteExpediente> listaHistorico = genericDao
						.getListOrdered(HistoricoCondicionanteExpediente.class, order, filtro, filtro2);
				if (!Checks.esNulo(listaHistorico)) {
					for (HistoricoCondicionanteExpediente historico : listaHistorico) {
						DtoHistoricoCondiciones d = new DtoHistoricoCondiciones();
						d.setCondicionante(historico.getCondicionante().getId());
						d.setId(historico.getId().toString());
						d.setFecha(historico.getFecha());
						d.setIncrementoRenta(historico.getIncrementoRenta());
						dto.add(d);
					}
				}

			}
		}

		return dto;

	}

	@Transactional(readOnly = false)
	public DtoCompradorLLamadaBC saveFichaComprador(VBusquedaDatosCompradorExpediente dto) {
		DtoCompradorLLamadaBC response = new DtoCompradorLLamadaBC();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getId());
		Comprador comprador = genericDao.get(Comprador.class, filtro);
		DtoInterlocutorBC oldDataComprador = new DtoInterlocutorBC();
		DtoInterlocutorBC newDataComprador = new DtoInterlocutorBC();
		DtoInterlocutorBC oldDataRepresentante = new DtoInterlocutorBC();
		DtoInterlocutorBC newDataRepresentante = new DtoInterlocutorBC();

		if (!Checks.esNulo(comprador)) {

			oldDataComprador.compradorToDto(comprador);

			boolean reiniciarPBC = false;
			
			if(dto.getNumeroClienteUrsus() != null)
				comprador.setIdCompradorUrsus(dto.getNumeroClienteUrsus());
			
			if(dto.getNumeroClienteUrsusBh() != null)
				comprador.setIdCompradorUrsusBh(dto.getNumeroClienteUrsusBh());
			
			if((DDTiposPersona.CODIGO_TIPO_PERSONA_JURIDICA).equals(dto.getCodTipoPersona())) {
				comprador.setApellidos(null);
			}

			if (!Checks.esNulo(dto.getEstadoCivilURSUS())) {
				comprador.setEstadoCivilURSUS(Long.parseLong(dto.getEstadoCivilURSUS()));
			}

			if (!Checks.esNulo(dto.getNumeroConyugeUrsus())) {
				comprador.setNumeroConyugeUrsus(Integer.parseInt(dto.getNumeroConyugeUrsus()));
			}

			if (!Checks.esNulo(dto.getRegimenMatrimonialUrsus())) {
				comprador.setRegimenMatrimonialUrsus(Long.parseLong(dto.getRegimenMatrimonialUrsus()));
			}

			if (!Checks.esNulo(dto.getNombreConyugeURSUS())) {
				comprador.setNombreConyugeURSUS(dto.getNombreConyugeURSUS());
			}

			if (!Checks.esNulo(dto.getCodTipoPersona())) {
				DDTiposPersona tipoPersona = (DDTiposPersona) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTiposPersona.class, dto.getCodTipoPersona());
				comprador.setTipoPersona(tipoPersona);
			}

			// Datos de identificación
			if (!Checks.esNulo(dto.getApellidos())) {
				reiniciarPBC = true;
			}

			if((DDTiposPersona.CODIGO_TIPO_PERSONA_JURIDICA).equals(dto.getCodTipoPersona())) {
				comprador.setApellidos(null);
			}else {
				comprador.setApellidos(dto.getApellidos());
			}

			if (!Checks.esNulo(dto.getCodTipoDocumento())) {
				DDTipoDocumento tipoDocumentoComprador = (DDTipoDocumento) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumento());
				comprador.setTipoDocumento(tipoDocumentoComprador);
			}

			if (!Checks.esNulo(dto.getNombreRazonSocial())) {
				reiniciarPBC = true;
			}

			comprador.setNombre(dto.getNombreRazonSocial());

			if (!Checks.esNulo(dto.getProvinciaCodigo())) {
				DDProvincia provincia = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class,
						dto.getProvinciaCodigo());
				comprador.setProvincia(provincia);
				reiniciarPBC = true;
			} else {
				comprador.setProvincia(null);
			}

			if (!Checks.esNulo(dto.getMunicipioCodigo())) {
				Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
				Localidad localidad = genericDao.get(Localidad.class, filtroLocalidad);
				comprador.setLocalidad(localidad);
				reiniciarPBC = true;
			} else {
				comprador.setLocalidad(null);
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

			comprador.setTelefono1(dto.getTelefono1());

			comprador.setTelefono2(dto.getTelefono2());

			comprador.setEmail(dto.getEmail());

			// HREOS-4937 -- GDPR
			// Actualizamos datos GDPR del comprador
			if (!Checks.esNulo(dto.getCesionDatos())) {
				comprador.setCesionDatos(dto.getCesionDatos());
			}
			if (!Checks.esNulo(dto.getComunicacionTerceros())) {
				comprador.setComunicacionTerceros(dto.getComunicacionTerceros());
			}
			if (!Checks.esNulo(dto.getTransferenciasInternacionales())) {
				comprador.setTransferenciasInternacionales(dto.getTransferenciasInternacionales());
			}
			
			if(!Checks.isFechaNula(dto.getFechaNacimientoConstitucion())){
				comprador.setFechaNacimientoConstitucion(dto.getFechaNacimientoConstitucion());
			}
			
			Filter filtroAdjunto = genericDao.createFilter(FilterType.NOTNULL, "idAdjunto");
			List<TmpClienteGDPR> tmpClienteGDPR = genericDao.getList(TmpClienteGDPR.class, 
					genericDao.createFilter(FilterType.EQUALS, "numDocumento", dto.getNumDocumento()), filtroAdjunto);

			// Historificamos despues del update
			AdjuntoComprador docAdjunto = null;
			if (!Checks.esNulo(dto.getIdDocAdjunto())) {
				docAdjunto = genericDao.get(AdjuntoComprador.class,
						genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdDocAdjunto()));
			} else {
				if (!Checks.estaVacio(tmpClienteGDPR)) {
					docAdjunto = genericDao.get(AdjuntoComprador.class,
							genericDao.createFilter(FilterType.EQUALS, "id", tmpClienteGDPR.get(0).getIdAdjunto()));
				}
			}

			if (!Checks.esNulo(docAdjunto)) {
				comprador.setAdjunto(docAdjunto);
			}

			ClienteCompradorGDPR clienteCompradorGDPR = new ClienteCompradorGDPR();

			if (!Checks.esNulo(comprador.getTipoDocumento())) {
				clienteCompradorGDPR.setTipoDocumento(comprador.getTipoDocumento());
			}
			if (!Checks.esNulo(comprador.getDocumento())) {
				clienteCompradorGDPR.setNumDocumento(comprador.getDocumento());
			}
			if (!Checks.esNulo(comprador.getCesionDatos())) {
				clienteCompradorGDPR.setCesionDatos(comprador.getCesionDatos());
			}
			if (!Checks.esNulo(comprador.getComunicacionTerceros())) {
				clienteCompradorGDPR.setComunicacionTerceros(comprador.getComunicacionTerceros());
			}
			if (!Checks.esNulo(comprador.getTransferenciasInternacionales())) {
				clienteCompradorGDPR.setTransferenciasInternacionales(comprador.getTransferenciasInternacionales());

			}
			if (!Checks.esNulo(docAdjunto)) {
				clienteCompradorGDPR.setAdjuntoComprador(docAdjunto);
			}

			genericDao.save(ClienteCompradorGDPR.class, clienteCompradorGDPR);

			Filter filtroComprador = genericDao.createFilter(FilterType.EQUALS, "comprador", dto.getId());
			Filter filtroExpComComprador = genericDao.createFilter(FilterType.EQUALS, "expediente",
					dto.getIdExpedienteComercial());
			Filter filtroExpedienteComercial = genericDao.createFilter(FilterType.EQUALS, "id",
					dto.getIdExpedienteComercial());

			ExpedienteComercial expedienteComercial = genericDao.get(ExpedienteComercial.class,
					filtroExpedienteComercial);
			CompradorExpediente compradorExpediente = genericDao.get(CompradorExpediente.class, filtroComprador,
					filtroExpComComprador);
			DDEstadoContrasteListas estadoNoSolicitado = genericDao.get(DDEstadoContrasteListas.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoContrasteListas.NO_SOLICITADO));
			boolean esNuevo = false;
			boolean haCambiadoPorcionCompra = false;
			if (Checks.esNulo(compradorExpediente)) {
				compradorExpediente = new CompradorExpediente();
				//compradorExpediente.setBorrado(false);

				CompradorExpedientePk pk = new CompradorExpedientePk();
				pk.setComprador(comprador);
				pk.setExpediente(expedienteComercial);
				compradorExpediente.setPrimaryKey(pk);
				esNuevo = true;
				

			}

			oldDataComprador.cexToDto(compradorExpediente);
			oldDataRepresentante.representanteToDto(compradorExpediente);

			if (!Checks.esNulo(dto.getPorcentajeCompra())) {
				if(!dto.getPorcentajeCompra().equals(compradorExpediente.getPorcionCompra())) {
					haCambiadoPorcionCompra = true;
				}
				compradorExpediente.setPorcionCompra(dto.getPorcentajeCompra());
			}

			if (!Checks.esNulo(dto.getTitularContratacion())
					&& Checks.esNulo(expedienteComercial.getCompradorPrincipal())) {
				compradorExpediente.setTitularContratacion(dto.getTitularContratacion());

				if (dto.getTitularContratacion() == 1) {
					compradorExpediente.setTitularReserva(0);
				} else if (dto.getTitularContratacion() == 0) {
					compradorExpediente.setTitularReserva(1);
				}
			} else {
				if (compradorExpediente.getTitularReserva() == null) {
					compradorExpediente.setTitularReserva(1);
				}
				if (compradorExpediente.getTitularContratacion() == null) {
					compradorExpediente.setTitularContratacion(0);
				}

			}
			// Nexos

			Boolean estaCasado = false;
			Boolean esGananciales = false;

			if (!Checks.esNulo(dto.getCodEstadoCivil())) {

				Filter estadoCivilFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						dto.getCodEstadoCivil());
				DDEstadosCiviles estadoCivil = genericDao.get(DDEstadosCiviles.class, estadoCivilFilter);

				compradorExpediente.setEstadoCivil(estadoCivil);
				reiniciarPBC = true;
				if (!Checks.esNulo(estadoCivil)
						&& DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO.equals(estadoCivil.getCodigo())) {
					estaCasado = true;
				}
			} else {
				compradorExpediente.setEstadoCivil(null);
			}
			
			if (!Checks.esNulo(dto.getCodigoRegimenMatrimonial()) && estaCasado) {

				Filter regimenMatrimonialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",
						dto.getCodigoRegimenMatrimonial());
				DDRegimenesMatrimoniales regimenMatrimonial = genericDao.get(DDRegimenesMatrimoniales.class,
						regimenMatrimonialFilter);

				compradorExpediente.setRegimenMatrimonial(regimenMatrimonial);
				reiniciarPBC = true;
				if (!Checks.esNulo(regimenMatrimonial)
						&& DDRegimenesMatrimoniales.COD_GANANCIALES.equals(regimenMatrimonial.getCodigo())) {
					esGananciales = true;
				}
			} else {
				compradorExpediente.setRegimenMatrimonial(null);
			}

			if (!Checks.esNulo(dto.getDocumentoConyuge()) && esGananciales) {
				compradorExpediente.setDocumentoConyuge(dto.getDocumentoConyuge());
			} else {
				compradorExpediente.setDocumentoConyuge(null);
			}

			if (!Checks.esNulo(dto.getCodTipoDocumentoConyuge()) && esGananciales) {
				compradorExpediente.setTipoDocumentoConyuge((DDTipoDocumento) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumentoConyuge()));
			} else {
				compradorExpediente.setTipoDocumentoConyuge(null);
			}

			if ((Checks.esNulo(dto.getNumeroClienteUrsusConyuge())
					|| Checks.esNulo(dto.getNumeroClienteUrsusBhConyuge())) && !estaCasado) {
				compradorExpediente.setNumUrsusConyuge(null);
				compradorExpediente.setNumUrsusConyugeBh(null);
			}

			compradorExpediente.setRelacionAntDeudor(dto.getRelacionAntDeudor());

			compradorExpediente.setRelacionHre(dto.getRelacionHre());

			compradorExpediente.setAntiguoDeudor(dto.getAntiguoDeudor());
			
			compradorExpediente.setSociedad(dto.getSociedad());
			
			compradorExpediente.setOficinaTrabajo(dto.getOficinaTrabajo());
			
			// Datos representante
			if (!Checks.esNulo(dto.getCodTipoDocumentoRte())) {
				DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumentoRte());
				compradorExpediente.setTipoDocumentoRepresentante(tipoDocumento);
			} else {
				compradorExpediente.setTipoDocumentoRepresentante(null);
			}

			compradorExpediente.setNombreRepresentante(dto.getNombreRazonSocialRte());
			compradorExpediente.setApellidosRepresentante(dto.getApellidosRte());

			if (!Checks.esNulo(dto.getProvinciaRteCodigo())) {
				DDProvincia provinciaRte = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class,
						dto.getProvinciaRteCodigo());
				compradorExpediente.setProvinciaRepresentante(provinciaRte);
			} else {
				compradorExpediente.setProvinciaRepresentante(null);
			}

			if (!Checks.esNulo(dto.getMunicipioRteCodigo())) {
				Filter filtroLocalidadRte = genericDao.createFilter(FilterType.EQUALS, "codigo",
						dto.getMunicipioRteCodigo());
				Localidad localidadRte = (Localidad) genericDao.get(Localidad.class, filtroLocalidadRte);
				compradorExpediente.setLocalidadRepresentante(localidadRte);
			} else {
				compradorExpediente.setLocalidadRepresentante(null);
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
			} else {
				compradorExpediente.setPais(null);
			}

			if (!Checks.esNulo(dto.getCodigoPaisRte())) {
				Filter filtroPaisRte = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoPaisRte());
				DDPaises paisRte = genericDao.get(DDPaises.class, filtroPaisRte);
				compradorExpediente.setPaisRte(paisRte);
			} else {
				compradorExpediente.setPaisRte(null);
			}

			if (!Checks.esNulo(dto.getCodigoGradoPropiedad())) {
				Filter filtroGradoPropiedad = genericDao.createFilter(FilterType.EQUALS, "codigo",
						dto.getCodigoGradoPropiedad());
				DDTipoGradoPropiedad gradoPropiedad = genericDao.get(DDTipoGradoPropiedad.class, filtroGradoPropiedad);
				compradorExpediente.setGradoPropiedad(gradoPropiedad);
			} else {
				compradorExpediente.setGradoPropiedad(null);
			}

			if (!Checks.esNulo(docAdjunto)) {
				compradorExpediente.setDocumentoAdjunto(docAdjunto);
			} else if (!Checks.esNulo(comprador.getAdjunto())) {
				compradorExpediente.setDocumentoAdjunto(comprador.getAdjunto());
			}
			if(dto.getApellidos()!=null || dto.getNumDocumento()!=null || dto.getNombreRazonSocial()!=null) {
				compradorExpediente.setEstadoContrasteListas(estadoNoSolicitado);		
				compradorExpediente.setFechaContrasteListas(new Date());
			}
			

			if(!Checks.esNulo(dto.getCodEstadoContraste())) {
				Filter estadoContrasteFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodEstadoContraste());
				DDEstadoContrasteListas estadoContraste = genericDao.get(DDEstadoContrasteListas.class, estadoContrasteFilter);
				compradorExpediente.setEstadoContrasteListas(estadoContraste);
			}
			
			if (dto.getUsufructuario() != null && "0".equals(dto.getUsufructuario().toString())) {
				compradorExpediente.setUsufructuario(false);
			} else if (dto.getUsufructuario() != null && "1".equals(dto.getUsufructuario().toString())) {
				compradorExpediente.setUsufructuario(true);
			}
			
			if (!Checks.esNulo(dto.getLocalidadNacimientoRepresentanteCodigo())) {
				Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getLocalidadNacimientoRepresentanteCodigo());
				Localidad localidad = genericDao.get(Localidad.class, filtroLocalidad);
				compradorExpediente.setLocalidadNacimientoRepresentante(localidad);
			} else {
				compradorExpediente.setLocalidadNacimientoRepresentante(null);
			}
			
			if (dto.getCompradorPrp() != null) {
				comprador.setCompradorPrp(dto.getCompradorPrp());
			}
			
			if (dto.getRepresentantePrp() != null) {
				compradorExpediente.setPrp(dto.getRepresentantePrp());
			
			}
			
			if (!Checks.isFechaNula(dto.getFechaNacimientoConstitucion())) {
				comprador.setFechaNacimientoConstitucion(dto.getFechaNacimientoConstitucion());
			} else {
				comprador.setFechaNacimientoConstitucion(null);
			}
			
			if (!Checks.isFechaNula(dto.getFechaNacimientoRepresentante())) {
				compradorExpediente.setFechaNacimientoRepresentante(dto.getFechaNacimientoRepresentante());
			} else {
				compradorExpediente.setFechaNacimientoRepresentante(null);
			}
			
			if (dto.getPaisNacimientoCompradorCodigo() != null) {
				Filter filtroPaisComprador = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPaisNacimientoCompradorCodigo());
				DDPaises paisComprador = genericDao.get(DDPaises.class, filtroPaisComprador);
				comprador.setPaisNacimientoComprador(paisComprador);
			} else {
				comprador.setPaisNacimientoComprador(null);
			}
			
			if (dto.getPaisNacimientoRepresentanteCodigo() != null) {
				Filter filtroPaisRepresentante = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPaisNacimientoRepresentanteCodigo());
				DDPaises paisRepresentante = genericDao.get(DDPaises.class, filtroPaisRepresentante);
				compradorExpediente.setPaisNacimientoRepresentante(paisRepresentante);
			} else {
				compradorExpediente.setPaisNacimientoRepresentante(null);
			}
			
			if (!Checks.esNulo(dto.getLocalidadNacimientoCompradorCodigo())) {
				Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getLocalidadNacimientoCompradorCodigo());
				Localidad localidad = genericDao.get(Localidad.class, filtroLocalidad);
				comprador.setLocalidadNacimientoComprador(localidad);
			} else {
				comprador.setLocalidadNacimientoComprador(null);
			}
			
			
			if (dto.getCompradorPrp() != null) {
				comprador.setCompradorPrp(dto.getCompradorPrp());
	
			}
			
			if(!Checks.esNulo(dto.getPaisNacimientoCompradorCodigo())) {
				Filter filtroPais = genericDao.createFilter(FilterType.EQUALS, "codigo",dto.getPaisNacimientoCompradorCodigo());
				DDPaises pais = genericDao.get(DDPaises.class, filtroPais);
				comprador.setPaisNacimientoComprador(pais);		
			}
			
				
			if (dto.getProvinciaNacimientoCompradorCodigo() != null) {
				Filter filtroNuevosCamposCom = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaNacimientoCompradorCodigo());
				DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtroNuevosCamposCom);
				comprador.setProvinciaNacimiento(provinciaNueva);
			}
			
			if (dto.getProvinciaNacimientoRepresentanteCodigo() != null) {
				Filter filtroNuevosCamposRep = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaNacimientoRepresentanteCodigo());
				DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtroNuevosCamposRep);
				compradorExpediente.setProvinciaNacimientoRep(provinciaNueva);
			}
			
			if (dto.getLocalidadNacimientoCompradorCodigo() != null) {
				Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getLocalidadNacimientoCompradorCodigo());
				Localidad localidad = genericDao.get(Localidad.class, filtroLocalidad);
				comprador.setLocalidadNacimientoComprador(localidad);
			} else {
				comprador.setLocalidadNacimientoComprador(null);
			}
			
			if (dto.getLocalidadNacimientoRepresentanteCodigo() != null) {
				Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getLocalidadNacimientoRepresentanteCodigo());
				Localidad localidad = genericDao.get(Localidad.class, filtroLocalidad);
				compradorExpediente.setLocalidadNacimientoRepresentante(localidad);
			} else {
				compradorExpediente.setLocalidadNacimientoRepresentante(null);
			}
			
			DDVinculoCaixa vinculoCaixa = null;
			if(!Checks.esNulo(dto.getVinculoCaixaCodigo())) {
					vinculoCaixa = genericDao.get(DDVinculoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getVinculoCaixaCodigo()));
			}

			assignIAPCompradorRepresentante(compradorExpediente,expedienteComercial.getId(),comprador,expedienteComercial.getOferta());

			if(comprador.getInfoAdicionalPersona() != null) {
				comprador.getInfoAdicionalPersona().setVinculoCaixa(vinculoCaixa);
				comprador.getInfoAdicionalPersona().setSociedad(dto.getSociedad());
				comprador.getInfoAdicionalPersona().setOficinaTrabajo(dto.getOficinaTrabajo());
			}
			if (vinculoCaixa != null) {
				compradorExpediente.setVinculoCaixa(vinculoCaixa);
			}
			if (esNuevo) {
				
				Oferta oferta = expedienteComercial.getOferta();
				if(oferta != null && oferta.getActivoPrincipal() != null && DDCartera.isCarteraBk(oferta.getActivoPrincipal().getCartera())) {
					boolean isPrincipal = compradorExpediente.getTitularContratacion() == 1 ? true : false;
					tramitacionOfertasManager.setInterlocutorOferta(compradorExpediente, isPrincipal, oferta);
				}
				
				genericDao.save(Comprador.class, comprador);
				compradorExpediente.setEstadoContrasteListas(estadoNoSolicitado);
				compradorExpediente.setFechaContrasteListas(new Date());
				expedienteComercial.getCompradores().add(compradorExpediente);
				genericDao.save(ExpedienteComercial.class, expedienteComercial);
				
			} else {
				genericDao.save(Comprador.class, comprador);
				genericDao.update(CompradorExpediente.class, compradorExpediente);
				genericDao.save(ExpedienteComercial.class, expedienteComercial);
			}

			if (reiniciarPBC) {
				ofertaApi.resetPBC(expedienteComercial, false);
			}

			if (particularValidatorApi.esOfertaCaixa(expedienteComercial.getOferta().getNumOferta().toString())){
				Boolean isAprobado = false;
				if(esNuevo || haCambiadoPorcionCompra) {
					String estadoInterlocutorCodigo = DDEstadoInterlocutor.CODIGO_SOLICITUD_ALTA;
					if(DDEstadoInterlocutor.isSolicitudAlta(compradorExpediente.getEstadoInterlocutor())){
						estadoInterlocutorCodigo = DDEstadoInterlocutor.CODIGO_SOLICITUD_ALTA;
					}else if(DDEstadoInterlocutor.isSolicitudBaja(compradorExpediente.getEstadoInterlocutor())) {
						estadoInterlocutorCodigo = DDEstadoInterlocutor.CODIGO_SOLICITUD_BAJA;	
					}else if(!esNuevo && haCambiadoPorcionCompra) {
						estadoInterlocutorCodigo = DDEstadoInterlocutor.CODIGO_SOLICITUD_CAMBIO_PORCENTAJE_COMPRA;
					}
					
					isAprobado = this.updateEstadoInterlocutorCompradores(expedienteComercial, compradorExpediente, estadoInterlocutorCodigo, true,response);
				}
				newDataComprador.compradorToDto(comprador);
				newDataComprador.cexToDto(compradorExpediente);
				newDataRepresentante.representanteToDto(compradorExpediente);
				boolean compradorOrepresentanteModificado = interlocutorCaixaService.hasChangestoBC(oldDataComprador,newDataComprador,comprador.getIdPersonaHayaCaixa())
				|| interlocutorCaixaService.hasChangestoBC(oldDataRepresentante,newDataRepresentante,compradorExpediente.getIdPersonaHayaCaixaRepresentante());
				if (compradorOrepresentanteModificado){
					response.setIdComprador(comprador.getId());
					response.setNumOferta(expedienteComercial.getOferta().getNumOferta());
					response.setReplicarCLiente(Boolean.TRUE);
					if(new BigDecimal(100).equals(expedienteComercial.getImporteParticipacionTotal()) && (esNuevo || haCambiadoPorcionCompra) && isAprobado) {
						this.guardaBloqueoReplicaOferta(expedienteComercial, compradorExpediente,response);
					};
				}
			}

		}

		response.setSucessComprador(Boolean.TRUE);

		return response;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean marcarCompradorPrincipal(Long idComprador, Long idExpedienteComercial) {
		Filter filterLista = genericDao.createFilter(FilterType.EQUALS, "primaryKey.expediente.id",idExpedienteComercial);
		List<CompradorExpediente> listaCompradores = genericDao.getList(CompradorExpediente.class, filterLista);
		ExpedienteComercial expediente = findOne(idExpedienteComercial);
		boolean isBk = false;
		Oferta oferta = null;
		if(expediente.getOferta() != null) {
			oferta = expediente.getOferta();
			if(oferta.getActivoPrincipal() != null && DDCartera.isCarteraBk(oferta.getActivoPrincipal().getCartera())){
				isBk = true;
			}
		}
		
		for (CompradorExpediente compradorExpediente : listaCompradores) {
			if (idComprador.equals(compradorExpediente.getPrimaryKey().getComprador().getId())) {
				compradorExpediente.setTitularContratacion(1);
				if(isBk) {
					tramitacionOfertasManager.setInterlocutorOferta(compradorExpediente, true, oferta);
				}
			} else {
				compradorExpediente.setTitularContratacion(0);
				if(isBk) {
					tramitacionOfertasManager.setInterlocutorOferta(compradorExpediente, false, oferta);
				}
			}
			genericDao.update(CompradorExpediente.class, compradorExpediente);
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public String getTareaDefinicionDeOferta(Long idExpedienteComercial, WebDto webDto) {
		Oferta oferta = null;
		ExpedienteComercial expediente = findOne(idExpedienteComercial);
		List<ActivoTramite> listaTramites = null;
		String resultadoTramite = "venta";
		try {
			if (expediente != null) {

				if (expediente.getTrabajo() != null) {
					listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(expediente.getTrabajo().getId());
				}
				oferta = expediente.getOferta();
				if (oferta != null && oferta.getTipoOferta() != null
						&& DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())
						&& listaTramites != null && !listaTramites.isEmpty()) {

					ActivoTramite tramite = listaTramites.get(0);
					Set<TareaActivo> listaTareas = tramite.getTareas();

					if (listaTareas != null && listaTareas.size() >= 2) {
						for (TareaActivo tarea : listaTareas) {
							if ("Verificar seguro de rentas".equals(tarea.getTarea())) {
								return FECHA_SEGURO_RENTA;

							} else if ("Verificar scoring".equals(tarea.getTarea())) {
								return FECHA_SCORING;
							}
						}

					} else {
						resultadoTramite = NO_MOSTRAR;
					}

				}
			}

		} catch (Exception e) {
			logger.error("error en expedienteComercialManager", e);
			return resultadoTramite;
		}
		return resultadoTramite;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean checkCamposComprador(TareaExterna tareaExterna){

		Boolean comprobarCompradores;
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);

		comprobarCompradores = this.compruebaCompradores(expedienteComercial);

		return comprobarCompradores;
	}

	@Override
	@Transactional(readOnly = false)
	public List<GastosExpediente> actualizarHonorariosPorExpediente(Long idExpediente) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		List<GastosExpediente> gastosExpediente = genericDao.getList(GastosExpediente.class, filtro);
		List<GastosExpediente> honorarios = new ArrayList<GastosExpediente>();
		ExpedienteComercial eco = this.findOne(idExpediente);
		if(eco != null) {
			Oferta oferta = eco.getOferta();
			boolean isAlquiler = DDTipoOferta.isTipoAlquiler(oferta.getTipoOferta());
			if(oferta != null) {			
				for (GastosExpediente gastoExpediente : gastosExpediente) {
					if (DDTipoCalculo.TIPO_CALCULO_PORCENTAJE.equals(gastoExpediente.getTipoCalculo().getCodigo())) {
						Double calculoImporteC = gastoExpediente.getImporteCalculo();
						Long idActivo = gastoExpediente.getActivo().getId();
						Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo", idActivo);
						Filter filtroOferta = genericDao.createFilter(FilterType.EQUALS, "oferta", oferta.getId());
						ActivoOferta activoOferta = genericDao.get(ActivoOferta.class, filtroActivo, filtroOferta);
						if(activoOferta != null && activoOferta.getImporteActivoOferta() != null && calculoImporteC != null) {
							Double honorario = (activoOferta.getImporteActivoOferta() * calculoImporteC / 100);
							// Si el honorario es menor de 100 € y es de tipo alquiler el valor final será, salvo si el importe es fijo, de 100 €. HREOS-5149
							if (honorario < 100.00 && isAlquiler) {
								gastoExpediente.setImporteFinal(100.00);
							} else {
								gastoExpediente.setImporteFinal(honorario);
							}
						}
		
						honorarios.add(gastoExpediente);
						genericDao.save(GastosExpediente.class, gastoExpediente);
					}
				}
			}
		}
		return honorarios;
	}

	@Transactional(readOnly = false)
	public boolean saveHonorario(DtoGastoExpediente dtoGastoExpediente) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoGastoExpediente.getId()));
		GastosExpediente gastoExpediente = genericDao.get(GastosExpediente.class, filtro);

		if (dtoGastoExpediente.getCodigoTipoComision() != null) {
			DDAccionGastos acciongasto = (DDAccionGastos) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDAccionGastos.class, dtoGastoExpediente.getCodigoTipoComision());
			if (acciongasto != null) {
				gastoExpediente.setAccionGastos(acciongasto);
			}
		}

		if (dtoGastoExpediente.getCodigoTipoCalculo() != null) {
			DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDTipoCalculo.class, dtoGastoExpediente.getCodigoTipoCalculo());
			gastoExpediente.setTipoCalculo(tipoCalculo);
		}

		DDTipoProveedorHonorario tipoProveedor = null;

		if (dtoGastoExpediente.getCodigoTipoProveedor() != null) {
			Filter filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo",
					dtoGastoExpediente.getCodigoTipoProveedor());
			tipoProveedor = genericDao.get(DDTipoProveedorHonorario.class, filtroTipoProveedor);
		}

		if (tipoProveedor != null) {
			if (DDTipoProveedorHonorario.CODIGO_OFICINA_BANKIA.equals(tipoProveedor.getCodigo())
					|| DDTipoProveedorHonorario.CODIGO_OFICINA_CAJAMAR.equals(tipoProveedor.getCodigo())) {
				// Si es de estos tipos no puede haber proveedor.
				gastoExpediente.setProveedor(null);
				dtoGastoExpediente.setIdProveedor(null);
			}
			gastoExpediente.setTipoProveedor(tipoProveedor);
		}

		if (dtoGastoExpediente.getCodigoProveedorRem() != null) {
			Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
					dtoGastoExpediente.getCodigoProveedorRem());
			ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroProveedor);

			if (proveedor == null
					|| !proveedor.getTipoProveedor().getCodigo().equals(dtoGastoExpediente.getCodigoTipoProveedor())) {
				throw new JsonViewerException(ExpedienteComercialManager.PROVEDOR_NO_EXISTE_O_DISTINTO_TIPO);
			}

			gastoExpediente.setProveedor(proveedor);
		}

		gastoExpediente.setImporteCalculo(dtoGastoExpediente.getImporteCalculo());

		// Si el honorario es menor de 100 € el valor final será, salvo si el importe es
		// fijo, de 100 €. HREOS-5149
		if(gastoExpediente.getExpediente() != null && gastoExpediente.getExpediente().getOferta() != null) {
			Oferta oferta = gastoExpediente.getExpediente().getOferta();
			
			if (dtoGastoExpediente.getHonorarios() < 100.00 && DDTipoOferta.isTipoAlquiler(oferta.getTipoOferta())
					&& !DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO_ALQ.equals(dtoGastoExpediente.getCodigoTipoCalculo())
					&& !DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO.equals(dtoGastoExpediente.getCodigoTipoCalculo())) {
				gastoExpediente.setImporteFinal(100.00);
			} else {
				gastoExpediente.setImporteFinal(dtoGastoExpediente.getHonorarios());
			}
		}

		gastoExpediente.setObservaciones(dtoGastoExpediente.getObservaciones());
		gastoExpediente.setEditado(1);

		if (dtoGastoExpediente.getIdActivo() != null) {
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
		boolean estadoBcModificado = false;
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		CompradorExpediente compradorExpediente = null;
		ArrayList<Long> idActivoActualizarPublicacion = new ArrayList<Long>();

		if (!Checks.esNulo(expedienteComercial)) {
			boolean actualizarEstadoPublicacion = false;

			try {

				beanUtilNotNull.copyProperties(expedienteComercial, dto);

				if (!Checks.esNulo(dto.getCodigoEstado())) {
					DDEstadosExpedienteComercial estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoEstado()));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

				}

				if (!Checks.esNulo(dto.getConflictoIntereses())
						|| !Checks.esNulo(dto.getRiesgoReputacional())) {
					ofertaApi.resetPBC(expedienteComercial, false);
				}

				if (!Checks.esNulo(dto.getNumContratoAlquiler())) {
					expedienteComercial.setNumContratoAlquiler(dto.getNumContratoAlquiler());
				}

				if (!Checks.esNulo(dto.getRiesgoReputacional())) {
					expedienteComercial.setRiesgoReputacional(dto.getRiesgoReputacional());
				}

				if (!Checks.esNulo(dto.getConflictoIntereses())) {
					expedienteComercial.setConflictoIntereses(dto.getConflictoIntereses());
				}

				if (!Checks.esNulo(dto.getFechaVenta())) {
					expedienteComercial.setFechaVenta(dto.getFechaVenta());
				}

				if (!Checks.esNulo(dto.getFechaSancion())) {
					expedienteComercial.setFechaSancion(dto.getFechaSancion());
				}

				if (!Checks.esNulo(dto.getFechaSancionComite())) {
					expedienteComercial.setFechaSancionComite(dto.getFechaSancionComite());
				}

				if (!Checks.esNulo(dto.getEstadoPbc())) {
					expedienteComercial.setEstadoPbc(dto.getEstadoPbc());
				}

				if (!Checks.esNulo(dto.getPeticionarioAnulacion())) {
					expedienteComercial.setPeticionarioAnulacion(dto.getPeticionarioAnulacion());
				}
				Oferta oferta = expedienteComercial.getOferta();
				if (!Checks.esNulo(dto.getCodMotivoAnulacion()) && (DDTipoOferta.isTipoVenta(oferta.getTipoOferta()) || DDCartera.isCarteraBk(oferta.getActivoPrincipal().getCartera()))) {
					DDMotivoAnulacionExpediente motivoAnulacionExpediente = (DDMotivoAnulacionExpediente) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDMotivoAnulacionExpediente.class, dto.getCodMotivoAnulacion());
					expedienteComercial.setMotivoAnulacion(motivoAnulacionExpediente);

					actualizarEstadoPublicacion = true;
				}

				if (!Checks.esNulo(dto.getCodMotivoRechazoExp()) && DDTipoOferta.CODIGO_ALQUILER
						.equals(expedienteComercial.getOferta().getTipoOferta().getCodigo())) {
					DDMotivoRechazoExpediente motivoRechazoExpediente = (DDMotivoRechazoExpediente) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDMotivoRechazoExpediente.class, dto.getCodMotivoRechazoExp());

					expedienteComercial.setMotivoRechazo(motivoRechazoExpediente);

					actualizarEstadoPublicacion = true;
				}

				if (!Checks.esNulo(expedienteComercial.getReserva())) {
					if (!Checks.esNulo(dto.getEstadoDevolucionCodigo())) {
						DDEstadoDevolucion estadoDevolucion = (DDEstadoDevolucion) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDEstadoDevolucion.class, dto.getEstadoDevolucionCodigo());
						expedienteComercial.getReserva().setEstadoDevolucion(estadoDevolucion);

						if (dto.getEstadoDevolucionCodigo().equals(DDEstadoDevolucion.ESTADO_DEVUELTA)) {
							if (Checks.esNulo(dto.getCodigoEstado())) {
								DDEstadosExpedienteComercial estadoExpedienteComercial = (DDEstadosExpedienteComercial) utilDiccionarioApi
										.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class,
												DDEstadosExpedienteComercial.ANULADO);
								expedienteComercial.setEstado(estadoExpedienteComercial);
								recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

							}
							expedienteComercial.setFechaVenta(null);
							expedienteComercial.getReserva()
									.setEstadoReserva((DDEstadosReserva) utilDiccionarioApi.dameValorDiccionarioByCod(
											DDEstadosReserva.class, DDEstadosReserva.CODIGO_RESUELTA_DEVUELTA));
							expedienteComercial.getOferta().setEstadoOferta((DDEstadoOferta) utilDiccionarioApi
									.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_RECHAZADA));
//							HREOS-13592 Se bloquea el evolutivo de ocultación de activos para la subida 							
//							for (ActivoOferta activoOferta : expedienteComercial.getOferta().getActivosOferta()) {
//								if (activoOferta != null && activoOferta.getPrimaryKey() != null 
//										&& activoOferta.getPrimaryKey().getActivo() != null) {
//									activoApi.devolucionFasePublicacionAnterior(activoOferta.getPrimaryKey().getActivo());
//								}								
//							}
						}
						// Descongelamos el resto de ofertas del activo.
						ofertaApi.descongelarOfertas(expedienteComercial);
						actualizarEstadoPublicacion = true;
					}

					if (!Checks.esNulo(dto.getFechaReserva())) {
						expedienteComercial.getReserva().setFechaFirma(dto.getFechaReserva());
					}

					if (!Checks.esNulo(dto.getFechaContabilizacionReserva())) {
						expedienteComercial.getReserva()
								.setFechaContabilizacionReserva(dto.getFechaContabilizacionReserva());
					}
				}

				if (!Checks.esNulo(dto.getTipoAlquiler())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoAlquiler());
					DDTipoAlquiler tipoAlquiler = genericDao.get(DDTipoAlquiler.class, filtro);

					expedienteComercial.setTipoAlquiler(tipoAlquiler);
				}

				if (!Checks.esNulo(dto.getTipoInquilino())) {

					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "comprador",
							expedienteComercial.getCompradorPrincipal().getId());
					Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "expediente",
							expedienteComercial.getId());
					compradorExpediente = genericDao.get(CompradorExpediente.class, filtro, filtro2);

					if (!Checks.esNulo(compradorExpediente)) {

						Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoInquilino());
						DDTipoInquilino tipoInquilino = genericDao.get(DDTipoInquilino.class, filtro3);

						compradorExpediente.setTipoInquilino(tipoInquilino);
					}

				}

				if (!Checks.esNulo(expedienteComercial.getUltimoPosicionamiento())
						&& !Checks.esNulo(dto.getFechaPosicionamiento())) {
					expedienteComercial.getUltimoPosicionamiento()
							.setFechaPosicionamiento(dto.getFechaPosicionamiento());
				}

				if (!Checks.esNulo(dto.getCodigoComiteSancionador())) {
					expedienteComercial.setComiteSancion((DDComiteSancion) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDComiteSancion.class, dto.getCodigoComiteSancionador()));
				}
				
				if(dto.getCodigoEstadoBc() != null) {
					expedienteComercial.setEstadoBc((DDEstadoExpedienteBc) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoExpedienteBc.class, dto.getCodigoEstadoBc()));
					estadoBcModificado = true;
				}
				
				if (dto.getEstadoPbcArras() != null) {
					expedienteComercial.setEstadoPbcArras(dto.getEstadoPbcArras());
				}
				if (dto.getEstadoPbcCn() != null) {
					expedienteComercial.setEstadoPbcCn(dto.getEstadoPbcCn());
				}
				if (dto.getFechaReservaDeposito() != null) {
					expedienteComercial.setFechaReservaDeposito(dto.getFechaReservaDeposito());
				}
				if (dto.getFechaContabilizacion() != null) {
					expedienteComercial.setFechaContabilizacion(dto.getFechaContabilizacion());
				}
				if(dto.getClasificacionCodigo() != null && expedienteComercial.getOferta() != null) {
					DDClasificacionContratoAlquiler clasificacion = (DDClasificacionContratoAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDClasificacionContratoAlquiler.class, dto.getClasificacionCodigo());
					expedienteComercial.getOferta().setClasificacion(clasificacion);
				}
				
				expedienteComercial.setMesesDuracionCntAlquiler(dto.getMesesDuracionCntAlquiler());
				expedienteComercial.setDetalleAnulacionCntAlquiler(dto.getDetalleAnulacionCntAlquiler());
				if(dto.getMotivoRechazoAntiguoDeudCod() != null) {
					DDMotivoRechazoAntiguoDeud motivoRechazoAntiguoDeud = (DDMotivoRechazoAntiguoDeud) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRechazoAntiguoDeud.class, dto.getMotivoRechazoAntiguoDeudCod());
					expedienteComercial.setMotivoRechazoAntiguoDeud(motivoRechazoAntiguoDeud);
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
						idActivoActualizarPublicacion.add(activoOferta.getPrimaryKey().getActivo().getId());
						// activoAdapter.actualizarEstadoPublicacionActivo(activoOferta.getPrimaryKey().getActivo().getId());
					}
				}

				activoAdapter.actualizarEstadoPublicacionActivo(idActivoActualizarPublicacion, true);
			} catch (IllegalAccessException e) {
				logger.error("error en expedienteComercialManager", e);

			} catch (InvocationTargetException e) {
				logger.error("error en expedienteComercialManager", e);

			} catch (Exception e) {
				logger.error("error en expedienteComercialManager", e);
			}
		}

		if(estadoBcModificado) {
			ofertaApi.replicateOfertaFlush(expedienteComercial.getOferta());
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

	@Transactional(readOnly = false)
	public DtoCompradorLLamadaBC createComprador(VBusquedaDatosCompradorExpediente dto, Long idExpediente) {

		DtoCompradorLLamadaBC response = new DtoCompradorLLamadaBC();

		Filter filtroComprador = genericDao.createFilter(FilterType.EQUALS, "documento", dto.getNumDocumento());
		Comprador compradorBusqueda = genericDao.get(Comprador.class, filtroComprador);

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idExpediente);
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);
		CompradorExpediente compradorExpediente = new CompradorExpediente();
		DDEstadoContrasteListas estadoNoSolicitado = genericDao.get(DDEstadoContrasteListas.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoContrasteListas.NO_SOLICITADO));
		boolean esOfertaCaixa = expediente != null && expediente.getOferta() != null ? particularValidatorApi.esOfertaCaixa(expediente.getOferta().getNumOferta().toString()) : false;
		//compradorExpediente.setBorrado(false);

		if (!Checks.esNulo(compradorBusqueda)) {
			CompradorExpedientePk pk = new CompradorExpedientePk();
			pk.setComprador(compradorBusqueda);
			pk.setExpediente(expediente);
			compradorExpediente.setPrimaryKey(pk);
			compradorExpediente.setPorcionCompra(dto.getPorcentajeCompra());

			if (!Checks.esNulo(dto.getCodigoRegimenMatrimonial())) {
				Filter filtroRegimenMatrimonial = genericDao.createFilter(FilterType.EQUALS, "codigo",
						dto.getCodigoRegimenMatrimonial());
				DDRegimenesMatrimoniales regimenMatrimonial = genericDao.get(DDRegimenesMatrimoniales.class,
						filtroRegimenMatrimonial);
				if (!Checks.esNulo(regimenMatrimonial))
					compradorExpediente.setRegimenMatrimonial(regimenMatrimonial);
			}

			if (!Checks.esNulo(dto.getCodEstadoCivil())) {
				Filter filtroEstadoCivil = genericDao.createFilter(FilterType.EQUALS, "codigo",
						dto.getCodEstadoCivil());
				DDEstadosCiviles estadoCivil = genericDao.get(DDEstadosCiviles.class, filtroEstadoCivil);
				if (!Checks.esNulo(estadoCivil))
					compradorExpediente.setEstadoCivil(estadoCivil);
			}
			
			if (!Checks.esNulo(dto.getCodEstadoContraste())) {
				Filter filtroEstadoContraste = genericDao.createFilter(FilterType.EQUALS, "codigo",
						dto.getCodEstadoContraste());
				DDEstadoContrasteListas estadoContraste = genericDao.get(DDEstadoContrasteListas.class, filtroEstadoContraste);
				if (!Checks.esNulo(estadoContraste)) {
					compradorExpediente.setEstadoContrasteListas(estadoContraste);
				}
			}else {
				compradorExpediente.setEstadoContrasteListas(estadoNoSolicitado);
			}
			compradorExpediente.setFechaContrasteListas(new Date());
			
			if (!Checks.esNulo(dto.getTitularContratacion()) && Checks.esNulo(expediente.getCompradorPrincipal())) {
				compradorExpediente.setTitularContratacion(dto.getTitularContratacion());

			} else {
				compradorExpediente.setTitularContratacion(0);
			}

			//compradorExpediente.setBorrado(false);

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
			
			Filter filtroAdjunto = genericDao.createFilter(FilterType.NOTNULL, "idAdjunto");
			List<TmpClienteGDPR> tmpClienteGDPR = genericDao.getList(TmpClienteGDPR.class, 
					genericDao.createFilter(FilterType.EQUALS, "numDocumento", dto.getNumDocumento()), filtroAdjunto);
			
			// Historificamos despues del update
			AdjuntoComprador docAdjunto = null;
			if (!Checks.esNulo(dto.getIdDocAdjunto())) {
				docAdjunto = genericDao.get(AdjuntoComprador.class,
						genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdDocAdjunto()));
			} else {
				if (!Checks.estaVacio(tmpClienteGDPR)) {
					docAdjunto = genericDao.get(AdjuntoComprador.class,
							genericDao.createFilter(FilterType.EQUALS, "id", tmpClienteGDPR.get(0).getIdAdjunto()));
				}else {
					tmpClienteGDPR = genericDao.getList(TmpClienteGDPR.class, genericDao.createFilter(FilterType.EQUALS, "numDocumento", dto.getNumDocumento()));
				}
			}

			if (!Checks.esNulo(docAdjunto)) {
				compradorBusqueda.setAdjunto(docAdjunto);
				compradorExpediente.setDocumentoAdjunto(docAdjunto);
			}

			if(!Checks.estaVacio(tmpClienteGDPR) && !Checks.esNulo(tmpClienteGDPR.get(0).getIdPersonaHaya()))
				compradorBusqueda.setIdPersonaHaya(tmpClienteGDPR.get(0).getIdPersonaHaya());
			
			if(!Checks.esNulo(dto.getLocalidadNacimientoRepresentanteCodigo())) {
				Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo",dto.getLocalidadNacimientoRepresentanteCodigo());
				Localidad localidad = genericDao.get(Localidad.class, filtroLocalidad);
				compradorExpediente.setLocalidadNacimientoRepresentante(localidad);
				
			}
			if(!Checks.esNulo(dto.getFechaNacimientoRepresentante())) {
				compradorExpediente.setFechaNacimientoRepresentante(dto.getFechaNacimientoRepresentante());
			}
			
			if (!Checks.esNulo(dto.getPaisNacimientoRepresentanteCodigo())) {
				Filter filtroPais = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPaisNacimientoRepresentanteCodigo());
				DDPaises pais = genericDao.get(DDPaises.class, filtroPais);
				compradorExpediente.setPaisNacimientoRepresentante(pais);
			}

			assignIAPCompradorRepresentante(compradorExpediente,expediente.getId(),compradorBusqueda,expediente.getOferta());

			genericDao.save(Comprador.class,compradorBusqueda);

			if(compradorBusqueda.getInfoAdicionalPersona() != null) {
				Filter filtroEstadoC4C = genericDao.createFilter(FilterType.EQUALS, "codigo",DDEstadoComunicacionC4C.C4C_NO_ENVIADO);
				DDEstadoComunicacionC4C estadoComunicacionC4C = genericDao.get(DDEstadoComunicacionC4C.class, filtroEstadoC4C);
				compradorBusqueda.getInfoAdicionalPersona().setEstadoComunicacionC4C(estadoComunicacionC4C);
			}
			
			if(expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null && DDCartera.isCarteraBk(expediente.getOferta().getActivoPrincipal().getCartera())) {
				boolean isPrincipal = compradorExpediente.getTitularContratacion() == 1 ? true : false;
				tramitacionOfertasManager.setInterlocutorOferta(compradorExpediente, isPrincipal, expediente.getOferta());
			}
			
			
			expediente.getCompradores().add(compradorExpediente);

			genericDao.save(ExpedienteComercial.class, expediente);

			ofertaApi.resetPBC(expediente, true);

			if(!Checks.estaVacio(tmpClienteGDPR))
				clienteComercialDao.deleteTmpClienteByDocumento(tmpClienteGDPR.get(0).getNumDocumento());

			if (esOfertaCaixa && compradorBusqueda.getInfoAdicionalPersona() != null && compradorBusqueda.getInfoAdicionalPersona().getEstadoComunicacionC4C() != null && DDEstadoComunicacionC4C.C4C_NO_ENVIADO.equals(compradorBusqueda.getInfoAdicionalPersona().getEstadoComunicacionC4C().getCodigo()))
				response.setIdComprador(compradorBusqueda.getId());
				response.setReplicarCLiente(Boolean.TRUE);
				response.setNumOferta(expediente.getOferta().getNumOferta());
			response.setSucessComprador(Boolean.TRUE);

			return response;
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
					DDTiposPersona tipoPersona = (DDTiposPersona) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTiposPersona.class, dto.getCodTipoPersona());
					comprador.setTipoPersona(tipoPersona);
				}

				// Datos de identificación
				if (!Checks.esNulo(dto.getApellidos())) {
					comprador.setApellidos(dto.getApellidos());
				}

				if (!Checks.esNulo(dto.getCodTipoDocumento())) {
					DDTipoDocumento tipoDocumentoComprador = (DDTipoDocumento) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumento());
					comprador.setTipoDocumento(tipoDocumentoComprador);
				}

				if (!Checks.esNulo(dto.getNombreRazonSocial())) {
					comprador.setNombre(dto.getNombreRazonSocial());
				}

				if (!Checks.esNulo(dto.getProvinciaCodigo())) {
					DDProvincia provincia = (DDProvincia) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDProvincia.class, dto.getProvinciaCodigo());
					comprador.setProvincia(provincia);
				}

				if (!Checks.esNulo(dto.getMunicipioCodigo())) {
					Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo",
							dto.getMunicipioCodigo());
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
				// HREOS - 4937 -- GDPR
				if (!Checks.esNulo(dto.getCesionDatos())) {
					comprador.setCesionDatos(dto.getCesionDatos());
				}
				if (!Checks.esNulo(dto.getComunicacionTerceros())) {
					comprador.setComunicacionTerceros(dto.getComunicacionTerceros());
				}
				if (!Checks.esNulo(dto.getTransferenciasInternacionales())) {
					comprador.setTransferenciasInternacionales(dto.getTransferenciasInternacionales());
				}

				if (!Checks.esNulo(dto.getTitularReserva())) {
					compradorExpediente.setTitularReserva(dto.getTitularReserva());
				}

				compradorExpediente.setPorcionCompra(dto.getPorcentajeCompra());

				if (!Checks.esNulo(dto.getTitularContratacion()) && Checks.esNulo(expediente.getCompradorPrincipal())) {
					compradorExpediente.setTitularContratacion(dto.getTitularContratacion());

				} else {
					compradorExpediente.setTitularContratacion(0);
				}

				// Nexos
				if (!Checks.esNulo(dto.getCodEstadoCivil())) {
					DDEstadosCiviles estadoCivil = (DDEstadosCiviles) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDEstadosCiviles.class, dto.getCodEstadoCivil());
					compradorExpediente.setEstadoCivil(estadoCivil);
				}
				
				if (!Checks.esNulo(dto.getCodEstadoContraste())) {
					DDEstadoContrasteListas estadoContraste = (DDEstadoContrasteListas) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDEstadoContrasteListas.class, dto.getCodEstadoContraste());
					compradorExpediente.setEstadoContrasteListas(estadoContraste);
				}else {
					compradorExpediente.setEstadoContrasteListas(estadoNoSolicitado);
				}
				compradorExpediente.setFechaContrasteListas(new Date());

				if (!Checks.esNulo(dto.getCodTipoDocumentoConyuge())) {
					DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumentoConyuge());
					compradorExpediente.setTipoDocumentoConyuge(tipoDocumento);
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
					DDRegimenesMatrimoniales regimenMatrimonial = (DDRegimenesMatrimoniales) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDRegimenesMatrimoniales.class,
									dto.getCodigoRegimenMatrimonial());
					compradorExpediente.setRegimenMatrimonial(regimenMatrimonial);
				}

				if (!Checks.esNulo(dto.getAntiguoDeudor())) {
					compradorExpediente.setAntiguoDeudor(dto.getAntiguoDeudor());
				}
				
				if (dto.getSociedad() != null) {
					compradorExpediente.setSociedad(dto.getSociedad());
				}
				
				if (dto.getOficinaTrabajo() != null) {
					compradorExpediente.setOficinaTrabajo(dto.getOficinaTrabajo());
				}

				// Datos representante
				if (!Checks.esNulo(dto.getCodTipoDocumentoRte())) {
					DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumentoRte());
					compradorExpediente.setTipoDocumentoRepresentante(tipoDocumento);
				}

				if (!Checks.esNulo(dto.getNombreRazonSocialRte())) {
					compradorExpediente.setNombreRepresentante(dto.getNombreRazonSocialRte());
				}

				if (!Checks.esNulo(dto.getApellidosRte())) {
					compradorExpediente.setApellidosRepresentante(dto.getApellidosRte());
				}

				if (!Checks.esNulo(dto.getProvinciaRteCodigo())) {
					DDProvincia provinciaRte = (DDProvincia) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDProvincia.class, dto.getProvinciaRteCodigo());
					compradorExpediente.setProvinciaRepresentante(provinciaRte);
				}

				if (!Checks.esNulo(dto.getMunicipioRteCodigo())) {
					Filter filtroLocalidadRte = genericDao.createFilter(FilterType.EQUALS, "codigo",
							dto.getMunicipioRteCodigo());
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
					Filter filtroGradoPropiedad = genericDao.createFilter(FilterType.EQUALS, "codigo",
							dto.getCodigoGradoPropiedad());
					DDTipoGradoPropiedad gradoPropiedad = genericDao.get(DDTipoGradoPropiedad.class,
							filtroGradoPropiedad);
					compradorExpediente.setGradoPropiedad(gradoPropiedad);
				}

				CompradorExpedientePk pk = new CompradorExpedientePk();
				pk.setComprador(comprador);
				pk.setExpediente(expediente);
				compradorExpediente.setPrimaryKey(pk);

				Filter filtroAdjunto = genericDao.createFilter(FilterType.NOTNULL, "idAdjunto");
				Filter filtroPersona = genericDao.createFilter(FilterType.NOTNULL, "idPersonaHaya");
				List<TmpClienteGDPR> tmpClienteGDPR = genericDao.getList(TmpClienteGDPR.class, 
						genericDao.createFilter(FilterType.EQUALS, "numDocumento", dto.getNumDocumento()), filtroAdjunto, filtroPersona);				
				if(tmpClienteGDPR.size() < 1) {
					tmpClienteGDPR = genericDao.getList(TmpClienteGDPR.class, 
							genericDao.createFilter(FilterType.EQUALS, "numDocumento", dto.getNumDocumento()), filtroPersona);
					if(tmpClienteGDPR.size() < 1) {
						tmpClienteGDPR = genericDao.getList(TmpClienteGDPR.class, 
								genericDao.createFilter(FilterType.EQUALS, "numDocumento", dto.getNumDocumento()));
					}
				}					

				// Historificamos despues del update
				AdjuntoComprador docAdjunto = null;
				if (!Checks.esNulo(dto.getIdDocAdjunto())) {
					docAdjunto = genericDao.get(AdjuntoComprador.class,
							genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdDocAdjunto()));
				} else {
					if (!Checks.estaVacio(tmpClienteGDPR) && !Checks.esNulo(tmpClienteGDPR.get(0).getIdAdjunto())) {
						docAdjunto = genericDao.get(AdjuntoComprador.class,
								genericDao.createFilter(FilterType.EQUALS, "id", tmpClienteGDPR.get(0).getIdAdjunto()));
					}
				}

				if (!Checks.esNulo(docAdjunto)) {
					comprador.setAdjunto(docAdjunto);
					compradorExpediente.setDocumentoAdjunto(docAdjunto);
				}

				if(!Checks.estaVacio(tmpClienteGDPR) && !Checks.esNulo(tmpClienteGDPR.get(0).getIdPersonaHaya()))
					comprador.setIdPersonaHaya(tmpClienteGDPR.get(0).getIdPersonaHaya());

				ClienteCompradorGDPR clienteCompradorGDPR = new ClienteCompradorGDPR();

				if (!Checks.esNulo(dto.getCodTipoDocumento())) {
					DDTipoDocumento tipoDocumentoComprador = (DDTipoDocumento) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumento());
					clienteCompradorGDPR.setTipoDocumento(tipoDocumentoComprador);
				}
				if (!Checks.esNulo(dto.getNumDocumento())) {
					clienteCompradorGDPR.setNumDocumento(dto.getNumDocumento());
				}
				if (!Checks.esNulo(dto.getCesionDatos())) {
					clienteCompradorGDPR.setCesionDatos(dto.getCesionDatos());
				}
				if (!Checks.esNulo(dto.getComunicacionTerceros())) {
					clienteCompradorGDPR.setComunicacionTerceros(dto.getComunicacionTerceros());
				}
				if (!Checks.esNulo(dto.getTransferenciasInternacionales())) {
					clienteCompradorGDPR.setTransferenciasInternacionales(dto.getTransferenciasInternacionales());

				}
				if (!Checks.esNulo(docAdjunto)) {
					clienteCompradorGDPR.setAdjuntoComprador(docAdjunto);
				}
				
				
				if(!Checks.esNulo(dto.getLocalidadNacimientoCompradorCodigo())) {
					Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo",dto.getLocalidadNacimientoCompradorCodigo());
					Localidad localidad = genericDao.get(Localidad.class, filtroLocalidad);
					comprador.setLocalidadNacimientoComprador(localidad);
					
				}
				
				if(!Checks.esNulo(dto.getPaisNacimientoCompradorCodigo())) {
					Filter filtroPais = genericDao.createFilter(FilterType.EQUALS, "codigo",dto.getPaisNacimientoCompradorCodigo());
					DDPaises pais = genericDao.get(DDPaises.class, filtroPais);
					comprador.setPaisNacimientoComprador(pais);
					
				}
				
				if(!Checks.esNulo(dto.getFechaNacimientoConstitucion())) {
					comprador.setFechaNacimientoConstitucion(dto.getFechaNacimientoConstitucion());
				}
				if(!Checks.esNulo(dto.getCompradorPrp())) {
					comprador.setCompradorPrp(dto.getCompradorPrp());
				}
				
				if(!Checks.esNulo(dto.getLocalidadNacimientoRepresentanteCodigo())) {
					Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo",dto.getLocalidadNacimientoRepresentanteCodigo());
					Localidad localidad = genericDao.get(Localidad.class, filtroLocalidad);
					compradorExpediente.setLocalidadNacimientoRepresentante(localidad);
					
				}
				if(!Checks.esNulo(dto.getFechaNacimientoRepresentante())) {
					compradorExpediente.setFechaNacimientoRepresentante(dto.getFechaNacimientoRepresentante());
				}
				
				if (!Checks.esNulo(dto.getPaisNacimientoRepresentanteCodigo())) {
					Filter filtroPais = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPaisNacimientoRepresentanteCodigo());
					DDPaises pais = genericDao.get(DDPaises.class, filtroPais);
					compradorExpediente.setPaisNacimientoRepresentante(pais);
				}

				assignIAPCompradorRepresentante(compradorExpediente,expediente.getId(),comprador,expediente.getOferta());


				InfoAdicionalPersona iap = comprador.getInfoAdicionalPersona();

				if(!Checks.esNulo(dto.getVinculoCaixaCodigo())) {
					iap.setVinculoCaixa(genericDao.get(DDVinculoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getVinculoCaixaCodigo())));
					iap.setSociedad(dto.getSociedad());
					iap.setOficinaTrabajo(dto.getOficinaTrabajo());
				}

				comprador.setInfoAdicionalPersona(iap);
				
				if(expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null && DDCartera.isCarteraBk(expediente.getOferta().getActivoPrincipal().getCartera())) {
					boolean isPrincipal = compradorExpediente.getTitularContratacion() == 1 ? true : false;
					tramitacionOfertasManager.setInterlocutorOferta(compradorExpediente, isPrincipal, expediente.getOferta());
				}
				
				
				genericDao.save(InfoAdicionalPersona.class, iap);

				genericDao.save(ClienteCompradorGDPR.class, clienteCompradorGDPR);

				genericDao.save(Comprador.class, comprador);
				
				expediente.getCompradores().add(compradorExpediente);

				genericDao.save(ExpedienteComercial.class, expediente);
				
				ofertaApi.resetPBC(expediente, true);

				Boolean isAprobado = false;

				if(expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null && DDCartera.isCarteraBk(expediente.getOferta().getActivoPrincipal().getCartera())) {
					isAprobado = this.updateEstadoInterlocutorCompradores(expediente, compradorExpediente, DDEstadoInterlocutor.CODIGO_SOLICITUD_ALTA, true,response);

				}


				if(!Checks.estaVacio(tmpClienteGDPR))
					clienteComercialDao.deleteTmpClienteByDocumento(tmpClienteGDPR.get(0).getNumDocumento());

				if (esOfertaCaixa && comprador.getInfoAdicionalPersona() != null && comprador.getInfoAdicionalPersona().getEstadoComunicacionC4C() != null
						&& DDEstadoComunicacionC4C.C4C_NO_ENVIADO.equals(comprador.getInfoAdicionalPersona().getEstadoComunicacionC4C().getCodigo())){
					response.setNumOferta(expediente.getOferta().getNumOferta());
					response.setIdComprador(comprador.getId());
					response.setReplicarCLiente(Boolean.TRUE);
					if(new BigDecimal(100).equals(expediente.getImporteParticipacionTotal()) && isAprobado) {
						this.guardaBloqueoReplicaOferta(expediente, compradorExpediente,response);
					}
				}

				response.setSucessComprador(Boolean.TRUE);

				return response;

			} catch (Exception e) {
				logger.error("error en expedienteComercialManager", e);
				response.setSucessComprador(Boolean.FALSE);
				return response;
			}
		}
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createCompradorAndSendToBC(VBusquedaDatosCompradorExpediente dto, Long idExpediente){
		DtoCompradorLLamadaBC responseComprador = createComprador(dto,idExpediente);
		if (responseComprador.getSucessComprador() != null && responseComprador.getSucessComprador())
			interlocutorCaixaService.callReplicateClientAndOfertaOnComprador(responseComprador);
		return responseComprador.getSucessComprador();
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveFichaCompradorAndSendToBC(VBusquedaDatosCompradorExpediente dto){
		DtoCompradorLLamadaBC responseComprador = saveFichaComprador(dto);
		if (responseComprador.getSucessComprador() != null && responseComprador.getSucessComprador())
			interlocutorCaixaService.callReplicateClientAndOfertaOnComprador(responseComprador);
		return responseComprador.getSucessComprador();
	}

	@Override
	public String consultarComiteSancionador(Long idExpediente) throws Exception {
		Double porcentajeImpuesto = null;

		try {
			ExpedienteComercial expediente = findOne(idExpediente);
			if (!Checks.esNulo(expediente.getCondicionante())) {
				if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
					porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable();
				}
			}

			InstanciaDecisionDto instancia = expedienteComercialToInstanciaDecisionList(expediente, porcentajeImpuesto,
					null);

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

		if (!Checks.esNulo(expediente.getCondicionante())
				&& !Checks.esNulo(expediente.getCondicionante().getSolicitaFinanciacion())
				&& expediente.getCondicionante().getSolicitaFinanciacion().getCodigo().equals("01")) {
			solicitaFinanciacion = true;
		}

		Integer numActivoEspecial = Checks.esNulo(activo.getNumActivoUvem()) ? 0 : activo.getNumActivoUvem().intValue();
		Long importe = Checks.esNulo(oferta.getImporteContraOferta())
				? Double.valueOf(oferta.getImporteOferta() * 100).longValue()
				: Double.valueOf(oferta.getImporteContraOferta() * 100).longValue();

		if (!Checks.esNulo(expediente.getCondicionante())
				&& !Checks.esNulo(expediente.getCondicionante().getTipoImpuesto())) {
			String tipoImpuestoCodigo = expediente.getCondicionante().getTipoImpuesto().getCodigo();
			if (DDTiposImpuesto.TIPO_IMPUESTO_IVA.equals(tipoImpuestoCodigo))
				tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IVA;
			if (DDTiposImpuesto.TIPO_IMPUESTO_IGIC.equals(tipoImpuestoCodigo))
				tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IGIC;
			if (DDTiposImpuesto.TIPO_IMPUESTO_IPSI.equals(tipoImpuestoCodigo))
				tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IPSI;
			if (DDTiposImpuesto.TIPO_IMPUESTO_ITP.equals(tipoImpuestoCodigo))
				tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_ITP;
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

	public InstanciaDecisionDto expedienteComercialToInstanciaDecisionList(ExpedienteComercial expediente,
			Double porcentajeImpuesto, String codComiteSuperior) throws Exception {
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

		if (oferta.getVentaDirecta() != null) {
			instancia.setOfertaVentaCartera(oferta.getVentaDirecta());
		} else {
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
		// Double sumatorioImporte = new Double(0);

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
			// importeXActivo = listaActivos.get(i).getImporteActivoOferta();

			sumatorioImporte = sumatorioImporte.add(importeXActivo);

			InstanciaDecisionDataDto instData = new InstanciaDecisionDataDto();
			// ImportePorActivo
			// instData.setImporteConSigno(Double.valueOf(num.format(importeXActivo*100)).longValue());
			instData.setImporteConSigno(importeXActivo.multiply(new BigDecimal(100)).longValue());
			// NumActivoUvem
			instData.setIdentificadorActivoEspecial(Integer.valueOf(activo.getNumActivoUvem().toString()));

			// TipoImpuesto
			if (!Checks.esNulo(expediente.getCondicionante())
					&& !Checks.esNulo(expediente.getCondicionante().getTipoImpuesto())) {
				tipoImpuestoCodigo = expediente.getCondicionante().getTipoImpuesto().getCodigo();
				if (DDTiposImpuesto.TIPO_IMPUESTO_IVA.equals(tipoImpuestoCodigo))
					tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IVA;
				if (DDTiposImpuesto.TIPO_IMPUESTO_IGIC.equals(tipoImpuestoCodigo))
					tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IGIC;
				if (DDTiposImpuesto.TIPO_IMPUESTO_IPSI.equals(tipoImpuestoCodigo))
					tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IPSI;
				if (DDTiposImpuesto.TIPO_IMPUESTO_ITP.equals(tipoImpuestoCodigo))
					tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_ITP;

			}

			if (!Checks.esNulo(tipoDeImpuesto)) {
				instData.setTipoDeImpuesto(tipoDeImpuesto);
			} else {
				throw new JsonViewerException("No se ha indicado el tipo de impuesto.");
			}

			if (!Checks.esNulo(expediente.getCondicionante())
					&& !Checks.esNulo(expediente.getCondicionante().getRenunciaExencion())) {
				instData.setRenunciaExencion(expediente.getCondicionante().getRenunciaExencion());
			}

			// PorcentajeImpuesto
			if (!Checks.esNulo(porcentajeImpuesto)) {
				instData.setPorcentajeImpuesto((int) (porcentajeImpuesto * 100));
			}
			instanciaList.add(instData);
		}

		if (!importeTotal.equals(sumatorioImporte.doubleValue())) {
			throw new JsonViewerException("La suma de los importes es diferente al importe de la oferta");
		}

		// SolicitaFinaciacion
		if (!Checks.esNulo(expediente.getCondicionante())
				&& !Checks.esNulo(expediente.getCondicionante().getSolicitaFinanciacion())
				&& expediente.getCondicionante().getSolicitaFinanciacion().getCodigo().equals("01")) {
			solicitaFinanciacion = true;
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
				// si no esta de baja
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
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento",
								comprador.getDocumentoConyuge());
						Comprador compradorConyuge = genericDao.get(Comprador.class, filtro);
						if (compradorConyuge != null) {
							if (compradorConyuge.getIdCompradorUrsus() != null) {
								titular.setConyugeNumeroUrsus(compradorConyuge.getIdCompradorUrsus());
							} else if (compradorConyuge.getIdCompradorUrsusBh() != null) {
								titular.setConyugeNumeroUrsus(compradorConyuge.getIdCompradorUrsusBh());
							}

						}
					}

					if (!primaryKey.equals(compradorPrincipal))
						titulares.add(titular);
					else
						titularPrincipal = titular;
				}
			}
		}

		if (!Checks.esNulo(titularPrincipal))
			titulares.add(0, titularPrincipal);
		instancia.setTitulares(titulares);

		// info de la reserva
		if (!Checks.esNulo(expediente.getCondicionante())) {
			if (expediente.getCondicionante().getImporteReserva() == null) {
				instancia.setImporteReserva(0D);

			} else {
				instancia.setImporteReserva(expediente.getCondicionante().getImporteReserva());
			}

			if (expediente.getCondicionante().getReservaConImpuesto() != null
					&& expediente.getCondicionante().getReservaConImpuesto().equals(1)) {
				instancia.setImpuestosReserva(true);

			} else {
				instancia.setImpuestosReserva(false);
			}

		} else {
			instancia.setImporteReserva(0D);
			instancia.setImpuestosReserva(false);
		}

		if (instancia.getImporteReserva() != null && instancia.getImporteReserva().compareTo(0D) != 0
				&& expediente.getReserva() != null && expediente.getReserva().getTipoArras() != null) {
			instancia.setCodTipoArras(expediente.getReserva().getTipoArras().getCodigo());
		}

		// MOD3
		List<GastosExpediente> gastosExpediente = expediente.getHonorarios();

		if (!Checks.estaVacio(gastosExpediente)) {
			for (GastosExpediente gastoExp : gastosExpediente) {
				if (!Checks.esNulo(gastoExp.getAccionGastos())
						&& DDAccionGastos.CODIGO_PRESCRIPCION.equals(gastoExp.getAccionGastos().getCodigo())) {
					if (!Checks.esNulo(gastoExp.getProveedor()) && DDTipoProveedor.COD_OFICINA_BANKIA
							.equals(gastoExp.getProveedor().getTipoProveedor().getCodigo())) {
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
			if (oferta.getIdUvem() != null) {
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
		char result = ' ';   codigoTipoDoc = "01";
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
			result = 'W';
		} else {
			throw new JsonViewerException("Tipo de documento no soportado");
		}
		return result;
	}

	@Override
	@Transactional(readOnly = false)
	public void sendPosicionamientoToBc(Long idEntidad, Boolean success) {
		ExpedienteComercial expediente = findOne(idEntidad);
		Boolean tieneTareaActiva = ofertaDao.tieneTareaActiva(TareaProcedimientoConstants.CODIGO_T018_AGENDAR_FIRMAR, expediente.getOferta().getNumOferta().toString())
				|| ofertaDao.tieneTareaActiva(TareaProcedimientoConstants.CODIGO_T015_FIRMA, expediente.getOferta().getNumOferta().toString()) ;

		if(tieneTareaActiva && success && DDCartera.isCarteraBk(expediente.getOferta().getActivoPrincipal().getCartera())){
			ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), this.buildReplicarOfertaDtoFromExpediente(expediente));
		}
	}

	@Override
	public Long getExpedienteByPosicionamiento(Long idPosicionamiento) {
		if(idPosicionamiento != null){
			Posicionamiento pos = genericDao.get(Posicionamiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idPosicionamiento));

			if(pos != null && pos.getExpediente() != null){
				return pos.getExpediente().getId();
			}
		}
		return null;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createPosicionamiento(DtoPosicionamiento dto, Long idEntidad) {
		ExpedienteComercial expediente = findOne(idEntidad);
		Posicionamiento posicionamiento = new Posicionamiento();
		List<Posicionamiento> lista = expediente.getPosicionamientos();
		dto.setValidacionBCPosi(DDMotivosEstadoBC.CODIGO_NO_ENVIADA);

		if (lista.isEmpty()) {
			
			posicionamiento = dtoToPosicionamiento(dto, posicionamiento);
			posicionamiento.setExpediente(expediente);

			genericDao.save(Posicionamiento.class, posicionamiento);

			return true;

		} else {
			boolean hayPosicionamientoVigente = false;
			boolean isCarteraBK = false;
			if(!Checks.esNulo(expediente.getOferta()) && !Checks.esNulo(expediente.getOferta().getActivoPrincipal())) {
				isCarteraBK = DDCartera.isCarteraBk(expediente.getOferta().getActivoPrincipal().getCartera());
			}
			for (Posicionamiento p : lista) {
				if (Checks.esNulo(p.getFechaFinPosicionamiento()) && Checks.esNulo(p.getMotivoAplazamiento())
				&& DDTipoOferta.isTipoVenta(expediente.getOferta().getTipoOferta())) {
					hayPosicionamientoVigente = true;
					if(isCarteraBK && DDMotivosEstadoBC.isRechazado(p.getValidacionBCPos())) {
						hayPosicionamientoVigente = false;
					}
					
					if(hayPosicionamientoVigente) {
						 break;
					}
				}else if(Checks.esNulo(p.getMotivoAplazamiento()) &&
						(DDTipoOferta.isTipoAlquiler(expediente.getOferta().getTipoOferta()) || DDTipoOferta.isTipoAlquilerNoComercial(expediente.getOferta().getTipoOferta()))){
					if(isCarteraBK && DDMotivosEstadoBC.isRechazado(p.getValidacionBCPos())) {
						hayPosicionamientoVigente = false;
					}

					if(hayPosicionamientoVigente) {
						break;
					}
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
		if(posicionamiento == null) {
			return false;
		}
		
		if(!Checks.esNulo(dto.getMotivoAplazamiento())){
			posicionamiento.setFechaFinPosicionamiento(new Date());
			if(DDMotivosEstadoBC.isNoEnviada(posicionamiento.getValidacionBCPos())) {
				dto.setValidacionBCPosi(DDMotivosEstadoBC.CODIGO_ANULADA);
			}else if(DDMotivosEstadoBC.isAprobada(posicionamiento.getValidacionBCPos())){
				dto.setValidacionBCPosi(DDMotivosEstadoBC.CODIGO_APLAZADA);
			}
		}
				
		posicionamiento = dtoToPosicionamiento(dto, posicionamiento);

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
		List<ActivoProveedorContacto> listaContactos = genericDao.getList(ActivoProveedorContacto.class,
				filtroProveedorId);

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
	 * @param notario:         entidad de la que obtener los datos.
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
	 * Este método genera un nuevo objeto dto, lo rellena con los datos de la
	 * entidad ActivoProveedorContacto y devuelve el objeto.
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

	public DatosClienteDto buscarNumeroUrsus(String numeroDocumento, String tipoDocumento, String idExpediente)
			throws Exception {
		DtoClienteUrsus compradorUrsus = new DtoClienteUrsus();
		String tipoDoc = null;

		if (!Checks.esNulo(tipoDocumento)) {
			if (DDTiposDocumentos.DNI.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.DNI;
			if (DDTiposDocumentos.CIF.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.CIF;
			if (DDTiposDocumentos.NIF.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.DNI;
			if (DDTiposDocumentos.TARJETA_RESIDENTE.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.TARJETA_RESIDENTE;
			if (DDTiposDocumentos.PASAPORTE.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.PASAPORTE;
			if (DDTiposDocumentos.CIF_EXTRANJERO.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.CIF_EXTRANJERO;
			if (DDTiposDocumentos.DNI_EXTRANJERO.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.DNI_EXTRANJERO;
			if (DDTiposDocumentos.TARJETA_DIPLOMATICA.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.TARJETA_DIPLOMATICA;
			if (DDTiposDocumentos.MENOR.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.MENOR;
			if (DDTiposDocumentos.OTROS_PERSONA_FISICA.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.OTROS_PERSONA_FISICA;
			if (DDTiposDocumentos.OTROS_PESONA_JURIDICA.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.OTROS_PESONA_JURIDICA;
		}

		if (!Checks.esNulo(numeroDocumento)) {
			compradorUrsus.setNumDocumento(numeroDocumento);
		}

		compradorUrsus.setTipoDocumento(tipoDoc);

		if (!Checks.esNulo(idExpediente)) {
			DDSubcartera subcarteraExpediente = getCodigoSubCarteraExpediente(Long.parseLong(idExpediente));

			if (!Checks.esNulo(subcarteraExpediente)
					&& DDSubcartera.CODIGO_BAN_BH.equals(subcarteraExpediente.getCodigo())) {
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
	public List<DatosClienteDto> buscarClientesUrsus(String numeroDocumento, String tipoDocumento, String idExpediente)
			throws Exception {
		List<DatosClienteDto> lista = new ArrayList<DatosClienteDto>();
		String tipoDoc = null;

		try {
			if (Checks.esNulo(numeroDocumento) || Checks.esNulo(tipoDocumento)) {
				return lista;
			}

			if (!Checks.esNulo(tipoDocumento)) {
				if (DDTiposDocumentos.DNI.equals(tipoDocumento))
					tipoDoc = DtoClienteUrsus.DNI;
				if (DDTiposDocumentos.CIF.equals(tipoDocumento))
					tipoDoc = DtoClienteUrsus.CIF;
				if (DDTiposDocumentos.NIF.equals(tipoDocumento))
					tipoDoc = DtoClienteUrsus.DNI;
				if (DDTiposDocumentos.TARJETA_RESIDENTE.equals(tipoDocumento))
					tipoDoc = DtoClienteUrsus.TARJETA_RESIDENTE;
				if (DDTiposDocumentos.PASAPORTE.equals(tipoDocumento))
					tipoDoc = DtoClienteUrsus.PASAPORTE;
				if (DDTiposDocumentos.CIF_EXTRANJERO.equals(tipoDocumento))
					tipoDoc = DtoClienteUrsus.CIF_EXTRANJERO;
				if (DDTiposDocumentos.DNI_EXTRANJERO.equals(tipoDocumento))
					tipoDoc = DtoClienteUrsus.DNI_EXTRANJERO;
				if (DDTiposDocumentos.TARJETA_DIPLOMATICA.equals(tipoDocumento))
					tipoDoc = DtoClienteUrsus.TARJETA_DIPLOMATICA;
				if (DDTiposDocumentos.MENOR.equals(tipoDocumento))
					tipoDoc = DtoClienteUrsus.MENOR;
				if (DDTiposDocumentos.OTROS_PERSONA_FISICA.equals(tipoDocumento))
					tipoDoc = DtoClienteUrsus.OTROS_PERSONA_FISICA;
				if (DDTiposDocumentos.OTROS_PESONA_JURIDICA.equals(tipoDocumento))
					tipoDoc = DtoClienteUrsus.OTROS_PESONA_JURIDICA;
				if (DDTiposDocumentos.NIE.equals(tipoDocumento))
					tipoDoc = DtoClienteUrsus.NIE;
			}

			if (!Checks.esNulo(idExpediente) && !Checks.esNulo(tipoDoc)) {
				DDSubcartera subcarteraExpediente = getCodigoSubCarteraExpediente(Long.parseLong(idExpediente));
				if (!Checks.esNulo(subcarteraExpediente)
						&& DDSubcartera.CODIGO_BAN_BH.equals(subcarteraExpediente.getCodigo())) {
					lista = uvemManagerApi.ejecutarNumCliente(numeroDocumento, tipoDoc,
							DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA_HABITAT);
				} else {
					lista = uvemManagerApi.ejecutarNumCliente(numeroDocumento, tipoDoc,
							DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA);
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
			if (!Checks.esNulo(idExpediente) && !Checks.esNulo(numeroUrsus)) {
				Integer numURSUS = Integer.parseInt(numeroUrsus);
				DDSubcartera subcarteraExpediente = getCodigoSubCarteraExpediente(Long.parseLong(idExpediente));
				if (!Checks.esNulo(subcarteraExpediente)
						&& DDSubcartera.CODIGO_BAN_BH.equals(subcarteraExpediente.getCodigo())) {
					datosClienteDto = uvemManagerApi.ejecutarDatosCliente(numURSUS,
							DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA_HABITAT);
				} else {
					datosClienteDto = uvemManagerApi.ejecutarDatosCliente(numURSUS,
							DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA);
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
	public List<DatosClienteProblemasVentaDto> buscarProblemasVentaClienteUrsus(String numeroUrsus, String idExpediente)
			throws Exception {

		List<DatosClienteProblemasVentaDto> datosClienteProblemasVentaDto = new ArrayList<DatosClienteProblemasVentaDto>();

		try {
			if (!Checks.esNulo(numeroUrsus) && !numeroUrsus.equals("null")) {
				Integer numURSUS = Integer.parseInt(numeroUrsus);

				if (!Checks.esNulo(idExpediente)) {
					DDSubcartera subcarteraExpediente = getCodigoSubCarteraExpediente(Long.parseLong(idExpediente));
					if (!Checks.esNulo(subcarteraExpediente)
							&& DDSubcartera.CODIGO_BAN_BH.equals(subcarteraExpediente.getCodigo())) {
						datosClienteProblemasVentaDto = uvemManagerApi.ejecutarDatosClienteProblemasVenta(numURSUS,
								DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA_HABITAT);
					} else {
						datosClienteProblemasVentaDto = uvemManagerApi.ejecutarDatosClienteProblemasVenta(numURSUS,
								DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA);
					}
				}
			}

		} catch (NumberFormatException nfe) {
			logger.error("error en expedienteComercialManager", nfe);

		} catch (Exception e) {
			logger.error("error en expedienteComercialManager", e);
			throw e;
		}

		return datosClienteProblemasVentaDto;
	}

	@Override
	public Page getComboProveedoresExpediente(String codigoTipoProveedor, String nombreBusqueda, String idActivo,
			WebDto dto) {
		String codigoProvinciaActivo = null;
		List<Long> proveedoresIDporCartera = new ArrayList<Long>();

		if (!Checks.esNulo(idActivo)) {
			Activo activo = activoAdapter.getActivoById(Long.parseLong(idActivo));
			codigoProvinciaActivo = activo.getProvincia();

			if (!Checks.esNulo(activo.getCartera())) {
				Filter filtroEntidad = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo",
						activo.getCartera().getCodigo());
				List<EntidadProveedor> epList = genericDao.getList(EntidadProveedor.class, filtroEntidad);
				for (EntidadProveedor e : epList) {
					proveedoresIDporCartera.add(e.getProveedor().getId());
				}
			}
		}

		return expedienteComercialDao.getComboProveedoresExpediente(codigoTipoProveedor, nombreBusqueda,
				codigoProvinciaActivo, proveedoresIDporCartera, dto);
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createHonorario(DtoGastoExpediente dto, Long idEntidad) {
		ExpedienteComercial expediente = findOne(idEntidad);
		GastosExpediente gastoExpediente = new GastosExpediente();
		Long idActivo = expediente.getOferta().getActivoPrincipal().getId();

		if (!Checks.esNulo(dto.getCodigoTipoComision())) {
			Filter filtroAccionGasto = genericDao.createFilter(FilterType.EQUALS, "codigo",
					dto.getCodigoTipoComision());
			DDAccionGastos accionGastos = genericDao.get(DDAccionGastos.class, filtroAccionGasto);
			gastoExpediente.setAccionGastos(accionGastos);
		}

		if (!Checks.esNulo(dto.getCodigoTipoProveedor())) {
			Filter filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo",
					dto.getCodigoTipoProveedor());
			DDTipoProveedorHonorario tipoProveedor = genericDao.get(DDTipoProveedorHonorario.class,
					filtroTipoProveedor);
			gastoExpediente.setTipoProveedor(tipoProveedor);
		}

		if (!Checks.esNulo(dto.getCodigoProveedorRem())) {
			Date fechaHoy = new Date();
			Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
					dto.getCodigoProveedorRem());
			ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroProveedor);

			if (Checks.esNulo(proveedor) || Checks.esNulo(proveedor.getTipoProveedor())
					|| !proveedor.getTipoProveedor().getCodigo().equals(dto.getCodigoTipoProveedor())
					|| (!Checks.esNulo(proveedor.getFechaBaja()) && proveedor.getFechaBaja().before(fechaHoy))) {
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

		if(gastoExpediente.getExpediente() != null && gastoExpediente.getExpediente().getOferta() != null) {
			Oferta oferta = gastoExpediente.getExpediente().getOferta();
			
			// Si el honorario es menor de 100 € el valor final será, salvo si el importe es
			// fijo, de 100 €. HREOS-5149
			if (dto.getHonorarios() < 100.00 && DDTipoOferta.isTipoAlquiler(oferta.getTipoOferta())
					&& !DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO_ALQ.equals(dto.getCodigoTipoCalculo())
					&& !DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO.equals(dto.getCodigoTipoCalculo())) {
				gastoExpediente.setImporteFinal(100.00);
			} else {
				gastoExpediente.setImporteFinal(dto.getHonorarios());
			}
		}

		gastoExpediente.setObservaciones(dto.getObservaciones());
		gastoExpediente.setExpediente(expediente);
		gastoExpediente.setEditado(0);

		if(Checks.esNulo(dto.getIdActivo())){
			dto.setIdActivo(idActivo);
		}

		if (!Checks.esNulo(dto.getIdActivo())) {
			Activo activo = null;

			for (ActivoOferta activoOferta : expediente.getOferta().getActivosOferta()) {
				if (activoOferta.getPrimaryKey().getActivo().getId().equals(dto.getIdActivo())) {
					activo = activoOferta.getPrimaryKey().getActivo();
				}
			}
			gastoExpediente.setActivo(activo);
		}
		gastoExpediente.setEditado(1);
		genericDao.save(GastosExpediente.class, gastoExpediente);

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createHistoricoCondiciones(DtoHistoricoCondiciones dto, Long idEntidad) {
		ExpedienteComercial expediente = findOne(idEntidad);

		HistoricoCondicionanteExpediente hisCE = new HistoricoCondicionanteExpediente();

		if (!Checks.esNulo(dto)) {
			if (!Checks.esNulo(expediente)) {
				hisCE.setCondicionante(expediente.getCondicionante());
				hisCE.setFecha(dto.getFecha());
				hisCE.setIncrementoRenta(dto.getIncrementoRenta());
				Auditoria a = new Auditoria();
				Usuario usuario = genericAdapter.getUsuarioLogado();
				a.setUsuarioCrear(usuario.getUsername());
				a.setFechaCrear(new Date());
				hisCE.setAuditoria(a);
			}

		}
		genericDao.save(HistoricoCondicionanteExpediente.class, hisCE);
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

		Double importeTotal = oferta.getImporteContraOferta() == null ? oferta.getImporteOferta()
				: oferta.getImporteContraOferta();
		if (importeTotal != null) {
			ofertaUVEM.setImporteVenta(num.format(importeTotal));
		}

		// Siempre se enviará 00000 (Bankia) para el servicio de consulta del cobro de
		// la reserva y de la venta.
		ofertaUVEM.setEntidad("00000");

		if (condExp != null && condExp.getReservaConImpuesto() != null
				&& condExp.getReservaConImpuesto() == 1) {
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
	public ArrayList<TitularUVEMDto> obtenerListaTitularesUVEM(ExpedienteComercial expedienteComercial)
			throws Exception {
		ArrayList<TitularUVEMDto> listaTitularUVEM = new ArrayList<TitularUVEMDto>();
		TitularUVEMDto titularPrincipal = null;
		Comprador compradorPrincipal = expedienteComercial.getCompradorPrincipal();

		for (int k = 0; k < expedienteComercial.getCompradores().size(); k++) {
			CompradorExpediente compradorExpediente = expedienteComercial.getCompradores().get(k);
			TitularUVEMDto titularUVEM = new TitularUVEMDto();

			Activo activoPrincipal = expedienteComercial.getOferta().getActivoPrincipal();

			String codigoSubcartera = activoPrincipal.getSubcartera().getCodigo();

			// Si es Bankia Habitat
			if (DDSubcartera.CODIGO_BAN_BH.equals(codigoSubcartera)) {
				Long idCompradorUrsusBh = compradorExpediente.getPrimaryKey().getComprador().getIdCompradorUrsusBh();
				if (idCompradorUrsusBh != null) {
					titularUVEM.setCliente(idCompradorUrsusBh.toString());
				}

				if (compradorExpediente.getDocumentoConyuge() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento",
							compradorExpediente.getDocumentoConyuge());
					Filter filtro2 = genericDao.createFilter(FilterType.NOTNULL, "idCompradorUrsusBh");
					List<Comprador> conyuges = genericDao.getList(Comprador.class, filtro, filtro2);
					Comprador conyuge = null;
					if (conyuges != null && conyuges.size() > 0) {
						conyuge = conyuges.get(0);
					}
					if (conyuge != null && conyuge.getIdCompradorUrsus() != null) {
						titularUVEM.setConyuge(conyuge.getIdCompradorUrsusBh().toString());
					}
				}

				// Si no es Bankia Habitat
			} else {
				Long idCompradorUrsus = compradorExpediente.getPrimaryKey().getComprador().getIdCompradorUrsus();
				if (idCompradorUrsus != null) {
					titularUVEM.setCliente(idCompradorUrsus.toString());
				}

				if (compradorExpediente.getDocumentoConyuge() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento",
							compradorExpediente.getDocumentoConyuge());
					Filter filtro2 = genericDao.createFilter(FilterType.NOTNULL, "idCompradorUrsus");
					List<Comprador> conyuges = genericDao.getList(Comprador.class, filtro, filtro2);
					Comprador conyuge = null;
					if (conyuges != null && !conyuges.isEmpty()) {
						conyuge = conyuges.get(0);
					}
					if (conyuge != null && conyuge.getIdCompradorUrsus() != null) {
						titularUVEM.setConyuge(conyuge.getIdCompradorUrsus().toString());
					}
				}
			}

			if (compradorExpediente.getPorcionCompra() != null) {
				titularUVEM.setPorcentaje(compradorExpediente.getPorcionCompra().toString());
			}

			if (!compradorPrincipal.equals(compradorExpediente.getPrimaryKey().getComprador())) {
				listaTitularUVEM.add(titularUVEM);
			} else {
				titularPrincipal = titularUVEM;
			}
		}

		if (titularPrincipal != null)
			listaTitularUVEM.add(0, titularPrincipal);

		return listaTitularUVEM;
	}

	@Override
	public boolean checkCompradoresTienenNumeroUrsus(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);

		if (Checks.esNulo(activoTramite)) {
			return false;
		}

		if (!Checks.esNulo(activoTramite.getActivo())
				&& activoTramite.getActivo().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA)) {
			Trabajo trabajo = activoTramite.getTrabajo();
			if (Checks.esNulo(trabajo)) {
				return false;
			}

			ExpedienteComercial expedienteComercial = expedienteComercialDao
					.getExpedienteComercialByIdTrabajo(trabajo.getId());
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
			Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "primaryKey.expediente.id",
					idExpediente);
			Filter filtroComprador = genericDao.createFilter(FilterType.EQUALS, "primaryKey.comprador.id", idComprador);

			CompradorExpediente compradorExpediente = genericDao.get(CompradorExpediente.class, filtroExpediente,
					filtroComprador);

			if (!Checks.esNulo(compradorExpediente)) {
				if (!Checks.esNulo(compradorExpediente.getTitularContratacion()) && compradorExpediente.getTitularContratacion() == 0) {
					ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", idExpediente));
					this.deleteCompradorExpedienteSetBorrado(idExpediente, idComprador);
					if(expediente != null && expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null
							&& DDCartera.isCarteraBk(expediente.getOferta().getActivoPrincipal().getCartera())) {
						this.updateEstadoInterlocutorCompradores(expediente, compradorExpediente, DDEstadoInterlocutor.CODIGO_SOLICITUD_BAJA, false,null);
					}
					ofertaApi.resetPBC(expediente, true);
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

		Double importeOferta = null;

		importeOferta = !Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteContraOferta()
				: oferta.getImporteOferta();

		try {
			List<ActivoOferta> activosOferta = oferta.getActivosOferta();
			for (ActivoOferta activoOferta : activosOferta) {
				if (!Checks.esNulo(activoOferta.getPorcentajeParticipacion())) {
					activoOferta
							.setImporteActivoOferta((importeOferta * activoOferta.getPorcentajeParticipacion()) / 100);
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
				List<BloqueoActivoFormalizacion> bloqueos = genericDao.getList(BloqueoActivoFormalizacion.class,
						genericDao.createFilter(FilterType.EQUALS, "expediente.id",
								Long.parseLong(dto.getIdExpediente())),
						genericDao.createFilter(FilterType.EQUALS, "activo.id", Long.parseLong(dto.getId())));

				for (BloqueoActivoFormalizacion bloqueo : bloqueos) {
					DtoBloqueosFinalizacion bloqueoDto = new DtoBloqueosFinalizacion();

					try {
						beanUtilNotNull.copyProperty(bloqueoDto, "id", bloqueo.getId().toString());

						if (!Checks.esNulo(bloqueo.getActivo())) {
							beanUtilNotNull.copyProperty(bloqueoDto, "numActivo", bloqueo.getActivo().getNumActivo());
						}

						if (!Checks.esNulo(bloqueo.getArea())) {
							beanUtilNotNull.copyProperty(bloqueoDto, "areaBloqueoCodigo",
									bloqueo.getArea().getCodigo());
						}

						if (!Checks.esNulo(bloqueo.getTipo())) {
							beanUtilNotNull.copyProperty(bloqueoDto, "tipoBloqueoCodigo",
									bloqueo.getTipo().getCodigo());
						}

						if (!Checks.esNulo(bloqueo.getAuditoria())) {
							beanUtilNotNull.copyProperty(bloqueoDto, "fechaAlta",
									bloqueo.getAuditoria().getFechaCrear());
							beanUtilNotNull.copyProperty(bloqueoDto, "usuarioAlta",
									bloqueo.getAuditoria().getUsuarioCrear());
							beanUtilNotNull.copyProperty(bloqueoDto, "fechaBaja",
									bloqueo.getAuditoria().getFechaBorrar());
							beanUtilNotNull.copyProperty(bloqueoDto, "usuarioBaja",
									bloqueo.getAuditoria().getUsuarioBorrar());
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
			BloqueoActivoFormalizacion bloqueoExistente = genericDao.get(BloqueoActivoFormalizacion.class,
					genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo),
					genericDao.createFilter(FilterType.EQUALS, "expediente.id", Long.parseLong(dto.getIdExpediente())),
					genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),
					genericDao.createFilter(FilterType.EQUALS, "area.codigo", dto.getAreaBloqueoCodigo()),
					genericDao.createFilter(FilterType.EQUALS, "tipo.codigo", dto.getTipoBloqueoCodigo()),
					genericDao.createFilter(FilterType.EQUALS, "solucionarBloqueo", dto.getAcuerdoCodigo()));

			if (Checks.esNulo(bloqueoExistente)) {
				if (!Checks.esNulo(idActivo)) {
					Activo activo = genericDao.get(Activo.class,
							genericDao.createFilter(FilterType.EQUALS, "id", idActivo));
					if (!Checks.esNulo(activo)) {
						bloqueo.setActivo(activo);
					}
				}

				if (!Checks.esNulo(dto.getAreaBloqueoCodigo())) {
					DDAreaBloqueo area = (DDAreaBloqueo) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDAreaBloqueo.class, dto.getAreaBloqueoCodigo());
					if (!Checks.esNulo(area)) {
						bloqueo.setArea(area);
					}
				}

				if (!Checks.esNulo(dto.getTipoBloqueoCodigo())) {
					DDTipoBloqueo tipo = (DDTipoBloqueo) utilDiccionarioApi
							.dameValorDiccionarioByCod(DDTipoBloqueo.class, dto.getTipoBloqueoCodigo());
					if (!Checks.esNulo(tipo)) {
						bloqueo.setTipo(tipo);
					}
				}

				if (!Checks.esNulo(dto.getIdExpediente())) {
					ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class,
							genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdExpediente())));
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
			BloqueoActivoFormalizacion bloqueo = genericDao.get(BloqueoActivoFormalizacion.class,
					genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId())));
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
			BloqueoActivoFormalizacion bloqueo = genericDao.get(BloqueoActivoFormalizacion.class,
					genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId())));
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

				if (oferta != null && oferta.getEstadoOferta() != null
						&& DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
					ExpedienteComercial expediente = expedienteComercialPorOferta(oferta.getId());

					if (expediente != null && expediente.getEstado() != null
							&& !DDEstadosExpedienteComercial.EN_TRAMITACION.equals(expediente.getEstado().getCodigo())
							&& !DDEstadosExpedienteComercial.PTE_SANCION.equals(expediente.getEstado().getCodigo())
							&& !DDEstadosExpedienteComercial.CONTRAOFERTADO.equals(expediente.getEstado().getCodigo())
							&& !DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
							&& !DDEstadosExpedienteComercial.DENEGADO.equals(expediente.getEstado().getCodigo())
							&& !DDEstadosExpedienteComercial.ANULADO.equals(expediente.getEstado().getCodigo()))
						return expediente;
				}
			}
		}

		return null;
	}

	@Override
	@Transactional(readOnly = false)
	public Double obtencionDatosPrestamo(DtoObtencionDatosFinanciacion dto) throws Exception {
		try {
			ExpedienteComercial expediente = this.findOne(Long.parseLong(dto.getIdExpediente()));

			Formalizacion formalizacion = expediente.getFormalizacion();

			if (!Checks.esNulo(formalizacion)) {
				String numExpedienteRiesgo = dto.getNumExpediente();
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodTipoRiesgo());
				DDTipoRiesgoClase tipoRiesgo = genericDao.get(DDTipoRiesgoClase.class, filtro);

				if (!Checks.esNulo(numExpedienteRiesgo) && !Checks.esNulo(tipoRiesgo)) {
					Long capitalConcedido;
					capitalConcedido = uvemManagerApi.consultaDatosPrestamo(numExpedienteRiesgo,
							Integer.parseInt(tipoRiesgo.getCodigo()));

					if (!Checks.esNulo(capitalConcedido)) {

						return capitalConcedido.doubleValue() / 100;
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

		return null;
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

				DDSnsSiNoNosabe solicitaFinanciacion = condiciones.getSolicitaFinanciacion();
				dto.setSolicitaFinanciacion(!Checks.esNulo(solicitaFinanciacion) ? solicitaFinanciacion.getCodigo() : null);

				if (!Checks.esNulo(solicitaFinanciacion)) {
					if (solicitaFinanciacion.getCodigo().equals("01")) {
						if (!Checks.esNulo(condiciones.getEntidadFinanciera())) {
							dto.setEntidadFinancieraCodigo(condiciones.getEntidadFinanciera().getCodigo());
						}
						if (!Checks.esNulo(condiciones.getTipoFinanciacion())) {
							dto.setFinanciacionTPCodigo(condiciones.getTipoFinanciacion().getCodigo());
						}
					} else {
						dto.setEntidadFinancieraCodigo(null);
						dto.setFinanciacionTPCodigo(null);
					}
				}

				if (!Checks.esNulo(dto.getSolicitaFinanciacion()) && dto.getSolicitaFinanciacion().equals("01")
						&& Checks.esNulo(dto.getCapitalConcedido())) {
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
				
				if (condiciones.getOtraEntidadFinaciera() != null) {
					dto.setOtraEntidadFinanciera(condiciones.getOtraEntidadFinaciera());
				}

			}
			if (!Checks.esNulo(expediente.getFechaPosicionamientoPrevista())) {
				dto.setFechaPosicionamientoPrevista(expediente.getFechaPosicionamientoPrevista());
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
			if (Checks.esNulo(expediente.getCondicionante()))
				expediente.setCondicionante(new CondicionanteExpediente());
			CondicionanteExpediente condiciones = expediente.getCondicionante();
			Formalizacion formalizacion = expediente.getFormalizacion();
			DDEntidadFinanciera entidadFinancieraPrevia = condiciones.getEntidadFinanciera();

			if (!Checks.esNulo(condiciones)) {

				String solicitaFinanciacion = null;

				if (!Checks.esNulo(dto.getSolicitaFinanciacion())) {
					solicitaFinanciacion = dto.getSolicitaFinanciacion();
				} else if (!Checks.esNulo(condiciones.getSolicitaFinanciacion())) {
					solicitaFinanciacion = condiciones.getSolicitaFinanciacion().getCodigo();
				}

				if (!Checks.esNulo(solicitaFinanciacion)) {
					DDSnsSiNoNosabe sns = genericDao.get(DDSnsSiNoNosabe.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", solicitaFinanciacion));
					condiciones.setSolicitaFinanciacion(sns);
				}

				if (!Checks.esNulo(solicitaFinanciacion) && solicitaFinanciacion.equals("01")) {
					if (!Checks.esNulo(dto.getEntidadFinancieraCodigo())){
						DDEntidadFinanciera entidadFinanciera = (DDEntidadFinanciera) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDEntidadFinanciera.class, dto.getEntidadFinancieraCodigo());
						condiciones.setEntidadFinanciera(entidadFinanciera);
						DDTfnTipoFinanciacion tfn = genericDao.get(DDTfnTipoFinanciacion.class,
								genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getFinanciacionTPCodigo()));
						condiciones.setTipoFinanciacion(tfn);
						if(!Checks.esNulo(formalizacion))
						{
							if(Checks.esNulo(dto.getNumExpedienteRiesgo())) {
								formalizacion.setNumExpediente(null);
							}
							if(Checks.esNulo(dto.getTiposFinanciacionCodigo()) && Checks.esNulo(dto.getTiposFinanciacionCodigoBankia())) {
								formalizacion.setTipoRiesgoClase(null);
							}
						}
					}
				} else if (!Checks.esNulo(solicitaFinanciacion) && solicitaFinanciacion != "01") {
					condiciones.setEntidadFinanciera(null);
					condiciones.setTipoFinanciacion(null);
					if(!Checks.esNulo(formalizacion))
					{
						formalizacion.setNumExpediente(null);
						formalizacion.setTipoRiesgoClase(null);
					}
				}

				if (!Checks.esNulo(dto.getEstadosFinanciacion())
						|| !Checks.esNulo(dto.getEstadosFinanciacionBankia())) {
					if (!Checks.esNulo(dto.getEstadosFinanciacion())) {
						DDEstadoFinanciacion estadoFinanciacion = (DDEstadoFinanciacion) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDEstadoFinanciacion.class, dto.getEstadosFinanciacion());
						condiciones.setEstadoFinanciacion(estadoFinanciacion);
					}

					if (!Checks.esNulo(dto.getEstadosFinanciacionBankia())) {
						DDEstadoFinanciacion estadoFinanciacionBankia = (DDEstadoFinanciacion) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDEstadoFinanciacion.class,
										dto.getEstadosFinanciacionBankia());
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
				if (dto.getOtraEntidadFinanciera() != null) {
					condiciones.setOtraEntidadFinaciera(dto.getOtraEntidadFinanciera());
				}

				genericDao.save(CondicionanteExpediente.class, condiciones);
			}

			// Formalizacion

			if (!Checks.esNulo(formalizacion)) {
				if (!Checks.esNulo(dto.getNumExpedienteRiesgo())) {
					formalizacion.setNumExpediente(dto.getNumExpedienteRiesgo());
				}

				if (!Checks.esNulo(dto.getTiposFinanciacionCodigo())
						|| !Checks.esNulo(dto.getTiposFinanciacionCodigoBankia())) {
					if (!Checks.esNulo(dto.getTiposFinanciacionCodigo())) {
						DDTipoRiesgoClase tipoFinanciacion = (DDTipoRiesgoClase) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDTipoRiesgoClase.class, dto.getTiposFinanciacionCodigo());
						formalizacion.setTipoRiesgoClase(tipoFinanciacion);
					}

					if (!Checks.esNulo(dto.getTiposFinanciacionCodigoBankia())) {
						DDTipoRiesgoClase tipoFinanciacionBankia = (DDTipoRiesgoClase) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDTipoRiesgoClase.class,
										dto.getTiposFinanciacionCodigoBankia());
						formalizacion.setTipoRiesgoClase(tipoFinanciacionBankia);
					}
				}

				if (!Checks.esNulo(dto.getCapitalConcedido())) {
					formalizacion.setCapitalConcedido(dto.getCapitalConcedido());
				}

				if (!Checks.esNulo(dto.getSolicitaFinanciacion()) && dto.getSolicitaFinanciacion() != "01") {

					formalizacion.setCapitalConcedido(null);

				} else if (!Checks.esNulo(entidadFinancieraPrevia) && !Checks.esNulo(dto.getEntidadFinancieraCodigo())
						&& !entidadFinancieraPrevia.getCodigo().equals(dto.getEntidadFinancieraCodigo())
						&& !dto.getEntidadFinancieraCodigo().equals(DDEntidadFinanciera.ENTIDAD_FINANCIERA_BANKIA)) {
					formalizacion.setCapitalConcedido(null);
				}

				genericDao.save(Formalizacion.class, formalizacion);
			}

			if (!Checks.esNulo(dto.getFechaPosicionamientoPrevista())) {
				expediente.setFechaPosicionamientoPrevista(dto.getFechaPosicionamientoPrevista());
			}

			genericDao.save(ExpedienteComercial.class, expediente);
		}

		return true;
	}

	@Override
	public List<DtoUsuario> getComboUsuarios(Long idTipoGestor) {
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

		List<GestorEntidadHistorico> gestoresEntidad = gestorExpedienteApi
				.getListGestoresAdicionalesHistoricoData(gestorEntidadDto);

		List<DtoListadoGestores> listadoGestoresDto = new ArrayList<DtoListadoGestores>();

		for (GestorEntidadHistorico gestor : gestoresEntidad) {
			DtoListadoGestores dtoGestor = new DtoListadoGestores();

			try {
				BeanUtils.copyProperties(dtoGestor, gestor);
				BeanUtils.copyProperties(dtoGestor, gestor.getUsuario());
				BeanUtils.copyProperties(dtoGestor, gestor.getTipoGestor());
				BeanUtils.copyProperty(dtoGestor, "id", gestor.getId());

				GestorSustituto gestorSustituto = getGestorSustitutoVigente(gestor);

				if (gestorSustituto != null) {
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

	@SuppressWarnings("unchecked")
	@Override
	public List<EXTDDTipoGestor> getComboTipoGestor(Long idExpediente) {

		List<Object> gestoresAincluir = new LinkedList<Object>();

		ExpedienteComercial eco = expedienteComercialDao.get(idExpediente);
		if (!Checks.esNulo(eco) && !Checks.esNulo(eco.getOferta())
				&& DDTipoOferta.CODIGO_ALQUILER.equals(eco.getOferta().getTipoOferta().getCodigo())) {
			gestoresAincluir = new LinkedList<Object>(Arrays.asList(gestorExpedienteApi.getCodigosTipoGestorExpedienteComercialAlquiler()));
		} else {
			gestoresAincluir = new LinkedList<Object>(Arrays.asList(gestorExpedienteApi.getCodigosTipoGestorExpedienteComercial()));
			if(!DDCartera.CODIGO_CARTERA_BANKIA.equals(eco.getOferta().getActivoPrincipal().getCartera().getCodigo())) {
				gestoresAincluir.remove(GestorExpedienteComercialApi.CODIGO_GESTOR_COMERCIAL_ALQUILER);
				
			}
		}
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		List<EXTDDTipoGestor> listAllTiposGestor = genericDao.getListOrdered(EXTDDTipoGestor.class, order,
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		List<EXTDDTipoGestor> listTiposGestor = new ArrayList<EXTDDTipoGestor>();

		if (!Checks.estaVacio(listAllTiposGestor)) {
			for (EXTDDTipoGestor tipoGestor : listAllTiposGestor) {
				if (gestoresAincluir.contains(tipoGestor.getCodigo()))
					listTiposGestor.add(tipoGestor);
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

				if (!Checks.esNulo(oferta.getEstadoOferta())
						&& DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
					ExpedienteComercial expediente = this.expedienteComercialPorOferta(oferta.getId());

					if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getTrabajo())) {
						List<ActivoTramite> listaTramites = activoTramiteApi
								.getTramitesActivoTrabajoList(expediente.getTrabajo().getId());

						for (ActivoTramite tramite : listaTramites) {
							List<TareaProcedimiento> tareasActivas = activoTramiteApi
									.getTareasActivasByIdTramite(tramite.getId());

							if (!Checks.esNulo(tareasActivas))
								return true;
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

				if (!Checks.esNulo(oferta.getEstadoOferta())
						&& DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())) {
					return this.expedienteComercialPorOferta(oferta.getId());
				}
			}
		}

		return null;
	}

	@Override
	@Transactional(readOnly = false)
	public List<GastosExpediente> creaGastoExpediente(ExpedienteComercial expediente, Oferta oferta, Activo activo)
			throws IllegalAccessException, InvocationTargetException {

		List<GastosExpediente> listaGastos = new ArrayList<GastosExpediente>();

		List<DtoGastoExpediente> listDtoGastoExpediente = ofertaApi.calculaHonorario(oferta, activo,false);

		for (DtoGastoExpediente dtoGastoExpediente : listDtoGastoExpediente) {
			GastosExpediente gastoExpediente = new GastosExpediente();

			if (!Checks.esNulo(dtoGastoExpediente.getCodigoTipoComision())) {
				DDAccionGastos acciongasto = (DDAccionGastos) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDAccionGastos.class, dtoGastoExpediente.getCodigoTipoComision());

				if (!Checks.esNulo(acciongasto)) {
					gastoExpediente.setAccionGastos(acciongasto);
				}
			}

			if (!Checks.esNulo(dtoGastoExpediente.getCodigoTipoCalculo())) {
				DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoCalculo.class, dtoGastoExpediente.getCodigoTipoCalculo());
				gastoExpediente.setTipoCalculo(tipoCalculo);
			}

			if (!Checks.esNulo(dtoGastoExpediente.getIdProveedor())) {
				Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
						dtoGastoExpediente.getIdProveedor());
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroProveedor);
				gastoExpediente.setProveedor(proveedor);

				DDTipoProveedorHonorario tipoProveedor = null;

				if (!Checks.esNulo(proveedor) && !Checks.esNulo(proveedor.getTipoProveedor())) {
					if (proveedor.getTipoProveedor().getCodigo().equals(DDTipoProveedorHonorario.CODIGO_MEDIADOR)) {
						tipoProveedor = (DDTipoProveedorHonorario) utilDiccionarioApi.dameValorDiccionarioByCod(
								DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_MEDIADOR);
					} else if (proveedor.getTipoProveedor().getCodigo().equals(DDTipoProveedorHonorario.CODIGO_FVD)) {
						tipoProveedor = (DDTipoProveedorHonorario) utilDiccionarioApi.dameValorDiccionarioByCod(
								DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_FVD);
					} else if (proveedor.getTipoProveedor().getCodigo()
							.equals(DDTipoProveedorHonorario.CODIGO_OFICINA_BANKIA)) {
						tipoProveedor = (DDTipoProveedorHonorario) utilDiccionarioApi.dameValorDiccionarioByCod(
								DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_OFICINA_BANKIA);
					} else if (proveedor.getTipoProveedor().getCodigo()
							.equals(DDTipoProveedorHonorario.CODIGO_OFICINA_CAJAMAR)) {
						tipoProveedor = (DDTipoProveedorHonorario) utilDiccionarioApi.dameValorDiccionarioByCod(
								DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_OFICINA_CAJAMAR);
					}

					gastoExpediente.setTipoProveedor(tipoProveedor);
				}
			}

			gastoExpediente.setImporteCalculo(dtoGastoExpediente.getImporteCalculo());
			// Si el honorario es menor de 100 € el valor final será, salvo si el importe es
			// fijo, de 100 €. HREOS-5149
			
				
			if (dtoGastoExpediente.getHonorarios() < 100.00 && DDTipoOferta.isTipoAlquiler(oferta.getTipoOferta())
					&& !DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO_ALQ.equals(dtoGastoExpediente.getCodigoTipoCalculo())
					&& !DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO.equals(dtoGastoExpediente.getCodigoTipoCalculo())) {
				gastoExpediente.setImporteFinal(100.00);
			} else {
				gastoExpediente.setImporteFinal(dtoGastoExpediente.getHonorarios());
			}
			gastoExpediente.setImporteOriginal(dtoGastoExpediente.getImporteOriginal());
			gastoExpediente.setExpediente(expediente);
			gastoExpediente.setActivo(activo);
			gastoExpediente.setEditado(0);

			gastoExpediente = genericDao.save(GastosExpediente.class, gastoExpediente);

			listaGastos.add(gastoExpediente);
		}

		return listaGastos;
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

			listaActivos.add(dto);
		}

		return listaActivos;
	}

	@Transactional()
	@Override
	public void actualizarImporteReservaPorExpediente(ExpedienteComercial expediente) {
		// Si el expediente tiene reserva.
		if (!Checks.esNulo(expediente.getReserva())) {
			// El cálculo de reserva es del tipo porcentaje.
			CondicionanteExpediente condicionanteExpediente = expediente.getCondicionante();

			if (!Checks.esNulo(condicionanteExpediente)
					&& !Checks.esNulo(condicionanteExpediente.getTipoCalculoReserva()) && condicionanteExpediente
							.getTipoCalculoReserva().getCodigo().equals(DDTipoCalculo.TIPO_CALCULO_PORCENTAJE)) {
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
	public boolean checkContabilizacionReserva(TareaExterna tareaExterna) {

		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		boolean contabilizacionReserva;

		if (!Checks.esNulo(expedienteComercial.getCondicionante())
				&& !Checks.esNulo(expedienteComercial.getCondicionante().getSolicitaReserva())
				&& !Checks.esNulo(expedienteComercial.getCondicionante().getSolicitaReserva() == 1)
				&& DDEstadosReserva.CODIGO_FIRMADA
						.equals(expedienteComercial.getReserva().getEstadoReserva().getCodigo())) {
			if (!Checks.esNulo(expedienteComercial.getReserva())
					&& !Checks.esNulo(expedienteComercial.getReserva().getFechaContabilizacionReserva())) {
				contabilizacionReserva = true;
			} else {
				contabilizacionReserva = false;
			}
		} else {
			contabilizacionReserva = true;
		}

		return contabilizacionReserva;
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
			if (TAR_INFORME_JURIDICO.equals(tareaNotificacion.getTarea())) {
				if (tareaNotificacion.getTareaFinalizada()) {
					informeJuridicoFinalizado = true;
				}
				tieneTareaInformeJuridico = true;
			}
		}

		if (informeJuridicoFinalizado || !tieneTareaInformeJuridico) {
			return true;
		} else {
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

		Double importeExpediente = oferta.getImporteContraOferta() != null ? oferta.getImporteContraOferta()
				: oferta.getImporteOferta();
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
		// Filter
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta", id);

		// Declarar lista + genericDao.getList
		List<VActivoOfertaImporte> listaActOfrImp = genericDao.getList(VActivoOfertaImporte.class, filtro);

		return listaActOfrImp;
	}

	public DtoCondicionesActivoExpediente getCondicionesActivoExpediete(Long idExpediente, Long idActivo) {

		DDTipoTituloActivoTPA tipoTitulo;

		Filter tituloActivo;
		Activo activo = activoAdapter.getActivoById(idActivo);

		tituloActivo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoTituloActivoTPA.tipoTituloNo);
		tipoTitulo = genericDao.get(DDTipoTituloActivoTPA.class, tituloActivo);

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

			if (Checks.esNulo(activo.getSituacionPosesoria().getOcupado()))
				activo.getSituacionPosesoria().setOcupado(0);
			if (Checks.esNulo(activo.getSituacionPosesoria().getConTitulo()))
				activo.getSituacionPosesoria().setConTitulo(tipoTitulo);

			if (activo.getSituacionPosesoria().getOcupado() != null
					&& activo.getSituacionPosesoria().getOcupado().equals(Integer.valueOf(0))) {
				resultado.setSituacionPosesoriaCodigoInformada("01");

			} else if (!Checks.esNulo(activo.getSituacionPosesoria().getOcupado())
					&& activo.getSituacionPosesoria().getOcupado().equals(1)
					&& !Checks.esNulo(activo.getSituacionPosesoria().getConTitulo()) && activo.getSituacionPosesoria()
							.getConTitulo().getCodigo().equals(DDTipoTituloActivoTPA.tipoTituloSi)) {
				resultado.setSituacionPosesoriaCodigoInformada("02");

			} else if (!Checks.esNulo(activo.getSituacionPosesoria().getOcupado())
					&& activo.getSituacionPosesoria().getOcupado().equals(1)
					&& !Checks.esNulo(activo.getSituacionPosesoria().getConTitulo())
					&& (activo.getSituacionPosesoria().getConTitulo().getCodigo()
							.equals(DDTipoTituloActivoTPA.tipoTituloNo)
							|| activo.getSituacionPosesoria().getConTitulo().getCodigo()
									.equals(DDTipoTituloActivoTPA.tipoTituloNoConIndicios))) {
				resultado.setSituacionPosesoriaCodigoInformada("03");
			}
		}

		// informada al comprador
		// Si las condiciones al comprador no están informadas en cartera CAJAMAR, estas
		// se copian del activo.
		CondicionesActivo condicionesActivo = genericDao.get(CondicionesActivo.class,
				genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo),
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
	public boolean guardarCondicionesActivosExpediente(DtoCondicionesActivoExpediente condiciones) {
		if (!Checks.esNulo(condiciones.getActivos())) {
			String[] idsActivos = condiciones.getActivos().split(",");

			for (String idActivo : idsActivos) {
				condiciones.setIdActivo(Long.valueOf(idActivo));
				guardarCondicionesActivoExpediente(condiciones);
			}
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean guardarCondicionesActivoExpediente(DtoCondicionesActivoExpediente condiciones) {
		boolean altaNueva = false;
		Activo activo = activoAdapter.getActivoById(condiciones.getIdActivo());
		ExpedienteComercial expediente = this.findOne(condiciones.getEcoId());
		CondicionesActivo condicionesActivo = genericDao.get(CondicionesActivo.class,
				genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()),
				genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId()));

		if (condicionesActivo == null) {
			condicionesActivo = new CondicionesActivo();
			condicionesActivo.setActivo(activo);
			condicionesActivo.setExpediente(expediente);
			altaNueva = true;
		}

		if (!Checks.esNulo(condiciones.getEstadoTitulo())) {
			DDEstadoTitulo estadoTitulo = genericDao.get(DDEstadoTitulo.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", condiciones.getEstadoTitulo()));

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
			DDSituacionesPosesoria situacionPosesoria = genericDao.get(DDSituacionesPosesoria.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", condiciones.getSituacionPosesoriaCodigo()));

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

		if (tanteoActivoDto.getId() == null || tanteoActivoDto.getId().isEmpty()
				|| !StringUtils.isNumeric(tanteoActivoDto.getId())) {
			tanteoActivo = new TanteoActivoExpediente();
			tanteoActivo.setExpediente(this.findOne(tanteoActivoDto.getEcoId()));
			tanteoActivo.setActivo(activoAdapter.getActivoById(tanteoActivoDto.getIdActivo()));

			if (Checks.esNulo(tanteoActivoDto.getCondicionesTransmision())) {
				tanteoActivo.setCondicionesTx(
						"Comprador asume la situación física, jurídica, registral, urbanística y administrativa existente");
			}

		} else {
			tanteoActivo = genericDao.get(TanteoActivoExpediente.class,
					genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(tanteoActivoDto.getId())));
		}

		if (!Checks.esNulo(tanteoActivoDto.getCondicionesTransmision())) {
			tanteoActivo.setCondicionesTx(tanteoActivoDto.getCondicionesTransmision());
		}

		if (!Checks.esNulo(tanteoActivoDto.getCodigoTipoAdministracion())) {
			DDAdministracion administracion = genericDao.get(DDAdministracion.class, genericDao
					.createFilter(FilterType.EQUALS, "codigo", tanteoActivoDto.getCodigoTipoAdministracion()));
			if (!Checks.esNulo(administracion)) {
				tanteoActivo.setAdminitracion(administracion);
			}
		}

		if (!Checks.esNulo(tanteoActivoDto.getFechaComunicacion())
				&& tanteoActivoDto.getFechaComunicacion().getTime() > 0) {
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
			DDResultadoTanteo resultadoTanteo = genericDao.get(DDResultadoTanteo.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", tanteoActivoDto.getCodigoTipoResolucion()));

			if (!Checks.esNulo(resultadoTanteo)) {
				tanteoActivo.setResultadoTanteo(resultadoTanteo);
				actualizarFVencimientoReservaTanteosRenunciados(tanteoActivo, null);
			}
		}

		if (!Checks.esNulo(tanteoActivoDto.getFechaVencimiento())
				&& tanteoActivoDto.getFechaVencimiento().getTime() > 0) {
			tanteoActivo.setFechaVencimientoResol(tanteoActivoDto.getFechaVencimiento());
		}

		if (!Checks.esNulo(tanteoActivoDto.getFechaResolucion())
				&& tanteoActivoDto.getFechaResolucion().getTime() > 0) {
			tanteoActivo.setFechaResolucion(tanteoActivoDto.getFechaResolucion());
		}

		Calendar cal;
		if (!Checks.esNulo(tanteoActivoDto.getFechaRespuesta()) && tanteoActivoDto.getFechaRespuesta().getTime() > 0
				&& !Checks.esNulo(tanteoActivoDto.getFechaVisita()) && tanteoActivoDto.getFechaVisita().getTime() > 0) {
			if (!Checks.esNulo(tanteoActivoDto.getSolicitaVisitaCodigo())
					&& tanteoActivoDto.getSolicitaVisitaCodigo().equals(1)) {
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
					long diferencia = tanteoActivoDto.getFechaVisita().getTime()
							- tanteoActivoDto.getFechaRespuesta().getTime();
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

		if (tanteoActivo != null) {
			if (tanteoActivo.getResultadoTanteo() != null
					&& DDResultadoTanteo.CODIGO_RENUNCIADO.equals(tanteoActivo.getResultadoTanteo().getCodigo())) {
				if (tanteoActivo.getExpediente() != null && tanteoActivo.getExpediente().getCondicionante() != null
						&& (Integer.valueOf(1)
								.equals(tanteoActivo.getExpediente().getCondicionante().getSujetoTanteoRetracto()))) {
					List<TanteoActivoExpediente> tanteosExpediente = tanteoActivo.getExpediente()
							.getTanteoActivoExpediente();
					if (tanteosExpediente != null && !tanteosExpediente.isEmpty()) {
						fechaResolucionMayor = tanteosExpediente.get(0).getFechaResolucion();
					}

					for (TanteoActivoExpediente tanteo : tanteosExpediente) {
						activo = tanteo.getActivo();
						if (tanteo.getResultadoTanteo() != null) {
							if (!DDResultadoTanteo.CODIGO_RENUNCIADO.equals(tanteo.getResultadoTanteo().getCodigo())) {
								todosRenunciados = false;
								break;
							}

						} else {
							todosRenunciados = false;
							break;
						}

						Date fechaResolucion = tanteo.getFechaResolucion();
						if (fechaResolucionMayor != null && fechaResolucion != null
								&& fechaResolucion.after(fechaResolucionMayor)) {
							fechaResolucionMayor = fechaResolucion;
						}
					}

					if (todosRenunciados && fechaResolucionMayor != null) {
						Calendar calendar = Calendar.getInstance();
						calendar.setTime(fechaResolucionMayor);
						if (activo != null
								&& DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo())) {
							calendar.add(Calendar.DAY_OF_YEAR, NUMERO_DIAS_VENCIMIENTO_SAREB);
						} else {
							calendar.add(Calendar.DAY_OF_YEAR, NUMERO_DIAS_VENCIMIENTO);
						}
						this.actualizaFechaVencimientoReserva(tanteoActivo.getExpediente().getReserva(),
								calendar.getTime());

					} else {
						this.actualizaFechaVencimientoReserva(tanteoActivo.getExpediente().getReserva(), null);
					}
				}

			} else {
				this.actualizaFechaVencimientoReserva(tanteoActivo.getExpediente().getReserva(), null);
			}

		} else if (tanteosActivo != null && !tanteosActivo.isEmpty()) {
			fechaResolucionMayor = tanteosActivo.get(0).getFechaResolucion();

			for (TanteoActivoExpediente tanteo : tanteosActivo) {
				activo = tanteo.getActivo();
				if (tanteo.getResultadoTanteo() != null) {
					if (!DDResultadoTanteo.CODIGO_RENUNCIADO.equals(tanteo.getResultadoTanteo().getCodigo())) {
						todosRenunciados = false;
						break;
					}

				} else {
					todosRenunciados = false;
					break;
				}

				Date fechaResolucion = tanteo.getFechaResolucion();
				if (fechaResolucionMayor != null && fechaResolucion != null
						&& fechaResolucion.after(fechaResolucionMayor)) {
					fechaResolucionMayor = fechaResolucion;
				}
			}

			if (todosRenunciados && fechaResolucionMayor != null) {
				ExpedienteComercial expediente = tanteosActivo.get(0).getExpediente();
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(fechaResolucionMayor);
				if (activo != null && activo.getCartera() != null && DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo())) {
					calendar.add(Calendar.DAY_OF_YEAR, NUMERO_DIAS_VENCIMIENTO_SAREB);
				} else {
					calendar.add(Calendar.DAY_OF_YEAR, NUMERO_DIAS_VENCIMIENTO);
				}
				this.actualizaFechaVencimientoReserva(expediente.getReserva(), calendar.getTime());
			}

		}
	}

	/**
	 * Este método actualiza la fecha de vencimiento de la reserva si la reserva no
	 * es nula.
	 *
	 * @param reserva:          entidad reserva.
	 * @param fechaVencimiento: fecha a actualizar en el campo fecha de vencimiento
	 *                          de la reserva.
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
		TanteoActivoExpediente tanteo = genericDao.get(TanteoActivoExpediente.class,
				genericDao.createFilter(FilterType.EQUALS, "id", idTanteo));

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

			Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "expediente.id",
					informeJuridico.getExpedienteComercial().getId());
			Filter filtro4 = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
			List<BloqueoActivoFormalizacion> bloqueos = genericDao.getList(BloqueoActivoFormalizacion.class, filtro3,
					filtro4);

			if (!Checks.esNulo(informeJuridico.getFechaEmision())) {
				// No calcular el estado del informe hasta que se haya introducido fecha de
				// emisión.
				dto.setResultadoBloqueo(InformeJuridico.RESULTADO_FAVORABLE);

				if (!Checks.estaVacio(bloqueos)) {
					for (BloqueoActivoFormalizacion bloqueo : bloqueos) {
						if (Checks.esNulo(bloqueo.getAuditoria().getUsuarioBorrar()))
							dto.setResultadoBloqueo(InformeJuridico.RESULTADO_DESFAVORABLE);

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
		InformeJuridico inJu = genericDao.get(InformeJuridico.class,
				genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", dto.getIdExpediente()),
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

	
	@Transactional(readOnly = false)
	public String validaBloqueoExpediente(Long idExpediente) {
		String codigoError = "";

		ExpedienteComercial expediente = this.findOne(idExpediente);

		// Validamos condiciones jurídicas.
		if (expediente.getEstadoPbc() == null || expediente.getEstadoPbc().equals(0)
				|| expediente.getRiesgoReputacional() == null
				|| expediente.getRiesgoReputacional().equals(Integer.valueOf(1))
				|| expediente.getConflictoIntereses() == null || expediente.getConflictoIntereses().equals(1)) {
			codigoError = "imposible.bloquear.responsabilidad.corporativa";

		} else if (DDCartera.CODIGO_CARTERA_BANKIA
				.equals(expediente.getOferta().getActivoPrincipal().getCartera().getCodigo())
				&& hayDiscrepanciasClientesURSUS(idExpediente)) {
			// Si es Bankia, validamos las discrepancias de los compradores, si las hay, no
			// se puede bloquear
			codigoError = "no.bloqueo.validar.compradores";
		} else {
			// Validamos los bloqueos
			List<ActivoOferta> activosExpediente = expediente.getOferta().getActivosOferta();
			boolean bloqueoVigente = false;

			for (ActivoOferta activoOferta : activosExpediente) {
				Activo activo = activoOferta.getPrimaryKey().getActivo();
				DtoInformeJuridico dtoInfoJuridico = this.getFechaEmisionInfJuridico(idExpediente, activo.getId());

				if (dtoInfoJuridico != null && dtoInfoJuridico.getResultadoBloqueo() != null
						&& dtoInfoJuridico.getResultadoBloqueo().equals(InformeJuridico.RESULTADO_DESFAVORABLE)) {
					bloqueoVigente = true;
					break;
				}
			}
			if (bloqueoVigente) {
				codigoError = "imposible.bloquear.bloqueo.vigente";
			} else {
				// validamos fecha posicionamiento
				if (expediente.getPosicionamientos() == null || expediente.getPosicionamientos().size() < 1) {
					codigoError = "imposible.bloquear.fecha.posicionamiento";
				} else {
					// el usuario logado tiene que ser gestoria
					Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

					if (DDCartera.CODIGO_CARTERA_CAJAMAR
							.equals(expediente.getOferta().getActivoPrincipal().getCartera().getCodigo())) {
						if (!genericAdapter.tienePerfil(PERFIL_GESTOR_MINUTAS, usuarioLogado)
								&& !genericAdapter.tienePerfil(PERFIL_SUPERVISOR_MINUTAS, usuarioLogado)
								&& !genericAdapter.isSuper(usuarioLogado)
								&& !genericAdapter.tienePerfil(PERFIL_GESTOR_FORMALIZACION, usuarioLogado)
								&& !genericAdapter.tienePerfil(PERFIL_GESTORIA_FORMALIZACION, usuarioLogado)) {
							codigoError = "imposible.bloquear.expediente.cajamar";

						} else {
							// la financiación tiene que estar informada
							DtoFormalizacionFinanciacion financiacion = new DtoFormalizacionFinanciacion();
							financiacion.setId(String.valueOf(idExpediente));
							financiacion = this.getFormalizacionFinanciacion(financiacion);
							if (Checks.esNulo(financiacion.getSolicitaFinanciacion())) {
								codigoError = "imposible.bloquear.financiacion.no.informada";
							} else {
								if (!Checks.esNulo(financiacion.getSolicitaFinanciacion()) 
										&& financiacion.getSolicitaFinanciacion().equals("01")
										&& Checks.esNulo(financiacion.getEntidadFinancieraCodigo())) {
									codigoError = "imposible.bloquear.entidad.financiera.no.informada";
								}
							}
						}

					} else {
						if (!genericAdapter.isGestoria(usuarioLogado) && !genericAdapter.isSuper(usuarioLogado)
								&& !genericAdapter.tienePerfil(PERFIL_GESTOR_FORMALIZACION, usuarioLogado)
								&& !genericAdapter.tienePerfil(PERFIL_SUPERVISOR_FORMALIZACION, usuarioLogado)) {
							codigoError = "imposible.bloquear.no.es.gestoria";

						} else {
							// la financiación tiene que estar informada
							DtoFormalizacionFinanciacion financiacion = new DtoFormalizacionFinanciacion();
							financiacion.setId(String.valueOf(idExpediente));
							financiacion = this.getFormalizacionFinanciacion(financiacion);
							if (Checks.esNulo(financiacion.getSolicitaFinanciacion())) {
								codigoError = "imposible.bloquear.financiacion.no.informada";
							} else {
								if (!Checks.esNulo(financiacion.getSolicitaFinanciacion()) 
										&& financiacion.getSolicitaFinanciacion().equals("01")
										&& Checks.esNulo(financiacion.getEntidadFinancieraCodigo())) {
									codigoError = "imposible.bloquear.entidad.financiera.no.informada";
								}
							}
						}
					}
				}
			}
		}

		return codigoError;
	}

	
	@Transactional(readOnly = false)
	public void bloquearExpediente(Long idExpediente) {
		try {
			ExpedienteComercial expediente = this.findOne(idExpediente);
			
			this.guardarBloqueoExpediente(expediente);
			this.sendMailBloqueoExpediente(expediente);

		} catch (Exception e) {
			logger.error("No se ha podido notificar por correo el bloqueo del expediente", e);
		}
	}

	
	public String validaDesbloqueoExpediente(Long idExpediente) {
		String codigoError = "";
		ExpedienteComercial expediente = this.findOne(idExpediente);

		if (expediente.getEstado() != null
				&& expediente.getEstado().getCodigo().equals(DDEstadosExpedienteComercial.VENDIDO)) {
			codigoError = "imposible.desbloquear.vendido";
		}

		return codigoError;
	}

	
	@Transactional(readOnly = false)
	public void desbloquearExpediente(Long idExpediente, String motivoCodigo, String motivoDescLibre) {	
		try {
			ExpedienteComercial expediente = this.findOne(idExpediente);
			this.guardarDesbloqueoExpediente(expediente, motivoCodigo, motivoDescLibre);

			this.sendMailDesbloqueoExpediente(expediente);

		} catch (Exception e) {
			logger.error("No se ha podido notificar por correo el desbloqueo del expediente", e);
		}
	}
	

	/**
	 * Este método obtiene la dirección de email de diferentes figuras del
	 * expediente.
	 *
	 * @param expediente: entidad expediente.
	 * @return Devuelve una lista de direcciones de correo.
	 */
	private ArrayList<String> obtnerEmailsBloqueoExpediente(ExpedienteComercial expediente) {
		ArrayList<String> mailsPara = new ArrayList<String>();

		if (expediente.getOferta() != null && expediente.getOferta().getPrescriptor() != null
				&& expediente.getOferta().getPrescriptor().getEmail() != null) {
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
			Usuario gestorActivoBackoffice = gestorActivoApi.getGestorByActivoYTipo(
					expediente.getOferta().getActivoPrincipal(), GestorActivoApi.CODIGO_GESTOR_BACKOFFICE);

			if (gestorActivoBackoffice != null && gestorActivoBackoffice.getEmail() != null) {
				mailsPara.add(gestorActivoBackoffice.getEmail());
			}
		}

		return mailsPara;
	}

	private ArrayList<String> obtenerEmailsEnviarComercializadora(ExpedienteComercial expediente) {
		ArrayList<String> mailsParaEnviarComercializadora = new ArrayList<String>();
		if (expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null) {
			Usuario gestorActivoGestorAlquileres = gestorActivoApi.getGestorByActivoYTipo(
					expediente.getOferta().getActivoPrincipal(), GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES);
			if (gestorActivoGestorAlquileres != null && gestorActivoGestorAlquileres.getEmail() != null) {
				mailsParaEnviarComercializadora.add(gestorActivoGestorAlquileres.getEmail());
			}
		}
		if (expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null) {
			Usuario gestorActivoSupervisorAlquileres = gestorActivoApi.getGestorByActivoYTipo(
					expediente.getOferta().getActivoPrincipal(),
					GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_ALQUILERES);
			if (gestorActivoSupervisorAlquileres != null && gestorActivoSupervisorAlquileres.getEmail() != null) {
				mailsParaEnviarComercializadora.add(gestorActivoSupervisorAlquileres.getEmail());
			}
		}
		if (expediente.getOferta() != null && expediente.getOferta().getPrescriptor() != null
				&& expediente.getOferta().getPrescriptor().getEmail() != null) {
			mailsParaEnviarComercializadora.add(expediente.getOferta().getPrescriptor().getEmail());
		}
		return mailsParaEnviarComercializadora;

	}
	
	@Override
	public boolean checkExpedienteBloqueado(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);
		
		if (!Checks.esNulo(activoTramite)) {
			Trabajo trabajo = activoTramite.getTrabajo();

			if (!Checks.esNulo(trabajo)) {
				ExpedienteComercial expediente = expedienteComercialDao
						.getExpedienteComercialByIdTrabajo(trabajo.getId());
				return (new Integer(1).equals(expediente.getBloqueado()));
			}
		}

		return false;
	}

	@Override
	public boolean checkExpedienteFechaChequeLiberbank(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);
		if (!Checks.esNulo(activoTramite) && !Checks.esNulo(activoTramite.getActivo())
				&& !Checks.esNulo(activoTramite.getActivo().getCartera())
				&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activoTramite.getActivo().getCartera().getCodigo())) {
			Trabajo trabajo = activoTramite.getTrabajo();
			if (!Checks.esNulo(trabajo)) {
				ExpedienteComercial expediente = expedienteComercialDao
						.getExpedienteComercialByIdTrabajo(trabajo.getId());
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
						&& !Checks.esNulo(expediente.getReserva().getEstadoReserva())) {
					return expediente.getReserva().getEstadoReserva().getCodigo()
							.equals(DDEstadosReserva.CODIGO_FIRMADA);
				}
			}
		}
		return false;
	}

	public boolean esMayorista(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);
		if (!Checks.esNulo(activoTramite)) {
			Trabajo trabajo = activoTramite.getTrabajo();
			if (!Checks.esNulo(trabajo)) {
				ExpedienteComercial expediente = expedienteComercialDao
						.getExpedienteComercialByTrabajo(trabajo.getId());
				if (!Checks.esNulo(expediente)) {
					return true;
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

				PerimetroActivo pac = genericDao.get(PerimetroActivo.class,
						genericDao.createFilter(FilterType.EQUALS, "activo", activo));
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
				ExpedienteComercial expediente = expedienteComercialDao
						.getExpedienteComercialByIdTrabajo(trabajo.getId());

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
				ExpedienteComercial expediente = expedienteComercialDao
						.getExpedienteComercialByIdTrabajo(trabajo.getId());

				if (!Checks.esNulo(expediente)) {
					Oferta oferta = expediente.getOferta();

					if (!Checks.esNulo(oferta)) {
						Double importeExpediente = oferta.getImporteContraOferta() != null
								? oferta.getImporteContraOferta()
								: oferta.getImporteOferta();
						List<Activo> activos = activoTramite.getActivos();
						Double precioMinimo = 0.00D;

						if (!Checks.estaVacio(activos)) {
							for (Activo activo : activos) {
								precioMinimo += activoApi.getImporteValoracionActivoByCodigo(activo,
										DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO);
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
	 * Este método genera un objeto dto de decisión en base al ID de expediente que
	 * recibe.
	 *
	 * @param idExpediente: ID de la entidad expediente.
	 * @return Devuelve un objeto dto InstanciaDecisionDto.
	 * @throws Exception: Devuelve una excepción si algo no se ha procesado
	 *                    correctamente.
	 */
	private InstanciaDecisionDto creaInstanciaDecisionDto(Long idExpediente) throws Exception {
		try {
			ExpedienteComercial expediente = findOne(idExpediente);
			Double porcentajeImpuesto = null;

			if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getCondicionante())) {
				if (!Checks.esNulo(expediente.getCondicionante().getTipoAplicable())) {
					porcentajeImpuesto = expediente.getCondicionante().getTipoAplicable();
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
		DDEstadosExpedienteComercial estadoExpedienteComercial = (DDEstadosExpedienteComercial) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class,
						DDEstadosExpedienteComercial.EN_DEVOLUCION);
		DDEstadosReserva estadoReserva = (DDEstadosReserva) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadosReserva.class, DDEstadosReserva.CODIGO_PENDIENTE_DEVOLUCION);
		expedienteComercial.setEstado(estadoExpedienteComercial);
		recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

		if (!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getReserva())) {
			Reserva reserva = expedienteComercial.getReserva();
			reserva.setIndicadorDevolucionReserva(1);

			if (dto.getPenitenciales() != null && dto.getPenitenciales().equals("3")) {
				DDDevolucionReserva estadoDevolucionReserva = (DDDevolucionReserva) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDDevolucionReserva.class, DDDevolucionReserva.CODIGO_SI_SIMPLES);
				reserva.setDevolucionReserva(estadoDevolucionReserva);
			}

			if (dto.getPenitenciales() != null && dto.getPenitenciales().equals("4")) {
				DDDevolucionReserva estadoDevolucionReserva = (DDDevolucionReserva) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDDevolucionReserva.class, DDDevolucionReserva.CODIGO_SI_DUPLICADOS);
				reserva.setDevolucionReserva(estadoDevolucionReserva);
			}

			reserva.setEstadoReserva(estadoReserva);
		}

		return this.update(expedienteComercial, false);
	}
	
	@Override
	@Transactional(readOnly = false)
	public void insertarRegistroAuditoriaDesbloqueo(Long expedienteId, String comentario, Long usuId) {
		if(usuId == null || expedienteId == null) {
			return;
		}
		Usuario usuario = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id",usuId));
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class,
				genericDao.createFilter(FilterType.EQUALS, "id",expedienteId));//numExpediente
		AuditoriaDesbloqueo auditoria = new AuditoriaDesbloqueo();
		Date fechaActual = new Date();
		if(expediente != null) {
			auditoria.setExpediente(expediente);
		}
		if(usuario != null) {
			auditoria.setUsuario(usuario);
		}
		auditoria.setMotivoDesbloqueo(comentario);
		auditoria.setFechaDesbloqueo(fechaActual);
		
		genericDao.save(AuditoriaDesbloqueo.class, auditoria);
		
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateEstadosResolucionNoDevolucion(ExpedienteComercial expedienteComercial,
			ResolucionComiteDto dto) {
		DDEstadosExpedienteComercial estadoExpedienteComercial = (DDEstadosExpedienteComercial) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class, DDEstadosExpedienteComercial.ANULADO);
		expedienteComercial.setFechaVenta(null);
		DDEstadosReserva estadoReserva = (DDEstadosReserva) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadosReserva.class, DDEstadosReserva.CODIGO_RESUELTA_POSIBLE_REINTEGRO);
		expedienteComercial.setEstado(estadoExpedienteComercial);
		recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

		if (!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getReserva())) {
			Reserva reserva = expedienteComercial.getReserva();
			reserva.setIndicadorDevolucionReserva(0);
			DDDevolucionReserva estadoDevolucionReserva = (DDDevolucionReserva) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDDevolucionReserva.class, DDDevolucionReserva.CODIGO_NO);
			reserva.setDevolucionReserva(estadoDevolucionReserva);
			reserva.setEstadoReserva(estadoReserva);
		}

		return this.update(expedienteComercial, false);
	}

	@Override
	public DDSubcartera getCodigoSubCarteraExpediente(Long idExpediente) {

		DDSubcartera subcartera = null;

		if (!Checks.esNulo(idExpediente)) {
			ExpedienteComercial expediente = findOne(idExpediente);
			if (!Checks.esNulo(expediente)) {
				subcartera = expediente.getOferta().getActivosOferta().get(0).getPrimaryKey().getActivo()
						.getSubcartera();
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
	public GestorSustituto getGestorSustitutoVigente(GestorEntidadHistorico gestor) {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal", gestor.getUsuario());

		try {
			List<GestorSustituto> gestoresSustitutos = genericDao.getList(GestorSustituto.class, filter);

			for (GestorSustituto sustituto : gestoresSustitutos) {
				if (!Checks.esNulo(sustituto.getFechaFin())) {
					if (sustituto.getFechaFin().after(new Date())
							|| DateUtils.isSameDay(sustituto.getFechaFin(), new Date())) {
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

		if (checkAgrupacionAsistida(activoTramite.getActivo())) {
			return true;
		}

		if (expediente.getFechaContabilizacionPropietario() != null) {
			return true;
		} else {
			return false;
		}
	}

	private Boolean checkAgrupacionAsistida(Activo activo) {
		Date fechaHoy = new Date();

		try {
			if (!Checks.esNulo(activo)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo", activo);
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "agrupacion.eliminado", 0);
				List<ActivoAgrupacionActivo> lista = genericDao.getList(ActivoAgrupacionActivo.class, filtro, filtro2);
				ActivoAgrupacionActivo aga = lista.get(0);
				if (!Checks.esNulo(aga)) {
					ActivoAgrupacion agr = aga.getAgrupacion();
					if (!Checks.esNulo(agr)
							&& DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agr.getTipoAgrupacion().getCodigo())) {
						if (fechaHoy.compareTo(agr.getFechaInicioVigencia()) >= 0
								&& fechaHoy.compareTo(agr.getFechaFinVigencia()) <= 0) {
							return true;
						}
					}
				}

			}

		} catch (Exception e) {
			return false;
		}

		return false;
	}

	@Override
	public DtoModificarCompradores vistaADtoModCompradores(VBusquedaDatosCompradorExpediente vista) {
		DtoModificarCompradores comprador = new DtoModificarCompradores();

		try {
			beanUtilNotNull.copyProperties(comprador, vista);
			String cartera = getCodigoCarteraExpediente(vista.getIdExpedienteComercial());
			comprador.setEsBH(esBH(vista.getIdExpedienteComercial()));
			comprador.setCesionDatos(vista.getCesionDatos());
			comprador.setComunicacionTerceros(vista.getComunicacionTerceros());
			comprador.setTransferenciasInternacionales(vista.getTransferenciasInternacionales());
			comprador.setEntidadPropietariaCodigo(cartera);
			comprador.setEsCarteraBankia(DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera));
			if(DDTiposDocumentos.NIF.equals(vista.getCodTipoDocumento())) {
				comprador.setFormaJuridica(vista.getNumDocumento());
			}
			

			if (comprador.getEsCarteraBankia()) {
				if (comprador.getEsBH()) {
					comprador.setMostrarUrsus(false);
					comprador.setMostrarUrsusBh(true);
				} else {
					comprador.setMostrarUrsus(true);
					comprador.setMostrarUrsusBh(false);
				}

			} else {
				comprador.setMostrarUrsus(false);
				comprador.setMostrarUrsusBh(false);
			}

		} catch (Exception e) {
			logger.error("vistaADtoModCompradores", e);
		}

		return comprador;
	}

	@Override
	public DtoModificarCompradores vistaCrearComprador(VBusquedaDatosCompradorExpediente vista) {
		DtoModificarCompradores comprador = new DtoModificarCompradores();

		try {
			beanUtilNotNull.copyProperties(comprador, vista);

			comprador.setEsBH(esBH(vista.getIdExpedienteComercial()));
			comprador.setEntidadPropietariaCodigo(getCodigoCarteraExpediente(vista.getIdExpedienteComercial()));
			comprador.setEsCarteraBankia(getCodigoCarteraExpediente(vista.getIdExpedienteComercial())
					.equals(DDCartera.CODIGO_CARTERA_BANKIA));

			if (comprador.getEsCarteraBankia()) {
				if (comprador.getEsBH()) {
					comprador.setMostrarUrsus(false);
					comprador.setMostrarUrsusBh(true);
				} else {
					comprador.setMostrarUrsus(true);
					comprador.setMostrarUrsusBh(false);
				}

			} else {
				comprador.setMostrarUrsus(false);
				comprador.setMostrarUrsusBh(false);
			}

		} catch (Exception e) {
			logger.error("vistaCrearComprador", e);
		}

		return comprador;
	}

	@Override
	public Boolean esBH(Long idExpediente) {

		return DDSubcartera.CODIGO_BAN_BH.equals(getCodigoSubCarteraExpediente(idExpediente).getCodigo());
	}

	@Override
	public String getCodigoCarteraExpediente(Long idExpediente) {
		String cartera = null;
		ExpedienteComercial expediente = null;
		if (!Checks.esNulo(idExpediente)) {
			expediente = findOne(idExpediente);
//			DtoPage dto = this.getActivosExpediente(idExpediente);
//			List<DtoActivosExpediente> dtosActivos = (List<DtoActivosExpediente>) dto.getResults();
//			if (!Checks.estaVacio(dtosActivos)) {
//				Activo primerActivo = activoApi.get(dtosActivos.get(0).getIdActivo());
//				if (!Checks.esNulo(primerActivo)) {
//					cartera = primerActivo.getCartera().getCodigo();
//				}
//			}
			if (!Checks.esNulo(expediente))
				cartera = expediente.getOferta().getActivosOferta().get(0).getPrimaryKey().getActivo().getCartera()
						.getCodigo();
		}

		return cartera;
	}


	private String getNombreCarteraExpediente(Long idExpediente) {
		String cartera = null;
		ExpedienteComercial expediente = null;
		if (!Checks.esNulo(idExpediente)) {
			expediente = findOne(idExpediente);
//			DtoPage dto = this.getActivosExpediente(idExpediente);
//			List<DtoActivosExpediente> dtosActivos = (List<DtoActivosExpediente>) dto.getResults();
//			if (!Checks.estaVacio(dtosActivos)) {
//				Activo primerActivo = activoApi.get(dtosActivos.get(0).getIdActivo());
//				if (!Checks.esNulo(primerActivo)) {
//					cartera = primerActivo.getCartera().getCodigo();
//				}
//			}
			if (!Checks.esNulo(expediente))
				cartera = expediente.getOferta().getActivosOferta().get(0).getPrimaryKey().getActivo().getCartera()
						.getDescripcion();
		}

		return cartera;
	}

	@Override
	public List<DDTipoCalculo> getComboTipoCalculo(Long idExpediente) {
		ExpedienteComercial expediente = findOne(idExpediente);

		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "tipoOferta.id",
				expediente.getOferta().getTipoOferta().getId());

		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);

		return genericDao.getList(DDTipoCalculo.class, f1, filtroBorrado);
	}

	@Override
	public boolean enviarCorreoComercializadora(String cuerpoEmail, Long idExpediente) {
		boolean resultado = false;
		ExpedienteComercial expediente = this.findOne(idExpediente);

		try {
			// notificamos por correo a los interesados
			ArrayList<String> mailsParaEnviarComercializadora = this.obtenerEmailsEnviarComercializadora(expediente);
			String asunto = "Incidencia en la oferta de alquiler";

			genericAdapter.sendMail(mailsParaEnviarComercializadora, new ArrayList<String>(), asunto, cuerpoEmail);
			resultado = true;

		} catch (Exception e) {
			logger.error("No se ha podido notificar la incidencia en la oferta de alquiler.", e);
		}

		return resultado;
	}

	public DtoExpedienteScoring expedienteToDtoScoring(ExpedienteComercial expediente) {

		DtoExpedienteScoring scoringDto = new DtoExpedienteScoring();
		DDResultadoCampo resultadoCampo = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId());
		ScoringAlquiler scoringAlquiler = genericDao.get(ScoringAlquiler.class, filtro);
		if (!Checks.esNulo(scoringAlquiler)) {
			if (DDResultadoCampo.RESULTADO_APROBADO.equals(scoringAlquiler.getResultadoScoring().getCodigo())) {
				resultadoCampo = (DDResultadoCampo) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoCampo.class,
						DDResultadoCampo.RESULTADO_APROBADO);
				scoringDto.setComboEstadoScoring(resultadoCampo.getDescripcion());
			} else {
				resultadoCampo = (DDResultadoCampo) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoCampo.class,
						DDResultadoCampo.RESULTADO_RECHAZADO);
				scoringDto.setComboEstadoScoring(resultadoCampo.getDescripcion());
			}
			scoringDto.setId(scoringAlquiler.getId());
			scoringDto.setMotivoRechazo(scoringAlquiler.getMotivoRechazo());
			scoringDto.setnSolicitud(scoringAlquiler.getIdSolicitud());

			if (!Checks.esNulo(scoringAlquiler.getRevision()) && scoringAlquiler.getRevision() == 1) {
				scoringDto.setRevision(true);
			} else {
				scoringDto.setRevision(false);
			}

			scoringDto.setComentarios(scoringAlquiler.getComentarios());

		} else {
			scoringDto.setComboEstadoScoring("En trámite");
		}

		return scoringDto;
	}

	private DtoExpedienteDocumentos expedienteToDtoDocumentos(ExpedienteComercial expediente) {

		DtoExpedienteDocumentos documentosExpDto = new DtoExpedienteDocumentos();

		documentosExpDto.setDocOk(expediente.getDocumentacionOk());
		documentosExpDto.setFechaValidacion(expediente.getFechaValidacion());

		return documentosExpDto;
	}

	@Override
	public List<DtoExpedienteHistScoring> getHistoricoScoring(Long idScoring) {

		List<DtoExpedienteHistScoring> listaHstco = new ArrayList<DtoExpedienteHistScoring>();
		List<HistoricoScoringAlquiler> listaHistoricoScoring = new ArrayList<HistoricoScoringAlquiler>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "scoringAlquiler.expediente.id", idScoring); // 126464
		listaHistoricoScoring = genericDao.getList(HistoricoScoringAlquiler.class, filtro);
		ExpedienteComercial exp = null;
		DtoAdjunto adjFinal = new DtoAdjunto();
		if (!Checks.estaVacio(listaHistoricoScoring)) {
			exp = listaHistoricoScoring.get(0).getScoringAlquiler().getExpediente();
		}
		if (!Checks.esNulo(exp)) {
			List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
			Usuario usuario = genericAdapter.getUsuarioLogado();
			Date fechaFinal = null;
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				try {
					listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosExpedienteComercial(exp);
					for (DtoAdjunto adj : listaAdjuntos) {
						AdjuntoExpedienteComercial adjuntoExpedienteComercial = exp.getAdjuntoGD(adj.getId());
						if (!Checks.esNulo(adjuntoExpedienteComercial) && DDSubtipoDocumentoExpediente.CODIGO_SCORING
								.equals(adjuntoExpedienteComercial.getSubtipoDocumentoExpediente().getCodigo())) {
							if (Checks.esNulo(fechaFinal)
									|| adjuntoExpedienteComercial.getFechaDocumento().compareTo(fechaFinal) > 0) {
								fechaFinal = adjuntoExpedienteComercial.getFechaDocumento();
								adjFinal = adj;
							}

						}

					}
				} catch (GestorDocumentalException gex) {
					String[] error = gex.getMessage().split("-");
					if (error.length > 0 && (error[2].trim().contains("Error al obtener el activo, no existe"))) {

						Integer idExp;
						try {
							idExp = gestorDocumentalAdapterApi.crearExpedienteComercial(exp, usuario.getUsername());
							logger.debug("GESTOR DOCUMENTAL [ crearExpediente para " + exp.getNumExpediente()
									+ "]: ID EXPEDIENTE RECIBIDO " + idExp);
						} catch (GestorDocumentalException gexc) {
							gexc.printStackTrace();
							logger.debug(gexc.getMessage());
						}

					}
				}
			} else {
				listaAdjuntos = getAdjuntosExp(exp.getId(), listaAdjuntos);
				if (Checks.esNulo(listaAdjuntos)) {
					for (DtoAdjunto adj : listaAdjuntos) {
						if (!Checks.esNulo(adj) && "Scoring".equals(adj.getDescripcionSubtipo())) {
							if (Checks.esNulo(fechaFinal) || adj.getFechaDocumento().compareTo(fechaFinal) > 0) {
								fechaFinal = adj.getFechaDocumento();
								adjFinal = adj;
							}
						}

					}

				}

			}
		}
		for (HistoricoScoringAlquiler hist : listaHistoricoScoring) {
			DtoExpedienteHistScoring dto = new DtoExpedienteHistScoring();
			if (!Checks.esNulo(hist.getFechaSancion())) {
				dto.setFechaSancion(hist.getFechaSancion());
			}

			if (!Checks.esNulo(hist.getResultadoScoring())) {
				dto.setResultadoScoring(hist.getResultadoScoring().getDescripcion());
			}

			if (!Checks.esNulo(hist.getIdSolicitud())) {
				dto.setnSolicitud(Long.parseLong(hist.getIdSolicitud()));
			}

			if (!Checks.esNulo(hist.getMesesFianza())) {
				dto.setnMesesFianza(hist.getMesesFianza());
			}

			if (!Checks.esNulo(hist.getImportFianza())) {
				dto.setImporteFianza(hist.getImportFianza());
			}
			dto.setDocScoring(adjFinal.getNombre());
			dto.setIdActivo(adjFinal.getId_activo());
			dto.setIdentificador(adjFinal.getId());

			listaHstco.add(dto);
		}

		return listaHstco;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveExpedienteScoring(DtoExpedienteScoring dto, Long idEntidad) {

		ScoringAlquiler scoring = null;

		if (dto.getId() != null) {
			Filter filtroSeg = genericDao.createFilter(FilterType.EQUALS, "expediente.id", dto.getId());
			scoring = genericDao.get(ScoringAlquiler.class, filtroSeg);
		}

		if (scoring == null) {
			scoring = new ScoringAlquiler();
		}

		if (dto.getMotivoRechazo() != null) {
			scoring.setMotivoRechazo(dto.getMotivoRechazo());
		}

		if (dto.getRevision() != null) {
			if (dto.getRevision()) {
				scoring.setRevision(Integer.valueOf(1));
			} else {
				scoring.setRevision(Integer.valueOf(0));
			}
		}

		if (dto.getComboEstadoScoring() != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getComboEstadoScoring());
			DDResultadoCampo estadoScoring = genericDao.get(DDResultadoCampo.class, filtro);
			scoring.setResultadoScoring(estadoScoring);
		}

		if (dto.getComentarios() != null) {
			scoring.setComentarios(dto.getComentarios());
		}

		if (dto.getId() != null) {
			try {
				genericDao.update(ScoringAlquiler.class, scoring);
			} catch (Exception e) {
				logger.error("error en expedienteComercialManager", e);
			}
		} else {
			try {
				genericDao.save(ScoringAlquiler.class, scoring);
			} catch (Exception e) {
				logger.error("error en expedienteComercialManager", e);
			}
		}
		return true;
	}

	@Override
	public boolean enviarCorreoAsegurador(Long idExpediente) {
		boolean resultado = false;
		ExpedienteComercial expediente = this.findOne(idExpediente);
		Activo activo = expediente.getOferta().getActivoPrincipal();
		
		Filter filtroTramite = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", expediente.getTrabajo().getId());
		ActivoTramite tramite = genericDao.get(ActivoTramite.class, filtroTramite);

		try {
			ArrayList<String> mailsParaEnviarAsegurador = this.obtenerEmailsParaEnviarAsegurador(expediente);
			String asunto = "Firma contrato alquiler";
			String cuerpo = "Comunicamos que se ha firmado el contrato de arrendamiento del inmueble "
					+ activo.getNumActivo() + "."
					+ "<br><br> Adjunto copia del contrato suscrito para el alta para la gestión del alta en cobertura de la póliza de seguro de rentas."
					+ "<br><br> Rogamos confirmación del alta.";
			
			cuerpo = tieneNumeroInmuebleBC(cuerpo, tramite);

			Adjunto adjuntoMail = null;
			String nombreDocumento = null;

			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				List<DtoAdjunto> adjuntosExpediente = gestorDocumentalAdapterApi
						.getAdjuntosExpedienteComercial(expediente);

				for (DtoAdjunto adjunto : adjuntosExpediente) {
					if (DDSubtipoDocumentoExpediente.MATRICULA_CONTRATO.equals(adjunto.getMatricula())) {
						AdjuntoExpedienteComercial adjuntoGD = expediente.getAdjuntoGD(adjunto.getId());
						adjuntoMail = adjuntoGD.getAdjunto();
						nombreDocumento = adjuntoGD.getNombre();
						break;
					}
				}
			} else {

				List<AdjuntoExpedienteComercial> adjuntosRecuperados = genericDao.getListOrdered(
						AdjuntoExpedienteComercial.class, new Order(OrderType.DESC, "auditoria.fechaCrear"),
						genericDao.createFilter(FilterType.EQUALS, "expediente", expediente),
						genericDao.createFilter(FilterType.EQUALS, "subtipoDocumentoExpediente.codigo",
								DDSubtipoDocumentoExpediente.CODIGO_CONTRATO));

				Adjunto adjuntoLocal = adjuntosRecuperados.get(0).getAdjunto();

				nombreDocumento = adjuntosRecuperados.get(0).getNombre();

				adjuntoMail = adjuntoLocal;
			}

			DtoAdjuntoMail dto = new DtoAdjuntoMail();
			dto.setNombre(nombreDocumento);
			dto.setAdjunto(adjuntoMail);

			List<DtoAdjuntoMail> adjuntosParaEnviarAsegurador = new ArrayList<DtoAdjuntoMail>();
			adjuntosParaEnviarAsegurador.add(dto);

			genericAdapter.sendMail(mailsParaEnviarAsegurador, new ArrayList<String>(), asunto, cuerpo,
					adjuntosParaEnviarAsegurador);
			resultado = true;
		} catch (Exception e) {
			logger.error("No se ha podido notificar a la aseguradora.", e);
		}
		return resultado;
	}

	private ArrayList<String> obtenerEmailsParaEnviarAsegurador(ExpedienteComercial expediente) {

		ArrayList<String> mailsParaEnviarAsegurador = new ArrayList<String>();

		if (!Checks.esNulo(expediente.getSeguroRentasAlquiler())) {
			if (!Checks.esNulo(expediente.getSeguroRentasAlquiler().getEmailPolizaAseguradora())) {
				mailsParaEnviarAsegurador.add(expediente.getSeguroRentasAlquiler().getEmailPolizaAseguradora());
			} else {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id",
						Long.valueOf(expediente.getSeguroRentasAlquiler().getAseguradoras()));
				ActivoProveedor aseguradora = genericDao.get(ActivoProveedor.class, filtro);
				mailsParaEnviarAsegurador.add(aseguradora.getEmail());
			}
		}

		if (expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null) {
			Usuario gestorActivoGestorAlquileres = gestorActivoApi.getGestorByActivoYTipo(
					expediente.getOferta().getActivoPrincipal(), GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES);
			if (gestorActivoGestorAlquileres != null && gestorActivoGestorAlquileres.getEmail() != null) {
				mailsParaEnviarAsegurador.add(gestorActivoGestorAlquileres.getEmail());
			}
		}

		if (expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null) {
			Usuario gestorActivoSupervisorAlquileres = gestorActivoApi.getGestorByActivoYTipo(
					expediente.getOferta().getActivoPrincipal(),
					GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_ALQUILERES);
			if (gestorActivoSupervisorAlquileres != null && gestorActivoSupervisorAlquileres.getEmail() != null) {
				mailsParaEnviarAsegurador.add(gestorActivoSupervisorAlquileres.getEmail());
			}
		}

		return mailsParaEnviarAsegurador;

	}

	@Override
	public boolean enviarCorreoGestionLlaves(Long idExpediente, Posicionamiento posicionamiento, int envio) {
		boolean resultado = false;
		ExpedienteComercial expediente = this.findOne(idExpediente);
		Activo activo = expediente.getOferta().getActivoPrincipal();
		
		Filter filtroTramite = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", expediente.getTrabajo().getId());
		ActivoTramite tramite = genericDao.get(ActivoTramite.class, filtroTramite);

		if (Checks.esNulo(posicionamiento)) {
			posicionamiento = expediente.getUltimoPosicionamiento();
		}

		// Solo enviamos el correo si hay un posicionamiento vigente.
		if (!Checks.esNulo(posicionamiento)) {

			DateFormat fechaCompleta = new SimpleDateFormat("dd/MM/yyyy");
			String fechaFirmaContrato = fechaCompleta.format(posicionamiento.getFechaPosicionamiento());

			try {

				ArrayList<String> mailsParaEnviarAsegurador = this.obtenerEmailsEnviarGestionLlaves(expediente);
				String asunto = null;
				if (envio == 0)
					asunto = "Fecha firma contrato alquiler";
				else if (envio == 1)
					asunto = "Modificación fecha firma contrato alquiler";
				String cuerpo = "Comunicamos que se ha posicionado para el día " + fechaFirmaContrato
						+ ", la firma del contrato de arrendamiento del inmueble " + activo.getNumActivo()
						+ ", siendo el "
						+ String.format("Api gestor de la firma  %s",
								(activo.getInfoComercial() != null)
										? activo.getInfoComercial().getMediadorInforme().getNombre()
										: STR_MISSING_VALUE)
						+ "<br><br> Rogamos se gestione el envío de llaves para dicha operación.";
				
				cuerpo = tieneNumeroInmuebleBC(cuerpo, tramite);

				genericAdapter.sendMail(mailsParaEnviarAsegurador, new ArrayList<String>(), asunto, cuerpo);
				resultado = true;
			} catch (Exception e) {
				logger.error("No se ha podido notificar a la aseguradora.", e);
			}
		}
		return resultado;
	}

	private ArrayList<String> obtenerEmailsEnviarGestionLlaves(ExpedienteComercial expediente) {

		ArrayList<String> mailsParaEnviarComercializadora = new ArrayList<String>();

		// HREOS-4374, HREOS-4487, HREOS-5176, HREOS-6183
		if (!Checks.esNulo(expediente.getOferta())) {

			if (!Checks.esNulo(expediente.getOferta().getActivoPrincipal())) {
				Usuario gestorActivoGestorLlaves = gestorActivoApi.getGestorByActivoYTipo(
						expediente.getOferta().getActivoPrincipal(), GestorActivoApi.CODIGO_GESTOR_LLAVES);
				if (!Checks.esNulo(gestorActivoGestorLlaves) && !Checks.esNulo(gestorActivoGestorLlaves.getEmail())) {
					mailsParaEnviarComercializadora.add(gestorActivoGestorLlaves.getEmail());
				}

				// En ocasiones, getInfoComercial da nulo pese a la comprobación de la Oferta y
				// el ActivoPrincipal
				if (!Checks.esNulo(expediente.getOferta().getActivoPrincipal().getInfoComercial())) {
					if (!Checks.esNulo(
							expediente.getOferta().getActivoPrincipal().getInfoComercial().getMediadorInforme())) {
						ActivoProveedor custodio = expediente.getOferta().getActivoPrincipal().getInfoComercial()
								.getMediadorInforme();
						if (!Checks.esNulo(custodio.getEmail())) {
							mailsParaEnviarComercializadora.add(custodio.getEmail());
						}
					}
				}

				if (!Checks.esNulo(expediente.getOferta().getPrescriptor())
						&& !Checks.esNulo(expediente.getOferta().getPrescriptor().getEmail())) {
					mailsParaEnviarComercializadora.add(expediente.getOferta().getPrescriptor().getEmail());
				}

				Usuario gestorActivoGestorAlquileres = gestorActivoApi.getGestorByActivoYTipo(
						expediente.getOferta().getActivoPrincipal(),
						GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES);
				if (!Checks.esNulo(gestorActivoGestorAlquileres)
						&& !Checks.esNulo(gestorActivoGestorAlquileres.getEmail())) {
					mailsParaEnviarComercializadora.add(gestorActivoGestorAlquileres.getEmail());
				}

				Usuario gestorActivoSupervisorAlquileres = gestorActivoApi.getGestorByActivoYTipo(
						expediente.getOferta().getActivoPrincipal(),
						GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_ALQUILERES);
				if (!Checks.esNulo(gestorActivoSupervisorAlquileres)
						&& !Checks.esNulo(gestorActivoSupervisorAlquileres.getEmail())) {
					mailsParaEnviarComercializadora.add(gestorActivoSupervisorAlquileres.getEmail());
				}

				Usuario gestorActivoGestor = gestorActivoApi.getGestorByActivoYTipo(
						expediente.getOferta().getActivoPrincipal(), GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
				if (!Checks.esNulo(gestorActivoGestor) && !Checks.esNulo(gestorActivoGestor.getEmail())) {
					mailsParaEnviarComercializadora.add(gestorActivoGestor.getEmail());
				}

				Usuario gestorActivoSupervisor = gestorActivoApi.getGestorByActivoYTipo(
						expediente.getOferta().getActivoPrincipal(), GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
				if (!Checks.esNulo(gestorActivoSupervisor) && !Checks.esNulo(gestorActivoSupervisor.getEmail())) {
					mailsParaEnviarComercializadora.add(gestorActivoSupervisor.getEmail());
				}

				Usuario gestorActivoHPM = gestorActivoApi.getGestorByActivoYTipo(
						expediente.getOferta().getActivoPrincipal(), GestorActivoApi.CODIGO_GESTOR_HPM);
				if (!Checks.esNulo(gestorActivoHPM) && !Checks.esNulo(gestorActivoHPM.getEmail())) {
					mailsParaEnviarComercializadora.add(gestorActivoHPM.getEmail());
				}
			}
		}

		return mailsParaEnviarComercializadora;

	}

	@Override
	public List<DtoDiccionario> getComboExpedienteComercialByEstado(String idEstado) {

		DtoDiccionario diccionario = new DtoDiccionario();

		List<DDEstadosExpedienteComercial> listaEstados = new ArrayList<DDEstadosExpedienteComercial>();
		List<DtoDiccionario> listaDiccionario = new ArrayList<DtoDiccionario>();

		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);

		if (!Checks.esNulo(idEstado)) {
			if (DDEstadosExpedienteComercial.VENTA.equals(idEstado)) {
				Filter filtroVenta = genericDao.createFilter(FilterType.EQUALS, "estadoVenta", true);
				listaEstados = genericDao.getList(DDEstadosExpedienteComercial.class, filtroVenta, filtroBorrado);
			} else if (DDEstadosExpedienteComercial.ALQUILER.equals(idEstado)) {
				Filter filtroAlquiler = genericDao.createFilter(FilterType.EQUALS, "estadoAlquiler", true);
				listaEstados = genericDao.getList(DDEstadosExpedienteComercial.class, filtroAlquiler, filtroBorrado);
			}
		}

		for (DDEstadosExpedienteComercial estadosExpedieteComercial : listaEstados) {
			diccionario = new DtoDiccionario();

			diccionario.setId(estadosExpedieteComercial.getId());
			diccionario.setDescripcion(estadosExpedieteComercial.getDescripcion());
			diccionario.setCodigo(estadosExpedieteComercial.getCodigo());
			listaDiccionario.add(diccionario);
		}

		return listaDiccionario;
	}

	@Override
	public boolean enviarCorreoPosicionamientoFirma(Long idExpediente, Posicionamiento posicionamiento) {
		boolean resultado = false;
		ExpedienteComercial expediente = this.findOne(idExpediente);
		Activo activo = expediente.getOferta().getActivoPrincipal();
		
		Filter filtroTramite = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", expediente.getTrabajo().getId());
		ActivoTramite tramite = genericDao.get(ActivoTramite.class, filtroTramite);

		if (Checks.esNulo(posicionamiento)) {
			posicionamiento = expediente.getUltimoPosicionamiento();
		}

		// Solo enviamos el correo si hay un posicionamiento vigente.
		if (!Checks.esNulo(posicionamiento)) {

			DateFormat fechaCompleta = new SimpleDateFormat("dd/MM/yyyy");
			String fechaFirmaContrato = fechaCompleta.format(posicionamiento.getFechaPosicionamiento());

			try {
				ArrayList<String> mailsParaEnviar = this.obtenerEmailsParaEnviarPosicionamientoFirma(expediente);
				String asunto = "Posicionamiento firma contrato alquiler";
				String cuerpo = "Confirmamos la aprobación de la operación de arrendamiento del inmueble "
						+ activo.getNumActivo() + ", y confirmamos posicionamiento de firma el día "
						+ fechaFirmaContrato + "." + "<br><br> Se gestiona el envío de llaves por nuestra parte."
						+ "<br><br> Rogamos se gestione la coordinación de la firma con el cliente en los términos aprobados.";
				
				cuerpo = tieneNumeroInmuebleBC(cuerpo, tramite);

				genericAdapter.sendMail(mailsParaEnviar, new ArrayList<String>(), asunto, cuerpo);
				resultado = true;
			} catch (Exception e) {
				logger.error("No se ha podido notificar el posicionamiento de firma.", e);
			}
		}
		return resultado;
	}

	private ArrayList<String> obtenerEmailsParaEnviarPosicionamientoFirma(ExpedienteComercial expediente) {

		ArrayList<String> mailsParaEnviarPosicionamientoFirma = new ArrayList<String>();

		if (expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null) {
			Usuario gestorActivoGestorAlquileres = gestorActivoApi.getGestorByActivoYTipo(
					expediente.getOferta().getActivoPrincipal(), GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES);
			if (gestorActivoGestorAlquileres != null && gestorActivoGestorAlquileres.getEmail() != null) {
				mailsParaEnviarPosicionamientoFirma.add(gestorActivoGestorAlquileres.getEmail());
			}
		}

		if (expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null) {
			Usuario gestorActivoSupervisorAlquileres = gestorActivoApi.getGestorByActivoYTipo(
					expediente.getOferta().getActivoPrincipal(),
					GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_ALQUILERES);
			if (gestorActivoSupervisorAlquileres != null && gestorActivoSupervisorAlquileres.getEmail() != null) {
				mailsParaEnviarPosicionamientoFirma.add(gestorActivoSupervisorAlquileres.getEmail());
			}
		}

		return mailsParaEnviarPosicionamientoFirma;
	}

	@Override
	public boolean enviarCorreoSubidaDeContrato(Long idExpediente) {
		boolean resultado = false;
		ExpedienteComercial expediente = this.findOne(idExpediente);
		Activo activo = expediente.getOferta().getActivoPrincipal();

		try {
			ArrayList<String> mailsParaEnviar = this.obtenerEmailsParaEnviarSubidaDeContrato(expediente);
			String asunto = "Documentación disponible para la firma contrato alquiler";
			String cuerpo = "Se ha subido al gestor documental de HAYA copia del contrato de arrendamiento suscrito del inmueble "
					+ activo.getNumActivo()
					+ " para su descarga, firma y posterior incorporación de nuevo al gestor documental de REM.";

			genericAdapter.sendMail(mailsParaEnviar, new ArrayList<String>(), asunto, cuerpo);
			resultado = true;
		} catch (Exception e) {
			logger.error("No se ha podido notificar la subida de contratos.", e);
		}
		return resultado;
	}

	private ArrayList<String> obtenerEmailsParaEnviarSubidaDeContrato(ExpedienteComercial expediente) {

		ArrayList<String> mailsParaEnviarSubidaDeContrato = new ArrayList<String>();

		if (expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null) {
			Usuario gestorActivoGestorAlquileres = gestorActivoApi.getGestorByActivoYTipo(
					expediente.getOferta().getActivoPrincipal(), GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES);
			if (gestorActivoGestorAlquileres != null && gestorActivoGestorAlquileres.getEmail() != null) {
				mailsParaEnviarSubidaDeContrato.add(gestorActivoGestorAlquileres.getEmail());
			}
		}

		if (expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null) {
			Usuario gestorActivoSupervisorAlquileres = gestorActivoApi.getGestorByActivoYTipo(
					expediente.getOferta().getActivoPrincipal(),
					GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_ALQUILERES);
			if (gestorActivoSupervisorAlquileres != null && gestorActivoSupervisorAlquileres.getEmail() != null) {
				mailsParaEnviarSubidaDeContrato.add(gestorActivoSupervisorAlquileres.getEmail());
			}
		}

		if (expediente.getOferta() != null && expediente.getOferta().getPrescriptor() != null
				&& expediente.getOferta().getPrescriptor().getEmail() != null) {
			mailsParaEnviarSubidaDeContrato.add(expediente.getOferta().getPrescriptor().getEmail());
		}

		return mailsParaEnviarSubidaDeContrato;
	}

	@Override
	public boolean checkPrecontratoSubido(TareaExterna tareaExterna) {

		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		try {
			List<DtoAdjunto> adjuntosExpediente = gestorDocumentalAdapterApi
					.getAdjuntosExpedienteComercial(expedienteComercial);
			for (DtoAdjunto adjunto : adjuntosExpediente) {
				if (DDSubtipoDocumentoExpediente.MATRICULA_PRE_CONTRATO.equals(adjunto.getMatricula())) {
					return true;
				}
			}
		} catch (GestorDocumentalException e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public boolean checkDepositoDespublicacionSubido(TareaExterna tareaExterna) {

		if (esApple(tareaExterna) || esDivarian(tareaExterna) || esBBVA(tareaExterna) || esBankia(tareaExterna)) {
			return true;
		}

		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);

		try {
			List<DtoAdjunto> adjuntosExpediente = gestorDocumentalAdapterApi
					.getAdjuntosExpedienteComercial(expedienteComercial);
			for (DtoAdjunto adjunto : adjuntosExpediente) {
				if (DDSubtipoDocumentoExpediente.MATRICULA_DEPOSITO_DESPUBLICACION_ACTIVO
						.equals(adjunto.getMatricula())) {
					return true;
				}
			}
		} catch (GestorDocumentalException e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public boolean esDivarian(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		boolean esDivarian = false;
		for (ActivoOferta activoOferta : expedienteComercial.getOferta().getActivosOferta()) {
			Activo activo = activoApi.get(activoOferta.getPrimaryKey().getActivo().getId());
			esDivarian=false;
			if (DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo()) &&
				(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activo.getSubcartera().getCodigo())
						|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo()))) {
				esDivarian = true;
			}
		}
		return esDivarian;
	}

	@Override
	public boolean esAgora(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		boolean esAgora = false;
		for (ActivoOferta activoOferta : expedienteComercial.getOferta().getActivosOferta()) {
			Activo activo = activoApi.get(activoOferta.getPrimaryKey().getActivo().getId());
			esAgora = false;
			if (DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo())
					&& ((DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))
							|| (DDSubcartera.CODIGO_AGORA_FINANCIERO.equals(activo.getSubcartera().getCodigo())))) {
				esAgora = true;
			}
		}
		return esAgora;
		/*
		 * return
		 * (DDCartera.CODIGO_CARTERA_CERBERUS.equals(expedienteComercial.getOferta().
		 * getActivoPrincipal().getCartera().getCodigo()) &&
		 * ((DDSubcartera.CODIGO_AGORA_FINANCIERO.equals(expedienteComercial.getOferta()
		 * .getActivoPrincipal().getSubcartera().getCodigo()) ||
		 * DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(expedienteComercial.getOferta()
		 * .getActivoPrincipal().getSubcartera().getCodigo()))));
		 */
	}

	@SuppressWarnings("unused")
	@Override
	public boolean checkDepositoRelleno(TareaExterna tareaExterna) {

		if (esApple(tareaExterna) || esDivarian(tareaExterna) || esBBVA(tareaExterna) || esBankia(tareaExterna)) {
			return true;
		}

		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		boolean depositoRelleno = false;

		for (ActivoOferta activoOferta : expedienteComercial.getOferta().getActivosOferta()) {
			// Activo activo =
			// activoApi.get(activoOferta.getPrimaryKey().getActivo().getId());
			depositoRelleno = false;
			if (!Checks.esNulo(expedienteToDtoCondiciones(expedienteComercial).getDepositoReserva())) {
				depositoRelleno = true;
			}
		}
		return depositoRelleno;
	}

	@Override
	public ExpedienteComercial tareaExternaToExpedienteComercial(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = null;
		Trabajo trabajo = trabajoApi.getTrabajoByTareaExterna(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			expedienteComercial = this.findOneByTrabajo(trabajo);
		}
		return expedienteComercial;
	}

	@Override
	public boolean checkContratoSubido(TareaExterna tareaExterna) {

		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		List<DtoAdjunto> adjuntosExpediente = new ArrayList<DtoAdjunto>();

		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				adjuntosExpediente = gestorDocumentalAdapterApi.getAdjuntosExpedienteComercial(expedienteComercial);
				for (DtoAdjunto adjunto : adjuntosExpediente) {
					if (DDSubtipoDocumentoExpediente.MATRICULA_CONTRATO.equals(adjunto.getMatricula())
							|| DDSubtipoDocumentoExpediente.MATRICULA_CONTRATO_ALQUILER_CON_OPCION_A_COMPRA
									.equals(adjunto.getMatricula())) {
						return true;
					}
				}
			} catch (GestorDocumentalException e) {
				e.printStackTrace();
			}
			return false;
		} else {

			adjuntosExpediente = getAdjuntosExp(expedienteComercial.getId(), adjuntosExpediente);
			if (!Checks.esNulo(adjuntosExpediente)) {
				for (DtoAdjunto adjunto : adjuntosExpediente) {
					if (!Checks.esNulo(adjunto))
						if ("Contrato".equals(adjunto.getDescripcionSubtipo())
								|| "Contrato de alquiler con opción a compra".equals(adjunto.getDescripcionSubtipo())) {
							return true;
						}

				}

			}
			return false;
		}
	}

	@Override
	public boolean checkConOpcionCompra(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		if (!Checks.esNulo(expedienteComercial) && DDTipoAlquiler.CODIGO_ALQUILER_OPCION_COMPRA
				.equals(expedienteComercial.getTipoAlquiler().getCodigo())) {
			return true;
		}
		return false;
	}

	@Override
	public Long getIdByNumExpOrNumOfr(Long numBusqueda, String campo) {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numBusqueda", numBusqueda);
		
		rawDao.addParams(params);

		Long idExpediente;

		try {
			if (ExpedienteComercialController.CAMPO_EXPEDIENTE.equals(campo)) {
				idExpediente = Long.parseLong(
						rawDao.getExecuteSQL("SELECT ECO_ID FROM ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = :numBusqueda  AND BORRADO = 0"));
			} else {
				Long idOferta = Long.parseLong(rawDao.getExecuteSQL(
						"SELECT OFR_ID FROM OFR_OFERTAS WHERE OFR_NUM_OFERTA = :numBusqueda AND BORRADO = 0"));
				
				params = new HashMap<String, Object>();
				params.put("idOferta", idOferta);
				
				rawDao.addParams(params);
				
				idExpediente = Long.parseLong(rawDao.getExecuteSQL(
						"SELECT ECO_ID FROM ECO_EXPEDIENTE_COMERCIAL WHERE OFR_ID = :idOferta AND BORRADO = 0"));
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		return idExpediente;
	}

	@Override
	public boolean checkEstadoOcupadoTramite(Long idTramite) {
		boolean ocupado = true;
		try {
			ActivoTramite activoTramite = activoTramiteApi.get(idTramite);

			Activo activo = activoTramite.getActivo();
			DtoActivoSituacionPosesoria activoDto = new DtoActivoSituacionPosesoria();
			if (activo != null) {
				BeanUtils.copyProperty(activoDto, "ocupado", activo.getSituacionPosesoria().getOcupado());
			}

			if (!Checks.esNulo(activoDto) && activoDto.getOcupado() == 0) {
				ocupado = false;
			}

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		} catch (NullPointerException e) {
			e.printStackTrace();
		}

		return ocupado;
	}

	@Override
	public boolean checkConTituloTramite(Long idTramite) {
		boolean ocupado = true;
		try {
			ActivoTramite activoTramite = activoTramiteApi.get(idTramite);

			Activo activo = activoTramite.getActivo();
			DtoActivoSituacionPosesoria activoDto = new DtoActivoSituacionPosesoria();

			if (activo != null) {
				BeanUtils.copyProperty(activoDto, "conTitulo",
						activo.getSituacionPosesoria().getConTitulo().getCodigo());
			}

			if (!Checks.esNulo(activoDto) && activoDto.getConTituloCodigo().equals("0")) {
				ocupado = false;
			}

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		} catch (NullPointerException e) {
			e.printStackTrace();
		}

		return ocupado;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoActivosExpediente> getActivosPropagables(Long idExpediente) {
		DtoPage dtopage = getActivosExpediente(idExpediente);
		List<DtoActivosExpediente> activos = (List<DtoActivosExpediente>) dtopage.getResults();

		return activos;
	}

	@Override
	public Long getNumExpByNumOfr(Long numBusqueda) {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numOferta", numBusqueda);
		
		rawDao.addParams(params);
		
		long idOferta = Long.parseLong(rawDao.getExecuteSQL(
				"SELECT OFR_ID FROM OFR_OFERTAS WHERE OFR_NUM_OFERTA = :numOferta AND BORRADO = 0"));
		
		params = new HashMap<String, Object>();
		params.put("idOferta", idOferta);
		
		rawDao.addParams(params);

		return Long.parseLong(
				rawDao.getExecuteSQL("SELECT ECO_NUM_EXPEDIENTE FROM ECO_EXPEDIENTE_COMERCIAL WHERE OFR_ID = :idOferta AND BORRADO = 0"));
	}

	@Override
	public List<DtoPropuestaAlqBankia> getListaDtoPropuestaAlqBankiaByExpId(Long ecoId) {
		List<DtoPropuestaAlqBankia> listaPropuestaBankia = new ArrayList<DtoPropuestaAlqBankia>();
		DtoPropuestaAlqBankia dto = null;
		DtoPropuestaAlqBankia dtoFinal = new DtoPropuestaAlqBankia();

		ExpedienteComercial expediente = this.findOne(ecoId);
		Oferta ofertaPrincipal = expediente.getOferta();

		Activo activo;
		Long indiceTabla = 0L;
		Date aux1 = new Date();
		int index = 0;
		int aux2 = 0;
		BigDecimal sumaTasacionFinal = new BigDecimal(0);
		BigDecimal importeOfertaFinal = new BigDecimal(0);

		List<ActivoOferta> activoOferta = ofertaPrincipal.getActivosOferta();
		for (ActivoOferta actOf : activoOferta) {
			dto = new DtoPropuestaAlqBankia();

			Filter filtroActivoOfertaActivo = genericDao.createFilter(FilterType.EQUALS, "id", actOf.getActivoId());
			activo = genericDao.get(Activo.class, filtroActivoOfertaActivo);

			dto.setId(indiceTabla);
			dto.setEcoId(ecoId);
			if (!Checks.esNulo(activo)) {
				dto.setNumActivoUvem(activo.getNumActivoUvem());
				if (!Checks.esNulo(activo.getCodPostal())) {
					dto.setCodPostal(Integer.parseInt(activo.getCodPostal()));
				}

				if (!Checks.esNulo(activo.getMunicipio())) {
					String codigoMunicipio = activo.getMunicipio();
					Filter filtroMunicipio = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoMunicipio);
					Localidad localidad = genericDao.get(Localidad.class, filtroMunicipio);
					if (!Checks.esNulo(localidad)) {
						dto.setMunicipio(localidad.getDescripcion());
					}
				}

				if (!Checks.esNulo(activo.getTipoAlquiler())) {
					dto.setTipoAlquiler(activo.getTipoAlquiler().getDescripcion());
				}

				if (!Checks.esNulo(activo.getTipoActivo())) {
					dto.setTipoActivo(activo.getTipoActivo().getDescripcion());
				}
				dto.setProvincia(activo.getProvincia());

				if (!Checks.esNulo(activo.getCartera())) {
					dto.setCartera(activo.getCartera().getDescripcion());
				}
				if (!Checks.esNulo(activo.getActivoPublicacion())) {
					dto.setFechaPublicacionWeb(activo.getActivoPublicacion().getFechaInicioAlquiler());
				}
				if (!Checks.esNulo(activo.getPropietarioPrincipal())) {
					dto.setNombrePropietario(activo.getPropietarioPrincipal().getNombre());
				}

				List<ActivoTasacion> activoTasacionList = activo.getTasacion();
				index = 0;
				aux2 = 0;
				aux1 = new Date();
				if (!Checks.estaVacio(activoTasacionList)) {
					for (ActivoTasacion activoTasacion : activoTasacionList) {
						if (index == 0) {
							if (!Checks.esNulo(activoTasacion.getAuditoria())) {
								aux1 = activoTasacion.getAuditoria().getFechaCrear();
							}
						} else {
							if (!Checks.esNulo(activoTasacion.getAuditoria())) {
								if ((activoTasacion.getAuditoria().getFechaCrear()).after(aux1)
										|| (activoTasacion.getAuditoria().getFechaCrear()).equals(aux1)) {
									aux2 = index;
								} else {
									aux1 = activoTasacion.getAuditoria().getFechaCrear();
								}
							}
						}
						index++;
					}

					if (!Checks.esNulo(activoTasacionList.get(aux2))) {
						ActivoTasacion activoTasacion = activoTasacionList.get(aux2);
						if (!Checks.esNulo(activoTasacion.getImporteTasacionFin())) {
							dto.setImporteTasacionFinal((BigDecimal.valueOf(activoTasacion.getImporteTasacionFin())));
						}
						dto.setFechaUltimaTasacion(activoTasacion.getFechaRecepcionTasacion());
					}
				}

				ActivoLocalizacion activoLocalizacion = activo.getLocalizacion();
				if (!Checks.esNulo(activoLocalizacion)) {
					NMBLocalizacionesBien localizacionesBien = activoLocalizacion.getLocalizacionBien();

					if (!Checks.esNulo(localizacionesBien)) {
						if (!Checks.esNulo(localizacionesBien.getTipoVia())) {
							dto.setTipoVia(localizacionesBien.getTipoVia().getDescripcion());
						}
						dto.setCalle(localizacionesBien.getNombreVia());
						dto.setNumDomicilio(localizacionesBien.getNumeroDomicilio());
						dto.setPuerta(localizacionesBien.getPuerta());
						dto.setPiso(localizacionesBien.getPiso());
						dto.setEscalera(localizacionesBien.getEscalera());
					}

				}
			}

			Filter filtroActivoOfertaOferta = genericDao.createFilter(FilterType.EQUALS, "id", actOf.getOferta());
			Oferta oferta = genericDao.get(Oferta.class, filtroActivoOfertaOferta);
			if (!Checks.esNulo(oferta)) {
				Filter textoOfertaFiltro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", actOf.getOferta());
				List<TextosOferta> ofertaTXT = genericDao.getList(TextosOferta.class, textoOfertaFiltro);
				for (TextosOferta textosOferta : ofertaTXT) {
					if ((DDTiposTextoOferta.TIPOS_TEXTO_OFERTA_GESTOR)
							.equals(textosOferta.getTipoTexto().getCodigo())) {
						dto.setTextoOferta(textosOferta.getTexto());
						break;
					}
				}

				dto.setFechaAltaOferta(oferta.getFechaAlta());
				if (!Checks.esNulo(oferta.getAgrupacion())) {
					dto.setNumeroAgrupacion(oferta.getAgrupacion().getNumAgrupUvem());
				}
				if (!Checks.esNulo(oferta.getImporteOferta())) {
					dto.setImporteOferta(BigDecimal.valueOf(oferta.getImporteOferta()));
				}
			}

			dto.setFechaAltaExpedienteComercial(expediente.getFechaAlta());

			if (!Checks.esNulo(expediente.getCondicionante())) {
				dto.setMesesFianza(expediente.getCondicionante().getMesesFianza());
				if (!Checks.esNulo(expediente.getCondicionante().getImporteFianza())) {
					dto.setImporteFianza((BigDecimal.valueOf(expediente.getCondicionante().getImporteFianza())));
				}
				if (!Checks.esNulo(expediente.getCondicionante().getCarencia())) {
					dto.setCarenciaALquiler(expediente.getCondicionante().getMesesCarencia());
				}
			}

			if (!Checks.esNulo(expediente.getOferta())) {
				if (!Checks.esNulo(expediente.getOferta().getCliente())) {
					ClienteComercial cliente = expediente.getOferta().getCliente();
					dto.setCompradorNombre(cliente.getNombre());
					dto.setCompradorApellidos(cliente.getApellidos());
					dto.setCompradorDocumento(cliente.getDocumento());
				}
			}

			String stringAux = "";

			if (Checks.esNulo(dto.getCompradorNombre())) {
				stringAux = "";
			} else {
				stringAux = dto.getCompradorNombre() + " ";
			}
			if (Checks.esNulo(dto.getCompradorApellidos())) {
				stringAux = stringAux + "";
			} else {
				stringAux = stringAux + dto.getCompradorApellidos();
			}
			dto.setNombreCompleto(stringAux);
			stringAux = "";
			if (Checks.esNulo(dto.getCodPostal())) {
				stringAux = " ";
			} else {
				stringAux = Integer.toString(dto.getCodPostal()) + " ";
			}
			if (Checks.esNulo(dto.getMunicipio())) {
				stringAux = " ";
			} else {
				stringAux = stringAux + dto.getMunicipio();
			}
			dto.setCodPostMunicipio(stringAux);

			stringAux = "";
			if (Checks.esNulo(dto.getTipoVia())) {
				stringAux = "";
			} else {
				stringAux = dto.getTipoVia() + " ";
			}
			if (Checks.esNulo(dto.getCalle())) {
				stringAux = stringAux + "";
			} else {
				stringAux = stringAux + dto.getCalle() + " ";
			}
			if (Checks.esNulo(dto.getNumDomicilio())) {
				stringAux = stringAux + "";
			} else {
				stringAux = dto.getCalle() + " ";
				stringAux = stringAux + dto.getNumDomicilio() + " ";
			}
			if (Checks.esNulo(dto.getPiso())) {
				stringAux = stringAux + "";
			} else {
				stringAux = stringAux + dto.getPiso() + " ";
			}
			if (Checks.esNulo(dto.getPuerta())) {
				stringAux = stringAux + "";
			} else {
				stringAux = stringAux + dto.getPuerta() + " ";
			}
			if (Checks.esNulo(dto.getEscalera())) {
				stringAux = stringAux + "";
			} else {
				stringAux = stringAux + dto.getEscalera();
			}

			dto.setDireccionCompleta(stringAux);

			if (!Checks.esNulo(dto.getImporteOferta())) {
				importeOfertaFinal = importeOfertaFinal.add(dto.getImporteOferta());
			}
			if (!Checks.esNulo(dto.getImporteTasacionFinal())) {
				sumaTasacionFinal = sumaTasacionFinal.add(dto.getImporteTasacionFinal());
			}

			indiceTabla++;
			listaPropuestaBankia.add(dto);
		}

		dtoFinal.setId(indiceTabla);
		dtoFinal.setNumActivoUvem(indiceTabla);
		dtoFinal.setImporteTasacionFinal(sumaTasacionFinal);
		dtoFinal.setImporteOferta(importeOfertaFinal);

		listaPropuestaBankia.add(dtoFinal);

		return listaPropuestaBankia;
	}

	@Override
	@Transactional(readOnly = false)
	public List<DtoTipoDocExpedientes> getSubtipoDocumentosExpedientes(Long idExpediente, String valorCombo) {

		List<DtoTipoDocExpedientes> listDtoTipoDocExpediente = new ArrayList<DtoTipoDocExpedientes>();
		List<DDSubtipoDocumentoExpediente> listaDDSubtipoDocExp = new ArrayList<DDSubtipoDocumentoExpediente>();
		ExpedienteComercial expediente = findOne(idExpediente);

		String codigoVenta = DDTipoOferta.CODIGO_VENTA;
		String codigoAlquiler = DDTipoOferta.CODIGO_ALQUILER;
		String codigoAlqNoComercial = DDTipoOferta.CODIGO_ALQUILER_NO_COMERCIAL;

		if (!Checks.esNulo(expediente)) {
			if (expediente.getOferta().getTipoOferta().getCodigo().equals(codigoVenta)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoExpediente.codigo",
						valorCombo);
				listaDDSubtipoDocExp = genericDao.getList(DDSubtipoDocumentoExpediente.class, filtro);
				if (DDSubcartera.CODIGO_AGORA_FINANCIERO
						.equals(expediente.getOferta().getActivoPrincipal().getSubcartera().getCodigo())
						|| DDSubcartera.CODIGO_AGORA_INMOBILIARIO
								.equals(expediente.getOferta().getActivoPrincipal().getSubcartera().getCodigo())
						|| DDSubcartera.CODIGO_APPLE_INMOBILIARIO
								.equals(expediente.getOferta().getActivoPrincipal().getSubcartera().getCodigo())) {
					listDtoTipoDocExpediente = generateListSubtipoExpediente(listaDDSubtipoDocExp);
				} else {
					listDtoTipoDocExpediente = generateListSubtipoExpedienteNoAgora(listaDDSubtipoDocExp);
				}
			} else if (expediente.getOferta().getTipoOferta().getCodigo().equals(codigoAlquiler)) {
				DDSubtipoDocumentoExpediente codRenovacionContrato = (DDSubtipoDocumentoExpediente) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDSubtipoDocumentoExpediente.class,
								DDSubtipoDocumentoExpediente.CODIGO_RENOVACION_CONTRATO);

				if (DDEstadosExpedienteComercial.FIRMADO.equals(expediente.getEstado().getCodigo())) {
					listaDDSubtipoDocExp.add(codRenovacionContrato);
					listDtoTipoDocExpediente = generateListSubtipoExpediente(listaDDSubtipoDocExp);

				} else {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoExpediente.codigo",
							valorCombo);
					listaDDSubtipoDocExp = genericDao.getList(DDSubtipoDocumentoExpediente.class, filtro);
					listaDDSubtipoDocExp.remove(codRenovacionContrato);
					listDtoTipoDocExpediente = generateListSubtipoExpediente(listaDDSubtipoDocExp);
					String tipoAlquilerOpcionCompra = DDTipoAlquiler.CODIGO_ALQUILER_OPCION_COMPRA;
					String tipoTratamientoScoring = DDTipoTratamiento.TIPO_TRATAMIENTO_SCORING;
					String tipoTratamientoSeguroRentas = DDTipoTratamiento.TIPO_TRATAMIENTO_SEGURO_DE_RENTAS;
					String tipoTratamientoNinguna = DDTipoTratamiento.TIPO_TRATAMIENTO_NINGUNA;
					String flagNoDefinido = DDTipoAlquiler.CODIGO_NO_DEFINIDO;

					if (!Checks.esNulo(expediente.getTipoAlquiler().getCodigo())) {
						DDSubtipoDocumentoExpediente codigoContrato = null;
						if (expediente.getTipoAlquiler().getCodigo().equals(tipoAlquilerOpcionCompra)) {
							codigoContrato = (DDSubtipoDocumentoExpediente) utilDiccionarioApi
									.dameValorDiccionarioByCod(DDSubtipoDocumentoExpediente.class,
											DDSubtipoDocumentoExpediente.CODIGO_CONTRATO);

						} else if (!expediente.getTipoAlquiler().getCodigo().equals(flagNoDefinido)) {
							codigoContrato = (DDSubtipoDocumentoExpediente) utilDiccionarioApi
									.dameValorDiccionarioByCod(DDSubtipoDocumentoExpediente.class,
											DDSubtipoDocumentoExpediente.CODIGO_ALQUILER_CON_OPCION_A_COMPRA);
						}

						listaDDSubtipoDocExp.remove(codigoContrato);
						listaDDSubtipoDocExp.remove(codRenovacionContrato);

					}

					List<ActivoTramite> tramitesActivo = tramiteDao
							.getTramitesActivoTrabajoList(expediente.getTrabajo().getId());
					Filter filtroTratamiento = genericDao.createFilter(FilterType.EQUALS, "codigo",
							"T015_DefinicionOferta");
					Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					TareaProcedimiento tap = genericDao.get(TareaProcedimiento.class, filtroTratamiento,
							filtroBorrado);

					for (ActivoTramite actt : tramitesActivo) {
						List<TareaExterna> tareas = activoTareaExternaApi
								.getByIdTareaProcedimientoIdTramite(actt.getId(), tap.getId());
						for (TareaExterna t : tareas) {
							if (t.getTareaPadre().getTareaFinalizada()
									&& t.getTareaPadre().getAuditoria().isBorrado()) {
								List<TareaExternaValor> listaTareaExterna = activoTareaExternaApi
										.obtenerValoresTarea(t.getId());
								for (TareaExternaValor te : listaTareaExterna) {
									if (te.getNombre().equals("tipoTratamiento")) {
										if (te.getValor().equals(tipoTratamientoScoring)) {
											listaDDSubtipoDocExp
													.remove((DDSubtipoDocumentoExpediente) utilDiccionarioApi
															.dameValorDiccionarioByCod(
																	DDSubtipoDocumentoExpediente.class,
																	DDSubtipoDocumentoExpediente.CODIGO_SEGURO_RENTAS));
										} else if (te.getValor().equals(tipoTratamientoSeguroRentas)) {
											listaDDSubtipoDocExp
													.remove((DDSubtipoDocumentoExpediente) utilDiccionarioApi
															.dameValorDiccionarioByCod(
																	DDSubtipoDocumentoExpediente.class,
																	DDSubtipoDocumentoExpediente.CODIGO_SCORING));
										} else if (te.getValor().equals(tipoTratamientoNinguna)) {
											listaDDSubtipoDocExp
													.remove((DDSubtipoDocumentoExpediente) utilDiccionarioApi
															.dameValorDiccionarioByCod(
																	DDSubtipoDocumentoExpediente.class,
																	DDSubtipoDocumentoExpediente.CODIGO_SEGURO_RENTAS));
											listaDDSubtipoDocExp
													.remove((DDSubtipoDocumentoExpediente) utilDiccionarioApi
															.dameValorDiccionarioByCod(
																	DDSubtipoDocumentoExpediente.class,
																	DDSubtipoDocumentoExpediente.CODIGO_SCORING));
										}
									}
								}
							}
						}
					}

					listDtoTipoDocExpediente = generateListSubtipoExpediente(listaDDSubtipoDocExp);
					listDtoTipoDocExpediente = generateListSubtipoExpediente(listaDDSubtipoDocExp);
				}
			} else if (expediente.getOferta().getTipoOferta().getCodigo().equals(codigoAlqNoComercial)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoExpediente.codigo",valorCombo);
				listaDDSubtipoDocExp = genericDao.getList(DDSubtipoDocumentoExpediente.class, filtro);
				listDtoTipoDocExpediente = generateListSubtipoExpediente(listaDDSubtipoDocExp);
			}
		}

		Collections.sort(listDtoTipoDocExpediente);
		return listDtoTipoDocExpediente;
	}

	private List<DtoTipoDocExpedientes> generateListSubtipoExpediente(
			List<DDSubtipoDocumentoExpediente> listadoDDSubtipoDoc) {

		List<DtoTipoDocExpedientes> listDtoTipoDocExpediente = new ArrayList<DtoTipoDocExpedientes>();

		for (DDSubtipoDocumentoExpediente tipDocExp : listadoDDSubtipoDoc) {
			DtoTipoDocExpedientes aux = new DtoTipoDocExpedientes();
			aux.setId(tipDocExp.getId());
			aux.setCodigo(tipDocExp.getCodigo());
			aux.setDescripcion(tipDocExp.getDescripcion());
			aux.setDescripcionLarga(tipDocExp.getDescripcionLarga());
			aux.setVinculable(tipDocExp.getVinculable());
			listDtoTipoDocExpediente.add(aux);
		}

		return listDtoTipoDocExpediente;
	}

	@Override
	public DtoExpedienteComercial getExpedienteComercialByOferta(Long numOferta) {
		Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(numOferta);
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class,
				genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));
		DtoExpedienteComercial dtoExp = new DtoExpedienteComercial();
		dtoExp.setId(expediente.getId());
		dtoExp.setNumExpediente(expediente.getNumExpediente());
		return dtoExp;

	}

	@Override
	public Long getCompradorIdByDocumento(String dniComprador, String codtipoDoc) {
		long comId = 0;
		if (!Checks.esNulo(dniComprador) && !Checks.esNulo(codtipoDoc)) {
			Filter filterComprador = genericDao.createFilter(FilterType.EQUALS, "documento", dniComprador);
			Filter filterCodigoTpoDoc = genericDao.createFilter(FilterType.EQUALS, "tipoDocumento.codigo", codtipoDoc);
			Comprador comprador = genericDao.get(Comprador.class, filterComprador, filterCodigoTpoDoc);
			if (!Checks.esNulo(comprador)) {
				comId = comprador.getId();
			}
		}
		if (comId != 0) {
			return comId;
		} else {
			return null;
		}

	}

	@Override
	public boolean checkAmConUasConOfertasVivas(TareaExterna tareaExterna) {
		boolean existenOfertasVivas = false;
		TareaActivo tareaActivo = tareaActivoApi.getByIdTareaExterna(tareaExterna.getId());
		Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id",
				tareaActivo.getTramite().getTrabajo().getId());
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtroTrabajo);
		Filter filtroOferta = genericDao.createFilter(FilterType.EQUALS, "id", expediente.getOferta().getId());
		Oferta oferta = genericDao.get(Oferta.class, filtroOferta);
		ActivoAgrupacion agrupacion = oferta.getAgrupacion();
		Long idActivo = tareaActivo.getActivo().getId();
		if (!Checks.esNulo(agrupacion) && !Checks.esNulo(idActivo)) {
			if (DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())
					&& activoDao.isActivoMatriz(idActivo)) {
				existenOfertasVivas = activoDao.existenUAsconOfertasVivas(agrupacion.getId());
			}
		}

		return existenOfertasVivas;
	}

	@Override
	public DtoAviso getAvisosExpedienteById(Long id) {
		boolean provieneOfertaGencat = false;
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		ExpedienteComercial expediente = findOne(id);
		DtoAviso avisosFormateados = new DtoAviso();
		avisosFormateados.setDescripcion("");
		avisosFormateados.setId(id.toString());
		if (!Checks.esNulo(expediente)) {
			List<ComunicacionGencat> comunicacionesVivas = gencatApi.comunicacionesVivas(expediente);
			provieneOfertaGencat = gencatApi.esOfertaGencat(expediente);
			for (ExpedienteAvisadorApi avisador : avisadores) {
				DtoAviso aviso = avisador.getAviso(expediente, usuarioLogado);
				if (!Checks.esNulo(aviso) && !Checks.esNulo(aviso.getDescripcion())) {
					avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() + "<div class='div-aviso red'>"
							+ aviso.getDescripcion() + "</div>");
				}
			}
			if (!Checks.estaVacio(comunicacionesVivas) && !provieneOfertaGencat
					&& !DDEstadosExpedienteComercial.EN_TRAMITACION.equals(expediente.getEstado().getCodigo())
					&& !DDEstadosExpedienteComercial.PTE_SANCION.equals(expediente.getEstado().getCodigo())
					&& ((!Checks.esNulo(expediente.getReserva())
							&& !DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo()))
							|| (Checks.esNulo(expediente.getReserva())
									&& DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo()))
							|| DDEstadosExpedienteComercial.ANULADO.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.ANULADO_PDTE_DEVOLUCION
									.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(expediente.getEstado().getCodigo()))) {
				if (gencatApi.comprobarExpedienteAnuladoGencat(comunicacionesVivas)) {
					avisosFormateados.setDescripcion(avisosFormateados.getDescripcion()
							+ "<div class='div-aviso red'> Expediente anulado por GENCAT </div>");
				} else if (gencatApi.comprobarExpedienteBloqueadoGencat(comunicacionesVivas)) {
					avisosFormateados.setDescripcion(avisosFormateados.getDescripcion()
							+ "<div class='div-aviso red'> Expediente bloqueado por GENCAT </div>");
				} else if (gencatApi.comprobarExpedientePreBloqueadoGencat(comunicacionesVivas)) {
					avisosFormateados.setDescripcion(avisosFormateados.getDescripcion()
							+ "<div class='div-aviso red'> Expediente pre-bloqueado por GENCAT </div>");
				}
			}	
			
			BulkOferta blkOfr = bulkOfertaDao.findOne(null, expediente.getOferta().getId(), false);
			
			if(!Checks.esNulo(blkOfr)) {
				List<BulkOferta> listaBlkOfr = bulkOfertaDao.getListBulkOfertasByIdBulk(blkOfr.getPrimaryKey().getBulkAdvisoryNote().getId());
	
				if (listaBlkOfr != null && !listaBlkOfr.isEmpty()) {
					avisosFormateados.setDescripcion(avisosFormateados.getDescripcion()
							+ "<div class='div-aviso red'> Oferta incluida dentro de Bulk AN </div>");
				}
			}
		}
		return avisosFormateados;
	}

	private List<DtoTipoDocExpedientes> generateListSubtipoExpedienteNoAgora(
			List<DDSubtipoDocumentoExpediente> listadoDDSubtipoDoc) {

		List<DtoTipoDocExpedientes> listDtoTipoDocExpediente = new ArrayList<DtoTipoDocExpedientes>();

		for (DDSubtipoDocumentoExpediente tipDocExp : listadoDDSubtipoDoc) {
			DtoTipoDocExpedientes aux = new DtoTipoDocExpedientes();
			aux.setId(tipDocExp.getId());
			aux.setCodigo(tipDocExp.getCodigo());
			aux.setDescripcion(tipDocExp.getDescripcion());
			aux.setDescripcionLarga(tipDocExp.getDescripcionLarga());
			aux.setVinculable(tipDocExp.getVinculable());
			if (!DDSubtipoDocumentoExpediente.CODIGO_CONTRATO_ARRAS_PENITENCIALES.equals(aux.getCodigo())) {
				if (!DDSubtipoDocumentoExpediente.CODIGO_DEPOSITO_DESPUBLICACION_ACTIVO.equals(aux.getCodigo())) {
					listDtoTipoDocExpediente.add(aux);
				}
			}
		}

		return listDtoTipoDocExpediente;
	}

	@Override
	public boolean esApple(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		boolean esApple = false;
		for (ActivoOferta activoOferta : expedienteComercial.getOferta().getActivosOferta()) {
			Activo activo = activoApi.get(activoOferta.getPrimaryKey().getActivo().getId());
			esApple = false;
			if (DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo())
					&& DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())) {
				esApple = true;
			}
		}
		return esApple;
	}

	@Override
	public Boolean checkPaseDirectoPendDevol(TareaExterna tareaExterna) {

		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);

		Oferta ofertaAceptada = expedienteComercial.getOferta();

		List<TareaExternaValor> valores = activoTareaExternaManagerApi.obtenerValoresTarea(tareaExterna.getId());

		String valorComboMotivoAnularReserva = null;

		for (TareaExternaValor valor : valores) {
			if (UpdaterServiceSancionOfertaResolucionExpediente.MOTIVO_ANULACION_RESERVA.equals(valor.getNombre())
					&& !Checks.esNulo(valor.getValor())) {
				valorComboMotivoAnularReserva = valor.getValor();
				break;
			}
		}

		WSDevolBankiaDto dto = null;

		try {
			dto = uvemManagerApi.notificarDevolucionReserva(ofertaAceptada.getNumOferta().toString(),
					uvemManagerApi.obtenerMotivoAnulacionPorCodigoMotivoAnulacionReserva(valorComboMotivoAnularReserva),
					UvemManagerApi.INDICADOR_DEVOLUCION_RESERVA.DEVOLUCION_RESERVA,
					UvemManagerApi.CODIGO_SERVICIO_MODIFICACION.PROPUESTA_ANULACION_RESERVA_FIRMADA);

			beanUtilNotNull.copyProperties(expedienteComercial, dto);

			if (!Checks.esNulo(dto) && dto.getCorrecw() == 1) {
				expedienteComercial.setDevolAutoNumber(true);
			} else {
				expedienteComercial.setDevolAutoNumber(false);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		genericDao.save(ExpedienteComercial.class, expedienteComercial);

		return Checks.esNulo(expedienteComercial.getCorrecw()) ? false : expedienteComercial.getCorrecw() == 1;
	}

	@Transactional(readOnly = false)
	@Override
	public boolean checkInquilinos(TareaExterna tareaExterna) {

		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);

		if (!Checks.esNulo(expedienteComercial)) {
			Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "idExpedienteComercial",
					expedienteComercial.getId());
			Filter filtroTitular = genericDao.createFilter(FilterType.EQUALS, "titularContratacion", 1);
			VBusquedaDatosCompradorExpediente comprador = genericDao.get(VBusquedaDatosCompradorExpediente.class,
					filtroId, filtroTitular);

			if (!Checks.esNulo(comprador.getCodTipoDocumento())) { // Tipo de documento
				if (!Checks.esNulo(comprador.getNumDocumento())) { // Número de documento

					// Campos dependientes de si el tipo de persona es física
					if (!Checks
							.esNulo(DDTiposPersona.CODIGO_TIPO_PERSONA_FISICA.equals(comprador.getCodTipoPersona()))) {
						if (!Checks.esNulo(comprador.getNombreRazonSocial())) { // Nombre
							if (!Checks.esNulo(comprador.getApellidos())) { // Apellidos
								if (!Checks.esNulo(comprador.getDireccion())) { // Dirección
									if (!Checks.esNulo(comprador.getCodEstadoCivil())) { // Estado civil
										return true;
									}
								}
							}
						}
					}

					// Campos dependientes de si el tipo de persona es jurídica
					if (!Checks.esNulo(
							DDTiposPersona.CODIGO_TIPO_PERSONA_JURIDICA.equals(comprador.getCodTipoPersona()))) {
						if (!Checks.esNulo(comprador.getNombreRazonSocial())) { // Razón social (Titular)
							if (!Checks.esNulo(comprador.getNombreRazonSocialRte())) { // Nombre del representante
								if (!Checks.esNulo(comprador.getApellidosRte())) { // Apellidos del representante
									if (!Checks.esNulo(comprador.getCodTipoDocumentoRte())) { // Tipo de documento del
																								// representante
										if (!Checks.esNulo(comprador.getNumDocumentoRte())) { // Número de documento del
																								// representante
											if (!Checks.esNulo(comprador.getCodigoPaisRte())) { // País de residencia
																								// del representante
												return true;
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		return false;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean hayDiscrepanciasClientesURSUS(Long idExpediente) {

		Boolean flagHayDiscrepancias = false;
		Boolean problemasPorComprador = false;
		Filter filterExpediente = genericDao.createFilter(FilterType.EQUALS, "id", idExpediente);

		ExpedienteComercial expedienteComercial = genericDao.get(ExpedienteComercial.class, filterExpediente);
		List<CompradorExpediente> compradores = expedienteComercial.getCompradores();
		for (CompradorExpediente compradorExpediente : compradores) {
			Filter filterComprador = genericDao.createFilter(FilterType.EQUALS, "id",
					compradorExpediente.getComprador());
			Comprador comprador = genericDao.get(Comprador.class, filterComprador);
			if (!Checks.esNulo(comprador)) {
				try {
					problemasPorComprador = comprobarDatosComprador(comprador, idExpediente);
					if (problemasPorComprador) {
						flagHayDiscrepancias = true;
						filterComprador = genericDao.createFilter(FilterType.EQUALS, "id",
								compradorExpediente.getComprador());
						comprador = genericDao.get(Comprador.class, filterComprador);
						comprador.setProblemasUrsus(true);
						genericDao.update(Comprador.class, comprador);
						crearTareaValidacionClientes(expedienteComercial);
					} else if (!Checks.esNulo(comprador.getProblemasUrsus()) && comprador.getProblemasUrsus()) {
						filterComprador = genericDao.createFilter(FilterType.EQUALS, "id",
								compradorExpediente.getComprador());
						comprador = genericDao.get(Comprador.class, filterComprador);
						comprador.setProblemasUrsus(false);
						genericDao.update(Comprador.class, comprador);
						finalizarTareaValidacionClientes(expedienteComercial);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return flagHayDiscrepancias;
	}

	@Transactional(readOnly = false)
	public Boolean comprobarDatosComprador(Comprador comprador, Long idExpediente) throws Exception {
		Boolean problemasPorComprador = false;
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class,
				genericDao.createFilter(FilterType.EQUALS, "id", idExpediente));
		if (!Checks.esNulo(comprador.getIdCompradorUrsus()) || !Checks.esNulo(comprador.getIdCompradorUrsusBh())) {
			Integer numURSUS = null;
			DatosClienteDto ejecutarDatosCliente = null;

			if (!Checks.esNulo(expediente.getOferta()) && !Checks.esNulo(expediente.getOferta().getActivoPrincipal())
					&& !Checks.esNulo(expediente.getOferta().getActivoPrincipal().getSubcartera())
					&& DDSubcartera.CODIGO_BAN_BH
							.equals(expediente.getOferta().getActivoPrincipal().getSubcartera().getCodigo())) {
				if (!Checks.esNulo(comprador.getIdCompradorUrsusBh())) {
					numURSUS = comprador.getIdCompradorUrsusBh().intValue();
					if (!Checks.esNulo(numURSUS)) {
						ejecutarDatosCliente = uvemManagerApi.ejecutarDatosCliente(numURSUS,
								DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA_HABITAT);
					}
				}
			} else {
				if (!Checks.esNulo(comprador.getIdCompradorUrsus())) {
					numURSUS = comprador.getIdCompradorUrsus().intValue();
					if (!Checks.esNulo(numURSUS)) {
						ejecutarDatosCliente = uvemManagerApi.ejecutarDatosCliente(numURSUS,
								DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA);
					}
				}
			}

			// Comprobación de discrepancias
			List<DatosClienteProblemasVentaDto> problemasClienteUrsus = buscarProblemasVentaClienteUrsus(
					String.valueOf(numURSUS), String.valueOf(idExpediente));
			for (DatosClienteProblemasVentaDto datosClienteProblemasVentaDto : problemasClienteUrsus) {
				if (PROBLEMA.equals(datosClienteProblemasVentaDto.getTipoMensaje())) {
					problemasPorComprador = true;
					return true;
				} else if (AVISO.equals(datosClienteProblemasVentaDto.getTipoMensaje())
						&& TITULAR_NO_CLIENTE_URSUS.equals(datosClienteProblemasVentaDto.getLiavi1().toUpperCase())) {
					return false;
				}
			}
			if (!problemasPorComprador) {
				Filter filterCompradorExpedientePorComprador = genericDao.createFilter(FilterType.EQUALS, "comprador",
						comprador.getId());
				Filter filterCompradorExpedientePorExpediente = genericDao.createFilter(FilterType.EQUALS, "expediente",
						expediente.getId());
				CompradorExpediente compradorExpediente = genericDao.get(CompradorExpediente.class,
						filterCompradorExpedientePorComprador, filterCompradorExpedientePorExpediente);

				if (!Checks.esNulo(ejecutarDatosCliente) && !Checks.esNulo(compradorExpediente)) {
					if ((!Checks.esNulo(ejecutarDatosCliente.getCodigoEstadoCivil())
							&& !Character.isWhitespace(ejecutarDatosCliente.getCodigoEstadoCivil()))
							&& !Checks.esNulo(compradorExpediente.getEstadoCivil())) {
						String codigoEstadoCivilUrsus = getCodigoEstadoCivilUrsusRem(
								String.valueOf(ejecutarDatosCliente.getCodigoEstadoCivil()));
						if (!codigoEstadoCivilUrsus.equals(compradorExpediente.getEstadoCivil().getCodigo())
								&& (DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO.equals(codigoEstadoCivilUrsus)
										|| DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO
												.equals(compradorExpediente.getEstadoCivil().getCodigo()))) {
							return true;
						} else {
							String codigoRegistroEconomicoUrsus = getCodigoRegistroEconomicoMatrimonialURSUS(
									ejecutarDatosCliente);
							if ((!Checks.esNulo(compradorExpediente.getRegimenMatrimonial())
									&& !Checks.esNulo(codigoRegistroEconomicoUrsus))) {
								if ((DDRegimenesMatrimoniales.COD_GANANCIALES
										.equals(compradorExpediente.getRegimenMatrimonial().getCodigo())
										&& !compradorExpediente.getRegimenMatrimonial().getCodigo()
												.equals(codigoRegistroEconomicoUrsus))
										|| (DDRegimenesMatrimoniales.COD_GANANCIALES
												.equals(codigoRegistroEconomicoUrsus)
												&& !codigoRegistroEconomicoUrsus.equals(
														compradorExpediente.getRegimenMatrimonial().getCodigo()))) {
									return true;
								} else {
									// Filter filterCOmpradorExpediente = genericDao.createFilter(FilterType.EQUALS,
									// "id", comprador.getId());
									// CompradorExpediente compradorExpediente =
									// genericDao.get(CompradorExpediente.class, filterCOmpradorExpediente);

									if (!Checks.esNulo(expediente.getOferta())
											&& !Checks.esNulo(expediente.getOferta().getActivoPrincipal())
											&& !Checks
													.esNulo(expediente.getOferta().getActivoPrincipal().getSubcartera())
											&& DDSubcartera.CODIGO_BAN_BH.equals(expediente.getOferta()
													.getActivoPrincipal().getSubcartera().getCodigo())) {
										if (!Checks.esNulo(ejecutarDatosCliente.getNumeroClienteUrsusConyuge())
												&& !Checks.esNulo(compradorExpediente)
												&& !Checks.esNulo(compradorExpediente.getNumUrsusConyuge())
												&& !ejecutarDatosCliente.getNumeroClienteUrsusConyuge().equals(
														String.valueOf(compradorExpediente.getNumUrsusConyugeBh()))) {
											return true;
										}
									} else {
										if (!Checks.esNulo(ejecutarDatosCliente.getNumeroClienteUrsusConyuge())
												&& !Checks.esNulo(compradorExpediente)
												&& !Checks.esNulo(compradorExpediente.getNumUrsusConyuge())
												&& !ejecutarDatosCliente.getNumeroClienteUrsusConyuge().equals(
														String.valueOf(compradorExpediente.getNumUrsusConyuge()))) {
											return true;
										}
									}
								}
							} else {
								// comprobamos si alguno esta casado devolvemos error porque no coinciden los
								// regimenes o estan vacios
								if (DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO.equals(codigoEstadoCivilUrsus)
										|| DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO
												.equals(compradorExpediente.getEstadoCivil().getCodigo())) {
									if (DDRegimenesMatrimoniales.COD_GANANCIALES
											.equals(compradorExpediente.getRegimenMatrimonial().getCodigo())) {
										return true;
									}
								}
								return false;
							}
						}
					} else {
						if (DDTipoPersona.CODIGO_TIPO_PERSONA_FISICA.equals(comprador.getTipoPersona().getCodigo())) {
							return true;
						}

					}
				} else {
					return true;
				}
			}
		} else {
			return false;
		}
		return false;
	}

	public String getCodigoEstadoCivilUrsusRem(String codigoUrsusEstadoCivil) {
		String codigo = NO_EXISTE_CODIGO_REM;
		if (SOLTERO.equals(codigoUrsusEstadoCivil)) {
			codigo = DDEstadosCivilesURSUS.CODIGO_ESTADO_CIVIL_SOLTERO;
		} else if (CASADO.equals(codigoUrsusEstadoCivil)) {
			codigo = DDEstadosCivilesURSUS.CODIGO_ESTADO_CIVIL_CASADO;
		} else if (VIUDO.equals(codigoUrsusEstadoCivil)) {
			codigo = DDEstadosCivilesURSUS.CODIGO_ESTADO_CIVIL_VIUDO;
		} else if (DIVORCIADO.equals(codigoUrsusEstadoCivil)) {
			codigo = DDEstadosCivilesURSUS.CODIGO_ESTADO_CIVIL_DIVORCIADO;
		} else if (DESCONOCIDO.equals(codigoUrsusEstadoCivil)) {
			codigo = DDEstadosCivilesURSUS.CODIGO_ESTADO_DESCONOCIDO;
		} else if (SEPARADO_LEGAL.equals(codigoUrsusEstadoCivil)) {
			codigo = DDEstadosCivilesURSUS.CODIGO_ESTADO_SEPARADO_LEGAL;
		} else if (RELIGIOSO.equals(codigoUrsusEstadoCivil)) {
			codigo = DDEstadosCivilesURSUS.CODIGO_ESTADO_RELIGIOSO;
		} else if (NULIDAD_MATRIMONIAL.equals(codigoUrsusEstadoCivil)) {
			codigo = DDEstadosCivilesURSUS.CODIGO_ESTADO_NULIDAD_MATRIMONIAL;
		}

		return codigo;

	}

	public String getCodigoRegistroEconomicoMatrimonialURSUS(DatosClienteDto ejecutarDatosCliente) {
		String codigoRegistroEconomico = NO_EXISTE_CODIGO_REM;
		if (!Checks.esNulo(ejecutarDatosCliente.getCodigoEstadoCivil())) {
			if (CASADO.equals(String.valueOf(ejecutarDatosCliente.getCodigoEstadoCivil()))) {
				if (Checks.esNulo(ejecutarDatosCliente.getNumeroClienteUrsusConyuge())
						|| "0".equals(ejecutarDatosCliente.getNumeroClienteUrsusConyuge())) {
					codigoRegistroEconomico = DDRegimenesMatrimoniales.COD_SEPARACION_BIENES;
				} else {
					codigoRegistroEconomico = DDRegimenesMatrimoniales.COD_GANANCIALES;
				}
			}
		}
		return codigoRegistroEconomico;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean hayProblemasURSUS(Long idExpediente) {

		Filter filterExpediente = genericDao.createFilter(FilterType.EQUALS, "id", idExpediente);

		Boolean hayProblemasUrsus = false;
		ExpedienteComercial expedienteComercial = genericDao.get(ExpedienteComercial.class, filterExpediente);
		if (!Checks.esNulo(expedienteComercial)) {
			List<CompradorExpediente> compradores = expedienteComercial.getCompradores();
			if (!Checks.estaVacio(compradores)) {
				for (CompradorExpediente compradorExpediente : compradores) {
					Filter filterComprador = genericDao.createFilter(FilterType.EQUALS, "id",
							compradorExpediente.getComprador());
					Comprador comprador = genericDao.get(Comprador.class, filterComprador);
					if (!Checks.esNulo(comprador)) {
						if (!Checks.esNulo(comprador.getProblemasUrsus())) {
							hayProblemasUrsus = comprador.getProblemasUrsus();
							if (hayProblemasUrsus)
								break;
						} else {
							hayProblemasUrsus = false;
						}
					}
				}
			}
		}
		return hayProblemasUrsus;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean checkDiscrepanciasUrsus(Long idTramite) {
		Filter filtroTramite = genericDao.createFilter(FilterType.EQUALS, "id", idTramite);
		ActivoTramite tramite = genericDao.get(ActivoTramite.class, filtroTramite);
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialPorOferta(ofertaAceptada.getId());
			return hayDiscrepanciasClientesURSUS(expediente.getId());
		}
		return false;
	}

	@Transactional(readOnly = false)
	private void crearTareaValidacionClientes(ExpedienteComercial expedienteComercial) {
		Boolean existeTareaValidacion = false;
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		ActivoTramite tramite = tramiteDao
				.getTramiteComercialVigenteByTrabajo(expedienteComercial.getTrabajo().getId());
		List<TareaProcedimiento> tareasActivas = activoTramiteApi.getTareasActivasByIdTramite(tramite.getId());
		for (TareaProcedimiento tarea : tareasActivas) {
			if (tarea.getCodigo().equals(ComercialUserAssigantionService.CODIGO_T013_VALIDACION_CLIENTES)) {
				existeTareaValidacion = true;
			} else {
				existeTareaValidacion = false;
			}
		}

		if (!existeTareaValidacion) {
			tramiteDao.creaTareaValidacion(usuarioLogado.getUsername(),
					expedienteComercial.getNumExpediente().toString());
			Usuario gestor = gestorActivoApi.getGestorByActivoYTipo(tramite.getActivo(),
					GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			TareaNotificacion tarNot;
			List<TareaExterna> tareasActivas2 = activoTramiteApi
					.getListaTareaExternaActivasByIdTramite(tramite.getId());
			for (TareaExterna tarea : tareasActivas2) {
				if (tarea.getTareaProcedimiento().getCodigo()
						.equals(ComercialUserAssigantionService.CODIGO_T013_VALIDACION_CLIENTES)) {
					tarNot = tarea.getTareaPadre();
					if (!Checks.esNulo(tarNot)) {
						TareaActivo tac = genericDao.get(TareaActivo.class,
								genericDao.createFilter(FilterType.EQUALS, "id", tarNot.getId()));
						Auditoria au = tac.getAuditoria();

						if (!Checks.esNulo(tac)) {
							au.setFechaModificar(new Date());
							au.setUsuarioModificar(usuarioLogado.getUsername());
							if (!Checks.esNulo(gestor)) {
								tac.setUsuario(gestor);
							} else {
								tac.setUsuario(usuarioLogado);
							}
							tac.setAuditoria(au);
							tarNot.setAuditoria(Auditoria.getNewInstance());
							genericDao.update(TareaActivo.class, tac);
							genericDao.update(TareaNotificacion.class, tarNot);
						} else {
							TareaActivo tacNuevo = new TareaActivo();
							tacNuevo.setActivo(tramite.getActivo());
							tacNuevo.setId(tarNot.getId());
							tacNuevo.setTramite(tramite);
							tacNuevo.setAuditoria(Auditoria.getNewInstance());

							if (!Checks.esNulo(gestor)) {
								tacNuevo.setUsuario(gestor);
							} else {
								tacNuevo.setUsuario(usuarioLogado);
							}
							genericDao.save(TareaActivo.class, tacNuevo);
						}
					}

				}
			}
		}
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean modificarDatosUnCompradorProblemasURSUS(DtoSlideDatosCompradores dto) throws Exception {
		if (!DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO.equals(dto.getCodEstadoCivil())) {
			dto.setCodigoRegimenMatrimonial(null);
		}
		Boolean problemasPorComprador = false;
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class,
				genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdExpedienteComercial()));
		if (!Checks.esNulo(dto.getId())) {
			Comprador comprador = genericDao.get(Comprador.class,
					genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));
			Filter filterCompradorExpedientePorComprador = genericDao.createFilter(FilterType.EQUALS, "comprador",
					comprador.getId());
			Filter filterCompradorExpedientePorExpediente = genericDao.createFilter(FilterType.EQUALS, "expediente",
					expediente.getId());
			CompradorExpediente compradorExpediente = genericDao.get(CompradorExpediente.class,
					filterCompradorExpedientePorComprador, filterCompradorExpedientePorExpediente);
			Integer numURSUS = null;
			DatosClienteDto ejecutarDatosCliente = null;
			if (!Checks.esNulo(expediente.getOferta()) && !Checks.esNulo(expediente.getOferta().getActivoPrincipal())
					&& !Checks.esNulo(expediente.getOferta().getActivoPrincipal().getSubcartera())
					&& DDSubcartera.CODIGO_BAN_BH
							.equals(expediente.getOferta().getActivoPrincipal().getSubcartera().getCodigo())) {
				if (!Checks.esNulo(comprador.getIdCompradorUrsusBh())) {
					numURSUS = comprador.getIdCompradorUrsusBh().intValue();
					if (!Checks.esNulo(numURSUS)) {
						ejecutarDatosCliente = uvemManagerApi.ejecutarDatosCliente(numURSUS,
								DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA_HABITAT);
					}
				}
			} else {
				if (!Checks.esNulo(comprador.getIdCompradorUrsus())) {
					numURSUS = comprador.getIdCompradorUrsus().intValue();
					if (!Checks.esNulo(numURSUS)) {
						ejecutarDatosCliente = uvemManagerApi.ejecutarDatosCliente(numURSUS,
								DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA);
					}
				}
			}

			if (!Checks.esNulo(numURSUS)) {

				// GuardarEstadoCivilURSUS
				if (!Checks.esNulo(ejecutarDatosCliente)) {
					String codigoParaGuardarEstadoCivilURSUS = getCodigoEstadoCivilUrsusRem(
							String.valueOf(ejecutarDatosCliente.getCodigoEstadoCivil()));
					if (codigoParaGuardarEstadoCivilURSUS != NO_EXISTE_CODIGO_REM) {
						DDEstadosCivilesURSUS estadoCivilURSUS = genericDao.get(DDEstadosCivilesURSUS.class, genericDao
								.createFilter(FilterType.EQUALS, "codigo", codigoParaGuardarEstadoCivilURSUS));
						comprador.setEstadoCivilURSUS(estadoCivilURSUS.getId());
					} else {
						comprador.setEstadoCivilURSUS(null);
					}
					// GuardarRegistroMatrimonialURSUS
					String codigoParaGuardarRegistroMatrimonialURSUS = getCodigoRegistroEconomicoMatrimonialURSUS(
							ejecutarDatosCliente);
					if (codigoParaGuardarRegistroMatrimonialURSUS != NO_EXISTE_CODIGO_REM) {
						DDRegimenesMatrimoniales regimenMatrimonialURSUS = genericDao
								.get(DDRegimenesMatrimoniales.class, genericDao.createFilter(FilterType.EQUALS,
										"codigo", codigoParaGuardarRegistroMatrimonialURSUS));
						comprador.setRegimenMatrimonialUrsus(regimenMatrimonialURSUS.getId());
					} else {
						comprador.setRegimenMatrimonialUrsus(null);
					}
					// Guardar numero conyuge URSUS
					comprador.setNumeroConyugeUrsus(
							Integer.parseInt(ejecutarDatosCliente.getNumeroClienteUrsusConyuge()));

					if (!Checks.esNulo(ejecutarDatosCliente.getNombreYApellidosConyuge())) {
						comprador.setNombreConyugeURSUS(ejecutarDatosCliente.getNombreYApellidosConyuge());
					}

					if (!Checks.esNulo(dto.getNumeroClienteUrsusConyuge())) {
						compradorExpediente.setNumUrsusConyuge(Integer.parseInt(dto.getNumeroClienteUrsusConyuge()));
					}
					if (!Checks.esNulo(dto.getNumeroClienteUrsusBhConyuge())) {
						compradorExpediente
								.setNumUrsusConyugeBh(Integer.parseInt(dto.getNumeroClienteUrsusBhConyuge()));
					}

					genericDao.update(Comprador.class, comprador);
				}
			}

			if (!Checks.esNulo(numURSUS)) {

				// Comprobación de discrepancias
				List<DatosClienteProblemasVentaDto> problemasClienteUrsus = buscarProblemasVentaClienteUrsus(
						String.valueOf(numURSUS), String.valueOf(dto.getIdExpedienteComercial()));
				for (DatosClienteProblemasVentaDto datosClienteProblemasVentaDto : problemasClienteUrsus) {
					if (PROBLEMA.equals(datosClienteProblemasVentaDto.getTipoMensaje())) {
						problemasPorComprador = true;
						comprador.setProblemasUrsus(true);
						crearTareaValidacionClientes(expediente);
						genericDao.update(Comprador.class, comprador);
						return true;
					} else if (AVISO.equals(datosClienteProblemasVentaDto.getTipoMensaje()) && TITULAR_NO_CLIENTE_URSUS
							.equals(datosClienteProblemasVentaDto.getLiavi1().toUpperCase())) {
						comprador.setProblemasUrsus(false);
						finalizarTareaValidacionClientes(expediente);
						genericDao.update(Comprador.class, comprador);
						return false;
					}
				}
				if (!problemasPorComprador) {
					if (!Checks.esNulo(ejecutarDatosCliente)) {
						if ((!Checks.esNulo(ejecutarDatosCliente.getCodigoEstadoCivil())
								&& !Character.isWhitespace(ejecutarDatosCliente.getCodigoEstadoCivil()))
								&& !Checks.esNulo(dto.getCodEstadoCivil())) {
							String codigoEstadoCivilUrsus = getCodigoEstadoCivilUrsusRem(
									String.valueOf(ejecutarDatosCliente.getCodigoEstadoCivil()));
							if (!codigoEstadoCivilUrsus.equals(dto.getCodEstadoCivil())
									&& (DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO.equals(codigoEstadoCivilUrsus)
											|| DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO
													.equals(dto.getCodEstadoCivil()))) {
								comprador.setProblemasUrsus(true);
								crearTareaValidacionClientes(expediente);
								genericDao.update(Comprador.class, comprador);
								return true;
							} else {
								String codigoRegistroEconomicoUrsus = getCodigoRegistroEconomicoMatrimonialURSUS(
										ejecutarDatosCliente);
								if (!Checks.esNulo(dto.getCodigoRegimenMatrimonial())
										&& !NO_EXISTE_CODIGO_REM.equals(codigoRegistroEconomicoUrsus)) {
									if ((DDRegimenesMatrimoniales.COD_GANANCIALES
											.equals(dto.getCodigoRegimenMatrimonial())
											&& !dto.getCodigoRegimenMatrimonial().equals(codigoRegistroEconomicoUrsus))
											|| (DDRegimenesMatrimoniales.COD_GANANCIALES
													.equals(codigoRegistroEconomicoUrsus)
													&& !codigoRegistroEconomicoUrsus
															.equals(dto.getCodigoRegimenMatrimonial()))) {
										comprador.setProblemasUrsus(true);
										crearTareaValidacionClientes(expediente);
										genericDao.update(Comprador.class, comprador);
										return true;
									} else {
										if (!Checks.esNulo(expediente.getOferta())
												&& !Checks.esNulo(expediente.getOferta().getActivoPrincipal())
												&& !Checks.esNulo(
														expediente.getOferta().getActivoPrincipal().getSubcartera())
												&& DDSubcartera.CODIGO_BAN_BH.equals(expediente.getOferta()
														.getActivoPrincipal().getSubcartera().getCodigo())) {
											if (!Checks.esNulo(ejecutarDatosCliente.getNumeroClienteUrsusConyuge())
													&& !ejecutarDatosCliente.getNumeroClienteUrsusConyuge()
															.equals(dto.getNumeroClienteUrsusBhConyuge())) {
												comprador.setProblemasUrsus(true);
												crearTareaValidacionClientes(expediente);
												genericDao.update(Comprador.class, comprador);
												return true;
											}
										} else {
											if (!Checks.esNulo(ejecutarDatosCliente.getNumeroClienteUrsusConyuge())
													&& !ejecutarDatosCliente.getNumeroClienteUrsusConyuge()
															.equals(dto.getNumeroClienteUrsusConyuge())) {
												comprador.setProblemasUrsus(true);
												crearTareaValidacionClientes(expediente);
												genericDao.update(Comprador.class, comprador);
												return true;
											}
										}
									}
								} else {
									// comprobamos si alguno esta casado devolvemos error porque no coinciden los
									// regimenes o estan vacios
									if (DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO.equals(codigoEstadoCivilUrsus)
											|| DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO
													.equals(dto.getCodEstadoCivil())) {
										if (DDRegimenesMatrimoniales.COD_GANANCIALES
												.equals(dto.getCodigoRegimenMatrimonial())) {
											comprador.setProblemasUrsus(true);
											crearTareaValidacionClientes(expediente);
											comprador.setProblemasUrsus(true);
											genericDao.update(Comprador.class, comprador);
											return true;
										}
									}
									comprador.setProblemasUrsus(false);
									finalizarTareaValidacionClientes(expediente);
									genericDao.update(Comprador.class, comprador);
									return false;
								}
							}
						} else {
							if (DDTiposPersona.CODIGO_TIPO_PERSONA_JURIDICA
									.equals(comprador.getTipoPersona().getCodigo())) {
								comprador.setProblemasUrsus(false);
								crearTareaValidacionClientes(expediente);
								comprador.setProblemasUrsus(false);
								genericDao.update(Comprador.class, comprador);
								return false;
							} else {
								comprador.setProblemasUrsus(true);
								crearTareaValidacionClientes(expediente);
								comprador.setProblemasUrsus(true);
								genericDao.update(Comprador.class, comprador);
								return true;
							}
						}
					} else {
						comprador.setProblemasUrsus(true);
						crearTareaValidacionClientes(expediente);
						comprador.setProblemasUrsus(true);
						genericDao.update(Comprador.class, comprador);
						return true;
					}
				}
			} else {
				comprador.setProblemasUrsus(false);
				finalizarTareaValidacionClientes(expediente);
				genericDao.update(Comprador.class, comprador);
				return false;
			}
			comprador.setProblemasUrsus(false);
			finalizarTareaValidacionClientes(expediente);
			genericDao.update(Comprador.class, comprador);
			return false;
		}
		return null;
	}

	@Override
	@Transactional(readOnly = false)
	public void finalizarTareaValidacionClientes(ExpedienteComercial expedienteComercial) {
		TareaNotificacion tarNot = null;
		ActivoTramite tramite = tramiteDao
				.getTramiteComercialVigenteByTrabajo(expedienteComercial.getTrabajo().getId());
		if (!Checks.esNulo(tramite)) {
			List<TareaExterna> tareasActivas = activoTramiteApi.getListaTareaExternaActivasByIdTramite(tramite.getId());
			if (tareasActivas != null && !tareasActivas.isEmpty()) {
				for (TareaExterna tarea : tareasActivas) {
					if (tarea != null && tarea.getTareaProcedimiento() != null
							&& ComercialUserAssigantionService.CODIGO_T013_VALIDACION_CLIENTES
									.equals(tarea.getTareaProcedimiento().getCodigo())) {
						tarNot = tarea.getTareaPadre();
						if (!Checks.esNulo(tarNot)) {
							tarNot.setFechaFin(new Date());

							Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
							if (!Checks.esNulo(usuarioLogado)) {
								tarNot.getAuditoria().setUsuarioBorrar(usuarioLogado.getUsername());
								tarNot.getAuditoria().setFechaBorrar(new Date());
								tarNot.getAuditoria().setBorrado(true);

								genericDao.update(TareaNotificacion.class, tarNot);
							}
						}

					}
				}
			}
			genericaRestDaoImp.doFlush();
		}
	}

	@Override
	public boolean existeComprador(String numDoc) {
		if (!Checks.esNulo(numDoc)) {
			Filter filterComprador = genericDao.createFilter(FilterType.EQUALS, "documento", numDoc);
			Comprador comprador = genericDao.get(Comprador.class, filterComprador);
			if (!Checks.esNulo(comprador)) {
				return true;
			}
		}
		return false;
	}

	@Override
	public List<DtoDiccionario> calcularGestorComercialPrescriptor(Long idExpediente) {
		Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "id", idExpediente);
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtroExpediente);
		Boolean isMinoristaOResidencial = false;
		if (expediente != null) {
			Oferta ofr = expediente.getOferta();
			if (ofr != null) {
				List<ActivoOferta> listadoActivos = ofr.getActivosOferta();
				if (listadoActivos.size() > 1) {
					for (int i = 0; i < listadoActivos.size(); i++) {
						if (listadoActivos.get(i).getPrimaryKey() != null) {
							Activo act = listadoActivos.get(i).getPrimaryKey().getActivo();
							if (act != null) {
								if (!Checks.esNulo(ofr.getActivoPrincipal().getEquipoGestion())) {
									if (DDEquipoGestion.CODIGO_MINORISTA
											.equals(ofr.getActivoPrincipal().getEquipoGestion().getCodigo())) {
										return calcularGestorComercialPrescriptorResidencial(expediente,
												listadoActivos);
									}
								} else if (!Checks.esNulo(ofr.getActivoPrincipal().getTipoComercializar())
										&& DDTipoComercializar.CODIGO_RETAIL
												.equals(ofr.getActivoPrincipal().getTipoComercializar().getCodigo())) {
									return calcularGestorComercialPrescriptorResidencial(expediente, listadoActivos);
								}
							}
						}
					}
				} else if (listadoActivos.size() == 1) {
					if (listadoActivos.get(0).getPrimaryKey() != null) {
						Activo act = listadoActivos.get(0).getPrimaryKey().getActivo();
						if (act != null)
							if (!Checks.esNulo(ofr.getActivoPrincipal().getEquipoGestion())) {
								if (DDEquipoGestion.CODIGO_MINORISTA
										.equals(ofr.getActivoPrincipal().getEquipoGestion().getCodigo())) {
									isMinoristaOResidencial = true;
								}
							} else if (!Checks.esNulo(ofr.getActivoPrincipal().getTipoComercializar())
									&& DDTipoComercializar.CODIGO_RETAIL
											.equals(ofr.getActivoPrincipal().getTipoComercializar().getCodigo())) {
								isMinoristaOResidencial = true;
							}
						if (isMinoristaOResidencial) {
							return calcularGestorComercialPrescriptorResidencial(expediente, listadoActivos);
						} else if (Checks.esNulo(ofr.getAgrupacion())) {
							List<DtoDiccionario> listado = new ArrayList<DtoDiccionario>();
							DtoDiccionario diccionario = new DtoDiccionario();
							diccionario = new DtoDiccionario();
							Usuario gestorComercialPrescriptor = gestorActivoApi.getGestorByActivoYTipo(act,
									GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
							if(gestorComercialPrescriptor != null) {
								diccionario.setDescripcion(gestorComercialPrescriptor.getApellidoNombre());
								diccionario.setCodigo(gestorComercialPrescriptor.getId().toString());
							}
							listado.add(diccionario);
							return listado;
						}
					}
				}
			}
		}
		return GestorComercialPrescriptorParaOfertaAgrupacionSingular();
	}

	private List<DtoDiccionario> GestorComercialPrescriptorParaOfertaAgrupacionSingular() {
		List<DtoDiccionario> listado = new ArrayList<DtoDiccionario>();
		DtoDiccionario diccionario = new DtoDiccionario();
		diccionario.setDescripcion(OFERTA_NA_LOTE);
		diccionario.setCodigo(OFERTA_DICCIONARIO_CODIGO_NULO);
		listado.add(diccionario);
		return listado;
	}

	private List<DtoDiccionario> calcularGestorComercialPrescriptorResidencial(ExpedienteComercial expediente,
			List<ActivoOferta> listaActivosOferta) {
		List<DtoDiccionario> listado = new ArrayList<DtoDiccionario>();
		DtoDiccionario diccionario = null;
		boolean minoristaRetail = false;
		boolean prescriptorOficina = false;
		String apellidosNombre;
		String codigo;
		Activo activo = null;
		Usuario gestorComercialPrescriptor = null;

		if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getOferta())) {
			Oferta oferta = expediente.getOferta();
			gestorComercialPrescriptor = oferta.getGestorComercialPrescriptor();

			if (!Checks.esNulo(oferta.getPrescriptor()) && !Checks.esNulo(oferta.getPrescriptor().getTipoProveedor()))
				prescriptorOficina = DDTipoProveedor.COD_OFICINA_CAJAMAR
						.equals(oferta.getPrescriptor().getTipoProveedor().getCodigo());

			if (!Checks.esNulo(oferta.getActivoPrincipal())
					&& !Checks.esNulo(oferta.getActivoPrincipal().getEquipoGestion())) {
				if (DDEquipoGestion.CODIGO_MINORISTA
						.equals(oferta.getActivoPrincipal().getEquipoGestion().getCodigo())) {
					minoristaRetail = true;
				}
			} else if (!Checks.esNulo(oferta.getActivoPrincipal())
					&& !Checks.esNulo(oferta.getActivoPrincipal().getTipoComercializar())
					&& DDTipoComercializar.CODIGO_RETAIL
							.equals(oferta.getActivoPrincipal().getTipoComercializar().getCodigo())) {
				minoristaRetail = true;
			}

			if (Checks.esNulo(gestorComercialPrescriptor)) {
				if (minoristaRetail && prescriptorOficina) {
					diccionario = new DtoDiccionario();
					diccionario.setDescripcion(OFERTA_SIN_GESTOR_COMERCIAL_ASIGNADO);
					diccionario.setCodigo(OFERTA_DICCIONARIO_CODIGO_NULO);
					listado.add(diccionario);
				} else {
					diccionario = new DtoDiccionario();
					diccionario.setDescripcion(OFERTA_NA_LOTE);
					diccionario.setCodigo(OFERTA_DICCIONARIO_CODIGO_NULO);
					listado.add(diccionario);
				}
			} else {
				if (minoristaRetail && prescriptorOficina) {
					diccionario = new DtoDiccionario();
					apellidosNombre = gestorComercialPrescriptor.getApellidoNombre();
					codigo = gestorComercialPrescriptor.getId().toString();
					diccionario.setDescripcion(apellidosNombre);
					diccionario.setCodigo(!Checks.esNulo(codigo) ? codigo : OFERTA_DICCIONARIO_CODIGO_NULO);
					listado.add(diccionario);
				} else {
					if (!Checks.estaVacio(listaActivosOferta)) {
						for (ActivoOferta activoOferta : listaActivosOferta) {
							diccionario = new DtoDiccionario();
							activo = activoOferta.getPrimaryKey().getActivo();
							if (!Checks.esNulo(activo) && !Checks.esNulo(gestorActivoApi.getGestorByActivoYTipo(activo,
									GestorActivoApi.CODIGO_GESTOR_COMERCIAL))) {
								gestorComercialPrescriptor = gestorActivoApi.getGestorByActivoYTipo(activo,
										GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
								if (!Checks.esNulo(gestorComercialPrescriptor)) {
									apellidosNombre = gestorComercialPrescriptor.getApellidoNombre();
									codigo = gestorComercialPrescriptor.getId().toString();
									diccionario.setDescripcion(apellidosNombre);
									diccionario.setCodigo(
											!Checks.esNulo(codigo) ? codigo : OFERTA_DICCIONARIO_CODIGO_NULO);

									if (Checks.estaVacio(listado)) {
										listado.add(diccionario);
									} else if (!listado.get(0).getCodigo().equals(diccionario.getCodigo())) {
										listado.clear();
										break;
									}
								}
							}
						}
					}
					diccionario = new DtoDiccionario();
					diccionario.setDescripcion(OFERTA_NA_LOTE);
					diccionario.setCodigo(OFERTA_DICCIONARIO_CODIGO_NULO);
					listado.add(diccionario);
				}
			}
		}
		return listado;
	}

	@Override
	public List<VReportAdvisoryNotes> getAdvisoryNotesByOferta(Oferta oferta) {
		List<VReportAdvisoryNotes> listaAN = new ArrayList<VReportAdvisoryNotes>();

		listaAN = genericDao.getList(VReportAdvisoryNotes.class,
				genericDao.createFilter(FilterType.EQUALS, "numOferta", oferta.getNumOferta()));

		return listaAN;
	}

	@Override
	public boolean esYubai(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		boolean esYubai = false;
		if (!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getOferta())) {
			Activo activo = expedienteComercial.getOferta().getActivoPrincipal();
			if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getCartera())
					&& !Checks.esNulo(activo.getSubcartera())) {
				esYubai = (DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(activo.getCartera().getCodigo())
						&& DDSubcartera.CODIGO_YUBAI.equals(activo.getSubcartera().getCodigo()));
			}
		}
		return esYubai;
	}

	@Override
	public boolean esOmega(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		boolean esOmega = false;
		if (!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getOferta())) {
			Activo activo = expedienteComercial.getOferta().getActivoPrincipal();
			if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getCartera())
					&& !Checks.esNulo(activo.getSubcartera())) {
				esOmega = (DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(activo.getCartera().getCodigo())
						&& DDSubcartera.CODIGO_OMEGA.equals(activo.getSubcartera().getCodigo()));
			}
		}
		return esOmega;
	}

	@Override
	public List<VListadoOfertasAgrupadasLbk> getListActivosAgrupacionById(Long idOferta) {

		List<VListadoOfertasAgrupadasLbk> listaOfertasAgrupadas = new ArrayList<VListadoOfertasAgrupadasLbk>();
		Oferta oferta = ofertaApi.getOfertaById(idOferta);
		if (!Checks.esNulo(oferta)) {
			listaOfertasAgrupadas = expedienteComercialDao.getListActivosOfertaPrincipal(oferta.getNumOferta());
		}

		return listaOfertasAgrupadas;
	}

	public boolean isOfertaDependiente(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		boolean esOfertaDependiente = false;
		if (!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getOferta().getClaseOferta())
				&& DDCartera.CODIGO_CARTERA_LIBERBANK
						.equals(expedienteComercial.getOferta().getActivoPrincipal().getCartera().getCodigo())) {
			if ((T013_RESOLUCION_COMITE.equals(tareaExterna.getTareaProcedimiento().getCodigo()) 
					|| T013_DEFINICION_OFERTA.equals(tareaExterna.getTareaProcedimiento().getCodigo()))
				&& DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(expedienteComercial.getOferta().getClaseOferta().getCodigo())) {

				esOfertaDependiente = !permiteAvanzarOfertaDependiente(expedienteComercial, tareaExterna.getTareaProcedimiento().getCodigo());

			} else if (DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE
					.equals(expedienteComercial.getOferta().getClaseOferta().getCodigo())) {
				esOfertaDependiente = true;
			}
		}
		return esOfertaDependiente;

	}

	public DDComiteSancion comitePropuestoByIdExpediente(Long idExpediente) throws Exception {

		try {
			ExpedienteComercial expediente = findOne(idExpediente);

			return expediente.getComitePropuesto();

		} catch (JsonViewerException jve) {
			logger.info("error controlado en expedienteComercialManager.comitePropuestoByIdExpediente", jve);
			throw jve;
		} catch (Exception e) {
			logger.error("error en expedienteComercialManager.comitePropuestoByIdExpediente", e);
			throw e;
		}
	}

	@Override
	public DDComiteSancion comitePropuestoByIdOferta(Long idOferta) throws Exception {

		try {
			ExpedienteComercial expediente = expedienteComercialPorOferta(idOferta);

			return comitePropuestoByIdExpediente(expediente.getId());

		} catch (JsonViewerException jve) {
			logger.info("error controlado en expedienteComercialManager.comitePropuestoByIdOferta", jve);
			throw jve;
		} catch (Exception e) {
			logger.error("error en expedienteComercialManager.comitePropuestoByIdOferta", e);
			throw e;
		}
	}

	@Override
	public boolean esOfertaDependiente(Long oferta) {
		if (!Checks.esNulo(oferta)) {
			Oferta ofr = ofertaApi.getOfertaById(oferta);
			if (!Checks.esNulo(ofr) && !Checks.esNulo(ofr.getClaseOferta()))
				return DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(ofr.getClaseOferta().getCodigo());
			else
				return false;
		} else {
			return false;
		}
	}

	@Override
	public DtoOferta searchOfertaCodigo(String numOferta, String id, String esAgrupacion) {

		long numeroOferta;
		long idEntidad;
		boolean esUnaAgrupacion;
		boolean esOfertaPrincipal;
		try {
			esUnaAgrupacion = Boolean.parseBoolean(esAgrupacion);

			numeroOferta = Long.parseLong(numOferta);
			idEntidad = Long.parseLong(id);

			DtoOferta dtoOferta = new DtoOferta();
			Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(numeroOferta);
			esOfertaPrincipal = ofertaApi.isOfertaPrincipal(oferta);
			beanUtilNotNull.copyProperties(dtoOferta, oferta);

			if (DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())) {
				throw new JsonViewerException(
						"La oferta seleccionada es de alquiler, no se puede agrupar con este tipo de ofertas");
			}

			if(!Checks.esNulo(esOfertaPrincipal) && !esOfertaPrincipal){
				throw new JsonViewerException("La oferta que buscas no es una oferta principal");
			}


			if(!Checks.esNulo(oferta)){
				ExpedienteComercial eco = expedienteComercialDao.getExpedienteComercialByIdOferta(oferta.getId());

				if (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(oferta.getActivoPrincipal().getCartera().getCodigo())
						&& DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo())
						&& (DDEstadosExpedienteComercial.EN_TRAMITACION.equals(eco.getEstado().getCodigo())
								|| DDEstadosExpedienteComercial.PTE_SANCION.equals(eco.getEstado().getCodigo()))) {

					if (!esUnaAgrupacion && ofertaApi.activoYaIncluidoEnOfertaAgrupadaLbk(idEntidad, oferta)) {
						throw new JsonViewerException(
								"La oferta que estás intentando crear tiene un activo ya contenido en la agrupación.");
					}

					Long idTareaPadre = activoTareaExternaApi
							.getActivasByIdTramiteTodas(activoTramiteApi
									.getTramitesActivoTrabajoList(eco.getTrabajo().getId()).get(0).getId())
							.get(0).getTareaPadre().getId();

					Filter filtroTarea = genericDao.createFilter(FilterType.EQUALS, "tareaPadre.id", idTareaPadre);
					TareaExterna tareaExterna = genericDao.get(TareaExterna.class, filtroTarea);

					if (!Checks.esNulo(tareaExterna)) {
						TareaActivo tareaActivo = tareaActivoApi.getByIdTareaExterna(tareaExterna.getId());
						if (tareaActivo.getDescripcionTarea().equals("Definición oferta")) {
							return dtoOferta;
						}
					}
				}
			}

		} catch (NumberFormatException ex) {
			return null;
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage(), e);
			return null;
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage(), e);
			return null;
		}
		return null;
	}

	private Boolean permiteAvanzarOfertaDependiente(ExpedienteComercial eco, String codigoTarea) {
		Boolean permitir = false;

		List<VListadoOfertasAgrupadasLbk> vis = genericDao.getList(VListadoOfertasAgrupadasLbk.class,
				genericDao.createFilter(FilterType.EQUALS, "numOfertaDependiente", eco.getOferta().getNumOferta()));

		if (!Checks.estaVacio(vis)) {
			ExpedienteComercial ecoPrincipal = genericDao.get(ExpedienteComercial.class,
					genericDao.createFilter(FilterType.EQUALS, "oferta.numOferta", vis.get(0).getNumOfertaPrincipal()));

			if (!Checks.esNulo(ecoPrincipal)) {
				ActivoTramite tra = genericDao.get(ActivoTramite.class,
						genericDao.createFilter(FilterType.EQUALS, "trabajo", ecoPrincipal.getTrabajo()));

				if (!Checks.esNulo(tra) && ofertaApi.esTareaFinalizada(tra, codigoTarea)) {
					permitir = true;
				}
			}
		}

		return permitir;
	}

	@Override
	public boolean checkExpedienteFechaCheque(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);
		if (!Checks.esNulo(activoTramite) && !Checks.esNulo(activoTramite.getActivo())) {
			Trabajo trabajo = activoTramite.getTrabajo();
			if (!Checks.esNulo(trabajo)) {
				ExpedienteComercial expediente = expedienteComercialDao
						.getExpedienteComercialByIdTrabajo(trabajo.getId());
				return !Checks.esNulo(expediente.getFechaContabilizacionPropietario());
			}
		}
		return true;
	}

	public boolean fechaReservaPBCReserva(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		boolean fechaReserva = false;
		if (!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getOferta())
				&& !Checks.esNulo(expedienteComercial.getReserva().getFechaFirma())) {
			fechaReserva = true;

		}
		return fechaReserva;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean actualizarGastosExpediente(ExpedienteComercial expedienteComercial, Oferta oferta, Activo activo)
			throws IllegalAccessException, InvocationTargetException {
		gastosExpedienteApi.deleteGastosExpediente(expedienteComercial.getId());
		
		if (activo == null) {
			activo = oferta.getActivoPrincipal();
		}
		 

		List<DtoGastoExpediente> listDtoGastoExpediente = ofertaApi.calculaHonorario(oferta, activo,false);

		for (DtoGastoExpediente dtoGastoExpediente : listDtoGastoExpediente) {
			DDAccionGastos acciongasto = (DDAccionGastos) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDAccionGastos.class, dtoGastoExpediente.getCodigoTipoComision());

			GastosExpediente gastoExpediente = new GastosExpediente();

			if (acciongasto != null) {
				gastoExpediente.setAccionGastos(acciongasto);
			}

			if (!Checks.esNulo(dtoGastoExpediente.getCodigoTipoCalculo())) {
				DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoCalculo.class, dtoGastoExpediente.getCodigoTipoCalculo());
				gastoExpediente.setTipoCalculo(tipoCalculo);
			}

			if (!Checks.esNulo(dtoGastoExpediente.getIdProveedor())) {
				Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",
						dtoGastoExpediente.getIdProveedor());
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroProveedor);
				gastoExpediente.setProveedor(proveedor);

				DDTipoProveedorHonorario tipoProveedor = null;

				if (!Checks.esNulo(proveedor) && !Checks.esNulo(proveedor.getTipoProveedor())) {
					if (proveedor.getTipoProveedor().getCodigo().equals(DDTipoProveedorHonorario.CODIGO_MEDIADOR)) {
						tipoProveedor = (DDTipoProveedorHonorario) utilDiccionarioApi.dameValorDiccionarioByCod(
								DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_MEDIADOR);
					} else if (proveedor.getTipoProveedor().getCodigo().equals(DDTipoProveedorHonorario.CODIGO_FVD)) {
						tipoProveedor = (DDTipoProveedorHonorario) utilDiccionarioApi.dameValorDiccionarioByCod(
								DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_FVD);
					} else if (proveedor.getTipoProveedor().getCodigo()
							.equals(DDTipoProveedorHonorario.CODIGO_OFICINA_BANKIA)) {
						tipoProveedor = (DDTipoProveedorHonorario) utilDiccionarioApi.dameValorDiccionarioByCod(
								DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_OFICINA_BANKIA);
					} else if (proveedor.getTipoProveedor().getCodigo()
							.equals(DDTipoProveedorHonorario.CODIGO_OFICINA_CAJAMAR)) {
						tipoProveedor = (DDTipoProveedorHonorario) utilDiccionarioApi.dameValorDiccionarioByCod(
								DDTipoProveedorHonorario.class, DDTipoProveedorHonorario.CODIGO_OFICINA_CAJAMAR);
					}

					gastoExpediente.setTipoProveedor(tipoProveedor);
				}
			}

			gastoExpediente.setImporteCalculo(dtoGastoExpediente.getImporteCalculo());
			// Si el honorario es menor de 100 € el valor final será, salvo si el importe es
			// fijo, de 100 €. HREOS-5149
			if (dtoGastoExpediente.getHonorarios() < 100.00 && DDTipoOferta.isTipoAlquiler(oferta.getTipoOferta())
					&& !DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO_ALQ.equals(dtoGastoExpediente.getCodigoTipoCalculo())
					&& !DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO.equals(dtoGastoExpediente.getCodigoTipoCalculo())) {
				gastoExpediente.setImporteFinal(100.00);
			} else {
				gastoExpediente.setImporteFinal(dtoGastoExpediente.getHonorarios());
			}
			gastoExpediente.setImporteOriginal(dtoGastoExpediente.getImporteOriginal());
			gastoExpediente.setExpediente(expedienteComercial);
			gastoExpediente.setActivo(activo);

			gastoExpediente.setEditado(0);
			genericDao.save(GastosExpediente.class, gastoExpediente);

		}

		return true;
	}	
	
	@Override
	public String doCalculateComiteByExpedienteId(Long idExpediente) {
		if (idExpediente == null)
			return null;
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class,
				genericDao.createFilter(FilterType.EQUALS, "id", idExpediente));
		return expediente == null || expediente.getComiteSancion() == null ? null
				: expediente.getComiteSancion().getCodigo();
	}

	@Override
	public DtoOrigenLead getOrigenLeadList(Long idExpediente) {
		DtoOrigenLead dtoOrigenLead = new DtoOrigenLead();
		Boolean devolverOrigenLead = false;
		Oferta oferta = ofertaApi.getOfertaByIdExpediente(idExpediente);
		Visita visita = oferta.getVisita();

		DDOrigenComprador origenComprador = oferta.getOrigenComprador();

		if (!Checks.esNulo(origenComprador)) {
			dtoOrigenLead.setOrigenCompradorLead(origenComprador.getDescripcion());
			devolverOrigenLead = true;
		}

		if (!Checks.esNulo(oferta.getProveedorPrescriptorRemOrigenLead())) {
			dtoOrigenLead.setProveedorPrescriptorLead(oferta.getProveedorPrescriptorRemOrigenLead().getNombre());
			devolverOrigenLead = true;
		}

		if (!Checks.esNulo(oferta.getProveedorRealizadorRemOrigenLead())) {
			dtoOrigenLead.setProveedorRealizadorLead(oferta.getProveedorRealizadorRemOrigenLead().getNombre());
			devolverOrigenLead = true;
		}

		if (!Checks.esNulo(oferta.getFechaOrigenLead())) {
			String fechaOrigenLeadString = oferta.getFechaOrigenLead().toString();
			fechaOrigenLeadString = fechaOrigenLeadString.substring(0, 10);
			dtoOrigenLead.setFechaAltaLead(fechaOrigenLeadString);
			devolverOrigenLead = true;
		}

		if (!Checks.esNulo(visita)) {
			if (!Checks.esNulo(visita.getFechaReasignacionRealizadorOportunidad())) {
				String fechaReasignacionRealizadorOportunidadString = visita.getFechaReasignacionRealizadorOportunidad()
						.toString();
				fechaReasignacionRealizadorOportunidadString = fechaReasignacionRealizadorOportunidadString.substring(0,
						10);
				dtoOrigenLead.setFechaAsignacionRealizadorLead(fechaReasignacionRealizadorOportunidadString);
				devolverOrigenLead = true;
			} else {
				if (!Checks.esNulo(visita.getFechaSolicitud())) {
					String fechaSolicitudString = visita.getFechaSolicitud().toString();
					fechaSolicitudString = fechaSolicitudString.substring(0, 10);
					dtoOrigenLead.setFechaAsignacionRealizadorLead(fechaSolicitudString);
					devolverOrigenLead = true;
				}
			}
		}

		if (devolverOrigenLead) {
			return dtoOrigenLead;
		}

		return null;
	}
	
	@Override
	public List<DtoAuditoriaDesbloqueo> getAuditoriaDesbloqueoList(Long idExpediente) {
		if(idExpediente == null) {
			return null;
		}
		List<DtoAuditoriaDesbloqueo> lAuditoria = new ArrayList<DtoAuditoriaDesbloqueo>();
		List<AuditoriaDesbloqueo> listaAuditoriaDesbloqueo = genericDao.getList(AuditoriaDesbloqueo.class,
				genericDao.createFilter(FilterType.EQUALS, "expediente.id",idExpediente));
		if(listaAuditoriaDesbloqueo != null && !listaAuditoriaDesbloqueo.isEmpty()) {
			for (AuditoriaDesbloqueo auditoria : listaAuditoriaDesbloqueo) {
				DtoAuditoriaDesbloqueo auditoriaDesbloqueo = new DtoAuditoriaDesbloqueo();
				if(auditoria.getId() != null) 
					auditoriaDesbloqueo.setIdCombo(auditoria.getId().toString());
				if(auditoria.getExpediente() != null && auditoria.getExpediente().getId() != null)
					auditoriaDesbloqueo.setIdEco(auditoria.getExpediente().getId().toString());
				if(auditoria.getUsuario() != null && auditoria.getUsuario().getUsername() != null)
					auditoriaDesbloqueo.setIdUsuario(auditoria.getUsuario().getUsername());
				if(auditoria.getMotivoDesbloqueo() != null)
					auditoriaDesbloqueo.setMotivoDeDesbloqueo(auditoria.getMotivoDesbloqueo());
				if(auditoria.getMotivoDesbloqueo() != null)
					auditoriaDesbloqueo.setFechaDeDesbloqueo(auditoria.getFechaDesbloqueo().toString());
				lAuditoria.add(auditoriaDesbloqueo);
			}
		}
		if(lAuditoria != null && !lAuditoria.isEmpty())
			return lAuditoria;
		else
			return null;
	}
	
	private void compruebaEstadoAnyadirDependiente(Oferta ofertaPrincipal) {
		ExpedienteComercial expedienteOfertaPrincipal = genericDao.get(ExpedienteComercial.class,
				genericDao.createFilter(FilterType.EQUALS, "oferta", ofertaPrincipal));
		

		if (expedienteOfertaPrincipal != null
				&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(ofertaPrincipal.getActivoPrincipal().getCartera().getCodigo()) &&
				DDEstadoOferta.CODIGO_ACEPTADA.equals(ofertaPrincipal.getEstadoOferta().getCodigo()) &&
				(!DDEstadosExpedienteComercial.EN_TRAMITACION.equals(expedienteOfertaPrincipal.getEstado().getCodigo()) 
						&& !DDEstadosExpedienteComercial.PTE_SANCION.equals(expedienteOfertaPrincipal.getEstado().getCodigo()))) {
			throw new JsonViewerException("La oferta principal ya está en estado '" + expedienteOfertaPrincipal.getEstado().getDescripcion()
					+ "', ya no se pueden añadir más dependientes");
		}
	}
	
	@Override
	public boolean finalizadoCierreEconomico(ExpedienteComercial expediente) {
		boolean finalizada = false;
		
		if (expediente != null && expediente.getTrabajo() != null) {
			ActivoTramite tramite = genericDao.get(ActivoTramite.class, genericDao.createFilter(FilterType.EQUALS, "trabajo", expediente.getTrabajo()));
			
			if(tramite != null && (ofertaApi.esTareaFinalizada(tramite, T013_CIERRE_ECONOMICO) || ofertaApi.esTareaFinalizada(tramite, T017_CIERRE_ECONOMICO))) {
				finalizada = true;
			}
		}
		
		return finalizada;
	}
	
	@Override
	public boolean finalizadoCierreEconomico(Long expedienteId) {
		Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "id", expedienteId);
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtroExpediente);
		if ( expediente != null ) {
			return this.finalizadoCierreEconomico(expediente);
		}
		return false;

	}

	@Transactional(readOnly = false)
	public boolean ofertasEnLaMismaTarea(BulkOferta blkOfr) {
		boolean ofertasEnLaMismaTarea = true;
		List<String> tareasOfertaActual;
		if (!Checks.esNulo(blkOfr)) {
			List<BulkOferta> listaBlkOfr = bulkOfertaDao.getListBulkOfertasByIdBulk(blkOfr.getPrimaryKey().getBulkAdvisoryNote().getId());		
			Oferta ofertaActual = ofertaDao.get(blkOfr.getPrimaryKey().getOferta().getId());
			tareasOfertaActual = ofertaDao.getTareasActivas(ofertaActual.getNumOferta().toString());
							
			for(int i = 0; i < listaBlkOfr.size() && ofertasEnLaMismaTarea; i++) {
				Oferta ofertasDelBulk =  ofertaDao.get(listaBlkOfr.get(i).getPrimaryKey().getOferta().getId());
				List<String> tareasActivas = ofertaDao.getTareasActivas(ofertasDelBulk.getNumOferta().toString());
				boolean existeTareaActiva = false;	
				for (int f = 0; f < tareasActivas.size() && !existeTareaActiva; f++) {
					existeTareaActiva = tareasOfertaActual.contains(tareasActivas.get(f));
				}
				ofertasEnLaMismaTarea = existeTareaActiva;
			}
		}
		return ofertasEnLaMismaTarea;
	}
	
	public void cambiarBulkOferta(Oferta oferta, DtoDatosBasicosOferta dto, BulkOferta blkOfr) {
		if(!Checks.esNulo(blkOfr)) {
			//Borrado logico del anterior registro si procede
			Auditoria.delete(blkOfr);	
			bulkOfertaDao.update(blkOfr);				
			OfertaDto ofertaDto = new OfertaDto();
			ofertaDto.setNumeroBulkAdvisoryNote(blkOfr.getBulkAdvisoryNote().toString());
		}
		//Nuevo registro idAdvisoryNote
		if(!ofertaDao.tieneTareaActivaOrFinalizada("T017_ResolucionPROManzana", oferta.getNumOferta().toString())) {
			
			Filter filtroNumeroBulkAN = genericDao.createFilter(FilterType.EQUALS, "numeroBulkAdvisoryNote", dto.getIdAdvisoryNote());
			BulkAdvisoryNote blkAn = genericDao.get(BulkAdvisoryNote.class,	filtroNumeroBulkAN);		
			//Si el blkAn es nulo significa que no existe el número de bulk introducido con el tipo de bulk del anterior bulk (debe existir el bulk y que sea del mismo tipo)
			if(!Checks.esNulo(blkAn)) {
				List<BulkOferta> bulkOfertas = blkAn.getBulkOferta();
				if(Checks.esNulo(bulkOfertas)) {
					bulkOfertas = new ArrayList<BulkOferta>();
				}
				blkOfr = bulkOfertaDao.findOne(blkAn.getId(), oferta.getId(), true);	
				if(blkOfr != null) {
					blkOfr.getAuditoria().setBorrado(false);
					blkOfr.getAuditoria().setFechaBorrar(null);
					blkOfr.getAuditoria().setUsuarioBorrar(null);
					blkOfr.getAuditoria().setFechaModificar(new Date());
					blkOfr.getAuditoria().setUsuarioModificar(SecurityUtils.getCurrentUser().getUsername());
					bulkOfertaDao.update(blkOfr);
				}else {
					blkOfr = new BulkOferta();				
					blkOfr.setBulkAdvisoryNote(blkAn);
					blkOfr.setOferta(oferta);
					blkOfr.setPrimaryKey(new BulkOfertaPk(blkAn,oferta));
					blkOfr.setAuditoria(Auditoria.getNewInstance());
					bulkOfertaDao.save(blkOfr);
				}
				if(!bulkOfertas.contains(blkOfr))
					bulkOfertas.add(blkOfr);
				blkAn.setBulkOferta(bulkOfertas);
				genericDao.save(BulkAdvisoryNote.class, blkAn);
			}else {
				throw new JsonViewerException("El Bulk con id '"+dto.getIdAdvisoryNote()+"' no existe");
			}
		}else {
			throw new JsonViewerException("La Oferta de este activo ha avanzado la tarea Autorización Propietario");
		}
	}
	
	public void guardaExclusionBulk(Long idExclusion) {
		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

		OfertaExclusionBulk ofertaExclusionBulk = genericDao.get(OfertaExclusionBulk.class, genericDao.createFilter(FilterType.EQUALS, "id", idExclusion));
		
		ofertaExclusionBulk.setFechaFin(new Date());
		genericDao.update(OfertaExclusionBulk.class, ofertaExclusionBulk);

		transactionManager.commit(transaction);
	}

	private boolean compruebaCompradores(ExpedienteComercial expedienteComercial){
		if (!Checks.esNulo(expedienteComercial)) {
            Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "idExpedienteComercial",expedienteComercial.getId());
            Filter filtroTitular = genericDao.createFilter(FilterType.EQUALS, "titularContratacion",1);

            VBusquedaDatosCompradorExpediente comprador = genericDao.get(VBusquedaDatosCompradorExpediente.class, filtroId, filtroTitular);
            
            if(comprador.getPorcentajeCompra() != null && comprador.getCodTipoDocumento() != null && comprador.getNombreRazonSocial() != null
            && comprador.getNumDocumento() != null && comprador.getDireccion() != null && comprador.getCodigoPais() != null
            && ((comprador.getProvinciaCodigo() != null && comprador.getMunicipioCodigo() != null) || !DDPaises.CODIGO_PAIS_ESPANYA.equals(comprador.getCodigoPais())) ) {
            	if (DDTiposPersona.CODIGO_TIPO_PERSONA_FISICA.equals(comprador.getCodTipoPersona())) {
            		if(comprador.getApellidos() != null && comprador.getCodEstadoCivil() != null) {
            			if(!DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO.equals(comprador.getCodEstadoCivil()) || !DDRegimenesMatrimoniales.COD_GANANCIALES.equals(comprador.getCodigoRegimenMatrimonial())){
            				return true;
            			}else {
            				if(comprador.getCodTipoDocumentoConyuge() != null && comprador.getDocumentoConyuge() != null) {
            					return true;
            				}
            			}
            		}
            	}else if(DDTiposPersona.CODIGO_TIPO_PERSONA_JURIDICA.equals(comprador.getCodTipoPersona())) {
            		if(comprador.getNombreRazonSocialRte() != null && comprador.getApellidosRte() != null && comprador.getCodTipoDocumentoRte() != null 
            			&& comprador.getNumDocumentoRte() != null && comprador.getCodigoPaisRte() != null 
            			&& ((comprador.getProvinciaRteCodigo() != null && comprador.getMunicipioRteCodigo() != null) || !DDPaises.CODIGO_PAIS_ESPANYA.equals(comprador.getCodigoPaisRte()))) {
            			return true;
            		}
            	}
            }
		}
		
		return false;
	}
	
	@Override
	public boolean cumpleCondicionesCrearHonorario(Long idEntidad) {
		ExpedienteComercial expediente = findOne(idEntidad);
		Usuario  usuario = genericAdapter.getUsuarioLogado();
		List<Perfil> perfiles = usuario.getPerfiles();
		for (Perfil perfil : perfiles) {
			if(PERFIL_HAYASUPER.equalsIgnoreCase(perfil.getCodigo())
					|| PERFIL_PERFGCONTROLLER.equalsIgnoreCase(perfil.getCodigo())){
				return true;
			}
		}
		
		if(!finalizadoCierreEconomico(expediente) && funcionApi.elUsuarioTieneFuncion(FUNCION_EDITAR_TAB_GESTION, usuario)){
			return true;	
		}
		
		return false;		
	}

	@Override
	@Transactional(readOnly = false)
	public boolean activarCompradorExpediente(Long idCompradorExpediente, Long idExpediente) {
		if (idCompradorExpediente != null && idExpediente != null) {
			Filter filtroIdCex = genericDao.createFilter(FilterType.EQUALS, "comprador", idCompradorExpediente);
			Filter filtroIdEx = genericDao.createFilter(FilterType.EQUALS, "expediente", idExpediente);
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", true);
			CompradorExpediente compradorExpediente = genericDao.get(CompradorExpediente.class, filtroIdCex, filtroIdEx, filtroBorrado);
			if (compradorExpediente != null) {
				Auditoria auditoria = compradorExpediente.getAuditoria();
				auditoria.setBorrado(false);
				auditoria.setFechaModificar(new Date());
				auditoria.setUsuarioModificar(genericAdapter.getUsuarioLogado().getUsername());
				compradorExpediente.setAuditoria(auditoria);
				compradorExpediente.setFechaBaja(null);
				genericDao.update(CompradorExpediente.class, compradorExpediente);
				
				return true;
			}
		}
		return false;
	}
	
	@Override
	public boolean esBBVA(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		boolean esBBVA = false;
		if (!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getOferta())) {
			Activo activo = expedienteComercial.getOferta().getActivoPrincipal();
			if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getCartera())
					&& !Checks.esNulo(activo.getSubcartera())) {
				esBBVA = DDCartera.CODIGO_CARTERA_BBVA.equals(activo.getCartera().getCodigo());
			}
		}
		return esBBVA;
	}
	
	@Override
	public List<DtoActivosAlquiladosGrid> getActivosAlquilados(Long idExpediente) {
		
		ExpedienteComercial expediente = findOne(idExpediente);
		List<DtoActivosAlquiladosGrid> dtoActivosAlquilados = new ArrayList <DtoActivosAlquiladosGrid>();
		List<ActivoOferta> activosExpediente = expediente.getOferta().getActivosOferta();
		
		Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "codigo", expediente.getEstado().getCodigo());
		DDEstadosExpedienteComercial estadoExpediente = genericDao.get(DDEstadosExpedienteComercial.class, filtroExpediente);

		if (activosExpediente != null && !activosExpediente.isEmpty()) {
			for (ActivoOferta activoOferta: activosExpediente) {
				
				DtoActivosAlquiladosGrid dto = new DtoActivosAlquiladosGrid();
				
				dto.setId(activoOferta.getPrimaryKey().getActivo().getId());
				dto.setNumActivo(activoOferta.getPrimaryKey().getActivo().getNumActivo());
				dto.setSubTipoActivo(activoOferta.getPrimaryKey().getActivo().getSituacionComercial().getDescripcion());
				dto.setMunicipio(activoOferta.getPrimaryKey().getActivo().getMunicipio());
				dto.setDireccion(activoOferta.getPrimaryKey().getActivo().getDireccion());
				
				Long a = activoOferta.getPrimaryKey().getActivo().getId();
				Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activoAlq.id", a);
				ActivosAlquilados activoAlquilado = genericDao.get(ActivosAlquilados.class, filtroActivo);
				
				if (activoAlquilado != null && activoAlquilado.getActivoAlq() != null && activoAlquilado.getActivoAlq().getSituacionPosesoria() != null 
						&& activoAlquilado.getActivoAlq().getSituacionPosesoria().getOcupado() == 1 
						&& activoAlquilado.getActivoAlq().getSituacionPosesoria().getConTitulo() != null 
						&& DDTipoTituloActivoTPA.tipoTituloSi.contentEquals(activoAlquilado.getActivoAlq().getSituacionPosesoria().getConTitulo().getCodigo())){

					dto.setRentaMensual(activoAlquilado.getAlqRentaMensual());
					dto.setDeudaActual(activoAlquilado.getAlqDeudaActual());
					
					if (activoAlquilado.getAlqDeudas() == 1) {
						dto.setConDeudas("Si");
					} else {
						dto.setConDeudas("No");
					}
					if (activoAlquilado.getAlqInquilino() == 1) {
						dto.setInquilino("Si");
					} else {
						dto.setInquilino("No");
					}
					if (activoAlquilado.getAlqOfertante() == 1) {
						dto.setOfertante("Si");
					} else {
						dto.setOfertante("No");
					}
					
					dto.setFechaFinContrato(activoAlquilado.getAlqFechaFin());
					
					if (estadoExpediente != null && estadoExpediente.getCodigo() != null) {
						dto.setEstadoExpediente(estadoExpediente.getCodigo());
					}
					
				}
				dtoActivosAlquilados.add(dto);
			}
		}
		return dtoActivosAlquilados;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateActivosAlquilados(DtoActivosAlquiladosGrid dto) {
		
		Integer si = 1;
		Integer no = 0;
		
		if (dto != null) {
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activoAlq.id", dto.getId());
			ActivosAlquilados activoAlquilado = genericDao.get(ActivosAlquilados.class, filtro);
			
			if (activoAlquilado != null) {
				if (dto.getRentaMensual() != null) {
					activoAlquilado.setAlqRentaMensual(dto.getRentaMensual());
				}
				if (dto.getDeudaActual() != null) {
					activoAlquilado.setAlqDeudaActual(dto.getDeudaActual());
				}
				if (dto.getConDeudas() != null) {
					if (Integer.parseInt(dto.getConDeudas()) == 1) {
						activoAlquilado.setAlqDeudas(si);
					} else {
						activoAlquilado.setAlqDeudas(no);
					} 
				}
				if (dto.getInquilino() != null) {
					if (Integer.parseInt(dto.getConDeudas()) == 1) {
						activoAlquilado.setAlqInquilino(si);
					} else {
						activoAlquilado.setAlqInquilino(no);
					} 
				}
				if (dto.getOfertante() != null) {
					if (Integer.parseInt(dto.getConDeudas()) == 1) {
						activoAlquilado.setAlqOfertante(si);
					} else {
						activoAlquilado.setAlqOfertante(no);
					} 
				}
				if (dto.getFechaFinContrato() != null) {
					activoAlquilado.setAlqFechaFin(dto.getFechaFinContrato());
				}
				
				genericDao.save(ActivosAlquilados.class, activoAlquilado);

				return true;
				
			}
			
		}
		
		return false;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean sacarBulk(Long idExpediente) {
		if(idExpediente == null) return false;
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", idExpediente));
		if(expediente == null || expediente.getOferta() == null) return false;		
		
		BulkOferta blkOfr = bulkOfertaDao.findOne(null, expediente.getOferta().getId(), false);
		if(blkOfr == null) return false;
		
		OfertaExclusionBulk exclusion = genericDao.get(OfertaExclusionBulk.class, 				
				genericDao.createFilter(FilterType.EQUALS, "oferta", expediente.getOferta()),
				genericDao.createFilter(FilterType.NULL, "fechaFin"));
		
		if(exclusion != null ) {			
			exclusion.setFechaFin(new Date());
			genericDao.update(OfertaExclusionBulk.class, exclusion);
			bulkOfertaDao.flush();
		}
		
		OfertaExclusionBulk oeb = new OfertaExclusionBulk();
		oeb.setOferta(expediente.getOferta());
		oeb.setExclusionBulk(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_SI)));
		oeb.setFechaInicio(new Date());
		oeb.setUsuarioAccion(genericAdapter.getUsuarioLogado());
		genericDao.save(OfertaExclusionBulk.class, oeb);
		Auditoria.delete(blkOfr);
		bulkOfertaDao.update(blkOfr);
		
		return true;
	}

	
	@Override
	public boolean compruebaEstadoNoSolicitadoPendiente (TareaExterna tareaExterna){
		boolean tipoEstado = false;
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		List <CompradorExpediente> cexpediente = expedienteComercial.getCompradores();
			
		for (CompradorExpediente compradorExpediente : cexpediente) {
				
			if(Checks.esNulo(compradorExpediente.getEstadoContrasteListas()) ||
					DDEstadoContrasteListas.NO_SOLICITADO.equals(compradorExpediente.getEstadoContrasteListas().getCodigo()) || 
					DDEstadoContrasteListas.PENDIENTE.equals(compradorExpediente.getEstadoContrasteListas().getCodigo()) ) {
				tipoEstado = true;
				break;
			}
		}
		return tipoEstado;
	}
	@Override
	public boolean compruebaEstadoPositivoRealDenegado (TareaExterna tareaExterna){
		boolean tipoEstado = false;
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		List <CompradorExpediente> cexpediente = expedienteComercial.getCompradores();
			
		for (CompradorExpediente compradorExpediente : cexpediente) {
			
			if(!Checks.esNulo(compradorExpediente.getEstadoContrasteListas()) &&  DDEstadoContrasteListas.POSITIVO_REAL_DENEGADO.equals(compradorExpediente.getEstadoContrasteListas().getCodigo())) {
				tipoEstado = true;
				break;
			}
		}
		return tipoEstado;
	}

	@Override
	public String tipoTratamiento(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		
		return expedienteComercial.getEstado().getCodigo();
	}

	@Override
	@Transactional(readOnly = false)
	public void recalcularHonorarios(Long idExpediente) throws Exception {
		
		Oferta oferta = ofertaApi.getOfertaByIdExpediente(idExpediente);
		
		ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdOferta(oferta.getId());
		
		Activo activo = oferta.getActivoPrincipal();
		
		this.actualizarGastosExpediente(expediente,oferta,activo);
		
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public void getCierreOficinaBankiaById(Long idExpediente) {

		EnvioCierreOficinasBankia auxiliar = genericDao.get(EnvioCierreOficinasBankia.class,
				genericDao.createFilter(FilterType.EQUALS, "idExpediente", idExpediente));
		
		if (auxiliar != null && !auxiliar.getEnviado()) {
			auxiliar.setEnviado(true);
			Auditoria auditoria = auxiliar.getAuditoria();			
			auditoria.setFechaModificar(new Date());
			auditoria.setUsuarioModificar(genericAdapter.getUsuarioLogado().getUsername());
			auxiliar.setAuditoria(auditoria);	
			
			genericDao.update(EnvioCierreOficinasBankia.class, auxiliar);
			
		}
	}	

	@Override
	public DtoListadoTramites ponerTareasCarteraCorrespondiente(DtoListadoTramites tramite, ExpedienteComercial expediente) {
		if(expediente.getOferta().getActivoPrincipal() != null && expediente.getOferta().getActivoPrincipal().getCartera() !=  null) {
			String tipoTramiteCartera = tramite.getNombre().replace("Cerberus", expediente.getOferta().getActivoPrincipal().getCartera().getDescripcion());
			if(!Checks.esNulo(tramite.getTareas())) {
				DtoListadoTareas[] tareas = tramite.getTareas();
				for (DtoListadoTareas tarea : tareas) {
					tarea.setNombre(tipoTramiteCartera);
				}
			}
		}
		
		return tramite;
	}
	
	@Override
	public boolean esBankia(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = tareaExternaToExpedienteComercial(tareaExterna);
		boolean esBankia = false;
		if (!Checks.esNulo(expedienteComercial) && !Checks.esNulo(expedienteComercial.getOferta())) {
			Activo activo = expedienteComercial.getOferta().getActivoPrincipal();
			if (!Checks.esNulo(activo)) {
				esBankia = DDCartera.isCarteraBk(activo.getCartera());
			}
		}
		return esBankia;
	}
	
	@Override
	public DtoGridFechaArras getFechaUltimaPropuestaSinContestar(Long idExpediente){
		Filter filtroFechaRespuesta = genericDao.createFilter(FilterType.NULL, "fechaRespuestaBC");
		
		FechaArrasExpediente fechaArrasExpediente =  this.getUltimaPropuesta(idExpediente, filtroFechaRespuesta);
		return this.propuestaToDto(fechaArrasExpediente);
	}
	
	
	@Override
	public DtoGridFechaArras getUltimaPropuestaEnviada(Long idExpediente) {	
		FechaArrasExpediente fechaArrasExpediente =  this.getUltimaPropuesta(idExpediente, null);
		return this.propuestaToDto(fechaArrasExpediente);
	}
	
	@Override
	public FechaArrasExpediente getUltimaPropuesta(Long idExpediente, Filter filter) {
		FechaArrasExpediente fechaArrasExpediente = null;
		List<FechaArrasExpediente> fechaArrasExpedienteList = null;
		Order order = new Order(OrderType.DESC,"id");
		Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", idExpediente);
		if(filter == null) {
			fechaArrasExpedienteList = genericDao.getListOrdered(FechaArrasExpediente.class, order, filtroExpediente);
		}else {
			fechaArrasExpedienteList = genericDao.getListOrdered(FechaArrasExpediente.class, order, filtroExpediente, filter);
		}

		fechaArrasExpedienteList = this.listFechaArrasFiltradaSinAnulados(fechaArrasExpedienteList);
		if(fechaArrasExpedienteList != null && !fechaArrasExpedienteList.isEmpty()){
			fechaArrasExpediente = fechaArrasExpedienteList.get(0);
		}
		return fechaArrasExpediente;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void createOrUpdateUltimaPropuestaEnviada(Long idExpediente, DtoGridFechaArras dto) {
		Filter filtroFechaRespuesta = genericDao.createFilter(FilterType.NULL, "fechaRespuestaBC");
		FechaArrasExpediente fechaArrasExpediente =  this.getUltimaPropuesta(idExpediente, filtroFechaRespuesta);
		
		this.createOrUpdatePropuesta(fechaArrasExpediente,dto,idExpediente);
	}
	
	
	
	private DtoGridFechaArras propuestaToDto(FechaArrasExpediente fechaArrasExpediente) {
		DtoGridFechaArras dto = new DtoGridFechaArras();
		if(fechaArrasExpediente != null){
			dto.setFechaPropuesta(fechaArrasExpediente.getFechaPropuesta());
			if(fechaArrasExpediente.getValidacionBC() != null) {
				dto.setValidacionBC(fechaArrasExpediente.getValidacionBC().getCodigo());
			}
			dto.setFechaBC(fechaArrasExpediente.getFechaRespuestaBC());
			dto.setComentariosBC(fechaArrasExpediente.getComentariosBC());
			dto.setMotivoAnulacion(fechaArrasExpediente.getMotivoAnulacion());
			dto.setComentariosBC(fechaArrasExpediente.getComentariosBC());
		}
		return dto;
	}
	
	private FechaArrasExpediente dtoToPropuesta(FechaArrasExpediente fechaArrasExpediente, DtoGridFechaArras dto) {
		
		try {
			beanUtilNotNull.copyProperty(fechaArrasExpediente, "fechaPropuesta", dto.getFechaPropuesta());
			beanUtilNotNull.copyProperty(fechaArrasExpediente, "fechaRespuestaBC", dto.getFechaBC());
			beanUtilNotNull.copyProperty(fechaArrasExpediente, "comentariosBC", dto.getComentariosBC());
			beanUtilNotNull.copyProperty(fechaArrasExpediente, "fechaEnvio", dto.getFechaEnvio());
			beanUtilNotNull.copyProperty(fechaArrasExpediente, "observaciones", dto.getObservaciones());
			
			if(dto.getValidacionBC() != null) {
				DDMotivosEstadoBC dd = genericDao.get(DDMotivosEstadoBC.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getValidacionBC()));
				if(dd != null) {
					fechaArrasExpediente.setValidacionBC(dd);
				}
			}

			if (dto.getMotivoAnulacion() != null) {
				fechaArrasExpediente.setMotivoAnulacion(dto.getMotivoAnulacion());
			}
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return fechaArrasExpediente;
	}


	@Override
	public List<DtoGridFechaArras> getFechaArras(Long idExpediente) throws IllegalAccessException, InvocationTargetException {
		List<DtoGridFechaArras> listDto = new ArrayList<DtoGridFechaArras>();
		List<FechaArrasExpediente> list = new ArrayList<FechaArrasExpediente>();
		Order order = new Order(OrderType.DESC,"id");
		//list = genericDao.getList(FechaArrasExpediente.class, genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", idExpediente));
		list = genericDao.getListOrdered(FechaArrasExpediente.class, order, genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", idExpediente));
		
		
		for(FechaArrasExpediente reg: list) {
			DtoGridFechaArras dto = new DtoGridFechaArras();
			
			beanUtilNotNull.copyProperties(dto, reg);
			dto.setFechaAlta(reg.getAuditoria().getFechaCrear());
			dto.setFechaBC(reg.getFechaRespuestaBC());
			dto.setMotivoAnulacion(reg.getMotivoAnulacion());
			if(reg.getValidacionBC() != null) {
				dto.setValidacionBC(reg.getValidacionBC().getDescripcion());
				dto.setValidacionBCcodigo(reg.getValidacionBC().getCodigo());
			}else {
				dto.setValidacionBC("Pte respuesta");
			}
			
			listDto.add(dto);
		}
		
		return listDto;
	}

	@Override
	@Transactional
	public Boolean saveFechaArras(DtoGridFechaArras dto) throws ParseException {
		FechaArrasExpediente nuevaFecha = new FechaArrasExpediente();
		
		nuevaFecha.setFechaPropuesta(ft.parse(dto.getFechaPropuestaString()));
		nuevaFecha.setObservaciones(dto.getObservaciones());
		nuevaFecha.setExpedienteComercial(genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdExpediente())));
		DDMotivosEstadoBC validacionBC = genericDao.get(DDMotivosEstadoBC.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivosEstadoBC.CODIGO_NO_ENVIADA));
		nuevaFecha.setValidacionBC(validacionBC);
		if (dto.getMotivoAnulacion() != null) {
			nuevaFecha.setMotivoAnulacion(dto.getMotivoAnulacion());
		}
		
		nuevaFecha = genericDao.save(FechaArrasExpediente.class, nuevaFecha);
		
		return nuevaFecha != null;
	}

	@Override
	@Transactional
	public Boolean updateFechaArras(DtoGridFechaArras dto) throws IllegalAccessException, InvocationTargetException {
		
		if(dto != null) {
			
			FechaArrasExpediente fechaArras = genericDao.get(FechaArrasExpediente.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));
			
			
			if(dto.getFechaBC() != null) {
				String fechaBC = ft.format(dto.getFechaBC());
				
				if(!FECHA_1970.equals(fechaBC)) {
					fechaArras.setFechaRespuestaBC(dto.getFechaBC());
				}
			}
			if (dto.getObservaciones() != null) {
				fechaArras.setObservaciones(dto.getObservaciones());
			}
			if (dto.getMotivoAnulacion() != null) {
				if (DDMotivosEstadoBC.CODIGO_NO_ENVIADA.equals(fechaArras.getValidacionBC().getCodigo())) {
					DDMotivosEstadoBC motivo = genericDao.get(DDMotivosEstadoBC.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivosEstadoBC.CODIGO_ANULADA));
					fechaArras.setValidacionBC(motivo);					
				}
				if (DDMotivosEstadoBC.CODIGO_APROBADA_BC.equals(fechaArras.getValidacionBC().getCodigo())) {
					DDMotivosEstadoBC motivo = genericDao.get(DDMotivosEstadoBC.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivosEstadoBC.CODIGO_APLAZADA));
					fechaArras.setValidacionBC(motivo);
				}
				fechaArras.setMotivoAnulacion(dto.getMotivoAnulacion());
			}
			
			genericDao.update(FechaArrasExpediente.class, fechaArras);
			
			return true;
		}
		
		return false;
	}
	
	
	
	
	@Override
	public DtoPosicionamiento getUltimoPosicionamientoSinContestar(Long idExpediente){
		Filter filtroFechaRespuesta = genericDao.createFilter(FilterType.NULL, "fechaValidacionBCPos");
		
		Posicionamiento posicionamiento =  this.getUltimoPosicionamiento(idExpediente, filtroFechaRespuesta, true);
		return this.posicionamientoToDto(posicionamiento);
	}
	
	
	@Override
	public DtoPosicionamiento getUltimoPosicionamientoEnviado(Long idExpediente) {	
		Posicionamiento posicionamiento =  this.getUltimoPosicionamiento(idExpediente, null, false);
		return this.posicionamientoToDto(posicionamiento);
	}
	
	@Override
	public Posicionamiento getUltimoPosicionamiento(Long idExpediente, Filter filter, boolean noMostrarAnulados) {
		Posicionamiento posicionamiento = null;
		List<Posicionamiento> posicionamientosList = null;
		Order order = new Order(OrderType.DESC,"id");
		Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		if(filter == null) {
			posicionamientosList = genericDao.getListOrdered(Posicionamiento.class, order, filtroExpediente);
		}else if(noMostrarAnulados){
			Filter filtroAnulados = genericDao.createFilter(FilterType.NULL, "fechaFinPosicionamiento");
			posicionamientosList = genericDao.getListOrdered(Posicionamiento.class, order, filtroExpediente, filter, filtroAnulados);
		}else{
			posicionamientosList = genericDao.getListOrdered(Posicionamiento.class, order, filtroExpediente, filter);

		}

		if(posicionamientosList != null && !posicionamientosList.isEmpty()){
			posicionamiento = posicionamientosList.get(0);
		}
		return posicionamiento;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void createOrUpdateUltimoPosicionamientoEnviado(Long idExpediente, DtoPosicionamiento dto) {
		Filter filtroFechaRespuesta = genericDao.createFilter(FilterType.NULL, "fechaValidacionBCPos");
		Posicionamiento posicionamiento =  this.getUltimoPosicionamiento(idExpediente, filtroFechaRespuesta, true);
		
		if(posicionamiento == null) {
			posicionamiento = new Posicionamiento();
			ExpedienteComercial eco = this.findOne(idExpediente);
			posicionamiento.setExpediente(eco);
		}
		
		this.dtoToPosicionamiento(posicionamiento, dto);
		
		genericDao.save(Posicionamiento.class, posicionamiento);

	}

	@Override
	@Transactional(readOnly = false)
	public void createOrUpdateUltimoPosicionamiento(Long idExpediente, DtoPosicionamiento dto) {
		Posicionamiento posicionamiento =  this.getUltimoPosicionamiento(idExpediente, null, true);
		
		if(posicionamiento == null) {
			posicionamiento = new Posicionamiento();
			ExpedienteComercial eco = this.findOne(idExpediente);
			posicionamiento.setExpediente(eco);
		}
		
		this.dtoToPosicionamiento(posicionamiento, dto);
		
		genericDao.save(Posicionamiento.class, posicionamiento);

	}

	
	private Posicionamiento dtoToPosicionamiento (Posicionamiento posicionamiento, DtoPosicionamiento dto) {
		
		try {
			beanUtilNotNull.copyProperty(posicionamiento, "fechaPosicionamiento", dto.getFechaPosicionamiento());
			beanUtilNotNull.copyProperty(posicionamiento, "fechaValidacionBCPos", dto.getFechaValidacionBCPos());
			beanUtilNotNull.copyProperty(posicionamiento, "comentariosBC", dto.getObservacionesBcPos());
			beanUtilNotNull.copyProperty(posicionamiento, "fechaEnvio", dto.getFechaEnvioPos());
			beanUtilNotNull.copyProperty(posicionamiento, "motivoAplazamiento", dto.getMotivoAplazamiento());
			beanUtilNotNull.copyProperty(posicionamiento, "fechaFinPosicionamiento", dto.getFechaFinPosicionamiento());
			beanUtilNotNull.copyProperty(posicionamiento, "observacionesBcPos", dto.getObservacionesBcPos());
			beanUtilNotNull.copyProperty(posicionamiento, "observacionesRem", dto.getObservacionesRem());
			
			
			
			
			if(dto.getValidacionBCPosi() != null) {
				DDMotivosEstadoBC dd = genericDao.get(DDMotivosEstadoBC.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getValidacionBCPosi()));
				if(dd != null) {
					posicionamiento.setValidacionBCPos(dd);
				}
			}
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return posicionamiento;
	}
	
	@Override
	public boolean checkVueltaAtras(Long idTramite) {
		ExpedienteComercial eco = this.getExpedienteByIdTramite(idTramite);
		boolean vueltaAtras = true;
		if(eco != null) {
			DtoPosicionamiento dto = getUltimoPosicionamientoEnviado(eco.getId());
			if(dto != null && DDApruebaDeniega.getCodigoAprueba().equals(dto.getValidacionBCPosi())) {
				vueltaAtras = false;
			}
		}

		return vueltaAtras;
	}
	
	@Override
	public ExpedienteComercial getExpedienteByIdTramite(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);
		ExpedienteComercial expediente = null;
		if (!Checks.esNulo(activoTramite)) {
			Trabajo trabajo = activoTramite.getTrabajo();

			if (!Checks.esNulo(trabajo)) {
				expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(trabajo.getId());
			}
		}
		
		return expediente;
	}
	
	@Override
	public List<DtoRespuestaBCGenerica> getListResolucionComiteBC(Long idExpediente) {	
		List<DtoRespuestaBCGenerica> dtoRespuestaBCGenericaList = new ArrayList<DtoRespuestaBCGenerica>();
		Order order = new Order(OrderType.DESC,"id");
		Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", idExpediente);
		List<RespuestaComiteBC> respuestaComiteBcList =  genericDao.getListOrdered(RespuestaComiteBC.class, order, filtroExpediente);
		if(respuestaComiteBcList != null && !respuestaComiteBcList.isEmpty()) {
			for (RespuestaComiteBC respuestaComiteBc : respuestaComiteBcList) {
				DtoRespuestaBCGenerica dtoRespuestaBCGenerica = this.respuestaComiteToDtoRespuestaBCGen(respuestaComiteBc);
				dtoRespuestaBCGenerica.setNecesidadArrasActivo(this.getCodigoNecesitaArras(idExpediente));
				dtoRespuestaBCGenericaList.add(dtoRespuestaBCGenerica);
			}
		}
		return dtoRespuestaBCGenericaList;
	}
	
	private DtoRespuestaBCGenerica respuestaComiteToDtoRespuestaBCGen(RespuestaComiteBC respuesta) {
		DtoRespuestaBCGenerica dto = new DtoRespuestaBCGenerica();
		if(respuesta != null) {
			dto.setId(respuesta.getId());
			dto.setFechaRespuestaBC(respuesta.getFechaRespuestaBcRBC());
			
			if (respuesta.getSancionClRod() != null) {
				dto.setObservacionesBC(respuesta.getSancionClRod());
			} else {
				dto.setObservacionesBC(respuesta.getObservacionesBcRBC());
			}
			
			if (respuesta.getComiteRBC() != null && respuesta.getComiteRBC()) {
				dto.setComite(RespuestaComiteBC.COMITE_COMERCIAL);
			} else {
				dto.setComite(RespuestaComiteBC.COMITE_CL_ROD);
			}
			
			if(respuesta.getExpedienteComercial() != null) {
				dto.setIdExpediente(respuesta.getExpedienteComercial().getId());
			}
			
			if(respuesta.getValidacionBcRBC() != null) {
				dto.setRespuestaBC(respuesta.getValidacionBcRBC().getCodigo());
			}
		}
		
		return dto;
	}
	
	private String getCodigoNecesitaArras(Long idExpediente) {
		String necesitaArrasCod = null;
		
		Oferta oferta = ofertaApi.getOfertaByIdExpediente(idExpediente);
		if(oferta != null){
			Activo activo = oferta.getActivoPrincipal();
			if(activo != null) {
				ActivoCaixa cb = genericDao.get(ActivoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
				if(cb != null && cb.getNecesidadArras() != null) {
					String codigo = DDSinSiNo.cambioBooleanToCodigoDiccionario(cb.getNecesidadArras());
					DDSinSiNo sino = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigo));
					necesitaArrasCod = sino.getCodigo();
				}
			}		
		}
		
		return necesitaArrasCod;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void tareaBloqueoScreening(DtoScreening dto) throws IllegalArgumentException, IllegalAccessException {
		Oferta o = ofertaApi.getOfertaByNumOfertaRem(dto.getNumOferta());
		ExpedienteComercial expedienteComercial =  expedienteComercialDao.getExpedienteComercialByIdOferta(o.getId());
		TareaExterna tarea = null;
		Map<String, Boolean> campos = new HashMap<String,Boolean>();
		dto.setNumExpedienteComercial(expedienteComercial.getNumExpediente());
		dto.setComboResultado(DDSinSiNo.CODIGO_SI);
		campos.put(COMPRADOR_BLOQUEADO, true);
		
		if(!dto.getIsTareaActiva()) {
			this.guardarBloqueoExpediente(expedienteComercial);
			tarea = this.crearTareaScreening(dto, expedienteComercial);
			if(Checks.esNulo(dto.getMotivoBloqueado())) {
				dto.setMotivoBloqueado(DDMotivoBloqueo.BLOQUEO_SCREENING);
			}
		}

		if(tarea != null) {
			this.setValoresTEB(dto, tarea, dto.getCodigoTarea());

		}
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		
		if (!campos.isEmpty() && boardingComunicacionApi.modoRestClientBloqueoCompradoresActivado())
			boardingComunicacionApi.enviarBloqueoCompradoresCFV(o, campos ,BoardingComunicacionApi.TIMEOUT_1_MINUTO);
	}
	
	@Override
	@Transactional(readOnly = false)
	public void tareaDesbloqueoScreening(DtoScreening dto) throws Exception {
		Oferta o = ofertaApi.getOfertaByNumOfertaRem(dto.getNumOferta());
		ExpedienteComercial expedienteComercial =  expedienteComercialDao.getExpedienteComercialByIdOferta(o.getId());
		TareaExterna tarea = null;
		Map<String, Boolean> campos = new HashMap<String,Boolean>();
		dto.setNumExpedienteComercial(expedienteComercial.getNumExpediente());
		dto.setComboResultado(DDSinSiNo.CODIGO_NO);
		campos.put(COMPRADOR_BLOQUEADO, false);
		if(dto.getIsTareaActiva()){
			if(Checks.esNulo(dto.getMotivoDesbloqueado())) {
				dto.setMotivoDesbloqueado(DDMotivosDesbloqueo.DESBLOQUEO_SCREENING);
			}
	
			ActivoTramite tramiteVenta = tramiteDao.getTramiteComercialVigenteByTrabajoT017(expedienteComercial.getTrabajo().getId());
			ActivoTramite tramiteAlquiler = tramiteDao.getTramiteComercialVigenteByTrabajoT015(expedienteComercial.getTrabajo().getId());
			ActivoTramite tramiteAlquilerNoComercial = tramiteDao.getTramiteComercialVigenteByTrabajoT018(expedienteComercial.getTrabajo().getId());

			if(tramiteVenta != null) {
				tarea = activoTramiteApi.getTareaActivaByCodigoAndTramite(tramiteVenta.getId(), ComercialUserAssigantionService.CODIGO_T017_BLOQUEOSCREENING);
				this.guardarDesbloqueoExpediente(expedienteComercial, dto.getMotivoDesbloqueado(), null);
				
				if(tarea != null) {
					this.setValoresTEB(dto, tarea, dto.getCodigoTarea());
					if(tarea.getTareaPadre() != null) {
						this.avanzarTareaScreening(tarea.getId(), tarea.getTareaPadre().getId());
					}
				}		
			} else if(tramiteAlquiler != null) {
				tarea = activoTramiteApi.getTareaActivaByCodigoAndTramite(tramiteAlquiler.getId(), ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_BLOQUEOSCREENING);
				this.guardarDesbloqueoExpediente(expedienteComercial, dto.getMotivoDesbloqueado(), null);
				
				if(tarea != null) {
					this.setValoresTEB(dto, tarea, dto.getCodigoTarea());
					if(tarea.getTareaPadre() != null) {
						this.avanzarTareaScreening(tarea.getId(), tarea.getTareaPadre().getId());
					}
				}		
			} else if (tramiteAlquilerNoComercial != null) {
				tarea = activoTramiteApi.getTareaActivaByCodigoAndTramite(tramiteAlquilerNoComercial.getId(), ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_BLOQUEOSCREENING);
				this.guardarDesbloqueoExpediente(expedienteComercial, dto.getMotivoDesbloqueado(), null);
				
				if(tarea != null) {
					this.setValoresTEB(dto, tarea, dto.getCodigoTarea());
					if(tarea.getTareaPadre() != null) {
						this.avanzarTareaScreening(tarea.getId(), tarea.getTareaPadre().getId());
					}
				}
			}
			DDEstadoComunicacionC4C estadoValidado = (DDEstadoComunicacionC4C) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoComunicacionC4C.class, DDEstadoComunicacionC4C.C4C_VALIDADO);
			this.actualizarEstadoBCInterlocutores(expedienteComercial, estadoValidado);
			this.actualizarEstadoBCCompradores(expedienteComercial, estadoValidado);
			genericDao.save(ExpedienteComercial.class, expedienteComercial);
			
			if (!campos.isEmpty() && boardingComunicacionApi.modoRestClientBloqueoCompradoresActivado())
				boardingComunicacionApi.enviarBloqueoCompradoresCFV(o, campos ,BoardingComunicacionApi.TIMEOUT_1_MINUTO);
		}
	}

	@Override
	public DtoScreening dataToDtoScreeningBloqueo(Long numOferta, String motivo, String observaciones) {
		
		ActivoTramite tramiteVenta = null;
		ActivoTramite tramiteAlquiler = null;
		ActivoTramite tramiteAlquilerNoComercial = null;
		
		if (numOferta != null) {
			Filter filtroOferta = genericDao.createFilter(FilterType.EQUALS, "numOferta", numOferta);
			Oferta oferta =  genericDao.get(Oferta.class, filtroOferta);
			
			if (oferta != null) {
				ExpedienteComercial expedienteComercial =  expedienteComercialDao.getExpedienteComercialByIdOferta(oferta.getId());
				if (expedienteComercial != null) {
					tramiteVenta = tramiteDao.getTramiteComercialVigenteByTrabajoT017(expedienteComercial.getTrabajo().getId());
					tramiteAlquiler = tramiteDao.getTramiteComercialVigenteByTrabajoT015(expedienteComercial.getTrabajo().getId());
					tramiteAlquilerNoComercial = tramiteDao.getTramiteComercialVigenteByTrabajoT018(expedienteComercial.getTrabajo().getId());
				}
			}
		}

		
		DtoScreening dto = new DtoScreening();
		dto.setNumOferta(numOferta);
		dto.setMotivoBloqueado(motivo);
		dto.setObservacionesBloqueado(observaciones);
		dto.setIsTareaActiva(false);
		
		if (tramiteVenta != null) {
			dto.setCodigoTarea(ComercialUserAssigantionService.CODIGO_T017_BLOQUEOSCREENING);
		} else if (tramiteAlquiler != null) {
			dto.setCodigoTarea(ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_BLOQUEOSCREENING);
		} else if (tramiteAlquilerNoComercial != null) {
			dto.setCodigoTarea(ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_BLOQUEOSCREENING);
		}

		return dto;
	}
	
	@Override
	public DtoScreening dataToDtoScreeningDesBloqueo(Long numOferta, String motivo, String observaciones) {
		
		ActivoTramite tramiteVenta = null;
		ActivoTramite tramiteAlquiler = null;
		ActivoTramite tramiteAlquilerNoComercial = null;
		
		if (numOferta != null) {
			Filter filtroOferta = genericDao.createFilter(FilterType.EQUALS, "numOferta", numOferta);
			Oferta oferta =  genericDao.get(Oferta.class, filtroOferta);
			
			if (oferta != null) {
				ExpedienteComercial expedienteComercial =  expedienteComercialDao.getExpedienteComercialByIdOferta(oferta.getId());
				if (expedienteComercial != null) {
					tramiteVenta = tramiteDao.getTramiteComercialVigenteByTrabajoT017(expedienteComercial.getTrabajo().getId());
					tramiteAlquiler = tramiteDao.getTramiteComercialVigenteByTrabajoT015(expedienteComercial.getTrabajo().getId());
					tramiteAlquilerNoComercial = tramiteDao.getTramiteComercialVigenteByTrabajoT018(expedienteComercial.getTrabajo().getId());
				}
			}
		}
		
		DtoScreening dto = new DtoScreening();
		dto.setNumOferta(numOferta);
		dto.setMotivoDesbloqueado(motivo);
		dto.setObservacionesDesbloqueado(observaciones);
		
		if (tramiteVenta != null) {
			dto.setCodigoTarea(ComercialUserAssigantionService.CODIGO_T017_BLOQUEOSCREENING);
		} else if (tramiteAlquiler != null) {
			dto.setCodigoTarea(ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_BLOQUEOSCREENING);
		} else if (tramiteAlquilerNoComercial != null) {
			dto.setCodigoTarea(ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_BLOQUEOSCREENING);
		}
		dto.setIsTareaActiva(true);

		return dto;
	}
	
	@Transactional(readOnly = false)
	private TareaExterna crearTareaScreening(DtoScreening dto, ExpedienteComercial expedienteComercial) {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		TareaExterna tareaNueva = null;
		ActivoTramite tramiteVenta = null;
		ActivoTramite tramiteAlquiler = null;
		ActivoTramite tramiteAlquilerNoComercial = null;
		
		if (expedienteComercial != null && expedienteComercial.getTrabajo() != null) {
			tramiteVenta = tramiteDao.getTramiteComercialVigenteByTrabajoT017(expedienteComercial.getTrabajo().getId());
			tramiteAlquiler = tramiteDao.getTramiteComercialVigenteByTrabajoT015(expedienteComercial.getTrabajo().getId());
			tramiteAlquilerNoComercial = tramiteDao.getTramiteComercialVigenteByTrabajoT018(expedienteComercial.getTrabajo().getId());
		}
		
		if (tramiteVenta != null) {
			dto.setUsuarioLogado(usuarioLogado.getUsername());
			tramiteDao.creaTareas(dto);
			TareaNotificacion tarNot = null;
			List<TareaExterna> tareasActivas2 = activoTramiteApi.getListaTareaExternaActivasByIdTramite(tramiteVenta.getId());
			for (TareaExterna tarea : tareasActivas2) {
				if (dto.getCodigoTarea().equals(tarea.getTareaProcedimiento().getCodigo())) {
					tareaNueva = tarea;
					tarNot = tarea.getTareaPadre();
					if (!Checks.esNulo(tarNot)) {
						TareaActivo tac = genericDao.get(TareaActivo.class, genericDao.createFilter(FilterType.EQUALS, "id", tarNot.getId()));
						if(Checks.esNulo(tac)) {
							tac = new TareaActivo();
							tac.setActivo(tramiteVenta.getActivo());
							tac.setId(tarNot.getId());
							tac.setTramite(tramiteVenta);
							tac.setAuditoria(Auditoria.getNewInstance());
						}
							tac.setUsuario(usuarioLogado);
						genericDao.save(TareaActivo.class, tac);
					}
					break;
				}
			}
		} else if(tramiteAlquiler != null) {
			dto.setUsuarioLogado(usuarioLogado.getUsername());
			tramiteDao.creaTareas(dto);
			TareaNotificacion tarNot = null;
			List<TareaExterna> tareasActivas3 = activoTramiteApi.getListaTareaExternaActivasByIdTramite(tramiteAlquiler.getId());
			for (TareaExterna tarea : tareasActivas3) {
				if (dto.getCodigoTarea().equals(tarea.getTareaProcedimiento().getCodigo())) {
					tareaNueva = tarea;
					tarNot = tarea.getTareaPadre();
					if (!Checks.esNulo(tarNot)) {
						TareaActivo tac = genericDao.get(TareaActivo.class, genericDao.createFilter(FilterType.EQUALS, "id", tarNot.getId()));
						if(Checks.esNulo(tac)) {
							tac = new TareaActivo();
							tac.setActivo(tramiteAlquiler.getActivo());
							tac.setId(tarNot.getId());
							tac.setTramite(tramiteAlquiler);
							tac.setAuditoria(Auditoria.getNewInstance());
						}
							tac.setUsuario(usuarioLogado);
						genericDao.save(TareaActivo.class, tac);
					}
					break;
				}
			}
		} else if (tramiteAlquilerNoComercial != null) {
			dto.setUsuarioLogado(usuarioLogado.getUsername());
			tramiteDao.creaTareas(dto);
			TareaNotificacion tarNot = null;
			List<TareaExterna> tareasActivas4 = activoTramiteApi.getListaTareaExternaActivasByIdTramite(tramiteAlquilerNoComercial.getId());
			for (TareaExterna tarea : tareasActivas4) {
				if (dto.getCodigoTarea().equals(tarea.getTareaProcedimiento().getCodigo())) {
					tareaNueva = tarea;
					tarNot = tarea.getTareaPadre();
					if (!Checks.esNulo(tarNot)) {
						TareaActivo tac = genericDao.get(TareaActivo.class, genericDao.createFilter(FilterType.EQUALS, "id", tarNot.getId()));
						if(Checks.esNulo(tac)) {
							tac = new TareaActivo();
							tac.setActivo(tramiteAlquilerNoComercial.getActivo());
							tac.setId(tarNot.getId());
							tac.setTramite(tramiteAlquilerNoComercial);
							tac.setAuditoria(Auditoria.getNewInstance());
						}
							tac.setUsuario(usuarioLogado);
						genericDao.save(TareaActivo.class, tac);
					}
					break;
				}
			}
		}
		
		return tareaNueva;
	}
	
	private void sendMailBloqueoExpediente(ExpedienteComercial expediente) {
		Posicionamiento posicionamiento = expediente.getUltimoPosicionamiento();
		ArrayList<String> mailsPara = this.obtnerEmailsBloqueoExpediente(expediente);
		String asunto = "Bloqueo del expediente comercial ".concat(String.valueOf(expediente.getNumExpediente()));
		String cuerpo = "El expediente ".concat(String.valueOf(expediente.getNumExpediente()))
				+ " con el Nº de Oferta ".concat(String.valueOf(expediente.getOferta().getNumOferta()))
				+ " y el Nº de Activo ".concat(String.valueOf(expediente.getOferta().getActivoPrincipal().getNumActivo()))
				+ " se ha posicionado correctamente para su firma el" + " día #Fecha_posicionamiento a las "
				+ "#Hora_posicionamiento en la notaría #Notaria";

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
	}
	
	
	@Transactional(readOnly = false)
	private void guardarBloqueoExpediente(ExpedienteComercial expediente) {
		expediente.setBloqueado(1);
		genericDao.update(ExpedienteComercial.class, expediente);
	}
	
	private void sendMailDesbloqueoExpediente(ExpedienteComercial expediente) {
		String motivoDescLibre = "";
		
		if(expediente.getMotivoDesbloqueoDescLibre() == null && expediente.getMotivoDesbloqueo() != null) {
			motivoDescLibre = expediente.getMotivoDesbloqueo().getDescripcionLarga();
		}

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		ArrayList<String> mailsPara = this.obtnerEmailsBloqueoExpediente(expediente);
		String asunto = "Desbloqueo del expediente comercial ".concat(String.valueOf(expediente.getNumExpediente()));
		String cuerpo = "El expediente ".concat(String.valueOf(expediente.getNumExpediente())) + " se ha desbloqueado por el usuario #Usuario_logado por motivo: #Motivo";

		cuerpo = cuerpo.replace("#Usuario_logado", usuarioLogado.getApellidoNombre());
		cuerpo = cuerpo.replace("#Motivo", motivoDescLibre);
		genericAdapter.sendMail(mailsPara, new ArrayList<String>(), asunto, cuerpo);
	}
	
	@Transactional(readOnly = false)
	private void guardarDesbloqueoExpediente(ExpedienteComercial expediente, String motivoCodigo, String motivoDescLibre) {

		DDMotivosDesbloqueo motivoDesbloqueo = null;
		expediente.setBloqueado(0);

		if (!Checks.esNulo(motivoCodigo)) {
			motivoDesbloqueo = genericDao.get(DDMotivosDesbloqueo.class,genericDao.createFilter(FilterType.EQUALS, "codigo", motivoCodigo));
			expediente.setMotivoDesbloqueo(motivoDesbloqueo);
		}

		expediente.setMotivoDesbloqueoDescLibre(motivoDescLibre);
		genericDao.update(ExpedienteComercial.class, expediente);
	}

	@Override
	@Transactional(readOnly = false)
	public void setValoresTEB(WebDto dto, TareaExterna tarea, String codigoTarea) throws IllegalArgumentException, IllegalAccessException {
		List<String> camposGuardar = ValorTareaBC.getCampoByTarea(codigoTarea);

		Filter filtroIdTarea = genericDao.createFilter(FilterType.EQUALS, "tareaExterna.id", tarea.getId());
		Field[] fs =  dto.getClass().getDeclaredFields();
		for (Field field : fs) {
			field.setAccessible(true);
			String campo = field.getName();
			if(camposGuardar.contains(campo)) {
				String valor = this.getValorFromField((Object) field.get(dto));
				Filter filtroNombreCampo = genericDao.createFilter(FilterType.EQUALS, "campo", campo);
				ValorTareaBC val = genericDao.get(ValorTareaBC.class, filtroIdTarea, filtroNombreCampo );
				
				if(val == null) {
					val = new ValorTareaBC();
					val.setTareaExterna(tarea);
					val.setCampo(campo);
					val.setAuditoria(Auditoria.getNewInstance());
				}
				if(!Checks.esNulo(valor)) {
					val.setValor(valor);
				}
				genericDao.save(ValorTareaBC.class, val);
				
			}
		}
	}

	private String getValorFromField(Object object) {
		String field = null;
		if (object != null) {
			if (object instanceof String){
				field = object.toString();
			}else if(object instanceof Date){
				Date d  = (Date) object;
				field = ft.format(d);
			}else  {
				field = String.valueOf(object);
			}
		}
		
		return field;
	}
	
	@Override
	public WebDto devolverValoresTEB(Long idTarea, String codigoTarea) throws IllegalAccessException, InvocationTargetException {
		WebDto dto = null;
		TareaNotificacion tar = genericDao.get(TareaNotificacion.class,  genericDao.createFilter(FilterType.EQUALS, "id", idTarea));
		if(tar != null && tar.getTareaExterna() != null) {
			
			List<ValorTareaBC> valores = genericDao.getList(ValorTareaBC.class,  genericDao.createFilter(FilterType.EQUALS, "tareaExterna.id", tar.getTareaExterna().getId()));	
			if(ComercialUserAssigantionService.CODIGO_T017_BLOQUEOSCREENING.equals(codigoTarea)) {
				dto = new DtoScreening();
			} else if(ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_BLOQUEOSCREENING.equals(codigoTarea)) {
				dto = new DtoScreening();
			}else if(ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_ELEVAR_SANCION.equals(codigoTarea)) {
				dto = new DtoAccionAprobacionCaixa();
			} else if (ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_BLOQUEOSCREENING.equals(codigoTarea)) {
				dto = new DtoScreening();
			}
			if(valores != null) {
				for (ValorTareaBC valorTareaBC : valores) {
					beanUtilNotNull.copyProperty(dto, valorTareaBC.getCampo(), valorTareaBC.getValor());
				}
			}
		}
		
		return dto;
	}
	
	
	private void avanzarTareaScreening(Long idTareaExterna, Long idTareaNotificacion) throws Exception {
		Map<String, String[]> valoresTarea = new HashMap<String, String[]>();
		List<ValorTareaBC> valores = genericDao.getList(ValorTareaBC.class,  genericDao.createFilter(FilterType.EQUALS, "tareaExterna.id", idTareaExterna));	
		if(valores != null && !valores.isEmpty()) {
			valoresTarea.put("idTarea", new String[] { idTareaNotificacion.toString() });
			for (ValorTareaBC valorTareaBC : valores) {
				valoresTarea.put(valorTareaBC.getCampo(), new String[] { valorTareaBC.getValor() });
			}
		}
		
		agendaAdapter.save(valoresTarea);
	}
	
	@Transactional(readOnly = false)
	private void actualizarEstadoBCInterlocutores(ExpedienteComercial eco, DDEstadoComunicacionC4C estado) {
		List<InterlocutorExpediente> interlocutores = genericDao.getList(InterlocutorExpediente.class,  genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", eco.getId()));
		if(interlocutores != null && !interlocutores.isEmpty()) {
			for (InterlocutorExpediente interlocutorExpediente : interlocutores) {
				if(interlocutorExpediente.getInterlocutorPBCCaixa() != null && interlocutorExpediente.getInterlocutorPBCCaixa().getInfoAdicionalPersona() != null) {
					InfoAdicionalPersona ipa = interlocutorExpediente.getInterlocutorPBCCaixa().getInfoAdicionalPersona();
					ipa.setEstadoComunicacionC4C(estado);
					genericDao.save(InfoAdicionalPersona.class, ipa);	
				}
			}
		}
	}
	
	@Transactional(readOnly = false)
	private void actualizarEstadoBCCompradores(ExpedienteComercial eco, DDEstadoComunicacionC4C estado ) {
		List<CompradorExpediente> compradoresExpediente = genericDao.getList(CompradorExpediente.class,  genericDao.createFilter(FilterType.EQUALS, "expediente", eco.getId()));
		if(compradoresExpediente != null && !compradoresExpediente.isEmpty()) {
			for (CompradorExpediente compradorExpediente : compradoresExpediente) {
				Comprador comprador = genericDao.get(Comprador.class,  genericDao.createFilter(FilterType.EQUALS, "id", compradorExpediente.getComprador()));
				if(comprador != null && comprador.getInfoAdicionalPersona() != null) {
					InfoAdicionalPersona ipa = comprador.getInfoAdicionalPersona();
					ipa.setEstadoComunicacionC4C(estado);
					genericDao.save(InfoAdicionalPersona.class, ipa);	
				}	
			}
		}
	}
	
	@Transactional(readOnly = false)
	private void createOrUpdatePropuesta(FechaArrasExpediente fae, DtoGridFechaArras dto, Long idExpediente) {
		if(fae == null) {
			fae = new FechaArrasExpediente();
			ExpedienteComercial eco = this.findOne(idExpediente);
			fae.setExpedienteComercial(eco);
			
		}
		this.dtoToPropuesta(fae, dto);
		
		genericDao.save(FechaArrasExpediente.class, fae);

	}
	
	@Override
	@Transactional(readOnly = false)
	public void createOrUpdateUltimaPropuesta(Long idExpediente, DtoGridFechaArras dto) {
		FechaArrasExpediente fechaArrasExpediente =  this.getUltimaPropuesta(idExpediente,null);
		
		this.createOrUpdatePropuesta(fechaArrasExpediente,dto,idExpediente);
	}
	
	private List<FechaArrasExpediente> listFechaArrasFiltradaSinAnulados(List<FechaArrasExpediente> listaFechaArrasExp){
		List<FechaArrasExpediente> listaAux = new ArrayList<FechaArrasExpediente>();
		for (FechaArrasExpediente fechaArrasExp : listaFechaArrasExp) {
			if (!DDMotivosEstadoBC.isAnulado(fechaArrasExp.getValidacionBC())) {
				listaAux.add(fechaArrasExp);
			}
		}
		return listaAux;
	}
		

	
	private String tieneNumeroInmuebleBC(String cuerpo, ActivoTramite tramite) {
		if ((tramite.getTipoTramite() == null || CODIGO_TRAMITE_T015.equals(tramite.getTipoTramite().getCodigo())) 
			&& DDCartera.isCarteraBk(tramite.getActivo().getCartera())
			&& !Checks.esNulo(tramite.getActivo().getNumActivoCaixa())) {
			cuerpo = MENSAJE_BC + tramite.getActivo().getNumActivoCaixa() + ",\n" + cuerpo;
		}
		return cuerpo;
	}
	
	@Override
	public List<DDEntidadFinanciera> getListEntidadFinanciera(Long idExpediente) {
		
		List<DDEntidadFinanciera> entidadesFinancieras;
		ExpedienteComercial eco = this.findOne(idExpediente);
		if(eco != null && eco.getOferta() != null && eco.getOferta().getActivoPrincipal() != null && DDCartera.isCarteraBk(eco.getOferta().getActivoPrincipal().getCartera())) {
			entidadesFinancieras = genericDao.getList(DDEntidadFinanciera.class);
		}else {
			Filter filtro = genericDao.createFilter(FilterType.NULL, "codigoCaixa");
			entidadesFinancieras = genericDao.getList(DDEntidadFinanciera.class, filtro);
		}
		
		return entidadesFinancieras;
	}
	
	@Override
	public boolean isEmpleadoCaixa(Oferta oferta) {
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id" ,oferta.getId()));
		boolean isEmpleadoCaixa = false;
		if (expediente != null) {
			List<CompradorExpediente> listaCompradores = expediente.getCompradores();
			for (CompradorExpediente compradorExpediente : listaCompradores) {
				if (compradorExpediente.getVinculoCaixa() != null) {
					isEmpleadoCaixa = true;
					break;
				}
			}
		}
		return isEmpleadoCaixa;
	}


	@Override
	@Transactional
	public boolean doTramitacionAsincrona(Activo activo, Oferta oferta) {
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			String usuarioLogado = genericAdapter.getUsuarioLogado().getUsername();
			ExpedienteComercial expediente = oferta.getExpedienteComercial();
			
			Thread creacionAsincrona = new Thread(new TramitacionOfertasAsync(activo.getId(), true,
					expediente.getTrabajo().getId(), oferta.getId(), expediente.getId(), usuarioLogado));
	
			creacionAsincrona.start();
			 		
			transactionManager.commit(transaction);
			return true;
		}catch(Exception e) {
			transactionManager.rollback(transaction);
			return false;
		}
	}
	
	@Override
	@Transactional(readOnly = false)
	public void createReservaAndCondicionesReagendarArras(ExpedienteComercial expediente, Double importe, Integer mesesFianza, Oferta oferta) {
		Reserva reserva = expediente.getReserva();
		if (reserva == null) {
			reserva = new Reserva();
			reserva.setExpediente(expediente);
			reserva.setNumReserva(reservaDao.getNextNumReservaRem());
			reserva.setAuditoria(Auditoria.getNewInstance());

		}
		if (reserva != null) {
			DDEstadosReserva estadoReserva = (DDEstadosReserva) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDEstadosReserva.class, DDEstadosReserva.CODIGO_PENDIENTE_FIRMA);
			reserva.setEstadoReserva(estadoReserva);

			DDTiposArras tipoArras = (DDTiposArras) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposArras.class,
					DDTiposArras.PENITENCIALES);
			reserva.setTipoArras(tipoArras);
		}
		
		CondicionanteExpediente condiciones = expediente.getCondicionante();
		if (condiciones == null) {
			condiciones = new CondicionanteExpediente();
			condiciones.setExpediente(expediente);
			condiciones.setAuditoria(Auditoria.getNewInstance());
		}
		if (condiciones != null) {
			DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCalculo.class,
					DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO);
			condiciones.setImporteReserva(importe);
			condiciones.setMesesFianza(mesesFianza);
			condiciones.setPlazoFirmaReserva(mesesFianza*30);
			condiciones.setSolicitaReserva(1);
			condiciones.setTipoCalculoReserva(tipoCalculo);
			
		}
		genericDao.save(Reserva.class, reserva);
		genericDao.save(CondicionanteExpediente.class, condiciones);
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_PBC_ARRAS);
		DDEstadosExpedienteComercial estadoExp = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		expediente.setEstado(estadoExp);
		
		OfertaCaixa ofertaCaixa = genericDao.get(OfertaCaixa.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));
		if (ofertaCaixa != null) {
			if (ofertaCaixa.getRiesgoOperacion() != null) {
				Filter filtroBc = null;
				if (DDRiesgoOperacion.CODIGO_ROP_ALTO.equals(ofertaCaixa.getRiesgoOperacion().getCodigo())) {
					filtroBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_ARRAS_PENDIENTES_DE_APROBACION_BC);
				}else {
					filtroBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_PTE_AGENDAR_ARRAS);
				}
				DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, filtroBc);
				expediente.setEstadoBc(estadoBc);
			}
		}
		
		genericDao.save(ExpedienteComercial.class, expediente);
		
		
	}

	private boolean tieneInterlocutoresNoEnviados(ExpedienteComercial eco){

		List<InfoAdicionalPersona> infoAdicionalPersonas = new ArrayList<InfoAdicionalPersona>();

		final String CODIGO_NOTARIA = "NOTARI";
		final String CODIGO_GESTORIA_FORMALIZACION = "GIAFORM";


		addIapToList(infoAdicionalPersonas,eco.getOferta().getCliente().getInfoAdicionalPersona());

		if (eco.getOferta().getPrescriptor() != null){
			addIapToList(infoAdicionalPersonas,eco.getOferta().getPrescriptor().getInfoAdicionalPersona());
		}

		if (eco.getOferta().getCustodio() != null){
			addIapToList(infoAdicionalPersonas,eco.getOferta().getCustodio().getInfoAdicionalPersona());
		}

		for (GestorExpedienteComercial gec: genericDao.getList(GestorExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"expedienteComercial.id",eco.getId()))) {
			if ((gec.getTipoGestor()!= null && CODIGO_NOTARIA.equals(gec.getTipoGestor().getCodigo())) || (gec.getTipoGestor()!= null && CODIGO_GESTORIA_FORMALIZACION.equals(gec.getTipoGestor().getCodigo())) && gec.getUsuario() != null){
				ActivoProveedorContacto activoProveedorContacto = genericDao.get(ActivoProveedorContacto.class,genericDao.createFilter(FilterType.EQUALS,"usuario.id",gec.getUsuario().getId()),
						genericDao.createFilter(FilterType.EQUALS,"proveedor.estadoProveedor.codigo", DDEstadoProveedor.ESTADO_BIGENTE),genericDao.createFilter(FilterType.NOTNULL,"proveedor.fechaBaja"));
				if (activoProveedorContacto != null && activoProveedorContacto.getProveedor() != null){
					addIapToList(infoAdicionalPersonas,activoProveedorContacto.getProveedor().getInfoAdicionalPersona());
				}
			}
		}

		for (CompradorExpediente cex:eco.getCompradores()) {
			addIapToList(infoAdicionalPersonas,cex.getPrimaryKey().getComprador().getInfoAdicionalPersona());
			addIapToList(infoAdicionalPersonas,cex.getInfoAdicionalRepresentante());
		}

		for (TitularesAdicionalesOferta tia:eco.getOferta().getTitularesAdicionales()) {
			addIapToList(infoAdicionalPersonas,tia.getInfoAdicionalPersona());
		}

		for (InterlocutorExpediente iex:eco.getInterlocutoresExpediente()) {
			if(iex.getInterlocutorPBCCaixa() != null){
				addIapToList(infoAdicionalPersonas,iex.getInterlocutorPBCCaixa().getInfoAdicionalPersona());
			}
		}

		for (InfoAdicionalPersona iap:infoAdicionalPersonas) {
			if (iap.getEstadoComunicacionC4C() != null && (DDEstadoComunicacionC4C.C4C_NO_ENVIADO.equals(iap.getEstadoComunicacionC4C().getCodigo()) || DDEstadoComunicacionC4C.C4C_PTE_VALIDACION.equals(iap.getEstadoComunicacionC4C().getCodigo()))){
				return true;
			}
		}

		return false;
	}

	private void addIapToList(List<InfoAdicionalPersona> iaps, InfoAdicionalPersona iap){
		if (iap != null){
			iaps.add(iap);
		}
	}

	@Override
	public List<DtoActualizacionRenta> getActualizacionRenta (Long idExpediente) throws IllegalAccessException, InvocationTargetException {
		List<DtoActualizacionRenta> listActualizacionesRentaLibre = new ArrayList<DtoActualizacionRenta>();
		ExpedienteComercial eco = this.findOne(idExpediente);
		if(eco != null) {
			CondicionanteExpediente coe = eco.getCondicionante();
			if(coe != null) {
				Filter filtroCoe = genericDao.createFilter(FilterType.EQUALS, "condicionanteExpediente.id", coe.getId());
				Order order = new Order(GenericABMDao.OrderType.DESC, "fechaActualizacion");

				List<ActualizacionRentaLibre> arlList = genericDao.getListOrdered(ActualizacionRentaLibre.class, order, filtroCoe);
				if(arlList != null && !arlList.isEmpty()) {
					for (ActualizacionRentaLibre actualizacionRentaLibre : arlList) {
						DtoActualizacionRenta dto = new DtoActualizacionRenta();
						beanUtilNotNull.copyProperties(dto, actualizacionRentaLibre);
						if(actualizacionRentaLibre.getMetodoActualizacionRenta() != null) {
							dto.setTipoActualizacionCodigo(actualizacionRentaLibre.getMetodoActualizacionRenta().getCodigo());
						}
						
						listActualizacionesRentaLibre.add(dto);
					}
				}
			}
		}
		
		return listActualizacionesRentaLibre;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void deleteActualizacionRenta(Long id){
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActualizacionRentaLibre arl = genericDao.get(ActualizacionRentaLibre.class, filter);
		
		if(arl != null) {
			Auditoria.delete(arl);
			genericDao.save(ActualizacionRentaLibre.class, arl);
		}		
	}
	
	private ActualizacionRentaLibre dtoToActualizacionRentaLibre (ActualizacionRentaLibre arl, DtoActualizacionRenta dto ) throws IllegalAccessException, InvocationTargetException {
		beanUtilNotNull.copyProperties(arl, dto);
		if(dto.getTipoActualizacionCodigo() != null) {
			DDMetodoActualizacionRenta metodoActualizacionRenta = (DDMetodoActualizacionRenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDMetodoActualizacionRenta.class, dto.getTipoActualizacionCodigo());
			arl.setMetodoActualizacionRenta(metodoActualizacionRenta);
		}
		return arl;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void addActualizacionRenta(Long idExpediente, DtoActualizacionRenta dto ) throws IllegalAccessException, InvocationTargetException{
		ExpedienteComercial eco = this.findOne(idExpediente);
		if(eco != null) {
			CondicionanteExpediente coe = eco.getCondicionante();
			if(coe != null) {
				ActualizacionRentaLibre arl = new ActualizacionRentaLibre();
				arl.setCondicionanteExpediente(coe);
				arl = this.dtoToActualizacionRentaLibre(arl, dto);
				arl.setAuditoria(Auditoria.getNewInstance());
				genericDao.save(ActualizacionRentaLibre.class, arl);				
			}
		}
	}
	
	@Override
	@Transactional(readOnly = false)
	public void updateActualizacionRenta(Long id, DtoActualizacionRenta dto ) throws IllegalAccessException, InvocationTargetException{
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActualizacionRentaLibre arl = genericDao.get(ActualizacionRentaLibre.class, filter);
		
		if(arl != null) {
			arl = this.dtoToActualizacionRentaLibre(arl, dto);
			Auditoria.save(arl);
			genericDao.save(ActualizacionRentaLibre.class, arl);	
		}
			
		
	}
	
	@Override
	public List<DtoRespuestaBCGenerica> getSancionesBk(Long idExpediente) {
		
		List<DtoRespuestaBCGenerica> listDtos = new ArrayList<DtoRespuestaBCGenerica>();
		
		DtoRespuestaBCGenerica dtoComercial = new DtoRespuestaBCGenerica();
		dtoComercial.setComite(RespuestaComiteBC.COMITE_COMERCIAL);
		listDtos.add(dtoComercial);
		DtoRespuestaBCGenerica dtoClRod = new DtoRespuestaBCGenerica();
		dtoClRod.setComite(RespuestaComiteBC.COMITE_CL_ROD);
		listDtos.add(dtoClRod);
		
		List<DtoRespuestaBCGenerica> dtoRespuestaBCGenericaList = this.getListResolucionComiteBC(idExpediente);
		
		if (dtoRespuestaBCGenericaList != null && !dtoRespuestaBCGenericaList.isEmpty()) {
			for (DtoRespuestaBCGenerica dtoRespuestaBCGenerica : dtoRespuestaBCGenericaList) {
				if (RespuestaComiteBC.COMITE_COMERCIAL.equalsIgnoreCase(dtoRespuestaBCGenerica.getComite()) && listDtos.contains(dtoComercial)) {
					listDtos.remove(dtoComercial);
				} else if (RespuestaComiteBC.COMITE_CL_ROD.equalsIgnoreCase(dtoRespuestaBCGenerica.getComite()) && listDtos.contains(dtoComercial)) {
					listDtos.remove(dtoClRod);
				}
			}
			
			listDtos.addAll(dtoRespuestaBCGenericaList);
		}		
		
//		ExpedienteComercial eco = this.findOne(idExpediente);
//		if(eco != null && eco.getTrabajo() != null) {
//			ActivoTramite tra = genericDao.get(ActivoTramite.class, genericDao.createFilter(FilterType.EQUALS, "trabajo.id", eco.getTrabajo().getId()));
//			//TODO añadir la sanción Comité lanzamiento/ROD para cuando esté el trámite de alquiler no comercial
//		}
		
		
		return listDtos;
	}



	@Transactional
	private void assignIAPCompradorRepresentante(CompradorExpediente compradorExpediente, Long expedienteID, Comprador comprador,Oferta oferta){

		
		if(comprador.getIdPersonaHayaCaixa() == null || comprador.getIdPersonaHayaCaixa().trim().isEmpty()) {
			comprador.setIdPersonaHayaCaixa(interlocutorCaixaService.getIdPersonaHayaCaixa(oferta,null,comprador.getDocumento()));
		}
		if (comprador.getIdPersonaHaya() == null){
			String idPersonaHaya = interlocutorGenericService.getIdPersonaHayaClienteHayaByDocumento(comprador.getDocumento());
			comprador.setIdPersonaHaya(idPersonaHaya != null ? Long.parseLong(idPersonaHaya) : null);
		}

		InfoAdicionalPersona iap = interlocutorCaixaService.getIapCaixaOrDefault(comprador.getInfoAdicionalPersona(),comprador.getIdPersonaHayaCaixa(),comprador.getIdPersonaHaya() != null ? comprador.getIdPersonaHaya().toString() : null);
		comprador.setInfoAdicionalPersona(iap);

		if (iap != null){
			iap.setRolInterlocutor(genericDao.get(DDRolInterlocutor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDRolInterlocutor.COD_CLIENTE_FINAL)));
			genericDao.save(InfoAdicionalPersona.class, iap);
		}

		if (compradorExpediente.getDocumentoRepresentante() != null && !compradorExpediente.getDocumentoRepresentante().isEmpty()){

			if (compradorExpediente.getIdPersonaHayaRepresentante() == null){
				String idPersonaHaya = interlocutorGenericService.getIdPersonaHayaClienteHayaByDocumento(compradorExpediente.getDocumentoRepresentante());
				compradorExpediente.setIdPersonaHayaRepresentante(idPersonaHaya != null ? Long.parseLong(idPersonaHaya) : null);
			}

			if(compradorExpediente.getIdPersonaHayaCaixaRepresentante() == null || compradorExpediente.getIdPersonaHayaCaixaRepresentante().trim().isEmpty()) {
				compradorExpediente.setIdPersonaHayaCaixaRepresentante(interlocutorCaixaService.getIdPersonaHayaCaixa(oferta,null,compradorExpediente.getDocumentoRepresentante()));
			}

			InfoAdicionalPersona iapRepresentante = interlocutorCaixaService.getIapCaixaOrDefault(compradorExpediente.getInfoAdicionalRepresentante(),compradorExpediente.getIdPersonaHayaCaixaRepresentante(),compradorExpediente.getIdPersonaHayaRepresentante() != null ? compradorExpediente.getIdPersonaHayaRepresentante().toString() : null);
			compradorExpediente.setInfoAdicionalRepresentante(iapRepresentante);

			if (iapRepresentante != null){
				iapRepresentante.setRolInterlocutor(genericDao.get(DDRolInterlocutor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDRolInterlocutor.COD_CLIENTE_FINAL)));
				genericDao.save(InfoAdicionalPersona.class, iapRepresentante);
			}
		}
	}
	@Override
	@Transactional(readOnly = false)
	public boolean saveFormalizacionResolucion(DtoFormalizacionResolucion dto) {

		if (dto.getId() == null) {
			return false;
		}
		ExpedienteComercial expediente = this.findOne(Long.parseLong(dto.getId()));
		
		if (!Checks.esNulo(expediente)) {	
			Oferta oferta = expediente.getOferta();
			Formalizacion formalizacion = expediente.getFormalizacion();
			
			if (dto.getVentaPlazos() != null) {
				formalizacion.setVentaPlazos(dto.getVentaPlazos());
			}
			if (dto.getCesionRemate() != null) {
				formalizacion.setCesionRemate(dto.getCesionRemate());
			}
			if (dto.getContratoPrivado() != null) {
				formalizacion.setContratoPrivado(dto.getContratoPrivado());
			}
			
			if(oferta != null) {
				if(!Checks.isFechaNula(dto.getFechaInicioCnt())) {
					oferta.setFechaInicioContrato(dto.getFechaInicioCnt());
				}
				if(!Checks.isFechaNula(dto.getFechaFinCnt())) {
					oferta.setFechaFinContrato(dto.getFechaFinCnt());
				}
				
				genericDao.save(Oferta.class, oferta);
			}
			
			genericDao.save(Formalizacion.class, formalizacion);

		}
		return true;
	}

	@Override
	@Transactional(readOnly = true)
	public ReplicarOfertaDto buildReplicarOfertaDtoFromExpediente(final ExpedienteComercial eco){
		return new ReplicarOfertaDto(){{
			setNumeroOferta(eco.getOferta().getNumOferta());
			setEstadoExpedienteBcCodigoBC(eco.getEstadoBc() != null ? eco.getEstadoBc().getCodigoC4C() : null);
		}};
	}

	@Override
	@Transactional(readOnly = true)
	public ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndArras(final ExpedienteComercial eco, final String fechaPropuesta){
		return new ReplicarOfertaDto(){{
			setNumeroOferta(eco.getOferta().getNumOferta());
			setEstadoExpedienteBcCodigoBC(eco.getEstadoBc().getCodigoC4C());
			setFechaPropuesta(fechaPropuesta);
		}};
	}

	@Override
	@Transactional(readOnly = true)
	public ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndCodEstadoAlquiler(final ExpedienteComercial eco,final String codEstadoAlquiler){
		return new ReplicarOfertaDto(){{
			setNumeroOferta(eco.getOferta().getNumOferta());
			setEstadoExpedienteBcCodigoBC(eco.getEstadoBc().getCodigoC4C());
			setCodEstadoAlquiler(codEstadoAlquiler);
		}};
	}

	@Override
	@Transactional(readOnly = true)
	public ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndEstadoArras(final ExpedienteComercial eco, final String estadoArras){
		return new ReplicarOfertaDto(){{
			setNumeroOferta(eco.getOferta().getNumOferta());
			setEstadoExpedienteBcCodigoBC(eco.getEstadoBc().getCodigoC4C());
			setEstadoArras(estadoArras);
		}};
	}

	@Override
	@Transactional(readOnly = true)
	public ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndVerificarScoring(final ExpedienteComercial eco, final ScoringAlquiler scoring){
		return new ReplicarOfertaDto(){{
			setNumeroOferta(eco.getOferta().getNumOferta());
			setEstadoExpedienteBcCodigoBC(eco.getEstadoBc().getCodigoC4C());
			setEstadoScoringAlquilerCodigoBC(scoring != null && scoring.getResultadoScoringServicer() != null ? scoring.getResultadoScoringServicer().getCodigo() : null);
			setCodResultadoScoringBc(scoring != null && scoring.getResultadoScoringBc() != null ? scoring.getResultadoScoringBc().getCodigo() : null);
			setRatingScoringServicerC4c(scoring != null && scoring.getRatingScoringServicer() != null ? scoring.getRatingScoringServicer().getCodigoC4c() : null);
			setFechaScoringBc(scoring != null && scoring.getFechaSancionBc() != null ? ft.format(scoring.getFechaSancionBc()) : null);
		}};
	}
	
	@Override
	@Transactional(readOnly = true)
	public ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndScoringBc(final ExpedienteComercial eco, final String resultadoScoring, final String fecha){
		return new ReplicarOfertaDto(){{
			setNumeroOferta(eco.getOferta().getNumOferta());
			setEstadoExpedienteBcCodigoBC(eco.getEstadoBc().getCodigoC4C());
			setCodResultadoScoringBc(resultadoScoring);
			setFechaScoringBc(fecha);
		}};
	}

	@Override
	@Transactional(readOnly = true)
	public ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndCex(final ExpedienteComercial eco, CompradorExpediente cex){
		final CexDto cexDto = buildCexDtoFromCex(cex);
		return new ReplicarOfertaDto(){{
			setNumeroOferta(eco.getOferta().getNumOferta());
			setEstadoExpedienteBcCodigoBC(eco.getEstadoBc().getCodigoC4C());
			setCompradorEditado(cexDto);
		}};
	}

	private CexDto buildCexDtoFromCex(CompradorExpediente cex) {
		CexDto dto = new CexDto();

		dto.setTitularContratacion(cex.getTitularContratacion());
		dto.setInterlocutorOfertaCod(cex.getInterlocutorOferta() != null ? cex.getInterlocutorOferta().getCodigoC4C() : null);
		dto.setPorcionCompra(cex.getPorcionCompra());
		dto.setAntiguoDeudor(cex.getAntiguoDeudor());
		dto.setVinculoCaixaCod(cex.getVinculoCaixa() != null ? cex.getVinculoCaixa().getCodigo() : null);
		dto.setEstadoInterlocutorCod(cex.getEstadoInterlocutor() != null ? cex.getEstadoInterlocutor().getCodigo() : null);
		dto.setIdComprador(cex.getComprador());

		Comprador com = cex.getPrimaryKey().getComprador();

		dto.setIdPersonaHayaCaixa(com != null ? com.getIdPersonaHayaCaixa() : null);

		return dto;
	}

	@Override
	@Transactional(readOnly = true)
	public ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndRespuestaComprador(final ExpedienteComercial eco, final String codRespuestaComprador){
		return new ReplicarOfertaDto(){{
			setNumeroOferta(eco.getOferta().getNumOferta());
			setEstadoExpedienteBcCodigoBC(eco.getEstadoBc().getCodigoC4C());
			setCodRespuestaComprador(codRespuestaComprador);
		}};
	}
	
	@Override
	@Transactional(readOnly = true)
	public ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndSancionCLROD(final ExpedienteComercial eco, final String sancionCLROD){
		return new ReplicarOfertaDto(){{
			setNumeroOferta(eco.getOferta().getNumOferta());
			setEstadoExpedienteBcCodigoBC(eco.getEstadoBc().getCodigoC4C());
			setSancionCLROD(sancionCLROD);
		}};
	}
	
	@Override
	@Transactional(readOnly = true)
	public ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndFechaFirma(final ExpedienteComercial eco, final String fechaFirma){
		return new ReplicarOfertaDto(){{
			setNumeroOferta(eco.getOferta().getNumOferta());
			setEstadoExpedienteBcCodigoBC(eco.getEstadoBc().getCodigoC4C());
			setFechaFirma(fechaFirma);
		}};
	}
	
	@Override
	@Transactional(readOnly = true)
	public ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndFechaEnvio(final ExpedienteComercial eco, final String fechaEnvio){
		return new ReplicarOfertaDto(){{
			setNumeroOferta(eco.getOferta().getNumOferta());
			setEstadoExpedienteBcCodigoBC(eco.getEstadoBc().getCodigoC4C());
			setFechaEnvio(fechaEnvio);
		}};
	}
	
	@Override
	public Formalizacion formalizacionPorExpedienteComercial(Long idExpediente) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);

		return genericDao.get(Formalizacion.class, filtro);
	}

	private DtoGarantiasExpediente expedienteToDtoGarantias(ExpedienteComercial expediente) {
		DtoGarantiasExpediente dto = new DtoGarantiasExpediente();
		if (expediente != null) {
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId());
			ScoringAlquiler scoring = genericDao.get(ScoringAlquiler.class, filter);
			CondicionanteExpediente coe = genericDao.get(CondicionanteExpediente.class, filter);
			SeguroRentasAlquiler sra = genericDao.get(SeguroRentasAlquiler.class, filter);
			
			if (scoring != null) {
				
				if (scoring.getRatingScoringServicer() != null) {
					dto.setRatingHayaCod(scoring.getRatingScoringServicer().getCodigo());
					dto.setRatingHayaDesc(scoring.getRatingScoringServicer().getDescripcion());
				}
				if (scoring.getMotivoRechazo() != null) {
					dto.setMotivoRechazo(scoring.getMotivoRechazo());
				}
				if (scoring.getFechaSancionBc() != null) {
					dto.setFechaSancion(scoring.getFechaSancionBc());
				}
				if (scoring.getResultadoScoringBc() != null) {
					dto.setResultadoHayaCod(scoring.getResultadoScoringBc().getCodigo());
					dto.setResultadoHayaDesc(scoring.getResultadoScoringBc().getDescripcion());
				}
				if (scoring.getResultadoScoring() != null) {
					dto.setResultadoPropiedadCod(scoring.getResultadoScoring().getCodigo());
					dto.setResultadoPropiedadDesc(scoring.getResultadoScoring().getDescripcion());
				}
				if (scoring.getNumeroExpedienteBc() != null) {
					dto.setNumeroExpediente(scoring.getNumeroExpedienteBc());
				}
			}
			if (coe != null) {
				if (coe.getScoringBc() != null) {
					dto.setScoring(coe.getScoringBc());
				}
				if (coe.getAvalBc()!= null) {
					dto.setAval(coe.getAvalBc());
				}
				if (coe.getSeguroRentasBc() != null) {
					dto.setSeguroRentas(coe.getSeguroRentasBc());
				}
				if (coe.getEntidadBancariaFiador() != null) {
					dto.setEntidadBancariaCod(coe.getEntidadBancariaFiador().getCodigo());
					dto.setEntidadBancariaDesc(coe.getEntidadBancariaFiador().getDescripcion());
				}
				if (coe.getMesesAval() != null) {
					dto.setMesesAval(coe.getMesesAval().longValue());
				}
				if (coe.getFechaVencimientoAvalBc() != null) {
					dto.setFechaVencimiento(coe.getFechaVencimientoAvalBc());
				}
				if (coe.getDocumentoFiador() != null) {
					dto.setDocumento(coe.getDocumentoFiador());
				}
				if (coe.getAvalista() != null) {
					dto.setAvalista(coe.getAvalista());
				}
				if (coe.getImporteAval() != null) {
					dto.setImporteAval(coe.getImporteAval());
				}
				if (!Checks.esNulo(coe.getMesesDeposito())) {
					dto.setMesesDeposito(coe.getMesesDeposito());
				}
				
				if (!Checks.esNulo(coe.getDepositoActualizable())) {
					dto.setDepositoActualizable(coe.getDepositoActualizable());
				}
							
				if (!Checks.esNulo(coe.getImporteDeposito())) {
					dto.setImporteDeposito(coe.getImporteDeposito());
				}
				if(coe.getCheckDeposito() != null && coe.getCheckDeposito()) {
					dto.setCheckDeposito(coe.getCheckDeposito());
				}
				
			}
			if (sra != null) {
				
				if(sra.getAseguradoraProveedor() != null) {
					ActivoProveedor actPve =  genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS,"id", sra.getAseguradoraProveedor().getId()));
					if(actPve != null) {
						dto.setAseguradoraCod(String.valueOf(actPve.getId()));
					}
					dto.setAseguradoraDesc(actPve.getNombre());	
				}
				
				if (sra.getFechaVencimientoRentaslBc() != null) {
					dto.setFechaSancionRentas(sra.getFechaVencimientoRentaslBc());
				}
				if (sra.getMesesAval() != null) {
					dto.setMesesRentas(sra.getMesesAval().longValue());
				}
				if (sra.getImporteRentasBc() != null) {
					dto.setImporteRentas(sra.getImporteRentasBc());
				}
			}
			
			boolean completada = false;
			dto.setScoringEditable(false);
			dto.setBloqueEditable(false);
			
			ActivoTramite tramite = tramiteDao.getTramiteComercialVigenteByTrabajoYCodTipoTramite(expediente.getTrabajo().getId(),CODIGO_TRAMITE_T015);
			if(tramite != null) {
				completada = tareaActivoApi.getSiTareaCompletada(tramite.getId(), ComercialUserAssigantionService.CODIGO_T015_SOLICITAR_GARANTIAS_ADICIONALES);
		
				if (completada) {
					dto.setScoringEditable(false);
					dto.setBloqueDepositoEditable(false);
				}else {
					dto.setBloqueDepositoEditable(true);
					List<TareaProcedimiento> tareasActivas = activoTramiteApi.getTareasActivasByIdTramite(tramite.getId());
					for (TareaProcedimiento tarea : tareasActivas) {
						if (!ComercialUserAssigantionService.CODIGO_T015_VERIFICAR_SCORING.equals(tarea.getCodigo())
								|| !ComercialUserAssigantionService.CODIGO_T015_SOLICITAR_GARANTIAS_ADICIONALES.equals(tarea.getCodigo())) {
							dto.setScoringEditable(true);
							dto.setBloqueEditable(true);
							break;
						} else {
							dto.setScoringEditable(false);						
						}
					}
				}
				
				completada = tareaActivoApi.getSiTareaCompletada(tramite.getId(), ComercialUserAssigantionService.CODIGO_T015_SOLICITAR_GARANTIAS_ADICIONALES);
				
				if(completada) {
					dto.setBloqueEditable(false);
				}else{
					dto.setBloqueEditable(true);
				}
			}
			
			tramite = tramiteDao.getTramiteComercialVigenteByTrabajoYCodTipoTramite(expediente.getTrabajo().getId(),CODIGO_TRAMITE_T018);
			if(tramite != null) {
				completada = tareaActivoApi.getSiTareaCompletada(tramite.getId(), ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_SOLICITAR_GARANTIAS_ADICIONALES);
				
				if(completada) {
					dto.setBloqueEditable(false);
					dto.setBloqueDepositoEditable(false);
				}else{
					dto.setBloqueDepositoEditable(true);
					List<TareaProcedimiento> tareasActivas = activoTramiteApi.getTareasActivasByIdTramite(tramite.getId());
					for (TareaProcedimiento tarea : tareasActivas) {
						if (!ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_SCORING.equals(tarea.getCodigo())
								|| !ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_SOLICITAR_GARANTIAS_ADICIONALES.equals(tarea.getCodigo())) {
							dto.setScoringEditable(true);
							dto.setBloqueEditable(true);
							break;
						} else {
							dto.setScoringEditable(false);						
						}
					}
				}
			}
		}
		return dto;
	}
	@Override
	@Transactional(readOnly = false)
	public boolean saveGarantiasExpediente(DtoGarantiasExpediente dto, Long id) {
		ExpedienteComercial expediente = findOne(id);
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId());
		ScoringAlquiler scoring = genericDao.get(ScoringAlquiler.class, filter);
		CondicionanteExpediente coe = genericDao.get(CondicionanteExpediente.class, filter);
		SeguroRentasAlquiler sra = genericDao.get(SeguroRentasAlquiler.class, filter);
		
		if (scoring == null && (dto.getScoring() != null && Boolean.TRUE.equals(dto.getScoring()))) {
			scoring = new ScoringAlquiler();
			scoring.setAuditoria(Auditoria.getNewInstance());
			scoring.setExpediente(expediente);			
		}
		if (sra == null && (dto.getSeguroRentas() != null && Boolean.TRUE.equals(dto.getSeguroRentas()))) {
			sra = new SeguroRentasAlquiler();
			sra.setAuditoria(Auditoria.getNewInstance());
			sra.setExpediente(expediente);
		}
		
		if (coe != null) {
			if (dto.getScoring() != null) {
				coe.setScoringBc(dto.getScoring());
			}
			if (dto.getAval() != null) {
				coe.setAvalBc(dto.getAval());
			}
			if (dto.getSeguroRentas() != null) {
				coe.setSeguroRentasBc(dto.getSeguroRentas());
			}
			if (dto.getEntidadBancariaCod() != null) {
				DDEntidadesAvalistas entidadAval = (DDEntidadesAvalistas) utilDiccionarioApi.dameValorDiccionarioByCod(DDEntidadesAvalistas.class, dto.getEntidadBancariaCod());
				coe.setEntidadBancariaFiador(entidadAval);
			}
			if (dto.getMesesAval() != null) {
				coe.setMesesAval(dto.getMesesAval().intValue());
			}
			if (!Checks.isFechaNula(dto.getFechaVencimiento())) {
				coe.setFechaVencimientoAvalBc(dto.getFechaVencimiento());
			}else {
				coe.setFechaVencimientoAvalBc(null);
			}	
			if (dto.getDocumento() != null) {
				coe.setDocumentoFiador(dto.getDocumento());
			}			
			if (dto.getAvalista() != null) {
				coe.setAvalista(dto.getAvalista());
			}
			if (dto.getImporteAval() != null) {
				coe.setImporteAval(dto.getImporteAval());
			}
			
			if(dto.getCheckDeposito() != null && dto.getCheckDeposito()){
				coe.setCheckDeposito(dto.getCheckDeposito());
			}else {
				coe.setCheckDeposito(false);
			}
			
			if (!Checks.esNulo(dto.getMesesDeposito())) {
				coe.setMesesDeposito(dto.getMesesDeposito());
			}
			
			if (!Checks.esNulo(dto.getDepositoActualizable())) {
				coe.setDepositoActualizable(dto.getDepositoActualizable());
			}
						
			if (!Checks.esNulo(dto.getImporteDeposito())) {
				coe.setImporteDeposito(dto.getImporteDeposito());
			}
			 
			genericDao.save(CondicionanteExpediente.class, coe);
			
		}
		
		if (sra != null) {
			if(dto.getAseguradoraCod() != null && dto.getAseguradoraCod() != "") {
				ActivoProveedor actPve =  genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS,"id", Long.parseLong(dto.getAseguradoraCod())));
			
				if(actPve != null) {
					sra.setAseguradoraProveedor(actPve);
				}
			}else {
				sra.setAseguradoraProveedor(null);
			}
			if (!Checks.isFechaNula(dto.getFechaSancionRentas())) {
				sra.setFechaVencimientoRentaslBc(dto.getFechaSancionRentas());
			}else {
				sra.setFechaVencimientoRentaslBc(null);
			}	
			if (dto.getMesesRentas() != null) {
				sra.setMesesAval(dto.getMesesRentas().intValue());
			}else {
				sra.setMesesAval(null);
			}
			if (dto.getImporteRentas() != null) {
				sra.setImporteRentasBc(dto.getImporteRentas());
			}else {
				sra.setImporteRentasBc(null);
			}
			genericDao.save(SeguroRentasAlquiler.class, sra);
		}
		
		if (scoring != null) {
			
			if (dto.getRatingHayaCod() != null) {
				DDRatingScoringServicer rating = (DDRatingScoringServicer) utilDiccionarioApi.dameValorDiccionarioByCod(DDRatingScoringServicer.class, dto.getRatingHayaCod());
				scoring.setRatingScoringServicer(rating);
			}
			
			if (dto.getMotivoRechazo() != null) {
				scoring.setMotivoRechazo(dto.getMotivoRechazo());
			}
			if (dto.getFechaSancion() != null) {
				scoring.setFechaSancionBc(dto.getFechaSancion());
			}
			if (dto.getResultadoPropiedadCod() != null) {
				DDResultadoCampo resultadoCampo = (DDResultadoCampo) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoCampo.class, dto.getResultadoPropiedadCod());
				scoring.setResultadoScoring(resultadoCampo);
			}
			if (dto.getResultadoHayaCod() != null) {
				DDResultadoScoring resultadoScoring = (DDResultadoScoring) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoScoring.class, dto.getResultadoHayaCod());
				scoring.setResultadoScoringBc(resultadoScoring);
			}
			if (dto.getNumeroExpediente() != null) {
				scoring.setNumeroExpedienteBc(String.valueOf(dto.getNumeroExpediente()));
			}
			genericDao.save(ScoringAlquiler.class, scoring);
		}
		
		
		return true;
	}
	
	private Boolean updateEstadoInterlocutorCompradores(ExpedienteComercial eco, CompradorExpediente compradorExpediente, String codigoEstadoInterlocutor,
													 Boolean llamaReplicarClientes,DtoCompradorLLamadaBC dtoCompradorLLamadaBC){
		Set<TareaExterna> tareasActivas = activoTramiteApi.getTareasActivasByExpediente(eco);
		List<String> codigoTareasActivas = new ArrayList<String>();
		boolean isAprobado = false;
		
		
		for (TareaExterna tareaExterna : tareasActivas) {
			codigoTareasActivas.add(tareaExterna.getTareaProcedimiento().getCodigo());
		}
		TipoProcedimiento tp = activoTramiteApi.getTipoTramiteByExpediente(eco);
		if(tp != null) {
			String codigoTp = tp.getCodigo();
			if(ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA_APPLE.equals(codigoTp)) {
				isAprobado = tramiteVentaApi.isTramiteT017Aprobado(codigoTareasActivas);
			}else if(ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_ALQUILER.equals(codigoTp)){
				isAprobado = tramiteAlquilerApi.isTramiteT015Aprobado(codigoTareasActivas);
			}else if(ActivoTramiteApi.CODIGO_TRAMITE_ALQUILER_NO_COMERCIAL.equals(codigoTp)){
				isAprobado = tramiteAlquilerNoComercialApi.isTramiteT018Aprobado(codigoTareasActivas);
			}
		}
		
		if(isAprobado) {
			this.updateAndReplicate(eco, compradorExpediente, codigoEstadoInterlocutor, llamaReplicarClientes,dtoCompradorLLamadaBC);
		}else {
			if(DDEstadoInterlocutor.CODIGO_SOLICITUD_BAJA.equals(codigoEstadoInterlocutor)) {
				codigoEstadoInterlocutor = DDEstadoInterlocutor.CODIGO_INACTIVO;
			}else {
				codigoEstadoInterlocutor = DDEstadoInterlocutor.CODIGO_ACTIVO;
			}
			compradorExpediente.setEstadoInterlocutor(genericDao.get(DDEstadoInterlocutor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstadoInterlocutor)));
			genericDao.update(CompradorExpediente.class, compradorExpediente);

		}

		return isAprobado;
		
	}
	
	@Transactional(readOnly = false)
	private void updateAndReplicate(ExpedienteComercial eco, CompradorExpediente compradorExpediente, String codigoEstadoInterlocutor, Boolean llamaReplicarClientes,DtoCompradorLLamadaBC dtoCompradorLLamadaBC){
		compradorExpediente.setEstadoInterlocutor(genericDao.get(DDEstadoInterlocutor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstadoInterlocutor)));
		genericDao.update(CompradorExpediente.class, compradorExpediente);

		if(new BigDecimal(100).equals(eco.getImporteParticipacionTotal()) && !llamaReplicarClientes) {
			this.guardaBloqueoReplicaOferta(eco, compradorExpediente, dtoCompradorLLamadaBC);
		}
	}

	@Transactional
	public void guardaBloqueoReplicaOferta(ExpedienteComercial eco, CompradorExpediente cex,DtoCompradorLLamadaBC dtoCompradorLLamadaBC){
		this.guardarBloqueoExpediente(eco);
		if (dtoCompradorLLamadaBC != null){
			dtoCompradorLLamadaBC.setReplicarOferta(Boolean.TRUE);
			dtoCompradorLLamadaBC.setNumOferta(eco.getOferta().getNumOferta());
		}else
		ofertaApi.replicateOfertaFlushDto(eco.getOferta(),this.buildReplicarOfertaDtoFromExpedienteAndCex(eco, cex));
	}
	
	@Override
	public Boolean checkExpedienteBloqueadoPorFuncion(Long idTramite) {
		Boolean bloqueado = checkExpedienteBloqueado(idTramite);
		Usuario usuario = genericAdapter.getUsuarioLogado();	
		
		if(bloqueado && usuario != null) {
			if(!funcionApi.userHasFunction(FUNCION_AV_ECO_BLOQ, usuario.getUsername())) {
				bloqueado = true;
			}
		}

		return bloqueado;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void createGastoRepercutido(DtoGastoRepercutido dto, Long idExpediente) {
		ExpedienteComercial eco = this.findOne(idExpediente);
		if(eco != null) {
			GastoRepercutido gr = null;
			if(dto.getId() == null) {
				gr = new GastoRepercutido();
				gr.setCondicionanteExpediente(eco.getCondicionante());
				gr.setAuditoria(Auditoria.getNewInstance());
			}else {
				gr = genericDao.get(GastoRepercutido.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));
			}
			
			if(dto.getTipoGastoCodigo() != null) {
				gr.setTipoGastoRepercutido(genericDao.get(DDTipoGastoRepercutido.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoGastoCodigo())));
			}
			
			gr.setMeses(dto.getMeses());	
			gr.setImporte(dto.getImporte());
			gr.setFechaAlta(new Date());
			
			genericDao.save(GastoRepercutido.class, gr);
		}
	}
	
	@Override
	public List<DtoGastoRepercutido> getGastosRepercutidosList(Long idExpediente) {
		ExpedienteComercial eco = this.findOne(idExpediente);
		List<DtoGastoRepercutido> dtoList = new ArrayList<DtoGastoRepercutido>();
		
		if(eco != null && eco.getCondicionante() != null) {
			List<GastoRepercutido> grList = genericDao.getList(GastoRepercutido.class, genericDao.createFilter(FilterType.EQUALS, "condicionanteExpediente.id", eco.getCondicionante().getId()));
			
			if(grList != null && !grList.isEmpty()) {
				for (GastoRepercutido gastoRepercutido : grList) {
					DtoGastoRepercutido dto = new DtoGastoRepercutido();
					dto.setId(gastoRepercutido.getId());
					dto.setTipoGastoCodigo(gastoRepercutido.getTipoGastoRepercutido().getCodigo());
					if(gastoRepercutido.getImporte() == null) {
						dto.setImporte(0.0);
					}else {
						dto.setImporte(gastoRepercutido.getImporte());
					}
					dto.setFechaAlta(gastoRepercutido.getFechaAlta());
					dto.setMeses(gastoRepercutido.getMeses());
					dtoList.add(dto);
				}
			}
		}
		return dtoList;
	}
	
	@Override
	public List<DtoTestigos> getTestigos(Long idOferta) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idOferta);
		Oferta oferta = genericDao.get(Oferta.class, filtro);
		List<DtoTestigos> listaDtoTestigos = new ArrayList<DtoTestigos>();
		
		if (!Checks.esNulo(oferta)) {
			filtro = genericDao.createFilter(FilterType.EQUALS, "oferta", oferta);
			List<OfertaTestigos> listaTestigos = genericDao.getList(OfertaTestigos.class, filtro);

			for (OfertaTestigos lista : listaTestigos) {
				DtoTestigos dtoTestigosOpc = new DtoTestigos();
				try {
					beanUtilNotNull.copyProperties(dtoTestigosOpc, lista);
					if (!Checks.esNulo(lista.getFuenteTestigos())) {
						beanUtilNotNull.copyProperty(dtoTestigosOpc, "fuenteTestigosDesc",
								lista.getFuenteTestigos().getDescripcion());
					}
					if (!Checks.esNulo(lista.getTipoActivo())) {
						beanUtilNotNull.copyProperty(dtoTestigosOpc, "tipoActivoDesc",
								lista.getTipoActivo().getDescripcion());
					}	
				} catch (IllegalAccessException e) {
					logger.error("Error en expedienteComercialManager (copyProperties) ", e);	
				} catch (InvocationTargetException e) {
					logger.error("Error en expedienteComercialManager (copyProperties) ", e);
				}
	
				listaDtoTestigos.add(dtoTestigosOpc);
			}
		}
	
		return listaDtoTestigos;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveTestigos(DtoTestigos dto, Long id) {
		boolean success = false;
		ExpedienteComercial expedienteComercial = findOne(id);
		Oferta oferta = expedienteComercial.getOferta();
		OfertaTestigos testigo = null;
		if(dto != null && dto.getId() != null && !dto.getId().contains("Testigo")) {
			Filter idTestigo = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
			testigo = genericDao.get(OfertaTestigos.class, idTestigo);
		}
		
		try {
			if (Checks.esNulo(testigo) && !Checks.esNulo(oferta)) {
				success = true;
				testigo = new OfertaTestigos();
				testigo.setOferta(oferta);
			} else if (!Checks.esNulo(testigo)) {
				success = true;
			} else {
				throw new JsonViewerException("Error con la oferta. No ha sido posible realizar la operación.");
			}
			if (success) {
				beanUtilNotNull.copyProperties(testigo, dto);
				if (!Checks.esNulo(dto.getFuenteTestigosDesc())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getFuenteTestigosDesc());
					DDFuenteTestigos fte = genericDao.get(DDFuenteTestigos.class, filtro);
					beanUtilNotNull.copyProperty(testigo, "fuenteTestigos",fte);
				}
				if (!Checks.esNulo(dto.getTipoActivoDesc())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoActivoDesc());
					DDTipoActivo tpa = genericDao.get(DDTipoActivo.class, filtro);
					beanUtilNotNull.copyProperty(testigo, "tipoActivo",tpa);
				}
			}
		} catch (IllegalAccessException e) {
			logger.error("Error en expedienteComercialManager (copyProperties) ", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en expedienteComercialManager (copyProperties) ", e);
		}
		if (success) {
			genericDao.save(OfertaTestigos.class, testigo);
			return success;
		}
		
		return success;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public void deleteGastoRepercutido(Long idGastoRepercutido) {
		GastoRepercutido gr = genericDao.get(GastoRepercutido.class, genericDao.createFilter(FilterType.EQUALS, "id", idGastoRepercutido));
		
		if(gr != null) {
			Auditoria.delete(gr);
			genericDao.save(GastoRepercutido.class, gr);
		}
	}
	
	@Override
	public DtoScoringGarantias getScoringGarantias(Long idExpediente) {	
		DtoScoringGarantias dto = new DtoScoringGarantias();
		
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		ScoringAlquiler scoring = genericDao.get(ScoringAlquiler.class, filter);
		
		if(!Checks.esNulo(scoring)) {
			if (!Checks.esNulo(scoring.getFechaSancionBc()))
				dto.setFechaSancScoring(scoring.getFechaSancionBc());
			if (!Checks.esNulo(scoring.getMotivoRechazo())){
				Filter filtroMotivoRezhazo = genericDao.createFilter(FilterType.EQUALS, "descripcion", scoring.getMotivoRechazo());
				DDMotivoRechazoAlquiler motivoRechazo = genericDao.get(DDMotivoRechazoAlquiler.class, filtroMotivoRezhazo);
				dto.setMotivoRechazo(!Checks.esNulo(motivoRechazo.getCodigo()) ? motivoRechazo.getCodigo() : null);
			}
			if (!Checks.esNulo(scoring.getNumeroExpedienteBc()))
				dto.setNumExpediente(scoring.getNumeroExpedienteBc());
			if (!Checks.esNulo(scoring.getResultadoScoringBc()))
				dto.setResultadoScoringHaya(scoring.getResultadoScoringBc().getCodigo());
			if (!Checks.esNulo(scoring.getRatingScoringServicer()))
				dto.setRatingHaya(scoring.getRatingScoringServicer().getCodigo());
		}
		return dto;
	}

	@Override
	public List<DDRatingScoringServicer> getDDRatingScoringOrderByCodC4c() {
		Order orden = new Order(GenericABMDao.OrderType.ASC, "codigoC4c");
		return  genericDao.getListOrdered(DDRatingScoringServicer.class, orden);
	}
	
	@Transactional(readOnly = false)
	private void deleteCompradorExpedienteSetBorrado(Long idExpediente, Long idComprador) {
		Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "expediente", idExpediente);
		Filter filtroComprador = genericDao.createFilter(FilterType.EQUALS, "comprador", idComprador);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);

		CompradorExpediente cex = genericDao.get(CompradorExpediente.class, filtroExpediente, filtroComprador, filtroBorrado);
		
		if(cex != null) {
			cex.setPorcionCompra(0.0);
			Auditoria.delete(cex);
			genericDao.update(CompradorExpediente.class, cex);
		}
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean deleteTestigos(DtoTestigos dto) {
		genericDao.deleteById(OfertaTestigos.class, Long.parseLong(dto.getId()));
		return true;
	}

}
