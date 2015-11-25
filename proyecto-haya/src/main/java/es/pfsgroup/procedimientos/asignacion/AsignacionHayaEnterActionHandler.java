package es.pfsgroup.procedimientos.asignacion;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.procedimientos.context.HayaProjectContext;

public class AsignacionHayaEnterActionHandler extends PROBaseActionHandler {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2156270993650719342L;

	@Autowired
	private Executor executor;

	@Autowired
	TipoProcedimientoManager tipoProcedimientoManager;

	@Autowired
	HayaProjectContext hayaProjectContext;

	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		Procedimiento prc = getProcedimiento(executionContext);
		String codigoProcedimiento = null;
		if (prc != null && prc.getAsunto() != null && prc.getAsunto().getTipoAsunto() != null) {
			if (DDTiposAsunto.CONCURSAL.equals(prc.getAsunto().getTipoAsunto().getCodigo())) {
				codigoProcedimiento = hayaProjectContext.getTareaInicioConcurso();
			} else {
				codigoProcedimiento = hayaProjectContext.getTareaAceptacionLitigios();
			}
			TipoProcedimiento tipoProcedimientoHijo = tipoProcedimientoManager.getByCodigo(codigoProcedimiento);
			this.creaProcedimientoHijo(executionContext, tipoProcedimientoHijo, prc, null, null);
		}
	}
}
