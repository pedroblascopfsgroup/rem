package es.pfsgroup.plugin.rem.service;

import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;
import org.springframework.stereotype.Component;

@Component
public class InterlocutorGenericService {

    private MaestroDePersonas maestroDePersonas = new MaestroDePersonas(OfertaApi.CLIENTE_HAYA);


    public String getIdPersonaHayaClienteHayaByDocumento(String documento){
        return maestroDePersonas.getIdPersonaHayaByDocumento(documento);
    }

}
