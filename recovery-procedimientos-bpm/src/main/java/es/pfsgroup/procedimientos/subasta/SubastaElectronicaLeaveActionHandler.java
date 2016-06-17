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
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoComite;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

public class SubastaElectronicaLeaveActionHandler extends PROGenericLeaveActionHandler {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	GenericABMDao genericDao;

    @Autowired
    private SubastaCalculoManager subastaCalculoManager;
	
    @Autowired
    private IntegracionBpmService bpmIntegracionService;
    
    @Autowired
    private SubastaProcedimientoApi subastaProcedimientoApi;
    
    private ExecutionContext executionContext;

	private final String TAP_SOLICITUD_SUBASTA = "P458_SolicitudSubasta";
	private final String TAP_DECRETO_CONVOCATORIA_SUBASTA = "P458_DecretoConvocatoriaSubasta";
	
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
				TAP_DECRETO_CONVOCATORIA_SUBASTA.equals(tareaExterna.getTareaProcedimiento().getCodigo()) 
				)) {
			subastaCalculoManager.actualizarTipoSubasta(procedimiento);	
		}
		avanzamosEstadoSubasta(procedimiento);
			
	}

	@Transactional
	private void avanzamosEstadoSubasta(Procedimiento prc) {
		
		Subasta sub = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(prc.getId());

		if (executionContext.getNode().getName().contains("SolicitudSubasta") || executionContext.getNode().getName().contains("DecretoConvocatoriaSubasta")) {
			if (!Checks.esNulo(sub)) {
				cambiaEstadoSubasta(sub, DDEstadoSubasta.PIN);
				duplicaInfoSubasta(executionContext, sub);
				subastaProcedimientoApi.determinarTipoSubasta(sub);
			}
		} else if (executionContext.getNode().getName().contains("AdjuntarNotasSimples") || executionContext.getNode().getName().contains("AdjuntarInformeFiscal")) {
			if (!Checks.esNulo(sub)) {
				cambiaEstadoSubasta(sub, DDEstadoSubasta.PPR);
			}
		} else if (executionContext.getNode().getName().contains("PrepararInformeSubasta")) {
			if (!Checks.esNulo(sub)) {
				cambiaEstadoSubasta(sub, DDEstadoSubasta.PCO);
			}
		} else if (executionContext.getNode().getName().contains("ValidarInformeSubasta")) {
			if (!Checks.esNulo(sub)) {
				cambiaEstadoSubasta(sub, obtenerEstadoSiguiente(executionContext, "ValidarInformeSubasta", "comboAceptarInforme"));
			}
		} else if (executionContext.getNode().getName().contains("RegistrarPagoTasaPublicacionBOE")) {
			if (!Checks.esNulo(sub)) {
				cambiaEstadoSubasta(sub, DDEstadoSubasta.PCE);
			}
		} else if (executionContext.getNode().getName().contains("RegistrarResultadoSubasta")) {
			if (!Checks.esNulo(sub)) {
				cambiaEstadoSubasta(sub, obtenerEstadoSiguiente(executionContext, "RegistrarResultadoSubasta", "comboDecision"));
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

	private String obtenerEstadoSiguiente(ExecutionContext executionContext, String tarea, String campo) {

		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory.proxy(SubastaProcedimientoApi.class)).obtenerValoresTareaByTexId(tex.getId());
		if (!Checks.esNulo(listado)) {
			if (tarea.contains("RegistrarResultadoSubasta")) {
				for (TareaExternaValor tev : listado) {
					if (DDSiNo.SI.equals(tev.getValor())) {
						return DDEstadoSubasta.CEL;
					} else if (DDSiNo.NO.equals(tev.getValor())) {
						return DDEstadoSubasta.SUS;
					}
				}
			}
			if (tarea.contains("ValidarInformeSubasta")) {
				for (TareaExternaValor tev : listado) {
					if (DDResultadoComite.ACEPTADA.equals(tev.getValor())) {
						return DDEstadoSubasta.PAC;
					} else if (DDResultadoComite.SUSPENDER.equals(tev.getValor())) {
						return DDEstadoSubasta.SUS;
					}
				}
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
	
}
