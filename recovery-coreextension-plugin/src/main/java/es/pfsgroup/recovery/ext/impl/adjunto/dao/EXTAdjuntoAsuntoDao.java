package es.pfsgroup.recovery.ext.impl.adjunto.dao;

import java.util.List;

import es.capgemini.devon.hibernate.dao.HibernateDao;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;

/**
 * @author maruiz
 * 
 */
public interface EXTAdjuntoAsuntoDao extends
		HibernateDao<EXTAdjuntoAsunto, Long> {

	List<EXTAdjuntoAsunto> getAdjuntoAsuntoByNombreByAsu(Long idAsunto, String nombre);

}
