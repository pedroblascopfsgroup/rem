package es.capgemini.pfs.ruleengine.rule;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.validation.ErrorMessage;
import es.capgemini.devon.validation.Severity;
import es.capgemini.devon.validation.ValidationException;

/**
 * @author lgiavedo
 *
 */
public abstract class Rule {

    public static final String OPERATOR_EQUAL = "equal";
    public static final String OPERATOR_NOT_EQUAL = "notEqual";
    public static final String OPERATOR_LIKE = "like";
    public static final String OPERATOR_NOT_LIKE = "notLike";
    public static final String OPERATOR_GREATER_THAN = "greaterThan";
    public static final String OPERATOR_LESS_THAN = "lessThan";
    public static final String OPERATOR_BETWEEN = "between";
    public static final String OPERATOR_NOT_BETWEEN = "notBetween";
    public static final String OPERATOR_NULL = "null";
    public static final String OPERATOR_NOT_NULL = "notNull";

    private List<String> values;
    private String data;
    private String format;

    public static final String FORMAT_NUMBER = "number";
    public static final String FORMAT_DATE = "date";
    public static final String FORMAT_DATE_TIME = "dateTime";
    public static final String FORMAT_TEXT = "text";

    /**
     * @return string
     */
    public abstract String generateSQL();

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * TODO DOCUMENTAR FO.
     */
    public Rule() {
        super();
        values = new ArrayList<String>();
    }

    public String getValue() {
        return values.get(0);
    }

    public List<String> getValues() {
        return values;
    }

    protected String formatValue(String data) {
        if (isFormatNumber()) {
            return "TO_NUMBER('" + data + "')";
        }

        if (isFormatDate()) {
            return "TO_DATE('" + data + "', 'DD/MM/YYYY' )";
        }

        if (isFormatDateTime()) {
            return "TO_TIMESTAMP('" + data + "', 'DD-MM-YYYY HH24:MI:SS.FF')";
        }
        
        if (isFormatText()) {
        	return "'" + data + "'";
        }

        return data;
    }

    protected void checkValueFormat(String data) {
        List<ErrorMessage> errores = new ArrayList<ErrorMessage>();
        if (isFormatNumber()) {
            if (!Pattern.matches("[0-9]*(,[0-9][0-9]?)?", data)) {
                errores.add(new ErrorMessage(this, "El valor: " + data + " no cumple con el formato de Numero correcto.", Severity.ERROR));
            }
        }
        if (isFormatDate()) {
            if (!Pattern.matches("[0-9][0-9]?/[0-9][0-9]?/[0-9]{4}", data)) {
                errores.add(new ErrorMessage(this, "El valor: " + data + " no cumple con el formato de Fecha.", Severity.ERROR));
            }
        }

        if (isFormatDateTime()) {
            if (!Pattern.matches("[0-9][0-9]?/[0-9][0-9]?/[0-9]{4} [0-9][0-9]?:[0-9][0-9]?(:[0-9][0-9]?)?", data)) {
                errores.add(new ErrorMessage(this, "El valor: " + data + " no cumple con el formato de Fecha y Hora.", Severity.ERROR));
            }
        }

        if (errores.size() > 0) {
            logger.error(errores.toString());
            throw new ValidationException(errores);
        }
    }

    /**
     * TODO DOCUMENTAR FO.
     * @return string
     */
    public String getValueFormated() {
        return formatValue(getValue());
    }

    public void addValue(String value) {
        checkValueFormat(value);
        values.add(value);
    }

    /**
     * TODO DOCUMENTAR FO.
     * @return string
     */
    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    /**
     * @return the format
     */
    public String getFormat() {
        return format;
    }

    /**
     * @param type the type to set
     */
    public void setFormat(String format) {
        this.format = format;
        if (!(isFormatDate() || isFormatDateTime() || isFormatNumber() || isFormatText())) {
            List<ErrorMessage> errores = new ArrayList<ErrorMessage>();
            errores.add(new ErrorMessage(this, "El formato: " + format + " no es valido! Los tipos validos son [" + FORMAT_DATE + ", "
                    + FORMAT_DATE_TIME + ", " + FORMAT_NUMBER + ", " + FORMAT_TEXT + "]", Severity.ERROR));
            logger.error(errores.get(0));
            throw new ValidationException(errores);
        }
        this.format = format;
    }

    public boolean isFormatNumber() {
        return FORMAT_NUMBER.equals(format);
    }

    public boolean isFormatDate() {
        return FORMAT_DATE.equals(format);
    }

    public boolean isFormatDateTime() {
        return FORMAT_DATE_TIME.equals(format);
    }

    public boolean isFormatText() {
        return FORMAT_TEXT.equals(format);
    }
}
