package es.capgemini.pfs.tareaNotificacion.dao.impl;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.Festivo;
import es.capgemini.pfs.tareaNotificacion.dao.FestivoDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;

@Repository
public class FestivoDaoImpl extends AbstractEntityDao<Festivo, Long>  implements FestivoDao{

	@Override
	public Festivo buscaFestivo(Date fecha) {
		if (fecha == null){
			return null;
		}
		GregorianCalendar cal = new GregorianCalendar();
		cal.setTime(fecha);
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH) + 1;
		int day = cal.get(Calendar.DAY_OF_MONTH);
		
		
		HQLBuilder b = new HQLBuilder("from Festivo");
		b.appendWhere("auditoria.borrado = false");
		b.appendWhere("year = " + year);
		b.appendWhere("month = " + month);
		b.appendWhere(day + " between dayStart and dayEnd");
		
		List<Festivo> festivos = HibernateQueryUtils.list(this, b);
		if (festivos.isEmpty()){
			return null;
		}else{
			return festivos.get(0);
		}
	}

}
