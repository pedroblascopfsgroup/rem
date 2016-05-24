package es.pfsgroup.procedimientos.subasta;

import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoComite;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

public class SubastaV4LeaveActionHandler extends PROGenericLeaveActionHandler {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6476140372822561349L;

	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private Executor executor;

	@Autowired
	private JBPMProcessManager jbpmUtil;

    @Autowired
    private SubastaCalculoManager subastaCalculoManager;

    @Autowired
    private SubastaProcedimientoApi subastaProcedimientoApi;
	
    @Autowired
    private IntegracionBpmService bpmIntegracionService;
    
	private ExecutionContext executionContext;

	private final String SALIDA_ETIQUETA = "DecisionRama_%d";
	private final String SALIDA_SI = "si";
	private final String SALIDA_NO = "no";

	private final String TAP_SOLICITUD_SUBASTA = "P401_SolicitudSubasta";
	private final String TAP_SENYALAMIENTO_SUBASTA = "P401_SenyalamientoSubasta";
	private final String TAP_SOLICITUD_SUBASTA_SAREB = "P409_SolicitudSubasta";
	private final String TAP_SENYALAMIENTO_SUBASTA_SAREB = "P409_SenyalamientoSubasta";
	
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		this.executionContext = executionContext;

		String transition = executionContext.getTransition().getName();
		Boolean transicionTemporal = (
				transition.equals(BPMContants.TRANSICION_PRORROGA) || 
				transition.equals(BPMContants.TRANSICION_FIN) || 
				transition.equals(BPMContants.TRANSICION_APLAZAR_TAREAS) || 
				transition.equals(BPMContants.TRANSICION_PARALIZAR_TAREAS) || 
				transition.equals(BPMContants.TRANSICION_ACTIVAR_TAREAS));
		if (transicionTemporal) {
			return;
		}
		
		Procedimiento procedimiento = getProcedimiento(executionContext);
		TareaExterna tareaExterna = getTareaExterna(executionContext);

		if (tareaExterna!=null &&
				tareaExterna.getTareaProcedimiento() != null && 
				(
				TAP_SOLICITUD_SUBASTA.equals(tareaExterna.getTareaProcedimiento().getCodigo()) ||
				TAP_SOLICITUD_SUBASTA_SAREB.equals(tareaExterna.getTareaProcedimiento().getCodigo()) || 
				TAP_SENYALAMIENTO_SUBASTA.equals(tareaExterna.getTareaProcedimiento().getCodigo()) ||
				TAP_SENYALAMIENTO_SUBASTA_SAREB.equals(tareaExterna.getTareaProcedimiento().getCodigo())
				)) {
			subastaCalculoManager.actualizarTipoSubasta(procedimiento);	
		}
		avanzamosEstadoSubasta();
			
	}

	@Transactional
	private void avanzamosEstadoSubasta() {

		// executionContext.getProcessDefinition().getName();
		// executionContext.getEventSource().getName();
		// executionContext.getNode().getName();

		Procedimiento prc = getProcedimiento(executionContext);
		Subasta sub = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(prc.getId());

		if (executionContext.getNode().getName().contains("SolicitudSubasta") || executionContext.getNode().getName().contains("SenyalamientoSubasta")) {
			//
			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.PIN);
				duplicaInfoSubasta(executionContext, sub);
				subastaProcedimientoApi.determinarTipoSubasta(sub);
			}
		} else if (executionContext.getNode().getName().contains("AdjuntarInformeSubasta")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.PPR);
			}
		} else if (executionContext.getNode().getName().contains("PrepararPropuestaSubasta")) {

			if (!Checks.esNulo(sub)) {
				cambiaEstadoSubasta(sub, DDEstadoSubasta.PCO);
				cambiaEstadoLotesSubasta(sub);
			}
		} else if (executionContext.getNode().getName().contains("ValidarPropuesta")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, obtenerEstadoSiguiente(executionContext, "ValidarPropuesta", "comboResultado"));
				cambiaEstadoValidarLotesSubasta(sub);
			}
		} else if (executionContext.getNode().getName().contains("LecturaAceptacionInstrucciones")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.PCE);
			}
		} else if (executionContext.getNode().getName().contains("CelebracionSubasta")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, obtenerEstadoSiguiente(executionContext, "CelebracionSubasta", "comboCelebracion"));
				estableceContexto();
			}
		}
		// else if
		// (executionContext.getNode().getName().contains("BPMTramiteAdjudicacionV4"))
		// {
		//
		// // Tenemos que crear un procedimiento adjudicación por cada uno de
		// // los bienes asociados a la subasta
		// if (!Checks.esNulo(sub)) {
		// List<LoteSubasta> listado = sub.getLotesSubasta();
		// if (!Checks.estaVacio(listado)) {
		// for (LoteSubasta ls : listado) {
		// List<Bien> bienes = ls.getBienes();
		// if (!Checks.estaVacio(bienes)) {
		// for (Bien b : bienes) {
		// creaProcedimientoAdjudicacion(prc, b);
		// }
		// }
		// }
		// }
		//
		// }
		//
		// }
		else if (executionContext.getNode().getName().contains("SuspenderSubasta")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.SUS);
			}

			// Finalizamos el procedimiento padre
			try {
				jbpmUtil.finalizarProcedimiento(prc.getId());
				prc.setEstadoProcedimiento(genericDao.get(DDEstadoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO)));
				genericDao.save(Procedimiento.class, prc);

			} catch (Exception e) {
				logger.error("avanzamosEstadoSubasta: " +e);
			}

			// FINALIZAMOS TODAS LAS TAREAS DEL PROCEDIMIENTO
			for (TareaNotificacion t : prc.getTareas()) {
				if (!t.getAuditoria().isBorrado()) {
					if (t.getTareaFinalizada() == null || (t.getTareaFinalizada() != null && !t.getTareaFinalizada())) {
						t.setTareaFinalizada(true);
						genericDao.update(TareaNotificacion.class, t);
						HibernateUtils.merge(t);
					}
				}
			}
		}

		genericDao.save(Subasta.class, sub);
		bpmIntegracionService.enviarDatos(sub);
	}

	private void cambiaEstadoSubasta(Subasta sub, String estado) {
		if (!Checks.esNulo(sub.getEstadoSubasta().getCodigo()) && DDEstadoSubasta.CEL.compareTo(sub.getEstadoSubasta().getCodigo()) != 0) {
			DDEstadoSubasta esu = genericDao.get(DDEstadoSubasta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estado), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			sub.setEstadoSubasta(esu);
		}
	}

	// private void creaProcedimientoAdjudicacion(Procedimiento procPadre, Bien
	// b) {
	// MEJProcedimiento procHijo = new MEJProcedimiento();
	//
	// procHijo.setAuditoria(Auditoria.getNewInstance());
	// procHijo.setProcedimientoPadre(procPadre);
	// procHijo.setPlazoRecuperacion(procPadre.getPlazoRecuperacion());
	// procHijo.setSaldoRecuperacion(procPadre.getSaldoRecuperacion());
	// procHijo.setPorcentajeRecuperacion(procPadre.getPorcentajeRecuperacion());
	// procHijo.setJuzgado(procPadre.getJuzgado());
	// procHijo.setCodigoProcedimientoEnJuzgado(procPadre.getCodigoProcedimientoEnJuzgado());
	// procHijo.setObservacionesRecopilacion(procPadre.getObservacionesRecopilacion());
	// procHijo.setSaldoOriginalNoVencido(procPadre.getSaldoOriginalNoVencido());
	// procHijo.setSaldoOriginalVencido(procPadre.getSaldoOriginalVencido());
	// procHijo.setAsunto(procPadre.getAsunto());
	// procHijo.setExpedienteContratos(procPadre.getExpedienteContratos());
	// procHijo.setDecidido(procPadre.getDecidido());
	// procHijo.setFechaRecopilacion(procPadre.getFechaRecopilacion());
	//
	// // seteo el procedimiento como 'derivado'
	// DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento)
	// executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
	// DDEstadoProcedimiento.class,
	// DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO);
	// procHijo.setEstadoProcedimiento(estadoProcedimiento);
	//
	// // seteo el tipo de actuación
	// DDTipoActuacion tipoActuacion = (DDTipoActuacion)
	// executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
	// DDTipoActuacion.class, procPadre.getTipoActuacion());
	// procHijo.setTipoActuacion(tipoActuacion);
	//
	// // seteo el tipo de prodecimiento adjudicación
	// TipoProcedimiento tipoProcedimiento =
	// genericDao.get(TipoProcedimiento.class,
	// genericDao.createFilter(FilterType.EQUALS, "codigo", "P413"));
	// procHijo.setTipoProcedimiento(tipoProcedimiento);
	//
	// // seteo el tipo de reclamación heredado del padre
	// DDTipoReclamacion tipoReclamacion = (DDTipoReclamacion)
	// executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
	// DDTipoReclamacion.class, procPadre.getTipoReclamacion());
	// procHijo.setTipoReclamacion(tipoReclamacion);
	//
	// // Agrego las personas al procedimiento
	// List<Persona> personas = new ArrayList<Persona>();
	// for (Persona p : procPadre.getPersonasAfectadas()) {
	//
	// personas.add(genericDao.get(Persona.class,
	// genericDao.createFilter(FilterType.EQUALS, "id", p.getId())));
	// }
	// procHijo.setPersonasAfectadas(personas);
	//
	// // Agrego el bien al procedimiento
	// List<ProcedimientoBien> procedimientosBien = new
	// ArrayList<ProcedimientoBien>();
	//
	// ProcedimientoBien prcBien = genericDao.get(ProcedimientoBien.class,
	// genericDao.createFilter(FilterType.EQUALS, "bien.id", b.getId()),
	// genericDao.createFilter(FilterType.EQUALS, "procedimiento.id",
	// procPadre.getId()));
	//
	// ProcedimientoBien procBienCopiado = new ProcedimientoBien();
	// procBienCopiado.setBien(b);
	// procBienCopiado.setProcedimiento(procHijo);
	// procBienCopiado.setSolvenciaGarantia(prcBien.getSolvenciaGarantia());
	// genericDao.save(ProcedimientoBien.class, procBienCopiado);
	//
	// procHijo.setBienes(procedimientosBien);
	//
	// executor.execute(ExternaBusinessOperation.BO_PRC_MGR_SAVE_OR_UPDATE_PROCEDIMIMENTO,
	// procHijo);
	//
	// }

	private String obtenerEstadoSiguiente(ExecutionContext executionContext, String tarea, String campo) {

		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory.proxy(SubastaProcedimientoApi.class)).obtenerValoresTareaByTexId(tex.getId());
		if (!Checks.esNulo(listado)) {
			if (tarea.contains("CelebracionSubasta")) {
				for (TareaExternaValor tev : listado) {
					if (DDSiNo.SI.equals(tev.getValor())) {
						return DDEstadoSubasta.CEL;
					} else if (DDSiNo.NO.equals(tev.getValor())) {
						return DDEstadoSubasta.SUS;
					}
				}
			}
			if (tarea.contains("ValidarPropuesta")) {
				for (TareaExternaValor tev : listado) {
					if (DDResultadoComite.ACEPTADA.equals(tev.getValor())) {
						return DDEstadoSubasta.PAC;
					} else if (DDResultadoComite.SUSPENDER.equals(tev.getValor())) {
						return DDEstadoSubasta.SUS;
					}
				}
				return DDEstadoSubasta.PPR;
			}
		}
		return null;

	}

	private void duplicaInfoSubasta(ExecutionContext executionContext, Subasta sub) {

		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory.proxy(SubastaProcedimientoApi.class)).obtenerValoresTareaByTexId(tex.getId());
		if (!Checks.esNulo(listado)) {
			for (TareaExternaValor tev : listado) {
				try {
					if ("fechaSolicitud".equals(tev.getNombre())) {
						sub.setFechaSolicitud(formatter.parse(tev.getValor()));
					}
					if ("fechaAnuncio".equals(tev.getNombre())) {
						sub.setFechaAnuncio(formatter.parse(tev.getValor()));
					}
					if ("fechaSenyalamiento".equals(tev.getNombre())) {
						sub.setFechaSenyalamiento(formatter.parse(tev.getValor()));
					}
					if ("costasLetrado".equals(tev.getNombre())) {
						sub.setCostasLetrado(Float.parseFloat(tev.getValor()));
					}
					if ("costasProcurador".equals(tev.getNombre())) {
						sub.setCostasProcurador(Float.parseFloat(tev.getValor()));
					}
				} catch (Exception e) {
					logger.error("duplicaInfoSubasta: "+e);
				}
			}

		}
	}

	/**
	 * Realiza la lógica principal de la clase.
	 * 
	 * @param executionContext
	 */
	private void estableceContexto() {
		Boolean[] valoresRamas = getValoresRamas();
		for (int i = 0; i < valoresRamas.length; i++) {
			String variableName = String.format(SALIDA_ETIQUETA, i + 1);
			String valor = (valoresRamas[i]) ? SALIDA_SI : SALIDA_NO;
			executionContext.setVariable(variableName, valor);
		}
	}

	/**
	 * Este método consultará todos los datos de los bienes para determinar que
	 * caracteristicas tiene, y así devolver la rama correspondiente A, B, CEH,
	 * DEFGH,...
	 * 
	 * @return Array con los valores para decidir, uno por cada Rama en orden
	 *         0-Primera rama, 1-Segunda rama,...
	 */
	protected Boolean[] getValoresRamas() {
		Procedimiento proc = getProcedimiento(executionContext);

		// Consulta los contratos.
		Boolean[] valores = (Boolean[]) executor.execute("es.pfsgroup.recovery.subasta.bpmGetValoresRamasCelebracion", proc, getTareaExterna(executionContext));
		return valores;
	}

	/**
	 * Cambia el estado de los lotes de la subasta de conformado a propuesta.
	 * @param subasta
	 */
	protected void cambiaEstadoLotesSubasta(Subasta subasta) {
		executor.execute("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.marcarLotesEstadoTrasPropuesta", subasta);
	}
	
	/**
	 * Cambia el estado de los lotes de la subasta de conformado a propuesta.
	 * @param subasta
	 */
	protected void cambiaEstadoValidarLotesSubasta(Subasta subasta) {
		TareaExterna tarea = getTareaExterna(executionContext);
		String nombreDecision = getNombreNodo(executionContext) + "Decision";
		String decision = (String)getVariable(nombreDecision, executionContext);
		executor.execute("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.marcarLotesEstadoTrasValidar", subasta, tarea, decision);
	}
	
}
