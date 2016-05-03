package es.capgemini.pfs.acuerdo.dao;

import java.util.List;

import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Mariano Ruiz
 *
 */
public interface DDEstadoAcuerdoDao extends AbstractDao<DDEstadoAcuerdo, Long> {

    /**
     * Busca un DDEstadoAcuerdo.
     * @param codigo String: el codigo del DDEstadoAcuerdo
     * @return DDEstadoAcuerdo
     */
    DDEstadoAcuerdo buscarPorCodigo(String codigo);
    
	List<DDEstadoAcuerdo> getListEstadosAcuerdo();

}
