package es.pfsgroup.plugin.rem.tests.restclient.utils;

import static org.junit.Assert.*;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.ParamsList;
import es.pfsgroup.plugin.rem.tests.restclient.webcom.examples.ExampleDto;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

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

	@Test
	public void camposObligatorios_DTOs_anidados() {
		String[] camposObligatorios = WebcomRequestUtils.camposObligatorios(ExampleDto.class);
		// Hay 4 campos anotados con @WebcomRequired en ExampleDto y otro cada
		// uno de los 2
		// ExampleSubDto
		assertEquals("No coincide la cantidad de campos obligatorios", 6, camposObligatorios.length);

		assertTrue("El campo obligado del DTO principal no aparece  correctamente identificado",
				Arrays.asList(camposObligatorios).contains("campoObligatorio"));
		assertTrue("El campo obligado del SubDto no aparece  correctamente identificado",
				Arrays.asList(camposObligatorios).contains("listado1.campoObligatorio"));
		assertTrue("El campo obligado del SubDto no aparece  correctamente identificado",
				Arrays.asList(camposObligatorios).contains("listado2.campoObligatorio"));
	}

	@Test
	public void createRequestJson_DTOs_anidados() {

		// Contenido del DTO principal
		Map<String, Object> dtoPrincipal = new HashMap<String, Object>();
		// Contenido del sub-dto
		Map<String, Object> simpleData = new HashMap<String, Object>();
		// Lista de sub-dtos
		ArrayList<Map<String, Object>> subDtoList = new ArrayList<Map<String, Object>>();

		dtoPrincipal.put("value", "my value");
		// seteamos la lista de sub-dtos en el dto principal
		dtoPrincipal.put("subDtoList", subDtoList);
		// añadimos el contenido de un sub-dto a la lista.
		subDtoList.add(simpleData);
		// seteamos un valor en el sub-dto
		simpleData.put("name", "my name");

		ParamsList paramsList = new ParamsList();
		paramsList.add(dtoPrincipal);

		// Vamos a intentar recuperar el valor del sub-dto
		JSONObject json = WebcomRequestUtils.createRequestJson(paramsList);
		// en el JSON debe existir un array 'data' con un elemento.
		JSONArray data = json.getJSONArray("data");
		// el primer elemento del 'data' debe contener otro array 'subDtoList'
		JSONObject data1 = data.getJSONObject(0);
		assertEquals("'data1' no tiene el estado esperado", "my value", data1.get("value"));
		JSONArray list = data1.getJSONArray("subDtoList");
		// Obtenemos el primer sub-dto
		JSONObject object = list.getJSONObject(0);

		// Comprobamos el estado del sub-dto
		assertEquals("El estado de 'object' no es el esperado", "my name", object.get("name"));
	}

	@Test
	public void createRequestJson_ValoresBooleanos() {
		/*
		 * El propósito de este test es comprobar que no estemos mandando los
		 * 'trues' y 'falses' entrecomillados.
		 * 
		 * Para ello vamso a comprobar que un Objeto Boolean en ParamsList es
		 * devuelto como tal en el JSON.
		 */
		ParamsList paramsList = new ParamsList();
		Map<String, Object> data = new HashMap<String, Object>();
		data.put("bool", Boolean.TRUE);
		paramsList.add(data);
		JSONObject json = WebcomRequestUtils.createRequestJson(paramsList);
		assertTrue("El valor 'bool' no se está mandando como Boolean",
				json.getJSONArray("data").getJSONObject(0).get("bool") instanceof Boolean);
	}

}
