package es.capgemini.pfs.test.cache.entity;

import static org.junit.Assert.assertFalse;

import java.util.List;

import org.junit.BeforeClass;
import org.junit.Test;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.test.cache.users.imp.ehcache.UserEhCache;

public class Entity2 extends UserEhCache {

    @BeforeClass
    public static void beforeClass() {
        DbIdContextHolder.setDbId(2L);
    }

    @Test
    public void getClientesListTest() {
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        while (Entity1.load_clientes == false) {
            try {
                Thread.sleep(20);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        List<Cliente> clientes = clienteManager.findClientes(new DtoBuscarClientes());
        for (int i = 0; i < clientes.size(); i++) {
            assertFalse(Entity1.clientes_ids.contains(clientes.get(i).getId()));
        }

    }

    @Test
    public void getPersonasListTest() {
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        while (Entity1.load_personas == false) {
            try {
                Thread.sleep(20);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        List<Persona> personas = personaManager.getList();
        for (int i = 0; i < personas.size(); i++) {
            assertFalse(Entity1.personas_ids.contains(personas.get(i).getId()));
        }
    }

}
