package es.capgemini.pfs.test.embargoProcedimiento;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.embargoProcedimiento.EmbargoProcedimientoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class EmbargoProcedimientoManagerTest extends CommonTestAbstract{
	
	@Autowired
	EmbargoProcedimientoManager embargoProcedimientoManager;

	@Test
	public final void testGetList() {
		embargoProcedimientoManager.getList();
	}

	@Test
	public final void testGet() {
		embargoProcedimientoManager.get(1L);
	}

	@Test
	public final void testGetByIdBien() {
		embargoProcedimientoManager.getByIdBien(1L);
	}

	@Test
	public final void testGetInstance() {
		embargoProcedimientoManager.getInstance(1L);
	}

}
