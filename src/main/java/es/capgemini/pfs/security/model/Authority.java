package es.capgemini.pfs.security.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.springframework.security.GrantedAuthority;

/**
 * Entidad deprecada Authority.
 * @author aesteban
 *
 */
@Entity
@Table(name = "Role")
@Deprecated
public class Authority implements GrantedAuthority, Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    private String role;

    /**
     * @return Sring
     */
    public String getAuthority() {
        return role;
    }

    /**
     * @param role string
     */
    public void setAuthority(String role) {
        this.role = role;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int compareTo(Object o) {
        if (o != null && o instanceof Authority) {
            Authority rhs = (Authority) o;
            return this.role.compareTo(rhs.getAuthority());
        }
        return -1;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean equals(Object obj) {
        if (obj instanceof String) {
            return obj.equals(this.role);
        }
        if (obj instanceof Authority) {
            Authority attr = (Authority) obj;
            return this.role.equals(attr.getAuthority());
        }
        return false;
    }

    /**
     * hashcode.
     * @return hashcode
     */
    @Override
    public int hashCode() {
        if (getAuthority() != null) {
            return getAuthority().hashCode();
        }
        return super.hashCode();
    }

    /**
     * {@inheritDoc}
     */

    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }
}
