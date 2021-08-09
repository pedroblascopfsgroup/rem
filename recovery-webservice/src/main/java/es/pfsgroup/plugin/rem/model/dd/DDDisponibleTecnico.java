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
 * Modelo que gestiona el diccionario de la disponibilidad técnica
 * 
 * @author Adrián Molina
 *
 */
@Entity
@Table(name = "DD_DIT_DISP_TECNICO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDDisponibleTecnico implements Auditable, Dictionary {
	
	
	public static final String COD_SI ="001";
	public static final String COD_NO ="002";
	public static final String COD_ESTUDIADO ="003";
	public static final String COD_PENDIENTE_PROTOCOLO ="004";
	public static final String COD_PENDIENTE_PROTOCOLO_POST_ALQUILER ="005";
	public static final String COD_SI_CONDICIONAL ="006";
	public static final String COD_VACIO ="007";
	public static final String COD_PENDIENTE_PROTOCOLO_POST_OCUPACION ="008";
	public static final String COD_NO_DISPONIBLE_POR_AFECCION_LEGAL ="009";
	

	/**
	 * 
	 */
	private static final long serialVersionUID = 2307957295534774606L;

	@Id
	@Column(name = "DD_DIT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDDisponibleTecnicoGenerator")
	@SequenceGenerator(name = "DDDisponibleTecnicoGenerator", sequenceName = "S_DD_DIT_DISP_TECNICO")
	private Long id;
	
	@Column(name = "DD_DIT_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_DIT_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_DIT_DESCRIPCION_LARGA")   
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
