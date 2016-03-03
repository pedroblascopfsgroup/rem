package es.capgemini.pfs.security.dao.imp;

import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.hibernate.SQLQuery;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.utils.PropertyPlaceholderUtils;
import es.capgemini.pfs.dao.AbstractMasterDao;
import es.capgemini.pfs.security.dao.UsuarioSecurityDao;
import es.capgemini.pfs.security.model.UsuarioSecurity;

/**
 * @author Nicolás Cornaglia
 */
@Repository("UsuarioSecurityDao")
public class UsuarioSecurityDaoImpl extends AbstractMasterDao<UsuarioSecurity, Long> implements UsuarioSecurityDao {

    private static final String SELECT_AUTHORITIES = "select fun.FUN_descripcion from ${master.schema}.USU_USUARIOS usu, pfs01.PEF_PERFILES pef, pfs01.ZON_PEF_USU pu, pfs01.FUN_PEF fp, ${master.schema}.FUN_funciones fun where usu.USU_ID = ? and usu.USU_ID = pu.USU_ID and pef.PEF_ID = pu.PEF_ID and pef.PEF_ID = fp.PEF_ID and fun.FUN_ID = fp.FUN_ID and pu.borrado = 0 group by fun.FUN_descripcion";

    @Resource
    private Properties appProperties;

    private String authoritiesQuery = null;

    /**
     * Inicializa.
     */
    @PostConstruct
    public void initialize() {
        authoritiesQuery = PropertyPlaceholderUtils.resolve(SELECT_AUTHORITIES, appProperties);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public UsuarioSecurity getByUsername(String usernameToFind) {
        List<UsuarioSecurity> users = getHibernateTemplate().find("from UsuarioSecurity u where u.username = ? and u.auditoria.borrado = false",
                usernameToFind);
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
    @Override
    public UsuarioSecurity getByUsernameAndEntity(String usernameToFind, String workingCode) {
        List<UsuarioSecurity> users = getHibernateTemplate()
                .find(
                        "from UsuarioSecurity u where u.username = ? and u.auditoria.borrado = false and u.entidad.configuracion['workingCode'].dataValue = ?",
                        new Object[] { usernameToFind, workingCode });
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
    public Set<GrantedAuthority> getAuthorities(UsuarioSecurity usuario) {
        Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();

        SQLQuery query = getHibernateTemplate().getSessionFactory().getCurrentSession().createSQLQuery(authoritiesQuery);
        query.setLong(0, usuario.getId());
        query.setCacheable(true);
        List<String> authorityNames = query.list();

        for (String name : authorityNames) {
            GrantedAuthorityImpl a = new GrantedAuthorityImpl(name);
            authorities.add(a);
        }

        return authorities;
    }

}
