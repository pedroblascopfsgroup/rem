package es.capgemini.devon.events.defered;

/**
 * @author Nicolás Cornaglia
 */
public enum DeferedEventState {

    NEW("N"), SENDED("S"), RECEIVED("R");

    private String code;

    DeferedEventState(String code) {
        this.code = code;
    }

    // the valueOfMethod
    public static DeferedEventState fromCode(String code) {
        if ("N".equals(code)) {
            return NEW;
        } else if ("S".equals(code)) {
            return SENDED;
        } else if ("R".equals(code)) {
            return RECEIVED;
        }
        return null;
    }

    public String getCode() {
        return code;
    }

}
