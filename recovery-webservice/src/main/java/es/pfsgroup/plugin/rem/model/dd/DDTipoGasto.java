

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
 * Modelo que gestiona el diccionario de tipos de gastos
 */
@Entity
@Table(name = "DD_TGA_TIPOS_GASTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoGasto implements Auditable, Dictionary {
	
	public static final String CODIGO_SERV_PROF_INDEPENDIENTES = "11";
	public static final String CODIGO_ALQUILER = "19";
	public static final String CODIGO_IMPUESTO = "01";
	public static final String CODIGO_TASA = "02";

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TGA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoGastoGenerator")
	@SequenceGenerator(name = "DDTipoGastoGenerator", sequenceName = "S_DD_TGA_TIPOS_GASTO")
	private Long id;
	    
	@Column(name = "DD_TGA_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TGA_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TGA_DESCRIPCION_LARGA")   
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

	
	public static boolean isTipoGastoAlquiler (DDTipoGasto tipo) {
		boolean is = false;
		if(tipo != null && (CODIGO_ALQUILER.equals(tipo.getCodigo()))) {
			is = true;
		}
		return is;
	}
	
	public static boolean isTipoGastoImpuestoOrTasa (DDTipoGasto tipo) {
		boolean is = false;
		if (tipo != null && (CODIGO_IMPUESTO.equals(tipo.getCodigo()) || CODIGO_TASA.equals(tipo.getCodigo()))) {
			is = true;
		}
		return is;
	}
}



