package es.pfsgroup.plugin.rem.tests.restclient.utils;

import static org.junit.Assert.*;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.junit.Test;

import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;

public class WebcomRequestUtilsTests {

	@Test
	public void testConvertirStringToDate() {
		String str = "2016-01-01T23:00:00";
		try {
			Date date = WebcomRequestUtils.parseDate(str);
			GregorianCalendar cal = new GregorianCalendar();
			cal.setTime(date);
			assertEquals("El año devuelto no es el correcto", 2016, cal.get(Calendar.YEAR));
			assertEquals("El dia devuelto no es el correcto", 1, cal.get(Calendar.DAY_OF_MONTH));
			assertEquals("El mes devuelto no es el correcto", Calendar.JANUARY, cal.get(Calendar.MONTH));
			assertEquals("La hora devuelta no es la correcta", 23, cal.get(Calendar.HOUR_OF_DAY));
		} catch (ParseException e) {
			fail("No se debería haber lanzado ninguna excepción: " + e.getMessage());
		}
	}

}
