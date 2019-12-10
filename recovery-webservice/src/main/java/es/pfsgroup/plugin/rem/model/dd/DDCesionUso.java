

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
 * Modelo que gestiona el diccionario de los tipos de cesion de uso
 * 
 * @author Rasul Abdulaev
 *
 */
@Entity
@Table(name = "DD_CDU_CESION_USO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDCesionUso implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;
	
	public static final String CARITAS= "01";
	public static final String CESION_GENERALITAT_CX = "02";
	public static final String CESION_OTRAS_OPERACIONES= "03";
	public static final String EN_TRAMITE_OTRAS_OPERACIONES= "04";
	public static final String NO_APLICA= "05";

	@Id
	@Column(name = "DD_CDU_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDCesionUsoGenerator")
	@SequenceGenerator(name = "DDCesionUsoGenerator", sequenceName = "S_DD_CDU_CESION_USO")
	private Long id;
	    
	@Column(name = "DD_CDU_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_CDU_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_CDU_DESCRIPCION_LARGA")   
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



