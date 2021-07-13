

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
@Table(name = "DD_PFP_PROC_FONDOS_PROPIOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDProcedenciaFondosPropios implements Auditable {
	
	public static final String CODIGO_BC_ACTIVIDAD_ECONOMICA = "10";
	public static final String CODIGO_BC_FINANCIACION_PARTICULAR = "20";
	public static final String CODIGO_BC_OTROS = "30";
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_PFP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDProcedenciaFondosPropiosGenerator")
	@SequenceGenerator(name = "DDProcedenciaFondosPropiosGenerator", sequenceName = "S_DD_PFP_PROC_FONDOS_PROPIOS")
	private Long id;
    
	@Column(name = "DD_PFP_CODIGO_PBC")   
	private String codigoPbc;
	
	@Column(name = "DD_PFP_CODIGO_BC")   
	private String codigoBc;
	 
	@Column(name = "DD_PFP_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_PFP_DESCRIPCION_LARGA")   
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



