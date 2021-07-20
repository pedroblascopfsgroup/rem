package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.*;
import org.springframework.transaction.annotation.Transactional;

public interface AccionesCaixaApi {

    void accionAprobacion(DtoAccionAprobacionCaixa dto) throws Exception;

    void accionRechazo(DtoAccionRechazoCaixa dto) throws Exception;

    void accionRechazoAvanzaRE(DtoAccionRechazoCaixa dto) throws Exception;

    void accionResultadoRiesgo(DtoAccionResultadoRiesgoCaixa dto);

    void accionArrasAprobadas(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionIngresoFinalAprobado(DtoOnlyExpedienteYOfertaCaixa dto);

    void accionFirmaArrasAprobadas(DtoFirmaArrasAprobadasCaixa dto) throws Exception;

    void accionFirmaContratoAprobada(DtoFirmaContratoAprobadaCaixa dto) throws Exception;

    void accionVentaContabilizada(DtoOnlyExpedienteYOfertaCaixa dto);

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

    void accionIncautacionReservaCont(DtoAccionRechazoCaixa dto);
}
