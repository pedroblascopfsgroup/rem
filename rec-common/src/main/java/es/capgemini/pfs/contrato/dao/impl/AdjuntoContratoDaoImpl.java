package es.capgemini.pfs.contrato.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.contrato.dao.AdjuntoContratoDao;
import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;

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
		if(!Checks.estaVacio(idsDocumento)) {
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
		return new ArrayList<AdjuntoContrato>();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<AdjuntoContrato> getAdjuntoContratoByIdNombreTipoDocumento(Long idContrato, String nombre, String tipoDocumento) {
		StringBuffer hql = new StringBuffer();
		hql.append(" select aa from AdjuntoContrato aa where aa.auditoria.borrado = false and aa.contrato.id = :idContrato");
		hql.append(" and aa.nombre like :nombreDoc");
		hql.append(" and aa.tipoAdjuntoEntidad.codigo = :tipoDoc");
		
		Query hqlQuery = getSession().createQuery(hql.toString());
		hqlQuery.setLong("idContrato", idContrato);
		hqlQuery.setString("nombreDoc", nombre + "%");
		hqlQuery.setString("tipoDoc", tipoDocumento);
		return hqlQuery.list();
	}

}
