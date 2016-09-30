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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProvisionGastos;


/**
 * Modelo que gestiona la informacion de una provisión de gastos.
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "PRG_PROVISION_GASTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ProvisionGastoS implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "PRG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ProvisionGastosGenerator")
    @SequenceGenerator(name = "ProvisionGastosGenerator", sequenceName = "S_PRG_PROVISION_GASTOS")
    private Long id;	
	
	@Column(name="PRG_NUM_PROVISION")
	private Long numProvision;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EPR_ID")
    private DDEstadoProvisionGastos estadoProvision;
	
	@Column(name="PRG_FECHA_ALTA")
	private Date fechaAlta;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PRV_ID_GESTORIA")
    private ActivoProveedor gestoria;
	
	@Column(name="PRG_FECHA_ENVIO")
	private Date fechaEnvio;
	
	@Column(name="PRG_FECHA_RESPUESTA")
	private Date fechaRespuesta;

	@Column(name="PRG_FECHA_ANULACION")
	private Date fechaAnulacion;
	
	
    
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

	public Long getNumProvision() {
		return numProvision;
	}

	public void setNumProvision(Long numProvision) {
		this.numProvision = numProvision;
	}

	public DDEstadoProvisionGastos getEstadoProvision() {
		return estadoProvision;
	}

	public void setEstadoProvision(DDEstadoProvisionGastos estadoProvision) {
		this.estadoProvision = estadoProvision;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public ActivoProveedor getGestoria() {
		return gestoria;
	}

	public void setGestoria(ActivoProveedor gestoria) {
		this.gestoria = gestoria;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public Date getFechaRespuesta() {
		return fechaRespuesta;
	}

	public void setFechaRespuesta(Date fechaRespuesta) {
		this.fechaRespuesta = fechaRespuesta;
	}

	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}

	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
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
