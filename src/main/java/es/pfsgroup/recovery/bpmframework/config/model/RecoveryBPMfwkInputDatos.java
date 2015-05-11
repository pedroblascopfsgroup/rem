package es.pfsgroup.recovery.bpmframework.config.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Tabla donde se almacena la información sobre los datos que debe incluir cada tipo de input en función del tipo de procedimiento.
 * @author manuel
 *
 */
@Entity
@Table(name = "BPM_IDT_INPUT_DATOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class RecoveryBPMfwkInputDatos implements Auditable, Serializable{

	private static final long serialVersionUID = -2268083231310271097L;

    @Id
    @Column(name = "BPM_IDT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RecoveryBPMfwkInputDatosGenerator")
    @SequenceGenerator(name = "RecoveryBPMfwkInputDatosGenerator", sequenceName = "S_BPM_IDT_INPUT_DATOS")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "BPM_TPI_ID", nullable = false)
    private RecoveryBPMfwkTipoProcInput tipoProcInput;
	
	@Column(name = "BPM_IDT_NOMBRE")
    private String nombre;
	
	@Column(name = "BPM_IDT_GRUPO")
    private String grupo;
	
	@Column(name = "BPM_IDT_DATO")
    private String dato;
	
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;
    

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public RecoveryBPMfwkTipoProcInput getTipoProcInput() {
		return tipoProcInput;
	}

	public void setTipoProcInput(RecoveryBPMfwkTipoProcInput tipoProcInput) {
		this.tipoProcInput = tipoProcInput;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getGrupo() {
		return grupo;
	}

	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}

	public String getDato() {
		return dato;
	}

	public void setDato(String dato) {
		this.dato = dato;
	}    
    
    public Auditoria getAuditoria() {
        return auditoria;
    }

    public void setAuditoria(final Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    public Integer getVersion() {
        return version;
    }

    public void setVersion(final Integer version) {
        this.version = version;
    }    

}
