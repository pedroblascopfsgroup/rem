package es.pfsgroup.plugin.recovery.plazasJuzgados.tipoPlaza.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;

public interface JUZTipoPlazaDao extends AbstractDao<TipoPlaza, Long>{

	TipoPlaza createNewTipoPlaza();

	

}
