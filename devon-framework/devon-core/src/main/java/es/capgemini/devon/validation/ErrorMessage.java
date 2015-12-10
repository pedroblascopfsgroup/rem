package es.capgemini.devon.validation;

import java.io.Serializable;

import org.springframework.core.style.ToStringCreator;

public class ErrorMessage implements Serializable {
    private Object source;
    private String text;
    private Severity severity;
    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    public ErrorMessage(Object source, String text, Severity severity) {
        this.source = source;
        this.text = text;
        this.severity = severity;
    }

    public Object getSource() {
        return source;
    }

    public String getText() {
        return text;
    }

    public Severity getSeverity() {
        return severity;
    }

    public String toString() {
        return (new ToStringCreator(this)).append("severity", severity).append("text", text).toString();
    }
}
