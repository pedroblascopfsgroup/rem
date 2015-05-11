package es.pfsgroup.plugin.recovery.masivo.utils;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

public class MSVUtils {
	
	
	public static Double getDouble(String valor) {
		DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("es"));
		DecimalFormat format = new DecimalFormat("0.#", symbols);
		String valorRpl = valor.replace(".", String.valueOf(symbols.getDecimalSeparator()));
		valorRpl = valorRpl.replace(",", String.valueOf(symbols.getDecimalSeparator()));
		try {
			return format.parse((valorRpl)).doubleValue();
		} catch (Exception ex) {
			return null;
		}
//		try {
//			String valorRpl = valor.replaceAll(",", ".");			
//			return Double.valueOf(valorRpl);
//		} catch (Exception ex) {
//			return null;
//		}
	}
	
	public static BigDecimal getBigDecimal(String valor) {		
		try {
			return BigDecimal.valueOf(getDouble(valor));
		} catch (Exception ex) {
			return null;
		}
//		try {
//			String valorRpl = valor.replaceAll(",", ".");
//			return BigDecimal.valueOf(getDouble(valorRpl));
//		} catch (Exception ex) {
//			return null;
//		}
	}
	
	/**
	 * Devuelve un String con el formato de fecha actual concatenando lo que se pase en la variable concat
	 * 
	 * @param format formato de la fecha
	 * @param concat String que se concatenará a la fecha
	 * @return
	 */
	public static String getNow(String format, String concat) {
		Calendar currentDate = Calendar.getInstance(); //Get the current date
		SimpleDateFormat formatter= new SimpleDateFormat(format);
		String dateNow = formatter.format(currentDate.getTime());
		
		return dateNow.concat(concat);
	}
	
	/**
	 * Devuelve un String con el formato de fecha actual
	 * 
	 * @param format formato de la fecha
	 * @return
	 */
	public static String getNow(String format) {
		return getNow(format, "");
	}
	
}
