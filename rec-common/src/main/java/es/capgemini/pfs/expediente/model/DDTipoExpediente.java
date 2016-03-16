package es.capgemini.pfs.expediente.model;

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
 * 
 * @author diana
 *
 */
@Entity
@Table(name = "DD_TPX_TIPO_EXPEDIENTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoExpediente implements Auditable, Dictionary{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 5576059256328892846L;
	
	public static final String TIPO_EXPEDIENTE_INTERNO = "INT";
	public static final String TIPO_EXPEDIENTE_RECOBRO = "REC";
	public static final String TIPO_EXPEDIENTE_RECUPERACION = "RECU";
	public static final String TIPO_EXPEDIENTE_SEGUIMIENTO = "SEG";
	public static final String TIPO_EXPEDIENTE_GESTION_DEUDA = "GESDEU";

	@Id
	 @Column(name = "DD_TPX_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoExpedienteGenerator")
	 @SequenceGenerator(name = "DDTipoExpedienteGenerator", sequenceName = "S_DD_TPX_TIPO_EXPEDIENTE")
	 private Long id;
	    
	 @Column(name = "DD_TPX_DESCRIPCION")   
	 private String descripcion;
	    
	 @Column(name = "DD_TPX_DESCRIPCION_LARGA")   
	 private String descripcionLarga;
	    
	 @Column(name = "DD_TPX_CODIGO")   
	 private String codigo;
	    
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
