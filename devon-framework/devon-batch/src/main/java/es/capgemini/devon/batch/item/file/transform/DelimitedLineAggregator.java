package es.capgemini.devon.batch.item.file.transform;

import org.springframework.batch.item.file.mapping.FieldSet;
import org.springframework.batch.item.file.transform.LineAggregator;

/**
 * Class used to create string representing object. Values are separated by
 * defined delimiter.
 * 
 * Agregado de "stringDelimiter" para rodear los campos String
 * Agregado de "stringFields" para marcar los campos que son de tipo String
 * 
 * @author tomas.slanina
 * @author Nicolás Cornaglia
 * 
 */
public class DelimitedLineAggregator implements LineAggregator {

    private int maxFields = 100;
    private String delimiter = ",";
    private String stringDelimiter = "\"";
    private String stringDelimiterEscaped = "'";

    Boolean[] fields = new Boolean[maxFields];

    /**
     * Method used to create string representing object.
     * 
     * @param fieldSet arrays of strings representing data to be stored
     */
    public String aggregate(FieldSet fieldSet) {
        StringBuffer buffer = new StringBuffer();
        String[] args = fieldSet.getValues();
        for (int i = 0; i < args.length; i++) {
            if (i < maxFields && fields[i]) {
                buffer.append(stringDelimiter).append(args[i].replaceAll(stringDelimiter, stringDelimiterEscaped)).append(stringDelimiter);
            } else {
                buffer.append(args[i]);
            }

            if (i != (args.length - 1)) {
                buffer.append(delimiter);
            }
        }

        return buffer.toString();
    }

    public void setDelimiter(String delimiter) {
        this.delimiter = delimiter;
    }

    public void setStringDelimiter(String stringDelimiter) {
        this.stringDelimiter = stringDelimiter;
    }

    public void setStringDelimiterEscaped(String stringDelimiterEscaped) {
        this.stringDelimiterEscaped = stringDelimiterEscaped;
    }

    /**
     * @param stringFields the stringFields to set
     */
    public void setStringFields(String stringFields) {
        for (int i = 0; i < fields.length; i++) {
            fields[i] = false;
        }
        String[] splited = stringFields.split(",");
        for (String s : splited) {
            fields[Integer.parseInt(s)] = true;
        }
    }

}