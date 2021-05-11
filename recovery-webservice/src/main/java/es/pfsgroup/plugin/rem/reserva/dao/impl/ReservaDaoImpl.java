package es.pfsgroup.plugin.rem.reserva.dao.impl;


import java.math.BigDecimal;
import java.util.Date;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.reserva.dao.ReservaDao;

@Repository("ReservaDao")
public class ReservaDaoImpl extends AbstractEntityDao<Reserva, Long> implements ReservaDao{
	
	
	@Override
	public Long getNextNumReservaRem() {
		String sql = "SELECT S_RES_NUM_RESERVA.NEXTVAL FROM DUAL";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue();
	}
	
	@Override
	public Date getFechaFirmaReservaByIdExpediente(Long idExpediente) {
		String sql = "SELECT RES.RES_FECHA_FIRMA FROM REM01.RES_RESERVAS RES WHERE RES.ECO_ID = :idExpediente" 
				+" AND RES.BORRADO = 0";
		
		return ((Date) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).setParameter("idExpediente", idExpediente).uniqueResult());
	}


}
