package es.capgemini.pfs.test.grupoCliente;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.grupoCliente.PersonaGrupoManager;
import es.capgemini.pfs.grupoCliente.dto.DtoPersonasDelGrupo;
import es.capgemini.pfs.test.CommonTestAbstract;

public class PersonaGrupoManagerTest extends CommonTestAbstract{
	
	@Autowired
	PersonaGrupoManager personaGrupoManager;

	@Test
	public final void testGetPersonasGrupo() {
		DtoPersonasDelGrupo dto = new DtoPersonasDelGrupo();
		personaGrupoManager.getPersonasGrupo(dto );
	}

}
