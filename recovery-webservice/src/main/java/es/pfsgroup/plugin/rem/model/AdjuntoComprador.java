package es.pfsgroup.plugin.rem.model;


import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


/**
 * 
 * HREOS-4937
 * 
 * Modelo que gestiona la informacion de adjuntos compradores
 *  
 * @author Carlos Ruiz Beltrán
 *
 */
@Entity
@Table(name = "ADC_ADJUNTO_COMPRADOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class AdjuntoComprador implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "ADCOM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AdjuntoCompradorGenerator")
    @SequenceGenerator(name = "AdjuntoCompradorGenerator", sequenceName = "S_ADC_ADJUNTO_COMPRADOR")
    private Long id;
	
    @Column(name = "ADC_DOC_TYPE")
    private String tipoDocumento;
    
    @Column(name = "ADC_SUBDOC_TYPE")
    private String subTipoDocumento;
    
    @Column(name = "MATRICULA")
    private String matricula;
    
    @Column(name = "ADC_NAME")
    private String nombreAdjunto;
    
    @Column(name = "ADC_ID_DOCUMENTO_REST")
    private Long idDocRestClient;

    //Esta columna contendrá el ID de ADJ_ADJUNTOS pero no tiene una Clave Foranea como tal
    // ya que puede ser null dependiendo de si el Gestor Documental esta activado (esta columna a null) o no (esta columna deberia rellenarse).
    @Column(name = "ADJ_ID")
    private Long adjunto; 

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

	public String getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public String getSubTipoDocumento() {
		return subTipoDocumento;
	}

	public void setSubTipoDocumento(String subTipoDocumento) {
		this.subTipoDocumento = subTipoDocumento;
	}

	public String getMatricula() {
		return matricula;
	}

	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}

	public String getNombreAdjunto() {
		return nombreAdjunto;
	}

	public void setNombreAdjunto(String nombreAdjunto) {
		this.nombreAdjunto = nombreAdjunto;
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
	
	public Long getIdDocRestClient() {
		return idDocRestClient;
	}

	public void setIdDocRestClient(Long idDocRestClient) {
		this.idDocRestClient = idDocRestClient;
	}

	public Long getAdjunto() {
		return adjunto;
	}

	public void setAdjunto(Long adjunto) {
		this.adjunto = adjunto;
	}
	
	
	
}
