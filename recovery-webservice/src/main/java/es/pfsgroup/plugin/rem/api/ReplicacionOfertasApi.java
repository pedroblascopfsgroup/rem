package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.accionesCaixa.CaixaBcReplicationDataHolder;
import org.springframework.transaction.annotation.Transactional;

public interface ReplicacionOfertasApi {

    void callReplicateOferta(CaixaBcReplicationDataHolder dataHolder, Boolean success);
    void callSPPublicaciones(Long idTarea,Boolean success);
}
