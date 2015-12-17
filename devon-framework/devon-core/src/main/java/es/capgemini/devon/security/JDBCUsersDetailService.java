package es.capgemini.devon.security;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.context.ApplicationContextException;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.object.MappingSqlQuery;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.security.userdetails.jdbc.JdbcDaoImpl;
import org.springframework.util.Assert;

/**
 * Implementación de usuarios en base de datos, según las siguientes tablas:
 * 
 * CREATE TABLE USUARIO (
 *   ID               NUMBER(20)              NOT NULL,
 *   USERNAME         VARCHAR2(50)            NOT NULL,
 *   PASSWORD         VARCHAR2(50),
 *   NOMBRE           VARCHAR2(50),
 *   APELLIDO1        VARCHAR2(50),
 *   APELLIDO2        VARCHAR2(50),
 *   ENABLED          CHAR(1)                 DEFAULT 'Y' NOT NULL,
 *   CONSTRAINT PK_USUARIO PRIMARY KEY (ID),
 *   CONSTRAINT AK_USUARIO_USERNAME UNIQUE (USERNAME)
 * );
 *
 * CREATE TABLE AUTHORITY (
 *     USUARIO_ID      NUMBER(20)             NOT NULL,
 *     AUTHORITY       VARCHAR2(50)           NOT NULL,
 *     FOREIGN KEY (USUARIO_ID) REFERENCES USUARIO (ID)
 * );
 * 
 * @author Nicolás Cornaglia
 */
public class JDBCUsersDetailService extends JdbcDaoImpl {

    public static final String DEF_USERS_BY_USERNAME_QUERY = "SELECT id, username, password, enabled FROM Usuario WHERE username=?";
    public static final String DEF_AUTHORITIES_BY_USERNAME_QUERY = "SELECT u.username, a.authority FROM Usuario u, Authority a WHERE u.id = a.USUARIO_ID AND u.username=?";

    private String idAuthoritiesByUsernameQuery = DEF_USERS_BY_USERNAME_QUERY;
    private String idUsersByUsernameQuery = DEF_AUTHORITIES_BY_USERNAME_QUERY;

    private MappingSqlQuery authoritiesByUsernameMapping;
    private MappingSqlQuery usersByUsernameMapping;

    @Override
    protected void initDao() throws ApplicationContextException {
        Assert.isTrue(getEnableAuthorities() || getEnableGroups(), "Use of either authorities or groups must be enabled");
        initMappingSqlQueries();
    }

    private void initMappingSqlQueries() {
        this.usersByUsernameMapping = new IDUsersByUsernameMapping(getDataSource());
        this.authoritiesByUsernameMapping = new IDAuthoritiesByUsernameMapping(getDataSource());
    }

    @SuppressWarnings("unchecked")
    @Override
    protected List loadUserAuthorities(String username) {
        return authoritiesByUsernameMapping.execute(username);
    }

    @SuppressWarnings("unchecked")
    @Override
    protected List loadUsersByUsername(String username) {
        return usersByUsernameMapping.execute(username);
    }

    @Override
    protected UserDetails createUserDetails(String username, UserDetails userFromUserQuery, GrantedAuthority[] combinedAuthorities) {
        return new SecurityUser(((SecurityUser) userFromUserQuery).getId(), userFromUserQuery.getUsername(), userFromUserQuery.getPassword(),
                userFromUserQuery.isEnabled(), true, true, true, combinedAuthorities);
    }

    @Override
    public String getAuthoritiesByUsernameQuery() {
        return idAuthoritiesByUsernameQuery;
    }

    @Override
    public void setAuthoritiesByUsernameQuery(String authoritiesByUsernameQuery) {
        this.idAuthoritiesByUsernameQuery = authoritiesByUsernameQuery;
    }

    @Override
    public String getUsersByUsernameQuery() {
        return idUsersByUsernameQuery;
    }

    @Override
    public void setUsersByUsernameQuery(String usersByUsernameQuery) {
        this.idUsersByUsernameQuery = usersByUsernameQuery;
    }

    /**
     * Query object to look up a user's authorities.
     */
    private class IDAuthoritiesByUsernameMapping extends MappingSqlQuery {

        protected IDAuthoritiesByUsernameMapping(DataSource ds) {
            super(ds, idUsersByUsernameQuery);
            declareParameter(new SqlParameter(Types.VARCHAR));
            compile();
        }

        @Override
        protected Object mapRow(ResultSet rs, int rownum) throws SQLException {
            String roleName = getRolePrefix() + rs.getString(2);
            GrantedAuthorityImpl authority = new GrantedAuthorityImpl(roleName);

            return authority;
        }
    }

    /**
     * Query object to look up a user.
     */
    private class IDUsersByUsernameMapping extends MappingSqlQuery {

        protected IDUsersByUsernameMapping(DataSource ds) {
            super(ds, idAuthoritiesByUsernameQuery);
            declareParameter(new SqlParameter(Types.VARCHAR));
            compile();
        }

        @Override
        protected Object mapRow(ResultSet rs, int rownum) throws SQLException {
            Long id = rs.getLong(1);
            String username = rs.getString(2);
            String password = rs.getString(3);
            boolean enabled = "Y".equals(rs.getString(4)) ? true : false;
            SecurityUser user = new SecurityUser(id, username, password, enabled, true, true, true,
                    new GrantedAuthority[] { new GrantedAuthorityImpl("HOLDER") });

            return user;
        }
    }

}
