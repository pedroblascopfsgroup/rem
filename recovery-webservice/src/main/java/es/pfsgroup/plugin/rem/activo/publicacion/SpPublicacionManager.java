package es.pfsgroup.plugin.rem.activo.publicacion;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.SpPublicacionApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.constants.TareaProcedimientoConstants;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Service("spPublicacionManager")
public class SpPublicacionManager extends BusinessOperationOverrider<SpPublicacionApi> implements SpPublicacionApi{

    @Autowired
    private TareaActivoApi tareaActivoApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private OfertaApi ofertaApi;
    
    
	@Autowired
	private ActivoAdapter activoAdapter;

    @Override
    public String managerName() {
        return "spPublicacionManager";
    }

    @Transactional
    @Override
    public void callSpPublicacionAsincrono(Long idTarea, Boolean success){
        ExpedienteComercial eco = null;
        Boolean lanzarSpPublicacion = false;
        TareaActivo tarea = null;

        if(idTarea != null){
            tarea = tareaActivoApi.get(idTarea);
            Long idTramite = tarea != null && tarea.getTramite() != null ? tarea.getTramite().getId() : null;
            if(idTramite != null)
                eco = expedienteComercialApi.getExpedienteByIdTramite(idTramite);
        }

        if(eco != null && tarea != null && success){
            lanzarSpPublicacion = calculaLanzarSpPublicacionAsincrono(eco, tarea);
            if(lanzarSpPublicacion) {
            	
            	ejecutarSpPublicacionAsincrono(eco);
            }
        }
    }
    
    private boolean ejecutarSpPublicacionAsincrono(ExpedienteComercial eco) {
    	ArrayList<Long> listaIdActivos = new ArrayList<Long>();
    	
		if(!Checks.esNulo(eco.getOferta().getActivosOferta())) {
			for (ActivoOferta activoOfer : eco.getOferta().getActivosOferta()) {
				if(!Checks.esNulo(activoOfer.getPrimaryKey()) 
					&& !Checks.esNulo(activoOfer.getPrimaryKey().getActivo())){
						Activo act = activoOfer.getPrimaryKey().getActivo();
						listaIdActivos.add(act.getId());
					}
				
			}
		}
		return (!Checks.estaVacio(listaIdActivos)) ? activoAdapter.actualizarEstadoPublicacionActivo(listaIdActivos, true): false;
    }

    private Boolean calculaLanzarSpPublicacionAsincrono(ExpedienteComercial eco, TareaActivo tarea) {
        String codTarea = tarea.getTareaExterna().getTareaProcedimiento().getCodigo();
        DDEstadosExpedienteComercial estado = eco.getEstado();
        DDEstadoExpedienteBc estadobc = eco.getEstadoBc();
        String codEstado = estado != null ? estado.getCodigo() : null;
        String codEstadobc = estadobc != null ? estadobc.getCodigo() : null;

        if(!DDCartera.isCarteraBk(eco.getOferta().getActivoPrincipal().getCartera())){
            return false;
        }

        return calculaT017ResolucionCES(codTarea, codEstadobc) || calculaT015ElevaraSancion(codTarea, codEstado);
    }


    private boolean calculaT017ResolucionCES(String codTarea, String codEstadobc) {
        return (TareaProcedimientoConstants.CODIGO_RESOLUCION_CES_T017.equals(codTarea) && DDEstadoExpedienteBc.CODIGO_OFERTA_APROBADA.equals(codEstadobc));

    }
    
    private boolean calculaT015ElevaraSancion(String codTarea, String codEstado) {
        
    	return (TareaProcedimientoConstants.TramiteAlquilerT015.CODIGO_ELEVAR.equals(codTarea) && DDEstadosExpedienteComercial.PTE_SCORING.equals(codEstado));
    }
}
