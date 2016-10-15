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
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.apache.commons.lang.BooleanUtils;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
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
    
    @OneToOne(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private CondicionanteExpediente condicionante; 
    
    @OneToMany(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private List<CompradorExpediente> compradores;
    
    @OneToMany(mappedBy = "expediente", fetch = FetchType.LAZY)
    @OrderBy("fechaPosicionamiento DESC")
    private List<Posicionamiento> posicionamientos;
    
    @Column(name="ECO_FECHA_ANULACION")
    private Date fechaAnulacion;
    
    @Column(name="ECO_MOTIVO_ANULACION")
    private String motivoAnulacion;
    
    @Column(name="ECO_FECHA_CONT_PROPIETARIO")
    private Date fechaContabilizacionPropietario;
    
    @Column(name="ECO_PETICIONARIO_ANULACION")
    private String peticionarioAnulacion;
    
    @Column(name="ECO_IMP_DEV_ENTREGAS")
    private Double importeDevolucionEntregas;
    
    @Column(name="ECO_FECHA_DEV_ENTREGAS")
    private Date fechaDevolucionEntregas;

    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Trabajo trabajo;
    
    @OneToMany(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<AdjuntoExpedienteComercial> adjuntos;
    
    @Column(name="ECO_FECHA_INICIO_ALQUILER")
    private Date fechaInicioAlquiler;
    
    @Column(name="ECO_FECHA_FIN_ALQUILER")
    private Date fechaFinAlquiler;
    
    @Column(name="ECO_IMPORTE_RENTA_ALQUILER")
    private Double importeRentaAlquiler;
    
    @Column(name="ECO_NUMERO_CONTRATO_ALQUILER")
    private Integer numContratoAlquiler;
    
    @Column(name="ECO_PLAZO_OPCION_COMPRA")
    private Date fechaPlazoOpcionCompraAlquiler;
    
    @Column(name="ECO_PRIMA_OPCION_COMPRA")
    private Double primaOpcionCompraAlquiler;
    
    @Column(name="ECO_PRECIO_OPCION_COMPRA")
    private Double precioOpcionCompraAlquiler;
    
    @Column(name="ECO_CONDICIONES_OPCION_COMPRA")
    private String condicionesOpcionCompraAlquiler;
    
    @Column(name="ECO_CONFLICTO_INTERESES")
    private Integer conflictoIntereses;
    
    @Column(name="ECO_RIESGO_REPUTACIONAL")
    private Integer riesgoReputacional;
    
    @Column(name="ECO_FECHA_SANCION_COMITE")
    private Date fechaSancionComite;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_COS_ID")
	private DDComiteSancion comiteSancion;   
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_COS_ID_PROPUESTO")
	private DDComiteSancion comitePropuesto;
    
    @Column(name="ECO_ESTADO_PBC")
    private Integer estadoPbc;   
    
    
     
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

	public CondicionanteExpediente getCondicionante() {
		return condicionante;
	}

	public void setCondicionante(CondicionanteExpediente condicionante) {
		this.condicionante = condicionante;
	}

	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}

	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}

	public String getMotivoAnulacion() {
		return motivoAnulacion;
	}

	public void setMotivoAnulacion(String motivoAnulacion) {
		this.motivoAnulacion = motivoAnulacion;
	}
	
    public List<Posicionamiento> getPosicionamientos() {
		return posicionamientos;
	}

	public void setPosicionamientos(List<Posicionamiento> posicionamientos) {
		this.posicionamientos = posicionamientos;
	}

	public Date getFechaContabilizacionPropietario() {
		return fechaContabilizacionPropietario;
	}

	public void setFechaContabilizacionPropietario(
			Date fechaContabilizacionPropietario) {
		this.fechaContabilizacionPropietario = fechaContabilizacionPropietario;
	}

	public String getPeticionarioAnulacion() {
		return peticionarioAnulacion;
	}

	public void setPeticionarioAnulacion(String peticionarioAnulacion) {
		this.peticionarioAnulacion = peticionarioAnulacion;
	}

	public Double getImporteDevolucionEntregas() {
		return importeDevolucionEntregas;
	}

	public void setImporteDevolucionEntregas(Double importeDevolucionEntregas) {
		this.importeDevolucionEntregas = importeDevolucionEntregas;
	}

	public Date getFechaDevolucionEntregas() {
		return fechaDevolucionEntregas;
	}

	public void setFechaDevolucionEntregas(Date fechaDevolucionEntregas) {
		this.fechaDevolucionEntregas = fechaDevolucionEntregas;
	}

	public Comprador getCompradorPrincipal() {
    	Comprador comprador = null;
    	
    	if(!Checks.esNulo(this.compradores)) {
    	
	    	for(CompradorExpediente compradorExp: this.compradores) {
	    		
	    		if(BooleanUtils.toBoolean(compradorExp.getTitularContratacion())) {
	    			comprador = compradorExp.getPrimaryKey().getComprador();
	    		}	    		
	    	}
    	}
    	
    	return comprador;
    	
    }
    
    public Posicionamiento getUltimoPosicionamiento() {
    	
    	Posicionamiento posicionamiento = null;
    	
    	if(!Checks.esNulo(this.posicionamientos) && !this.posicionamientos.isEmpty()) {    		
    		posicionamiento = this.posicionamientos.get(0);
    	}
    	
    	return posicionamiento;
    }

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
	}
    
	public List<AdjuntoExpedienteComercial> getAdjuntos() {
		return adjuntos;
	}

	public void setAdjuntos(List<AdjuntoExpedienteComercial> adjuntos) {
		this.adjuntos = adjuntos;
	}
    
	/**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public AdjuntoExpedienteComercial getAdjunto(Long id) {
        for (AdjuntoExpedienteComercial adj : getAdjuntos()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }

	public Date getFechaInicioAlquiler() {
		return fechaInicioAlquiler;
	}

	public void setFechaInicioAlquiler(Date fechaInicioAlquiler) {
		this.fechaInicioAlquiler = fechaInicioAlquiler;
	}

	public Date getFechaFinAlquiler() {
		return fechaFinAlquiler;
	}

	public void setFechaFinAlquiler(Date fechaFinAlquiler) {
		this.fechaFinAlquiler = fechaFinAlquiler;
	}

	public Double getImporteRentaAlquiler() {
		return importeRentaAlquiler;
	}

	public void setImporteRentaAlquiler(Double importeRentaAlquiler) {
		this.importeRentaAlquiler = importeRentaAlquiler;
	}

	public Integer getNumContratoAlquiler() {
		return numContratoAlquiler;
	}

	public void setNumContratoAlquiler(Integer numContratoAlquiler) {
		this.numContratoAlquiler = numContratoAlquiler;
	}

	public Date getFechaPlazoOpcionCompraAlquiler() {
		return fechaPlazoOpcionCompraAlquiler;
	}

	public void setFechaPlazoOpcionCompraAlquiler(
			Date fechaPlazoOpcionCompraAlquiler) {
		this.fechaPlazoOpcionCompraAlquiler = fechaPlazoOpcionCompraAlquiler;
	}

	public Double getPrimaOpcionCompraAlquiler() {
		return primaOpcionCompraAlquiler;
	}

	public void setPrimaOpcionCompraAlquiler(Double primaOpcionCompraAlquiler) {
		this.primaOpcionCompraAlquiler = primaOpcionCompraAlquiler;
	}

	public Double getPrecioOpcionCompraAlquiler() {
		return precioOpcionCompraAlquiler;
	}

	public void setPrecioOpcionCompraAlquiler(Double precioOpcionCompraAlquiler) {
		this.precioOpcionCompraAlquiler = precioOpcionCompraAlquiler;
	}

	public String getCondicionesOpcionCompraAlquiler() {
		return condicionesOpcionCompraAlquiler;
	}

	public void setCondicionesOpcionCompraAlquiler(
			String condicionesOpcionCompraAlquiler) {
		this.condicionesOpcionCompraAlquiler = condicionesOpcionCompraAlquiler;
	}

	public Integer getConflictoIntereses() {
		return conflictoIntereses;
	}

	public void setConflictoIntereses(Integer conflictoIntereses) {
		this.conflictoIntereses = conflictoIntereses;
	}

	public Integer getRiesgoReputacional() {
		return riesgoReputacional;
	}

	public void setRiesgoReputacional(Integer riesgoReputacional) {
		this.riesgoReputacional = riesgoReputacional;
	}

	public Date getFechaSancionComite() {
		return fechaSancionComite;
	}

	public void setFechaSancionComite(Date fechaSancionComite) {
		this.fechaSancionComite = fechaSancionComite;
	}

	public DDComiteSancion getComiteSancion() {
		return comiteSancion;
	}

	public void setComiteSancion(DDComiteSancion comiteSancion) {
		this.comiteSancion = comiteSancion;
	}

	public DDComiteSancion getComitePropuesto() {
		return comitePropuesto;
	}

	public void setComitePropuesto(DDComiteSancion comitePropuesto) {
		this.comitePropuesto = comitePropuesto;
	}

	public Integer getEstadoPbc() {
		return estadoPbc;
	}

	public void setEstadoPbc(Integer estadoPbc) {
		this.estadoPbc = estadoPbc;
	}
	
    
   
}
