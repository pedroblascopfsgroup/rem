package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.SQLQuery;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVConfImpulsoAutomaticoDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVConfImpulsoAutomatico;

@Repository("MSVConfImpulsoAutomaticoDao")
public class MSVConfImpulsoAutomaticoDaoImpl 
		extends AbstractEntityDao<MSVConfImpulsoAutomatico, Long> 
		implements MSVConfImpulsoAutomaticoDao {

	@Override
	public List<String> obtenerListaCarteras() {
		String queryString = "select distinct car_descripcion from car_cartera where borrado=0 order by car_descripcion";

		SQLQuery sqlQuery = getSession().createSQLQuery(queryString);
		@SuppressWarnings("unchecked")
		List<String> lista = sqlQuery.list();
		List<String> resultado = new ArrayList<String>();
		for (String cartera : lista) {
			resultado.add("\"" + cartera + "\"");
		}
		return resultado;	
		
	}

}
