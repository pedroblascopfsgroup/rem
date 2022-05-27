package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.*;
import net.sf.json.JSONObject;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;

public interface AccionesCaixaApi {

    Boolean accionAprobacion(DtoAccionAprobacionCaixa dto) throws Exception;

    boolean accionRechazo(DtoAccionRechazoCaixa dto) throws Exception;

    Boolean accionRechazoAvanzaRE(DtoAccionRechazoCaixa dto) throws Exception;

    void accionResultadoRiesgo(DtoAccionResultadoRiesgoCaixa dto) throws Exception;

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

    @Transactional
    void accionDevolverArras(DtoOnlyExpedienteOfertaCaixaYFecha dto) throws ParseException;

    void accionIncautarArras(DtoOnlyExpedienteOfertaCaixaYFecha dto) throws ParseException;

    void accionDevolArrasCont(DtoAccionRechazoCaixa dto) throws ParseException;

    void accionIncautacionArrasCont(DtoAccionRechazoCaixa dto);

    void accionRechazoModTitulares(DtoAccionRechazoCaixa dto);

    void accionFirmaArrasRechazadas(DtoFirmaArrasCaixa dto) throws ParseException, Exception;

    void accionFirmaContratoRechazada(DtoFirmaContratoCaixa dto) throws Exception;

    void accionArrasContabilizadas(DtoExpedienteFechaYOfertaCaixa dto) throws ParseException;

    boolean accionContraoferta(DtoAccionAprobacionCaixa dto) throws Exception;

    void accionScoringBC(DtoAvanzaScoringBC dto) throws Exception;

    Boolean avanzarTareaGenerico(JSONObject dto) throws Exception;
    
    void sendReplicarOfertaAccion(Long numOferta);

    void callSPPublicaciones(Long idTarea, Boolean success);

    @Transactional
    void sendReplicarOfertaByOferta(Long idOferta);

    @Transactional
    boolean modificaEstadoDeposito(String codEstado, Long idOferta);

	void accionIngresoDeposito(Long numOferta);

    @Transactional
    boolean incautaODevuelveDeposito(String codEstado, Long numOferta);
}
