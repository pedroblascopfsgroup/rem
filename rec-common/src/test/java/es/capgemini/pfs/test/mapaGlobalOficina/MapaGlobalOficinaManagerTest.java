package es.capgemini.pfs.test.mapaGlobalOficina;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.mapaGlobalOficina.MapaGlobalOficinaManager;
import es.capgemini.pfs.mapaGlobalOficina.dto.DtoBuscarMapaGlobalOficina;
import es.capgemini.pfs.test.CommonTestAbstract;

public class MapaGlobalOficinaManagerTest extends CommonTestAbstract{
	
	@Autowired
	MapaGlobalOficinaManager mapaGlobalOficinaManager;

	@Test
	public final void testGet() {
		mapaGlobalOficinaManager.get(1L);
	}

	@Test
	public final void testFindDDCriterioAnalisisByCodigo() {
		mapaGlobalOficinaManager.findDDCriterioAnalisisByCodigo("codigo");
	}

	@Test
	public final void testGetCriteriosAnalisis() {
		mapaGlobalOficinaManager.getCriteriosAnalisis();
	}

	@Test
	public final void testBuscar() throws Exception {
		DtoBuscarMapaGlobalOficina dto = new DtoBuscarMapaGlobalOficina();
		mapaGlobalOficinaManager.buscar(dto);
	}

}
