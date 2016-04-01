package es.capgemini.pfs.arquetipo.dao.imp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.type.Type;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.arquetipo.dao.ArquetipoDao;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;

/**
 * Dao de arquetipo.
 * @author jbosnjak
 *
 */
@Repository("ArquetipoDao")
public class ArquetipoDaoImpl extends AbstractEntityDao<Arquetipo, Long> implements ArquetipoDao {

    private static final String BUSCAR_ARQ_PREDEFINIDO = "SELECT arq_id FROM per_arq WHERE per_id = ? AND borrado = 0";

    /**
     * buscarArquetipoPredefinido.
     *
     * @param personaId Long
     * @return arquetipo
     */
    public Long buscarArquetipoPredefinido(Long personaId) {
        try {
            Object[] args = new Object[] { personaId };
            Type[] argsTypes = new Type[] { Hibernate.LONG };
            Long arquetipo = (Long) getSession().createSQLQuery(BUSCAR_ARQ_PREDEFINIDO).setParameters(args, argsTypes).uniqueResult();
            logger.debug("Se encontró el arquetipo predefinido " + arquetipo + " para la persona con id " + personaId);
            return arquetipo;
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Boolean isArquetipoRecuperacion(Long arquetipoId) {
        try {
            return get(arquetipoId).getItinerario().getdDtipoItinerario().getItinerarioRecuperacion();
        } catch (NullPointerException e) {
            return false;
        }
    }

    /**
     * {@inheritDoc}
     */
	@Override
	public Arquetipo getArquetipoPorNombre(String nombre) {
        String hql = " from Arquetipo where UPPER(nombre) = '" + nombre.toUpperCase() + "'";
        Session session = getHibernateTemplate().getSessionFactory().getCurrentSession();
        Query query = session.createQuery(hql);	        
        return (Arquetipo) query.list().get(0);
	}
	
    public Arquetipo getArquetipoPorPersona(Long idPersona){
    	
    	try{
    		
    		Arquetipo arquetipo = null;
    		
            Session session = getHibernateTemplate().getSessionFactory().getCurrentSession();
            String hql = "select arr.arquetipo "
            		+ "from ArquetipoRecuperacionPersona arr "
            		+ "where arr.persona.id = :id and rownum = 1 order by arr.arquetipoFecha desc";
            Query query = session.createQuery(hql);
            query.setParameter("id", idPersona);
            arquetipo = (Arquetipo) query.uniqueResult();
    		
    		return arquetipo;
    		
    	}catch(Exception e){
    		return null;
    	}
    	
    }

	@Override
	public List<Arquetipo> getListRecuperacion() {
		List<Arquetipo> arquetipos = this.getList();
		
		List<Arquetipo> arquetiposRecup = new ArrayList<Arquetipo>();
		
		for (Arquetipo arquetipo : arquetipos) {
			if ((!Checks.esNulo(arquetipo.getItinerario())) && 
					(arquetipo.getItinerario().getdDtipoItinerario().getItinerarioRecuperacion()) && 
					(!arquetipo.getAuditoria().isBorrado())) {
				arquetiposRecup.add(arquetipo);
			}
		}
		
		return arquetiposRecup;
		
	}

	@Override
	public List<Arquetipo> getListSeguimiento() {
		List<Arquetipo> arquetipos = this.getList();
		
		List<Arquetipo> arquetiposSeg = new ArrayList<Arquetipo>();
		
		for (Arquetipo arquetipo : arquetipos) {
			if ((!Checks.esNulo(arquetipo.getItinerario())) && 
					(arquetipo.getItinerario().getdDtipoItinerario().getItinerarioSeguimiento()) && 
					(!arquetipo.getAuditoria().isBorrado())) {
				arquetiposSeg.add(arquetipo);
			}
		}

		return arquetiposSeg;
	}
	
	@Override
	public List<Arquetipo> getListGestDeuda() {
		List<Arquetipo> arquetipos = this.getList();
		
		List<Arquetipo> arquetiposGestDeuda = new ArrayList<Arquetipo>();
		
		if (!Checks.esNulo(arquetipos))
		for (Arquetipo arquetipo : arquetipos) {
			if ( (!Checks.esNulo(arquetipo)) &&
				(!Checks.esNulo(arquetipo.getItinerario())) &&
				(arquetipo.getItinerario().getdDtipoItinerario().getItinerarioGestionDeuda()) &&
				(!arquetipo.getAuditoria().isBorrado()) ) {
				arquetiposGestDeuda.add(arquetipo);
			}
		}
		
		return arquetiposGestDeuda;
	}

}
