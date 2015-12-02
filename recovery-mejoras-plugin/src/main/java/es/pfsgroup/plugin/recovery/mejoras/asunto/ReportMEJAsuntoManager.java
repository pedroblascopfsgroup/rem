package es.pfsgroup.plugin.recovery.mejoras.asunto;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.hibernate.proxy.HibernateProxy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.ReportAsuntoApi;
import es.capgemini.pfs.asunto.dao.AsuntoDao;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.dto.DtoReportAnotacionAgenda;
import es.capgemini.pfs.asunto.dto.DtoReportAsunto;
import es.capgemini.pfs.asunto.dto.DtoReportAsuntoActuacion;
import es.capgemini.pfs.asunto.dto.DtoReportAsuntoDemandados;
import es.capgemini.pfs.asunto.dto.DtoReportComunicacion;
import es.capgemini.pfs.asunto.dto.DtoReportFaseComun;
import es.capgemini.pfs.asunto.dto.DtoReportInstrucciones;
import es.capgemini.pfs.asunto.dto.DtoReportLIQCobroPago;
import es.capgemini.pfs.asunto.dto.DtoReportProrroga;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfo;
import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfoImpl;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.core.api.registro.HistoricoProcedimientoApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procedimiento.dao.EXTProcedimientoDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.recurso.model.Recurso;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.dao.TareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dao.MEJAsuntoDao;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.Dao.MEJRecursoDao;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.recovery.api.AsuntoApi;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

@Component
public class ReportMEJAsuntoManager {

	public static final String GET_DATOS_ASUNTO_REPORT = "plugin.asunto.report.getDatosAsunto";
	public static final String GET_ACTUACIONES_ASUNTO_REPORT = "plugin.asunto.report.obtenerActuacionesAsunto";
	//private static final String GET_RIESGOS_ORIGEN_ASUNTO_REPORT = "plugin.asunto.report.obtenerRiesgosOrigen";
	public static final String GET_DEMANDADOS_ASUNTO_REPORT = "plugin.asunto.report.obtenerDemandadosAsunto";
	//private static final String GET_CUENTAS_ASUNTO_REPORT = "plugin.asunto.report.obtenerCuentasAsunto";
	public static final String GET_SOLVENCIA_BIENES_LITIGIO_REPORT = "plugin.asunto.report.obtenerSolvenciaBienesAsuntoLitigio";
	public static final String GET_HISTORICO_TAREAS_PROCEDIMIENTO_REPORT = "plugin.asunto.report.getHistoricoTareasProcedimientoAsunto";
	public static final String GET_ACUERDOS_ASUNTO_REPORT = "plugin.asunto.report.obtenerAcuerdos";
	public static final String GET_RECURSOS_ASUNTO_REPORT = "plugin.asunto.report.obtenerRecursos";
	public static final String GET_PRORROGAS_ASUNTO_REPORT = "plugin.asunto.report.obtenerProrrogas";
	public static final String GET_DECISIONES_ASUNTO_REPORT = "plugin.asunto.report.obtenerDecisiones";
	public static final String GET_LITIGIOS_ASOCIADOS_ASUNTO_REPORT = "plugin.asunto.report.obtenerLitigiosAsociados";
	public static final String GET_DEMANDAS_RESCISORIAS_REPORT = "plugin.asunto.report.obtenerDemandasRescisorias";
	public static final String GET_OBSERVACIONES_PROCEDIMIENTO_REPORT = "plugin.asunto.report.obtenerObservacionesProcedimiento";
	
	private static final String MEJ_BO_GETMAPA_REGISTRO = "plugin.mejoras.registro.getMapa";

	private static final String[] PRORROGA_CODIGO_ACEPTADA = {"7","11"};
	
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Resource
	private Properties appProperties;
	
	@Autowired
    private Executor executor;
	
	@Autowired
	private TareaExternaValorDao texValorDao;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private MEJAsuntoDao mejAsuntoDao;
	
	@Autowired
	private AsuntoDao asuntoDao;

	@Autowired
	private MEJRecursoDao mejRecursoDao;

	@Autowired
	private ProcedimientoDao procedimientoDao;
	
	@Autowired
	private EXTProcedimientoDao extProcedimientoDao;

	@Autowired
	private TareaNotificacionDao tareaNotificacionDao;
	
	@Autowired
	private UsuarioDao usuarioDao;

	
	@BusinessOperation(GET_DATOS_ASUNTO_REPORT)
	public DtoReportAsunto getDatosAsunto(Long asuId) {

		EXTAsunto asunto = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "id", asuId), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));

		//DatosExtraAsuntoFacade extras = proxyFactory.proxy(EXTAsuntoApi.class).getDatosExtraAsuntoLitigios(asuId);
		//UGASGestoresAsuntoFacade gestores = proxyFactory.proxy(MEJAsuntoApi.class).getGestoresAsuntoLitigios(asuId);

		DtoReportAsunto dto = new DtoReportAsunto(asunto);
		if (asunto == null) {
			logger.warn("No se ha encontrado el asunto con id " + asuId + ", no se van a mostrar datos en el asunto del informe");
			return dto;
		}
		
		return dto;
		
		/*
		if (extras != null) {
			dto.setCccLitigio(extras.getCodigoLitigio());
			dto.setCuentaOrigen(extras.getCuentaOrigen());
			dto.setFechaContabilizacion(extras.getFechaContabilizacion());
			dto.setGarantia(extras.getGarantia());
			dto.setReferenciaAsesoria(extras.getReferenciaAsesoria());
			dto.setTotalDeuda(extras.getTotalDeuda() != null ? extras.getTotalDeuda() : null);
			dto.setIbanLitigio(extras.getIbanLitigio());
			dto.setJuzgado(extras.getJuzgado());
			dto.setNumAuto(extras.getNumAuto());
			dto.setEstadoLitigio(extras.getEstadoLitigio());
			dto.setCartera(extras.getCartera());			
		} else {
			String cartera = proxyFactory.proxy(MEJAsuntoApi.class).getCartera(asuId);
			dto.setCartera(cartera);
		}
		*/
	}
	

	private List<Procedimiento> dameHijosProcedimiento(Procedimiento p) {
		List<Procedimiento> listaDevuelta = new ArrayList<Procedimiento>();
		if (!p.getAuditoria().isBorrado()) {
			listaDevuelta.add(p);
		}
		List<Procedimiento> listaHijosPorFecha = extProcedimientoDao.buscaHijosProcedimiento(p.getId());
		if (!Checks.esNulo(listaHijosPorFecha) && !Checks.estaVacio(listaHijosPorFecha)) {
			for (Procedimiento proc : listaHijosPorFecha) {
				List<Procedimiento> listaOtroNivel = dameHijosProcedimiento(proc);
				listaDevuelta.addAll(listaOtroNivel);
			}
		}
		return listaDevuelta;

	}
	
	/**
	 * Obtiene la informaci�n de las actuaciones de un asunto
	 * 
	 * @param idAsunto
	 *            long
	 * @return dto con la informaci�n de las actuaciones
	 */
	@BusinessOperation(GET_ACTUACIONES_ASUNTO_REPORT)
	public List<DtoReportAsuntoActuacion> obtenerActuacionesAsunto(Long idAsunto) {
		
		List<DtoReportAsuntoActuacion> actuaciones = new ArrayList<DtoReportAsuntoActuacion>();
		List<Procedimiento> procedimientosOrigen = extProcedimientoDao.getProcedimientosOrigenOrdenados(idAsunto);

		Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroNombre = genericDao.createFilter(FilterType.EQUALS, "nombre", "principalDemanda");
		List<GenericFormItem> listGenericFormItem = genericDao.getList(GenericFormItem.class, filtroNombre, filtroAuditoria);
		List<String> codigosTareas = new ArrayList<String>();
		for (GenericFormItem genericFormItem : listGenericFormItem) {
			codigosTareas.add(genericFormItem.getTareaProcedimiento().getCodigo());
		}

		for (Procedimiento p : procedimientosOrigen) {
			
			List<Procedimiento> listaHijosPorFecha = this.dameHijosProcedimiento(p);
			
			for (Procedimiento hijo : listaHijosPorFecha) {
				DtoReportAsuntoActuacion dto = new DtoReportAsuntoActuacion();
				actuaciones.add(dto);
				dto.setProcedimiento(hijo);
				
				List<TareaNotificacion> tareasProc = proxyFactory.proxy(TareaNotificacionApi.class).
						getListByProcedimientoSubtipo(hijo.getId(), SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR);
				
				if (Checks.esNulo(tareasProc)) {
					continue;
				}
					
				for (TareaNotificacion tar : tareasProc) {
					if (!codigosTareas.contains(tar.getCodigoTarea()) || tar.getTareaFinalizada() == null || !tar.getTareaFinalizada()) {
						continue;
					}
					TareaExterna tex = tar.getTareaExterna();
					List<TareaExternaValor> listTexValor = texValorDao.getByTareaExterna(tex.getId());
					
					for (TareaExternaValor texValor : listTexValor) {							
						if(!texValor.getNombre().equals("principalDemanda") || Checks.esNulo(texValor.getValor())) {
							continue;
						}
						String aux = texValor.getValor();
						String importeReclamadoLitigio = "";
						double valor = 0;
							
						valor = Double.parseDouble(aux.replace(",", "."));
						importeReclamadoLitigio = String.valueOf(valor);

						dto.setPrincipal(importeReclamadoLitigio);
						break;
					}
				
				}
			}
		}
		return actuaciones;
	}
	
	private Procedimiento getPrimerProcedimientoNoConcursalPadre(Asunto asunto) {
		if (asunto == null) {
			return null;
		}
		if (Checks.estaVacio(asunto.getProcedimientos())) {
			return null;
		}
		for (Procedimiento p : asunto.getProcedimientos()) {
			if (!p.getTipoActuacion().getCodigo().equals("CO") && (p.getProcedimientoPadre() == null)) {
				return p;
			}
		}
		return null;
	}

	private ContratoPersona getRelacionContratoPersona(List<ContratoPersona> contratosPersona, List<ExpedienteContrato> expedienteContratos) {
		if (Checks.estaVacio(contratosPersona) || Checks.estaVacio(expedienteContratos)) {
			return null;
		}
		List<Contrato> contratos = getContratos(expedienteContratos);
		for (ContratoPersona cpe : contratosPersona) {
			if (contratos.contains(cpe.getContrato())) {
				return cpe;
			}
		}
		return null;
	}
	
	private List<Contrato> getContratos(List<ExpedienteContrato> expedienteContratos) {
		if (Checks.estaVacio(expedienteContratos)) {
			return null;
		}
		ArrayList<Contrato> contratos = new ArrayList<Contrato>();
		for (ExpedienteContrato ec : expedienteContratos) {
			boolean pase = (ec.getPase() != null) && (ec.getPase() > 0);
			if (pase) {
				contratos.add(ec.getContrato());
			}
		}
		return contratos;
	}

	/**
	 * Obtiene los riesgos origen de la actuaci�n activa del asunto.
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de riesgos
	 
	@BusinessOperation(GET_RIESGOS_ORIGEN_ASUNTO_REPORT)
	public List<Contrato> obtenerRiesgosOrigenAsunto(Long idAsunto) {
		
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		List<DtoReportAsuntoRiesgoOrigen> listadoRiesgos = new ArrayList<DtoReportAsuntoRiesgoOrigen>();
		
		Set<Contrato> contratos = asunto.getContratos();
		List<Contrato> listaContratos = new ArrayList<Contrato>();
		listaContratos.addAll(contratos);
		
		return listaContratos;
	}
	*/
	/**
	 * Obtiene los demandados de un asunto.
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de demandados
	 */
	@BusinessOperation(GET_DEMANDADOS_ASUNTO_REPORT)
	public List<DtoReportAsuntoDemandados> obtenerDemandadosAsunto(Long idAsunto) {
		
		ArrayList<DtoReportAsuntoDemandados> demandados = new ArrayList<DtoReportAsuntoDemandados>();
		Procedimiento procedimientoPrincipal = getPrimerProcedimientoNoConcursalPadre(proxyFactory.proxy(AsuntoApi.class).get(idAsunto));
		if (procedimientoPrincipal != null) {
			List<Persona> personas = procedimientoPrincipal.getPersonasAfectadas();
			for (Persona p : personas) {
				ContratoPersona cpe = getRelacionContratoPersona(p.getContratosPersona(), procedimientoPrincipal.getExpedienteContratos());
				if (cpe != null) {
					DtoReportAsuntoDemandados d = new DtoReportAsuntoDemandados();
					d.setTipoIntervencion(cpe.getTipoIntervencion().getCodigo());
					d.setPersona(p);
					demandados.add(d);
				}
			}
		}
		return demandados;
	}

	/**
	 * Obtiene los contratos relacionados de un asunto.
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de cuentas
	@BusinessOperation(GET_CUENTAS_ASUNTO_REPORT)
	public List<DtoCuentaAsunto> obtenerCuentasAsunto(Long idAsunto) {

		List<DtoCuentaAsunto> cuentas = new ArrayList<DtoCuentaAsunto>();

		//if (extras != null) {
			//List<? extends UGASDatosExtraAsuntoFacade.InfoContratoAsunto> contratos = extras.getContratosAsunto();
			Procedimiento procedimientoPrincipal = getPrimerProcedimientoNoConcursalPadre(proxyFactory.proxy(AsuntoApi.class).get(idAsunto));
			List<? extends DatosExtraAsuntoFacade.InfoContratoAsunto> contratos = getContratosProcedimiento(procedimientoPrincipal);

			if (!Checks.esNulo(contratos)) {
				for (DatosExtraAsuntoFacade.InfoContratoAsunto c : contratos) {
					DtoCuentaAsunto d = new DtoCuentaAsunto();
					d.setCodigoContrato(c.getCodigoContrato());
					d.setMoneda(c.getTipoMoneda());
					d.setSaldoNoVencido(c.getSaldoNoVencido() != null ? c.getSaldoNoVencido().toString() : null);
					d.setSaldoVencido(c.getSaldoVencido() != null ? c.getSaldoVencido().toString() : null);
					d.setLimite(c.getLimite().toString());
					d.setFechaFormalizacion(c.getFechaCreacion());
					d.setFechaFinalizacion(c.fechaFinalizacion() != null ? formatter.format(c.fechaFinalizacion()) : null);
					d.setGarantia(c.getGarantia());
					d.setTipo(c.getTipoContrato());
					cuentas.add(d);
				}
			}
		//}

		return cuentas;
	}
	*/

	@BusinessOperation(GET_SOLVENCIA_BIENES_LITIGIO_REPORT)
	public List<NMBBien> obtenerSolvenciaBienesAsuntoLitigio(Long idAsunto) {
		List<NMBBien> bienes = new ArrayList<NMBBien>();
		
		EXTAsunto asunto = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "id", idAsunto), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		for (Procedimiento procedimiento : asunto.getProcedimientos()) {
			for (ProcedimientoBien procedimientoBien : procedimiento.getBienes()) {
				Bien bien = procedimientoBien.getBien();
				NMBBien nmbBien = null;
				if (!Hibernate.getClass(bien).equals(NMBBien.class)) {
					continue;
				}
				if (bien instanceof  HibernateProxy) {
					HibernateProxy proxy = (HibernateProxy) bien;
					nmbBien = ((NMBBien) proxy.writeReplace());
				} else if (bien instanceof NMBBien){
					nmbBien = (NMBBien)bien;
				}
				if (nmbBien==null) {
					continue;
				}
				if (!bienes.contains(nmbBien)) {
					bienes.add(nmbBien);
				}
			}
			
		}
		return bienes;
	}

	/**
	 * Tareas pendientes de un procedimiento.
	 * 
	 * @param idAsunto
	 * @return
	 */
	@BusinessOperation(GET_HISTORICO_TAREAS_PROCEDIMIENTO_REPORT)
	public List<HistoricoAsuntoInfo> getHistoricoTareasProcedimientoAsunto(Long idAsunto) {
		List<HistoricoAsuntoInfo> hisotoricoProcedimientos = new ArrayList<HistoricoAsuntoInfo>();
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		if (!Checks.esNulo(asunto.getProcedimientos())) {
			for (Procedimiento procedimiento : asunto.getProcedimientos()) {
				List<HistoricoAsuntoInfo> historicoProcedimiento = getHistoricoProcedimiento(procedimiento); 
				hisotoricoProcedimientos.addAll(historicoProcedimiento);
			}
		}
		return hisotoricoProcedimientos;
	}
	
	private List<HistoricoAsuntoInfo> getHistoricoProcedimiento(Procedimiento p) {

		List<HistoricoAsuntoInfo> resultado = new ArrayList<HistoricoAsuntoInfo>();
		List<HistoricoProcedimiento> listadoHistorico = proxyFactory.proxy(HistoricoProcedimientoApi.class).getListByProcedimiento(p.getId());
		
		for (HistoricoProcedimiento h : listadoHistorico) {
			HistoricoAsuntoInfoImpl haf = new HistoricoAsuntoInfoImpl();
			haf.setProcedimiento(p);
			haf.setTarea(h);
			haf.setTipoActuacion(p.getTipoActuacion().getDescripcion());
			haf.setGroup("A");
			
			if(h.getTipoEntidad().equals(HistoricoProcedimiento.TIPO_ENTIDAD_TAREA)){
				
				StringBuffer fechaTarea = new StringBuffer();
				
				if (!Checks.esNulo(h.getIdEntidad())){ 
					
					TareaNotificacion tarea = proxyFactory.proxy(TareaNotificacionApi.class).get(h.getIdEntidad());
					
					if (!Checks.esNulo(tarea.getTareaExterna())) {
						
						Long texId = tarea.getTareaExterna().getId();
					
						List<TareaExternaValor> listTexValor = texValorDao.getByTareaExterna(texId);
						for (TareaExternaValor texValor : listTexValor){							
							if(texValor.getNombre().contains("fecha")){
								if (!Checks.esNulo(texValor.getValor())){
									if(fechaTarea.length() != 0) {
										fechaTarea.append(", ");
									}
									fechaTarea.append(texValor.getNombre() + ":  " +texValor.getValor().substring(0, 10));
								}
							}
						}
					}
				}
				
				haf.setFechasTarea(fechaTarea.toString());
			} 
						
			if (HistoricoProcedimiento.TIPO_ENTIDAD_TAREA.equals(h.getTipoEntidad()))
				haf.setTipoTraza(HistoricoProcedimientoApi.TIPO_TAREA_PROCEDIMIENTO);
			if (HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_DECISION.equals(h.getTipoEntidad()) || HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_DECISION.equals(h.getTipoEntidad()))
				haf.setTipoTraza(HistoricoProcedimientoApi.TIPO_PROPUESTA_DECISION);
			resultado.add(haf);

		}
		return resultado;
	}

	/**
	 * Obtiene los acuerdos relacionados de un asunto.
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de acuerdos
	 */
	@BusinessOperation(GET_ACUERDOS_ASUNTO_REPORT)
	public List<EXTAcuerdo> obtenerAcuerdosAsunto(Long idAsunto) {

		Filter filtroAsunto = genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto);
		Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<EXTAcuerdo> listadoAcuerdos = (List<EXTAcuerdo>)genericDao.getList(EXTAcuerdo.class, filtroAuditoria, filtroAsunto); 
		return listadoAcuerdos;
	}
	
	/**
	 * Obtiene los recursos relacionados de un asunto.
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de recursos
	 */
	@BusinessOperation(GET_RECURSOS_ASUNTO_REPORT)
	public List<Recurso> obtenerRecursosAsunto(Long idAsunto) {

		EXTAsunto asunto = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "id", idAsunto), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		List<Recurso> listadoRecursos = new ArrayList<Recurso>();
		
		for (Procedimiento proc : asunto.getProcedimientos()){
			List<Recurso> listRecProc = mejRecursoDao.getRecursosPorProcedimiento(proc.getId());
			listadoRecursos.addAll(listRecProc);
		}	

		return listadoRecursos;
	}
	
	/**
	 * Obtiene las prorrogas relacionadas de un asunto.
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de prorrogas
	 */
	@BusinessOperation(GET_PRORROGAS_ASUNTO_REPORT)
	public List<DtoReportProrroga> obtenerProrrogasAsunto(Long idAsunto) {

		List<DtoReportProrroga> listadoProrrogas = new ArrayList<DtoReportProrroga>();

		// PRUEBA
		List<Procedimiento> listProc = proxyFactory.proxy(AsuntoApi.class).obtenerActuacionesAsunto(idAsunto);
		for (Procedimiento proc : listProc){
			
			// Obtenemos la tarea toma decision
			TareaNotificacion tomaDecision = new TareaNotificacion();
			
			List<TareaNotificacion> tareasDec = proxyFactory.proxy(TareaNotificacionApi.class).
					getListByProcedimientoSubtipo(proc.getId(), SubtipoTarea.CODIGO_TOMA_DECISION_BPM);
			
			for(TareaNotificacion tareaDec : tareasDec){
				if(Checks.esNulo(tareaDec.getFechaFin()))
					tomaDecision = tareaDec;
			}
			
			// Obtenemos las prorrogas
			List<TareaNotificacion> prorrogasProc = proxyFactory.proxy(TareaNotificacionApi.class).
					getListByProcedimientoSubtipo(proc.getId(), EXTSubtipoTarea.CODIGO_TAREA_PRORROGA_TOMA_DECISION);
						
			List<TareaNotificacion> prorrogasOrdenadas = ordenaTareasFechaCrear(prorrogasProc);
			
			for (TareaNotificacion tar : prorrogasOrdenadas) {
				
				Prorroga prorroga = tar.getProrroga();
				
				if (!Checks.esNulo(prorroga)){

					DtoReportProrroga dto = new DtoReportProrroga(prorroga);
					//dto.setFecha(formatter.format(prorroga.getFechaPropuesta()));
					//dto.setMotivo(prorroga.getCausaProrroga().getDescripcion());
					//dto.setDetalle(prorroga.getTarea().getDescripcionTarea());
					
					if (!Checks.esNulo(prorroga.getRespuestaProrroga())) {
						//dto.setResolucion(prorroga.getRespuestaProrroga().getDescripcion());
						
						if (Arrays.asList(PRORROGA_CODIGO_ACEPTADA).contains(prorroga.getRespuestaProrroga().getCodigo())){
							// Si ha sido aceptada buscar la causa en la traza
							
							if (!Checks.esNulo(tomaDecision.getId())){
								MEJInfoRegistro infoRegistro = getTrazaRespuestaProrroga(tomaDecision.getId());
							
								if (infoRegistro != null){
									Map<String, String> info = getInfoAdicionalTraza(infoRegistro); 
							
									if(getInfoValue(info, "DETALLE", null) != null){
										dto.setResolucionDesc(getInfoValue(info, "DETALLE", null));
									}
								}
							}
							
						} else {
							// Si ha sido rechazada buscar la causa en la tarea notificacion
							
							List<TareaNotificacion> tareasRechazo = proxyFactory.proxy(TareaNotificacionApi.class).
									getListByProcedimientoSubtipo(proc.getId(), SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_PROCEDIMIENTO);
							
							for (TareaNotificacion tarRechazo : tareasRechazo){
								if(!Checks.esNulo(tar.getFechaFin()) && 
										tar.getFechaFin().toString().substring(0, 19).equals(tarRechazo.getFechaInicio().toString().substring(0, 19)) ){
									dto.setResolucionDesc(tarRechazo.getDescripcionTarea());
								}
							}
									
						}
						
						
					}
					
					listadoProrrogas.add(dto);
				}
			}		
		}	

		return listadoProrrogas;
	}
	
	 @SuppressWarnings("unchecked")
	protected Map<String, String> getInfoAdicionalTraza(MEJInfoRegistro infoRegistro) {
		 
	     if (infoRegistro == null) 
	    	 return null;  
	     
	     Map<String, String> info = new HashMap<String, String>();
	     
	     try {
	    	 info = (Map<String, String>) executor.execute(MEJ_BO_GETMAPA_REGISTRO, infoRegistro.getRegistro().getId());
	     } catch (Exception e) {
				return null;
	     }
	     
	     return info;
	 }
		 
	 protected MEJInfoRegistro getTrazaRespuestaProrroga(Long idTarea) {
		    Filter fr1 = genericDao.createFilter(FilterType.EQUALS, "clave", "tarId");
		    Filter fr2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTarea.toString());
		    MEJInfoRegistro infoRegistroRespuesta = new MEJInfoRegistro();
		    try{
		    	infoRegistroRespuesta = genericDao.get(MEJInfoRegistro.class, fr1, fr2);
		    } catch (Exception e) {
				return null;
		    }    
		    return infoRegistroRespuesta;
	}

	 protected List<TareaNotificacion> ordenaTareasFechaCrear(List<TareaNotificacion> list) {
			if (!Checks.estaVacio(list)) {
				Collections.sort(list, new Comparator<TareaNotificacion>() {

					@Override
					public int compare(TareaNotificacion o1, TareaNotificacion o2) {
						if ((o1 == null) && (o2 == null))
							return 0;
						else if ((o1 == null) && (o2 != null))
							return 1;
						else if ((o1 != null) && (o2 == null))
							return -1;
						else {
							Date f1 = o1.getFechaInicio();
							Date f2 = o2.getFechaInicio();
							if ((f1 == null) && (f2 == null))
								return 0;
							else if ((f1 == null) && (f2 != null))
								return 1;
							else if ((f1 != null) && (f2 == null))
								return -1;
							else {
								return f1.compareTo(f2);
							}
						}
					}
				});
			}
			return list;
	}
	 
	 private String getInfoValue(Map<String, String> info, String infoKey, String defaultValue) {
	     if (Checks.estaVacio(info)) {
	    	 return defaultValue;
	     } else {
	         String v = info.get(infoKey);
	         return Checks.esNulo(v) ? defaultValue : v;
	     }
	 }
	 

		/**
		 * Obtiene las decisiones de paralizacion/finalizacion relacionadas de un asunto.
		 * 
		 * @param idAsunto
		 *            long
		 * @return lista de prorrogas
		 */
		@SuppressWarnings("unchecked")
		@BusinessOperation(GET_DECISIONES_ASUNTO_REPORT)
		public List<DecisionProcedimiento> obtenerDecisionesAsunto(Long idAsunto) {
			
			List<DecisionProcedimiento> listadoSolicitudes = new ArrayList<DecisionProcedimiento>();
			
			List<Procedimiento> listProc = proxyFactory.proxy(AsuntoApi.class).obtenerActuacionesAsunto(idAsunto);

			for (Procedimiento proc : listProc){
				List<DecisionProcedimiento> decisionesProc = (List<DecisionProcedimiento>) executor.execute(ExternaBusinessOperation.BO_DEC_PRC_MGR_GET_LIST, proc.getId());
				
				if (Checks.esNulo(decisionesProc)){ 
					continue;
				}
				for (DecisionProcedimiento dec : decisionesProc){
					if (!dec.getFinalizada() && !dec.getParalizada()) {
						continue;
					}
					listadoSolicitudes.add(dec);
				}
				
				
				
				/*
						
						// Solo a�adimos las decisiones de tipo paralizacion o finalizacion
						if (dec.getFinalizada() || dec.getParalizada()){
							
							DtoReportDecision dto = new DtoReportDecision(dec);
							
							//String actuacion = proc.getTipoProcedimiento().getDescripcion() + " (" + proc.getId().toString() + ")";
							//dto.setActuacion(actuacion);
							
							if (dec.getParalizada() && !Checks.esNulo(dec.getFechaParalizacion()) &&  dec.getFechaParalizacion().toString().length() >= 10){
								dto.setTipo("Paralizar");
								dto.setFecha(formatter.format(dec.getFechaParalizacion()));
							} else {
								dto.setTipo("Finalizar");
								dto.setFecha("");
							}
								
							//if (!Checks.esNulo(dec.getCausaDecision()) && !Checks.esNulo(dec.getCausaDecision().getDescripcion()))
							//	dto.setCausa(dec.getCausaDecision().getDescripcion());
							//else
							//	dto.setCausa("");
							
							//dto.setComentarios(dec.getComentarios());
							
							//if (!Checks.esNulo(dec.getEstadoDecision()) && !Checks.esNulo(dec.getEstadoDecision().getDescripcion()))
							//	dto.setEstado(dec.getEstadoDecision().getDescripcion());
							//else
							//	dto.setEstado("");
							
							listadoSolicitudes.add(dto);
						}
					} 
				}*/
				
			}
			
			return listadoSolicitudes;
			
		}

		/**
		 * Devuelve el listado de litigios asociados (asuntos de la misma persona)
		 * @param idAsunto
		 * @return
		 */
		@BusinessOperation(GET_LITIGIOS_ASOCIADOS_ASUNTO_REPORT)
		public List<DtoReportAsunto> obtenerLitigiosAsociados(Long idAsunto) {
			
			List<DtoReportAsunto> listado = new ArrayList<DtoReportAsunto>();
			
			//Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
			//String nombreAsunto = asunto.getNombre();
			//Integer index = nombreAsunto.indexOf(")");
			//String nombre = nombreAsunto.substring(index + 2);

			//MEJBuscarClientesDto dtoBuscarCliente = new MEJBuscarClientesDto();
			//dtoBuscarCliente.setNombre(nombre);
			//List<Persona> listClientes = proxyFactory.proxy(MEJClienteApi.class).findClientesExcel(dtoBuscarCliente);
			
			//if (listClientes != null && listClientes.size() >0){
			Set<Long> idsAsuntosBag = new HashSet<Long>(); 
			List<Persona> listPersonas = asuntoDao.obtenerPersonasDeUnAsunto(idAsunto);
			for (Persona persona : listPersonas) {
				
				List<Asunto> listAsuntos = asuntoDao.obtenerAsuntosDeUnaPersona(persona.getId());
			
				for (Asunto asu : listAsuntos){

					if (idsAsuntosBag.contains(asu.getId()) || !(asu instanceof EXTAsunto)) {
						continue;
					}
					
					EXTAsunto extAsunto = (EXTAsunto)asu;
					idsAsuntosBag.add(asu.getId());
					
					//UGASGestoresAsuntoFacade gestores = proxyFactory.proxy(UGASAsuntoApi.class).getGestoresAsuntoLitigios(asu.getId());
					DtoReportAsunto dto = new DtoReportAsunto(extAsunto);
					
					List<Contrato> contratos = new ArrayList<Contrato>();
					contratos.addAll(extAsunto.getContratos());
									
					List<Procedimiento> actuaciones = proxyFactory.proxy(AsuntoApi.class).obtenerActuacionesAsunto(asu.getId());
					StringBuffer actuacionActiva = new StringBuffer();
					StringBuffer tareaPendiente = new StringBuffer();
				
					for (Procedimiento proc : actuaciones){
						TareaNotificacion tarPendiente = isProcedimientoActivo(proc.getId());
						if(tarPendiente != null){
							if(actuacionActiva.length() != 0) {
								actuacionActiva.append(", ");
							}
							if(tareaPendiente.length() != 0) {
								tareaPendiente.append(", ");
							}
							actuacionActiva.append(proc.getTipoProcedimiento().getDescripcion());
						
							if(tarPendiente.getId() != null){
								tareaPendiente.append(tarPendiente.getDescripcionTarea());
							}
						}
					}
					
					dto.setActuacionVigente(actuacionActiva.toString());
					dto.setTareaPendiente(tareaPendiente.toString());
					
					listado.add(dto);
				}
			}
			
			return listado;
		}

		
		/**
		 * 
		 * @param idProcedimiento
		 * @return Devuelve la tarea pendiente del procedimiento en caso de que el procedimient sea activo.
		 * En caso de que el procedimiento est� paralizado devuelve una tarea vacia, quiere decir que el procedimiento esta activo
		 * pero no hay ninguna tarea pendiente en ese momento por estar paralizado.
		 * Si el procedimiento no es activo devuelve null.
		 */
		private TareaNotificacion isProcedimientoActivo(Long idProcedimiento) {
			
			TareaNotificacion tarResultado = new TareaNotificacion();
			
			Boolean isActivo = false;
			MEJProcedimiento procedimiento = (MEJProcedimiento) proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);

			if (!Checks.esNulo(procedimiento)) {
				if (procedimiento.getEstadoProcedimiento().getCodigo().equals(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO)
					|| (procedimiento.getDerivacionAceptada() 
						&& !procedimiento.getEstadoProcedimiento().getCodigo().equals(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO)
								&& !procedimiento.getEstadoProcedimiento().getCodigo().equals(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO))) {
					Set<TareaNotificacion> tareasProc = procedimiento.getTareas();

					Boolean texPendientes = false;
					for (TareaNotificacion tar : tareasProc) {
						TareaExterna tarExterna = tar.getTareaExterna();
						if (!Checks.esNulo(tarExterna)) {
							if (tarExterna.getAuditoria() != null && !tarExterna.getAuditoria().isBorrado()) {
								texPendientes = true;
								tarResultado = tar;
							}
						}
					}
					if (texPendientes) {
						isActivo = true;
					} else {
						// Si el procedimiento no tiene ninguna tarea externa
						// pendiente comprobamos
						// si tiene decisiones pendientes de las que no tienen tarea
						// externa
						Boolean tarPendiente = false;
						for (TareaNotificacion tar : tareasProc) {
							if (tar.getSubtipoTarea() != null
									&& tar.getSubtipoTarea().getCodigoSubtarea() != null
									&& (tar.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_GESTOR )
											|| tar.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_SUPERVISOR)
											|| tar.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_TOMA_DECISION_BPM)
											|| tar.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO)
											|| tar.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_ACUERDO_PROPUESTO)
											|| tar.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC)
											|| tar.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO)
											|| tar.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_TAREA_PROPUESTA_CUMPLIMIENTO_OBJETIVO)
											|| tar.getSubtipoTarea().getCodigoSubtarea().equals(EXTSubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_SEG)
											|| tar.getSubtipoTarea().getCodigoSubtarea().equals(EXTSubtipoTarea.CODIGO_TAREA_PRORROGA_TOMA_DECISION)
											|| tar.getSubtipoTarea().getCodigoSubtarea().equals(EXTSubtipoTarea.CODIGO_TAREA_GESTOR_CONFECCION_EXPTE)
											|| tar.getSubtipoTarea().getCodigoSubtarea().equals(EXTSubtipoTarea.CODIGO_TAREA_SUPERVISOR_CONFECCION_EXPTE)
											|| tar.getSubtipoTarea().getCodigoSubtarea().equals(EXTSubtipoTarea.CODIGO_TAREA_GESTOR_ADMINISTRATIVO) || tar.getSubtipoTarea().getCodigoSubtarea()
											.equals(EXTSubtipoTarea.CODIGO_TAREA_RESPONSABLE_CONCURSAL))) {
								
								if (Checks.esNulo(tar.getTareaFinalizada()) || (!Checks.esNulo(tar.getTareaFinalizada()) && !tar.getTareaFinalizada())){
									tarPendiente = true;
									tarResultado = tar;
								}
						
							}
						}
						if (tarPendiente) {
							isActivo = true;
						}
					}
					if (procedimiento.isEstaParalizado()) {
						isActivo = true;
					}

				}
			}
			if (isActivo)
				return tarResultado;
			else
				return null;

		}

		/**
		 * Obtiene la informaci�n de las tareas del T. demandado en incidente
		 * 
		 * @param idAsunto
		 *            long
		 * @return dto con la informaci�n de las tareas
		@Override
		@BusinessOperation(GET_DEMANDAS_RESCISORIAS_REPORT)
		public List<String> obtenerDemandasRescisorias(Long idAsunto) {
			List<DtoDemandas> demandas = new ArrayList<DtoDemandas>();
			//List<Procedimiento> actuaciones = proxyFactory.proxy(AsuntoApi.class).obtenerActuacionesAsunto(idAsunto);
			StringBuffer condenaEconomica = new StringBuffer();
			StringBuffer garantia = new StringBuffer();
			DecimalFormat monedaDecimalFormat = new DecimalFormat(FormatUtils.FORMATO_MONEDA + " " + FormatUtils.EURO);
			Double importeCostas = new Double(0);
			
			for (Procedimiento proc : listProc){
				if (proc.getTipoProcedimiento().getCodigo().equals(UGASConstantes.ID_TIPO_PROCEDIMIENTO_DEMANDADO_EN_INCIDENTE)){
					
					condenaEconomica = new StringBuffer();
					garantia = new StringBuffer();
					
					DtoDemandas dto = new DtoDemandas();
					dto.setPrincipalDemanda(proc.getSaldoRecuperacion().toString());
					
					List<TareaNotificacion> tareasProc = proxyFactory.proxy(TareaNotificacionApi.class).
							getListByProcedimientoSubtipo(proc.getId(), SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR);
					
					if (!Checks.esNulo(tareasProc)){
						for (TareaNotificacion tar: tareasProc){
							if(!Checks.esNulo(tar.getTareaExterna()) && tar.getTareaFinalizada() != null && tar.getTareaFinalizada()){
								
								TareaExterna tex = tar.getTareaExterna();
								List<TareaExternaValor> listTexValor = new ArrayList<TareaExternaValor>();
								
								if (tex.getTareaProcedimiento().getDescripcion().equals(UGASConstantes.TAREA_NOTIF_DEMANDA_INCIDENTAL)){
									
									listTexValor = texValorDao.getByTareaExterna(tex.getId());
									for (TareaExternaValor texValor : listTexValor){							
										if(texValor.getNombre().equals("tipoReclamacion")){
											if (!Checks.esNulo(texValor.getValor())){
												dto.setTipoReclamacion(getTipoReclamacionDesc(texValor.getValor()));
											}
										}
									}
								} else if (tex.getTareaProcedimiento().getDescripcion().equals(UGASConstantes.TAREA_REGISTRAR_OPOSICION)
										|| tex.getTareaProcedimiento().getDescripcion().equals(UGASConstantes.TAREA_REGISTRAR_ALLANAMIENTO)){
									
									listTexValor = texValorDao.getByTareaExterna(tex.getId());
									for (TareaExternaValor texValor : listTexValor){							
										if(texValor.getNombre().equals("observaciones")){
											if (!Checks.esNulo(texValor.getValor())){
												dto.setInstrucciones(texValor.getValor());
											}
										}
									}
								} else if (tex.getTareaProcedimiento().getDescripcion().equals(UGASConstantes.TAREA_REGISTRAR_RESOLUCION)){
									
									listTexValor = texValorDao.getByTareaExterna(tex.getId());
									for (TareaExternaValor texValor : listTexValor){							
										if(texValor.getNombre().equals("condena")){
											if (!Checks.esNulo(texValor.getValor())){
												if (texValor.getValor().equals("01"))
													condenaEconomica.append("S�");
												else
													condenaEconomica.append("No");
											}
										} else if(texValor.getNombre().equals("importeCondena")){
											if (!Checks.esNulo(texValor.getValor())){
												condenaEconomica.append(": ");
												condenaEconomica.append(monedaDecimalFormat.format(new Double(texValor.getValor())));
											}
										} else if(texValor.getNombre().equals("garantia")){
											if (!Checks.esNulo(texValor.getValor())){
												if (texValor.getValor().equals("01"))
													garantia.append("S�");
												else
													garantia.append("No");
											}
										} else if(texValor.getNombre().equals("importeGarantia")){
											if (!Checks.esNulo(texValor.getValor())){
												garantia.append(": ");
												garantia.append(monedaDecimalFormat.format(new Double(texValor.getValor())));
											}
										} else if(texValor.getNombre().equals("recurso")){
											if (!Checks.esNulo(texValor.getValor())){
												if (texValor.getValor().equals("01"))
													dto.setRecurso("S�");
												else
													dto.setRecurso("No");
											}
										}
									}
									dto.setCondena(condenaEconomica.toString());
									dto.setGarantias(garantia.toString());
									
								} else if (tex.getTareaProcedimiento().getDescripcion().equals(UGASConstantes.TAREA_RESOLUCION_FIRME)){
									
									listTexValor = texValorDao.getByTareaExterna(tex.getId());
									for (TareaExternaValor texValor : listTexValor){							
										if(texValor.getNombre().equals("resultadoRecurso")){
											if (!Checks.esNulo(texValor.getValor())){
												if (texValor.getValor().equals("01"))
													dto.setResultado("Favorable");
												else if (texValor.getValor().equals("02"))
													dto.setResultado("No Favorable");
												else
													dto.setResultado("No Recurrida");
											}
										}
									}
								} else if (tex.getTareaProcedimiento().getDescripcion().equals(UGASConstantes.TAREA_REGISTRAR_IMPORTE_COSTAS)){
									
									listTexValor = texValorDao.getByTareaExterna(tex.getId());
									for (TareaExternaValor texValor : listTexValor){							
										if(texValor.getNombre().equals("importe1letrado")){
											if (!Checks.esNulo(texValor.getValor())){
												importeCostas = importeCostas + new Double(texValor.getValor());
											}
										} else if(texValor.getNombre().equals("importe1procurador")){
											if (!Checks.esNulo(texValor.getValor())){
												importeCostas = importeCostas + new Double(texValor.getValor());
											}
										} else if(texValor.getNombre().equals("importe2letrado")){
											if (!Checks.esNulo(texValor.getValor())){
												importeCostas = importeCostas + new Double(texValor.getValor());
											}
										} else if(texValor.getNombre().equals("importe2procurador")){
											if (!Checks.esNulo(texValor.getValor())){
												importeCostas = importeCostas + new Double(texValor.getValor());
											}
										}
									}
									
									dto.setCostas(monedaDecimalFormat.format(importeCostas));
								} 
							}	
							
						}
					}
					
					demandas.add(dto);
					
				}
			}

			return demandas;
		}
		 */
		

		/**
		 * Obtiene las observaciones de los procedimientos del asunto
		 * 
		 * @param idAsunto
		 *            long
		 * @return lista de cobros/pagos
		 */
		@BusinessOperation(GET_OBSERVACIONES_PROCEDIMIENTO_REPORT)
		public List<TareaExternaValor> obtenerObservacionesProcedimiento(Long idAsunto) {
			
			List<TareaExternaValor> observacionesProcedimiento = new ArrayList<TareaExternaValor>();
						
			List<TareaNotificacion> tareasProc = tareaNotificacionDao.getListByAsunto(idAsunto);

			List<TareaNotificacion> tareasProcFinalizadas = new ArrayList<TareaNotificacion>();
			for (TareaNotificacion tar : tareasProc){
				if (tar.getTareaFinalizada() != null && tar.getTareaFinalizada() && !Checks.esNulo(tar.getFechaFin())){
					tareasProcFinalizadas.add(tar);
				}
			}
			
			List<TareaNotificacion> tareasProcFinalizadasOrdenadas = ordenaTareasFinalizadas(tareasProcFinalizadas);
			
			for (TareaNotificacion tarOrdenada : tareasProcFinalizadasOrdenadas){
				
				TareaExterna tex = tarOrdenada.getTareaExterna();
					
				if (!Checks.esNulo(tex)){
				List<TareaExternaValor> listTexValor = texValorDao.getByTareaExterna(tex.getId());
					for (TareaExternaValor texValor : listTexValor){							
						if(texValor.getNombre().equals("observaciones")){
							if (!Checks.esNulo(texValor.getValor())){
								/*dto.setActuacion(proc.getTipoProcedimiento().getDescripcion());
								dto.setDescTarea(tarOrdenada.getTarea());
								dto.setObservacionesTarea(texValor.getValor());
								if (!Checks.esNulo(tarOrdenada.getFechaFin())){
									dto.setFechaTarea(tarOrdenada.getFechaFin()));
								}
								*/
								observacionesProcedimiento.add(texValor);
							}
						}
					}
				}
			}

			
			return observacionesProcedimiento;
			
		}

		private List<TareaNotificacion> ordenaTareasFinalizadas(List<TareaNotificacion> list) {
			if (!Checks.estaVacio(list)) {
				Collections.sort(list, new Comparator<TareaNotificacion>() {

					@Override
					public int compare(TareaNotificacion o1, TareaNotificacion o2) {
						if ((o1 == null) && (o2 == null))
							return 0;
						else if ((o1 == null) && (o2 != null))
							return 1;
						else if ((o1 != null) && (o2 == null))
							return -1;
						else {
							Date f1 = o1.getFechaFin();
							Date f2 = o2.getFechaFin();
							if ((f1 == null) && (f2 == null))
								return 0;
							else if ((f1 == null) && (f2 != null))
								return 1;
							else if ((f1 != null) && (f2 == null))
								return -1;
							else {
								return f1.compareTo(f2);
							}
						}
					}
				});
			}
			return list;
		}
		
}
