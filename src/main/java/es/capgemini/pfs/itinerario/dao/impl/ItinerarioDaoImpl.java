package es.capgemini.pfs.itinerario.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.dao.ItinerarioDao;
import es.capgemini.pfs.itinerario.model.Itinerario;

/**
 * @author Nicolás Cornaglia
 */
@Repository("ItinerarioDao")
public class ItinerarioDaoImpl extends AbstractEntityDao<Itinerario, Long> implements ItinerarioDao {

}
