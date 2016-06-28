package es.pfsgroup.plugin.precontencioso.tipoProdPlantilla.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.DDAplicativoOrigen;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDTipoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;

@Entity
@Table(name = "MPP_MAPEO_PLANTILLAS_PCO", schema = "${entity.schema}")
public class TipoProductoPlantilla implements Auditable, Serializable {

	private static final long serialVersionUID = -3976064880614203640L;

	@Id
	@Column(name = "MPP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "TipoProductoPlantillaGenerator")
	@SequenceGenerator(name = "TipoProductoPlantillaGenerator", sequenceName = "S_MPP_MAPEO_PLANTILLAS_PCO")
	private Long id;
	
	
	@ManyToOne
	@JoinColumn(name = "DD_APO_ID")
	private DDAplicativoOrigen aplicativoOrigen;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_LIQ_ID", nullable = true)
	private DDTipoLiquidacionPCO tipoLiquidacion;
	
	@ManyToOne
	@JoinColumn(name = "DD_PCO_BFT_ID", nullable = true)
	private DDTipoBurofaxPCO tipoBurofax;

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

	public DDAplicativoOrigen getAplicativoOrigen() {
		return aplicativoOrigen;
	}

	public void setAplicativoOrigen(DDAplicativoOrigen aplicativoOrigen) {
		this.aplicativoOrigen = aplicativoOrigen;
	}

	public DDTipoLiquidacionPCO getTipoLiquidacion() {
		return tipoLiquidacion;
	}

	public void setTipoLiquidacion(DDTipoLiquidacionPCO tipoLiquidacion) {
		this.tipoLiquidacion = tipoLiquidacion;
	}

	public DDTipoBurofaxPCO getTipoBurofax() {
		return tipoBurofax;
	}

	public void setTipoBurofax(DDTipoBurofaxPCO tipoBurofax) {
		this.tipoBurofax = tipoBurofax;
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

}
