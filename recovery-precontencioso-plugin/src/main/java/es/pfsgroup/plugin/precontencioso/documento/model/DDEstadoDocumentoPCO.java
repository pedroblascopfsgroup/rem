package es.pfsgroup.plugin.precontencioso.documento.model;

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
@Table(name = "DD_PCO_DOC_ESTADO", schema = "${entity.schema}")
public class DDEstadoDocumentoPCO implements Dictionary, Auditable {

	public static final String PENDIENTE_SOLICITAR = "PS";
	public static final String SOLICITADO = "SO";
	public static final String ENVIADO = "EN";
	public static final String DISPONIBLE = "DI";
	public static final String DESCARTADO = "DE";
	
	private static final long serialVersionUID = 3659782421784672994L;

	@Id
	@Column(name = "DD_PCO_DED_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoDocumentoPCOGenerator")
	@SequenceGenerator(name = "DDEstadoDocumentoPCOGenerator", sequenceName = "S_DD_PCO_DOC_ESTADO")
	private Long id;

	@Column(name = "DD_PCO_DED_CODIGO")
	private String codigo;

	@Column(name = "DD_PCO_DED_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_PCO_DED_DESCRIPCION_LARGA")
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
