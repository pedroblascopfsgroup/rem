package es.capgemini.pfs.test.bien;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.bien.BienManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class BienManagerTest extends CommonTestAbstract{

	@Autowired
	BienManager bienManager;
	
	@Test
	public final void testGet() {
		bienManager.get(1L);
	}

	@Test
	public final void testGetList() {
		bienManager.getList();
	}

	@Test
	public final void testGetListFull() {
		bienManager.getListFull();
	}

}
