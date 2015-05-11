package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verifyZeroInteractions;
import static org.mockito.Mockito.when;

import org.junit.Test;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dto.ADMDtoBusquedaDespachoExterno;

public class FindDespachosExternosTest extends AbstractADMDespachoExternoManagerTest{

	@Test
	public void testEncontrarDespacho() throws Exception{
		// Delegamos completamente al dao
		ADMDtoBusquedaDespachoExterno dto = new ADMDtoBusquedaDespachoExterno();
		Page mockPage = mock(Page.class);
		
		when(despachoExternoDao.findDespachosExternos(dto)).thenReturn(mockPage );
		Page result = admDespachoExternoManager.findDespachosExternos(dto);
		
		assertEquals(mockPage, result);
		verifyZeroInteractions(mockPage);
	}
}
