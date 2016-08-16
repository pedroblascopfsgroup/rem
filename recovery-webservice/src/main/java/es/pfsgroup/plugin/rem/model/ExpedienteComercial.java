package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

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
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
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
    
    @Column(name = "ECO_FECHA_ALTA")
    private Date fechaAlta;
    
    @Column(name = "ECO_FECHA_SANCION")
    private Date fechaSancion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;    
    
    @OneToOne(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Reserva reserva;
    
    @OneToOne(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Formalizacion formalizacion;   
    
    @OneToMany(mappedBy = "comprador", fetch = FetchType.LAZY)
    private List<CompradorExpediente> compradores;

     
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

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}

	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public List<CompradorExpediente> getCompradores() {
		return compradores;
	}

	public void setCompradores(List<CompradorExpediente> compradores) {
		this.compradores = compradores;
	}

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public Reserva getReserva() {
		return reserva;
	}

	public void setReserva(Reserva reserva) {
		this.reserva = reserva;
	}

	public Formalizacion getFormalizacion() {
		return formalizacion;
	}

	public void setFormalizacion(Formalizacion formalizacion) {
		this.formalizacion = formalizacion;
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
    
    public Comprador getCompradorPrincipal() {
    	Comprador comprador = null;
    	
    	for(CompradorExpediente compradorExp: this.compradores) {
    		
    		if(compradorExp.isTitularContratacion()) {
    			comprador = compradorExp.getPrimaryKey().getComprador();
    		}
    		
    	}
    	
    	return comprador;
    	
    }
    
    
   
}
