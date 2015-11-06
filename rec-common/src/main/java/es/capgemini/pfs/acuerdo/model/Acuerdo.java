package es.capgemini.pfs.acuerdo.model;

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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.acuerdo.model.DDMotivoRechazoAcuerdo;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase que representa a un Acuerdo de un Asunto.
 * @author pamuller
 *
 */
@Entity
@Table(name = "ACU_ACUERDO_PROCEDIMIENTOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Acuerdo implements Serializable, Auditable {

    private static final long serialVersionUID = 0L;

    @Id
    @Column(name = "ACU_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AcuerdoGenerator")
    @SequenceGenerator(name = "AcuerdoGenerator", sequenceName = "S_ACU_ACUERDO_PROCEDIMIENTOS")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "ASU_ID")
    private Asunto asunto;

    @ManyToOne
    @JoinColumn(name = "DD_TPA_ID")
    private DDTipoAcuerdo tipoAcuerdo;

    @ManyToOne
    @JoinColumn(name = "DD_SOL_ID")
    private DDSolicitante solicitante;

    @ManyToOne
    @JoinColumn(name = "DD_EAC_ID")
    private DDEstadoAcuerdo estadoAcuerdo;

    @Column(name = "ACU_OBSERVACIONES")
    private String observaciones;

    @Column(name = "ACU_FECHA_PROPUESTA")
    private Date fechaPropuesta;

    @Column(name = "ACU_FECHA_ESTADO")
    private Date fechaEstado;

    @ManyToOne
    @JoinColumn(name = "DD_ATP_ID")
    private DDTipoPagoAcuerdo tipoPagoAcuerdo;

    @Column(name = "ACU_IMPORTE_PAGO")
    private Double importePago;

    @ManyToOne
    @JoinColumn(name = "DD_APE_ID")
    private DDPeriodicidadAcuerdo periodicidadAcuerdo;

    @Column(name = "ACU_PERIODO")
    private Long periodo;

    @OneToOne(mappedBy = "acuerdo")
    private AnalisisAcuerdo analisisAcuerdo;

    @OneToMany(mappedBy = "acuerdo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "acu_id")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActuacionesRealizadasAcuerdo> actuacionesRealizadas;

    @OneToMany(mappedBy = "acuerdo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "acu_id")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActuacionesAExplorarAcuerdo> actuacionesAExplorar;

    @Column(name = "ACU_FECHA_CIERRE")
    private Date fechaCierre;

    @Column(name = "ACU_IDJBPM")
    private Long idJBPM;
    
    @ManyToOne
    @JoinColumn(name = "EXP_ID")
    private Expediente expediente;
    
    @ManyToOne
    @JoinColumn(name = "RCF_STP_ID")
    private RecobroDDSubtipoPalanca subTipoPalanca;
    
    @ManyToOne
    @JoinColumn(name = "RCF_TPP_ID")
    private RecobroDDTipoPalanca tipoPalanca;

    @OneToMany(mappedBy = "acuerdo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "acu_id")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<AcuerdoContrato> contratos;
    
    @Column(name = "ACU_FECHA_RESOL_PROP")
    private Date fechaResolucionPropuesta;
    
    @Column(name = "ACU_PORC_QUITA")
    private Integer porcentajeQuita;
    
    @Transient
    private String contratosString;
    
    @ManyToOne
    @JoinColumn(name = "DES_ID")
    private DespachoExterno despacho;
    
    @Column(name = "ACU_DEUDA_TOTAL")
    private Double deudaTotal;

    @Column(name="ACU_MOTIVO")
	private String motivo;
	
	@Column(name = "ACU_FECHA_LIMITE")
	private Date fechaLimite;	
	
	@Column(name = "ACU_IMPORTE_COSTAS")
	private Long importeCostas;	
	
    @ManyToOne
    @JoinColumn(name = "ACU_USER_PROPONENTE")
	private Usuario proponente;
    
    @ManyToOne
    @JoinColumn(name = "USD_ID")
	private GestorDespacho gestorDespacho;

    @ManyToOne
    @JoinColumn(name = "DD_MTR_ID")
    private DDMotivoRechazoAcuerdo motivoRechazo;

    @Column(name = "SYS_GUID")
	private String guid;
    
    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;
    

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
     * @return the tipoAcuerdo
     */
    public DDTipoAcuerdo getTipoAcuerdo() {
        return tipoAcuerdo;
    }

    /**
     * @param tipoAcuerdo the tipoAcuerdo to set
     */
    public void setTipoAcuerdo(DDTipoAcuerdo tipoAcuerdo) {
        this.tipoAcuerdo = tipoAcuerdo;
    }

    /**
     * @return the solicitante
     */
    public DDSolicitante getSolicitante() {
        return solicitante;
    }

    /**
     * @param solicitante the solicitante to set
     */
    public void setSolicitante(DDSolicitante solicitante) {
        this.solicitante = solicitante;
    }

    /**
     * @return the estado
     */
    public DDEstadoAcuerdo getEstadoAcuerdo() {
        return estadoAcuerdo;
    }

    /**
     * @param estadoAcuerdo the estado to set
     */
    public void setEstadoAcuerdo(DDEstadoAcuerdo estadoAcuerdo) {
        this.estadoAcuerdo = estadoAcuerdo;
    }

    /**
     * @return the observaciones
     */
    public String getObservaciones() {
        return observaciones;
    }

    /**
     * @param observaciones the observaciones to set
     */
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    /**
     * @return the fechaPropuesta
     */
    public Date getFechaPropuesta() {
        return fechaPropuesta;
    }

    /**
     * @param fechaPropuesta the fechaPropuesta to set
     */
    public void setFechaPropuesta(Date fechaPropuesta) {
        this.fechaPropuesta = fechaPropuesta;
    }

    /**
     * @return the fechaEstado
     */
    public Date getFechaEstado() {
        return fechaEstado;
    }

    /**
     * @param fechaEstado the fechaEstado to set
     */
    public void setFechaEstado(Date fechaEstado) {
        this.fechaEstado = fechaEstado;
    }

    /**
     * @return the tipoPagoAcuerdo
     */
    public DDTipoPagoAcuerdo getTipoPagoAcuerdo() {
        return tipoPagoAcuerdo;
    }

    /**
     * @param tipoPagoAcuerdo the tipoPagoAcuerdo to set
     */
    public void setTipoPagoAcuerdo(DDTipoPagoAcuerdo tipoPagoAcuerdo) {
        this.tipoPagoAcuerdo = tipoPagoAcuerdo;
    }

    /**
     * @return the importePago
     */
    public Double getImportePago() {
        return importePago;
    }

    /**
     * @param importePago the importePago to set
     */
    public void setImportePago(Double importePago) {
        this.importePago = importePago;
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
     * @return the analisisAcuerdo
     */
    public AnalisisAcuerdo getAnalisisAcuerdo() {
        return analisisAcuerdo;
    }

    /**
     * @param analisisAcuerdo the analisisAcuerdo to set
     */
    public void setAnalisisAcuerdo(AnalisisAcuerdo analisisAcuerdo) {
        this.analisisAcuerdo = analisisAcuerdo;
    }

    /**
     * @return the actuacionesRealizadas
     */
    public List<ActuacionesRealizadasAcuerdo> getActuacionesRealizadas() {
        return actuacionesRealizadas;
    }

    /**
     * @param actuacionesRealizadas the actuacionesRealizadas to set
     */
    public void setActuacionesRealizadas(List<ActuacionesRealizadasAcuerdo> actuacionesRealizadas) {
        this.actuacionesRealizadas = actuacionesRealizadas;
    }

    /**
     * @return the periodicidadAcuerdo
     */
    public DDPeriodicidadAcuerdo getPeriodicidadAcuerdo() {
        return periodicidadAcuerdo;
    }

    /**
     * @param periodicidadAcuerdo the periodicidadAcuerdo to set
     */
    public void setPeriodicidadAcuerdo(DDPeriodicidadAcuerdo periodicidadAcuerdo) {
        this.periodicidadAcuerdo = periodicidadAcuerdo;
    }

    /**
     * @return the periodo
     */
    public Long getPeriodo() {
        return periodo;
    }

    /**
     * @param periodo the periodo to set
     */
    public void setPeriodo(Long periodo) {
        this.periodo = periodo;
    }

    /**
     * @return the actuacionesAExplorar
     */
    public List<ActuacionesAExplorarAcuerdo> getActuacionesAExplorar() {
        return actuacionesAExplorar;
    }

    /**
     * @param actuacionesAExplorar the actuacionesAExplorar to set
     */
    public void setActuacionesAExplorar(List<ActuacionesAExplorarAcuerdo> actuacionesAExplorar) {
        this.actuacionesAExplorar = actuacionesAExplorar;
    }

    /**
     * @return the idJBPM
     */
    public Long getIdJBPM() {
        return idJBPM;
    }

    /**
     * @param idJBPM the idJBPM to set
     */
    public void setIdJBPM(Long idJBPM) {
        this.idJBPM = idJBPM;
    }

    /**
     * Indica si el acuerdo está en estado vigente.
     * @return true si está en estado vigente
     */
    public boolean getEstaVigente() {
        return DDEstadoAcuerdo.ACUERDO_VIGENTE.equals(estadoAcuerdo.getCodigo());
    }

    /**
     * @return the fechaCierre
     */
    public Date getFechaCierre() {
        return fechaCierre;
    }

    /**
     * @param fechaCierre the fechaCierre to set
     */
    public void setFechaCierre(Date fechaCierre) {
        this.fechaCierre = fechaCierre;
    }

	public Expediente getExpediente() {
		return expediente;
	}

	public void setExpediente(Expediente expediente) {
		this.expediente = expediente;
	}

	public RecobroDDSubtipoPalanca getSubTipoPalanca() {
		return subTipoPalanca;
	}

	public void setSubTipoPalanca(RecobroDDSubtipoPalanca subTipoPalanca) {
		this.subTipoPalanca = subTipoPalanca;
	}

	public Date getFechaResolucionPropuesta() {
		return fechaResolucionPropuesta;
	}

	public void setFechaResolucionPropuesta(Date fechaResolucionPropuesta) {
		this.fechaResolucionPropuesta = fechaResolucionPropuesta;
	}

	public Integer getPorcentajeQuita() {
		return porcentajeQuita;
	}

	public void setPorcentajeQuita(Integer porcentajeQuita) {
		this.porcentajeQuita = porcentajeQuita;
	}
	
	public RecobroDDTipoPalanca getTipoPalanca() {
			return tipoPalanca;
	}

	public void setTipoPalanca(RecobroDDTipoPalanca tipoPalanca) {
		this.tipoPalanca = tipoPalanca;
	}

	public List<AcuerdoContrato> getContratos() {
		return contratos;
	}

	public void setContratos(List<AcuerdoContrato> contratos) {
		this.contratos = contratos;
	}

	public String getContratosString() {
		String contratos ="";
		for (AcuerdoContrato ac : this.getContratos()){
			if ("".equals(contratos)){
				contratos=contratos+ac.getContrato().getCodigoContrato();
			} else {
				contratos = contratos +", "+ ac.getContrato().getCodigoContrato();
			}
		}
		return contratos;
	}

	public DespachoExterno getDespacho() {
		return despacho;
	}

	public void setDespacho(DespachoExterno despacho) {
		this.despacho = despacho;
	}

	public Double getDeudaTotal() {
		return deudaTotal;
	}

	public void setDeudaTotal(Double deudaTotal) {
		this.deudaTotal = deudaTotal;
	}
	

	public GestorDespacho getGestorDespacho() {
		return gestorDespacho;
	}

	public void setGestorDespacho(GestorDespacho gestorDespacho) {
		this.gestorDespacho = gestorDespacho;
	}

    public DDMotivoRechazoAcuerdo getMotivoRechazo() {
        return motivoRechazo;
    }

    public void setMotivoRechazo(DDMotivoRechazoAcuerdo motivoRechazo) {
        this.motivoRechazo = motivoRechazo;
    }

	public Usuario getProponente() {
		return proponente;
	}

	public void setProponente(Usuario proponente) {
		this.proponente = proponente;
	}

	public Long getImporteCostas() {
		return importeCostas;
	}

	public void setImporteCostas(Long importeCostas) {
		this.importeCostas = importeCostas;
	}
	
	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public Date getFechaLimite() {
		return fechaLimite;
	}

	public void setFechaLimite(Date fechaLimite) {
		this.fechaLimite = fechaLimite;
	}

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}
	
    
}
