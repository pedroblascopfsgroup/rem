package es.pfsgroup.plugin.rem.oferta.dao.impl;


import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.model.OfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.oferta.dao.OfertasAgrupadasLbkDao;

@Repository("OfertasAgrupadasLbkDao")
public class OfertasAgrupadasLbkDaoImpl extends AbstractEntityDao<OfertasAgrupadasLbk, Long> implements OfertasAgrupadasLbkDao {
		
	@Autowired
	private GenericABMDao genericDao;
	

	@Override
	public Long getIdOfertaAgrupadaLBK(Long idOferta) {
		
		OfertasAgrupadasLbk resultado = null;
		HQLBuilder hql = new HQLBuilder("select oferAgruLbk from OfertasAgrupadasLbk oferAgruLbk join oferAgruLbk.ofertaDependiente depen");
		HQLBuilder.addFiltroIgualQue(hql, "depen.id", idOferta);
		try {
			resultado =  HibernateQueryUtils.uniqueResult(this, hql);
		} catch (Exception e) {
			logger.error("error obtienendo oferta principal",e);
		} 
		
		if(resultado == null) {
			throw new JsonViewerException("No se ha encontrado la oferta principal");
		}
		
		return resultado.getId();
	}

	@Override
	public boolean suprimeOfertaDependiente(Long idOferta) {
		boolean resultado = false;
		try {
			Long idOfertaLBK = getIdOfertaAgrupadaLBK(idOferta);
			genericDao.deleteById(OfertasAgrupadasLbk.class, idOfertaLBK);
			resultado = true;
		} catch (Exception e) {
			logger.error("error obtienendo oferta principal",e);
		}
		return resultado;
	}
	
	@Override
	public void actualizaPrincipalId (Long nuevoPrincipalId, Long dependienteId){
		
		try {
			Long ogr_id = getIdOfertaAgrupadaLBK(dependienteId);
			StringBuilder hqlUpdate = new StringBuilder("update OfertasAgrupadasLbk ogr set ogr.ofertaPrincipal.id = :nuevoPrincipalId");	
        	hqlUpdate.append(" where ogr.id = :ogrId");

            Query queryUpdate = this.getSessionFactory().getCurrentSession().createQuery(hqlUpdate.toString());
            
            queryUpdate.setParameter("nuevoPrincipalId", nuevoPrincipalId);
            queryUpdate.setParameter("ogrId", ogr_id);

            queryUpdate.executeUpdate();
            
		} catch (Exception e) {
			logger.error("error obtienendo oferta principal",e);
		}
	}	
}
