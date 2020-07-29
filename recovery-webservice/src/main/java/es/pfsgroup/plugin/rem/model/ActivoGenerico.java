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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;



/**
 * Modelo que permita incluir un activo genérico configurable para cada uno de los clientes.
 * 
 * @author Javier Esbrí
 *
 */
@Entity
@Table(name = "ACT_AGS_ACTIVO_GENERICO_STG", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoGenerico implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "AGS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoGenericoGenerator")
    @SequenceGenerator(name = "ActivoGenericoGenerator", sequenceName = "S_ACT_AGS_ACTIVO_GENERICO_STG")
    private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STG_ID")
    private DDSubtipoGasto subtipoGasto;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_CRA_ID")
	private DDCartera cartera;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_SCR_ID")
	private DDSubcartera subcartera;
	
	@Column(name = "AGS_ANYO")
    private Integer anyoActivoGenerico;   
	
	@Column(name = "AGS_ACTIVO_GENERICO")
	private String agsActivoGenerico;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	@Override
	public Auditoria getAuditoria() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setAuditoria(Auditoria arg0) {
		// TODO Auto-generated method stub
		
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDSubtipoGasto getSubtipoGasto() {
		return subtipoGasto;
	}

	public void setSubtipoGasto(DDSubtipoGasto subtipoGasto) {
		this.subtipoGasto = subtipoGasto;
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

	public Integer getAnyoActivoGenerico() {
		return anyoActivoGenerico;
	}

	public void setAnyoActivoGenerico(Integer anyoActivoGenerico) {
		this.anyoActivoGenerico = anyoActivoGenerico;
	}

	public String getAgsActivoGenerico() {
		return agsActivoGenerico;
	}

	public void setAgsActivoGenerico(String agsActivoGenerico) {
		this.agsActivoGenerico = agsActivoGenerico;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}
}