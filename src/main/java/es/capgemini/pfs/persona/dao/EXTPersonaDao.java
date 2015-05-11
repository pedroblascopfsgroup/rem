package es.capgemini.pfs.persona.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.persona.dto.EXTDtoBuscarClientes;
import es.capgemini.pfs.persona.model.EXTPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;

public interface EXTPersonaDao extends AbstractDao<EXTPersona, Long> {
	
	String BUSQUEDA_PRIMER_TITULAR = "PTIT";

    String BUSQUEDA_TITULARES = "TIT";

    String BUSQUEDA_AVALISTAS = "AVAL";

    String BUSQUEDA_RIESGO_DIRECTO = "riesgoDirecto";
    String BUSQUEDA_RIESGO_INDIRECTO = "riesgoIndirecto";
    String BUSQUEDA_RIESGO_TOTAL = "riesgoTotal";

	Page findClientesProveedorSolvenciaPaginated(EXTDtoBuscarClientes clientes, GestorDespacho gestor);
	
	public String getGestorSolvencias(Long idPersona);
	public Page findClientesPaginated(DtoBuscarClientes clientes,Usuario usuarioLogueado);
	
	/**
     * obtenerCantidadDeVencidosUsuario.
     * @param clientes DTO de búsqueda
     * @param conCarterizacion flag que indica si se quiere utilizar la opción de carterización
     * @param usuarioLogado usuario logado acutal, falla si este es NULL
     * @return cantidad
     */
    Long obtenerCantidadDeVencidosUsuario(DtoBuscarClientes clientes, boolean conCarterizacion, Usuario usuarioLogado);

	List<Persona> findClientesProveedorSolvenciaExcel(EXTDtoBuscarClientes dto, GestorDespacho gestor);

}
