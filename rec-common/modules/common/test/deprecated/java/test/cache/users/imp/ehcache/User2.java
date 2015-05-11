package es.capgemini.pfs.test.cache.users.imp.ehcache;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;

public class User2 extends UserEhCache {

    @Test
    @Override
    public void getPersona() {
        // TODO Auto-generated method stub
        super.getPersona();
    }

    @Test
    @Override
    public void getCliente() {
        // TODO Auto-generated method stub
        super.getCliente();
    }

    @Test
    @Override
    public void getPersonaContratosNoTitular() {
        // TODO Auto-generated method stub
        super.getPersonaContratosNoTitular();
    }

    @Test
    @Override
    public void getClientesList() {
        // TODO Auto-generated method stub
        super.getClientesList();
    }

    @Test
    @Override
    public void getClienteContratos() {
        // TODO Auto-generated method stub
        super.getClienteContratos();
    }

    @Test
    @Override
    public void getPersonasList() {
        // TODO Auto-generated method stub
        super.getPersonasList();
    }

    //Pruebas de sincronizacion entre caches

    @Test
    public void getClienteTest() {
        while (User1.id_new_cliente == null) {
            try {
                Thread.sleep(20);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        assertNotNull(getCliente(User1.id_new_cliente));
    }

}
