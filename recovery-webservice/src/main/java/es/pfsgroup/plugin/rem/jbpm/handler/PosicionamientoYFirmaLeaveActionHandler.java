package es.pfsgroup.plugin.rem.jbpm.handler;

import java.io.IOException;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.tareasactivo.TareaActivoManager;

public class PosicionamientoYFirmaLeaveActionHandler extends ActivoGenericLeaveActionHandler {
	
	
	@SuppressWarnings("unused")
	private ExecutionContext executionContext;

	private static final long serialVersionUID = -5256087821622834764L;
	
    @Autowired
    private ActivoTareaExternaApi activoTareaExternaManagerApi;
    
    @Autowired
    private ActivoApi activoApi;
    
    @Autowired
    private TareaActivoManager tareaActivoManager;
    
    @Autowired
    private AgrupacionAdapter agrupacionAdapter;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {
		
		TareaExterna tareaExterna = getTareaExterna(executionContext);
		if(!Checks.esNulo(tareaExterna)){
			TareaActivo tarAct = tareaActivoManager.getByIdTareaExterna(tareaExterna.getId());
			if(!Checks.esNulo(tarAct) && activoApi.isActivoMatriz(tarAct.getActivo().getId()) ){
				List<TareaExternaValor> valores = activoTareaExternaManagerApi.obtenerValoresTarea(tareaExterna.getId());
				for(TareaExternaValor valor : valores){
					if(valor.getNombre().equals("comboFirma") && valor.getValor().equals(DDSiNo.SI)){
						agrupacionAdapter.deleteActivosUA(tarAct.getActivo().getId());
					}
				}
			}
		}
		
		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		this.executionContext = executionContext;
		
	}
	
	private void writeObject(java.io.ObjectOutputStream out) throws IOException {
		//empty
	}

	private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
		//empty
	}

}
