package es.capgemini.pfs.analisisExterna.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.procesosJudiciales.model.DDFaseProcesal;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Tabla de analisis externa
 * @author pajimene
 */
@Entity
@Table(name = "ANE_ANALISIS_EXTERNA", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class AnalisisExterna implements Serializable, Auditable {

    private static final long serialVersionUID = 0L;

    @Id
    @Column(name = "ANE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AnalisisExternaGenerator")
    @SequenceGenerator(name = "AnalisisExternaGenerator", sequenceName = "S_ANE_ANALISIS_EXTERNA")
    private Long id;

    @Column(name = "ANE_FECHA_EXTRACCION")
    private Date fechaExtraccion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPO_ID")
    private TipoProcedimiento tipoProcedimiento;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DES_ID")
    private DespachoExterno despacho;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
    private Usuario gestor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GAS_ID")
    private Usuario supervisor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_FAP_ID")
    private DDFaseProcesal faseProcesal;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PAC_ID")
    private DDPlazoAceptacion plazoAceptacion;

    @Column(name = "ANE_PRC_ACTIVO")
    private Boolean procedimientoActivo;

    @Column(name = "ANE_N_PROCEDIMIENTO")
    private Long numProcedimientos;

    @Column(name = "ANE_N_ASUNTOS")
    private Long numAsuntos;

    @Column(name = "ANE_PRINCIPAL")
    private Float principal;

    @Column(name = "ANE_COBROSPAGOS")
    private Float cobrosPagos;

    @Column(name = "ANE_IMPORTE_RECUP")
    private Float importeRecuperado;

    @Column(name = "ANE_IMP_MENOR_MENOS24")
    private Float importeMenorMenos24;

    @Column(name = "ANE_IMP_MENOR_MENOS12")
    private Float importeMenorMenos12;

    @Column(name = "ANE_IMP_MENOR_MENOS6")
    private Float importeMenorMenos6;

    @Column(name = "ANE_IMP_MENOR_MENOS3")
    private Float importeMenorMenos3;

    @Column(name = "ANE_IMP_MENOR_MENOS0")
    private Float importeMenorMenos0;

    @Column(name = "ANE_IMP_MENOR_3")
    private Float importeMenor3;

    @Column(name = "ANE_IMP_MENOR_6")
    private Float importeMenor6;

    @Column(name = "ANE_IMP_MENOR_12")
    private Float importeMenor12;

    @Column(name = "ANE_IMP_MENOR_24")
    private Float importeMenor24;

    @Column(name = "ANE_IMP_MAYOR_24")
    private Float importeMayor24;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

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
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param fechaExtraccion the fechaExtraccion to set
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
        this.fechaExtraccion = fechaExtraccion;
    }

    /**
     * @return the fechaExtraccion
     */
    public Date getFechaExtraccion() {
        return fechaExtraccion;
    }

    /**
     * @param tipoProcedimiento the tipoProcedimiento to set
     */
    public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
        this.tipoProcedimiento = tipoProcedimiento;
    }

    /**
     * @return the tipoProcedimiento
     */
    public TipoProcedimiento getTipoProcedimiento() {
        return tipoProcedimiento;
    }

    /**
     * @param despacho the despacho to set
     */
    public void setDespacho(DespachoExterno despacho) {
        this.despacho = despacho;
    }

    /**
     * @return the despacho
     */
    public DespachoExterno getDespacho() {
        return despacho;
    }

    /**
     * @param gestor the gestor to set
     */
    public void setGestor(Usuario gestor) {
        this.gestor = gestor;
    }

    /**
     * @return the gestor
     */
    public Usuario getGestor() {
        return gestor;
    }

    /**
     * @param supervisor the supervisor to set
     */
    public void setSupervisor(Usuario supervisor) {
        this.supervisor = supervisor;
    }

    /**
     * @return the supervisor
     */
    public Usuario getSupervisor() {
        return supervisor;
    }

    /**
     * @param faseProcesal the faseProcesal to set
     */
    public void setFaseProcesal(DDFaseProcesal faseProcesal) {
        this.faseProcesal = faseProcesal;
    }

    /**
     * @return the faseProcesal
     */
    public DDFaseProcesal getFaseProcesal() {
        return faseProcesal;
    }

    /**
     * @param plazoAceptacion the plazoAceptacion to set
     */
    public void setPlazoAceptacion(DDPlazoAceptacion plazoAceptacion) {
        this.plazoAceptacion = plazoAceptacion;
    }

    /**
     * @return the plazoAceptacion
     */
    public DDPlazoAceptacion getPlazoAceptacion() {
        return plazoAceptacion;
    }

    /**
     * @param procedimientoActivo the procedimientoActivo to set
     */
    public void setProcedimientoActivo(Boolean procedimientoActivo) {
        this.procedimientoActivo = procedimientoActivo;
    }

    /**
     * @return the procedimientoActivo
     */
    public Boolean getProcedimientoActivo() {
        return procedimientoActivo;
    }

    /**
     * @param numProcedimientos the numProcedimientos to set
     */
    public void setNumProcedimientos(Long numProcedimientos) {
        this.numProcedimientos = numProcedimientos;
    }

    /**
     * @return the numProcedimientos
     */
    public Long getNumProcedimientos() {
        return numProcedimientos;
    }

    /**
     * @param numAsuntos the numAsuntos to set
     */
    public void setNumAsuntos(Long numAsuntos) {
        this.numAsuntos = numAsuntos;
    }

    /**
     * @return the numAsuntos
     */
    public Long getNumAsuntos() {
        return numAsuntos;
    }

    /**
     * @param principal the principal to set
     */
    public void setPrincipal(Float principal) {
        this.principal = principal;
    }

    /**
     * @return the principal
     */
    public Float getPrincipal() {
        return principal;
    }

    /**
     * @param cobrosPagos the cobrosPagos to set
     */
    public void setCobrosPagos(Float cobrosPagos) {
        this.cobrosPagos = cobrosPagos;
    }

    /**
     * @return the cobrosPagos
     */
    public Float getCobrosPagos() {
        return cobrosPagos;
    }

    /**
     * @param importeRecuperado the importeRecuperado to set
     */
    public void setImporteRecuperado(Float importeRecuperado) {
        this.importeRecuperado = importeRecuperado;
    }

    /**
     * @return the importeRecuperado
     */
    public Float getImporteRecuperado() {
        return importeRecuperado;
    }

    /**
     * @param importeMenorMenos24 the importeMenorMenos24 to set
     */
    public void setImporteMenorMenos24(Float importeMenorMenos24) {
        this.importeMenorMenos24 = importeMenorMenos24;
    }

    /**
     * @return the importeMenorMenos24
     */
    public Float getImporteMenorMenos24() {
        return importeMenorMenos24;
    }

    /**
     * @param importeMenorMenos12 the importeMenorMenos12 to set
     */
    public void setImporteMenorMenos12(Float importeMenorMenos12) {
        this.importeMenorMenos12 = importeMenorMenos12;
    }

    /**
     * @return the importeMenorMenos12
     */
    public Float getImporteMenorMenos12() {
        return importeMenorMenos12;
    }

    /**
     * @param importeMenorMenos6 the importeMenorMenos6 to set
     */
    public void setImporteMenorMenos6(Float importeMenorMenos6) {
        this.importeMenorMenos6 = importeMenorMenos6;
    }

    /**
     * @return the importeMenorMenos6
     */
    public Float getImporteMenorMenos6() {
        return importeMenorMenos6;
    }

    /**
     * @param importeMenorMenos3 the importeMenorMenos3 to set
     */
    public void setImporteMenorMenos3(Float importeMenorMenos3) {
        this.importeMenorMenos3 = importeMenorMenos3;
    }

    /**
     * @return the importeMenorMenos3
     */
    public Float getImporteMenorMenos3() {
        return importeMenorMenos3;
    }

    /**
     * @param importeMenorMenos0 the importeMenorMenos0 to set
     */
    public void setImporteMenorMenos0(Float importeMenorMenos0) {
        this.importeMenorMenos0 = importeMenorMenos0;
    }

    /**
     * @return the importeMenorMenos0
     */
    public Float getImporteMenorMenos0() {
        return importeMenorMenos0;
    }

    /**
     * @param importeMenor3 the importeMenor3 to set
     */
    public void setImporteMenor3(Float importeMenor3) {
        this.importeMenor3 = importeMenor3;
    }

    /**
     * @return the importeMenor3
     */
    public Float getImporteMenor3() {
        return importeMenor3;
    }

    /**
     * @param importeMenor6 the importeMenor6 to set
     */
    public void setImporteMenor6(Float importeMenor6) {
        this.importeMenor6 = importeMenor6;
    }

    /**
     * @return the importeMenor6
     */
    public Float getImporteMenor6() {
        return importeMenor6;
    }

    /**
     * @param importeMenor12 the importeMenor12 to set
     */
    public void setImporteMenor12(Float importeMenor12) {
        this.importeMenor12 = importeMenor12;
    }

    /**
     * @return the importeMenor12
     */
    public Float getImporteMenor12() {
        return importeMenor12;
    }

    /**
     * @param importeMenor24 the importeMenor24 to set
     */
    public void setImporteMenor24(Float importeMenor24) {
        this.importeMenor24 = importeMenor24;
    }

    /**
     * @return the importeMenor24
     */
    public Float getImporteMenor24() {
        return importeMenor24;
    }

    /**
     * @param importeMayor24 the importeMayor24 to set
     */
    public void setImporteMayor24(Float importeMayor24) {
        this.importeMayor24 = importeMayor24;
    }

    /**
     * @return the importeMayor24
     */
    public Float getImporteMayor24() {
        return importeMayor24;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

}
