

package es.pfsgroup.plugin.rem.model.dd;

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
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.commons.utils.Checks;

/**
 * Modelo que gestiona el diccionario de tipos de gastos
 */
@Entity
@Table(name = "DD_STG_SUBTIPOS_GASTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubtipoGasto implements Auditable, Dictionary {
	
    public static final String OTROS = "01";

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_STG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubTipoGastoGenerator")
	@SequenceGenerator(name = "DDSubTipoGastoGenerator", sequenceName = "S_DD_STG_SUBTIPOS_GASTO")
	private Long id;
	
	@JoinColumn(name = "DD_TGA_ID")  
    @ManyToOne(fetch = FetchType.LAZY)
	private DDTipoGasto tipoGasto;
	    
	@Column(name = "DD_STG_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_STG_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_STG_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Transient
	private String tipoGastoCodigo;
	    
	
	    
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

	public DDTipoGasto getTipoGasto() {
		return tipoGasto;
	}

	public void setTipoGasto(DDTipoGasto tipoGasto) {
		this.tipoGasto = tipoGasto;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getTipoGastoCodigo() {
		return !Checks.esNulo(tipoGasto) ? this.tipoGastoCodigo = tipoGasto.getCodigo(): null;
	}

	public void setTipoGastoCodigo(String tipoGastoCodigo) {
		this.tipoGastoCodigo = !Checks.esNulo(tipoGastoCodigo) ? tipoGastoCodigo : tipoGasto.getCodigo();
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



