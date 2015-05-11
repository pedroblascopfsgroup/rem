package es.pfsgroup.plugin.recovery.coreextension.test.dao.coreextensionManager;

import static org.junit.Assert.assertSame;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.dao.abm.Order;

/**
 * Tests del m�todo {@link es.pfsgroup.plugin.recovery.coreextension.dao.coreextensionManager#getListTipoGestorAdicional()}
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class GetListTipoGestorAdicionalTest extends AbstractCoreextensionManagerTest {

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
	public void testGetListTipoGestorAdicional(){

		List<EXTDDTipoGestor> listado = new ArrayList<EXTDDTipoGestor>();
		
		when(mockGenericDao.getListOrdered(eq(EXTDDTipoGestor.class), any(Order.class), any(Filter.class))).thenReturn(listado);
		
		List<EXTDDTipoGestor> result = coreextensionManager.getListTipoGestorAdicional();
		
		assertSame(result, listado);
		
	}

}
