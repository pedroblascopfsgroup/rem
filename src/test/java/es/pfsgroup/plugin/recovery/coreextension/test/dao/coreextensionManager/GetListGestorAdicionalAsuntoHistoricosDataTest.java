package es.pfsgroup.plugin.recovery.coreextension.test.dao.coreextensionManager;

import static org.junit.Assert.assertSame;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoHistoricoDao;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsuntoHistorico;

/**
 * Tests del método {@link es.pfsgroup.plugin.recovery.coreextension.dao.coreextensionManager#getListGestorAdicionalAsuntoHistoricosData(Long)}
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class GetListGestorAdicionalAsuntoHistoricosDataTest extends AbstractCoreextensionManagerTest {

	@Mock
	EXTGestorAdicionalAsuntoHistoricoDao mockGestorAdicionalAsuntoHistoricoDao;
	
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
	public void testGetListGestorAdicionalAsuntoHistoricosData(){

		List<EXTGestorAdicionalAsuntoHistorico> listado = new ArrayList<EXTGestorAdicionalAsuntoHistorico>();
		Long idAsunto = RandomUtils.nextLong();
		
		when(mockGestorAdicionalAsuntoHistoricoDao.getListOrderedByAsunto(idAsunto)).thenReturn(listado);
		
		List<EXTGestorAdicionalAsuntoHistorico> result = coreextensionManager.getListGestorAdicionalAsuntoHistoricosData(idAsunto);
		
		assertSame(result, listado);

	}

}
