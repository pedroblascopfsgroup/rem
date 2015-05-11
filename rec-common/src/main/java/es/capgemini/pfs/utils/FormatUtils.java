package es.capgemini.pfs.utils;

import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import es.capgemini.devon.bo.BusinessOperationException;

/**
 * Clase con métodos encargados de realizar formateo de fechas y números.
 * @author mtorrado
 */
public class FormatUtils {

    /**
     * Formato de fecha latinoamericano, ej. <code>01/09/2009</code>.
     */
    public static final String DDMMYYYY = "dd/MM/yyyy";

    /**
     * Formato de fecha en texto latinoamericano, ej. <code>1 de septiembre de 2009</code>.
     */
    public static final String DD_DE_MES_DE_YYYY = "d 'de' MMMM 'de' yyyy";

    /**
     * Máscara de formato moneda para {@link DecimalFormat}, ej. <code>1.587,80</code>.
     */
    public static final String FORMATO_MONEDA = "#,##0.00";

    /**
     * Símbolo del EURO.
     */
    public static final String EURO = "\u20AC";

    /**
     * Método que recibe una fecha en formato String y la devuelve en formato Date.
     * @param fecha String
     * @param mascara String: Formato de la fecha a transformar, ej. <code>yyyy-MM-dd</code>
     * @return date
     */
    public static Date strADate(String fecha, String mascara) {

        Date date = null;
        SimpleDateFormat df = new SimpleDateFormat(mascara);
        try {
            date = df.parse(fecha);
        } catch (ParseException e) {
            new BusinessOperationException("error.parse.fecha");
        }
        return date;
    }

    /**
     * Retorna la misma fecha pero sin la información de la hora (o sea con hora 00:00).
     * @param d Date
     * @return Date
     */
    public static Date fechaSinHora(Date d) {
        SimpleDateFormat sd = new SimpleDateFormat(DDMMYYYY);
        Date fecha = null;
        try {
            fecha = sd.parse(sd.format(d));
        } catch (ParseException e) {
            throw new BusinessOperationException("Error al formatear una fecha");
        }
        return fecha;
    }

    /**
     * Retorna el porcentaje de num sobre el total, pero redondeado el resultado hasta 2 decimales.
     * @param num double: número
     * @param total double: total sobre el que se calcula el porcentaje
     * @return double: resultado con decimales redondeados hasta el segundo dígito
     */
    public static double porcentajeRedendeado(double num, double total) {
        if (num == 0.0 && total == 0.0) { return redondear(0.0, 2); }
        final double CIEN_PORCIENTO = 100.0;
        return redondear(num / total * CIEN_PORCIENTO, 2);
    }

    /**
     * Retorna un número hasta una determinada cantidad de decimales redondeandolo.
     * @param numero double
     * @param decimales double
     * @return double
     */
    public static double redondear(double numero, int decimales) {
        double resultado;
        BigDecimal res;

        res = new BigDecimal(numero).setScale(decimales, BigDecimal.ROUND_HALF_DOWN);
        resultado = res.doubleValue();
        return resultado;
    }

    /**
     * Retorna el porcentaje como string en el formato <code>##.### %</code>.
     * @param n double
     * @param total double
     * @return String
     */
    public static String formatoPorcentaje(Double n, Double total) {
        DecimalFormat pf = new DecimalFormat("##.### %");
        if (total == 0) { return pf.format(0); }
        return pf.format(n / total);
    }

    /**
     * Recorre toda la lista he invoca por cada elemento el método <code>name</code>, y concatena
     * en un <code>String</code> el resultado de cada uno separados por coma.
     * @param list List: lista de objetos
     * @param name String: nombre del método
     * @return String
     * @throws Exception e
     */
    @SuppressWarnings("unchecked")
    public static String objectListToString(List list, String name) throws Exception {
        String text = "";
        Class c = list.get(0).getClass();
        Class params[] = {};
        Object paramsObj[] = {};
        Method method = c.getDeclaredMethod(name, params);
        for (Object obj : list) {
            if (!text.equals("")) {
                text += ", ";
            }
            text += method.invoke(obj, paramsObj).toString();
        }
        return text;
    }
}
