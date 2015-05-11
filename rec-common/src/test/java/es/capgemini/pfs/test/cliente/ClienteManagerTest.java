package es.capgemini.pfs.test.cliente;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.cliente.ClienteManager;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.test.CommonTestAbstract;

public class ClienteManagerTest extends CommonTestAbstract{


	@Autowired
	ClienteManager clienteManager;
	
	@Test
	public final void testFindClientesPaginated() {
		DtoBuscarClientes clientes = new DtoBuscarClientes();
		clientes.setApellido1("MARTIN");
		clienteManager.findClientesPaginated(clientes );
	}

	@Test
	public final void testFindClientes() {
		DtoBuscarClientes clientes = new DtoBuscarClientes();
		clientes.setApellido1("MARTIN");
		clienteManager.findClientes(clientes);
	}

	@Test
	public final void testFindByNameClientes() {
		DtoBuscarClientes clientes = new DtoBuscarClientes();
		clienteManager.findByNameClientes(clientes);
	}

	@Test
	public final void testGet() {
		clienteManager.get(1L);
	}

	@Test
	public final void testGetWithEstado() {
		clienteManager.getWithEstado(1L);
	}

	@Test
	public final void testGetWithContratos() {
		clienteManager.getWithContratos(1L);
	}

	@Test
	public final void testBuscarClientesPorContrato() {
		clienteManager.buscarClientesPorContrato(1L);
	}

	@Test
	public final void testBuscarClientesTitularesPorContrato() {
		clienteManager.buscarClientesTitularesPorContrato(1L);
	}

	@Test
	public final void testFindClienteByContratoPaseId() {
		clienteManager.findClienteByContratoPaseId(1L);
	}

}
