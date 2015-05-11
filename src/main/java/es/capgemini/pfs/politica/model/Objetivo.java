package es.capgemini.pfs.politica.model;

import java.io.Serializable;
import java.util.Date;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Clase que representa un objetivo de una política.
 * @author Andrés Esteban
*/
@Entity
@Table(name = "OBJ_OBJETIVO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Objetivo implements Auditable, Serializable {

    private static final long serialVersionUID = 949975113689764152L;

    @Id
    @Column(name = "OBJ_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ObjetivoGenerator")
    @SequenceGenerator(name = "ObjetivoGenerator", sequenceName = "S_OBJ_OBJETIVO")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "POL_ID")
    private Politica politica;

    @ManyToOne
    @JoinColumn(name = "OBJ_PADRE_ID")
    private Objetivo objetivoPadre;

    @ManyToOne
    @JoinColumn(name = "TOB_ID")
    private DDTipoObjetivo tipoObjetivo;

    @ManyToOne
    @JoinColumn(name = "DD_ESO_ID")
    private DDEstadoObjetivo estadoObjetivo;

    @ManyToOne
    @JoinColumn(name = "DD_ESC_ID")
    private DDEstadoCumplimiento estadoCumplimiento;

    @ManyToOne
    @JoinColumn(name = "DD_TOP_ID")
    private DDTipoOperador tipoOperador;

    @ManyToOne
    @JoinColumn(name = "CNT_ID")
    private Contrato contrato;

    @Column(name = "OBJ_OBSERVACION")
    private String observacion;

    @Column(name = "OBJ_RESUMEN")
    private String resumen;

    @Column(name = "OBJ_PROP_CUMPLE")
    private String propuestaCumplimiento;

    @Column(name = "OBJ_RTA_PROP_CUMPLE")
    private String respuestaPropuestaCumplimiento;

    @Column(name = "OBJ_JUSTIFICACION")
    private String justificacion;

    @Column(name = "OBJ_FECHA_LIMITE")
    private Date fechaLimite;

    @Column(name = "OBJ_FECHA_VIGENCIA")
    private Date fechaVigencia;

    @Column(name = "OBJ_VALOR")
    private Float valor;

    @Column(name = "OBJ_PROCESS_BPM")
    private Long processBpm;

    @Column(name = "OBJ_ESTADO_ANTERIOR")
    private Boolean definidoEstadoAnterior;

    @OneToMany(mappedBy = "objetivo")
    @JoinColumn(name = "OBJ_ID")
    private Set<TareaNotificacion> tareas;

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
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the objetivoPadre
     */
    public Objetivo getObjetivoPadre() {
        return objetivoPadre;
    }

    /**
     * @param objetivoPadre the objetivoPadre to set
     */
    public void setObjetivoPadre(Objetivo objetivoPadre) {
        this.objetivoPadre = objetivoPadre;
    }

    /**
     * @return the tipoObjetivo
     */
    public DDTipoObjetivo getTipoObjetivo() {
        return tipoObjetivo;
    }

    /**
     * @param tipoObjetivo the tipoObjetivo to set
     */
    public void setTipoObjetivo(DDTipoObjetivo tipoObjetivo) {
        this.tipoObjetivo = tipoObjetivo;
    }

    /**
     * @return the estadoObjetivo
     */
    public DDEstadoObjetivo getEstadoObjetivo() {
        return estadoObjetivo;
    }

    /**
     * @param estadoObjetivo the estadoObjetivo to set
     */
    public void setEstadoObjetivo(DDEstadoObjetivo estadoObjetivo) {
        this.estadoObjetivo = estadoObjetivo;
    }

    /**
     * @return the estadoCumplimiento
     */
    public DDEstadoCumplimiento getEstadoCumplimiento() {
        return estadoCumplimiento;
    }

    /**
     * @param estadoCumplimiento the estadoCumplimiento to set
     */
    public void setEstadoCumplimiento(DDEstadoCumplimiento estadoCumplimiento) {
        this.estadoCumplimiento = estadoCumplimiento;
    }

    /**
     * @return the tipoOperador
     */
    public DDTipoOperador getTipoOperador() {
        return tipoOperador;
    }

    /**
     * @param tipoOperador the tipoOperador to set
     */
    public void setTipoOperador(DDTipoOperador tipoOperador) {
        this.tipoOperador = tipoOperador;
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
     * @return the observacion
     */
    public String getObservacion() {
        return observacion;
    }

    /**
     * @return the resumen
     */
    public String getResumen() {
        return resumen;
    }

    /**
     * @param resumen the resumen to set
     */
    public void setResumen(String resumen) {
        this.resumen = resumen;
    }

    /**
     * @param observacion the observacion to set
     */
    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    /**
     * @return the justificacion
     */
    public String getJustificacion() {
        return justificacion;
    }

    /**
     * @param justificacion the justificacion to set
     */
    public void setJustificacion(String justificacion) {
        this.justificacion = justificacion;
    }

    /**
     * @return the fechaLimite
     */
    public Date getFechaLimite() {
        return fechaLimite;
    }

    /**
     * @param fechaLimite the fechaLimite to set
     */
    public void setFechaLimite(Date fechaLimite) {
        this.fechaLimite = fechaLimite;
    }

    /**
     * @return the fechaVigencia
     */
    public Date getFechaVigencia() {
        return fechaVigencia;
    }

    /**
     * @param fechaVigencia the fechaVigencia to set
     */
    public void setFechaVigencia(Date fechaVigencia) {
        this.fechaVigencia = fechaVigencia;
    }

    /**
     * @return the valor
     */
    public Float getValor() {
        return valor;
    }

    /**
     * @param valor the valor to set
     */
    public void setValor(Float valor) {
        this.valor = valor;
    }

    /**
     * @return the processBpm
     */
    public Long getProcessBpm() {
        return processBpm;
    }

    /**
     * @param processBpm the processBpm to set
     */
    public void setProcessBpm(Long processBpm) {
        this.processBpm = processBpm;
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
     * @return boolean
     */
    public boolean getEstaPendiente() {
        return estadoCumplimiento.getCodigo().equals(DDEstadoCumplimiento.ESTADO_PENDIENTE);
    }

    /**
     * @return boolean
     */
    public boolean getEstaPropuesto() {
        return estadoObjetivo.getCodigo().equals(DDEstadoObjetivo.ESTADO_PROPUESTO);
    }

    /**
     * @return boolean
     */
    public boolean getEstaConfirmado() {
        return estadoObjetivo.getCodigo().equals(DDEstadoObjetivo.ESTADO_CONFIRMADO);
    }

    /**
     * @param politica the politica to set
     */
    public void setPolitica(Politica politica) {
        this.politica = politica;
    }

    /**
     * @return the politica
     */
    public Politica getPolitica() {
        return politica;
    }

    /**
     * Indica si el objetivo está incumplido.
     * @return true si está incumplido
     */
    public boolean getEstaIncumplido() {
        return DDEstadoCumplimiento.ESTADO_INCUMPLIDO.equals(estadoCumplimiento.getCodigo());
    }

    /**
     * Crea una copia exacta del objetivo sin asociarlo a la politica.
     * @return un objetivo igual al que se tenía.
     */
    @Override
    public Objetivo clone() {
        Objetivo nuevoObjetivo = new Objetivo();
        nuevoObjetivo.setContrato(this.getContrato());
        nuevoObjetivo.setEstadoCumplimiento(this.getEstadoCumplimiento());
        nuevoObjetivo.setEstadoObjetivo(this.getEstadoObjetivo());
        nuevoObjetivo.setFechaLimite(this.getFechaLimite());
        nuevoObjetivo.setFechaVigencia(this.getFechaVigencia());
        nuevoObjetivo.setJustificacion(this.getJustificacion());
        nuevoObjetivo.setObjetivoPadre(this.getObjetivoPadre());
        nuevoObjetivo.setObservacion(this.getObservacion());
        nuevoObjetivo.setResumen(this.getResumen());
        nuevoObjetivo.setTipoObjetivo(this.getTipoObjetivo());
        nuevoObjetivo.setTipoOperador(this.getTipoOperador());
        nuevoObjetivo.setValor(this.getValor());
        nuevoObjetivo.setPropuestaCumplimiento(this.propuestaCumplimiento);
        nuevoObjetivo.setRespuestaPropuestaCumplimiento(this.respuestaPropuestaCumplimiento);
        return nuevoObjetivo;

    }

    /**
     * @param definidoEstadoAnterior the definidoEstadoAnterior to set
     */
    public void setDefinidoEstadoAnterior(Boolean definidoEstadoAnterior) {
        this.definidoEstadoAnterior = definidoEstadoAnterior;
    }

    /**
     * @return the definidoEstadoAnterior
     */
    public Boolean getDefinidoEstadoAnterior() {
        return definidoEstadoAnterior;
    }

    /**
     * @return the tareas
     */
    public Set<TareaNotificacion> getTareas() {
        return tareas;
    }

    /**
     * @return the propuestaCumplimiento
     */
    public String getPropuestaCumplimiento() {
        return propuestaCumplimiento;
    }

    /**
     * @param propuestaCumplimiento the propuestaCumplimiento to set
     */
    public void setPropuestaCumplimiento(String propuestaCumplimiento) {
        this.propuestaCumplimiento = propuestaCumplimiento;
    }

    /**
     * @return the respuestaPropuestaCumplimiento
     */
    public String getRespuestaPropuestaCumplimiento() {
        return respuestaPropuestaCumplimiento;
    }

    /**
     * @param respuestaPropuestaCumplimiento the respuestaPropuestaCumplimiento to set
     */
    public void setRespuestaPropuestaCumplimiento(String respuestaPropuestaCumplimiento) {
        this.respuestaPropuestaCumplimiento = respuestaPropuestaCumplimiento;
    }

}
