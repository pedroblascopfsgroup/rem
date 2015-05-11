package es.pfsgroup.plugin.recovery.config.test.manager.ADMPerfilManager;

import static org.junit.Assert.*;
import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.Test;

import es.capgemini.pfs.users.domain.Perfil;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;
import es.pfsgroup.testfwk.TestData;
public class ObtenerPerfilTest extends AbstractADMPerfilManagerTest{

	
	@Test
	public void testObtenerPerfil() throws Exception{
		EXTPerfil expected = TestData.newTestObject(EXTPerfil.class, null);
		when(perfilDao.get(1L)).thenReturn(expected);
		
		Perfil result = manager.getPerfil(1L);
		verify(perfilDao).get(1L);
		assertSame(expected, result);
	}
	
	@Test
	public void testNoExistePerfil(){
		when(perfilDao.get(1L)).thenReturn(null);
		
		Perfil result = manager.getPerfil(1L);
		verify(perfilDao).get(1L);
		assertNull(result);
	}
}
