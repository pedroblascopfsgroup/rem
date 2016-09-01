package es.pfsgroup.plugin.rem.expedienteComercial.dao;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

public interface ExpedienteComercialDao extends AbstractDao<ExpedienteComercial, Long> {

	/**
	 * Recupera una lista de compradores de un expediente comercial
	 * @param idExpediente
	 * @param webDto
	 * @return
	 */
	public Page getCompradoresByExpediente(Long idExpediente, WebDto webDto);
}
