package es.pfsgroup.plugin.rem.tests.restclient.utils;

import static org.junit.Assert.*;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.DecimalDataTypeFormat;
import es.pfsgroup.plugin.rem.restclient.utils.Converter;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ServicioStockConstantes;

public class ConverterTests {

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

}
