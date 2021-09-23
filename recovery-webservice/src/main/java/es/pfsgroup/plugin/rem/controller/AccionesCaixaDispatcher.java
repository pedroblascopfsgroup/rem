package es.pfsgroup.plugin.rem.controller;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoAccionCaixaReturn;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

public class AccionesCaixaDispatcher {

    private static final Log logger = LogFactory.getLog(ActivoControllerDispatcher.class);

    private AccionesCaixaController controller;

    public AccionesCaixaDispatcher(AccionesCaixaController c) {
        if (c == null) {
            throw new IllegalArgumentException("NULL controller");
        }
        this.controller = c;
    }

    public Boolean dispatchAccion(JSONObject json, String accion) {
        Boolean resultado = false;

        if ((json != null) && accion != null) {
            JSONArray modelsArray = json.getJSONArray("dto");
            JSONObject model = (JSONObject) modelsArray.get(0);

            AccionesCaixaControllerDispachableMethods methods = new AccionesCaixaControllerDispachableMethods(controller);
            AccionesCaixaControllerDispachableMethods.DispachableMethod method = methods.findDispachableMethod(accion);
            if (method != null) {
                resultado = method.execute(createFromJson(method.getArgumentType(), model));
            }

            if(!resultado){
                throw new IllegalArgumentException("DTO incorrecto para la acción solicitada");
            }

        } else {
            throw new IllegalArgumentException("missing properties in json ('accion' and 'dto' are requiered)");
        }

        return resultado;
    }

    public static <T> T createFromJson(Class<T> clazz, JSONObject json) {
        T dto;
        try {
            dto = clazz.newInstance();
            if (dto instanceof JSONObject){
                return (T) json;
            }
            for (Field f : getAllFields(new LinkedList<Field>(), clazz)) {
                if (json.containsKey(f.getName())) {
//					if ("idsMotivo".equals(f.getName()))
//						f.setAccessible(true);
                    f.setAccessible(true);
                    f.set(dto, convertToType(f.getType(), json.get(f.getName())));
                }
            }
        } catch (Exception e) {
            logger.error("Cannot create " + clazz.getSimpleName() + " from JSON", e);
            throw new RuntimeException(e);
        }
        return dto;
    }

    private static Object convertToType(Class<?> type, Object object) {
        Object value = null;
        if (object != null) {
            try {
                if (String.class.isAssignableFrom(type)) {
                    value = object.toString();
                } else if (Date.class.isAssignableFrom(type)) {
                    SimpleDateFormat formatter = new  SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                    if(!Checks.esNulo(object) && !Checks.esNulo(object.toString())) {
                        value = (object instanceof Date) ? (Date) object : formatter.parse(object.toString());
                    }
                }  else if (Integer.class.isAssignableFrom(type)) {
                    value = Integer.parseInt(object.toString());
                } else if (Long.class.isAssignableFrom(type)) {
                    value = Long.parseLong(object.toString());
                } else if (Boolean.class.isAssignableFrom(type)) {
                    value = Boolean.parseBoolean(object.toString());
                } else if (Double.class.isAssignableFrom(type)) {
                    value = Double.parseDouble(object.toString());
                } else if (List.class.isAssignableFrom(type)) {
                    value = (List<?>) object;
                }
            } catch (Exception e) {
                logger.warn("No se va a setear el valor", e);
            }
        }
        return value;
    }

    private static List<Field> getAllFields(List<Field> fields, Class<?> type) {
        fields.addAll(Arrays.asList(type.getDeclaredFields()));

        if (type.getSuperclass() != null) {
            getAllFields(fields, type.getSuperclass());
        }

        return fields;
    }

}
