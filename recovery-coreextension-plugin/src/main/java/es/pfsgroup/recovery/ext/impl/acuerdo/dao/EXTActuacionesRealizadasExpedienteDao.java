package es.pfsgroup.recovery.ext.impl.acuerdo.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTActuacionesRealizadasExpediente;

/**
 * @author maruiz
 *
 */
public interface EXTActuacionesRealizadasExpedienteDao extends AbstractDao<EXTActuacionesRealizadasExpediente, Long> {

    /**
     * Busca todas las ActuacionesRealizadasAcuerdo del Acuerdo.
     * @param idAcuerdo Long
     * @return List ActuacionesRealizadasAcuerdo
     */
    List<EXTActuacionesRealizadasExpediente> buscarPorExpediente(Long idExpediente);
}
