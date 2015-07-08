package es.pfsgroup.plugin.recovery.coreextension.subasta.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

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
public class BatchAcuerdoCierreDeuda implements Serializable{

	public static String PROPIEDAD_AUTOMATICO = "AUTOMATICO";
	public static String PROPIEDAD_MANUAL = "MANUAL";
	public static Long PROPIEDAD_RESULTADO_OK = 1L;
	public static Long PROPIEDAD_RESULTADO_KO= 0L;
	
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
	
	@Column(name = "ORIGEN_PROPUESTA")
	private String origenPropuesta;
	
	@Column(name = "RESULTADO_VALIDACION")
	private Long resultadoValidacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_RVC_ID")
	private DDResultadoValidacionCDD resultadoValidacionCDD;
	
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

	public String getOrigenPropuesta() {
		return origenPropuesta;
	}

	public void setOrigenPropuesta(String origenPropuesta) {
		this.origenPropuesta = origenPropuesta;
	}

	public Long getResultadoValidacion() {
		return resultadoValidacion;
	}

	public void setResultadoValidacion(Long resultadoValidacion) {
		this.resultadoValidacion = resultadoValidacion;
	}
	
	public DDResultadoValidacionCDD getResultadoValidacionCDD() {
		return resultadoValidacionCDD;
	}
	
	public void setResultadoValidacionCDD(DDResultadoValidacionCDD resultadoValidacionCDD) {
		this.resultadoValidacionCDD = resultadoValidacionCDD;
	}

}
