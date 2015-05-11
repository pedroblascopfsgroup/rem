package es.capgemini.pfs.actitudAptitudActuacion.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.actitudAptitudActuacion.dao.DDPropuestaActuacionDao;
import es.capgemini.pfs.actitudAptitudActuacion.model.DDPropuestaActuacion;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Clase que implementa los métodos de la interfaz DDPropuestaActuacionDao.
 * @author marruiz
 *
 */

@Repository("DDPropuestaActuacionDao")
public class DDPropuestaActuacionDaoImpl extends AbstractEntityDao<DDPropuestaActuacion, Long> implements DDPropuestaActuacionDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDPropuestaActuacion getByCodigo(String codigo) {
        String hql = "from DDPropuestaActuacion propuestaActuacion where propuestaActuacion.codigo = ? and propuestaActuacion.auditoria." + Auditoria.UNDELETED_RESTICTION;
        List<DDPropuestaActuacion> propuestaActuacion = getHibernateTemplate().find(hql, new Object[] { codigo });
        if(propuestaActuacion.size()==0) {
            return null;
        } else if(propuestaActuacion.size()==1) {
            return propuestaActuacion.get(0);
        } else {
            throw new BusinessOperationException("tipoIngreso.error.duplicado");
        }
    }

}
