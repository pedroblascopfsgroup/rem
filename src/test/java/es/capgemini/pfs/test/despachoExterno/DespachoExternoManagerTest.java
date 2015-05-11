package es.capgemini.pfs.test.despachoExterno;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.despachoExterno.DespachoExternoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class DespachoExternoManagerTest extends CommonTestAbstract{
	
	@Autowired
	DespachoExternoManager despachoExternoManager;

	@Test
	public final void testGetDespachosExternos() {
		despachoExternoManager.getDespachosExternos();
	}

	@Test
	public final void testGetGestoresDespacho() {
		despachoExternoManager.getGestoresDespacho(1L);
	}

	@Test
	public final void testGetSupervisoresDespacho() {
		despachoExternoManager.getSupervisoresDespacho(1L);
	}

	@Test
	public final void testGetAllSupervisores() {
		despachoExternoManager.getAllSupervisores();
	}

}
