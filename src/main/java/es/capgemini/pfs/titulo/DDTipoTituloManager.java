package es.capgemini.pfs.titulo;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.titulo.dao.DDTipoTituloDao;
import es.capgemini.pfs.titulo.dao.DDTipoTituloGeneralDao;
import es.capgemini.pfs.titulo.model.DDTipoTitulo;
import es.capgemini.pfs.titulo.model.DDTipoTituloGeneral;

/**
 * Clase manager de la entidad TipoTitulo.
 */
@Service("ddTipoTituloManager")
public class DDTipoTituloManager {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private DDTipoTituloDao ddTipoTituloDao;
    @Autowired
    private DDTipoTituloGeneralDao ddTipoTituloGeneralDao;

    /**
     * Retorna lista de tipos titulo.
     * @param codigoTipoDocGen Long id del tipo de documento general
     * @return List
     */
    @BusinessOperation
    public List<DDTipoTitulo> buscarTipos(String codigoTipoDocGen) {
        if (codigoTipoDocGen == null || codigoTipoDocGen.trim().equals("")) { return new ArrayList<DDTipoTitulo>(); }
        return ddTipoTituloDao.buscarPorTipoGeneral(codigoTipoDocGen);
    }

    /**
     * Retorna lista de tipos titulo generales.
     * @return List
     */
    @BusinessOperation
    public List<DDTipoTituloGeneral> getListGeneral() {
        return ddTipoTituloGeneralDao.getList();
    }

    /**
     * Retorna un tipo de titulo.
     * @param id Long
     * @return DDTipoTitulo
     */
    @Deprecated
    public DDTipoTitulo get(Long id) {
        logger.debug("Posible error: Acceso a entidad de diccionario DDTipoTitulo mediante Id.");
        return ddTipoTituloDao.get(id);
    }

    /**
     * Retorna el tipo de título para un id determinado.
     *
     * @param codigo
     *            String
     * @return DDTipoTitulo
     */
    public DDTipoTitulo findTipoTitulo(String codigo) {
        return ddTipoTituloDao.obtenerTipoTitulo(codigo);
    }

}
