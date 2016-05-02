package es.pfsgroup.plugin.recovery.mejoras.procedimiento;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.bpm.ProcessManager;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.devon.web.DynamicElementManager;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.actitudAptitudActuacion.model.DDMotivoNoLitigar;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.asunto.dao.EstadoProcedimientoDao;
import es.capgemini.pfs.asunto.dao.ProcedimientoContratoExpedienteDao;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.dao.TipoProcedimientoDao;
import es.capgemini.pfs.asunto.dto.ProcedimientoDto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.decisionProcedimiento.DecisionProcedimientoManager;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.persona.dao.EXTPersonaDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.MEJConstantes;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.PropuestaApi;
import es.pfsgroup.plugin.recovery.mejoras.asunto.dao.MEJProcedimientoContratoExpedienteDao;
import es.pfsgroup.plugin.recovery.mejoras.expediente.MEJExpedienteFacade;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.dto.MEJDtoBloquearProcedimientos;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.dto.MEJDtoInclusionExclusionContratoProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.Dao.MEJRecursoDao;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoDto;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;

@Component
public class MEJProcedimientoManager extends BusinessOperationOverrider<MEJProcedimientoApi> implements MEJProcedimientoApi {

	@Autowired
	private Executor executor;

	@Autowired
	private DynamicElementManager tabManager;

	@Autowired
	ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private MEJRecursoDao recursoDao;

	@Autowired
	private ProcedimientoDao procedimientoDao;

	@Autowired
	private JBPMProcessManager jbpmUtil;
	
	@Autowired
	private ProcessManager processManager;

	@Autowired
	private TipoProcedimientoDao tipoProcedimientoDao;

	/* PBO: Cambiado para resolver la incidencia UGAS-1369, que requería modificaciones en ProcedimientoContratoExpedienteImpl */
	@Autowired
	@Qualifier("MEJProcedimientoContratoExpedienteDao")
	private MEJProcedimientoContratoExpedienteDao mejProcedimientoContratoExpedienteDao;

	@Autowired
	private ProcedimientoContratoExpedienteDao procedimientoContratoExpedienteDao;
	
	@Autowired
	private EXTPersonaDao personaDao;

	@Autowired
	private EstadoProcedimientoDao estadoProcedimientoDao;

	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
	@Autowired
	private DecisionProcedimientoManager decisionProcedimientoManager;
	
	@Autowired
	private AcuerdoDao propuestaDao;

	@Autowired
	private PropuestaApi propuestaApi;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	
	@BusinessOperation("procedimiento.buttons")
	public List<DynamicElement> getTabs(long idProcedimiento) {
		return tabManager.getDynamicElements("procedimiento.buttons", idProcedimiento);
	}

	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_PROCEDIMIENTO_PARALIZADO)
	public boolean procedimientoParalizado(Long id) {

		boolean procedimientoParalizado = false;

		List<TareaNotificacion> listaTareas = new ArrayList<TareaNotificacion>();
		listaTareas = (List<TareaNotificacion>) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_LIST_BY_PROC, id);
		if (listaTareas.size() > 0) {
			for (TareaNotificacion tn : listaTareas) {
				if (!Checks.esNulo(tn.getTareaExterna())) {
					procedimientoParalizado = tn.getTareaExterna().getDetenida();
				}
			}
		}

		return procedimientoParalizado;

	}

	@Override
	public String managerName() {
		return "procedimientoManager";
	}

	@Override
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_PRC_MGR_BUSCAR_TAREA_PENDIENTE)
	public TareaNotificacion buscarTareaPendiente(Long idProcedimiento) {
		EventFactory.onMethodStart(this.getClass());
		return parent().buscarTareaPendiente(idProcedimiento);
	}

	@Override
	@BusinessOperation(MEJ_MGR_PROCEDIMIENTO_BUTTONS_LEFT)
	public List<DynamicElement> getButtonsProcedimientoLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("plugin.mejoras.web.procedimientos.buttons.left", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(MEJ_MGR_PROCEDIMIENTO_BUTTONS_RIGHT)
	public List<DynamicElement> getButtonsProcedimientoRight() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("plugin.mejoras.web.procedimientos.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_PROCEDIMIENTO_BUTTONS_LEFT_FAST)
	public List<DynamicElement> getButtonsProcedimientoLeftFast() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("entidad.procedimiento.buttons.left.fast", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_PROCEDIMIENTO_BUTTONS_RIGHT_FAST)
	public List<DynamicElement> getButtonsProcedimientoRightFast() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class).getDynamicElements("entidad.procedimiento.buttons.right.fast", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_MGR_PROCEDIMIENTO_TABS_FAST)
	public List<DynamicElement> getTabsProcedimientoFast() {
		return tabManager.getDynamicElements("tabs.procedimiento.fast", null);
	}

	public GenericABMDao getGenericDao() {
		return genericDao;
	}

	public void setGenericDao(GenericABMDao genericDao) {
		this.genericDao = genericDao;
	}

	public ProcedimientoDao getProcedimientoDao() {
		return procedimientoDao;
	}

	public void setProcedimientoDao(ProcedimientoDao procedimientoDao) {
		this.procedimientoDao = procedimientoDao;
	}

	@BusinessOperation(overrides = ExternaBusinessOperation.BO_PRC_MGR_SALVAR_PROCEDIMIMENTO)
	@Transactional(readOnly = false)
	public Long salvarProcedimiento(ProcedimientoDto dto) {
		MEJProcedimiento p = saveOrUpdateProcedimiento(dto);
		
		///Si tenemos una propuesta asociada al procedimiento
		if(!Checks.esNulo(dto.getPropuesta())){
			///Asociamos la propuesta al asunto
			propuestaApi.asignaPropuestaAlAsunto(dto.getPropuesta(),dto.getAsunto());
			
			///Asociamos la propuesta al procedimiento
			Acuerdo propuesta = propuestaDao.get(dto.getPropuesta());
			p.setPropuesta(propuesta);
		}

		// Al crear una nueva lista borramos la anterior (de contratos
		// relacionados con el proc.)
		if (dto.getContratosAfectados() == null) {
			String[] idsExpedienteContratos = dto.getSeleccionContratos().split(",");
			List<ExpedienteContrato> listado = new ArrayList<ExpedienteContrato>(idsExpedienteContratos.length);
			for (int i = 0; i < idsExpedienteContratos.length; i++) {
				listado.add((ExpedienteContrato) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDINTE_CONTRATO, Long.decode(idsExpedienteContratos[i])));
			}
			p.setExpedienteContratos(listado);
		} else {
			p.setExpedienteContratos(dto.getContratosAfectados());
		}

		Long id = procedimientoDao.save(p);
		mejProcedimientoContratoExpedienteDao.actualizaCEXProcedimiento(p.getProcedimientosContratosExpedientes(), id);

		// Ahora iteramos los contratos y agregamos el procedimiento,
		// y quitamos la marca de 'Sin Actuaci�n' si la tubiera
		for (ExpedienteContrato ec : p.getExpedienteContratos()) {
			if (ec.getProcedimientos() == null) {
				ec.setProcedimientos(new ArrayList<Procedimiento>());
			}
			if (ec.getContrato().getProcedimientos() == null) {
				ec.getContrato().setProcedimientos(new ArrayList<Procedimiento>());
			}

			ec.getProcedimientos().add(p);
			ec.getContrato().getProcedimientos().add(p);
			ec.setSinActuacion(false);

			executor.execute(InternaBusinessOperation.BO_EXP_MGR_UPDATE_EXPEDIENTE_CONTRATO, ec);
			executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_SAVE_OR_UPDATE, ec.getContrato());
		}

		return id;
	}

	private MEJProcedimiento saveOrUpdateProcedimiento(ProcedimientoDto dto) {
		MEJProcedimiento p;

		if (dto.getIdProcedimiento() != null) {
			p = (MEJProcedimiento) procedimientoDao.get(dto.getIdProcedimiento());
		} else {
			p = new MEJProcedimiento();
			DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoProcedimiento.class,
					DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION);
			p.setEstadoProcedimiento(estadoProcedimiento);
			dto.setEnConformacion(true);
		}

		// Si el procedimiento se ha elevado desde un asunto y no es un
		// procedimiento original, solo se permite modificar el asunto
		if (!dto.getEnConformacion()) {
			Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, dto.getAsunto());
			p.setAsunto(asunto);
		} else {
			// En caso contrario se actualiza el resto
			if (dto.getPersonasAfectadas() == null) {
				String[] idsPersonas = dto.getSeleccionPersonas().split("-");
				Persona[] personas = new Persona[idsPersonas.length];
				for (int i = 0; i < idsPersonas.length; i++) {
					if (!"".equals(idsPersonas[i])) {
						personas[i] = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, Long.decode(idsPersonas[i]));
					}
				}
				p.setPersonasAfectadas(new ArrayList<Persona>(Arrays.asList(personas)));
			} else {
				p.setPersonasAfectadas(dto.getPersonasAfectadas());
			}

			if (p.getEstadoProcedimiento() == null) {
				DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoProcedimiento.class,
						DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION);
				p.setEstadoProcedimiento(estadoProcedimiento);
			}
			Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, dto.getAsunto());
			p.setAsunto(asunto);

			// AQUI METE EL TIPO ACTUACION
			DDTipoActuacion tipoActuacion = (DDTipoActuacion) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoActuacion.class, dto.getActuacion());
			p.setTipoActuacion(tipoActuacion);
			DDTipoReclamacion tipoReclamacion = (DDTipoReclamacion) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoReclamacion.class, dto.getTipoReclamacion());
			p.setTipoReclamacion(tipoReclamacion);

			// AQUI METE EL TIPO PROC
			p.setTipoProcedimiento(tipoProcedimientoDao.getByCodigo(dto.getTipoProcedimiento()));
			p.setPlazoRecuperacion(dto.getPlazo());
			p.setPorcentajeRecuperacion(dto.getRecuperacion());
			p.setSaldoRecuperacion(dto.getSaldorecuperar());

			p.setSaldoOriginalVencido(dto.getSaldoOriginalVencido());
			p.setSaldoOriginalNoVencido(dto.getSaldoOriginalNoVencido());
		}

		//GUARDAMOS LA NUEVA INFORMACION PRODCUTO-1089
		if(!Checks.esNulo(dto.getTipoProcedimiento())){
			if(dto.getTipoProcedimiento().equals("NOLIT")){
				//estamos en un procemiento de no litigar, guardamos motivo y observaciones
				if(!Checks.esNulo(dto.getMotivo())){
					DDMotivoNoLitigar ddMotivo;
					ddMotivo = (DDMotivoNoLitigar) diccionarioApi.dameValorDiccionarioByCod(DDMotivoNoLitigar.class, dto.getMotivo());
					if(Checks.esNulo(ddMotivo)){
						ddMotivo = (DDMotivoNoLitigar) diccionarioApi.dameValorDiccionarioByDes(DDMotivoNoLitigar.class, dto.getMotivo());
					}
					p.setMotivoNoLitigar(ddMotivo);
				}
				if(!Checks.esNulo(dto.getObservaciones())){
					p.setObservacionesNoLitigar(dto.getObservaciones());
				}
			}
		}
		//------------------------------------------------------
		procedimientoDao.saveOrUpdate(p);
		return p;
	}

	@BusinessOperation(overrides = ComunBusinessOperation.BO_JBPM_MGR_CREA_PROCEDIMIENTO_HIJO)
	public Procedimiento creaProcedimientoHijo(TipoProcedimiento tipoProcedimiento, Procedimiento procPadre) {
		EXTProcedimientoDto procDto = new EXTProcedimientoDto(); 
		procDto.setAsunto(procPadre.getAsunto());
		procDto.setProcedimientoPadre(procPadre);
		procDto.setTipoProcedimiento(tipoProcedimiento);
		procDto.setDecidido(procPadre.getDecidido());
		// procDto.setContrato(procPadre.getContrato());
		procDto.setDecidido(procPadre.getDecidido());
		procDto.setExpedienteContratos(procPadre.getExpedienteContratos());
		procDto.setFechaRecopilacion(procPadre.getFechaRecopilacion());
		procDto.setTipoProcedimiento(tipoProcedimiento);
		procDto.setProcedimientoPadre(procPadre);
		procDto.setPersonas(procPadre.getPersonasAfectadas());
		
		DDEstadoProcedimiento estadoProcedimiento = estadoProcedimientoDao.buscarPorCodigo(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO);
		procDto.setEstadoProcedimiento(estadoProcedimiento);

		procDto.setJuzgado(procPadre.getJuzgado());
		procDto.setCodigoProcedimientoEnJuzgado(procPadre.getCodigoProcedimientoEnJuzgado());
		procDto.setObservacionesRecopilacion(procPadre.getObservacionesRecopilacion());
		procDto.setPlazoRecuperacion(procPadre.getPlazoRecuperacion());
		procDto.setPorcentajeRecuperacion(procPadre.getPorcentajeRecuperacion());
		procDto.setSaldoOriginalNoVencido(procPadre.getSaldoOriginalNoVencido());
		procDto.setSaldoOriginalVencido(procPadre.getSaldoOriginalVencido());
		procDto.setSaldoRecuperacion(procPadre.getSaldoRecuperacion());
		procDto.setTipoReclamacion(procPadre.getTipoReclamacion());
		
		procDto.setBienes(procPadre.getBienes());
		
		Procedimiento prc = extProcedimientoManager.guardaProcedimiento(procDto);
		return prc;
	}

	@BusinessOperation(overrides = ComunBusinessOperation.BO_JBPM_MGR_LANZAR_BPM_ASOC_PROC)
	public Long lanzaBPMAsociadoAProcedimiento(Long idProcedimiento, Long idTokenAviso) {
		Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idProcedimiento);
		MEJProcedimiento procedimiento = (MEJProcedimiento) proc;
		// procedimientoManager.getProcedimiento(idProcedimiento);

		// Lanzamos el BPM nuevo asociandolo al nuevo procedimiento
		String procesoJBPM = procedimiento.getTipoProcedimiento().getXmlJbpm();
		Map<String, Object> params = new HashMap<String, Object>();
		params.put(BPMContants.PROCEDIMIENTO_TAREA_EXTERNA, idProcedimiento);
		if (idTokenAviso != null) {
			params.put(BPMContants.TOKEN_JBPM_PADRE, idTokenAviso);
		}

		long idProcessBPM = ((Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, procesoJBPM, params)).longValue();

		// Escribimos el id de proceso BPM en el objeto procedimiento
		procedimiento.setProcessBPM(idProcessBPM);
		saveOrUpdateProcedimiento(procedimiento);

		return idProcessBPM;
	}

	@BusinessOperation(overrides = "procedimientoManager.saveOrUpdateProcedimiento")
	@Transactional
	public void saveOrUpdateProcedimiento(Procedimiento p) {
		List<ProcedimientoContratoExpediente> procContratosExpedientes = p.getProcedimientosContratosExpedientes();
		procedimientoDao.saveOrUpdate(p);
		procedimientoContratoExpedienteDao.actualizaCEXProcedimiento(procContratosExpedientes, p.getId());
		try {
			cambiarGestorSupervisorTramiteSubasta(p);
		} catch (Exception e) {
		    //FIXME Debemos gestionar esta excepcion, por ejemplo lanzando la de m�s abajo.
		    //throw new BusinessOperationException(e);
		}
		;
	}

	/***
	 * PROPIO DE UNNIM Cambia el gestor de confecci�n de expediente y el
	 * supervisor de confecci�n de expediente del asunto cuando se crea un
	 * procedimiento del tipo Tr�mite de subasta, poniendole los
	 * correspondientes al despacho TASACI�N INTERNA - ECOGEST
	 * 
	 * Este m�todo es protected para permitir el testeo.
	 * 
	 * @param proc
	 *            {@link Procedimiento} que se va a crear
	 * 
	 * */
	protected void cambiarGestorSupervisorTramiteSubasta(Procedimiento proc) {
		if ("P11".equals(proc.getTipoProcedimiento().getCodigo())) {

			// OBTENEMOS EL ASUNTO CORRESPONDIENTE AL PROCEDIMIENTO
			EXTAsunto asunto = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "id", proc.getAsunto().getId()));

			// OBTENEMOS LOS GESTORES DESPACHO DEL DESPACHO TASACI�N INTERNA -
			// ECOGEST QUE TIENEN PUESTO EL FLAG DE GESTOR POR DEFECTO
			GestorDespacho cexp = genericDao.get(GestorDespacho.class, genericDao.createFilter(FilterType.EQUALS, "despachoExterno.despacho", "TASACI�N INTERNA - ECOGEST"),
					genericDao.createFilter(FilterType.EQUALS, "gestorPorDefecto", true));

			Order ord = new Order(OrderType.ASC, "id");
			// OBTENEMOS LOS SUPERVISORES DEL DESPACHO TASACI�N INTERNA -
			// ECOGEST QUE TIENEN PUESTO EL FLAG DE SUPERVISOR
			List<GestorDespacho> listaSup = genericDao.getListOrdered(GestorDespacho.class, ord, genericDao.createFilter(FilterType.EQUALS, "despachoExterno.despacho", "TASACI�N INTERNA - ECOGEST"),
					genericDao.createFilter(FilterType.EQUALS, "supervisor", true));

			GestorDespacho gd1 = listaSup.get(0);
			GestorDespacho gd2 = listaSup.get(1);

			// BUSCAMOS TODOS LOS CASOS QUE LOS DOS GESTORES EST�N PUESTOS COMO
			// GESTORES ADICIONALES DE ALG�N ASUNTO
			// ESTO SE REALIZARA PARA PODER IR ALTERNANDO EL SUPERVISOR DE
			// CONFECCI�N DE EXPEDIENTE QUE VAMOS A SETEAR
			List<EXTGestorAdicionalAsunto> lista1 = genericDao.getList(EXTGestorAdicionalAsunto.class, genericDao.createFilter(FilterType.EQUALS, "gestor.id", gd1.getId()),
					genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP));
			List<EXTGestorAdicionalAsunto> lista2 = genericDao.getList(EXTGestorAdicionalAsunto.class, genericDao.createFilter(FilterType.EQUALS, "gestor.id", gd2.getId()),
					genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP));

			GestorDespacho scexp = null;

			// SI UNA LISTA ES M�S GRANDE QUE LA OTRA, DEBEMOS SETEAR EL OTRO
			// SUPERVISOR
			if (lista1.size() > lista2.size()) {
				scexp = gd2;
			} else {
				scexp = gd1;
			}

			boolean cambiadoCEXP = false;
			boolean cambiadoSCEXP = false;
			for (EXTGestorAdicionalAsunto gestor : asunto.getGestoresAsunto()) {
				if (gestor.getTipoGestor().getCodigo().equalsIgnoreCase(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_CONF_EXP) && cexp != null) {
					gestor.setGestor(cexp);
					cambiadoCEXP = true;
				}
				if (gestor.getTipoGestor().getCodigo().equalsIgnoreCase(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP) && scexp != null) {
					gestor.setGestor(scexp);
					cambiadoSCEXP = true;
				}

			}

			// SI EL ASUNTO NO TENIA SETEADO EL GESTOR DE CONFECCI�N DE
			// EXPEDIENTE NI EL SUPERVISOR DE CONFECCI�N DE EXPEDIENTE
			// LO CREAMOS NUEVO
			if (!cambiadoCEXP && cexp != null) {
				EXTGestorAdicionalAsunto gaa = new EXTGestorAdicionalAsunto();
				gaa.setAsunto(asunto);
				gaa.setGestor(cexp);
				gaa.setTipoGestor(genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),
						genericDao.createFilter(FilterType.EQUALS, "codigo", EXTDDTipoGestor.CODIGO_TIPO_GESTOR_CONF_EXP)));
				gaa.setAuditoria(Auditoria.getNewInstance());

				asunto.getGestoresAsunto().add(gaa);
			}
			if (!cambiadoSCEXP && scexp != null) {
				EXTGestorAdicionalAsunto gaa = new EXTGestorAdicionalAsunto();
				gaa.setAsunto(asunto);
				gaa.setGestor(scexp);
				gaa.setTipoGestor(genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),
						genericDao.createFilter(FilterType.EQUALS, "codigo", EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP)));
				gaa.setAuditoria(Auditoria.getNewInstance());

				asunto.getGestoresAsunto().add(gaa);
			}
			genericDao.update(EXTAsunto.class, asunto);
		}

	}

    /**
     * PBO: desconexión UNNIM
     * 
	 * Excluye los contratos al expediente.
	 * 
	 * @param dto
	 *            DtoExclusionContratoExpediente
	 */
	@BusinessOperation(MEJ_BO_PRC_EXCLUIR_CONTRATOS_AL_PROCEDIMIENTO)
	@Transactional(readOnly = false)
	@Override
	public void excluirContratosAlProcedimiento(MEJDtoInclusionExclusionContratoProcedimiento dto) {
		try {
	        String[] listaCexs = dto.getCexs().split(",");
	        for (String idCex : listaCexs) {
	    		Filter fProcedimiento = genericDao.createFilter(FilterType.EQUALS,
	    				"procedimiento", dto.getIdProcedimiento());
	    		Filter fCex = genericDao.createFilter(FilterType.EQUALS,
	    				"expedienteContrato", new Long(idCex));
	    		ProcedimientoContratoExpediente procedimientoContratoExpediente = genericDao.get(ProcedimientoContratoExpediente.class, fProcedimiento,fCex);
	    		
	    		// Introducido por PBO para resolver la incidencia UGAS-1369
	    		// UGAS-1369: Borrado l�gico de los cr�ditos (CRE_PRC_CEX) asociados al procedimiento
	    		mejProcedimientoContratoExpedienteDao.delete(procedimientoContratoExpediente);
	    		// UGAS-1369: Borramos f�sicamente (de momento) de los contratos-expediente (PRC_CEX) asociados al procedimiento
	    		mejProcedimientoContratoExpedienteDao.borraCreditos(procedimientoContratoExpediente);
	        }
	        
		} catch (Exception e) {
			throw new BusinessOperationException(e);
		}

	}

    /**
     * Crea un nuevo procedimiento de tipo bloqueado.
     * @param dto UNNIMDtoInclusionExclusionContratoProcedimiento
     */
    @BusinessOperation(MEJ_BO_PRC_ADJUNTAR_CONTRATOS_AL_PROCEDIMIENTO)
	@Transactional(readOnly = false)
	@Override
    public void adjuntarContratosAlProcedimiento(MEJDtoBloquearProcedimientos dto) {

    	MEJProcedimiento p = new MEJProcedimiento();

        Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, dto.getAsunto());
        p.setAsunto(asunto);
        // estado de procedimiento
        DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoProcedimiento.class, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO);
        p.setEstadoProcedimiento(estadoProcedimiento);
        
        // tipo actuación de procedimiento
		Filter fta = genericDao.createFilter(FilterType.EQUALS, "codigo",String.valueOf(MEJConstantes.ID_TIPO_ACTUACION_BLOQUEADO));
		DDTipoActuacion tipoActuacion = genericDao.get(DDTipoActuacion.class, fta);
		p.setTipoActuacion(tipoActuacion);
		
        // tipo de procedimiento
		Filter ftp = genericDao.createFilter(FilterType.EQUALS,"codigo", String.valueOf(MEJConstantes.ID_TIPO_PROCEDIMIENTO_BLOQUEADO));
		TipoProcedimiento tipoProcedimiento = genericDao.get(TipoProcedimiento.class, ftp);
		p.setTipoProcedimiento(tipoProcedimiento);
		
        // tipo reclamación de procedimiento
		Filter ftr = genericDao.createFilter(FilterType.EQUALS, "codigo",String.valueOf(MEJConstantes.ID_TIPO_RECLAMACION_BLOQUEADO));
		DDTipoReclamacion tipoReclamacion = genericDao.get(DDTipoReclamacion.class, ftr);
		p.setTipoReclamacion(tipoReclamacion);
		
		p.setSaldoRecuperacion(dto.getSaldorecuperar());
		p.setPorcentajeRecuperacion(100);
		p.setPlazoRecuperacion(0);
		
		// personas afectadas prc_per
        String[] listaContratos = dto.getContratos().split(",");
        ArrayList<Persona> listaPersonas = new ArrayList<Persona>();
        for (String idContrato: listaContratos) {
        	Filter fContrato= genericDao.createFilter(FilterType.EQUALS,"id", new Long(idContrato));
        	Contrato contrato = genericDao.get(Contrato.class, fContrato);
        	
        	for (Persona persona : contrato.getIntervinientes()) {
				if(!listaPersonas.contains(persona)) listaPersonas.add(persona);
			}

        }
        
        p.setPersonasAfectadas(listaPersonas);
        
		genericDao.save(Procedimiento.class, p);
		
		Boolean hayPase=false;
		//guardar en cex
		//listado de contratos a adjuntar al procedimiento creado de tipo bloquedado
        for (String idContrato: listaContratos) {
    		Filter fContrato= genericDao.createFilter(FilterType.EQUALS,"id", new Long(idContrato));
    		Contrato contrato = genericDao.get(Contrato.class, fContrato);
    		
			ExpedienteContrato cex=new ExpedienteContrato();
			Expediente expediente = p.getAsunto().getExpediente();
			
			//guardo en cex
			cex.setContrato(contrato);
			cex.setExpediente(expediente);
			//ambito expediente
	        DDAmbitoExpediente ambitoExpedientePase = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
	                DDAmbitoExpediente.class, DDAmbitoExpediente.CONTRATO_PASE);
			cex.setAmbitoExpediente(ambitoExpedientePase);
			// asignar contrato de pase
			if (hayPase==false){
				cex.setPase(1);
				hayPase=true;
			}else{
				cex.setPase(0);
			}
			genericDao.save(ExpedienteContrato.class, cex);
			//guardo en procediemientoContratoExpediente
    		ProcedimientoContratoExpediente procedimientoContratoExpediente = new ProcedimientoContratoExpediente();
    		procedimientoContratoExpediente.setProcedimiento(p);
    		procedimientoContratoExpediente.setExpedienteContrato(cex);
    		mejProcedimientoContratoExpedienteDao.save(procedimientoContratoExpediente);
    		
        }
    }

	/**
	 * Incluye los contratos al expediente.
	 * 
	 * @param dto
	 *            DtoExclusionContratoExpediente
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation(MEJ_BO_PRC_INCLUIR_CONTRATOS_AL_PROCEDIMIENTO)
	@Transactional(readOnly = false)
	@Override
	public void incluirContratosAlProcedimiento(
			MEJDtoInclusionExclusionContratoProcedimiento dto) {
		List<Contrato> contratos = (List<Contrato>) executor.execute(
				PrimariaBusinessOperation.BO_CNT_MGR_GET_CONTRATOS_BY_ID, dto
						.getContratos());
	
		Procedimiento procedimiento = proxyFactory
				.proxy(ProcedimientoApi.class).getProcedimiento(
						dto.getIdProcedimiento());
		List<ProcedimientoContratoExpediente> contratosProcedimiento = procedimiento
				.getProcedimientosContratosExpedientes();
		if ((!Checks.estaVacio(contratos)) && procedimiento != null) {
			Expediente expediente = procedimiento.getAsunto().getExpediente();
			MEJExpedienteFacade unnexp = new MEJExpedienteFacade(expediente);
			if (expediente != null) {
				ExpedienteContrato cex;
				for (Contrato contrato : contratos) {
					if (unnexp.hasContrato(contrato)) {
						cex = unnexp.getExpedienteContrato(contrato);
					} else {
						dto.setIdExpediente(expediente.getId());
						proxyFactory.proxy(ExpedienteApi.class)
								.incluirContratosAlExpediente(dto);
						expediente = HibernateUtils.merge(expediente);
						unnexp = new MEJExpedienteFacade(expediente);
						cex = unnexp.getExpedienteContrato(contrato);
					}
					if (cex == null) {
						throw new BusinessOperationException(
								"mejoras.error.procedimiento.insertarContrato.error");
					}
					// Equivalente a if (cex.getProcedimientos() != null
					// Lo hacemos as� por que el getProcedimientos() peta
					// si no hay procedimientos en cex
					try {
						if (!cex.getProcedimientos().contains(procedimiento)) {
							cex.getProcedimientos().add(procedimiento);
						}
					} catch (NullPointerException e) {
						cex.setProcedimientos(Arrays.asList(procedimiento));
					}

					ProcedimientoContratoExpediente pce = new ProcedimientoContratoExpediente();
					pce.setExpedienteContrato(cex);
					pce.setProcedimiento(procedimiento);
					contratosProcedimiento.add(pce);

					executor
							.execute(
									InternaBusinessOperation.BO_EXP_MGR_UPDATE_EXPEDIENTE_CONTRATO,
									cex);
					executor
							.execute(
									PrimariaBusinessOperation.BO_CNT_MGR_SAVE_OR_UPDATE,
									cex.getContrato());
				}
				mejProcedimientoContratoExpedienteDao.actualizaCEXProcedimiento(
						contratosProcedimiento, procedimiento.getId());
			}

			HibernateUtils.merge(procedimiento);

		}

	}

	@Override
	@BusinessOperation(MEJ_BO_PRC_ES_TRAMITE_SUBASTA_BY_PRC_ID)
	public boolean esTramiteSubastaByPrcId(Long prcId) {
		
		Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);
		if("P401".equals(procedimiento.getTipoProcedimiento().getCodigo()) || "P409".equals(procedimiento.getTipoProcedimiento().getCodigo())
				 || "H002".equals(procedimiento.getTipoProcedimiento().getCodigo())  || "H003".equals(procedimiento.getTipoProcedimiento().getCodigo())  || "H004".equals(procedimiento.getTipoProcedimiento().getCodigo())
				){
			return true;
		}
		
		return false;
	}
    
}
