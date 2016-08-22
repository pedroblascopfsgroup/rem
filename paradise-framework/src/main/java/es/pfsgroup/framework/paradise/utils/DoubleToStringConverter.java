package es.pfsgroup.framework.paradise.utils;


import java.text.NumberFormat;

import org.apache.commons.beanutils.ConversionException;
import org.apache.commons.beanutils.Converter;


public final class DoubleToStringConverter implements Converter {


    // ----------------------------------------------------------- Constructors


    /**
     * Create a {@link Converter} that will throw a {@link ConversionException}
     * if a conversion error occurs.
     */
    public DoubleToStringConverter() {

        this.defaultValue = null;
        this.useDefault = false;

    }


    /**
     * Create a {@link Converter} that will return the specified default value
     * if a conversion error occurs.
     *
     * @param defaultValue The default value to be returned
     */
    public DoubleToStringConverter(Object defaultValue) {

        this.defaultValue = defaultValue;
        this.useDefault = true;

    }


    // ----------------------------------------------------- Instance Variables


    /**
     * The default value specified to our Constructor, if any.
     */
    private Object defaultValue = null;


    /**
     * Should we return the default value on conversion errors?
     */
    private boolean useDefault = true;


    // --------------------------------------------------------- Public Methods


    /**
     * Convert the specified input object into an output object of the
     * specified type.
     *
     * @param type Data type to which this value should be converted
     * @param value The input value to be converted
     *
     * @exception ConversionException if conversion cannot be performed
     *  successfully
     */
    public Object convert(Class type, Object value) {

        if (value == null) {
            if (useDefault) {
                return (defaultValue);
            } else {
                throw new ConversionException("No value specified");
            }
        }

        if (value instanceof String) {
            return (value);
        } else if(value instanceof Number) {
        	NumberFormat f = NumberFormat.getInstance();
        	f.setGroupingUsed(false);
        	f.setMaximumFractionDigits(2);
            f.setMinimumFractionDigits(2);
            return new String(f.format(((Number)value).doubleValue()));
        }
            

        try {
        	NumberFormat f = NumberFormat.getInstance();
        	f.setGroupingUsed(false);
        	f.setMaximumFractionDigits(2);
            f.setMinimumFractionDigits(2);
            return (new String(f.format(value)));
        } catch (Exception e) {
            if (useDefault) {
                return (defaultValue);
            } else {
                throw new ConversionException(e);
            }
        }

    }


}
