package es.pfsgroup.plugin.recovery.coreextension.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.coreextension.dao.DDGestoriaDao;
import es.pfsgroup.plugin.recovery.coreextension.model.DDGestoria;

@Repository("DDGestoriaDao")
public class DDGestoriaDaoImpl extends AbstractEntityDao<DDGestoria, Long> implements DDGestoriaDao{

	@SuppressWarnings("unchecked")
   public DDGestoria buscarPorCodigo(String codigo) {
           String hql = "from DDGestoria where codigo = ?";
           List<DDGestoria> tipos = getHibernateTemplate().find(hql, codigo);
           if (tipos==null || tipos.size()==0){
                   return null;
           }
           return tipos.get(0);
   }	
	
}
