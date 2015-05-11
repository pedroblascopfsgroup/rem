package es.capgemini.pfs.multigestor.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoHistoricoDao;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsuntoHistorico;

/**
 * 
 * Dao de la entidad  {@link EXTGestorAdicionalAsuntoHistorico}
 * 
 * @author manuel
 *
 */
@Repository
public class EXTGestorAdicionalAsuntoHistoricoDaoImpl extends AbstractEntityDao<EXTGestorAdicionalAsuntoHistorico, Long> implements EXTGestorAdicionalAsuntoHistoricoDao {

	/* (non-Javadoc)
	 * @see es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoHistoricoDao#actualizaFechaHasta(java.lang.Long, java.lang.Long)
	 */
	@Override
	public void actualizaFechaHasta(Long idAsunto, Long idTipoGestor) {

        StringBuilder hqlUpdate = new StringBuilder("update EXTGestorAdicionalAsuntoHistorico gah set gah.fechaHasta = sysdate ");
        hqlUpdate.append(" where gah.asunto.id = :idAsunto and gah.tipoGestor.id = :idGestor and gah.fechaHasta is null");
        Query queryUpdate = this.getSession().createQuery(hqlUpdate.toString());

        queryUpdate.setParameter("idAsunto", idAsunto);
        queryUpdate.setParameter("idGestor", idTipoGestor);
        
        queryUpdate.executeUpdate();

	}

	/* (non-Javadoc)
	 * @see es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoHistoricoDao#getListOrderedByAsunto(java.lang.Long)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<EXTGestorAdicionalAsuntoHistorico> getListOrderedByAsunto(
			Long idAsunto) {
		
        StringBuilder hqlList = new StringBuilder(" from EXTGestorAdicionalAsuntoHistorico gah ");
        hqlList.append(" where gah.asunto.id = :idAsunto order by gah.tipoGestor.descripcion asc, gah.fechaDesde desc");
        Query queryList = this.getSession().createQuery(hqlList.toString());

        queryList.setParameter("idAsunto", idAsunto);
        
        return queryList.list();
	}

}
