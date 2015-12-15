package es.capgemini.pfs.expediente.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.expediente.model.ExpedientePersona;

/**
 * Clase que agrupa método para la creación y acceso de datos de las
 * Personas del expedientes.
 * @author pajimene
 */

public interface ExpedientePersonaDao extends AbstractDao<ExpedientePersona, Long> {

    /**
     * Obtiene un ExpedienteContrato por los ids del expediente y el contrato.
     * @param idExpediente Long
     * @param idPersona Long
     * @return ExpedienteContrato
     */
    ExpedientePersona get(Long idExpediente, Long idPersona);

    /**
     * Recupera los ExpedientePersona que están incluidos en el ambito y expediente que se envía por parametro.
     * @param idExpediente IDExpediente del que quiero consultar
     * @param ambitoExpediente Ambito del expediente del que quiero consultar
     * @return Listado de ExpedientePersona
     */
    List<ExpedientePersona> getListadoExpedientePersonaAmbito(Long idExpediente, DDAmbitoExpediente ambitoExpediente);
    
    /**
     * Recupera los expedientePersona de cada cliente.
     * @param idPersona
     * @return Listado de String
     */
    List<ExpedientePersona> getListadoExpedientePersonaId(Long idPersona);
}
