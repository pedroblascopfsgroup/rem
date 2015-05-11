package es.pfsgroup.plugin.recovery.coreextension.test.coreextensionController;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertSame;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsuntoHistorico;

/**
 * Tests del método {@link es.pfsgroup.plugin.recovery.coreextension.coreextensionController#getListGestoresAdicionalesHistoricoData(ModelMap, Long)}
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class GetListGestoresAdicionalesHistoricoDataTest extends AbstractCoreextensionControllerTest {

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
	public void testGetListGestoresAdicionalesHistoricoData(){
		
		List<EXTGestorAdicionalAsuntoHistorico> listaGestores = new ArrayList<EXTGestorAdicionalAsuntoHistorico>();
		Long idAsunto = RandomUtils.nextLong();
		
		when(mockCoreextensionApi.getListGestorAdicionalAsuntoHistoricosData(idAsunto)).thenReturn(listaGestores);
		
		String resultado = coreextensionController.getListGestoresAdicionalesHistoricoData(modelMap, idAsunto);
		
		assertSame(modelMap.get("listaGestoresAdicionales"), listaGestores);
		assertEquals(resultado, "plugin/coreextension/multigestor/multiGestorAdicionalDataJSON");
		
	}

}
