package es.pfsgroup.plugin.rem.model;

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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTenedor;



/**
 * Modelo que gestiona la informacion de las llaves de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_LLV_LLAVE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ActivoLlave implements Serializable, Auditable, Comparable<ActivoLlave> {


	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6095852150728740944L;

	@Id
    @Column(name = "LLV_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoLlaveGenerator")
    @SequenceGenerator(name = "ActivoLlaveGenerator", sequenceName = "S_ACT_LLV_LLAVE")
    private Long id;
	
    @ManyToOne
    @JoinColumn(name = "ACT_ID")
    private Activo activo;	
    
	@OneToMany(mappedBy = "activoLlave", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "LLV_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoMovimientoLlave> activoMovimientoLlave; 

	@Column(name = "LLV_COD_CENTRO")
	private String codCentroLlave;
	
	@Column(name = "LLV_NOMBRE_CENTRO")
	private String nomCentroLlave;
	
	@Column(name = "LLV_ARCHIVO1")
	private String archivo1;
	
	@Column(name = "LLV_ARCHIVO2")
	private String archivo2;
	
	@Column(name = "LLV_ARCHIVO3")
	private String archivo3;
	
	@Column(name = "LLV_COMPLETO")
	private Integer juegoCompleto;
	
	@Column(name = "LLV_MOTIVO_INCOMPLETO")
	private String motivoIncompleto;
	
	@Column(name ="LLV_NUM_LLAVE")
	private String numLlave;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TTE_ID_POSEEDOR")
	private DDTipoTenedor tipoTenedor;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "LLV_COD_TENEDOR_POSEEDOR")
	private ActivoProveedor poseedor;
	
	@Column(name = "LLV_COD_TENEDOR_NO_PVE")
	private String codNoPoseedor;
	
	@Column(name = "LLV_FECHA_ANILLADO")
	private Date fechaPrimerAnillado;
	
	@Column(name ="LLV_FECHA_RECEPCION")
	private Date fechaRecepcion;
	
	@Column(name ="LLV_CODE")
	private String codigoLlavero;
	
	@Column(name ="LLV_OBSERVACIONES")
	private String observaciones;
	
	
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public String getCodCentroLlave() {
		return codCentroLlave;
	}

	public void setCodCentroLlave(String codCentroLlave) {
		this.codCentroLlave = codCentroLlave;
	}

	public String getNomCentroLlave() {
		return nomCentroLlave;
	}

	public void setNomCentroLlave(String nomCentroLlave) {
		this.nomCentroLlave = nomCentroLlave;
	}

	public String getArchivo1() {
		return archivo1;
	}

	public void setArchivo1(String archivo1) {
		this.archivo1 = archivo1;
	}

	public String getArchivo2() {
		return archivo2;
	}

	public void setArchivo2(String archivo2) {
		this.archivo2 = archivo2;
	}

	public String getArchivo3() {
		return archivo3;
	}

	public void setArchivo3(String archivo3) {
		this.archivo3 = archivo3;
	}

	public Integer getJuegoCompleto() {
		return juegoCompleto;
	}

	public void setJuegoCompleto(Integer juegoCompleto) {
		this.juegoCompleto = juegoCompleto;
	}

	public String getMotivoIncompleto() {
		return motivoIncompleto;
	}

	public void setMotivoIncompleto(String motivoIncompleto) {
		this.motivoIncompleto = motivoIncompleto;
	}

	public List<ActivoMovimientoLlave> getActivoMovimientoLlave() {
		return activoMovimientoLlave;
	}

	public void setActivoMovimientoLlave(
			List<ActivoMovimientoLlave> activoMovimientoLlave) {
		this.activoMovimientoLlave = activoMovimientoLlave;
	}
	
	public String getNumLlave() {
		return numLlave;
	}

	public void setNumLlave(String numLlave) {
		this.numLlave = numLlave;
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

	public DDTipoTenedor getTipoTenedor() {
		return tipoTenedor;
	}

	public void setTipoTenedor(DDTipoTenedor tipoTenedor) {
		this.tipoTenedor = tipoTenedor;
	}

	public ActivoProveedor getPoseedor() {
		return poseedor;
	}

	public void setPoseedor(ActivoProveedor poseedor) {
		this.poseedor = poseedor;
	}

	public String getCodNoPoseedor() {
		return codNoPoseedor;
	}

	public void setCodNoPoseedor(String codNoPoseedor) {
		this.codNoPoseedor = codNoPoseedor;
	}

	public Date getFechaPrimerAnillado() {
		return fechaPrimerAnillado;
	}

	public void setFechaPrimerAnillado(Date fechaPrimerAnillado) {
		this.fechaPrimerAnillado = fechaPrimerAnillado;
	}

	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}

	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}

	public String getCodigoLlavero() {
		return codigoLlavero;
	}

	public void setCodigoLlavero(String codigoLlavero) {
		this.codigoLlavero = codigoLlavero;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	@Override
	public int compareTo(ActivoLlave o) {
		if ( getFechaRecepcion() == null || o.getFechaRecepcion() == null)
			return 0; 
		else
			return getFechaRecepcion().compareTo(o.getFechaRecepcion());
	}
	
}
