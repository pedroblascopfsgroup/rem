package es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado.dto.JUZDtoBusquedaPlaza;


public interface JUZJuzgadoDao extends AbstractDao<TipoJuzgado, Long>{

	Page findJuzgados(JUZDtoBusquedaPlaza dto);

	TipoJuzgado createNewJuzgado();

	List<TipoJuzgado> findByPlaza(Long idPlaza);


}
