package es.pfsgroup.plugin.rem.oferta;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.api.LlamadaPBCApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.constants.TareaProcedimientoConstants;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOfertaAcciones;

@Service("llamadaPBCManager")
public class LlamadaPBCManager extends BusinessOperationOverrider<LlamadaPBCApi> implements LlamadaPBCApi{

    protected static final Log logger = LogFactory.getLog(LlamadaPBCManager.class);

    @Autowired
    private OfertaApi ofertaApi;


    @Override
    public String managerName() {
        return "llamadaPBCManager";
    }

    @Transactional
    @Override
    public void callPBC(ExpedienteComercial eco, TareaActivo tarea){
    	Oferta ofertaAceptada = eco.getOferta();
    	String accion = this.calcularLlamadaPBC(eco, tarea);
    	
    	if(accion != null) {
    		ofertaApi.llamadaPbc(ofertaAceptada, accion);
    	}
    }

    private String calcularLlamadaPBC(ExpedienteComercial eco, TareaActivo tarea) {
        String codTarea = tarea.getTareaExterna().getTareaProcedimiento().getCodigo();
        DDEstadoExpedienteBc estadoBc = eco.getEstadoBc();
        String codEstado = estadoBc != null ? estadoBc.getCodigo() : null;

        
        List<String> codigos = this.devolverCodigosLlamadaPbc(codTarea, codEstado);
        String codigoAccion = null;
        
        for (String codigo : codigos) {
			if(codigo != null) {
				codigoAccion = codigo;
				break;
			}
		}
        

        return codigoAccion;
    }
    
    private List<String> devolverCodigosLlamadaPbc(String codTarea, String codEstado) {
    	List<String> codigos = new ArrayList<String>();
    	codigos.add(this.calcularLlamadaPBCT015GarantiasAdicionales(codTarea, codEstado));
        codigos.add(this.calcularLlamadaPBCT015SancionBC(codTarea, codEstado));
        codigos.add(this.calcularLlamadaPBCT018TrasladarOfertaCliente(codTarea, codEstado));
        
        return codigos;
    }

    private String calcularLlamadaPBCT015GarantiasAdicionales(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.TramiteAlquilerT015.CODIGO_T015_SOLICITAR_GARANTIAS_ADICIONALES.equals(codTarea) && DDEstadoExpedienteBc.CODIGO_SCORING_APROBADO.equals(codEstado))
            return  DDTipoOfertaAcciones.ACCION_TAREA_DATOS_PBC;

        return null;
    }
    
    private String calcularLlamadaPBCT015SancionBC(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.TramiteAlquilerT015.CODIGO_SANCION.equals(codTarea) && DDEstadoExpedienteBc.CODIGO_SCORING_APROBADO.equals(codEstado))
            return  DDTipoOfertaAcciones.ACCION_TAREA_DATOS_PBC;

        return null;
    }
    
    private String calcularLlamadaPBCT018TrasladarOfertaCliente(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.TramiteAlquilerNoCmT018.CODIGO_T018_TRASLADAR_OFERTA_CLIENTE.equals(codTarea) && DDEstadoExpedienteBc.PTE_PBC_ALQUILER_HRE.equals(codEstado))
            return  DDTipoOfertaAcciones.ACCION_TAREA_DATOS_PBC;

        return null;
    }
	
}
