package es.capgemini.pfs.segmento.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.segmento.dao.SegmentoDao;
import es.capgemini.pfs.segmento.model.DDSegmento;

/**
 * @author Mariano Ruiz
 */
@Repository("SegmentoDao")
public class SegmentoDaoImpl extends AbstractEntityDao<DDSegmento, Long> implements SegmentoDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<DDSegmento> getSegmentosByCodigos(Set<String> codigos) {
        if (codigos.size() == 0 || codigos.toString().equals("[]")) {
            return new ArrayList<DDSegmento>();
        }
        // En la entidad Segmento el campo 'codigo' es el 'id'
        String hql = "from DDSegmento segmento " + "where segmento.id in (" + codigos.toString().replace("[", "").replace("]", "") + ")"
                + "      and segmento.auditoria." + Auditoria.UNDELETED_RESTICTION;
        return getHibernateTemplate().find(hql);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public DDSegmento findByCodigo(String codigo) {
        String hql = "from DDSegmento where codigo = ?";

        List<DDSegmento> tipos = getHibernateTemplate().find(hql, new Object[] { codigo });
        if (tipos.size() > 0) {
            return tipos.get(0);
        }
        return null;
    }
}
