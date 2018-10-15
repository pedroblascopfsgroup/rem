package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.pfsgroup.plugin.rem.model.dd.DDCategoriaContable;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivoBDE;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivoBDE;

/**
 * Modelo que gestiona la informacion de los activos de liberbank
 * 
 * @author Juanjo Arbona
 *
 */
@Entity
@Table(name = "ACT_ILB_NFO_LIBERBANK", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ActivoInfoLiberbank implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name="ACT_ID")
	private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_CCO_ID")
	private DDCategoriaContable categoriaContable;

	@Column(name = "ILB_COD_PROMOCION")
	private String codPromocion;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TBE_ID")
	private DDTipoActivoBDE tipoActivoBde;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_SBE_ID")
	private DDSubtipoActivoBDE subtipoActivoBde;

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public DDCategoriaContable getCategoriaContable() {
		return categoriaContable;
	}

	public void setCategoriaContable(DDCategoriaContable categoriaContable) {
		this.categoriaContable = categoriaContable;
	}

	public String getCodPromocion() {
		return codPromocion;
	}

	public void setCodPromocion(String codPromocion) {
		this.codPromocion = codPromocion;
	}

	public DDTipoActivoBDE getTipoActivoBde() {
		return tipoActivoBde;
	}

	public void setTipoActivoBde(DDTipoActivoBDE tipoActivoBde) {
		this.tipoActivoBde = tipoActivoBde;
	}

	public DDSubtipoActivoBDE getSubtipoActivoBde() {
		return subtipoActivoBde;
	}

	public void setSubtipoActivoBde(DDSubtipoActivoBDE subtipoActivoBde) {
		this.subtipoActivoBde = subtipoActivoBde;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

}