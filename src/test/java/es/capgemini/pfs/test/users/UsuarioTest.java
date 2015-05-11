package es.capgemini.pfs.test.users;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.test.CommonTestAbstract;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Test para probar el correcto funcionamiento del la calse UsuarioManager 
 * 
 * @author lgiavedo
 */
public class UsuarioTest extends CommonTestAbstract {
    

    @Autowired
    private UsuarioManager usuarioManager;

    public static final String ADMIN_USER_NAME = "admin";
    public static final Long ADMIN_USER_ID = 1L;

    /**
     * Test getByUsername
     */
    @Test
    public void testGetByUsername() {
        // Obtenemos el usuario ADMIN
        Usuario user = usuarioManager.getByUsername(ADMIN_USER_NAME);
        assertNotNull(user);
        // Validamos que el nombre es correcto
        assertEquals(user.getUsername(), ADMIN_USER_NAME);
    }

    /**
     * Test findByUsername.
     */
    @Test
    public void testGetById() {
        // Obtenemos la lista de usuarios
        Usuario user = usuarioManager.get(1L);
        assertNotNull(user);
     // Validamos que el nombre es correcto
        assertEquals(user.getUsername(), ADMIN_USER_NAME);
    }
}
