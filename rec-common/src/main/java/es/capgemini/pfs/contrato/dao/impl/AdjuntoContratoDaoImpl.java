package es.capgemini.pfs.contrato.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.contrato.dao.AdjuntoContratoDao;
import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Clase que implementa los métodos de la interfaz AdjuntoContratoDao.
 *
 */
@Repository("AdjuntoContrato")
public class AdjuntoContratoDaoImpl extends AbstractEntityDao<AdjuntoContrato, Long> implements AdjuntoContratoDao {
	
	@SuppressWarnings("unchecked")
	@Override
	public List<AdjuntoContrato> getAdjuntoContratoByIdDocumento(List<Integer> idsDocumento) {
		StringBuilder listToString = new StringBuilder();
		for ( int i = 0; i< idsDocumento.size(); i++){
			listToString.append(idsDocumento.get(i));
			if ( i != idsDocumento.size()-1){
				listToString.append(", ");
			}
	    }
		StringBuffer hql = new StringBuffer();
		hql.append(" select ac from AdjuntoContrato ac where ac.auditoria.borrado = false ");
		hql.append(" and ac.servicerId in( ");
		hql.append(listToString);
		hql.append(")");
		return getSession().createQuery(hql.toString()).list();
	}
}
