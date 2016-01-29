package es.capgemini.pfs.termino.model;

import java.io.Serializable;
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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDSubTipoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.DDTipoProducto;

/**
 * 
 * @author AMQ
 *
 */
@Entity
@Table(name = "TEA_TERMINOS_ACUERDO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class TerminoAcuerdo implements Serializable, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1958131562516043847L;

	@Id
    @Column(name = "TEA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TerminoAcuerdoGenerator")
    @SequenceGenerator(name = "TerminoAcuerdoGenerator", sequenceName = "S_TEA_TERMINOS_ACUERDO")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "ACU_ID")
	private Acuerdo acuerdo;
	
	@ManyToOne
	@JoinColumn(name = "DD_TPA_ID")
	private DDTipoAcuerdo tipoAcuerdo;

	@ManyToOne
	@JoinColumn(name = "DD_SBT_ID")
	private DDSubTipoAcuerdo subtipoAcuerdo;
	
    @ManyToOne
    @JoinColumn(name = "DD_TPR_ID")
    private DDTipoProducto tipoProducto;	
    
    @Column(name = "TEA_MODO_DESEMBOLSO")
    private String modoDesembolso;	
    
    @Column(name = "TEA_FORMALIZACION")
    private String formalizacion;	
    
    @Column(name = "TEA_IMPORTE")
    private Float importe;	
    
    @Column(name = "TEA_COMISIONES")
    private Float comisiones;	
    
    @Column(name = "TEA_PERIODICIDAD")
    private String periodicidad;	

    @Column(name = "TEA_PERIODO_FIJO")
    private String periodoFijo;	
   
    @Column(name = "TEA_SISTEMA_AMORTIZACION")
    private String sistemaAmortizacion;	

    @Column(name = "TEA_INTERES")
    private Float interes;	
    
    @Column(name = "TEA_PERIODO_VARIABLE")
    private String periodoVariable;	    

    @Column(name = "TEA_INFORME_LETRADO")
    private String informeLetrado;
    
    @OneToMany(mappedBy = "termino", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_TEA_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<TerminoBien> bienes;
    
    @OneToOne(mappedBy = "termino", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "OP_TERM_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private TerminoOperaciones operaciones;

	@Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

	@Column(name = "SYS_GUID")
	private String guid;
    
    @ManyToOne
    @JoinColumn(name = "DD_EGT_ID")
    private DDEstadoGestionTermino estadoGestion;	
    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Acuerdo getAcuerdo() {
		return acuerdo;
	}

	public void setAcuerdo(Acuerdo acuerdo) {
		this.acuerdo = acuerdo;
	}

	public DDTipoAcuerdo getTipoAcuerdo() {
		return tipoAcuerdo;
	}

	public void setTipoAcuerdo(DDTipoAcuerdo tipoAcuerdo) {
		this.tipoAcuerdo = tipoAcuerdo;
	}
	
	public DDSubTipoAcuerdo getSubtipoAcuerdo() {
		return subtipoAcuerdo;
	}

	public void setSubtipoAcuerdo(DDSubTipoAcuerdo subtipoAcuerdo) {
		this.subtipoAcuerdo = subtipoAcuerdo;
	}

	public DDTipoProducto getTipoProducto() {
		return tipoProducto;
	}

	public void setTipoProducto(DDTipoProducto tipoProducto) {
		this.tipoProducto = tipoProducto;
	}

	public String getModoDesembolso() {
		return modoDesembolso;
	}

	public void setModoDesembolso(String modoDesembolso) {
		this.modoDesembolso = modoDesembolso;
	}

	public String getFormalizacion() {
		return formalizacion;
	}

	public void setFormalizacion(String formalizacion) {
		this.formalizacion = formalizacion;
	}

	public Float getImporte() {
		return importe;
	}

	public void setImporte(Float importe) {
		this.importe = importe;
	}

	public Float getComisiones() {
		return comisiones;
	}

	public void setComisiones(Float comisiones) {
		this.comisiones = comisiones;
	}

	public String getPeriodicidad() {
		return periodicidad;
	}

	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}

	public String getPeriodoFijo() {
		return periodoFijo;
	}

	public void setPeriodoFijo(String periodoFijo) {
		this.periodoFijo = periodoFijo;
	}

	public String getSistemaAmortizacion() {
		return sistemaAmortizacion;
	}

	public void setSistemaAmortizacion(String sistemaAmortizacion) {
		this.sistemaAmortizacion = sistemaAmortizacion;
	}

	public Float getInteres() {
		return interes;
	}

	public void setInteres(Float interes) {
		this.interes = interes;
	}

	public String getPeriodoVariable() {
		return periodoVariable;
	}

	public void setPeriodoVariable(String periodoVariable) {
		this.periodoVariable = periodoVariable;
	}

	public String getInformeLetrado() {
		return informeLetrado;
	}

	public void setInformeLetrado(String informeLetrado) {
		this.informeLetrado = informeLetrado;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public List<TerminoBien> getBienes() {
		return bienes;
	}

	public void setBienes(List<TerminoBien> bienes) {
		this.bienes = bienes;
	}
	
    public TerminoOperaciones getOperaciones() {
		return operaciones;
	}

	public void setOperaciones(TerminoOperaciones operaciones) {
		this.operaciones = operaciones;
	}

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}
	
	public DDEstadoGestionTermino getEstadoGestion() {
		return estadoGestion;
	}

	public void setEstadoGestion(DDEstadoGestionTermino estadoGestion) {
		this.estadoGestion = estadoGestion;
	}

}
