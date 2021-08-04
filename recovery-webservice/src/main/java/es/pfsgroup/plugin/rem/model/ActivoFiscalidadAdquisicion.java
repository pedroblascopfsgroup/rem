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

import es.pfsgroup.plugin.rem.model.dd.*;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "ACT_FAD_FISCALIDAD_ADQUISICION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoFiscalidadAdquisicion implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "FAD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoFiscalidadAdquisicionGenerator")
    @SequenceGenerator(name = "ActivoFiscalidadAdquisicionGenerator", sequenceName = "S_ACT_FAD_FISCALIDAD_ADQUISICION")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TIC_ID")
	private DDTipoImpuestoCompra tipoImpuestoCompra;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SIC_ID")
	private DDSubtipoImpuestoCompra subtipoImpuestoCompra;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TII_ID")
	private DDTipoITP tipoImpositivoITP;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TIA_ID")
	private DDTipoIVA tipoImpositivoIVA;
	
    @Column(name = "FAD_PORCENTAJE_IMPUESTO_COMPRA")
    private Double porcentajeImpuestoCompra;
    
    @Column(name = "FAD_COD_TP_IVA_COMPRA")
    private String codigoTpIvaCompra;
    
    @Column(name = "FAD_RENUNCIA_EXENCION")
    private Boolean renunciaExencionCompra;

    @Column(name = "FAD_DEDUCIBLE")
	private Long deducible;

    @Column(name = "FAD_BONIFICADO")
	private Long bonificado;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

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

	public DDTipoImpuestoCompra getTipoImpuestoCompra() {
		return tipoImpuestoCompra;
	}

	public void setTipoImpuestoCompra(DDTipoImpuestoCompra tipoImpuestoCompra) {
		this.tipoImpuestoCompra = tipoImpuestoCompra;
	}

	public DDSubtipoImpuestoCompra getSubtipoImpuestoCompra() {
		return subtipoImpuestoCompra;
	}

	public void setSubtipoImpuestoCompra(DDSubtipoImpuestoCompra subtipoImpuestoCompra) {
		this.subtipoImpuestoCompra = subtipoImpuestoCompra;
	}

	public Double getPorcentajeImpuestoCompra() {
		return porcentajeImpuestoCompra;
	}

	public void setPorcentajeImpuestoCompra(Double porcentajeImpuestoCompra) {
		this.porcentajeImpuestoCompra = porcentajeImpuestoCompra;
	}

	public String getCodigoTpIvaCompra() {
		return codigoTpIvaCompra;
	}

	public void setCodigoTpIvaCompra(String codigoTpIvaCompra) {
		this.codigoTpIvaCompra = codigoTpIvaCompra;
	}

	public Boolean getRenunciaExencionCompra() {
		return renunciaExencionCompra;
	}

	public void setRenunciaExencionCompra(Boolean renunciaExencionCompra) {
		this.renunciaExencionCompra = renunciaExencionCompra;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public DDTipoITP getTipoImpositivoITP() {
		return tipoImpositivoITP;
	}

	public void setTipoImpositivoITP(DDTipoITP tipoImpositivoITP) {
		this.tipoImpositivoITP = tipoImpositivoITP;
	}

	public DDTipoIVA getTipoImpositivoIVA() {
		return tipoImpositivoIVA;
	}

	public void setTipoImpositivoIVA(DDTipoIVA tipoImpositivoIVA) {
		this.tipoImpositivoIVA = tipoImpositivoIVA;
	}

	public Long getDeducible() {
		return deducible;
	}

	public void setDeducible(Long deducible) {
		this.deducible = deducible;
	}

	public Long getBonificado() {
		return bonificado;
	}

	public void setBonificado(Long bonificado) {
		this.bonificado = bonificado;
	}
}
