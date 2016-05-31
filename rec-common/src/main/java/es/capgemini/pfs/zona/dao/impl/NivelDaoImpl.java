package es.capgemini.pfs.zona.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.zona.dao.NivelDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.Nivel;

/**
 * Implementación del dao de subtipos de tareas.
 * @author pamuller
 *
 */
@Repository("NivelDao")
public class NivelDaoImpl extends AbstractEntityDao<Nivel, Long> implements NivelDao{

	@SuppressWarnings("unchecked")
	@Override
	public Integer buscarCodigoNivelPorDescripcion(String descripcion) {
		
		String hql = " select n.codigo from Nivel n where n.auditoria.borrado = 0 and UPPER(trim(n.descripcion)) = :descripcion and n.codigo != null";
 
        Query query = getSession().createQuery(hql);
        query.setParameter("descripcion", descripcion);
        
        List<Integer> listaCodigos= query.list();
        
        if(listaCodigos.size()>0){
        	return listaCodigos.get(0);
        }
        else{
        	return (Integer) query.uniqueResult();
        }
        
        
		
	}


}
