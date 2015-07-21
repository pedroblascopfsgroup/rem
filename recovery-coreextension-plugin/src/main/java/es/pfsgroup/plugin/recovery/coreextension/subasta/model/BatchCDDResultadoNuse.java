package es.pfsgroup.plugin.recovery.coreextension.subasta.model;

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

import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * @author
 */
@Entity
@Table(name = "CDD_CRN_RESULTADO_NUSE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class BatchCDDResultadoNuse implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "CRN_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "BatchCDDResultadoNuse")
	@SequenceGenerator(name = "BatchCDDResultadoNuse", sequenceName = "${entity.schema}.S_CDD_CRN_RESULTADO_NUSE")
	private Long id;

	@Column(name = "ID_EXPEDIENTE")
	private Long id_expediente;

	@Column(name = "ASU_ID_EXTERNO")
	private String codigoExterno;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ACUERDO_CIERRE")
	private BatchAcuerdoCierreDeuda batchAcuerdoCierreDeuda;

	@Column(name = "CRN_FECHA_EXTRACCION")
	private Date fechaExtraccion;

	@Column(name = "CRN_FICHERO_DAT")
	private String ficheroDat;

	@Column(name = "CRN_CLAVE_FICHERO")
	private String claveFichero;

	@Column(name = "CRN_RESULTADO")
	private String resultado;

	@Column(name = "CRN_DESC_RESULT")
	private String descripcionResultado;

	@Column(name = "CRN_FECHA_RESULT")
	private Date fechaResultado;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	public Long getId() {
		return id;
	}

	public Long getId_expediente() {
		return id_expediente;
	}

	public String getCodigoExterno() {
		return codigoExterno;
	}

	public BatchAcuerdoCierreDeuda getBatchAcuerdoCierreDeuda() {
		return batchAcuerdoCierreDeuda;
	}

	public Date getFechaExtraccion() {
		return fechaExtraccion;
	}

	public String getFicheroDat() {
		return ficheroDat;
	}

	public String getClaveFichero() {
		return claveFichero;
	}

	public String getResultado() {
		return resultado;
	}

	public String getDescripcionResultado() {
		return descripcionResultado;
	}

	public Date getFechaResultado() {
		return fechaResultado;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setId_expediente(Long id_expediente) {
		this.id_expediente = id_expediente;
	}

	public void setCodigoExterno(String codigoExterno) {
		this.codigoExterno = codigoExterno;
	}

	public void setBatchAcuerdoCierreDeuda(
			BatchAcuerdoCierreDeuda batchAcuerdoCierreDeuda) {
		this.batchAcuerdoCierreDeuda = batchAcuerdoCierreDeuda;
	}

	public void setFechaExtraccion(Date fechaExtraccion) {
		this.fechaExtraccion = fechaExtraccion;
	}

	public void setFicheroDat(String ficheroDat) {
		this.ficheroDat = ficheroDat;
	}

	public void setClaveFichero(String claveFichero) {
		this.claveFichero = claveFichero;
	}

	public void setResultado(String resultado) {
		this.resultado = resultado;
	}

	public void setDescripcionResultado(String descripcionResultado) {
		this.descripcionResultado = descripcionResultado;
	}

	public void setFechaResultado(Date fechaResultado) {
		this.fechaResultado = fechaResultado;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

}
