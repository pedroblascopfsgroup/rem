package es.pfsgroup.recovery.panelcontrol.letrados.vistas.zona.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.zona.dao.PCZonaDao;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.zona.model.PCZona;

@Repository
public class PCZonaDaoImpl extends AbstractEntityDao<PCZona, Long> implements PCZonaDao{

	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<PCZona> getListaZonas(Long nivel) {
		StringBuffer query = new StringBuffer();
		query.append(" select z from PCZona z where  ");
		query.append(" z.id ="+nivel);
		return getSession().createQuery(query.toString()).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<PCZona> getListaZonas(Long nivel, String cod) {
		StringBuffer query = new StringBuffer();
		query.append(" select z from PCZona z where  ");
		query.append(" z.id ="+nivel);
		query.append(" and z.codigo like '"+cod+"%'");
		return getSession().createQuery(query.toString()).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<PCZona> getLetrados(Long nivel, String cod) {
		StringBuffer query = new StringBuffer();
		query.append(" select z from PCZona z where  ");
		query.append(" z.codigo like '"+cod+"'");
		return getSession().createQuery(query.toString()).list();
	}


}
