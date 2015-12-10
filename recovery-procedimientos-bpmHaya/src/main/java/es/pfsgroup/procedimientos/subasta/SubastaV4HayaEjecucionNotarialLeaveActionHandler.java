package es.pfsgroup.procedimientos.subasta;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.recovery.coreextension.model.DDResultadoComiteConcursal;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDMotivoSuspSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoComite;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDTipoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.procedimientos.model.DDTipoRespuestaElevacionSareb;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

//public class SubastaV4HayaEjecucionNotarialLeaveActionHandler extends SubastaV4LeaveActionHandler {
public class SubastaV4HayaEjecucionNotarialLeaveActionHandler extends PROGenericLeaveActionHandler {	
	

	/**
	 * 
	 */
	private static final long serialVersionUID = 6476140372822561349L;

	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private Executor executor;

	@Autowired
	private JBPMProcessManager jbpmUtil;

    @Autowired
    private IntegracionBpmService bpmIntegracionService;
	
	private ExecutionContext executionContext;
	
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
		
		avanzamosEstadoSubasta();
	}

private void avanzamosEstadoSubasta() {
		
		Procedimiento prc = getProcedimiento(executionContext);
		Subasta sub = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(prc.getId());		
		
		if (executionContext.getNode().getName().contains("entregaActaRequerimiento")) {
			//
			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.PIN);
			}
		} else if (executionContext.getNode().getName().contains("PrepararInformeSubasta")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.PCO);
			}
		} else if (executionContext.getNode().getName().contains("registrarAnuncioSubasta")) {

			if (!Checks.esNulo(sub)) {

				duplicaInfoSubasta(executionContext,sub);
			}
		} else if (executionContext.getNode().getName().contains("ValidarPropuesta")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, obtenerEstadoSiguiente(executionContext, "ValidarPropuesta", "suspender"));
				TareaExterna tex = getTareaExterna(executionContext);
				List<TareaExternaValor> listadoValores = tex.getValores();
				for(TareaExternaValor val : listadoValores){
					if("delegada".equals(val.getNombre())){
						actualizarTipoSubasta(sub, val.getValor());
					}
				}
			}
		} else if (executionContext.getNode().getName().contains("LecturaYAceptacionInstrucciones")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.PCE);
			}
		} else if (executionContext.getNode().getName()
				.contains("ElevarPropuestaAComite")) {
			if (!Checks.esNulo(sub)) {
				TareaExterna tex = getTareaExterna(executionContext);
				List<TareaExternaValor> listadoValores = tex.getValores();
				for(TareaExternaValor val : listadoValores){
					if("comboResultadoComite".equals(val.getNombre())){
						actualizarRevisionSubasta(sub, val.getValor());
					}
				}
			}
		} else if (executionContext.getNode().getName()
				.contains("RegistrarRespuestaSarebSub")) {
			if (!Checks.esNulo(sub)) {
				TareaExterna tex = getTareaExterna(executionContext);
				List<TareaExternaValor> listadoValores = tex.getValores();
				for(TareaExternaValor val : listadoValores){
					if("comboResultado".equals(val.getNombre())){
						actualizarRevisionSareb(sub, val.getValor());
					}
				}
			}
		} else if (executionContext.getNode().getName().contains("CelebracionSubasta")) {

			if (!Checks.esNulo(sub)) {

				final String estadoSiguiente = obtenerEstadoSiguiente(executionContext, "CelebracionSubasta", "celebrada");
				if (DDEstadoSubasta.SUS.equals(estadoSiguiente)) {
					setMotivoSuspensionSubasta(sub);
				}
				cambiaEstadoSubasta(sub, estadoSiguiente);
				
			}
		} else if (executionContext.getNode().getName().contains("SuspenderSubasta")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.SUS);
				setMotivoSuspensionSubasta(sub);				
			}

			// Finalizamos el procedimiento padre
			try {
				jbpmUtil.finalizarProcedimiento(prc.getId());
				prc.setEstadoProcedimiento(genericDao.get(DDEstadoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO)));
				genericDao.save(Procedimiento.class, prc);

			} catch (Exception e) {
				e.printStackTrace();
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
		if (!Checks.esNulo(sub.getEstadoSubasta().getCodigo()) && 
				(DDEstadoSubasta.CEL.compareTo(sub.getEstadoSubasta().getCodigo()) != 0 
				&& DDEstadoSubasta.SUS.compareTo(sub.getEstadoSubasta().getCodigo()) != 0)) {
			DDEstadoSubasta esu = genericDao.get(DDEstadoSubasta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estado), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			sub.setEstadoSubasta(esu);
		}
	}
	
	private void setMotivoSuspensionSubasta(final Subasta sub){
		TareaExterna tex = getTareaExterna(executionContext);
		List<TareaExternaValor> listadoValores = tex.getValores();
		for(TareaExternaValor val : listadoValores){
			if("comboMotivoSuspension".equals(val.getNombre())){
				sub.setMotivoSuspension(genericDao.get(DDMotivoSuspSubasta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", val.getValor())));
			}
		}
	}
	
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
					if (DDSiNo.SI.equals(tev.getValor())) {
						return DDEstadoSubasta.SUS;
					} else if (DDSiNo.NO.equals(tev.getValor())) {
						return DDEstadoSubasta.PAC;
					}
				}
				return DDEstadoSubasta.PCO;
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
					if ("fechaAnuncio".equals(tev.getNombre())) {
						sub.setFechaAnuncio(formatter.parse(tev.getValor()));
					}
					if ("fechaSubasta".equals(tev.getNombre())) {
						sub.setFechaSenyalamiento(formatter.parse(tev.getValor()));
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
	
		}
	}	
	
	private void actualizarRevisionSubasta(Subasta sub, String resultado){
		if(!Checks.esNulo(resultado)){
			if(resultado.equals(DDResultadoComiteConcursal.CONCEDIDO) || resultado.equals(DDResultadoComiteConcursal.CONCEDIDO_CON_MODIFICACIONES)){
				DDResultadoComite resCom = genericDao.get(DDResultadoComite.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoComite.ACEPTADA), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				sub.setResultadoComite(resCom);
			}else if(resultado.equals(DDResultadoComiteConcursal.MODIFICAR)){
				DDResultadoComite resCom = genericDao.get(DDResultadoComite.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoComite.RECTIFICAR), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				sub.setResultadoComite(resCom);
			}else if(resultado.equals(DDResultadoComiteConcursal.DENEGADA)){
				DDResultadoComite resCom = genericDao.get(DDResultadoComite.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoComite.SUSPENDER), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				sub.setResultadoComite(resCom);
			}
		}
	}
	
	private void actualizarRevisionSareb(Subasta sub, String resultado){
		if(!Checks.esNulo(resultado)){
			if(resultado.equals(DDTipoRespuestaElevacionSareb.ACEPTADA) || resultado.equals(DDTipoRespuestaElevacionSareb.ACCONCAM)){
				DDResultadoComite resCom = genericDao.get(DDResultadoComite.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoComite.ACEPTADA), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				sub.setResultadoComite(resCom);
			}else if(resultado.equals(DDTipoRespuestaElevacionSareb.DENEGADA)){
				DDResultadoComite resCom = genericDao.get(DDResultadoComite.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoComite.SUSPENDER), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				sub.setResultadoComite(resCom);
			}
		}
	}
	
	private void actualizarTipoSubasta(Subasta sub, String resultado){
		if(!Checks.esNulo(resultado)){
			if(resultado.equals(DDSiNo.SI)){
				DDTipoSubasta tipoSubasta = genericDao.get(DDTipoSubasta.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDTipoSubasta.DEL), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				sub.setTipoSubasta(tipoSubasta);
			}else if(resultado.equals(DDSiNo.NO)){
				DDTipoSubasta tipoSubasta = genericDao.get(DDTipoSubasta.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDTipoSubasta.NDE), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				sub.setTipoSubasta(tipoSubasta);
			}
		}
	}
	
	
	
}
