package es.capgemini.devon.batch;

import java.util.HashMap;
import java.util.Map;

import org.springframework.batch.core.JobParameters;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.PropertyValues;
import org.springframework.validation.DataBinder;

/**
 * @author Nicolás Cornaglia
 */
public class ParameterBinder {

    public static void bind(Object bean, String bindings, Map<String, Object> properties) {
        if (bindings != null) {
            DataBinder db = new DataBinder(bean);
            PropertyValues pvs = new MutablePropertyValues(properties);
            db.bind(pvs);
        }
    }

    public static void bind(Object bean, String bindings, JobParameters jobParameters) {
        if (bindings != null) {
            String[] parameters = bindings.split(",");
            Map jp = jobParameters.getParameters();
            Map<String, Object> properties = new HashMap<String, Object>();
            for (String p : parameters) {
                String[] splited = p.split("=");
                properties.put(splited[0], jp.get(splited[1]));
            }
            bind(bean, bindings, properties);
        }
    }

}
