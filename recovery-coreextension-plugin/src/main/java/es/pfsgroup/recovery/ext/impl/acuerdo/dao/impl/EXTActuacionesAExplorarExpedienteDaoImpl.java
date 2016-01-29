package es.pfsgroup.recovery.ext.impl.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.model.DDSubtipoSolucionAmistosaAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.ext.impl.acuerdo.dao.EXTActuacionesAExplorarExpedienteDao;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTActuacionesAExplorarExpediente;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("EXTActuacionesAExplorarExpedienteDao")
public class EXTActuacionesAExplorarExpedienteDaoImpl extends AbstractEntityDao<EXTActuacionesAExplorarExpediente, Long> implements
	EXTActuacionesAExplorarExpedienteDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<EXTActuacionesAExplorarExpediente> getActuacionesAExplorarMarcadasByExpediente(Long idExpediente) {
        String hql = "select aee from EXTActuacionesAExplorarExpediente aee where aee.expediente.id = ?";
        return getHibernateTemplate().find(hql, idExpediente);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<DDSubtipoSolucionAmistosaAcuerdo> getSubtiposActivosOMarcadosByExpediente(Long idExpediente) {
        String hql = "select ssa " + "from DDSubtipoSolucionAmistosaAcuerdo ssa, DDTipoSolucionAmistosa tsa "
                + "where ssa.auditoria.borrado=false and tsa = ssa.ddTipoSolucionAmistosa " + "and (  (ssa.activo=true and tsa.activo=1) "
                + "     or      " + "       ssa.id in ( " + "            select aee.ddSubtipoSolucionAmistosaAcuerdo.id "
                + "            from EXTActuacionesAExplorarExpediente aee " + "            where aee.expediente.id = ?" + "        )" + "    )";
        return getHibernateTemplate().find(hql, idExpediente);
    }
}
