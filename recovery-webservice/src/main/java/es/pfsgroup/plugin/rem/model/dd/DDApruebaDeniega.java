package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.commons.utils.Checks;

/**
 * Modelo que gestiona el diccionario de comités sancionadores
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "DD_APD_APRUEBA_DENIEGA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDApruebaDeniega implements Auditable, Dictionary {
	
	public static final String CODIGO_APRUEBA = "01";
	public static final String CODIGO_DENIEGA = "02";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_APD_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDApruebaDeniegaGenerator")
	@SequenceGenerator(name = "DDApruebaDeniegaGenerator", sequenceName = "S_DD_APD_APRUEBA_DENIEGA")
	private Long id;
	    
	@Column(name = "DD_APD_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_APD_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_APD_DESCRIPCION_LARGA")   
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
	
	
	public static String getCodigoAprueba() {
		return CODIGO_APRUEBA;
	}
	
	public static String getCodigoDeniega() {
		return CODIGO_DENIEGA;
	}

}
