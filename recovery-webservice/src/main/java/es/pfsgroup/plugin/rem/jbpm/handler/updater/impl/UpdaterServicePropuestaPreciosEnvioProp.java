package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class UpdaterServicePropuestaPreciosEnvioProp implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
	private static final String FECHA_ENVIO = "fechaEnvio";
	private static final String CODIGO_T009_ENVIO_PROPUESTA = "T009_EnvioPropuestaPropietario";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		for(TareaExternaValor valor :  valores){

			//Fecha generación
			if(FECHA_ENVIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				//Guardado adicional Fecha generación propuesta => trabajo.propuesta precios ->  Fecha envio
				try {
					tramite.getTrabajo().getPropuestaPrecio().setFechaEnvio(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					e.printStackTrace();
				}

			}
			

		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T009_ENVIO_PROPUESTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
