package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.*;
import net.sf.json.JSONObject;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;

public interface AccionesCaixaApi {

    void accionAprobacion(DtoAccionAprobacionCaixa dto) throws Exception;

    void accionRechazo(DtoAccionRechazoCaixa dto) throws Exception;

    Boolean accionRechazoAvanzaRE(DtoAccionRechazoCaixa dto) throws Exception;

    void accionResultadoRiesgo(DtoAccionResultadoRiesgoCaixa dto);

    void accionArrasAprobadas(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionIngresoFinalAprobado(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionFirmaArrasAprobadas(DtoFirmaArrasCaixa dto) throws Exception;

    void accionFirmaContratoAprobada(DtoFirmaContratoCaixa dto) throws Exception;

    void accionVentaContabilizada(DtoAccionVentaContabilizada dto) throws Exception;

    void accionArrasRechazadas(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionArrasPteDoc(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionIngresoFinalRechazado(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionIngresoFinalPdteDoc(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionAprobarModTitulares(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionDevolverArras(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionIncautarArras(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionDevolverReserva(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionIncautarReserva(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionDevolArrasCont(DtoAccionRechazoCaixa dto);

    void accionDevolReservaCont(DtoAccionRechazoCaixa dto);

    void accionIncautacionArrasCont(DtoAccionRechazoCaixa dto);

    void accionRechazoModTitulares(DtoAccionRechazoCaixa dto);

    void accionIncautacionReservaCont(DtoAccionRechazoCaixa dto);

    void accionFirmaArrasRechazadas(DtoFirmaArrasCaixa dto) throws ParseException, Exception;

    void accionFirmaContratoRechazada(DtoFirmaContratoCaixa dto) throws Exception;

    void accionArrasContabilizadas(DtoExpedienteFechaYOfertaCaixa dto) throws ParseException;

    void accionContraoferta(DtoAccionAprobacionCaixa dto) throws Exception;

    void accionScoringBC(DtoAvanzaScoringBC dto) throws Exception;

    Boolean avanzarTareaGenerico(JSONObject dto) throws Exception;
    
    void sendReplicarOfertaAccion(Long numOferta);

    void sendReplicarOfertaAccionesAvanzarTarea(Long idTarea, Boolean success);
}
