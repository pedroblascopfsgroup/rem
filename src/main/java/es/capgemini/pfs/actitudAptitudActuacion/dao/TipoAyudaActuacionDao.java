package es.capgemini.pfs.actitudAptitudActuacion.dao;

import es.capgemini.devon.hibernate.dao.HibernateDao;
import es.capgemini.pfs.actitudAptitudActuacion.model.DDTipoAyudaActuacion;

/**
 * Interfase que contiene los métodos de acceso a la entidad TipoAyudaActuacion.
 * @author mtorrado, marruiz
 *
 */
public interface TipoAyudaActuacionDao extends HibernateDao<DDTipoAyudaActuacion, Long> {
    /**
     * Obtiene el tipo de ayuda actuación por su código.
     * @param codigo String
     * @return TipoAyudaActuacion
     */
    DDTipoAyudaActuacion getByCodigo(String codigo);
}
