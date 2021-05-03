package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

/**
 * Modelo que gestiona la tabla Auxiliar de Cierre Oficinas Bankia
 * 
 * @author Hector Crespo
 */

@Entity
@Table(name = "APR_AUX_CIE_OFI_BNK_MUL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class AuxiliarCierreOficinasBankiaMul implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "CIEOFI_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "AuxCierreOficinasBankiaMulGenerator")
	@SequenceGenerator(name = "AuxCierreOficinasBankiaMulGenerator", sequenceName = "S_APR_AUX_CIE_OFI_BNK_MUL")
	private Long id;

	@Column(name = "OFI_SALIENTE")
	private String oficinaSaliente;

	@Column(name = "OFI_ENTRANTE")
	private String oficinaEntrante;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getOficinaSaliente() {
		return oficinaSaliente;
	}

	public void setOficinaSaliente(String oficinaSaliente) {
		this.oficinaSaliente = oficinaSaliente;
	}

	public String getOficinaEntrante() {
		return oficinaEntrante;
	}

	public void setOficinaEntrante(String oficinaEntrante) {
		this.oficinaEntrante = oficinaEntrante;
	}

}
