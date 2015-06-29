package es.capgemini.pfs.integration;

import java.util.UUID;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import es.pfsgroup.commons.utils.Checks;

@Embeddable
public class Guid {

	@Column(name = "SYS_GUID")
	private String valor;

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}
	
    public static Guid getNewInstance() {
    	Guid guid = new Guid();
    	guid.setValor(UUID.randomUUID().toString());
		return guid;
	}

    public static Guid getNewInstance(String valor) {
    	Guid guid = new Guid();
    	if (Checks.esNulo(valor)) {
    		guid.setValor(UUID.randomUUID().toString());
    	} else {
    		guid.setValor(valor);
    	}
		return guid;
	}
    
}
