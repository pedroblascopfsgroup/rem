package es.capgemini.pfs.procesosJudiciales.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.DDFaseProcesal;

/**
 * Definición del DAO para fase procesa.
 * @author pajimene
 *
 */
public interface DDFaseProcesalDao extends AbstractDao<DDFaseProcesal, Long> {

    /**
     * Devuelve una fase procesal según su código.
     * @param codigoFase codigo
     * @return fase procesal
     */
    DDFaseProcesal getByCodigo(String codigoFase);
}
