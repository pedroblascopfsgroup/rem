package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.DtoAccionAprobacionCaixa;
import es.pfsgroup.plugin.rem.model.DtoAccionRechazoCaixa;
import org.springframework.transaction.annotation.Transactional;

public interface AccionesCaixaApi {

    void accionAprobacion(DtoAccionAprobacionCaixa dto) throws Exception;

    void accionRechazo(DtoAccionRechazoCaixa dto) throws Exception;

    void accionRechazoAvanzaRE(DtoAccionRechazoCaixa dto) throws Exception;
}
