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
	
	var optionsEsquema  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
		
	]);
	
	var optionsEsquemasStore = page.getStore({
	       flow: 'expedienterecobro/getListEsquemas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, optionsEsquema)	       
	});
	
	var comboEsquemas = new Ext.form.ComboBox({
				store:optionsEsquemasStore
				,displayField:'nombre'
				,valueField:'id'
				,mode: 'remote'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.recobro.expedientes.busqueda.esquema" text="**Esquema"/>'
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
	});
	
	comboEsquemas.on('select', function(){
		comboCarteras.reset();
		comboSubCarteras.reset();
		
		optionsCarterasStore.webflow({'idEsquema': comboEsquemas.getValue()});
		comboCarteras.setDisabled(false);
		comboSubCarteras.setDisabled(true);
		
	});
	
	// CARTERAS
	var optionsCarteras  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
		
	]);
	
	var optionsCarterasStore = page.getStore({
	       flow: 'expedienterecobro/getListCarteras'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, optionsCarteras)	       
	});
	
	var comboCarteras = new Ext.form.ComboBox({
				store:optionsCarterasStore
				,displayField:'nombre'
				,valueField:'id'
				,mode: 'remote'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.recobro.expedientes.busqueda.cartera" text="**Cartera"/>'
				,disabled: true
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
	});
	
	comboCarteras.on('select', function(){
		comboSubCarteras.reset();
		optionsSubCarterasStore.webflow({'idEsquema': comboEsquemas.getValue(), 'idCartera': comboCarteras.getValue()});
		comboSubCarteras.setDisabled(false);
	});
	
	//SUBCARTERAS
	var optionsSubCarteras  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
		
	]);
	
	var optionsSubCarterasStore = page.getStore({
	       flow: 'expedienterecobro/getListSubCarteras'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, optionsSubCarteras)
	});
	
	var comboSubCarteras = new Ext.form.ComboBox({
				store:optionsSubCarterasStore
				,displayField:'nombre'
				,valueField:'id'
				,mode: 'remote'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.recobro.expedientes.busqueda.subcartera" text="**Subcartera"/>'
				,disabled: true
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
	});
	
	//MOTIVOS BAJA
	var optionsMotivosBaja  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
		
	]);
	
	var optionsMotivosBajaStore = page.getStore({
	       flow: 'expedienterecobro/getListMotivosBaja'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, optionsMotivosBaja)
	});
	
	var comboMotivosBaja = new Ext.form.ComboBox({
				store:optionsMotivosBajaStore
				,displayField:'descripcion'
				,valueField:'id'
				,mode: 'remote'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.recobro.expedientes.busqueda.motivobaja" text="**Motivo Baja"/>'
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
	});

//AGENCIAS

	var optionsAgencias  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
		
	]);
	
	var optionsAgenciasStore = page.getStore({
	       flow: 'expedienterecobro/getListAgencias'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, optionsAgencias)
	});
	
	var comboAgencias = new Ext.form.ComboBox({
				store:optionsAgenciasStore
				,displayField:'nombre'
				,valueField:'id'
				,mode: 'remote'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.recobro.expedientes.busqueda.agencia" text="**Agencia"/>'
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
	});
	              
//SUPERVISORES
	var optionsSupervisores  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
		
	]);
	
	var optionsSupervisoresStore = page.getStore({
	       flow: 'expedienterecobro/getListSupervisores'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, optionsSupervisores)
	});
	
	var comboSupervisores = new Ext.form.ComboBox({
				store:optionsSupervisoresStore
				,displayField:'nombre'
				,valueField:'id'
				,mode: 'remote'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.recobro.expedientes.busqueda.supervisor" text="**Supervisor"/>'
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
	});            
	
	//FIN DATOS  
	
	var validarEmptyForm= function(){

		if (comboEsquemas.getValue() != ''){
			return true;
		} 
		if (comboCarteras.getValue() != ''){
			return true;
		} 
		if (comboSubCarteras.getValue() != '' ){
			return true;
		}
		if (comboMotivosBaja.getValue() != '' ){
            return true;
        }
		if (comboAgencias.getValue() != '' ){
            return true;
        }
		if (comboSupervisores.getValue() != '' ){
            return true;
        }
		return false;
			
	}
	
    
     var getParametros = function() { 
     	if(comboEsquemas.getValue()=='undefined' || !comboEsquemas.getValue()){
			comboEsquemas.setValue('');
		}
     	if(comboCarteras.getValue()=='undefined' || !comboCarteras.getValue()){
			comboCarteras.setValue('');
		}
		if(comboSubCarteras.getValue()=='undefined' || !comboSubCarteras.getValue()){
			comboSubCarteras.setValue('');
		}
		if(comboMotivosBaja.getValue()=='undefined' || !comboMotivosBaja.getValue()){
			comboMotivosBaja.setValue('');
		}
		if(comboAgencias.getValue()=='undefined' || !comboAgencias.getValue()){
			comboAgencias.setValue('');
		}
		if(comboSupervisores.getValue()=='undefined' || !comboSupervisores.getValue()){
			comboSupervisores.setValue('');
		}
		
		return {
			params:'origen:recobro;'+
				'esquema'+':'+comboEsquemas.getValue()+';'+
				'cartera'+':'+comboCarteras.getValue()+';'+
				'subcartera'+':'+comboSubCarteras.getValue()+';'+
				'motivoBaja'+':'+ comboMotivosBaja.getValue()+';'+
				'agencia'+':'+ comboAgencias.getValue() +';'+
				'supervisor'+':'+comboSupervisores.getValue()	
		};
	};
	
     var panel=new Ext.Panel({
		autoHeight:true
		,autoWidth:true
		,layout:'table'
		,title : '<s:message code="plugin.recobro.expedientes.busqueda.titulo" text="**Recobro" />'
		,layoutConfig:{columns:2}
	    ,header: false
	    ,border:false
		//,titleCollapse : true
		//,collapsible:true
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding-left:10px;padding-right:10px;padding-top:1px;padding-bottom:1px;cellspacing:10px'}
		,items: [{
					layout:'form'
					,items:[comboEsquemas,comboCarteras, comboSubCarteras]
				},{
					layout:'form'
					,items:[comboMotivosBaja,comboAgencias, comboSupervisores]
				}]
		,listeners:{	
			getParametros: function(anadirParametros, hayError) {
		        if (validarEmptyForm()){
    	                anadirParametros(getParametros());
    	        }
			}
    	,limpiar: function() {
    		   app.resetCampos([      
    		   			comboEsquemas
    		           ,comboCarteras
    		           ,comboSubCarteras
    		           ,comboMotivosBaja
    		           ,comboAgencias
    		           ,comboSupervisores
	           ]);
	           comboCarteras.setDisabled(true);
	           comboSubCarteras.setDisabled(true); 
    		}
    	
		}
	});

	Ext.onReady(function(){
		 optionsEsquemasStore.webflow();
		 optionsMotivosBajaStore.webflow();
		 optionsAgenciasStore.webflow();
		 optionsSupervisoresStore.webflow();
	});
	
    return panel;

})()