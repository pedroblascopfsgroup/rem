package es.capgemini.devon.utils.enums;

/**
 * Enum support for "code"
 * 
 * @author Nicol�s Cornaglia
 */
public interface CodableEnum {

    public String getCode();

    public CodableEnum getByCode(String code);

}
