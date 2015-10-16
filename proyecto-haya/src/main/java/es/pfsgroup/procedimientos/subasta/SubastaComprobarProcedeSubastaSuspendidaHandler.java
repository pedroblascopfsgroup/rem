package es.pfsgroup.procedimientos.subasta;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDDecisionSuspension;
import es.pfsgroup.procedimientos.PROBaseActionHandler;


public class SubastaComprobarProcedeSubastaSuspendidaHandler extends PROBaseActionHandler {

	private static final long serialVersionUID = 1L;

	private static final int DIAS_ESPERA_SUBASTA = 60;
	private static final String TIMER_NAME = "Espera Subasta Suspendida";
	private static final String TIMER_DURATION_MASK = "%d days";
	
	@Autowired
	protected ApiProxyFactory proxyFactory;
	
	@Autowired
    private TareaExternaManager tareaExternaManager;
	
    /**
     * Comprueba si procede de un trámite de subasta que ha sido suspendido. En ese caso lanza una tarea de espera de 60 días; en otro continúa el trámite
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
    	
		Procedimiento prc = getProcedimiento(executionContext);
		Procedimiento prcPadre = prc.getProcedimientoPadre();
		
		// Si procede de un trámite de subasta se comprueba si la subasta ha sido suspendida
		if(prcPadre != null && prcPadre.getTipoProcedimiento().getCodigo().equals("H002")) {
			
			boolean esperar = false;
			List<TareaExterna> tareasPadre = tareaExternaManager.obtenerTareasPorProcedimiento(prcPadre.getId());
			
			for(TareaExterna tex : tareasPadre) {
				
				if("H002_RegistrarResSuspSubasta".equals(tex.getTareaProcedimiento().getCodigo())) {
					
					for(TareaExternaValor tev : tex.getValores()) {
						
						if(tev.getNombre().equals("comboSuspension")) {
							if(tev.getValor().equals(DDSiNo.SI)) {
								esperar = true;
								break;
							}
						}
						
					}
				}
				else if("H002_CelebracionSubasta".equals(tex.getTareaProcedimiento().getCodigo())) {
					
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
				String duration = String.format(TIMER_DURATION_MASK, DIAS_ESPERA_SUBASTA);
				BPMUtils.createTimer (executionContext, TIMER_NAME, duration, BPMContants.TRANSICION_AVANZA_BPM);
			}
			else {
				executionContext.getToken().signal(BPMContants.TRANSICION_AVANZA_BPM);
			}
		}
		// Si no procede de un trámite de subasta se avanza el trámite 
		else {
			executionContext.getToken().signal(BPMContants.TRANSICION_AVANZA_BPM);
		}
    }
}