package es.pfsgroup.procedimientos.subasta;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDDecisionSuspension;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.ConfiguradorPropuesta;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.MEJDecisionProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.procedimientos.PROGenericEnterActionHandler;


public class SubastaComprobarProcedeSubastaSuspendidaHandler extends PROGenericEnterActionHandler {

	private static final long serialVersionUID = 1L;

	private static final int DIAS_ESPERA_SUBASTA = 60;
	
	@Autowired
	protected ApiProxyFactory proxyFactory;
	
	@Autowired
	private MEJDecisionProcedimientoManager decisionManager;
	
	@Autowired
    private TareaExternaManager tareaExternaManager;
	
	
	@Override
	protected Procedimiento creaProcedimientoHijo(
			ExecutionContext executionContext,
			TipoProcedimiento tipoProcedimientoHijo, Procedimiento procPadre,
			String iterationProperty, Object item) {
		Procedimiento prcHijo = super.creaProcedimientoHijo(executionContext, tipoProcedimientoHijo,
				procPadre, iterationProperty, item);

		// Paralizara el procedimiento.
		paralizarProcedimiento(executionContext, prcHijo);

		return prcHijo;
	}
	
	
    private void paralizarProcedimiento(ExecutionContext executionContext, Procedimiento nuevoProcedimiento) {
    	
    	
		Procedimiento prcActual = getProcedimiento(executionContext);
		
		List<TareaExterna> tareasPrcActual = tareaExternaManager.obtenerTareasPorProcedimiento(prcActual.getId());
		
		boolean esperar=false;
		for(TareaExterna tex : tareasPrcActual) {
			if("H002_RegistrarResSuspSubasta".equals(tex.getTareaProcedimiento().getCodigo())) {
				
				for(TareaExternaValor tev : tex.getValores()) {
					
					if(tev.getNombre().equals("comboSuspension")) {
						if(tev.getValor().equals(DDSiNo.SI)) {
							esperar = true;
							break;
						}
					}
					
				}
			} else if("H002_CelebracionSubasta".equals(tex.getTareaProcedimiento().getCodigo())) {
				
				for(TareaExternaValor tev : tex.getValores()) {
					
					if(tev.getNombre().equals("comboDecisionSuspension")) {
						if(tev.getValor().equals(DDDecisionSuspension.ENTIDAD)) {
							esperar = true;
							break;
						}
					}					
				}
			}
			if(esperar) {
				break;
			}
		}
	
		if(esperar) {
			Calendar calendario = Calendar.getInstance();
			calendario.add(Calendar.DATE, DIAS_ESPERA_SUBASTA);
			Date fecha = calendario.getTime();
			
			DecisionProcedimiento dec = new DecisionProcedimiento();
		    dec.setProcedimiento(nuevoProcedimiento);				
			MEJDtoDecisionProcedimiento decisionProcedimiento = new MEJDtoDecisionProcedimiento();
			decisionProcedimiento.setDecisionProcedimiento(dec);
			decisionProcedimiento.setStrEstadoDecision(DDEstadoDecision.ESTADO_PROPUESTO);
			decisionProcedimiento.setIdProcedimiento(nuevoProcedimiento.getId());
			decisionProcedimiento.setCausaDecisionParalizar("OTRA");
			decisionProcedimiento.setComentarios("Paralizado por suspensión de subasta");
			decisionProcedimiento.setFechaParalizacion(fecha);
			decisionProcedimiento.setParalizar(true);
			decisionManager.aceptarPropuestaSinControl(decisionProcedimiento, new ConfiguradorPropuesta());
		}
    }

}