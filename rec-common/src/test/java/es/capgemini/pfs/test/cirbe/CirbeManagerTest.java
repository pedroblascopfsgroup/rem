package es.capgemini.pfs.test.cirbe;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.cirbe.CirbeManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class CirbeManagerTest extends CommonTestAbstract{

	@Autowired
	CirbeManager cirbeManager;
	
	@Test
	public final void testGetCirbeData() {
		cirbeManager.getCirbeData(1L, "01/01/2001", "01/01/2001", "01/01/2001");
	}

	@Test
	public final void testGetFechaCirbe() {
		cirbeManager.getFechaCirbe(1L, 1L);
	}

}
