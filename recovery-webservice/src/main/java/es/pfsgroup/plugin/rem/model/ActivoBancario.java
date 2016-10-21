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
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpIncorrienteBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpRiesgoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProductoBancario;



/**
 * Modelo que gestiona los datos de activo bancario
 * 
 * @author Bender
 */
@Entity
@Table(name = "ACT_ABA_ACTIVO_BANCARIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoBancario implements Serializable, Auditable {

	
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ABA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoBancarioGenerator")
    @SequenceGenerator(name = "ActivoBancarioGenerator", sequenceName = "S_ACT_ABA_ACTIVO_BANCARIO")
    private Long id;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CLA_ID")
    private DDClaseActivoBancario claseActivo;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SCA_ID")
    private DDSubtipoClaseActivoBancario subtipoClaseActivo;
	
	@Column(name = "ABA_NEXPRIESGO")
	private String numExpRiesgo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TIP_ID")
    private DDTipoProductoBancario tipoProducto;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EER_ID")
    private DDEstadoExpRiesgoBancario estadoExpRiesgo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EEI_ID")
    private DDEstadoExpIncorrienteBancario estadoExpIncorriente;
	
	@Column(name = "ABA_TIPO_PRODUCTO")
	private String productoDescripcion;
	
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public DDClaseActivoBancario getClaseActivo() {
		return claseActivo;
	}

	public void setClaseActivo(DDClaseActivoBancario claseActivo) {
		this.claseActivo = claseActivo;
	}

	public DDSubtipoClaseActivoBancario getSubtipoClaseActivo() {
		return subtipoClaseActivo;
	}

	public void setSubtipoClaseActivo(DDSubtipoClaseActivoBancario subtipoClaseActivo) {
		this.subtipoClaseActivo = subtipoClaseActivo;
	}

	public String getNumExpRiesgo() {
		return numExpRiesgo;
	}

	public void setNumExpRiesgo(String numExpRiesgo) {
		this.numExpRiesgo = numExpRiesgo;
	}

	public DDTipoProductoBancario getTipoProducto() {
		return tipoProducto;
	}

	public void setTipoProducto(DDTipoProductoBancario tipoProducto) {
		this.tipoProducto = tipoProducto;
	}

	public DDEstadoExpRiesgoBancario getEstadoExpRiesgo() {
		return estadoExpRiesgo;
	}

	public void setEstadoExpRiesgo(DDEstadoExpRiesgoBancario estadoExpRiesgo) {
		this.estadoExpRiesgo = estadoExpRiesgo;
	}

	public DDEstadoExpIncorrienteBancario getEstadoExpIncorriente() {
		return estadoExpIncorriente;
	}

	public void setEstadoExpIncorriente(DDEstadoExpIncorrienteBancario estadoExpIncorriente) {
		this.estadoExpIncorriente = estadoExpIncorriente;
	}

	public String getProductoDescripcion() {
		return productoDescripcion;
	}

	public void setProductoDescripcion(String productoDescripcion) {
		this.productoDescripcion = productoDescripcion;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	

}
