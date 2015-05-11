package es.capgemini.pfs.test.security;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.security.UsuarioSecurityManager;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.capgemini.pfs.test.CommonTestAbstract;

public class UsuarioSecurityManagerTest extends CommonTestAbstract{
	
	@Autowired
	UsuarioSecurityManager usuarioSecurityManager;

	@Test
	public final void testGetByUsername() {
		usuarioSecurityManager.getByUsername("admin");
	}

	@Test
	public final void testGetByUsernameAndEntity() {
		usuarioSecurityManager.getByUsernameAndEntity("admin","Caja Canarias");
	}

	@Test
	public final void testGet() {
		usuarioSecurityManager.get(1L);
	}

	@Test
	public final void testGetUsuarioLogado() {
		usuarioSecurityManager.getUsuarioLogado();
	}

	@Test
	public final void testGetAuthorities() {
		UsuarioSecurity usuario = usuarioSecurityManager.get(1L);
		usuarioSecurityManager.getAuthorities(usuario);
	}

}
