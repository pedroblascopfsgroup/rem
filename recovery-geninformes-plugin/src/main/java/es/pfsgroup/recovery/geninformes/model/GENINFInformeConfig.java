package es.pfsgroup.recovery.geninformes.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

/**
 * Clase de con datos de configuración de informes
 * @author pedro
 *
 */
@Entity
@Table(name = "CFI_CONFIGURACION_INFORMES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class GENINFInformeConfig implements Serializable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = -1224479298382584866L;

	@Id
	@Column(name = "CFI_CODIGO")
	private String codigo;
    
    @Column(name = "CFI_VALOR")
    private String valor;

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}

}
