package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.util.Properties;

import javax.annotation.Resource;

public class Paginacion {
	@Resource
	private Properties appProperties;

	private Boolean hasMore = false;
	private Integer numeroBloque = 0;
	private Integer tamanyoBloque = null;
	private Integer totalFilas = null;

	public Paginacion(Integer tamanyoBloque) {
		this.tamanyoBloque = tamanyoBloque;
	}

	public Integer getTotalFilas() {
		return totalFilas;
	}

	public void setTotalFilas(Integer totalFilas) {
		this.totalFilas = totalFilas;
	}

	public Boolean getHasMore() {
		return hasMore;
	}

	public void setHasMore(Boolean hasMore) {
		this.hasMore = hasMore;
	}

	public Integer getNumeroBloque() {
		return numeroBloque;
	}

	public void setNumeroBloque(Integer numeroBloque) {
		this.numeroBloque = numeroBloque;
	}

	public Integer getTamanyoBloque() {
		return tamanyoBloque;
	}

	public void setTamanyoBloque(Integer tamanyoBloque) {
		this.tamanyoBloque = tamanyoBloque;
	}

}
