

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
 * Modelo que gestiona el diccionario de acción de gastos
 */
@Entity
@Table(name = "DD_ACC_ACCION_GASTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDAccionGastos implements Auditable, Dictionary {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_ACC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDAccionGastosGenerator")
	@SequenceGenerator(name = "DDAccionGastosGenerator", sequenceName = "S_DD_ACC_ACCION_GASTOS_")
	private Long id;
	    
	@Column(name = "DD_ACC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_ACC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_ACC_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	public static final String CODIGO_PRESCRIPCION = "04";
	public static final String CODIGO_COLABORACION = "05";
	public static final String CODIGO_RESPONSABLE_CLIENTE = "06";
	public static final String CODIGO_PRE_Y_COL = "PRE_Y_COL";
	public static final String CODIGO_API_ORI_LEA = "API_ORI_LEA";
	    
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



