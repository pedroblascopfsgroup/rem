package es.capgemini.pfs.test.comite;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.comite.ComiteManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class ComiteManagerTest extends CommonTestAbstract{

	@Autowired
	ComiteManager comiteManager;
	
	@Test
	public final void testGetComites() {
		comiteManager.getComites();
	}

	@Test
	public final void testGet() {
		comiteManager.get(1L);
	}

	@Test
	public final void testGetActaPDF() {
		comiteManager.getActaPDF(1L);
	}

	@Test
	public final void testFindComitesCurrentUser() {
		comiteManager.findComitesCurrentUser();
	}

	@Test
	public final void testFindSesionesComiteCerradasCurrentUser() {
		comiteManager.findSesionesComiteCerradasCurrentUser();
	}

	@Test
	public final void testGetDto() {
		comiteManager.getDto(1L);
	}

	@Test
	public final void testGetDtoParaSesion() {
		comiteManager.getDtoParaSesion(1L);
	}

	@Test
	public final void testGetWithSessiones() {
		comiteManager.getWithSessiones(1L);
	}

	@Test
	public final void testBuscarComiteParaElevar() {
		comiteManager.buscarComiteParaElevar(1L);
	}

	@Test
	public final void testBuscarComitesDelegar() {
		comiteManager.buscarComitesDelegar(1L);
	}

	@Test
	public final void testGetWithAsistentes() {
		comiteManager.getWithAsistentes(1L);
	}

}
