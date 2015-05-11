package es.capgemini.pfs.oficina.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.oficina.model.Oficina;

/**
 * Dao para Oficina.
 *
 */
public interface OficinaDao extends AbstractDao<Oficina, Long> {

    /**
     * Busca una oficina por su codigo.
     * @param codigo el codigo de la oficina
     * @return la oficina.
     */
    Oficina buscarPorCodigo(Integer codigo);
    
    /**
     * Busca una oficina por el campo OFI_CODIGO_OFICINA
     * @param codigo
     * @return
     */
    Oficina buscarPorCodigoOficina(Integer codigo);
    
    
	/**
	 * Recupera el listado de oficinas padres de una oficina.
	 * 
	 * @param idZonaOficina
	 * @return
	 */
	List<Oficina> damePadresOficina(Long idZonaOficina);
	
	/**
	 * Recupera el listado de oficinas padres de una oficina a partir de cierto nivel (considera que el ID de nivel está ordenado de forma ascendente.
	 * 
	 * @param idZonaOficina
	 * @param nivelId
	 * @return
	 */
	List<Oficina> dameAscendientesOficinaAPartirDeNivel(Long idZonaOficina, Long nivelId);

	/**
	 * Recupera la oficina padre directa de una oficina a partir de cierto nivel (considera que el ID de nivel está ordenado de forma ascendente.
	 * 
	 * @param idZonaOficina
	 * @param nivelId
	 * @return
	 */
	Oficina dameAscendientesDirectoAPartirDeNivel(Long idZonaOficina, Long nivelId);
    
}
