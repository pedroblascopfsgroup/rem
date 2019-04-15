package es.pfsgroup.plugin.rem.dao;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.Order;

@Service
public class FlashDao extends AbstractEntityDao<Serializable, Serializable>{
	
	public List<Serializable> getList(Serializable clazz)
			throws InstantiationException, IllegalAccessException {
		return this.getListOrdered(clazz, null, (Filter)null);
	}


	public List<Serializable> getListOrdered(Serializable clazz, Order order) throws InstantiationException, IllegalAccessException {
		return this.getListOrdered(clazz, order, (Filter)null);
	}

	public List<Serializable> getList(Serializable clazz, Filter... filters) throws InstantiationException, IllegalAccessException {
		return this.getListOrdered(clazz, null, filters);
	}


	@SuppressWarnings({"unchecked", "rawtypes" })
	public List<Serializable> getListOrdered(Serializable clazz, Order order, Filter... filters) throws InstantiationException, IllegalAccessException {
		ArrayList<Serializable> respuesta = new ArrayList<Serializable>();
		String sql = "";
		StringBuilder functionHQL = new StringBuilder(sql);
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(functionHQL.toString());
		List<Object[]> resultados = callFunctionSql.list();
		
		if(!Checks.estaVacio(resultados)){
			for(Object[] resultado : resultados){
				Serializable objetoEntity = (Serializable) ((Class)clazz).newInstance();
				
				
				respuesta.add(objetoEntity);
			}
		}
		
		
		return respuesta;
	}


	public <T extends Serializable> T get(Class<T> clazz, Filter... filters) {
		// TODO Auto-generated method stub
		return null;
	}

}
