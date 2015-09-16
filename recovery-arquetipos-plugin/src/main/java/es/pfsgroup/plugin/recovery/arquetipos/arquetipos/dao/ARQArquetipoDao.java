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
	 * Busca arquetipos seg�n los criterios definidos en el DTO
	 * La b�squeda no distingue entre buscar con may�sculas o con 
	 * min�sculas
	 * @param dto
	 * @return
	 */
	public Page findArquetipo(ARQDtoBusquedaArquetipo dto);
	
	
}
