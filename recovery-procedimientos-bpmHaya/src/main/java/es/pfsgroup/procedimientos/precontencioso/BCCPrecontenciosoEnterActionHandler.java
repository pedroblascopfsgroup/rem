package es.pfsgroup.procedimientos.precontencioso;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.turnadoProcuradores.TurnadoProcuradoresApi;
import es.pfsgroup.recovery.ext.turnadodespachos.AplicarTurnadoException;

public class BCCPrecontenciosoEnterActionHandler extends PROGenericLeaveActionHandler {

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

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);

		Procedimiento procedimiento = getProcedimiento(executionContext);
		TareaExterna tex = getTareaExterna(executionContext);

		personalizacionTarea(procedimiento, tex);

	}

	@Transactional
	private void personalizacionTarea(Procedimiento procedimiento, TareaExterna tex) {

		// Llamamos al turnado de procuradores siempre y cuando se haya
		// detectado diferencia entre lo propuesto y lo asignado
		// actualmente, ya que el usuario puede haber cambiado el procurador
		// asignado manualmente

		if (turnadoProcuradoresApi.comprobarSiProcuradorHaSidoCambiado(procedimiento.getId())) {
			try {
				turnadoProcuradoresApi.turnarProcurador(procedimiento.getId(), usuarioManager.getUsuarioLogado().getUsername());
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (AplicarTurnadoException e) {
				e.printStackTrace();
			}
		}
	}

}
