package es.capgemini.pfs.alerta.dao;

import es.capgemini.pfs.alerta.model.TipoAlerta;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Andrés Esteban.
 */
public interface TipoAlertaDao extends AbstractDao<TipoAlerta, Long> {

    /**
     * Busca el tipo de alerta por codigo.
     * @param codigo string;
     * @return TipoAlerta
     */
    TipoAlerta findByCodigo(String codigo);
}
