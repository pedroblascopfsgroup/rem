package es.pfsgroup.recovery.ext.impl.adjunto.dao.impl;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.ext.impl.adjunto.dao.EXTAdjuntoAsuntoDao;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;

/**
 * @author maruiz
 * 
 */
@Repository
public class EXTAdjuntoAsuntoDaoImpl extends AbstractEntityDao<EXTAdjuntoAsunto, Long> implements
		EXTAdjuntoAsuntoDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<EXTAdjuntoAsunto> getAdjuntoAsuntoByNombreByAsu(Long idAsunto, String nombre) {
		StringBuffer hql = new StringBuffer();
		hql.append(" select aa from AdjuntoAsunto aa where aa.auditoria.borrado = false and aa.asunto.id = ");
		hql.append(idAsunto);
		hql.append(" and aa.nombre like '");
		hql.append(nombre);
		hql.append("%'");
		return getSession().createQuery(hql.toString()).list();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Set<AdjuntoAsunto> getAdjuntoAsuntoByIdDocumentoAndPrcId(List<Integer> idsDocumento, Long idPrc) {
		StringBuilder listToString = new StringBuilder();
		for ( int i = 0; i< idsDocumento.size(); i++){
			listToString.append(idsDocumento.get(i));
			if ( i != idsDocumento.size()-1){
				listToString.append(", ");
			}
	    }
		StringBuffer hql = new StringBuffer();
		hql.append(" select aa from AdjuntoAsunto aa where aa.auditoria.borrado = false ");
		if(!Checks.esNulo(idPrc)) {
			hql.append(" and aa.procedimiento.id = ");
			hql.append(idPrc);
		}
		hql.append(" and aa.servicerId in( ");
		hql.append(listToString);
		hql.append(")");
		return new HashSet<AdjuntoAsunto>(getSession().createQuery(hql.toString()).list());
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<EXTAdjuntoAsunto> getAdjuntoAsuntoByNombreAndPrcIdAndTipoAdjunto(Long idPrc, String nombre, String codTipoAdjunto) {
		StringBuffer hql = new StringBuffer();
		hql.append(" select aa from EXTAdjuntoAsunto aa where aa.auditoria.borrado = false and aa.procedimiento.id = ");
		hql.append(idPrc);
		hql.append(" and aa.nombre like '");
		hql.append(nombre);
		hql.append("%'");
		hql.append(" AND aa.tipoFichero.codigo = '").append(codTipoAdjunto).append("' ");
		hql.append(" ORDER BY aa.auditoria.fechaCrear DESC ");

		return getSession().createQuery(hql.toString()).list();

	}
}
