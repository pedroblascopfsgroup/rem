package es.capgemini.pfs.politica.dao.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

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
import es.capgemini.pfs.politica.model.Politica;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.dao.ZonaDao;
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
    
    @Autowired
    private ZonaDao zonaDao;

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
    		
    		List<Objetivo> todosObjetivosPorGerarquiaZona = getHibernateTemplate().find(hql);	
    		List<Objetivo> objetivosQuePuedeVer = new ArrayList<Objetivo>();
    		
    		/*Agrupamos los objetivos en un map con la key politica*/
    		Map<Politica, List<Objetivo>> map = new HashMap<Politica, List<Objetivo>>();
    		for(Objetivo obj : todosObjetivosPorGerarquiaZona){
    			
    			if(!Checks.esNulo(map.get(obj.getPolitica()))){
    				map.get(obj.getPolitica()).add(obj);	
    			}else{
    				List<Objetivo> lisobj = new ArrayList<Objetivo>();
    				lisobj.add(obj);
    				map.put(obj.getPolitica(), lisobj);
    			}
    			
    		}
    		
    		/*Comprobamos si el usuario esta en la zon_pef_usu de nivel mas bajo existente*/
    		Iterator it = map.entrySet().iterator();
    		while (it.hasNext()) {
     	        Map.Entry politicaObjs = (Map.Entry)it.next();
     	        ///Obtenemos las zon pef usu del nivel mas bajo 
     	        Politica pol = (Politica) politicaObjs.getKey();
     	        List<ZonaUsuarioPerfil> zpusDeLaPol = zonaDao.getZonasPerfilesUsuariosPrimerNivelExistente(pol.getPerfilGestor().getId(), pol.getZonaGestor().getCodigo());
     	        
     	        List<Usuario> usuariosPuedenVer = new ArrayList<Usuario>();
     	        for(ZonaUsuarioPerfil zpu : zpusDeLaPol){
     	        	usuariosPuedenVer.add(zpu.getUsuario());
     	        }
     	        
     	        if(usuariosPuedenVer.contains(usuario)){
     	        	objetivosQuePuedeVer.addAll((Collection<? extends Objetivo>) politicaObjs.getValue());
     	        }
     	        
     	    }
    		
    		return objetivosQuePuedeVer;
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
    	
    	List<Objetivo> objs = buscarObjetivosPendientesGestor(usuario);

    	if(!Checks.estaVacio(objs)){
            return (long) objs.size();	
    	}else{
    		return (long) 0;
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
    
    private String armaWhereHQLObjetivosPendientes(Usuario usuario){
    	boolean tieneZona = false;
    	String hql = " where obj.auditoria.borrado = 0 AND obj.estadoCumplimiento.codigo = '"+DDEstadoCumplimiento.ESTADO_PENDIENTE+"' AND obj.estadoObjetivo.codigo = '"+DDEstadoObjetivo.ESTADO_CONFIRMADO+"' AND obj.politica.estadoPolitica.codigo = '"+DDEstadoPolitica.ESTADO_VIGENTE+"' AND (";
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
