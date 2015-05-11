package es.capgemini.pfs.expediente.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;

/**
 * Clase que agrupa método para la creación y acceso de datos de los
 * Contratos del expedientes.
 * @author jbosnjak
 */

public interface ExpedienteContratoDao extends AbstractDao<ExpedienteContrato, Long> {

    /**
     * Obtiene un ExpedienteContrato por los ids del expediente y el contrato.
     * @param idExpediente Long
     * @param idContrato Long
     * @return ExpedienteContrato
     */
    ExpedienteContrato get(Long idExpediente, Long idContrato);

    /**
     * Recupera los ExpedienteContrato que están incluidos en el ambito y expediente que se envía por parametro.
     * @param idExpediente IDExpediente del que quiero consultar
     * @param ambitoExpediente Ambito del expediente del que quiero consultar
     * @return Listado de ExpedienteContrato
     */
    List<ExpedienteContrato> getListadoExpedienteContratoAmbito(Long idExpediente, DDAmbitoExpediente ambitoExpediente);
}
