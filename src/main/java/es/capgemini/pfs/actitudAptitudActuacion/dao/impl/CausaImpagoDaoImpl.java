package es.capgemini.pfs.actitudAptitudActuacion.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.actitudAptitudActuacion.dao.CausaImpagoDao;
import es.capgemini.pfs.actitudAptitudActuacion.model.DDCausaImpago;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Clase que implementa los métodos de la interfaz CausaImpagoDao.
 * @author mtorrado
 *
 */

@Repository("CausaImpagoDao")
public class CausaImpagoDaoImpl extends AbstractEntityDao<DDCausaImpago, Long> implements CausaImpagoDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDCausaImpago getByCodigo(String codigo) {
        String hql = "from CausaImpago causaImpago where causaImpago.codigo = ? and causaImpago.auditoria." + Auditoria.UNDELETED_RESTICTION;
        List<DDCausaImpago> causaImpago = getHibernateTemplate().find(hql, new Object[] { codigo });
        if(causaImpago.size()==0) {
            return null;
        } else if(causaImpago.size()==1) {
            return causaImpago.get(0);
        } else {
            throw new BusinessOperationException("causaImpago.error.duplicado");
        }
    }
}
