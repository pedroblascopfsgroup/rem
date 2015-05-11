package es.capgemini.pfs.asunto.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.asunto.dao.ProcedimientoContratoExpedienteDao;
import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Implementacion de ProcedimientoContratoExpedienteDao.
 *
 */
@Repository("ProcedimientoContratoExpedienteDao")
public class ProcedimientoContratoExpedienteDaoImpl extends AbstractEntityDao<ProcedimientoContratoExpediente, Long> implements
        ProcedimientoContratoExpedienteDao {

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional(readOnly = true)
    public void actualizaCEXProcedimiento(List<ProcedimientoContratoExpediente> list, Long idProcedimiento) {
        borraTodosExpedienteContrato(idProcedimiento);
        saveExpedienteContrato(list);
    }

    /**
     * Borra todos los CEX-PRC de un procedimiento en concreto.
     * @param idProcedimiento
     */
    @Transactional(readOnly = true)
    private void borraTodosExpedienteContrato(Long idProcedimiento) {
        String hql = "from ProcedimientoContratoExpediente pce where pce.procedimiento = ?";
        getHibernateTemplate().deleteAll(getHibernateTemplate().find(hql, new Object[] { idProcedimiento }));
    }

    /**
     * Guarda la relacion entre procedimientos y ExpedienteContrato.
     * @param list
     */
    @Transactional(readOnly = true)
    private void saveExpedienteContrato(List<ProcedimientoContratoExpediente> list) {
        for (ProcedimientoContratoExpediente pce : list) {
            saveOrUpdate(pce);
        }
    }
}
