package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDSubtipoSolucionAmistosaAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.DDSubtipoSolucionAmistosaAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDSubtipoSolucionAmistosaAcuerdoDao")
public class DDSubtipoSolucionAmistosaAcuerdoDaoImpl extends AbstractEntityDao<DDSubtipoSolucionAmistosaAcuerdo, Long> implements
        DDSubtipoSolucionAmistosaAcuerdoDao {

    /**
     * Busca un DDSubtipoSolucionAmistosaAcuerdo.
     * @param codigo String: el codigo del DDSubtipoSolucionAmistosaAcuerdo
     * @return DDSubtipoSolucionAmistosaAcuerdo
     */
    @SuppressWarnings("unchecked")
    public DDSubtipoSolucionAmistosaAcuerdo buscarPorCodigo(String codigo) {
        String hql = "from DDSubtipoSolucionAmistosaAcuerdo where codigo = ?";
        List<DDSubtipoSolucionAmistosaAcuerdo> tipos = getHibernateTemplate().find(hql, codigo);
        if (tipos == null || tipos.size() == 0) { return null; }
        return tipos.get(0);
    }
}
