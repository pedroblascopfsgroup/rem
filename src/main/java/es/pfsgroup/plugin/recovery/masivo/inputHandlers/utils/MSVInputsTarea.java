package es.pfsgroup.plugin.recovery.masivo.inputHandlers.utils;


// movido al plugin de lindorffProcedimientos-bpm
public class MSVInputsTarea {
	/*
	@Autowired(required = false)
	private List<MSVConfiguradorInputs> listaInputs;
	
	@Autowired(required = false)
	private Map<String, List<MSVConfiguradorInputs>> mapaConfiguraciones;

	
	public void setListaInputs(List<MSVConfiguradorInputs> listaInputs) {
		this.listaInputs = listaInputs;
	}


	public List<MSVConfiguradorInputs> getListaInputs() {
		return listaInputs;
	}
	
	public void setMapaConfiguraciones(Map<String, List<MSVConfiguradorInputs>> mapaConfiguraciones) {
		this.mapaConfiguraciones = mapaConfiguraciones;
	}


	public Map<String, List<MSVConfiguradorInputs>> getMapaConfiguraciones() {
		return mapaConfiguraciones;
	}
	
	public List<MSVConfiguradorInputs> getListaElementosPorTipoProcedimiento(String tipoProc) {
		List<MSVConfiguradorInputs> listaElementos = null;
		if (mapaConfiguraciones!= null && mapaConfiguraciones.containsKey(tipoProc)) {
			listaElementos = mapaConfiguraciones.get(tipoProc);
		}
		return listaElementos;
	}

	public String obtenerCodigoInput(MSVConfiguradorInputs dto){
		String resultado=null;
		
		if (listaInputs != null){
			for (int i = 0; i < listaInputs.size(); i++) {
				MSVConfiguradorInputs l =listaInputs.get(i);
				if (l.igualQue(dto)){
					resultado=l.getCodigoInput();
					break;
				}
				
			}
		}
		return resultado;
	}
	
	public MSVConfiguradorInputs obtenerConfiguracionInputTarea(MSVConfiguradorInputs dto) {
		MSVConfiguradorInputs resultado=null;
		
		if (listaInputs != null){
			for (int i = 0; i < listaInputs.size(); i++) {
				MSVConfiguradorInputs l =listaInputs.get(i);
				if (l.igualQue(dto)){
					resultado=l;
					break;
				}
				
			}
		}
		return resultado;
	}
	*/
	

}
