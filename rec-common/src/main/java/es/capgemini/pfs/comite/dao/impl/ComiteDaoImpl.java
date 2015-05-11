package es.capgemini.pfs.comite.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.comite.dao.ComiteDao;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.Nivel;

/**
 * @author Andrés Esteban
 *
 */
@Repository("ComiteDao")
public class ComiteDaoImpl extends AbstractEntityDao<Comite, Long> implements ComiteDao {

    /**
     * {@inheritDoc}
     */
    @Override
    public Comite get(Long id) {
        Comite comite = super.get(id);
        return comite;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void saveOrUpdate(Comite t) {
        super.saveOrUpdate(t);
        getHibernateTemplate().flush();
    }

    /**
     * Busca el comité al que se enviaría un expediente en el caso de querer elevarlo.
     * @param c el comité actual
     * @return el nuevo comité o null si no hay ninguno.
     */
    @SuppressWarnings("unchecked")
    public Comite buscarComiteParaElevar(Comite c) {
        StringBuffer hql = new StringBuffer(1024);
        hql.append(" select c");
        hql.append(" from Comite c");
        hql.append(" where c.prioridad > :prioridad");
        hql.append(" and c.zona.nivel.id = :nivel");
        hql.append(" and not exists (select c1 from Comite c1 " + "where c1.prioridad < c.prioridad and c1.prioridad>:prioridad "
                + "and c1.zona.nivel.id = :nivel)");
        hql.append(" and exists (from c.itinerarios iti where iti in (:itinerario))");
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("prioridad", c.getPrioridad());
        params.put("nivel", c.getZona().getNivel().getId());
        if (c.getItinerarios() == null || c.getItinerarios().size() == 0)
            params.put("itinerario", -1);
        else
            params.put("itinerario", c.getItinerarios());
        Query query = getSession().createQuery(hql.toString());
        query.setProperties(params);
        List<Comite> results = query.list();
        if (results.size() > 0) {
            //encontró alguno que sirve, devuelvo el primero
            //TODO ver si en el caso de que haya más de 1, hay algún otro criterio para decidir
            return results.get(0);
        }
        //buscamos en el nivel superior
        //En nivel superior es aquel tal que el id del nivel es = nivel-1...
        if (c.getZona().getNivel().getId() == 1) {
            //Está en el nivel superior y no se encontró otro al mismo nivel.
            return null;
        }
        hql = new StringBuffer(1024);
        hql.append("select c");
        hql.append(" from Comite c");
        hql.append(" where c.zona.nivel.id = :nivel");
        hql.append(" and not exists (select c1 from Comite c1 where c1.zona.nivel=:nivel and c1.prioridad<c.prioridad)");
        hql.append(" and exists (from c.itinerarios iti where iti in (:itinerario))");
        query = getSession().createQuery(hql.toString());
        params = new HashMap<String, Object>();
        params.put("nivel", (c.getZona().getNivel().getId() - 1L));
        if (c.getItinerarios() == null || c.getItinerarios().size() == 0)
            params.put("itinerario", -1);
        else
            params.put("itinerario", c.getItinerarios());
        query.setProperties(params);
        results = query.list();
        if (results.size() > 0) {
            //TODO de nuevo, ver si hay otro criterio de selección en este caso
            return results.get(0);
        }
        return null;

    }

    /**
     * Busca los comités a los que podría delegar.
     * @param comite el comité actual.
     * @return la lista de comités a los que puede delegar.
     */
    @SuppressWarnings("unchecked")
    public List<Comite> buscarComitesParaDelegar(Comite comite) {
        StringBuffer hql = new StringBuffer(1024);
        hql.append("select c from Comite c");
        hql.append(" where c.zona.nivel.id = :nivel");
        hql.append(" and c.prioridad<:prioridad");
        hql.append(" and exists (from c.itinerarios iti where iti in (:itinerario))");
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("prioridad", comite.getPrioridad());
        params.put("nivel", comite.getZona().getNivel().getId());

        if (comite.getItinerarios() == null || comite.getItinerarios().size() == 0)
            params.put("itinerario", -1);
        else
            params.put("itinerario", comite.getItinerarios());

        Query query = getSession().createQuery(hql.toString());
        query.setProperties(params);
        List<Comite> results = query.list();
        if (results.size() > 0) {
            //Hay comités al mismo nivel con menor prioridad, lo puede delegar.
            return results;
        }
        String hqlNiveles = "from Nivel where id > ?";
        List<Nivel> niveles = getHibernateTemplate().find(hqlNiveles, comite.getZona().getNivel().getId());
        if (niveles.size() < 1) {
            //No hay un nivel inferior, devolvemos una lista vacía
            return new ArrayList<Comite>();
        }
        hql = new StringBuffer(1024);
        hql.append("select c from Comite c");
        hql.append(" where c.zona.nivel.id = :nivel");
        hql.append(" and exists (from c.itinerarios iti where iti in (:itinerario))");
        params = new HashMap<String, Object>();
        params.put("nivel", comite.getZona().getNivel().getId() + 1);

        if (comite.getItinerarios() == null || comite.getItinerarios().size() == 0)
            params.put("itinerario", -1);
        else
            params.put("itinerario", comite.getItinerarios());

        query = getSession().createQuery(hql.toString());
        query.setProperties(params);
        results = query.list();
        //Se devuelve el resultado, como ya no hay más opciones no importa si devolvió o no registros.
        return results;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<Comite> findComitesValidosCurrentUser(Usuario usuario) {

        /*
        for (Perfil perfil : usuario.getPerfiles()) {
            for (PuestosComite puesto : perfil.getPuestosComites()) {
                if (usuario.getZonas().contains(puesto.getZona())) {
                    comites.add(get(puesto.getComite().getId()));
                }
            }
        }
        
         if (!comite.getExpedientes().isEmpty() || !comite.getPreasuntos().isEmpty()
                    || Comite.INICIADO.equals(Comite.calcularEstado(comite.getUltimaSesion()))) {
                    
             if (sesion.getFechaInicio() != null && sesion.getFechaFin() == null) { return INICIADO; }
         
         */

        StringBuilder sb = new StringBuilder();

        //Comites del mismo perfil-zona
        sb.append("select distinct c from ZonaUsuarioPerfil zpu, PuestosComite pco, Comite c ");
        sb.append("WHERE c.auditoria.borrado = false and pco.auditoria.borrado = false and zpu.auditoria.borrado = false ");
        sb.append("and zpu.zona.id = pco.zona.id and pco.comite.id = c.id and zpu.usuario.id = ? ");
        sb.append("and (");

        //Que tenga expedientes
        sb.append("exists (select e from Expediente e where e.comite.id= c.id and e.auditoria.borrado = false) ");

        //O que tenga asuntos
        sb.append("or exists (select a from Asunto a where a.comite.id = c.id and a.auditoria.borrado = false) ");

        //Que esté iniciado    
        sb.append("or exists (select s from SesionComite s where s.fechaInicio = (");
        sb.append("select max(fechaInicio) from SesionComite where comite.id = s.comite.id) and s.comite.id = c.id and fechaFin is null)) ");

        return getHibernateTemplate().find(sb.toString(), usuario.getId());
    }
}
