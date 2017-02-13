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
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoDenegacionResolucion;



/**
 * Modelo que gestiona la informacion de las resoluciones tomadas por los comites de bankia.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "RCB_RESOL_COMITE_BANKIA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ResolucionComiteBankia implements Serializable, Auditable {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "RCB_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ResolucionComiteBankiaGenerator")
    @SequenceGenerator(name = "ResolucionComiteBankiaGenerator", sequenceName = "S_RCB_RESOL_COMITE_BANKIA")
    private Long id;
    				
	@OneToOne
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_COS_ID")
    private DDComiteSancion comite;
 
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ERE_ID")
    private DDEstadoResolucion estadoResolucion;
	 
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DCB_ID")
    private DDMotivoDenegacionResolucion motivoDenegacion;
	
	@Column(name = "RCB_FECHA_ANULA")
   	private Date fechaAnulacion;
	
	@Column(name = "RCB_IMPORTE_CONTRAOFR")
	private Double importeContraoferta;
	
	

	
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

	public DDComiteSancion getComite() {
		return comite;
	}

	public void setComite(DDComiteSancion comite) {
		this.comite = comite;
	}

	public DDEstadoResolucion getEstadoResolucion() {
		return estadoResolucion;
	}

	public void setEstadoResolucion(DDEstadoResolucion estadoResolucion) {
		this.estadoResolucion = estadoResolucion;
	}

	public DDMotivoDenegacionResolucion getMotivoDenegacion() {
		return motivoDenegacion;
	}

	public void setMotivoDenegacion(DDMotivoDenegacionResolucion motivoDenegacion) {
		this.motivoDenegacion = motivoDenegacion;
	}

	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}

	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}

	public Double getImporteContraoferta() {
		return importeContraoferta;
	}

	public void setImporteContraoferta(Double importeContraoferta) {
		this.importeContraoferta = importeContraoferta;
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
