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
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivoBDE;




/**
 * 
 * 
 * @author Jonathan Ovalle
 *
 */
@Entity
@Table(name = "ACT_TDI_TIPO_DIARIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoTipoDiario implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "TDI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoTipoDiarioGenerator")
    @SequenceGenerator(name = "ActivoTipoDiarioGenerator", sequenceName = "S_ACT_TDI_TIPO_DIARIO")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DD_TBE_ID")
	private DDTipoActivoBDE tipoActivoBDE;
	
	@Column(name = "TIPO_INMUEBLE")
    private String tipoInmueble;   
	 
	@Column(name = "TIPO_DIARIO")
	private String tipoDiario;
	
	@Column(name = "TIPO_DIARIO_DESCRIPCION")
	private String tipoDiarioDescriptcion;
	
	
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

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public DDTipoActivoBDE getTipoActivoBDE() {
		return tipoActivoBDE;
	}

	public void setTipoActivoBDE(DDTipoActivoBDE tipoActivoBDE) {
		this.tipoActivoBDE = tipoActivoBDE;
	}

	public String getTipoInmueble() {
		return tipoInmueble;
	}

	public void setTipoInmueble(String tipoInmueble) {
		this.tipoInmueble = tipoInmueble;
	}

	public String getTipoDiario() {
		return tipoDiario;
	}

	public void setTipoDiario(String tipoDiario) {
		this.tipoDiario = tipoDiario;
	}

	public String getTipoDiarioDescriptcion() {
		return tipoDiarioDescriptcion;
	}

	public void setTipoDiarioDescriptcion(String tipoDiarioDescriptcion) {
		this.tipoDiarioDescriptcion = tipoDiarioDescriptcion;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	
	

}
