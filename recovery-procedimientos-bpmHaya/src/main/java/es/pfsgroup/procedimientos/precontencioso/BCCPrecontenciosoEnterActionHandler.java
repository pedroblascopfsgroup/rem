package es.pfsgroup.procedimientos.precontencioso;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
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
	private Executor executor;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {

		personalizacionTarea(getProcedimiento(executionContext), getTareaExterna(executionContext));

	}

	@SuppressWarnings("unchecked")
	@Transactional
	private void personalizacionTarea(Procedimiento procedimiento, TareaExterna tex) {

		String plaza = "";
		String tpo = "";

		List<EXTTareaExternaValor> listado = (List<EXTTareaExternaValor>) executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_VALORES_TAREA, tex.getId());

		if (!Checks.esNulo(listado)) {
			for (EXTTareaExternaValor tev : listado) {
				if ("partidoJudicial".equals(tev.getNombre())) {
					plaza = tev.getValor();
				} else if ("proc_a_iniciar".equals(tev.getNombre())) {
					tpo = tev.getValor();
				}

			}
		}
		try {
			turnadoProcuradoresApi.turnarProcurador(procedimiento.getId(), usuarioManager.getUsuarioLogado().getUsername(), plaza, tpo);
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (AplicarTurnadoException e) {
			e.printStackTrace();
		}

	}

}
