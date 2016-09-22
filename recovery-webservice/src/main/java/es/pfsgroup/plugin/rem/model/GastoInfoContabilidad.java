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
import es.pfsgroup.plugin.rem.model.dd.DDCuentaContable;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDPartidaPresupuestaria;
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
@Inheritance(strategy=InheritanceType.JOINED)
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
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PPR_ID")
    private DDPartidaPresupuestaria partidaPresupuestaria;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CCO_ID")
    private DDCuentaContable cuentaContable;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPE_ID_ESPECIAL")
    private DDTipoPeriocidad tipoPeriocidadEspecial;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRE_ID_ESPECIAL")
    private DDPartidaPresupuestaria partidaPresupuestariaEspecial;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CCO_ID_ESPECIAL")
    private DDCuentaContable cuentaContableEspecial;
    
    @Column(name="GIC_FECHA_CONTABILIZACION")
    private Date fechaContabilizacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DES_ID_CONTABILIZA")
    private DDDestinatarioGasto contabilizadoPor;
    
    
    
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

	public DDPartidaPresupuestaria getPartidaPresupuestaria() {
		return partidaPresupuestaria;
	}

	public void setPartidaPresupuestaria(
			DDPartidaPresupuestaria partidaPresupuestaria) {
		this.partidaPresupuestaria = partidaPresupuestaria;
	}

	public DDCuentaContable getCuentaContable() {
		return cuentaContable;
	}

	public void setCuentaContable(DDCuentaContable cuentaContable) {
		this.cuentaContable = cuentaContable;
	}

	public DDTipoPeriocidad getTipoPeriocidadEspecial() {
		return tipoPeriocidadEspecial;
	}

	public void setTipoPeriocidadEspecial(DDTipoPeriocidad tipoPeriocidadEspecial) {
		this.tipoPeriocidadEspecial = tipoPeriocidadEspecial;
	}

	public DDPartidaPresupuestaria getPartidaPresupuestariaEspecial() {
		return partidaPresupuestariaEspecial;
	}

	public void setPartidaPresupuestariaEspecial(
			DDPartidaPresupuestaria partidaPresupuestariaEspecial) {
		this.partidaPresupuestariaEspecial = partidaPresupuestariaEspecial;
	}

	public DDCuentaContable getCuentaContableEspecial() {
		return cuentaContableEspecial;
	}

	public void setCuentaContableEspecial(DDCuentaContable cuentaContableEspecial) {
		this.cuentaContableEspecial = cuentaContableEspecial;
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
    



     
    
   
}
