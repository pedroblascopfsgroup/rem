package es.pfsgroup.plugin.rem.model;

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
 * Modelo que gestiona la informacion de los ocupantes legales de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_OLE_OCUPANTE_LEGAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoOcupanteLegal implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "OLE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoOcupanteLegalGenerator")
    @SequenceGenerator(name = "ActivoOcupanteLegalGenerator", sequenceName = "S_ACT_OLE_OCUPANTE_LEGAL")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "SPS_ID")
	private ActivoSituacionPosesoria situacionPosesoria;
	
	@Column(name = "OLE_NOMBRE")
	private String nombreOcupante;

	@Column(name = "OLE_NIF")
	private String nifOcupante;
	 
	@Column(name = "OLE_EMAIL")
	private String emailOcupante;
	
	@Column(name = "OLE_TELF")
	private String telefonoOcupante;
	
	@Column(name = "OLE_OBS")
	private String observacionesOcupante;

	
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ActivoSituacionPosesoria getSituacionPosesoria() {
		return situacionPosesoria;
	}

	public void setSituacionPosesoria(ActivoSituacionPosesoria situacionPosesoria) {
		this.situacionPosesoria = situacionPosesoria;
	}

	public String getNombreOcupante() {
		return nombreOcupante;
	}

	public void setNombreOcupante(String nombreOcupante) {
		this.nombreOcupante = nombreOcupante;
	}

	public String getNifOcupante() {
		return nifOcupante;
	}

	public void setNifOcupante(String nifOcupante) {
		this.nifOcupante = nifOcupante;
	}

	public String getEmailOcupante() {
		return emailOcupante;
	}

	public void setEmailOcupante(String emailOcupante) {
		this.emailOcupante = emailOcupante;
	}

	public String getTelefonoOcupante() {
		return telefonoOcupante;
	}

	public void setTelefonoOcupante(String telefonoOcupante) {
		this.telefonoOcupante = telefonoOcupante;
	}

	public String getObservacionesOcupante() {
		return observacionesOcupante;
	}

	public void setObservacionesOcupante(String observacionesOcupante) {
		this.observacionesOcupante = observacionesOcupante;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
