package es.capgemini.pfs.test.procedimientoDerivado;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procedimientoDerivado.ProcedimientoDerivadoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class ProcedimientoDerivadoManagerTest extends CommonTestAbstract{
	
	@Autowired
	ProcedimientoDerivadoManager procedimientoDerivadoManager;

	@Test
	public final void testGetList() {
		procedimientoDerivadoManager.getList();
	}

	@Test
	public final void testGet() {
		procedimientoDerivadoManager.get(1L);
	}

}
