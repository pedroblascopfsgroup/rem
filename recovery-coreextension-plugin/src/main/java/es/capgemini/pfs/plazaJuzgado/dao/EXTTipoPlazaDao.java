package es.capgemini.pfs.plazaJuzgado.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.plazaJuzgado.BuscaPlazaPaginadoDtoInfo;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;

public interface EXTTipoPlazaDao extends AbstractDao<TipoPlaza, Long> {
	
	Page buscarPorDescripcion(BuscaPlazaPaginadoDtoInfo dto);

}
