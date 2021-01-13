package es.pfsgroup.plugin.rem.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;

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
			if ((rem != null && !rem.isEmpty()) && (dq != null && !dq.isEmpty())) {
				if (!rem.equals(dq)) {
					this.indicadorCorrecto = 0;
				}else {
					this.indicadorCorrecto = 1;
				}
			}else if((rem != null && rem.isEmpty()) && (dq != null && dq.isEmpty())) {
				this.indicadorCorrecto = 1;
			}else if(rem == null && dq == null) {
				this.indicadorCorrecto = 1;
			}
			
			if ("Idufir".equals(nombre) && (dq == null || dq.isEmpty())) {
				this.indicadorCorrecto = 1;
			}else if("Idufir".equals(nombre) && (dq != null && !dq.isEmpty())){
				this.indicadorCorrecto = 0;
			}
			
			if ("Superficie Construida".equals(nombre)) {
				if(dq == null) {
					this.indicadorCorrecto = null;					
				}else{
					if ((dq != null && !dq.isEmpty()) && (rem != null && !rem.isEmpty())) {
						BigDecimal dqF3SuperficieCons = new BigDecimal(dq);
						BigDecimal drF3SuperficieCons = new BigDecimal(rem);
						if (dqF3SuperficieCons.compareTo(BigDecimal.ZERO) > 0) {
							BigDecimal calcSupUtil = drF3SuperficieCons.divide(dqF3SuperficieCons, 2, RoundingMode.HALF_UP); 
							Double supConstruida = calcSupUtil.doubleValue();
							
							if(supConstruida >= 0.8 && supConstruida <= 1.2 ) {
								this.indicadorCorrecto = 1;								
							}else {
								this.indicadorCorrecto = 0;	
							}
						}else {
							this.indicadorCorrecto = 0;
						}						
					}else {
						this.indicadorCorrecto = null;
					}			
				}
			}
			if ("Superficie útil".equals(nombre)) {
				if(dq == null) {
					this.indicadorCorrecto = null;
				}else{
					if ((dq != null && !dq.isEmpty()) && (rem != null && !rem.isEmpty())) {
						BigDecimal dqF3SuperficieUtil = new BigDecimal(dq);
						BigDecimal drF3SuperficieUtil = new BigDecimal(rem);
						if (dqF3SuperficieUtil.compareTo(BigDecimal.ZERO) > 0) {
							BigDecimal calcSupUtil = drF3SuperficieUtil.divide(dqF3SuperficieUtil, 2, RoundingMode.HALF_UP); 
							Double supUtil = calcSupUtil.doubleValue();
							
							if(supUtil >= 0.8 && supUtil <= 1.2 ) {
								this.indicadorCorrecto = 1;
							}else {
								this.indicadorCorrecto = 0;
							}
						}else {
							this.indicadorCorrecto = 0;
						}
						
					}else {
						this.indicadorCorrecto = null;
					}			
				}
			}
						
			this.codigoGrid = codGrid;
			
			
		}
		
		public DtoCalidadDatoPublicacionGrid(String nombre, String rem, String dq, String codGrid, int separador) {
			this.nombreCampoWeb = nombre;
			
			if (rem != null) {
				this.valorRem = rem;
			}
			
			if (dq != null) {
				this.valorDq = dq;
			}
			this.indicadorCorrecto = 2;
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
