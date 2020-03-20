package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;
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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
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
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGestionPlusv;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;


/**
 * Modelo que gestiona la plusvalía de un activo.
 * 
 * @author Mariam Lliso
 */
@Entity
@Table(name = "ACT_PLS_PLUSVALIA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ActivoPlusvalia implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ACT_PLS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoPlusvaliaGenerator")
	@SequenceGenerator(name = "ActivoPlusvaliaGenerator", sequenceName = "S_ACT_PLS_PLUSVALIA")
	private Long id;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

	@Column(name = "ACT_PLS_FECHA_RECEPCION_PLUSVALIA")
	private Date dateRecepcionPlus;
	
	@Column(name = "ACT_PLS_FECHA_PRESENTACION_PLUSVALIA")
	private Date datePresentacionPlus;
	
	@Column(name = "ACT_PLS_FECHA_PRESENTACION_RECURSO")
	private Date datePresentacionRecu;
	
	@Column(name = "ACT_PLS_FECHA_RESPUESTA_RECURSO")
	private Date dateRespuestaRecu;
	
	
	@JoinColumn(name = "ACT_PLS_APERTURA_Y_SEGUIMIENTO_EXP")  
    @ManyToOne(fetch = FetchType.LAZY)
   	private DDSinSiNo aperturaSeguimientoExp;
    
    @Column(name = "ACT_PLS_IMPORTE_PAGADO")
   	private BigDecimal importePagado;
    
	@ManyToOne
    @JoinColumn(name = "GPV_ID")
    private GastoProveedor gastoProveedor; 
    
	@JoinColumn(name = "ACT_PLS_MINUSVALIA")  
    @ManyToOne(fetch = FetchType.LAZY)
   	private DDSinSiNo minusvalia;
    
	@JoinColumn(name = "ACT_PLS_EXENTO")  
    @ManyToOne(fetch = FetchType.LAZY)
   	private DDSinSiNo exento;
    
	@JoinColumn(name = "ACT_PLS_AUTOLIQUIDACION")  
    @ManyToOne(fetch = FetchType.LAZY)
   	private DDSinSiNo autoliquidacion;
    
    @Column(name = "ACT_PLS_OBSERVACIONES")
   	private String observaciones;
    
   @OneToMany(mappedBy = "plusvalia", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
   @JoinColumn(name = "PLS_ID")
   @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
   private List<AdjuntoPlusvalias> adjuntos;
	
	@JoinColumn(name = "DD_EGP_ID")  
    @ManyToOne(fetch = FetchType.LAZY)
   	private DDEstadoGestionPlusv estadoGestion;
   
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

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public Date getDateRecepcionPlus() {
		return dateRecepcionPlus;
	}

	public void setDateRecepcionPlus(Date dateRecepcionPlus) {
		this.dateRecepcionPlus = dateRecepcionPlus;
	}

	public Date getDatePresentacionPlus() {
		return datePresentacionPlus;
	}

	public void setDatePresentacionPlus(Date datePresentacionPlus) {
		this.datePresentacionPlus = datePresentacionPlus;
	}

	public Date getDatePresentacionRecu() {
		return datePresentacionRecu;
	}

	public void setDatePresentacionRecu(Date datePresentacionRecu) {
		this.datePresentacionRecu = datePresentacionRecu;
	}

	public Date getDateRespuestaRecu() {
		return dateRespuestaRecu;
	}

	public void setDateRespuestaRecu(Date dateRespuestaRecu) {
		this.dateRespuestaRecu = dateRespuestaRecu;
	}

	public DDSinSiNo getAperturaSeguimientoExp() {
		return aperturaSeguimientoExp;
	}

	public void setAperturaSeguimientoExp(DDSinSiNo aperturaSeguimientoExp) {
		this.aperturaSeguimientoExp = aperturaSeguimientoExp;
	}

	public BigDecimal getImportePagado() {
		return importePagado;
	}

	public void setImportePagado(BigDecimal importePagado) {
		this.importePagado = importePagado;
	}

	public GastoProveedor getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(GastoProveedor gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}

	public DDSinSiNo getMinusvalia() {
		return minusvalia;
	}

	public void setMinusvalia(DDSinSiNo minusvalia) {
		this.minusvalia = minusvalia;
	}

	public DDSinSiNo getExento() {
		return exento;
	}

	public void setExento(DDSinSiNo exento) {
		this.exento = exento;
	}

	public DDSinSiNo getAutoliquidacion() {
		return autoliquidacion;
	}

	public void setAutoliquidacion(DDSinSiNo autoliquidacion) {
		this.autoliquidacion = autoliquidacion;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	

	public List<AdjuntoPlusvalias> getAdjuntos() {
	return adjuntos;
	}

	public void setAdjuntos(List<AdjuntoPlusvalias> adjuntos) {
	this.adjuntos = adjuntos;
	}
	   
	/**
	    * devuelve el adjunto por Id.
	    * @param id id
	    * @return adjunto
	    */
	   public AdjuntoPlusvalias getAdjunto(Long id) {
	       for (AdjuntoPlusvalias adj : getAdjuntos()) {
	           if (adj.getId().equals(id)) { return adj; }
	       }
	       return null;
	   }
	   
	   /**
	    * devuelve el adjunto por Id.
	    * @param id id
	    * @return adjunto
	    */
	   public AdjuntoPlusvalias getAdjuntoGD(Long idDocRestClient) {
	   	for (AdjuntoPlusvalias adj : getAdjuntos()) {
	    if(!Checks.esNulo(adj.getDocumentoRest()) && adj.getDocumentoRest().equals(idDocRestClient)) { return adj; }
	       }
	       return null;
	   }

	public DDEstadoGestionPlusv getEstadoGestion() {
		return estadoGestion;
	}

	public void setEstadoGestion(DDEstadoGestionPlusv estadoGestion) {
		this.estadoGestion = estadoGestion;
	}	 
}
	