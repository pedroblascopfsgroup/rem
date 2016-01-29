package es.pfsgroup.plugin.recovery.mejoras.asunto.dao.impl;


import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.mejoras.asunto.dao.MEJProcedimientoContratoExpedienteDao;

/**
 * PBO: Introducido para resolver la incidencia UGAS-1369
 * Implementacion de MEJProcedimientoContratoExpedienteDao.
 *
 */
@Repository("MEJProcedimientoContratoExpedienteDao")
public class MEJProcedimientoContratoExpedienteDaoImpl extends AbstractEntityDao<ProcedimientoContratoExpediente, Long> implements
        MEJProcedimientoContratoExpedienteDao {

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
     * Borra previo de los creditos asociados a un ContratoExpediente
     * PBO: Introducido para resolver la incidencia UGAS-1369
     * @param ProcedimientoContratoExpediente procContratoExpediente
     */
    @Transactional(readOnly = true)
    public void borraCreditos(ProcedimientoContratoExpediente procContratoExpediente) {
    	Long idProcedimiento = procContratoExpediente.getProcedimiento().getId();
    	Long idContratoExpediente = procContratoExpediente.getExpedienteContrato().getId();
    	String hqlPrevio = "from Credito cre where cre.idProcedimiento = ? and cre.idContratoExpediente = ?";
        getHibernateTemplate().deleteAll(getHibernateTemplate().find(hqlPrevio, new Object[] { idProcedimiento, idContratoExpediente }));
    }

    /**
     * Borra los ContratoExpediente asociados a un Procedimiento
     * PBO: Deprecado (ya no hace falta)
     * @param idProcedimiento, idContratoExpediente
     */
    //@Deprecated
    @Transactional(readOnly = true)
    private void borraTodosExpedienteContrato(Long idProcedimiento) {
//    	String hqlPrevio = "from Credito cre where cre.idProcedimiento = ?";
//        getHibernateTemplate().deleteAll(getHibernateTemplate().find(hqlPrevio, new Object[] { idProcedimiento }));

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