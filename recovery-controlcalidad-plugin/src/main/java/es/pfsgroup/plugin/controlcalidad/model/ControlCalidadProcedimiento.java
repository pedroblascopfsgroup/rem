package es.pfsgroup.plugin.controlcalidad.model;

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

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


/**
 * Modelo de datos para la entidad de Control de Calidad de procedimientos
 * @author Guillem
 *
 */
@Entity
@Table(name = "CCP_CONTROL_CALIDAD_PROC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ControlCalidadProcedimiento implements Auditable, Serializable{
	
	private static final long serialVersionUID = -4164049936192210879L;

	@Id
	@Column(name = "CCP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ControlCalidadProcedimientosGenerator")
	@SequenceGenerator(name = "ControlCalidadProcedimientosGenerator", sequenceName = "S_CCP_CONTROL_CALIDAD_PROC")
	private Long id;
	 
	@Column(name = "CCP_ID_BPM")
	private Long idBPM;
	 
	@Column(name = "CCP_DESCRIPCION")
	private String descripcion;
	 
	@Column(name = "CCP_REVISADO")
	private Boolean revisado;
	 
	@ManyToOne
	@JoinColumn(name = "CCA_ID")
	private ControlCalidad controlCalidad;

	@ManyToOne
	@JoinColumn(name = "PRC_ID")
	private Procedimiento procedimiento;
	 
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

	public Long getIdBPM() {
		return idBPM;
	}

	public void setIdBPM(Long idBPM) {
		this.idBPM = idBPM;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Boolean getRevisado() {
		return revisado;
	}

	public void setRevisado(Boolean revisado) {
		this.revisado = revisado;
	}

	public ControlCalidad getControlCalidad() {
		return controlCalidad;
	}

	public void setControlCalidad(ControlCalidad controlCalidad) {
		this.controlCalidad = controlCalidad;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}	
	
}
