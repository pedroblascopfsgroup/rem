package es.capgemini.pfs.despachoExterno.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.dao.DespachoExternoDao;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

/**
 * Implementación del dao de despachos externos.
 * @author pamuller
 *
 */
@Repository("DespachoExternoDao")
public class DespachoExternoDaoImpl extends AbstractEntityDao<DespachoExterno, Long> implements DespachoExternoDao {

    /**
     * Busca los gestores de un despacho.
     * @param idDespacho el id del despacho.
     * @return la lista de gestores.
     */
    @Override
    @SuppressWarnings("unchecked")
    public List<GestorDespacho> buscarGestoresDespacho(Long idDespacho) {
        String hql = "from GestorDespacho gd where gd.despachoExterno.id = ? and gd.supervisor=false and gd.auditoria.borrado = false and gd.usuario.auditoria.borrado = false";

        return getHibernateTemplate().find(hql, new Object[] { idDespacho });
    }

    /**
     * Busca los gestores de un despacho.
     * @param idDespacho el id del despacho.
     * @return la lista de gestores.
     */
    @Override
    @SuppressWarnings("unchecked")
    public List<GestorDespacho> buscarSupervisoresDespacho(Long idDespacho) {
        String hql = "from GestorDespacho gd where gd.despachoExterno.id = ? and gd.supervisor=true and gd.auditoria.borrado = false and gd.usuario.auditoria.borrado = false";
        return getHibernateTemplate().find(hql, new Object[] { idDespacho });
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public List<Usuario> buscarAllSupervisores() {
        String hqlUsuarios = "select distinct gd.usuario from GestorDespacho gd where gd.supervisor=true and gd.auditoria.borrado = false and gd.usuario.auditoria.borrado = false";
        return getHibernateTemplate().find(hqlUsuarios);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DespachoExterno> buscarDespachosPorTipoZona(String zonas, String tipoDespacho) {
        String arrayZonas[] = zonas.split(",");
        String hql = "select distinct dex from DespachoExterno dex where (";
        boolean first = true;
        for (String zona : arrayZonas) {
            if (!first)
                hql += " or ";
            else
                first = false;
            hql += " dex.zona.codigo like '" + zona + "%'";

        }
        hql += ")";
        hql += " and dex.tipoDespacho.codigo='" + tipoDespacho + "'";
        hql += " and dex.auditoria.borrado = false";
        return getHibernateTemplate().find(hql);
    }
    
    @Override
    public List<GestorDespacho> buscaDespachosPorUsuario(Long idUsuario) {
    	 String hql = "select distinct ged from GestorDespacho ged where" +
    	 		" ged.usuario.id = " + idUsuario +
    	 		" and ged.auditoria.borrado = 0";
    	 
		return getHibernateTemplate().find(hql);
	}
    
    @Override
    public List<GestorDespacho> buscaDespachosPorUsuarioYTipo(Long idUsuario, String ddTipoDespachoExterno) {
    	 String hql = "select distinct ged from GestorDespacho ged where" +
    	 		" ged.usuario.id = " + idUsuario +
    	 		" and ged.auditoria.borrado = 0" +
    	 		" and ged.despachoExterno.tipoDespacho.codigo='"+ddTipoDespachoExterno+"'";
    	 
//		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", idUsuario);
//		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
//		Filter filtroTipoDespacho = genericDao.createFilter(FilterType.EQUALS, "despachoExterno.tipoDespacho.codigo", DDTipoDespachoExterno.CODIGO_AGENCIA_RECOBRO);
//		List<GestorDespacho> despachos = genericDao.getList(GestorDespacho.class, filtroUsuario, filtroBorrado, filtroTipoDespacho);
    	 
		return getHibernateTemplate().find(hql);
	}

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public List<Usuario> getGestoresListadoDespachos(String listadoDespachos) {
        String hqlUsuarios = "select distinct gd.usuario from GestorDespacho gd where gd.supervisor=false and gd.auditoria.borrado = false and gd.despachoExterno.id IN ("
                + listadoDespachos + ") and gd.usuario.auditoria.borrado = false ";
        return getHibernateTemplate().find(hqlUsuarios);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public List<Usuario> getSupervisoresListadoDespachos(String listadoDespachos) {
        String hqlUsuarios = "select distinct gd.usuario from GestorDespacho gd where gd.supervisor=true and gd.auditoria.borrado = false and gd.despachoExterno.id IN ("
                + listadoDespachos + ") and gd.usuario.auditoria.borrado = false";
        return getHibernateTemplate().find(hqlUsuarios);
    }

	@Override
	public Page getDespachosExternosByTipo(String tipo,String query) {
		
		PageSql page = new PageSql();
		
		 String hql = "select distinct d from DespachoExterno d where d.auditoria.borrado = 0 and d.tipoDespacho.codigo = '"+tipo+"' ";
		
	        if(!Checks.esNulo(query)) {
	        	hql += " and (d.despacho like '%";
	        	hql += query;
	        	hql += "%' or upper(d.despacho) like '%";
	        	hql += query.toUpperCase();
	        	hql += "%' )";
	        }
	        
	     page.setResults(getHibernateTemplate().find(hql));  
	     
		return page;
	}

    
    @Override
    @SuppressWarnings("unchecked")
    public List<DespachoExterno> getDespachosAsociadosAlUsuario(Long idUsuario) {
    	String hql = "select distinct gd.despachoExterno from GestorDespacho gd where gd.auditoria.borrado = false and gd.usuario.id = "+idUsuario;
    	
    	return getHibernateTemplate().find(hql);
    }

}
