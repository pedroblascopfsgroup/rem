package es.capgemini.pfs.test.users;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.test.AbstractCommonTest;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * @author Luciano Giavedoni
 */
public class UsuarioTest extends AbstractCommonTest {

    @Autowired
    private UsuarioManager usuarioManager;

    /**
     * Set up.
     */
    @Before
    public void onSetUp() {
        /*cleanDDBB();
        cargarDatosComunes();
        enableHibernateLazyMode();*/
    }

    /**
     * Clean.
     */
    @After
    public void after() {
        /*cleanDDBB();*/
    }

    /**
     * testFindByUsername.
     */
    @Test
    public void testFindByUsername() {
        // Obtenemos la lista de usuarios
        List<Usuario> users = usuarioManager.findByUsername("ADMIN");
        /*  assertNotNull(users);
          assertEquals(users.size(), 1);

          // Validamos las propiedades del usuario 1
          //validarUsuario(users.get(0), "test_user1", "pass_user1", "Alberto", "Ramírez", "Gomez", "aramirez@bancaja.es", true);

          // Validamos las propiedades de la entidad
          assertEquals(users.get(0).getEntidad().getId().intValue(), 1);
          */

    }

    /**
     * testFindByUsername.
     */

    /*
    @Test
    public void testFindByUsernameArray() {
        clearHibernateSession();
        // Obtenemos la lista de usuarios
        Usuario[] users = usuarioManager.findByUsernameArray("user11");
        assertNotNull(users);
        assertEquals(users.length, 1);

        // Validamos las propiedades del usuario 1
        assertEquals(users[0].getUsername(), "user11");
        assertEquals(users[0].getPassword(), "user11");
        assertEquals(users[0].getNombre(), "Alberto");
        assertEquals(users[0].getApellido1(), "Ramírez");
        assertEquals(users[0].getEmail(), "aramirez@bancaja.es");
        assertEquals(users[0].isEnabled(), true);

        // Validamos las propiedades de la entidad
        assertEquals(users[0].getEntidad().getId().intValue(), 1);

    }*/

    /**
     * Obtener oficinal del perfil.
     */

    /*
    @Test
    public void testObtenerOficinasPerfil() {
        List<Usuario> usuarios = usuarioManager.findByUsername("user11");
        List<Oficina> oficinas = usuarioManager.getOficinas(usuarios.get(0));
        assertEquals(oficinas.size(), 6);
    }*/

}
