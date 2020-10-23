package es.pfsgroup.plugin.rem.model.dd;

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
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de Situacion Inicial Cargas
 * 
 * PRP/Propias
 * AJE/Ajenas
 * AFF/Libre de cargas salvo afecciones fiscales
 * PUR/Las cargas se purgan con la inscripción
 * PRE/Título judicial/Preferentes
 * ANT/Título judicial/Anteriores
 * 
 * @author Alberto Flores
 *
 */
@Entity
@Table(name = "DD_SIC_SIT_INI_CARGAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSituacionInicialCargas implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_PROPIAS = "PRP";
	public static final String CODIGO_AJENAS = "AJE";
	public static final String CODIGO_AFECCIONES = "AFF";
	public static final String CODIGO_PURGAN = "PUR";
	public static final String CODIGO_PREFERENTES = "PRE";
	public static final String CODIGO_ANTERIORES = "ANT";

	@Id
	@Column(name = "DD_SIC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSituacionInicialCargas")
	@SequenceGenerator(name = "DDSituacionInicialCargas", sequenceName = "S_DD_SIC_SIT_INI_CARGAS")
	private Long id;

	@Column(name = "DD_SIC_CODIGO")
	private String codigo;

	@Column(name = "DD_SIC_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_SIC_DESCRIPCION_LARGA")
	private String descripcionLarga;

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