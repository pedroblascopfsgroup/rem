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
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.dao.ZonaDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;

import java.math.BigDecimal;

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
    
    @SuppressWarnings("unchecked")
    @Override
    public List<DDZona> getZonasJerarquiaByCodDesc(Integer idNivel, Set<String> codigoZonasUsuario, String codDesc) {
        String hql = " from DDZona z where z.auditoria.borrado = 0 and z.nivel.codigo = ?";
        if (codigoZonasUsuario != null && codigoZonasUsuario.size() > 0) {
            hql += " and ( ";
            for (String cz : codigoZonasUsuario) {
                hql += " z.codigo like '" + cz + "%' or";
            }
            hql = hql.substring(0, hql.length() - 2);
            hql += " ) ";
        }
        if(!Checks.esNulo(codDesc)) {
        	hql += " and ( z.codigo like '%";
        	hql += codDesc;
        	hql += "%' or z.descripcion like '%";
        	hql += codDesc;
        	hql += "%' )";
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
    
    /**
     * Método que devuelve las zonas a partir del usuario y el perfil
     * @param idUsuario
     * @param codPerfil
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<DDZona> getZonaPorUsuarioPerfil(Long idUsuario, String codPerfil) {
    	String hql = "select distinct z.zona from ZonaUsuarioPerfil z where z.perfil.codigo = :codPerfil" +
    			" and z.usuario.id = :idUsuario and z.auditoria." + Auditoria.UNDELETED_RESTICTION;
    	Query query = getSession().createQuery(hql);
        query.setParameter("codPerfil", codPerfil);
        query.setParameter("idUsuario", idUsuario);
        List<DDZona> zonas = query.list();
        if (Checks.esNulo(zonas) || zonas.size()==0) {
            return null;
        } else /*if (zonas.size() == 1)*/ {
        	return zonas; 
        } //else {
        //	throw new DataIntegrityViolationException("Duplicate zona de usuario: " + idUsuario + " perfil: "+codPerfil);
      //  }
    }
    
    /**
     * Guarda un nuevo registro en ZON_PEF_USU, si no existe ya (se comrpueba que no haya ya un registro con la zona,
     * el perfil, y el usuario pasados por parametro)
     */
    public void guardarNuevoZonaPerfilUsuario(DDZona zona, Usuario usuario, String codPerfil) {
    	String sqlSecuence = "SELECT S_ZON_PEF_USU.NEXTVAL FROM DUAL";
    	Long secuenciaHistorico = ((BigDecimal)getSession().createSQLQuery(sqlSecuence).uniqueResult()).longValue();
    	
    	Perfil perfil = (Perfil) getHibernateTemplate().find("from Perfil p where p.codigo = ? and p.auditoria.borrado=0", codPerfil).get(0);
    	
    	String hql = "select * from ZON_PEF_USU where zon_id="+zona.getId()+" and pef_id="+perfil.getId()+" and usu_id="+usuario.getId() +" and borrado=0";
    	if(getSession().createSQLQuery(hql).list().size() == 0)
    	{
	    	hql = "insert into ZON_PEF_USU (zpu_id,zon_id, pef_id, usu_id, version, usuariocrear,fechacrear,borrado) "
	    			+ "select "+secuenciaHistorico+", "+zona.getId()+", "+perfil.getId()+", "+usuario.getId()+", "+0+", '"+usuario.getUsername()+"', TRUNC(sysdate),"+0+" from dual";
	    	getSession().createSQLQuery(hql).executeUpdate();
    	}
    }
}
