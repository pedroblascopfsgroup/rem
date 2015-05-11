package es.pfsgroup.commons.utils.test.web.dto.factory.DTOFactory;

import es.pfsgroup.commons.utils.web.dto.extensible.ExtensibleDto;

/**
 * DTO  creado sólo para propósitos del test
 * @author bruno
 *
 */
public class DTOEjemplo extends ExtensibleDto{
    
    private String nullString;
    
    private String stringProperty;
    
    private Long longProperty;
    
    private Integer integerProperty;

    public String getNullString() {
        return nullString;
    }

    public void setNullString(String nullString) {
        this.nullString = nullString;
    }

    public String getStringProperty() {
        return stringProperty;
    }

    public void setStringProperty(String stringProperty) {
        this.stringProperty = stringProperty;
    }

    public Long getLongProperty() {
        return longProperty;
    }

    public void setLongProperty(Long longProperty) {
        this.longProperty = longProperty;
    }

    public Integer getIntegerProperty() {
        return integerProperty;
    }

    public void setIntegerProperty(Integer integerProperty) {
        this.integerProperty = integerProperty;
    }

}
