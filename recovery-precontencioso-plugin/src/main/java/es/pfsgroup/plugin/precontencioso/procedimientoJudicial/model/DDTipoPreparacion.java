package es.pfsgroup.plugin.precontencioso.procedimientoJudicial.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Version;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "DD_PCO_PRC_TIPO_PREPARACION", schema = "${master.schema}")
public class DDTipoPreparacion implements Dictionary, Auditable {

	private static final long serialVersionUID = 5392971820536499815L;

	@Id
	@Column(name = "DD_PCO_PTP_ID")
	private Long id;

	@Column(name = "DD_PCO_PTP_CODIGO")
	private String codigo;

	@Column(name = "DD_PCO_PTP_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_PCO_PTP_DESCRIPCION_LARGA")
	private String descripcionLarga;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

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
