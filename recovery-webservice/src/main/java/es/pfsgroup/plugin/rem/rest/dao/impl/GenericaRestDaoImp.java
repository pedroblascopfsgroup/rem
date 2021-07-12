package es.pfsgroup.plugin.rem.rest.dao.impl;

import java.io.Serializable;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.rest.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.rest.dao.GenericRestDao;

@Repository("genericaRestDaoImp")
public class GenericaRestDaoImp extends AbstractEntityDao<Serializable, Serializable> implements GenericRestDao {

	@Override
	public void deleteInformeMediador(InformeMediadorDto informeComerical) throws Exception {
		
		Query query = null;
		
		if(Checks.esNulo(informeComerical.getCodTipoActivo()) 
				|| !DDTipoActivo.COD_VIVIENDA.equals(informeComerical.getCodTipoActivo()) ) {
			query = this.getSessionFactory().getCurrentSession().createQuery("delete from ActivoInfraestructura inf where inf.infoComercial = (select info from ActivoInfoComercial info where activo.numActivo=:ID)");
			query.setParameter("ID", informeComerical.getIdActivoHaya());
			query.executeUpdate();
			
			query = this.getSessionFactory().getCurrentSession().createQuery("delete from ActivoCarpinteriaInterior carpint where carpint.infoComercial = (select info from ActivoInfoComercial info where activo.numActivo=:ID)");
			query.setParameter("ID", informeComerical.getIdActivoHaya());
			query.executeUpdate();
			
			query = this.getSessionFactory().getCurrentSession().createQuery("delete from ActivoCarpinteriaExterior carpext where carpext.infoComercial = (select info from ActivoInfoComercial info where activo.numActivo=:ID)");
			query.setParameter("ID", informeComerical.getIdActivoHaya());
			query.executeUpdate();
			
			query = this.getSessionFactory().getCurrentSession().createQuery("delete from ActivoParamentoVertical para where para.infoComercial = (select info from ActivoInfoComercial info where activo.numActivo=:ID)");
			query.setParameter("ID", informeComerical.getIdActivoHaya());
			query.executeUpdate();
			
			query = this.getSessionFactory().getCurrentSession().createQuery("delete from ActivoSolado sola where sola.infoComercial = (select info from ActivoInfoComercial info where activo.numActivo=:ID)");
			query.setParameter("ID", informeComerical.getIdActivoHaya());
			query.executeUpdate();
			
			query = this.getSessionFactory().getCurrentSession().createQuery("delete from ActivoCocina coci where coci.infoComercial = (select info from ActivoInfoComercial info where activo.numActivo=:ID)");
			query.setParameter("ID", informeComerical.getIdActivoHaya());
			query.executeUpdate();
			
			query = this.getSessionFactory().getCurrentSession().createQuery("delete from ActivoBanyo banyo where banyo.infoComercial = (select info from ActivoInfoComercial info where activo.numActivo=:ID)");
			query.setParameter("ID", informeComerical.getIdActivoHaya());
			query.executeUpdate();				
			
			query = this.getSessionFactory().getCurrentSession().createQuery("delete from ActivoZonaComun zonacom where zonacom.infoComercial = (select info from ActivoInfoComercial info where activo.numActivo=:ID)");
			query.setParameter("ID", informeComerical.getIdActivoHaya());
			query.executeUpdate();
			
			query = this.getSessionFactory().getCurrentSession().createQuery("delete from ActivoDistribucion distr where distr.infoComercial = (select info from ActivoInfoComercial info where activo.numActivo=:ID)");
			query.setParameter("ID", informeComerical.getIdActivoHaya());
			query.executeUpdate();
			
			query = this.getSessionFactory().getCurrentSession().createQuery("delete from ActivoInstalacion insta where insta.infoComercial = (select info from ActivoInfoComercial info where activo.numActivo=:ID)");
			query.setParameter("ID", informeComerical.getIdActivoHaya());
			query.executeUpdate();
			
//			query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoEdificio where infoComercial.activo.numActivo=:ID");
//			query.setParameter("ID", informeComerical.getIdActivoHaya());
//			query.executeUpdate();
			
			//query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoAnejo where infoComercial=:ID");
			//query.setParameter("ID", informeComerical);
			//query.executeUpdate();
			
			query = this.getSessionFactory().getCurrentSession().createSQLQuery("delete from act_viv_vivienda where ico_id=(select ico_id from act_ico_info_comercial where act_id = (select act_id from act_activo where act_num_activo = :idActivoHaya))");
			query.setParameter("idActivoHaya", informeComerical.getIdActivoHaya());
			query.executeUpdate();
		}
		
		if(Checks.esNulo(informeComerical.getCodTipoActivo()) 
				|| !DDTipoActivo.COD_COMERCIAL.equals(informeComerical.getCodTipoActivo()) ) {
			query = this.getSessionFactory().getCurrentSession().createSQLQuery("delete from act_lco_local_comercial where ico_id=(select ico_id from act_ico_info_comercial where act_id = (select act_id from act_activo where act_num_activo = :idActivoHaya))");
			query.setParameter("idActivoHaya", informeComerical.getIdActivoHaya());
			query.executeUpdate();
		}
		
		if(Checks.esNulo(informeComerical.getCodTipoActivo()) 
				|| !DDTipoActivo.COD_OTROS.equals(informeComerical.getCodTipoActivo()) ) {
			query = this.getSessionFactory().getCurrentSession().createSQLQuery("delete from act_apr_plaza_aparcamiento where ico_id=(select ico_id from act_ico_info_comercial where act_id = (select act_id from act_activo where act_num_activo = :idActivoHaya))");
			query.setParameter("idActivoHaya", informeComerical.getIdActivoHaya());
			query.executeUpdate();
		}
		
		doFlush();
	
		
	}
	
	public void doFlush(){
		this.getHibernateTemplate().flush();
	}

}
