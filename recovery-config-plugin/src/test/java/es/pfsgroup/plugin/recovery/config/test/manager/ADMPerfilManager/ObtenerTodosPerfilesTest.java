package es.pfsgroup.plugin.recovery.config.test.manager.ADMPerfilManager;

import java.util.ArrayList;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import es.capgemini.pfs.users.domain.Perfil;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;

public class ObtenerTodosPerfilesTest extends AbstractADMPerfilManagerTest{
	
	@Test
	public void testBuscarPerfilesTest(){
		
		// Devolvemos directamente lo que nos de el DAO
		List<EXTPerfil> expected = new ArrayList<EXTPerfil>();
		List<EXTPerfil> result = manager.buscaPerfiles();
		
		Assert.assertEquals(expected, result);
	}

}
