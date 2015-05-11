package es.pfsgroup.plugin.recovery.config.test.manager.ADMPerfilManager;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.junit.Test;

import es.capgemini.pfs.users.domain.Funcion;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;

public class BuscarFuncionesNoAsocadasAPerfilTest extends AbstractADMPerfilManagerTest{

	@Test
	public void testBuscarFuncionesNoAsociadas(){
		
		List<Funcion> mockListFunciones =  mock(List.class);
		Set<Funcion> setFunciones = new HashSet<Funcion>();
		EXTPerfil mockPerfil = mock(EXTPerfil.class);
		when(funcionDao.getList()).thenReturn(mockListFunciones);
		when(perfilDao.get(1L)).thenReturn(mockPerfil);
		when(mockPerfil.getFunciones()).thenReturn(setFunciones);
		
		List<Funcion> result = manager.listarRestoFunciones(1L);
		
		verify(mockListFunciones).removeAll(setFunciones);
		
		assertEquals(mockListFunciones, result);
	}
}
