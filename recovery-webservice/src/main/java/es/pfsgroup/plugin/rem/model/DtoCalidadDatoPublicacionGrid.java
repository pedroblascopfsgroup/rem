package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoCalidadDatoPublicacionGrid extends WebDto{


		private static final long serialVersionUID = 1L;
	
		private String nombreCampoWeb;
		private String valorRem;
		private String valorDq;
		private Integer indicadorCorrecto;
		private String codigoGrid;
		
		
		
		private DtoCalidadDatoPublicacionGrid() {
			
		}
		
		public DtoCalidadDatoPublicacionGrid(String nombre, String rem, String dq, String codGrid) {
			this.nombreCampoWeb = nombre;
			
			if (rem != null) {
				this.valorRem = rem;
			}
			
			if (dq != null) {
				this.valorDq = dq;
			}
			
			if (rem != null && dq != null) {
				if (!rem.equals(dq)) {
					this.indicadorCorrecto = 0;
				}else {
					this.indicadorCorrecto = 1;
				}
			}
			this.codigoGrid = codGrid;
			
			
		}
		
		public DtoCalidadDatoPublicacionGrid(String nombre, String rem,  String codGrid) {
			this.nombreCampoWeb = nombre;
			if (rem != null) {
				this.valorRem = rem;
			}						
			this.codigoGrid = codGrid;
		}
		
		public String getNombreCampoWeb() {
			return nombreCampoWeb;
		}
		public void setNombreCampoWeb(String nombreCampoWeb) {
			this.nombreCampoWeb = nombreCampoWeb;
		}
		public String getValorRem() {
			return valorRem;
		}
		public void setValorRem(String valorRem) {
			this.valorRem = valorRem;
		}
		public String getValorDq() {
			return valorDq;
		}
		public void setValorDq(String valorDq) {
			this.valorDq = valorDq;
		}

		public Integer getIndicadorCorrecto() {
			return indicadorCorrecto;
		}

		public void setIndicadorCorrecto(Integer indicadorCorrecto) {
			this.indicadorCorrecto = indicadorCorrecto;
		}

		public String getCodigoGrid() {
			return codigoGrid;
		}

		public void setCodigoGrid(String codigoGrid) {
			this.codigoGrid = codigoGrid;
		}



		
		
	
}
