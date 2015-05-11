package es.capgemini.pfs.expediente.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.dao.ExpedienteContratoDao;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;

/**
 * Clase que agrupa método para la creación y acceso de datos de los
 * contratos del expedientes.
 *
 * @author jbosnjak
 */
@Repository("ExpedienteContratoDao")
public class ExpedienteContratoDaoImpl extends AbstractEntityDao<ExpedienteContrato, Long> implements ExpedienteContratoDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public ExpedienteContrato get(Long idExpediente, Long idContrato) {
        String hql = "from ExpedienteContrato cex where cex.expediente.id = ? and cex.contrato.id = ? and cex.auditoria."
                + Auditoria.UNDELETED_RESTICTION;
        List<ExpedienteContrato> l = getHibernateTemplate().find(hql, new Object[] { idExpediente, idContrato });
        if (l.size() == 0) { return null; }
        return l.get(0);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<ExpedienteContrato> getListadoExpedienteContratoAmbito(Long idExpediente, DDAmbitoExpediente ambitoExpediente) {
        String[] vAmbitos = DDAmbitoExpediente.getListadoAmbitos(ambitoExpediente);
        if (vAmbitos == null) { return null; }

        boolean isSeparador = false;
        StringBuilder listadoCampos = new StringBuilder();
        for (String amb : vAmbitos) {
            if (isSeparador) {
                listadoCampos.append(",");
            }
            isSeparador = true;

            listadoCampos.append("'" + amb + "'");
        }

        StringBuilder hql = new StringBuilder();
        hql.append("select cex from ExpedienteContrato cex, Movimiento m, Contrato c ");
        hql.append(" where cex.expediente.id = ? and cex.auditoria.borrado = false ");
        hql.append(" and cex.contrato.id = c.id ");
        hql.append(" and m.contrato.id = c.id and m.fechaExtraccion = c.fechaExtraccion ");
        hql.append(" and m.riesgo > 0 ");
        hql.append(" and cex.ambitoExpediente.codigo IN (" + listadoCampos.toString() + ")");

        return getHibernateTemplate().find(hql.toString(), new Object[] { idExpediente });
    }
}
