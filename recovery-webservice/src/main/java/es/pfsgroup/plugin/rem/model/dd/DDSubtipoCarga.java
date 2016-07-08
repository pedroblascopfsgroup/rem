package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.OneToOne;
import javax.persistence.JoinColumn;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCargaActivo;

/**
 * Modelo que gestiona el diccionario de los subtipos de cargas
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_STC_SUBTIPO_CARGA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubtipoCarga implements Auditable, Dictionary {
	
	

	/**
	 * 
	 */
	private static final long serialVersionUID = -8653244063687370245L;

	@Id
	@Column(name = "DD_STC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubtipoActivoGenerator")
	@SequenceGenerator(name = "DDSubtipoActivoGenerator", sequenceName = "S_DD_TVP_TIPO_VPO")
	private Long id;
	  
	@OneToOne
	@JoinColumn(name = "DD_TCA_ID")   
	private DDTipoCargaActivo tipoCargaActivo;
	
	@Column(name = "DD_STC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_STC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_STC_DESCRIPCION_LARGA")   
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

	public DDTipoCargaActivo getTipoCargaActivo() {
		return tipoCargaActivo;
	}

	public void setTipoCargaActivo(DDTipoCargaActivo tipoCargaActivo) {
		this.tipoCargaActivo = tipoCargaActivo;
	}

}
