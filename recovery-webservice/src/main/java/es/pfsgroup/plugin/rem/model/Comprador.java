package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.persona.model.DDTipoPersona;


/**
 * Modelo que gestiona la informacion de un comprador
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "COM_COMPRADOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class Comprador implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "COM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CompradorGenerator")
    @SequenceGenerator(name = "CompradorGenerator", sequenceName = "S_COM_COMPRADOR")
    private Long id;
	
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPE_ID")
    private DDTipoPersona tipoPersona;
    
    @Column(name = "COM_NOMBRE")
    private String nombre;
    
    @Column(name = "COM_APELLIDOS")
    private String apellidos;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID")
	private DDTipoDocumento tipoDocumento;
    
    @Column(name = "COM_DOCUMENTO")
    private String documento;
    
    @Column(name = "COM_TELEFONO1")
    private String telefono1;
    
    @Column(name = "COM_TELEFONO2")
    private String telefono2;
    
    @Column(name = "COM_EMAIL")
    private String email;
    
    @Column(name = "COM_DIRECCION")
    private String direccion;
    
    @Column(name = "COM_MUNICIPIO")
    private String municipio;
    
    @Column(name = "COM_CODIGO_POSTAL")
    private String codigoPostal;
    
    @Column(name = "COM_PROVINCIA")
    private String provincia;   
   
    

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;
    

	
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
