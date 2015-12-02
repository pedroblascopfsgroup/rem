package es.capgemini.pfs.procesosJudiciales.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;

/**
 * Implementación del dao de TareaExternaDao para Hibenate.
 *
 */
@Repository("TareaExternaValorDao")
public class TareaExternaValorDaoImpl extends AbstractEntityDao<TareaExternaValor, Long> implements TareaExternaValorDao {

	/**
	 * getByTareaExterna.
	 * @param idTareaExterna idTareaExterna
	 * @return TareaExternaValor
	 */
    @Override
    @SuppressWarnings("unchecked")
    public List<TareaExternaValor> getByTareaExterna(Long idTareaExterna) {
    	if (idTareaExterna == null){
    		throw new IllegalArgumentException("'idTareaExterna' no puede ser NULL");
    	}
        String hql = "from TareaExternaValor where tareaExterna.id= ?";

        List<TareaExternaValor> list = getHibernateTemplate().find(hql, new Object[] { idTareaExterna });
        return list;
    }

}
