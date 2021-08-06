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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionC4C;
import es.pfsgroup.plugin.rem.model.dd.DDFinalidadOperacion;
import es.pfsgroup.plugin.rem.model.dd.DDMedioPago;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDProcedenciaFondosPropios;
import es.pfsgroup.plugin.rem.model.dd.DDRiesgoOperacion;

@Entity
@Table(name = "OFR_OFERTAS_CAIXA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class OfertaCaixa implements Serializable, Auditable {

    private static final long serialVersionUID = -83911589408025818L;

    @Id
    @Column(name = "OFR_CAIXA_ID", updatable = false, nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "OfertaCaixaGenerator")
    @SequenceGenerator(name = "OfertaCaixaGenerator", sequenceName = "S_OFR_OFERTAS_CAIXA", allocationSize = 1)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;

    @Column(name = "OFR_NUM_OFERTA_CAIXA")
    private Long numOfertaCaixa;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ECC_ID")
	private DDEstadoComunicacionC4C estadoComunicacionC4C;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ROP_BC_ID")
	private DDRiesgoOperacion riesgoOperacion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MEP_ID")
	private DDMedioPago medioPago;
    
	@Column(name="OFR_OCULTA_IDENTIDAD_TITULAR")
	private Boolean ocultaIdentidadTitular;
    
	@Column(name="OFR_ACTITUD_INCOHERENTE")
	private Boolean actitudIncoherente;
    
	@Column(name="OFR_PAGO_INTERMEDIARIO")
	private Boolean pagoIntermediario;
    
	@Column(name="OFR_TITULOS_PORTADOR")
	private Boolean titulosPortador;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PAI_TRANSFERENCIA_ID")
	private DDPaises paisTransferencia;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_FOP_FINALIDAD_OPERACION")
	private DDFinalidadOperacion finalidadOperacion;
    
	@Column(name="OFR_OTRA_FINALIDAD_OPERACION")
	private String otraFinalidadOperacion;
    
	@Column(name="OFR_MOTIVO_COMPRA")
	private String motivoCompra;
    
	@Column(name="OFR_ORI_FONDOS_PROPIOS")
	private Double fondosPropios;
    
	@Column(name="OFR_FONDOS_BANCO")
	private Double fondosBanco;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PFP_PROC_FONDOS_PROPIOS")
	private DDProcedenciaFondosPropios procedenciaFondosPropios;
    
	@Column(name="OFR_OTRA_PROC_FONDOS_PROPIOS")
	private String otraProcedenciaFondosPropios;
    
	@Column(name="OFR_DETECCION_INDICIO")
	private Boolean deteccionIndicio;
    
	@Column(name="OFR_CHECK_SUBASTA")
	private Boolean checkSubasta;
	
    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Oferta getOferta() {
        return oferta;
    }

    public void setOferta(Oferta oferta) {
        this.oferta = oferta;
    }

    public Long getNumOfertaCaixa() {
        return numOfertaCaixa;
    }

    public void setNumOfertaCaixa(Long numOfertaCaixa) {
        this.numOfertaCaixa = numOfertaCaixa;
    }

    public Integer getVersion() {
        return version;
    }

    public void setVersion(Integer version) {
        this.version = version;
    }

    @Override
    public Auditoria getAuditoria() {
        return auditoria;
    }

    @Override
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

	public DDEstadoComunicacionC4C getEstadoComunicacionC4C() {
		return estadoComunicacionC4C;
	}

	public void setEstadoComunicacionC4C(DDEstadoComunicacionC4C estadoComunicacionC4C) {
		this.estadoComunicacionC4C = estadoComunicacionC4C;
	}

	public DDRiesgoOperacion getRiesgoOperacion() {
		return riesgoOperacion;
	}

	public void setRiesgoOperacion(DDRiesgoOperacion riesgoOperacion) {
		this.riesgoOperacion = riesgoOperacion;
	}

	public DDMedioPago getMedioPago() {
		return medioPago;
	}

	public void setMedioPago(DDMedioPago medioPago) {
		this.medioPago = medioPago;
	}

	public Boolean getOcultaIdentidadTitular() {
		return ocultaIdentidadTitular;
	}

	public void setOcultaIdentidadTitular(Boolean ocultaIdentidadTitular) {
		this.ocultaIdentidadTitular = ocultaIdentidadTitular;
	}

	public Boolean getActitudIncoherente() {
		return actitudIncoherente;
	}

	public void setActitudIncoherente(Boolean actitudIncoherente) {
		this.actitudIncoherente = actitudIncoherente;
	}

	public Boolean getPagoIntermediario() {
		return pagoIntermediario;
	}

	public void setPagoIntermediario(Boolean pagoIntermediario) {
		this.pagoIntermediario = pagoIntermediario;
	}

	public Boolean getTitulosPortador() {
		return titulosPortador;
	}

	public void setTitulosPortador(Boolean titulosPortador) {
		this.titulosPortador = titulosPortador;
	}

	public DDPaises getPaisTransferencia() {
		return paisTransferencia;
	}

	public void setPaisTransferencia(DDPaises paisTransferencia) {
		this.paisTransferencia = paisTransferencia;
	}

	public DDFinalidadOperacion getFinalidadOperacion() {
		return finalidadOperacion;
	}

	public void setFinalidadOperacion(DDFinalidadOperacion finalidadOperacion) {
		this.finalidadOperacion = finalidadOperacion;
	}

	public String getOtraFinalidadOperacion() {
		return otraFinalidadOperacion;
	}

	public void setOtraFinalidadOperacion(String otraFinalidadOperacion) {
		this.otraFinalidadOperacion = otraFinalidadOperacion;
	}

	public String getMotivoCompra() {
		return motivoCompra;
	}

	public void setMotivoCompra(String motivoCompra) {
		this.motivoCompra = motivoCompra;
	}

	public Double getFondosPropios() {
		return fondosPropios;
	}

	public void setFondosPropios(Double fondosPropios) {
		this.fondosPropios = fondosPropios;
	}

	public Double getFondosBanco() {
		return fondosBanco;
	}

	public void setFondosBanco(Double fondosBanco) {
		this.fondosBanco = fondosBanco;
	}

	public DDProcedenciaFondosPropios getProcedenciaFondosPropios() {
		return procedenciaFondosPropios;
	}

	public void setProcedenciaFondosPropios(DDProcedenciaFondosPropios procedenciaFondosPropios) {
		this.procedenciaFondosPropios = procedenciaFondosPropios;
	}

	public String getOtraProcedenciaFondosPropios() {
		return otraProcedenciaFondosPropios;
	}

	public void setOtraProcedenciaFondosPropios(String otraProcedenciaFondosPropios) {
		this.otraProcedenciaFondosPropios = otraProcedenciaFondosPropios;
	}

	public Boolean getDeteccionIndicio() {
		return deteccionIndicio;
	}

	public void setDeteccionIndicio(Boolean deteccionIndicio) {
		this.deteccionIndicio = deteccionIndicio;
	}

	public Boolean getCheckSubasta() {
		return checkSubasta;
	}

	public void setCheckSubasta(Boolean checkSubasta) {
		this.checkSubasta = checkSubasta;
	}



}
