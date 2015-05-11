package es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento.dao;

import java.util.Collection;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento.dto.BPRDtoBusquedaProcedimientos;

@SuppressWarnings("rawtypes")
public interface BPRProcedimientoDao extends AbstractDao{

	Page findProcedimientos(Usuario usuarioLogado, BPRDtoBusquedaProcedimientos dto);

	Collection<? extends Persona> getDemandadosInstant(String query, Usuario usuLogado);

}
