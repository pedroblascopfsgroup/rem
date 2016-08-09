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
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;


/**
 * Modelo que gestiona la informacion de un cliente comercial
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "ECO_EXPEDIENTE_COMERCIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ExpedienteComercial implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "ECO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ExpedienteComercialGenerator")
    @SequenceGenerator(name = "ExpedienteComercialGenerator", sequenceName = "S_ECO_EXPEDIENTE_COMERCIAL")
    private Long id;
	
    @Column(name = "ECO_NUM_EXPEDIENTE")
    private Long numExpediente;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EEC_ID")
	private DDEstadosExpedienteComercial estado;      
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "RES_ID")
    private Reserva reserva;   

     
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

	

	public Long getNumExpediente() {
		return numExpediente;
	}

	public void setNumExpediente(Long numExpediente) {
		this.numExpediente = numExpediente;
	}

	public DDEstadosExpedienteComercial getEstado() {
		return estado;
	}

	public void setEstado(DDEstadosExpedienteComercial estado) {
		this.estado = estado;
	}

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
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
