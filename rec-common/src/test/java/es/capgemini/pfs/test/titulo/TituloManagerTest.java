package es.capgemini.pfs.test.titulo;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.test.CommonTestAbstract;
import es.capgemini.pfs.titulo.TituloManager;

public class TituloManagerTest extends CommonTestAbstract{
	
	@Autowired
	TituloManager tituloManager;

	@Test
	public final void testGetDto() {
		tituloManager.getDto(1L, 1L);
	}

	@Test
	public final void testFindTituloByContratoDtoBuscarContrato() {
		DtoBuscarContrato dtoBuscarContrato = new DtoBuscarContrato();
		dtoBuscarContrato.setId(1L);
		tituloManager.findTituloByContrato(dtoBuscarContrato);
	}

	@Test
	public final void testGetTitulo() {
		tituloManager.getTitulo(1L);
	}

}
