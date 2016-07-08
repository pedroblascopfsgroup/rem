package es.pfsgroup.tipoContenedor.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.tipoContenedor.dao.MapeoTipoContenedorDao;
import es.pfsgroup.tipoContenedor.model.MapeoTipoContenedor;

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
		
		MapeoTipoContenedor mapeo =  null;
		
		if(getHibernateTemplate().find(hql.toString()).size() > 0) {
			mapeo = (MapeoTipoContenedor) getHibernateTemplate().find(hql.toString()).get(0);			
		}
		
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

	@Override
	public List<Long> obtenerIdsTiposDocMapeados(List<String> tiposClasesContenedor) {
		
		StringBuffer hql = new StringBuffer("Select mtc from MapeoTipoContenedor mtc");
		hql.append(" where mtc.auditoria.borrado = 0  and (");
		if (!Checks.estaVacio(tiposClasesContenedor)) {
			for (String tipoClase : tiposClasesContenedor) {
				hql.append(" mtc.codigoTDN2 like '" + tipoClase + "%' OR");			
			}
			hql.append(" 0=1 )");
		} else {
			hql.append(" 1=1 ");
		}
		List<MapeoTipoContenedor> resultadoConsulta = getHibernateTemplate().find(hql.toString());
		List<Long> resultado = new ArrayList<Long>();
		for (int i = 0; i < resultadoConsulta.size(); i++) {
			resultado.add(resultadoConsulta.get(i).getTipoFichero().getId());
		}
		return resultado;
	}
}
