package es.capgemini.pfs.actitudAptitudActuacion.dao;

import es.capgemini.devon.hibernate.dao.HibernateDao;
import es.capgemini.pfs.actitudAptitudActuacion.model.DDPropuestaActuacion;

/**
 * Interfaz que contiene los métodos de acceso a la entidad DDPropuestaActuacion.
 * @author marruiz
 *
 */
public interface DDPropuestaActuacionDao extends HibernateDao<DDPropuestaActuacion, Long> {

    /**
     * Obtiene el DDPropuestaActuacion por su código.
     * @param codigo String
     * @return DDPropuestaActuacion
     */
    DDPropuestaActuacion getByCodigo(String codigo);

}
