package es.capgemini.pfs.multigestor.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoHistoricoDao;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsuntoHistorico;
import es.pfsgroup.commons.utils.Checks;

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
	public List<EXTGestorAdicionalAsuntoHistorico> getListOrderedByAsunto(Long idAsunto) {
		
        StringBuilder hqlList = new StringBuilder(" from EXTGestorAdicionalAsuntoHistorico gah ");
        hqlList.append(" where gah.asunto.id = :idAsunto order by gah.tipoGestor.descripcion asc, gah.fechaDesde desc");
        Query queryList = this.getSession().createQuery(hqlList.toString());

        queryList.setParameter("idAsunto", idAsunto);
        
        return queryList.list();
	}
	
	/**
	 * Comprueba si un Asunto ha tenido algun gestor que peretece a un despacho Integral
	 * @param idAsunto id del asunto
	 * @return True si el asunto ha tenido asignadot un despacho integral (del historico GAH)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public boolean hayAlgunDespachoIntegral(Long idAsunto) {
		
		StringBuilder hqlList = new StringBuilder(" from ConfiguracionDespachoExterno dec ");
        hqlList.append(" where dec.despachoIntegal = :despachoIntegal and dec.despachoExterno.id in ( select gah.gestor.despachoExterno.id from EXTGestorAdicionalAsuntoHistorico gah where gah.asunto.id = :idAsunto)");
        Query queryList = this.getSession().createQuery(hqlList.toString());

        queryList.setParameter("despachoIntegal", true);
        queryList.setParameter("idAsunto", idAsunto);
        
        if(!Checks.esNulo(queryList.list()) && queryList.list().size() > 0) {
        	return true;
        }
		
		return false;
	}

	@Override
	public void actualizaFechaHastaIdGestor(Long idAsunto, Long idTipoGestor,Long idGestor) {
		 StringBuilder hqlUpdate = new StringBuilder("update EXTGestorAdicionalAsuntoHistorico gah set gah.fechaHasta = sysdate ");
	        hqlUpdate.append(" where gah.asunto.id = :idAsunto and gah.tipoGestor.id = :idTipoGestor and gah.gestor.id = :idGestor and gah.fechaHasta is null");
	        Query queryUpdate = this.getSession().createQuery(hqlUpdate.toString());

	        queryUpdate.setParameter("idAsunto", idAsunto);
	        queryUpdate.setParameter("idTipoGestor", idTipoGestor);
	        queryUpdate.setParameter("idGestor", idGestor);
	        
	        queryUpdate.executeUpdate();
		
	}

}
