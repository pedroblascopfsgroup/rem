package es.capgemini.pfs.test.itinerario;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.itinerario.EstadoProcesoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class EstadoProcesoManagerTest extends CommonTestAbstract{
	
	@Autowired
	EstadoProcesoManager estadoProcesoManager;

	@Test
	public final void testGet() {
		estadoProcesoManager.get(1L);
	}

}
