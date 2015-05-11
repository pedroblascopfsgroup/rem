package es.capgemini.pfs.test.procesosJudiciales;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procesosJudiciales.PlazoTareaExternaPlazaManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class PlazoTareaExternaPlazaManagerTest extends CommonTestAbstract{
	
	@Autowired
	PlazoTareaExternaPlazaManager plazoTareaExternaPlazaManager;

	@Test
	public final void testGetByTipoTareaTipoPlazaTipoJuzgado() {
		plazoTareaExternaPlazaManager.getByTipoTareaTipoPlazaTipoJuzgado(1L,1L, 1L);
	}

	@Test
	public final void testGet() {
		plazoTareaExternaPlazaManager.get(1L);
	}

}
