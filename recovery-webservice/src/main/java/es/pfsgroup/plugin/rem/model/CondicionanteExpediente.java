package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoFinanciacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;


/**
 * Modelo que gestiona la informacion de condicionantes de un expediente comercial
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "COE_CONDICIONANTES_EXPEDIENTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class CondicionanteExpediente implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "COE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CondicionantesExpedienteGenerator")
    @SequenceGenerator(name = "CondicionantesExpedienteGenerator", sequenceName = "S_COE_CONDICIONANTES_EXP")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;
	
	@Column(name="COE_SOLICITA_FINANCIACION")
	private Integer solicitaFinanciacion;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ESF_ID")
	private DDEstadoFinanciacion estadoFinanciacion;
		
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TCC_ID")
	private DDTipoCalculo tipoCalculoReserva;
    
    @Column(name="COE_PORCENTAJE_RESERVA")
    private Double porcentajeReserva;
    
    @Column(name="COE_IMPORTE_RESERVA")
    private Double importeReserva;

    @Column(name="COE_PLAZO_FIRMA_RESERVA")
    private Integer plazoFirmaReserva;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TIT_ID")
	private DDTiposImpuesto tipoImpuesto;
    
    @Column(name="COE_TIPO_APLICABLE")
    private Double tipoAplicable;

    @Column(name="COE_RENUNCIA_EXENCION")
    private Integer renunciaExencion;

    @Column(name="COE_RESERVA_CON_IMPUESTO")
    private Integer reservaConImpuesto;

    @Column(name="COE_GASTOS_PLUSVALIA")
    private Double gastosPlusvalia;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_PLUSVALIA")
	private DDTiposPorCuenta tipoPorCuentaPlusvalia;
    
    @Column(name="COE_GASTOS_NOTARIA")
    private Double gastosNotaria;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_NOTARIA")
	private DDTiposPorCuenta tipoPorCuentaNotaria;
    
    @Column(name="COE_GASTOS_OTROS")
    private Double gastosOtros;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_GASTOS_OTROS")
	private DDTiposPorCuenta tipoPorCuentaGastosOtros;
    
    @Column(name="COE_CARGAS_IMPUESTOS")
    private Double cargasImpuestos;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_IMPUESTOS")
	private DDTiposPorCuenta tipoPorCuentaImpuestos;
    
    @Column(name="COE_CARGAS_COMUNIDAD")
    private Double cargasComunidad;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_COMUNIDAD")
	private DDTiposPorCuenta tipoPorCuentaComunidad;
    
    @Column(name="COE_CARGAS_OTROS")
    private Double cargasOtros;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_CARGAS_OTROS")
	private DDTiposPorCuenta tipoPorCuentaCargasOtros;
    
    @Column(name="COE_SUJETO_TANTEO_RETRACTO")
    private Integer sujetoTanteoRetracto;
    
    @Column(name="COE_RENUNCIA_SNMTO_EVICCION")
    private Integer renunciaSaneamientoEviccion;
    
    @Column(name="COE_RENUNCIA_SNMTO_VICIOS")
    private Integer renunciaSaneamientoVicios;
    
    @Column(name="COE_VPO")
    private Integer vpo;
    
    @Column(name="COE_LICENCIA")
    private Integer licencia;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_LICENCIA")
	private DDTiposPorCuenta tipoPorCuentaLicencia;
    
    @Column(name="COE_PROCEDE_DESCALIFICACION")
    private Integer procedeDescalificacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_DESCALIFICACION")
	private DDTiposPorCuenta tipoPorCuentaDescalificacion;
    
    
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

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	public Integer getSolicitaFinanciacion() {
		return solicitaFinanciacion;
	}

	public void setSolicitaFinanciacion(Integer solicitaFinanciacion) {
		this.solicitaFinanciacion = solicitaFinanciacion;
	}

	public DDTipoCalculo getTipoCalculoReserva() {
		return tipoCalculoReserva;
	}

	public void setTipoCalculoReserva(DDTipoCalculo tipoCalculoReserva) {
		this.tipoCalculoReserva = tipoCalculoReserva;
	}

	public Double getImporteReserva() {
		return importeReserva;
	}

	public void setImporteReserva(Double importeReserva) {
		this.importeReserva = importeReserva;
	}

	public Double getPorcentajeReserva() {
		return porcentajeReserva;
	}

	public void setPorcentajeReserva(Double porcentajeReserva) {
		this.porcentajeReserva = porcentajeReserva;
	}

	public Integer getPlazoFirmaReserva() {
		return plazoFirmaReserva;
	}

	public void setPlazoFirmaReserva(Integer plazoFirmaReserva) {
		this.plazoFirmaReserva = plazoFirmaReserva;
	}

	public DDTiposImpuesto getTipoImpuesto() {
		return tipoImpuesto;
	}

	public void setTipoImpuesto(DDTiposImpuesto tipoImpuesto) {
		this.tipoImpuesto = tipoImpuesto;
	}

	public Double getTipoAplicable() {
		return tipoAplicable;
	}

	public void setTipoAplicable(Double tipoAplicable) {
		this.tipoAplicable = tipoAplicable;
	}

	public Integer getRenunciaExencion() {
		return renunciaExencion;
	}

	public void setRenunciaExencion(Integer renunciaExencion) {
		this.renunciaExencion = renunciaExencion;
	}

	public Integer getReservaConImpuesto() {
		return reservaConImpuesto;
	}

	public void setReservaConImpuesto(Integer reservaConImpuesto) {
		this.reservaConImpuesto = reservaConImpuesto;
	}

	public Double getGastosPlusvalia() {
		return gastosPlusvalia;
	}

	public void setGastosPlusvalia(Double gastosPlusvalia) {
		this.gastosPlusvalia = gastosPlusvalia;
	}

	public DDTiposPorCuenta getTipoPorCuentaPlusvalia() {
		return tipoPorCuentaPlusvalia;
	}

	public void setTipoPorCuentaPlusvalia(DDTiposPorCuenta tipoPorCuentaPlusvalia) {
		this.tipoPorCuentaPlusvalia = tipoPorCuentaPlusvalia;
	}

	public Double getGastosNotaria() {
		return gastosNotaria;
	}

	public void setGastosNotaria(Double gastosNotaria) {
		this.gastosNotaria = gastosNotaria;
	}

	public DDTiposPorCuenta getTipoPorCuentaNotaria() {
		return tipoPorCuentaNotaria;
	}

	public void setTipoPorCuentaNotaria(DDTiposPorCuenta tipoPorCuentaNotaria) {
		this.tipoPorCuentaNotaria = tipoPorCuentaNotaria;
	}

	public Double getGastosOtros() {
		return gastosOtros;
	}

	public void setGastosOtros(Double gastosOtros) {
		this.gastosOtros = gastosOtros;
	}

	public DDTiposPorCuenta getTipoPorCuentaGastosOtros() {
		return tipoPorCuentaGastosOtros;
	}

	public void setTipoPorCuentaGastosOtros(
			DDTiposPorCuenta tipoPorCuentaGastosOtros) {
		this.tipoPorCuentaGastosOtros = tipoPorCuentaGastosOtros;
	}

	public Double getCargasImpuestos() {
		return cargasImpuestos;
	}

	public void setCargasImpuestos(Double cargasImpuestos) {
		this.cargasImpuestos = cargasImpuestos;
	}

	public DDTiposPorCuenta getTipoPorCuentaImpuestos() {
		return tipoPorCuentaImpuestos;
	}

	public void setTipoPorCuentaImpuestos(DDTiposPorCuenta tipoPorCuentaImpuestos) {
		this.tipoPorCuentaImpuestos = tipoPorCuentaImpuestos;
	}

	public Double getCargasComunidad() {
		return cargasComunidad;
	}

	public void setCargasComunidad(Double cargasComunidad) {
		this.cargasComunidad = cargasComunidad;
	}

	public DDTiposPorCuenta getTipoPorCuentaComunidad() {
		return tipoPorCuentaComunidad;
	}

	public void setTipoPorCuentaComunidad(DDTiposPorCuenta tipoPorCuentaComunidad) {
		this.tipoPorCuentaComunidad = tipoPorCuentaComunidad;
	}

	public Double getCargasOtros() {
		return cargasOtros;
	}

	public void setCargasOtros(Double cargasOtros) {
		this.cargasOtros = cargasOtros;
	}

	public DDTiposPorCuenta getTipoPorCuentaCargasOtros() {
		return tipoPorCuentaCargasOtros;
	}

	public void setTipoPorCuentaCargasOtros(
			DDTiposPorCuenta tipoPorCuentaCargasOtros) {
		this.tipoPorCuentaCargasOtros = tipoPorCuentaCargasOtros;
	}

	public Integer getSujetoTanteoRetracto() {
		return sujetoTanteoRetracto;
	}

	public void setSujetoTanteoRetracto(Integer sujetoTanteoRetracto) {
		this.sujetoTanteoRetracto = sujetoTanteoRetracto;
	}

	public Integer getRenunciaSaneamientoEviccion() {
		return renunciaSaneamientoEviccion;
	}

	public void setRenunciaSaneamientoEviccion(Integer renunciaSaneamientoEviccion) {
		this.renunciaSaneamientoEviccion = renunciaSaneamientoEviccion;
	}

	public Integer getRenunciaSaneamientoVicios() {
		return renunciaSaneamientoVicios;
	}

	public void setRenunciaSaneamientoVicios(Integer renunciaSaneamientoVicios) {
		this.renunciaSaneamientoVicios = renunciaSaneamientoVicios;
	}

	public Integer getVpo() {
		return vpo;
	}

	public void setVpo(Integer vpo) {
		this.vpo = vpo;
	}

	public Integer getLicencia() {
		return licencia;
	}

	public void setLicencia(Integer licencia) {
		this.licencia = licencia;
	}

	public DDTiposPorCuenta getTipoPorCuentaLicencia() {
		return tipoPorCuentaLicencia;
	}

	public void setTipoPorCuentaLicencia(DDTiposPorCuenta tipoPorCuentaLicencia) {
		this.tipoPorCuentaLicencia = tipoPorCuentaLicencia;
	}

	public Integer getProcedeDescalificacion() {
		return procedeDescalificacion;
	}

	public void setProcedeDescalificacion(Integer procedeDescalificacion) {
		this.procedeDescalificacion = procedeDescalificacion;
	}

	public DDTiposPorCuenta getTipoPorCuentaDescalificacion() {
		return tipoPorCuentaDescalificacion;
	}

	public void setTipoPorCuentaDescalificacion(
			DDTiposPorCuenta tipoPorCuentaDescalificacion) {
		this.tipoPorCuentaDescalificacion = tipoPorCuentaDescalificacion;
	}

	public DDEstadoFinanciacion getEstadoFinanciacion() {
		return estadoFinanciacion;
	}

	public void setEstadoFinanciacion(DDEstadoFinanciacion estadoFinanciacion) {
		this.estadoFinanciacion = estadoFinanciacion;
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
