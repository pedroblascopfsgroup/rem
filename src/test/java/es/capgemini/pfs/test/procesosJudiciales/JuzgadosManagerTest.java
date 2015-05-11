package es.capgemini.pfs.test.procesosJudiciales;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procesosJudiciales.JuzgadosManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class JuzgadosManagerTest extends CommonTestAbstract{
	
	@Autowired
	JuzgadosManager juzgadosManager;

	@Test
	public final void testGetJuzgadosByPlaza() {
		juzgadosManager.getJuzgadosByPlaza("codigoPlaza");
	}

}
