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
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
/**
 * HREOS-4937
 * 
 * Modelo que gestiona la informacion GDPR de un cliente
 *  
 * @author Carlos Ruiz Beltrán
 *
 */
@Entity
@Table(name = "CGD_CLIENTE_GDPR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ClienteGDPR implements Serializable, Auditable{
	
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "CGD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ClienteGdprGenerator")
    @SequenceGenerator(name = "ClienteGdprGenerator", sequenceName = "S_CGD_CLIENTE_GDPR")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CLC_ID")
    private ClienteComercial cliente;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID")
	private DDTipoDocumento tipoDocumento;
	
    @Column(name = "NUM_DOCUMENTO")
    private String numDocumento;
    
    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ADCOM_ID")
    private AdjuntoComprador adjuntoComprador;
    
    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ADCOM_DOC_IDENT")
    private AdjuntoComprador adcomIdDocumentoIdentificativo;
    

	  //Se añaden nuevos atributos. HREOS-4851<o
    @Column(name = "CLC_CESION_DATOS")
    private Boolean cesionDatos;
    
    @Column(name = "CLC_COMUNI_TERCEROS")
    private Boolean comunicacionTerceros;
    
    @Column(name = "CLC_TRANSF_INTER")
    private Boolean transferenciasInternacionales;
    
    
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

	public ClienteComercial getCliente() {
		return cliente;
	}

	public void setCliente(ClienteComercial cliente) {
		this.cliente = cliente;
	}

	public DDTipoDocumento getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(DDTipoDocumento tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public String getNumDocumento() {
		return numDocumento;
	}

	public void setNumDocumento(String numDocumento) {
		this.numDocumento = numDocumento;
	}
	

	public AdjuntoComprador getAdjuntoComprador() {
		return adjuntoComprador;
	}

	public void setAdjuntoComprador(AdjuntoComprador adjuntoComprador) {
		this.adjuntoComprador = adjuntoComprador;
	}

	public Boolean getCesionDatos() {
		return cesionDatos;
	}

	public void setCesionDatos(Boolean cesionDatos) {
		this.cesionDatos = cesionDatos;
	}

	public Boolean getComunicacionTerceros() {
		return comunicacionTerceros;
	}

	public void setComunicacionTerceros(Boolean comunicacionTerceros) {
		this.comunicacionTerceros = comunicacionTerceros;
	}

	public Boolean getTransferenciasInternacionales() {
		return transferenciasInternacionales;
	}

	public void setTransferenciasInternacionales(Boolean transferenciasInternacionales) {
		this.transferenciasInternacionales = transferenciasInternacionales;
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

	public AdjuntoComprador getAdcomIdDocumentoIdentificativo() {
		return adcomIdDocumentoIdentificativo;
	}

	public void setAdcomIdDocumentoIdentificativo(AdjuntoComprador adcomIdDocumentoIdentificativo) {
		this.adcomIdDocumentoIdentificativo = adcomIdDocumentoIdentificativo;
	}
	
	
}
