package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComisionado;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;


/**
 * Modelo que gestiona la informacion de la contabilidad de un gasto
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "GIC_GASTOS_INFO_CONTABILIDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class GastoInfoContabilidad implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "GIC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoInfoContabilidadGenerator")
    @SequenceGenerator(name = "GastoInfoContabilidadGenerator", sequenceName = "S_GIC_GASTOS_INFO_CONTABILIDAD")
    private Long id;
	
    @ManyToOne
    @JoinColumn(name = "GPV_ID")
    private GastoProveedor gastoProveedor;
    
    @ManyToOne
    @JoinColumn(name = "EJE_ID")
    private Ejercicio ejercicio;
    
    @Column(name="GIC_FECHA_CONTABILIZACION")
    private Date fechaContabilizacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DEG_ID_CONTABILIZA")
    private DDDestinatarioGasto contabilizadoPor;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPE_ID_ESPECIAL")
    private DDTipoPeriocidad tipoPeriocidadEspecial;
    
    @Column(name="GIC_FECHA_DEVENGO_ESPECIAL")
    private Date fechaDevengoEspecial;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CPS_ID")
    private ConfiguracionSubpartidasPresupuestarias configuracionSubpartidasPresupuestarias;

	@JoinColumn(name = "GIC_ACTIVABLE")
	@ManyToOne(fetch = FetchType.LAZY)
	private DDSinSiNo activable;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TCH_ID")
    private DDTipoComisionado tipoComisionadoHre;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "GIC_PLAN_VISITAS")
	private DDSinSiNo gicPlanVisitas;

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


	public GastoProveedor getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(GastoProveedor gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}

	
	public Ejercicio getEjercicio() {
		return ejercicio;
	}

	public void setEjercicio(Ejercicio ejercicio) {
		this.ejercicio = ejercicio;
	}

	public DDTipoPeriocidad getTipoPeriocidadEspecial() {
		return tipoPeriocidadEspecial;
	}

	public void setTipoPeriocidadEspecial(DDTipoPeriocidad tipoPeriocidadEspecial) {
		this.tipoPeriocidadEspecial = tipoPeriocidadEspecial;
	}

	public Date getFechaContabilizacion() {
		return fechaContabilizacion;
	}

	public void setFechaContabilizacion(Date fechaContabilizacion) {
		this.fechaContabilizacion = fechaContabilizacion;
	}

	public DDDestinatarioGasto getContabilizadoPor() {
		return contabilizadoPor;
	}

	public void setContabilizadoPor(DDDestinatarioGasto contabilizadoPor) {
		this.contabilizadoPor = contabilizadoPor;
	}

	public Date getFechaDevengoEspecial() {
		return fechaDevengoEspecial;
	}

	public void setFechaDevengoEspecial(Date fechaDevengoEspecial) {
		this.fechaDevengoEspecial = fechaDevengoEspecial;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
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

	public ConfiguracionSubpartidasPresupuestarias getConfiguracionSubpartidasPresupuestarias() {
		return configuracionSubpartidasPresupuestarias;
	}

	public void setConfiguracionSubpartidasPresupuestarias(
			ConfiguracionSubpartidasPresupuestarias configuracionSubpartidasPresupuestarias) {
		this.configuracionSubpartidasPresupuestarias = configuracionSubpartidasPresupuestarias;
	}

	public DDSinSiNo getActivable() {
		return activable;
	}

	public void setActivable(DDSinSiNo activable) {
		this.activable = activable;
	}

	public DDTipoComisionado getTipoComisionadoHre() {
		return tipoComisionadoHre;
	}

	public void setTipoComisionadoHre(DDTipoComisionado tipoComisionadoHre) {
		this.tipoComisionadoHre = tipoComisionadoHre;
	}

	public DDSinSiNo getGicPlanVisitas() {
		return gicPlanVisitas;
	}

	public void setGicPlanVisitas(DDSinSiNo gicPlanVisitas) {
		this.gicPlanVisitas = gicPlanVisitas;
	}
	

}
