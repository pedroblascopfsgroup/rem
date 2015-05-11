package es.capgemini.pfs.ingreso.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.ingreso.dao.DDTipoIngresoDao;
import es.capgemini.pfs.ingreso.model.DDTipoIngreso;



/**
 * @author Mariano Ruiz
 */
@Repository("DDTipoIngresoDao")
public class DDTipoIngresoDaoImpl extends AbstractEntityDao<DDTipoIngreso, Long> implements DDTipoIngresoDao {
    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDTipoIngreso getByCodigo(String codigo) {
        String hql = "from DDTipoIngreso tipoIngreso where tipoIngreso.codigo = ? and tipoIngreso.auditoria." + Auditoria.UNDELETED_RESTICTION;
        List<DDTipoIngreso> tipoIngreso = getHibernateTemplate().find(hql, new Object[] { codigo });
        if(tipoIngreso.size()==0) {
            return null;
        } else if(tipoIngreso.size()==1) {
            return tipoIngreso.get(0);
        } else {
            throw new BusinessOperationException("tipoIngreso.error.duplicado");
        }
    }
}
