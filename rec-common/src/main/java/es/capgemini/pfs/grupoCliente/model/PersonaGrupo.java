package es.capgemini.pfs.grupoCliente.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;

/**
 * @author marruiz
 */
@Entity
@Table(name = "PER_GCL", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class PersonaGrupo implements Serializable, Auditable {

    private static final long serialVersionUID = -5596170844767184502L;

    @Id
    @Column(name = "PER_GCL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PersonaGrupoGenerator")
    @SequenceGenerator(name = "PersonaGrupoGenerator", sequenceName = "S_PER_GCL")
    private Long id;

    @ManyToOne
    @JoinColumn(name="GCL_ID")
    private GrupoCliente grupoCliente;

    /*
     * [Bruno] A partir de la versión 2.7.0_sencha_rc4 se soporta que una persona esté en varios grupos
     */
    @ManyToOne
    @JoinColumn(name="PER_ID")
    private Persona persona;

    @Column(name = "PER_GCL_FECHA_EXTRACCION")
    private Date fechaExtraccion;
    
    @ManyToOne
    @JoinColumn(name="DD_TGE_ID")
    private DDTipoRelacionGrupo tipoRelacionGrupo;

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;


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
     * @return the grupoCliente
     */
    public GrupoCliente getGrupoCliente() {
        return grupoCliente;
    }

    /**
     * @param grupoCliente the grupoCliente to set
     */
    public void setGrupoCliente(GrupoCliente grupoCliente) {
        this.grupoCliente = grupoCliente;
    }

    /**
     * @return the persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * @param persona the persona to set
     */
    public void setPersona(Persona persona) {
        this.persona = persona;
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

	public DDTipoRelacionGrupo getTipoRelacionGrupo() {
		return tipoRelacionGrupo;
	}

	public void setTipoRelacionGrupo(DDTipoRelacionGrupo tipoRelacionGrupo) {
		this.tipoRelacionGrupo = tipoRelacionGrupo;
	}
}
