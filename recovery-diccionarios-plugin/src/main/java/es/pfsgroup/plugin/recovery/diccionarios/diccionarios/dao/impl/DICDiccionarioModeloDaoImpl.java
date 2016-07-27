package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.classic.Session;
import org.hibernate.metadata.ClassMetadata;
import org.hibernate.persister.entity.AbstractEntityPersister;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICDiccionarioModeloDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICGenericDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dto.DICDtoValorDiccionario;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model.DICDiccionarioEditable;

@Repository("DICDiccionarioModeloDao")
public class DICDiccionarioModeloDaoImpl extends AbstractEntityDao<DICDiccionarioEditable, Long> implements DICDiccionarioModeloDao{

	@Resource
	private PaginationManager paginationManager;
	
	public boolean existeCodigoConBorrado(DICDtoValorDiccionario dto,String nombreTabla) {
		SessionFactory sessionFactory = getHibernateTemplate().getSessionFactory();
		Map<String, ClassMetadata> classMetaDataMap = sessionFactory.getAllClassMetadata();
		boolean existe=false;
		for(Map.Entry<String, ClassMetadata> metaDataMap : classMetaDataMap.entrySet()) {
		    ClassMetadata classMetadata = metaDataMap.getValue();
		    AbstractEntityPersister abstractEntityPersister = (AbstractEntityPersister) classMetadata;
		    String tableName = abstractEntityPersister.getTableName();
		    String entity="${entity.schema}.";
		    String master="${master.schema}.";
		    
		    if(tableName.equals(entity.concat(nombreTabla)) || tableName.equals(master.concat(nombreTabla)))
		    {
		    	String clase = abstractEntityPersister.getName();
		    	StringBuffer query = new StringBuffer();
			    StringBuffer hql = new StringBuffer();
			    hql.append("select dic from "+clase+" dic where dic.auditoria.borrado = 1 and dic.codigo ='"+dto.getCodigo()+"'").toString();
			    Page page = paginationManager.getHibernatePage(getHibernateTemplate(), hql.toString(), dto);
			    if(page.getTotalCount()>0){
			    	existe=true;
			    	break;
			    }
		    }	    
		}
		return existe;
	}

	
	public void updateLineaDic(DICDtoValorDiccionario dto, String nombreTabla) {
		SessionFactory sessionFactory = getHibernateTemplate().getSessionFactory();
		Map<String, ClassMetadata> classMetaDataMap = sessionFactory.getAllClassMetadata();
		boolean existe=false;
		for(Map.Entry<String, ClassMetadata> metaDataMap : classMetaDataMap.entrySet()) {
		    ClassMetadata classMetadata = metaDataMap.getValue();
		    AbstractEntityPersister abstractEntityPersister = (AbstractEntityPersister) classMetadata;
		    String tableName = abstractEntityPersister.getTableName();
		    String entity="${entity.schema}.";
		    String master="${master.schema}.";
		    
		    if(tableName.equals(entity.concat(nombreTabla)) || tableName.equals(master.concat(nombreTabla)))
		    { 
		    	String clase = abstractEntityPersister.getName();
		    	StringBuffer hql = new StringBuffer();
		    	hql.append(" update "+clase+" dic set dic.descripcion='"+dto.getDescripcion()+"', dic.descripcionLarga='"+dto.getDescripcionLarga()+"', dic.auditoria.borrado=0, dic.auditoria.usuarioBorrar=null, dic.auditoria.fechaBorrar=null where dic.codigo='"+dto.getCodigo()+"' and dic.auditoria.borrado=1");
		    	Session sesion = getHibernateTemplate().getSessionFactory().getCurrentSession();
				Query q = sesion.createQuery(hql.toString());
				int i = q.executeUpdate();
				break;
			    
		    }	    
		}
		
	}

	

}