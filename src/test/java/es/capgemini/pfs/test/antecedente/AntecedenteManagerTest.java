package es.capgemini.pfs.test.antecedente;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.antecedente.AntecedenteManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class AntecedenteManagerTest extends CommonTestAbstract {

	@Autowired
	AntecedenteManager antecedenteManager;
	
	@Test
	public final void testGet() {
		antecedenteManager.get(1L);
	}

}
