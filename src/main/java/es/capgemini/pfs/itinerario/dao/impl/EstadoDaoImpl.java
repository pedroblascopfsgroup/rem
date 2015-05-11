package es.capgemini.pfs.itinerario.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.dao.EstadoDao;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.capgemini.pfs.users.domain.Perfil;

/**
 * Implementación del dao de estados.
 * @author pajimene
 *
 */
@Repository("EstadoDao")
public class EstadoDaoImpl extends AbstractEntityDao<Estado, Long> implements EstadoDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public boolean existeGestorByPerfilEstadoItinerario(List<Perfil> perfiles, DDEstadoItinerario estadoItinerario) {

        if (perfiles.isEmpty()) { return false; }
        List ids = new ArrayList();
        for (Perfil perfil : perfiles) {
            ids.add(perfil.getId());
        }

        String listado = StringUtils.join(ids.iterator(), ",");

        String hql = " from Estado e where e.estadoItinerario = ? and e.gestorPerfil.id IN (" + listado + ")";

        List<Estado> estados = getHibernateTemplate().find(hql, new Object[] { estadoItinerario });

        if (estados != null && estados.size() > 0) { return true; }
        return false;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Estado getEstado(Itinerario itinerario, DDEstadoItinerario ddEstadoItinerario) {
        String hql = " from Estado e where e.estadoItinerario = ? and e.itinerario = ?";

        List<Estado> estados = getHibernateTemplate().find(hql, new Object[] { ddEstadoItinerario, itinerario });

        if (estados != null && estados.size() > 0) { return estados.get(0); }
        return null;
    }

}
