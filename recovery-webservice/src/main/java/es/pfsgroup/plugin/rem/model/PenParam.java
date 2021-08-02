package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo que gestiona parametros globales para la aplicacion, 
 * 
 * @author Jesus Jativa
 */
@Entity
@Table(name = "PEN_PARAM_ENTIDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class PenParam implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "PEN_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "PenParamGenerator")
	@SequenceGenerator(name = "PenParamGenerator", sequenceName = "S_PEN_PARAM_ENTIDAD")
	private Long id;

	@Column(name = "PEN_PARAM")
	private String param;

	@Column(name = "PEN_DESCRIPCION")
	private String descripcion;

	@Column(name = "PEN_USOS")
	private String usos;
	
	@Column(name = "PEN_VALOR")
	private String valor;
	
	
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

	public String getParam() {
		return param;
	}

	public void setParam(String param) {
		this.param = param;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getUsos() {
		return usos;
	}

	public void setUsos(String usos) {
		this.usos = usos;
	}

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
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