package es.capgemini.pfs.users.dao.impl;

import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.hibernate.Hibernate;
import org.hibernate.SQLQuery;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.devon.utils.PropertyPlaceholderUtils;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * @author Nicolás Cornaglia
 */
@Repository("UsuarioDao")
public class UsuarioDaoImpl extends AbstractEntityDao/*AbstractMasterDao*/<Usuario, Long> implements UsuarioDao {

    private static final String SELECT_AUTHORITIES = "select fun.FUN_descripcion from ${master.schema}.USU_USUARIOS usu, pfs01.PEF_PERFILES pef, pfs01.ZON_PEF_USU pu, pfs01.FUN_PEF fp, ${master.schema}.FUN_funciones fun where usu.USU_ID = ? and usu.USU_ID = pu.USU_ID and pef.PEF_ID = pu.PEF_ID and pef.PEF_ID = fp.PEF_ID and fun.FUN_ID = fp.FUN_ID and pu.borrado = 0 group by fun.FUN_descripcion";

    @Resource
    private PaginationManager paginationManager;

    @Resource
    private Properties appProperties;

    private String authoritiesQuery = null;

    /**
     * {@inheritDoc}
     */
    @PostConstruct
    public void initialize() {
        authoritiesQuery = PropertyPlaceholderUtils.resolve(SELECT_AUTHORITIES, appProperties);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Usuario> findByUsername(String usernameToFind) {
        if (usernameToFind == null) {
            usernameToFind = "";
        }
        return (getHibernateTemplate().find("from Usuario u where u.username like '%'||?||'%'", usernameToFind));
    }

    /**
     * {@inheritDoc}
     */
    public Page findByUsername(String usernameToFind, PaginationParams tableParams) {
        if (usernameToFind == null) {
            usernameToFind = "";
        }
        return paginationManager.getHibernatePage(getHibernateTemplate(), "from Usuario u where u.username like '%" + usernameToFind + "%'",
                tableParams);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public Usuario getByUsername(String usernameToFind) {
        List<Usuario> users = getHibernateTemplate().find("from Usuario u where u.username = ?", usernameToFind);
        if (users.size() == 0) {
            return null;
        } else if (users.size() > 1) {
            throw new DataIntegrityViolationException("Duplicate user: " + usernameToFind);
        } else {
            return users.get(0);
        }
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Deprecated
    public Set<GrantedAuthority> getAuthorities(Usuario usuario) {
        Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();

        SQLQuery query = getHibernateTemplate().getSessionFactory().getCurrentSession().createSQLQuery(authoritiesQuery);
        query.setCacheable(true);
        query.setLong(0, usuario.getId());
        List<String> authorityNames = query.list();

        for (String name : authorityNames) {
            GrantedAuthorityImpl a = new GrantedAuthorityImpl(name);
            authorities.add(a);
        }

        return authorities;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Usuario> getUsuariosZonaPerfil(Long idZona, Long idPerfil) {
        String hql = "from Usuario u where u.id IN (select zp.usuario from ZonaUsuarioPerfil zp where zp.zona.id = " + idZona
                + " and zp.perfil.id = " + idPerfil + " and zp.auditoria.borrado = 0)";
        return getHibernateTemplate().find(hql);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public List<Usuario> getUsuariosWithMail(Long idEntidad) {
        String hql = "from Usuario u where u.entidad.id = " + idEntidad + " and u.email is not null";
        List<Usuario> list = getHibernateTemplate().find(hql);

        for (Usuario usu : list) {
            Hibernate.initialize(usu.getZonaPerfil());
            Hibernate.initialize(usu.getPerfiles());
            Hibernate.initialize(usu.getZonas());
        }
        return list;
    }

}
