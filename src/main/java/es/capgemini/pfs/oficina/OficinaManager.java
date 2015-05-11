package es.capgemini.pfs.oficina;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.oficina.api.OficinaApi;
import es.capgemini.pfs.oficina.dao.OficinaDao;
import es.capgemini.pfs.oficina.model.Oficina;

/**
 * Manager para oficinas.
 * @author aesteban
 *
 */
@Service
public class OficinaManager implements OficinaApi {

    @Autowired
    private OficinaDao oficinaDao;


    /**
     * @param id oficina
     * @return Oficina
     */
    @Override
    @BusinessOperation(ComunBusinessOperation.BO_OFICINA_MGR_GET)
    public Oficina get(Long id) {
        return oficinaDao.get(id);
    }
    /**
     * Busca una oficina por su codigo.
     * @param codigo el codigo de la oficina
     * @return la oficina.
     */
    @Override
    @BusinessOperation(ComunBusinessOperation.BO_OFICINA_MGR_BUSCAR_POR_CODIGO)
    public Oficina buscarPorCodigo(Integer codigo) {
        return oficinaDao.buscarPorCodigo(codigo);
    }
    
    /**
     * Busca una oficina por el campo OFI_CODIGO_OFICINA
     * @param codigo
     * @return
     */
    @Override
    @BusinessOperation(ComunBusinessOperation.BO_OFICINA_MGR_BUSCAR_POR_CODIGO_OFICINA)
    public Oficina buscarPorCodigoOficina(Integer codigo) {
        return oficinaDao.buscarPorCodigoOficina(codigo);
    }
}
