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
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;



/**
 * Modelo que gestiona la información de la documentación exigida de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_CFD_CONFIG_DOCUMENTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoConfigDocumento implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "CFD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoConfigDocumentoGenerator")
    @SequenceGenerator(name = "ActivoConfigDocumentoGenerator", sequenceName = "S_ACT_CFD_CONFIG_DOCUMENTO")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "DD_TPA_ID")
    private DDTipoActivo tipoActivo;   
	
	@ManyToOne
    @JoinColumn(name = "DD_TPD_ID")
    private DDTipoDocumentoActivo tipoDocumentoActivo; 
	 
	@Column(name = "CFD_OBLIGATORIO")
	private Boolean obligatorio;
	
	@Column(name = "CFD_APLICA_F_CADUCIDAD")
	private Boolean aplicaFechaCaducidad;
	
	@Column(name = "CFD_APLICA_F_ETIQUETA")
	private Boolean aplicaFechaEtiqueta;
	
	@Column(name = "CFD_APLICA_CALIFICACION")
	private Boolean aplicaCalificacion;
	
	@ManyToOne
	@JoinColumn(name = "DD_SAC_ID")
	private DDSubtipoActivo subtipoActivo;
	
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

	public DDTipoActivo getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(DDTipoActivo tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public DDTipoDocumentoActivo getTipoDocumentoActivo() {
		return tipoDocumentoActivo;
	}

	public void setTipoDocumentoActivo(DDTipoDocumentoActivo tipoDocumentoActivo) {
		this.tipoDocumentoActivo = tipoDocumentoActivo;
	}

	public Boolean getObligatorio() {
		return obligatorio;
	}

	public void setObligatorio(Boolean obligatorio) {
		this.obligatorio = obligatorio;
	}

	public Boolean getAplicaFechaCaducidad() {
		return aplicaFechaCaducidad;
	}

	public void setAplicaFechaCaducidad(Boolean aplicaFechaCaducidad) {
		this.aplicaFechaCaducidad = aplicaFechaCaducidad;
	}

	public Boolean getAplicaFechaEtiqueta() {
		return aplicaFechaEtiqueta;
	}

	public void setAplicaFechaEtiqueta(Boolean aplicaFechaEtiqueta) {
		this.aplicaFechaEtiqueta = aplicaFechaEtiqueta;
	}

	public Boolean getAplicaCalificacion() {
		return aplicaCalificacion;
	}

	public void setAplicaCalificacion(Boolean aplicaCalificacion) {
		this.aplicaCalificacion = aplicaCalificacion;
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
