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
 * Modelo que gestiona el diccionario de los tipos de transmision.
 * 
 * @author Ivan Rubio
 *
 */
@Entity
@Table(name = "DD_TTR_TIPO_TRANSMISION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoTransmision implements Auditable, Dictionary {


	/**
	 * 
	 */
	private static final long serialVersionUID = 2307957295534774606L;
	public static final String CODIGO_TR1 = "TR1";
    public static final String CODIGO_TR2 = "TR2";

	@Id
	@Column(name = "DD_TTR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoTransmisionGenerator")
	@SequenceGenerator(name = "DDTipoTransmisionGenerator", sequenceName = "S_DD_TTR_TIPO_TRANSMISION")
	private Long id;
	
	@Column(name = "DD_TTR_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TTR_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TTR_DESCRIPCION_LARGA")   
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
