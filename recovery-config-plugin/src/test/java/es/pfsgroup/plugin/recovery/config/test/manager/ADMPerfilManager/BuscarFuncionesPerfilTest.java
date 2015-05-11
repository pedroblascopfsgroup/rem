package es.pfsgroup.plugin.recovery.config.test.manager.ADMPerfilManager;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.HashSet;
import java.util.Set;

import org.junit.Test;

import es.capgemini.pfs.users.domain.Funcion;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;

public class BuscarFuncionesPerfilTest extends AbstractADMPerfilManagerTest{

	@Test
	public void testBuscarFuncionesPerfil(){
		Set<Funcion> expected  = new HashSet<Funcion>();
		
		EXTPerfil mockPerfil = mock(EXTPerfil.class);
		when(perfilDao.get(1L)).thenReturn(mockPerfil );
		when(mockPerfil.getFunciones()).thenReturn(expected);
		
		Set<Funcion> result =  manager.buscaFuncionesPerfil(1L);
		
		assertEquals(expected, result);
	}
}
