package es.pfsgroup.concursal.credito.model;

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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.concursal.convenio.model.ConvenioCredito;

@Entity
@Table(name = "CRE_PRC_CEX", schema = "${entity.schema}")
public class Credito implements Serializable, Auditable{

	private static final long serialVersionUID = -7940687884107775604L;

	@Id
	@Column(name = "CRE_CEX_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CreditoGenerator")
	@SequenceGenerator(name = "CreditoGenerator", sequenceName = "S_CRE_PRC_CEX")
	private Long id;

	@OneToMany(mappedBy = "credito", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "CRE_CEX_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ConvenioCredito> convenioCreditos;
	
	@Column(name = "CRE_PRC_CEX_PRCID")
	private Long idProcedimiento;
	
	@Column(name = "CRE_PRC_CEX_CEXID")
	private Long idContratoExpediente;

	@ManyToOne
    @JoinColumn(name = "STD_CRE_ID")
	private DDEstadoCredito estadoCredito;
	
	@ManyToOne
    @JoinColumn(name = "TPO_CNT_ID_EXT")
	private DDTipoCredito tipoExterno;
	
	@ManyToOne
    @JoinColumn(name = "TPO_CNT_ID_SUP")
	private DDTipoCredito tipoSupervisor;
	
	@ManyToOne
    @JoinColumn(name = "TPO_CNT_ID_FINAL")
	private DDTipoCredito tipoDefinitivo;
	
	@Column(name = "CRE_PRINCIPAL_EXT")
	private Double principalExterno;
	
	@Column(name = "CRE_PRINCIPAL_SUP")
	private Double principalSupervisor;
	
	@Column(name = "CRE_PRINCIPAL_FINAL")
	private Double principalDefinitivo;
	
	@Column(name = "CRE_FECHA_VENCIMIENTO")
	private Date fechaVencimiento;	

	@Column(name="SYS_GUID")
	private String guid;

	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDTipoCredito getTipoExterno() {
		return tipoExterno;
	}

	public void setTipoExterno(DDTipoCredito tipoExterno) {
		this.tipoExterno = tipoExterno;
	}

	public DDTipoCredito getTipoSupervisor() {
		return tipoSupervisor;
	}

	public void setTipoSupervisor(DDTipoCredito tipoSupervisor) {
		this.tipoSupervisor = tipoSupervisor;
	}

	public DDTipoCredito getTipoDefinitivo() {
		return tipoDefinitivo;
	}

	public void setTipoDefinitivo(DDTipoCredito tipoDefinitivo) {
		this.tipoDefinitivo = tipoDefinitivo;
	}

	public Double getPrincipalExterno() {
		return principalExterno;
	}

	public void setPrincipalExterno(Double principalExterno) {
		this.principalExterno = principalExterno;
	}

	public Double getPrincipalSupervisor() {
		return principalSupervisor;
	}

	public void setPrincipalSupervisor(
			Double principalSupervisor) {
		this.principalSupervisor = principalSupervisor;
	}

	public Double getPrincipalDefinitivo() {
		return principalDefinitivo;
	}

	public void setPrincipalDefinitivo(Double principalDefinitivo) {
		this.principalDefinitivo = principalDefinitivo;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	public void setIdContratoExpediente(Long idContratoExpediente) {
		this.idContratoExpediente = idContratoExpediente;
	}

	public Long getIdContratoExpediente() {
		return idContratoExpediente;
	}

	public void setConvenioCreditos(List<ConvenioCredito> convenioCreditos) {
		this.convenioCreditos = convenioCreditos;
	}

	public List<ConvenioCredito> getConvenioCreditos() {
		return convenioCreditos;
	}

	public void setEstadoCredito(DDEstadoCredito estadoCredito) {
		this.estadoCredito = estadoCredito;
	}

	public DDEstadoCredito getEstadoCredito() {
		return estadoCredito;
	}
	
	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

}
