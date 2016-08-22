package es.pfsgroup.framework.paradise.utils;



import java.text.DateFormat;
import java.text.ParseException;
import java.util.Date;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.util.StringUtils;


/**
 * Clase utilizada para sobreescribir el CustomDateEditor utilizado en el initBinder de los controllers,
 * con el fin de setear a una fecha por defecto aquellas que hayan sido seteadas a vacio en la vista.
 * 
 * @author bguerrero
 *
 */
public class ParadiseCustomDateEditor extends CustomDateEditor {
	
	private final DateFormat dateFormat;

	private final boolean allowEmpty;

	private final int exactDateLength;

	
	public ParadiseCustomDateEditor(DateFormat dateFormat, boolean allowEmpty) {
		super(dateFormat, allowEmpty);
		this.dateFormat = dateFormat;
		this.allowEmpty = allowEmpty;
		this.exactDateLength = -1;
	}

    @Override
    public void setAsText(String text) throws IllegalArgumentException {
		if (this.allowEmpty && !StringUtils.hasText(text)) {
			// Treat empty String as null value.
			//setValue(null);
			setValue(new Date(0L));

			
		} else if (text != null && this.exactDateLength >= 0 && text.length() != this.exactDateLength) {
			throw new IllegalArgumentException(
					"Could not parse date: it is not exactly" + this.exactDateLength + "characters long");
		} else {
			try {
				setValue(this.dateFormat.parse(text));
			}
			catch (ParseException ex) {
				IllegalArgumentException iae =
						new IllegalArgumentException("Could not parse date: " + ex.getMessage());
				iae.initCause(ex);
				throw iae;
			}
		}
	}

}
