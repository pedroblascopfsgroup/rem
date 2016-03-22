package es.pfsgroup.plugin.recovery.liquidaciones.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cobropago.model.CobroPago;
import es.capgemini.pfs.cobropago.model.DDEstadoCobroPago;
import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.commons.utils.Checks;

@Entity
@Table(name = "CPA_COBROS_PAGOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class LIQCobroPago implements Auditable, Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4828134585141618353L;

	@Id
    @Column(name = "CPA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CobroPagoGenerator")
    @SequenceGenerator(name = "CobroPagoGenerator", sequenceName = "S_CPA_COBROS_PAGOS")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "PRC_ID")
    private Procedimiento procedimiento;

    @ManyToOne
    @JoinColumn(name = "ASU_ID")
    private Asunto asunto;

    @ManyToOne
    @JoinColumn(name = "DD_ECP_ID")
    @NotNull(message = "plugin.liquidaciones.model.liqcobropago.estado.null")
    private DDEstadoCobroPago estado;

    @ManyToOne
    @JoinColumn(name = "DD_SCP_ID")
    @NotNull(message = "plugin.liquidaciones.model.liqcobropago.subtipo.null")
    private DDSubtipoCobroPago subTipo;

    @Column(name = "CPA_IMPORTE")
    @NotNull(message = "plugin.liquidaciones.model.liqcobropago.importe.null")
    private Float importe;

    @Column(name = "CPA_FECHA")
    @NotNull(message = "plugin.liquidaciones.model.liqcobropago.fecha.null")
    private Date fecha;

    @Column(name = "CPA_OBSERVACIONES")
    private String observaciones;
    
    @ManyToOne
    @JoinColumn(name = "DD_OC_ID")
    private DDOrigenCobro origenCobro;
    
    @ManyToOne
    @JoinColumn(name = "DD_MC_ID")
    private DDModalidadCobro modalidadCobro;
    

    @ManyToOne
    @JoinColumn(name = "DD_TIM_ID")
    private DDTipoImputacion tipoImputacion;
    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;
    
    @ManyToOne
    @JoinColumn(name = "CNT_ID")
    private Contrato contrato;
    
    @Column(name = "CPA_REVISADO")
    private Integer revisado;
    
    @Column(name = "CPA_FECHA_VALOR")
    private Date fechaValor;
   
    @Column(name = "CPA_CAPITAL")
    private Float capital;
    
    @Column(name="CPA_INTERESES_ORDINAR")
    private Float interesesOrdinarios;
    
    @Column(name="CPA_IMPUESTOS")
    private Float impuestos;
    
    @Column(name="CPA_COMISIONES")
    private Float comisiones;
    
    @Column(name="CPA_GASTOS")
    private Float gastos;
    
    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the procedimiento
     */
    public Procedimiento getProcedimiento() {
        return procedimiento;
    }

    /**
     * @param procedimiento the procedimiento to set
     */
    public void setProcedimiento(Procedimiento procedimiento) {
        this.procedimiento = procedimiento;
    }

    /**
     * @return the asunto
     */
    public Asunto getAsunto() {
        return asunto;
    }

    /**
     * @param asunto the asunto to set
     */
    public void setAsunto(Asunto asunto) {
        this.asunto = asunto;
    }

    /**
     * @return the estado
     */
    public DDEstadoCobroPago getEstado() {
        return estado;
    }

    /**
     * @param estado the estado to set
     */
    public void setEstado(DDEstadoCobroPago estado) {
        this.estado = estado;
    }

    /**
     * @return the subTipo
     */
    public DDSubtipoCobroPago getSubTipo() {
        return subTipo;
    }

    /**
     * @param subTipo the subTipo to set
     */
    public void setSubTipo(DDSubtipoCobroPago subTipo) {
        this.subTipo = subTipo;
    }

    /**
     * @return the importe
     */
    public Float getImporte() {
        return importe;
    }

    /**
     * @param importe the importe to set
     */
    public void setImporte(Float importe) {
        this.importe = importe;
    }

    /**
     * @return the fecha
     */
    public Date getFecha() {
        return fecha;
    }

    /**
     * @param fecha the fecha to set
     */
    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public Contrato getContrato() {
		return contrato;
	}
	
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setOrigenCobro(DDOrigenCobro origenCobro) {
		this.origenCobro = origenCobro;
	}

	public DDOrigenCobro getOrigenCobro() {
		return origenCobro;
	}

	public void setModalidadCobro(DDModalidadCobro modalidadCobro) {
		this.modalidadCobro = modalidadCobro;
	}

	public DDModalidadCobro getModalidadCobro() {
		return modalidadCobro;
	}

	public Integer getRevisado() {
		return revisado;
	}

	public void setRevisado(Integer revisado) {
		this.revisado = revisado;
	}

	public DDTipoImputacion getTipoImputacion() {
		return tipoImputacion;
	}

	public void setTipoImputacion(DDTipoImputacion tipoImputacion) {
		this.tipoImputacion = tipoImputacion;
	}

	public Date getFechaValor() {
		return fechaValor;
	}

	public void setFechaValor(Date fechaValor) {
		this.fechaValor = fechaValor;
	}

	public Float getCapital() {
		return capital;
	}

	public void setCapital(Float capital) {
		this.capital = capital;
	}

	public Float getInteresesOrdinarios() {
		return interesesOrdinarios;
	}

	public void setInteresesOrdinarios(Float interesesOrdinarios) {
		this.interesesOrdinarios = interesesOrdinarios;
	}

	public Float getImpuestos() {
		return impuestos;
	}

	public void setImpuestos(Float impuestos) {
		this.impuestos = impuestos;
	}

	public Float getComisiones() {
		return comisiones;
	}

	public void setComisiones(Float comisiones) {
		this.comisiones = comisiones;
	}

	public Float getGastos() {
		return gastos;
	}

	public void setGastos(Float gastos) {
		this.gastos = gastos;
	}
	
}
