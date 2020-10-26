package es.pfsgroup.plugin.rem.model.dd;

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
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de las descripciones de foto de activos
 * 
 * @author Ivan Repiso
 *
 */
@Entity
@Table(name = "DD_DFA_DESCRIPCION_FOTO_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDDescripcionFotoActivo implements Auditable, Dictionary {
	
	


	/**
	 * 
	 */
	private static final long serialVersionUID = -4491891020118703404L;

	@Id
	@Column(name = "DD_DFA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDDescripcionFotoActivoGenerator")
	@SequenceGenerator(name = "DDDescripcionFotoActivoGenerator", sequenceName = "S_DD_DFA_DESCRIPCION_FOTO_ACTIVO")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DD_TPA_ID")
	private DDTipoActivo tipoActivo;
	
	@ManyToOne
	@JoinColumn(name = "DD_SAC_ID")
	private DDSubtipoActivo subtipoActivo;
	
	@Column(name = "DD_DFA_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_DFA_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_DFA_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	@Transient
	private String codigoTipoActivo;
	
	@Transient
	private String codigoSubtipoActivo;
	
	
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

	public DDTipoActivo getTipo() {
		return tipoActivo;
	}

	public void setTipo(DDTipoActivo tipo) {
		this.tipoActivo = tipo;
	}

	public DDSubtipoActivo getSubtipo() {
		return subtipoActivo;
	}

	public void setSubtipo(DDSubtipoActivo subtipo) {
		this.subtipoActivo = subtipo;
	}

	public void setCodigoTipoActivo(String codigoTipoActivo) {
		this.codigoTipoActivo = this.tipoActivo.getCodigo();
	}
	
	public String getCodigoTipoActivo() {
		return this.tipoActivo.getCodigo();
	}

	public void setCodigoSubtipoActivo(String codigoSubtipoActivo) {
		this.codigoSubtipoActivo = this.subtipoActivo.getCodigo();
	}
	
	public String getCodigoSubtipoActivo() {
		return this.subtipoActivo.getCodigo();
	}

	public DDTipoActivo getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(DDTipoActivo tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public DDSubtipoActivo getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(DDSubtipoActivo subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}	
}
