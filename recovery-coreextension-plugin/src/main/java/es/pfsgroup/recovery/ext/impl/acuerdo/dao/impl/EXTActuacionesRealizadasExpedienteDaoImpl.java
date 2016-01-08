package es.pfsgroup.recovery.ext.impl.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.ext.impl.acuerdo.dao.EXTActuacionesRealizadasExpedienteDao;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTActuacionesRealizadasExpediente;

/**
 * @author marruiz
 *
 */
@Repository("EXTActuacionesRealizadasExpedienteDao")
public class EXTActuacionesRealizadasExpedienteDaoImpl extends AbstractEntityDao<EXTActuacionesRealizadasExpediente, Long>
        implements EXTActuacionesRealizadasExpedienteDao {

    /**
     * Busca todas las ActuacionesRealizadasAcuerdo del Acuerdo.
     * @param idAcuerdo Long
     * @return List ActuacionesRealizadasAcuerdo
     */
    @SuppressWarnings("unchecked")
    public List<EXTActuacionesRealizadasExpediente> buscarPorExpediente(Long idExpediente) {
        String hql = "select actuacion from EXTActuacionesRealizadasExpediente actuacion, Acuerdo acuerdo "
                + "where acuerdo.actuacionesRealizadas = actuacion and expediente.id = ?";
        return getHibernateTemplate().find(hql, idExpediente);
    }
}