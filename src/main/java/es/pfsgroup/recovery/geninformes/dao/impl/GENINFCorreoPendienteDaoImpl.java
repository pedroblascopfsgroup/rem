package es.pfsgroup.recovery.geninformes.dao.impl;

import java.util.Calendar;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.geninformes.dao.GENINFCorreoPendienteDao;
import es.pfsgroup.recovery.geninformes.model.GENINFCorreoPendiente;

@Repository("GENINFCorreoPendienteDao")
public class GENINFCorreoPendienteDaoImpl  extends AbstractEntityDao<GENINFCorreoPendiente, Long> implements GENINFCorreoPendienteDao {

	@Override
	public List<GENINFCorreoPendiente> getCorreosPendientes() {

		HQLBuilder hb = new HQLBuilder("from GENINFCorreoPendiente cpe");
		hb.appendWhere("cpe.procesado=0");
		Calendar inicioHoy = Calendar.getInstance();
		inicioHoy.set(Calendar.HOUR_OF_DAY, 0);
		inicioHoy.set(Calendar.MINUTE, 0);
		inicioHoy.set(Calendar.SECOND, 0);
		inicioHoy.set(Calendar.MILLISECOND, 0);
		
		Calendar finHoy = Calendar.getInstance();
		finHoy.set(Calendar.HOUR_OF_DAY, 23);
		finHoy.set(Calendar.MINUTE, 59);
		finHoy.set(Calendar.SECOND, 59);
		finHoy.set(Calendar.MILLISECOND, 999);

		HQLBuilder.addFiltroBetweenSiNotNull(hb, "cpe.fechaEnvio", inicioHoy.getTime(), finHoy.getTime());
		return HibernateQueryUtils.list(this, hb);

	}

}
