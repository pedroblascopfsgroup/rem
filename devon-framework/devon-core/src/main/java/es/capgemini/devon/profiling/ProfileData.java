package es.capgemini.devon.profiling;

/**
 * @author Nicolás Cornaglia
 */
public class ProfileData {

    private long startTime;

    private String label;
    private String arguments;
    private long time;

    public ProfileData(String label, String arguments, long time) {
        this.label = label;
        this.arguments = arguments;
        this.time = time;
        this.startTime = System.currentTimeMillis();
    }

    public String getLabel() {
        return label;
    }

    public String getArguments() {
        return arguments;
    }

    public long getTime() {
        return time;
    }

    public long getStartTime() {
        return startTime;
    }

    @Override
    public String toString() {
        return "label=" + label + ",arguments=" + arguments + ",time=" + time;
    }

}
