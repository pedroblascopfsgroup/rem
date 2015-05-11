package es.capgemini.pfs.core.api.plazaJuzgado;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface PlazaJuzgadoApi {
	
	String BO_CORE_PLAZAJUZGADO_TIPO_PLAZA_BY_DESC = "core.plazaJuzgado.getPlazaByDesc";
	String BO_CORE_PLAZAJUZGADO_FIND_JUZGADO_BY_PLAZA = "core.plazaJuzgado.findJuzgadoByPlaza";
	String BO_CORE_PLAZAJUZGADO_FIND_PLAZA_BY_COD = "core.plazaJuzgado.findPlazaByCod";
	String BO_CORE_PLAZAJUZGADO_LISTA_PLAZAS = "core.plazaJuzgado.listaPlazas";
	String BO_CORE_PLAZAJUZGADO_FIND_JUZGADO_ID_PLAZA = "core.plazaJuzgado.findJuzgadoByIdPlaza";
	

	/**
	 * devuelve una lista paginada para un combo
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(BO_CORE_PLAZAJUZGADO_TIPO_PLAZA_BY_DESC)
	Page buscarPorDescripcion(BuscaPlazaPaginadoDtoInfo dto);

	/**
	 * busca juzgados por código de plaza
	 * @param codigo
	 * @return
	 */
	@BusinessOperationDefinition(BO_CORE_PLAZAJUZGADO_FIND_JUZGADO_BY_PLAZA)
	List<TipoJuzgado> buscaJuzgadosPorPlaza(String codigo);

	/**
	 * busca la página en la que se encuentra el código de la plaza
	 * @param codigo
	 * @return un entero que es el número de la página donde se encuentra el código
	 */
	@BusinessOperationDefinition(BO_CORE_PLAZAJUZGADO_FIND_PLAZA_BY_COD)
	int buscarPorCodigo(String codigo);
	
	/**
	 * lista todas las plazas de juzgados disponibles
	 * @return
	 */
	@BusinessOperationDefinition(BO_CORE_PLAZAJUZGADO_LISTA_PLAZAS)
	List<TipoPlaza> listaPlazas();

	/**
	 * busca juzgados que id de plaza
	 * @param id
	 * @return 
	 */
	@BusinessOperationDefinition(BO_CORE_PLAZAJUZGADO_FIND_JUZGADO_ID_PLAZA)
	List<TipoJuzgado> buscaJuzgadosPorIdPlaza(Long id);
}
