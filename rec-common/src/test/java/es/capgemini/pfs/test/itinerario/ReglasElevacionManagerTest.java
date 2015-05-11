package es.capgemini.pfs.test.itinerario;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.itinerario.ReglasElevacionManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class ReglasElevacionManagerTest extends CommonTestAbstract{
	
	@Autowired
	ReglasElevacionManager reglasElevacionManager;

	@Test
	public final void testFindByTipoAndEstado() {
		reglasElevacionManager.findByTipoAndEstado(1L, 1L);
	}

	@Test
	public final void testGet() {
		reglasElevacionManager.get(1L);
	}

}
