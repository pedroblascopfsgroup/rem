package es.pfsgroup.plugin.rem.trabajo;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import es.pfsgroup.plugin.rem.activotrabajo.dao.ActivoTrabajoDao;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import edu.emory.mathcs.backport.java.util.Collections;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.impl.MSVProcesoManager;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVFicheroDao;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.adapter.RemUtils;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.PresupuestoApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.dao.FlashDao;
import es.pfsgroup.plugin.rem.gestor.GestorActivoManager;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoDao;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.historicotarifaplana.dao.HistoricoTarifaPlanaDao;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManager;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ActuacionTecnicaUserAssignationService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo.ActivoTrabajoPk;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.AdjuntoTrabajo;
import es.pfsgroup.plugin.rem.model.ConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.DtoActivoTrabajo;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoGestionEconomicaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoListadoGestores;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoPresupuestoTrabajo;
import es.pfsgroup.plugin.rem.model.DtoPresupuestosTrabajo;
import es.pfsgroup.plugin.rem.model.DtoProveedorContactoSimple;
import es.pfsgroup.plugin.rem.model.DtoProvisionSuplido;
import es.pfsgroup.plugin.rem.model.DtoRecargoProveedor;
import es.pfsgroup.plugin.rem.model.DtoTarifaTrabajo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.PresupuestoTrabajo;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.TrabajoConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.TrabajoFoto;
import es.pfsgroup.plugin.rem.model.TrabajoObservacion;
import es.pfsgroup.plugin.rem.model.TrabajoProvisionSuplido;
import es.pfsgroup.plugin.rem.model.TrabajoRecargosProveedor;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VActivosAgrupacionTrabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoPresupuesto;
import es.pfsgroup.plugin.rem.model.VBusquedaPresupuestosActivo;
import es.pfsgroup.plugin.rem.model.VProveedores;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPresupuesto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAdelanto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRecargoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.PropuestaPrecioDao;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.TrabajoDto;
import es.pfsgroup.plugin.rem.tareasactivo.TareaActivoManager;
import es.pfsgroup.plugin.rem.tareasactivo.dao.ActivoTareaExternaDao;
import es.pfsgroup.plugin.rem.thread.LiberarFicheroTrabajos;
import es.pfsgroup.plugin.rem.trabajo.dao.TrabajoDao;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoFilter;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGrupoUsuariosApi;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;

@Service("trabajoManager")
public class TrabajoManager extends BusinessOperationOverrider<TrabajoApi> implements TrabajoApi {

	private SimpleDateFormat groovyft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(TrabajoManager.class);

	private static final String RELACION_TIPO_DOCUMENTO_EXPEDIENTE = "d-e";
	private static final String OPERACION_ALTA = "Alta";

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private GenericAdapter adapter;

	@Autowired
	private ActivoAgrupacionDao activoAgrupacionDao;

	@Autowired
	private TrabajoDao trabajoDao;

	@Autowired
	private GestorActivoManager gestorActivoManager;

	@Autowired
	protected JBPMActivoTramiteManager jbpmActivoTramiteManager;

	@Autowired
	protected TipoProcedimientoManager tipoProcedimientoManager;

	@Autowired
	protected TareaActivoManager tareaActivoManager;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private MSVProcesoManager procesoManager;

	@Autowired
	private MSVExcelParser excelParser;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private RestApi restApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	ActivoTareaExternaApi activoTareaExternaManagerApi;

	@Autowired
	private UpdaterStateApi updaterStateApi;

	@Autowired
	private PropuestaPrecioDao propuestaDao;

	@Autowired
	private ProcessAdapter processAdapter;

	@Resource
	private MessageService messageServices;

	@Autowired
	private ProveedoresDao proveedoresDao;

	@Autowired
	private GestorActivoDao gestorActivoDao;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private GastoProveedorApi gastoProveedorApi;

	@Autowired
	private HistoricoTarifaPlanaDao historicoTarifaPlanaDao;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private TareaActivoApi tareaActivoApi;

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private PresupuestoApi presupuestoManager;
	
	@Autowired
	FlashDao flashDao;
	
	@Autowired
	private RemUtils remUtils;
	
	@Autowired
	private UsuarioDao usuarioDao;

	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Autowired
	private ActivoTareaExternaDao activoTareaExternaDao;
	
	@Autowired
	private EXTGrupoUsuariosApi grupoUsuariosApi;

	@Autowired
	private EXTGrupoUsuariosDao extGrupoUsuariosDao;

	@Autowired
	UsuarioManager usuarioManager;
	
	@Autowired
	private MSVFicheroDao ficheroDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private ActivoTrabajoDao activotrabajoDao;
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	@Override
	public String managerName() {
		return "trabajoManager";
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.findAll")
	public Page findAll(DtoTrabajoFilter dto, Usuario usuarioLogado) {

		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		if (!Checks.esNulo(usuarioCartera)){
			if(!Checks.esNulo(usuarioCartera.getSubCartera())){
				dto.setCartera(usuarioCartera.getCartera().getCodigo());
				dto.setSubcartera(usuarioCartera.getSubCartera().getCodigo());
			}else{
				dto.setCartera(usuarioCartera.getCartera().getCodigo());
			}
		}
		
		
		// Comprobar si el usuario es externo y, en tal caso, seteamos proveedor
		// y según HREOS-2272 en el modulo de trabajos
		// los perfiles externos de CAPA_CONTROL_BANKIA y USUARIOS_DE_CONSULTA
		// Siempre tendrán filtrado por actuación técnica y obtención documental

		if(this.gestorActivoDao.isUsuarioGestorExterno(usuarioLogado.getId())) {
			boolean esControlConsulta =  false;
			List<Perfil> perfilesUsuario = usuarioLogado.getPerfiles();
			for (int i=0;i<perfilesUsuario.size() && !esControlConsulta;i++) {
				if (perfilesUsuario.get(i).getCodigo().equals(PERFIL_CAPA_CONTROL_BANKIA) ||
					perfilesUsuario.get(i).getCodigo().equals(PERFIL_USUARIOS_DE_CONSULTA)) {
					esControlConsulta = true;
				}
			}
			if (esControlConsulta) {
				dto.setCodigoTipo(CODIGO_OBTENCION_DOCUMENTACION);
				dto.setCodigoTipo2(CODIGO_ACTUACION_TECNICA);
				return trabajoDao.findAll(dto);
			}
			return trabajoDao.findAllFilteredByProveedorContacto(dto, usuarioLogado.getId());
		}

		return trabajoDao.findAll(dto);
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.getTrabajoById")
	@Transactional(readOnly = false)
	public Object getTrabajoById(Long id, String pestana) {

		Trabajo trabajo = findOne(id);
		Object dto = null;

		try {

			if (PESTANA_FICHA.equals(pestana)) {
				dto = trabajoToDtoFichaTrabajo(trabajo);
			} else if (PESTANA_GESTION_ECONOMICA.equals(pestana)) {
				// Dto de gestión económica
				dto = trabajoToDtoGestionEconomicaTrabajo(trabajo);
			}

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return dto;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.getTrabajoByTareaExterna")
	public Trabajo getTrabajoByTareaExterna(TareaExterna tarea) {
		TareaActivo tareaActivo = tareaActivoManager.getByIdTareaExterna(tarea.getId());
		return tareaActivo.getTramite().getTrabajo();
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.findOne")
	public Trabajo findOne(Long id) {

		return trabajoDao.get(id);

	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.saveFichaTrabajo")
	@Transactional
	public boolean saveFichaTrabajo(DtoFichaTrabajo dtoTrabajo, Long id) {
		Trabajo trabajo = trabajoDao.get(id);
		List<ActivoTramite> activoTramites = activoTramiteApi.getTramitesActivoTrabajoList(trabajo.getId());
		ActivoTramite activoTramite = activoTramites.get(0);
		TareaActivo tareaActivo = tareaActivoApi.getUltimaTareaActivoByIdTramite(activoTramite.getId());

		try {
			// Si estado trabajo = EMITIDO PENDIENTE PAGO y se ha rellenado
			// "fecha pago", estado trabajo = PAGADO
			// Este cambio de estado se produce en la tarea "Cierre Económico"
			// de los trámites pero es necesario
			// controlar también si la fecha pago se informa y no hay que cerrar
			// ningún trámite
			if (!Checks.esNulo(trabajo.getFechaPago())
					&& trabajo.getEstado().getCodigo().equals(DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO)) {
				dtoTrabajo.setEstadoCodigo(DDEstadoTrabajo.ESTADO_PAGADO);
			}

			dtoToTrabajo(dtoTrabajo, trabajo);

			if(!Checks.esNulo(tareaActivo.getTareaExterna()) && !Checks.esNulo(tareaActivo.getTareaExterna().getTareaProcedimiento()) &&
					!Checks.esNulo(dtoTrabajo.getIdResponsableTrabajo()) &&
					(CODIGO_T004_AUTORIZACION_BANKIA.equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo())) ||
					(CODIGO_T004_AUTORIZACION_PROPIETARIO.equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo()) && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(trabajo.getActivo().getCartera().getCodigo()))){
				// Si las condiciones no se cumplen evitar cambiar el responsable al trámite lanzando excepción.
				throw new JsonViewerException("No se permite cambiar de responsable para la tarea Autorizacion del propietario");
			} else if(!Checks.esNulo(dtoTrabajo.getIdResponsableTrabajo())) {
				// Si las condiciones si se cumplen, comprobar de igual forma si se ha cambiado específicamente el responsable del trabajo.
				editarTramites(trabajo);
			}

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		trabajoDao.saveOrUpdate(trabajo);

		return true;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.saveGestionEconomicaTrabajo")
	@Transactional
	public boolean saveGestionEconomicaTrabajo(DtoGestionEconomicaTrabajo dtoGestionEconomica, Long id) {

		Trabajo trabajo = trabajoDao.get(id);

		try {

			dtoGestionEconomicaToTrabajo(dtoGestionEconomica, trabajo);

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		actualizarImporteTotalTrabajo(trabajo.getId());
		trabajoDao.saveOrUpdate(trabajo);

		return true;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.actualizarImporteTotalTrabajo")
	@Transactional
	public Trabajo actualizarImporteTotalTrabajo(Long idTrabajo) {

		Double importeA = new Double("0.0");
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", idTrabajo);

		Trabajo trabajo = findOne(idTrabajo);

		if (!Checks.esNulo(trabajo.getEsTarificado()) && trabajo.getEsTarificado()) {
			List<TrabajoConfiguracionTarifa> cfgTarifas = genericDao.getList(TrabajoConfiguracionTarifa.class, filtro);

			for (TrabajoConfiguracionTarifa tarifa : cfgTarifas) {

				if (!tarifa.getAuditoria().isBorrado() && !Checks.esNulo(tarifa.getPrecioUnitario())
						&& !Checks.esNulo(tarifa.getMedicion())) {
					importeA += tarifa.getPrecioUnitario() * tarifa.getMedicion();
				}
			}
		} else if (!Checks.esNulo(trabajo.getEsTarificado()) && !trabajo.getEsTarificado()) {
			List<PresupuestoTrabajo> presupuestos = genericDao.getList(PresupuestoTrabajo.class, filtro);

			for (PresupuestoTrabajo presupuesto : presupuestos) {
				if (!presupuesto.getAuditoria().isBorrado() && !Checks.esNulo(presupuesto.getImporte())
						&& presupuesto.getEstadoPresupuesto() != null
						&& "02".equalsIgnoreCase(presupuesto.getEstadoPresupuesto().getCodigo())) {
					importeA += presupuesto.getImporte();
				}
			}
		}

		Double importeB = trabajo.getImportePenalizacionTotal();

		Double importeC = new Double("0.0");
		if (!Checks.estaVacio(trabajo.getRecargosProveedor())) {

			for (TrabajoRecargosProveedor recargo : trabajo.getRecargosProveedor()) {

				if (!recargo.getAuditoria().isBorrado()) {
					if (DDTipoCalculo.TIPO_CALCULO_PORCENTAJE.equals(recargo.getTipoCalculo().getCodigo())) {
						if (!Checks.esNulo(recargo.getImporteCalculo())) {
							recargo.setImporteFinal(importeA * recargo.getImporteCalculo() / 100);
						}
					} else if (DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO.equals(recargo.getTipoCalculo().getCodigo())) {
						recargo.setImporteFinal(recargo.getImporteCalculo());
					}

					genericDao.save(TrabajoRecargosProveedor.class, recargo);

					if (!Checks.esNulo(recargo.getImporteFinal())) {
						importeC += recargo.getImporteFinal();
					}
				}
			}

		}

		Double importeTotal = importeA - importeB + importeC;

		trabajo.setImporteTotal(importeTotal);

		genericDao.save(Trabajo.class, trabajo);

		return trabajo;

	}

	@Override
	@Transactional(readOnly = false)
	public Trabajo create(DDSubtipoTrabajo subtipoTrabajo, List<Activo> listaActivos, PropuestaPrecio propuestaPrecio,
			boolean inicializarTramite) throws Exception {
		/*
		 * Crear trabajo a partir de una lista de activos y un subtipo dados: -
		 * Nuevos trabajos del módulo de precios y marketing - Otros trabajos
		 * que no provengan de la pantalla "Crear trabajo", por esto no requiere
		 * el DtoFichaTrabajo solo requiere una lista de activos y el subtipo de
		 * trabajo a generar. - La propuesta ES OPCIONAL para crear el trabajo.
		 * Si se pasa la propuesta crea la relación, si no, solo crea el
		 * trabajo-tramite.
		 */
		Trabajo trabajo = new Trabajo();
		try {
			trabajo.setFechaSolicitud(new Date());
			trabajo.setNumTrabajo(trabajoDao.getNextNumTrabajo());
			trabajo.setSolicitante(genericAdapter.getUsuarioLogado());
			trabajo.setUsuarioResponsableTrabajo(genericAdapter.getUsuarioLogado());

			trabajo.setTipoTrabajo(subtipoTrabajo.getTipoTrabajo());
			trabajo.setSubtipoTrabajo(subtipoTrabajo);

			// Estado trabajo: En tramite y con fecha solicitud
			trabajo.setEstado((DDEstadoTrabajo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoTrabajo.class,
					DDEstadoTrabajo.ESTADO_EN_TRAMITE));
			trabajo.setFechaSolicitud(new Date());

			// TODO: Evaluar correctamente quienes son gestores de activo en
			// trabajos multiactivo
			//
			// Si el trabajo es creado por el tipo de gestor que debe
			// gestionarlo,
			// tendra fecha APROBACION. Se evalua el gestor solo del 1er activo
			//
			// Para modulo precios:
			if (DDTipoTrabajo.CODIGO_PRECIOS.equals(trabajo.getTipoTrabajo().getCodigo())) {
				if (gestorActivoManager.isGestorPreciosOMarketing(listaActivos.get(0),
						genericAdapter.getUsuarioLogado())) { 
					trabajo.setFechaAprobacion(new Date());
				}
			}

			// Se crea la relacion de activos - trabajos, utilizando la lista de
			// activos de entrada
			Double participacion = null;
			for (Activo activo : listaActivos) {
				participacion = updaterStateApi.calcularParticipacionPorActivo(trabajo.getTipoTrabajo().getCodigo(),listaActivos, activo);

				//Si participación es null significa que, o no se han pasado bien los parámetros,
				//o que no son ni de tipo obtención documental ni actuaciones técnicas.
				//Se calcula a partes iguales para todos los activos.
				if(participacion == null){
					participacion = (100d / listaActivos.size());
				}

				ActivoTrabajo activoTrabajo = createActivoTrabajo(activo, trabajo, participacion.toString());
				trabajo.getActivosTrabajo().add(activoTrabajo);
			}

			// Si es un trabajo derivado de propuesta de precios:
			// - Antes de crear el tramite, se relacionan la propuesta y el
			// trabajo, porque el tramite puede requerir la propuesta
			// - Si no viene de una propuesta, solo crea el trabajo-tramite
			if (!Checks.esNulo(propuestaPrecio)) {
				trabajo.setPropuestaPrecio(propuestaPrecio);
			}

			if(listaActivos != null && listaActivos.size() == 1){
				Activo activo = listaActivos.get(0);
				trabajo.setActivo(activo);
				// Seteo del flag esTarifaPlana
				trabajo.setEsTarifaPlana(this.esTrabajoTarifaPlana(activo, subtipoTrabajo, trabajo.getFechaSolicitud()));
			}

			trabajoDao.saveOrUpdate(trabajo);

			// Crea el trámite relacionado con el nuevo trabajo generado
			// --------------------

			if (inicializarTramite) {
				createTramiteTrabajo(trabajo);
			}

		} catch (Exception e) {
			String mensaje = "";
			if (e.getMessage() != null) {
				mensaje = e.getMessage();
			}
			logger.error("[ERROR] - Crear trabajo multiactivo: ".concat(mensaje));
			throw e;
		}

		return trabajo;
	}

	@Override
	@Transactional(readOnly = false)
	public Trabajo create(DDSubtipoTrabajo subtipoTrabajo, List<Activo> listaActivos, PropuestaPrecio propuestaPrecio) throws Exception {
		return this.create(subtipoTrabajo, listaActivos, propuestaPrecio,true);
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.create")
	@Transactional(readOnly = false)
	public Long create(DtoFichaTrabajo dtoTrabajo){
		/*
		 * Crear trabajo desde la pantalla de crear trabajos: - Crea un trabajo
		 * desde el activo o desde la agrupación de activos (Nuevos trabajos
		 * Fase1) o crea un trabajo introduciendo un listado de activos en excel
		 * (trabajos con tramite multiactivo Fase 2) - Son solo trabajos que
		 * provienen de la pantalla "Crear trabajo"
		 */
		Trabajo trabajo = new Trabajo();

		List<Long> idsActivosSeleccionados = new ArrayList<Long>();
		if (!Checks.esNulo(dtoTrabajo.getIdsActivos())) {
			List<String> activosIDArray = Arrays.asList(dtoTrabajo.getIdsActivos().split(","));
			for (String idActivoSeleccionado : activosIDArray) {
				idsActivosSeleccionados.add(Long.parseLong(idActivoSeleccionado));
			}
		}

		if (!Checks.esNulo(dtoTrabajo.getIdProceso())) {
			MSVDocumentoMasivo document = ficheroDao.findByIdProceso(dtoTrabajo.getIdProceso());
			MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(document);
			
			Integer numFilas;
			try {
				numFilas = exc.getNumeroFilasByHoja(0,document.getProcesoMasivo().getTipoOperacion())-1;
				processAdapter.setStateProcessing(document.getProcesoMasivo().getId(),new Long(numFilas));
				Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

				Thread creacionAsincrona = new Thread(new LiberarFicheroTrabajos(usu, dtoTrabajo));

				creacionAsincrona.start();
				trabajo.setId(-1L);
			} catch (Exception e) {
				logger.error(e.getMessage());
			}			

		} else {
			if (dtoTrabajo.getIdActivo() != null) {
				Activo activo = activoDao.get(dtoTrabajo.getIdActivo());
				Double participacion = updaterStateApi.calcularParticipacionPorActivo(dtoTrabajo.getTipoTrabajoCodigo(), null, activo);
				dtoTrabajo.setParticipacion(Checks.esNulo(participacion) ? "0" : participacion.toString());
				trabajo = crearTrabajoPorActivo(activo, dtoTrabajo);
				createTramiteTrabajo(trabajo);

			}

			else if(Checks.esNulo(dtoTrabajo.getIdsActivos())){ //Si no se selecciona ningun activo
				if(!Checks.esNulo(dtoTrabajo.getEsSolicitudConjunta()) && dtoTrabajo.getEsSolicitudConjunta().equals(true)){ //Si se marca el check
					//Se lanza un trabajo que englobe a todos loas activos de la agrupacion
					trabajo = crearTrabajoPorAgrupacion(dtoTrabajo, null);
					createTramiteTrabajo(trabajo);
				} else {//Si no se marca el check
					//Se lanza un trabajo por cada activo de la agrupacion

					List<Trabajo> trabajos = crearTrabajoPorActivoAgrupacion(dtoTrabajo, null);
					for (Trabajo trabajoActivoAgrupacion : trabajos) {
						createTramiteTrabajo(trabajoActivoAgrupacion);
					}
				}

			} else {//Si se seleccionan activos
				if(!Checks.esNulo(dtoTrabajo.getEsSolicitudConjunta()) && dtoTrabajo.getEsSolicitudConjunta().equals(true)){//Si se marca el check
					//se lanza un trabajo que engloba a todos los activos seleccionados
					trabajo = crearTrabajoPorAgrupacion(dtoTrabajo, idsActivosSeleccionados);
					createTramiteTrabajo(trabajo);
				} else { //Si no se marca el check
					//Se lanza un trabajo por cada activo seleccionados
					List<Trabajo> trabajos= crearTrabajoPorActivoAgrupacion(dtoTrabajo,idsActivosSeleccionados);

					for (Trabajo trabajoActivoAgrupacion : trabajos) {
						createTramiteTrabajo(trabajoActivoAgrupacion);
					}
				}
			}
		}
		
		if(DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(dtoTrabajo.getTipoTrabajoCodigo())){
			if((DDCartera.CODIGO_CARTERA_CERBERUS.equals(dtoTrabajo.getCodCartera()) 
					&& (DDSubcartera.CODIGO_JAIPUR_INMOBILIARIO.equals(dtoTrabajo.getCodSubcartera()) 
							|| DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(dtoTrabajo.getCodSubcartera())
							|| DDSubcartera.CODIGO_EGEO.equals(dtoTrabajo.getCodSubcartera())
							|| DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(dtoTrabajo.getCodSubcartera())))
			   || (DDCartera.CODIGO_CARTERA_EGEO.equals(dtoTrabajo.getCodCartera())
					   && (DDSubcartera.CODIGO_ZEUS.equals(dtoTrabajo.getCodSubcartera())
							   || DDSubcartera.CODIGO_PROMONTORIA.equals(dtoTrabajo.getCodSubcartera())))){
				trabajo.setEsTarificado(false);
			}
		}
		
		return trabajo.getId();
	}

	private List<Trabajo> crearTrabajoPorActivoAgrupacion(DtoFichaTrabajo dtoTrabajo, List<Long> idsActivosSeleccionados) {
		List<Trabajo> trabajos = new ArrayList<Trabajo>();
		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "agrId", Long.valueOf(dtoTrabajo.getIdAgrupacion()));
		List<VActivosAgrupacionTrabajo> activosAgrupacionTrabajo = genericDao.getList(VActivosAgrupacionTrabajo.class, filtro1);

		List<Long> activosID = new ArrayList<Long>();

		for(VActivosAgrupacionTrabajo activoAgrupacion : activosAgrupacionTrabajo) {
			if(activoAgrupacion.getIdActivo() != null) {

				if(!Checks.esNulo(idsActivosSeleccionados)){
					for(Long idActivoSeleccionado: idsActivosSeleccionados){
						if(activoAgrupacion.getIdActivo().equals(idActivoSeleccionado.toString())){
							activosID.add(Long.parseLong(activoAgrupacion.getIdActivo()));
							break;
						}
					}
				} else {
					activosID.add(Long.parseLong(activoAgrupacion.getIdActivo()));
				}
			}
		}

		List<Activo> activosList = activoApi.getListActivosPorID(activosID);

		Trabajo trabajo = null;
		Double participacion = null;
		Integer participacionTotalPorCien = 10000;
		Integer participacionPorCien = 0;
		for (Activo activo : activosList) {
			participacion = updaterStateApi.calcularParticipacionPorActivo(dtoTrabajo.getTipoTrabajoCodigo(), activosList, null);
			participacionPorCien = (int)(participacion*100);				
			participacionTotalPorCien -= participacionPorCien;
			dtoTrabajo.setParticipacion(Checks.esNulo(participacion) ? "0" : String.valueOf(participacionPorCien/100f));
			trabajo = crearTrabajoPorActivo(activo, dtoTrabajo);
			trabajos.add(trabajo);
		}
		if(participacionTotalPorCien != 0) {
			while(participacionTotalPorCien != 0) {
				participacionTotalPorCien--;
				trabajo.getActivosTrabajo().get(participacionTotalPorCien).setParticipacion(
						trabajo.getActivosTrabajo().get(participacionTotalPorCien).getParticipacion()+(1/100f));
			}
			trabajoDao.saveOrUpdate(trabajo);
		}

		return trabajos;

	}

	private Trabajo crearTrabajoPorAgrupacion(DtoFichaTrabajo dtoTrabajo, List<Long> idsActivosSelecionados) {

		ActivoAgrupacion agrupacion = activoAgrupacionDao.get(dtoTrabajo.getIdAgrupacion());

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "agrId", Long.valueOf(dtoTrabajo.getIdAgrupacion()));
		List<VActivosAgrupacionTrabajo> activosAgrupacionTrabajoTem = genericDao
				.getList(VActivosAgrupacionTrabajo.class, filtro);
		List<VActivosAgrupacionTrabajo> activosAgrupacionTrabajo = new ArrayList<VActivosAgrupacionTrabajo>();

		Long idActivo = null;
		ActivoTrabajo activoTrabajo = null;
		Float participacionTotal = null;

		if (!Checks.esNulo(idsActivosSelecionados) && !Checks.esNulo(dtoTrabajo.getEsSolicitudConjunta())
				&& dtoTrabajo.getEsSolicitudConjunta().equals(true)) {
			boolean seleccionado;
			for (VActivosAgrupacionTrabajo activoAgr : activosAgrupacionTrabajoTem) {
				seleccionado = false;
				for (Long idActivoSeleccionado : idsActivosSelecionados) {
					if (activoAgr.getIdActivo().equals(idActivoSeleccionado.toString())) {
						seleccionado = true;
						break;
					}
				}
				if (seleccionado) {
					activosAgrupacionTrabajo.add(activoAgr);
				}
			}
		} else {
			activosAgrupacionTrabajo = activosAgrupacionTrabajoTem;
		}

		Trabajo trabajo = new Trabajo();

		try {
			dtoToTrabajo(dtoTrabajo, trabajo);

			trabajo.setFechaSolicitud(new Date());
			trabajo.setNumTrabajo(trabajoDao.getNextNumTrabajo());
			trabajo.setAgrupacion(agrupacion);

			if (GestorActivoApi.CODIGO_GESTOR_ACTIVO.equals(dtoTrabajo.getResponsableTrabajo())
					&& !Checks.esNulo(dtoTrabajo.getIdSolicitante())) {
				Filter filtroSolicitante = genericDao.createFilter(FilterType.EQUALS, "id", dtoTrabajo.getIdSolicitante());

				Usuario solicitante = genericDao.get(Usuario.class, filtroSolicitante);
				Usuario responsable = gestorActivoApi.getGestorByActivoYTipo(agrupacion.getActivos().get(0).getActivo(), "GACT");

				if (!Checks.esNulo(solicitante) && !Checks.esNulo(responsable)) {
					trabajo.setSolicitante(solicitante);
					trabajo.setUsuarioResponsableTrabajo(responsable);
				} else {
					trabajo.setSolicitante(genericAdapter.getUsuarioLogado());
				}

			} else {

				trabajo.setSolicitante(genericAdapter.getUsuarioLogado());

			}

			List<Long> activosID = new ArrayList<Long>();

			for (VActivosAgrupacionTrabajo activoAgrupacion : activosAgrupacionTrabajo) {
				if (activoAgrupacion.getIdActivo() != null) {
					activosID.add(Long.parseLong(activoAgrupacion.getIdActivo()));
				}
			}

			List<Activo> activosList = activoApi.getListActivosPorID(activosID);

			Boolean isFirstLoop = true;
			Double participacion = null;
			Integer participacionTotalPorCien = 10000;
			Integer participacionPorCien = 0;
			for (VActivosAgrupacionTrabajo activoAgrupacion : activosAgrupacionTrabajo) {
				Activo activo = activoDao.get(Long.valueOf(activoAgrupacion.getIdActivo()));

				participacion = updaterStateApi.calcularParticipacionPorActivo(trabajo.getTipoTrabajo().getCodigo(), activosList, activo);

				participacionPorCien = (int)(participacion*100);				
				participacionTotalPorCien -= participacionPorCien;
				dtoTrabajo.setParticipacion(Checks.esNulo(participacion) ? "0" : String.valueOf(participacionPorCien/100f));

				// FIXME: Datos del trabajo que se definen por un activo, en
				// agrupación de activos están tomándose del primer activo del
				// grupo.
				// Es necesario revisar la forma de definir estos datos del
				// trabajo con "Agrupación activos Conjunta" --> "Trabajo"
				if (isFirstLoop) {
					idActivo = activo.getId();
					trabajo.setEstado(getEstadoNuevoTrabajo(dtoTrabajo, activo));
					trabajo.setActivo(activo); // En caso de ser un trabajo por
												// agrupación, metemos el primer
												// activo para sacar los datos
												// comunes en el listado
					// El estado del trabajo se define solo por el primer activo
					// del grupo

					// El gestor de activo se salta tareas de estos trámites y
					// por tanto es necesario settear algunos datos
					// al crear el trabajo.
					if (gestorActivoManager.isGestorActivo(activo, genericAdapter.getUsuarioLogado())) {
						if (DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())
								|| DDTipoTrabajo.CODIGO_TASACION.equals(trabajo.getTipoTrabajo().getCodigo())
								|| DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS
										.equals(trabajo.getSubtipoTrabajo().getCodigo())) {
							trabajo.setFechaAprobacion(new Date());
						}
					}

					// El trámite de cédula queda aprobado al crearlo, sea o no
					// sea gestor activo quien lo crea
					if (DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD.equals(trabajo.getSubtipoTrabajo().getCodigo())) {
						trabajo.setFechaAprobacion(new Date());
					}

				}

				activoTrabajo = createActivoTrabajo(activo, trabajo, dtoTrabajo.getParticipacion());
				trabajo.getActivosTrabajo().add(activoTrabajo);
				isFirstLoop = false;
			}

			if (DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())
					|| DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS.equals(trabajo.getSubtipoTrabajo().getCodigo()))
				trabajo.setEsTarificado(true);

			if (activosAgrupacionTrabajo.size() > 0) {
				Activo activo = activoDao.get(Long.valueOf(activosAgrupacionTrabajo.get(0).getIdActivo()));
				Usuario galq = gestorActivoApi.getGestorByActivoYTipo(activo, "GALQ");
				Usuario gsue = gestorActivoApi.getGestorByActivoYTipo(activo, "GSUE");
				Usuario gedi = gestorActivoApi.getGestorByActivoYTipo(activo, "GEDI");
				Usuario gact = gestorActivoApi.getGestorByActivoYTipo(activo, "GACT");
				Usuario grupoGestorActivos = usuarioDao.getByUsername("grupgact");
				Usuario solicitante = genericAdapter.getUsuarioLogado();

				if (Checks.esNulo(galq) && Checks.esNulo(gsue) && Checks.esNulo(gedi) && !Checks.esNulo(gact)) {
					trabajo.setUsuarioResponsableTrabajo(gact);
				} else if ((!Checks.esNulo(galq) && solicitante.equals(galq))
						|| (!Checks.esNulo(gsue) && solicitante.equals(gsue))
						|| (!Checks.esNulo(gedi) && solicitante.equals(gedi))
						|| (!Checks.esNulo(gact) && (solicitante.equals(gact) || (gact.equals(grupoGestorActivos) && grupoUsuariosApi.usuarioPerteneceAGrupo(solicitante, gact))))) {
							if(grupoUsuariosApi.usuarioPerteneceAGrupo(solicitante, gact)) {
								trabajo.setUsuarioResponsableTrabajo(gact);
							}else {
								trabajo.setUsuarioResponsableTrabajo(solicitante);
							}
				} else {
					if (!Checks.esNulo(galq)) {
						trabajo.setUsuarioResponsableTrabajo(galq);
					} else if (!Checks.esNulo(gsue)) {
						trabajo.setUsuarioResponsableTrabajo(gsue);
					} else if (!Checks.esNulo(gedi)) {
						trabajo.setUsuarioResponsableTrabajo(gedi);
					}
				}
			} else {
				trabajo.setUsuarioResponsableTrabajo(genericAdapter.getUsuarioLogado());
			}

			if (dtoTrabajo.getRequerimiento() != null) {
				trabajo.setRequerimiento(dtoTrabajo.getRequerimiento());
			}

			trabajoDao.saveOrUpdate(trabajo);

			trabajoDao.flush();

			//Cuando haya tiempo se debe cambiar el siguiente codigo repetido en varios sitios para meterlo en un mismo metodo.

			if(participacionTotalPorCien != 0){

				Filter filter = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());

				List<ActivoTrabajo> listaActTbj = genericDao.getList(ActivoTrabajo.class, filter);
				
				for(ActivoTrabajo actTbj : listaActTbj) {
					actTbj.setParticipacion(actTbj.getParticipacion()+(1/100f));
					genericDao.update(ActivoTrabajo.class, actTbj);
					participacionTotalPorCien--;
					if(participacionTotalPorCien == 0) break;
				}				
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return trabajo;

	}
	
	@Transactional
	public void doCreacionTrabajosAsync(DtoFichaTrabajo dtoTrabajo, Usuario usuarioLogado) {
		TransactionStatus transaction = null;
		transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		List<Activo> listaActivos = this.getListaActivosProceso(dtoTrabajo.getIdProceso());
		Trabajo trabajo = new Trabajo();
		Long idActivo = null;
		ActivoTrabajo activoTrabajo = null;
		Float participacionTotal = null;
		
		try {

			Boolean isFirstLoop = true;
			Double total= 0d;
			Boolean algunoSinPrecio= false;
			Map<Long,Double> mapaValores= new HashMap<Long,Double>();
			for(Activo activo:listaActivos){
				Double valor= updaterStateApi.calcularParticipacionValorPorActivo(dtoTrabajo.getTipoTrabajoCodigo(), activo);
				total= total+valor;
				if(valor.equals(0d)){
					algunoSinPrecio= true;
					break;
				}
				mapaValores.put(activo.getId(), valor);
			}
			Double participacion = null;
			Integer participacionTotalPorCien = 10000;
			Integer participacionPorCien = 0;
			for (Activo activo : listaActivos) {
				participacion = null;
				
				if (algunoSinPrecio) {
					participacion = (100d / listaActivos.size());
				} else {
					participacion = (mapaValores.get(activo.getId()) / total) * 100;
				}
				
				participacionPorCien = (int)(participacion*100);				
				participacionTotalPorCien -= participacionPorCien;
				
				dtoTrabajo.setParticipacion(Checks.esNulo(participacion) ? "0" : String.valueOf(participacionPorCien/100f));

				Usuario usuarioGestor = null;

				if(!Checks.esNulo(dtoTrabajo.getIdGestorActivoResponsable())){
					usuarioGestor = usuarioManager.get(dtoTrabajo.getIdGestorActivoResponsable());
					if(!Checks.esNulo(usuarioGestor)){
						trabajo.setUsuarioGestorActivoResponsable(usuarioGestor);
					}
				}

				if (isFirstLoop || !dtoTrabajo.getEsSolicitudConjunta()) {
					trabajo = new Trabajo();
					this.dtoToTrabajo(dtoTrabajo, trabajo);
					trabajo.setFechaSolicitud(new Date());
					trabajo.setNumTrabajo(trabajoDao.getNextNumTrabajo());
					trabajo.setSolicitante(usuarioLogado);
					idActivo = activo.getId();
					if (!Checks.esNulo(usuarioGestor)) {
						trabajo.setUsuarioResponsableTrabajo(usuarioGestor);
					} else {
						trabajo.setUsuarioResponsableTrabajo(usuarioLogado);
					}

					trabajo.setEstado(this.getEstadoNuevoTrabajoUsuario(dtoTrabajo, activo, usuarioLogado));

					// El gestor de activo se salta tareas de estos trámites y
					// por tanto es necesario settear algunos datos
					// al crear el trabajo.
					if (gestorActivoManager.isGestorActivo(activo, usuarioLogado)) {
						if (DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())
								|| DDTipoTrabajo.CODIGO_TASACION.equals(trabajo.getTipoTrabajo().getCodigo())
								|| DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS.equals(trabajo.getSubtipoTrabajo().getCodigo())) {

							trabajo.setFechaAprobacion(new Date());
						}
					}

					// El trámite de cédula queda aprobado al crearlo, sea o no
					// sea gestor activo quien lo crea
					if (DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD.equals(trabajo.getSubtipoTrabajo().getCodigo())) {
						trabajo.setFechaAprobacion(new Date());
					}

					if (DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo()) 
							|| DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS.equals(trabajo.getSubtipoTrabajo().getCodigo())) {
						trabajo.setEsTarificado(true);
					}
				}
				activoTrabajo = this.createActivoTrabajo(activo, trabajo, dtoTrabajo.getParticipacion());
				transactionManager.commit(transaction);
				transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
				
				trabajo.getActivosTrabajo().add(activoTrabajo);
				isFirstLoop = false;

				if (!Checks.esNulo(dtoTrabajo.getIdSupervisorActivo())) {
					Usuario usuarioSupervisor = usuarioManager.get(dtoTrabajo.getIdSupervisorActivo());
					if (!Checks.esNulo(usuarioSupervisor)) {
						trabajo.setSupervisorActivoResponsable(usuarioSupervisor);
					}
				}

				if (!dtoTrabajo.getEsSolicitudConjunta()) {
					if (dtoTrabajo.getRequerimiento() != null) {
						trabajo.setRequerimiento(dtoTrabajo.getRequerimiento());
					}
					trabajoDao.saveOrUpdate(trabajo);
					transactionManager.commit(transaction);
					transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
					
					this.createTramiteTrabajo(trabajo);
					transactionManager.commit(transaction);
					transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
					

				}
			}

			if (dtoTrabajo.getEsSolicitudConjunta()) {
				if (dtoTrabajo.getRequerimiento() != null) {
					trabajo.setRequerimiento(dtoTrabajo.getRequerimiento());
				}
				trabajoDao.saveOrUpdate(trabajo);
				transactionManager.commit(transaction);
				transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
				this.createTramiteTrabajo(trabajo);
				transactionManager.commit(transaction);
				transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
				ficheroMasivoToTrabajo(dtoTrabajo.getIdProceso(), trabajo);	
				transactionManager.commit(transaction);
			}

			

			if(participacionTotalPorCien != 0){

				Filter filter = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());

				List<ActivoTrabajo> listaActTbj = genericDao.getList(ActivoTrabajo.class, filter);
				
				for(ActivoTrabajo actTbj : listaActTbj) {
					actTbj.setParticipacion(actTbj.getParticipacion()+(1/100f));
					genericDao.update(ActivoTrabajo.class, actTbj);
					participacionTotalPorCien--;
					if(participacionTotalPorCien == 0) break;
				}				
			}

		} catch (Exception e) {
			logger.error(e.getMessage());
			try {
				transactionManager.rollback(transaction);
			} catch (Exception ex) {
				logger.error("error rollback proceso masivo: " + ex.getMessage());
			}
		}
	}
	
	private List<Activo> getListaActivosProceso(Long idProceso) {

		List<Activo> listaActivos = new ArrayList<Activo>();
		MSVDocumentoMasivo documento = procesoManager.getMSVDocumento(idProceso);
		MSVHojaExcel exc = excelParser.getExcel(documento.getContenidoFichero().getFile());

		try {

			Integer numFilas = exc.getNumeroFilasByHoja(0,documento.getProcesoMasivo().getTipoOperacion());

			for (int i = 1; i < numFilas; i++) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numActivo",
						Long.parseLong(exc.dameCelda(i, 0)));
				Activo activo = genericDao.get(Activo.class, filtro);
				if (activo != null) {
					listaActivos.add(activo);
				}
			}
		} catch (NumberFormatException e) {
			logger.error(e.getMessage());
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
		} catch (IOException e) {
			logger.error(e.getMessage());
		} catch (ParseException e) {
			logger.error(e.getMessage());
		}
		return listaActivos;
	}

	@Transactional(readOnly = false)
	private void ficheroMasivoToTrabajo(Long idProceso, Trabajo trabajo) {
		MSVDocumentoMasivo documento = procesoManager.getMSVDocumento(idProceso);
		FileItem fileItem = documento.getContenidoFichero();
		fileItem.setFileName(documento.getNombre());
		// fileItem.setLength(); //TODO: Hay que meter el tamaño del fichero
		// fileItem.setContentType(); //TODO: Hay que meter el tipo del fichero
		WebFileItem webFileItem = new WebFileItem();
		webFileItem.setFileItem(fileItem);
		Map<String, String> mapaParametros = new HashMap<String, String>();
		mapaParametros.put("idEntidad", trabajo.getId().toString());
		mapaParametros.put("tipo", "01"); // TODO: He puesto informe comercial
											// pero hay que crear un tipo nuevo
		mapaParametros.put("descripcion", "Listado de activos");
		webFileItem.setParameters(mapaParametros);

		List<AdjuntoTrabajo> adjuntosTrabajo = new ArrayList<AdjuntoTrabajo>();
		trabajo.setAdjuntos(adjuntosTrabajo);
		trabajoDao.saveOrUpdate(trabajo);
		try {
			upload(webFileItem);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}


	private Trabajo crearTrabajoPorActivo(Activo activo, DtoFichaTrabajo dtoTrabajo) {

		Trabajo trabajo = new Trabajo();

		Usuario galq = gestorActivoApi.getGestorByActivoYTipo(activo, "GALQ");
		Usuario gsue = gestorActivoApi.getGestorByActivoYTipo(activo, "GSUE");
		Usuario gedi = gestorActivoApi.getGestorByActivoYTipo(activo, "GEDI");
		Usuario gact = gestorActivoApi.getGestorByActivoYTipo(activo, "GACT");
		Usuario solicitante = genericAdapter.getUsuarioLogado();
		Usuario grupoGestorActivos = usuarioDao.getByUsername("grupgact");
		
		//Si el trabajo es de limpieza se asigna el usuario responsable del dto,
		//ya que en UpdaterServicePosicionamiento en crearTrabajoLimpieza()
		//se calcula si existe doble gestor o no.
		//HREOS-5061
		if(DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(dtoTrabajo.getTipoTrabajoCodigo()) && DDSubtipoTrabajo.CODIGO_AT_LIMPIEZA.equals(dtoTrabajo.getSubtipoTrabajoCodigo())
				&& !Checks.esNulo(dtoTrabajo.getResponsableTrabajo())) {
			Usuario responsable= gestorActivoApi.getGestorByActivoYTipo(activo, dtoTrabajo.getResponsableTrabajo());
			trabajo.setUsuarioResponsableTrabajo(responsable);
		}
		else if (GestorActivoApi.CODIGO_GESTOR_ACTIVO.equals(dtoTrabajo.getResponsableTrabajo())

				&& !Checks.esNulo(gact)) {

			trabajo.setUsuarioResponsableTrabajo(gact);

		} else {

			if (Checks.esNulo(galq) && Checks.esNulo(gsue) && Checks.esNulo(gedi) && !Checks.esNulo(gact)) {
				trabajo.setUsuarioResponsableTrabajo(gact);
			} else if ((!Checks.esNulo(galq) && solicitante.equals(galq))
					|| (!Checks.esNulo(gsue) && solicitante.equals(gsue))
					|| (!Checks.esNulo(gedi) && solicitante.equals(gedi))
					|| (!Checks.esNulo(gact) && (solicitante.equals(gact) || (gact.equals(grupoGestorActivos) && grupoUsuariosApi.usuarioPerteneceAGrupo(solicitante, gact))))) {
				if(grupoUsuariosApi.usuarioPerteneceAGrupo(solicitante, gact)) {
					trabajo.setUsuarioResponsableTrabajo(gact);
				}else {
					trabajo.setUsuarioResponsableTrabajo(solicitante);
				}
			} else {
				if (!Checks.esNulo(galq)) {
					trabajo.setUsuarioResponsableTrabajo(galq);
				} else if (!Checks.esNulo(gsue)) {
					trabajo.setUsuarioResponsableTrabajo(gsue);
				} else if (!Checks.esNulo(gedi)) {
					trabajo.setUsuarioResponsableTrabajo(gedi);
				}
			}
		}

		try {

			dtoToTrabajo(dtoTrabajo, trabajo);

			trabajo.setNumTrabajo(trabajoDao.getNextNumTrabajo());
			trabajo.setActivo(activo);
			trabajo.setFechaSolicitud(new Date());
			if (!Checks.esNulo(dtoTrabajo.getIdSolicitante())) {

				Usuario user = genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "id", dtoTrabajo.getIdSolicitante()));

				if (!Checks.esNulo(user)) {
					trabajo.setSolicitante(user);

				} else {
					trabajo.setSolicitante(genericAdapter.getUsuarioLogado());
				}
			} else {
				trabajo.setSolicitante(genericAdapter.getUsuarioLogado());

			}
			trabajo.setEstado(getEstadoNuevoTrabajo(dtoTrabajo, activo));

			ActivoTrabajo activoTrabajo = createActivoTrabajo(activo, trabajo, dtoTrabajo.getParticipacion());
			trabajo.getActivosTrabajo().add(activoTrabajo);

			if (DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())
					|| DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS.equals(trabajo.getSubtipoTrabajo().getCodigo()))
				trabajo.setEsTarificado(true);

			// El gestor de activo se salta tareas de estos trámites y por tanto
			// es necesario settear algunos datos
			// al crear el trabajo.
			if (gestorActivoManager.isGestorActivo(activo, genericAdapter.getUsuarioLogado())) {
				if (DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())
						|| DDTipoTrabajo.CODIGO_TASACION.equals(trabajo.getTipoTrabajo().getCodigo())
						|| DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS
								.equals(trabajo.getSubtipoTrabajo().getCodigo())) {
					trabajo.setFechaAprobacion(new Date());
				}
			}

			// El trámite de cédula queda aprobado al crearlo, sea o no sea
			// gestor activo quien lo crea
			if (DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD.equals(trabajo.getSubtipoTrabajo().getCodigo())) {
				trabajo.setFechaAprobacion(new Date());
			}

			if (dtoTrabajo.getRequerimiento() != null) {

				trabajo.setRequerimiento(dtoTrabajo.getRequerimiento());
			}

			trabajoDao.saveOrUpdate(trabajo);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return trabajo;

	}

	public DDEstadoTrabajo getEstadoNuevoTrabajo(DtoFichaTrabajo dtoTrabajo, Activo activo) {
		/*
		 * Estados del trabajo - Al crear un trabajo: Si es trámite "Cedula": EN
		 * TRAMITE Si es gestor activo (algunos trámites): EN TRAMITE El resto
		 * de casos: SOLICITADO
		 */
		Usuario logedUser = usuarioManager.getUsuarioLogado();

		List<Long> idGrpsUsuario = null;

		idGrpsUsuario = extGrupoUsuariosDao.buscaGruposUsuario(logedUser);

		Usuario gestorActivo = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO);

		Filter filtroSolicitado = genericDao.createFilter(FilterType.EQUALS, "codigo",
				DDEstadoTrabajo.ESTADO_SOLICITADO);
		Filter filtroEnTramite = genericDao.createFilter(FilterType.EQUALS, "codigo",
				DDEstadoTrabajo.ESTADO_EN_TRAMITE);

		// Por defecto: Solicitado
		DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filtroSolicitado);
		if ((!Checks.esNulo(gestorActivo) && logedUser.equals(gestorActivo)
			|| (idGrpsUsuario != null && !idGrpsUsuario.isEmpty() && idGrpsUsuario.contains(gestorActivo.getId())))
				&& (dtoTrabajo.getTipoTrabajoCodigo().equals(DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL)
						|| dtoTrabajo.getTipoTrabajoCodigo().equals(DDTipoTrabajo.CODIGO_TASACION) || dtoTrabajo
								.getSubtipoTrabajoCodigo().equals(DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS))) {

			// Es gestor activo + Obtención documental(menos Cédula) o
			// Tasación: En Trámite
			estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filtroEnTramite);
		}

		return estadoTrabajo;
	}
	
	public DDEstadoTrabajo getEstadoNuevoTrabajoUsuario(DtoFichaTrabajo dtoTrabajo, Activo activo, Usuario logedUser) {
		/*
		 * Estados del trabajo - Al crear un trabajo: Si es trámite "Cedula": EN
		 * TRAMITE Si es gestor activo (algunos trámites): EN TRAMITE El resto
		 * de casos: SOLICITADO
		 */

		List<Long> idGrpsUsuario = null;

		idGrpsUsuario = extGrupoUsuariosDao.buscaGruposUsuario(logedUser);

		Usuario gestorActivo = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO);

		Filter filtroSolicitado = genericDao.createFilter(FilterType.EQUALS, "codigo",
				DDEstadoTrabajo.ESTADO_SOLICITADO);
		Filter filtroEnTramite = genericDao.createFilter(FilterType.EQUALS, "codigo",
				DDEstadoTrabajo.ESTADO_EN_TRAMITE);

		// Por defecto: Solicitado
		DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filtroSolicitado);
		if ((!Checks.esNulo(gestorActivo) && logedUser.equals(gestorActivo)
			|| (idGrpsUsuario != null && !idGrpsUsuario.isEmpty() && idGrpsUsuario.contains(gestorActivo.getId())))
				&& (dtoTrabajo.getTipoTrabajoCodigo().equals(DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL)
						|| dtoTrabajo.getTipoTrabajoCodigo().equals(DDTipoTrabajo.CODIGO_TASACION) || dtoTrabajo
								.getSubtipoTrabajoCodigo().equals(DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS))) {

			// Es gestor activo + Obtención documental(menos Cédula) o
			// Tasación: En Trámite
			estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filtroEnTramite);
		}

		return estadoTrabajo;
	}

	@Override
	public ActivoTrabajo createActivoTrabajo(Activo activo, Trabajo trabajo, String participacion) {

		if (trabajo.getId() == null) {
			trabajo = genericDao.save(Trabajo.class, trabajo);
		}
		
		if(activoDao.isUnidadAlquilable(activo.getId())) {
			ActivoAgrupacion actagr = activoDao.getAgrupacionPAByIdActivo(activo.getId());
			Activo activoMatriz =new Activo();
			activoMatriz = activoApi.get(activoDao.getIdActivoMatriz(actagr.getId()));
			trabajo.setActivo(activoMatriz);
			trabajo = genericDao.save(Trabajo.class, trabajo);
		}
		
		ActivoTrabajo activoTrabajo = new ActivoTrabajo();
		activoTrabajo.setActivo(activo);
		activoTrabajo.setTrabajo(trabajo);
		activoTrabajo.setPrimaryKey(new ActivoTrabajoPk(activo.getId(),trabajo.getId()));
		activoTrabajo.setParticipacion(Float.valueOf(participacion));
		return activoTrabajo;
	}

	public void dtoToTrabajo(DtoFichaTrabajo dtoTrabajo, Trabajo trabajo)
			throws IllegalAccessException, InvocationTargetException {
		beanUtilNotNull.copyProperties(trabajo, dtoTrabajo);

		if (Checks.esNulo(dtoTrabajo.getUrgente()))
			trabajo.setUrgente(false);

		if (Checks.esNulo(dtoTrabajo.getRiesgoInminenteTerceros()))
			trabajo.setRiesgoInminenteTerceros(false);

		if (Checks.esNulo(dtoTrabajo.getCubreSeguro()))
			trabajo.setCubreSeguro(false);

		if (dtoTrabajo.getEstadoCodigo() != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTrabajo.getEstadoCodigo());
			DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filtro);

			trabajo.setEstado(estadoTrabajo);
		}

		if (dtoTrabajo.getTipoCalidadCodigo() != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTrabajo.getTipoCalidadCodigo());
			DDTipoCalidad tipoCalidad = genericDao.get(DDTipoCalidad.class, filtro);

			trabajo.setTipoCalidad(tipoCalidad);
		}

		if (dtoTrabajo.getTipoTrabajoCodigo() != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTrabajo.getTipoTrabajoCodigo());
			DDTipoTrabajo tipoTrabajo = genericDao.get(DDTipoTrabajo.class, filtro);

			trabajo.setTipoTrabajo(tipoTrabajo);
		}

		if (dtoTrabajo.getSubtipoTrabajoCodigo() != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTrabajo.getSubtipoTrabajoCodigo());
			DDSubtipoTrabajo subtipoTrabajo = genericDao.get(DDSubtipoTrabajo.class, filtro);

			trabajo.setSubtipoTrabajo(subtipoTrabajo);

			// Seteo del flag esTarifaPlana
			if (!Checks.esNulo(dtoTrabajo.getIdActivo())) {
				Activo activoAux = activoApi.get(dtoTrabajo.getIdActivo());
				if (!Checks.esNulo(activoAux)) {
					trabajo.setEsTarifaPlana(this.esTrabajoTarifaPlana(activoAux, subtipoTrabajo, new Date()));
				}
			}
		}

		if (dtoTrabajo.getIdMediador() != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoTrabajo.getIdMediador());
			ActivoProveedor mediador = genericDao.get(ActivoProveedor.class, filtro);

			trabajo.setMediador(mediador);
		}

		if (!Checks.esNulo(dtoTrabajo.getIdGestorActivoResponsable())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoTrabajo.getIdGestorActivoResponsable());
			Usuario usuario = genericDao.get(Usuario.class, filtro);

			trabajo.setUsuarioGestorActivoResponsable(usuario);
		}

		if (!Checks.esNulo(dtoTrabajo.getIdSupervisorActivo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoTrabajo.getIdSupervisorActivo());
			Usuario usuario = genericDao.get(Usuario.class, filtro);

			trabajo.setSupervisorActivoResponsable(usuario);
		}

		if (!Checks.esNulo(dtoTrabajo.getIdResponsableTrabajo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoTrabajo.getIdResponsableTrabajo());
			Usuario usuario = genericDao.get(Usuario.class, filtro);
			trabajo.setUsuarioResponsableTrabajo(usuario);

			List<ActivoTramite> activoTramites = activoTramiteApi.getTramitesActivoTrabajoList(trabajo.getId());
			ActivoTramite activoTramite = activoTramites.get(0);
			TareaActivo tareaActivo = tareaActivoApi.getUltimaTareaActivoByIdTramite(activoTramite.getId());

			if(!Checks.esNulo(tareaActivo.getTareaExterna()) && !Checks.esNulo(tareaActivo.getTareaExterna().getTareaProcedimiento()) &&
					(!CODIGO_T004_AUTORIZACION_BANKIA.equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo())) ||
					(CODIGO_T004_AUTORIZACION_PROPIETARIO.equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo()) && !DDCartera.CODIGO_CARTERA_LIBERBANK.equals(trabajo.getActivo().getCartera().getCodigo()))) {
				if(gestorActivoApi.isGestorAlquileres(trabajo.getActivo(), usuario)){
					Usuario supervisor = gestorActivoApi.getGestorByActivoYTipo(trabajo.getActivo(), GestorActivoApi.CODIGO_SUPERVISOR_ALQUILERES);
					tareaActivo.setSupervisorActivo(supervisor);

				} else if(gestorActivoApi.isGestorEdificaciones(trabajo.getActivo(), usuario)) {
					Usuario supervisor = gestorActivoApi.getGestorByActivoYTipo(trabajo.getActivo(), GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES);
					tareaActivo.setSupervisorActivo(supervisor);

				} else if(gestorActivoApi.isGestorSuelos(trabajo.getActivo(), usuario)) {
					Usuario supervisor = gestorActivoApi.getGestorByActivoYTipo(trabajo.getActivo(), GestorActivoApi.CODIGO_SUPERVISOR_SUELOS);
					tareaActivo.setSupervisorActivo(supervisor);

				} else {
					Usuario supervisor = gestorActivoApi.getGestorByActivoYTipo(trabajo.getActivo(), GestorActivoApi.CODIGO_SUPERVISOR_ACTIVOS);
					tareaActivo.setSupervisorActivo(supervisor);
				}
			}
		}

		if (!Checks.esNulo(dtoTrabajo.getRequerimiento())) {
			trabajo.setRequerimiento(dtoTrabajo.getRequerimiento());

		}

	}

	private void dtoGestionEconomicaToTrabajo(DtoGestionEconomicaTrabajo dtoGestionEconomica, Trabajo trabajo)
			throws IllegalAccessException, InvocationTargetException {

		BeanUtilNotNull beanUtils = new BeanUtilNotNull();
		beanUtils.copyProperties(trabajo, dtoGestionEconomica);

		if(!Checks.esNulo(dtoGestionEconomica.getIdProveedorContacto())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoGestionEconomica.getIdProveedorContacto());
			ActivoProveedorContacto proveedorContacto = genericDao.get(ActivoProveedorContacto.class, filtro);

			if(!Checks.esNulo(proveedorContacto))
				trabajo.setProveedorContacto(proveedorContacto);
		}
	}
	
	@Override
	@Transactional
	public ActivoTramite createTramiteTrabajo(Long idTrabajo,ExpedienteComercial expedienteComercial){
		return this.createTramiteTrabajo(trabajoDao.get(idTrabajo),expedienteComercial);
	}
	
	@Override
	@Transactional
	public ActivoTramite createTramiteTrabajo(Trabajo trabajo) {
		return createTramiteTrabajo(trabajo,null);
	}

	@Override
	@Transactional
	public ActivoTramite createTramiteTrabajo(Trabajo trabajo,ExpedienteComercial expedienteComercial){
		TipoProcedimiento tipoTramite = new TipoProcedimiento();

		if (trabajo.getEsTarifaPlana() == null) {
			trabajo.setEsTarifaPlana(false);
		}

		// Tramites [FASE 1] -----------------------
		if (trabajo.getTipoTrabajo().getCodigo().equals(DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL)) { 	// Obtención
	
			if (trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_CEE)) {// CEE
				tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_OBTENCION_DOC_CEE); 
				// Trámite de obtención documental CEE
				//Si el trabajo es de Tango asignamos proveedorContacto
				if(this.checkTango(trabajo)) {
					Filter filtroUsuProveedorBankiaSareb = genericDao.createFilter(FilterType.EQUALS, "username", remUtils.obtenerUsuarioPorDefecto(GestorActivoApi.USU_PROVEEDOR_BANKIA_SAREB_TINSA));
					Usuario usuProveedorBankiaSareb = genericDao.get(Usuario.class, filtroUsuProveedorBankiaSareb);
					if(!Checks.esNulo(usuProveedorBankiaSareb)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "usuario",usuProveedorBankiaSareb);
						Filter filtro2 = genericDao.createFilter(FilterType.NULL, "fechaBaja");
						List<ActivoProveedorContacto> listaPVC = genericDao.getList(ActivoProveedorContacto.class,
								filtro,filtro2);
						if(!Checks.estaVacio(listaPVC)){
							trabajo.setProveedorContacto(listaPVC.get(0));
							trabajo = genericDao.save(Trabajo.class, trabajo);
						}
					}
				//Si el trabajo es de BANKIA
				}else if(this.checkBankia(trabajo)) {
					
					Filter filtroUsuProveedorBankia = genericDao.createFilter(FilterType.EQUALS, "username", remUtils.obtenerUsuarioPorDefecto(GestorActivoApi.USU_PROVEEDOR_PACI));
					Usuario usuProveedorBankia = genericDao.get(Usuario.class, filtroUsuProveedorBankia);
					if(!Checks.esNulo(usuProveedorBankia)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "usuario",usuProveedorBankia);
						Filter filtro2 = genericDao.createFilter(FilterType.NULL, "fechaBaja");
						List<ActivoProveedorContacto> listaPVC = genericDao.getList(ActivoProveedorContacto.class,
								filtro,filtro2);
						if(!Checks.estaVacio(listaPVC)){
							trabajo.setProveedorContacto(listaPVC.get(0));
							trabajo = genericDao.save(Trabajo.class, trabajo);
						}
					}
				//Si el trabajo es de SAREB	
				}else if(this.checkSareb(trabajo)) {
					
					Filter filtroUsuProveedorSareb = genericDao.createFilter(FilterType.EQUALS, "username", remUtils.obtenerUsuarioPorDefecto(GestorActivoApi.USU_PROVEEDOR_ELECNOR));
					Usuario usuProveedorSareb = genericDao.get(Usuario.class, filtroUsuProveedorSareb);
					if(!Checks.esNulo(usuProveedorSareb)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "usuario",usuProveedorSareb);
						Filter filtro2 = genericDao.createFilter(FilterType.NULL, "fechaBaja");
						List<ActivoProveedorContacto> listaPVC = genericDao.getList(ActivoProveedorContacto.class,
								filtro,filtro2);
						if(!Checks.estaVacio(listaPVC)){
							trabajo.setProveedorContacto(listaPVC.get(0));
							trabajo = genericDao.save(Trabajo.class, trabajo);
						}
					}
					
				//Si el trabajo es de JAIPUR/GIANTS/GALEON
				}else if(this.checkGiants(trabajo) || this.checkGaleon(trabajo) || this.checkJaipur(trabajo)){
					Filter filtroUsuProveedor = genericDao.createFilter(FilterType.EQUALS ,"username", remUtils.obtenerUsuarioPorDefecto(GestorActivoApi.USU_PROVEEDOR_HOMESERVE));
					Usuario usuProveedor = genericDao.get(Usuario.class, filtroUsuProveedor);
					if (!Checks.esNulo(usuProveedor)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "usuario", usuProveedor);
						Filter filtro2 = genericDao.createFilter(FilterType.NULL, "proveedor.fechaBaja");
						List<ActivoProveedorContacto> listaPVC = genericDao.getList(ActivoProveedorContacto.class,
								filtro, filtro2);
						if (!Checks.estaVacio(listaPVC)) {
							trabajo.setProveedorContacto(listaPVC.get(0));
							trabajo = genericDao.save(Trabajo.class, trabajo);
						}
					}
				} else if (this.checkLiberbank(trabajo)) {
					Filter filtroUsuProveedor = genericDao.createFilter(FilterType.EQUALS ,"username", remUtils.obtenerUsuarioPorDefecto(GestorActivoApi.USU_PROVEEDOR_AESCTECTONICA));
					Usuario usuProveedor = genericDao.get(Usuario.class, filtroUsuProveedor);
					if (!Checks.esNulo(usuProveedor)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "usuario", usuProveedor);
						Filter filtro2 = genericDao.createFilter(FilterType.NULL, "fechaBaja");
						List<ActivoProveedorContacto> listaPVC = genericDao.getList(ActivoProveedorContacto.class,
								filtro, filtro2);
						if (!Checks.estaVacio(listaPVC)) {
							trabajo.setProveedorContacto(listaPVC.get(0));
							trabajo = genericDao.save(Trabajo.class, trabajo);
						}
					}
				}
				
			} else if (trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD)) {
				tipoTramite = tipoProcedimientoManager
						.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_OBTENCION_DOC_CEDULA); 
				String username = null;
				Usuario usuario = null;				
				
				// Trámite de obtención de cédula				
				// Si el trabajo es de Tango/Giants asignamos proveedorContacto
				if (this.checkTango(trabajo) || this.checkGiants(trabajo)) {
					usuario = gestorActivoManager.getGestorByActivoYTipo(trabajo.getActivo(),
							GestorActivoApi.CODIGO_GESTORIA_CEDULAS);					
				// Si el trabajo es de Sareb asignamos proveedorContacto	
				}else if(this.checkSareb(trabajo)) {
					Filter filtroUsuProveedorSareb = genericDao.createFilter(FilterType.EQUALS, "username", remUtils.obtenerUsuarioPorDefecto(GestorActivoApi.USU_PROVEEDOR_ELECNOR));
					Usuario usuProveedorSareb = genericDao.get(Usuario.class, filtroUsuProveedorSareb);
					if(!Checks.esNulo(usuProveedorSareb)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "usuario",usuProveedorSareb);
						Filter filtro2 = genericDao.createFilter(FilterType.NULL, "fechaBaja");
						List<ActivoProveedorContacto> listaPVC = genericDao.getList(ActivoProveedorContacto.class,
								filtro,filtro2);
						if(!Checks.estaVacio(listaPVC)){
							trabajo.setProveedorContacto(listaPVC.get(0));
							trabajo = genericDao.save(Trabajo.class, trabajo);
						}
					}
				// Si el trabajo es de Bankia asignamos proveedorContacto
				}else if(this.checkBankia(trabajo)) {

					Filter filtroUsuProveedorBankia = genericDao.createFilter(FilterType.EQUALS, "username", remUtils.obtenerUsuarioPorDefecto(GestorActivoApi.USU_PROVEEDOR_PACI));
					Usuario usuProveedorBankia = genericDao.get(Usuario.class, filtroUsuProveedorBankia);
					if(!Checks.esNulo(usuProveedorBankia)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "usuario",usuProveedorBankia);
						Filter filtro2 = genericDao.createFilter(FilterType.NULL, "fechaBaja");
						List<ActivoProveedorContacto> listaPVC = genericDao.getList(ActivoProveedorContacto.class,
								filtro,filtro2);
						if(!Checks.estaVacio(listaPVC)){
							trabajo.setProveedorContacto(listaPVC.get(0));
							trabajo = genericDao.save(Trabajo.class, trabajo);
						}
					}
				}
				if(!Checks.esNulo(username)){
					usuario = usuarioDao.getByUsername(username);
				}
				if (!Checks.esNulo(usuario)) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "usuario", usuario);
					Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "proveedor.tipoProveedor.codigo", DDTipoProveedor.COD_GESTORIA);
					List<ActivoProveedorContacto> listaPVC = genericDao.getList(ActivoProveedorContacto.class,
							filtro, filtro2);
					if (!Checks.estaVacio(listaPVC)) {
						trabajo.setProveedorContacto(listaPVC.get(0));
						trabajo = genericDao.save(Trabajo.class, trabajo);
					}
				}
			
			} else if (trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_INFORMES))
				tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_INFORME);// Trámite
			// de
			// informes
			else {
				tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_OBTENCION_DOC); // Trámite
																													// de
				if(this.checkBankia(trabajo) /*|| this.checkSareb(trabajo) */|| this.checkTango(trabajo) || this.checkGiants(trabajo)) {

					Usuario gestorAdmision = gestorActivoManager.getGestorByActivoYTipo(trabajo.getActivo(), GestorActivoApi.CODIGO_GESTOR_ADMISION);

					if(!Checks.esNulo(gestorAdmision)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "usuario", gestorAdmision);
						List<ActivoProveedorContacto> listaPVC = genericDao.getList(ActivoProveedorContacto.class,filtro);
						if(!Checks.estaVacio(listaPVC)){
							trabajo.setProveedorContacto(listaPVC.get(0));
							trabajo = genericDao.save(Trabajo.class, trabajo);
						}
					}
				}
			}
		}
		
		if (trabajo.getTipoTrabajo().getCodigo().equals(DDTipoTrabajo.CODIGO_TASACION)) {
			tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_TASACION);
		}
		if (trabajo.getTipoTrabajo().getCodigo().equals(DDTipoTrabajo.CODIGO_ACTUACION_TECNICA)) { 
			if (trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS)){
				tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_INFORME); 
			}
			else{
				tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_ACTUACION_TECNICA);
			}
		}

		// Tramites [FASE 2] -----------------------
		//
		// Modulo de Precios -----------------------
		//
		// Propuesta de precios
		if (trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_TRAMITAR_PROPUESTA_PRECIOS)) {
			tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_PROPUESTA_PRECIOS);
		}
		// Tramite de actualizacion de precios / propuesta descuento
		if (trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_TRAMITAR_PROPUESTA_DESCUENTO)) {
			tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_PROPUESTA_PRECIOS);
		}
		// Tramite de bloqueo de precios
		if (trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_PRECIOS_BLOQUEAR_ACTIVOS)) {
			tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_ACTUALIZA_PRECIOS);
		}
		// Tramite de desbloqueo de precios
		if (trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_PRECIOS_DESBLOQUEAR_ACTIVOS)) {
			tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_ACTUALIZA_PRECIOS);
		}
		// Tramite de actualizacion de precios / carga de precios
		if (trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_ACTUALIZACION_PRECIOS)) {
			tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_ACTUALIZA_PRECIOS);
		}
		if (trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_ACTUALIZACION_PRECIOS_DESCUENTO)) {
			tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_ACTUALIZA_PRECIOS);
		}

		// Módulo de Publicaciones ------------------
		//
		// Trámite de actualización de estados
		if (trabajo.getTipoTrabajo().getCodigo().equals(DDTipoTrabajo.CODIGO_PUBLICACIONES)) {
			tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_ACTUALIZA_ESTADOS);
		}

		
		//TODO DE MOMENTO EL TIPO DE TRABAJO DE EDIFICACIÓN VA LIGADO CON EL TRAMITE DE ACTUACIÓN TÉCNICA  HREOS-8327
		if(DDTipoTrabajo.CODIGO_EDIFICACION.equals(trabajo.getTipoTrabajo().getCodigo())
				|| DDTipoTrabajo.CODIGO_SUELO.equals(trabajo.getTipoTrabajo().getCodigo())) {
			tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_ACTUACION_TECNICA);
		}
		// Módulo de Expediente comercial ----------
		if(trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_VENTA)) {
			boolean esApple = false;
			boolean esDivarian = false;
			if(expedienteComercial == null) {
				expedienteComercial = expedienteComercialApi.findOneByTrabajo(trabajo);
			}
			if (expedienteComercial != null) {
				for (ActivoOferta activoOferta : expedienteComercial.getOferta().getActivosOferta()) {
					Activo activo = activoApi.get(activoOferta.getPrimaryKey().getActivo().getId());
					esApple=false;
					if (DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo()) &&
						DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())) {
						esApple = true;
					}
					esDivarian = false;
					if (DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo()) &&
							(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activo.getSubcartera().getCodigo())
									|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo()))) {
						esDivarian = true;
					}
					if (!esApple && !esDivarian) {
						tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA);
					}else {
						tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA_APPLE);
					}
				}
					
			}

		}
		if(trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_SANCION_OFERTA_ALQUILER)) {
			tipoTramite = tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_ALQUILER);
		}

		if (Checks.esNulo(tipoTramite.getId())) {
			return null;
		}
		ActivoTramite tramite = jbpmActivoTramiteManager.createActivoTramiteTrabajo(tipoTramite, trabajo);
		tramite.setActivo(trabajo.getActivo());

		jbpmActivoTramiteManager.lanzaBPMAsociadoATramite(tramite.getId());
		return tramite;

	}

	private DtoFichaTrabajo trabajoToDtoFichaTrabajo(Trabajo trabajo) throws IllegalAccessException, InvocationTargetException {

		DtoFichaTrabajo dtoTrabajo = new DtoFichaTrabajo();

		beanUtilNotNull.copyProperties(dtoTrabajo, trabajo);

		Activo activo = trabajo.getActivo();

		Usuario usuariologado = adapter.getUsuarioLogado();

		if (!Checks.esNulo(activo)) {

			if (!Checks.esNulo(activo.getInfoComercial())
					&& !Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
				dtoTrabajo.setNombreMediador(activo.getInfoComercial().getMediadorInforme().getNombre());
			}

			dtoTrabajo.setCartera(activo.getCartera().getDescripcion());
			dtoTrabajo.setCodCartera(activo.getCartera().getCodigo());
			dtoTrabajo.setPropietario(activo.getFullNamePropietario());
			dtoTrabajo.setIdActivo(activo.getId());

		} else if (trabajo.getAgrupacion() != null && trabajo.getAgrupacion().getActivoPrincipal() != null) {
			dtoTrabajo.setCodCartera(trabajo.getAgrupacion().getActivoPrincipal().getCartera().getCodigo());
		}

		if (trabajo.getProveedorContacto() != null && trabajo.getProveedorContacto().getProveedor() != null) {
			dtoTrabajo.setNombreProveedor(trabajo.getProveedorContacto().getProveedor().getNombreComercial());
			dtoTrabajo.setIdProveedor(trabajo.getProveedorContacto().getProveedor().getId());
		}
		if(!Checks.esNulo(trabajo.getGastoTrabajo())) {
			dtoTrabajo.setGastoProveedor(trabajo.getGastoTrabajo().getGastoProveedor().getNumGastoHaya());
			dtoTrabajo.setEstadoGasto(trabajo.getGastoTrabajo().getGastoProveedor().getEstadoGasto().getCodigo());
		}

		if (trabajo.getTipoTrabajo() != null) {
			dtoTrabajo.setTipoTrabajoDescripcion(trabajo.getTipoTrabajo().getDescripcion());
			dtoTrabajo.setTipoTrabajoCodigo(trabajo.getTipoTrabajo().getCodigo());
		}

		if (trabajo.getSubtipoTrabajo() != null) {
			dtoTrabajo.setSubtipoTrabajoDescripcion(trabajo.getSubtipoTrabajo().getDescripcion());
			dtoTrabajo.setSubtipoTrabajoCodigo(trabajo.getSubtipoTrabajo().getCodigo());
		}

		if (trabajo.getEstado() != null) {
			dtoTrabajo.setEstadoCodigo(trabajo.getEstado().getCodigo());
			dtoTrabajo.setEstadoDescripcion(trabajo.getEstado().getDescripcion());
		}

		if (trabajo.getTipoCalidad() != null)
			dtoTrabajo.setTipoCalidadCodigo(trabajo.getTipoCalidad().getCodigo());

		if (trabajo.getSolicitante() != null) {
			dtoTrabajo.setSolicitante(trabajo.getSolicitante().getApellidoNombre());
			dtoTrabajo.setIdSolicitante(trabajo.getSolicitante().getId());
		} else {
			if (trabajo.getMediador() != null) {
				dtoTrabajo.setSolicitante(trabajo.getMediador().getNombre());
			}
		}

		dtoTrabajo.setHoraConcreta(trabajo.getFechaHoraConcreta());
		dtoTrabajo.setFechaConcreta(trabajo.getFechaHoraConcreta());

		if (trabajo.getAgrupacion() != null) {
			dtoTrabajo.setNumAgrupacion(trabajo.getAgrupacion().getNumAgrupRem());
			dtoTrabajo.setIdAgrupacion(trabajo.getAgrupacion().getId());
			dtoTrabajo.setNumActivosAgrupacion(trabajo.getAgrupacion().getActivos().size());
			dtoTrabajo.setTipoAgrupacionDescripcion(trabajo.getAgrupacion().getTipoAgrupacion().getDescripcion());
		}

		if (!Checks.esNulo(trabajo.getGastoTrabajo()) && !Checks.esNulo(trabajo.getGastoTrabajo().getGastoProveedor())) {
			dtoTrabajo.setFechaEmisionFactura(trabajo.getGastoTrabajo().getGastoProveedor().getFechaEmision());
		}

		if(!Checks.esNulo(trabajo.getUsuarioGestorActivoResponsable())){
			dtoTrabajo.setGestorActivoResponsable(trabajo.getUsuarioGestorActivoResponsable().getApellidoNombre());
			dtoTrabajo.setIdGestorActivoResponsable(trabajo.getUsuarioGestorActivoResponsable().getId());

		} else {
			Usuario gestorActivo = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO);

			if (!Checks.esNulo(gestorActivo)) {
				dtoTrabajo.setGestorActivoResponsable(gestorActivo.getApellidoNombre());
				dtoTrabajo.setIdGestorActivoResponsable(gestorActivo.getId());
			}
		}

		if (!Checks.esNulo(trabajo.getSupervisorActivoResponsable())) {
			dtoTrabajo.setSupervisorActivo(trabajo.getSupervisorActivoResponsable().getApellidoNombre());
			dtoTrabajo.setIdSupervisorActivo(trabajo.getSupervisorActivoResponsable().getId());

		} else {
			Usuario supervisorActivo = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_SUPERVISOR_ACTIVOS);
			if(!Checks.esNulo(supervisorActivo)){
				dtoTrabajo.setSupervisorActivo(supervisorActivo.getApellidoNombre());
				dtoTrabajo.setIdSupervisorActivo(supervisorActivo.getId());
			}
		}

		if (!Checks.esNulo(trabajo.getUsuarioResponsableTrabajo())) {
			dtoTrabajo.setResponsableTrabajo(trabajo.getUsuarioResponsableTrabajo().getApellidoNombre());
			dtoTrabajo.setIdResponsableTrabajo(trabajo.getUsuarioResponsableTrabajo().getId());

		} else if (!Checks.esNulo(trabajo.getSolicitante())) {
			dtoTrabajo.setResponsableTrabajo(trabajo.getSolicitante().getApellidoNombre());
			dtoTrabajo.setIdResponsableTrabajo(trabajo.getSolicitante().getId());
		}

		if (trabajo.getEsTarifaPlana()) {
			dtoTrabajo.setEsTarifaPlana(1);
		} else {
			dtoTrabajo.setEsTarifaPlana(0);
		}

		if (!Checks.esNulo(trabajo.getFechaAutorizacionPropietario())) {
			dtoTrabajo.setFechaAutorizacionPropietario(trabajo.getFechaAutorizacionPropietario());
		}

		Usuario supervisorActivo = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_SUPERVISOR_ACTIVOS);
		Usuario supervisorEdificaciones = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_SUPERVISOR_EDIFICACIONES);
		Usuario supervisorAlquileres = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_SUPERVISOR_ALQUILERES);
		Usuario supervisorSuelos = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_SUPERVISOR_SUELOS);
		Usuario gestorEdificaciones = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES);
		Usuario gestorAlquileres = gestorActivoApi.getGestorByActivoYTipo(activo,
				GestorActivoApi.CODIGO_GESTOR_ALQUILERES);
		Usuario gestorSuelos = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_SUELOS);
		Usuario gestorActivo = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO);
		Usuario responsableTrabajo = trabajo.getUsuarioResponsableTrabajo();

		if (!Checks.esNulo(responsableTrabajo) ? usuariologado.equals(responsableTrabajo) : false) {
			dtoTrabajo.setBloquearResponsable(false);
		} else if (((!Checks.esNulo(responsableTrabajo) && !Checks.esNulo(gestorEdificaciones))
				? responsableTrabajo.equals(gestorEdificaciones) : false)
				&& (!Checks.esNulo(supervisorEdificaciones) ? usuariologado.equals(supervisorEdificaciones) : false)) {
			dtoTrabajo.setBloquearResponsable(false);
		} else if (((!Checks.esNulo(responsableTrabajo) && !Checks.esNulo(gestorAlquileres))
				? responsableTrabajo.equals(gestorAlquileres) : false)
				&& (!Checks.esNulo(supervisorAlquileres) ? usuariologado.equals(supervisorAlquileres) : false)) {
			dtoTrabajo.setBloquearResponsable(false);
		} else if (((!Checks.esNulo(responsableTrabajo) && !Checks.esNulo(gestorSuelos))
				? responsableTrabajo.equals(gestorSuelos) : false)
				&& (!Checks.esNulo(supervisorSuelos) ? usuariologado.equals(supervisorSuelos) : false)) {
			dtoTrabajo.setBloquearResponsable(false);
		} else if (((!Checks.esNulo(responsableTrabajo) && !Checks.esNulo(gestorActivo))
				? responsableTrabajo.equals(gestorActivo) : false)
				&& (!Checks.esNulo(supervisorActivo) ? usuariologado.equals(supervisorActivo) : false)) {
			dtoTrabajo.setBloquearResponsable(false);
		} else {
			dtoTrabajo.setBloquearResponsable(true);
		}

		if (usuariologado != null && usuariologado.equals(gestorActivo)) {
			dtoTrabajo.setLogadoGestorMantenimiento(true);
		} else {
			dtoTrabajo.setLogadoGestorMantenimiento(false);
		}

		if (!Checks.esNulo(supervisorEdificaciones)) {
			dtoTrabajo.setIdSupervisorEdificaciones(supervisorEdificaciones.getId());
		} else if (!Checks.esNulo(supervisorAlquileres)) {
			dtoTrabajo.setIdSupervisorAlquileres(supervisorAlquileres.getId());
		} else if (!Checks.esNulo(supervisorSuelos)) {
			dtoTrabajo.setIdSupervisorSuelos(supervisorSuelos.getId());
		}

		if (trabajo.getRequerimiento() != null && trabajo.getRequerimiento()) {
			dtoTrabajo.setRequerimiento(true);
		} else {
			dtoTrabajo.setRequerimiento(false);
		}
		
				
		if (DDTipoTrabajo.CODIGO_EDIFICACION.equals(trabajo.getTipoTrabajo().getCodigo())
				|| DDTipoTrabajo.CODIGO_SUELO.equals(trabajo.getTipoTrabajo().getCodigo())) {
			dtoTrabajo.setPerteneceDNDtipoEdificacion(true);

			dtoTrabajo.setCodigoPartida(trabajo.getCodigoPartida());
			dtoTrabajo.setCodigoSubpartida(trabajo.getCodigoSubpartida());
			dtoTrabajo.setNombreUg(trabajo.getNombreUg());
			dtoTrabajo.setNombreExpediente(trabajo.getNombreExpedienteTrabajo());
			dtoTrabajo.setNombreProyecto(trabajo.getNombreProyecto());

		} else {
			dtoTrabajo.setPerteneceDNDtipoEdificacion(false);
		}

		return dtoTrabajo;
	}

	@Transactional(readOnly = false)
	private void editarTramites (Trabajo trabajo) {

	 List<ActivoTramite> listActTra = genericDao.getList(ActivoTramite.class,genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId()),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
	 for (ActivoTramite actTra : listActTra) {
		 List<TareaActivo> listaActivo = genericDao.getList(TareaActivo.class,genericDao.createFilter(FilterType.EQUALS, "tramite.id", actTra.getId()),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		 for (TareaActivo tarAct: listaActivo) {
			 if(!Checks.esNulo(trabajo.getUsuarioResponsableTrabajo())){
				 tarAct.setUsuario(trabajo.getUsuarioResponsableTrabajo());
					genericDao.save(TareaActivo.class, tarAct);


			 }

		 }
	 }
	}

	private DtoGestionEconomicaTrabajo trabajoToDtoGestionEconomicaTrabajo(Trabajo trabajo)
			throws IllegalAccessException, InvocationTargetException {

		DtoGestionEconomicaTrabajo dtoTrabajo = new DtoGestionEconomicaTrabajo();

		beanUtilNotNull.copyProperties(dtoTrabajo, trabajo);
		beanUtilNotNull.copyProperty(dtoTrabajo.getNumTrabajo(), "numTrabajo", trabajo.getNumTrabajo());
		if (trabajo.getImporteTotal() != null) {
			BeanUtils.copyProperty(dtoTrabajo.getImporteTotal(), "importeTotal", trabajo.getImporteTotal());
		}

		dtoTrabajo.setIdTrabajo(trabajo.getId());

		if (trabajo.getTipoTrabajo() != null) {
			dtoTrabajo.setTipoTrabajoCodigo(trabajo.getTipoTrabajo().getCodigo());
			dtoTrabajo.setTipoTrabajoDescripcion(trabajo.getTipoTrabajo().getDescripcion());
		}
		if (trabajo.getSubtipoTrabajo() != null) {
			dtoTrabajo.setSubtipoTrabajoCodigo(trabajo.getSubtipoTrabajo().getCodigo());
			dtoTrabajo.setSubtipoTrabajoDescripcion(trabajo.getSubtipoTrabajo().getDescripcion());
		}
		if (trabajo.getActivo() != null && trabajo.getActivo().getCartera() != null) {
			dtoTrabajo.setCarteraCodigo(trabajo.getActivo().getCartera().getCodigo());
			
			if (trabajo.getActivo().getSubcartera() != null) {
				dtoTrabajo.setSubcarteraCodigo(trabajo.getActivo().getSubcartera().getCodigo());
			}
		}

		
		dtoTrabajo.setDiasRetrasoOrigen(trabajo.getDiasRetrasoOrigen());

		dtoTrabajo.setDiasRetrasoMesCurso(trabajo.getDiasRetrasoMesCurso());

		if (trabajo.getProveedorContacto() != null) {
			dtoTrabajo.setIdProveedorContacto(trabajo.getProveedorContacto().getId());

			if (trabajo.getProveedorContacto().getProveedor() != null) {
				dtoTrabajo.setIdProveedor(trabajo.getProveedorContacto().getProveedor().getId());
				dtoTrabajo.setCodigoTipoProveedor(trabajo.getProveedorContacto().getProveedor().getTipoProveedor().getCodigo());
			}
			if (trabajo.getProveedorContacto().getUsuario() != null) {
				dtoTrabajo.setUsuarioProveedorContacto(trabajo.getProveedorContacto().getUsuario().getApellidoNombre());
			}
			dtoTrabajo.setEmailProveedorContacto(trabajo.getProveedorContacto().getEmail());
			dtoTrabajo.setTelefonoProveedorContacto(trabajo.getProveedorContacto().getTelefono1());
		}

		return dtoTrabajo;

	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.deleteAdjunto")
	@Transactional(readOnly = false)
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {

		boolean borrado = false;
		Trabajo trabajo = trabajoDao.get(dtoAdjunto.getIdEntidad());
		AdjuntoTrabajo adjunto = trabajo.getAdjunto(dtoAdjunto.getId());

		try {
			// Borramos en el gestor documental si hay
			if ((DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(trabajo.getTipoTrabajo().getCodigo())
					|| DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())
					|| DDTipoTrabajo.CODIGO_PRECIOS.equals(trabajo.getTipoTrabajo().getCodigo()) ) && gestorDocumentalAdapterApi.modoRestClientActivado()) {

				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());

				AdjuntoTrabajo adjuntoGD = trabajo.getAdjuntoGD(dtoAdjunto.getId());

				if (adjuntoGD == null) {
					borrado = false;
				}
				trabajo.getAdjuntos().remove(adjuntoGD);
				trabajoDao.save(trabajo);

			} else {
				if (adjunto == null) {
					borrado = false;
				}
				trabajo.getAdjuntos().remove(adjunto);
				trabajoDao.save(trabajo);
			}
			borrado = true;
		} catch (Exception ex) {
			logger.debug(ex.getMessage());
			borrado = false;
		}

		return borrado;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.createTarifaTrabajo")
	@Transactional(readOnly = false)
	public boolean createTarifaTrabajo(DtoTarifaTrabajo tarifaDto, Long idTrabajo) {
		Trabajo trabajo = trabajoDao.get(idTrabajo);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", tarifaDto.getIdConfigTarifa());
		ConfiguracionTarifa cfgTarifa = genericDao.get(ConfiguracionTarifa.class, filtro);

		try {
			TrabajoConfiguracionTarifa traCfgTarifa = new TrabajoConfiguracionTarifa();
			traCfgTarifa.setConfigTarifa(cfgTarifa);
			traCfgTarifa.setTrabajo(trabajo);
			if (tarifaDto.getMedicion() != null && !tarifaDto.getMedicion().isEmpty()) {
				traCfgTarifa.setMedicion(Float.valueOf(tarifaDto.getMedicion()));
			}
			if (tarifaDto.getPrecioUnitario() != null && !tarifaDto.getPrecioUnitario().isEmpty()) {
				traCfgTarifa.setPrecioUnitario(Float.valueOf(tarifaDto.getPrecioUnitario()));
			}
			genericDao.save(TrabajoConfiguracionTarifa.class, traCfgTarifa);
			actualizarImporteTotalTrabajo(idTrabajo);
			// Luego en el callback hacer que se refresque automáticamente el
			// grid

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return true;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.createPresupuestoTrabajo")
	@Transactional(readOnly = false)
	public boolean createPresupuestoTrabajo(DtoPresupuestosTrabajo presupuestoDto, Long idTrabajo) {
		Trabajo trabajo = trabajoDao.get(idTrabajo);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", presupuestoDto.getIdProveedor());
		ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtro);
		filtro = genericDao.createFilter(FilterType.EQUALS, "id", presupuestoDto.getIdProveedorContacto());
		ActivoProveedorContacto proveedorContacto = genericDao.get(ActivoProveedorContacto.class, filtro);
		try {

			PresupuestoTrabajo presupuesto = new PresupuestoTrabajo();
			presupuesto.setTrabajo(trabajo);
			presupuesto.setProveedor(proveedor);
			presupuesto.setProveedorContacto(proveedorContacto);
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "codigo", "03"); // Estado
																							// inicial
																							// del
																							// presupuesto:
																							// en
																							// estudio

			DDEstadoPresupuesto estadoPresupuesto = genericDao.get(DDEstadoPresupuesto.class, filtro2);
			presupuesto.setEstadoPresupuesto(estadoPresupuesto);
			beanUtilNotNull.copyProperties(presupuesto, presupuestoDto);
			genericDao.save(PresupuestoTrabajo.class, presupuesto);

		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return true;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.savePresupuestoTrabajo")
	@Transactional(readOnly = false)
	public boolean savePresupuestoTrabajo(DtoPresupuestosTrabajo presupuestoDto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(presupuestoDto.getId()));
		PresupuestoTrabajo presupuestoTrabajo = genericDao.get(PresupuestoTrabajo.class, filtro);
		Trabajo trabajo = findOne(presupuestoTrabajo.getTrabajo().getId());

		try {
			beanUtilNotNull.copyProperties(presupuestoTrabajo, presupuestoDto);
			if (presupuestoDto.getIdProveedor() != null) {
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "id", presupuestoDto.getIdProveedor());
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtro2);
				presupuestoTrabajo.setProveedor(proveedor);
			}
			if (presupuestoDto.getIdProveedorContacto() != null) {
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "id", presupuestoDto.getIdProveedorContacto());

				ActivoProveedorContacto proveedorContacto = genericDao.get(ActivoProveedorContacto.class, filtro2);
				presupuestoTrabajo.setProveedorContacto(proveedorContacto);
			}
			if (presupuestoDto.getEstadoPresupuestoCodigo() != null) {
				Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "codigo",
						presupuestoDto.getEstadoPresupuestoCodigo());

				DDEstadoPresupuesto estadoPresupuesto = genericDao.get(DDEstadoPresupuesto.class, filtro3);
				presupuestoTrabajo.setEstadoPresupuesto(estadoPresupuesto);
				// Si el nuevo estado del presupuesto es autorizado, el resto de
				// presupuestos para ese trabajo pasa a ser rechazado
				// Sacar lista de todos los presupuestos menos el que acabamos
				// de modificar y cambiar atributo
				if ("02".equalsIgnoreCase(estadoPresupuesto.getCodigo())) {
					Filter filtroPresupuestos = genericDao.createFilter(FilterType.EQUALS, "trabajo.id",
							presupuestoTrabajo.getTrabajo().getId());
					List<PresupuestoTrabajo> listaPresup = genericDao.getList(PresupuestoTrabajo.class,
							filtroPresupuestos);

					// Buscamos el proveedor y lo asignamos al trabajo
					filtro = genericDao.createFilter(FilterType.EQUALS, "id", presupuestoTrabajo.getProveedorContacto().getId());

					ActivoProveedorContacto activoProveedor = genericDao.get(ActivoProveedorContacto.class, filtro);
					trabajo.setProveedorContacto(activoProveedor);

					for (PresupuestoTrabajo presup : listaPresup) {
						if (presup.getId() != presupuestoTrabajo.getId()) {
							Filter filtroRechazado = genericDao.createFilter(FilterType.EQUALS, "codigo", "01"); // Estado
																													// rechazado
							DDEstadoPresupuesto estadoPresupuestoRechazado = genericDao
									.get(DDEstadoPresupuesto.class, filtroRechazado);

							presup.setEstadoPresupuesto(estadoPresupuestoRechazado);
							genericDao.save(PresupuestoTrabajo.class, presup);
						}
					}
				}
			}
			genericDao.save(PresupuestoTrabajo.class, presupuestoTrabajo);

			actualizarImporteTotalTrabajo(trabajo.getId());

		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return true;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.saveTarifaTrabajo")
	@Transactional(readOnly = false)
	public boolean saveTarifaTrabajo(DtoTarifaTrabajo tarifaDto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(tarifaDto.getId()));
		TrabajoConfiguracionTarifa tarifaTrabajo = genericDao.get(TrabajoConfiguracionTarifa.class, filtro);

		try {

			beanUtilNotNull.copyProperties(tarifaTrabajo, tarifaDto);
			genericDao.save(TrabajoConfiguracionTarifa.class, tarifaTrabajo);
			actualizarImporteTotalTrabajo(tarifaTrabajo.getTrabajo().getId());

		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}

		return true;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.deletePresupuestoTrabajo")
	@Transactional(readOnly = false)
	public boolean deletePresupuestoTrabajo(Long id) {
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(id));

			PresupuestoTrabajo presupuesto = genericDao.get(PresupuestoTrabajo.class, filtro);
			Trabajo trabajo = presupuesto.getTrabajo();

			genericDao.deleteById(PresupuestoTrabajo.class, id);

			actualizarImporteTotalTrabajo(trabajo.getId());
			trabajoDao.save(trabajo);

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return true;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.deleteTarifaTrabajo")
	@Transactional(readOnly = false)
	public boolean deleteTarifaTrabajo(Long id) {
		try {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(id));

			TrabajoConfiguracionTarifa tarifa = genericDao.get(TrabajoConfiguracionTarifa.class, filtro);
			Trabajo trabajo = tarifa.getTrabajo();

			genericDao.deleteById(TrabajoConfiguracionTarifa.class, id);

			actualizarImporteTotalTrabajo(trabajo.getId());
			trabajoDao.save(trabajo);

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return true;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.upload")
	@Transactional(readOnly = false)
	public String upload(WebFileItem fileItem) throws Exception {

		Trabajo trabajo = trabajoDao.get(Long.parseLong(fileItem.getParameter("idEntidad")));
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));

		DDTipoDocumentoActivo tipoDocumento = genericDao.get(DDTipoDocumentoActivo.class, filtro);

		if ((DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(trabajo.getTipoTrabajo().getCodigo())
				|| DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())
				|| DDTipoTrabajo.CODIGO_PRECIOS.equals(trabajo.getTipoTrabajo().getCodigo()))
				&& gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoActuacionesTecnicas(trabajo, fileItem,
						usuarioLogado.getUsername(), tipoDocumento.getMatricula());
				// Subida del registro del adjunto al Trabajo
				CrearRelacionExpedienteDto crearRelacionExpedienteDto = new CrearRelacionExpedienteDto();
				crearRelacionExpedienteDto.setTipoRelacion(RELACION_TIPO_DOCUMENTO_EXPEDIENTE);
				String mat = tipoDocumento.getMatricula();

				if (!Checks.esNulo(mat)) {
					String[] matSplit = mat.split("-");
					crearRelacionExpedienteDto.setCodTipoDestino(matSplit[0]);
					crearRelacionExpedienteDto.setCodClaseDestino(matSplit[1]);
				}
				crearRelacionExpedienteDto.setOperacion(OPERACION_ALTA);

				gestorDocumentalAdapterApi.crearRelacionTrabajosActivo(trabajo, idDocRestClient, trabajo.getActivo().getNumActivo().toString(),
						usuarioLogado.getUsername(), crearRelacionExpedienteDto);

				AdjuntoTrabajo adjuntoTrabajo = new AdjuntoTrabajo();
				adjuntoTrabajo.setTrabajo(trabajo);
				adjuntoTrabajo.setTipoDocumentoActivo(tipoDocumento);
				adjuntoTrabajo.setContentType(fileItem.getFileItem().getContentType());
				adjuntoTrabajo.setTamanyo(fileItem.getFileItem().getLength());
				adjuntoTrabajo.setNombre(fileItem.getFileItem().getFileName());
				adjuntoTrabajo.setDescripcion(fileItem.getParameter("descripcion"));
				adjuntoTrabajo.setFechaDocumento(new Date());
				adjuntoTrabajo.setIdDocRestClient(idDocRestClient);
				Auditoria.save(adjuntoTrabajo);
				trabajo.getAdjuntos().add(adjuntoTrabajo);
				trabajoDao.save(trabajo);
			} catch (GestorDocumentalException gex) {
				logger.error(gex.getMessage());
				return gex.getMessage();
			}
		} else {

			if (!Checks.esNulo(tipoDocumento)) {

				// Subida de adjunto al Trabajo
				AdjuntoTrabajo adjuntoTrabajo = new AdjuntoTrabajo();

				Adjunto adj = uploadAdapter.saveBLOB(fileItem.getFileItem());
				adjuntoTrabajo.setAdjunto(adj);

				adjuntoTrabajo.setTrabajo(trabajo);

				adjuntoTrabajo.setTipoDocumentoActivo(tipoDocumento);

				adjuntoTrabajo.setContentType(fileItem.getFileItem().getContentType());

				adjuntoTrabajo.setTamanyo(fileItem.getFileItem().getLength());

				adjuntoTrabajo.setNombre(fileItem.getFileItem().getFileName());

				adjuntoTrabajo.setDescripcion(fileItem.getParameter("descripcion"));

				adjuntoTrabajo.setFechaDocumento(new Date());

				Auditoria.save(adjuntoTrabajo);

				trabajo.getAdjuntos().add(adjuntoTrabajo);

				trabajoDao.save(trabajo);

				// Copia de adjunto al Activo
				ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo();
				adjuntoActivo.setAdjunto(adj);
				adjuntoActivo.setActivo(trabajo.getActivo());
				adjuntoActivo.setTipoDocumentoActivo(tipoDocumento);
				adjuntoActivo.setContentType(fileItem.getFileItem().getContentType());
				adjuntoActivo.setTamanyo(fileItem.getFileItem().getLength());
				adjuntoActivo.setNombre(fileItem.getFileItem().getFileName());
				adjuntoActivo.setDescripcion(fileItem.getParameter("descripcion"));
				adjuntoActivo.setFechaDocumento(new Date());
				Auditoria.save(adjuntoActivo);
				trabajo.getActivo().getAdjuntos().add(adjuntoActivo);

			}


		}

		return null;

	}

	@Override
	@BusinessOperationDefinition("trabajoManager.getFileItemAdjunto")
	public FileItem getFileItemAdjunto(DtoAdjunto dtoAdjunto) {

		Trabajo trabajo = trabajoDao.get(dtoAdjunto.getIdEntidad());
		AdjuntoTrabajo adjuntoTrabajo = null;
		FileItem fileItem = null;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				fileItem = gestorDocumentalAdapterApi.getFileItem(dtoAdjunto.getId(),dtoAdjunto.getNombre());
			} catch (Exception e) {
				logger.error(e.getMessage());
			}
		} else {
			adjuntoTrabajo = trabajo.getAdjunto(dtoAdjunto.getId());
			fileItem = adjuntoTrabajo.getAdjunto().getFileItem();
			fileItem.setContentType(adjuntoTrabajo.getContentType());
			fileItem.setFileName(adjuntoTrabajo.getNombre());
		}

		return fileItem;
	}

	@Override
	@BusinessOperationDefinition("trabajoManager.getAdjuntosTrabajo")
	public List<DtoAdjunto> getAdjuntos(Long id) throws GestorDocumentalException {

		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		Usuario usuario = genericAdapter.getUsuarioLogado();
		Trabajo trabajo = trabajoDao.get(id);

		if ((DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(trabajo.getTipoTrabajo().getCodigo())
				|| DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())
				|| DDTipoTrabajo.CODIGO_PRECIOS.equals(trabajo.getTipoTrabajo().getCodigo()))
				&& gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosActuacionesTecnicas(trabajo);
				for (DtoAdjunto adj : listaAdjuntos) {

					AdjuntoTrabajo adjTrabajo = trabajo.getAdjuntoGD(adj.getId());
					if (!Checks.esNulo(adjTrabajo)) {
						if (!Checks.esNulo(adjTrabajo.getTipoDocumentoActivo())) {
							adj.setDescripcionTipo(adjTrabajo.getTipoDocumentoActivo().getDescripcion());
						}
						adj.setContentType(adjTrabajo.getContentType());
						if (!Checks.esNulo(adjTrabajo.getAuditoria())) {
							adj.setGestor(adjTrabajo.getAuditoria().getUsuarioCrear());
						}
						adj.setTamanyo(adjTrabajo.getTamanyo());
						adj.setDescripcion(adjTrabajo.getDescripcion());
						adj.setFechaDocumento(adjTrabajo.getFechaDocumento());
					}
				}

			} catch (GestorDocumentalException gex) {
				if (GestorDocumentalException.CODIGO_ERROR_CONTENEDOR_NO_EXISTE.equals(gex.getCodigoError())) {

					Integer idTrabajo;
					try {
						idTrabajo = gestorDocumentalAdapterApi.crearActuacionTecnica(trabajo, usuario.getUsername());
						logger.debug("GESTOR DOCUMENTAL [ crearActuacionTecnica para " + trabajo.getNumTrabajo() + "]: ID TRABAJO RECIBIDO " + idTrabajo);
					} catch (GestorDocumentalException gexc) {
						logger.error("error creando el contenedor del trabajo ",gexc);
					}
				}

				throw gex;
			}
		} else {
			try {
				for (AdjuntoTrabajo adjunto : trabajo.getAdjuntos()) {
					DtoAdjunto dto = new DtoAdjunto();

					BeanUtils.copyProperties(dto, adjunto);
					dto.setIdEntidad(trabajo.getId());
					dto.setDescripcionTipo(adjunto.getTipoDocumentoActivo().getDescripcion());
					dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());

					listaAdjuntos.add(dto);
				}
			} catch (Exception ex) {

				logger.error(ex.getMessage(),ex);

			}
		}

		return listaAdjuntos;
	}

	@Override
	public Page getListActivos(DtoActivosTrabajoFilter dto) throws InstantiationException, IllegalAccessException, Exception {

		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.idTrabajo", dto.getIdTrabajo());
   		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.idActivo", dto.getIdActivo());
   		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.estadoContable", dto.getEstadoContable());
   		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.codigoEstado", dto.getEstadoCodigo());
   		
//   		ArrayList<Filter> filtros = new ArrayList<Filter>();
//   		if(!Checks.esNulo(dto.getIdTrabajo())){
//   			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idTrabajo", dto.getIdTrabajo());
//   			filtros.add(filtro);
//   		}
//   		if(!Checks.esNulo(dto.getIdActivo())){
//   			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", dto.getIdActivo());
//   			filtros.add(filtro);
//   		}
//   		
//   		Filter[] filtrosArray = new Filter[filtros.size()];
//   		int i = 0;
//   		for(Filter f : filtros){
//   			filtrosArray[i] = f;
//   			i++;
//   		}
   		
		//flashDao.getList(VBusquedaActivosTrabajoParticipa.class,filtrosArray);
		return trabajoDao.getListActivosTrabajo(dto);
	}
	
	@Override
	public Page getActivoMatrizPresupuesto(DtoActivosTrabajoFilter dto) {

		return trabajoDao.getActivoMatrizPresupuesto(dto);
	}

	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getObservaciones(DtoTrabajoFilter dto) {

		Page page = trabajoDao.getObservaciones(dto);

		List<TrabajoObservacion> lista = (List<TrabajoObservacion>) page.getResults();
		List<DtoObservacion> observaciones = new ArrayList<DtoObservacion>();

		for (TrabajoObservacion observacion : lista) {

			DtoObservacion dtoObservacion = observacionToDto(observacion);
			observaciones.add(dtoObservacion);
		}

		return new DtoPage(observaciones, page.getTotalCount());

	}

	@Transactional(readOnly = false)
	public boolean saveObservacion(DtoObservacion dtoObservacion) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoObservacion.getId()));
		TrabajoObservacion observacion = genericDao.get(TrabajoObservacion.class, filtro);

		try {

			beanUtilNotNull.copyProperties(observacion, dtoObservacion);
			genericDao.save(TrabajoObservacion.class, observacion);

		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean createObservacion(DtoObservacion dtoObservacion, Long idTrabajo) {

		TrabajoObservacion observacion = new TrabajoObservacion();
		Trabajo trabajo = findOne(idTrabajo);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		try {

			// beanUtilNotNull.copyProperties(activoObservacion,
			// dtoObservacion);
			observacion.setObservacion(dtoObservacion.getObservacion());
			observacion.setFecha(new Date());
			observacion.setUsuario(usuarioLogado);
			observacion.setTrabajo(trabajo);

			genericDao.save(TrabajoObservacion.class, observacion);

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return true;

	}

	@Transactional(readOnly = false)
	public boolean deleteObservacion(Long idObservacion) {

		try {

			genericDao.deleteById(TrabajoObservacion.class, idObservacion);

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return true;

	}

	private DtoObservacion observacionToDto(TrabajoObservacion observacion) {

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

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return observacionDto;
	}

	private DtoConfiguracionTarifa tarifaToDto(ConfiguracionTarifa tarifa) {

		DtoConfiguracionTarifa tarifaDto = new DtoConfiguracionTarifa();

		try {
			BeanUtils.copyProperties(tarifaDto, tarifa);

			if (tarifa.getTipoTarifa() != null) {
				tarifaDto.setCodigoTarifa(tarifa.getTipoTarifa().getCodigo());
				tarifaDto.setDescripcion(tarifa.getTipoTarifa().getDescripcion());
			}

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return tarifaDto;
	}

	private DtoTarifaTrabajo tarifaAplicadaToDto(TrabajoConfiguracionTarifa tarifaAplicada) {

		DtoTarifaTrabajo tarifaDto = new DtoTarifaTrabajo();

		try {
			BeanUtils.copyProperties(tarifaDto, tarifaAplicada);
			if (tarifaAplicada.getConfigTarifa() != null) {
				BeanUtils.copyProperties(tarifaDto, tarifaAplicada.getConfigTarifa());
				// Sobreescribir la ID (con el copyProperties se adopta la de la
				// entidad ConfiguracionTarifa)
				BeanUtils.copyProperty(tarifaDto, "id", tarifaAplicada.getId());
				// Sobreescribir el precioUnitario que viene de
				// ConfiguracionTarifa si vienen datos nuevos
				if (tarifaAplicada.getPrecioUnitario() != null) {
					BeanUtils.copyProperty(tarifaDto, "precioUnitario", tarifaAplicada.getPrecioUnitario());
				}
				if (tarifaAplicada.getConfigTarifa().getTipoTarifa() != null) {
					tarifaDto.setCodigoTarifa(tarifaAplicada.getConfigTarifa().getTipoTarifa().getCodigo());
					tarifaDto.setDescripcion(tarifaAplicada.getConfigTarifa().getTipoTarifa().getDescripcion());
				}

				if (tarifaAplicada.getConfigTarifa().getSubtipoTrabajo() != null) {
					tarifaDto.setSubtipoTrabajoCodigo(tarifaAplicada.getConfigTarifa().getSubtipoTrabajo().getCodigo());
					tarifaDto.setSubtipoTrabajoDescripcion(
							tarifaAplicada.getConfigTarifa().getSubtipoTrabajo().getDescripcion());
				}
			}

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return tarifaDto;
	}

	private DtoPresupuestosTrabajo presupuestoTrabajoToDto(PresupuestoTrabajo presupuesto) {

		DtoPresupuestosTrabajo presupuestoDto = new DtoPresupuestosTrabajo();

		try {
			BeanUtils.copyProperties(presupuestoDto, presupuesto);
			if (presupuesto.getTrabajo() != null) {
				BeanUtils.copyProperty(presupuestoDto, "idTrabajo", presupuesto.getTrabajo().getId());
				if (presupuesto.getTrabajo().getTipoTrabajo() != null) {
					BeanUtils.copyProperty(presupuestoDto, "tipoTrabajoDescripcion",
							presupuesto.getTrabajo().getTipoTrabajo().getDescripcion());
				}
				if (presupuesto.getTrabajo().getSubtipoTrabajo() != null) {
					BeanUtils.copyProperty(presupuestoDto, "subtipoTrabajoDescripcion",
							presupuesto.getTrabajo().getSubtipoTrabajo().getDescripcion());

				}
			}
			if (presupuesto.getProveedor() != null) {
				BeanUtils.copyProperty(presupuestoDto, "idProveedor", presupuesto.getProveedor().getId());
				BeanUtils.copyProperty(presupuestoDto, "proveedorDescripcion", presupuesto.getProveedor().getNombre());
				BeanUtils.copyProperty(presupuestoDto, "codigoTipoProveedor", presupuesto.getProveedor().getTipoProveedor().getCodigo());

			}
			if (presupuesto.getEstadoPresupuesto() != null) {
				BeanUtils.copyProperty(presupuestoDto, "estadoPresupuestoCodigo",
						presupuesto.getEstadoPresupuesto().getCodigo());
				BeanUtils.copyProperty(presupuestoDto, "estadoPresupuestoDescripcion",
						presupuesto.getEstadoPresupuesto().getDescripcion());
			}
			if(presupuesto.getProveedorContacto() != null){
				BeanUtils.copyProperty(presupuestoDto, "idProveedorContacto", presupuesto.getProveedorContacto().getId());
				BeanUtils.copyProperty(presupuestoDto, "nombreProveedorContacto", presupuesto.getProveedorContacto().getNombre());
				BeanUtils.copyProperty(presupuestoDto, "emailProveedorContacto", presupuesto.getProveedorContacto().getEmail());
				if(presupuesto.getProveedorContacto().getUsuario() != null) {
					BeanUtils.copyProperty(presupuestoDto, "usuarioProveedorContacto", presupuesto.getProveedorContacto().getUsuario().getApellidoNombre());

				}
			}

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return presupuestoDto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveActivoTrabajo(DtoActivoTrabajo dtoActivoTrabajo) {
		Float porcentajeParticipacion = null;

		if (dtoActivoTrabajo.getParticipacion() != null) {
			porcentajeParticipacion = Float.valueOf(dtoActivoTrabajo.getParticipacion());
		}
		
		if(porcentajeParticipacion != null) {
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "activo.id",
					Long.valueOf(dtoActivoTrabajo.getIdActivo()));
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "trabajo.id",
					Long.valueOf(dtoActivoTrabajo.getIdTrabajo()));

			ActivoTrabajo activoTrabajo = genericDao.get(ActivoTrabajo.class, f1, f2);
			activoTrabajo.setParticipacion(porcentajeParticipacion);
			genericDao.update(ActivoTrabajo.class, activoTrabajo);
			// Si el trabajo está asociado a un gasto actualizar el porcentaje en el
			// mismo.
			if (activoTrabajo.getTrabajo().getGastoTrabajo() != null) {
				gastoProveedorApi.calcularParticipacionActivosGasto(activoTrabajo.getTrabajo().getGastoTrabajo().getGastoProveedor());
			}
		}	

		return true;
	}

	@Override
	public Page getListActivosAgrupacion(DtoAgrupacionFilter filtro, Long id) {
		if(id == null)
			return null;
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		filtro.setAgrupacionId(String.valueOf(id));

		return trabajoDao.getListActivosAgrupacion(filtro, usuarioLogado);
	}

	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getSeleccionTarifasTrabajo(DtoGestionEconomicaTrabajo filtro, String cartera, String tipoTrabajo,
			String subtipoTrabajo, String codigoTarifa, String descripcionTarifa, String subcarteraCodigo) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		filtro.setCarteraCodigo(cartera);
		filtro.setTipoTrabajoCodigo(tipoTrabajo);
		filtro.setSubtipoTrabajoCodigo(subtipoTrabajo);
		filtro.setSubcarteraCodigo(subcarteraCodigo);
		
		if (!Checks.esNulo(filtro.getIdTrabajo())) {
			Trabajo trabajo = findOne(filtro.getIdTrabajo());
			if (!Checks.esNulo(trabajo.getProveedorContacto())
					&& !Checks.esNulo(trabajo.getProveedorContacto().getProveedor())) {
				filtro.setIdProveedor(trabajo.getProveedorContacto().getProveedor().getId());
			}
		}
		if (!Checks.esNulo(codigoTarifa)) {
			filtro.setCodigoTarifaTrabajo(codigoTarifa);
		}
		if (!Checks.esNulo(descripcionTarifa)) {
			filtro.setDescripcionTarifaTrabajo(descripcionTarifa);
		}
		Page page = trabajoDao.getSeleccionTarifasTrabajo(filtro, usuarioLogado);
		// Si no existen tarifas para un Proveedor, se recuperan las tarifas sin
		// el filtro del Proveedor
		if (page.getTotalCount() == 0) {
			filtro.setIdProveedor(null);
			page = trabajoDao.getSeleccionTarifasTrabajo(filtro, usuarioLogado);
		}

		List<ConfiguracionTarifa> lista = (List<ConfiguracionTarifa>) page.getResults();
		List<DtoConfiguracionTarifa> tarifas = new ArrayList<DtoConfiguracionTarifa>();

		for (ConfiguracionTarifa configuracion : lista) {

			DtoConfiguracionTarifa dtoConfiguracionTarifa = tarifaToDto(configuracion);
			tarifas.add(dtoConfiguracionTarifa);
		}

		return new DtoPage(tarifas, page.getTotalCount());
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoTarifaTrabajo> getListDtoTarifaTrabajo(DtoGestionEconomicaTrabajo filtro, Long idTrabajo) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		filtro.setIdTrabajo(idTrabajo);
		int limiteOriginal = filtro.getLimit();
		int startOriginal = filtro.getStart();
		filtro.setStart(0);
		filtro.setLimit(Integer.MAX_VALUE);
		Page page = trabajoDao.getTarifasTrabajo(filtro, usuarioLogado);
		BigDecimal sumaTotal = BigDecimal.ZERO;
		NumberFormat format = NumberFormat.getNumberInstance(Locale.ENGLISH);
        format.setMinimumFractionDigits(2);
        format.setMaximumFractionDigits(5);
        format.setRoundingMode(RoundingMode.HALF_EVEN);
		
		List<TrabajoConfiguracionTarifa> lista = (List<TrabajoConfiguracionTarifa>) page.getResults();
		List<DtoTarifaTrabajo> tarifas = new ArrayList<DtoTarifaTrabajo>();

		for (TrabajoConfiguracionTarifa trabajoTarifa : lista) {
			BigDecimal precioUnitario = new BigDecimal(trabajoTarifa.getPrecioUnitario().toString());
			BigDecimal medicion = new BigDecimal(trabajoTarifa.getMedicion().toString());
			sumaTotal = sumaTotal.add(precioUnitario.multiply(medicion));
		}
		
		for(int i=startOriginal; i<(((startOriginal+limiteOriginal) > lista.size()) ? lista.size() : startOriginal+limiteOriginal); i++) {		

			DtoTarifaTrabajo dtoTarifaTrabajo = tarifaAplicadaToDto(lista.get(i));
			dtoTarifaTrabajo.setTotalCount(page.getTotalCount());
			dtoTarifaTrabajo.setImporteTotalTarifas(format.format(sumaTotal));
			tarifas.add(dtoTarifaTrabajo);
		}

		return tarifas;
	}

	@Override
	public DtoPage getTarifasTrabajo(DtoGestionEconomicaTrabajo filtro, Long idTrabajo) {

		List<DtoTarifaTrabajo> listaTarifasTrabajo = getListDtoTarifaTrabajo(filtro, idTrabajo);
		
		if(!Checks.estaVacio(listaTarifasTrabajo)) {
			return new DtoPage(listaTarifasTrabajo, listaTarifasTrabajo.get(0).getTotalCount());
		}else {
			return new DtoPage(listaTarifasTrabajo, 0);
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getPresupuestosTrabajo(DtoGestionEconomicaTrabajo filtro, Long idTrabajo) {
		List<DtoPresupuestosTrabajo> presupuestos = new ArrayList<DtoPresupuestosTrabajo>();
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		filtro.setIdTrabajo(idTrabajo);
		Page page = trabajoDao.getPresupuestosTrabajo(filtro, usuarioLogado);
		
		if(!Checks.esNulo(page)){
			List<PresupuestoTrabajo> lista = (List<PresupuestoTrabajo>) page.getResults();
			
			for (PresupuestoTrabajo presupuesto : lista) {
	
				DtoPresupuestosTrabajo presupuestoDto = presupuestoTrabajoToDto(presupuesto);
				presupuestos.add(presupuestoDto);
			}
		}
		return new DtoPage(presupuestos, page.getTotalCount());
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.existePresupuestoTrabajo")
	public Boolean existePresupuestoTrabajo(TareaExterna tarea) {
		String PRESUPUESTO_AUTORIZADO = "02";

		Boolean hayPresupuestoAutorizado = false;

		Trabajo trabajo = getTrabajoByTareaExterna(tarea);

		Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
		List<PresupuestoTrabajo> presupuestosTrabajo = genericDao.getList(PresupuestoTrabajo.class, filtroTrabajo);

		for (PresupuestoTrabajo presupuestoTrabajo : presupuestosTrabajo) {
			if (PRESUPUESTO_AUTORIZADO.equals(presupuestoTrabajo.getEstadoPresupuesto().getCodigo())) {
				hayPresupuestoAutorizado = true;
			}
		}

		return hayPresupuestoAutorizado;
	}

	@Override
	public Boolean checkSuperaDelegacion(TareaExterna tarea) {
		String PRESUPUESTO_AUTORIZADO = "02";
		Long limiteDelegacion = 5000L; //Importe maximo para Delegacion a Capa Control Bankia

		Trabajo trabajo = getTrabajoByTareaExterna(tarea);

		if(!Checks.esNulo(trabajo.getEsTarificado()) && trabajo.getEsTarificado()){
			DtoGestionEconomicaTrabajo filtroTarifas = new DtoGestionEconomicaTrabajo();
			filtroTarifas.setLimit(5000000); // Limite de paginacion de resultados - Maximo soportado 5mill de tarifas por trabajo
			filtroTarifas.setStart(0);
			List<DtoTarifaTrabajo> listaTarifas = getListDtoTarifaTrabajo(filtroTarifas, trabajo.getId());

			// Acumulado por tarifas
			BigDecimal importeTotalTarifas = new BigDecimal(0);

			for (DtoTarifaTrabajo tarifaTrabajo : listaTarifas) {
				importeTotalTarifas = importeTotalTarifas.add(new BigDecimal(tarifaTrabajo.getPrecioUnitario()));

				// Si el acumulado de tarifas hasta ahora, supera limite de
				// delegacion - Supera delegacion - a Capa Control
				if (importeTotalTarifas.compareTo(new BigDecimal(limiteDelegacion)) == 1) {

					return true;
				}
			}

		} else {
			Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
			List<PresupuestoTrabajo> presupuestosTrabajo = genericDao.getList(PresupuestoTrabajo.class, filtroTrabajo);

			for (PresupuestoTrabajo presupuestoTrabajo : presupuestosTrabajo) {
				if (PRESUPUESTO_AUTORIZADO.equals(presupuestoTrabajo.getEstadoPresupuesto().getCodigo())) {

					// Si el presupuesto del trabajo supera limite de delegacion- Supera delegacion - a Capa Control
					if (presupuestoTrabajo.getImporte() != null && presupuestoTrabajo.getImporte() > limiteDelegacion)

						return true;
				}
			}
		}

		return false;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.checkSuperaPresupuestoActivoTarea")
	public Boolean checkSuperaPresupuestoActivoTarea(TareaExterna tarea)  throws Exception {
		Trabajo trabajo = getTrabajoByTareaExterna(tarea);

		return checkSuperaPresupuestoActivo(trabajo);
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.checkSuperaPresupuestoActivo")
	public Boolean checkSuperaPresupuestoActivo(Trabajo trabajo)  throws Exception {

		if (getExcesoPresupuestoActivo(trabajo) > 0L)

			return true;
		else
			return false;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.getExcesoPresupuestoActivo")
	public Float getExcesoPresupuestoActivo(Trabajo trabajo) throws Exception {

		SimpleDateFormat dfAnyo = new SimpleDateFormat("yyyy");
		String ejercicioActual = dfAnyo.format(new Date());

		Double ultimoPresupuestoActivoImporte = 0D;
		Double acumuladoTrabajosActivoImporte = 0D;
		Long idUltimoPresupuestoActivo = null;
		VBusquedaPresupuestosActivo ultimoPresupuestoActivo = null;

		// Obtiene el presupuesto del activo, si se asigno para el ejercicio
		// actual
		if (!Checks.esNulo(trabajo.getActivo()))
			idUltimoPresupuestoActivo = activoApi.getPresupuestoActual(trabajo.getActivo().getId());

		if (idUltimoPresupuestoActivo != null) {
			Filter filtroUltimoPresupuesto = genericDao.createFilter(FilterType.EQUALS, "id",
					idUltimoPresupuestoActivo.toString());

			ultimoPresupuestoActivo = genericDao.get(VBusquedaPresupuestosActivo.class, filtroUltimoPresupuesto);
		}

		if (ultimoPresupuestoActivo != null && !Checks.esNulo(ultimoPresupuestoActivo.getImporteInicial()))
			if (!Checks.esNulo(ultimoPresupuestoActivo.getSumaIncrementos()))
				ultimoPresupuestoActivoImporte = ultimoPresupuestoActivo.getImporteInicial()
						+ ultimoPresupuestoActivo.getSumaIncrementos();
			else
				ultimoPresupuestoActivoImporte = ultimoPresupuestoActivo.getImporteInicial();

		
		List<VBusquedaActivosTrabajoPresupuesto>  listaTrabajosActivo =presupuestoManager.listarTrabajosActivo(trabajo.getActivo().getId(), ejercicioActual);;
			
				
		BigDecimal importeParticipacionTrabajo = new BigDecimal(0);

		BigDecimal importeExcesoPresupuesto = new BigDecimal(0);
		
		if(listaTrabajosActivo !=null){
			for (VBusquedaActivosTrabajoPresupuesto trabajoActivo : listaTrabajosActivo) {
				if (!Checks.esNulo(trabajoActivo.getImporteParticipa()))
					importeParticipacionTrabajo = new BigDecimal(trabajoActivo.getImporteParticipa());
				else
					importeParticipacionTrabajo = new BigDecimal(0);
	
				acumuladoTrabajosActivoImporte = acumuladoTrabajosActivoImporte + importeParticipacionTrabajo.doubleValue();
			}
	
			importeExcesoPresupuesto = new BigDecimal(
					acumuladoTrabajosActivoImporte - ultimoPresupuestoActivoImporte);
			}

		return importeExcesoPresupuesto.floatValue();
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.existeTarifaTrabajo")
	public Boolean existeTarifaTrabajo(TareaExterna tarea) {

		Trabajo trabajo = getTrabajoByTareaExterna(tarea);

		if (trabajo.getEsTarifaPlana()) {
			return true;
		} else {

			Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
			List<TrabajoConfiguracionTarifa> tarifasTrabajo = genericDao.getList(TrabajoConfiguracionTarifa.class,
					filtroTrabajo);

			return !tarifasTrabajo.isEmpty();
		}
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.existeTarifaSuperiorCeroTrabajo")
	public Boolean existeTarifaSuperiorCeroTrabajo(TareaExterna tarea) {

		Trabajo trabajo = getTrabajoByTareaExterna(tarea);

		if (trabajo.getEsTarifaPlana()) {
			return true;
		} else {

			Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
			List<TrabajoConfiguracionTarifa> tarifasTrabajo = genericDao.getList(TrabajoConfiguracionTarifa.class,
					filtroTrabajo);

			for (TrabajoConfiguracionTarifa tct : tarifasTrabajo) {

				if (tct.getMedicion() != null && tct.getPrecioUnitario() != null) {

					Float importe = tct.getMedicion() * tct.getPrecioUnitario();

					if (importe > 0) {
						return true;
					}
				}
			}

			return false;
		}
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.getPresupuestoById")
	public DtoPresupuestoTrabajo getPresupuestoById(Long id) {
		DtoPresupuestoTrabajo dtoPresupuesto = new DtoPresupuestoTrabajo();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);

		PresupuestoTrabajo presupuestoSeleccionado = genericDao.get(PresupuestoTrabajo.class, filtro);

		try {
			beanUtilNotNull.copyProperties(dtoPresupuesto, presupuestoSeleccionado);
			if (presupuestoSeleccionado.getTrabajo() != null) {
				beanUtilNotNull.copyProperty(dtoPresupuesto, "tipoTrabajoDescripcion",
						presupuestoSeleccionado.getTrabajo().getTipoTrabajo().getDescripcion());
				beanUtilNotNull.copyProperty(dtoPresupuesto, "subtipoTrabajoDescripcion",
						presupuestoSeleccionado.getTrabajo().getSubtipoTrabajo().getDescripcion());
			}
			if (presupuestoSeleccionado.getEstadoPresupuesto() != null) {
				beanUtilNotNull.copyProperty(dtoPresupuesto, "estadoPresupuestoDescripcion",
						presupuestoSeleccionado.getEstadoPresupuesto().getDescripcion());
			}
			if (presupuestoSeleccionado.getProveedor() != null) {

				beanUtilNotNull.copyProperty(dtoPresupuesto, "nombreProveedor",
						presupuestoSeleccionado.getProveedor().getNombre());
				beanUtilNotNull.copyProperty(dtoPresupuesto, "emailProveedor",
						presupuestoSeleccionado.getProveedor().getEmail());
				beanUtilNotNull.copyProperty(dtoPresupuesto, "telefonoProveedor",
						presupuestoSeleccionado.getProveedor().getTelefono1());
				beanUtilNotNull.copyProperty(dtoPresupuesto, "idProveedor",
						presupuestoSeleccionado.getProveedor().getId());
				beanUtilNotNull.copyProperty(dtoPresupuesto, "codigoTipoProveedor",
						presupuestoSeleccionado.getProveedor().getTipoProveedor().getCodigo());
				// El usuario actualmente no está conectado con el proveedor,
				// así que no podemos hacer su copyProperty
			}

			if (presupuestoSeleccionado.getProveedorContacto() != null) {
				beanUtilNotNull.copyProperty(dtoPresupuesto, "idProveedorContacto",
						presupuestoSeleccionado.getProveedorContacto().getId());
				beanUtilNotNull.copyProperty(dtoPresupuesto, "nombreProveedorContacto",
						presupuestoSeleccionado.getProveedorContacto().getNombre());

				if (presupuestoSeleccionado.getProveedorContacto().getUsuario() != null) {
					beanUtilNotNull.copyProperty(dtoPresupuesto, "usuarioProveedorContacto",
							presupuestoSeleccionado.getProveedorContacto().getUsuario().getApellidoNombre());
				}
				beanUtilNotNull.copyProperty(dtoPresupuesto, "emailProveedorContacto",
						presupuestoSeleccionado.getProveedorContacto().getEmail());

			}

		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}

		return dtoPresupuesto;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.existeProveedorTrabajo")
	public Boolean existeProveedorTrabajo(TareaExterna tarea) {

		Trabajo trabajo = getTrabajoByTareaExterna(tarea);

		return !Checks.esNulo(trabajo.getProveedorContacto());
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.uploadFoto")
	@Transactional(readOnly = false)
	public String uploadFoto(WebFileItem fileItem) {

		Trabajo trabajo = findOne(Long.parseLong(fileItem.getParameter("idEntidad")));

		TrabajoFoto trabajoFoto = new TrabajoFoto(fileItem.getFileItem());

		trabajoFoto.setTrabajo(trabajo);

		trabajoFoto.setTamanyo(fileItem.getFileItem().getLength());

		trabajoFoto.setNombre(fileItem.getFileItem().getFileName());

		trabajoFoto.setDescripcion(fileItem.getParameter("descripcion"));

		trabajoFoto.setSolicitanteProveedor(Boolean.valueOf(fileItem.getParameter("solicitanteProveedor")));

		trabajoFoto.setFechaDocumento(new Date());

		Integer orden = trabajoDao.getMaxOrdenFotoById(Long.parseLong(fileItem.getParameter("idEntidad")));
		orden++;

		trabajoFoto.setOrden(orden);

		Auditoria.save(trabajoFoto);

		trabajo.getFotos().add(trabajoFoto);

		trabajoDao.save(trabajo);

		return "success";

	}

	@Override
	@BusinessOperationDefinition("trabajoManager.getComboProveedor")
	public List<VProveedores> getComboProveedor(Long idTrabajo) {

		Trabajo trabajo = findOne(idTrabajo);
		Activo activo = trabajo.getActivo();

		if (!Checks.esNulo(activo)){
			if(!Checks.esNulo(activo.getCartera())) {

				Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigoCartera", activo.getCartera().getCodigo());
				Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "baja", 0);
				Order orden = new Order(OrderType.ASC,"nombreComercial");

				return genericDao.getListOrdered(VProveedores.class, orden, filtro1, filtro3);
			}
		}

		return new ArrayList<VProveedores>();
	}

	@Override
	public List<VProveedores> getComboProveedorFiltered(Long idTrabajo, String codigoTipoProveedor) {

		Trabajo trabajo = findOne(idTrabajo);
		Activo activo = trabajo.getActivo();

		if(!Checks.esNulo(activo)){
			if(!Checks.esNulo(activo.getCartera())) {
				return proveedoresDao.getProveedoresFilteredByTiposTrabajo(codigoTipoProveedor,activo.getCartera().getCodigo());
			}
		}
		return new ArrayList<VProveedores>();
	}

	@Override
	public List<DDTipoProveedor> getComboTipoProveedorFiltered(Long idTrabajo) {

		Trabajo trabajo = findOne(idTrabajo);
		Activo activo = trabajo.getActivo();
		List<DDTipoProveedor> listaTiposProveedor = new ArrayList<DDTipoProveedor>();

		if (!Checks.esNulo(activo)) {
			if (!Checks.esNulo(activo.getCartera())) {
				Filter filtroTipoProveedor = null;
				DDTipoProveedor tipoProveedor = null;
				if (DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(trabajo.getTipoTrabajo().getCodigo())) {
					filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo",
							DDTipoProveedor.COD_MANTENIMIENTO_TECNICO);
					tipoProveedor = genericDao.get(DDTipoProveedor.class, filtroTipoProveedor);
					listaTiposProveedor.add(tipoProveedor);
					filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo",
							DDTipoProveedor.COD_ASEGURADORA);
					tipoProveedor = genericDao.get(DDTipoProveedor.class, filtroTipoProveedor);
					listaTiposProveedor.add(tipoProveedor);

				} else if (DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())) {
					String codSubtipo = trabajo.getSubtipoTrabajo().getCodigo();
					if (!DDSubtipoTrabajo.CODIGO_CEE.equals(codSubtipo)) {
						filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDTipoProveedor.COD_MANTENIMIENTO_TECNICO);
						tipoProveedor = genericDao.get(DDTipoProveedor.class, filtroTipoProveedor);
						listaTiposProveedor.add(tipoProveedor);
						filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDTipoProveedor.COD_GESTORIA);
						tipoProveedor = genericDao.get(DDTipoProveedor.class, filtroTipoProveedor);
						listaTiposProveedor.add(tipoProveedor);
						filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDTipoProveedor.COD_CERTIFICADORA);
						tipoProveedor = genericDao.get(DDTipoProveedor.class, filtroTipoProveedor);
						listaTiposProveedor.add(tipoProveedor);
						filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDTipoProveedor.COD_ASEGURADORA);
						tipoProveedor = genericDao.get(DDTipoProveedor.class, filtroTipoProveedor);
						listaTiposProveedor.add(tipoProveedor);
					} else {
						filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDTipoProveedor.COD_CERTIFICADORA);
						tipoProveedor = genericDao.get(DDTipoProveedor.class, filtroTipoProveedor);
						listaTiposProveedor.add(tipoProveedor);
						filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo",
								DDTipoProveedor.COD_MANTENIMIENTO_TECNICO);
						tipoProveedor = genericDao.get(DDTipoProveedor.class, filtroTipoProveedor);

						listaTiposProveedor.add(tipoProveedor);
					}
				}else if(DDTipoTrabajo.CODIGO_EDIFICACION.equals(trabajo.getTipoTrabajo().getCodigo())
						|| DDTipoTrabajo.CODIGO_SUELO.equals(trabajo.getTipoTrabajo().getCodigo())){
					String codTipoProveedor = trabajo.getProveedorContacto().getProveedor().getTipoProveedor().getCodigo();
					filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo",
							codTipoProveedor);
					tipoProveedor = genericDao.get(DDTipoProveedor.class, filtroTipoProveedor);

					listaTiposProveedor.add(tipoProveedor);
				}

			}
		}
		return listaTiposProveedor;
	}

	@Override
	public List<DtoProveedorContactoSimple> getComboProveedorContacto(Long idProveedor) throws Exception {
		
		List<DtoProveedorContactoSimple> listaDtoProveedorContactoSimple = new ArrayList<DtoProveedorContactoSimple>();		
		
		if (Checks.esNulo(idProveedor)) {
			throw new JsonViewerException("Debe seleccionar antes un proveedor.");
		} else {
			final String USUARIO_BORRADO = "usuario_borrado";
			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", idProveedor);
			List<ActivoProveedorContacto> listaProveedorContacto =  genericDao.getList(ActivoProveedorContacto.class, filtro1);
			for (ActivoProveedorContacto source : listaProveedorContacto) {
				try {
					Usuario usuario = source.getUsuario();
					if (!Checks.esNulo(usuario) && !usuario.getUsername().toLowerCase().contains(USUARIO_BORRADO)) {
						DtoProveedorContactoSimple target = new DtoProveedorContactoSimple();				
						BeanUtils.copyProperties(target, source);
						target.setIdUsuario(usuario.getId());
						target.setLoginUsuario(usuario.getUsername());					
						if (!Checks.esNulo(source.getProvincia())) {
							target.setCodProvincia(source.getProvincia().getCodigo());
						}
						if (!Checks.esNulo(source.getTipoDocIdentificativo())) {
							target.setCodTipoDocIdentificativo(source.getTipoDocIdentificativo().getCodigo());
						}
						if (!Checks.esNulo(usuario.getUsuarioGrupo())) {
							target.setUsuarioGrupo(usuario.getUsuarioGrupo());
						}						
						listaDtoProveedorContactoSimple.add(target);
					}
				} catch (IllegalAccessException e) {
					logger.error("Error al consultar las localidades sin filtro", e);
					throw new Exception(e);
				} catch (InvocationTargetException e) {
					logger.error("Error al consultar las localidades sin filtro", e);
					throw new Exception(e);
				}
			}
		}
		Collections.sort(listaDtoProveedorContactoSimple);
		return listaDtoProveedorContactoSimple;
	}

	@Override
	@BusinessOperationDefinition("trabajoManager.getRecargosProveedor")
	public List<DtoRecargoProveedor> getRecargosProveedor(Long idTrabajo) {

		Trabajo trabajo = findOne(idTrabajo);
		List<DtoRecargoProveedor> recargos = new ArrayList<DtoRecargoProveedor>();

		for (TrabajoRecargosProveedor recargo : trabajo.getRecargosProveedor()) {
			DtoRecargoProveedor dtoRecargo = new DtoRecargoProveedor();

			try {
				dtoRecargo.setIdRecargo(String.valueOf(recargo.getId()));
				beanUtilNotNull.copyProperties(dtoRecargo, recargo);
			} catch (Exception e) {
				logger.error(e.getMessage());
			}

			dtoRecargo.setTipoCalculoCodigo(recargo.getTipoCalculo().getCodigo());
			dtoRecargo.setTipoCalculoDescripcion(recargo.getTipoCalculo().getCodigo());
			dtoRecargo.setTipoRecargoCodigo(recargo.getTipoRecargo().getCodigo());
			dtoRecargo.setTipoRecargoDescripcion(recargo.getTipoRecargo().getDescripcion());

			recargos.add(dtoRecargo);
		}

		return recargos;

	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.createRecargoProveedor")
	@Transactional(readOnly = false)
	public boolean createRecargoProveedor(DtoRecargoProveedor recargoDto, Long idTrabajo) {
		Trabajo trabajo = trabajoDao.get(idTrabajo);

		try {
			TrabajoRecargosProveedor recargo = new TrabajoRecargosProveedor();
			recargo.setTrabajo(trabajo);

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", recargoDto.getTipoCalculoCodigo());
			DDTipoCalculo tipoCalculo = genericDao.get(DDTipoCalculo.class, filtro);
			recargo.setTipoCalculo(tipoCalculo);

			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", recargoDto.getTipoRecargoCodigo());

			DDTipoRecargoProveedor tipoRecargo = genericDao.get(DDTipoRecargoProveedor.class, filtro);
			recargo.setTipoRecargo(tipoRecargo);
			beanUtilNotNull.copyProperties(recargo, recargoDto);
			trabajo.getRecargosProveedor().add(recargo);

			genericDao.save(TrabajoRecargosProveedor.class, recargo);

			actualizarImporteTotalTrabajo(idTrabajo);

		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return true;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.saveRecargoProveedor")
	@Transactional(readOnly = false)
	public boolean saveRecargoProveedor(DtoRecargoProveedor recargoDto) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(recargoDto.getIdRecargo()));
		TrabajoRecargosProveedor recargo = genericDao.get(TrabajoRecargosProveedor.class, filtro);

		try {

			beanUtilNotNull.copyProperties(recargo, recargoDto);

			if (!Checks.esNulo(recargoDto.getTipoCalculoCodigo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", recargoDto.getTipoCalculoCodigo());
				DDTipoCalculo tipoCalculo = genericDao.get(DDTipoCalculo.class, filtro);
				recargo.setTipoCalculo(tipoCalculo);
			}

			if (!Checks.esNulo(recargoDto.getTipoRecargoCodigo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", recargoDto.getTipoRecargoCodigo());

				DDTipoRecargoProveedor tipoRecargo = genericDao.get(DDTipoRecargoProveedor.class, filtro);

				recargo.setTipoRecargo(tipoRecargo);
			}
			genericDao.save(TrabajoRecargosProveedor.class, recargo);

			actualizarImporteTotalTrabajo(recargo.getTrabajo().getId());

		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}

		return true;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.deleteRecargoProveedor")
	@Transactional(readOnly = false)
	public boolean deleteRecargoProveedor(Long id) {

		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(id));
			TrabajoRecargosProveedor recargo = genericDao.get(TrabajoRecargosProveedor.class, filtro);
			Long idTrabajo = recargo.getTrabajo().getId();
			genericDao.deleteById(TrabajoRecargosProveedor.class, id);

			actualizarImporteTotalTrabajo(idTrabajo);

		} catch (Exception e) {
			logger.error(e.getMessage());
			return false;
		}

		return true;
	}

	@Override
	public List<DtoProvisionSuplido> getProvisionSuplidos(Long idTrabajo) {

		Trabajo trabajo = findOne(idTrabajo);
		List<DtoProvisionSuplido> provisionesSuplidos = new ArrayList<DtoProvisionSuplido>();

		for (TrabajoProvisionSuplido provisionSuplido : trabajo.getProvisionSuplido()) {
			DtoProvisionSuplido dtoProvisionSuplido = new DtoProvisionSuplido();

			try {

				dtoProvisionSuplido.setIdProvisionSuplido(String.valueOf(provisionSuplido.getId()));
				beanUtilNotNull.copyProperties(dtoProvisionSuplido, provisionSuplido);

			} catch (Exception e) {
				logger.error(e.getMessage());
			}

			dtoProvisionSuplido.setTipoCodigo(provisionSuplido.getTipoAdelanto().getCodigo());
			dtoProvisionSuplido.setTipoDescripcion(provisionSuplido.getTipoAdelanto().getDescripcion());

			provisionesSuplidos.add(dtoProvisionSuplido);
		}

		return provisionesSuplidos;

	}

	@Override
	@Transactional(readOnly = false)
	public boolean createProvisionSuplido(DtoProvisionSuplido provisionSuplidoDto, Long idTrabajo) {

		Trabajo trabajo = trabajoDao.get(idTrabajo);

		try {
			TrabajoProvisionSuplido provisionSuplido = new TrabajoProvisionSuplido();
			provisionSuplido.setTrabajo(trabajo);

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", provisionSuplidoDto.getTipoCodigo());
			DDTipoAdelanto tipoAdelanto = genericDao.get(DDTipoAdelanto.class, filtro);
			provisionSuplido.setTipoAdelanto(tipoAdelanto);

			beanUtilNotNull.copyProperties(provisionSuplido, provisionSuplidoDto);

			genericDao.save(TrabajoProvisionSuplido.class, provisionSuplido);

			actualizarImporteTotalTrabajo(idTrabajo);

		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveProvisionSuplido(DtoProvisionSuplido provisionSuplidoDto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id",
				Long.valueOf(provisionSuplidoDto.getIdProvisionSuplido()));
		TrabajoProvisionSuplido provisionSuplido = genericDao.get(TrabajoProvisionSuplido.class, filtro);

		try {

			beanUtilNotNull.copyProperties(provisionSuplido, provisionSuplidoDto);

			if (!Checks.esNulo(provisionSuplidoDto.getTipoCodigo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", provisionSuplidoDto.getTipoCodigo());
				DDTipoAdelanto tipoAdelanto = genericDao.get(DDTipoAdelanto.class, filtro);
				provisionSuplido.setTipoAdelanto(tipoAdelanto);
			}

			genericDao.save(TrabajoProvisionSuplido.class, provisionSuplido);

		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteProvisionSuplido(Long id) {
		try {
			genericDao.deleteById(TrabajoProvisionSuplido.class, id);

		} catch (Exception e) {
			logger.error(e.getMessage());
			return false;
		}

		return true;
	}

	@Override
	public Boolean comprobarExisteAdjuntoTrabajo(Long idTrabajo, String codigoDocumento) {

		Filter idTrabajoFilter = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", idTrabajo);
		Filter codigoDocumentoFilter = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo.codigo",
				codigoDocumento);

		List<AdjuntoTrabajo> adjuntosTrabajo = genericDao.getList(AdjuntoTrabajo.class, idTrabajoFilter,
				codigoDocumentoFilter);

		if (!Checks.estaVacio(adjuntosTrabajo)) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public String hoyDateServer() {
		return groovyft.format(new Date());
	}

	@Override
	public String diffDate(String date1, String date2) {

		Long datef1 = null;
		Long datef2 = null;

		if (date1 != null && !date1.isEmpty()) {
			datef1 = Long.valueOf(date1.replace("-", ""));
		}
		if (date2 != null && !date2.isEmpty()) {
			datef2 = Long.valueOf(date2.replace("-", ""));
		}
		if(datef1 == null && datef2 == null){
			return "IGUAL";
		}
		if(datef1 == null){
			return "MENOR";
		}
		if(datef2 == null){
			return "MAYOR";
		}
		if (datef1.equals(datef2)) {
			return "IGUAL";
		} else if (datef1 > datef2) {
			return "MAYOR";
		} else {
			return "MENOR";
		}
	}

	@Override
	public String getFechaSolicitudTrabajo(TareaExterna tareaExterna) {
		if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
				|| Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo()
						.getFechaSolicitud()))
			return null;
		else
			return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite()
					.getTrabajo().getFechaSolicitud());
	}

	@Override
	public String getFechaAprobacionTrabajo(TareaExterna tareaExterna) {
		if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
				|| Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo()
						.getFechaAprobacion()))
			return null;
		else
			return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite()
					.getTrabajo().getFechaAprobacion());
	}

	@Override
	public String getFechaRechazoTrabajo(TareaExterna tareaExterna) {
		if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
				|| Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo()
						.getFechaRechazo()))
			return null;
		else
			return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite()
					.getTrabajo().getFechaRechazo());
	}

	@Override
	public String getFechaEleccionProveedorTrabajo(TareaExterna tareaExterna) {
		if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
				|| Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo()
						.getFechaEleccionProveedor()))
			return null;
		else
			return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite()
					.getTrabajo().getFechaEleccionProveedor());
	}

	@Override
	public String getFechaEjecutadoTrabajo(TareaExterna tareaExterna) {
		if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
				|| Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo()
						.getFechaEjecucionReal()))
			return null;
		else
			return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite()
					.getTrabajo().getFechaEjecucionReal());
	}

	@Override
	public String getFechaValidacionTrabajo(TareaExterna tareaExterna) {
		if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
				|| Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo()
						.getFechaValidacion()))
			return null;
		else
			return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite()
					.getTrabajo().getFechaValidacion());
	}

	@Override
	public String getFechaAnulacionTrabajo(TareaExterna tareaExterna) {
		if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
				|| Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo()
						.getFechaAnulacion()))
			return null;
		else
			return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite()
					.getTrabajo().getFechaAnulacion());
	}

	@Override
	public String getFechaCierreEcoTrabajo(TareaExterna tareaExterna) {
		if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
				|| Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo()
						.getFechaCierreEconomico()))
			return null;
		else
			return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite()
					.getTrabajo().getFechaCierreEconomico());
	}

	@Override
	public String getFechaPagoTrabajo(TareaExterna tareaExterna) {
		if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
				|| Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo()
						.getFechaPago()))
			return null;
		else
			return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite()
					.getTrabajo().getFechaPago());
	}

	@Override
	public Boolean existsTrabajoByIdTrabajoWebcom(Long idTrabajoWebcom) {
		Boolean existe = null;
		DtoTrabajoFilter dtoTrabajo = null;

		try {

			if (Checks.esNulo(idTrabajoWebcom)) {
				throw new Exception("El parámetro idTrabajoWebcom es obligatorio.");

			} else {
				dtoTrabajo = new DtoTrabajoFilter();
				dtoTrabajo.setIdTrabajoWebcom(idTrabajoWebcom);
				existe = trabajoDao.existsTrabajo(dtoTrabajo);
			}

		} catch (Exception ex) {
			logger.error(ex.getMessage());
		}

		return existe;
	}

	@Override
	public HashMap<String, String> validateTrabajoPostRequestData(TrabajoDto trabajoDto) {
		HashMap<String, String> hashErrores = restApi.validateRequestObject(trabajoDto);
		Boolean existe = null;

		hashErrores = restApi.validateRequestObject(trabajoDto, TIPO_VALIDACION.INSERT);

		if (Checks.esNulo(trabajoDto.getIdTrabajoWebcom())) {
			hashErrores.put("idTrabajoWebcom", RestApi.REST_MSG_MISSING_REQUIRED);

		} else {

			existe = existsTrabajoByIdTrabajoWebcom(trabajoDto.getIdTrabajoWebcom());
			if (Checks.esNulo(existe) || (!Checks.esNulo(existe) && existe)) {
				hashErrores.put("idTrabajoWebcom", RestApi.REST_MSG_UNKNOWN_KEY);

			} else {

				if (!Checks.esNulo(trabajoDto.getIdActivoHaya())) {
					Activo activo = genericDao.get(Activo.class,
							genericDao.createFilter(FilterType.EQUALS, "numActivo", trabajoDto.getIdActivoHaya()));
					if (Checks.esNulo(activo)) {
						hashErrores.put("idActivoHaya", RestApi.REST_MSG_UNKNOWN_KEY);
					}
				}
				if (!Checks.esNulo(trabajoDto.getCodTipoTrabajo())) {
					DDTipoTrabajo tipotbj = genericDao.get(DDTipoTrabajo.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", trabajoDto.getCodTipoTrabajo()));
					if (Checks.esNulo(tipotbj)) {
						hashErrores.put("codTipoTrabajo", RestApi.REST_MSG_UNKNOWN_KEY);
					} else if (!Checks.esNulo(tipotbj)
							&& !tipotbj.getCodigo().equalsIgnoreCase(DDTipoTrabajo.CODIGO_ACTUACION_TECNICA)) {
						hashErrores.put("codTipoTrabajo", RestApi.REST_MSG_UNKNOWN_KEY);
					}
				}
				if (!Checks.esNulo(trabajoDto.getCodSubtipoTrabajo())) {

					DDSubtipoTrabajo subtipotbj = genericDao.get(DDSubtipoTrabajo.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", trabajoDto.getCodSubtipoTrabajo()));
					if (Checks.esNulo(subtipotbj)) {
						hashErrores.put("codSubtipoTrabajo", RestApi.REST_MSG_UNKNOWN_KEY);
					} else if (!Checks.esNulo(subtipotbj) && !subtipotbj.getCodigoTipoTrabajo()
							.equalsIgnoreCase(DDTipoTrabajo.CODIGO_ACTUACION_TECNICA)) {
						hashErrores.put("codSubtipoTrabajo", RestApi.REST_MSG_UNKNOWN_KEY);
					}
				}
				if (!Checks.esNulo(trabajoDto.getIdUsuarioRemAccion())) {
					Usuario user = genericDao.get(Usuario.class,
							genericDao.createFilter(FilterType.EQUALS, "id", trabajoDto.getIdUsuarioRemAccion()));
					if (Checks.esNulo(user)) {
						hashErrores.put("idUsuarioRem", RestApi.REST_MSG_UNKNOWN_KEY);
					}
				}
				if (!Checks.esNulo(trabajoDto.getIdProveedorRem())) {
					ActivoProveedor apiResp = genericDao.get(ActivoProveedor.class, genericDao
							.createFilter(FilterType.EQUALS, "codigoProveedorRem", trabajoDto.getIdProveedorRem()));
					if (Checks.esNulo(apiResp)) {
						hashErrores.put("idProveedorRem", RestApi.REST_MSG_UNKNOWN_KEY);
					}
				}

				if (!Checks.esNulo(trabajoDto.getFechaPrioridadRequirienteEsExacta())
						&& trabajoDto.getFechaPrioridadRequirienteEsExacta()) {

					if (Checks.esNulo(trabajoDto.getFechaPrioridadRequiriente())) {
						hashErrores.put("fechaPrioridadRequiriente", RestApi.REST_MSG_MISSING_REQUIRED);
					}

				} else if (!Checks.esNulo(trabajoDto.getFechaPrioridadRequirienteEsExacta())
						&& !trabajoDto.getFechaPrioridadRequirienteEsExacta()) {

					// Validamos que venga fecha o alguno de los checks
					if (Checks.esNulo(trabajoDto.getFechaPrioridadRequiriente())
							&& (Checks.esNulo(trabajoDto.getUrgentePrioridadRequiriente())
									|| (!Checks.esNulo(trabajoDto.getUrgentePrioridadRequiriente())
											&& !trabajoDto.getUrgentePrioridadRequiriente()))
							&& (Checks.esNulo(trabajoDto.getRiesgoPrioridadRequiriente())
									|| (!Checks.esNulo(trabajoDto.getRiesgoPrioridadRequiriente())
											&& !trabajoDto.getRiesgoPrioridadRequiriente()))) {
						hashErrores.put("fechaPrioridadRequiriente", RestApi.REST_MSG_MISSING_REQUIRED);
					}
				}
			}
		}

		return hashErrores;
	}

	@Override
	public DtoFichaTrabajo convertTrabajoDto2DtoFichaTrabajo(TrabajoDto trabajoDto) {
		DtoFichaTrabajo dtoFichaTrabajo = null;
		String descripcion = "";

		try {
			if (!Checks.esNulo(trabajoDto)) {
				dtoFichaTrabajo = new DtoFichaTrabajo();

				if (!Checks.esNulo(trabajoDto.getIdTrabajoWebcom())) {
					dtoFichaTrabajo.setIdTrabajoWebcom(trabajoDto.getIdTrabajoWebcom());
				}
				if (!Checks.esNulo(trabajoDto.getIdActivoHaya())) {
					Activo activo = genericDao.get(Activo.class,
							genericDao.createFilter(FilterType.EQUALS, "numActivo", trabajoDto.getIdActivoHaya()));
					if (!Checks.esNulo(activo)) {
						dtoFichaTrabajo.setIdActivo(activo.getId());
					}
				}
				if (!Checks.esNulo(trabajoDto.getCodTipoTrabajo())) {
					dtoFichaTrabajo.setTipoTrabajoCodigo(trabajoDto.getCodTipoTrabajo());
				}
				if (!Checks.esNulo(trabajoDto.getCodSubtipoTrabajo())) {
					dtoFichaTrabajo.setSubtipoTrabajoCodigo(trabajoDto.getCodSubtipoTrabajo());
				}
				if (!Checks.esNulo(trabajoDto.getFechaAccion())) {
					dtoFichaTrabajo.setFechaSolicitud(trabajoDto.getFechaAccion());
				}
				if (!Checks.esNulo(trabajoDto.getIdUsuarioRemAccion())) {
					dtoFichaTrabajo.setIdSolicitante(trabajoDto.getIdUsuarioRemAccion());
				}
				if (!Checks.esNulo(trabajoDto.getDescripcion())) {
					String descStr = "Descripcion: ";
					descripcion = descripcion.concat(descStr).concat(trabajoDto.getDescripcion()).concat("<br>");
				}
				if (!Checks.esNulo(trabajoDto.getNombreContacto())) {
					String nombreStr = "Nombre contacto: ";
					descripcion = descripcion.concat(nombreStr).concat(trabajoDto.getNombreContacto()).concat("<br>");
				}
				if (!Checks.esNulo(trabajoDto.getTelefonoContacto())) {
					String telfStr = "Teléfono contacto: ";
					descripcion = descripcion.concat(telfStr).concat(trabajoDto.getTelefonoContacto()).concat("<br>");
				}
				if (!Checks.esNulo(trabajoDto.getEmailContacto())) {
					String emailStr = "Email contacto: ";
					descripcion = descripcion.concat(emailStr).concat(trabajoDto.getEmailContacto()).concat("<br>");
				}
				if (!Checks.esNulo(trabajoDto.getDescripcionContacto())) {
					String descontStr = "Descripcion contacto: ";
					descripcion = descripcion.concat(descontStr).concat(trabajoDto.getDescripcionContacto())
							.concat("<br>");
				}
				if (!Checks.esNulo(descripcion) && !descripcion.equalsIgnoreCase("")) {
					dtoFichaTrabajo.setDescripcion(descripcion);
				}
				if (!Checks.esNulo(trabajoDto.getIdProveedorRem())) {
					ActivoProveedor apiResp = genericDao.get(ActivoProveedor.class, genericDao
							.createFilter(FilterType.EQUALS, "codigoProveedorRem", trabajoDto.getIdProveedorRem()));
					if (!Checks.esNulo(apiResp)) {
						dtoFichaTrabajo.setIdMediador(apiResp.getId());
					}
				}
				if (!Checks.esNulo(trabajoDto.getNombreRequiriente())) {
					dtoFichaTrabajo.setTerceroNombre(trabajoDto.getNombreRequiriente());
				}
				if (!Checks.esNulo(trabajoDto.getTelefonoRequiriente())) {
					dtoFichaTrabajo.setTerceroTel1(trabajoDto.getTelefonoRequiriente());
				}
				if (!Checks.esNulo(trabajoDto.getEmailRequiriente())) {
					dtoFichaTrabajo.setTerceroEmail(trabajoDto.getEmailRequiriente());
				}
				if (!Checks.esNulo(trabajoDto.getDescripcionRequiriente())) {
					dtoFichaTrabajo.setTerceroContacto(trabajoDto.getDescripcionRequiriente());
				}

				if (!Checks.esNulo(trabajoDto.getFechaPrioridadRequirienteEsExacta())
						&& trabajoDto.getFechaPrioridadRequirienteEsExacta()) {
					if (!Checks.esNulo(trabajoDto.getFechaPrioridadRequiriente())) {
						dtoFichaTrabajo.setFechaConcreta(trabajoDto.getFechaPrioridadRequiriente());
						dtoFichaTrabajo.setHoraConcreta(trabajoDto.getFechaPrioridadRequiriente());

					} else {
						// este supuesto no es posible x la validacion de la
						// peticion
						dtoFichaTrabajo.setFechaConcreta(new Date());
					}
				} else {
					Calendar cal = Calendar.getInstance();
					if (!Checks.esNulo(trabajoDto.getUrgentePrioridadRequiriente())
							&& trabajoDto.getUrgentePrioridadRequiriente()) {
						dtoFichaTrabajo.setUrgente(true);
						dtoFichaTrabajo.setFechaTope(cal.getTime());
					} else if (!Checks.esNulo(trabajoDto.getRiesgoPrioridadRequiriente())
							&& trabajoDto.getRiesgoPrioridadRequiriente()) {
						dtoFichaTrabajo.setRiesgoInminenteTerceros(true);
						cal.add(Calendar.DATE, 2);
						dtoFichaTrabajo.setFechaTope(cal.getTime());
					} else {
						if (!Checks.esNulo(trabajoDto.getFechaPrioridadRequiriente())) {
							dtoFichaTrabajo.setFechaTope(trabajoDto.getFechaPrioridadRequiriente());

						} else {

							dtoFichaTrabajo.setFechaTope(new Date());
						}
					}
				}
			}

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return dtoFichaTrabajo;
	}

	@Override
	public Trabajo tareaExternaToTrabajo(TareaExterna tareaExterna) {
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
	public boolean checkFormalizacion(TareaExterna tareaExterna) {
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(primerActivo.getId());
				return (Integer.valueOf(1).equals(perimetro.getAplicaFormalizar()));
			}
		}
		return false;
	}

	@Override
	public boolean checkReservaNecesariaNotNull(TareaExterna tareaExterna) {
		boolean result= false;
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			ExpedienteComercial expediente = expedienteComercialApi.findOneByTrabajo(trabajo);
			if (!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getSolicitaReserva())) {

				result = true;
			}
		}
		return result;
	}

	@Override
	public boolean checkReservaNecesariaNotNull(ExpedienteComercial expediente) {

		boolean result= false;
		if (!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getSolicitaReserva())) {

			result = true;
		}

		return result;
	}

	@Override
	public boolean checkSareb(TareaExterna tareaExterna) {
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_SAREB.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public boolean checkSareb(Trabajo trabajo) {
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_SAREB.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public boolean checkTango(TareaExterna tareaExterna) {
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_TANGO.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public boolean checkTango(Trabajo trabajo) {
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_TANGO.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public boolean checkGiants(TareaExterna tareaExterna) {
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_GIANTS.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public boolean checkGiants(Trabajo trabajo) {
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_GIANTS.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public boolean checkJaipur(Trabajo trabajo) {
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_JAIPUR.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public boolean checkGaleon(Trabajo trabajo) {
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_GALEON.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public boolean checkBankia(TareaExterna tareaExterna) {
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_BANKIA.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public boolean checkBankia(Trabajo trabajo) {
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_BANKIA.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}
	
	@Override
	public boolean checkCerberusAgoraApple(TareaExterna tareaExterna) {
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				if((DDCartera.CODIGO_CARTERA_CERBERUS.equals(primerActivo.getCartera().getCodigo()))&&
				(DDSubcartera.CODIGO_AGORA_FINANCIERO.equals(primerActivo.getSubcartera().getCodigo())||
				DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(primerActivo.getSubcartera().getCodigo())||
				DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(primerActivo.getSubcartera().getCodigo())))
				{
					return true;
				}
			}
		}
		return false;
	}

	@Override
	public boolean checkCerberusAgoraApple(Trabajo trabajo) {
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				if((DDCartera.CODIGO_CARTERA_CERBERUS.equals(primerActivo.getCartera().getCodigo()))&&
				(DDSubcartera.CODIGO_AGORA_FINANCIERO.equals(primerActivo.getSubcartera().getCodigo())||
				DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(primerActivo.getSubcartera().getCodigo())||
				DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(primerActivo.getSubcartera().getCodigo())))
				{
					return true;
				}
			}
		}
		return false;
	}

	@Override
	public boolean checkLiberbank(TareaExterna tareaExterna) {
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public boolean checkLiberbank(Trabajo trabajo) {
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public boolean checkCajamar(TareaExterna tareaExterna) {
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public boolean checkCajamar(Trabajo trabajo) {
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(primerActivo.getCartera().getCodigo()));
			}
		}
		return false;
	}

	@Override
	public DDCartera getCartera(TareaExterna tareaExterna) {
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			Activo primerActivo = trabajo.getActivo();
			if (!Checks.esNulo(primerActivo)) {
				return primerActivo.getCartera();
			}
		}

		return null;
	}

	public String comprobarPropuestaPrecios(TareaExterna tareaExterna) {

		String mensaje = new String();
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);

		if (!propuestaDao.existePropuestaEnTrabajo(trabajo.getId())) {
			mensaje = mensaje.concat(
					messageServices.getMessage("tramite.propuestaPrecios.GenerarPropuesta.validacionPre.propuesta"));
		}

		if (!Checks.esNulo(mensaje)) {
			mensaje = messageServices.getMessage("tramite.propuestaPrecios.GenerarPropuesta.validacionPre.debeRealizar")
					.concat(mensaje);
		}

		return mensaje;
	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> createTrabajos(List<TrabajoDto> listaTrabajoDto) throws Exception {
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		HashMap<String, String> errorsList = null;
		Map<String, Object> map = null;
		TrabajoDto trabajoDto = null;
		DtoFichaTrabajo dtoFichaTrabajo = null;
		for (int i = 0; i < listaTrabajoDto.size(); i++) {

			Long idTrabajo = null;
			Trabajo trabajo = null;
			map = new HashMap<String, Object>();
			trabajoDto = listaTrabajoDto.get(i);

			errorsList = this.validateTrabajoPostRequestData(trabajoDto);
			if (!Checks.esNulo(errorsList) && errorsList.isEmpty()) {
				dtoFichaTrabajo = this.convertTrabajoDto2DtoFichaTrabajo(trabajoDto);
				if (!Checks.esNulo(dtoFichaTrabajo)) {
					idTrabajo = this.create(dtoFichaTrabajo);
					if (!Checks.esNulo(idTrabajo)) {
						trabajo = this.findOne(idTrabajo);
					}
				}
			}

			if (!Checks.esNulo(errorsList) && errorsList.isEmpty() && trabajo != null) {
				map.put("idTrabajoWebcom", trabajoDto.getIdTrabajoWebcom());
				map.put("idTrabajoRem", trabajo.getNumTrabajo());
				map.put("success", true);
			} else {
				map.put("idTrabajoWebcom", trabajoDto.getIdTrabajoWebcom());
				map.put("idTrabajoRem", "");
				map.put("success", false);
				map.put("invalidFields", errorsList);
			}
			listaRespuesta.add(map);

		}
		return listaRespuesta;
	}

	@Override
	public void downloadTemplateActivosTrabajo(HttpServletRequest request, HttpServletResponse response,
			String codPlantilla) throws Exception {

		try {

			MSVDDOperacionMasiva plantilla = (MSVDDOperacionMasiva) utilDiccionarioApi
					.dameValorDiccionarioByCod(MSVDDOperacionMasiva.class, codPlantilla);

			ServletOutputStream salida = response.getOutputStream();
			FileItem fileItem = processAdapter.downloadTemplate(plantilla.getId());

			if (fileItem != null) {

				response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
				response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
				response.setHeader("Cache-Control", "max-age=0");
				response.setHeader("Expires", "0");
				response.setHeader("Pragma", "public");
				response.setDateHeader("Expires", 0); // prevents caching at the
														// proxy
				response.setContentType(fileItem.getContentType());
				// Write
				FileUtils.copy(fileItem.getInputStream(), salida);
				salida.flush();
				salida.close();
			}

		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}

	@Override
	public boolean checkEsMultiactivo(TareaExterna tareaExterna) {
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		if (!Checks.esNulo(trabajo)) {
			if (trabajo.getActivosTrabajo().size() > 1) {
				return true;
			} else {
				return false;
			}
		}
		return false;
	}

	@Override
	public Map<String, Long> getSupervisorGestor(Long idAgrupacion) {
		Map<String, Long> supervisorGestor = new HashMap<String, Long>();

		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(idAgrupacion);
		if (!Checks.esNulo(agrupacion)) {
			Activo activo = agrupacion.getActivos().get(0).getActivo();
			if (!Checks.esNulo(activo)) {
				List<DtoListadoGestores> gestores = activoAdapter.getGestores(activo.getId());
				for (DtoListadoGestores gestor : gestores) {
					if (gestor.getCodigo().equals(GestorActivoApi.CODIGO_SUPERVISOR_ACTIVOS)) {
						if (Checks.esNulo(gestor.getFechaHasta())) {
							supervisorGestor.put("SUPACT", gestor.getIdUsuario());
						}
					}
					if (gestor.getCodigo().equals(GestorActivoApi.CODIGO_GESTOR_ACTIVO)) {
						if (Checks.esNulo(gestor.getFechaHasta())) {
							supervisorGestor.put("GACT", gestor.getIdUsuario());
						}
					}
				}
			}
		}

		return supervisorGestor;
	}

	private Boolean esTrabajoTarifaPlana(Activo activo, DDSubtipoTrabajo subtipoTrabajo, Date fechaSolicitud){
		Boolean resultado = false;
		Usuario gestorProveedorTecnico = gestorActivoApi.getGestorByActivoYTipo(activo, "PTEC");
		if(!Checks.esNulo(gestorProveedorTecnico) && !Checks.esNulo(activo.getCartera())){
				if (historicoTarifaPlanaDao.subtipoTrabajoTieneTarifaPlanaVigente(activo.getCartera().getId(), subtipoTrabajo.getId(), fechaSolicitud)) {
					resultado = true;
				}
		}
		return resultado;
	}

	@Override
	public Boolean trabajoTieneTarifaPlana(TareaExterna tareaExterna){
		Boolean esTarifaPlana = false;
		Trabajo trabajo = tareaExternaToTrabajo(tareaExterna);
		Activo activo = trabajo.getActivo();
		if (!Checks.esNulo(activo) && !Checks.esNulo(trabajo)) {
			Usuario gestorProveedorTecnico = gestorActivoApi.getGestorByActivoYTipo(activo, "PTEC");
			if(!Checks.esNulo(gestorProveedorTecnico) && !Checks.esNulo(activo.getCartera())){
				if (DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo()) 
						&& DDSubcartera.CODIGO_SAR_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())) {
					esTarifaPlana = true;
				}
				else {
					if (historicoTarifaPlanaDao.subtipoTrabajoTieneTarifaPlanaVigente(activo.getCartera().getId(), trabajo.getSubtipoTrabajo().getId(), trabajo.getFechaSolicitud())) {
						esTarifaPlana = true;
					}
				}
			}
		}
		return esTarifaPlana;
	}

	public boolean superaLimiteLiberbank(Long idTramite) {
		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);
		boolean supera = false;

		if (!Checks.esNulo(activoTramite)) {
			Double importe = new Double("0.0");
			Trabajo trabajo = activoTramite.getTrabajo();
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
			List<ActivoTrabajo> listActivos = trabajo.getActivosTrabajo();
			int nActivos = listActivos.size();
			boolean hasCodPrinex = false;

			if(!Checks.esNulo(trabajo.getAgrupacion()))
				for(ActivoTrabajo activo : listActivos) {
					if(null != activo.getActivo().getCodigoPromocionPrinex() && !activo.getActivo().getCodigoPromocionPrinex().isEmpty()){
						hasCodPrinex = true;
						break;
					}
				}

			else if (!Checks.esNulo(trabajo.getCodigoPromocionPrinex()))
				hasCodPrinex = true;

			if (!Checks.esNulo(trabajo.getEsTarificado()) && !trabajo.getEsTarificado()) { // Presupuesto
				List<PresupuestoTrabajo> presupuestos = genericDao.getList(PresupuestoTrabajo.class, filtro);
				for (PresupuestoTrabajo presupuesto : presupuestos) {
					if (!presupuesto.getAuditoria().isBorrado() && !Checks.esNulo(presupuesto.getImporte())
							&& presupuesto.getEstadoPresupuesto() != null && "02".equals(presupuesto.getEstadoPresupuesto().getCodigo())) {
						importe += presupuesto.getImporte();
					}
				}
			} else { // Tarifas
				List<TrabajoConfiguracionTarifa> cfgTarifas = genericDao.getList(TrabajoConfiguracionTarifa.class, filtro);

				for (TrabajoConfiguracionTarifa tarifa : cfgTarifas) {
					if (!tarifa.getAuditoria().isBorrado() && !Checks.esNulo(tarifa.getPrecioUnitario())
							&& !Checks.esNulo(tarifa.getMedicion())) {
						importe += tarifa.getPrecioUnitario() * tarifa.getMedicion();
					}
				}
			}

			if (nActivos > 1 && hasCodPrinex) {
				if (importe >= ActuacionTecnicaUserAssignationService.LIBERBANK_LIMITE_INFERIOR_AGRUPACIONES)
					supera = true;
			} else {
				if (importe >= ActuacionTecnicaUserAssignationService.LIBERBANK_LIMITE_INFERIOR) {
					supera = true;
				}
			}
		}
		return supera;
	}

	@Override
	public Boolean trabajoEsTarificado(Long idTramite){

		ActivoTramite activoTramite = activoTramiteApi.get(idTramite);
		Trabajo trabajo = null;
		if (!Checks.esNulo(activoTramite)) {
			trabajo = activoTramite.getTrabajo();

			if (!Checks.esNulo(trabajo)) {
				if (!Checks.esNulo(trabajo.getEsTarifaPlana()) && trabajo.getEsTarifaPlana().equals(true)) {
					return true;
				} else if (!Checks.esNulo(trabajo.getEsTarificado())) {
					return trabajo.getEsTarificado();
				}
			}
		}
		return false;
	}

	public Boolean activoEnTramite(Long idActivo) {
		Activo activo;
		if(activoDao.isUnidadAlquilable(idActivo)) {
			ActivoAgrupacion actagr = activoDao.getAgrupacionPAByIdActivo(idActivo);
			activo = activoApi.get(activoDao.getIdActivoMatriz(actagr.getId()));
			
		}else {
			activo = activoApi.get(idActivo);
		}
		return activo.getEnTramite() == 1;
	}

	@Override
	public Trabajo getTrabajoByNumeroTrabajo(Long numTrabajo) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numTrabajo", numTrabajo);
		return genericDao.get(Trabajo.class, filter);
	}

	public Long getIdTareaBytbjNumTrabajoAndCodTarea(Long tbjNumTrabajo, String codTarea) {
		Long idTarea =null;
		List<Long> tareasTramite = activoTareaExternaDao.getTareasBytbjNumTrabajoCodigoTarea(tbjNumTrabajo,codTarea);
        if(!Checks.esNulo(tareasTramite) && !tareasTramite.isEmpty()) {
        	idTarea = tareasTramite.get(0);
        }
		return idTarea;
	}
	
	@Override
 	public Boolean tipoTramiteValidoObtencionDocSolicitudDocumentoGestoria(Trabajo trabajo){
 	
 		Boolean esTramiteValido = false;
	 	if(!Checks.esNulo(trabajo) && !Checks.esNulo(trabajo.getSubtipoTrabajo())  
		&&	(DDSubtipoTrabajo.CODIGO_BOLETIN_AGUA.equals(trabajo.getSubtipoTrabajo().getCodigo())
				 || DDSubtipoTrabajo.CODIGO_BOLETIN_GAS.equals(trabajo.getSubtipoTrabajo().getCodigo())
				 || DDSubtipoTrabajo.CODIGO_BOLETIN_ELECTRICIDAD.equals(trabajo.getSubtipoTrabajo().getCodigo())
				 || DDSubtipoTrabajo.CODIGO_CFO.equals(trabajo.getSubtipoTrabajo().getCodigo())
				 || DDSubtipoTrabajo.CODIGO_LPO.equals(trabajo.getSubtipoTrabajo().getCodigo())
				 || DDSubtipoTrabajo.CODIGO_VPO_AUTORIZACION_VENTA.equals(trabajo.getSubtipoTrabajo().getCodigo())
				 || DDSubtipoTrabajo.CODIGO_VPO_NOTIFICACION_ADJUDICACION.equals(trabajo.getSubtipoTrabajo().getCodigo())
				 || DDSubtipoTrabajo.CODIGO_VPO_SOLICITUD_DEVOLUCION.equals(trabajo.getSubtipoTrabajo().getCodigo())
			 )
		) {
			esTramiteValido = true;
		}
	 	
	 	return esTramiteValido;
 	}
}
