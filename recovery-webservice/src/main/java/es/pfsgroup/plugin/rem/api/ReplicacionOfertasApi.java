package es.pfsgroup.plugin.rem.api;

import org.springframework.transaction.annotation.Transactional;

public interface ReplicacionOfertasApi {

    void callReplicateOferta(Long idTarea, Boolean success);
}
