package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_LISTADO_OFERTAS_AGRUPADAS_LBK", schema = "${entity.schema}")
public class VListadoOfertasAgrupadasLbk implements Serializable {

	@Id
	@Column(name = "ID_VISTA")  
	private Long id;	
	
	@Column(name="OFR_NUM_OFERTA_PRINCIPAL")
	private Long numOfertaPrincipal;
	
	@Column(name="OFR_NUM_OFERTA_DEPENDIENTE")
	private Long numOfertaDependiente;
	
	@Column(name="ACT_NUM_ACTIVO")
	private Long numActivo;
	
	@Column(name="OFR_IMPORTE")
	private Double importeOfertaDependiente;
	
	@Column(name="TAS_IMPORTE_TAS_FIN")
	private Double valorTasacionActivo;
	
	@Column(name="VAL_IMPORTE_VNC")
	private Double valorNetoContable;
	
	@Column(name="VAL_IMPORTE_VR")
	private Double valorRazonable;
	
	public VListadoOfertasAgrupadasLbk() {}
	
	public VListadoOfertasAgrupadasLbk(Long id, Long numOfertaPrincipal, Long numOfertaDependiente, Long numActivo,
			Double importeOfertaDependiente, Double valorTasacionActivo, Double valorNetoContable,
			Double valorRazonable) {
		super();
		this.id = id;
		this.numOfertaPrincipal = numOfertaPrincipal;
		this.numOfertaDependiente = numOfertaDependiente;
		this.numActivo = numActivo;
		this.importeOfertaDependiente = importeOfertaDependiente;
		this.valorTasacionActivo = valorTasacionActivo;
		this.valorNetoContable = valorNetoContable;
		this.valorRazonable = valorRazonable;
	}

	public VListadoOfertasAgrupadasLbk(Long numOfertaPrincipal, Long numOfertaDependiente,
			Double importeOfertaDependiente) {
		super();
		this.numOfertaPrincipal = numOfertaPrincipal;
		this.numOfertaDependiente = numOfertaDependiente;
		this.importeOfertaDependiente = importeOfertaDependiente;
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getNumOfertaPrincipal() {
		return numOfertaPrincipal;
	}

	public void setNumOfertaPrincipal(Long numOfertaPrincipal) {
		this.numOfertaPrincipal = numOfertaPrincipal;
	}

	public Long getNumOfertaDependiente() {
		return numOfertaDependiente;
	}

	public void setNumOfertaDependiente(Long numOfertaDependiente) {
		this.numOfertaDependiente = numOfertaDependiente;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public Double getImporteOfertaDependiente() {
		return importeOfertaDependiente;
	}

	public void setImporteOfertaDependiente(Double importeOfertaDependiente) {
		this.importeOfertaDependiente = importeOfertaDependiente;
	}

	public Double getValorTasacionActivo() {
		return valorTasacionActivo;
	}

	public void setValorTasacionActivo(Double valorTasacionActivo) {
		this.valorTasacionActivo = valorTasacionActivo;
	}

	public Double getValorNetoContable() {
		return valorNetoContable;
	}

	public void setValorNetoContable(Double valorNetoContable) {
		this.valorNetoContable = valorNetoContable;
	}

	public Double getValorRazonable() {
		return valorRazonable;
	}

	public void setValorRazonable(Double valorRazonable) {
		this.valorRazonable = valorRazonable;
	}
	
}
