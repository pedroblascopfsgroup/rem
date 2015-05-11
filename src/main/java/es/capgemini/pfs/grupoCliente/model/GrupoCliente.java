package es.capgemini.pfs.grupoCliente.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * @author marruiz
 */
@Entity
@Table(name = "GCL_GRUPOS_CLIENTES", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class GrupoCliente implements Serializable, Auditable {

    private static final long serialVersionUID = -83911589408025818L;

    @Id
    @Column(name = "GCL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GrupoClienteGenerator")
    @SequenceGenerator(name = "GrupoClienteGenerator", sequenceName = "S_GCL_GRUPOS_CLIENTES")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TGL_ID")
    private DDTipoGrupoCliente tipoGrupoCliente;

    @Column(name = "GCL_CODIGO")
    private String codigo;

    @Column(name = "GCL_NOMBRE")
    private String nombre;

    @Column(name = "GCL_FECHA_EXTRACCION")
    private Date fechaExtraccion;

    @Column(name = "GCL_RIESGO_DIR")
    private Float riesgoDirecto;

    @Column(name = "GCL_RIESGO_DIR_VENCIDO")
    private Float riesgoDirectoVencido;

    @Column(name = "GCL_RIESGO_DIR_DANYADO")
    private Float riesgoDirectoDanyado;
    
    @Column(name="GCL_RIESGO_INDIR")
    private Float riesgoIndirecto;
    

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

    @OneToMany(mappedBy = "grupoCliente", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<PersonaGrupo> personasGrupo;

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
     * @return the tipoGrupoCliente
     */
    public DDTipoGrupoCliente getTipoGrupoCliente() {
        return tipoGrupoCliente;
    }

    /**
     * @param tipoGrupoCliente the tipoGrupoCliente to set
     */
    public void setTipoGrupoCliente(DDTipoGrupoCliente tipoGrupoCliente) {
        this.tipoGrupoCliente = tipoGrupoCliente;
    }

    /**
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
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
     * @return the fechaExtraccion
     */
    public Date getFechaExtraccion() {
        return fechaExtraccion;
    }

    /**
     * @param fechaExtraccion the fechaExtraccion to set
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
        this.fechaExtraccion = fechaExtraccion;
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
     * @return the personasGrupo
     */
    public List<PersonaGrupo> getPersonasGrupo() {
        return personasGrupo;
    }

    /**
     * @param personasGrupo the personasGrupo to set
     */
    public void setPersonasGrupo(List<PersonaGrupo> personasGrupo) {
        this.personasGrupo = personasGrupo;
    }

    /**
     * @param riesgoDirecto the riesgoDirecto to set
     */
    public void setRiesgoDirecto(Float riesgoDirecto) {
        this.riesgoDirecto = riesgoDirecto;
    }

    /**
     * @return the riesgoDirecto
     */
    public Float getRiesgoDirecto() {
        if (riesgoDirecto != null) {
            return riesgoDirecto;
        }
        return 0f;
    }

    /**
     * @param riesgoDirectoDanyado the riesgoDirectoDanyado to set
     */
    public void setRiesgoDirectoDanyado(Float riesgoDirectoDanyado) {
        this.riesgoDirectoDanyado = riesgoDirectoDanyado;
    }

    /**
     * @return the riesgoDirectoDanyado
     */
    public Float getRiesgoDirectoDanyado() {
        if (riesgoDirectoDanyado != null) {
            return riesgoDirectoDanyado;
        }
        return 0f;
    }

    /**
     * @param riesgoDirectoVencido the riesgoDirectoVencido to set
     */
    public void setRiesgoDirectoVencido(Float riesgoDirectoVencido) {
        this.riesgoDirectoVencido = riesgoDirectoVencido;
    }

    /**
     * @return the riesgoDirectoVencido
     */
    public Float getRiesgoDirectoVencido() {
        return riesgoDirectoVencido;
    }

	public Float getRiesgoIndirecto() {
		return riesgoIndirecto;
	}

	public void setRiesgoIndirecto(Float riesgoIndirecto) {
		this.riesgoIndirecto = riesgoIndirecto;
	}
}
