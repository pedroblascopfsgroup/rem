package es.capgemini.pfs.procesosJudiciales.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa la entidad TEV_TAREA_EXTERNA_VALOR.
 * Esta entidad guarda los valores ingresados por el usuario en cada tarea de un proceso judicial.
 * @author jpbosnjak
 *
 */
@Entity
@Table(name = "TEV_TAREA_EXTERNA_VALOR", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class TareaExternaValor implements Serializable, Auditable {

    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = -8961132998182577279L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TareaExternaValorGenerator")
    @SequenceGenerator(name = "TareaExternaValorGenerator", sequenceName = "S_TEV_TAREA_EXTERNA_VALOR")
    @Column(name = "TEV_ID")
    private Long id;

    @Column(name = "TEV_NOMBRE")
    private String nombre;

    @ManyToOne
    @JoinColumn(name = "TEX_ID")
    private TareaExterna tareaExterna;

    @Column(name = "TEV_VALOR")
    private String valor;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

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
     * @return the tareaExterna
     */
    public TareaExterna getTareaExterna() {
        return tareaExterna;
    }

    /**
     * @param tareaExterna the tareaExterna to set
     */
    public void setTareaExterna(TareaExterna tareaExterna) {
        this.tareaExterna = tareaExterna;
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
	 * @return the valor
	 */
	public String getValor() {
		return valor;
	}

	/**
	 * @param valor the valor to set
	 */
	public void setValor(String valor) {
		this.valor = valor;
	}
}
