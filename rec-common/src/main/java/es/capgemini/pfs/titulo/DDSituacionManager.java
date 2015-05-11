package es.capgemini.pfs.titulo;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.titulo.dao.DDSituacionDao;
import es.capgemini.pfs.titulo.model.DDSituacion;

/**
 * Clase manager de la entidad Situación.
 * @author mtorrado
 *
 */
@Service("ddSituacionManager")
public class DDSituacionManager {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private DDSituacionDao ddSituacionDao;

    /**
     * Retorna una lista de situaciones.
     * @return List de situaciones.
     */
    @BusinessOperation
    public List<DDSituacion> getList() {
        return ddSituacionDao.getList();
    }

    /**
     * Retorna una situación.
     * @param id Long
     * @return DDSituacion
     */
    @Deprecated
    public DDSituacion get(Long id) {
        logger.debug("Posible error: Acceso a entidad de diccionario DDSituacion mediante Id.");
        return ddSituacionDao.get(id);
    }

    /**
     * Retorna la situación para un id determinado.
     *
     * @param codigo
     *            String
     * @return DDSituacion
     */
    public DDSituacion findSituacion(String codigo) {
        return ddSituacionDao.obtenerSituacion(codigo);
    }

}
