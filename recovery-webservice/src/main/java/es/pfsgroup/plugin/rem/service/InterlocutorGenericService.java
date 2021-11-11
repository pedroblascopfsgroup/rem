package es.pfsgroup.plugin.rem.service;

import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;
import org.springframework.stereotype.Component;

@Component
public class InterlocutorGenericService {

    public String getIdPersonaHayaClienteHayaByDocumento(String documento){
        MaestroDePersonas maestroDePersonas = new MaestroDePersonas(OfertaApi.CLIENTE_HAYA);
        return maestroDePersonas.getIdPersonaHayaByDocumento(documento);
    }

}
