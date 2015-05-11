package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "V_BUSQUEDA_ASUNTOS_FILTRO_AGEN", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class BusquedaAsuntosFiltroAgendaBean  implements Serializable {

	/**
	 * SERIAL UID
	 */
	private static final long serialVersionUID = 1222152169452481334L;

	@Id
	@Column(name = "ASU_ID")
	private Long id;
	
	@Column(name = "USU_USERNAME")
	private String usu_username;
	
	@Column(name = "DD_TRG_CODIGO")
	private String dd_trg_codigo;
	
	@Column(name = "IRG_CLAVE")
	private String irg_clave;
	
	@Column(name = "IRG_VALOR")
	private String irg_valor;
	
	@Column(name = "TAR_EMISOR")
	private String tar_emisor;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getUsu_username() {
		return usu_username;
	}

	public void setUsu_username(String usu_username) {
		this.usu_username = usu_username;
	}

	public String getDd_trg_codigo() {
		return dd_trg_codigo;
	}

	public void setDd_trg_codigo(String dd_trg_codigo) {
		this.dd_trg_codigo = dd_trg_codigo;
	}

	public String getIrg_clave() {
		return irg_clave;
	}

	public void setIrg_clave(String irg_clave) {
		this.irg_clave = irg_clave;
	}

	public String getIrg_valor() {
		return irg_valor;
	}

	public void setIrg_valor(String irg_valor) {
		this.irg_valor = irg_valor;
	}

	public String getTar_emisor() {
		return tar_emisor;
	}

	public void setTar_emisor(String tar_emisor) {
		this.tar_emisor = tar_emisor;
	}

}
