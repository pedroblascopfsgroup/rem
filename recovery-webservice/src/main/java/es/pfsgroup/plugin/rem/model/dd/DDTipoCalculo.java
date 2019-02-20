

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de tipos de calculo
 */
@Entity
@Table(name = "DD_TCC_TIPO_CALCULO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoCalculo implements Auditable, Dictionary {
	
	public static String TIPO_CALCULO_PORCENTAJE = "01";
	public static String TIPO_CALCULO_IMPORTE_FIJO = "02";
	public static String TIPO_CALCULO_PORCENTAJE_ALQ = "03";
	public static String TIPO_CALCULO_IMPORTE_FIJO_ALQ = "04";
	public static String TIPO_CALCULO_MENSUALIDAD_ALQ = "05";

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TCC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoCalculoGenerator")
	@SequenceGenerator(name = "DDTipoCalculoGenerator", sequenceName = "S_DD_TCC_TIPO_CALCULO")
	private Long id;
	    
	@Column(name = "DD_TCC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TCC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TCC_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	@ManyToOne
	@JoinColumn(name = "DD_TOF_ID")
	private DDTipoOferta tipoOferta;
	    
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

}



