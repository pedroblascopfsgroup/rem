package es.capgemini.pfs.actitudAptitudActuacion.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.actitudAptitudActuacion.dao.TipoAyudaActuacionDao;
import es.capgemini.pfs.actitudAptitudActuacion.model.DDTipoAyudaActuacion;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Clase que implementa los métodos de la interfaz TipoAyudaActuacionDao.
 * @author mtorrado
 *
 */

@Repository("TipoAyudaActuacionDao")
public class TipoAyudaActuacionDaoImpl extends AbstractEntityDao<DDTipoAyudaActuacion, Long> implements TipoAyudaActuacionDao {
    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDTipoAyudaActuacion getByCodigo(String codigo) {
        String hql = "from DDTipoAyudaActuacion tipoAyudaActuacion where tipoAyudaActuacion.codigo = ? and tipoAyudaActuacion.auditoria." + Auditoria.UNDELETED_RESTICTION;
        List<DDTipoAyudaActuacion> tipoAyudaActuacion = getHibernateTemplate().find(hql, new Object[] { codigo });
        if(tipoAyudaActuacion.size()==0) {
            return null;
        } else if(tipoAyudaActuacion.size()==1) {
            return tipoAyudaActuacion.get(0);
        } else {
            throw new BusinessOperationException("tipoAyudaActuacion.error.duplicado");
        }
    }
}
