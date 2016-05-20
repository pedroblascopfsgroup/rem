package es.pfsgroup.plugin.recovery.config.delegaciones.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.config.delegaciones.dto.DelegacionDto;
import es.pfsgroup.plugin.recovery.config.delegaciones.model.Delegacion;

public interface DelegacionDao extends AbstractDao<Delegacion, Long>{

	/**
	 * 
	 * @param DelegacionDto dto
	 * @return Page
	 */
	public Page getDelegaciones(DelegacionDto dto);

}
