package es.pfsgroup.plugin.rem.model;

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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEquipoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDRecomendacionRCDC;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;

/**
 * Modelo que gestiona la configuracion de las recomendaciones.
 * 
 * @author Ivan Repiso
 *
 */
@Entity
@Table(name = "COR_CONFIG_RECOMENDACION_RCDC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ConfiguracionRecomendacion implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "COR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TestigosObligatoriosGenerator")
    @SequenceGenerator(name = "TestigosObligatoriosGenerator", sequenceName = "S_TOB_TESTIGOS_OBLIGATORIOS")
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "DD_CRA_ID")
    private DDCartera cartera; 
    
    @ManyToOne
    @JoinColumn(name = "DD_SCR_ID")
    private DDSubcartera subcartera; 
    
    @ManyToOne
    @JoinColumn(name = "DD_TCO_ID")
    private DDTipoComercializacion tipoComercializacion; 
    
    @ManyToOne
    @JoinColumn(name = "DD_EQG_ID")
    private DDEquipoGestion equipoGestion; 

    @Column(name = "COR_PORCENTAJE_DESC")
	private Double porcentajeDescuento;
	 
    @Column(name = "COR_IMPORTE_MIN")
	private Double importeMinimo;
	 
    @ManyToOne
    @JoinColumn(name = "DD_REC_ID")
	private DDRecomendacionRCDC recomendacionRCDC;

	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDSubcartera getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(DDSubcartera subcartera) {
		this.subcartera = subcartera;
	}

	public DDTipoComercializacion getTipoComercializacion() {
		return tipoComercializacion;
	}

	public void setTipoComercializacion(DDTipoComercializacion tipoComercializacion) {
		this.tipoComercializacion = tipoComercializacion;
	}

	public DDEquipoGestion getEquipoGestion() {
		return equipoGestion;
	}

	public void setEquipoGestion(DDEquipoGestion equipoGestion) {
		this.equipoGestion = equipoGestion;
	}

	public Double getPorcentajeDescuento() {
		return porcentajeDescuento;
	}

	public void setPorcentajeDescuento(Double porcentajeDescuento) {
		this.porcentajeDescuento = porcentajeDescuento;
	}

	public Double getImporteMinimo() {
		return importeMinimo;
	}

	public void setImporteMinimo(Double importeMinimo) {
		this.importeMinimo = importeMinimo;
	}

	public DDRecomendacionRCDC getRecomendacionRCDC() {
		return recomendacionRCDC;
	}

	public void setRecomendacionRCDC(DDRecomendacionRCDC recomendacionRCDC) {
		this.recomendacionRCDC = recomendacionRCDC;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}