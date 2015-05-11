package es.capgemini.pfs.test.cache.users.imp.nocache;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;

public class User1 extends UserNoCache {

    public static Long id_new_cliente;

    @Test
    @Override
    public void getCliente() {
        // TODO Auto-generated method stub
        super.getCliente();
    }

    @Test
    @Override
    public void getClienteContratos() {
        // TODO Auto-generated method stub
        super.getClienteContratos();
    }

    @Test
    @Override
    public void getClientesList() {
        // TODO Auto-generated method stub
        super.getClientesList();
    }

    @Test
    @Override
    public void getPersona() {
        // TODO Auto-generated method stub
        super.getPersona();
    }

    @Test
    @Override
    public void getPersonaContratosNoTitular() {
        // TODO Auto-generated method stub
        super.getPersonaContratosNoTitular();
    }

    @Test
    @Override
    public void getPersonasList() {
        // TODO Auto-generated method stub
        super.getPersonasList();
    }

    //Pruebas de sincronizacion entre caches

    @Test
    public void saveClienteTest() {
        id_new_cliente = super.saveCliente();
        assertNotNull(id_new_cliente);
    }

}
