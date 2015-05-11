package es.pfsgroup.commons.utils;

import java.util.Calendar;
import java.util.Date;

public class DateUtils {
	/**
	 * Devuelve la fecha de hoy truncada, con tiempo 0
	 * @return
	 */
	public static Date getTodayWithoutTime() {
		return clearDateTime(new Date());
	}
	
	/**
	 * Trunca la fecha pasada, marca el tiempo a 0
	 * @param fecha
	 * @return
	 */
	public static Date clearDateTime(Date fecha) {
		if (fecha==null)
			return null;
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(fecha);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		
		return cal.getTime();
	}
	
	/**
	 * Agrega un número de dias a la fecha pasada
	 * @param fecha Fecha ha modificar
	 * @param dias Número de días a agregar, puede ser negativos para restar
	 * @return
	 */
	public static Date addDays(Date fecha, int dias) {
		if (fecha==null)
			return null;
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(fecha);
		cal.add(Calendar.DAY_OF_MONTH, dias);
		
		return cal.getTime();
	}
}
