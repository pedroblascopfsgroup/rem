package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
 * Modelo que gestiona el diccionario de los subtipos de activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_SAC_SUBTIPO_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubtipoActivo implements Auditable, Dictionary {
	
	public static final String COD_LOCAL_COMERCIAL ="13";
	public static final String COD_GARAJE ="24";
	public static final String COD_TRASTERO ="25";
	public static final String CODIGO_SUBTIPO_LOCAL_COMERCIAL = "13";
	public static final String CODIGO_SUBTIPO_NO_URBAN_RUSTICO = "01";
	public static final String CODIGO_SUBTIPO_NAVE_AISLADA = "17";
	public static final String CODIGO_SUBTIPO_NAVE_ADOSADA = "18";

	/**
	 * 
	 */
	private static final long serialVersionUID = -8653244063687370245L;

	@Id
	@Column(name = "DD_SAC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubtipoActivoGenerator")
	@SequenceGenerator(name = "DDSubtipoActivoGenerator", sequenceName = "S_DD_SAC_SUBTIPO_ACTIVO")
	private Long id;
	  
	@JoinColumn(name = "DD_TPA_ID")  
    @ManyToOne(fetch = FetchType.LAZY)
	private DDTipoActivo tipoActivo;
	
	@Column(name = "DD_SAC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SAC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SAC_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	@Transient
	private String codigoTipoActivo;
	
	    
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
	
	public String getCodigo() {
		return codigo;
	}
	
	public void setCodigo(String codigo) {
		this.codigo = codigo;
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

	public DDTipoActivo getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(DDTipoActivo tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public String getCodigoTipoActivo() {
		return tipoActivo.getCodigo();
	}

	public void setCodigoTipoActivo(String codigoTipoActivo) {
		this.codigoTipoActivo = tipoActivo.getCodigo();
	}

}
