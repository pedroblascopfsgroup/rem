package es.pfsgroup.recovery.ext.impl.expediente.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.dto.DtoBuscarExpedientes;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.users.domain.Usuario;

public interface EXTExpedienteDao extends AbstractDao<Expediente, Long>{

	/**
	 * Busca expedients que contengan un determinado contrato
	 * @param idContrato Contrato que buscamos
	 * @param estados Lista de estados posibles para los expedientes. Si se indica NULL se devuelven todos independientemente del estado
	 * @return
	 */
	List<? extends Expediente> buscaExpedientesConContrato(Long idContrato,
			String[] estados);
	
	 public Page buscarExpedientesPaginado(DtoBuscarExpedientes dtoExpediente,Usuario usuarioLogueado);

	 /**
	  * Devuelve un objeto Expediente a partir de su identificador único global
	  * @param guid
	  * @return Expediente
	  */
	 Expediente getByGuid(String guid);

}
