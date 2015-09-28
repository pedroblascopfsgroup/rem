package es.pfsgroup.plugin.recovery.arquetipos.itinerario.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.pfsgroup.plugin.recovery.arquetipos.itinerario.dao.ARQItinerarioDao;

@Repository("ARQItinerarioDao")
public class ARQItinerarioDaoImpl extends AbstractEntityDao<Itinerario, Long> implements ARQItinerarioDao {

}
