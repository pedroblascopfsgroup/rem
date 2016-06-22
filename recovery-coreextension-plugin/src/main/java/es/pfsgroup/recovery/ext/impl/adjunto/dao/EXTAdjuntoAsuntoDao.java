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
	
	Set<AdjuntoAsunto> getAdjuntoAsuntoByIdDocumentoAndPrcId(List<Integer> idsDocumento, Long idPrc);

	List<EXTAdjuntoAsunto> getAdjuntoAsuntoByNombreAndPrcIdAndTipoAdjunto(Long idPrc, String nombre, String codTipoAdjunto);

	List<EXTAdjuntoAsunto> getAdjuntoAsuntoByIdNombreTipoDocumento(
			Long idAsunto, String nombre, String tipoDocumento);

}
