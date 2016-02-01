package es.pfsgroup.plugin.precontencioso.expedienteJudicial.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "DD_MAL_MOTIVO_ASIG_LET", schema = "${entity.schema}")
public class DDMotivoAsignacionLetrado implements Dictionary, Auditable {

	private static final long serialVersionUID = 4172101451507576888L;

	@Id
	@Column(name = "DD_MAL_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivoAsignacionLetradoGenerator")
	@SequenceGenerator(name = "DDMotivoAsignacionLetradoGenerator", sequenceName = "S_DD_MAL_MOTIVO_ASIG_LET")
	private Long id;

	@Column(name = "DD_MAL_CODIGO")
	private String codigo;

	@Column(name = "DD_MAL_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_MAL_DESCRIPCION_LARGA")
	private String descripcionLarga;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/*
	 * GETTERS & SETTERS
	 */

	public Long getId() {
		return id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
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
