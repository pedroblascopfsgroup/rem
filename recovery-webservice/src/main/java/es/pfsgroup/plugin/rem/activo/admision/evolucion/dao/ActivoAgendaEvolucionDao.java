package es.pfsgroup.plugin.rem.activo.admision.evolucion.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoAgendaEvolucion;

public interface ActivoAgendaEvolucionDao extends AbstractDao<ActivoAgendaEvolucion, Long> {
	
	public List<ActivoAgendaEvolucion> getListAgendaEvolucionByIdActivo(Long id);

}
