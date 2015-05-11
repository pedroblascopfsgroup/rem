package es.capgemini.pfs.metrica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.metrica.dto.DtoMetrica;
import es.capgemini.pfs.metrica.model.FicheroMetrica;

/**
 * Dao para los ficheros de métricas.
 * @author aesteban
 *
 */
public interface FicheroMetricaDao extends AbstractDao<FicheroMetrica, Long> {

    /**
     * Crea el registro en la tabla para el fichero indicado en el DTO
     * y sus parámetros correspondientes.
     * @param dto parámetros
     * @return FicheroMetrica
     */
    FicheroMetrica guardarFichero(DtoMetrica dto);

    /**
     * Borra FISICAMANENTE el fichero indicado.
     * @param ficheroInactivo a borrar
     */
    void borrarFisicamente(FicheroMetrica ficheroInactivo);

}
