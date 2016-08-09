package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Iterator;
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

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.DDTipoBien;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDOrigenBien;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadOrigen;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDRatingActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPropuestaPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;


/**
 * Modelo que gestiona las propuestas de precios 
 * @author Jose Villel
 */
@Entity
@Table(name = "PRP_PROPUESTAS_PRECIOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class PropuestaPrecio implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
    @Id
    @Column(name = "PRP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PropuestaPrecioGenerator")
    @SequenceGenerator(name = "PropuestaPrecioGenerator", sequenceName = "S_PRP_PROPUESTAS_PRECIOS")
    private Long id;

    @Column(name = "PRP_NUM_PROPUESTA")
   	private Long numPropuesta;    
        
    @Column(name = "PRP_NOMBRE_PROPUESTA")
   	private String nombrePropuesta; 
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EPP_ID")
    private DDEstadoPropuestaPrecio estado;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    private Trabajo trabajo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
    private Usuario gestor;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
    private DDCartera cartera;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPP_ID")
    private DDTipoPropuestaPrecio tipoPropuesta;  

	@Column(name = "PRP_ES_PROP_MANUAL")
	private Boolean esPropuestaManual;
    
	@Column(name = "PRP_FECHA_EMISION")
	private Date fechaEmision;
	
	@Column(name = "PRP_FECHA_ENVIO")
	private Date fechaEnvio;
	
	@Column(name = "PRP_FECHA_SANCION")
	private Date fechaSancion;
	
	@Column(name = "PRP_FECHA_CARGA")
	private Date fechaCarga;
	
	@Column(name="PRP_OBSERVACIONES")
	private String observaciones;	
	
    @OneToMany(mappedBy = "propuestaPrecio", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "PRP_ID")
    private List<ActivoPropuesta> activosPropuesta;

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

	public Long getNumPropuesta() {
		return numPropuesta;
	}

	public void setNumPropuesta(Long numPropuesta) {
		this.numPropuesta = numPropuesta;
	}

	public DDEstadoPropuestaPrecio getEstado() {
		return estado;
	}

	public void setEstado(DDEstadoPropuestaPrecio estado) {
		this.estado = estado;
	}

	public Usuario getGestor() {
		return gestor;
	}

	public void setGestor(Usuario gestor) {
		this.gestor = gestor;
	}

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDTipoPropuestaPrecio getTipoPropuesta() {
		return tipoPropuesta;
	}

	public void setTipoPropuesta(DDTipoPropuestaPrecio tipoPropuesta) {
		this.tipoPropuesta = tipoPropuesta;
	}

	public Boolean getEsPropuestaManual() {
		return esPropuestaManual;
	}

	public void setEsPropuestaManual(Boolean esPropuestaManual) {
		this.esPropuestaManual = esPropuestaManual;
	}

	public Date getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}

	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public Date getFechaCarga() {
		return fechaCarga;
	}

	public void setFechaCarga(Date fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public List<ActivoPropuesta> getActivosPropuesta() {
		return activosPropuesta;
	}

	public void setActivosPropuesta(List<ActivoPropuesta> activosPropuesta) {
		this.activosPropuesta = activosPropuesta;
	}

	public String getNombrePropuesta() {
		return nombrePropuesta;
	}

	public void setNombrePropuesta(String nombrePropuesta) {
		this.nombrePropuesta = nombrePropuesta;
	}

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
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
