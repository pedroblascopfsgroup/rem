package es.pfsgroup.plugin.recovery.coreextension.subasta.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

/**
 * Esta clase se utiliza para almacenar el cierre de deuda desde el BPM para que la recoja el Batch
 * 
 * @author gonzalo
 *
 */
@Entity
@Table(name = "CNV_AUX_CCDD_PR_CONV_CIERR_DD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class BatchAcuerdoCierreDeuda implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ID_ACUERDO_CIERRE")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "BatchAcuerdoCierreDeuda")
    @SequenceGenerator(name = "BatchAcuerdoCierreDeuda", sequenceName = "${entity.schema}.S_CCDD_PR_CONV_CIERR_DD_PK")
	private Long id;

	@Column(name = "PRC_ID")
	private Long idProcedimiento;
	
	@Column(name = "FECHA_ALTA")
	private Date fechaAlta;
	
	@Column(name = "ASU_ID")
	private Long idAsunto;
	
	@Column(name = "FECHA_ENTREGA")
	private Date fechaEntrega;

	@Column(name = "USUARIOCREAR")
	private String usuarioCrear;

	@Column(name = "BIE_ID")
	private Long idBien;
	
	@Column(name = "ENTIDAD")
	private String entidad;
	
	@Column(name = "VERSION")
	@Version
    private Integer version;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	public Long getIdAsunto() {
		return idAsunto;
	}

	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Date getFechaEntrega() {
		return fechaEntrega;
	}

	public void setFechaEntrega(Date fechaEntrega) {
		this.fechaEntrega = fechaEntrega;
	}

	public String getUsuarioCrear() {
		return usuarioCrear;
	}

	public void setUsuarioCrear(String usuarioCrear) {
		this.usuarioCrear = usuarioCrear;
	}

	public Long getIdBien() {
		return idBien;
	}

	public void setIdBien(Long idBien) {
		this.idBien = idBien;
	}

	public String getEntidad() {
		return entidad;
	}

	public void setEntidad(String entidad) {
		this.entidad = entidad;
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
	
	
}
