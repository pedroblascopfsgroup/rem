package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;

@Component
public class UpdaterServiceActuacionTecnicaEleccionProveedor implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
	private static final String CODIGO_T004_ELECCION_PROVEEDOR = "T004_EleccionProveedorYTarifa";
	
	private static final String FECHA_EMISION = "fechaEmision";
	
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		Trabajo trabajo = tramite.getTrabajo();
		
		for(TareaExternaValor valor :  valores){

			if(FECHA_EMISION.equals(valor.getNombre())){
				try {
					trabajo.setFechaEleccionProveedor(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
			
		}
		genericDao.save(Trabajo.class, trabajo);
	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T004_ELECCION_PROVEEDOR};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
