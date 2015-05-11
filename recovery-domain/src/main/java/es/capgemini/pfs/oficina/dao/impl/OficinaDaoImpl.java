package es.capgemini.pfs.oficina.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.oficina.dao.OficinaDao;
import es.capgemini.pfs.oficina.model.Oficina;

/**
 * Implementacion de OficinaDao.
 *
 */
@Repository("OficinaDao")
public class OficinaDaoImpl extends AbstractEntityDao<Oficina, Long> implements OficinaDao {

	   private static final String BUSCAR_POR_CODIGO = "from Oficina where codigo = ?";
	   private static final String BUSCAR_POR_CODIGO_OFICINA = "from Oficina where codigoOficina = ?";

    /**
     * Busca una oficina por su codigo.
     * @param codigo el codigo de la oficina
     * @return la oficina.
     */
    @SuppressWarnings("unchecked")
    public Oficina buscarPorCodigo(Integer codigo) {
        return null;
    }

	@Override
	public Oficina buscarPorCodigoOficina(Integer codigo) {
        return null;
	}
	
	@Override
	public List<Oficina> damePadresOficina(Long idZonaOficina) {
		return null;
	}
	
	@Override
	public List<Oficina> dameAscendientesOficinaAPartirDeNivel(Long idZonaOficina, Long nivelId) {
		return null;
	}

	@Override
	public Oficina dameAscendientesDirectoAPartirDeNivel(Long idZonaOficina, Long nivelId) {
		return null;
	}
	
}
