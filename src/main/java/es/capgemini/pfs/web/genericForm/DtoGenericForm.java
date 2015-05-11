package es.capgemini.pfs.web.genericForm;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.scripting.ScriptingUtils;

public class DtoGenericForm extends WebDto {

    private static final String OK_VALUE = "true";
    private static final long serialVersionUID = 1L;

    /** El objeto que contiene la definiciÃ³n del formulario. Nos servirÃ¡ para poder hacer referencia a Ã©l dentro del script de validaciÃ³n de los
     * elementos del formulario.
     * 
     * Este objeto se debe inyectar desde el webflow
     */
    private GenericForm form;

    /** Array de valores que vendrÃ¡ desde el formulario generado dinÃ¡micamente
     */
    private String[] values; // =new String[100];

    /** Ejecuta la validaciÃ³n de uno de los elementos del formulario
     * @param item
     * @return
     */
    private Object validateItem(GenericFormItem item) {
        if (StringUtils.isBlank(item.getValidation())) { return OK_VALUE; }
        Map<String, Object> context = new HashMap<String, Object>();
        context.put("form", form);
        context.put("valor", getValues()[item.getOrder()]);
        context.put("valores", getValues());
        return ObjectUtils.toString(ScriptingUtils.getEvaluator().evaluate(item.getValidation(), context));

    }

    /** Este mÃ©todo se ejecuta al intenar salir del estado "formulario" del flow de pantallas genÃ©ricas
     * @param messageContext
     */
    public void validateFormulario(MessageContext messageContext) {
        for (GenericFormItem item : form.getItems()) {
            Object result = validateItem(item);
            if (!OK_VALUE.equals(result)) {
                messageContext.addMessage(new MessageBuilder().code(item.getValidationError()).error().source("values[" + item.getOrder() + "]")
                        .defaultText("**Error validacion dinamica.").build());
            }
        }
        addValidation("ss", messageContext, "excluidos").addValidation(this, messageContext).validate();
    }

    public void setForm(GenericForm form) {
        this.form = form;
        this.setValues(new String[form.getItems().size()]);
    }

    public GenericForm getForm() {
        return form;
    }

    public void setValues(String[] values) {
        this.values = values;
    }

    public String[] getValues() {
        return values;
    }

}
