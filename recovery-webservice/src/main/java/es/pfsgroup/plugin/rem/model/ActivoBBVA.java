package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTransmision;

@Entity
@Table(name = "ACT_BBVA_ACTIVOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoBBVA implements Serializable, Auditable{
	private static final long serialVersionUID = 1L;
	
	
	@Id
    @Column(name = "BBVA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoBbvaGenerator")
    @SequenceGenerator(name = "ActivoBbvaGenerator", sequenceName = "S_ACT_BBVA_ACTIVOS")
	private Long id;

	
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@Column(name = "BBVA_NUM_ACTIVO")
	private Long bbva_num_activo;
	
	@Column(name = "BBVA_ID_DIVARIAN")
	private Long id_Divarian;
	
	@Column(name = "BBVA_LINEA_FACTURA")
	private Long linea_Factura;
	
	@Column(name = "BBVA_ID_ORIGEN_HRE")
	private Long id_Origen_Haya;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TTR_ID")
	private DDTipoTransmision tipo_Trasmision;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAL_ID")
	private DDTipoAlta tipoAlta;
	
	@Column(name = "BBVA_UIC")
	private String uic;
	
	@Column(name = "BBVA_CEXPER")
	private String cexper;
	
	@Column(name = "BBVA_ID_PROCESO_ORIGEN")
	private Long id_Proceso_Origen;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SIN_ID")
	private DDSinSiNo activo_Epa;
	
	@Column(name = "BBVA_EMPRESA")
	private Long empresa;
	
	@Column(name = "BBVA_OFICINA")
	private Long oficina;
	
	@Column(name = "BBVA_CONTRAPARTIDA")
	private Long contrapartida;
	
	@Column(name = "BBVA_FOLIO")
	private Long folio;
	
	@Column(name = "BBVA_CDPEN")
	private Long cdpen;
	
	@Embedded
	private Auditoria auditoria;
	
	
	@Version   
	private Long version;


	public Long getId() {
		return id;
	}


	public void setId(Long id) {
		this.id = id;
	}


	public Activo getActivo() {
		return activo;
	}


	public void setActivo(Activo activo) {
		this.activo = activo;
	}


	public Long getBbva_num_activo() {
		return bbva_num_activo;
	}


	public void setBbva_num_activo(Long bbva_num_activo) {
		this.bbva_num_activo = bbva_num_activo;
	}


	public Long getId_Divarian() {
		return id_Divarian;
	}


	public void setId_Divarian(Long id_Divarian) {
		this.id_Divarian = id_Divarian;
	}


	public Long getLinea_Factura() {
		return linea_Factura;
	}


	public void setLinea_Factura(Long linea_Factura) {
		this.linea_Factura = linea_Factura;
	}


	public Long getId_Origen_Haya() {
		return id_Origen_Haya;
	}


	public void setId_Origen_Haya(Long id_Origen_Haya) {
		this.id_Origen_Haya = id_Origen_Haya;
	}


	public DDTipoTransmision getTipo_Trasmision() {
		return tipo_Trasmision;
	}


	public void setTipo_Trasmision(DDTipoTransmision tipo_Trasmision) {
		this.tipo_Trasmision = tipo_Trasmision;
	}


	public DDTipoAlta getTipoAlta() {
		return tipoAlta;
	}


	public void setTipoAlta(DDTipoAlta tipoAlta) {
		this.tipoAlta = tipoAlta;
	}


	public String getUic() {
		return uic;
	}


	public void setUic(String uic) {
		this.uic = uic;
	}


	public String getCexper() {
		return cexper;
	}


	public void setCexper(String cexper) {
		this.cexper = cexper;
	}


	public Long getId_Proceso_Origen() {
		return id_Proceso_Origen;
	}


	public void setId_Proceso_Origen(Long id_Proceso_Origen) {
		this.id_Proceso_Origen = id_Proceso_Origen;
	}


	public DDSinSiNo getActivo_Epa() {
		return activo_Epa;
	}


	public void setActivo_Epa(DDSinSiNo activo_Epa) {
		this.activo_Epa = activo_Epa;
	}


	public Long getEmpresa() {
		return empresa;
	}


	public void setEmpresa(Long empresa) {
		this.empresa = empresa;
	}


	public Long getOficina() {
		return oficina;
	}


	public void setOficina(Long oficina) {
		this.oficina = oficina;
	}


	public Long getContrapartida() {
		return contrapartida;
	}


	public void setContrapartida(Long contrapartida) {
		this.contrapartida = contrapartida;
	}


	public Long getFolio() {
		return folio;
	}


	public void setFolio(Long folio) {
		this.folio = folio;
	}


	public Long getCdpen() {
		return cdpen;
	}


	public void setCdpen(Long cdpen) {
		this.cdpen = cdpen;
	}


	public Auditoria getAuditoria() {
		return auditoria;
	}


	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}



	
	

	
	
		
	

}