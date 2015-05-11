package es.capgemini.pfs.movimiento.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDMotivoRenumeracion;

/**
 * Clase que representa la entidad Movimiento.
 * @author Lisandro Medrano
 *
 */
@Entity
@Table(name = "MOV_MOVIMIENTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class Movimiento implements Serializable, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "MOV_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "CNT_ID")
    private Contrato contrato;

    @Column(name = "MOV_POS_VIVA_NO_VENCIDA")
    private Float posVivaNoVencida;

    @Column(name = "MOV_POS_VIVA_VENCIDA")
    private Float posVivaVencida;

    @Column(name = "MOV_FECHA_POS_VENCIDA")
    private Date fechaPosVencida;

    @Column(name = "MOV_SALDO_DUDOSO")
    private Float saldoDudoso;

    @Column(name = "MOV_FECHA_DUDOSO")
    private Date fechaDudoso;

    @Column(name = "MOV_PROVISION")
    private Float provision;

    @Column(name = "MOV_INT_REMUNERATORIOS")
    private Float movIntRemuneratorios;

    @Column(name = "MOV_INT_MORATORIOS")
    private Float movIntMoratorios;

    @Column(name = "MOV_COMISIONES")
    private Float comisiones;

    @Column(name = "MOV_GASTOS")
    private Float gastos;

    @Column(name = "MOV_FECHA_EXTRACCION")
    private Date fechaExtraccion;

    @Column(name = "MOV_FICHERO_CARGA")
    private String ficheroCarga;

    //    MOV_FECHA_CARGA      DATE NOT NULL,
    @Column(name = "MOV_FECHA_CARGA")
    private Date fechaCarga;

    @Column(name = "MOV_RIESGO")
    private Float riesgo;
    @Column(name = "MOV_DEUDA_IRREGULAR")
    private Float deudaIrregular;
    @Column(name = "MOV_DISPUESTO")
    private Float dispuesto;
    @Column(name = "MOV_SALDO_PASIVO")
    private Float saldoPasivo;
    @Column(name = "MOV_RIESGO_GARANT")
    private Float riesgoGarantizado;
    @Column(name = "MOV_SALDO_EXCE")
    private Float saldoExcedido;
    @Column(name = "MOV_LIMITE_DESC")
    private Float limiteDescubierto;
    @Column(name = "MOV_EXTRA_1")
    private Float extra1;
    @Column(name = "MOV_EXTRA_2")
    private Float extra2;
    @Column(name = "MOV_LTV_INI")
    private Float ltvInicial;
    @Column(name = "MOV_LTV_FIN")
    private Float ltvFinal;

    @ManyToOne
    @JoinColumn(name = "DD_MX3_ID")
    private DDMovimientoExtra3 extra3;
    @ManyToOne
    @JoinColumn(name = "DD_MX4_ID")
    private DDMovimientoExtra4 extra4;
    @Column(name = "MOV_EXTRA_5")
    private Date extra5;
    @Column(name = "MOV_EXTRA_6")
    private Date extra6;

    
    //Nuevos campos 10.0
    
    @Column(name = "MOV_ENTREGAS_A_CUENTA")
    private Float entregasACuenta;
    
    @Column(name = "MOV_DEUDA_EXIGIBLE")
    private Float deudaExigible;
    
    @Column(name = "MOV_INTERESES_ENTREGAS")
    private Float interesesEntregas;
    
    @Column(name = "MOV_CUOTAS_VENCIDAS_IMPAGADAS")
    private Float cuotasVencidasImpagadas;
    
    @Column(name = "MOV_PENDIENTE_DESEMBOLSO")
    private Float pendienteDesembolso;
    
    @Column(name = "EXTRAFLOAT")
    private Float extraFloat;
    
    @Column(name = "MOV_PROVISION_PORCENTAJE")
    private Integer provisionPorcentaje;
    
//    @Column(name = "MOV_SCORING")
//    private String scoring;
    
    @Column(name = "MOV_DOMICI_EXT_FECHA_RECIB_DEV")
    private Date fechaReciboDev;
    
    @Column(name = "MOV_DOMICI_EXT_TOTAL_SALDO_DEV")
    private Float totalRecibosDev;
    
    @Column(name = "MOV_CONTRATO_ANTERIOR")
    private String contratoAnterior;
    
    @ManyToOne
    @JoinColumn(name = "DD_MTR_ID")
    private DDMotivoRenumeracion motivoRenumeracion;
    
    @Column(name = "MOV_IMPUESTOS")
    private Float impuestos;
    
    @Column(name="MOV_CNT_FECHA_INI_EPI_IRREG")
    private Date fechaIniEpiIrregular;
    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * saldo total.
     * @return saldo
     */
    public Float getSaldoTotal() {
        return getPosVivaNoVencida() + getPosVivaVencida();
    }

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
     * @return the contrato
     */
    public Contrato getContrato() {
        return contrato;
    }

    /**
     * @param contrato the contrato to set
     */
    public void setContrato(Contrato contrato) {
        this.contrato = contrato;
    }

    /**
     * @return the posVivaNoVencida
     */
    public Float getPosVivaNoVencida() {
        return posVivaNoVencida;
    }

    /**
     * @param posVivaNoVencida the posVivaNoVencida to set
     */
    public void setPosVivaNoVencida(Float posVivaNoVencida) {
        this.posVivaNoVencida = posVivaNoVencida;
    }

    /**
     * @return the posVivaVencida
     */
    public Float getPosVivaVencida() {
        return posVivaVencida;
    }

    /**
     * @param posVivaVencida the posVivaVencida to set
     */
    public void setPosVivaVencida(Float posVivaVencida) {
        this.posVivaVencida = posVivaVencida;
    }

    /**
     * @return the fechaPosVencida
     */
    public Date getFechaPosVencida() {
        return fechaPosVencida;
    }

    /**
     * @param fechaPosVencida the fechaPosVencida to set
     */
    public void setFechaPosVencida(Date fechaPosVencida) {
        this.fechaPosVencida = fechaPosVencida;
    }

    /**
     * @return the saldoDudoso
     */
    public Float getSaldoDudoso() {
        return saldoDudoso;
    }

    /**
     * @param saldoDudoso the saldoDudoso to set
     */
    public void setSaldoDudoso(Float saldoDudoso) {
        this.saldoDudoso = saldoDudoso;
    }

    /**
     * @return the fechaDudoso
     */
    public Date getFechaDudoso() {
        return fechaDudoso;
    }

    /**
     * @param fechaDudoso the fechaDudoso to set
     */
    public void setFechaDudoso(Date fechaDudoso) {
        this.fechaDudoso = fechaDudoso;
    }

    /**
     * @return the provision
     */
    public Float getProvision() {
        return provision;
    }

    /**
     * @param provision the provision to set
     */
    public void setProvision(Float provision) {
        this.provision = provision;
    }

    /**
     * @return the movIntRemuneratorios
     */
    public Float getMovIntRemuneratorios() {
        return movIntRemuneratorios;
    }

    /**
     * @param movIntRemuneratorios the movIntRemuneratorios to set
     */
    public void setMovIntRemuneratorios(Float movIntRemuneratorios) {
        this.movIntRemuneratorios = movIntRemuneratorios;
    }

    /**
     * @return the movIntMoratorios
     */
    public Float getMovIntMoratorios() {
        return movIntMoratorios;
    }

    /**
     * @param movIntMoratorios the movIntMoratorios to set
     */
    public void setMovIntMoratorios(Float movIntMoratorios) {
        this.movIntMoratorios = movIntMoratorios;
    }

    /**
     * @return the comisiones
     */
    public Float getComisiones() {
        return comisiones;
    }

    /**
     * @param comisiones the comisiones to set
     */
    public void setComisiones(Float comisiones) {
        this.comisiones = comisiones;
    }

    /**
     * @return the gastos
     */
    public Float getGastos() {
        return gastos;
    }

    /**
     * @param gastos the gastos to set
     */
    public void setGastos(Float gastos) {
        this.gastos = gastos;
    }

    /**
     * @return the fechaExtraccion
     */
    public Date getFechaExtraccion() {
        return fechaExtraccion;
    }

    /**
     * @param fechaExtraccion the fechaExtraccion to set
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
        this.fechaExtraccion = fechaExtraccion;
    }

    /**
     * @return the ficheroCarga
     */
    public String getFicheroCarga() {
        return ficheroCarga;
    }

    /**
     * @param ficheroCarga the ficheroCarga to set
     */
    public void setFicheroCarga(String ficheroCarga) {
        this.ficheroCarga = ficheroCarga;
    }

    /**
     * @return the fechaCarga
     */
    public Date getFechaCarga() {
        return fechaCarga;
    }

    /**
     * @param fechaCarga the fechaCarga to set
     */
    public void setFechaCarga(Date fechaCarga) {
        this.fechaCarga = fechaCarga;
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

    /**
     * Devuelve la posici�n viva vencida absoluta.
     * @return la posVivaVencida si >=0 o - posVivaVencida si <0
     */
    public Float getPosVivaVencidaAbsoluta() {
        return Math.abs(posVivaVencida);
    }

    /**
     * Devuelve la posici�n viva no vencida absoluta.
     * @return la posVivaNoVencida si >=0 o - posVivaNoVencida si <0
     */
    public Float getPosVivaNoVencidaAbsoluta() {
        return Math.abs(posVivaNoVencida);
    }

    /**
     * Devuelve el saldo dudoso absoluto.
     * @return la saldoDudoso si >=0 o - saldoDudoso si <0
     */
    public Float getSaldoDudosoAbsoluto() {
        return Math.abs(saldoDudoso);
    }

    /**
     * Devuelve la provisi�n de forma absoluta.
     * @return la provisi�n en valor absoluto.
     */
    public Float getProvisionAbsoluta() {
        return Math.abs(provision);
    }

    /**
     * Devuelve las comisiones de forma absoluta.
     * @return las comisiones en valor absoluto.
     */
    public Float getComisionesAbsoluta() {
        return Math.abs(comisiones);
    }

    /**
     * Devuelve los movIntRemuneratorios de forma absoluta.
     * @return los movIntRemuneratorios en valor absoluto.
     */
    public Float getMovIntRemuneratoriosAbsoluta() {
        return Math.abs(movIntRemuneratorios);
    }

    /**
     * Devuelve los movIntMoratorios de forma absoluta.
     * @return los movIntMoratorios en valor absoluto.
     */
    public Float getMovIntMoratoriosAbsoluta() {
        return Math.abs(movIntMoratorios);
    }

    /**
     * Devuelve los gastos de forma absoluta.
     * @return los gastos en valor absoluto.
     */
    public Float getGastosAbsoluta() {
        return Math.abs(gastos);
    }

    /**
     * saldo total absoluto.
     * @return saldo en valor absoluto
     */
    public Float getSaldoTotalAbsoluto() {
        return Math.abs(getPosVivaNoVencida()) + Math.abs(getPosVivaVencida());
    }

    /**
     * @return the riesgo
     */
    public Float getRiesgo() {
        if (riesgo == null)
            return 0F;
        else
            return riesgo;
    }

    /**
     * @param riesgo the riesgo to set
     */
    public void setRiesgo(Float riesgo) {
        this.riesgo = riesgo;
    }

    /**
     * @return the deudaIrregular
     */
    public Float getDeudaIrregular() {
        return deudaIrregular;
    }

    /**
     * @param deudaIrregular the deudaIrregular to set
     */
    public void setDeudaIrregular(Float deudaIrregular) {
        this.deudaIrregular = deudaIrregular;
    }

    /**
     * @return the dispuesto
     */
    public Float getDispuesto() {
        return dispuesto;
    }

    /**
     * @param dispuesto the dispuesto to set
     */
    public void setDispuesto(Float dispuesto) {
        this.dispuesto = dispuesto;
    }

    /**
     * @return the saldoPasivo
     */
    public Float getSaldoPasivo() {
        return saldoPasivo;
    }

    /**
     * @param saldoPasivo the saldoPasivo to set
     */
    public void setSaldoPasivo(Float saldoPasivo) {
        this.saldoPasivo = saldoPasivo;
    }

    /**
     * @return the riesgoGarantizado
     */
    public Float getRiesgoGarantizado() {
        return riesgoGarantizado;
    }

    public Float getRiesgoNoGarantizado() {
        Float r = riesgo - riesgoGarantizado;
        if (r < 0) r = 0F;

        return r;
    }

    /**
     * @param riesgoGarantizado the riesgoGarantizado to set
     */
    public void setRiesgoGarantizado(Float riesgoGarantizado) {
        this.riesgoGarantizado = riesgoGarantizado;
    }

    /**
     * @return the saldoExcedido
     */
    public Float getSaldoExcedido() {
        return saldoExcedido;
    }

    /**
     * @param saldoExcedido the saldoExcedido to set
     */
    public void setSaldoExcedido(Float saldoExcedido) {
        this.saldoExcedido = saldoExcedido;
    }

    /**
     * @return the limiteDescubierto
     */
    public Float getLimiteDescubierto() {
        return limiteDescubierto;
    }

    /**
     * @param limiteDescubierto the limiteDescubierto to set
     */
    public void setLimiteDescubierto(Float limiteDescubierto) {
        this.limiteDescubierto = limiteDescubierto;
    }

    /**
     * @return the extra1
     */
    public Float getExtra1() {
        return extra1;
    }

    /**
     * @param extra1 the extra1 to set
     */
    public void setExtra1(Float extra1) {
        this.extra1 = extra1;
    }

    /**
     * @return the extra2
     */
    public Float getExtra2() {
        return extra2;
    }

    /**
     * @param extra2 the extra2 to set
     */
    public void setExtra2(Float extra2) {
        this.extra2 = extra2;
    }

    /**
     * @return the ltvInicial
     */
    public Float getLtvInicial() {
        return ltvInicial;
    }

    /**
     * @param ltvInicial the ltvInicial to set
     */
    public void setLtvInicial(Float ltvInicial) {
        this.ltvInicial = ltvInicial;
    }

    /**
     * @return the ltvFinal
     */
    public Float getLtvFinal() {
        return ltvFinal;
    }

    /**
     * @param ltvFinal the ltvFinal to set
     */
    public void setLtvFinal(Float ltvFinal) {
        this.ltvFinal = ltvFinal;
    }

    /**
     * @return the extra3
     */
    public DDMovimientoExtra3 getExtra3() {
        return extra3;
    }

    /**
     * @param extra3 the extra3 to set
     */
    public void setExtra3(DDMovimientoExtra3 extra3) {
        this.extra3 = extra3;
    }

    /**
     * @return the extra4
     */
    public DDMovimientoExtra4 getExtra4() {
        return extra4;
    }

    /**
     * @param extra4 the extra4 to set
     */
    public void setExtra4(DDMovimientoExtra4 extra4) {
        this.extra4 = extra4;
    }

    /**
     * @return the extra5
     */
    public Date getExtra5() {
        return extra5;
    }

    /**
     * @param extra5 the extra5 to set
     */
    public void setExtra5(Date extra5) {
        this.extra5 = extra5;
    }

    /**
     * @return the extra6
     */
    public Date getExtra6() {
        return extra6;
    }

    /**
     * @param extra6 the extra6 to set
     */
    public void setExtra6(Date extra6) {
        this.extra6 = extra6;
    }

	public Float getDeudaExigible() {
		return deudaExigible;
	}

	public void setDeudaExigible(Float deudaExigible) {
		this.deudaExigible = deudaExigible;
	}

	public Float getEntregasACuenta() {
		return entregasACuenta;
	}

	public void setEntregasACuenta(Float entregasACuenta) {
		this.entregasACuenta = entregasACuenta;
	}

	public Float getInteresesEntregas() {
		return interesesEntregas;
	}

	public void setInteresesEntregas(Float interesesEntregas) {
		this.interesesEntregas = interesesEntregas;
	}

	public Float getCuotasVencidasImpagadas() {
		return cuotasVencidasImpagadas;
	}

	public void setCuotasVencidasImpagadas(Float cuotasVencidasImpagadas) {
		this.cuotasVencidasImpagadas = cuotasVencidasImpagadas;
	}

	public Float getPendienteDesembolso() {
		return pendienteDesembolso;
	}

	public void setPendienteDesembolso(Float pendienteDesembolso) {
		this.pendienteDesembolso = pendienteDesembolso;
	}

	public Float getExtraFloat() {
		return extraFloat;
	}

	public void setExtraFloat(Float extraFloat) {
		this.extraFloat = extraFloat;
	}

	public Integer getProvisionPorcentaje() {
		return provisionPorcentaje;
	}

	public void setProvisionPorcentaje(Integer provisionPorcentaje) {
		this.provisionPorcentaje = provisionPorcentaje;
	}

//	public String getScoring() {
//		return scoring;
//	}
//
//	public void setScoring(String scoring) {
//		this.scoring = scoring;
//	}

	public Date getFechaReciboDev() {
		return fechaReciboDev;
	}

	public void setFechaReciboDev(Date fechaReciboDev) {
		this.fechaReciboDev = fechaReciboDev;
	}

	public Float getTotalRecibosDev() {
		return totalRecibosDev;
	}

	public void setTotalRecibosDev(Float totalRecibosDev) {
		this.totalRecibosDev = totalRecibosDev;
	}

	public String getContratoAnterior() {
		return contratoAnterior;
	}

	public void setContratoAnterior(String contratoAnterior) {
		this.contratoAnterior = contratoAnterior;
	}

	public DDMotivoRenumeracion getMotivoRenumeracion() {
		return motivoRenumeracion;
	}

	public void setMotivoRenumeracion(DDMotivoRenumeracion motivoRenumeracion) {
		this.motivoRenumeracion = motivoRenumeracion;
	}

	public Float getImpuestos() {
		return impuestos;
	}

	public void setImpuestos(Float impuestos) {
		this.impuestos = impuestos;
	}

	public Date getFechaIniEpiIrregular() {
		return fechaIniEpiIrregular;
	}

	public void setFechaIniEpiIrregular(Date fechaIniEpiIrregular) {
		this.fechaIniEpiIrregular = fechaIniEpiIrregular;
	}

}
