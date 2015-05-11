package es.pfsgroup.procedimientos.adjudicacion;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchAcuerdoCierreDeuda;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

public class GenerarPropuestaNUSEHandler extends es.pfsgroup.procedimientos.subasta.GenerarPropuestaNUSEHandler {

	private static final long serialVersionUID = 1L;
	private static final String PROPIEDAD_SAREB = "SAREB";
	private static final String TRANSICION_FIN = "Fin";

	private Procedimiento procedimiento = null;
	
	@Override
	protected BatchAcuerdoCierreDeuda getCierreDeudaInstance() {
		BatchAcuerdoCierreDeuda cierreDeuda = super.getCierreDeudaInstance();
		
		cierreDeuda.setEntidad(PROPIEDAD_SAREB);
		logger.debug(String.format("CIERRE DE DEUDA SAREB: Modificado Entidad: %s", cierreDeuda.getEntidad()));
		
		// Recupera el bien asociado.
		List<ProcedimientoBien> bienes = procedimiento.getBienes();
		if (bienes!=null && bienes.size()>0) {
			cierreDeuda.setIdBien(bienes.get(0).getBien().getId());
		}
		
		if (cierreDeuda.getIdBien() == null) {
			logger.warn(String.format("CIERRE DE DEUDA SAREB: No se ha encontrado el Bien del procedimiento %d", procedimiento.getId()));
		} else {
			logger.debug(String.format("CIERRE DE DEUDA SAREB: Modificado idBien: %s", cierreDeuda.getIdBien()));	
		}
		
		return cierreDeuda;
	};
	
	
	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		procedimiento = this.getProcedimiento(executionContext);
		
		EXTAsunto extAsunto = getExtAsunto(procedimiento);
		if (extAsunto!=null && PROPIEDAD_SAREB.equals(extAsunto.getPropiedadAsunto().getCodigo())) {
			super.run(executionContext);
			return;
		}
		
    	// Avanza BPM
		executionContext.getToken().signal(TRANSICION_FIN);
	}
	
}