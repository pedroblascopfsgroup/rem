package es.pfsgroup.plugin.recovery.config.test.manager.ADMFuncionManager;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import org.junit.Test;

public class GetListTest extends AbstractADMFuncionManagerTest{

	
	@Test
	public void testGetList() throws Exception {
		manager.getList();
		verify(dao,times(1)).getList();
		verifyNoMoreInteractions(dao);
	}
}
