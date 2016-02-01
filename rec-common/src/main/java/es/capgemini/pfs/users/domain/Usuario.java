package es.capgemini.pfs.users.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;
import javax.validation.constraints.NotNull;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;
import org.hibernate.validator.constraints.Length;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;

/**
 * Clase usuario.
 */

@Entity
@Table(name = "USU_USUARIOS", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class Usuario implements Serializable, Auditable {
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

    @Column(name = "USU_NOMBRE")
    @NotNull
    @Length(max = 10)
    private String nombre;

    @Column(name = "USU_APELLIDO1")
    private String apellido1;

    @Column(name = "USU_APELLIDO2")
    private String apellido2;

    @Column(name = "USU_MAIL")
    private String email;

    @Column(name = "USU_TELEFONO")
    private String telefono;

    @Column(name = "USU_EXTERNO")
    private Boolean usuarioExterno;

    @Column(name = "USU_FECHA_VIGENCIA_PASS")
    private Date fechaVigenciaPassword;

    @JoinColumn(name = "ENTIDAD_ID")
    @ManyToOne(fetch = FetchType.EAGER)
    private Entidad entidad;
    
    @Column(name = "USU_GRUPO")
    private Boolean usuarioGrupo;

    /*@OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinTable(name = "ZON_PEF_USU", schema = "${entity.schema}", joinColumns = { @JoinColumn(name = "USU_ID") }, inverseJoinColumns = @JoinColumn(name = "PEF_ID"))
    private Set<Perfil> perfiles = null;*/

    /*@OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinTable(name = "ZON_PEF_USU", schema = "${entity.schema}", joinColumns = { @JoinColumn(name = "USU_ID") }, inverseJoinColumns = @JoinColumn(name = "ZON_ID"))
    private final Set<Zona> zonas = null;*/

    @OneToMany(mappedBy = "usuario")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ZonaUsuarioPerfil> zonaPerfil;
    
    @OneToMany(mappedBy = "usuario")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<UsuEntidad> usuEntidad;
    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    @Transient
    private boolean enabled = true;

    @Transient
    private final Log logger = LogFactory.getLog(getClass());

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }

    /**
     * Obtiene el nivel mas alto del usuario.
     * @return nivel
     */
    public Long getMaximoNivelZona() {
        Long nivel = null;
        for (ZonaUsuarioPerfil z : getZonaPerfil()) {
            Long codigo = z.getZona().getNivel().getId();
            if (nivel == null || nivel.longValue() > codigo.longValue()) {
                nivel = codigo;
            }
        }
        return nivel;
    }

    /**
     * retorna el codigo de zonas del usuario.
     * @return zonas
     */
    public Set<String> getCodigoZonas() {
        Set<String> codZonas = new HashSet<String>();
        for (ZonaUsuarioPerfil z : getZonaPerfil()) {
            codZonas.add(z.getZona().getCodigo());
        }
        return codZonas;
    }

    /**
     * Retorna todos los apellidos.
     * @return string
     */
    public String getApellidos() {
        String apellidos = "";
        if (apellido1 != null) {
            apellidos += apellido1 + " ";
        }
        if (apellido2 != null) {
            apellidos += apellido2;
        }
        return apellidos;
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
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * @return the apellido1
     */
    public String getApellido1() {
        return apellido1;
    }

    /**
     * @param apellido1 the apellido1 to set
     */
    public void setApellido1(String apellido1) {
        this.apellido1 = apellido1;
    }

    /**
     * @return the apellido2
     */
    public String getApellido2() {
        return apellido2;
    }

    /**
     * @param apellido2 the apellido2 to set
     */
    public void setApellido2(String apellido2) {
        this.apellido2 = apellido2;
    }

    /**
     * @return the email
     */
    public String getEmail() {
        return email;
    }

    /**
     * @param email the email to set
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * @return the telefono
     */
    public String getTelefono() {
        return telefono;
    }

    /**
     * @param telefono the telefono to set
     */
    public void setTelefono(String telefono) {
        this.telefono = telefono;
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
     * @return the enabled
     */
    public boolean isEnabled() {
        return enabled;
    }

    /**
     * @param enabled the enabled to set
     */
    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    /**
     * @return the zonaPerfil
     */
    public List<ZonaUsuarioPerfil> getZonaPerfil() {
        return zonaPerfil;
    }

    /**
     * @param zonaPerfil the zonaPerfil to set
     */
    public void setZonaPerfil(List<ZonaUsuarioPerfil> zonaPerfil) {
        this.zonaPerfil = zonaPerfil;
    }
    
    public List<UsuEntidad> getUsuEntidad() {
		return usuEntidad;
	}
    
    public void setUsuEntidad(List<UsuEntidad> usuEntidad) {
		this.usuEntidad = usuEntidad;
	}

    /**
     * devuelve los perfiles del usuario.
     * @return perfiles
     */
    public List<Perfil> getPerfiles() {
        List<Perfil> perfiles = new ArrayList<Perfil>();
        for (ZonaUsuarioPerfil zp : getZonaPerfil()) {
            perfiles.add(zp.getPerfil());
        }
        return perfiles;
    }

    /**
     * devuelve las zonas del usuario.
     * @return zonas
     */
    public List<DDZona> getZonas() {
        List<DDZona> zonas = new ArrayList<DDZona>();
        for (ZonaUsuarioPerfil zp : getZonaPerfil()) {
            zonas.add(zp.getZona());
        }
        return zonas;
    }

    /**
     * getApellidoNombre.
     * @return getApellidoNombre
     */
    public String getApellidoNombre() {
        String r = "";
        if (apellido1 != null && apellido1.length() > 0) {
            r += apellido1;
        }
        if (apellido2 != null && apellido2.length() > 0) {
            if (r.trim().length() > 0) {
                r += " ";
            }
            r += apellido2;
        }
        if (r.trim().length() > 0) {
            if (r.trim().length() > 0) {
                r += ", ";
            }
        }
        if (nombre != null && nombre.length() > 0) {
            r += nombre;
        }
        return r;
    }

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

    /**
     * Calcula una nueva fecha de vigencia a partir de la actual mas la configuraci�n de la entidad que pertenezca el usuario.
     * @return date
     */
    public Date getNuevaFechaVigenciaPassword() {
        Calendar fechaVigenciaPassword = Calendar.getInstance();
        String strVigenciaPassword = "30";

        try {
            strVigenciaPassword = getEntidad().getConfiguracion().get("PeriodoVigenciaPassword").getDataValue();
        } catch (Exception e) {
            logger.warn("Error al recuperar el parametro de entidad: PeriodoVigenciaPassword, se coger� por defecto 30");
            strVigenciaPassword = "30";
        }
        int vigenciaPassword = Integer.parseInt(strVigenciaPassword);
        fechaVigenciaPassword.add(Calendar.DATE, vigenciaPassword);
        return fechaVigenciaPassword.getTime();
    }

    /**
     * override equals.
     * @param u u
     * @return compare
     */
    @Override
    public boolean equals(Object u) {
        if (u == null) { return false; }
        return this.hashCode() == u.hashCode();
    }

    /**
     * {@link Override}.
     * @return hashcode
     */
    @Override
    public int hashCode() {
        if (id == null) { return super.hashCode(); }
        return id.hashCode();
    }

    /**
     * @param usuarioExterno the usuarioExterno to set
     */
    public void setUsuarioExterno(Boolean usuarioExterno) {
        this.usuarioExterno = usuarioExterno;
    }

    /**
     * @return the usuarioExterno
     */
    public Boolean getUsuarioExterno() {
        return usuarioExterno;
    }
    
    public Boolean getUsuarioGrupo() {
		return usuarioGrupo;
	}

	public void setUsuarioGrupo(Boolean usuarioGrupo) {
		this.usuarioGrupo = usuarioGrupo;
	}

	public void initialize(){
      //initialize
        Hibernate.initialize(getZonaPerfil());
        Hibernate.initialize(getPerfiles());
        for (Perfil p : getPerfiles()) {
            Hibernate.initialize(p.getPuestosComites());
        } 
    }
    
}
