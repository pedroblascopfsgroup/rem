package es.pfsgroup.recovery.ext.turnadoProcuradores;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto;

public interface EsquemaTurnadoProcuradorDao extends AbstractDao<EsquemaTurnadoProcurador, Long> {
	
	/**
	 * Recupera el esquema de turnado activo
	 * 
	 * @return Esquema activo vigente
	 */
	EsquemaTurnadoProcurador getEsquemaVigente();
	
	/**
	 * Buscar esquemas de turnado paginados.
	 * 
	 * @param dto con los filtros de búsqueda
	 * 
	 * @return
	 */
	Page buscarEsquemasTurnado(EsquemaTurnadoBusquedaDto dto, Usuario usuLogado);
	
	/**
	 * Asigna un despacho al asunto pasado como parámetro teniendo en cuenta la configuración del esquema de turnado vigente
	 * 
	 * @param prcId
	 */
	void turnarProcurador(Long prcId, String username);

	/**
	 * Cuenta los letrados que hay asignados a estos tipos de turnado.
	 * 
	 * @param codigosCI
	 * @param codigosCC
	 * @param codigosLI
	 * @param codigosLC
	 * @return
	 */
	int cuentaLetradosAsignados(List<String> codigosCI, List<String> codigosCC, List<String> codigosLI, List<String> codigosLC);
	
	/**
	 * Limpia el turnado de todos los despachos activos.
	 * 
	 */
	void limpiarTurnadoTodosLosDespachos();
	
}
