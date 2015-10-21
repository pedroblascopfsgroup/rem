package es.pfsgroup.plugin.recovery.coreextension.subasta.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Formula;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;

/**
 * Clase que representa la entidad Subasta.
 * 
 * @author
 * 
 */
@Entity
@Table(name = "LOS_LOTE_SUBASTA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class LoteSubasta implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5987488870796403973L;


	@Id
	@Column(name = "LOS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "LoteGenerator")
	@SequenceGenerator(name = "LoteGenerator", sequenceName = "S_LOS_LOTE_SUBASTA")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "SUB_ID")
	private Subasta subasta;
	
	@Column(name = "LOS_PUJA_SIN_POSTORES")
	private Float insPujaSinPostores;

	@Column(name = "LOS_PUJA_POSTORES_DESDE")
	private Float insPujaPostoresDesde;

	@Column(name = "LOS_PUJA_POSTORES_HASTA")
	private Float insPujaPostoresHasta;

	@Formula(value = "(select sum(bie.BIE_TIPO_SUBASTA) from LOS_LOTE_SUBASTA los "
				     +"inner join LOB_LOTE_BIEN lob on  lob.LOS_ID = los.LOS_ID "
				     +"inner join BIE_BIEN bie on bie.BIE_ID = lob.BIE_ID "
				     +"where los.LOS_ID = LOS_ID)")
	private Float valorBienes;
	
	@Column(name = "LOS_VALOR_SUBASTA")
	private Float insValorSubasta;

	@Column(name = "LOS_50_DEL_TIPO_SUBASTA")
	private Float ins50DelTipoSubasta;

	@Column(name = "LOS_60_DEL_TIPO_SUBASTA")
	private Float ins60DelTipoSubasta;

	@Column(name = "LOS_70_DEL_TIPO_SUBASTA")
	private Float ins70DelTipoSubasta;

	@Column(name = "LOS_OBSERVACIONES")
	private String observaciones;

	@Formula(value = "(SELECT CASE WHEN count(*)>0 THEN 1 ELSE 0 END " +
					" FROM LOB_LOTE_BIEN LOS " +
					" INNER JOIN BIE_CAR_CARGAS BCAR ON LOS.BIE_ID=BCAR.BIE_ID AND BCAR.BORRADO=0 " +
					" INNER JOIN DD_TPC_TIPO_CARGA TPC ON TPC.DD_TPC_ID=BCAR.DD_TPC_ID AND TPC.DD_TPC_CODIGO='ANT' " +
					" LEFT JOIN DD_SIC_SITUACION_CARGA SIC ON SIC.DD_SIC_ID=BCAR.DD_SIC_ID AND SIC.DD_SIC_CODIGO='ACT' AND SIC.BORRADO=0 " +
					" LEFT JOIN DD_SIC_SITUACION_CARGA SIC2 ON SIC2.DD_SIC_ID=BCAR.DD_SIC_ID2 AND SIC2.DD_SIC_CODIGO='ACT' AND SIC2.BORRADO=0 " +
					" WHERE LOS.LOS_ID=LOS_ID)")
	private Boolean tieneCargasAnteriores;	

	@Formula(value = "(SELECT VLOS.IMPORTE_TASACION FROM VLOS_TASACION_ACTIVA VLOS WHERE VLOS.LOS_ID=LOS_ID)") 
	private Float tasacionActiva;
	
//	@OneToMany(mappedBy = "lote", fetch = FetchType.LAZY)
//    @Where(clause = Auditoria.UNDELETED_RESTICTION)
//    private List<LoteBien> lotesBien;
	
	@OneToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "LOB_LOTE_BIEN", joinColumns = @JoinColumn(name = "LOS_ID", referencedColumnName = "LOS_ID"), inverseJoinColumns = @JoinColumn(name = "BIE_ID", referencedColumnName = "BIE_ID"))
    private List<Bien> bienes;
	
	@Column(name = "LOS_NUM_LOTE")
	private Integer numLote;

	@Column(name = "LOS_RIESGO_CONSIG")
	private Boolean riesgoConsignacion;

	@Column(name = "LOS_DEUDA_JUDICIAL")
	private Float deudaJudicial;
	
	@Column(name = "LOS_OBSERVACION_COMITE")
	private String observacionesComite;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_EPI_ID")
	private DDEstadoLoteSubasta estado;
	
	@Column(name = "LOS_FECHA_ESTADO")
	private Date fechaEstado;
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	@Column(name="SYS_GUID")
	private String guid;
	
	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Subasta getSubasta() {
		return subasta;
	}

	public void setSubasta(Subasta subasta) {
		this.subasta = subasta;
	}

	public Float getInsPujaSinPostores() {
		return insPujaSinPostores;
	}

	public void setInsPujaSinPostores(Float insPujaSinPostores) {
		this.insPujaSinPostores = insPujaSinPostores;
	}

	public Float getInsPujaPostoresDesde() {
		return insPujaPostoresDesde;
	}

	public void setInsPujaPostoresDesde(Float insPujaPostoresDesde) {
		this.insPujaPostoresDesde = insPujaPostoresDesde;
	}

	public Float getInsPujaPostoresHasta() {
		return insPujaPostoresHasta;
	}

	public void setInsPujaPostoresHasta(Float insPujaPostoresHasta) {
		this.insPujaPostoresHasta = insPujaPostoresHasta;
	}

	public Float getInsValorSubasta() {
		if (insValorSubasta != null && insValorSubasta >0 ){ 
			return insValorSubasta;
		} else {
			return valorBienes;
		}
	}
	
	public Float getInsValorSubastaSinBienes() {
		return insValorSubasta;
	}
	
	public Float getValorBienes() {
		return valorBienes;
	}

	public void setValorBienes(Float valorBienes) {
		this.valorBienes = valorBienes;
	}

	public void setInsValorSubasta(Float insValorSubasta) {
		this.insValorSubasta = insValorSubasta;
	}

	public Float getIns50DelTipoSubasta() {
		return insValorSubasta != null && insValorSubasta > 0 ? (insValorSubasta*50)/100 : 0;
	}

	public void setIns50DelTipoSubasta(Float ins50DelTipoSubasta) {
		this.ins50DelTipoSubasta = insValorSubasta != null && insValorSubasta > 0 ? (insValorSubasta*50)/100 : 0;
	}

	public Float getIns60DelTipoSubasta() {
		return insValorSubasta != null && insValorSubasta > 0 ? (insValorSubasta*60)/100 : 0;
	}

	public void setIns60DelTipoSubasta(Float ins60DelTipoSubasta) {
		this.ins60DelTipoSubasta = insValorSubasta != null && insValorSubasta > 0 ? (insValorSubasta*60)/100 : 0;
	}

	public Float getIns70DelTipoSubasta() {
		return insValorSubasta != null && insValorSubasta > 0 ? (insValorSubasta*70)/100 : 0;
	}

	public void setIns70DelTipoSubasta(Float ins70DelTipoSubasta) {
		this.ins70DelTipoSubasta = insValorSubasta != null && insValorSubasta > 0 ? (insValorSubasta*70)/100 : 0;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	public List<Bien> getBienes() {
		return bienes;
	}

	public void setBienes(List<Bien> bienes) {
		this.bienes = bienes;
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

	public Integer getNumLote() {
		return numLote;
	}

	public void setNumLote(Integer numLote) {
		this.numLote = numLote;
	}

	public Boolean getRiesgoConsignacion() {
		return riesgoConsignacion;
	}

	public void setRiesgoConsignacion(Boolean riesgoConsignacion) {
		this.riesgoConsignacion = riesgoConsignacion;
	}

	public Float getDeudaJudicial() {
		return deudaJudicial;
	}

	public void setDeudaJudicial(Float deudaJudicial) {
		this.deudaJudicial = deudaJudicial;
	}

	public String getObservacionesComite() {
		return observacionesComite;
	}

	public void setObservacionesComite(String observacionesComite) {
		this.observacionesComite = observacionesComite;
	}

	public DDEstadoLoteSubasta getEstado() {
		return estado;
	}

	public void setEstado(DDEstadoLoteSubasta estado) {
		this.estado = estado;
	}

	public Date getFechaEstado() {
		return fechaEstado;
	}

	public void setFechaEstado(Date fechaEstado) {
		this.fechaEstado = fechaEstado;
	}
	
	public Float getTasacionActiva() {
		return tasacionActiva;
	}

	public Boolean getTieneCargasAnteriores() {
		return tieneCargasAnteriores;
	}

	
}
