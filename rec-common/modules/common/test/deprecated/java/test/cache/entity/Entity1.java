package es.capgemini.pfs.test.cache.entity;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.test.cache.users.imp.ehcache.UserEhCache;

public class Entity1 extends UserEhCache {

    public static List personas_ids = new ArrayList();
    public static List clientes_ids = new ArrayList();
    public static boolean load_personas = false;
    public static boolean load_clientes = false;

    @Test
    public void getClientesListTest() {
        List<Cliente> clientes = clienteManager.findClientes(new DtoBuscarClientes());
        for (int i = 0; i < clientes.size(); i++) {
            clientes_ids.add(clientes.get(i).getId());
        }
        load_clientes = true;

    }

    @Test
    public void getPersonasListTest() {
        List<Persona> personas = personaManager.getList();
        for (int i = 0; i < personas.size(); i++) {
            personas_ids.add(personas.get(i).getId());
        }
        load_personas = true;
    }

}
