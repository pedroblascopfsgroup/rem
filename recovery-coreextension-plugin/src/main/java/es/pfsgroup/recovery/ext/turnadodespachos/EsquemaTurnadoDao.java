package es.pfsgroup.recovery.ext.turnadodespachos;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;

public interface EsquemaTurnadoDao extends AbstractDao<EsquemaTurnado, Long> {
	
	/**
	 * Recupera el esquema de turnado activo
	 * 
	 * @return Esquema activo vigente
	 */
	EsquemaTurnado getEsquemaVigente();
	
	/**
	 * Buscar esquemas de turnado paginados.
	 * 
	 * @param dto con los filtros de búsqueda
	 * 
	 * @return
	 */
	Page buscarEsquemasTurnado(EsquemaTurnadoBusquedaDto dto, Usuario usuLogado);

}
