package es.pfsgroup.recovery.ext.impl.adjunto.dao;

import java.util.List;
import java.util.Set;

import es.capgemini.devon.hibernate.dao.HibernateDao;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;

/**
 * @author maruiz
 * 
 */
public interface EXTAdjuntoAsuntoDao extends
		HibernateDao<EXTAdjuntoAsunto, Long> {

	List<EXTAdjuntoAsunto> getAdjuntoAsuntoByNombreByAsu(Long idAsunto, String nombre);
	
	Set<AdjuntoAsunto> getAdjuntoAsuntoByIdDocumento(List<Integer> idsDocumento);

}
