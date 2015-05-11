package es.capgemini.pfs.test.decisionProcedimiento;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.decisionProcedimiento.DecisionProcedimientoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class DecisionProcedimientoManagerTest extends CommonTestAbstract{
	
	@Autowired
	DecisionProcedimientoManager decisionProcedimientoManager;

	@Test
	public final void testGetList() {
		decisionProcedimientoManager.getList(1L);
	}

	@Test
	public final void testGet() {
		decisionProcedimientoManager.get(1L);
	}

	@Test
	public final void testGetInstance() {
		decisionProcedimientoManager.getInstance(1L);
	}

	@Test
	public final void testGetProcedimientosDerivados() {
		decisionProcedimientoManager.getProcedimientosDerivados(1L);
	}

}
