package es.capgemini.pfs.procesosJudiciales.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.dao.PlazoTareaExternaPlazaDao;
import es.capgemini.pfs.procesosJudiciales.model.PlazoTareaExternaPlaza;

/**
 * Implementaci�n del dao de TareaExternaDao para Hibenate.
 *
 * @author pajimene
 *
 */
@Repository("PlazoTareaExternaPlazaDao")
public class PlazoTareaExternaPlazaDaoImpl extends AbstractEntityDao<PlazoTareaExternaPlaza, Long> implements PlazoTareaExternaPlazaDao {

    /**
     * getByTipoTareaTipoPlazaTipoJuzgado.
     * @param idTipoTarea id
     * @param idTipoPlaza id
     * @param idTipoJuzgado id
     * @return pt
     */
    @SuppressWarnings("unchecked")
    @Override
    public PlazoTareaExternaPlaza getByTipoTareaTipoPlazaTipoJuzgado(Long idTipoTarea, Long idTipoPlaza, Long idTipoJuzgado) {
        String hql1 = "from PlazoTareaExternaPlaza where idTareaProcedimiento = ? AND idTipoPlaza = ? and idTipoJuzgado = ?";
        String hql2 = "from PlazoTareaExternaPlaza where idTareaProcedimiento = ? AND idTipoPlaza = ? and idTipoJuzgado = null";
        String hql3 = "from PlazoTareaExternaPlaza where idTareaProcedimiento = ? AND idTipoPlaza = null and idTipoJuzgado = null";

        List<PlazoTareaExternaPlaza> list = null;

        if (idTipoJuzgado != null && idTipoPlaza != null) {
            list = getHibernateTemplate().find(hql1, new Object[] { idTipoTarea, idTipoPlaza, idTipoJuzgado });
        }
        if (list != null && list.size() > 0) {
            return list.get(0);
        }

        if (idTipoPlaza != null) {
            list = getHibernateTemplate().find(hql2, new Object[] { idTipoTarea, idTipoPlaza });
        }
        if (list != null && list.size() > 0) {
            return list.get(0);
        }

        list = getHibernateTemplate().find(hql3, new Object[] { idTipoTarea });
        if (list != null && list.size() > 0) {
            return list.get(0);
        }

        return null;
    }
}
