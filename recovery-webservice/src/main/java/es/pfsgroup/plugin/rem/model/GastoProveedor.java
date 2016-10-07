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
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;


/**
 * Modelo que gestiona la informacion de gasto de un proveedor
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "GPV_GASTOS_PROVEEDOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class GastoProveedor implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "GPV_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoProveedorGenerator")
    @SequenceGenerator(name = "GastoProveedorGenerator", sequenceName = "S_GPV_GASTOS_PROVEEDOR")
    private Long id;
	
	@Column(name="GPV_REF_EMISOR")
	private String referenciaEmisor;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TGA_ID")
    private DDTipoGasto tipoGasto;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STG_ID")
    private DDSubtipoGasto subtipoGasto;
	
	@Column(name="GPV_CONCEPTO")
	private String concepto;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPE_ID")
    private DDTipoPeriocidad tipoPeriocidad;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_EMISOR")
	private ActivoProveedor proveedor;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PRO_ID")
	private ActivoPropietario propietario;
	
	@Column(name="GPV_FECHA_EMISION")
	private Date fechaEmision;
	
	@Column(name="GPV_FECHA_NOTIFICACION")
	private Date fechaNotificacion;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DEG_ID")
    private DDDestinatarioGasto destinatarioGasto;
	
	@Column(name="GPV_CUBRE_SEGURO")
	private Integer cubreSeguro;
	
	@Column(name="GPV_OBSERVACIONES")
	private String observaciones;
	
	@Column(name="GPV_NUM_GASTO_HAYA")
	private Long numGastoHaya;
	
	@Column(name="GPV_NUM_GASTO_GESTORIA")
	private Long numGastoGestoria;
	
    @OneToOne(mappedBy = "gastoProveedor", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private GastoGestion gastoGestion;

    @OneToOne(mappedBy = "gastoProveedor", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private GastoDetalleEconomico gastoDetalleEconomico;    
	
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="PRG_ID")
	private ProvisionGastos provision;
	
    @OneToMany(mappedBy = "gastoProveedor", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<AdjuntoGasto> adjuntos;
    
    @OneToMany(mappedBy = "gastoProveedor", fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<GastoProveedorTrabajo> gastoProveedorTrabajos;
    
    @OneToMany(mappedBy = "gastoProveedor", fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<GastoProveedorActivo> gastoProveedorActivos;
    
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

	public String getReferenciaEmisor() {
		return referenciaEmisor;
	}

	public void setReferenciaEmisor(String referenciaEmisor) {
		this.referenciaEmisor = referenciaEmisor;
	}

	public DDTipoGasto getTipoGasto() {
		return tipoGasto;
	}

	public void setTipoGasto(DDTipoGasto tipoGasto) {
		this.tipoGasto = tipoGasto;
	}

	public DDSubtipoGasto getSubtipoGasto() {
		return subtipoGasto;
	}

	public void setSubtipoGasto(DDSubtipoGasto subtipoGasto) {
		this.subtipoGasto = subtipoGasto;
	}

	public String getConcepto() {
		return concepto;
	}

	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}

	public DDTipoPeriocidad getTipoPeriocidad() {
		return tipoPeriocidad;
	}

	public void setTipoPeriocidad(DDTipoPeriocidad tipoPeriocidad) {
		this.tipoPeriocidad = tipoPeriocidad;
	}

	public ActivoProveedor getProveedor() {
		return proveedor;
	}

	public void setProveedor(ActivoProveedor proveedor) {
		this.proveedor = proveedor;
	}

	public Date getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public Date getFechaNotificacion() {
		return fechaNotificacion;
	}

	public void setFechaNotificacion(Date fechaNotificacion) {
		this.fechaNotificacion = fechaNotificacion;
	}

	public DDDestinatarioGasto getDestinatarioGasto() {
		return destinatarioGasto;
	}

	public void setDestinatarioGasto(DDDestinatarioGasto destinatarioGasto) {
		this.destinatarioGasto = destinatarioGasto;
	}

	public Integer getCubreSeguro() {
		return cubreSeguro;
	}

	public void setCubreSeguro(Integer cubreSeguro) {
		this.cubreSeguro = cubreSeguro;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public ActivoPropietario getPropietario() {
		return propietario;
	}

	public void setPropietario(ActivoPropietario propietario) {
		this.propietario = propietario;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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

	public Long getNumGastoHaya() {
		return numGastoHaya;
	}

	public void setNumGastoHaya(Long numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
	}

	public Long getNumGastoGestoria() {
		return numGastoGestoria;
	}

	public void setNumGastoGestoria(Long numGastoGestoria) {
		this.numGastoGestoria = numGastoGestoria;
	}


	public ProvisionGastos getProvision() {
		return provision;
	}

	public void setProvision(ProvisionGastos provision) {
		this.provision = provision;
	}

	public GastoGestion getGastoGestion() {
		return gastoGestion;
	}

	public void setGastoGestion(GastoGestion gastoGestion) {
		this.gastoGestion = gastoGestion;
	}

	public GastoDetalleEconomico getGastoDetalleEconomico() {
		return gastoDetalleEconomico;
	}

	public void setGastoDetalleEconomico(GastoDetalleEconomico gastoDetalleEconomico) {
		this.gastoDetalleEconomico = gastoDetalleEconomico;
	}

	public List<GastoProveedorTrabajo> getGastoProveedorTrabajos() {
		return gastoProveedorTrabajos;
	}

	public void setGastoProveedorTrabajos(
			List<GastoProveedorTrabajo> gastoProveedorTrabajos) {
		this.gastoProveedorTrabajos = gastoProveedorTrabajos;
	}

	public List<GastoProveedorActivo> getGastoProveedorActivos() {
		return gastoProveedorActivos;
	}

	public void setGastoProveedorActivos(
			List<GastoProveedorActivo> gastoProveedorActivos) {
		this.gastoProveedorActivos = gastoProveedorActivos;
	}
	public List<AdjuntoGasto> getAdjuntos() {
		return adjuntos;
	}

	public void setAdjuntos(List<AdjuntoGasto> adjuntos) {
		this.adjuntos = adjuntos;
	}
	
	/**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public AdjuntoGasto getAdjunto(Long id) {
        for (AdjuntoGasto adj : getAdjuntos()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }

    
}
