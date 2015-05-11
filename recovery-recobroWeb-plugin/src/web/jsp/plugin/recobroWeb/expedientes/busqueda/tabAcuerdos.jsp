<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

(function(){

	var limit=25;
	var labelStyle = 'width:200px;';
	var labelStyle2 = 'font-size:9px';
	
	var comboTipoAcuerdoRecord  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
		,{name:'descripcion'}
		
	]);
	
	var comboTipoAcuerdoStore = page.getStore({
	       flow: 'expedienterecobro/getTipoAcuerdo'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, comboTipoAcuerdoRecord)	       
	});
	
	var comboTipoAcuerdo = new Ext.form.ComboBox({
				store: comboTipoAcuerdoStore
				,displayField:'descripcion'
				,valueField:'id'
				,mode: 'remote'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.recobro.expedientes.busqueda.combo.tipo.acuerdo" text="**Tipo Acuerdo"/>'
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
	});
	
	var comboSolicitanteRecord  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
		,{name:'descripcion'}
		
	]);
	
	var comboSolicitanteStore = page.getStore({
	       flow: 'expedienterecobro/getSolicitante'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, comboSolicitanteRecord)	       
	});
	
	var comboSolicitante = new Ext.form.ComboBox({
				store: comboSolicitanteStore
				,displayField:'descripcion'
				,valueField:'id'
				,mode: 'remote'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.recobro.expedientes.busqueda.combo.solicitante.acuerdo" text="**Solicitante"/>'
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
	});
	
	var comboEstadoAcuerdoRecord  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
		,{name:'descripcion'}
		
	]);
	
	var comboEstadoAcuerdoStore = page.getStore({
	       flow: 'expedienterecobro/getEstadoAcuerdo'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, comboEstadoAcuerdoRecord)	       
	});
	
	var comboEstadoAcuerdo = new Ext.form.ComboBox({
				store: comboEstadoAcuerdoStore
				,displayField:'descripcion'
				,valueField:'id'
				,mode: 'remote'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.recobro.expedientes.busqueda.combo.estado.acuerdo" text="**Estado Acuerdo"/>'
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
	});
	
	var fechaCreacionDesde = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="plugin.recobro.expedientes.busqueda.creaciondesde.acuerdo" text="**Desde" />'
		,name:'fechaCreacionDesde'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	var fechaCreacionHasta = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="plugin.recobro.expedientes.busqueda.creacionhasta.acuerdo" text="**Hasta" />'
		,name:'fechaCreacionHasta'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	//mmImporteAcuerdo
	var mmImporteAcuerdo = app.creaMinMax('<s:message code="plugin.recobro.expedientes.busqueda.importe.acuerdo" text="**Importe Acuerdo" />', 'importeAcuerdo',{width : 80});

	//porcentaje quita
	var mmporcentajeQuita = app.creaMinMax('<s:message code="plugin.recobro.expedientes.busqueda.quita.acuerdo" text="**% Quita" />', 'porcentajeQuita',{width : 80});
	
	
	
	//FIN DATOS  
	
	var validarEmptyForm= function(){

		if (comboTipoAcuerdo.getValue() != ''){
			return true;
		} 
		if (fechaCreacionDesde.getValue() != '' ){
            return true;
        }
        if (fechaCreacionHasta.getValue() != '' ){
            return true;
        }
        if (comboSolicitante.getValue() != '' ){
            return true;
        }
        if (comboEstadoAcuerdo.getValue() != '' ){
            return true;
        }
        if(!(mmImporteAcuerdo.max.getValue()==='')){
			return true;
		}
		if(!(mmImporteAcuerdo.max.getValue()==='')){
			return true;
		}
		if (!app.validaValoresDblText(mmImporteAcuerdo)){
			return false;
		}
		if(!(mmporcentajeQuita.max.getValue()==='')){
			return true;
		}
		if(!(mmporcentajeQuita.max.getValue()==='')){
			return true;
		}
		if (!app.validaValoresDblText(mmporcentajeQuita)){
			return false;
		}
		
		return false;
			
	}
		
    
     var getParametros = function() { 
     	if(comboTipoAcuerdo.getValue()=='undefined' || !comboTipoAcuerdo.getValue()){
			comboTipoAcuerdo.setValue('');
		}
		if(fechaCreacionDesde.getValue()=='undefined' || !fechaCreacionDesde.getValue()){
			fechaCreacionDesde.setValue('');
		}
		if(fechaCreacionHasta.getValue()=='undefined' || !fechaCreacionHasta.getValue()){
			fechaCreacionHasta.setValue('');
		}
		if(comboSolicitante.getValue()=='undefined' || !comboSolicitante.getValue()){
			comboSolicitante.setValue('');
		}
		if(comboEstadoAcuerdo.getValue()=='undefined' || !comboEstadoAcuerdo.getValue()){
			comboEstadoAcuerdo.setValue('');
		}
		if(mmImporteAcuerdo.min.getValue()=='undefined' || !mmImporteAcuerdo.min.getValue()){
			mmImporteAcuerdo.min.setValue('');
		}
		if(mmImporteAcuerdo.max.getValue()=='undefined' || !mmImporteAcuerdo.max.getValue()){
			mmImporteAcuerdo.max.setValue('');
		}
		if(mmporcentajeQuita.min.getValue()=='undefined' || !mmporcentajeQuita.min.getValue()){
			mmporcentajeQuita.min.setValue('');
		}
		if(mmporcentajeQuita.max.getValue()=='undefined' || !mmporcentajeQuita.max.getValue()){
			mmporcentajeQuita.max.setValue('');
		}
		if(mmporcentajeQuita.max.getValue() > 100){
			mmporcentajeQuita.max.setValue(100);
		}
		
		return {
			params:'origen:acuerdo;'+
				'tipoAcuerdo'+':'+comboTipoAcuerdo.getValue()+';'+
				'fechaDesdeAcuerdo'+':'+app.format.dateRenderer(fechaCreacionDesde.getValue())+';'+
				'fechaHastaAcuerdo'+':'+app.format.dateRenderer(fechaCreacionHasta.getValue())+';'+
				'minImporteAcuerdo'+':'+mmImporteAcuerdo.min.getValue()+';'+
				'maxImporteAcuerdo'+':'+mmImporteAcuerdo.max.getValue()+';'+
				'minporcentajeQuita'+':'+mmporcentajeQuita.min.getValue()+';'+
				'maxporcentajeQuita'+':'+mmporcentajeQuita.max.getValue()+';'+
				'estadoAcuerdo'+':'+comboEstadoAcuerdo.getValue()+';'+
				'solicitante'+':'+comboSolicitante.getValue()+';'
		};
	};
	
     var panel=new Ext.Panel({
		autoHeight:true
		,autoWidth:true
		,layout:'table'
		,title : '<s:message code="plugin.recobro.expedientes.busqueda.titulo.acuerdos" text="**Acuerdos" />'
		,layoutConfig:{columns:2}
	    ,header: false
	    ,border:false
		//,titleCollapse : true
		//,collapsible:true
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding-left:10px;padding-right:10px;padding-top:1px;padding-bottom:1px;cellspacing:10px'}
		,items: [{
					layout:'form'
					,items:[comboTipoAcuerdo,comboEstadoAcuerdo,mmImporteAcuerdo.panel,mmporcentajeQuita.panel]
					,width: 300
				},{
					layout:'form'
					,items:[fechaCreacionDesde,fechaCreacionHasta,comboSolicitante]
					,width: 300
				}]
		,listeners:{	
			getParametros: function(anadirParametros, hayError) {
		        if (validarEmptyForm()){
    	                anadirParametros(getParametros());
    	        }
			}
    	,limpiar: function() {
    		   app.resetCampos([      
    		   			comboTipoAcuerdo,fechaCreacionDesde,fechaCreacionHasta,
    		   			comboSolicitante,comboEstadoAcuerdo,mmImporteAcuerdo.min,mmImporteAcuerdo.max,  
    		   			mmporcentajeQuita.min,mmporcentajeQuita.max       
	           ]);
 
    		}
    	
		}
	});

	Ext.onReady(function(){
		 //optionsEsquemasStore.webflow();
		 
	});
	
    return panel;

})()