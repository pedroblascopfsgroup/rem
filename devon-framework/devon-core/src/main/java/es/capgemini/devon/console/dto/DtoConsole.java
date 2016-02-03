package es.capgemini.devon.console.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * @author Nicolás Cornaglia
 */
public class DtoConsole extends WebDto {

    private String name;

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

}
