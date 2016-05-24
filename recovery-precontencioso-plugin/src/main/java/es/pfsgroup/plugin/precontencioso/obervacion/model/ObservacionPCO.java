package es.pfsgroup.plugin.precontencioso.obervacion.model;

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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;

@Entity
@Table(name = "PCO_OBS_OBSERVACIONES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ObservacionPCO implements Serializable, Auditable {

	private static final long serialVersionUID = -8126507983462211724L;

	@Id
	@Column(name = "PCO_OBS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ObservacionPCOGenerator")
	@SequenceGenerator(name = "ObservacionPCOGenerator", sequenceName = "S_PCO_OBS_OBSERVACIONES")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "PCO_PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private ProcedimientoPCO procedimientoPCO;
	
	@Column(name = "PCO_OBS_FECHA_ANOTACION")
	private Date fechaAnotacion;
	
	@Column(name = "PCO_OBS_TEXTO_ANOTACION")
	private String textoAnotacion;
	
	@Column(name = "PCO_OBS_SECUENCIA_ANOTACION")
	private Integer secuenciaAnotacion;
	
	@ManyToOne
	@JoinColumn(name = "USU_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Usuario usuario;
	
	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ProcedimientoPCO getProcedimientoPCO() {
		return procedimientoPCO;
	}

	public void setProcedimientoPCO(ProcedimientoPCO procedimientoPCO) {
		this.procedimientoPCO = procedimientoPCO;
	}

	public Date getFechaAnotacion() {
		return fechaAnotacion;
	}

	public void setFechaAnotacion(Date fechaAnotacion) {
		this.fechaAnotacion = fechaAnotacion;
	}

	public String getTextoAnotacion() {
		return textoAnotacion;
	}

	public void setTextoAnotacion(String textoAnotacion) {
		this.textoAnotacion = textoAnotacion;
	}

	public Integer getSecuenciaAnotacion() {
		return secuenciaAnotacion;
	}

	public void setSecuenciaAnotacion(Integer secuenciaAnotacion) {
		this.secuenciaAnotacion = secuenciaAnotacion;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
