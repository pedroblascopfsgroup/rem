package es.pfsgroup.plugin.recovery.comites.itinerario.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.pfsgroup.plugin.recovery.comites.itinerario.dao.CMTItinerarioDao;

@Repository("CMTItinerarioDao")
public class CMTItinerarioDaoImpl extends AbstractEntityDao<Itinerario, Long> implements CMTItinerarioDao{

}
