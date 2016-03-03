package es.pfsgroup.plugins.web.menu;

import es.capgemini.devon.web.DynamicElementAdapter;

public class ElementoDinamicoPorLogica extends DynamicElementAdapter {

	private static final long serialVersionUID = -6196192069381898890L;

	private DynamicElementLogic logica;

	@Override
	public boolean valid(Object param) {
		return logica.validar();
	}

	public void setLogica(DynamicElementLogic logica) {
		this.logica = logica;
	}
	
}
