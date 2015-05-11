package es.capgemini.pfs.expediente.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;

public interface ExpedienteContratoDao extends AbstractDao<ExpedienteContrato, Long> {

    /**
     * Obtiene un ExpedienteContrato por los ids del expediente y el contrato.
     * @param idExpediente Long
     * @param idContrato Long
     * @return ExpedienteContrato
     */
    ExpedienteContrato get(Long idExpediente, Long idContrato);

    /**
     * Recupera los ExpedienteContrato que est�n incluidos en el ambito y expediente que se env�a por parametro.
     * @param idExpediente IDExpediente del que quiero consultar
     * @param ambitoExpediente Ambito del expediente del que quiero consultar
     * @return Listado de ExpedienteContrato
     */
    List<ExpedienteContrato> getListadoExpedienteContratoAmbito(Long idExpediente, DDAmbitoExpediente ambitoExpediente);
}