package es.pfsgroup.recovery.integration;

import java.util.UUID;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import es.pfsgroup.commons.utils.Checks;

@Embeddable
public class Guid {

	private static final CharSequence GUID_SEPARATOR = "-";
	private static final CharSequence EMPTY_STRING = "";
	
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
    	guid.setValor(UUID.randomUUID().toString().replace(GUID_SEPARATOR, EMPTY_STRING).toUpperCase());
		return guid;
	}

    public static Guid getNewInstance(String valor) {
    	if (Checks.esNulo(valor)) {
    		return null;
    	} else {
    		Guid guid = new Guid();
    		guid.setValor(valor);
    		return guid;
    	}
	}
    
    @Override
    public String toString() {
    	return (this.getValor()!=null) ? this.getValor() : super.toString();
    }
}
