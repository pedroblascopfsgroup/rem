package es.pfsgroup.plugin.rem.activo.admision.evolucion.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.rem.activo.admision.evolucion.dao.ActivoAgendaEvolucionDao;
import es.pfsgroup.plugin.rem.model.ActivoAgendaEvolucion;

@Repository("ActivoAgendaEvolucionDao")
public class ActivoAgendaEvolucionDaoImpl extends AbstractEntityDao<ActivoAgendaEvolucion, Long> implements ActivoAgendaEvolucionDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoAgendaEvolucion> getListAgendaEvolucionByIdActivo(Long id) {

		HQLBuilder hb = new HQLBuilder(" from ActivoAgendaEvolucion aae");
		hb.appendWhere(" aae.activo.id= " + id);
		hb.orderBy("aae.fechaAgendaEv", "desc");
		
		return (List<ActivoAgendaEvolucion>) getHibernateTemplate().find(hb.toString());
	}

}
