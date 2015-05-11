package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.ActuacionesRealizadasAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author marruiz
 *
 */
@Repository("ActuacionesRealizadasAcuerdoDao")
public class ActuacionesRealizadasAcuerdoDaoImpl extends AbstractEntityDao<ActuacionesRealizadasAcuerdo, Long>
        implements ActuacionesRealizadasAcuerdoDao {

    /**
     * Busca todas las ActuacionesRealizadasAcuerdo del Acuerdo.
     * @param idAcuerdo Long
     * @return List ActuacionesRealizadasAcuerdo
     */
    @SuppressWarnings("unchecked")
    public List<ActuacionesRealizadasAcuerdo> buscarPorAcuerdo(Long idAcuerdo) {
        String hql = "select actuacion from ActuacionesRealizadasAcuerdo actuacion, Acuerdo acuerdo "
                + "where acuerdo.actuacionesRealizadas = actuacion and acuerdo.id = ?";
        return getHibernateTemplate().find(hql, idAcuerdo);
    }
}
