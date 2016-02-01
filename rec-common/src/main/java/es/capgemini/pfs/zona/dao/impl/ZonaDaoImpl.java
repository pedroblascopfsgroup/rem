package es.capgemini.pfs.zona.dao.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.zona.dao.ZonaDao;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * Implementación del dao zona.
 * @author pamuller
 *
 */
@Repository("ZonaDao")
public class ZonaDaoImpl extends AbstractEntityDao<DDZona, Long> implements ZonaDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DDZona> buscarZonasPorCodigoNivel(Long idNivel, Set<String> codigoZonasUsuario) {
        String hql = " from DDZona z where z.auditoria.borrado = 0 and z.nivel.id = ?";
        if (codigoZonasUsuario != null && codigoZonasUsuario.size() > 0) {
            hql += " and ( ";
            for (String cz : codigoZonasUsuario) {
                hql += " z.codigo like '" + cz + "%' or";
            }
            hql = hql.substring(0, hql.length() - 2);
            hql += " ) ";
        }
        return getHibernateTemplate().find(hql, idNivel);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public DDZona getZonaPorCentro(String centro) {
        List<DDZona> zonas = getHibernateTemplate().find("from DDZona z where z.centro = ?", centro);
        if (zonas.size() == 0) {
            return null;
        } else if (zonas.size() > 1) {
            throw new DataIntegrityViolationException("Duplicate zona: " + centro);
        } else {
            return zonas.get(0);
        }
    }

    /**
     * @param codigo String
     * @return Zona
     */
    @SuppressWarnings("unchecked")
    public DDZona getZonaPorCodigo(String codigo) {
        List<DDZona> zonas = getHibernateTemplate().find("from DDZona z where z.codigo = ?", codigo);
        if (zonas.size() == 0) {
            return null;
        } else if (zonas.size() > 1) {
            throw new DataIntegrityViolationException("Duplicate zona: " + codigo);
        } else {
            return zonas.get(0);
        }
    }

    /**
     * @param descripcion String
     * @return Zona
     */
    @SuppressWarnings("unchecked")
    public DDZona getZonaPorDescripcion(String descripcion) {
        List<DDZona> zonas = getHibernateTemplate().find("from DDZona z where z.descripcion = ?", descripcion);
        if (zonas.size() == 0) {
            return null;
        } else if (zonas.size() > 1) {
            throw new DataIntegrityViolationException("Duplicate zona: " + descripcion);
        } else {
            return zonas.get(0);
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void updateZonaUsuarioItinerante(Long idUsuario, Long idZona) {

        /**
         * Método 1
         */
        /*
        //Ejecutamos el update
        String sql = "UPDATE ZON_PEF_USU SET ZON_ID = " + idZona + " WHERE USU_ID = " + idUsuario;

        getSession().createSQLQuery(sql).executeUpdate();
         */

        /**
         * Método 2
         */
        //Ejecutamos el update
        String sql = "UPDATE ZON_PEF_USU SET ZON_ID = " + idZona + " WHERE USU_ID = " + idUsuario + " AND BORRADO = 0";

        Session sesion = getSession();

        try {
            sesion.createSQLQuery(sql).executeUpdate();
        } finally {
            releaseSession(sesion);
        }

        /**
         * Método 3
         */
        /*
        //Ejecutamos el update
        String sql = "UPDATE ZonaUsuarioPerfil set zona.id = ? WHERE usuario.id = ?";
        */
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<DDZona> findZonasBycodigo(Set<String> codigos) {
        if (codigos.size() == 0 || codigos.toString().equals("[]")) { return new ArrayList<DDZona>(); }
        Iterator<String> it = codigos.iterator();
        String lista = "";
        while (it.hasNext()) {
            if (lista.equals("")) {
                lista += "'" + it.next() + "'";
            } else {
                lista += ", '" + it.next() + "'";
            }
        }
        String hql = "from DDZona zon " + "where zon.codigo in (" + lista + ")" + "      and zon.auditoria." + Auditoria.UNDELETED_RESTICTION;
        return getHibernateTemplate().find(hql);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DDZona> buscarZonasPorPerfil(Long idPerfil) {
        String hql = "select distinct z from DDZona z, ZonaUsuarioPerfil zup " + " where zup.zona.id = z.id and zup.perfil.id = ? "
                + "and zup.auditoria." + Auditoria.UNDELETED_RESTICTION + " and z.auditoria." + Auditoria.UNDELETED_RESTICTION;
        return getHibernateTemplate().find(hql, idPerfil);
    }
    
    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DDZona> buscarZonasPorCodigoPerfil(String codPerfil) {
        String hql = "select distinct z from DDZona z, ZonaUsuarioPerfil zup " + " where zup.zona.id = z.id and zup.perfil.codigo = ? "
                + "and zup.auditoria." + Auditoria.UNDELETED_RESTICTION + " and z.auditoria." + Auditoria.UNDELETED_RESTICTION;
        return getHibernateTemplate().find(hql, codPerfil);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Boolean existePerfilZona(Long idZona, Long idPerfil) {
        String hql = "select count(*) from ZonaUsuarioPerfil zup where zup.perfil.id = :idPerfil " + " and zup.zona.id = :idZona and zup.auditoria."
                + Auditoria.UNDELETED_RESTICTION;

        Query query = getSession().createQuery(hql);
        query.setParameter("idPerfil", idPerfil);
        query.setParameter("idZona", idZona);
        Long total = (Long) query.uniqueResult();

        return (total != null && total > 0L);
    }
}
