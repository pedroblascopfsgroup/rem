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
    
    @Column(name="GIC_CUENTA_CONTABLE")
    private String cuentaContable;
    
    @Column(name="GIC_PTDA_PRESUPUESTARIA")
    private String partidaPresupuestaria;
    
    @Column(name="GIC_CUENTA_CONTABLE_ESP")
    private String cuentaContableEspecial;
    
    @Column(name="GIC_PTDA_PRESUPUESTARIA_ESP")
    private String partidaPresupuestariaEspecial;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPE_ID_ESPECIAL")
    private DDTipoPeriocidad tipoPeriocidadEspecial;
    
    @Column(name="GIC_FECHA_DEVENGO_ESPECIAL")
    private Date fechaDevengoEspecial;
    
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

	public String getCuentaContable() {
		return cuentaContable;
	}

	public void setCuentaContable(String cuentaContable) {
		this.cuentaContable = cuentaContable;
	}

	public String getPartidaPresupuestaria() {
		return partidaPresupuestaria;
	}

	public void setPartidaPresupuestaria(String partidaPresupuestaria) {
		this.partidaPresupuestaria = partidaPresupuestaria;
	}

	public String getCuentaContableEspecial() {
		return cuentaContableEspecial;
	}

	public void setCuentaContableEspecial(String cuentaContableEspecial) {
		this.cuentaContableEspecial = cuentaContableEspecial;
	}

	public String getPartidaPresupuestariaEspecial() {
		return partidaPresupuestariaEspecial;
	}

	public void setPartidaPresupuestariaEspecial(
			String partidaPresupuestariaEspecial) {
		this.partidaPresupuestariaEspecial = partidaPresupuestariaEspecial;
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
    



     
    
   
}
