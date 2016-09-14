package es.pfsgroup.plugin.rem.reserva.dao.impl;


import java.math.BigDecimal;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.reserva.dao.ReservaDao;

@Repository("ReservaDao")
public class ReservaDaoImpl extends AbstractEntityDao<Reserva, Long> implements ReservaDao{
	
	
	@Override
	public Long getNextNumReservaRem() {
		String sql = "SELECT S_RES_NUM_RESERVA.NEXTVAL FROM DUAL";
		return ((BigDecimal) getSession().createSQLQuery(sql).uniqueResult()).longValue();
	}


}
