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
	
	//INICIO DATOS 

	//TIPO INCIDENCIA
	
	
	var comboTipoIncidenciaRecord  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
		,{name:'descripcion'}
		
	]);
	
	
	var comboSituacionIncidenciaRecord  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
		,{name:'descripcion'}
		
	]);
	
	var comboTipoIncidenciaStore = page.getStore({
	       flow: 'expedienterecobro/getTipoIncidencia'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, comboTipoIncidenciaRecord)	       
	});
	
	//Ext.getStore('comboTipoIncidenciaStore').on('load', function(store) {
    //store.insert(0, new comboTipoIncidenciaRecord{
    //    id: -1,     
    //    nombre: '---',
    //    descripcion: '---'
    //});
	//});
	//comboTipoIncidenciaStore.insert(0,new comboTipoIncidenciaRecord({id:0,nombre:'---',descipcion:'---'}));
              		
	

	var comboSituacionIncidenciaStore = page.getStore({
	       flow: 'expedienterecobro/getSituacionIncidencia'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, comboSituacionIncidenciaRecord)	       
	});
	
	var comboTipoIncidencias = new Ext.form.ComboBox({
				store: comboTipoIncidenciaStore
				,displayField:'descripcion'
				,valueField:'id'
				,mode: 'remote'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.recobro.expedientes.busqueda.combo.incidencia" text="**Tipo Incidencia"/>'
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        }
				}
	});  
	
	var comboSituacionIncidencias = new Ext.form.ComboBox({
				store: comboSituacionIncidenciaStore
				,displayField:'descripcion'
				,valueField:'id'
				,mode: 'remote'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.recobro.expedientes.busqueda.combo.situacion.incidencia" text="**Situacion Incidencia"/>'
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
	});  
	
	
	var fechaCreacionDesde = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="plugin.recobro.expedientes.busqueda.creaciondesde" text="**Desde" />'
		,name:'fechaCreacionDesde'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	var fechaCreacionHasta = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="plugin.recobro.expedientes.busqueda.creacionhasta" text="**Hasta" />'
		,name:'fechaCreacionHasta'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	    
	
	//FIN DATOS  
	
	
	
	var validarEmptyForm= function(){

        if (comboTipoIncidencias.getValue() != '' ){
            return true;
        }
        if (comboSituacionIncidencias.getValue() != '' ){
            return true;
        }
        if (fechaCreacionDesde.getValue() != '' ){
            return true;
        }
        if (fechaCreacionHasta.getValue() != '' ){
            return true;
        }
        
		return false;
			
	}
	
    
     var getParametros = function() { 		
		if(comboTipoIncidencias.getValue()=='undefined' || !comboTipoIncidencias.getValue()){
			comboTipoIncidencias.setValue('');
		}
		if(comboSituacionIncidencias.getValue()=='undefined' || !comboSituacionIncidencias.getValue()){
			comboSituacionIncidencias.setValue('');
		}
		if(fechaCreacionDesde.getValue()=='undefined' || !fechaCreacionDesde.getValue()){
			fechaCreacionDesde.setValue('');
		}
		if(fechaCreacionHasta.getValue()=='undefined' || !fechaCreacionHasta.getValue()){
			fechaCreacionHasta.setValue('');
		}
		return {
			params:'origen:incidencia;'+
				'tipoIncidencia'+':'+comboTipoIncidencias.getValue()+';'+
				'situacionIncidencia'+':'+comboSituacionIncidencias.getValue()+';'+
				'fechaDesdeIncidencia'+':'+app.format.dateRenderer(fechaCreacionDesde.getValue())+';'+
				'fechaHastaIncidencia'+':'+app.format.dateRenderer(fechaCreacionHasta.getValue())+';'
		
		};
	};
	

	
     var panel=new Ext.Panel({
		autoHeight:true
		,autoWidth:true
		,layout:'table'
		,title : '<s:message code="plugin.recobro.expedientes.busqueda.titulo.incidencias" text="**Incidencias" />'
		,layoutConfig:{columns:2}
	    ,header: false
	    ,border:false
		//,titleCollapse : true
		//,collapsible:true
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding-left:10px;padding-right:10px;padding-top:1px;padding-bottom:1px;cellspacing:10px'}
		,items: [{
					layout:'form'
					,items:[comboTipoIncidencias,comboSituacionIncidencias]
				},{
					layout:'form'
					,items:[fechaCreacionDesde,fechaCreacionHasta]
				}]
		,listeners:{	
			getParametros: function(anadirParametros, hayError) {
		        if (validarEmptyForm()){
    	                anadirParametros(getParametros());
    	        }
			}
    	,limpiar: function() {
    		   app.resetCampos([      
    		   			comboTipoIncidencias,comboSituacionIncidencias,fechaCreacionDesde,fechaCreacionHasta
	           ]); 
    		}
    	
		}
	});

	Ext.onReady(function(){
		 //comboTipoIncidenciasStore.webflow();
		 //comboSituacionIncidenciasStore.webflow();
	});
	
    return panel;

})()