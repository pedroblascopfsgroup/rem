package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule.dbchanges.common;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyVararg;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambioBD;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosBDDao;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.InfoTablasBD;
import es.pfsgroup.plugin.rem.tests.restclient.webcom.examples.ExampleDto;
import es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule.dbchanges.common.utilities.DetectorCambiosEjemplo;

@RunWith(MockitoJUnitRunner.class)
public class DetectorCambiosBDTests {

	private static final StringDataType CAMPO_OBLIGATORIO = StringDataType.stringDataType("campoObligatorio");

	@Mock
	private CambiosBDDao dao;

	@InjectMocks
	private DetectorCambiosEjemplo detector;

	@Test
	public void listPendientes_DTOs_anidados() {

		ArrayList<CambioBD> cambios = new ArrayList<CambioBD>();

		/*
		 * En este ejemplo, el dao va a devolver 3 registros cambiados.
		 * 
		 * Dos de ellos deben agruparse en un mismo DTO (con 2 sub-dtos). El otro debe dar lugar a otro DTO diferente
		 * 
		 */
		// Campos cambiados en el primer resgistro
		Map<String, Object> data1 = new HashMap<String, Object>();
		data1.put("listado.campoObligatorio", CAMPO_OBLIGATORIO);

		// Campos cambiados en el segundo resgistro
		Map<String, Object> data2 = new HashMap<String, Object>();
		data2.put("listado.campoObligatorio", StringDataType.nullStringDataType());
		
		// Campos cambiados en el tercer registro
		Map<String, Object> data3 = new HashMap<String, Object>();

		cambios.add(creaMock(1L, data1));
		cambios.add(creaMock(1L, data2));
		cambios.add(creaMock(2L, data3));

		when(dao.listCambios(any(Class.class), any(InfoTablasBD.class))).thenReturn(cambios);

		List<ExampleDto> lista = detector.listPendientes(ExampleDto.class);

		assertEquals("No se han creado la cantidad de DTOS esperada", 2, lista.size());
		ExampleDto dto = lista.get(0);
		assertEquals(CAMPO_OBLIGATORIO, dto.getCampoObligatorio());
		assertEquals(CAMPO_OBLIGATORIO, dto.getListado().get(0).getCampoObligatorio());
		assertNull(dto.getListado().get(1).getCampoObligatorio().getValue());

	}

	private CambioBD creaMock(long idObjeto, Map<String, Object> data) {
		CambioBD mock = mock(CambioBD.class);
		
		HashMap<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.putAll(data);
		dataMap.put(ExampleDto.GROUP_BY_FIELD, LongDataType.longDataType(idObjeto));
		dataMap.put("campoObligatorio", CAMPO_OBLIGATORIO);
		
		when(mock.getCambios()).thenReturn(dataMap);
		when(mock.getValoresHistoricos((String[]) anyVararg())).thenReturn(new HashMap<String, Object>());
		return mock;
	}
}
