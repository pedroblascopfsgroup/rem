package es.pfsgroup.procedimientos.adjudicacion;

import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

public class GenerarPropuestaNUSEHandler extends es.pfsgroup.procedimientos.subasta.GenerarPropuestaNUSEHandler {

	private static final long serialVersionUID = 1L;
	private static final String PROPIEDAD_SAREB = "SAREB";
	private static final String TRANSICION_FIN = "Fin";
	private static final String TPO_TIPO_PROCEDIMIENTO_SUBASTA_SAREB = "P409";

	private Procedimiento procedimiento = null;	
	private Procedimiento procedimientoSubasta = null;	
	
	
	/**
	 * Función que busca recursivamente la tarea de subasta. 
	 * Irá consultando los padres de cada procedimiento hasta que encuentre el de subasta o encuentre un procedimiento sin padre.
	 * @param procedimiento
	 * @return
	 */
	private Procedimiento getProcedimientoSubastaSareb(Procedimiento procedimiento) {
		
		
		if(Checks.esNulo(procedimiento) || TPO_TIPO_PROCEDIMIENTO_SUBASTA_SAREB.equals(procedimiento.getTipoProcedimiento().getCodigo())) {
			
			return procedimiento;
		
		} else {
			
			return getProcedimientoSubastaSareb(procedimiento.getProcedimientoPadre());
			
		}

	}
	
	
	
	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		
		this.procedimiento = this.getProcedimiento(executionContext);
		this.procedimientoSubasta = getProcedimientoSubastaSareb(procedimiento.getProcedimientoPadre());
		super.setProcedimientoSubasta(procedimientoSubasta);
		super.setProcedimiento(procedimiento);
		
		EXTAsunto extAsunto = getExtAsunto();
		if (extAsunto!=null && PROPIEDAD_SAREB.equals(extAsunto.getPropiedadAsunto().getCodigo())) {
			enviarCierreDeuda();
		}
		
    	// Avanza BPM
		executionContext.getToken().signal(TRANSICION_FIN);
	}

	
	
}