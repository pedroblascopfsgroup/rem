package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.ActuacionesAExplorarAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSubtipoSolucionAmistosaAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("ActuacionesAExplorarAcuerdoDao")
public class ActuacionesAExplorarAcuerdoDaoImpl extends AbstractEntityDao<ActuacionesAExplorarAcuerdo, Long> implements
        ActuacionesAExplorarAcuerdoDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<ActuacionesAExplorarAcuerdo> getActuacionesAExplorarMarcadasByAcuerdo(Long idAcuerdo) {
        String hql = "select aea from ActuacionesAExplorarAcuerdo aea where aea.acuerdo.id = ?";
        return getHibernateTemplate().find(hql, idAcuerdo);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<DDSubtipoSolucionAmistosaAcuerdo> getSubtiposActivosOMarcadosByAcuerdo(Long idAcuerdo) {
        String hql = "select ssa " + "from DDSubtipoSolucionAmistosaAcuerdo ssa, DDTipoSolucionAmistosa tsa "
                + "where ssa.auditoria.borrado=false and tsa = ssa.ddTipoSolucionAmistosa " + "and (  (ssa.activo=true and tsa.activo=1) "
                + "     or      " + "       ssa.id in ( " + "            select aea.ddSubtipoSolucionAmistosaAcuerdo.id "
                + "            from ActuacionesAExplorarAcuerdo aea " + "            where aea.acuerdo.id = ?" + "        )" + "    )";
        return getHibernateTemplate().find(hql, idAcuerdo);
    }
}
