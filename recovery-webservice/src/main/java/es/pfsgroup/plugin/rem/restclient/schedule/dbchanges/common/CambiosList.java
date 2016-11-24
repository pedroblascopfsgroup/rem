package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.util.ArrayList;

public class CambiosList extends ArrayList<Object> {

	private static final long serialVersionUID = 5828089068727603743L;
	private Paginacion paginacion = null;

	public CambiosList(Integer tamanyoBloque){
		setPaginacion(new Paginacion(tamanyoBloque));
	}
	
	public Paginacion getPaginacion() {
		return paginacion;
	}

	public void setPaginacion(Paginacion paginacion) {
		this.paginacion = paginacion;
	}
	
}
