package es.capgemini.pfs.test.ingreso;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.ingreso.IngresoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class IngresoManagerTest extends CommonTestAbstract{
	
	@Autowired
	IngresoManager ingresoManager;

	@Test
	public final void testGetIngreso() {
		ingresoManager.getIngreso(1L);
	}

	@Test
	public final void testGetTipoIngresoByCodigo() {
		ingresoManager.getTipoIngresoByCodigo("codigo");
	}

	@Test
	public final void testGetListTipoIngreso() {
		ingresoManager.getListTipoIngreso();
	}

}
