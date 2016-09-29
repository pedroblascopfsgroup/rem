package es.pfsgroup.plugin.rem.tests.restclient.utils;

import static org.junit.Assert.*;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.codehaus.jackson.map.ser.ArraySerializers;
import org.hibernate.mapping.Collection;
import org.junit.Test;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.DecimalDataTypeFormat;
import es.pfsgroup.plugin.rem.restclient.utils.Converter;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ServicioStockConstantes;
import es.pfsgroup.plugin.rem.tests.restclient.webcom.examples.ExampleDto;
import es.pfsgroup.plugin.rem.tests.restclient.webcom.examples.ExampleSubDto;

public class ConverterTests {
	
	private static final String LISTADO_KEY = "listado";
	private static final String CAMPO_OPCIONAL_KEY = "campoOpcional";
	private static final String CAMPO_OBLIGATORIO_KEY = "campoObligatorio";
	private static final StringDataType CAMPO_OBLIGATORIO = StringDataType.stringDataType(CAMPO_OBLIGATORIO_KEY);
	private static final StringDataType CAMPO_OPCIONAL = StringDataType.stringDataType(CAMPO_OPCIONAL_KEY);
	

	@Test
	public void toDtoMap_formateoDeDoubleDataType() {
		/*
		 * Vamos a convertir un DTO anotado con DecimalDataTypeFormat a Map y
		 * vamos a comprobar que el valor se transforma a String correctamente
		 * formateado según el pattern indicado en la anotación
		 */

		StockDto dto = new StockDto();
		dto.setActualImporte(DoubleDataType.doubleDataType(100.1));
		dto.setLat(DoubleDataType.doubleDataType(1111.333));
		dto.setLng(DoubleDataType.doubleDataType(1234567.1234567890));

		Map<String, Object> resultado = Converter.dtoToMap(dto);

		// Según la definición del DTO es @DecimalDataTypeFormat(decimals=2)
		assertEquals("El float no se ha parseado como se esperaba", "100.10",
				resultado.get(ServicioStockConstantes.ACTUAL_IMPORTE));

		// Según la definición del DTO es @DecimalDataTypeFormat(decimals=8)
		assertEquals("El float no se ha parseado como se esperaba", "1111.33300000",
				resultado.get(ServicioStockConstantes.LAT));

		// Según la definición del DTO es @DecimalDataTypeFormat(decimals=8)
		assertEquals("El float no se ha parseado como se esperaba", "1234567.12345678",
				resultado.get(ServicioStockConstantes.LNG));

	}
	
	@Test
	public void dtoToMap_DTOs_anidados(){
		
		// Creamos la estructura. Un DTO pricipal que contiene 2 DTOs anidados
		ExampleDto dto = new ExampleDto();
		dto.setCampoObligatorio(CAMPO_OBLIGATORIO);
		dto.setCampoOpcional(CAMPO_OPCIONAL);
		
		ExampleSubDto sub1 = new ExampleSubDto();
		ExampleSubDto sub2 = new ExampleSubDto();
		
		sub1.setCampoObligatorio(CAMPO_OBLIGATORIO);
		sub1.setCampoOpcional(CAMPO_OPCIONAL);
		sub2.setCampoObligatorio(CAMPO_OBLIGATORIO);
		sub2.setCampoOpcional(CAMPO_OPCIONAL);
		
		dto.setListado((List<ExampleSubDto>) Arrays.asList(new ExampleSubDto[]{sub1, sub2}));
		
		// Convertimos a MAP
		Map<String, Object> map  = Converter.dtoToMap(dto);
		
		// Comprobamos que existen los valores del DTO principal
		assertEquals(CAMPO_OBLIGATORIO, map.get(CAMPO_OBLIGATORIO_KEY));
		assertEquals(CAMPO_OPCIONAL, map.get(CAMPO_OPCIONAL_KEY));
		
		// Validamos que existe la lista de DTO's
		Object listado = map.get(LISTADO_KEY);
		assertTrue("'listado' debería ser una List", List.class.isAssignableFrom(listado.getClass()));
		
		// Comprobamos el contenido de la lista de DTOs
		List<Map<String, Object>> list = (List<Map<String, Object>>) listado;
		assertEquals("El listado no tiene el tamañao esperado", 2, list.size());
		
		assertTrue("El objeto debería ser un MAP", Map.class.isAssignableFrom(list.get(0).getClass()));
		assertEquals(CAMPO_OBLIGATORIO, list.get(0).get(CAMPO_OBLIGATORIO_KEY));
		assertEquals(CAMPO_OPCIONAL, list.get(0).get(CAMPO_OPCIONAL_KEY));
		
		assertTrue("El objeto debería ser un MAP", Map.class.isAssignableFrom(list.get(1).getClass()));
		assertEquals(CAMPO_OBLIGATORIO, list.get(1).get(CAMPO_OBLIGATORIO_KEY));
		assertEquals(CAMPO_OPCIONAL, list.get(1).get(CAMPO_OPCIONAL_KEY));
		
	}

	@Test
	public void updateObjectFromHashMap_DTOS_anidados(){
		Map<String, Object> mainMap = new HashMap<String, Object>();
		mainMap.put(CAMPO_OBLIGATORIO_KEY, CAMPO_OBLIGATORIO);
		mainMap.put(CAMPO_OPCIONAL_KEY, CAMPO_OPCIONAL);
		
		ArrayList<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		
		HashMap<String, Object> subMap1 = new HashMap<String, Object>();
		subMap1.put(CAMPO_OBLIGATORIO_KEY, CAMPO_OBLIGATORIO);
		subMap1.put(CAMPO_OPCIONAL_KEY, CAMPO_OPCIONAL);
		list.add(subMap1);
		
		HashMap<String, Object> subMap2 = new HashMap<String, Object>();
		subMap2.put(CAMPO_OBLIGATORIO_KEY, CAMPO_OBLIGATORIO);
		subMap2.put(CAMPO_OPCIONAL_KEY, CAMPO_OPCIONAL);
		list.add(subMap2);
		
		mainMap.put(LISTADO_KEY, list);
		
		// Rellenamos el DTO
		ExampleDto dto = new ExampleDto();
		Converter.updateObjectFromHashMap(mainMap, dto, null);
		
		// Comprobamos que el DTO esté relleno
		assertEquals(CAMPO_OBLIGATORIO, dto.getCampoObligatorio());
		assertEquals(CAMPO_OPCIONAL, dto.getCampoOpcional());
		
		assertEquals("El listado no tiene el número de DTO's esperado", 2, dto.getListado().size());
		assertEquals(CAMPO_OBLIGATORIO, dto.getListado().get(0).getCampoObligatorio());
		assertEquals(CAMPO_OPCIONAL, dto.getListado().get(0).getCampoOpcional());
		
		assertEquals(CAMPO_OBLIGATORIO, dto.getListado().get(1).getCampoObligatorio());
		assertEquals(CAMPO_OPCIONAL, dto.getListado().get(1).getCampoOpcional());
	}
}
