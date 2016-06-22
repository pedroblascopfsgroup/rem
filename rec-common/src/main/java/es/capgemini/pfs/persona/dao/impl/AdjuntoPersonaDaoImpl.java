package es.capgemini.pfs.persona.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.dao.AdjuntoPersonaDao;
import es.capgemini.pfs.persona.model.AdjuntoPersona;
import es.pfsgroup.commons.utils.Checks;

/**
 * Implementación del dao de adjuntos de Persona.
 * @author marruiz
 */
@Repository("AdjuntoPersonaDao")
public class AdjuntoPersonaDaoImpl extends AbstractEntityDao<AdjuntoPersona, Long> implements AdjuntoPersonaDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<AdjuntoPersona> getAdjuntoPersonaByIdDocumento(List<Integer> idsDocumento) {
		if(!Checks.estaVacio(idsDocumento)) {
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
		return new ArrayList<AdjuntoPersona>();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<AdjuntoPersona> getAdjuntoPersonaByIdNombreTipoDocumento(Long idPersona, String nombre, String tipoDocumento) {
		StringBuffer hql = new StringBuffer();
		hql.append(" select aa from AdjuntoPersona aa where aa.auditoria.borrado = false and aa.persona.id = ");
		hql.append(idPersona);
		hql.append(" and aa.nombre like '");
		hql.append(nombre);
		hql.append("%'");
		hql.append(" and aa.tipoAdjuntoEntidad.codigo = '");
		hql.append(tipoDocumento);
		hql.append("'");
		return getSession().createQuery(hql.toString()).list();
	}
	
}
