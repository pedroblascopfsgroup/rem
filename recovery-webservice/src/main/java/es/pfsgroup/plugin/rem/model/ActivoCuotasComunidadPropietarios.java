package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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
import es.pfsgroup.plugin.rem.model.dd.DDTipoCuota;



/**
 * Modelo que gestiona la informacion de las comunidades de propietarios de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_CCP_CUOTA_COM_PROP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoCuotasComunidadPropietarios implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CCP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoCuotasComunidadPropietariosGenerator")
    @SequenceGenerator(name = "ActivoCuotasComunidadPropietariosGenerator", sequenceName = "S_ACT_CCP_CUOTA_COM_PROP")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "CPR_ID")
    private ActivoComunidadPropietarios comunidadPropietarios; 
	
	@Column(name = "CCP_COD_CUOTA_UVEM")
	private Long codigoCuotaUvem;
	
	@ManyToOne
    @JoinColumn(name = "DD_TPC_ID")
    private DDTipoCuota tipoCuota;  
	
	@Column(name = "CCP_CONCEPTO_CUOTA")
	private String conceptoCuota;

	@Column(name = "CCP_FECHA_EMISION")
	private Date fechaEmision;
	 
	@Column(name = "CCP_PAGADA")
	private Integer pagada;
	
	@Column(name = "CCP_OBSERVACIONES")
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

	public ActivoComunidadPropietarios getComunidadPropietarios() {
		return comunidadPropietarios;
	}

	public void setComunidadPropietarios(
			ActivoComunidadPropietarios comunidadPropietarios) {
		this.comunidadPropietarios = comunidadPropietarios;
	}

	public DDTipoCuota getTipoCuota() {
		return tipoCuota;
	}

	public void setTipoCuota(DDTipoCuota tipoCuota) {
		this.tipoCuota = tipoCuota;
	}

	public Long getCodigoCuotaUvem() {
		return codigoCuotaUvem;
	}

	public void setCodigoCuotaUvem(Long codigoCuotaUvem) {
		this.codigoCuotaUvem = codigoCuotaUvem;
	}

	public String getConceptoCuota() {
		return conceptoCuota;
	}

	public void setConceptoCuota(String conceptoCuota) {
		this.conceptoCuota = conceptoCuota;
	}

	public Date getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public Integer getPagada() {
		return pagada;
	}

	public void setPagada(Integer pagada) {
		this.pagada = pagada;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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
