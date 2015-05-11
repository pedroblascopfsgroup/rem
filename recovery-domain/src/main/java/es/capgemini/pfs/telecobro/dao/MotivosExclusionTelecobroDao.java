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
     * busca un motivo de exclusi�n por su c�digo.
     * @param codigo el codigo
     * @return el motivo de exclusi�n
     */
    DDMotivosExclusionTelecobro buscarPorCodigo(String codigo);

}
