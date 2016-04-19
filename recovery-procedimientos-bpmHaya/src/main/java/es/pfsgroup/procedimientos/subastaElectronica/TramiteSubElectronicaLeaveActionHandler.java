package es.pfsgroup.procedimientos.subastaElectronica;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class TramiteSubElectronicaLeaveActionHandler extends PROGenericLeaveActionHandler {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;

	private final String SALIDA_ETIQUETA = "DecisionRama_%d";
	private final String SALIDA_SI = "si";
	private final String SALIDA_NO = "no";
	private final String CODIGO_STA_LETRADO = "814";

	@Autowired
	private Executor executor;

	@Autowired
	protected GenericABMDao genericDao;

	@Autowired
	private JBPMProcessManager jbpmUtil;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private UsuarioApi usuarioApi;

	@Autowired
	TramitesElectronicosApi tramitesElectronicos;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass,
			ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);

		personalizamosTramiteSubastaElectronica(executionContext);
	}

	private void personalizamosTramiteSubastaElectronica(ExecutionContext executionContext) {

		if (executionContext.getNode().getName().contains("RevisarDocumentacion")) {
			estableceContexto(executionContext);
		} else if (executionContext.getNode().getName().contains("DictarInstruccionesSubastaYPagoTasa")) {
			estableceNotificacion(executionContext);
		} else if (executionContext.getNode().getName().contains("RegistrarResultadoSubasta")) {
			personalizamosRegResSubasta(executionContext);
		} else if (executionContext.getNode().getName().contains("RegResulPresentacionEscrJuzgado")) {
			personalizamosRegResEscJuzgado(executionContext);
		}

	}

	/**
	 * Realiza la lógica principal de la clase.
	 * 
	 * @param executionContext
	 */
	private void estableceContexto(ExecutionContext executionContext) {
		Boolean[] valoresRamas = getValoresRamas(executionContext);
		for (int i = 0; i < valoresRamas.length; i++) {
			String variableName = String.format(SALIDA_ETIQUETA, i + 1);
			String valor = (valoresRamas[i]) ? SALIDA_SI : SALIDA_NO;
			executionContext.setVariable(variableName, valor);
		}
	}

	private void estableceNotificacion(ExecutionContext executionContext) {
		Procedimiento prc = getProcedimiento(executionContext);
		String nombreTarea = executionContext.getNode().getName();
		crearNotificacionManual(prc, nombreTarea,
				"Se han dictado instrucciones y la autorización para proceder al pago de la tasa", CODIGO_STA_LETRADO);
	}

	private void crearNotificacionManual(Procedimiento prc, String nombreTarea, String descripcion,
			String codigoGestor) {

		EXTTareaNotificacion notificacion = new EXTTareaNotificacion();
		notificacion.setProcedimiento(prc);
		notificacion.setAsunto(prc.getAsunto());
		notificacion.setEstadoItinerario(genericDao.get(DDEstadoItinerario.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoItinerario.ESTADO_ASUNTO)));

		SubtipoTarea subtipoTarea = genericDao.get(SubtipoTarea.class,
				genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", codigoGestor));

		if (subtipoTarea == null) {
			throw new GenericRollbackException("tareaNotificacion.subtipoTareaInexistente", codigoGestor);
		}

		notificacion.setEspera(Boolean.FALSE);
		notificacion.setAlerta(Boolean.FALSE);
		notificacion.setTarea(descripcion);
		notificacion.setDescripcionTarea(descripcion);
		notificacion.setCodigoTarea(subtipoTarea.getTipoTarea().getCodigoTarea());
		notificacion.setSubtipoTarea(subtipoTarea);

		DDTipoEntidad tipoEntidad = (DDTipoEntidad) diccionarioApi.dameValorDiccionarioByCod(DDTipoEntidad.class,
				DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);

		notificacion.setTipoEntidad(tipoEntidad);

		Date ahora = new Date(System.currentTimeMillis());

		notificacion.setFechaInicio(ahora);
		notificacion.setFechaVenc(ahora);
		notificacion.setFechaVencReal(ahora);
		notificacion.setFechaFin(ahora);
		notificacion.setTareaFinalizada(true);
		notificacion.setEmisor(usuarioApi.getUsuarioLogado().getApellidoNombre());

		Auditoria audit = new Auditoria();
		audit.setUsuarioCrear(usuarioApi.getUsuarioLogado().getApellidoNombre());
		audit.setFechaCrear(ahora);
		audit.setFechaBorrar(ahora);
		audit.setUsuarioBorrar(usuarioApi.getUsuarioLogado().getApellidoNombre());
		audit.setBorrado(true);

		notificacion.setAuditoria(audit);
		notificacion = genericDao.save(EXTTareaNotificacion.class, notificacion);

		TareaExterna tex = new TareaExterna();
		tex.setAuditoria(audit);
		tex.setTareaPadre(notificacion);

		if (!Checks.esNulo(nombreTarea)) {
			tex.setTareaProcedimiento(genericDao.get(TareaProcedimiento.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", nombreTarea)));
		} else {
			tex.setTareaProcedimiento(genericDao.get(TareaProcedimiento.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", "P458_DictarInstruccionesSubastaYPagoTasa")));
		}

		tex.setDetenida(false);

		genericDao.save(TareaExterna.class, tex);

	}

	/**
	 * Este método consultará todos los datos para determinar que
	 * caracteristicas tiene, y así devolver la rama correspondiente A, B, C
	 * 
	 * @return Array con los valores para decidir, uno por cada Rama en orden
	 *         0-Primera rama, 1-Segunda rama,...
	 */
	protected Boolean[] getValoresRamas(ExecutionContext executionContext) {
		Procedimiento proc = getProcedimiento(executionContext);

		Boolean[] valores = (Boolean[]) tramitesElectronicos.bpmGetValoresRamasRevisarDocumentacion(proc,
				getTareaExterna(executionContext));

		return valores;
	}

	private void personalizamosRegResSubasta(ExecutionContext executionContext) {

		Procedimiento prc = getProcedimiento(executionContext);
		Subasta sub = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(prc.getId());

		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory
				.proxy(SubastaProcedimientoApi.class)).obtenerValoresTareaByTexId(tex.getId());

		Boolean comboPostores = false;
		Boolean comboSubastaBienes = false;

		if (!Checks.esNulo(listado)) {
			for (TareaExternaValor tev : listado) {
				if ("comboPostores".equals(tev.getNombre())) {
					comboPostores = new Boolean(tev.getValor());
				}
				else if ("comboSubastaBienes".equals(tev.getNombre())) {
					comboSubastaBienes = new Boolean(tev.getValor());
				}
			}
		}

		
		modificarYCrearDesdeSubasta(sub, comboSubastaBienes, comboPostores);
		
//		// primer paso
//		// comprobamos valor postores en la tarea
//		if (comboSubastaBienes) {
//			if (comboPostores) {
//				// Decision SI y SI
//				modificarYCrearBienesDeLaSubasta(sub, comboSubastaBienes, comboPostores);
//			} else {
//				// Decision SI y NO
//				modificarYCrearBienesDeLaSubasta(sub, comboSubastaBienes, comboPostores);
//			}
//		}
//		// Decision NO
//		else {
//			// SEGUNDO PASO
//			// No hacemos nada
//			modificarYCrearBienesDeLaSubasta(sub, null, null);
//		}

	}
	
	private void personalizamosRegResEscJuzgado(ExecutionContext executionContext) {

		Procedimiento prc = getProcedimiento(executionContext);
		Subasta sub = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(prc.getId());

		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory
				.proxy(SubastaProcedimientoApi.class)).obtenerValoresTareaByTexId(tex.getId());

		Boolean comboCoincidencia = false;
		Boolean comboAdjudicacion = false;

		if (!Checks.esNulo(listado)) {
			for (TareaExternaValor tev : listado) {
				if ("comboCoincidencia".equals(tev.getNombre())) {
					comboCoincidencia = new Boolean(tev.getValor());
				}
				else if ("comboAdjudicacion".equals(tev.getNombre())) {
					comboAdjudicacion = new Boolean(tev.getValor());
				}
			}
		}
		
		modificarYCrearDesdeEscJuzgado(sub, comboCoincidencia, comboAdjudicacion);

	}

	private void modificarYCrearDesdeSubasta(Subasta sub, Boolean coincidencia, Boolean comboPostores) {

		if (!Checks.esNulo(sub)) {
			List<LoteSubasta> listado = sub.getLotesSubasta();
			if (!Checks.estaVacio(listado)) {
				for (LoteSubasta ls : listado) {
					List<Bien> bienes = ls.getBienes();
					if (!Checks.estaVacio(bienes)) {
						for (Bien b : bienes) {
							if (b instanceof NMBBien) {
								NMBBien bi = (NMBBien) b;
								if (bi.getAdjudicacion() != null) {
									if (coincidencia) {
										NMBAdjudicacionBien adju = bi.getAdjudicacion();
										adju.setPostores(comboPostores);
										genericDao.save(NMBAdjudicacionBien.class, adju);
										if (comboPostores) {
											creaProcedimientoAdjudicacion(sub.getProcedimiento(), bi);
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
	
	private void modificarYCrearDesdeEscJuzgado(Subasta sub, Boolean coincidencia, Boolean comboAdjudicacion) {

		if (!Checks.esNulo(sub)) {
			List<LoteSubasta> listado = sub.getLotesSubasta();
			if (!Checks.estaVacio(listado)) {
				for (LoteSubasta ls : listado) {
					List<Bien> bienes = ls.getBienes();
					if (!Checks.estaVacio(bienes)) {
						for (Bien b : bienes) {
							if (b instanceof NMBBien) {
								NMBBien bi = (NMBBien) b;
								if (bi.getAdjudicacion() != null) {
									if (coincidencia) {
										NMBAdjudicacionBien adju = bi.getAdjudicacion();
										adju.setCesionRemate(comboAdjudicacion);
										genericDao.save(NMBAdjudicacionBien.class, adju);
										if (comboAdjudicacion) {
											creaProcedimientoAdjudicacion(sub.getProcedimiento(), bi);
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

	private void creaProcedimientoAdjudicacion(Procedimiento procPadre, NMBBien b) {
		MEJProcedimiento procHijo = new MEJProcedimiento();

		procHijo.setAuditoria(Auditoria.getNewInstance());
		procHijo.setProcedimientoPadre(procPadre);
		procHijo.setPlazoRecuperacion(procPadre.getPlazoRecuperacion());
		procHijo.setSaldoRecuperacion(procPadre.getSaldoRecuperacion());
		procHijo.setPorcentajeRecuperacion(procPadre.getPorcentajeRecuperacion());
		procHijo.setJuzgado(procPadre.getJuzgado());
		procHijo.setCodigoProcedimientoEnJuzgado(procPadre.getCodigoProcedimientoEnJuzgado());
		procHijo.setObservacionesRecopilacion(procPadre.getObservacionesRecopilacion());
		procHijo.setSaldoOriginalNoVencido(procPadre.getSaldoOriginalNoVencido());
		procHijo.setSaldoOriginalVencido(procPadre.getSaldoOriginalVencido());
		procHijo.setAsunto(procPadre.getAsunto());
		procHijo.setExpedienteContratos(procPadre.getExpedienteContratos());
		procHijo.setDecidido(procPadre.getDecidido());
		procHijo.setFechaRecopilacion(procPadre.getFechaRecopilacion());

		// seteo el procedimiento como 'derivado'
		DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(
				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoProcedimiento.class,
				DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO);
		procHijo.setEstadoProcedimiento(estadoProcedimiento);

		// seteo el tipo de actuación
		DDTipoActuacion tipoActuacion = genericDao.get(DDTipoActuacion.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", procPadre.getTipoActuacion().getCodigo()));
		procHijo.setTipoActuacion(tipoActuacion);

		// seteo el tipo de prodecimiento adjudicación
		TipoProcedimiento tipoProcedimiento = genericDao.get(TipoProcedimiento.class, genericDao.createFilter(
				FilterType.EQUALS, "codigo", determinarTipoProcedimientoAdjudicacion(b.getAdjudicacion())));
		procHijo.setTipoProcedimiento(tipoProcedimiento);

		// seteo el tipo de reclamación heredado del padre
		DDTipoReclamacion tipoReclamacion = genericDao.get(DDTipoReclamacion.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", procPadre.getTipoReclamacion().getCodigo()));
		procHijo.setTipoReclamacion(tipoReclamacion);

		// Agrego las personas al procedimiento
		List<Persona> personas = new ArrayList<Persona>();
		for (Persona p : procPadre.getPersonasAfectadas()) {

			personas.add(genericDao.get(Persona.class, genericDao.createFilter(FilterType.EQUALS, "id", p.getId())));
		}
		procHijo.setPersonasAfectadas(personas);

		// Agrego el bien al procedimiento
		List<ProcedimientoBien> procedimientosBien = new ArrayList<ProcedimientoBien>();

		ProcedimientoBien prcBien = genericDao.get(ProcedimientoBien.class,
				genericDao.createFilter(FilterType.EQUALS, "bien.id", b.getId()),
				genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", procPadre.getId()));

		ProcedimientoBien procBienCopiado = new ProcedimientoBien();
		procBienCopiado.setBien(b);
		procBienCopiado.setProcedimiento(procHijo);
		procBienCopiado.setSolvenciaGarantia(prcBien.getSolvenciaGarantia());
		genericDao.save(ProcedimientoBien.class, procBienCopiado);

		procedimientosBien.add(procBienCopiado);
		procHijo.setBienes(procedimientosBien);

		executor.execute(ExternaBusinessOperation.BO_PRC_MGR_SAVE_OR_UPDATE_PROCEDIMIMENTO, procHijo);

		// Lanzar los JBPM para cada procedimiento
		String nombreJBPM = procHijo.getTipoProcedimiento().getXmlJbpm();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put(BPMContants.PROCEDIMIENTO_TAREA_EXTERNA, procHijo.getId());
		Long idBPM = jbpmUtil.crearNewProcess(nombreJBPM, param);

		procHijo.setProcessBPM(idBPM);
		executor.execute(ExternaBusinessOperation.BO_PRC_MGR_SAVE_OR_UPDATE_PROCEDIMIMENTO, procHijo);

		// FIXME
		// crearNotificacionManualAdjudicacion(procPadre);

	}

	private String determinarTipoProcedimientoAdjudicacion(NMBAdjudicacionBien adjudicacion) {

		if (adjudicacion != null) {
			if (adjudicacion.getEntidadAdjudicataria() != null) {
				if ("ENT".equals(adjudicacion.getEntidadAdjudicataria().getCodigo())) {
					return "P413";
				} else if ("TER".equals(adjudicacion.getEntidadAdjudicataria().getCodigo())) {
					return "P413";
				}
			} else if (adjudicacion.getCesionRemate()) {
				return "P413";
			}
		}

		// FIXME No puede no devolver un resultado
		return null;
	}

}
