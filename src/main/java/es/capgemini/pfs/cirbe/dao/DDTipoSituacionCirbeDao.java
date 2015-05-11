package es.capgemini.pfs.cirbe.dao;

import java.util.List;

import es.capgemini.pfs.cirbe.model.DDTipoSituacionCirbe;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Interfaz del dao de DDTipoSituacionCirbe.
 * @author pamuller
 *
 */
public interface DDTipoSituacionCirbeDao extends AbstractDao<DDTipoSituacionCirbe, Long> {

    /**
     * Busca los distintos tipos de situaciones por su descripción.
     * @return List String
     */
    List<String> getDescripciones();

}
