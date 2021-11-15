package es.pfsgroup.plugin.rem.oferta;

import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ReplicacionOfertasApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.constants.TareaProcedimientoConstants;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("replicacionOfertasManager")
public class ReplicacionOfertasManager extends BusinessOperationOverrider<ReplicacionOfertasApi> implements ReplicacionOfertasApi{

    @Autowired
    private TareaActivoApi tareaActivoApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private OfertaApi ofertaApi;

    @Override
    public String managerName() {
        return "replicacionOfertasManager";
    }

    @Transactional
    @Override
    public void callReplicateOferta(Long idTarea, Boolean success){
        ExpedienteComercial eco = null;
        Boolean lanzarReplicate = false;
        TareaActivo tarea = null;

        if(idTarea != null){
            tarea = tareaActivoApi.get(idTarea);
            Long idTramite = tarea != null && tarea.getTramite() != null ? tarea.getTramite().getId() : null;
            if(idTramite != null)
                eco = expedienteComercialApi.getExpedienteByIdTramite(idTramite);
        }

        if(eco != null && tarea != null && success){
            lanzarReplicate = calculaLanzarReplicateByEco(eco, tarea);
            if(lanzarReplicate)
                ofertaApi.replicateOfertaFlushDto(eco.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(eco));
        }
    }

    private Boolean calculaLanzarReplicateByEco(ExpedienteComercial eco, TareaActivo tarea) {
        String codTarea = tarea.getTareaExterna().getTareaProcedimiento().getCodigo();
        DDEstadoExpedienteBc estadoBc = eco.getEstadoBc();
        String codEstado = estadoBc != null ? estadoBc.getCodigo() : null;

        if(!DDCartera.isCarteraBk(eco.getOferta().getActivoPrincipal().getCartera())){
            return false;
        }

        if(calculaT017ResolucionExpdiente(codTarea, codEstado)){
            return true;
        } else if (calculaResolucionT018DefinicionOferta(codTarea, codEstado)) {
            return true;
        } else if (calculaResolucionT018AnalisisTecnico(codTarea, codEstado)) {
            return true;
        } else if (calculaResolucionT018AnalisisBc(codTarea, codEstado)) {
            return true;
        } else if (calculaResolucionT018ScoringBc(codTarea, codEstado)) {
            return true;
        } else if (calculaResolucionT018ResolucionComite(codTarea, codEstado)) {
            return true;
        } else if (calculaResolucionT018RevisionBcCondiciones(codTarea, codEstado)) {
            return true;
        } else if (calculaT017AgendarFechaArras(codTarea, codEstado)){
            return true;
        }

        return false;
    }

    private boolean calculaT017ResolucionExpdiente(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.CODIGO_RESOLUCION_EXPEDIENTE_T017.equals(codTarea) &&
                (DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA.equals(codEstado) || DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO.equals(codEstado)))
            return true;

        return false;
    }

    private boolean calculaResolucionT018DefinicionOferta(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.CODIGO_T018_DEFINICION_OFERTA.equals(codTarea) && DDEstadoExpedienteBc.PTE_SCREENING_Y_ANALISIS_BC.equals(codEstado))
            return true;

        return false;
    }

    private boolean calculaResolucionT018AnalisisTecnico(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.CODIGO_T018_ANALISIS_TECNICO.equals(codTarea) && DDEstadoExpedienteBc.PTE_SANCION_BC.equals(codEstado))
            return true;

        return false;
    }

    private boolean calculaResolucionT018AnalisisBc(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.CODIGO_T018_ANALISIS_BC.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_OFERTA_PDTE_SCORING.equals(codEstado)
                || DDEstadoExpedienteBc.PTE_PBC_ALQUILER_HRE.equals(codEstado) || DDEstadoExpedienteBc.PTE_ANALISIS_TECNICO.equals(codEstado)
                || DDEstadoExpedienteBc.PTE_NEGOCIACION.equals(codEstado) || DDEstadoExpedienteBc.PTE_CL_ROD.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA.equals(codEstado)))
            return true;

        return false;
    }

    private boolean calculaResolucionT018ScoringBc(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.CODIGO_T018_SCORING_BC.equals(codTarea) && (DDEstadoExpedienteBc.PTE_ANALISIS_TECNICO.equals(codEstado)
                || DDEstadoExpedienteBc.PTE_NEGOCIACION.equals(codEstado) || DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA.equals(codEstado)))
            return true;

        return false;
    }

    private boolean calculaResolucionT018ResolucionComite(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.CODIGO_T018_RESOLUCION_COMITE.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA.equals(codEstado)
                || DDEstadoExpedienteBc.PTE_NEGOCIACION.equals(codEstado)))
            return true;

        return false;
    }

    private boolean calculaResolucionT018RevisionBcCondiciones(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.CODIGO_T018_REVISION_BC_Y_CONDICIONES.equals(codTarea) && (DDEstadoExpedienteBc.PTE_CL_ROD.equals(codEstado)
                || DDEstadoExpedienteBc.PTE_NEGOCIACION.equals(codEstado)))
            return true;

        return false;
    }

    private boolean calculaT017AgendarFechaArras(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.TramiteComercialT017.CODIGO_T017_AGENDAR_FECHA_ARRAS.equals(codTarea))
            return true;

        return false;
    }
}
