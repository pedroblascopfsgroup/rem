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

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoPlazaGaraje;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAnejo;


/**
 * Modelo que gestiona los anejos.
 * 
 * @author Ramon Llinares
 */
@Entity
@Table(name = "ACT_ANJ_ANEJOS", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoAnejo implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
    @Id
    @Column(name = "ANJ_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AnejoGenerator")
    @SequenceGenerator(name = "AnejoGenerator", sequenceName = "S_ACT_ANJ_ANEJOS")
    private Long id;

    @Column(name = "ANJ_DESCRIPCION")
   	private String descripcion;
    
    @Column(name = "ANJ_CANTIDAD")
   	private Long cantidad;
    
    @Column(name = "ANJ_SUPERFICIE")
   	private Float superficie;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SPG_ID")
	private DDSubtipoPlazaGaraje subTipo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TNJ_ID")
	private DDTipoAnejo tipoAnejo;
    
    @OneToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoInfoComercial infoComercial;
    
    @Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Long getCantidad() {
		return cantidad;
	}

	public void setCantidad(Long cantidad) {
		this.cantidad = cantidad;
	}

	public Float getSuperficie() {
		return superficie;
	}

	public void setSuperficie(Float superficie) {
		this.superficie = superficie;
	}

	public DDSubtipoPlazaGaraje getSubTipo() {
		return subTipo;
	}

	public void setSubTipo(DDSubtipoPlazaGaraje subTipo) {
		this.subTipo = subTipo;
	}

	public DDTipoAnejo getTipoAnejo() {
		return tipoAnejo;
	}

	public void setTipoAnejo(DDTipoAnejo tipoAnejo) {
		this.tipoAnejo = tipoAnejo;
	}

	public ActivoInfoComercial getInfoComercial() {
		return infoComercial;
	}

	public void setInfoComercial(ActivoInfoComercial infoComercial) {
		this.infoComercial = infoComercial;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
    
    
	
}
