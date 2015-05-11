package es.capgemini.pfs.multigestor.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.multigestor.dao.EXTTipoGestorPropiedadDao;
import es.capgemini.pfs.multigestor.model.EXTTipoGestorPropiedad;

@Repository
public class EXTTipoGestorPropiedadDaoImpl extends AbstractEntityDao<EXTTipoGestorPropiedad, Long>  implements EXTTipoGestorPropiedadDao {

	@Override
	public List<EXTTipoGestorPropiedad> getByClaveValor(String clave,
			String valor) {		
		StringBuffer hql = new StringBuffer();
		
		hql.append(" Select tgp from  EXTTipoGestorPropiedad tgp where tgp.clave = '").append(clave).append("' ");
		hql.append(" and tgp.valor like '%").append(valor).append("%'");
		
		List<EXTTipoGestorPropiedad> lista = getSession().createQuery(hql.toString()).list();
		return lista;
	}

	@Override
	public List<EXTTipoGestorPropiedad> getByClave(String clave) {		
		StringBuffer hql = new StringBuffer();
		
		hql.append(" Select tgp from  EXTTipoGestorPropiedad tgp where tgp.clave = '").append(clave).append("' ");
		
		List<EXTTipoGestorPropiedad> lista = getSession().createQuery(hql.toString()).list();
		return lista;
	}
	
	@Override
	public EXTTipoGestorPropiedad getGestorPropiedad(String codTipoGestor, String clave, String valor) {
		StringBuffer hql = new StringBuffer();
		
		hql.append(" Select tgp from  EXTTipoGestorPropiedad tgp where tgp.tipoGestor.codigo ='").append(codTipoGestor).append("' ");
		hql.append(" and tgp.clave = '").append(clave).append("' ");
		hql.append(" and tgp.valor like '%").append(valor).append("%'");
		
		Query query = getSession().createQuery(hql.toString());
		EXTTipoGestorPropiedad gestorPropiedad = (EXTTipoGestorPropiedad) query.uniqueResult();
		return gestorPropiedad;
	}

	@Override
	public EXTTipoGestorPropiedad getByGestorClave(String codTipoGestor, String clave) {
		StringBuffer hql = new StringBuffer();
		
		hql.append(" Select tgp from  EXTTipoGestorPropiedad tgp where tgp.tipoGestor.codigo ='").append(codTipoGestor).append("' ");
		hql.append(" and tgp.clave = '").append(clave).append("' ");
		
		Query query = getSession().createQuery(hql.toString());
		EXTTipoGestorPropiedad gestorPropiedad = (EXTTipoGestorPropiedad) query.uniqueResult();
		return gestorPropiedad;
	}

	

}
