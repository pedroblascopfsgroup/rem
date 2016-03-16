package es.capgemini.pfs.tareaNotificacion;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.tareaNotificacion.dao.FestivoDao;

@Component
public class VencimientoUtils implements ApplicationContextAware {

	public interface PoliticaVencimientoPasado {

		boolean moveTomorrow();

	}

	private static class DefaultPoliticaVencimientoPasado implements
			PoliticaVencimientoPasado {

		@Override
		public boolean moveTomorrow() {
			GregorianCalendar calendar = new GregorianCalendar();
			calendar.setTime(new Date());
			int hour = calendar.get(Calendar.HOUR_OF_DAY);
			return hour >= 8;
		}

	}

	public static enum TipoCalculo {
		TODO, NADA, NO_SALTAR_AGOSTO, FEC_REALIZACION_FIJA, FEC_REALIZACION_FIJA_NO_SALTAR_AGOSTO, PRORROGA
	}

	private static PoliticaVencimientoPasado politicaVencimientoPasado;

	private static ApplicationContext ctx;

	@Autowired
	private FestivoDao festivoDao;

	public static class Resultado implements VencimientoTarea {
		private Date fechaCalculada;
		private Date fechaReal;

		@Override
		public Date getFechaReal() {
			return (Date)fechaReal.clone();
		}

		@Override
		public Date getFechaVencimiento() {
			return (Date)fechaCalculada.clone();
		}
	}

	public void setFestivoDao(FestivoDao dao) {
		festivoDao = dao;
	}

	/**
	 * Calcula la fecha de vencimiento de la tarea a partir de un plazo, a
	 * partir del momento actual
	 * 
	 * @param fechaVenc
	 *            Fecha de vencimiento original
	 * @param tipo
	 *            <ul>
	 *            <li>TODO: Aplica el c�clulo del m�s de Asto, festivos y fines
	 *            de semana</li>
	 *            <li>NADA o null: no aplica ning�n tipo de c�lculo</li>
	 *            </ul>
	 * @return
	 */
	public static Resultado getFecha(long plazo, TipoCalculo tipo) {
		return getFecha(new Date(System.currentTimeMillis() + plazo), tipo);
	}

	/**
	 * Calcula la fecha de vencimiento de la tarea a partir de una fecha dada
	 * 
	 * @param fechaVenc
	 *            Fecha de vencimiento original
	 * @param tipo
	 *            <ul>
	 *            <li>TODO: Aplica el c�clulo del m�s de Asto, festivos y fines
	 *            de semana</li>
	 *            <li>NADA o null: no aplica ning�n tipo de c�lculo</li>
	 *            </ul>
	 * @return
	 */
	public static Resultado getFecha(Date fechaVenc, TipoCalculo tipo) {
		Resultado r = new Resultado();
		if (tipo == null) {
			tipo = TipoCalculo.NADA;
		}
		VencimientoUtils util = (VencimientoUtils) ctx
				.getBean("vencimientoUtils");
		switch (tipo) {
		case TODO:
			r.fechaReal = trataFindes(util.trataFestivos(fechaVenc));
			r.fechaCalculada = trataAgosto(trataVencimientoPasado(r.fechaReal));
			
			break;
		case NO_SALTAR_AGOSTO:
			r.fechaReal = trataFindes(util.trataFestivos(fechaVenc));
			r.fechaCalculada = trataVencimientoPasado(r.fechaReal);
			break;
		case FEC_REALIZACION_FIJA:
			r.fechaReal = fechaVenc;
			r.fechaCalculada = trataAgosto(fechaVenc);
			break;
		case FEC_REALIZACION_FIJA_NO_SALTAR_AGOSTO:
			r.fechaReal = fechaVenc;
			r.fechaCalculada = trataVencimientoPasado(fechaVenc);
			break;
		case PRORROGA:
			r.fechaReal = null;
			r.fechaCalculada = fechaVenc;
			break;
		default:
			r.fechaReal = fechaVenc;
			r.fechaCalculada = trataVencimientoPasado(r.fechaReal);
		}
		cambiaHoraVencimiento(r);
		return r;
	}

	private static void cambiaHoraVencimiento(Resultado r) {
		GregorianCalendar cal = new GregorianCalendar();
		cal.setTime(r.fechaCalculada);
		cal.set(Calendar.HOUR_OF_DAY, 22);
		cal.set(Calendar.MINUTE, 0);
		r.fechaCalculada = cal.getTime();
	}

	private static Date trataVencimientoPasado(Date fechaReal) {
		if (venceEnElPasado(fechaReal)) {
			if (getPoliticaVencimientoPasado().moveTomorrow()) {
				GregorianCalendar calendar = new GregorianCalendar();
				calendar.setTime(new Date());
				calendar.add(Calendar.DAY_OF_YEAR, 1);
				return calendar.getTime();
			} else {
				return new Date();
			}
		} else {
			return fechaReal;
		}
	}

	private static boolean venceEnElPasado(Date fechaReal) {
		return fechaReal.before(new Date());
	}

	private synchronized static PoliticaVencimientoPasado getPoliticaVencimientoPasado() {
		if (politicaVencimientoPasado == null) {
			politicaVencimientoPasado = new DefaultPoliticaVencimientoPasado();
		}
		return politicaVencimientoPasado;
	}

	private static Date trataAgosto(Date fechaVenc) {
		if (fechaVenc == null)
			return null;
		GregorianCalendar cal = new GregorianCalendar();
		cal.setTime(fechaVenc);
		if (cal.get(Calendar.MONTH) == Calendar.AUGUST) {
			cal.add(Calendar.MONTH, 1);
		}
		return cal.getTime();

	}

	private Date trataFestivos(Date fechaVenc) {
		if (fechaVenc == null)
			return null;
		Festivo festivo = festivoDao.buscaFestivo(fechaVenc);
		if (festivo == null) {
			return fechaVenc;
		} else {
			return festivo.siguienteHabil();
		}
	}

	private static Date trataFindes(Date fechaVenc) {
		if (fechaVenc == null)
			return null;
		GregorianCalendar cal = new GregorianCalendar();
		cal.setTime(fechaVenc);

		if (cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY) {
			cal.add(Calendar.DATE, 2);
		} else if (cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
			cal.add(Calendar.DATE, 1);
		}
		return cal.getTime();
	}

	@Override
	public synchronized void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
		ctx = applicationContext;

	}

}
