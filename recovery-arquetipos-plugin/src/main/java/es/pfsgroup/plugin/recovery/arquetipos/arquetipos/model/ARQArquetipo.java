package es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.arquetipo.model.DDTipoSaltoNivel;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model.ARQModeloArquetipo;

@Entity
public class ARQArquetipo extends Arquetipo {

	private static final long serialVersionUID = -995141458489599512L;
	
	@OneToOne
	@JoinColumn(name="MRA_ID")
	private ARQModeloArquetipo modeloArquetipo;
	
	@Column(name="ARQ_NIVEL")
	private Long nivel;
	
	@Column(name="ARQ_PLAZO_DISPARO")
	private Long plazoDisparo;
	
	@OneToOne
	@JoinColumn(name="DD_TSN_ID")
	private DDTipoSaltoNivel tipoSaltoNivel;

	public ARQModeloArquetipo getModeloArquetipo() {
		return modeloArquetipo;
	}

	public void setModeloArquetipo(ARQModeloArquetipo modeloArquetipo) {
		this.modeloArquetipo = modeloArquetipo;
	}

	public Long getNivel() {
		return nivel;
	}

	public void setNivel(Long nivel) {
		this.nivel = nivel;
	}

	public Long getPlazoDisparo() {
		return plazoDisparo;
	}

	public void setPlazoDisparo(Long plazoDisparo) {
		this.plazoDisparo = plazoDisparo;
	}

	public DDTipoSaltoNivel getTipoSaltoNivel() {
		return tipoSaltoNivel;
	}

	public void setTipoSaltoNivel(DDTipoSaltoNivel tipoSaltoNivel) {
		this.tipoSaltoNivel = tipoSaltoNivel;
	}
	
	

}
