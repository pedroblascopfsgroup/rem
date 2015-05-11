<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	
	
	<%-- 
	<pfs:ddCombo name="comboTiposProc" labelKey="plugin.geninformes.escritos.window.comboTiposProc" label="**Tipo procedimiento" 
	propertyCodigo="id" value="" dd="${tiposProc}" width="250" />
	 --%>
	var procedimientoRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'tipoProcedimiento'}
		,{name: 'codProcEnJuzgado'}
	]);
	
	var procedimientosStore = page.getStore({
      flow:'listaprocedimientos/getProcedimientosAsuntoOrdenado'
      ,reader: new Ext.data.JsonReader({
        root : 'listado'
      } , procedimientoRecord)
     });
     
   	procedimientosStore.webflow({id: data.id});
   
   var tplCombo =  '<tpl for="."><p>'
                + '<p class="search-item">{id}&nbsp;-&nbsp;{tipoProcedimiento}&nbsp;-&nbsp;{codProcEnJuzgado}</p>'
                + '</tpl>';
                
	var comboTiposProc = new Ext.form.ComboBox({
    	name:'comboTiposProc'
    	,store:procedimientosStore
    	,displayField:'tipoProcedimiento'
    	,valueField:'id'
    	,mode: 'local'
    	,triggerAction: 'all'
    	,tpl: tplCombo
    	,editable:false
    	,emptyText:'Seleccionar...'
   		,fieldLabel:'<s:message code="plugin.geninformes.escritos.window.comboTiposProc" text="**Tipo procedimiento" />'
		,width: 350
		,forceSelection: true
		,itemSelector: 'p.search-item'
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
    });
    

	
	var escritosRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'codigo'}
		,{name:'descripcion'}
		,{name:'accion'}
		
	]);
 		
 	var escritosStore = page.getStore({
	       flow: 'geninfgenerarescritos/getEscritos'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'escritos'
	    }, escritosRecord)
	       
	});
	
	var comboEscritos = new Ext.form.ComboBox({
    	name:'comboEscritos'
    	,store:escritosStore
    	,displayField:'descripcion'
    	,valueField:'codigo'
    	,mode: 'local'
    	,triggerAction: 'all'
    	,editable:false
    	,emptyText:'Seleccionar...'
   		,fieldLabel:'<s:message code="plugin.geninformes.escritos.window.comboEscritos" text="**Escrito" />'
		,width: 350
		,forceSelection: true
    });
    
    
	var btnCancelar = new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	
	var btnGenerar = new Ext.Button({
		text : '<s:message code="plugin.geninformes.escritos.window.btnGenerar" text="**Generar" />'
		,iconCls:'icon_comite_actas'
		,handler : function(){
			if (comboEscritos.getValue() !='' && comboEscritos.getValue() != null ){
				var idAsunto=data.id;
			    var plantilla=comboEscritos.getValue();
			    var idProc=comboTiposProc.getValue();
				var flow='/pfs/geninfvisorinforme/generarEscritoEditableProc';
	            var params = {idAsunto:idAsunto, idProcedimiento: idProc, plantilla:plantilla};
	            app.openBrowserWindow(flow,params);
				page.fireEvent(app.event.DONE);
			} else {
				Ext.Msg.alert('<s:message code="plugin.geninformes.escritos.window.sinSeleccion.titulo" text="**Seleccionar escrito"/>','<s:message code="plugin.geninformes.escritos.window.sinSeleccion.texto" text="**Debe seleccionar un escrito a generar." />');
			}
		}
	});
	
	var btnReset = new Ext.Button({
		text : '<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler : function(){		
			comboTiposProc.reset();
			comboEscritos.reset();
			escritosStore.removeAll();
		}
	});

	
	comboTiposProc.on('select', function(){
		comboEscritos.reset(); 		
 		if (comboTiposProc.getValue() !='' && comboTiposProc.getValue() != null ){
 			escritosStore.webflow({id:comboTiposProc.getValue()});
 		} else {
 			escritosStore.removeAll();
 		}
 	});

	var DatosFieldSet = new Ext.form.FieldSet({
		autoHeight:'false'
		,style:'padding:2px'
 		,border:false
		,layout : 'column'
		,layoutConfig:{
			columns:1
		}
		,width:1300
		,defaults : {layout:'form',border: false,bodyStyle:'padding:3px'} 
		,items : [ 
				 { 	columnWidth:.37,
				 	items:[ comboTiposProc, comboEscritos ]
				 }
			
		]
	}); 	
	var mainPanel = new Ext.form.FormPanel({
		autoHeight:true
		,bodyStyle:'padding:0px;'
		,border: false
	    ,items : [{
			bodyStyle:'padding:5px;cellspacing:10px'
			,border:false
			,defaults : {xtype:'panel' ,cellCls : 'vtop'}
			,items : [DatosFieldSet]
		  }]
		,bbar: [ '->', btnGenerar, btnReset, btnCancelar ]
	});

	page.add(mainPanel);
	
	</fwk:page>