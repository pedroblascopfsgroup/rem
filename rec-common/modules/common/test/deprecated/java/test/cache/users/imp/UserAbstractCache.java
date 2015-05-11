package es.capgemini.pfs.test.cache.users.imp;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.cliente.ClienteManager;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.persona.PersonaManager;
import es.capgemini.pfs.test.cache.CacheAbstractTest;

public class UserAbstractCache extends CacheAbstractTest {

    @Autowired
    public PersonaManager personaManager;

    @Autowired
    public ClienteManager clienteManager;

    public void getPersonasList() {
        personaManager.getList();
    }

    public void getPersona() {
        personaManager.get(1L);
    }

    public void getClientesList() {
        clienteManager.findClientes(new DtoBuscarClientes());
    }

    public void getCliente() {
        clienteManager.get(1L);
    }

    public void getClienteContratos() {
        clienteManager.get(1L).getContratos().size();
    }

    public void getPersonaContratosNoTitular() {
        personaManager.get(1L).getContratosNoTitular();
    }

    public Long saveCliente() {
        Cliente c = Cliente.getNewInstance();
        c.setPersona(personaManager.get(1L));
        return clienteManager.save(c);
    }

    public Cliente getCliente(Long id) {
        return clienteManager.get(id);
    }
}
