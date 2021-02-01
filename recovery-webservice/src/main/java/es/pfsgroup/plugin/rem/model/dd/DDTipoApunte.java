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

@Entity
@Table(name = "DD_TAT_TIPO_APUNTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoApunte implements Auditable, Dictionary {
	
	public static final String CODIGO_GESTION = "01";
	public static final String CODIGO_ESTADO_ACTIVO = "02";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TAT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoApunteGenerator")
	@SequenceGenerator(name = "DDTipoApunteGenerator", sequenceName = "S_DD_TAT_TIPO_APUNTE")
	private Long id;
	
    /*@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TTR_ID")
    private DDTipoTrabajo tipoTrabajo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STR_ID")
    private DDSubtipoTrabajo subtipoTrabajo;*/
	    
	@Column(name = "DD_TAT_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TAT_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TAT_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "VER_NIVEL_ACTIVO")   
	private Integer verNivelActivo;

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
	
	/*public DDTipoTrabajo getTipoTrabajo() {
		return tipoTrabajo;
	}

	public void setTipoTrabajo(DDTipoTrabajo tipoTrabajo) {
		this.tipoTrabajo = tipoTrabajo;
	}

	public DDSubtipoTrabajo getSubtipoTrabajo() {
		return subtipoTrabajo;
	}

	public void setSubtipoTrabajo(DDSubtipoTrabajo subtipoTrabajo) {
		this.subtipoTrabajo = subtipoTrabajo;
	}*/

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
	
	public Integer getVerNivelActivo() {
		return verNivelActivo;
	}

	public void setVerNivelActivo(Integer verNivelActivo) {
		this.verNivelActivo = verNivelActivo;
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
