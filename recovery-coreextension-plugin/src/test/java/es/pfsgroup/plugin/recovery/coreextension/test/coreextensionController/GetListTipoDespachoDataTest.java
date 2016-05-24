package es.pfsgroup.plugin.recovery.coreextension.test.coreextensionController;

import static org.junit.Assert.*;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;

/**
 * Tests del m�todo {@link es.pfsgroup.plugin.recovery.coreextension.coreextensionController#getListTipoDespachoData(org.springframework.ui.ModelMap, Long)}
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class GetListTipoDespachoDataTest extends AbstractCoreextensionControllerTest {

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
	public void testGetListTipoDespachoData(){
		
		List<DespachoExterno> listaDespachos = new ArrayList<DespachoExterno>();
		Long idTipoGestor = RandomUtils.nextLong();
		
		when(mockCoreextensionApi.getListDespachos(idTipoGestor)).thenReturn(listaDespachos);
		
		String resultado = coreextensionController.getListTipoDespachoData(modelMap, idTipoGestor, false, false,false, false);
		
		assertEquals(modelMap.get("listadoDespachos"),listaDespachos);
		assertEquals(resultado,"plugin/coreextension/asunto/tipoDespachoJSON");
		
	}

}
