package es.pfsgroup.plugin.recovery.mejoras.cliente.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.mejoras.cliente.dto.MEJBuscarClientesDto;

public interface MEJClienteDao {

	public Page findClientesPage(MEJBuscarClientesDto clientes,
			Usuario usuarioLogueado, boolean conCarterizacion, boolean busquedaJerarquizada);

	public String getGestorSolvencias(Long idPersona);

	public Page findClientesPaginated(DtoBuscarClientes clientes,
			Usuario usuarioLogueado);

	public List<Persona> findClientesExcel(MEJBuscarClientesDto clientes,
			Usuario usuarioLogueado, boolean conCarterizacion, boolean busquedaJerarquizada);

	public int buscarClientesPaginadosCount(MEJBuscarClientesDto clientes,
			Usuario usuLogado, boolean conCarterizacion, boolean busquedaJerarquizada);

}
