package es.capgemini.pfs.security.model;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.WhereJoinTable;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.userdetails.UserDetails;

import es.capgemini.devon.security.SecurityUserInfo;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dsm.model.Entidad;

/**
 * TODO Documentar.
 *
 * @author Nicolás Cornaglia
 */
@Entity
@Table(name = "USU_USUARIOS", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class UsuarioSecurity implements SecurityUserInfo, UserDetails, Serializable, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "USU_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "UsuarioGenerator")
    @SequenceGenerator(name = "UsuarioGenerator", sequenceName = "${master.schema}.S_USU_USUARIOS")
    private Long id;

    @Column(name = "USU_USERNAME")
    private String username;

    @Column(name = "USU_PASSWORD")
    private String password;

    @Transient
    private Long loginTime;

    @Transient
    private String remoteAddress;

    /**
     * @return the fechaVigenciaPassword
     */
    public Date getFechaVigenciaPassword() {
        return fechaVigenciaPassword;
    }

    /**
     * @param fechaVigenciaPassword the fechaVigenciaPassword to set
     */
    public void setFechaVigenciaPassword(Date fechaVigenciaPassword) {
        this.fechaVigenciaPassword = fechaVigenciaPassword;
    }

    @Column(name = "USU_FECHA_VIGENCIA_PASS")
    private Date fechaVigenciaPassword;

    @JoinColumn(name = "ENTIDAD_ID")
    @ManyToOne(fetch = FetchType.EAGER)
    private Entidad entidad;

    @Transient
    private Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinTable(name = "ZON_PEF_USU", schema = "${entity.schema}", joinColumns = { @JoinColumn(name = "USU_ID") }, inverseJoinColumns = @JoinColumn(name = "PEF_ID"))
    @WhereJoinTable(clause = Auditoria.UNDELETED_RESTICTION)
    private Set<PerfilSecurity> perfiles = null;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    // Not implemented yet
    @Transient
    private boolean enabled = true;
    @Transient
    private boolean accountNonExpired = true;
    @Transient
    private boolean accountNonLocked = true;
    @Transient
    private boolean credentialsNonExpired = true;

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }

    /**
     * @see org.springframework.security.userdetails.UserDetails#getAuthorities()
     * @return GrantedAuthority[]
     */
    @Override
    public GrantedAuthority[] getAuthorities() {
        return authorities.toArray(new GrantedAuthority[0]);
    }

    /**
     * @see org.springframework.security.userdetails.UserDetails#isAccountNonExpired()
     * @return boolean
     */
    @Override
    public boolean isAccountNonExpired() {
        return accountNonExpired;
    }

    /**
     * @see org.springframework.security.userdetails.UserDetails#isAccountNonLocked()
     * @return boolean
     */
    @Override
    public boolean isAccountNonLocked() {
        return accountNonLocked;
    }

    /**
     * @see org.springframework.security.userdetails.UserDetails#isCredentialsNonExpired()
     * @return boolean
     */
    @Override
    public boolean isCredentialsNonExpired() {
        return credentialsNonExpired;
    }

    /**
     * @see org.springframework.security.userdetails.UserDetails#isEnabled()
     * @return boolean
     */
    @Override
    public boolean isEnabled() {
        return this.enabled;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean equals(Object rhs) {
        if ((rhs == null) || !(rhs instanceof UsuarioSecurity)) { return false; }

        UsuarioSecurity user = (UsuarioSecurity) rhs;

        // We rely on constructor to guarantee any User has non-null and >0
        // authorities
        if (user.getAuthorities().length != this.getAuthorities().length) { return false; }

        for (int i = 0; i < this.getAuthorities().length; i++) {
            if (!this.getAuthorities()[i].equals(user.getAuthorities()[i])) { return false; }
        }

        if ((this.getPassword() != null && user.getPassword() == null) || (this.getPassword() == null && user.getPassword() != null)
                || (this.getPassword() != null && user.getPassword() != null && !this.getPassword().equals(user.getPassword()))) { return false; }

        // We rely on constructor to guarantee non-null username and password
        return (this.getUsername().equals(user.getUsername()) && (this.isAccountNonExpired() == user.isAccountNonExpired())
                && (this.isAccountNonLocked() == user.isAccountNonLocked()) && (this.isCredentialsNonExpired() == user.isCredentialsNonExpired()) && (this
                .isEnabled() == user.isEnabled()));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int hashCode() {
        final int initCode = 9292;
        final int seven = 7;
        final int two = 2;
        final int five = 5;
        final int three = 3;
        int code = initCode;

        if (this.getAuthorities() != null) {
            for (int i = 0; i < this.getAuthorities().length; i++) {
                code = code * (this.getAuthorities()[i].hashCode() % seven);
            }
        }

        if (this.getPassword() != null) {
            code = code * (this.getPassword().hashCode() % seven);
        }

        if (this.getUsername() != null) {
            code = code * (this.getUsername().hashCode() % seven);
        }

        if (this.isAccountNonExpired()) {
            code = code * -two;
        }

        if (this.isAccountNonLocked()) {
            code = code * -three;
        }

        if (this.isCredentialsNonExpired()) {
            code = code * -five;
        }

        if (this.isEnabled()) {
            code = code * -seven;
        }

        return code;
    }

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the username
     */
    public String getUsername() {
        return username;
    }

    /**
     * @param username the username to set
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * @return the password
     */
    public String getPassword() {
        return password;
    }

    /**
     * @param password the password to set
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * @return the entidad
     */
    public Entidad getEntidad() {
        return entidad;
    }

    /**
     * @param entidad the entidad to set
     */
    public void setEntidad(Entidad entidad) {
        this.entidad = entidad;
    }

    /**
     * @return the perfiles
     */
    public Set<PerfilSecurity> getPerfiles() {
        return perfiles;
    }

    /**
     * @param perfiles the perfiles to set
     */
    public void setPerfiles(Set<PerfilSecurity> perfiles) {
        this.perfiles = perfiles;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @param authorities the authorities to set
     */
    public void setAuthorities(Set<GrantedAuthority> authorities) {
        this.authorities = authorities;
    }

    /**
     * @param enabled the enabled to set
     */
    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    /**
     * @param accountNonExpired the accountNonExpired to set
     */
    public void setAccountNonExpired(boolean accountNonExpired) {
        this.accountNonExpired = accountNonExpired;
    }

    /**
     * @param accountNonLocked the accountNonLocked to set
     */
    public void setAccountNonLocked(boolean accountNonLocked) {
        this.accountNonLocked = accountNonLocked;
    }

    /**
     * @return the loginTime
     */
    public Long getLoginTime() {
        return loginTime;
    }

    /**
     * @param loginTime the loginTime to set
     */
    public void setLoginTime(Long loginTime) {
        this.loginTime = loginTime;
    }

    /**
     * @return the remoteAddress
     */
    public String getRemoteAddress() {
        return remoteAddress;
    }

    /**
     * @param remoteAddress the remoteAddress to set
     */
    public void setRemoteAddress(String remoteAddress) {
        this.remoteAddress = remoteAddress;
    }

}
