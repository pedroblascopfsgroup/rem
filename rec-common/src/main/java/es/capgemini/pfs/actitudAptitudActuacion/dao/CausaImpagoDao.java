package es.capgemini.pfs.actitudAptitudActuacion.dao;

import es.capgemini.devon.hibernate.dao.HibernateDao;
import es.capgemini.pfs.actitudAptitudActuacion.model.DDCausaImpago;

/**
 * Interfase que contiene los métodos de acceso a la entidad CausaImpago.
 * @author mtorrado, marruiz
 *
 */
public interface CausaImpagoDao extends HibernateDao<DDCausaImpago, Long> {

    /**
     * Obtiene el tipo de causa impago por su código.
     * @param codigo String
     * @return CausaImpago
     */
    DDCausaImpago getByCodigo(String codigo);

}
