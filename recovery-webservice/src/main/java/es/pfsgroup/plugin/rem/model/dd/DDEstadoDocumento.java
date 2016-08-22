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
 * Modelo que gestiona el diccionario de los estados de los documentos de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_EDC_ESTADO_DOCUMENTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoDocumento implements Auditable, Dictionary {

    public static final String CODIGO_ESTADO_OBTENIDO = "01";
    public static final String CODIGO_ESTADO_EN_TRAMITE = "02";
    public static final String CODIGO_ESTADO_IMPOSIBLE = "03";
    
	/**
	 * 
	 */
	private static final long serialVersionUID = 1208989334329195723L;

	@Id
	@Column(name = "DD_EDC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoDocumentoGenerator")
	@SequenceGenerator(name = "DDEstadoDocumentoGenerator", sequenceName = "S_DD_EDC_ESTADO_DOCUMENTO")
	private Long id;
	 
	@Column(name = "DD_EDC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_EDC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_EDC_DESCRIPCION_LARGA")   
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
