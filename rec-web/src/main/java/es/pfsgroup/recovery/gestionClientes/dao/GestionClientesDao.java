package es.pfsgroup.recovery.gestionClientes.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;

public interface GestionClientesDao extends AbstractDao<Persona, Long> {
	
	public Long obtenerCantidadDeVencidosUsuario(String codigoGestion, Usuario usuarioLogado);

}
