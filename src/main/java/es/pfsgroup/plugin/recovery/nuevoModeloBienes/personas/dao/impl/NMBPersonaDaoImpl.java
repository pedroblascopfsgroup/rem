package es.pfsgroup.plugin.recovery.nuevoModeloBienes.personas.dao.impl;

import java.math.BigDecimal;

import org.hibernate.SQLQuery;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.personas.dao.NMBPersonaDao;

@Repository
public class NMBPersonaDaoImpl extends AbstractEntityDao<Persona, Long> implements NMBPersonaDao{

	@Override
	public Long getListaProcedimientosDePersona(Long idPersona) {
		StringBuffer hql = new StringBuffer();
		
		hql.append(" Select count(*) from PRC_PER pp, PRC_PROCEDIMIENTOS p  ");
		hql.append(" where  p.prc_id = pp.prc_id and p.borrado = 0");
		hql.append(" and pp.per_id =  "+idPersona);
		
		
		SQLQuery q = getSession().createSQLQuery(hql.toString());
		BigDecimal o = (BigDecimal)q.uniqueResult();
		Long cuenta = o.longValue();
		return cuenta;
	}

}
