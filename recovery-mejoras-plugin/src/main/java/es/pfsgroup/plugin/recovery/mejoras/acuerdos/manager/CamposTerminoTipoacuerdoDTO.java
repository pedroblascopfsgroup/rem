package es.pfsgroup.plugin.recovery.mejoras.acuerdos.manager;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.termino.model.CamposTerminoTipoAcuerdo;
import es.pfsgroup.commons.utils.Checks;

public class CamposTerminoTipoacuerdoDTO {
	
	 	private Long id;	
		
		private DDTipoAcuerdo tipoAcuerdo;	

	    private String nombreCampo;
			
		private String labelCampo;
			
		private String tipoCampo;
		
		private String valoresCombo;
		
		private Boolean obligatorio;
		
		private List<List<Object>> arrayValoresCombo;
		
		public CamposTerminoTipoacuerdoDTO(){
			
		}
		
		public CamposTerminoTipoacuerdoDTO(CamposTerminoTipoAcuerdo campos){
			this.id = campos.getId();
			this.tipoAcuerdo = campos.getTipoAcuerdo();
			this.nombreCampo = campos.getNombreCampo();
			this.labelCampo = campos.getLabelCampo();
			this.tipoCampo = campos.getTipoCampo();
			this.valoresCombo = campos.getValoresCombo();
			this.obligatorio = campos.getObligatorio();
			this.arrayValoresCombo = transformarArrayCampos(campos.getArrayValoresCombo(),this.tipoCampo);
		}

		public Long getId() {
			return id;
		}

		public void setId(Long id) {
			this.id = id;
		}

		public DDTipoAcuerdo getTipoAcuerdo() {
			return tipoAcuerdo;
		}

		public void setTipoAcuerdo(DDTipoAcuerdo tipoAcuerdo) {
			this.tipoAcuerdo = tipoAcuerdo;
		}

		public String getNombreCampo() {
			return nombreCampo;
		}

		public void setNombreCampo(String nombreCampo) {
			this.nombreCampo = nombreCampo;
		}

		public String getLabelCampo() {
			return labelCampo;
		}

		public void setLabelCampo(String labelCampo) {
			this.labelCampo = labelCampo;
		}

		public String getTipoCampo() {
			return tipoCampo;
		}

		public void setTipoCampo(String tipoCampo) {
			this.tipoCampo = tipoCampo;
		}

		public String getValoresCombo() {
			return valoresCombo;
		}

		public void setValoresCombo(String valoresCombo) {
			this.valoresCombo = valoresCombo;
		}

		public Boolean getObligatorio() {
			return obligatorio;
		}

		public void setObligatorio(Boolean obligatorio) {
			this.obligatorio = obligatorio;
		}

		public List<List<Object>> getArrayValoresCombo() {
			return arrayValoresCombo;
		}

		public void setArrayValoresCombo(List<List<Object>> arrayValoresCombo) {
			this.arrayValoresCombo = arrayValoresCombo;
		}
		
		private List<List<Object>> transformarArrayCampos(List<List> valores, String tipoCampo){
			if(Checks.estaVacio(valores)){
				return null;
			}
			List<List<Object>> camposValores = new ArrayList<List<Object>>();
			List<Object> cvalores = new ArrayList<Object>();
			for(List lista:valores){
				if(lista.size() > 2){
					if("fecha".equals(tipoCampo)){
						cvalores.add(lista.get(0));
						try {
							cvalores.add((new SimpleDateFormat("yyyy-MM-dd")).parse((String)lista.get(1)));
						} catch (ParseException e) {
							cvalores.add(null);
						}
					}else{
						cvalores.add(lista.get(0));
						cvalores.add(lista.get(1));
					}
					camposValores.add(cvalores);
				}
			}
			return camposValores;
		}

}
