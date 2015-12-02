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
@Table(name = "DD_TPD_PCO_TIPO_PRM_DOC", schema = "${entity.schema}")
public class DDTipoProblemaDocPco implements Dictionary, Auditable {

	private static final long serialVersionUID = 5392971820536499815L;
	
	public static final String TIPO_PROBLEMA_CAMBIO_PROCEDIMIENTO = "CPR";

	@Id
	@Column(name = "DD_TPD_PCO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoProblemaDocPcoGenerator")
	@SequenceGenerator(name = "DDTipoProblemaDocPcoGenerator", sequenceName = "S_DD_TPD_PCO_TIPO_PRM_DOC")
	private Long id;

	@Column(name = "DD_TPD_PCO_CODIGO")
	private String codigo;

	@Column(name = "DD_TPD_PCO_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_TPD_PCO_DESCRIPCION_LARGA")
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
