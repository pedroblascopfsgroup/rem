package es.pfsgroup.procedimientos.asignacion;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.procedimientos.context.HayaProjectContext;

public class AsignacionHayaDecidirTipoAsuntoHandler extends PROBaseActionHandler {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1417606815140759L;

	@Autowired
	private Executor executor;

	@Autowired
	TipoProcedimientoManager tipoProcedimientoManager;

	@Autowired
	HayaProjectContext hayaProjectContext;

	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		Procedimiento prc = getProcedimiento(executionContext);
		if (prc != null && prc.getAsunto() != null && prc.getAsunto().getTipoAsunto() != null) {
			if (DDTiposAsunto.CONCURSAL.equals(prc.getAsunto().getTipoAsunto().getCodigo())) {
				executionContext.getToken().signal("concurso");
			} else {
				executionContext.getToken().signal("litigio");
			}
		}
	}

}
