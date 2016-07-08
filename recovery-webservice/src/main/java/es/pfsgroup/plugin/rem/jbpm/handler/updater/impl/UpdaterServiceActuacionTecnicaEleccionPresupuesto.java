package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;

@Component
public class UpdaterServiceActuacionTecnicaEleccionPresupuesto implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
	private static final String CODIGO_T004_ELECCION_PRESUPUESTO = "T004_EleccionPresupuesto";
	
	private static final String FECHA_ELECCION = "fechaEmision";
	
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		Trabajo trabajo = tramite.getTrabajo();
		
		for(TareaExternaValor valor :  valores){

			if(FECHA_ELECCION.equals(valor.getNombre())){
				try {
					trabajo.setFechaEleccionProveedor(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
			
		}

	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T004_ELECCION_PRESUPUESTO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
