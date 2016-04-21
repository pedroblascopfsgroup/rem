package es.capgemini.pfs.politica.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.Query;
import org.hibernate.annotations.Check;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Expression;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.DDEstadoCumplimientoDao;
import es.capgemini.pfs.politica.dao.ObjetivoDao;
import es.capgemini.pfs.politica.model.DDEstadoCumplimiento;
import es.capgemini.pfs.politica.model.DDEstadoObjetivo;
import es.capgemini.pfs.politica.model.DDEstadoPolitica;
import es.capgemini.pfs.politica.model.Objetivo;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.Checks;

/**
 * Implementación de la interfaz de acceso a datos para objetivos.
 * @author pamuller
 *
 */
@Repository("ObjetivoDao")
public class ObjetivoDaoImpl extends AbstractEntityDao<Objetivo, Long> implements ObjetivoDao {

    @Autowired
    private DDEstadoCumplimientoDao estadoCumplimientoDao;

    /**
     * Devuelve la lista de objetivos pendientes.
     * @return la lista de objetivos pendientes.
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Objetivo> getObjetivosPendientes() {
        String hql = "from Objetivo o where o.auditoria.borrado = 0 and o.estadoCumplimiento.codigo = '" + DDEstadoCumplimiento.ESTADO_PENDIENTE
                + "'";
        List<Objetivo> lista = getHibernateTemplate().find(hql);
        for (Objetivo o : lista) {
            Hibernate.initialize(o.getPolitica().getCicloMarcadoPolitica().getPersona());
            Hibernate.initialize(o.getPolitica().getCicloMarcadoPolitica().getPersona().getContratosPersona());
            Hibernate.initialize(o.getPolitica().getCicloMarcadoPolitica().getPersona().getContratos());
        }
        return lista;
    }

    /**
     * Marca un objetivo como cumplido.
     * @param o el objetivo a marcar
     */
    @Override
    public void marcarComoCumplido(Objetivo o) {
        o.setEstadoCumplimiento(estadoCumplimientoDao.buscarPorCodigo(DDEstadoCumplimiento.ESTADO_CUMPLIDO));
        saveOrUpdate(o);
    }

    /**
     * Marca el objetivo como incumplido.
     * @param o el objetivo a marcar.
     */
    @Override
    public void marcarComoIncumplido(Objetivo o) {
        o.setEstadoCumplimiento(estadoCumplimientoDao.buscarPorCodigo(DDEstadoCumplimiento.ESTADO_INCUMPLIDO));
        saveOrUpdate(o);
    }

    /**
     * Busca los objetivos pendientes para el gestor.
     * @param usuario el usuario en cuestión
     * @param zonas la lista de zonas
     * @return la lista de objetivos pendientes para ese usuario en esa zona.
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Objetivo> buscarObjetivosPendientesGestor(Usuario usuario, List<DDZona> zonas) {
        DetachedCriteria crit = armarCriteriaObjetivosPendientes(usuario, zonas);

        return getHibernateTemplate().findByCriteria(crit);
    }
    
    /**
     * Busca los objetivos pendientes para el gestor.
     * @param usuario el usuario en cuestión
     * @return la lista de objetivos pendientes para ese usuario en esa zona.
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Objetivo> buscarObjetivosPendientesGestor(Usuario usuario) {
        
    	String hql = armaHQLObjetivosPendientes(usuario);

    	if(!Checks.esNulo(hql)){
    		return getHibernateTemplate().find(hql);	
    	}else{
    		return null;
    	}
    	
    }

    /**
     * Obtiene la cantidad de objetivos pendientes para el gestor.
     * @param usuario el usuario logado
     * @param zonas la lista de zonas del usuario logado
     * @return integer
     */
    @Override
    public Integer cantidadObjetivosPendientesGestor(Usuario usuario, List<DDZona> zonas) {
        DetachedCriteria crit = armarCriteriaObjetivosPendientes(usuario, zonas);
        crit.setProjection(Projections.rowCount());
        return (Integer) getHibernateTemplate().findByCriteria(crit).get(0);
    }
    
    /**
     * Obtiene la cantidad de objetivos pendientes para el gestor.
     * @param usuario el usuario logado
     * @return integer
     */
    @Override
    public Long cantidadObjetivosPendientesGestor(Usuario usuario) {
    	
    	String hql = armaHQLObjetivosPendientesCount(usuario);

    	if(!Checks.esNulo(hql)){
            Query query = getSession().createQuery(hql);
            return (Long) query.uniqueResult();	
    	}else{
    		return null;
    	}
    }

    /**
     * Arma el detachedCriteria para la busqueda de objetivos.
     * @param usuario
     * @param zonas
     * @return
     */
    private DetachedCriteria armarCriteriaObjetivosPendientes(Usuario usuario, List<DDZona> zonas) {
        DetachedCriteria crit = DetachedCriteria.forClass(Objetivo.class);

        crit.createCriteria("politica").add(Restrictions.in("perfilGestor", usuario.getPerfiles())).add(Restrictions.in("zonaGestor", zonas))
                .createCriteria("estadoPolitica").add(Restrictions.eq("codigo", DDEstadoPolitica.ESTADO_VIGENTE));
        crit.add(Expression.eq("auditoria.borrado", Boolean.FALSE));

        crit.createCriteria("estadoObjetivo").add(Expression.eq("codigo", DDEstadoObjetivo.ESTADO_CONFIRMADO));
        crit.createCriteria("estadoCumplimiento").add(Expression.eq("codigo", DDEstadoCumplimiento.ESTADO_PENDIENTE));
        return crit;
    }
    
    private String armaHQLObjetivosPendientes(Usuario usuario){
    	String where = armaWhereHQLObjetivosPendientes(usuario);
    	if(!Checks.esNulo(where)){
    		return "from Objetivo obj "+where;
    	}else{
    		return null;
    	}
    }
    
    private String armaHQLObjetivosPendientesCount(Usuario usuario){
    	String where = armaWhereHQLObjetivosPendientes(usuario);
    	if(!Checks.esNulo(where)){
    		return "select count(*) from Objetivo obj "+where;
    	}else{
    		return null;
    	}
    }
    
    private String armaWhereHQLObjetivosPendientes(Usuario usuario){
    	boolean tieneZona = false;
    	String hql = " where obj.auditoria.borrado AND obj.estadoCumplimiento.codigo = '"+DDEstadoCumplimiento.ESTADO_PENDIENTE+"' AND obj.estadoObjetivo.codigo = '"+DDEstadoObjetivo.ESTADO_CONFIRMADO+"' AND obj.politica.estadoPolitica.codigo = '"+DDEstadoPolitica.ESTADO_VIGENTE+"' AND (";
    		for(ZonaUsuarioPerfil zpu : usuario.getZonaPerfil()){
    			hql += "(obj.politica.perfilGestor.id = "+zpu.getPerfil().getId()+" and obj.politica.zonaGestor.codigo LIKE '"+zpu.getZona().getCodigo()+"%') OR";
    			tieneZona = true;
    		}
    		hql = hql.substring(0, hql.length() - 2);
    		hql += ")";
    	
    	if(tieneZona){
    		return hql;	
    	}else{
    		return null;
    	}
    }

    /**
     * @return the estadoCumplimientoDao
     */
    public DDEstadoCumplimientoDao getEstadoCumplimientoDao() {
        return estadoCumplimientoDao;
    }

    /**
     * @param estadoCumplimientoDao the estadoCumplimientoDao to set
     */
    public void setEstadoCumplimientoDao(DDEstadoCumplimientoDao estadoCumplimientoDao) {
        this.estadoCumplimientoDao = estadoCumplimientoDao;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Objetivo> getObjetivosActivos(Long idPolitica) {
        DetachedCriteria crit = DetachedCriteria.forClass(Objetivo.class);

        crit.createCriteria("politica").add(Restrictions.eq("id", idPolitica));
        crit.createCriteria("estadoObjetivo").add(Expression.ne("codigo", DDEstadoObjetivo.ESTADO_BORRADO)).add(
                Expression.ne("codigo", DDEstadoObjetivo.ESTADO_CANCELADO)).add(Expression.ne("codigo", DDEstadoObjetivo.ESTADO_RECHAZADO));

        return getHibernateTemplate().findByCriteria(crit);
    }
}
