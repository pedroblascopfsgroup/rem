package es.capgemini.pfs.persona.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.dao.AdjuntoPersonaDao;
import es.capgemini.pfs.persona.model.AdjuntoPersona;

/**
 * Implementación del dao de adjuntos de Persona.
 * @author marruiz
 */
@Repository("AdjuntoPersonaDao")
public class AdjuntoPersonaDaoImpl extends AbstractEntityDao<AdjuntoPersona, Long> implements AdjuntoPersonaDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<AdjuntoPersona> getAdjuntoPersonaByIdDocumento(List<Integer> idsDocumento) {
		StringBuilder listToString = new StringBuilder();
		for ( int i = 0; i< idsDocumento.size(); i++){
			listToString.append(idsDocumento.get(i));
			if ( i != idsDocumento.size()-1){
				listToString.append(", ");
			}
	    }
		StringBuffer hql = new StringBuffer();
		hql.append(" select ap from AdjuntoPersona ap where ap.auditoria.borrado = false ");
		hql.append(" and ap.servicerId in( ");
		hql.append(listToString);
		hql.append(")");
		return getSession().createQuery(hql.toString()).list();
	}
}
