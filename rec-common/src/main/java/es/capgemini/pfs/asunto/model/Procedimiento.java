package es.capgemini.pfs.asunto.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.recurso.model.Recurso;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Clase que representa la entidad procedimientos.
 *
 * @author jpbosnjak
 *
 */
@Entity
@org.hibernate.annotations.Entity(dynamicUpdate=true)
@Table(name = "PRC_PROCEDIMIENTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
//@Inheritance(strategy = InheritanceType.JOINED)
public class Procedimiento implements Serializable, Auditable, Comparable<Procedimiento> {

    private static final long serialVersionUID = -3745056486147306300L;

    @Id
    @Column(name = "PRC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ProcedimientoGenerator")
    @SequenceGenerator(name = "ProcedimientoGenerator", sequenceName = "S_PRC_PROCEDIMIENTOS")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PRC_PRC_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Procedimiento procedimientoPadre;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ASU_ID")
    private Asunto asunto;

    @OneToMany(mappedBy = "procedimiento", fetch = FetchType.LAZY)
    private List<ProcedimientoContratoExpediente> procedimientosContratosExpedientes;

    @Column(name = "PRC_PROCESS_BPM")
    private Long processBPM;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAC_ID")
    private DDTipoActuacion tipoActuacion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TRE_ID")
    private DDTipoReclamacion tipoReclamacion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPO_ID")
    private TipoProcedimiento tipoProcedimiento;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_JUZ_ID")
    private TipoJuzgado juzgado;

    @Column(name = "PRC_COD_PROC_EN_JUZGADO")
    private String codigoProcedimientoEnJuzgado;

    @Column(name = "PRC_PORCENTAJE_RECUPERACION")
    private Integer porcentajeRecuperacion;

    @Column(name = "PRC_PLAZO_RECUPERACION")
    private Integer plazoRecuperacion;

    @Column(name = "PRC_SALDO_ORIGINAL_VENCIDO")
    private BigDecimal saldoOriginalVencido;

    @Column(name = "PRC_SALDO_RECUPERACION")
    private BigDecimal saldoRecuperacion;

    @Column(name = "PRC_SALDO_ORIGINAL_NO_VENCIDO")
    private BigDecimal saldoOriginalNoVencido;

    @Column(name = "PRC_DOC_FECHA")
    private Date fechaRecopilacion;

    @Column(name = "PRC_DOC_OBSERVACIONES")
    private String observacionesRecopilacion;

    @OneToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "PRC_PER", joinColumns = @JoinColumn(name = "PRC_ID", referencedColumnName = "PRC_ID"), inverseJoinColumns = @JoinColumn(name = "PER_ID", referencedColumnName = "PER_ID"))
    private List<Persona> personasAfectadas;

    @OneToMany(mappedBy = "procedimiento", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "PRC_ID")
    private Set<TareaNotificacion> tareas;

    @OneToMany(mappedBy = "procedimiento", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "PRC_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Recurso> recursos;

    @Column(name = "PRC_DECIDIDO")
    private boolean decidido;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EPR_ID")
    private DDEstadoProcedimiento estadoProcedimiento;

    @OneToMany(mappedBy = "procedimiento", fetch = FetchType.LAZY)
    @JoinColumn(name = "PRC_ID")
    private List<ProcedimientoDerivado> procedimientoDerivado;
    
    @OneToMany(mappedBy = "procedimiento", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "PRC_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ProcedimientoBien> bienes;
    
    @OneToMany(mappedBy = "procedimiento", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "PRC_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Set<AdjuntoAsunto> adjuntos;
    
    @Transient
    private Boolean activo;


	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id
     *            the id to set
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
     * @param asunto
     *            the asunto to set
     */
    public void setAsunto(Asunto asunto) {
        this.asunto = asunto;
    }

    /**
     * @return the tipoActuacion
     */
    public DDTipoActuacion getTipoActuacion() {
        return tipoActuacion;
    }

    /**
     * @param tipoActuacion
     *            the tipoActuacion to set
     */
    public void setTipoActuacion(DDTipoActuacion tipoActuacion) {
        this.tipoActuacion = tipoActuacion;
    }

    /**
     * @return the tipoReclamacion
     */
    public DDTipoReclamacion getTipoReclamacion() {
        return tipoReclamacion;
    }

    /**
     * @param tipoReclamacion
     *            the tipoReclamacion to set
     */
    public void setTipoReclamacion(DDTipoReclamacion tipoReclamacion) {
        this.tipoReclamacion = tipoReclamacion;
    }

    /**
     * @return the tipoProcedimiento
     */
    public TipoProcedimiento getTipoProcedimiento() {
        return tipoProcedimiento;
    }

    /**
     * @param tipoProcedimiento
     *            the tipoProcedimiento to set
     */
    public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
        this.tipoProcedimiento = tipoProcedimiento;
    }

    /**
     * @return the porcentajeRecuperacion
     */
    public Integer getPorcentajeRecuperacion() {
        return porcentajeRecuperacion;
    }

    /**
     * @param porcentajeRecuperacion
     *            the porcentajeRecuperacion to set
     */
    public void setPorcentajeRecuperacion(Integer porcentajeRecuperacion) {
        this.porcentajeRecuperacion = porcentajeRecuperacion;
    }

    /**
     * @return the plazoRecuperacion
     */
    public Integer getPlazoRecuperacion() {
        return plazoRecuperacion;
    }

    /**
     * @param plazoRecuperacion
     *            the plazoRecuperacion to set
     */
    public void setPlazoRecuperacion(Integer plazoRecuperacion) {
        this.plazoRecuperacion = plazoRecuperacion;
    }

    /**
     * @return the saldoOriginalVencido
     */
    public BigDecimal getSaldoOriginalVencido() {
        return saldoOriginalVencido;
    }

    /**
     * @param saldoOriginalVencido
     *            the saldoOriginalVencido to set
     */
    public void setSaldoOriginalVencido(BigDecimal saldoOriginalVencido) {
        this.saldoOriginalVencido = saldoOriginalVencido;
    }

    /**
     * @return the saldoOriginalNoVencido
     */
    public BigDecimal getSaldoOriginalNoVencido() {
        return saldoOriginalNoVencido;
    }

    /**
     * @param saldoOriginalNoVencido
     *            the saldoOriginalNoVencido to set
     */
    public void setSaldoOriginalNoVencido(BigDecimal saldoOriginalNoVencido) {
        this.saldoOriginalNoVencido = saldoOriginalNoVencido;
    }

    /**
     * @return the saldoNoVencidoActual
     */
    public Double getSaldoNoVencidoActual() {
        Double result = 0.0;

        for (ExpedienteContrato ec : getExpedienteContratos()) {
        	if(ec.getContrato() != null && ec.getContrato().getLastMovimiento()!= null && ec.getContrato().getLastMovimiento().getPosVivaNoVencida() != null){
        		result += ec.getContrato().getLastMovimiento().getPosVivaNoVencida();
        	}
        }

        return result;
    }

    /**
     * @return the saldoVencidoActual
     */
    public Double getSaldoVencidoActual() {
        Double result = 0.0;

        for (ExpedienteContrato ec : getExpedienteContratos()) {
        	if(ec.getContrato() != null && ec.getContrato().getLastMovimiento()!= null && ec.getContrato().getLastMovimiento().getPosVivaVencida() != null){
        		result += ec.getContrato().getLastMovimiento().getPosVivaVencida();
        	}
        }

        return result;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria
     *            the auditoria to set
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
     * @param version
     *            the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the saldoRecuperacion
     */
    public BigDecimal getSaldoRecuperacion() {
        return saldoRecuperacion;
    }

    /**
     * @param saldoRecuperacion
     *            the saldoRecuperacion to set
     */
    public void setSaldoRecuperacion(BigDecimal saldoRecuperacion) {
        this.saldoRecuperacion = saldoRecuperacion;
    }

    /**
     * @return the fechaRecopilacion
     */
    public Date getFechaRecopilacion() {
        return fechaRecopilacion;
    }

    /**
     * @param fechaRecopilacion
     *            the fechaRecopilacion to set
     */
    public void setFechaRecopilacion(Date fechaRecopilacion) {
        this.fechaRecopilacion = fechaRecopilacion;
    }

    /**
     * @return the observacionesRecopilacion
     */
    public String getObservacionesRecopilacion() {
        return observacionesRecopilacion;
    }

    /**
     * @param observacionesRecopilacion
     *            the observacionesRecopilacion to set
     */
    public void setObservacionesRecopilacion(String observacionesRecopilacion) {
        this.observacionesRecopilacion = observacionesRecopilacion;
    }

    /**
     * @return the personasAfectadas
     */
    public List<Persona> getPersonasAfectadas() {
        return personasAfectadas;
    }

    /**
     * @param personasAfectadas
     *            the personasAfectadas to set
     */
    public void setPersonasAfectadas(List<Persona> personasAfectadas) {
        this.personasAfectadas = personasAfectadas;
    }

    /**
     * Suma al saldo original vencido el saldo original no vencido.
     *
     * @return BigDecimal
     */
    public BigDecimal getSaldoDeudorTotal() {
        if (saldoOriginalVencido == null) {
            saldoOriginalVencido = new BigDecimal(0L);
        }
        if (saldoOriginalNoVencido == null) {
            saldoOriginalNoVencido = new BigDecimal(0L);
        }
        return saldoOriginalVencido.add(saldoOriginalNoVencido);
    }

    /**
     * @return the expedienteContratos
     */
    public List<ExpedienteContrato> getExpedienteContratos() {

        List<ExpedienteContrato> list = new ArrayList<ExpedienteContrato>();
        for (ProcedimientoContratoExpediente pce : procedimientosContratosExpedientes) {
            list.add(pce.getExpedienteContrato());
        }

        return list;
    }

    /**
     * @param expedienteContratos the expedienteContratos to set
     */
    public void setExpedienteContratos(List<ExpedienteContrato> expedienteContratos) {
        if (expedienteContratos == null) {
            procedimientosContratosExpedientes = new ArrayList<ProcedimientoContratoExpediente>();
        } else {
            List<ProcedimientoContratoExpediente> list = new ArrayList<ProcedimientoContratoExpediente>();
            for (ExpedienteContrato ec : expedienteContratos) {
                ProcedimientoContratoExpediente pce = new ProcedimientoContratoExpediente();
                pce.setExpedienteContrato(ec);
                pce.setProcedimiento(this);
                list.add(pce);
            }
            procedimientosContratosExpedientes = list;
        }
    }

    /**
     * @return the processBPM
     */
    public Long getProcessBPM() {
        return processBPM;
    }

    /**
     * @param processBPM
     *            the processBPM to set
     */
    public void setProcessBPM(Long processBPM) {
        this.processBPM = processBPM;
    }

    /**
     * devuelve el nombre para los favoritos.
     *
     * @return nombre
     */
    public String getNombreProcedimiento() {
        return asunto.getNombre() + "-" + getTipoProcedimiento().getDescripcion();
    }

    /**
     * @return the juzgado
     */
    public TipoJuzgado getJuzgado() {
        return juzgado;
    }

    /**
     * @param juzgado
     *            the juzgado to set
     */
    public void setJuzgado(TipoJuzgado juzgado) {
        this.juzgado = juzgado;
    }

    /**
     * @return the codigoProcedimientoEnJuzgado
     */
    public String getCodigoProcedimientoEnJuzgado() {
        return codigoProcedimientoEnJuzgado;
    }

    /**
     * @param codigoProcedimientoEnJuzgado
     *            the codigoProcedimientoEnJuzgado to set
     */
    public void setCodigoProcedimientoEnJuzgado(String codigoProcedimientoEnJuzgado) {
        this.codigoProcedimientoEnJuzgado = codigoProcedimientoEnJuzgado;
    }

    /**
     * @return the decidido
     */
    public boolean getDecidido() {
        return decidido;
    }

    /**
     * @param decidido
     *            the decidido to set
     */
    public void setDecidido(boolean decidido) {
        this.decidido = decidido;
    }

    /**
     * @return the procedimientoPadre
     */
    public Procedimiento getProcedimientoPadre() {
        return procedimientoPadre;
    }

    /**
     * @param procedimientoPadre the procedimientoPadre to set
     */
    public void setProcedimientoPadre(Procedimiento procedimientoPadre) {
        this.procedimientoPadre = procedimientoPadre;
    }

    /**
     * @return the recursos
     */
    public List<Recurso> getRecursos() {
        return recursos;
    }

    /**
     * @param recursos the recursos to set
     */
    public void setRecursos(List<Recurso> recursos) {
        this.recursos = recursos;
    }

    /**
     * @return the estadoProcedimiento
     */
    public DDEstadoProcedimiento getEstadoProcedimiento() {
        return estadoProcedimiento;
    }

    /**
     * @param estadoProcedimiento the estadoProcedimiento to set
     */
    public void setEstadoProcedimiento(DDEstadoProcedimiento estadoProcedimiento) {
        this.estadoProcedimiento = estadoProcedimiento;
    }

    /**
     * método para registrar los saldos vencido y no vencido originales del
     * último movimiento del contrato.
     */
    public void registrarSaldosOriginales() {
        BigDecimal sonv = new BigDecimal(0);
        BigDecimal sov = new BigDecimal(0);
        for (Iterator<ExpedienteContrato> it = getExpedienteContratos().iterator(); it.hasNext();) {
            Movimiento mv = it.next().getContrato().getLastMovimiento();
            if (mv != null) {
                sonv.add(BigDecimal.valueOf(mv.getPosVivaNoVencida().floatValue()));
                sov.add(BigDecimal.valueOf(mv.getPosVivaVencida().floatValue()));
            }
        }
        saldoOriginalNoVencido = sonv;
        saldoOriginalVencido = sov;
    }

    /**
     * Devuelve si el procedimiento actual es un procedimiento válido contablemente (aceptado, cerrado o derivado)
     * @return
     */
    public Boolean isContable() {
        String codigoEstadoProcedimiento = estadoProcedimiento.getCodigo();
        return (!auditoria.isBorrado() && (DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO.equals(codigoEstadoProcedimiento)
                || DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(codigoEstadoProcedimiento) || DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO
                .equals(codigoEstadoProcedimiento)));
    }

    /**
     * Comprueba si el procedimiento NO se encuentra entre uno de los tres primeros estados (en conformación, confirmado o propuesto)
     * Es decir, comprueba que el asunto esté aceptado y con su BPM externo activo.
     * @return boolean
     */
    public boolean getEstaAceptado() {
        if (!getEstaEstadoPropuesto() && !getEstaEstadoConformacion() && !getEstaEstadoConfirmado()) { return true; }

        return false;

    }

    /**
     * Comprueba si el procedimiento se encuentra en estado confirmado.
     * @return boolean
     */
    public boolean getEstaEstadoConfirmado() {
        String codigoEstadoProcedimiento = estadoProcedimiento.getCodigo();
        if (DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO.equals(codigoEstadoProcedimiento)) { return true; }

        return false;
    }

    /**
     * Comprueba si el procedimiento se encuentra en estado propuesto.
     * @return boolean
     */
    public boolean getEstaEstadoPropuesto() {
        String codigoEstadoProcedimiento = estadoProcedimiento.getCodigo();
        if (DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_PROPUESTO.equals(codigoEstadoProcedimiento)) { return true; }

        return false;
    }

    /**
     * Comprueba si el procedimiento se encuentra en estado propuesto.
     * @return boolean
     */
    public boolean getEstaEstadoConformacion() {
        String codigoEstadoProcedimiento = estadoProcedimiento.getCodigo();
        if (DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION.equals(codigoEstadoProcedimiento)) { return true; }

        return false;
    }

    /**
     * @param tareas the tareas to set
     */
    public void setTareas(Set<TareaNotificacion> tareas) {
        this.tareas = tareas;
    }

    /**
     * @return the tareas
     */
    public Set<TareaNotificacion> getTareas() {
        return tareas;
    }

    /**
     * @return the procedimientosContratosExpedientes
     */
    public List<ProcedimientoContratoExpediente> getProcedimientosContratosExpedientes() {
        return procedimientosContratosExpedientes;
    }

    /**
     * @param procedimientosContratosExpedientes the procedimientosContratosExpedientes to set
     */
    public void setProcedimientosContratosExpedientes(List<ProcedimientoContratoExpediente> procedimientosContratosExpedientes) {
        this.procedimientosContratosExpedientes = procedimientosContratosExpedientes;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int compareTo(Procedimiento o) {
        return this.id.compareTo(o.getId());
    }

    /**
     * @param procedimientoDerivado the procedimientoDerivado to set
     */
    public void setProcedimientoDerivado(List<ProcedimientoDerivado> procedimientoDerivado) {
        this.procedimientoDerivado = procedimientoDerivado;
    }

    /**
     * @return the procedimientoDerivado
     */
    public List<ProcedimientoDerivado> getProcedimientoDerivado() {
        return procedimientoDerivado;
    }

    /**
     * Comprueba si es un procedimiento derivado si está o no aceptado
     * @return
     */
    public Boolean getDerivacionAceptada() {
        if (procedimientoDerivado == null || procedimientoDerivado.size() == 0) return true;

        ProcedimientoDerivado pd = procedimientoDerivado.get(0);
        if (pd == null) return true;

        if (pd.getDecisionProcedimiento() == null) return false;
        if (pd.getDecisionProcedimiento().getEstadoDecision() == null) return false;

        return DDEstadoDecision.ESTADO_ACEPTADO.equals(pd.getDecisionProcedimiento().getEstadoDecision().getCodigo());
    }

	public List<ProcedimientoBien> getBienes() {
		return bienes;
	}

	public void setBienes(List<ProcedimientoBien> bienes) {
		this.bienes = bienes;
	}

	public Set<AdjuntoAsunto> getAdjuntos() {
		return adjuntos;
	}

	public void setAdjuntos(Set<AdjuntoAsunto> adjuntos) {
		this.adjuntos = adjuntos;
	}

	public Boolean getActivo() {
		return activo;
	}

	public void setActivo(Boolean activo) {
		this.activo = activo;
	}
	

}