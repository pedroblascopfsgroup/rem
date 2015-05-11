package es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dao.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dto.RecobroAgenciaDto;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;

/**
 * 
 * Interfaz de acceso a base de datos para la clase RecobroAgencia
 * @author diana
 *
 */
public interface RecobroAgenciaDao extends AbstractDao<RecobroAgencia, Long>{

	/**
	 * Método que devuelve una página que contiene una lista de objetos RecobroAgencia
	 * Esta lista contendrá la lista de agencias que cumplan los criterios de búsqueda
	 * Si no hay ningún criterio de búsqueda se devolverán todas las agencias dadas de 
	 * alta en la base de datos que no estén borradas (borrado=0)
	 * @param dto
	 * @return pagina que contiene un listado de objetos RecobroAgencia
	 */
	Page buscaAgencias(RecobroAgenciaDto dto);
	
	/**
	 * 
	 * @param idDespacho
	 * @return
	 */
	List<RecobroAgencia> listaAgenciasByDespacho(Long idDespacho);
}
