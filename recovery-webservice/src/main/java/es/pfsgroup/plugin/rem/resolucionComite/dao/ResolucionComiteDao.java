package es.pfsgroup.plugin.rem.resolucionComite.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankiaDto;

public interface ResolucionComiteDao extends AbstractDao<ResolucionComiteBankia, Long> {


	/**
	 * Recupera una lista de ResolucionComite aplicando el filtro pasado por parámetro
	 * @param resolDto con la información para filtrar
	 * @return Page con las resoluciones de comite.
	 */
	public List<ResolucionComiteBankia> getListaResolucionComite(ResolucionComiteBankiaDto resolDto) throws Exception;
	
	
	
}
