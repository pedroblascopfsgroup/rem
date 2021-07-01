

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
 * Modelo que gestiona el diccionario de tipos de calculo
 */
@Entity
@Table(name = "DD_MDE_MOTIVO_DESBLOQUEO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDMotivosDesbloqueo implements Auditable, Dictionary {

	/**
	 * 
	 */
	public static final String DESBLOQUEO_OTROS = "04";
	private static final long serialVersionUID = 1L;
	
	public static final String DESBLOQUEO_SCREENING = "DBLOQS";
	
	@Id
	@Column(name = "DD_MDE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivosDesbloqueoGenerator")
	@SequenceGenerator(name = "DDMotivosDesbloqueoGenerator", sequenceName = "S_DD_MDE_MOTIVO_DESBLOQUEO")
	private Long id;
	    
	@Column(name = "DD_MDE_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_MDE_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_MDE_DESCRIPCION_LARGA")   
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

}



