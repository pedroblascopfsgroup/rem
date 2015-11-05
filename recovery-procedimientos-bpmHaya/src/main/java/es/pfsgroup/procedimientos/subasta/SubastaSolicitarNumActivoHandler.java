package es.pfsgroup.procedimientos.subasta;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastasServicioTasacionDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.procedimientos.PROBaseActionHandler;

public class SubastaSolicitarNumActivoHandler extends PROBaseActionHandler {

	private static final long serialVersionUID = 1L;

	@Autowired
	protected ApiProxyFactory proxyFactory;

    /**
     * Solicita un número de activo para cada bien.
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {

    	// Recupera la subasta de este procedimiento
		Procedimiento prc = getProcedimiento(executionContext);
		Subasta sub = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(prc.getId());
		
		// Recorre los bienes de los lotes.
		List<LoteSubasta> listaLotes = sub.getLotesSubasta();
		for (LoteSubasta lote : listaLotes) {
			List<Bien> bienes = lote.getBienes();
			for (Bien bien : bienes) {
				if (!(bien instanceof NMBBien)) {
					continue;
				}
				NMBBien nmbBien = (NMBBien)bien;
				boolean tieneNumeroActivo = nmbBien.tieneNumeroActivo();
				
				// para las que no tienen numero y hayan sido marcados para la subasta 
				if (!tieneNumeroActivo) {
					// llamada solicita_tasacion();
					try{
						proxyFactory.proxy(SubastasServicioTasacionDelegateApi.class).solicitarNumeroActivoByPrcId(nmbBien.getId(), prc.getId());
					}catch(Exception ex){
						logger.error(ex.getMessage());
						//seguimos con el siguiente
					}
				}
			}
		}
    	
    	// Avanza BPM
		executionContext.getToken().signal(BPMContants.TRANSICION_AVANZA_BPM);
    }

}