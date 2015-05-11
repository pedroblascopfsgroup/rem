package es.capgemini.pfs.telecobro.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.telecobro.model.DDMotivosExclusionTelecobro;

/**
 * Dao de causas de exclusion de telecobro.
 * @author aesteban
 *
 */
public interface MotivosExclusionTelecobroDao extends AbstractDao<DDMotivosExclusionTelecobro, Long> {

    /**
     * busca un motivo de exclusión por su código.
     * @param codigo el codigo
     * @return el motivo de exclusión
     */
    DDMotivosExclusionTelecobro buscarPorCodigo(String codigo);

}
