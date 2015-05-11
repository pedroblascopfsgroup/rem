package es.capgemini.pfs.test.oficina;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.oficina.OficinaManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class OficinaManagerTest extends CommonTestAbstract{
	
	@Autowired
	OficinaManager oficinaManager;

	@Test
	public final void testGet() {
		oficinaManager.get(1L);
	}

	@Test
	public final void testBuscarPorCodigo() {
		oficinaManager.buscarPorCodigo(1);
	}

}
