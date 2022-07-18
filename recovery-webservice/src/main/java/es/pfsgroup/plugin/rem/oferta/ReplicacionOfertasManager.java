package es.pfsgroup.plugin.rem.oferta;

import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.accionesCaixa.CaixaBcReplicationDataHolder;
import es.pfsgroup.plugin.rem.activo.ActivoAgrupacionManager;
import es.pfsgroup.plugin.rem.api.*;
import es.pfsgroup.plugin.rem.constants.TareaProcedimientoConstants;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("replicacionOfertasManager")
public class ReplicacionOfertasManager extends BusinessOperationOverrider<ReplicacionOfertasApi> implements ReplicacionOfertasApi{

    protected static final Log logger = LogFactory.getLog(ReplicacionOfertasManager.class);

    @Autowired
    private TareaActivoApi tareaActivoApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private SpPublicacionApi spPublicacionApi;

    @Autowired
    private LlamadaPBCApi llamadaPBCApi;
    
    @Override
    public String managerName() {
        return "replicacionOfertasManager";
    }

    @Transactional
    @Override
    public void callReplicateOferta(CaixaBcReplicationDataHolder dataHolder, Boolean success){
        ExpedienteComercial eco = null;
        Boolean lanzarReplicate = false;
        TareaActivo tarea = null;

        if(dataHolder.getIdTarea() != null){
            tarea = tareaActivoApi.get(dataHolder.getIdTarea());
            Long idTramite = tarea != null && tarea.getTramite() != null ? tarea.getTramite().getId() : null;
            if(idTramite != null)
                eco = expedienteComercialApi.getExpedienteByIdTramite(idTramite);
        }

        if (eco == null && dataHolder.getNumOferta() != null){
            eco = expedienteComercialApi.getExpedienteComercyalByNumOferta(dataHolder.getNumOferta());
        }

        if(eco != null && success){
            if (dataHolder.getCurrentStateExpedienteBcCod() == null)
                dataHolder.setCurrentStateExpedienteBcCod(eco.getEstadoBc() != null ? eco.getEstadoBc().getCodigo() : null);
            lanzarReplicate = dataHolder.haschangedExpedienteBCState();
            if(lanzarReplicate){
                if (dataHolder.getEsAccion() != null && dataHolder.getEsAccion()){
                    dataHolder.setReplicateToBc(Boolean.TRUE);
                }else {
                    if (tarea != null){
                        callSPPublicaciones(dataHolder.getIdTarea(),success);
                        ofertaApi.replicateOfertaFlush(eco.getOferta());
                        llamadaPBCApi.callPBC(eco, tarea);
                    }
                }
            }else if (tarea != null && (dataHolder.getEsAccion() == null || !dataHolder.getEsAccion())){
                callSPPublicaciones(dataHolder.getIdTarea(),success);
            }
        }
    }

    public void callSPPublicaciones(Long idTarea,Boolean success){
        if (idTarea != null)
        lanzarSPPublicaciones(idTarea != null ? idTarea.toString() : null,success);
    }

    private Boolean calculaLanzarReplicateByEco(ExpedienteComercial eco, TareaActivo tarea) {
        String codTarea = tarea.getTareaExterna().getTareaProcedimiento().getCodigo();
        DDEstadoExpedienteBc estadoBc = eco.getEstadoBc();
        String codEstado = estadoBc != null ? estadoBc.getCodigo() : null;

        if(!DDCartera.isCarteraBk(eco.getOferta().getActivoPrincipal().getCartera())){
            return false;
        }

        return calculaT017ResolucionExpdiente(codTarea, codEstado) || calculaResolucionT018DefinicionOferta(codTarea, codEstado)
                || calculaResolucionT018AnalisisTecnico(codTarea, codEstado) || calculaResolucionT018AnalisisBc(codTarea, codEstado)
                || calculaResolucionT018ScoringBc(codTarea, codEstado) || calculaResolucionT018ResolucionComite(codTarea, codEstado)
                || calculaResolucionT018RevisionBcCondiciones(codTarea, codEstado) || calculaT017AgendarFechaArras(codTarea, codEstado)
                || calculaT017ResolucionCES(codTarea, codEstado) || calculaT018PtClRod(codTarea, codEstado)
                || calculaT015ElevarASancion(codTarea, codEstado) || calculaT015SancionBc(codTarea, codEstado)
                || calculaT015SancionPatrimonio(codTarea, codEstado) || calculaT015ScoringBc(codTarea, codEstado)
                || calculaT015DatosPBC(codTarea,codEstado) || calculaT018DatosPBC(codTarea,codEstado)
                || calculaT015CalculoRiesgo(codTarea,codEstado) || calculaT018CalculoRiesgo(codTarea,codEstado)
                || calculaT015PBCAlquiler(codTarea,codEstado) || calculaT018PBCAlquiler(codTarea,codEstado)
                || calculaT015SolicitarGarantiasAdicionales(codTarea, codEstado) || calculaT018TrasladarOfertaCliente(codTarea, codEstado)
                || calculaResolucionT017ConfirmarFechaEscritura(codTarea, codEstado) || calculaResolucionT017AgendarPosicionamiento(codTarea, codEstado)
                || calculaResolucionT017FirmaContrato(codTarea, codEstado);
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

    private boolean calculaT017ResolucionCES(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.CODIGO_RESOLUCION_CES_T017.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_OFERTA_APROBADA.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA.equals(codEstado)))
            return true;

        return false;
    }
    
    private boolean calculaT018PtClRod(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.TramiteAlquilerNoCmT018.CLROD.equals(codTarea) && (DDEstadoExpedienteBc.PTE_TRASLADAR_OFERTA_AL_CLIENTE.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA.equals(codEstado)))
            return true;

        return false;
    }
    
    private boolean calculaT015ElevarASancion(String codTarea, String codEstado) {
    	if(TareaProcedimientoConstants.TramiteAlquilerT015.CODIGO_ELEVAR.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_OFERTA_PDTE_SCORING.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_CONTRAOFERTADO.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA.equals(codEstado)))
            return true;

        return false;
    }
    
    private boolean calculaT015SancionBc(String codTarea, String codEstado) {
    	if(TareaProcedimientoConstants.TramiteAlquilerT015.CODIGO_SANCION.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_SCORING_APROBADO.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO.equals(codEstado)))
            return true;

        return false;
    }
    
    private boolean calculaT015SancionPatrimonio(String codTarea, String codEstado) {
    	if(TareaProcedimientoConstants.TramiteAlquilerT015.CODIGO_SANCION_PATRIMONIO.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_PTE_ENVIO.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO.equals(codEstado)))
            return true;

        return false;
    }
    
    private boolean calculaT015ScoringBc(String codTarea, String codEstado) {
    	if(TareaProcedimientoConstants.TramiteAlquilerT015.CODIGO_SCORING_BC.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_PTE_GARANTIAS_ADICIONALES.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO.equals(codEstado)))
            return true;

        return false;
    }
    
    private boolean calculaT015DatosPBC(String codTarea, String codEstado) {
    	if(TareaProcedimientoConstants.TramiteAlquilerT015.CODIGO_DATOSPBC.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_PTE_CALCULO_RIESGO.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA.equals(codEstado)))
            return true;

        return false;
	}
    
    private boolean calculaT018DatosPBC(String codTarea, String codEstado) {
    	if(TareaProcedimientoConstants.TramiteAlquilerNoCmT018.CODIGO_DATOSPBC.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_PTE_CALCULO_RIESGO.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA.equals(codEstado)))
            return true;

        return false;
	}
    
    private boolean calculaT015CalculoRiesgo(String codTarea, String codEstado) {
    	if(TareaProcedimientoConstants.TramiteAlquilerT015.CODIGO_CALCULO_RIESGO.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO.equals(codEstado)
                || DDEstadoExpedienteBc.PTE_SANCION_PBC_SERVICER.equals(codEstado)))
            return true;

        return false;
	}
    private boolean calculaT018CalculoRiesgo(String codTarea, String codEstado) {
    	if(TareaProcedimientoConstants.TramiteAlquilerNoCmT018.CODIGO_CALCULO_RIESGO.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO.equals(codEstado)
                || DDEstadoExpedienteBc.PTE_SANCION_PBC_SERVICER.equals(codEstado)))
            return true;

        return false;
	}
    
    private boolean calculaT015PBCAlquiler(String codTarea, String codEstado) {
    	if(TareaProcedimientoConstants.TramiteAlquilerT015.CODIGO_PBC_ALQUILER.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO.equals(codEstado)))
            return true;

        return false;
	}
    
    private boolean calculaT018PBCAlquiler(String codTarea, String codEstado) {
    	if(TareaProcedimientoConstants.TramiteAlquilerNoCmT018.CODIGO_PBC_ALQUILER.equals(codTarea) && (DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA.equals(codEstado)))
            return true;

        return false;
	}

    private boolean calculaT015SolicitarGarantiasAdicionales(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.TramiteAlquilerT015.CODIGO_T015_SOLICITAR_GARANTIAS_ADICIONALES.equals(codTarea)
            && (DDEstadoExpedienteBc.CODIGO_SCORING_APROBADO.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_PENDIENTE_GARANTIAS_ADICIONALES_BC.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_VALORAR_ACUERDO_SIN_GARANTIAS_ADICIONALES.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA.equals(codEstado)))
            return true;

        return false;
    }

    private boolean calculaT018TrasladarOfertaCliente(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.TramiteAlquilerNoCmT018.CODIGO_T018_TRASLADAR_OFERTA_CLIENTE.equals(codTarea)
                && (DDEstadoExpedienteBc.PTE_PBC_ALQUILER_HRE.equals(codEstado)
                    || DDEstadoExpedienteBc.PTE_REVISAR_CONDICIONES_BC.equals(codEstado)))
            return true;

        return false;
    }

    private boolean calculaResolucionT017ConfirmarFechaEscritura(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.CODIGO_CONFIRMAR_FECHA_ESCRITURA_T017.equals(codTarea)
                && (DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_FIRMA_DE_CONTRATO_AGENDADO.equals(codEstado)
                || DDEstadoExpedienteBc.PTE_SANCION_PBC_SERVICER.equals(codEstado)))
            return true;

        return false;
    }

    private boolean calculaResolucionT017AgendarPosicionamiento(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.TramiteComercialT017.CODIGO_T017_AGENDAR_POSICIONAMIENTO.equals(codTarea)
                && (DDEstadoExpedienteBc.CODIGO_VALIDACION_DE_FIRMA_DE_CONTRATO_POR_BC.equals(codEstado)
                || DDEstadoExpedienteBc.PTE_SANCION_PBC_SERVICER.equals(codEstado)))
            return true;

        return false;
    }

    private boolean calculaResolucionT017FirmaContrato(String codTarea, String codEstado) {
        if(TareaProcedimientoConstants.TramiteComercialT017.CODIGO_T107_FIRMA_CONTRATO.equals(codTarea)
                && (DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO.equals(codEstado)
                || DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO.equals(codEstado)
                || DDEstadoExpedienteBc.PTE_SANCION_PBC_SERVICER.equals(codEstado)))
            return true;

        return false;
    }

    private void lanzarSPPublicaciones(String idTarea, Boolean success){
        try {
            spPublicacionApi.callSpPublicacionAsincrono(Long.parseLong(idTarea), success);
        }catch (Exception e){
            logger.error("Error en el servicio de publicaciones");
            e.printStackTrace();
        }
    }
}
