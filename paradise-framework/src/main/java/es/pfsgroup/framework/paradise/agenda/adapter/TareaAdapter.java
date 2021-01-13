package es.pfsgroup.framework.paradise.agenda.adapter;


import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.pfsgroup.framework.paradise.agenda.dao.TareaDao;

@Service
public class TareaAdapter {
	
	private static final String URL = "endpoint.haya.existe.endpoint";
	private static final String PORT = "edpoint.haya.existe.tarea.port";
	private static final String SERVICE = "endpoint.haya.existe.tarea.service";
	public static final String DEV = "DEV";
	
	@Resource
	private Properties appProperties;
    
    @Autowired
    private TareaDao tareaDao;	
    
    
    public Object findOne(Long id) {
    	return tareaDao.findOne(id);
    }
       
    public void saveForm (DtoGenericForm dto) {
        String[] valores = dto.getValues();
        GenericForm form = dto.getForm();
        
        List<TareaExternaValor> listaTareas = generateTareaExternaValor(form, valores);
        tareaDao.save(listaTareas);
    }
    
    public void advance (TareaExterna tarea) {
        tareaDao.advance(tarea);
    }
	
    private List<TareaExternaValor> generateTareaExternaValor(GenericForm form, String[] valores) {
    	TareaExterna tarea = form.getTareaExterna();
        List<TareaExternaValor> listaValores = new ArrayList<TareaExternaValor>();
        for (int i = 0; i < valores.length; i++) {
            GenericFormItem item = form.getItems().get(i);
            TareaExternaValor valor = new TareaExternaValor();
            valor.setTareaExterna(tarea);
            valor.setNombre(item.getNombre());
            valor.setValor(valores[i]);
            listaValores.add(valor);
        }
        return listaValores;
    }


	public String getExisteTareaHayaEndpoint() {
		String url = appProperties.getProperty(URL);
		String port = appProperties.getProperty(PORT);
		String service = appProperties.getProperty(SERVICE);
		if ( url == null || port == null || service == null ) {
			return DEV;
		} else {
			return String.format("%s%s%s",url, port,service);
		}
	}

}
