package es.pfsgroup.plugin.rem.model;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;


/**
 * Dto para el tab de cargas
 * @author Lara Pablo
 *
 */
public class DtoCargaMasivaUnicaGastos {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String idAgrupador;
	private static Map<String, DtoCargaMasivaUnicaGastos> instances = new HashMap<String, DtoCargaMasivaUnicaGastos>();
	private Map<String, GastoLineaDetalle> instancesGastoLineaDetalle = new HashMap<String, GastoLineaDetalle>();
	private GastoProveedor gastoProveedor;
	private List<GastoLineaDetalle> gastoLineaDetalleList;
	private GastoDetalleEconomico gastoDetalleEconomico;
   
    
    
    private DtoCargaMasivaUnicaGastos() {}
 
    public static  DtoCargaMasivaUnicaGastos getDtoCargaMasivaUnicaGastos(String identificador) {
    	DtoCargaMasivaUnicaGastos obj;
    	if(instances.containsKey(identificador)) {
    		obj=  instances.get(identificador);
    	}else {
    		obj = new DtoCargaMasivaUnicaGastos();
    		instances.put(identificador, obj);
    	}
    	return obj;
    }

	public String getIdAgrupador() {
		return idAgrupador;
	}

	public void setIdAgrupador(String idAgrupador) {
		this.idAgrupador = idAgrupador;
	}

	private Map<String, DtoCargaMasivaUnicaGastos> getInstances() {
		return instances;
	}

	private void setInstances(Map<String, DtoCargaMasivaUnicaGastos> instances) {
		this.instances = instances;
	}

	public GastoProveedor getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(GastoProveedor gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}

	public List<GastoLineaDetalle> getGastoLineaDetalleList() {
		if(gastoLineaDetalleList == null) {
			this.gastoLineaDetalleList =  new ArrayList<GastoLineaDetalle>();
		}
		return gastoLineaDetalleList;
	}

	public void setGastoLineaDetalleList(List<GastoLineaDetalle> gastoLineaDetalleList) {
		this.gastoLineaDetalleList = gastoLineaDetalleList;
	}

	public List<GastoLineaDetalle> getAllLineasDetalle() {
		List<GastoLineaDetalle> gastoLineaDetalleLista = new ArrayList<GastoLineaDetalle>();
	
		for(Entry<String, DtoCargaMasivaUnicaGastos> entryGasto: instances.entrySet()) {
			Collection<GastoLineaDetalle> gastoLinea = entryGasto.getValue().getGastoLineaDetalle().values();
			gastoLineaDetalleLista.addAll(gastoLinea);
		}
		
		return gastoLineaDetalleLista;		
	}
    
	 public GastoLineaDetalle getGastoLineaDetalle(String identificador) {
		 GastoLineaDetalle obj = null;
	    	if(instancesGastoLineaDetalle.containsKey(identificador)) {
	    		obj=  instancesGastoLineaDetalle.get(identificador);
	    	}
	    	
	    	return obj;
	  }
	 
	 public void setGastoLineaDetalle(String identificador) {
		 if(!instancesGastoLineaDetalle.containsKey(identificador)) {
			 instancesGastoLineaDetalle.put(identificador, new GastoLineaDetalle());
		 }
	 }
	 
	 private Map<String, GastoLineaDetalle> getGastoLineaDetalle() {
		 return instancesGastoLineaDetalle;
	 }
    
	 public List<GastoProveedor> getAllGastos(){
		 List<GastoProveedor> gastos = new ArrayList<GastoProveedor>();
		 for(Entry<String, DtoCargaMasivaUnicaGastos> entryGasto: instances.entrySet()) {
			 gastos.add(entryGasto.getValue().getGastoProveedor());
		}
		 
		 return gastos;
	 }
	 
	 public void vaciarInstancias() {
		 instances.clear();
		 instancesGastoLineaDetalle.clear();
	 }

	public GastoDetalleEconomico getGastoDetalleEconomico() {
		return gastoDetalleEconomico;
	}

	public void setGastoDetalleEconomico(GastoDetalleEconomico gastoDetalleEconomico) {
		this.gastoDetalleEconomico = gastoDetalleEconomico;
	}
	 
	public List<GastoDetalleEconomico> getAllGastoDetalleEconomico(){
		 List<GastoDetalleEconomico> gastos = new ArrayList<GastoDetalleEconomico>();
		 for(Entry<String, DtoCargaMasivaUnicaGastos> entryGasto: instances.entrySet()) {
			 gastos.add(entryGasto.getValue().getGastoDetalleEconomico());
		}
		 
		 return gastos;
	 }
	 
    
}