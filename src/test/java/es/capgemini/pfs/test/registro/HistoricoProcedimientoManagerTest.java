package es.capgemini.pfs.test.registro;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.registro.HistoricoProcedimientoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class HistoricoProcedimientoManagerTest extends CommonTestAbstract{
	
	@Autowired
	HistoricoProcedimientoManager historicoProcedimientoManager;

	@Test
	public final void testGetListByProcedimiento() {
		historicoProcedimientoManager.getListByProcedimiento(1L);
	}

}
