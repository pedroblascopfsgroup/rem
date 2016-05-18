package es.pfsgroup.procedimientos.precontencioso;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.procedimientos.PROGenericEnterActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.ext.turnadoProcuradores.TurnadoProcuradoresApi;
import es.pfsgroup.recovery.ext.turnadodespachos.AplicarTurnadoException;

public class BCCPrecontenciosoEnterActionHandler extends PROGenericEnterActionHandler {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;

	@Autowired
	UsuarioManager usuarioManager;

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	TurnadoProcuradoresApi turnadoProcuradoresApi;
	
	@Autowired
	private TareaExternaManager tareaExternaManager;
	
	@Autowired
	private SubastaProcedimientoApi subastaProcedimientoApi;

	@Autowired
	private Executor executor;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {
		
		try {
			super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		} catch (Exception e) {
			e.printStackTrace();
		}

		personalizacionTarea(getProcedimiento(executionContext), getTareaExterna(executionContext));

	}

	@SuppressWarnings("unchecked")
	@Transactional
	private void personalizacionTarea(Procedimiento procedimiento, TareaExterna tex) {

		String plaza = "";
		String tpo = "";

		List<TareaExterna> tareas = tareaExternaManager.obtenerTareasPorProcedimiento(procedimiento.getId());
		for (TareaExterna tarea : tareas) {
			if ("HC106_RedactarDemandaAdjuntarDocu".equals(tarea.getTareaProcedimiento().getCodigo())) {
				List<EXTTareaExternaValor> valores = subastaProcedimientoApi.obtenerValoresTareaByTexId(tarea.getId());
				for (EXTTareaExternaValor valor : valores) {
					if ("proc_a_iniciar".equals(valor.getNombre())) {
						tpo = valor.getValor();
					} 
					else if ("partidoJudicial".equals(valor.getNombre())) {
						plaza = valor.getValor();
					}
 				}
				break;
			}
		}
		try {
			turnadoProcuradoresApi.turnarProcurador(procedimiento.getId(), usuarioManager.getUsuarioLogado().getUsername(), plaza, tpo);
		} catch (IllegalArgumentException e) {
			logger.error("Illegal turnado: " + e);
		} catch (AplicarTurnadoException e) {
			logger.error("Aplicar turnado: " + e);
		}
	}
}
