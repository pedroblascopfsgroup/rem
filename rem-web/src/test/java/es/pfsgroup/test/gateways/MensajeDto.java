package es.pfsgroup.test.gateways;

import java.io.Serializable;

public class MensajeDto implements Serializable {
	
	private static final long serialVersionUID = 4584494082963180395L;
	private String text;

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

}
