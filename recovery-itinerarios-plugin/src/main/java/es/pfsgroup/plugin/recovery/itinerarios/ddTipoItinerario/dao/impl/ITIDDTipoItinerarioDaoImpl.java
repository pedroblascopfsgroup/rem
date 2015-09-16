package es.pfsgroup.plugin.recovery.itinerarios.ddTipoItinerario.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoItinerario.dao.ITIDDTipoItinerarioDao;

@Repository("ITIDDTipoItinerarioDao")
public class ITIDDTipoItinerarioDaoImpl extends AbstractEntityDao<DDTipoItinerario, Long> implements ITIDDTipoItinerarioDao {

}
