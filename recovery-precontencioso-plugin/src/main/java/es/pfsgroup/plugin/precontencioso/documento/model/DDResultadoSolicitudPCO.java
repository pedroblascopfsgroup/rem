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
@Table(name = "DD_PCO_DOC_SOLICIT_RESULTADO", schema = "${entity.schema}")
public class DDResultadoSolicitudPCO implements Dictionary, Auditable {

	final static public String RESPUESTA_OK = "OK";
	final static public String RESPUESTA_DOC_NO_ENCONTRADO = "NE";
	final static public String RESPUESTA_FALTA_INFO = "FI";
	
	private static final long serialVersionUID = 4401728773211770895L;

	@Id
	@Column(name = "DD_PCO_DSR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDResultadoSolicitudPCOGenerator")
	@SequenceGenerator(name = "DDResultadoSolicitudPCOGenerator", sequenceName = "S_DD_PCO_DOC_SOLICIT_RESULT")
	private Long id;

	@Column(name = "DD_PCO_DSR_CODIGO")
	private String codigo;

	@Column(name = "DD_PCO_DSR_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_PCO_DSR_DESCRIPCION_LARGA")
	private String descripcionLarga;

	@Column(name = "DD_PCO_DSR_RESUL_OK")
	private Boolean resultadoOK;

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

	public Boolean getResultadoOK() {
		return resultadoOK;
	}

	public void setResultadoOK(Boolean resultadoOK) {
		this.resultadoOK = resultadoOK;
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
