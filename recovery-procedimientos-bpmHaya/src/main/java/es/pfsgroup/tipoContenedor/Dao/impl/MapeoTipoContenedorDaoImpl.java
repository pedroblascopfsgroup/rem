package es.pfsgroup.tipoContenedor.Dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.tipoContenedor.MapeoTipoContenedor;
import es.pfsgroup.tipoContenedor.Dao.MapeoTipoContenedorDao;

@Repository("MapeoTipoContenedorDao")
public class MapeoTipoContenedorDaoImpl extends AbstractEntityDao<MapeoTipoContenedor,Long> implements MapeoTipoContenedorDao {

	@SuppressWarnings("unchecked")
	@Override
	public MapeoTipoContenedor getMapeoByTfaAndTdn2(String tipoExp, String claseExp, String tipoFichero) {
		String tdn2 = tipoExp.concat("-").concat(claseExp);
		StringBuffer hql = new StringBuffer("Select mtc from MapeoTipoContenedor mtc");
		hql.append(" where mtc.codigoTDN2 like '");
		hql.append(tdn2);
		hql.append("%' and mtc.tipoFichero.codigo = '");
		hql.append(tipoFichero);
		hql.append("' and mtc.auditoria.borrado = false");
		
		MapeoTipoContenedor mapeo = (MapeoTipoContenedor) getHibernateTemplate().find(hql.toString()).get(0);
		
		return mapeo;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public boolean existeMapeoByFicheroAdjunto(String codTFA) {
		StringBuffer hql = new StringBuffer("Select mtc from MapeoTipoContenedor mtc");
		hql.append(" where mtc.tipoFichero.codigo = '");
		hql.append(codTFA);
		hql.append("' and mtc.auditoria.borrado = false");
		
		if(getHibernateTemplate().find(hql.toString()).size() > 0) {
			return true;
		}
		
		return false;
	}
}
