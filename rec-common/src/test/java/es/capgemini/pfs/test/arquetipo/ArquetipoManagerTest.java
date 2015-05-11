package es.capgemini.pfs.test.arquetipo;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.arquetipo.ArquetipoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class ArquetipoManagerTest extends CommonTestAbstract{
	
	@Autowired
	ArquetipoManager arquetipoManager;

	@Test
	public final void testGet() {
		arquetipoManager.get(1L);
	}

	@Test
	public final void testGetWithEstado() {
		arquetipoManager.getWithEstado(1L);
	}

	@Test
	public final void testGetList() {
		arquetipoManager.getList();
	}

}
