package es.pfsgroup.plugin.rem.model;

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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoCampo;



/**
 * Modelo que gestiona el Seguro rentas del modulo alquiler
 * 
 * @author Sergio Beleña
 *
 */
@Entity
@Table(name = "SRE_SEGURO_RENTAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class SeguroRentasAlquiler implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "SRE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "SeguroRentasAlquilerGenerator")
    @SequenceGenerator(name = "SeguroRentasAlquilerGenerator", sequenceName = "S_SRE_SEGURO_RENTAS")
    private Long id;
	
	@Column(name = "SRE_MOTIVO_RECHAZO")
    private String motivoRechazo;	
	
	@Column(name = "SRE_EN_REVISION")
	private Boolean enRevision;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_REC_ID")
	private DDResultadoCampo resultadoSeguroRentas;

	@Column(name = "SRE_ASEGURADORAS")
	private String aseguradoras;
	
	@Column(name = "SRE_EMAIL_POLIZA_ASEGURADORA")
	private String emailPolizaAseguradora;
	
	@Column(name = "COMENTARIOS")
	private String comentarios;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;

    @Column(name="SRE_FECHA_SANCION_BC")
    private Date fechaVencimientoRentaslBc;
    
	@Column(name="SRE_MESES_BC")
    private Integer mesesAval;
	
    @Column(name="SRE_IMPORTE_BC")
    private Double importeRentasBc;
    
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID")
    private ActivoProveedor aseguradoraProveedor;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getMotivoRechazo() {
		return motivoRechazo;
	}

	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}

	public Boolean getEnRevision() {
		return enRevision;
	}

	public void setEnRevision(Boolean enRevision) {
		this.enRevision = enRevision;
	}

	public String getAseguradoras() {
		return aseguradoras;
	}

	public void setAseguradoras(String aseguradoras) {
		this.aseguradoras = aseguradoras;
	}

	public String getEmailPolizaAseguradora() {
		return emailPolizaAseguradora;
	}

	public void setEmailPolizaAseguradora(String emailPolizaAseguradora) {
		this.emailPolizaAseguradora = emailPolizaAseguradora;
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

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	public String getComentarios() {
		return comentarios;
	}

	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}

	public DDResultadoCampo getResultadoSeguroRentas() {
		return resultadoSeguroRentas;
	}

	public void setResultadoSeguroRentas(DDResultadoCampo resultadoSeguroRentas) {
		this.resultadoSeguroRentas = resultadoSeguroRentas;
	}

	public Date getFechaVencimientoRentaslBc() {
		return fechaVencimientoRentaslBc;
	}

	public void setFechaVencimientoRentaslBc(Date fechaVencimientoRentaslBc) {
		this.fechaVencimientoRentaslBc = fechaVencimientoRentaslBc;
	}

	public Integer getMesesAval() {
		return mesesAval;
	}

	public void setMesesAval(Integer mesesAval) {
		this.mesesAval = mesesAval;
	}

	public Double getImporteRentasBc() {
		return importeRentasBc;
	}

	public void setImporteRentasBc(Double importeRentasBc) {
		this.importeRentasBc = importeRentasBc;
	}

	public ActivoProveedor getAseguradoraProveedor() {
		return aseguradoraProveedor;
	}

	public void setAseguradoraProveedor(ActivoProveedor aseguradoraProveedor) {
		this.aseguradoraProveedor = aseguradoraProveedor;
	}
	
}
