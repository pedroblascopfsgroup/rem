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
 * Modelo que gestiona el historico de scoring de alquiler
 * 
 * @author Sergio Beleña
 *
 */
@Entity
@Table(name = "SRE_HIS_SEGURO_RENTAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class HistoricoSeguroRentasAlquiler implements Serializable,Auditable  {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "SRE_HIS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoSeguroRentasAlquilerGenerator")
    @SequenceGenerator(name = "HistoricoSeguroRentasAlquilerGenerator", sequenceName = "S_SRE_HIS_SEGURO_RENTAS")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SRE_ID")
    private SeguroRentasAlquiler seguroRentasAlquiler;
	
	
	@Column(name = "SRE_HIS_FECHA_SANCION")
	private Date fechaSancion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_REC_ID")
	private DDResultadoCampo resultadoSeguroRentas;

	@Column(name = "SRE_HIS_ID_SOLICITUD")
	private String idSolicitud;
	
	@Column(name = "SRE_HIS_DOCUMENTO_SCORING")
	private String documentoScoring;
	
	@Column(name = "SRE_HIS_MESES_FIANZA")
	private Integer mesesFianza;
	
	@Column(name = "SRE_HIS_IMPORTE_FIANZA")
	private Long importFianza;
	
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

	public SeguroRentasAlquiler getSeguroRentasAlquiler() {
		return seguroRentasAlquiler;
	}

	public void setSeguroRentasAlquiler(SeguroRentasAlquiler seguroRentasAlquiler) {
		this.seguroRentasAlquiler = seguroRentasAlquiler;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}

	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public String getIdSolicitud() {
		return idSolicitud;
	}

	public void setIdSolicitud(String idSolicitud) {
		this.idSolicitud = idSolicitud;
	}

	public String getDocumentoScoring() {
		return documentoScoring;
	}

	public void setDocumentoScoring(String documentoScoring) {
		this.documentoScoring = documentoScoring;
	}

	public Integer getMesesFianza() {
		return mesesFianza;
	}

	public void setMesesFianza(Integer mesesFianza) {
		this.mesesFianza = mesesFianza;
	}

	public Long getImportFianza() {
		return importFianza;
	}

	public void setImportFianza(Long importFianza) {
		this.importFianza = importFianza;
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

	public DDResultadoCampo getResultadoSeguroRentas() {
		return resultadoSeguroRentas;
	}

	public void setResultadoSeguroRentas(DDResultadoCampo resultadoSeguroRentas) {
		this.resultadoSeguroRentas = resultadoSeguroRentas;
	}
	
	
	
	
	
	
}
