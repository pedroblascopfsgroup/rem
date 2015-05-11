package es.capgemini.pfs.alerta.dao;

import java.util.List;

import es.capgemini.pfs.alerta.model.Alerta;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.scoring.dto.DtoAlerta;

/**
 * @author Andrés Esteban.
 */
public interface AlertaDao extends AbstractDao<Alerta, Long> {

    /**
     * Recupera Dto's de las ultimas alertas cargadas.
     * @return lista de alertas
     */
    List<DtoAlerta> getDtoAlertasActivas();

}
