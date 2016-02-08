package es.capgemini.pfs.acuerdo.dao;

import java.util.List;

import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author maruiz
 *
 */
public interface ActuacionesRealizadasAcuerdoDao extends AbstractDao<ActuacionesRealizadasAcuerdo, Long> {

    /**
     * Busca todas las ActuacionesRealizadasAcuerdo del Acuerdo.
     * @param idAcuerdo Long
     * @return List ActuacionesRealizadasAcuerdo
     */
    List<ActuacionesRealizadasAcuerdo> buscarPorAcuerdo(Long idAcuerdo);

    /**
     * Devuelve un objeto ActuacionesRealizadasAcuerdo a partir de su identificador único
     * @param guid
     * @return ActuacionesRealizadasAcuerdo
     */
	ActuacionesRealizadasAcuerdo getByGuid(String guid);
}
