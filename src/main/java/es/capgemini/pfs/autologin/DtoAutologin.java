package es.capgemini.pfs.autologin;

import es.capgemini.devon.dto.WebDto;

public class DtoAutologin extends WebDto {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    private String action;
    private String[] args = new String[20];

    public void setAction(String action) {
        this.action = action;
    }

    public String getAction() {
        return action;
    }

    public void setArgs(String[] args) {
        this.args = args;
    }

    public String[] getArgs() {
        return args;
    }

}
