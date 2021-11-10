

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
 * Modelo que gestiona el diccionario de tipos de medios de pago
 */
@Entity
@Table(name = "DD_FOP_FINALIDAD_OPERACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDFinalidadOperacion implements Auditable {

	public static final String CODIGO_PBC_PRIMERA_RESIDENCIA = "R";
	public static final String CODIGO_PBC_SEGUNDA_RESIDENCIA = "V";
	public static final String CODIGO_PBC_INVERSION = "I";
	public static final String CODIGO_PBC_FINALIDAD_COMERCIAL = "A";
	public static final String CODIGO_PBC_OTROS = "O";
	public static final String CODIGO_BC_PRIMERA_RESIDENCIA = "10";
	public static final String CODIGO_BC_SEGUNDA_RESIDENCIA = "20";
	public static final String CODIGO_BC_INVERSION = "30";
	public static final String CODIGO_BC_FINALIDAD_COMERCIAL = "40";
	public static final String CODIGO_BC_OTROS = "50";
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_FOP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDFinalidadOperacionGenerator")
	@SequenceGenerator(name = "DDFinalidadOperacionGenerator", sequenceName = "S_DD_FOP_FINALIDAD_OPERACION")
	private Long id;
    
	@Column(name = "DD_FOP_CODIGO_PBC")   
	private String codigoPbc;
	
	@Column(name = "DD_FOP_CODIGO_BC")   
	private String codigoBc;
	 
	@Column(name = "DD_FOP_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_FOP_DESCRIPCION_LARGA")   
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

	public String getCodigoPbc() {
		return codigoPbc;
	}

	public void setCodigoPbc(String codigoPbc) {
		this.codigoPbc = codigoPbc;
	}

	public String getCodigoBc() {
		return codigoBc;
	}

	public void setCodigoBc(String codigoBc) {
		this.codigoBc = codigoBc;
	}

}



