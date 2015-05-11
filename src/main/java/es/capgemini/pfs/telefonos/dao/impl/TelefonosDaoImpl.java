package es.capgemini.pfs.telefonos.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.telefonos.dao.TelefonosDao;
import es.capgemini.pfs.telefonos.model.Telefono;
import es.pfsgroup.commons.utils.Checks;

@Repository("TelefonosDao")
public class TelefonosDaoImpl extends AbstractEntityDao<Telefono, Long> implements TelefonosDao{

	
	@Override
	public void reorganizaPrioridades(Long idCliente, Long idTelefono, int prioridad, int prioridadAnt) {
		
		if (prioridadAnt==-1) {
			prioridadAnt = getMaxPrioridad(idCliente)+1;
//			if (prioridad != 1 && prioridad+1 == prioridadAnt) return;
		}
		
	    String sql = "";
		
	    if (prioridad>prioridadAnt) { 
			sql = "update tel_telefonos tel set tel.tel_prioridad = tel.tel_prioridad -1 " +
				" where tel.tel_id in (SELECT tp.tel_id FROM tel_per tp INNER JOIN per_personas per ON per.per_id = tp.per_id AND per.per_cod_cliente_entidad = " + idCliente + ") " +
				" and tel.TEL_PRIORIDAD >="+prioridadAnt+" and tel.TEL_PRIORIDAD <= "+ prioridad + " and tel.tel_id <> "+idTelefono+" and tel.BORRADO <> 1";
	    } else {
	    	sql = "update tel_telefonos tel set tel.tel_prioridad = tel.tel_prioridad +1 " +
    			" where tel.tel_id in (SELECT tp.tel_id FROM tel_per tp INNER JOIN per_personas per ON per.per_id = tp.per_id AND per.per_cod_cliente_entidad = " + idCliente + ") " +
				" and tel.TEL_PRIORIDAD >="+prioridad+" and tel.TEL_PRIORIDAD <= "+prioridadAnt+ " and tel.tel_id <> "+idTelefono+" and tel.BORRADO <> 1";
	    }

		Session sesion = getSession();

		try {
			sesion.createSQLQuery(sql).executeUpdate();
		} finally {
			releaseSession(sesion);
		}
		
	}

	@Override
	public Integer getMaxPrioridad(Long idCliente) {
			StringBuilder hql = new StringBuilder("select max(pTel.telefono.prioridad) from PersonasTelefono pTel ");
	        hql.append(" where pTel.persona.codClienteEntidad = ?)");
		
	        List<Integer> ret = getHibernateTemplate().find(hql.toString(), idCliente);
	        
	        return Checks.esNulo(ret.get(0)) ? 0 : ret.get(0);

	}

	
}
