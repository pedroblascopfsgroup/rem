package es.pfsgroup.plugin.recovery.coreextension.test.coreextensionController;

import static org.junit.Assert.*;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;

/**
 * Tests del m�todo {@link es.pfsgroup.plugin.recovery.coreextension.coreextensionController#getListTipoGestorAdicionalData(org.springframework.ui.ModelMap)}
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class GetListTipoGestorAdicionalDataTest extends AbstractCoreextensionControllerTest {

	@Override
	public void childBefore() {

	}

	@Override
	public void childAfter() {

	}
	
	/**
	 * Test general.
	 */
	@Test
	public void testGetListTipoGestorAdicionalData(){
		
		List<EXTDDTipoGestor> listaTipoGestorAdicional = new ArrayList<EXTDDTipoGestor>();
		
		when(mockCoreextensionApi.getListTipoGestorAdicional()).thenReturn(listaTipoGestorAdicional);
		
		String resultado = coreextensionController.getListTipoGestorAdicionalData(modelMap, false, false,false);
		
		assertSame(modelMap.get("listadoGestores"),listaTipoGestorAdicional);
		assertEquals(resultado,"plugin/coreextension/asunto/tipoGestorJSON");
		
	}

}
