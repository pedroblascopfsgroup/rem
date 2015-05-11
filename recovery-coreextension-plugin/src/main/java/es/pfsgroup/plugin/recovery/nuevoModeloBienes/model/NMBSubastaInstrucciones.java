package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDPostores2;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBSubastaInstruccionesInfo;

@Entity
@Table(name="BIE_SUI_SUBASTA_INSTRUCCIONES", schema="${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class NMBSubastaInstrucciones implements Serializable, Auditable, NMBSubastaInstruccionesInfo {

	private static final long serialVersionUID = 4018662337996731871L;

	@Id
	@Column(name = "SUI_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SubastaIntruccGenerator")
	@SequenceGenerator(name = "SubastaIntruccGenerator", sequenceName = "S_BIE_SUI_SUBASTA_INSTRUCS")
	private Long id;
	
	@ManyToOne
    @JoinColumn(name = "BIE_ID")
	private NMBBien bien;
	
	@ManyToOne
    @JoinColumn(name = "PRC_ID")
	private Procedimiento procedimiento;
	
	@ManyToOne
    @JoinColumn(name = "DD_TPS_ID")
	private NMBDDtipoSubasta tipoSubasta;
	
	@Column(name = "SUI_PRIMERA_SUBASTA")
	private Date primeraSubasta;
	
	@Column(name = "SUI_SEGUNDA_SUBASTA")
	private Date segundaSubasta;
	
	@Column(name = "SUI_TERCERA_SUBASTA")
	private Date terceraSubasta;
	
	@ManyToOne
    @JoinColumn(name = "SUI_NOTARIO_USU_ID")
	private Usuario notario;
	
	@Column(name = "SUI_VALOR_SUBASTA")
	private Float valorSubasta;
	
	@Column(name = "SUI_TOTAL_DEUDA")
	private Float totalDeuda;
	
	/* apremio y notarial */
	@Column(name = "SUI_PRINCIPAL")
	private BigDecimal principal;
	
	@Column(name = "SUI_CARGAS_ANTERIORES")
	private Float cargasAnteriores;
	
	@Column(name = "SUI_PERITACION_ACTUAL")
	private Float peritacionActual;
	
	@Column(name = "SUI_TIPO_SEG_SUBASTA")
	private Float tipoSegundaSubasta;
	
	@Column(name = "SUI_IMPORTE_SEG_SUBASTA")
	private Float importeSegundaSubasta;
	
	@Column(name = "SUI_TIPO_TER_SUBASTA")
	private Float tipoTerceraSubasta;
	
	@Column(name = "SUI_IMPORTE_TER_SUBASTA")
	private Float importeTerceraSubasta;
	
	@Column(name = "SUI_RESP_CAPITAL")
	private Float responsabilidadCapital;
	
	@Column(name = "SUI_RESP_INTERESES")
	private Float responsabilidadIntereses;
	
	@Column(name = "SUI_RESP_DEMORAS")
	private Float responsabilidadDemoras;
	
	@Column(name = "SUI_RESP_COSTAS")
	private Float responsabilidadCostas;
	
	/* apremio y notarial*/
	@Column(name = "SUI_PROP_CAPITAL")
	private Float propuestaCapital;
	
	/* apremio y notarial*/
	@Column(name = "SUI_PROP_INTERESES")
	private Float propuestaIntereses;
	
	@Column(name = "SUI_PROP_DEMORAS")
	private Float propuestaDemoras;
	
	@Column(name = "SUI_PROP_COSTAS")
	private Float propuestaCostas;
	
	@Column(name = "SUI_FECHA_INSCRIPCION")
	private Date fechaInscripcion;
	
	@Column(name = "SUI_FECHA_LLAVES")
	private Date fechaLlaves;
	
	@Column(name = "SUI_OBSERVACIONES")
	private String observacion;
	
	/* apremio */
	@Column(name = "SUI_COSTAS_PROCURADOR")
	private Float costasProcurador;
	
	/* apremio */
	@Column(name = "SUI_COSTAS_LETRADO")
	private Float costasLetrado;	
	
	/* apremio */
	@Column(name = "SUI_LIMITE_CON_POSTORES")
	private Float limiteConPostores;
	
	/* apremio */
	@OneToOne
    @JoinColumn(name = "DD_PS2_ID")
	private DDPostores2 postores;
	
	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

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

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public NMBBien getBien() {
		return bien;
	}

	public void setBien(NMBBien bien) {
		this.bien = bien;
	}

	public NMBDDtipoSubasta getTipoSubasta() {
		return tipoSubasta;
	}

	public void setTipoSubasta(NMBDDtipoSubasta tipoSubasta) {
		this.tipoSubasta = tipoSubasta;
	}

	public Date getPrimeraSubasta() {
		return primeraSubasta;
	}

	public void setPrimeraSubasta(Date primeraSubasta) {
		this.primeraSubasta = primeraSubasta;
	}

	public Date getSegundaSubasta() {
		return segundaSubasta;
	}

	public void setSegundaSubasta(Date segundaSubasta) {
		this.segundaSubasta = segundaSubasta;
	}

	public Date getTerceraSubasta() {
		return terceraSubasta;
	}

	public void setTerceraSubasta(Date terceraSubasta) {
		this.terceraSubasta = terceraSubasta;
	}

	public Usuario getNotario() {
		return notario;
	}

	public void setNotario(Usuario notario) {
		this.notario = notario;
	}

	public Float getValorSubasta() {
		return valorSubasta;
	}

	public void setValorSubasta(Float valorSubasta) {
		this.valorSubasta = valorSubasta;
	}

	public Float getTotalDeuda() {
		return totalDeuda;
	}

	public void setTotalDeuda(Float totalDeuda) {
		this.totalDeuda = totalDeuda;
	}

	public BigDecimal getPrincipal() {
		return principal;
	}

	public void setPrincipal(BigDecimal principal) {
		this.principal = principal;
	}

	public Float getCargasAnteriores() {
		return cargasAnteriores;
	}

	public void setCargasAnteriores(Float cargasAnteriores) {
		this.cargasAnteriores = cargasAnteriores;
	}

	public Float getPeritacionActual() {
		return peritacionActual;
	}

	public void setPeritacionActual(Float peritacionActual) {
		this.peritacionActual = peritacionActual;
	}

	public Float getTipoSegundaSubasta() {
		return tipoSegundaSubasta;
	}

	public void setTipoSegundaSubasta(Float tipoSegundaSubasta) {
		this.tipoSegundaSubasta = tipoSegundaSubasta;
	}

	public Float getImporteSegundaSubasta() {
		return importeSegundaSubasta;
	}

	public void setImporteSegundaSubasta(Float importeSegundaSubasta) {
		this.importeSegundaSubasta = importeSegundaSubasta;
	}

	public Float getTipoTerceraSubasta() {
		return tipoTerceraSubasta;
	}

	public void setTipoTerceraSubasta(Float tipoTerceraSubasta) {
		this.tipoTerceraSubasta = tipoTerceraSubasta;
	}

	public Float getImporteTerceraSubasta() {
		return importeTerceraSubasta;
	}

	public void setImporteTerceraSubasta(Float importeTerceraSubasta) {
		this.importeTerceraSubasta = importeTerceraSubasta;
	}

	public Float getResponsabilidadCapital() {
		return responsabilidadCapital;
	}

	public void setResponsabilidadCapital(Float responsabilidadCapital) {
		this.responsabilidadCapital = responsabilidadCapital;
	}

	public Float getResponsabilidadIntereses() {
		return responsabilidadIntereses;
	}

	public void setResponsabilidadIntereses(Float responsabilidadIntereses) {
		this.responsabilidadIntereses = responsabilidadIntereses;
	}

	public Float getResponsabilidadDemoras() {
		return responsabilidadDemoras;
	}

	public void setResponsabilidadDemoras(Float responsabilidadDemoras) {
		this.responsabilidadDemoras = responsabilidadDemoras;
	}

	public Float getResponsabilidadCostas() {
		return responsabilidadCostas;
	}

	public void setResponsabilidadCostas(Float responsabilidadCostas) {
		this.responsabilidadCostas = responsabilidadCostas;
	}

	public Float getPropuestaCapital() {
		return propuestaCapital;
	}

	public void setPropuestaCapital(Float propuestaCapital) {
		this.propuestaCapital = propuestaCapital;
	}

	public Float getPropuestaIntereses() {
		return propuestaIntereses;
	}

	public void setPropuestaIntereses(Float propuestaIntereses) {
		this.propuestaIntereses = propuestaIntereses;
	}

	public Float getPropuestaDemoras() {
		return propuestaDemoras;
	}

	public void setPropuestaDemoras(Float propuestaDemoras) {
		this.propuestaDemoras = propuestaDemoras;
	}

	public Float getPropuestaCostas() {
		return propuestaCostas;
	}

	public void setPropuestaCostas(Float propuestaCostas) {
		this.propuestaCostas = propuestaCostas;
	}

	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}

	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}

	public Date getFechaLlaves() {
		return fechaLlaves;
	}

	public void setFechaLlaves(Date fechaLlaves) {
		this.fechaLlaves = fechaLlaves;
	}

	/**
	 * @param procedimiento the procedimiento to set
	 */
	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	/**
	 * @return the procedimiento
	 */
	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	/**
	 * @param observacion the observacion to set
	 */
	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}

	/**
	 * @return the observacion
	 */
	public String getObservacion() {
		return observacion;
	}

	/**
	 * @param costasProcurador the costasProcurador to set
	 */
	public void setCostasProcurador(Float costasProcurador) {
		this.costasProcurador = costasProcurador;
	}

	/**
	 * @return the costasProcurador
	 */
	public Float getCostasProcurador() {
		return costasProcurador;
	}

	/**
	 * @param costasLetrado the costasLetrado to set
	 */
	public void setCostasLetrado(Float costasLetrado) {
		this.costasLetrado = costasLetrado;
	}

	/**
	 * @return the costasLetrado
	 */
	public Float getCostasLetrado() {
		return costasLetrado;
	}

	/**
	 * @param limiteConPostores the limiteConPostores to set
	 */
	public void setLimiteConPostores(Float limiteConPostores) {
		this.limiteConPostores = limiteConPostores;
	}

	/**
	 * @return the limiteConPostores
	 */
	public Float getLimiteConPostores() {
		return limiteConPostores;
	}

	/**
	 * @param postores the postores to set
	 */
	public void setPostores(DDPostores2 postores) {
		this.postores = postores;
	}

	/**
	 * @return the postores
	 */
	public DDPostores2 getPostores() {
		return postores;
	}
	
}

