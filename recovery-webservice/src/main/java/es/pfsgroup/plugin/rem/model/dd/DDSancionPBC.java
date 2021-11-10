package es.pfsgroup.plugin.rem.model.dd;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;

/**
 * Modelo que gestiona el diccionario de sanciones de PBC.
 * 
 * @author Vicente Martinez
 *
 */
@Entity
@Table(name = "DD_SAP_SANCION_PBC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSancionPBC implements Auditable, Dictionary {

	public static final String CODIGO_APROBADA = "10";
	public static final String CODIGO_APROBADA_ARRAS = "20";
	public static final String CODIGO_APROBADA_COND = "30";
	public static final String CODIGO_RECHAZADA = "40";
	public static final String CODIGO_ELEVADA_PROP = "50";
		/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_SAP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSancionPBCGenerator")
	@SequenceGenerator(name = "DDSancionPBCGenerator", sequenceName = "S_DD_SAP_SANCION_PBC")
	private Long id;
	 
	@Column(name = "DD_SAP_CODIGO")
	private String codigo;
	 
	@Column(name = "DD_SAP_DESCRIPCION")
	private String descripcion;
	    
	@Column(name = "DD_SAP_DESCRIPCION_LARGA")
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
