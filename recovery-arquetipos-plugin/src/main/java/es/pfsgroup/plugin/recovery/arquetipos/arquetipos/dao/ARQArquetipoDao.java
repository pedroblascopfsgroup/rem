package es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dto.ARQDtoBusquedaArquetipo;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQListaArquetipo;

public interface ARQArquetipoDao extends AbstractDao<ARQListaArquetipo, Long>{
	
	/**
	 * Nos crea una nueva instancia de Arquetipo
	 * @return
	 */
	public ARQListaArquetipo createNewArquetipo();
	
	
	/**
	 * Busca arquetipos según los criterios definidos en el DTO
	 * La búsqueda no distingue entre buscar con mayúsculas o con 
	 * minúsculas
	 * @param dto
	 * @return
	 */
	public Page findArquetipo(ARQDtoBusquedaArquetipo dto);
	
	
}
