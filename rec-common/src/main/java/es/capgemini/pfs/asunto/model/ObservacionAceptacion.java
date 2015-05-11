package es.capgemini.pfs.asunto.model;

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase que representa una observacion de aceptación de un Asunto.
 * @author pamuller
 *
 */
@Entity(name="OBA_OBSERVACION_ACEPTACION")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ObservacionAceptacion implements Auditable,Serializable {

	private static final long serialVersionUID = 4699576807583537710L;

	@Id
	@Column(name="OBA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ObservacionAceptacionGenerator")
    @SequenceGenerator(name = "ObservacionAceptacionGenerator", sequenceName = "S_OBA_OBSERVACION_ACEPTACION")
	private Long id;

	@OneToOne
	@JoinColumn(name="AFA_ID")
	private FichaAceptacion fichaAceptacion;

	@Column(name="OBA_FECHA")
	private Date fecha;

	@Column(name="OBA_DETALLE")
	private String detalle;

	@Column(name="OBA_ACCION")
	private String accion;

    @ManyToOne
    @JoinColumn(name = "USU_ID")
    private Usuario usuario;

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
	 * @return the fecha
	 */
	public Date getFecha() {
		return fecha;
	}

	/**
	 * @param fecha the fecha to set
	 */
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	/**
	 * @return the detalle
	 */
	public String getDetalle() {
		return detalle;
	}

	/**
	 * @param detalle the detalle to set
	 */
	public void setDetalle(String detalle) {
		this.detalle = detalle;
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
     * @return the usuario
     */
    public Usuario getUsuario() {
        return usuario;
    }

    /**
     * @param usuario the usuario to set
     */
    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

	/**
	 * @return the fichaAceptacion
	 */
	public FichaAceptacion getFichaAceptacion() {
		return fichaAceptacion;
	}

	/**
	 * @param fichaAceptacion the fichaAceptacion to set
	 */
	public void setFichaAceptacion(FichaAceptacion fichaAceptacion) {
		this.fichaAceptacion = fichaAceptacion;
	}

	/**
	 * @return the accion
	 */
	public String getAccion() {
		return accion;
	}

	/**
	 * @param accion the accion to set
	 */
	public void setAccion(String accion) {
		this.accion = accion;
	}
}
