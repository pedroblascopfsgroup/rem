package es.capgemini.pfs.web.genericForm;

import java.io.Serializable;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public class GenericForm implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;

    private Long plazo;

    private String codigo;

    private String htmlCabecera;

    private List<GenericFormItem> items;

    private TareaExterna tareaExterna;

    private String errorValidacion;

    private String view = "generico/genericForm";

    public void setView(String view) {
        if (!StringUtils.isBlank(view)) this.view = view;
    }

    //
    /*
    	public static GenericForm getFakeGenericForm() {
    		GenericForm gf = new GenericForm();
    		List<GenericFormItem> items = new ArrayList<GenericFormItem>();
    		items
    				.add(GenericFormItem
    						.getInstance(
    								0,
    								"app.botones.rechazar",
    								"<div style=\\'font-size:10pt;margin-bottom:10px\\'><b>Formulario din�mico</b><br/>Este texto sale del campo html de la definici�n de la tarea</div>",
    								"label", "", "", ""));
    		items.add(GenericFormItem.getInstance(1, "app.botones.aceptar", "start", "text", "", "", "solvencia.error.carga"));
    		items.add(GenericFormItem.getInstance(2, "app.botones.cancelar", "1", "number", "", "parseFloat(value)>0",
    				"antecedente.error.numreincidencias"));
    		items.add(GenericFormItem.getInstance(3, "app.botones.aceptar", "event1", "text", "", "", ""));
    		items.add(GenericFormItem.getInstance(4, "app.botones.aceptar", "10/10/2008", "date", "", "",
    				"menu.clientes.consultacliente.contratosTab.diasirr"));
    		items.add(GenericFormItem.getInstance(5, "app.botones.rechazar", "10/10/2008", "date", "", "", ""));
    		items
    				.add(GenericFormItem
    						.getInstance(
    								6,
    								"app.botones.rechazar",
    								"<div style=\\'font-size:10pt;margin-bottom:10px\\'><b>Formulario din�mico</b><br/>Este texto sale del campo html de la definici�n de la tarea</div>",
    								"label", "", "", ""));
    		items.add(GenericFormItem.getInstance(7, "app.botones.rechazar", "1", "combo", "asuntosManager.getEstadosAsuntos", "value!=null", ""));
    		items.add(GenericFormItem.getInstance(8, "app.botones.rechazar", "1", "combo", "asuntosManager.getEstadosAsuntos", "value!=null",
    				"menu.clientes.consultacliente.contratosTab.diasirr"));
    		items.add(GenericFormItem.getInstance(9, "app.botones.cancelar", "5", "number", "", "parseFloat(value)>3",
    				"antecedente.error.numreincidencias"));

    		String header = "";
    		String title = "Tarea de gestión ";
    		gf.setItems(items);
    		// gf.setTitle(title);
    		// gf.setHeader(header);
    		return gf;
    	}
    */
    public String getView() {
        return view;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getPlazo() {
        return plazo;
    }

    public void setPlazo(Long plazo) {
        this.plazo = plazo;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getHtmlCabecera() {
        return htmlCabecera;
    }

    public void setHtmlCabecera(String htmlCabecera) {
        this.htmlCabecera = htmlCabecera;
    }

    public List<GenericFormItem> getItems() {
        return items;
    }

    public void setItems(List<GenericFormItem> items) {
        this.items = items;
    }

    public void setTareaExterna(TareaExterna tareaExterna) {
        this.tareaExterna = tareaExterna;
    }

    public TareaExterna getTareaExterna() {
        return tareaExterna;
    }

    public void setErrorValidacion(String errorValidacion) {
        this.errorValidacion = errorValidacion;
    }

    public String getErrorValidacion() {
        return errorValidacion;
    }

}
