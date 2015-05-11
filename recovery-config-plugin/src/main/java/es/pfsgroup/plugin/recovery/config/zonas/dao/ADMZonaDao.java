package es.pfsgroup.plugin.recovery.config.zonas.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.zona.model.DDZona;

public interface ADMZonaDao extends AbstractDao<DDZona, Long>{
	

	/**
	 * Devuelve las zonas de un determinado nivel
	 * @param idNivel
	 * @return
	 */
	public List<DDZona> getByNivel(Long idNivel);

}