package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;


@Entity
@Table(name = "VI_BUSQUEDA_PLUSVALIA", schema = "${entity.schema}")
public class VPlusvalia implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name= "ACT_PLS_ID")
	private Long plusvalia;
	
	@Column(name = "ACT_NUM_ACTIVO")
	private Long activo;
	
	@Column(name = "ACT_ID")
	private Long idActivo;
	
	@Column(name = "DD_CRA_DESCRIPCION")
	private String cartera;
	
	@Column(name = "DD_TPA_DESCRIPCION")
	private String tipoActivo;
	
	@Column(name = "DD_SAC_DESCRIPCION")
	private String subtipoActivo;
	
	@Column(name = "DD_EAC_DESCRIPCION")
	private String estadoActivo;

    @Column(name = "DD_PRV_CODIGO")
    private String provincia;

	@Column(name = "DD_LOC_CODIGO")
	private String municipio;

	public Long getPlusvalia() {
		return plusvalia;
	}

	public void setPlusvalia(Long plusvalia) {
		this.plusvalia = plusvalia;
	}

	public Long getActivo() {
		return activo;
	}

	public void setActivo(Long activo) {
		this.activo = activo;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public String getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public String getEstadoActivo() {
		return estadoActivo;
	}

	public void setEstadoActivo(String estadoActivo) {
		this.estadoActivo = estadoActivo;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getMunicipio() {
		return municipio;
	}

	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	
}