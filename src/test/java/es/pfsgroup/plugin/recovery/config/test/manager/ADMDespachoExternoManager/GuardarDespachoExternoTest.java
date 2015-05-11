package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import static org.mockito.Matchers.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static es.pfsgroup.testfwk.TestData.*;
import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTTipoGestorPropiedad;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dto.ADMDtoDespachoExterno;
import es.pfsgroup.recovery.ext.api.multigestor.EXTDDTipoGestorApi;
import es.pfsgroup.testfwk.FieldCriteria;
import es.pfsgroup.testfwk.TestData;

public class GuardarDespachoExternoTest extends
		AbstractADMDespachoExternoManagerTest {

	@Test
	public void testNuevoDespacho() throws Exception {
		final Long NEW_ID_DESPACHO = 100L;
		ADMDtoDespachoExterno dto = newTestObject(ADMDtoDespachoExterno.class,
				new FieldCriteria("id", null), new FieldCriteria(
						"tipoDespacho", 1L));
		DDTipoDespachoExterno tipoDespacho = newTestObject(DDTipoDespachoExterno.class);

		DespachoExterno mockDespacho = mock(DespachoExterno.class);
		when(despachoExternoDao.createNewDespachoExterno()).thenReturn(
				mockDespacho);
		when(tipoDespachoDao.get(1L)).thenReturn(tipoDespacho);
		when(despachoExternoDao.save(mockDespacho)).thenReturn(NEW_ID_DESPACHO);
		
		addGestoresPropiedad(tipoDespacho.getCodigo());
		
		DespachoExterno result = admDespachoExternoManager.guardaDespachoExterno(dto);

		verify(mockDespacho).setId(NEW_ID_DESPACHO);
		verify(mockDespacho).setDespacho(dto.getDespacho());
		verify(mockDespacho).setTipoDespacho(tipoDespacho);

		verify(despachoExternoDao).save(mockDespacho);
		assertEquals(mockDespacho, result);
	}

	private void addGestoresPropiedad(String codTipoDespacho) {
		List<EXTTipoGestorPropiedad> tiposGestorPropiedad = new ArrayList<EXTTipoGestorPropiedad>();
		when(tipoGestorDao.getByClaveValor(EXTTipoGestorPropiedad.TGP_CLAVE_DESPACHOS_VALIDOS, codTipoDespacho)).thenReturn(tiposGestorPropiedad);
		
		EXTDDTipoGestorApi ddTipoGestorApi = mock(EXTDDTipoGestorApi.class);
		when(proxyMock.proxy(EXTDDTipoGestorApi.class)).thenReturn(ddTipoGestorApi);
		
		EXTDDTipoGestor ddTipoGestor = mock(EXTDDTipoGestor.class);
		when(ddTipoGestorApi.getByCod(anyString())).thenReturn(ddTipoGestor);
		
	}

	@Test
	public void testActualizarDespacho() throws Exception {
		ADMDtoDespachoExterno dto = TestData.newTestObject(
				ADMDtoDespachoExterno.class, new FieldCriteria("tipoDespacho",
						1L));

		DDTipoDespachoExterno tipoDespacho = newTestObject(DDTipoDespachoExterno.class);

		DespachoExterno mockDespacho = mock(DespachoExterno.class);
		when(despachoExternoDao.get(dto.getId())).thenReturn(mockDespacho);
		when(tipoDespachoDao.get(1L)).thenReturn(tipoDespacho);

		addGestoresPropiedad(tipoDespacho.getCodigo());
		
		DespachoExterno result = admDespachoExternoManager.guardaDespachoExterno(dto);

		verify(mockDespacho, never()).setId(anyLong());
		verify(mockDespacho).setDespacho(dto.getDespacho());
		verify(mockDespacho).setTipoDespacho(tipoDespacho);

		verify(despachoExternoDao).saveOrUpdate(mockDespacho);
		assertEquals(mockDespacho, result);
	}

	@Test
	public void testNuevoDespacho_tipoDespachoNoExiste_excepcion() throws Exception {
		ADMDtoDespachoExterno dto = newTestObject(ADMDtoDespachoExterno.class,
				new FieldCriteria("id", null), new FieldCriteria(
						"tipoDespacho", 1L));

		DespachoExterno mockDespacho = mock(DespachoExterno.class);
		when(despachoExternoDao.createNewDespachoExterno()).thenReturn(
				mockDespacho);
		when(tipoDespachoDao.get(1L)).thenReturn(null);
		try {
			admDespachoExternoManager.guardaDespachoExterno(dto);
			fail("Deber�a haberse lanzado una excepci�n");
		} catch (BusinessOperationException e) {
		}

		verify(mockDespacho, never()).setId(anyLong());
		verify(mockDespacho, never()).setDespacho(anyString());
		verify(mockDespacho, never()).setTipoDespacho(
				any(DDTipoDespachoExterno.class));

		verify(despachoExternoDao, never()).save(mockDespacho);
	}
	
	@Test
	public void testActualizarDespacho_tipoDespachoNoExiste_excepcion() throws Exception {
		ADMDtoDespachoExterno dto = TestData.newTestObject(
				ADMDtoDespachoExterno.class, new FieldCriteria("tipoDespacho",
						1L));


		DespachoExterno mockDespacho = mock(DespachoExterno.class);
		when(despachoExternoDao.get(dto.getId())).thenReturn(mockDespacho);
		when(tipoDespachoDao.get(1L)).thenReturn(null);

		try {
			admDespachoExternoManager.guardaDespachoExterno(dto);
			fail("Deber�a haberse lanzado una excepci�n");
		} catch (BusinessOperationException e) {
		}

		verify(mockDespacho, never()).setId(anyLong());
		verify(mockDespacho, never()).setDespacho(anyString());
		verify(mockDespacho, never()).setTipoDespacho(
				any(DDTipoDespachoExterno.class));

		verify(despachoExternoDao,never()).saveOrUpdate(mockDespacho);
	}
}
