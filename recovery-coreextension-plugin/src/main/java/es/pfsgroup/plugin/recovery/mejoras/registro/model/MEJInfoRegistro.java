package es.pfsgroup.plugin.recovery.mejoras.registro.model;

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
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;
import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.registro.ClaveValor;
import es.pfsgroup.commons.utils.Checks;

@Entity
@Table(name = "MEJ_IRG_INFO_REGISTRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class MEJInfoRegistro implements Serializable, Auditable,ClaveValor {

	private static final long serialVersionUID = 2778400362740546479L;
	
	private static final int MAX_SIZE_VALOR_CORTO = 255;

	@Id
	@Column(name = "IRG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "MEJInfoRegistroGenerator")
	@SequenceGenerator(name = "MEJInfoRegistroGenerator", sequenceName = "S_MEJ_IRG_INFO_REGISTRO")
	private Long id;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "REG_ID")
	@NotNull
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private MEJRegistro registro;

	@Column(name = "IRG_CLAVE")
	@NotNull
	@NotEmpty
	private String clave;

	@Column(name = "IRG_VALOR")
	private String valorCorto;

	@Column(name = "IRG_VALOR_CLOB")
	private String valorLargo;
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria=auditoria;
		
	}

	@Override
	public String getClave() {
		return clave;
	}
	
	public void setClave(String clave){
		this.clave=clave;
	}

	public String getValorLargo() {
		return valorLargo;
	}

	public void setValorLargo(String valorLargo) {
		this.valorLargo = valorLargo;
	}
	
	@Override
	public String getValor() {
		if (Checks.esNulo(valorLargo)) {
			return this.valorCorto;
		} else {
			return this.valorLargo;
		}
	}
	
	public void setValor(String v) {
		if (Checks.esNulo(v))
			return;
		
		if (MAX_SIZE_VALOR_CORTO < v.length()){
			this.valorLargo = v;
		}else{
			this.valorCorto = v;
		}
		
	}
	
	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setRegistro(MEJRegistro registro) {
		this.registro = registro;
	}

	public MEJRegistro getRegistro() {
		return registro;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

}
